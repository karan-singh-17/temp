

import json
import tempfile
import zipfile
import os
import requests


class ProvisioningPackager:
    def __init__(self):
        pass

    def fetch_provisioning_package(self):
        headers = {"Authorization": "ujhN1Tl76w8M"}
        url = "https://62nnzwanlq2b7l3lgi6llj233m0ufhgn.lambda-url.eu-central-1.on.aws/"

        response = requests.get(url, headers=headers)
        contents = response.content

        response_dict = json.loads(contents.decode("utf-8"))

        temp_dir = tempfile.mkdtemp(dir="/tmp")

        certificate_file = temp_dir + "/certificate.pem"
        with open(certificate_file, "w") as file:
            file.write(response_dict["certificatePem"])

        private_key_file = temp_dir + "/provisioning_key"
        with open(private_key_file, "w") as file:
            file.write(response_dict["keyPair"]["PrivateKey"])

        public_key_file = temp_dir + "/provisioning_key.pub"
        with open(public_key_file, "w") as file:
            file.write(response_dict["keyPair"]["PublicKey"])

        metadata_file = temp_dir + "/metadata.json"
        with open(metadata_file, "w") as file:
            json.dump(
                {
                    "expiration": response_dict["expiration"],
                    "deviceId": response_dict["deviceId"],
                },
                file,
            )

        zip_file = "provisioning_package.zip"
        with zipfile.ZipFile(zip_file, "w") as zf:
            zf.write(certificate_file, "certificate.pem")
            zf.write(private_key_file, "provisioning_key")
            zf.write(public_key_file, "provisioning_key.pub")
            zf.write(metadata_file, "metadata.json")

        os.rename(zip_file, os.path.join(os.getcwd(), zip_file))


if __name__ == "__main__":
    ProvisioningPackager().fetch_provisioning_package()
