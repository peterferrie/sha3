;
;  Copyright © 2017 Odzhan. All Rights Reserved.
;
;  Redistribution and use in source and binary forms, with or without
;  modification, are permitted provided that the following conditions are
;  met:
;
;  1. Redistributions of source code must retain the above copyright
;  notice, this list of conditions and the following disclaimer.
;
;  2. Redistributions in binary form must reproduce the above copyright
;  notice, this list of conditions and the following disclaimer in the
;  documentation and/or other materials provided with the distribution.
;
;  3. The name of the author may not be used to endorse or promote products
;  derived from this software without specific prior written permission.
;
;  THIS SOFTWARE IS PROVIDED BY AUTHORS "AS IS" AND ANY EXPRESS OR
;  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
;  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
;  DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
;  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
;  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
;  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
;  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
;  STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
;  ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
;  POSSIBILITY OF SUCH DAMAGE.
;
; -----------------------------------------------
; Keccak-p[800, 24] in x86 assembly
;
; size: 252 bytes
;
; global calls use cdecl convention
;
; -----------------------------------------------
    bits   32
  
struc kws_t
  bc1  resd 1 ; edi
  bc2  resd 1 ; esi
  bc3  resd 1 ; ebp
  bc4  resd 1 ; esp
  bc5  resd 1 ; ebx
  lfsr resd 1 ; edx
  ; ecx
  ; eax
  .size:
endstruc
  
    %ifndef BIN
      global k800_permutex
      global _k800_permutex
    %endif
    
; void k800_permutex(void *state);    
k800_permutex:
_k800_permutex:
    pushad
    mov    esi, [esp+32+4]      ; esi = st
    call   k800_l0
    ; modulo 5    
    dd     003020100h, 002010004h, 000000403h
    ; rho pi
    dd     0110b070ah, 010050312h, 004181508h 
    dd     00d13170fh, 00e14020ch, 001060916h
k800_l0:
    pop    ebx                  ; m + p
    push   22
    pop    eax
    cdq
    inc    edx                  ; lfsr = 1    
    pushad                      ; create local space
    mov    edi, esp             ; edi = bc   
k800_l1:    
    push   eax    
    push   5 
    pop    ecx    
    pushad
theta_l0:
    ; Theta
    lodsd                       ; t  = st[i     ];  
    xor    eax, [esi+ 5*4-4]    ; t ^= st[i +  5];
    xor    eax, [esi+10*4-4]    ; t ^= st[i + 10];
    xor    eax, [esi+15*4-4]    ; t ^= st[i + 15];
    xor    eax, [esi+20*4-4]    ; t ^= st[i + 20];
    stosd                       ; bc[i] = t;
    loop   theta_l0        
    popad    
    xor    eax, eax    
theta_l1:
    movzx  ebp, byte[ebx+eax+4] ; ebp = m[(i + 4)];
    mov    ebp, [edi+ebp*4]     ; t   = bc[m[(i + 4)]];    
    movzx  edx, byte[ebx+eax+1] ; edx = m[(i + 1)];
    mov    edx, [edi+edx*4]     ; edx = bc[m[(i + 1)]];
    rol    edx, 1               ; t  ^= ROTL32(edx, 1);
    xor    ebp, edx
    push   eax                  ; save i
theta_l2:
    xor    [esi+eax*4], ebp     ; st[j] ^= t;
    add    al, 5                ; j+=5 
    cmp    al, 25               ; j<25
    jb     theta_l2    
    pop    eax                  ; restore i    
    inc    eax                  ; i++
    cmp    al, 5                ; i<5
    jnz    theta_l1
    ; *************************************
    ; Rho Pi
    ; *************************************
    mov    ebp, [esi+1*4]       ; t = st[1];
    xor    eax, eax
    xor    ecx, ecx
rho_l0:
    lea    ecx, [ecx+eax+1]     ; r = r + i + 1;
    rol    ebp, cl              ; t = ROTL32(t, r); 
    movzx  edx, byte[ebx+eax+12]; edx = p[i];
    xchg   [esi+edx*4], ebp     ; XCHG(st[p[i]], t);
    mov    [edi+0*4], ebp       ; bc[0] = t;
    inc    eax                  ; i++
    cmp    al, 24               ; i<24
    jnz    rho_l0               ; 
    ; *************************************
    ; Chi
    ; *************************************
    xor    ecx, ecx             ; i = 0   
chi_l0:    
    pushad
    ; memcpy(&bc, &st[i], 5*4);
    lea    esi, [esi+ecx*4]     ; esi = &st[i];
    mov    cl, 5
    rep    movsd
    popad
    xor    eax, eax
chi_l1:
    movzx  ebp, byte[ebx+eax+1]
    movzx  edx, byte[ebx+eax+2]
    mov    ebp, [edi+ebp*4]     ; t = ~bc[m[(i + 1)]] 
    not    ebp            
    and    ebp, [edi+edx*4]
    lea    edx, [eax+ecx]       ; edx = j + i    
    xor    [esi+edx*4], ebp     ; st[j + i] ^= t;  
    inc    eax                  ; j++
    cmp    al, 5                ; j<5
    jnz    chi_l1        
    add    cl, 5                ; i+=5;
    cmp    cl, 25               ; i<25
    jb     chi_l0
    ; Iota
    lea    eax, [esp+kws_t+lfsr+4]; eax = lfsr
    pushad
    xor    esi, esi             ; esi = 0
    xchg   eax, esi             ; esi = &lfsr, eax = 0
    mov    edi, esi             ; edi = &lfsr
    cdq                         ; i = 0
    xchg   eax, ebx             ; c = 0
    inc    edx                  ; i = 1
    lodsb                       ; al = t = *LFSR
iota_l0:    
    test   al, 1                ; t & 1
    je     iota_l1    
    lea    ecx, [edx-1]         ; ecx = (i - 1)
    cmp    cl, 32               ; skip if (ecx >= 32)
    jae    iota_l1    
    btc    ebx, ecx             ; c ^= 1UL << (i - 1)
iota_l1:    
    add    al, al               ; t << 1
    sbb    ah, ah               ; ah = (t < 0) ? 0x00 : 0xFF
    and    ah, 0x71             ; ah = (ah == 0xFF) ? 0x71 : 0x00  
    xor    al, ah  
    add    dl, dl               ; i += i
    jns    iota_l0              ; while (i != 128)
    stosb                       ; save t
    mov    [esp+28], ebx        ; return c
    popad            
    xor    [esi], eax           ; st[0] ^= rc(&lfsr);      
    pop    eax
    dec    eax
    jnz    k800_l1              ; rnds<22    
    popad                       ; release bc
    popad                       ; restore registers 
    ret
