.globl __start


__start:
    li a0, 5
    ecall
    jal ra, Fib
    addi s1, a0, 0
    jal zero, output

Fib:
    addi sp, sp, -24 # store 3 32bits-register
    sw ra, 0(sp)
    sw a0, 8(sp)
    addi t0, a0, -2
    bge t0, zero, Fibn # if n - 2 >= 0
    addi t0, t0, 2
    beq t0, zero, Fib0 # if n == 0
    addi t0, t0, -1
    beq t0, zero, Fib1 # if n - 1 == 0
Fib0:
    addi a0, zero, 0
    addi sp, sp, 24
    jalr zero, 0(ra)

Fib1:
    addi a0, zero, 1
    addi sp, sp, 24
    jalr zero, 0(ra)

Fibn:
    addi a0, a0, -1
    jal ra, Fib
    sw a0, 16(sp) # sp+16: result of Fib(n-1)
    lw a0, 8(sp) # sp+8: n
    addi a0, a0, -2
    jal ra, Fib
    lw t0, 16(sp) # t0: result of Fib(n-1)
    add a0, a0, t0 # a0 = a0(result of Fib(n-2)) + t0
    lw ra, 0(sp)
    addi sp, sp, 24
    jalr zero, 0(ra)

output:
    li a0, 1
    mv a1, s1
    ecall
exit:
    li a0, 10
    ecall




