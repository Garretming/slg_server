#!/usr/bin/env python
import os
import sys
# import xxtea

os.chdir(os.path.dirname(sys.argv[0]))
os.system('pwd')

os.system('protoc -owegame.pb wegame.proto')
os.system('mv wegame.pb ../../slg_cilent/res/')
# key = "2dc48749b79380cb"

# with open('./wegame.pb', 'rb') as plainFile:
# 	wegame = plainFile.read()
# 	enc = xxtea.encrypt(wegame, key)
# 	with open('./wegame', 'wb') as outputFile:
# 		outputFile.write(enc)

# with open('./wegame.pb', 'rb') as plainFile:
# 	wegame = plainFile.read()
# 	with open('./wegame', 'rb') as encryptedFile:
# 		enc = encryptedFile.read()
# 		dec = xxtea.decrypt(enc, key)
# 		print(wegame == dec)
