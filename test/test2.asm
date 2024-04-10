format binary use32

mov ebx, 420
; r -> r test
mov al, bl
mov ax, bx
mov eax, ebx

; r -> m test
mov byte[t0], al
mov word [t0], ax
mov dword [t0], eax

; m -> r test
mov bl, [t0]
mov bx, [t0]
mov ebx, [t0]

; imm -> r test
mov bl, 420
mov bx, 420
mov ebx, 420

; imm -> m test
mov byte [t0], 420
mov word [t0], 420
mov dword [t0], 420

; r <-> sr <-> m test
mov cs, bx
mov ax, cs
mov [t0], cs
mov cs, [t0]

; r <-> cr <-> m test
mov eax, cr0
mov cr0, ebx
mov dword [t0], cr0
mov cr0, [t0]

; r <-> r
xchg al, bl
xchg ax, bx
xhcg eax, ebx

; r <-> m
xchg al, [t0]
xchg ax, [t0]
xchg eax, [t0]

t0 rd 1
