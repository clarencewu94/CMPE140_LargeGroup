main:
    # factorial
    addi $a0, $zero, 0x1
    addi $a2, $zero, 0x4
    # load n from gpi0
    lw $a2 0x10($zero)
    sw $a2, 0x0($zero)
    lw $a1, 0x0($zero)
    sw $a0, 0x4($zero)
    lw $a1, 0x4($zero)
    # add loop until done here
    # addi $v0, $zero, 0x1
    # addi $t0, $zero, 0x2
fact_loop:
    lw $v1, 0x8($zero)
    beq $v1, $zero, fact_loop
fact_end:
    lw $a1, 0xc($zero)
    # output result on gpo0 and in DM
    sw $a1, 0x18($zero)
    sw $a1, 0x24($zero)

    addi $a2, $zero, 13
    sw $a2, 0x0($zero)
    sw $a0, 0x4($zero)
fact_loop_error:
    lw $v1, 0x8($zero)
    beq $v1, $zero, fact_loop_error
fact_end_error:
    lw $a1, 0xc($zero)

    addi $a2, $zero, 0
    sw $a2, 0x0($zero)
    sw $a0, 0x4($zero)
fact_loop_zero:
    lw $v1, 0x8($zero)
    beq $v1, $zero, fact_loop_zero
fact_end_zero:
    lw $a1, 0xc($zero)


    # gpio
    lw $a1, 0x10($zero)
    lw $a1, 0x14($zero)
    sw $a0, 0x18($zero)
    lw $a1, 0x18($zero)
    sw $a0, 0x1c($zero)
    lw $a1, 0x1c($zero)

    # Data Memory
    sw $a0, 0x20($zero)
    lw $a1, 0x20($zero)
end: