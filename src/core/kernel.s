# Zettai OS
# - by Sakura Kurosawa [sakuroneko]
#
# core/kernel.s

#######################
    .section .multiboot
#######################

.set ALIGN,    1<<0
.set MEMINFO,  1<<1
.set FLAGS,    ALIGN | MEMINFO
.set MAGIC,    0x1BADB002
.set CHECKSUM, -(MAGIC + FLAGS)

.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

##################################
    .section .stack, "aw", @nobits
##################################

stack_bottom:
.skip 1024
stack_top:

##################
    .section .text
##################

.global _start
.type _start, @function
_start:
    movl $stack_top, %esp
    movw $0x0F48, (0xB8000)
    movw $0x0F65, (0xB8002)
    movw $0x0F6C, (0xB8004)
    movw $0x0F6C, (0xB8006)
    movw $0x0F6F, (0xB8008)
    movw $0x0F2C, (0xB800A)
    movw $0x0F20, (0xB800C)
    movw $0x0F57, (0xB800E)
    movw $0x0F6F, (0xB8010)
    movw $0x0F72, (0xB8012)
    movw $0x0F6C, (0xB8014)
    movw $0x0F64, (0xB8016)
    movw $0x0F21, (0xB8018)

.global _hang
.type _hang, @function
_hang:
    cli
    hlt
    jmp _hang

