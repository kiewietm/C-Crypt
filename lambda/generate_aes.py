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

def get_default_ssm_kms(kms_client):
    '''
    try:
        keys = kms_client.list_keys()
        return keys['Keys'][]
    '''

    return "arn:aws:kms:eu-west-1:931486170612:key/08cd5b04-bf09-49a6-9116-ade5d4c2f6d0"

def pad(s):
    #return s + (AES_BLOCK_SIZE - len(s) % AES_BLOCK_SIZE) * chr(AES_BLOCK_SIZE - len(s) % AES_BLOCK_SIZE)
    pad_length = 32 - len(s)
    print("PAD LENGTH = ", pad_length)
    #return s + HMAC.new(str(s).encode('utf-8'), None, SHA256).hexdigest()[:pad_length]
    return s + (" " * pad_length)

def unpad(s):
    return s[:-ord(s[len(s)-1:])]

def encrypt(secret, signature, key):
    print("AES BLOCK SIZE = ", AES_BLOCK_SIZE)
    padded_secret= pad(secret)
    print("Padded Secret = ", padded_secret)
    iv = HMAC.new(str(signature).encode('utf-8'), None, SHA256).hexdigest()[:IV_LENGTH]
    print("IV = ",iv)
    hmac_key = HMAC.new(str(key).encode('utf-8'), None, SHA256)
    print("HMAC KEY = ", hmac_key.hexdigest())
    cipher = AES.new(hmac_key.digest(), AES.MODE_CBC, iv)
    print("Encrypted SECRET", cipher.encrypt(padded_secret))
    #return base64.b64encode(cipher.encrypt(padded_secret))
    return cipher.encrypt(hmac_key.hexdigest()[:16])

def decrypt(encrypted_message, signature, key):
    #encrypted_message = base64.b64decode(encrypted_message)
    print("ENCRYPTED MESSAGE =", encrypted_message)
    iv = HMAC.new(str(signature).encode('utf-8'), None, SHA256).hexdigest()[:IV_LENGTH]
    print("IV = ", iv)
    hmac_key = HMAC.new(str(key).encode('utf-8'), None, SHA256).hexdigest()
    print("HMAC KEY = ", hmac_key)
    cipher = AES.new(hmac_key, AES.MODE_CBC, iv)
    return cipher.decrypt(encrypted_message)

def my_handler(event, context):
    ssm_client = boto3.client('ssm')
    kms_arn = os.getenv('KMS_ARN', get_default_ssm_kms(ssm_client))
    parameter_name = "c-crypt-test"
    encryption_response = encrypt("mySuperSecret", "AOBFX3DFGHZ", "753951Password!")
    response='None'
    '''   
    try:
        put_response = ssm_client.put_parameter(
            Name=parameter_name,
            Description='test',
            Value=encryption_response,
            Type='SecureString',
            KeyId=kms_arn,
            Overwrite=True
        )
        
        get_response = ssm_client.get_parameter(
            Name=parameter_name,
            WithDecryption=True
        )
        
        delete_response = ssm_client.delete_parameter(
            Name=parameter_name
        )
    except Exception as e:
        return { 
            'message' : e
        } 
    
    response = get_response['Parameter']['Value'] + '\n' + put_response + '\n' + delete_response + encryption_response
    '''
    response = unpad(decrypt(encryption_response,"AOBFX3DFGHZ", "753951Password!"))
    print("RESPONCE = ",response)
    
    return { 
        'message' : str(response)
    } 

if __name__ == "__main__":
    my_handler("test", "test")
