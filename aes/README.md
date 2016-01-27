# AES Verification with Cryptol and SAW

### Joe Kiniry, Galois

This directory contains several artifacts relevant to the
specification, implementation, verification, and quantitative
evaluation of AES-128.

## Manifest

The top-level artifacts of note include:
- `AES.cry`: A Cryptol specification of AES.
- `Makefile`: A build harness for compilation and verification.
- `aes-prover.saw`: This file is a top-level SAW Script file which
runs the verification on a particular solver.
- `aes.saw`: This file is a top-level SAW Script file which drives
verification of AES-128 and outputs some basic information about
intermediate verification artifacts like term sizes and the time spent
running solvers.
- `aes128BlockEncrypt.[c|h]`: This file contains an implementation of
AES-128's block encryption function as synthesized in C from Galios's
SAW tool via SBV.
- `aes128BlockEncrypt_driver.c`: An example LSS driver program for
aes128BlockEncrypt.  This C code uses `lss_` functions to setup a
symbolic interpretation environment, performs an AES-128 block
encryption, then writes the resulting AIG and CNF forms to two output
files, `aes.aig` and `noleaks.cnf`.  These files can be consumed by
other tools to reason about the final state of this driver's `main()`.
- `all_provers.sh`: A script that runs all verifications in
aes-prover.saw on all available provers from the set enumerated
therein (at the time of this writing, abc, cvc4, yices, z3, and
picosat).
- `run.sh`: A top-level script which simply runs saw on aes.saw.
- `set_prover.sh`: A sed command which changes the name of the prover
used in the aes-prover.saw script.  This script is used by
`all_provers.sh`.

## Overview

The "short version" Cryptol specification of AES, called AES.cry.

This specification is not a full-blown Literate Cryptol specification
of the FIPS 197 specification, but instead the "terse" version of the
specification that is found in the Programming in Cryptol2 book that
ships with Cryptol releases.

As such, it only includes a single theorem (aka a Cryptol property)
that stipulates that encryption and decryption are inverses of each
other (i.e., the decrypt of an encrypt of any plaintext with a given
key is that plaintext).  This theorem is called AESCorrect.

This Cryptol specification can be "executed" in the Cryptol REPL by
setting the type `Nk` on line 19 to be the flavor of AES that you wish
to evaluate or reason about and then just running the top-level
functions aesEncrypt and aesDecrypt as you please.

For example, consider the following REPL interactions.  Note that the
warnings about default type parameters can be ignored; they are simply
warnings about bit widths that is being inferred by our type inference
algorithm.

    dyn-40-222:aes> ../bin/cryptol AES.cry
                            _        _
       ___ _ __ _   _ _ __ | |_ ___ | |
      / __| '__| | | | '_ \| __/ _ \| |
     | (__| |  | |_| | |_) | || (_) | |
      \___|_|   \__, | .__/ \__\___/|_|
                |___/|_| version 2.3.0 (e87d046)
    
    Loading module Cryptol
    Loading module AES
    [warning] at ./AES.cry:156:1--159:39:
      Defaulting type parameter 'bits'
                 of finite enumeration
                 at ./AES.cry:156:36--156:51
      to 4
    [warning] at ./AES.cry:156:1--159:39:
      Defaulting type parameter 'bits'
                 of literal or demoted expression
                 at ./AES.cry:156:60--156:63
      to 4
    [warning] at ./AES.cry:133:1--138:31:
      Defaulting type parameter 'bits'
                 of literal or demoted expression
                 at ./AES.cry:136:32--136:33
      to 3
    [warning] at ./AES.cry:100:1--102:23:
      Defaulting type parameter 'bits'
                 of finite enumeration
                 at ./AES.cry:101:61--101:69
      to 2
    [warning] at ./AES.cry:95:1--97:20:
      Defaulting type parameter 'bits'
                 of finite enumeration
                 at ./AES.cry:96:58--96:66
      to 2
    AES> AES> aesEncrypt (0x3243f6a8885a308d313198a2e0370734, 0x2b7e151628aed2a6abf7158809cf4f3c)
    0x3925841d02dc09fbdc118597196a0b32
    AES> aesDecrypt (0x3925841d02dc09fbdc118597196a0b32, 0x2b7e151628aed2a6abf7158809cf4f3c)
    0x3243f6a8885a308d313198a2e0370734

One can perform random testing of the AESCorrect theorem using the
`:check` command in Cryptol.  This command automatically generates
unique random inputs to the free variables of a property to give some
evidence that the property is valid.  By default, 100 values are
generated, but one can stipulate other counts.

    AES> :check AESCorrect
    Using random testing.
    passed 100 tests.
    Coverage: 0.00% (100 of 2^^256 values)
    AES> :set tests=10
    AES> :check AESCorrect 
    Using random testing.
    passed 10 tests.
    Coverage: 0.00% (10 of 2^^256 values)

Using the `:exhaust` command, which generates and performs runtime
checking of all possible inputs is not sensible for this theorem,
given its state space is 2^^256 values, as the message size is 128
bits and the keysize of the default AES 128 is 128 bits, and
128+128=256 bits.

The `:prove` and `:sat` commands will attempt to prove a given
property using SMT or SAT solving, respectively.  You will find that,
even for AES 128, it will take an extremely long time (i.e., perhaps
never) to prove the AESCorrect theorem.

## Performance

To do a performance comparison between this synthesized AES-128 block
encode implementation and OpenSSL 1.1.0-pre1's implementation of the
same, we built the latter on an OS X 10.11 MacBook Pro (Retina,
15-inch, Late 2013) with a 2 GHz Intel Core i7.  Using OpenSSL's
`speed` command we compare three versions of AES-128: OpenSSL's
reference C implementation, OpenSSL's (presumably constant time) x86
assembly version, and our synthesized C version.

    SBV synthesized AES-128:

    aes-128 cbc     152108.50k   158374.19k   164103.34k   167080.28k   167348.91k

    OpenSSL 1.1.0-pre1 C AES-128:

    aes-128 cbc     156928.25k   157358.31k   155959.14k   157317.46k   158976.68k

    OpenSSL 1.1.0-pre1 ASM AES-128:

    aes-128 cbc     122542.22k   134664.13k   134970.82k   137819.48k   138742.44k

Thus, the synthesized verified version is speed-comparable to
reference C code and 25% faster than the ASM.

## To Do

- Cleanup the Makefile, sh scripts, and SAW scripts to be sensible for
the HACL audience who has never seen this stuff before.
- Snapshot AES-128 block encrypts from a handful of libraries and
provide a SAW Script for verifying all of them against our Cryptol
spec.
- Find at least one optimized C version and verify that it is
equivalent to the reference implementation and the specification.


