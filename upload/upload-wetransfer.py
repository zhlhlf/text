# by bunny
import base64
import json
import re
import time
import requests
import hashlib
import os
import sys

sleep_time = 3

class We:
    def __init__(self):
        """
        wetransfer.com tool for anonymously uploading and downloading files.
        Made by @bunnykek

        example usage:\n
        wetransfer = we()\n
        metadata = wetransfer.upload('path/to/file')\n
        print(metadata['shortened_url'])\n
        wetransfer.download(metadata['shortened_url'])\n
        """
        self.__session = requests.Session()
        self.__session.headers.update({'X-Requested-With': 'XMLHttpRequest'})

    def upload(self, path: str, display_name: str = '', message: str = ''):
        """Returns a json containing the metadata and the link to the uploaded file/folder"""

        if display_name == '':
            display_name = os.path.basename(path)
        files, type = self.__get_files(path)
        files_response = self.__link_files(files, display_name, message)
        transfer_id = files_response['id']
        files = files_response['files']
        auth_bearer = files_response['storm_upload_token']
        self.endpoints = self.__decodejwt(auth_bearer)
        return self.__process_files(files, transfer_id, path, type, auth_bearer)


    def __get_files(self, path: str) -> list:
        if os.path.isfile(path):
            file = [{'name': os.path.basename(path), 'size': os.path.getsize(
                path), 'item_type': 'file'}]
            return file, 'file'
        elif os.path.isdir(path):
            files = []
            for file in os.listdir(path):
                if os.path.isfile(os.path.join(path, file)):
                    files.append({'name': file, 'size': os.path.getsize(os.path.join(
                        path, file)), 'item_type': 'file'})
            print("Total number of files:", len(files))
            return files, 'folder'
        else:
            raise Exception('Path is not a file or directory')

    def __link_files(self, files: list, display_name: str, message: str):
        json_data = {
            'message': message,
            'display_name': display_name,
            'ui_language': 'en',
            'files': files
        }

        response = self.__session.post(
            'https://wetransfer.com/api/v4/transfers/link', json=json_data)

        if response.status_code == 200:
            return response.json()
        else:
            raise Exception("liink files error\n", response.text)

    def __process_files(self, files: dict, transfer_id: str, path: str, type: str, auth_bearer: str):
        items = []
        contentlenforblocks = []
        content_md5 = []
        files_path = []
        file_name_bcount = []
        for file in files:

            file_name = file['name']
            file_size = file['size']

            if type == 'folder':
                file_path = os.path.join(path, file_name)
            elif type == 'file':
                file_path = path

            files_path.append(file_path)

            n = int(file_size/15728640)
            chunks_list = [15728640]*n

            rem_chunk = file_size % 15728640
            if rem_chunk:
                chunks_list.append(rem_chunk)
                n += 1

            file_name_bcount.append((file_name, n))

            blocks = []
            for contlen in chunks_list:
                blocks.append({'content_length': contlen})
                contentlenforblocks.append(contlen)

            with open(file_path, "rb") as f:
                data = f.read(15728640)
                while data:
                    content_md5.append(hashlib.md5(data).hexdigest())
                    data = f.read(15728640)

            item = {
                'path': file_name,
                'item_type': 'file',
                'blocks': blocks
            }

            items.append(item)

        self.__preflight(items, auth_bearer)

        blocks_payload = []
        for x, y in zip(contentlenforblocks, content_md5):
            blocks_payload.append({
                'content_length': x,
                'content_md5_hex': y
            })

        s3_urls = self.__blocks(blocks_payload, auth_bearer)  # url md5 blockid

        self.__upload_chunks(files_path, s3_urls)

        time.sleep(sleep_time)

        self.__batch(file_name_bcount, s3_urls, auth_bearer)

        return self.__finalize_chunks_upload(transfer_id)

    def __batch(self, file_name_bcount, s3_urls, auth_bearer):

        items = []
        i = 0
        # print(file_name_bcount)
        for file_name, count in file_name_bcount:
            item = {
                'path': file_name,
                'item_type': 'file',
                'block_ids': [url[2] for url in s3_urls[i:i+count]]
            }
            i += count
            items.append(item)

        headers = {
            'Authorization': f'Bearer {auth_bearer}',
        }

        json_data = {
            'items': items
        }
        # print(json.dumps(json_data, indent=2))
        
        response = self.__session.post(self.endpoints['storm.create_batch_url'], headers=headers, json=json_data)
        # print(response.status_code)

    def __preflight(self, items, auth_bearer: str):
        headers = {
            'Authorization': f'Bearer {auth_bearer}',
        }

        json_data = {
            'items': items
        }

        # print(json.dumps(json_data, indent=2))
        response = self.__session.post(self.endpoints['storm.preflight_batch_url'], json=json_data, headers=headers)

        if response.status_code == 200:
            return response.json()
        else:
            raise Exception('enable_response_s3 error\n', response.text)

    def __blocks(self, blocks: list, auth_bearer: str):
        s3_urls = []

        headers = {
            'Authorization': f'Bearer {auth_bearer}',
        }

        json_data = {
            'blocks': blocks
        }

        response = self.__session.post(self.endpoints['storm.announce_blocks_url'], headers=headers, json=json_data)
        rblocks = response.json()['data']['blocks']
        for rblock in rblocks:
            s3_urls.append([rblock['presigned_put_url'],
                           rblock['put_request_headers']['Content-MD5'], rblock['block_id']])
        return s3_urls

    def __upload_chunks(self, files_path: list, s3_urls: list):
        headers = {
            'Content-MD5': '',
        }

        i = 0
        for file_path in files_path:
            with open(file_path, 'rb') as file:
                while chunk := file.read(15728640):
                    headers['Content-MD5'] = s3_urls[i][1]
                    response = self.__session.put(
                        s3_urls[i][0], data=chunk, headers=headers)
                    i += 1
                    if response.status_code != 200:
                        raise Exception(
                            'Error on upload_chunks\n', response.text)
        return True

    def __finalize_chunks_upload(self, transfer_id: str):

        json_data = {
            'wants_storm': True,
        }

        response = self.__session.put(
            f'https://wetransfer.com/api/v4/transfers/{transfer_id}/finalize',
            json=json_data
        )

        if response.status_code != 200:
            return str("Finalize error\n")
        else:
            return response.json()["shortened_url"]
    
    def __decodejwt(self, jwt_token):
        payload_b64= jwt_token.split('.')[1]
        payload = json.loads(base64.b64decode(payload_b64 + '==').decode('utf-8'))
        return payload

if __name__ == "__main__":
    qw=We()
    for i in sys.argv[1:]:
        sleep_time = 3
        print(i)
        url = qw.upload(i)
        count = 0
        while True:
            url = qw.upload(i)
            if count == 5:
                break
            if url.endswith("error"):
                sleep_time+=1
                count+=1
                continue
            break
        print("url: " + url + "\n")
