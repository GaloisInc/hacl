# Build, using LLVM, LLVM bytecode and object code for C
# implementation of AES128 from Cryptol.

TOP=..
BIN=${TOP}/bin
SYMAPI?=${TOP}/sym-api
CC=gcc
CCFLAGS?=-Wall -O3 -DNDEBUG -fomit-frame-pointer -I${SYMAPI}
SAW?=${BIN}/saw
CLANG?=clang
LLVM_LINK?=/usr/local/opt/llvm/bin/llvm-link

all: aes.bc aes128BlockEncrypt.o aes128BlockEncrypt_driver.o

%.o: %.c
	${CLANG} ${CCFLAGS} -c $< -o $@

%.bc: %.c
	${CLANG} -emit-llvm -I${SYMAPI} -c $< -o $@

sym-api.bc: ${SYMAPI}/sym-api.c
	${CLANG} -emit-llvm -I${SYMAPI} -c $< -o $@

aes.bc: aes128BlockEncrypt.bc aes128BlockEncrypt_driver.bc
	${LLVM_LINK} $^ -o $@

aes128BlockEncrypt_driver_llvm: aes128BlockEncrypt.bc aes128BlockEncrypt_driver.bc sym-api.bc
	llvm-dis aes128BlockEncrypt.bc
	llvm-dis aes128BlockEncrypt_driver.bc
	llvm-ld -disable-opt -native $^ -o $@

clean:
	rm -f *.o *.bc *.ll *.s aes128BlockEncrypt_driver_llvm *.aig *.cnf
