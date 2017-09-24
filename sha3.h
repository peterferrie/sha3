/**
  Copyright © 2015 Odzhan. All Rights Reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are
  met:

  1. Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.

  2. Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.

  3. The name of the author may not be used to endorse or promote products
  derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY AUTHORS "AS IS" AND ANY EXPRESS OR
  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
  STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
  ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  POSSIBILITY OF SUCH DAMAGE. */

#ifndef SHA3_H
#define SHA3_H

#include <stdint.h>

#include "macros.h"
   
#define SHA3_ROUNDS             24
#define SHA3_STATE_LEN          25

#define SHA3_224_DIGEST_LENGTH  28
#define SHA3_224                28
#define SHA3_224_CBLOCK        144

#define SHA3_256_DIGEST_LENGTH  32
#define SHA3_256                32
#define SHA3_256_CBLOCK        136

#define SHA3_384_DIGEST_LENGTH  48
#define SHA3_384                48
#define SHA3_384_CBLOCK        104

#define SHA3_512_DIGEST_LENGTH  64
#define SHA3_512                64
#define SHA3_512_CBLOCK         72

typedef union sha3_st_t {
  uint8_t  b[SHA3_STATE_LEN*8];
  uint32_t w[SHA3_STATE_LEN*2];
  uint64_t q[SHA3_STATE_LEN];
} sha3_st;

#pragma pack(push, 1)
typedef struct _SHA3_CTX {
  uint32_t olen;
  uint32_t blen;
  uint32_t idx;
  
  sha3_st s;
} SHA3_CTX;
#pragma pack(pop)

#ifdef __cplusplus
extern "C" {
#endif

  void SHA3_Init (SHA3_CTX *, int);
  void SHA3_Update (SHA3_CTX*, void *, uint32_t);
  void SHA3_Final (void*, SHA3_CTX*);

  void SHA3_Initx (SHA3_CTX *, int);
  void SHA3_Updatex (SHA3_CTX*, void *, uint32_t);
  void SHA3_Finalx (void*, SHA3_CTX*);
  
#ifdef __cplusplus
}
#endif

#endif