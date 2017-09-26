/**
  Copyright © 2017 Odzhan. All Rights Reserved.

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

#include "keccak.h"

// round constant function
// Primitive polynomial over GF(2): x^8+x^6+x^5+x^4+1
uint16_t rc (uint8_t *LFSR)
{
  uint16_t c; 
  int8_t   t;
  uint8_t  i;

  c = 0;
  t = *LFSR;
  
  for (i=1; i<128; i += i) 
  {
    if (t & 1) {
      // if shift value is < 16
      if ((i-1) < 16) {
        c ^= 1UL << (i - 1);
      }
    }
    t = (t & 0x80) ? (t << 1) ^ 0x71 : t << 1;
  }
  *LFSR = (uint8_t)t;
  return c;
}

void k400_permute (void *state)
{
  int     i, j, rnd, r;
  uint16_t t, bc[5];
  uint8_t  lfsr=1;
  uint16_t *st=(uint16_t*)state;
  
const uint8_t keccakf_piln[24] = 
{ 10, 7,  11, 17, 18, 3, 5,  16, 8,  21, 24, 4, 
  15, 23, 19, 13, 12, 2, 20, 14, 22, 9,  6,  1  };

const uint8_t m5[10] = 
{ 0, 1, 2, 3, 4, 0, 1, 2, 3, 4 };
  
  for (rnd=0; rnd<20; rnd++) 
  {
    // Theta
    for (i=0; i<5; i++) {     
      bc[i] = st[i] 
            ^ st[i +  5] 
            ^ st[i + 10] 
            ^ st[i + 15] 
            ^ st[i + 20];
    }
    for (i=0; i<5; i++) {
      t = bc[m5[(i + 4)]] ^ ROTL16(bc[m5[(i + 1)]], 1);
      for (j=0; j<25; j+=5) {
        st[j + i] ^= t;
      }
    }
    // Rho Pi
    t = st[1];
    for (i=0, r=0; i<24; i++) {
      r += i + 1;
      j = keccakf_piln[i];
      bc[0] = st[j];
      st[j] = ROTL16(t, r & 15);
      t = bc[0];
    }
    // Chi
    for (j=0; j<25; j+=5) {
      for (i=0; i<5; i++) {
        bc[i] = st[j + i];
      }
      for (i=0; i<5; i++) {
        st[j + i] ^= (~bc[m5[(i + 1)]]) & bc[m5[(i + 2)]];
      }
    }
    // Iota
    st[0] ^= rc(&lfsr);
  }
}

#ifdef TEST

#include <stdio.h>

uint8_t tv1[]={
  0xf5,0x09,0xac,0x40,0xa9,0x0f,0xf5,0x14,
  0x9f,0xe8,0xa0,0xec,0xd1,0x5b,0x70,0x78,
  0xf0,0xef,0x8f,0xbf,0x37,0x03,0x52,0x60,
  0x75,0xdc,0xc9,0x0e,0x76,0xe7,0x46,0x52,
  0xa1,0x59,0x81,0x5d,0x95,0x6d,0x14,0x6e,
  0x3e,0x63,0xee,0x58,0xff,0x71,0x4c,0x71,
  0x8e,0xb3 };

uint8_t tv2[]={
  0x37,0xe5,0xd6,0xd5,0xe7,0xdb,0xf3,0xaa,
  0xc7,0x9b,0x7d,0xca,0xb2,0x86,0xec,0xfd,
  0x2c,0x69,0x5b,0x4e,0xb1,0x67,0xad,0x15,
  0xf7,0xa7,0x6f,0xa6,0xff,0x67,0x8a,0x3f,
  0x99,0x2f,0xc2,0xe2,0x6b,0x65,0x31,0x5f,
  0xa6,0x5b,0x29,0xca,0x24,0xc2,0x5c,0xb8,
  0x7c,0x09 };
  
void bin2hex(uint8_t x[], int len) {
  int i;
  for (i=0; i<len; i++) {
    if ((i & 7)==0) putchar('\n');
    printf ("0x%02x,", x[i]);
  }
  putchar('\n');
}
  
int main(void)
{
  uint8_t  out[50];
  int      equ;
  
  memset(out, 0, sizeof(out));
  
  k400_permute(out);
  equ = memcmp(out, tv1, sizeof(tv1))==0;
  printf("Test 1 %s\n", equ ? "OK" : "Failed"); 
  //bin2hex(out, 50);

  k400_permute(out);
  equ = memcmp(out, tv2, sizeof(tv2))==0;
  printf("Test 2 %s\n", equ ? "OK" : "Failed");
  //bin2hex(out, 50);
  return 0;
}
#endif