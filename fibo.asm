SYS_EXIT  equ 1
SYS_WRITE equ 4
STDIN     equ 0
STDOUT    equ 1
SYS_READ  equ 3

section .data
   inpline db 'Enter number of Fibonacci terms you want! (48=>n>=1)', 0xa
   inplen equ $ - inpline
   nl db 0xa
   nlen equ $ - nl
   radix dd 10

section .bss
   ns resb 2
   n resb 1
   num1 resd 1
   num2 resd 1
   num3 resd 1
   temp resd 1
   arr resb 13 ;array for storing individual digits in the number. Idk y it needs 13 to store at max 10 digits. Wrong values if u try 10 instead of 13
   lv resb 1 ;looping variable

section .text
   global _start

print_nl: ;Function for printing new line
   push edx
   push ecx
   push ebx
   push eax
   mov edx, nlen
   mov ecx, nl
   mov ebx, STDOUT
   mov eax, SYS_WRITE
   int 0x80
   pop eax
   pop ebx
   pop ecx
   pop edx
   ret

_start:
   mov dword [num1], '0'
   mov dword [num2], '1'

   mov edx, inplen
   mov ecx, inpline
   mov ebx, STDOUT
   mov eax, SYS_WRITE
   int 0x80

   mov eax, SYS_READ
   mov ebx, STDIN
   mov ecx, ns
   mov edx, 2
   int 0x80

   cmp byte [ns+1], 0xa ;second char is newline character indicating only one digit number
   je sd ;single digit

   mov edi, ns
   xor eax, eax
   mov al, byte [ns]
   sub eax, '0'
   mov ebx, 10
   mul bx
   mov byte [n], al ;getting first digit

   sub byte [ns+1], '0'
   mov al, byte [ns+1]
   add byte [n], al ;getting second digit
   jmp atl1

sd:

   sub byte [ns], '0'
   mov al, byte [ns]
   mov byte [n], al

atl1: ;at least 1

   mov edx, 4
   mov ecx, num1
   mov ebx, STDOUT
   mov eax, SYS_WRITE
   int 0x80

   call print_nl

   cmp byte [n], 1
   jg atl2
   jmp _exit

atl2: ;at least 2

   mov edx, 4
   mov ecx, num2
   mov ebx, STDOUT
   mov eax, SYS_WRITE
   int 0x80

   call print_nl

   cmp byte [n], 2
   jg atl3
   jmp _exit

atl3: ;at least 3 
   sub dword [n],2 ;2 have already been printed
   sub dword [num1], '0' ;ASCII to number
   sub dword [num2], '0' ;ASCII to number
   mov ecx, [n]

   l1:

   push ecx
   mov eax, dword [num2]
   mov dword [num3], eax

   mov eax, dword [num1]
   add dword [num3], eax

   mov byte [lv], 0
   mov ecx, dword [num3]

   mov edi, arr
   
   l2: ;loop for storing digits in array form
   mov eax, ecx
   mov edx,0
   mov ebx, dword [radix] ;radix = 10
   div ebx ;num3/10

   mov ecx, eax ;storing quotient in ecx for cheking in loop condition at the end
   mov [edi], edx ;storing remainder of division in array
   inc byte [lv]
   inc edi
   cmp ecx, 0
   jnz l2

   mov ecx, [lv] ;No. of times loop l3 should execute
   dec edi

   l3: ;for printing individual digits
   push ecx
   mov edx, 1
   mov ecx, edi
   add byte [ecx], '0'
   mov ebx, STDOUT
   mov eax, SYS_WRITE
   int 0x80
   dec edi
   pop ecx
   loop l3

   call print_nl

   mov eax, dword [num2]
   mov dword [num1], eax

   mov eax, dword [num3]
   mov dword [num2], eax

   pop ecx

   dec ecx
   cmp ecx, 0
   jnz l1

_exit:
   mov eax, SYS_EXIT
   int 0x80