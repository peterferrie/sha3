; mark_description "Intel(R) C++ Compiler XE for applications running on IA-32, Version 15.0.0.108 Build 20140726";
; mark_description "-O2 -Os -FAs -GS- -c";
	.686P
 	.387
	OPTION DOTNAME
	ASSUME	CS:FLAT,DS:FLAT,SS:FLAT
;ident "-defaultlib:libcpmt"
_TEXT	SEGMENT  DWORD PUBLIC FLAT  'CODE'
;	COMDAT _SHA3_Update
TXTST0:
; -- Begin  _SHA3_Update
;_SHA3_Update	ENDS
_TEXT	ENDS
_TEXT	SEGMENT  DWORD PUBLIC FLAT  'CODE'
;	COMDAT _SHA3_Update
; mark_begin;
IF @Version GE 800
  .MMX
ELSEIF @Version GE 612
  .MMX
  MMWORD TEXTEQU <QWORD>
ENDIF
IF @Version GE 800
  .XMM
ELSEIF @Version GE 614
  .XMM
  XMMWORD TEXTEQU <OWORD>
ENDIF

	PUBLIC _SHA3_Update
_SHA3_Update	PROC NEAR 
; parameter 1: 24 + esp
; parameter 2: 28 + esp
; parameter 3: 32 + esp
.B1.1:                          ; Preds .B1.0

;;; {

        push      esi                                           ;119.1
        push      edi                                           ;119.1
        push      ebx                                           ;119.1
        push      ebp                                           ;119.1
        push      esi                                           ;119.1
        mov       edi, DWORD PTR [32+esp]                       ;118.6

;;;   uint32_t i;
;;;   
;;;   // update buffer and state
;;;   for (i=0; i<inlen; i++) {

        test      edi, edi                                      ;123.15
        jbe       .B1.8         ; Prob 10%                      ;123.15
                                ; LOE edi
.B1.2:                          ; Preds .B1.1
        mov       ebx, DWORD PTR [24+esp]                       ;118.6
        xor       esi, esi                                      ;123.8
        mov       ecx, DWORD PTR [28+esp]                       ;118.6

;;;     // absorb byte into state
;;;     c->s.b[c->idx++] ^= ((uint8_t*)in)[i];    

        mov       eax, DWORD PTR [8+ebx]                        ;125.12

;;;     if (c->idx == c->blen) {
;;;       SHA3_Transform (c->s.w);

        lea       ebp, DWORD PTR [12+ebx]                       ;127.23
                                ; LOE eax ecx ebx ebp esi edi
.B1.3:                          ; Preds .B1.6 .B1.2
        mov       dl, BYTE PTR [esi+ecx]                        ;125.36
        xor       BYTE PTR [12+eax+ebx], dl                     ;125.5
        mov       eax, DWORD PTR [8+ebx]                        ;125.12
        inc       eax                                           ;125.12
        mov       DWORD PTR [8+ebx], eax                        ;125.12
        cmp       eax, DWORD PTR [4+ebx]                        ;126.19
        jne       .B1.6         ; Prob 78%                      ;126.19
                                ; LOE eax ecx ebx ebp esi edi
.B1.4:                          ; Preds .B1.3
        mov       eax, ebp                                      ;127.7
        call      _SHA3_Transform.                              ;127.7
                                ; LOE ebx ebp esi
.B1.5:                          ; Preds .B1.4

;;;       c->idx = 0;

        xor       eax, eax                                      ;128.7
        mov       edi, DWORD PTR [32+esp]                       ;
        mov       ecx, DWORD PTR [28+esp]                       ;
        mov       DWORD PTR [8+ebx], eax                        ;128.7
                                ; LOE eax ecx ebx ebp esi edi
.B1.6:                          ; Preds .B1.5 .B1.3
        inc       esi                                           ;123.22
        cmp       esi, edi                                      ;123.15
        jb        .B1.3         ; Prob 82%                      ;123.15
                                ; LOE eax ecx ebx ebp esi edi
.B1.8:                          ; Preds .B1.6 .B1.1

;;;     }
;;;   }
;;; }

        pop       ecx                                           ;131.1
        pop       ebp                                           ;131.1
        pop       ebx                                           ;131.1
        pop       edi                                           ;131.1
        pop       esi                                           ;131.1
        ret                                                     ;131.1
                                ; LOE
; mark_end;
_SHA3_Update ENDP
;_SHA3_Update	ENDS
_TEXT	ENDS
_DATA	SEGMENT  DWORD PUBLIC FLAT  'DATA'
_DATA	ENDS
; -- End  _SHA3_Update
_TEXT	SEGMENT  DWORD PUBLIC FLAT  'CODE'
;	COMDAT _SHA3_Transform
TXTST1:
; -- Begin  _SHA3_Transform
;_SHA3_Transform	ENDS
_TEXT	ENDS
_TEXT	SEGMENT  DWORD PUBLIC FLAT  'CODE'
;	COMDAT _SHA3_Transform
; mark_begin;

	PUBLIC _SHA3_Transform
_SHA3_Transform	PROC NEAR 
; parameter 1: eax
.B2.1:                          ; Preds .B2.0

;;; {

        mov       eax, DWORD PTR [4+esp]                        ;54.1
	PUBLIC _SHA3_Transform.
_SHA3_Transform.::
        push      ebp                                           ;54.1
        mov       ebp, esp                                      ;54.1
        and       esp, -16                                      ;54.1
        push      esi                                           ;54.1
        push      edi                                           ;54.1
        push      ebx                                           ;54.1
        sub       esp, 84                                       ;54.1

;;;   uint32_t i, j, rnd, r;
;;;   uint32_t t, bc[5];
;;;   uint8_t  lfsr=1;
;;;   
;;; const uint8_t keccakf_piln[24] = 

        mov       esi, OFFSET FLAT: keccakf_piln.173.0.0.2      ;59.32
        push      6                                             ;59.32
        pop       ecx                                           ;59.32
        lea       edi, DWORD PTR [52+esp]                       ;59.32
        mov       DWORD PTR [-16+edi], eax                      ;54.1
        mov       BYTE PTR [24+edi], 1                          ;57.16
        rep   movsd                                             ;59.32
                                ; LOE
.B2.2:                          ; Preds .B2.1

;;; { 10, 7,  11, 17, 18, 3, 5,  16, 8,  21, 24, 4, 
;;;   15, 23, 19, 13, 12, 2, 20, 14, 22, 9,  6,  1  };
;;;   
;;;   for (rnd=0; rnd<22; rnd++) 

        mov       BYTE PTR [44+esp], 0                          ;63.8
                                ; LOE
.B2.3:                          ; Preds .B2.14 .B2.2

;;;   {
;;;     // Theta
;;;     for (i=0; i<5; i++) {     
;;;       bc[i] = st[i] 
;;;             ^ st[i +  5] 

        mov       eax, DWORD PTR [36+esp]                       ;68.15

;;;             ^ st[i + 10] 
;;;             ^ st[i + 15] 
;;;             ^ st[i + 20];
;;;     }
;;;     for (i=0; i<5; i++) {

        xor       esi, esi                                      ;73.10
        movdqu    xmm4, XMMWORD PTR [eax]                       ;68.15
        movdqu    xmm0, XMMWORD PTR [20+eax]                    ;68.15
        movdqu    xmm1, XMMWORD PTR [40+eax]                    ;69.15
        movdqu    xmm2, XMMWORD PTR [60+eax]                    ;70.15
        movdqu    xmm3, XMMWORD PTR [80+eax]                    ;71.15
        mov       edx, DWORD PTR [16+eax]                       ;67.15
        pxor      xmm4, xmm0                                    ;68.15
        xor       edx, DWORD PTR [36+eax]                       ;68.15
        pxor      xmm4, xmm1                                    ;69.15
        xor       edx, DWORD PTR [56+eax]                       ;69.15
        pxor      xmm4, xmm2                                    ;70.15
        xor       edx, DWORD PTR [76+eax]                       ;70.15
        pxor      xmm4, xmm3                                    ;71.15
        xor       edx, DWORD PTR [96+eax]                       ;71.15
        movdqa    XMMWORD PTR [16+esp], xmm4                    ;67.7
        mov       DWORD PTR [32+esp], edx                       ;67.7
                                ; LOE esi
.B2.4:                          ; Preds .B2.6 .B2.3

;;;       t = bc[(i + 4) % 5] ^ ROTL32(bc[(i + 1) % 5], 1);

        mov       eax, -858993459                               ;74.29
        lea       edi, DWORD PTR [1+esi]                        ;74.29
        mul       edi                                           ;74.29
        shr       edx, 2                                        ;74.29
        lea       ecx, DWORD PTR [4+esi]                        ;74.19
        mov       eax, -858993459                               ;74.24
        lea       ebx, DWORD PTR [edx+edx*4]                    ;74.29
        mul       ecx                                           ;74.24
        shr       edx, 2                                        ;74.24
        neg       ebx                                           ;74.29
        add       ebx, edi                                      ;74.29
        lea       eax, DWORD PTR [edx+edx*4]                    ;74.24

;;;       for (j=0; j<25; j+=5) {

        xor       edx, edx                                      ;75.12
        sub       ecx, eax                                      ;74.24
        mov       ebx, DWORD PTR [16+esp+ebx*4]                 ;74.29
        rol       ebx, 1                                        ;74.29
        xor       ebx, DWORD PTR [16+esp+ecx*4]                 ;74.29

;;;         st[j + i] ^= t;

        mov       ecx, DWORD PTR [36+esp]                       ;76.9
        lea       eax, DWORD PTR [ecx+esi*4]                    ;76.9
                                ; LOE eax edx ebx edi
.B2.5:                          ; Preds .B2.5 .B2.4
        xor       DWORD PTR [eax+edx*4], ebx                    ;76.9
        add       edx, 5                                        ;75.23
        cmp       edx, 25                                       ;75.19
        jb        .B2.5         ; Prob 80%                      ;75.19
                                ; LOE eax edx ebx edi
.B2.6:                          ; Preds .B2.5
        mov       esi, edi                                      ;73.20
        cmp       edi, 5                                        ;73.17
        jb        .B2.4         ; Prob 80%                      ;73.17
                                ; LOE esi
.B2.7:                          ; Preds .B2.6

;;;       }
;;;     }
;;; 
;;;     // Rho Pi
;;;     t = st[1];

        mov       eax, DWORD PTR [36+esp]                       ;81.9

;;;     for (i=0, r=0; i<24; i++) {

        xor       ecx, ecx                                      ;82.15
        xor       edx, edx                                      ;82.5
        mov       edi, DWORD PTR [4+eax]                        ;81.9
                                ; LOE edx ecx edi
.B2.8:                          ; Preds .B2.8 .B2.7

;;;       r += i + 1;
;;;       j = keccakf_piln[i];
;;;       bc[0] = st[j];

        mov       ebx, DWORD PTR [36+esp]                       ;85.15
        lea       eax, DWORD PTR [1+edx]                        ;83.16
        lea       ecx, DWORD PTR [1+ecx+edx]                    ;83.7
        movzx     edx, BYTE PTR [52+esp+edx]                    ;84.11

;;;       st[j] = ROTL32(t, r & 31);

        rol       edi, cl                                       ;86.15
        cmp       eax, 24                                       ;82.5
        mov       esi, DWORD PTR [ebx+edx*4]                    ;85.15
        mov       DWORD PTR [ebx+edx*4], edi                    ;86.7

;;;       t = bc[0];

        mov       edi, esi                                      ;87.7
        mov       edx, eax                                      ;82.5
        jb        .B2.8         ; Prob 95%                      ;82.5
                                ; LOE edx ecx esi edi
.B2.9:                          ; Preds .B2.8
        mov       DWORD PTR [16+esp], esi                       ;85.7

;;;     }
;;; 
;;;     // Chi
;;;     for (j=0; j<25; j+=5) {

        mov       DWORD PTR [40+esp], 0                         ;91.5
                                ; LOE
.B2.10:                         ; Preds .B2.12 .B2.9

;;;       for (i=0; i<5; i++) {
;;;         bc[i] = st[j + i];

        mov       edi, DWORD PTR [40+esp]                       ;93.24
        mov       edx, DWORD PTR [36+esp]                       ;93.17
        lea       ecx, DWORD PTR [edi+edi*4]                    ;93.24

;;;       }
;;;       for (i=0; i<5; i++) {

        xor       edi, edi                                      ;95.7
        movdqu    xmm0, XMMWORD PTR [edx+ecx*4]                 ;93.17
        mov       eax, DWORD PTR [16+edx+ecx*4]                 ;93.17

;;;         st[j + i] ^= (~bc[(i + 1) % 5]) & bc[(i + 2) % 5];

        lea       ebx, DWORD PTR [edx+ecx*4]                    ;96.9
        movdqa    XMMWORD PTR [16+esp], xmm0                    ;93.9
        mov       DWORD PTR [32+esp], eax                       ;93.9
        mov       DWORD PTR [48+esp], ebx                       ;96.9
                                ; LOE edi
.B2.11:                         ; Preds .B2.11 .B2.10
        mov       eax, -858993459                               ;96.37
        lea       esi, DWORD PTR [1+edi]                        ;96.32
        mul       esi                                           ;96.37
        shr       edx, 2                                        ;96.37
        lea       ecx, DWORD PTR [2+edi]                        ;96.51
        mov       eax, -858993459                               ;96.56
        lea       ebx, DWORD PTR [edx+edx*4]                    ;96.37
        mul       ecx                                           ;96.56
        shr       edx, 2                                        ;96.56
        neg       ebx                                           ;96.37
        add       ebx, esi                                      ;96.37
        lea       eax, DWORD PTR [edx+edx*4]                    ;96.56
        sub       ecx, eax                                      ;96.56
        mov       ebx, DWORD PTR [16+esp+ebx*4]                 ;96.24
        not       ebx                                           ;96.24
        and       ebx, DWORD PTR [16+esp+ecx*4]                 ;96.43
        mov       ecx, DWORD PTR [48+esp]                       ;96.9
        xor       DWORD PTR [ecx+edi*4], ebx                    ;96.9
        mov       edi, esi                                      ;95.7
        cmp       esi, 5                                        ;95.7
        jb        .B2.11        ; Prob 79%                      ;95.7
                                ; LOE edi
.B2.12:                         ; Preds .B2.11
        mov       eax, DWORD PTR [40+esp]                       ;91.5
        inc       eax                                           ;91.5
        mov       DWORD PTR [40+esp], eax                       ;91.5
        cmp       eax, 5                                        ;91.5
        jb        .B2.10        ; Prob 80%                      ;91.5
                                ; LOE
.B2.13:                         ; Preds .B2.12

;;;       }
;;;     }
;;;     // Iota
;;;     st[0] ^= rc(&lfsr);

        lea       eax, DWORD PTR [76+esp]                       ;100.14
        call      _rc.                                          ;100.14
                                ; LOE eax
.B2.14:                         ; Preds .B2.13
        mov       esi, DWORD PTR [36+esp]                       ;100.5
        xor       DWORD PTR [esi], eax                          ;100.5
        mov       al, BYTE PTR [44+esp]                         ;63.23
        inc       al                                            ;63.23
        mov       BYTE PTR [44+esp], al                         ;63.23
        cmp       al, 22                                        ;63.19
        jb        .B2.3         ; Prob 95%                      ;63.19
                                ; LOE
.B2.15:                         ; Preds .B2.14

;;;   }
;;; }

        add       esp, 84                                       ;102.1
        pop       ebx                                           ;102.1
        pop       edi                                           ;102.1
        pop       esi                                           ;102.1
        mov       esp, ebp                                      ;102.1
        pop       ebp                                           ;102.1
        ret                                                     ;102.1
                                ; LOE
; mark_end;
_SHA3_Transform ENDP
;_SHA3_Transform	ENDS
_TEXT	ENDS
_RDATA	SEGMENT  DWORD PUBLIC FLAT READ  'DATA'
keccakf_piln.173.0.0.2	DB	10
	DB	7
	DB	11
	DB	17
	DB	18
	DB	3
	DB	5
	DB	16
	DB	8
	DB	21
	DB	24
	DB	4
	DB	15
	DB	23
	DB	19
	DB	13
	DB	12
	DB	2
	DB	20
	DB	14
	DB	22
	DB	9
	DB	6
	DB	1
_RDATA	ENDS
_DATA	SEGMENT  DWORD PUBLIC FLAT  'DATA'
_DATA	ENDS
; -- End  _SHA3_Transform
_TEXT	SEGMENT  DWORD PUBLIC FLAT  'CODE'
;	COMDAT _rc
TXTST2:
; -- Begin  _rc
;_rc	ENDS
_TEXT	ENDS
_TEXT	SEGMENT  DWORD PUBLIC FLAT  'CODE'
;	COMDAT _rc
; mark_begin;

	PUBLIC _rc
_rc	PROC NEAR 
; parameter 1: eax
.B3.1:                          ; Preds .B3.0

;;; {

        mov       eax, DWORD PTR [4+esp]                        ;35.1
	PUBLIC _rc.
_rc.::
        push      esi                                           ;35.1
        push      edi                                           ;35.1
        push      ebx                                           ;35.1
        push      ebp                                           ;35.1
        push      esi                                           ;35.1
        push      esi                                           ;35.1

;;;   uint64_t c;
;;;   uint32_t i, t;
;;; 
;;;   c = 0;

        xor       esi, esi                                      ;39.3

;;;   t = *LFSR;

        movzx     edx, BYTE PTR [eax]                           ;40.8
        xor       ebp, ebp                                      ;39.3
        mov       DWORD PTR [4+esp], eax                        ;35.1

;;;   
;;;   for (i=1; i<128; i += i) 

        push      1                                             ;42.8
        pop       ebx                                           ;42.8
        mov       DWORD PTR [esp], edx                          ;40.8
                                ; LOE ebx ebp esi
.B3.2:                          ; Preds .B3.6 .B3.1

;;;   {
;;;     if (t & 1) {
;;;       c ^= (uint64_t)1ULL << (i - 1);

        push      1                                             ;45.35
        pop       eax                                           ;45.35
        lea       ecx, DWORD PTR [-1+ebx]                       ;45.35
        xor       edx, edx                                      ;45.35
        mov       edi, DWORD PTR [esp]                          ;44.13
        and       edi, 1                                        ;44.13
        call      __allshl                                      ;45.35
                                ; LOE eax edx ebx ebp esi edi
.B3.6:                          ; Preds .B3.2

;;;     }
;;;     t = (t & 0x80) ? (t << 1) ^ 0x71 : t << 1;

        mov       ecx, DWORD PTR [esp]                          ;47.28
        xor       eax, esi                                      ;45.7
        xor       edx, ebp                                      ;45.7
        test      edi, edi                                      ;45.7
        cmovne    ebp, edx                                      ;45.7
        lea       edi, DWORD PTR [ecx+ecx]                      ;47.28
        mov       edx, edi                                      ;47.33
        cmovne    esi, eax                                      ;45.7
        xor       edx, 113                                      ;47.33
        test      ecx, 128                                      ;47.14
        cmove     edx, edi                                      ;47.5
        add       ebx, ebx                                      ;42.20
        mov       DWORD PTR [esp], edx                          ;47.5
        cmp       ebx, 128                                      ;42.15
        jb        .B3.2         ; Prob 82%                      ;42.15
                                ; LOE rdx edx ebx ebp esi dl dh
.B3.3:                          ; Preds .B3.6

;;;   }
;;;   *LFSR = (uint8_t)t;

        mov       ecx, DWORD PTR [4+esp]                        ;49.4

;;;   return c;

        mov       eax, esi                                      ;50.10
        mov       BYTE PTR [ecx], dl                            ;49.4
                                ; LOE
.B3.7:                          ; Preds .B3.3
        pop       ecx                                           ;50.10
        pop       ecx                                           ;50.10
        pop       ebp                                           ;50.10
        pop       ebx                                           ;50.10
        pop       edi                                           ;50.10
        pop       esi                                           ;50.10
        ret                                                     ;50.10
                                ; LOE
; mark_end;
_rc ENDP
;_rc	ENDS
_TEXT	ENDS
_DATA	SEGMENT  DWORD PUBLIC FLAT  'DATA'
_DATA	ENDS
; -- End  _rc
_TEXT	SEGMENT  DWORD PUBLIC FLAT  'CODE'
;	COMDAT _SHA3_Final
TXTST3:
; -- Begin  _SHA3_Final
;_SHA3_Final	ENDS
_TEXT	ENDS
_TEXT	SEGMENT  DWORD PUBLIC FLAT  'CODE'
;	COMDAT _SHA3_Final
; mark_begin;

	PUBLIC _SHA3_Final
_SHA3_Final	PROC NEAR 
; parameter 1: 12 + esp
; parameter 2: 16 + esp
.B4.1:                          ; Preds .B4.0

;;; {

        push      ebx                                           ;134.1
        push      esi                                           ;134.1
        mov       ebx, DWORD PTR [16+esp]                       ;133.6

;;;   uint32_t i;
;;;   // absorb 3 bits, Keccak uses 1
;;;   c->s.b[c->idx] ^= 6;

        mov       edx, DWORD PTR [8+ebx]                        ;137.10

;;;   // absorb end bit
;;;   c->s.b[c->blen-1] ^= 0x80;
;;;   // update context
;;;   SHA3_Transform (c->s.w);

        lea       eax, DWORD PTR [12+ebx]                       ;141.3
        xor       BYTE PTR [12+edx+ebx], 6                      ;137.3
        mov       ecx, DWORD PTR [4+ebx]                        ;139.10
        xor       BYTE PTR [11+ecx+ebx], -128                   ;139.3
        call      _SHA3_Transform.                              ;141.3
                                ; LOE ebx ebp esi edi
.B4.2:                          ; Preds .B4.1

;;;   // copy digest to buffer
;;;   for (i=0; i<c->olen; i++) {

        cmp       DWORD PTR [ebx], 0                            ;143.15
        jbe       .B4.6         ; Prob 10%                      ;143.15
                                ; LOE ebx ebp esi edi
.B4.3:                          ; Preds .B4.2
        mov       ecx, DWORD PTR [12+esp]                       ;133.6
        xor       edx, edx                                      ;143.8
                                ; LOE edx ecx ebx ebp esi edi
.B4.4:                          ; Preds .B4.4 .B4.3

;;;     ((uint8_t*)out)[i] = c->s.b[i];

        mov       al, BYTE PTR [12+edx+ebx]                     ;144.26
        mov       BYTE PTR [edx+ecx], al                        ;144.16
        inc       edx                                           ;143.24
        cmp       edx, DWORD PTR [ebx]                          ;143.15
        jb        .B4.4         ; Prob 82%                      ;143.15
                                ; LOE edx ecx ebx ebp esi edi
.B4.6:                          ; Preds .B4.4 .B4.2

;;;   }
;;; }

        pop       ecx                                           ;146.1
        pop       ebx                                           ;146.1
        ret                                                     ;146.1
                                ; LOE
; mark_end;
_SHA3_Final ENDP
;_SHA3_Final	ENDS
_TEXT	ENDS
_DATA	SEGMENT  DWORD PUBLIC FLAT  'DATA'
_DATA	ENDS
; -- End  _SHA3_Final
_TEXT	SEGMENT  DWORD PUBLIC FLAT  'CODE'
;	COMDAT _SHA3_Init
TXTST4:
; -- Begin  _SHA3_Init
;_SHA3_Init	ENDS
_TEXT	ENDS
_TEXT	SEGMENT  DWORD PUBLIC FLAT  'CODE'
;	COMDAT _SHA3_Init
; mark_begin;

	PUBLIC _SHA3_Init
_SHA3_Init	PROC NEAR 
; parameter 1: 8 + esp
; parameter 2: 12 + esp
.B5.1:                          ; Preds .B5.0

;;; {

        push      edi                                           ;106.1

;;;   uint32_t i;
;;;   
;;;   c->olen = mdlen;
;;;   c->blen = 100 - (2 * mdlen);
;;;   c->idx  = 0;
;;;   
;;;   for (i=0; i<SHA3_STATE_LEN; i++) {
;;;     c->s.w[i] = 0;

        push      25                                            ;114.5
        pop       ecx                                           ;114.5
        mov       edi, DWORD PTR [8+esp]                        ;105.6
        mov       eax, DWORD PTR [12+esp]                       ;105.6
        mov       DWORD PTR [edi], eax                          ;109.3
        add       eax, eax                                      ;110.24
        neg       eax                                           ;110.24
        add       eax, 100                                      ;110.24
        mov       DWORD PTR [4+edi], eax                        ;110.3
        xor       eax, eax                                      ;114.5
        mov       DWORD PTR [8+edi], 0                          ;111.3
        add       edi, 12                                       ;114.5
        rep   stosd                                             ;114.5
                                ; LOE ebx ebp esi
.B5.2:                          ; Preds .B5.1

;;;   }
;;; }

        pop       edi                                           ;116.1
        ret                                                     ;116.1
                                ; LOE
; mark_end;
_SHA3_Init ENDP
;_SHA3_Init	ENDS
_TEXT	ENDS
_DATA	SEGMENT  DWORD PUBLIC FLAT  'DATA'
_DATA	ENDS
; -- End  _SHA3_Init
_DATA	SEGMENT  DWORD PUBLIC FLAT  'DATA'
_DATA	ENDS
EXTRN	__allshl:PROC
	INCLUDELIB <libmmt>
	INCLUDELIB <LIBCMT>
	INCLUDELIB <libirc>
	INCLUDELIB <svml_dispmt>
	INCLUDELIB <OLDNAMES>
	INCLUDELIB <libdecimal>
	END
