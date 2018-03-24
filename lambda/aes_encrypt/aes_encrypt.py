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

def encrypt(secret, signature, key):
    padded_secret= pad(secret)
    iv = HMAC.new(str(signature).encode('utf-8'), None, SHA256).hexdigest()[:IV_LENGTH]
    hmac_key = HMAC.new(str(key).encode('utf-8'), None, SHA256)
    cipher = AES.new(hmac_key.digest(), AES.MODE_CBC, iv)
    return base64.b64encode(cipher.encrypt(padded_secret))

def my_handler(event, context):
    ssm_client = boto3.client('ssm')
    kms_arn = os.getenv('KMS_ARN')
    parameter_name = "c-crypt-test"
    response='None'
    
    try:
        put_response = ssm_client.put_parameter(
            Name=parameter_name,
            Description='test',
            Value=encrypt("mySuperSecret", "AOBFX3DFGHZ", "753951Password!"),
            Type='SecureString',
            KeyId=kms_arn,
            Overwrite=True
        )
    except Exception as e:
        return { 
            'message' : e
        } 

    return { 
        'message' : str(put_response)
    } 

if __name__ == "__main__":
    my_handler("test", "test")