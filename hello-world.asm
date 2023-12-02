; going to write this as if I'm writing for amd64
; register recap
; https://stackoverflow.com/questions/20637569/assembly-registers-in-64-bit-architecture

; eax recap
; 32 bit register: eax, on 64 bit, this is the low 32 bits of rax
; 16 bit register: ax, on 64 bit, this is the low 16 bits of rax
; 8 bit register: ah, al - ah is the high byte of ax, al is the low byte
; modern times: rax, which is the 64 bit full register

; eax: accumulator
; ebx: base
; ecx: counter
; edx: data
; esi: source index
; edi: destination index
; esp: stack pointer
; ebp: base pointer

; data section
section .data
    ; msg: label
    ; db: Define Byte
    ; Then we define the string we want to print
    ; Commas are concat when used with db
    ; 0xa: newline
    msg db "Hello World", 0x0a
    ; len: label
    ; equ: symbol equ expr1 expr2 expr3 expr4 expr5
    ; we use symbol equ expr1
    ; note that current position and msg are addrs
    ; $-msg: subtracting the address of msg from the current position
    len equ $-msg

section.text
    ; global: make label visible to linker
    ; start: label
    global start

; start: entrypoint
start:
    ; goal is to basically call:
    ; sys_write(fd, msg, len)
    ; sys_exit()
    ; where fd is stdout, msg is hello world, len is len(msg)
    mov eax, 4 ; sys_write syscall number
    mov ebx, 1 ; stdout file descriptor
    mov ecx, msg ; msg addr
    mov edx, len ; len of msg
    int 0x80 ; interrupt with 0x80, which is the kernel handler

    ; now we need to exit
    mov eax, 1 ; sys_exit syscall number
    mov ebx, 0 ; exit code
    int 0x80 ; interrupt with 0x80, which is the kernel handler

; on linux:
; yasm -f elf64 -o hello-world.o hello-world.asm
; mold -o hello hello-world.o -m elf_x86_64
; ./hello
; on macos (x86_64):
; yasm -f macho32 -o hello-world.o hello-world.asm
; we have to use SOLD here!
; sold -o hello hello-world.o -m macho32
; ./hello

; questions: what's a relocation?
; why can't macho perform 32 bit relocations in 64 bit mode?
