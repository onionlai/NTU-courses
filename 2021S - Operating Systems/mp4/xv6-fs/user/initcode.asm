
user/initcode.o:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <start>:
#include "syscall.h"

# exec(init, argv)
.globl start
start:
        la a0, init
   0:	00000517          	auipc	a0,0x0
   4:	00050513          	mv	a0,a0

0000000000000008 <.L0 >:
        la a1, argv
   8:	00000597          	auipc	a1,0x0
   c:	00058593          	mv	a1,a1

0000000000000010 <.L0 >:
        li a7, SYS_exec
  10:	00700893          	li	a7,7

0000000000000014 <.L0 >:
        ecall
  14:	00000073          	ecall

0000000000000018 <exit>:

# for(;;) exit();
exit:
        li a7, SYS_exit
  18:	00200893          	li	a7,2

000000000000001c <.L0 >:
        ecall
  1c:	00000073          	ecall

0000000000000020 <.L0 >:
        jal exit
  20:	ff9ff0ef          	jal	ra,18 <exit>

0000000000000024 <init>:
  24:	696e692f          	0x696e692f
  28:	0074                	addi	a3,sp,12
	...

000000000000002b <argv>:
	...

0000000000000033 <.L0 >:
	...
