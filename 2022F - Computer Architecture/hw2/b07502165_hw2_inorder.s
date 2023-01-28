.globl __start

.rodata
    space_string: .string " "

.text
__start:
    li a0, 5
    ecall
    addi s0, a0, 0 # s0 = n
    li a0, 9
    slli a1, s0, 2 # a1 = 4 * n
    ecall # allocate 4*n bytes at address a0
    addi s1, a0, 0 # Heap start from s1
    addi a1, zero, 0 # getInput from 0 ... n-1
    jal ra, GetInput

    # == debug ==
    ; li a0, 1
    ; li a1, 9999999
    ; ecall
    # == debug ==

    addi a2, zero, 0 # a2 = 0
    jal ra, Inorder
    jal zero, exit

GetInput:# use a1 as index
    beq a1, s0, InputEnd
    li a0, 5
    ecall
    slli t0, a1, 2
    add t0, t0, s1
    sw a0, 0(t0) # store at s1 + a1*4
    addi a1, a1, 1
    jal zero, GetInput

InputEnd:
    jalr zero, 0(ra)

# ================================== #

Inorder: # s0=n, s1=heap_address. use a2 as parameter k
        #                      (a0, a1 reserved for syscall)
    addi sp, sp, -16
    sw ra, 0(sp)
    sw a2, 8(sp)
    bge a2, s0, InorderEnd # return if k >= n

    slli a2, a2, 1
    addi a2, a2, 1
    # a2 = 2*k+1
    jal ra, Inorder

    # =============== #
    lw a2, 8(sp) # a2=k
    slli t0, a2, 2
    add t0, t0, s1
    lw a1, 0(t0)
    li a0, 1
    ecall
    li a0, 4
    la a1, space_string # print space
    ecall

    # =============== #
    slli a2, a2, 1
    addi a2, a2, 2 # a2= 2k+2
    jal ra, Inorder

InorderEnd:
    lw ra, 0(sp)
    addi sp, sp, 16
    jalr zero, 0(ra)



exit:
    li a0, 10
    ecall




