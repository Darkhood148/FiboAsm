#!/bin/bash
nasm -f elf64 fibo64.asm
ld -o fibo64 fibo64.o
echo "File created successfully. Now you can run it by using './fibo64'"
echo "Delete Object file?"
read ch
if [ $ch == "y" -o $ch == "Y" ]; then
    rm fibo64.o
    echo "Deleted"
fi