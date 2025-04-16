# copy_shadow
shadow file take over

```shell
nasm -f elf32 copy_shadow.asm -o copy_shadow.o
ld -m elf_i386 -o copy_shadow copy_shadow.o
./copy_shadow
```
