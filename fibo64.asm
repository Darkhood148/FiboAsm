SYS_EXIT  equ 1
SYS_WRITE equ 4
STDIN     equ 0
STDOUT    equ 1
SYS_READ  equ 3

section .data
   inpline db 'Enter number of Fibonacci terms you want! (94=>n>=1)', 0xa
   inplen equ $ - inpline
   errline db 'Range of n is [1, 94]', 0xa
   errlen equ $ - errline
   nl db 0xa
   nlen equ $ - nl
   radix dq 10

section .bss
   ns resb 2
   n resb 1
   num1 resq 1
   num2 resq 1
   num3 resq 1
   temp resq 1
   arr resb 27 ;array for storing individual digits in the number. Idk y it needs 27 to store at max 20 digits. Wrong values if u try 20 instead of 27
   lv resb 1 ;looping variable

section .text
   global _start

print_nl: ;Function for printing new line
   push rdx
   push rcx
   push rbx
   push rax
   mov rdx, nlen
   mov rcx, nl
   mov rbx, STDOUT
   mov rax, SYS_WRITE
   int 0x80
   pop rax
   pop rbx
   pop rcx
   pop rdx
   ret

_start:
   mov qword [num1], '0'
   mov qword [num2], '1'

   mov rdx, inplen
   mov rcx, inpline
   mov rbx, STDOUT
   mov rax, SYS_WRITE
   int 0x80

   mov rax, SYS_READ
   mov rbx, STDIN
   mov rcx, ns
   mov rdx, 2
   int 0x80

   cmp byte [ns+1], 0xa ;second char is newline character indicating only one digit number
   je sd ;single digit

   mov edi, ns
   xor rax, rax
   mov al, byte [ns]
   sub rax, '0'
   mov rbx, 10
   mul bx
   mov byte [n], al ;getting first digit

   sub byte [ns+1], '0'
   mov al, byte [ns+1]
   add byte [n], al ;getting second digit
   jmp check

sd:

   sub byte [ns], '0'
   mov al, byte [ns]
   mov byte [n], al

check:
   cmp byte [n],1
   jl errocc
   cmp byte [n],94
   jg errocc

atl1: ;at least 1

   mov rdx, 4
   mov rcx, num1
   mov rbx, STDOUT
   mov rax, SYS_WRITE
   int 0x80

   call print_nl

   cmp byte [n], 1
   jg atl2
   jmp _exit

atl2: ;at least 2

   mov rdx, 4
   mov rcx, num2
   mov rbx, STDOUT
   mov rax, SYS_WRITE
   int 0x80

   call print_nl

   cmp byte [n], 2
   jg atl3
   jmp _exit

atl3: ;at least 3 
   sub byte [n],2 ;2 have already been printed
   sub qword [num1], '0' ;ASCII to number
   sub qword [num2], '0' ;ASCII to number
   mov rcx, [n]

   l1:

   push rcx
   mov rax, qword [num2]
   mov qword [num3], rax

   mov rax, qword [num1]
   add qword [num3], rax

   mov byte [lv], 0
   mov rcx, qword [num3]

   mov edi, arr
   
   l2: ;loop for storing digits in array form
   mov rax, rcx
   mov rdx,0
   mov rbx, qword [radix] ;radix = 10
   div rbx ;num3/10

   mov rcx, rax ;storing quotient in rcx for cheking in loop condition at the end
   mov [edi], rdx ;storing remainder of division in array
   inc byte [lv]
   inc edi
   cmp rcx, 0
   jnz l2

   mov ecx, [lv] ;No. of times loop l3 should execute
   dec edi

   l3: ;for printing individual digits
   push rcx
   mov rdx, 1
   mov ecx, edi
   add byte [ecx], '0'
   mov rbx, STDOUT
   mov rax, SYS_WRITE
   int 0x80
   dec edi
   pop rcx
   loop l3

   call print_nl

   mov rax, qword [num2]
   mov qword [num1], rax

   mov rax, qword [num3]
   mov qword [num2], rax

   pop rcx

   dec rcx
   cmp rcx, 0
   jnz l1
   jmp _exit

errocc:

   mov rdx, errlen
   mov rcx, errline
   mov rbx, STDOUT
   mov rax, SYS_WRITE
   int 0x80

_exit:
   mov rax, SYS_EXIT
   int 0x80