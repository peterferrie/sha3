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
; Keccak-p800 in x86 assembly
;
; size: 250 bytes
;
; global calls use cdecl convention
;
; -----------------------------------------------
    bits   32
k800x:
_k800x:
    pushad
    mov    esi, [esp+32+4]     ; esi = st
    call   ld_var
    ; rho pi
    dd     0110b070ah, 010050312h, 004181508h 
    dd     00d13170fh, 00e14020ch, 001060916h
    ; modulo 5    
    dd     003020100h, 002010004h, 000000403h
ld_var:
    pop    eax
    pushad                       ; create local space
    mov    edi, esp              ; edi = bc
    stosd
    push   22
    pop    ecx
k_l0:    
    push   ecx
    mov    cl, 5
    pushad
k_l1:
    ; Theta
    lodsd                    ; eax = st[i]  
    xor    eax, [esi+ 5*4-4] ; 
    xor    eax, [esi+10*4-4]
    xor    eax, [esi+15*4-4]
    xor    eax, [esi+20*4-4]
    stosd
    loop   k_l1
    
    popad 
    xor    eax, eax
k_l2:
    movzx  edx, byte[ebx+eax+1]     ; edx = m[(i + 1)]
    movzx  ebp, byte[ebx+eax+4]     ; ebp = m[(i + 4)]
    mov    edx, [esi+edx*4]     ; edx = bc[(i+1)%5]
    mov    ebp, [esi+ebp*4]     ; ebp = bc[(i+4)%5]
    rol    edx, 1
    xor    ebp, edx
k_l3:
    lea    ebp, [eax+edx]    
    xor    [edi+eax*4], ebp
    inc    edx
    cmp    dl, cl
    jnz    k_l3
    
    loop   k_l2
    ; *************************************
    ; Rho Pi
    ; *************************************
    mov    ebp, [esi+1*4]      ; t = st[1];
rho_l0:
    lea    ecx, [ecx+eax+1]    ; r += i + 1;
    rol    ebp, cl             ; t = ROTL32(t, r); 
    movzx  edx, byte[ebx+eax]  ; edx = p[i];
    xchg   [esi+edx*4], ebp    ; XCHG(st[p[i]], t);
    mov    [edi+0*4], ebp      ; bc[0] = t;
    inc    eax                 ; i++
    cmp    al, 24              ; i<24
    jnz    rho_l0
    ; *************************************
    ; Chi
    ; *************************************
    xor    ecx, ecx          ; j = 0 
chi_l0:    
    pushad
    add    esi, edx          ; esi = &st[j];
    mov    cl, 5
    rep    movsd
    popad
chi_l1:
    movzx  ebp, byte[ebx+eax+1]
    movzx  edx, byte[ebx+eax+2]
    mov    ebp, [edi+ebp*4]  ; t = ~bc[m[(i + 1)]] 
    not    ebp            
    and    ebp, [edi+edx*4]
    lea    edx, [eax+ecx]    ; edx = j + i    
    xor    [esi+edx*4], ebp  ; st[j + i] ^= t;  
    inc    eax               ; i++
    cmp    al, 5             ; i<5
    jnz    chi_l1
    
    add    cl, 5             ; j += 5;
    cmp    cl, 25            ; j<25
    jnz    chi_l0
    
    ; Iota
    lea    eax, [esp+5*6]    ; eax = lfsr
    ;call   rc               ; st[0] ^= rc(&lfsr);
    
    pushad
    xor    esi, esi            ; esi = 0
    xchg   eax, esi            ; esi = &lfsr, eax = 0
    mov    edi, esi            ; edi = &lfsr
    cdq                        ; i = 0
    xchg   eax, ebx            ; c = 0
    inc    edx                 ; i = 1
    lodsb                      ; al = t = *LFSR
rc_l0:    
    test   al, 1               ; t & 1
    je     rc_l1    
    lea    ecx, [edx-1]        ; ecx = (i - 1)
    cmp    cl, 32              ; skip if (ecx >= 32)
    jae    rc_l1    
    btc    ebx, ecx            ; c ^= 1UL << (i - 1)
rc_l1:    
    add    al, al              ; t << 1
    sbb    ah, ah              ; ah = (t < 0) ? 0x00 : 0xFF
    and    ah, 0x71            ; ah = (ah == 0xFF) ? 0x71 : 0x00  
    xor    al, ah  
    add    dl, dl              ; i += i
    jns    rc_l0               ; while (i != 128)
    stosb                      ; save t
    mov    [esp+28], ebx       ; return c & 255
    popad    
    
    xor    [esi], eax
    
    pop    ecx
    dec    ecx
    jnz    k_l0
    
    popad
    ret
