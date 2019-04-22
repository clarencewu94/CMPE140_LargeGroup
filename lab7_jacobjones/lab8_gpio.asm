main:
    # factorial
    addi $a0, $zero, 0x1
    sw $a0, 0x0($zero)
    sw $a0, 0x4($zero)
    lw $a1, 0x8($zero)
    lw $a1, 0xc($zero)

    # gpio
    sw $a0, 0x10($zero)
    sw $a0, 0x14($zero)
    lw $a1, 0x18($zero)
    lw $a1, 0x1c($zero)

    # Data Memory
    sw $a0, 0x20($zero)
    lw $a1, 0x2c($zero)
end: