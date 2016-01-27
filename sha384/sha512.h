#ifndef __SHA_512
#define __SHA_512

#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#define U64_C(c) (c ## U)

typedef uint32_t u32;
typedef uint64_t u64;
typedef uint8_t byte;

typedef struct
{
  u64 h0, h1, h2, h3, h4, h5, h6, h7;
  u64 nblocks;
  byte buf[128];
  int count;
} SHA512_CONTEXT;

#endif
