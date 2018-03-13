import boto3
import os
import sys
sys.path.append('./modules')
from Crypto.Hash import HMAC
from Crypto.Cipher import AES
from Crypto.Hash import SHA256

def get_default_ssm_kms(kms_client):
    '''
    try:
        keys = kms_client.list_keys()
        return keys['Keys'][]
    '''

    return "arn:aws:kms:eu-west-1:931486170612:key/08cd5b04-bf09-49a6-9116-ade5d4c2f6d0"

def create_key(secret, signature):
    iv = HMAC.new(str(signature).encode('utf-8'), None, SHA256).hexdigest()[:AES.block_size]
    sec = HMAC.new(str(secret).encode('utf-8'), None, SHA256)
    return AES.new(sec.digest(), AES.MODE_CBC, iv)

def my_handler(event, context):
    ssm_client = boto3.client('ssm')
    kms_arn = os.getenv('KMS_ARN', get_default_ssm_kms(ssm_client))
    parameter_name = "c-crypt-test"
    encryption_response = create_key("mySuperSecret", "AOBFX3DFGHZ")
    response='None'
    
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
    print(response)
    
    return { 
        'message' : str(response)
    } 

if __name__ == "__main__":
    my_handler("test", "test")
