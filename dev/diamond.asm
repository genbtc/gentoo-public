; # shamelessly lifted from SpawnsCarpeting - thanks fam

%define SYSCALL_WRITE 1
%define SYSCALL_EXIT 60
%define STDOUT 1

section .text
global _start
_start:


_read_argv:
; args: argv[n]
; locals: ptr digit counter accumulator

; prolog
    push rbp
    mov rbp, rsp

; setup space for locals
    sub rsp, 16

; copy argv pointer to ptr
    mov r8, [rsp + 16 - 2]
    mov [rsp + 1], r8

; init the rest of the local vars
    mov [rsp + 2], 0
    mov [rsp + 3], 0
    mov [rsp + 4], 0

; epilog
    pop rbp
    ret
