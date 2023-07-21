SYS_EXIT  equ 1
SYS_WRITE equ 4
STDIN     equ 0
STDOUT    equ 1
SYS_READ  equ 3

section .data
   inpline db 'Enter number of Fibonacci terms you want! (n>=1)', 0xa
   inplen equ $ - inpline
   nl db 0xa
   nlen equ $ - nl
   radix dd 10

section .bss
   n resb 1
   num1 resd 1
   num2 resd 1
   num3 resd 1
   temp resd 1
   arr resb 10 ;array for storing individual digits in the number
   lv resb 1 ;looping variable
   temp2 resb 1

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
   mov dword [num1], 0
   mov dword [num2], 1

   mov edx, inplen
   mov ecx, inpline
   mov ebx, STDOUT
   mov eax, SYS_WRITE
   int 0x80

   mov eax, SYS_READ
   mov ebx, STDIN
   mov ecx, n
   mov edx, 1
   int 0x80

   sub dword [n],'0'

   mov eax, dword [num1]
   mov dword [temp], eax
   add dword [temp], '0'

   mov edx, 4
   mov ecx, temp
   mov ebx, STDOUT
   mov eax, SYS_WRITE
   int 0x80

   call print_nl

   cmp dword [n], 1
   jg atl2
   jmp _exit

atl2: ;at least 2
   mov eax, dword [num2]
   mov dword [temp], eax
   add dword [temp], '0'

   mov edx, 4
   mov ecx, temp
   mov ebx, STDOUT
   mov eax, SYS_WRITE
   int 0x80

   call print_nl

   cmp dword [n], 2
   jg atl3
   jmp _exit

atl3: ;at least 3 
   sub dword [n],2
   mov ecx, [n]

   l1:

   push ecx
   mov eax, dword [num2]
   mov dword [num3], eax

   mov eax, dword [num1]
   add dword [num3], eax

   ;call print_nl

   mov byte [lv], 0
   mov ecx, dword [num3]

   ;call print_nl
   mov edi, arr
   
   l2: ;loop for storing digits in array form
   mov eax, ecx
   mov edx,0
   ;call print_nl
   mov ebx, dword [radix] ;radix = 10
   div ebx ;num3/10

   mov ecx, eax ;storing quotient in ecx for cheking in loop condition at the end
   mov [edi], edx ;storing remainder of division in array
   add byte [lv], 1
   inc edi
   cmp ecx, 0
   jnz l2

   mov ecx, dword [lv] ;No. of times loop l3 should execute
   dec edi

   l3: ;for printing individual digits
   push ecx
   mov edx, 4
   mov ebx, [edi]
   mov dword [temp], ebx
   add dword [temp], '0'
   mov ecx, temp
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