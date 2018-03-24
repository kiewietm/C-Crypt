'''
Based on Stackoverflow Answer: http://stackoverflow.com/a/12525165/353550
'''
import base64
import sys
sys.path.append('./modules')
from Crypto.Cipher import AES
from Crypto import Random


BS = 16


def pad(s):
    return s + (BS - len(s) % BS) * chr(BS - len(s) % BS)


def unpad(s):
    return s[:-ord(s[len(s)-1:])]


class AESCipher(object):
    def __init__(self, key):
        self.key = key

    def encrypt(self, raw):
        print("Key = ", self.key)
        raw = pad(raw)
        print("Raw = ", raw)
        iv = Random.new().read(AES.block_size)
        print("IV = ", iv)
        cipher = AES.new(self.key, AES.MODE_CBC, iv)
        #print("Encrypet Secret =", cipher.encrypt(raw))
        #print("Base Secret =", base64.b64encode(cipher.encrypt(raw)))
        return base64.b64encode(iv + cipher.encrypt(raw))

    def decrypt(self, enc):
        print("Encrypted Msg = ", enc)
        enc = base64.b64decode(enc)
        print("Base 64 decode = ", enc)
        iv = enc[:16]
        print("IV = ", iv)
        cipher = AES.new(self.key, AES.MODE_CBC, iv)
        return unpad(cipher.decrypt(enc[16:]))


if __name__ == '__main__':
    secret = 'kLF9AWRIA0H5WiLcoByZF9H3Yl7FXtBU'
    aes_cipher = AESCipher(secret)

    text = 'this is dummy text'
    encrypted_text = aes_cipher.encrypt(text)

    text = aes_cipher.decrypt(encrypted_text)
    print(text)
