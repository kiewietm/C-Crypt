import boto3
import os
import sys
sys.path.append('./modules')
from Crypto.Hash import HMAC
from Crypto.Cipher import AES
from Crypto.Hash import SHA256
import base64

AES_BLOCK_SIZE = 32
IV_LENGTH = 16

def pad(s):
    return s + (AES_BLOCK_SIZE - len(s) % AES_BLOCK_SIZE) * chr(AES_BLOCK_SIZE - len(s) % AES_BLOCK_SIZE)

def unpad(s):
    return s[:-ord(s[len(s)-1:])]

def decrypt(encrypted_message, signature, key):
    encrypted_message = base64.b64decode(encrypted_message)
    iv = HMAC.new(str(signature).encode('utf-8'), None, SHA256).hexdigest()[:IV_LENGTH]
    hmac_key = HMAC.new(str(key).encode('utf-8'), None, SHA256)
    cipher = AES.new(hmac_key.digest(), AES.MODE_CBC, iv)
    return cipher.decrypt(encrypted_message)

def my_handler(event, context):
    ssm_client = boto3.client('ssm')
    kms_arn = os.getenv('KMS_ARN')
    parameter_name = "c-crypt-test"
    response='None'
    
    try:
        get_response = ssm_client.get_parameter(
            Name=parameter_name,
            WithDecryption=True
        )

        print("Decrypted Secret = ", unpad(decrypt(get_response['Parameter']['Value'],"AOBFX3DFGHZ", "753951Password!")))

        delete_response = ssm_client.delete_parameter(
            Name=parameter_name
        )
    except Exception as e:
        return { 
            'message' : e
        } 
    
    return { 
        'message' : str(get_response)
    } 

if __name__ == "__main__":
    my_handler("test", "test")