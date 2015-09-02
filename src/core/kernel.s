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
    .skip 4
stack_top:

##################
    .section .text
##################

.macro vga_print char
    movb $0x0F, (0xB8001+\@*2)
    movb \char, (0xB8000+\@*2)
.endm

.global _start
.type _start, @function
_start:
    # set up stack
    movl $stack_top, %esp
    # set up GDT
    cli
    call _build_gdt
    sti
    vga_print $'Z
    vga_print $'e
    vga_print $'t
    vga_print $'O
    vga_print $'S

.global _hang
.type _hang, @function
_hang:
    cli
    hlt
    jmp _hang

