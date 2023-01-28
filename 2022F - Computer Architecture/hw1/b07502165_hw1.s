.globl __start

.rodata
    division_by_zero: .string "division by zero"
    JumpTable: .word L0, L1, L2, L3, L4, L5, L6

.text
__start:
    # Read first operand s0 = A
    li a0, 5 # load immediately.
             # store 5 in a0
    ecall    # system call.
             # 5 in a0 means read std input and store at a0
    mv s0, a0
    # Read operation s1 = op
    li a0, 5
    ecall
    mv s1, a0
    # Read second operand s2 = B
    li a0, 5
    ecall
    mv s2, a0

# ===================================== #

    la t3, JumpTable # t3 = jumpTable base addr(mem)
    slli t0, s1, 2 # t0 = s1 * 4
    add t1, t0, t3 # t1 = jumpTable[s1] addr = t3+s1*4
    lw t2, 0(t1) # t2 = mem{t1}
    jr t2 # = jalr x0, t2, 0. jump to addr t2

# ===================================== #

L0: # A+B
    add s3, s0, s2
    jal zero, output
L1: # A-B
    sub s3, s0, s2
    jal zero, output
L2: # A*B
    mul s3, s0, s2
    jal zero, output
L3: # A/B
    beq s2, zero, division_by_zero_except
    div s3, s0, s2
    jal zero, output
L4: # min(A, B)
    add s3 s0 zero
    blt s0, s2, output
    add s3 s2 zero
    jal zero, output

L5: # A^B
    jal ra, Pow
    add s3, a0, zero
    jal zero, output

Pow:  # Pow(B) = {A * Pow(B-1)} if B-1 >= 0
      #       = {1}            otherwise
      # treat A as constant. no need to store param B in memory (only use it for passing the next param, don't mind overwritten)
    addi sp, sp, -8
    sw ra, 0(sp)
    addi t0, s2, -1
    bge t0, zero, Pow2 # check B - 1 >= 0

    addi a0, zero, 1 # use a0 as return value
    addi sp, sp, 8
    jalr zero, 0(ra)
Pow2:
    addi s2, s2, -1
    jal ra, Pow
    # now a0 = pow(A, B-1)
    # ra = prev return addr
    lw ra, 0(sp)
    mul a0, a0, s0
    addi sp, sp, 8
    jalr zero, 0(ra)


L6: # A!
    add a0, s0, zero # param a0 = A
    jal ra, Fact
    add s3, a0, zero
    jal zero, output

Fact: # Fact(A) = {A * Fact(A-1)} if A-1 >= 0
      #         = {1}             otherwise
      # should store param A in memory, which would be reused for return value
    addi sp, sp, -16
    sw ra, 8(sp) # store ra in memory sp+8
    sw a0, 0(sp) # store a0(A) in memory sp

    # check if (A-1 >= 0)
    addi t0, a0, -1 # t0 = A-1
    # if yes, branch to Fact2, never back
    bge t0, zero, Fact2
    # if not
    addi a0, zero, 1 # a0 = 1, used it as return value
    addi sp, sp, 16 # pop stack
    jalr zero, 0(ra) # return
Fact2:
    addi a0, a0, -1 # A = A - 1
    jal ra, Fact # jump to fact, store current ra
    # now a0 = fact(A-1)
    # 0(sp) = A
    # 8(sp) = prev return address
    addi t1, a0, 0
    lw a0, 0(sp) # restore a0(A)
    lw ra, 8(sp) # restore ra
    addi sp, sp, 16 # pop stack
    mul a0, a0, t1
    jalr zero, 0(ra)

# ===================================== #

output:
    # Output the result
    li a0, 1
    mv a1, s3
    ecall

exit:
    # Exit program(necessary)
    li a0, 10
    ecall

division_by_zero_except:
    li a0, 4
    la a1, division_by_zero # why: a1
    ecall
    jal zero, exit
