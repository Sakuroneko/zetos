# Zettai OS
# - by Sakura Kurosawa [sakuroneko]
#
# core/gdt.s

###################################
    .section .data, "aw", @progbits
###################################

gdt_entry_info:
    .word 23
    .long gdt_entries

gdt_entries:
    # Null entry
    .word 0 # Limit low
    .word 0 # Base low
    .byte 0 # Base middle
    .byte 0 # Access
    .byte 0 # Granularity
    .byte 0 # Base high
    # Entry 1
    .word 65535
    .word 0
    .byte 0
    .byte 0xCF
    .byte 207
    .byte 0
    # Entry 2
    .word 65535
    .word 0
    .byte 0
    .byte 0xCF
    .byte 207
    .byte 0

##################
    .section .text
##################

.global _build_gdt
.type _build_gdt, @function
_build_gdt:
    ljmp $0x08, $flush
flush:
    lgdt (gdt_entry_info)
    movw $0x10, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs
    movw %ax, %ss
    ret
