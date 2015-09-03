# Zettai OS
# - by Sakura Kurosawa [sakuroneko]
#
# core/gdt.s

############
    # macros
############

.macro gdt_entry access
    .word 0xFFFF    # Limit low
    .word 0         # Base low
    .byte 0         # Base middle
    .byte \access   # Access
    .byte 0xCF      # Granularity
    .byte 0         # Base high
.endm

###################################
    .section .data, "aw", @progbits
###################################

gdt_entry_info:
    .word 0x27 # = 8*5-1
    .long gdt_entries

gdt_entries:
    # Null entry
    .word 0
    .word 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    # Code segment
    gdt_entry 0x9A
    # Data segment
    gdt_entry 0x92
    # User mode code segment
    gdt_entry 0xFA
    # User mode data segment
    gdt_entry 0xF2

##################
    .section .text
##################

.global _build_gdt
.type _build_gdt, @function
_build_gdt:
    lgdt (gdt_entry_info)
    movw $0x10, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs
    movw %ax, %ss
    ljmp $0x08, $flush
flush:
    ret
