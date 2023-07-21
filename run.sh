#!/bin/bash
nasm -f elf32 fibo.asm
ld -m elf_i386 -s -o fibo fibo.o
echo "File created successfully. Now you can run it by using './fibo'"
echo "Delete Object file?"
read ch
if [ $ch == "y" -o $ch == "Y" ]; then
    rm fibo.o
    echo "Deleted"
fi