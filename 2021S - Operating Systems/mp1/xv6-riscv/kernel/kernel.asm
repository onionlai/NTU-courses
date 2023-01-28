
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	85013103          	ld	sp,-1968(sp) # 80008850 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	078000ef          	jal	ra,8000008e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	95b2                	add	a1,a1,a2
    80000046:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00269713          	slli	a4,a3,0x2
    8000004c:	9736                	add	a4,a4,a3
    8000004e:	00371693          	slli	a3,a4,0x3
    80000052:	00009717          	auipc	a4,0x9
    80000056:	fde70713          	addi	a4,a4,-34 # 80009030 <timer_scratch>
    8000005a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005e:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000060:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000064:	00006797          	auipc	a5,0x6
    80000068:	b1c78793          	addi	a5,a5,-1252 # 80005b80 <timervec>
    8000006c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000070:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000074:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000078:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000080:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000084:	30479073          	csrw	mie,a5
}
    80000088:	6422                	ld	s0,8(sp)
    8000008a:	0141                	addi	sp,sp,16
    8000008c:	8082                	ret

000000008000008e <start>:
{
    8000008e:	1141                	addi	sp,sp,-16
    80000090:	e406                	sd	ra,8(sp)
    80000092:	e022                	sd	s0,0(sp)
    80000094:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000096:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000009a:	7779                	lui	a4,0xffffe
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd87ff>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	e0278793          	addi	a5,a5,-510 # 80000eb0 <main>
    800000b6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000ba:	4781                	li	a5,0
    800000bc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000c0:	67c1                	lui	a5,0x10
    800000c2:	17fd                	addi	a5,a5,-1
    800000c4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000cc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000d0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d4:	10479073          	csrw	sie,a5
  timerinit();
    800000d8:	00000097          	auipc	ra,0x0
    800000dc:	f44080e7          	jalr	-188(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000e0:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000e4:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000e6:	823e                	mv	tp,a5
  asm volatile("mret");
    800000e8:	30200073          	mret
}
    800000ec:	60a2                	ld	ra,8(sp)
    800000ee:	6402                	ld	s0,0(sp)
    800000f0:	0141                	addi	sp,sp,16
    800000f2:	8082                	ret

00000000800000f4 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000f4:	715d                	addi	sp,sp,-80
    800000f6:	e486                	sd	ra,72(sp)
    800000f8:	e0a2                	sd	s0,64(sp)
    800000fa:	fc26                	sd	s1,56(sp)
    800000fc:	f84a                	sd	s2,48(sp)
    800000fe:	f44e                	sd	s3,40(sp)
    80000100:	f052                	sd	s4,32(sp)
    80000102:	ec56                	sd	s5,24(sp)
    80000104:	0880                	addi	s0,sp,80
    80000106:	8a2a                	mv	s4,a0
    80000108:	84ae                	mv	s1,a1
    8000010a:	89b2                	mv	s3,a2
  int i;

  acquire(&cons.lock);
    8000010c:	00011517          	auipc	a0,0x11
    80000110:	06450513          	addi	a0,a0,100 # 80011170 <cons>
    80000114:	00001097          	auipc	ra,0x1
    80000118:	af2080e7          	jalr	-1294(ra) # 80000c06 <acquire>
  for(i = 0; i < n; i++){
    8000011c:	05305b63          	blez	s3,80000172 <consolewrite+0x7e>
    80000120:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000122:	5afd                	li	s5,-1
    80000124:	4685                	li	a3,1
    80000126:	8626                	mv	a2,s1
    80000128:	85d2                	mv	a1,s4
    8000012a:	fbf40513          	addi	a0,s0,-65
    8000012e:	00002097          	auipc	ra,0x2
    80000132:	360080e7          	jalr	864(ra) # 8000248e <either_copyin>
    80000136:	01550c63          	beq	a0,s5,8000014e <consolewrite+0x5a>
      break;
    uartputc(c);
    8000013a:	fbf44503          	lbu	a0,-65(s0)
    8000013e:	00000097          	auipc	ra,0x0
    80000142:	796080e7          	jalr	1942(ra) # 800008d4 <uartputc>
  for(i = 0; i < n; i++){
    80000146:	2905                	addiw	s2,s2,1
    80000148:	0485                	addi	s1,s1,1
    8000014a:	fd299de3          	bne	s3,s2,80000124 <consolewrite+0x30>
  }
  release(&cons.lock);
    8000014e:	00011517          	auipc	a0,0x11
    80000152:	02250513          	addi	a0,a0,34 # 80011170 <cons>
    80000156:	00001097          	auipc	ra,0x1
    8000015a:	b64080e7          	jalr	-1180(ra) # 80000cba <release>

  return i;
}
    8000015e:	854a                	mv	a0,s2
    80000160:	60a6                	ld	ra,72(sp)
    80000162:	6406                	ld	s0,64(sp)
    80000164:	74e2                	ld	s1,56(sp)
    80000166:	7942                	ld	s2,48(sp)
    80000168:	79a2                	ld	s3,40(sp)
    8000016a:	7a02                	ld	s4,32(sp)
    8000016c:	6ae2                	ld	s5,24(sp)
    8000016e:	6161                	addi	sp,sp,80
    80000170:	8082                	ret
  for(i = 0; i < n; i++){
    80000172:	4901                	li	s2,0
    80000174:	bfe9                	j	8000014e <consolewrite+0x5a>

0000000080000176 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000176:	7159                	addi	sp,sp,-112
    80000178:	f486                	sd	ra,104(sp)
    8000017a:	f0a2                	sd	s0,96(sp)
    8000017c:	eca6                	sd	s1,88(sp)
    8000017e:	e8ca                	sd	s2,80(sp)
    80000180:	e4ce                	sd	s3,72(sp)
    80000182:	e0d2                	sd	s4,64(sp)
    80000184:	fc56                	sd	s5,56(sp)
    80000186:	f85a                	sd	s6,48(sp)
    80000188:	f45e                	sd	s7,40(sp)
    8000018a:	f062                	sd	s8,32(sp)
    8000018c:	ec66                	sd	s9,24(sp)
    8000018e:	e86a                	sd	s10,16(sp)
    80000190:	1880                	addi	s0,sp,112
    80000192:	8aaa                	mv	s5,a0
    80000194:	8a2e                	mv	s4,a1
    80000196:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000198:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000019c:	00011517          	auipc	a0,0x11
    800001a0:	fd450513          	addi	a0,a0,-44 # 80011170 <cons>
    800001a4:	00001097          	auipc	ra,0x1
    800001a8:	a62080e7          	jalr	-1438(ra) # 80000c06 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800001ac:	00011497          	auipc	s1,0x11
    800001b0:	fc448493          	addi	s1,s1,-60 # 80011170 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001b4:	00011917          	auipc	s2,0x11
    800001b8:	05490913          	addi	s2,s2,84 # 80011208 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800001bc:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001be:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001c0:	4ca9                	li	s9,10
  while(n > 0){
    800001c2:	07305863          	blez	s3,80000232 <consoleread+0xbc>
    while(cons.r == cons.w){
    800001c6:	0984a783          	lw	a5,152(s1)
    800001ca:	09c4a703          	lw	a4,156(s1)
    800001ce:	02f71463          	bne	a4,a5,800001f6 <consoleread+0x80>
      if(myproc()->killed){
    800001d2:	00002097          	auipc	ra,0x2
    800001d6:	81c080e7          	jalr	-2020(ra) # 800019ee <myproc>
    800001da:	591c                	lw	a5,48(a0)
    800001dc:	e7b5                	bnez	a5,80000248 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800001de:	85a6                	mv	a1,s1
    800001e0:	854a                	mv	a0,s2
    800001e2:	00002097          	auipc	ra,0x2
    800001e6:	ffc080e7          	jalr	-4(ra) # 800021de <sleep>
    while(cons.r == cons.w){
    800001ea:	0984a783          	lw	a5,152(s1)
    800001ee:	09c4a703          	lw	a4,156(s1)
    800001f2:	fef700e3          	beq	a4,a5,800001d2 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800001f6:	0017871b          	addiw	a4,a5,1
    800001fa:	08e4ac23          	sw	a4,152(s1)
    800001fe:	07f7f713          	andi	a4,a5,127
    80000202:	9726                	add	a4,a4,s1
    80000204:	01874703          	lbu	a4,24(a4)
    80000208:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    8000020c:	077d0563          	beq	s10,s7,80000276 <consoleread+0x100>
    cbuf = c;
    80000210:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000214:	4685                	li	a3,1
    80000216:	f9f40613          	addi	a2,s0,-97
    8000021a:	85d2                	mv	a1,s4
    8000021c:	8556                	mv	a0,s5
    8000021e:	00002097          	auipc	ra,0x2
    80000222:	21a080e7          	jalr	538(ra) # 80002438 <either_copyout>
    80000226:	01850663          	beq	a0,s8,80000232 <consoleread+0xbc>
    dst++;
    8000022a:	0a05                	addi	s4,s4,1
    --n;
    8000022c:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    8000022e:	f99d1ae3          	bne	s10,s9,800001c2 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000232:	00011517          	auipc	a0,0x11
    80000236:	f3e50513          	addi	a0,a0,-194 # 80011170 <cons>
    8000023a:	00001097          	auipc	ra,0x1
    8000023e:	a80080e7          	jalr	-1408(ra) # 80000cba <release>

  return target - n;
    80000242:	413b053b          	subw	a0,s6,s3
    80000246:	a811                	j	8000025a <consoleread+0xe4>
        release(&cons.lock);
    80000248:	00011517          	auipc	a0,0x11
    8000024c:	f2850513          	addi	a0,a0,-216 # 80011170 <cons>
    80000250:	00001097          	auipc	ra,0x1
    80000254:	a6a080e7          	jalr	-1430(ra) # 80000cba <release>
        return -1;
    80000258:	557d                	li	a0,-1
}
    8000025a:	70a6                	ld	ra,104(sp)
    8000025c:	7406                	ld	s0,96(sp)
    8000025e:	64e6                	ld	s1,88(sp)
    80000260:	6946                	ld	s2,80(sp)
    80000262:	69a6                	ld	s3,72(sp)
    80000264:	6a06                	ld	s4,64(sp)
    80000266:	7ae2                	ld	s5,56(sp)
    80000268:	7b42                	ld	s6,48(sp)
    8000026a:	7ba2                	ld	s7,40(sp)
    8000026c:	7c02                	ld	s8,32(sp)
    8000026e:	6ce2                	ld	s9,24(sp)
    80000270:	6d42                	ld	s10,16(sp)
    80000272:	6165                	addi	sp,sp,112
    80000274:	8082                	ret
      if(n < target){
    80000276:	0009871b          	sext.w	a4,s3
    8000027a:	fb677ce3          	bgeu	a4,s6,80000232 <consoleread+0xbc>
        cons.r--;
    8000027e:	00011717          	auipc	a4,0x11
    80000282:	f8f72523          	sw	a5,-118(a4) # 80011208 <cons+0x98>
    80000286:	b775                	j	80000232 <consoleread+0xbc>

0000000080000288 <consputc>:
{
    80000288:	1141                	addi	sp,sp,-16
    8000028a:	e406                	sd	ra,8(sp)
    8000028c:	e022                	sd	s0,0(sp)
    8000028e:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000290:	10000793          	li	a5,256
    80000294:	00f50a63          	beq	a0,a5,800002a8 <consputc+0x20>
    uartputc_sync(c);
    80000298:	00000097          	auipc	ra,0x0
    8000029c:	55e080e7          	jalr	1374(ra) # 800007f6 <uartputc_sync>
}
    800002a0:	60a2                	ld	ra,8(sp)
    800002a2:	6402                	ld	s0,0(sp)
    800002a4:	0141                	addi	sp,sp,16
    800002a6:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800002a8:	4521                	li	a0,8
    800002aa:	00000097          	auipc	ra,0x0
    800002ae:	54c080e7          	jalr	1356(ra) # 800007f6 <uartputc_sync>
    800002b2:	02000513          	li	a0,32
    800002b6:	00000097          	auipc	ra,0x0
    800002ba:	540080e7          	jalr	1344(ra) # 800007f6 <uartputc_sync>
    800002be:	4521                	li	a0,8
    800002c0:	00000097          	auipc	ra,0x0
    800002c4:	536080e7          	jalr	1334(ra) # 800007f6 <uartputc_sync>
    800002c8:	bfe1                	j	800002a0 <consputc+0x18>

00000000800002ca <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002ca:	1101                	addi	sp,sp,-32
    800002cc:	ec06                	sd	ra,24(sp)
    800002ce:	e822                	sd	s0,16(sp)
    800002d0:	e426                	sd	s1,8(sp)
    800002d2:	e04a                	sd	s2,0(sp)
    800002d4:	1000                	addi	s0,sp,32
    800002d6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002d8:	00011517          	auipc	a0,0x11
    800002dc:	e9850513          	addi	a0,a0,-360 # 80011170 <cons>
    800002e0:	00001097          	auipc	ra,0x1
    800002e4:	926080e7          	jalr	-1754(ra) # 80000c06 <acquire>

  switch(c){
    800002e8:	47d5                	li	a5,21
    800002ea:	0af48663          	beq	s1,a5,80000396 <consoleintr+0xcc>
    800002ee:	0297ca63          	blt	a5,s1,80000322 <consoleintr+0x58>
    800002f2:	47a1                	li	a5,8
    800002f4:	0ef48763          	beq	s1,a5,800003e2 <consoleintr+0x118>
    800002f8:	47c1                	li	a5,16
    800002fa:	10f49a63          	bne	s1,a5,8000040e <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002fe:	00002097          	auipc	ra,0x2
    80000302:	1e6080e7          	jalr	486(ra) # 800024e4 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80000306:	00011517          	auipc	a0,0x11
    8000030a:	e6a50513          	addi	a0,a0,-406 # 80011170 <cons>
    8000030e:	00001097          	auipc	ra,0x1
    80000312:	9ac080e7          	jalr	-1620(ra) # 80000cba <release>
}
    80000316:	60e2                	ld	ra,24(sp)
    80000318:	6442                	ld	s0,16(sp)
    8000031a:	64a2                	ld	s1,8(sp)
    8000031c:	6902                	ld	s2,0(sp)
    8000031e:	6105                	addi	sp,sp,32
    80000320:	8082                	ret
  switch(c){
    80000322:	07f00793          	li	a5,127
    80000326:	0af48e63          	beq	s1,a5,800003e2 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000032a:	00011717          	auipc	a4,0x11
    8000032e:	e4670713          	addi	a4,a4,-442 # 80011170 <cons>
    80000332:	0a072783          	lw	a5,160(a4)
    80000336:	09872703          	lw	a4,152(a4)
    8000033a:	9f99                	subw	a5,a5,a4
    8000033c:	07f00713          	li	a4,127
    80000340:	fcf763e3          	bltu	a4,a5,80000306 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000344:	47b5                	li	a5,13
    80000346:	0cf48763          	beq	s1,a5,80000414 <consoleintr+0x14a>
      consputc(c);
    8000034a:	8526                	mv	a0,s1
    8000034c:	00000097          	auipc	ra,0x0
    80000350:	f3c080e7          	jalr	-196(ra) # 80000288 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000354:	00011797          	auipc	a5,0x11
    80000358:	e1c78793          	addi	a5,a5,-484 # 80011170 <cons>
    8000035c:	0a07a703          	lw	a4,160(a5)
    80000360:	0017069b          	addiw	a3,a4,1
    80000364:	0006861b          	sext.w	a2,a3
    80000368:	0ad7a023          	sw	a3,160(a5)
    8000036c:	07f77713          	andi	a4,a4,127
    80000370:	97ba                	add	a5,a5,a4
    80000372:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80000376:	47a9                	li	a5,10
    80000378:	0cf48563          	beq	s1,a5,80000442 <consoleintr+0x178>
    8000037c:	4791                	li	a5,4
    8000037e:	0cf48263          	beq	s1,a5,80000442 <consoleintr+0x178>
    80000382:	00011797          	auipc	a5,0x11
    80000386:	e867a783          	lw	a5,-378(a5) # 80011208 <cons+0x98>
    8000038a:	0807879b          	addiw	a5,a5,128
    8000038e:	f6f61ce3          	bne	a2,a5,80000306 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000392:	863e                	mv	a2,a5
    80000394:	a07d                	j	80000442 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80000396:	00011717          	auipc	a4,0x11
    8000039a:	dda70713          	addi	a4,a4,-550 # 80011170 <cons>
    8000039e:	0a072783          	lw	a5,160(a4)
    800003a2:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003a6:	00011497          	auipc	s1,0x11
    800003aa:	dca48493          	addi	s1,s1,-566 # 80011170 <cons>
    while(cons.e != cons.w &&
    800003ae:	4929                	li	s2,10
    800003b0:	f4f70be3          	beq	a4,a5,80000306 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003b4:	37fd                	addiw	a5,a5,-1
    800003b6:	07f7f713          	andi	a4,a5,127
    800003ba:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003bc:	01874703          	lbu	a4,24(a4)
    800003c0:	f52703e3          	beq	a4,s2,80000306 <consoleintr+0x3c>
      cons.e--;
    800003c4:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003c8:	10000513          	li	a0,256
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	ebc080e7          	jalr	-324(ra) # 80000288 <consputc>
    while(cons.e != cons.w &&
    800003d4:	0a04a783          	lw	a5,160(s1)
    800003d8:	09c4a703          	lw	a4,156(s1)
    800003dc:	fcf71ce3          	bne	a4,a5,800003b4 <consoleintr+0xea>
    800003e0:	b71d                	j	80000306 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003e2:	00011717          	auipc	a4,0x11
    800003e6:	d8e70713          	addi	a4,a4,-626 # 80011170 <cons>
    800003ea:	0a072783          	lw	a5,160(a4)
    800003ee:	09c72703          	lw	a4,156(a4)
    800003f2:	f0f70ae3          	beq	a4,a5,80000306 <consoleintr+0x3c>
      cons.e--;
    800003f6:	37fd                	addiw	a5,a5,-1
    800003f8:	00011717          	auipc	a4,0x11
    800003fc:	e0f72c23          	sw	a5,-488(a4) # 80011210 <cons+0xa0>
      consputc(BACKSPACE);
    80000400:	10000513          	li	a0,256
    80000404:	00000097          	auipc	ra,0x0
    80000408:	e84080e7          	jalr	-380(ra) # 80000288 <consputc>
    8000040c:	bded                	j	80000306 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000040e:	ee048ce3          	beqz	s1,80000306 <consoleintr+0x3c>
    80000412:	bf21                	j	8000032a <consoleintr+0x60>
      consputc(c);
    80000414:	4529                	li	a0,10
    80000416:	00000097          	auipc	ra,0x0
    8000041a:	e72080e7          	jalr	-398(ra) # 80000288 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000041e:	00011797          	auipc	a5,0x11
    80000422:	d5278793          	addi	a5,a5,-686 # 80011170 <cons>
    80000426:	0a07a703          	lw	a4,160(a5)
    8000042a:	0017069b          	addiw	a3,a4,1
    8000042e:	0006861b          	sext.w	a2,a3
    80000432:	0ad7a023          	sw	a3,160(a5)
    80000436:	07f77713          	andi	a4,a4,127
    8000043a:	97ba                	add	a5,a5,a4
    8000043c:	4729                	li	a4,10
    8000043e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000442:	00011797          	auipc	a5,0x11
    80000446:	dcc7a523          	sw	a2,-566(a5) # 8001120c <cons+0x9c>
        wakeup(&cons.r);
    8000044a:	00011517          	auipc	a0,0x11
    8000044e:	dbe50513          	addi	a0,a0,-578 # 80011208 <cons+0x98>
    80000452:	00002097          	auipc	ra,0x2
    80000456:	f0c080e7          	jalr	-244(ra) # 8000235e <wakeup>
    8000045a:	b575                	j	80000306 <consoleintr+0x3c>

000000008000045c <consoleinit>:

void
consoleinit(void)
{
    8000045c:	1141                	addi	sp,sp,-16
    8000045e:	e406                	sd	ra,8(sp)
    80000460:	e022                	sd	s0,0(sp)
    80000462:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000464:	00008597          	auipc	a1,0x8
    80000468:	bac58593          	addi	a1,a1,-1108 # 80008010 <etext+0x10>
    8000046c:	00011517          	auipc	a0,0x11
    80000470:	d0450513          	addi	a0,a0,-764 # 80011170 <cons>
    80000474:	00000097          	auipc	ra,0x0
    80000478:	702080e7          	jalr	1794(ra) # 80000b76 <initlock>

  uartinit();
    8000047c:	00000097          	auipc	ra,0x0
    80000480:	32a080e7          	jalr	810(ra) # 800007a6 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000484:	00021797          	auipc	a5,0x21
    80000488:	e6c78793          	addi	a5,a5,-404 # 800212f0 <devsw>
    8000048c:	00000717          	auipc	a4,0x0
    80000490:	cea70713          	addi	a4,a4,-790 # 80000176 <consoleread>
    80000494:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000496:	00000717          	auipc	a4,0x0
    8000049a:	c5e70713          	addi	a4,a4,-930 # 800000f4 <consolewrite>
    8000049e:	ef98                	sd	a4,24(a5)
}
    800004a0:	60a2                	ld	ra,8(sp)
    800004a2:	6402                	ld	s0,0(sp)
    800004a4:	0141                	addi	sp,sp,16
    800004a6:	8082                	ret

00000000800004a8 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004a8:	7179                	addi	sp,sp,-48
    800004aa:	f406                	sd	ra,40(sp)
    800004ac:	f022                	sd	s0,32(sp)
    800004ae:	ec26                	sd	s1,24(sp)
    800004b0:	e84a                	sd	s2,16(sp)
    800004b2:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004b4:	c219                	beqz	a2,800004ba <printint+0x12>
    800004b6:	08054663          	bltz	a0,80000542 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    800004ba:	2501                	sext.w	a0,a0
    800004bc:	4881                	li	a7,0
    800004be:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004c2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004c4:	2581                	sext.w	a1,a1
    800004c6:	00008617          	auipc	a2,0x8
    800004ca:	b7a60613          	addi	a2,a2,-1158 # 80008040 <digits>
    800004ce:	883a                	mv	a6,a4
    800004d0:	2705                	addiw	a4,a4,1
    800004d2:	02b577bb          	remuw	a5,a0,a1
    800004d6:	1782                	slli	a5,a5,0x20
    800004d8:	9381                	srli	a5,a5,0x20
    800004da:	97b2                	add	a5,a5,a2
    800004dc:	0007c783          	lbu	a5,0(a5)
    800004e0:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004e4:	0005079b          	sext.w	a5,a0
    800004e8:	02b5553b          	divuw	a0,a0,a1
    800004ec:	0685                	addi	a3,a3,1
    800004ee:	feb7f0e3          	bgeu	a5,a1,800004ce <printint+0x26>

  if(sign)
    800004f2:	00088b63          	beqz	a7,80000508 <printint+0x60>
    buf[i++] = '-';
    800004f6:	fe040793          	addi	a5,s0,-32
    800004fa:	973e                	add	a4,a4,a5
    800004fc:	02d00793          	li	a5,45
    80000500:	fef70823          	sb	a5,-16(a4)
    80000504:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80000508:	02e05763          	blez	a4,80000536 <printint+0x8e>
    8000050c:	fd040793          	addi	a5,s0,-48
    80000510:	00e784b3          	add	s1,a5,a4
    80000514:	fff78913          	addi	s2,a5,-1
    80000518:	993a                	add	s2,s2,a4
    8000051a:	377d                	addiw	a4,a4,-1
    8000051c:	1702                	slli	a4,a4,0x20
    8000051e:	9301                	srli	a4,a4,0x20
    80000520:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000524:	fff4c503          	lbu	a0,-1(s1)
    80000528:	00000097          	auipc	ra,0x0
    8000052c:	d60080e7          	jalr	-672(ra) # 80000288 <consputc>
  while(--i >= 0)
    80000530:	14fd                	addi	s1,s1,-1
    80000532:	ff2499e3          	bne	s1,s2,80000524 <printint+0x7c>
}
    80000536:	70a2                	ld	ra,40(sp)
    80000538:	7402                	ld	s0,32(sp)
    8000053a:	64e2                	ld	s1,24(sp)
    8000053c:	6942                	ld	s2,16(sp)
    8000053e:	6145                	addi	sp,sp,48
    80000540:	8082                	ret
    x = -xx;
    80000542:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000546:	4885                	li	a7,1
    x = -xx;
    80000548:	bf9d                	j	800004be <printint+0x16>

000000008000054a <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000054a:	1101                	addi	sp,sp,-32
    8000054c:	ec06                	sd	ra,24(sp)
    8000054e:	e822                	sd	s0,16(sp)
    80000550:	e426                	sd	s1,8(sp)
    80000552:	1000                	addi	s0,sp,32
    80000554:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000556:	00011797          	auipc	a5,0x11
    8000055a:	cc07ad23          	sw	zero,-806(a5) # 80011230 <pr+0x18>
  printf("panic: ");
    8000055e:	00008517          	auipc	a0,0x8
    80000562:	aba50513          	addi	a0,a0,-1350 # 80008018 <etext+0x18>
    80000566:	00000097          	auipc	ra,0x0
    8000056a:	02e080e7          	jalr	46(ra) # 80000594 <printf>
  printf(s);
    8000056e:	8526                	mv	a0,s1
    80000570:	00000097          	auipc	ra,0x0
    80000574:	024080e7          	jalr	36(ra) # 80000594 <printf>
  printf("\n");
    80000578:	00008517          	auipc	a0,0x8
    8000057c:	b5050513          	addi	a0,a0,-1200 # 800080c8 <digits+0x88>
    80000580:	00000097          	auipc	ra,0x0
    80000584:	014080e7          	jalr	20(ra) # 80000594 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000588:	4785                	li	a5,1
    8000058a:	00009717          	auipc	a4,0x9
    8000058e:	a6f72b23          	sw	a5,-1418(a4) # 80009000 <panicked>
  for(;;)
    80000592:	a001                	j	80000592 <panic+0x48>

0000000080000594 <printf>:
{
    80000594:	7131                	addi	sp,sp,-192
    80000596:	fc86                	sd	ra,120(sp)
    80000598:	f8a2                	sd	s0,112(sp)
    8000059a:	f4a6                	sd	s1,104(sp)
    8000059c:	f0ca                	sd	s2,96(sp)
    8000059e:	ecce                	sd	s3,88(sp)
    800005a0:	e8d2                	sd	s4,80(sp)
    800005a2:	e4d6                	sd	s5,72(sp)
    800005a4:	e0da                	sd	s6,64(sp)
    800005a6:	fc5e                	sd	s7,56(sp)
    800005a8:	f862                	sd	s8,48(sp)
    800005aa:	f466                	sd	s9,40(sp)
    800005ac:	f06a                	sd	s10,32(sp)
    800005ae:	ec6e                	sd	s11,24(sp)
    800005b0:	0100                	addi	s0,sp,128
    800005b2:	8a2a                	mv	s4,a0
    800005b4:	e40c                	sd	a1,8(s0)
    800005b6:	e810                	sd	a2,16(s0)
    800005b8:	ec14                	sd	a3,24(s0)
    800005ba:	f018                	sd	a4,32(s0)
    800005bc:	f41c                	sd	a5,40(s0)
    800005be:	03043823          	sd	a6,48(s0)
    800005c2:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005c6:	00011d97          	auipc	s11,0x11
    800005ca:	c6adad83          	lw	s11,-918(s11) # 80011230 <pr+0x18>
  if(locking)
    800005ce:	020d9b63          	bnez	s11,80000604 <printf+0x70>
  if (fmt == 0)
    800005d2:	040a0263          	beqz	s4,80000616 <printf+0x82>
  va_start(ap, fmt);
    800005d6:	00840793          	addi	a5,s0,8
    800005da:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005de:	000a4503          	lbu	a0,0(s4)
    800005e2:	14050f63          	beqz	a0,80000740 <printf+0x1ac>
    800005e6:	4981                	li	s3,0
    if(c != '%'){
    800005e8:	02500a93          	li	s5,37
    switch(c){
    800005ec:	07000b93          	li	s7,112
  consputc('x');
    800005f0:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005f2:	00008b17          	auipc	s6,0x8
    800005f6:	a4eb0b13          	addi	s6,s6,-1458 # 80008040 <digits>
    switch(c){
    800005fa:	07300c93          	li	s9,115
    800005fe:	06400c13          	li	s8,100
    80000602:	a82d                	j	8000063c <printf+0xa8>
    acquire(&pr.lock);
    80000604:	00011517          	auipc	a0,0x11
    80000608:	c1450513          	addi	a0,a0,-1004 # 80011218 <pr>
    8000060c:	00000097          	auipc	ra,0x0
    80000610:	5fa080e7          	jalr	1530(ra) # 80000c06 <acquire>
    80000614:	bf7d                	j	800005d2 <printf+0x3e>
    panic("null fmt");
    80000616:	00008517          	auipc	a0,0x8
    8000061a:	a1250513          	addi	a0,a0,-1518 # 80008028 <etext+0x28>
    8000061e:	00000097          	auipc	ra,0x0
    80000622:	f2c080e7          	jalr	-212(ra) # 8000054a <panic>
      consputc(c);
    80000626:	00000097          	auipc	ra,0x0
    8000062a:	c62080e7          	jalr	-926(ra) # 80000288 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000062e:	2985                	addiw	s3,s3,1
    80000630:	013a07b3          	add	a5,s4,s3
    80000634:	0007c503          	lbu	a0,0(a5)
    80000638:	10050463          	beqz	a0,80000740 <printf+0x1ac>
    if(c != '%'){
    8000063c:	ff5515e3          	bne	a0,s5,80000626 <printf+0x92>
    c = fmt[++i] & 0xff;
    80000640:	2985                	addiw	s3,s3,1
    80000642:	013a07b3          	add	a5,s4,s3
    80000646:	0007c783          	lbu	a5,0(a5)
    8000064a:	0007849b          	sext.w	s1,a5
    if(c == 0)
    8000064e:	cbed                	beqz	a5,80000740 <printf+0x1ac>
    switch(c){
    80000650:	05778a63          	beq	a5,s7,800006a4 <printf+0x110>
    80000654:	02fbf663          	bgeu	s7,a5,80000680 <printf+0xec>
    80000658:	09978863          	beq	a5,s9,800006e8 <printf+0x154>
    8000065c:	07800713          	li	a4,120
    80000660:	0ce79563          	bne	a5,a4,8000072a <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80000664:	f8843783          	ld	a5,-120(s0)
    80000668:	00878713          	addi	a4,a5,8
    8000066c:	f8e43423          	sd	a4,-120(s0)
    80000670:	4605                	li	a2,1
    80000672:	85ea                	mv	a1,s10
    80000674:	4388                	lw	a0,0(a5)
    80000676:	00000097          	auipc	ra,0x0
    8000067a:	e32080e7          	jalr	-462(ra) # 800004a8 <printint>
      break;
    8000067e:	bf45                	j	8000062e <printf+0x9a>
    switch(c){
    80000680:	09578f63          	beq	a5,s5,8000071e <printf+0x18a>
    80000684:	0b879363          	bne	a5,s8,8000072a <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80000688:	f8843783          	ld	a5,-120(s0)
    8000068c:	00878713          	addi	a4,a5,8
    80000690:	f8e43423          	sd	a4,-120(s0)
    80000694:	4605                	li	a2,1
    80000696:	45a9                	li	a1,10
    80000698:	4388                	lw	a0,0(a5)
    8000069a:	00000097          	auipc	ra,0x0
    8000069e:	e0e080e7          	jalr	-498(ra) # 800004a8 <printint>
      break;
    800006a2:	b771                	j	8000062e <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800006a4:	f8843783          	ld	a5,-120(s0)
    800006a8:	00878713          	addi	a4,a5,8
    800006ac:	f8e43423          	sd	a4,-120(s0)
    800006b0:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006b4:	03000513          	li	a0,48
    800006b8:	00000097          	auipc	ra,0x0
    800006bc:	bd0080e7          	jalr	-1072(ra) # 80000288 <consputc>
  consputc('x');
    800006c0:	07800513          	li	a0,120
    800006c4:	00000097          	auipc	ra,0x0
    800006c8:	bc4080e7          	jalr	-1084(ra) # 80000288 <consputc>
    800006cc:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006ce:	03c95793          	srli	a5,s2,0x3c
    800006d2:	97da                	add	a5,a5,s6
    800006d4:	0007c503          	lbu	a0,0(a5)
    800006d8:	00000097          	auipc	ra,0x0
    800006dc:	bb0080e7          	jalr	-1104(ra) # 80000288 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006e0:	0912                	slli	s2,s2,0x4
    800006e2:	34fd                	addiw	s1,s1,-1
    800006e4:	f4ed                	bnez	s1,800006ce <printf+0x13a>
    800006e6:	b7a1                	j	8000062e <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006e8:	f8843783          	ld	a5,-120(s0)
    800006ec:	00878713          	addi	a4,a5,8
    800006f0:	f8e43423          	sd	a4,-120(s0)
    800006f4:	6384                	ld	s1,0(a5)
    800006f6:	cc89                	beqz	s1,80000710 <printf+0x17c>
      for(; *s; s++)
    800006f8:	0004c503          	lbu	a0,0(s1)
    800006fc:	d90d                	beqz	a0,8000062e <printf+0x9a>
        consputc(*s);
    800006fe:	00000097          	auipc	ra,0x0
    80000702:	b8a080e7          	jalr	-1142(ra) # 80000288 <consputc>
      for(; *s; s++)
    80000706:	0485                	addi	s1,s1,1
    80000708:	0004c503          	lbu	a0,0(s1)
    8000070c:	f96d                	bnez	a0,800006fe <printf+0x16a>
    8000070e:	b705                	j	8000062e <printf+0x9a>
        s = "(null)";
    80000710:	00008497          	auipc	s1,0x8
    80000714:	91048493          	addi	s1,s1,-1776 # 80008020 <etext+0x20>
      for(; *s; s++)
    80000718:	02800513          	li	a0,40
    8000071c:	b7cd                	j	800006fe <printf+0x16a>
      consputc('%');
    8000071e:	8556                	mv	a0,s5
    80000720:	00000097          	auipc	ra,0x0
    80000724:	b68080e7          	jalr	-1176(ra) # 80000288 <consputc>
      break;
    80000728:	b719                	j	8000062e <printf+0x9a>
      consputc('%');
    8000072a:	8556                	mv	a0,s5
    8000072c:	00000097          	auipc	ra,0x0
    80000730:	b5c080e7          	jalr	-1188(ra) # 80000288 <consputc>
      consputc(c);
    80000734:	8526                	mv	a0,s1
    80000736:	00000097          	auipc	ra,0x0
    8000073a:	b52080e7          	jalr	-1198(ra) # 80000288 <consputc>
      break;
    8000073e:	bdc5                	j	8000062e <printf+0x9a>
  if(locking)
    80000740:	020d9163          	bnez	s11,80000762 <printf+0x1ce>
}
    80000744:	70e6                	ld	ra,120(sp)
    80000746:	7446                	ld	s0,112(sp)
    80000748:	74a6                	ld	s1,104(sp)
    8000074a:	7906                	ld	s2,96(sp)
    8000074c:	69e6                	ld	s3,88(sp)
    8000074e:	6a46                	ld	s4,80(sp)
    80000750:	6aa6                	ld	s5,72(sp)
    80000752:	6b06                	ld	s6,64(sp)
    80000754:	7be2                	ld	s7,56(sp)
    80000756:	7c42                	ld	s8,48(sp)
    80000758:	7ca2                	ld	s9,40(sp)
    8000075a:	7d02                	ld	s10,32(sp)
    8000075c:	6de2                	ld	s11,24(sp)
    8000075e:	6129                	addi	sp,sp,192
    80000760:	8082                	ret
    release(&pr.lock);
    80000762:	00011517          	auipc	a0,0x11
    80000766:	ab650513          	addi	a0,a0,-1354 # 80011218 <pr>
    8000076a:	00000097          	auipc	ra,0x0
    8000076e:	550080e7          	jalr	1360(ra) # 80000cba <release>
}
    80000772:	bfc9                	j	80000744 <printf+0x1b0>

0000000080000774 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000774:	1101                	addi	sp,sp,-32
    80000776:	ec06                	sd	ra,24(sp)
    80000778:	e822                	sd	s0,16(sp)
    8000077a:	e426                	sd	s1,8(sp)
    8000077c:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000077e:	00011497          	auipc	s1,0x11
    80000782:	a9a48493          	addi	s1,s1,-1382 # 80011218 <pr>
    80000786:	00008597          	auipc	a1,0x8
    8000078a:	8b258593          	addi	a1,a1,-1870 # 80008038 <etext+0x38>
    8000078e:	8526                	mv	a0,s1
    80000790:	00000097          	auipc	ra,0x0
    80000794:	3e6080e7          	jalr	998(ra) # 80000b76 <initlock>
  pr.locking = 1;
    80000798:	4785                	li	a5,1
    8000079a:	cc9c                	sw	a5,24(s1)
}
    8000079c:	60e2                	ld	ra,24(sp)
    8000079e:	6442                	ld	s0,16(sp)
    800007a0:	64a2                	ld	s1,8(sp)
    800007a2:	6105                	addi	sp,sp,32
    800007a4:	8082                	ret

00000000800007a6 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007a6:	1141                	addi	sp,sp,-16
    800007a8:	e406                	sd	ra,8(sp)
    800007aa:	e022                	sd	s0,0(sp)
    800007ac:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007ae:	100007b7          	lui	a5,0x10000
    800007b2:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007b6:	f8000713          	li	a4,-128
    800007ba:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007be:	470d                	li	a4,3
    800007c0:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007c4:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007c8:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007cc:	469d                	li	a3,7
    800007ce:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007d2:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007d6:	00008597          	auipc	a1,0x8
    800007da:	88258593          	addi	a1,a1,-1918 # 80008058 <digits+0x18>
    800007de:	00011517          	auipc	a0,0x11
    800007e2:	a5a50513          	addi	a0,a0,-1446 # 80011238 <uart_tx_lock>
    800007e6:	00000097          	auipc	ra,0x0
    800007ea:	390080e7          	jalr	912(ra) # 80000b76 <initlock>
}
    800007ee:	60a2                	ld	ra,8(sp)
    800007f0:	6402                	ld	s0,0(sp)
    800007f2:	0141                	addi	sp,sp,16
    800007f4:	8082                	ret

00000000800007f6 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007f6:	1101                	addi	sp,sp,-32
    800007f8:	ec06                	sd	ra,24(sp)
    800007fa:	e822                	sd	s0,16(sp)
    800007fc:	e426                	sd	s1,8(sp)
    800007fe:	1000                	addi	s0,sp,32
    80000800:	84aa                	mv	s1,a0
  push_off();
    80000802:	00000097          	auipc	ra,0x0
    80000806:	3b8080e7          	jalr	952(ra) # 80000bba <push_off>

  if(panicked){
    8000080a:	00008797          	auipc	a5,0x8
    8000080e:	7f67a783          	lw	a5,2038(a5) # 80009000 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000812:	10000737          	lui	a4,0x10000
  if(panicked){
    80000816:	c391                	beqz	a5,8000081a <uartputc_sync+0x24>
    for(;;)
    80000818:	a001                	j	80000818 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000081a:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000081e:	0207f793          	andi	a5,a5,32
    80000822:	dfe5                	beqz	a5,8000081a <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000824:	0ff4f513          	andi	a0,s1,255
    80000828:	100007b7          	lui	a5,0x10000
    8000082c:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000830:	00000097          	auipc	ra,0x0
    80000834:	42a080e7          	jalr	1066(ra) # 80000c5a <pop_off>
}
    80000838:	60e2                	ld	ra,24(sp)
    8000083a:	6442                	ld	s0,16(sp)
    8000083c:	64a2                	ld	s1,8(sp)
    8000083e:	6105                	addi	sp,sp,32
    80000840:	8082                	ret

0000000080000842 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000842:	00008797          	auipc	a5,0x8
    80000846:	7c27a783          	lw	a5,1986(a5) # 80009004 <uart_tx_r>
    8000084a:	00008717          	auipc	a4,0x8
    8000084e:	7be72703          	lw	a4,1982(a4) # 80009008 <uart_tx_w>
    80000852:	08f70063          	beq	a4,a5,800008d2 <uartstart+0x90>
{
    80000856:	7139                	addi	sp,sp,-64
    80000858:	fc06                	sd	ra,56(sp)
    8000085a:	f822                	sd	s0,48(sp)
    8000085c:	f426                	sd	s1,40(sp)
    8000085e:	f04a                	sd	s2,32(sp)
    80000860:	ec4e                	sd	s3,24(sp)
    80000862:	e852                	sd	s4,16(sp)
    80000864:	e456                	sd	s5,8(sp)
    80000866:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000868:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r];
    8000086c:	00011a97          	auipc	s5,0x11
    80000870:	9cca8a93          	addi	s5,s5,-1588 # 80011238 <uart_tx_lock>
    uart_tx_r = (uart_tx_r + 1) % UART_TX_BUF_SIZE;
    80000874:	00008497          	auipc	s1,0x8
    80000878:	79048493          	addi	s1,s1,1936 # 80009004 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000087c:	00008a17          	auipc	s4,0x8
    80000880:	78ca0a13          	addi	s4,s4,1932 # 80009008 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000884:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80000888:	02077713          	andi	a4,a4,32
    8000088c:	cb15                	beqz	a4,800008c0 <uartstart+0x7e>
    int c = uart_tx_buf[uart_tx_r];
    8000088e:	00fa8733          	add	a4,s5,a5
    80000892:	01874983          	lbu	s3,24(a4)
    uart_tx_r = (uart_tx_r + 1) % UART_TX_BUF_SIZE;
    80000896:	2785                	addiw	a5,a5,1
    80000898:	41f7d71b          	sraiw	a4,a5,0x1f
    8000089c:	01b7571b          	srliw	a4,a4,0x1b
    800008a0:	9fb9                	addw	a5,a5,a4
    800008a2:	8bfd                	andi	a5,a5,31
    800008a4:	9f99                	subw	a5,a5,a4
    800008a6:	c09c                	sw	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800008a8:	8526                	mv	a0,s1
    800008aa:	00002097          	auipc	ra,0x2
    800008ae:	ab4080e7          	jalr	-1356(ra) # 8000235e <wakeup>
    
    WriteReg(THR, c);
    800008b2:	01390023          	sb	s3,0(s2)
    if(uart_tx_w == uart_tx_r){
    800008b6:	409c                	lw	a5,0(s1)
    800008b8:	000a2703          	lw	a4,0(s4)
    800008bc:	fcf714e3          	bne	a4,a5,80000884 <uartstart+0x42>
  }
}
    800008c0:	70e2                	ld	ra,56(sp)
    800008c2:	7442                	ld	s0,48(sp)
    800008c4:	74a2                	ld	s1,40(sp)
    800008c6:	7902                	ld	s2,32(sp)
    800008c8:	69e2                	ld	s3,24(sp)
    800008ca:	6a42                	ld	s4,16(sp)
    800008cc:	6aa2                	ld	s5,8(sp)
    800008ce:	6121                	addi	sp,sp,64
    800008d0:	8082                	ret
    800008d2:	8082                	ret

00000000800008d4 <uartputc>:
{
    800008d4:	7179                	addi	sp,sp,-48
    800008d6:	f406                	sd	ra,40(sp)
    800008d8:	f022                	sd	s0,32(sp)
    800008da:	ec26                	sd	s1,24(sp)
    800008dc:	e84a                	sd	s2,16(sp)
    800008de:	e44e                	sd	s3,8(sp)
    800008e0:	e052                	sd	s4,0(sp)
    800008e2:	1800                	addi	s0,sp,48
    800008e4:	84aa                	mv	s1,a0
  acquire(&uart_tx_lock);
    800008e6:	00011517          	auipc	a0,0x11
    800008ea:	95250513          	addi	a0,a0,-1710 # 80011238 <uart_tx_lock>
    800008ee:	00000097          	auipc	ra,0x0
    800008f2:	318080e7          	jalr	792(ra) # 80000c06 <acquire>
  if(panicked){
    800008f6:	00008797          	auipc	a5,0x8
    800008fa:	70a7a783          	lw	a5,1802(a5) # 80009000 <panicked>
    800008fe:	c391                	beqz	a5,80000902 <uartputc+0x2e>
    for(;;)
    80000900:	a001                	j	80000900 <uartputc+0x2c>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    80000902:	00008697          	auipc	a3,0x8
    80000906:	7066a683          	lw	a3,1798(a3) # 80009008 <uart_tx_w>
    8000090a:	0016879b          	addiw	a5,a3,1
    8000090e:	41f7d71b          	sraiw	a4,a5,0x1f
    80000912:	01b7571b          	srliw	a4,a4,0x1b
    80000916:	9fb9                	addw	a5,a5,a4
    80000918:	8bfd                	andi	a5,a5,31
    8000091a:	9f99                	subw	a5,a5,a4
    8000091c:	00008717          	auipc	a4,0x8
    80000920:	6e872703          	lw	a4,1768(a4) # 80009004 <uart_tx_r>
    80000924:	04f71363          	bne	a4,a5,8000096a <uartputc+0x96>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000928:	00011a17          	auipc	s4,0x11
    8000092c:	910a0a13          	addi	s4,s4,-1776 # 80011238 <uart_tx_lock>
    80000930:	00008917          	auipc	s2,0x8
    80000934:	6d490913          	addi	s2,s2,1748 # 80009004 <uart_tx_r>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    80000938:	00008997          	auipc	s3,0x8
    8000093c:	6d098993          	addi	s3,s3,1744 # 80009008 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000940:	85d2                	mv	a1,s4
    80000942:	854a                	mv	a0,s2
    80000944:	00002097          	auipc	ra,0x2
    80000948:	89a080e7          	jalr	-1894(ra) # 800021de <sleep>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    8000094c:	0009a683          	lw	a3,0(s3)
    80000950:	0016879b          	addiw	a5,a3,1
    80000954:	41f7d71b          	sraiw	a4,a5,0x1f
    80000958:	01b7571b          	srliw	a4,a4,0x1b
    8000095c:	9fb9                	addw	a5,a5,a4
    8000095e:	8bfd                	andi	a5,a5,31
    80000960:	9f99                	subw	a5,a5,a4
    80000962:	00092703          	lw	a4,0(s2)
    80000966:	fcf70de3          	beq	a4,a5,80000940 <uartputc+0x6c>
      uart_tx_buf[uart_tx_w] = c;
    8000096a:	00011917          	auipc	s2,0x11
    8000096e:	8ce90913          	addi	s2,s2,-1842 # 80011238 <uart_tx_lock>
    80000972:	96ca                	add	a3,a3,s2
    80000974:	00968c23          	sb	s1,24(a3)
      uart_tx_w = (uart_tx_w + 1) % UART_TX_BUF_SIZE;
    80000978:	00008717          	auipc	a4,0x8
    8000097c:	68f72823          	sw	a5,1680(a4) # 80009008 <uart_tx_w>
      uartstart();
    80000980:	00000097          	auipc	ra,0x0
    80000984:	ec2080e7          	jalr	-318(ra) # 80000842 <uartstart>
      release(&uart_tx_lock);
    80000988:	854a                	mv	a0,s2
    8000098a:	00000097          	auipc	ra,0x0
    8000098e:	330080e7          	jalr	816(ra) # 80000cba <release>
}
    80000992:	70a2                	ld	ra,40(sp)
    80000994:	7402                	ld	s0,32(sp)
    80000996:	64e2                	ld	s1,24(sp)
    80000998:	6942                	ld	s2,16(sp)
    8000099a:	69a2                	ld	s3,8(sp)
    8000099c:	6a02                	ld	s4,0(sp)
    8000099e:	6145                	addi	sp,sp,48
    800009a0:	8082                	ret

00000000800009a2 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009a2:	1141                	addi	sp,sp,-16
    800009a4:	e422                	sd	s0,8(sp)
    800009a6:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009a8:	100007b7          	lui	a5,0x10000
    800009ac:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009b0:	8b85                	andi	a5,a5,1
    800009b2:	cb91                	beqz	a5,800009c6 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800009b4:	100007b7          	lui	a5,0x10000
    800009b8:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800009bc:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800009c0:	6422                	ld	s0,8(sp)
    800009c2:	0141                	addi	sp,sp,16
    800009c4:	8082                	ret
    return -1;
    800009c6:	557d                	li	a0,-1
    800009c8:	bfe5                	j	800009c0 <uartgetc+0x1e>

00000000800009ca <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800009ca:	1101                	addi	sp,sp,-32
    800009cc:	ec06                	sd	ra,24(sp)
    800009ce:	e822                	sd	s0,16(sp)
    800009d0:	e426                	sd	s1,8(sp)
    800009d2:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009d4:	54fd                	li	s1,-1
    800009d6:	a029                	j	800009e0 <uartintr+0x16>
      break;
    consoleintr(c);
    800009d8:	00000097          	auipc	ra,0x0
    800009dc:	8f2080e7          	jalr	-1806(ra) # 800002ca <consoleintr>
    int c = uartgetc();
    800009e0:	00000097          	auipc	ra,0x0
    800009e4:	fc2080e7          	jalr	-62(ra) # 800009a2 <uartgetc>
    if(c == -1)
    800009e8:	fe9518e3          	bne	a0,s1,800009d8 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009ec:	00011497          	auipc	s1,0x11
    800009f0:	84c48493          	addi	s1,s1,-1972 # 80011238 <uart_tx_lock>
    800009f4:	8526                	mv	a0,s1
    800009f6:	00000097          	auipc	ra,0x0
    800009fa:	210080e7          	jalr	528(ra) # 80000c06 <acquire>
  uartstart();
    800009fe:	00000097          	auipc	ra,0x0
    80000a02:	e44080e7          	jalr	-444(ra) # 80000842 <uartstart>
  release(&uart_tx_lock);
    80000a06:	8526                	mv	a0,s1
    80000a08:	00000097          	auipc	ra,0x0
    80000a0c:	2b2080e7          	jalr	690(ra) # 80000cba <release>
}
    80000a10:	60e2                	ld	ra,24(sp)
    80000a12:	6442                	ld	s0,16(sp)
    80000a14:	64a2                	ld	s1,8(sp)
    80000a16:	6105                	addi	sp,sp,32
    80000a18:	8082                	ret

0000000080000a1a <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a1a:	1101                	addi	sp,sp,-32
    80000a1c:	ec06                	sd	ra,24(sp)
    80000a1e:	e822                	sd	s0,16(sp)
    80000a20:	e426                	sd	s1,8(sp)
    80000a22:	e04a                	sd	s2,0(sp)
    80000a24:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a26:	03451793          	slli	a5,a0,0x34
    80000a2a:	ebb9                	bnez	a5,80000a80 <kfree+0x66>
    80000a2c:	84aa                	mv	s1,a0
    80000a2e:	00025797          	auipc	a5,0x25
    80000a32:	5d278793          	addi	a5,a5,1490 # 80026000 <end>
    80000a36:	04f56563          	bltu	a0,a5,80000a80 <kfree+0x66>
    80000a3a:	47c5                	li	a5,17
    80000a3c:	07ee                	slli	a5,a5,0x1b
    80000a3e:	04f57163          	bgeu	a0,a5,80000a80 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a42:	6605                	lui	a2,0x1
    80000a44:	4585                	li	a1,1
    80000a46:	00000097          	auipc	ra,0x0
    80000a4a:	2bc080e7          	jalr	700(ra) # 80000d02 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a4e:	00011917          	auipc	s2,0x11
    80000a52:	82290913          	addi	s2,s2,-2014 # 80011270 <kmem>
    80000a56:	854a                	mv	a0,s2
    80000a58:	00000097          	auipc	ra,0x0
    80000a5c:	1ae080e7          	jalr	430(ra) # 80000c06 <acquire>
  r->next = kmem.freelist;
    80000a60:	01893783          	ld	a5,24(s2)
    80000a64:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a66:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a6a:	854a                	mv	a0,s2
    80000a6c:	00000097          	auipc	ra,0x0
    80000a70:	24e080e7          	jalr	590(ra) # 80000cba <release>
}
    80000a74:	60e2                	ld	ra,24(sp)
    80000a76:	6442                	ld	s0,16(sp)
    80000a78:	64a2                	ld	s1,8(sp)
    80000a7a:	6902                	ld	s2,0(sp)
    80000a7c:	6105                	addi	sp,sp,32
    80000a7e:	8082                	ret
    panic("kfree");
    80000a80:	00007517          	auipc	a0,0x7
    80000a84:	5e050513          	addi	a0,a0,1504 # 80008060 <digits+0x20>
    80000a88:	00000097          	auipc	ra,0x0
    80000a8c:	ac2080e7          	jalr	-1342(ra) # 8000054a <panic>

0000000080000a90 <freerange>:
{
    80000a90:	7179                	addi	sp,sp,-48
    80000a92:	f406                	sd	ra,40(sp)
    80000a94:	f022                	sd	s0,32(sp)
    80000a96:	ec26                	sd	s1,24(sp)
    80000a98:	e84a                	sd	s2,16(sp)
    80000a9a:	e44e                	sd	s3,8(sp)
    80000a9c:	e052                	sd	s4,0(sp)
    80000a9e:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000aa0:	6785                	lui	a5,0x1
    80000aa2:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000aa6:	94aa                	add	s1,s1,a0
    80000aa8:	757d                	lui	a0,0xfffff
    80000aaa:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000aac:	94be                	add	s1,s1,a5
    80000aae:	0095ee63          	bltu	a1,s1,80000aca <freerange+0x3a>
    80000ab2:	892e                	mv	s2,a1
    kfree(p);
    80000ab4:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ab6:	6985                	lui	s3,0x1
    kfree(p);
    80000ab8:	01448533          	add	a0,s1,s4
    80000abc:	00000097          	auipc	ra,0x0
    80000ac0:	f5e080e7          	jalr	-162(ra) # 80000a1a <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ac4:	94ce                	add	s1,s1,s3
    80000ac6:	fe9979e3          	bgeu	s2,s1,80000ab8 <freerange+0x28>
}
    80000aca:	70a2                	ld	ra,40(sp)
    80000acc:	7402                	ld	s0,32(sp)
    80000ace:	64e2                	ld	s1,24(sp)
    80000ad0:	6942                	ld	s2,16(sp)
    80000ad2:	69a2                	ld	s3,8(sp)
    80000ad4:	6a02                	ld	s4,0(sp)
    80000ad6:	6145                	addi	sp,sp,48
    80000ad8:	8082                	ret

0000000080000ada <kinit>:
{
    80000ada:	1141                	addi	sp,sp,-16
    80000adc:	e406                	sd	ra,8(sp)
    80000ade:	e022                	sd	s0,0(sp)
    80000ae0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000ae2:	00007597          	auipc	a1,0x7
    80000ae6:	58658593          	addi	a1,a1,1414 # 80008068 <digits+0x28>
    80000aea:	00010517          	auipc	a0,0x10
    80000aee:	78650513          	addi	a0,a0,1926 # 80011270 <kmem>
    80000af2:	00000097          	auipc	ra,0x0
    80000af6:	084080e7          	jalr	132(ra) # 80000b76 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000afa:	45c5                	li	a1,17
    80000afc:	05ee                	slli	a1,a1,0x1b
    80000afe:	00025517          	auipc	a0,0x25
    80000b02:	50250513          	addi	a0,a0,1282 # 80026000 <end>
    80000b06:	00000097          	auipc	ra,0x0
    80000b0a:	f8a080e7          	jalr	-118(ra) # 80000a90 <freerange>
}
    80000b0e:	60a2                	ld	ra,8(sp)
    80000b10:	6402                	ld	s0,0(sp)
    80000b12:	0141                	addi	sp,sp,16
    80000b14:	8082                	ret

0000000080000b16 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b16:	1101                	addi	sp,sp,-32
    80000b18:	ec06                	sd	ra,24(sp)
    80000b1a:	e822                	sd	s0,16(sp)
    80000b1c:	e426                	sd	s1,8(sp)
    80000b1e:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b20:	00010497          	auipc	s1,0x10
    80000b24:	75048493          	addi	s1,s1,1872 # 80011270 <kmem>
    80000b28:	8526                	mv	a0,s1
    80000b2a:	00000097          	auipc	ra,0x0
    80000b2e:	0dc080e7          	jalr	220(ra) # 80000c06 <acquire>
  r = kmem.freelist;
    80000b32:	6c84                	ld	s1,24(s1)
  if(r)
    80000b34:	c885                	beqz	s1,80000b64 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b36:	609c                	ld	a5,0(s1)
    80000b38:	00010517          	auipc	a0,0x10
    80000b3c:	73850513          	addi	a0,a0,1848 # 80011270 <kmem>
    80000b40:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b42:	00000097          	auipc	ra,0x0
    80000b46:	178080e7          	jalr	376(ra) # 80000cba <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b4a:	6605                	lui	a2,0x1
    80000b4c:	4595                	li	a1,5
    80000b4e:	8526                	mv	a0,s1
    80000b50:	00000097          	auipc	ra,0x0
    80000b54:	1b2080e7          	jalr	434(ra) # 80000d02 <memset>
  return (void*)r;
}
    80000b58:	8526                	mv	a0,s1
    80000b5a:	60e2                	ld	ra,24(sp)
    80000b5c:	6442                	ld	s0,16(sp)
    80000b5e:	64a2                	ld	s1,8(sp)
    80000b60:	6105                	addi	sp,sp,32
    80000b62:	8082                	ret
  release(&kmem.lock);
    80000b64:	00010517          	auipc	a0,0x10
    80000b68:	70c50513          	addi	a0,a0,1804 # 80011270 <kmem>
    80000b6c:	00000097          	auipc	ra,0x0
    80000b70:	14e080e7          	jalr	334(ra) # 80000cba <release>
  if(r)
    80000b74:	b7d5                	j	80000b58 <kalloc+0x42>

0000000080000b76 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b76:	1141                	addi	sp,sp,-16
    80000b78:	e422                	sd	s0,8(sp)
    80000b7a:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b7c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b7e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b82:	00053823          	sd	zero,16(a0)
}
    80000b86:	6422                	ld	s0,8(sp)
    80000b88:	0141                	addi	sp,sp,16
    80000b8a:	8082                	ret

0000000080000b8c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b8c:	411c                	lw	a5,0(a0)
    80000b8e:	e399                	bnez	a5,80000b94 <holding+0x8>
    80000b90:	4501                	li	a0,0
  return r;
}
    80000b92:	8082                	ret
{
    80000b94:	1101                	addi	sp,sp,-32
    80000b96:	ec06                	sd	ra,24(sp)
    80000b98:	e822                	sd	s0,16(sp)
    80000b9a:	e426                	sd	s1,8(sp)
    80000b9c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b9e:	6904                	ld	s1,16(a0)
    80000ba0:	00001097          	auipc	ra,0x1
    80000ba4:	e32080e7          	jalr	-462(ra) # 800019d2 <mycpu>
    80000ba8:	40a48533          	sub	a0,s1,a0
    80000bac:	00153513          	seqz	a0,a0
}
    80000bb0:	60e2                	ld	ra,24(sp)
    80000bb2:	6442                	ld	s0,16(sp)
    80000bb4:	64a2                	ld	s1,8(sp)
    80000bb6:	6105                	addi	sp,sp,32
    80000bb8:	8082                	ret

0000000080000bba <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bba:	1101                	addi	sp,sp,-32
    80000bbc:	ec06                	sd	ra,24(sp)
    80000bbe:	e822                	sd	s0,16(sp)
    80000bc0:	e426                	sd	s1,8(sp)
    80000bc2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bc4:	100024f3          	csrr	s1,sstatus
    80000bc8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bcc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bce:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bd2:	00001097          	auipc	ra,0x1
    80000bd6:	e00080e7          	jalr	-512(ra) # 800019d2 <mycpu>
    80000bda:	5d3c                	lw	a5,120(a0)
    80000bdc:	cf89                	beqz	a5,80000bf6 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bde:	00001097          	auipc	ra,0x1
    80000be2:	df4080e7          	jalr	-524(ra) # 800019d2 <mycpu>
    80000be6:	5d3c                	lw	a5,120(a0)
    80000be8:	2785                	addiw	a5,a5,1
    80000bea:	dd3c                	sw	a5,120(a0)
}
    80000bec:	60e2                	ld	ra,24(sp)
    80000bee:	6442                	ld	s0,16(sp)
    80000bf0:	64a2                	ld	s1,8(sp)
    80000bf2:	6105                	addi	sp,sp,32
    80000bf4:	8082                	ret
    mycpu()->intena = old;
    80000bf6:	00001097          	auipc	ra,0x1
    80000bfa:	ddc080e7          	jalr	-548(ra) # 800019d2 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bfe:	8085                	srli	s1,s1,0x1
    80000c00:	8885                	andi	s1,s1,1
    80000c02:	dd64                	sw	s1,124(a0)
    80000c04:	bfe9                	j	80000bde <push_off+0x24>

0000000080000c06 <acquire>:
{
    80000c06:	1101                	addi	sp,sp,-32
    80000c08:	ec06                	sd	ra,24(sp)
    80000c0a:	e822                	sd	s0,16(sp)
    80000c0c:	e426                	sd	s1,8(sp)
    80000c0e:	1000                	addi	s0,sp,32
    80000c10:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c12:	00000097          	auipc	ra,0x0
    80000c16:	fa8080e7          	jalr	-88(ra) # 80000bba <push_off>
  if(holding(lk))
    80000c1a:	8526                	mv	a0,s1
    80000c1c:	00000097          	auipc	ra,0x0
    80000c20:	f70080e7          	jalr	-144(ra) # 80000b8c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c24:	4705                	li	a4,1
  if(holding(lk))
    80000c26:	e115                	bnez	a0,80000c4a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c28:	87ba                	mv	a5,a4
    80000c2a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c2e:	2781                	sext.w	a5,a5
    80000c30:	ffe5                	bnez	a5,80000c28 <acquire+0x22>
  __sync_synchronize();
    80000c32:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c36:	00001097          	auipc	ra,0x1
    80000c3a:	d9c080e7          	jalr	-612(ra) # 800019d2 <mycpu>
    80000c3e:	e888                	sd	a0,16(s1)
}
    80000c40:	60e2                	ld	ra,24(sp)
    80000c42:	6442                	ld	s0,16(sp)
    80000c44:	64a2                	ld	s1,8(sp)
    80000c46:	6105                	addi	sp,sp,32
    80000c48:	8082                	ret
    panic("acquire");
    80000c4a:	00007517          	auipc	a0,0x7
    80000c4e:	42650513          	addi	a0,a0,1062 # 80008070 <digits+0x30>
    80000c52:	00000097          	auipc	ra,0x0
    80000c56:	8f8080e7          	jalr	-1800(ra) # 8000054a <panic>

0000000080000c5a <pop_off>:

void
pop_off(void)
{
    80000c5a:	1141                	addi	sp,sp,-16
    80000c5c:	e406                	sd	ra,8(sp)
    80000c5e:	e022                	sd	s0,0(sp)
    80000c60:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c62:	00001097          	auipc	ra,0x1
    80000c66:	d70080e7          	jalr	-656(ra) # 800019d2 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c6a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c6e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c70:	e78d                	bnez	a5,80000c9a <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c72:	5d3c                	lw	a5,120(a0)
    80000c74:	02f05b63          	blez	a5,80000caa <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c78:	37fd                	addiw	a5,a5,-1
    80000c7a:	0007871b          	sext.w	a4,a5
    80000c7e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c80:	eb09                	bnez	a4,80000c92 <pop_off+0x38>
    80000c82:	5d7c                	lw	a5,124(a0)
    80000c84:	c799                	beqz	a5,80000c92 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c86:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c8a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c8e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c92:	60a2                	ld	ra,8(sp)
    80000c94:	6402                	ld	s0,0(sp)
    80000c96:	0141                	addi	sp,sp,16
    80000c98:	8082                	ret
    panic("pop_off - interruptible");
    80000c9a:	00007517          	auipc	a0,0x7
    80000c9e:	3de50513          	addi	a0,a0,990 # 80008078 <digits+0x38>
    80000ca2:	00000097          	auipc	ra,0x0
    80000ca6:	8a8080e7          	jalr	-1880(ra) # 8000054a <panic>
    panic("pop_off");
    80000caa:	00007517          	auipc	a0,0x7
    80000cae:	3e650513          	addi	a0,a0,998 # 80008090 <digits+0x50>
    80000cb2:	00000097          	auipc	ra,0x0
    80000cb6:	898080e7          	jalr	-1896(ra) # 8000054a <panic>

0000000080000cba <release>:
{
    80000cba:	1101                	addi	sp,sp,-32
    80000cbc:	ec06                	sd	ra,24(sp)
    80000cbe:	e822                	sd	s0,16(sp)
    80000cc0:	e426                	sd	s1,8(sp)
    80000cc2:	1000                	addi	s0,sp,32
    80000cc4:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000cc6:	00000097          	auipc	ra,0x0
    80000cca:	ec6080e7          	jalr	-314(ra) # 80000b8c <holding>
    80000cce:	c115                	beqz	a0,80000cf2 <release+0x38>
  lk->cpu = 0;
    80000cd0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000cd4:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000cd8:	0f50000f          	fence	iorw,ow
    80000cdc:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000ce0:	00000097          	auipc	ra,0x0
    80000ce4:	f7a080e7          	jalr	-134(ra) # 80000c5a <pop_off>
}
    80000ce8:	60e2                	ld	ra,24(sp)
    80000cea:	6442                	ld	s0,16(sp)
    80000cec:	64a2                	ld	s1,8(sp)
    80000cee:	6105                	addi	sp,sp,32
    80000cf0:	8082                	ret
    panic("release");
    80000cf2:	00007517          	auipc	a0,0x7
    80000cf6:	3a650513          	addi	a0,a0,934 # 80008098 <digits+0x58>
    80000cfa:	00000097          	auipc	ra,0x0
    80000cfe:	850080e7          	jalr	-1968(ra) # 8000054a <panic>

0000000080000d02 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000d02:	1141                	addi	sp,sp,-16
    80000d04:	e422                	sd	s0,8(sp)
    80000d06:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d08:	ca19                	beqz	a2,80000d1e <memset+0x1c>
    80000d0a:	87aa                	mv	a5,a0
    80000d0c:	1602                	slli	a2,a2,0x20
    80000d0e:	9201                	srli	a2,a2,0x20
    80000d10:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d14:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d18:	0785                	addi	a5,a5,1
    80000d1a:	fee79de3          	bne	a5,a4,80000d14 <memset+0x12>
  }
  return dst;
}
    80000d1e:	6422                	ld	s0,8(sp)
    80000d20:	0141                	addi	sp,sp,16
    80000d22:	8082                	ret

0000000080000d24 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d24:	1141                	addi	sp,sp,-16
    80000d26:	e422                	sd	s0,8(sp)
    80000d28:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d2a:	ca05                	beqz	a2,80000d5a <memcmp+0x36>
    80000d2c:	fff6069b          	addiw	a3,a2,-1
    80000d30:	1682                	slli	a3,a3,0x20
    80000d32:	9281                	srli	a3,a3,0x20
    80000d34:	0685                	addi	a3,a3,1
    80000d36:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d38:	00054783          	lbu	a5,0(a0)
    80000d3c:	0005c703          	lbu	a4,0(a1)
    80000d40:	00e79863          	bne	a5,a4,80000d50 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d44:	0505                	addi	a0,a0,1
    80000d46:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d48:	fed518e3          	bne	a0,a3,80000d38 <memcmp+0x14>
  }

  return 0;
    80000d4c:	4501                	li	a0,0
    80000d4e:	a019                	j	80000d54 <memcmp+0x30>
      return *s1 - *s2;
    80000d50:	40e7853b          	subw	a0,a5,a4
}
    80000d54:	6422                	ld	s0,8(sp)
    80000d56:	0141                	addi	sp,sp,16
    80000d58:	8082                	ret
  return 0;
    80000d5a:	4501                	li	a0,0
    80000d5c:	bfe5                	j	80000d54 <memcmp+0x30>

0000000080000d5e <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d5e:	1141                	addi	sp,sp,-16
    80000d60:	e422                	sd	s0,8(sp)
    80000d62:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d64:	02a5e563          	bltu	a1,a0,80000d8e <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d68:	fff6069b          	addiw	a3,a2,-1
    80000d6c:	ce11                	beqz	a2,80000d88 <memmove+0x2a>
    80000d6e:	1682                	slli	a3,a3,0x20
    80000d70:	9281                	srli	a3,a3,0x20
    80000d72:	0685                	addi	a3,a3,1
    80000d74:	96ae                	add	a3,a3,a1
    80000d76:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000d78:	0585                	addi	a1,a1,1
    80000d7a:	0785                	addi	a5,a5,1
    80000d7c:	fff5c703          	lbu	a4,-1(a1)
    80000d80:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000d84:	fed59ae3          	bne	a1,a3,80000d78 <memmove+0x1a>

  return dst;
}
    80000d88:	6422                	ld	s0,8(sp)
    80000d8a:	0141                	addi	sp,sp,16
    80000d8c:	8082                	ret
  if(s < d && s + n > d){
    80000d8e:	02061713          	slli	a4,a2,0x20
    80000d92:	9301                	srli	a4,a4,0x20
    80000d94:	00e587b3          	add	a5,a1,a4
    80000d98:	fcf578e3          	bgeu	a0,a5,80000d68 <memmove+0xa>
    d += n;
    80000d9c:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000d9e:	fff6069b          	addiw	a3,a2,-1
    80000da2:	d27d                	beqz	a2,80000d88 <memmove+0x2a>
    80000da4:	02069613          	slli	a2,a3,0x20
    80000da8:	9201                	srli	a2,a2,0x20
    80000daa:	fff64613          	not	a2,a2
    80000dae:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000db0:	17fd                	addi	a5,a5,-1
    80000db2:	177d                	addi	a4,a4,-1
    80000db4:	0007c683          	lbu	a3,0(a5)
    80000db8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000dbc:	fef61ae3          	bne	a2,a5,80000db0 <memmove+0x52>
    80000dc0:	b7e1                	j	80000d88 <memmove+0x2a>

0000000080000dc2 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000dc2:	1141                	addi	sp,sp,-16
    80000dc4:	e406                	sd	ra,8(sp)
    80000dc6:	e022                	sd	s0,0(sp)
    80000dc8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000dca:	00000097          	auipc	ra,0x0
    80000dce:	f94080e7          	jalr	-108(ra) # 80000d5e <memmove>
}
    80000dd2:	60a2                	ld	ra,8(sp)
    80000dd4:	6402                	ld	s0,0(sp)
    80000dd6:	0141                	addi	sp,sp,16
    80000dd8:	8082                	ret

0000000080000dda <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000dda:	1141                	addi	sp,sp,-16
    80000ddc:	e422                	sd	s0,8(sp)
    80000dde:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000de0:	ce11                	beqz	a2,80000dfc <strncmp+0x22>
    80000de2:	00054783          	lbu	a5,0(a0)
    80000de6:	cf89                	beqz	a5,80000e00 <strncmp+0x26>
    80000de8:	0005c703          	lbu	a4,0(a1)
    80000dec:	00f71a63          	bne	a4,a5,80000e00 <strncmp+0x26>
    n--, p++, q++;
    80000df0:	367d                	addiw	a2,a2,-1
    80000df2:	0505                	addi	a0,a0,1
    80000df4:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000df6:	f675                	bnez	a2,80000de2 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000df8:	4501                	li	a0,0
    80000dfa:	a809                	j	80000e0c <strncmp+0x32>
    80000dfc:	4501                	li	a0,0
    80000dfe:	a039                	j	80000e0c <strncmp+0x32>
  if(n == 0)
    80000e00:	ca09                	beqz	a2,80000e12 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000e02:	00054503          	lbu	a0,0(a0)
    80000e06:	0005c783          	lbu	a5,0(a1)
    80000e0a:	9d1d                	subw	a0,a0,a5
}
    80000e0c:	6422                	ld	s0,8(sp)
    80000e0e:	0141                	addi	sp,sp,16
    80000e10:	8082                	ret
    return 0;
    80000e12:	4501                	li	a0,0
    80000e14:	bfe5                	j	80000e0c <strncmp+0x32>

0000000080000e16 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e16:	1141                	addi	sp,sp,-16
    80000e18:	e422                	sd	s0,8(sp)
    80000e1a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e1c:	872a                	mv	a4,a0
    80000e1e:	8832                	mv	a6,a2
    80000e20:	367d                	addiw	a2,a2,-1
    80000e22:	01005963          	blez	a6,80000e34 <strncpy+0x1e>
    80000e26:	0705                	addi	a4,a4,1
    80000e28:	0005c783          	lbu	a5,0(a1)
    80000e2c:	fef70fa3          	sb	a5,-1(a4)
    80000e30:	0585                	addi	a1,a1,1
    80000e32:	f7f5                	bnez	a5,80000e1e <strncpy+0x8>
    ;
  while(n-- > 0)
    80000e34:	86ba                	mv	a3,a4
    80000e36:	00c05c63          	blez	a2,80000e4e <strncpy+0x38>
    *s++ = 0;
    80000e3a:	0685                	addi	a3,a3,1
    80000e3c:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000e40:	fff6c793          	not	a5,a3
    80000e44:	9fb9                	addw	a5,a5,a4
    80000e46:	010787bb          	addw	a5,a5,a6
    80000e4a:	fef048e3          	bgtz	a5,80000e3a <strncpy+0x24>
  return os;
}
    80000e4e:	6422                	ld	s0,8(sp)
    80000e50:	0141                	addi	sp,sp,16
    80000e52:	8082                	ret

0000000080000e54 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e54:	1141                	addi	sp,sp,-16
    80000e56:	e422                	sd	s0,8(sp)
    80000e58:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e5a:	02c05363          	blez	a2,80000e80 <safestrcpy+0x2c>
    80000e5e:	fff6069b          	addiw	a3,a2,-1
    80000e62:	1682                	slli	a3,a3,0x20
    80000e64:	9281                	srli	a3,a3,0x20
    80000e66:	96ae                	add	a3,a3,a1
    80000e68:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e6a:	00d58963          	beq	a1,a3,80000e7c <safestrcpy+0x28>
    80000e6e:	0585                	addi	a1,a1,1
    80000e70:	0785                	addi	a5,a5,1
    80000e72:	fff5c703          	lbu	a4,-1(a1)
    80000e76:	fee78fa3          	sb	a4,-1(a5)
    80000e7a:	fb65                	bnez	a4,80000e6a <safestrcpy+0x16>
    ;
  *s = 0;
    80000e7c:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e80:	6422                	ld	s0,8(sp)
    80000e82:	0141                	addi	sp,sp,16
    80000e84:	8082                	ret

0000000080000e86 <strlen>:

int
strlen(const char *s)
{
    80000e86:	1141                	addi	sp,sp,-16
    80000e88:	e422                	sd	s0,8(sp)
    80000e8a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e8c:	00054783          	lbu	a5,0(a0)
    80000e90:	cf91                	beqz	a5,80000eac <strlen+0x26>
    80000e92:	0505                	addi	a0,a0,1
    80000e94:	87aa                	mv	a5,a0
    80000e96:	4685                	li	a3,1
    80000e98:	9e89                	subw	a3,a3,a0
    80000e9a:	00f6853b          	addw	a0,a3,a5
    80000e9e:	0785                	addi	a5,a5,1
    80000ea0:	fff7c703          	lbu	a4,-1(a5)
    80000ea4:	fb7d                	bnez	a4,80000e9a <strlen+0x14>
    ;
  return n;
}
    80000ea6:	6422                	ld	s0,8(sp)
    80000ea8:	0141                	addi	sp,sp,16
    80000eaa:	8082                	ret
  for(n = 0; s[n]; n++)
    80000eac:	4501                	li	a0,0
    80000eae:	bfe5                	j	80000ea6 <strlen+0x20>

0000000080000eb0 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000eb0:	1141                	addi	sp,sp,-16
    80000eb2:	e406                	sd	ra,8(sp)
    80000eb4:	e022                	sd	s0,0(sp)
    80000eb6:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000eb8:	00001097          	auipc	ra,0x1
    80000ebc:	b0a080e7          	jalr	-1270(ra) # 800019c2 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000ec0:	00008717          	auipc	a4,0x8
    80000ec4:	14c70713          	addi	a4,a4,332 # 8000900c <started>
  if(cpuid() == 0){
    80000ec8:	c139                	beqz	a0,80000f0e <main+0x5e>
    while(started == 0)
    80000eca:	431c                	lw	a5,0(a4)
    80000ecc:	2781                	sext.w	a5,a5
    80000ece:	dff5                	beqz	a5,80000eca <main+0x1a>
      ;
    __sync_synchronize();
    80000ed0:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000ed4:	00001097          	auipc	ra,0x1
    80000ed8:	aee080e7          	jalr	-1298(ra) # 800019c2 <cpuid>
    80000edc:	85aa                	mv	a1,a0
    80000ede:	00007517          	auipc	a0,0x7
    80000ee2:	1da50513          	addi	a0,a0,474 # 800080b8 <digits+0x78>
    80000ee6:	fffff097          	auipc	ra,0xfffff
    80000eea:	6ae080e7          	jalr	1710(ra) # 80000594 <printf>
    kvminithart();    // turn on paging
    80000eee:	00000097          	auipc	ra,0x0
    80000ef2:	0d8080e7          	jalr	216(ra) # 80000fc6 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ef6:	00001097          	auipc	ra,0x1
    80000efa:	72e080e7          	jalr	1838(ra) # 80002624 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000efe:	00005097          	auipc	ra,0x5
    80000f02:	cc2080e7          	jalr	-830(ra) # 80005bc0 <plicinithart>
  }

  scheduler();        
    80000f06:	00001097          	auipc	ra,0x1
    80000f0a:	01c080e7          	jalr	28(ra) # 80001f22 <scheduler>
    consoleinit();
    80000f0e:	fffff097          	auipc	ra,0xfffff
    80000f12:	54e080e7          	jalr	1358(ra) # 8000045c <consoleinit>
    printfinit();
    80000f16:	00000097          	auipc	ra,0x0
    80000f1a:	85e080e7          	jalr	-1954(ra) # 80000774 <printfinit>
    printf("\n");
    80000f1e:	00007517          	auipc	a0,0x7
    80000f22:	1aa50513          	addi	a0,a0,426 # 800080c8 <digits+0x88>
    80000f26:	fffff097          	auipc	ra,0xfffff
    80000f2a:	66e080e7          	jalr	1646(ra) # 80000594 <printf>
    printf("xv6 kernel is booting\n");
    80000f2e:	00007517          	auipc	a0,0x7
    80000f32:	17250513          	addi	a0,a0,370 # 800080a0 <digits+0x60>
    80000f36:	fffff097          	auipc	ra,0xfffff
    80000f3a:	65e080e7          	jalr	1630(ra) # 80000594 <printf>
    printf("\n");
    80000f3e:	00007517          	auipc	a0,0x7
    80000f42:	18a50513          	addi	a0,a0,394 # 800080c8 <digits+0x88>
    80000f46:	fffff097          	auipc	ra,0xfffff
    80000f4a:	64e080e7          	jalr	1614(ra) # 80000594 <printf>
    kinit();         // physical page allocator
    80000f4e:	00000097          	auipc	ra,0x0
    80000f52:	b8c080e7          	jalr	-1140(ra) # 80000ada <kinit>
    kvminit();       // create kernel page table
    80000f56:	00000097          	auipc	ra,0x0
    80000f5a:	310080e7          	jalr	784(ra) # 80001266 <kvminit>
    kvminithart();   // turn on paging
    80000f5e:	00000097          	auipc	ra,0x0
    80000f62:	068080e7          	jalr	104(ra) # 80000fc6 <kvminithart>
    procinit();      // process table
    80000f66:	00001097          	auipc	ra,0x1
    80000f6a:	9c4080e7          	jalr	-1596(ra) # 8000192a <procinit>
    trapinit();      // trap vectors
    80000f6e:	00001097          	auipc	ra,0x1
    80000f72:	68e080e7          	jalr	1678(ra) # 800025fc <trapinit>
    trapinithart();  // install kernel trap vector
    80000f76:	00001097          	auipc	ra,0x1
    80000f7a:	6ae080e7          	jalr	1710(ra) # 80002624 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f7e:	00005097          	auipc	ra,0x5
    80000f82:	c2c080e7          	jalr	-980(ra) # 80005baa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f86:	00005097          	auipc	ra,0x5
    80000f8a:	c3a080e7          	jalr	-966(ra) # 80005bc0 <plicinithart>
    binit();         // buffer cache
    80000f8e:	00002097          	auipc	ra,0x2
    80000f92:	dd6080e7          	jalr	-554(ra) # 80002d64 <binit>
    iinit();         // inode cache
    80000f96:	00002097          	auipc	ra,0x2
    80000f9a:	466080e7          	jalr	1126(ra) # 800033fc <iinit>
    fileinit();      // file table
    80000f9e:	00003097          	auipc	ra,0x3
    80000fa2:	416080e7          	jalr	1046(ra) # 800043b4 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fa6:	00005097          	auipc	ra,0x5
    80000faa:	d3c080e7          	jalr	-708(ra) # 80005ce2 <virtio_disk_init>
    userinit();      // first user process
    80000fae:	00001097          	auipc	ra,0x1
    80000fb2:	d0a080e7          	jalr	-758(ra) # 80001cb8 <userinit>
    __sync_synchronize();
    80000fb6:	0ff0000f          	fence
    started = 1;
    80000fba:	4785                	li	a5,1
    80000fbc:	00008717          	auipc	a4,0x8
    80000fc0:	04f72823          	sw	a5,80(a4) # 8000900c <started>
    80000fc4:	b789                	j	80000f06 <main+0x56>

0000000080000fc6 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000fc6:	1141                	addi	sp,sp,-16
    80000fc8:	e422                	sd	s0,8(sp)
    80000fca:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000fcc:	00008797          	auipc	a5,0x8
    80000fd0:	0447b783          	ld	a5,68(a5) # 80009010 <kernel_pagetable>
    80000fd4:	83b1                	srli	a5,a5,0xc
    80000fd6:	577d                	li	a4,-1
    80000fd8:	177e                	slli	a4,a4,0x3f
    80000fda:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000fdc:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000fe0:	12000073          	sfence.vma
  sfence_vma();
}
    80000fe4:	6422                	ld	s0,8(sp)
    80000fe6:	0141                	addi	sp,sp,16
    80000fe8:	8082                	ret

0000000080000fea <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000fea:	7139                	addi	sp,sp,-64
    80000fec:	fc06                	sd	ra,56(sp)
    80000fee:	f822                	sd	s0,48(sp)
    80000ff0:	f426                	sd	s1,40(sp)
    80000ff2:	f04a                	sd	s2,32(sp)
    80000ff4:	ec4e                	sd	s3,24(sp)
    80000ff6:	e852                	sd	s4,16(sp)
    80000ff8:	e456                	sd	s5,8(sp)
    80000ffa:	e05a                	sd	s6,0(sp)
    80000ffc:	0080                	addi	s0,sp,64
    80000ffe:	84aa                	mv	s1,a0
    80001000:	89ae                	mv	s3,a1
    80001002:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80001004:	57fd                	li	a5,-1
    80001006:	83e9                	srli	a5,a5,0x1a
    80001008:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000100a:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000100c:	04b7f263          	bgeu	a5,a1,80001050 <walk+0x66>
    panic("walk");
    80001010:	00007517          	auipc	a0,0x7
    80001014:	0c050513          	addi	a0,a0,192 # 800080d0 <digits+0x90>
    80001018:	fffff097          	auipc	ra,0xfffff
    8000101c:	532080e7          	jalr	1330(ra) # 8000054a <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001020:	060a8663          	beqz	s5,8000108c <walk+0xa2>
    80001024:	00000097          	auipc	ra,0x0
    80001028:	af2080e7          	jalr	-1294(ra) # 80000b16 <kalloc>
    8000102c:	84aa                	mv	s1,a0
    8000102e:	c529                	beqz	a0,80001078 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80001030:	6605                	lui	a2,0x1
    80001032:	4581                	li	a1,0
    80001034:	00000097          	auipc	ra,0x0
    80001038:	cce080e7          	jalr	-818(ra) # 80000d02 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000103c:	00c4d793          	srli	a5,s1,0xc
    80001040:	07aa                	slli	a5,a5,0xa
    80001042:	0017e793          	ori	a5,a5,1
    80001046:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000104a:	3a5d                	addiw	s4,s4,-9
    8000104c:	036a0063          	beq	s4,s6,8000106c <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80001050:	0149d933          	srl	s2,s3,s4
    80001054:	1ff97913          	andi	s2,s2,511
    80001058:	090e                	slli	s2,s2,0x3
    8000105a:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000105c:	00093483          	ld	s1,0(s2)
    80001060:	0014f793          	andi	a5,s1,1
    80001064:	dfd5                	beqz	a5,80001020 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001066:	80a9                	srli	s1,s1,0xa
    80001068:	04b2                	slli	s1,s1,0xc
    8000106a:	b7c5                	j	8000104a <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000106c:	00c9d513          	srli	a0,s3,0xc
    80001070:	1ff57513          	andi	a0,a0,511
    80001074:	050e                	slli	a0,a0,0x3
    80001076:	9526                	add	a0,a0,s1
}
    80001078:	70e2                	ld	ra,56(sp)
    8000107a:	7442                	ld	s0,48(sp)
    8000107c:	74a2                	ld	s1,40(sp)
    8000107e:	7902                	ld	s2,32(sp)
    80001080:	69e2                	ld	s3,24(sp)
    80001082:	6a42                	ld	s4,16(sp)
    80001084:	6aa2                	ld	s5,8(sp)
    80001086:	6b02                	ld	s6,0(sp)
    80001088:	6121                	addi	sp,sp,64
    8000108a:	8082                	ret
        return 0;
    8000108c:	4501                	li	a0,0
    8000108e:	b7ed                	j	80001078 <walk+0x8e>

0000000080001090 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001090:	57fd                	li	a5,-1
    80001092:	83e9                	srli	a5,a5,0x1a
    80001094:	00b7f463          	bgeu	a5,a1,8000109c <walkaddr+0xc>
    return 0;
    80001098:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000109a:	8082                	ret
{
    8000109c:	1141                	addi	sp,sp,-16
    8000109e:	e406                	sd	ra,8(sp)
    800010a0:	e022                	sd	s0,0(sp)
    800010a2:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800010a4:	4601                	li	a2,0
    800010a6:	00000097          	auipc	ra,0x0
    800010aa:	f44080e7          	jalr	-188(ra) # 80000fea <walk>
  if(pte == 0)
    800010ae:	c105                	beqz	a0,800010ce <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800010b0:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800010b2:	0117f693          	andi	a3,a5,17
    800010b6:	4745                	li	a4,17
    return 0;
    800010b8:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800010ba:	00e68663          	beq	a3,a4,800010c6 <walkaddr+0x36>
}
    800010be:	60a2                	ld	ra,8(sp)
    800010c0:	6402                	ld	s0,0(sp)
    800010c2:	0141                	addi	sp,sp,16
    800010c4:	8082                	ret
  pa = PTE2PA(*pte);
    800010c6:	00a7d513          	srli	a0,a5,0xa
    800010ca:	0532                	slli	a0,a0,0xc
  return pa;
    800010cc:	bfcd                	j	800010be <walkaddr+0x2e>
    return 0;
    800010ce:	4501                	li	a0,0
    800010d0:	b7fd                	j	800010be <walkaddr+0x2e>

00000000800010d2 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800010d2:	715d                	addi	sp,sp,-80
    800010d4:	e486                	sd	ra,72(sp)
    800010d6:	e0a2                	sd	s0,64(sp)
    800010d8:	fc26                	sd	s1,56(sp)
    800010da:	f84a                	sd	s2,48(sp)
    800010dc:	f44e                	sd	s3,40(sp)
    800010de:	f052                	sd	s4,32(sp)
    800010e0:	ec56                	sd	s5,24(sp)
    800010e2:	e85a                	sd	s6,16(sp)
    800010e4:	e45e                	sd	s7,8(sp)
    800010e6:	0880                	addi	s0,sp,80
    800010e8:	8aaa                	mv	s5,a0
    800010ea:	8b3a                	mv	s6,a4
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
    800010ec:	777d                	lui	a4,0xfffff
    800010ee:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800010f2:	167d                	addi	a2,a2,-1
    800010f4:	00b609b3          	add	s3,a2,a1
    800010f8:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800010fc:	893e                	mv	s2,a5
    800010fe:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001102:	6b85                	lui	s7,0x1
    80001104:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80001108:	4605                	li	a2,1
    8000110a:	85ca                	mv	a1,s2
    8000110c:	8556                	mv	a0,s5
    8000110e:	00000097          	auipc	ra,0x0
    80001112:	edc080e7          	jalr	-292(ra) # 80000fea <walk>
    80001116:	c51d                	beqz	a0,80001144 <mappages+0x72>
    if(*pte & PTE_V)
    80001118:	611c                	ld	a5,0(a0)
    8000111a:	8b85                	andi	a5,a5,1
    8000111c:	ef81                	bnez	a5,80001134 <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000111e:	80b1                	srli	s1,s1,0xc
    80001120:	04aa                	slli	s1,s1,0xa
    80001122:	0164e4b3          	or	s1,s1,s6
    80001126:	0014e493          	ori	s1,s1,1
    8000112a:	e104                	sd	s1,0(a0)
    if(a == last)
    8000112c:	03390863          	beq	s2,s3,8000115c <mappages+0x8a>
    a += PGSIZE;
    80001130:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001132:	bfc9                	j	80001104 <mappages+0x32>
      panic("remap");
    80001134:	00007517          	auipc	a0,0x7
    80001138:	fa450513          	addi	a0,a0,-92 # 800080d8 <digits+0x98>
    8000113c:	fffff097          	auipc	ra,0xfffff
    80001140:	40e080e7          	jalr	1038(ra) # 8000054a <panic>
      return -1;
    80001144:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001146:	60a6                	ld	ra,72(sp)
    80001148:	6406                	ld	s0,64(sp)
    8000114a:	74e2                	ld	s1,56(sp)
    8000114c:	7942                	ld	s2,48(sp)
    8000114e:	79a2                	ld	s3,40(sp)
    80001150:	7a02                	ld	s4,32(sp)
    80001152:	6ae2                	ld	s5,24(sp)
    80001154:	6b42                	ld	s6,16(sp)
    80001156:	6ba2                	ld	s7,8(sp)
    80001158:	6161                	addi	sp,sp,80
    8000115a:	8082                	ret
  return 0;
    8000115c:	4501                	li	a0,0
    8000115e:	b7e5                	j	80001146 <mappages+0x74>

0000000080001160 <kvmmap>:
{
    80001160:	1141                	addi	sp,sp,-16
    80001162:	e406                	sd	ra,8(sp)
    80001164:	e022                	sd	s0,0(sp)
    80001166:	0800                	addi	s0,sp,16
    80001168:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000116a:	86b2                	mv	a3,a2
    8000116c:	863e                	mv	a2,a5
    8000116e:	00000097          	auipc	ra,0x0
    80001172:	f64080e7          	jalr	-156(ra) # 800010d2 <mappages>
    80001176:	e509                	bnez	a0,80001180 <kvmmap+0x20>
}
    80001178:	60a2                	ld	ra,8(sp)
    8000117a:	6402                	ld	s0,0(sp)
    8000117c:	0141                	addi	sp,sp,16
    8000117e:	8082                	ret
    panic("kvmmap");
    80001180:	00007517          	auipc	a0,0x7
    80001184:	f6050513          	addi	a0,a0,-160 # 800080e0 <digits+0xa0>
    80001188:	fffff097          	auipc	ra,0xfffff
    8000118c:	3c2080e7          	jalr	962(ra) # 8000054a <panic>

0000000080001190 <kvmmake>:
{
    80001190:	1101                	addi	sp,sp,-32
    80001192:	ec06                	sd	ra,24(sp)
    80001194:	e822                	sd	s0,16(sp)
    80001196:	e426                	sd	s1,8(sp)
    80001198:	e04a                	sd	s2,0(sp)
    8000119a:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000119c:	00000097          	auipc	ra,0x0
    800011a0:	97a080e7          	jalr	-1670(ra) # 80000b16 <kalloc>
    800011a4:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800011a6:	6605                	lui	a2,0x1
    800011a8:	4581                	li	a1,0
    800011aa:	00000097          	auipc	ra,0x0
    800011ae:	b58080e7          	jalr	-1192(ra) # 80000d02 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800011b2:	4719                	li	a4,6
    800011b4:	6685                	lui	a3,0x1
    800011b6:	10000637          	lui	a2,0x10000
    800011ba:	100005b7          	lui	a1,0x10000
    800011be:	8526                	mv	a0,s1
    800011c0:	00000097          	auipc	ra,0x0
    800011c4:	fa0080e7          	jalr	-96(ra) # 80001160 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800011c8:	4719                	li	a4,6
    800011ca:	6685                	lui	a3,0x1
    800011cc:	10001637          	lui	a2,0x10001
    800011d0:	100015b7          	lui	a1,0x10001
    800011d4:	8526                	mv	a0,s1
    800011d6:	00000097          	auipc	ra,0x0
    800011da:	f8a080e7          	jalr	-118(ra) # 80001160 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800011de:	4719                	li	a4,6
    800011e0:	004006b7          	lui	a3,0x400
    800011e4:	0c000637          	lui	a2,0xc000
    800011e8:	0c0005b7          	lui	a1,0xc000
    800011ec:	8526                	mv	a0,s1
    800011ee:	00000097          	auipc	ra,0x0
    800011f2:	f72080e7          	jalr	-142(ra) # 80001160 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800011f6:	00007917          	auipc	s2,0x7
    800011fa:	e0a90913          	addi	s2,s2,-502 # 80008000 <etext>
    800011fe:	4729                	li	a4,10
    80001200:	80007697          	auipc	a3,0x80007
    80001204:	e0068693          	addi	a3,a3,-512 # 8000 <_entry-0x7fff8000>
    80001208:	4605                	li	a2,1
    8000120a:	067e                	slli	a2,a2,0x1f
    8000120c:	85b2                	mv	a1,a2
    8000120e:	8526                	mv	a0,s1
    80001210:	00000097          	auipc	ra,0x0
    80001214:	f50080e7          	jalr	-176(ra) # 80001160 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001218:	4719                	li	a4,6
    8000121a:	46c5                	li	a3,17
    8000121c:	06ee                	slli	a3,a3,0x1b
    8000121e:	412686b3          	sub	a3,a3,s2
    80001222:	864a                	mv	a2,s2
    80001224:	85ca                	mv	a1,s2
    80001226:	8526                	mv	a0,s1
    80001228:	00000097          	auipc	ra,0x0
    8000122c:	f38080e7          	jalr	-200(ra) # 80001160 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001230:	4729                	li	a4,10
    80001232:	6685                	lui	a3,0x1
    80001234:	00006617          	auipc	a2,0x6
    80001238:	dcc60613          	addi	a2,a2,-564 # 80007000 <_trampoline>
    8000123c:	040005b7          	lui	a1,0x4000
    80001240:	15fd                	addi	a1,a1,-1
    80001242:	05b2                	slli	a1,a1,0xc
    80001244:	8526                	mv	a0,s1
    80001246:	00000097          	auipc	ra,0x0
    8000124a:	f1a080e7          	jalr	-230(ra) # 80001160 <kvmmap>
  proc_mapstacks(kpgtbl);
    8000124e:	8526                	mv	a0,s1
    80001250:	00000097          	auipc	ra,0x0
    80001254:	644080e7          	jalr	1604(ra) # 80001894 <proc_mapstacks>
}
    80001258:	8526                	mv	a0,s1
    8000125a:	60e2                	ld	ra,24(sp)
    8000125c:	6442                	ld	s0,16(sp)
    8000125e:	64a2                	ld	s1,8(sp)
    80001260:	6902                	ld	s2,0(sp)
    80001262:	6105                	addi	sp,sp,32
    80001264:	8082                	ret

0000000080001266 <kvminit>:
{
    80001266:	1141                	addi	sp,sp,-16
    80001268:	e406                	sd	ra,8(sp)
    8000126a:	e022                	sd	s0,0(sp)
    8000126c:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000126e:	00000097          	auipc	ra,0x0
    80001272:	f22080e7          	jalr	-222(ra) # 80001190 <kvmmake>
    80001276:	00008797          	auipc	a5,0x8
    8000127a:	d8a7bd23          	sd	a0,-614(a5) # 80009010 <kernel_pagetable>
}
    8000127e:	60a2                	ld	ra,8(sp)
    80001280:	6402                	ld	s0,0(sp)
    80001282:	0141                	addi	sp,sp,16
    80001284:	8082                	ret

0000000080001286 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001286:	715d                	addi	sp,sp,-80
    80001288:	e486                	sd	ra,72(sp)
    8000128a:	e0a2                	sd	s0,64(sp)
    8000128c:	fc26                	sd	s1,56(sp)
    8000128e:	f84a                	sd	s2,48(sp)
    80001290:	f44e                	sd	s3,40(sp)
    80001292:	f052                	sd	s4,32(sp)
    80001294:	ec56                	sd	s5,24(sp)
    80001296:	e85a                	sd	s6,16(sp)
    80001298:	e45e                	sd	s7,8(sp)
    8000129a:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000129c:	03459793          	slli	a5,a1,0x34
    800012a0:	e795                	bnez	a5,800012cc <uvmunmap+0x46>
    800012a2:	8a2a                	mv	s4,a0
    800012a4:	892e                	mv	s2,a1
    800012a6:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012a8:	0632                	slli	a2,a2,0xc
    800012aa:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800012ae:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012b0:	6b05                	lui	s6,0x1
    800012b2:	0735e263          	bltu	a1,s3,80001316 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    800012b6:	60a6                	ld	ra,72(sp)
    800012b8:	6406                	ld	s0,64(sp)
    800012ba:	74e2                	ld	s1,56(sp)
    800012bc:	7942                	ld	s2,48(sp)
    800012be:	79a2                	ld	s3,40(sp)
    800012c0:	7a02                	ld	s4,32(sp)
    800012c2:	6ae2                	ld	s5,24(sp)
    800012c4:	6b42                	ld	s6,16(sp)
    800012c6:	6ba2                	ld	s7,8(sp)
    800012c8:	6161                	addi	sp,sp,80
    800012ca:	8082                	ret
    panic("uvmunmap: not aligned");
    800012cc:	00007517          	auipc	a0,0x7
    800012d0:	e1c50513          	addi	a0,a0,-484 # 800080e8 <digits+0xa8>
    800012d4:	fffff097          	auipc	ra,0xfffff
    800012d8:	276080e7          	jalr	630(ra) # 8000054a <panic>
      panic("uvmunmap: walk");
    800012dc:	00007517          	auipc	a0,0x7
    800012e0:	e2450513          	addi	a0,a0,-476 # 80008100 <digits+0xc0>
    800012e4:	fffff097          	auipc	ra,0xfffff
    800012e8:	266080e7          	jalr	614(ra) # 8000054a <panic>
      panic("uvmunmap: not mapped");
    800012ec:	00007517          	auipc	a0,0x7
    800012f0:	e2450513          	addi	a0,a0,-476 # 80008110 <digits+0xd0>
    800012f4:	fffff097          	auipc	ra,0xfffff
    800012f8:	256080e7          	jalr	598(ra) # 8000054a <panic>
      panic("uvmunmap: not a leaf");
    800012fc:	00007517          	auipc	a0,0x7
    80001300:	e2c50513          	addi	a0,a0,-468 # 80008128 <digits+0xe8>
    80001304:	fffff097          	auipc	ra,0xfffff
    80001308:	246080e7          	jalr	582(ra) # 8000054a <panic>
    *pte = 0;
    8000130c:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001310:	995a                	add	s2,s2,s6
    80001312:	fb3972e3          	bgeu	s2,s3,800012b6 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001316:	4601                	li	a2,0
    80001318:	85ca                	mv	a1,s2
    8000131a:	8552                	mv	a0,s4
    8000131c:	00000097          	auipc	ra,0x0
    80001320:	cce080e7          	jalr	-818(ra) # 80000fea <walk>
    80001324:	84aa                	mv	s1,a0
    80001326:	d95d                	beqz	a0,800012dc <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80001328:	6108                	ld	a0,0(a0)
    8000132a:	00157793          	andi	a5,a0,1
    8000132e:	dfdd                	beqz	a5,800012ec <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001330:	3ff57793          	andi	a5,a0,1023
    80001334:	fd7784e3          	beq	a5,s7,800012fc <uvmunmap+0x76>
    if(do_free){
    80001338:	fc0a8ae3          	beqz	s5,8000130c <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    8000133c:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000133e:	0532                	slli	a0,a0,0xc
    80001340:	fffff097          	auipc	ra,0xfffff
    80001344:	6da080e7          	jalr	1754(ra) # 80000a1a <kfree>
    80001348:	b7d1                	j	8000130c <uvmunmap+0x86>

000000008000134a <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000134a:	1101                	addi	sp,sp,-32
    8000134c:	ec06                	sd	ra,24(sp)
    8000134e:	e822                	sd	s0,16(sp)
    80001350:	e426                	sd	s1,8(sp)
    80001352:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001354:	fffff097          	auipc	ra,0xfffff
    80001358:	7c2080e7          	jalr	1986(ra) # 80000b16 <kalloc>
    8000135c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000135e:	c519                	beqz	a0,8000136c <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001360:	6605                	lui	a2,0x1
    80001362:	4581                	li	a1,0
    80001364:	00000097          	auipc	ra,0x0
    80001368:	99e080e7          	jalr	-1634(ra) # 80000d02 <memset>
  return pagetable;
}
    8000136c:	8526                	mv	a0,s1
    8000136e:	60e2                	ld	ra,24(sp)
    80001370:	6442                	ld	s0,16(sp)
    80001372:	64a2                	ld	s1,8(sp)
    80001374:	6105                	addi	sp,sp,32
    80001376:	8082                	ret

0000000080001378 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80001378:	7179                	addi	sp,sp,-48
    8000137a:	f406                	sd	ra,40(sp)
    8000137c:	f022                	sd	s0,32(sp)
    8000137e:	ec26                	sd	s1,24(sp)
    80001380:	e84a                	sd	s2,16(sp)
    80001382:	e44e                	sd	s3,8(sp)
    80001384:	e052                	sd	s4,0(sp)
    80001386:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001388:	6785                	lui	a5,0x1
    8000138a:	04f67863          	bgeu	a2,a5,800013da <uvminit+0x62>
    8000138e:	8a2a                	mv	s4,a0
    80001390:	89ae                	mv	s3,a1
    80001392:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80001394:	fffff097          	auipc	ra,0xfffff
    80001398:	782080e7          	jalr	1922(ra) # 80000b16 <kalloc>
    8000139c:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000139e:	6605                	lui	a2,0x1
    800013a0:	4581                	li	a1,0
    800013a2:	00000097          	auipc	ra,0x0
    800013a6:	960080e7          	jalr	-1696(ra) # 80000d02 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800013aa:	4779                	li	a4,30
    800013ac:	86ca                	mv	a3,s2
    800013ae:	6605                	lui	a2,0x1
    800013b0:	4581                	li	a1,0
    800013b2:	8552                	mv	a0,s4
    800013b4:	00000097          	auipc	ra,0x0
    800013b8:	d1e080e7          	jalr	-738(ra) # 800010d2 <mappages>
  memmove(mem, src, sz);
    800013bc:	8626                	mv	a2,s1
    800013be:	85ce                	mv	a1,s3
    800013c0:	854a                	mv	a0,s2
    800013c2:	00000097          	auipc	ra,0x0
    800013c6:	99c080e7          	jalr	-1636(ra) # 80000d5e <memmove>
}
    800013ca:	70a2                	ld	ra,40(sp)
    800013cc:	7402                	ld	s0,32(sp)
    800013ce:	64e2                	ld	s1,24(sp)
    800013d0:	6942                	ld	s2,16(sp)
    800013d2:	69a2                	ld	s3,8(sp)
    800013d4:	6a02                	ld	s4,0(sp)
    800013d6:	6145                	addi	sp,sp,48
    800013d8:	8082                	ret
    panic("inituvm: more than a page");
    800013da:	00007517          	auipc	a0,0x7
    800013de:	d6650513          	addi	a0,a0,-666 # 80008140 <digits+0x100>
    800013e2:	fffff097          	auipc	ra,0xfffff
    800013e6:	168080e7          	jalr	360(ra) # 8000054a <panic>

00000000800013ea <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800013ea:	1101                	addi	sp,sp,-32
    800013ec:	ec06                	sd	ra,24(sp)
    800013ee:	e822                	sd	s0,16(sp)
    800013f0:	e426                	sd	s1,8(sp)
    800013f2:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800013f4:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800013f6:	00b67d63          	bgeu	a2,a1,80001410 <uvmdealloc+0x26>
    800013fa:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800013fc:	6785                	lui	a5,0x1
    800013fe:	17fd                	addi	a5,a5,-1
    80001400:	00f60733          	add	a4,a2,a5
    80001404:	767d                	lui	a2,0xfffff
    80001406:	8f71                	and	a4,a4,a2
    80001408:	97ae                	add	a5,a5,a1
    8000140a:	8ff1                	and	a5,a5,a2
    8000140c:	00f76863          	bltu	a4,a5,8000141c <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001410:	8526                	mv	a0,s1
    80001412:	60e2                	ld	ra,24(sp)
    80001414:	6442                	ld	s0,16(sp)
    80001416:	64a2                	ld	s1,8(sp)
    80001418:	6105                	addi	sp,sp,32
    8000141a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000141c:	8f99                	sub	a5,a5,a4
    8000141e:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001420:	4685                	li	a3,1
    80001422:	0007861b          	sext.w	a2,a5
    80001426:	85ba                	mv	a1,a4
    80001428:	00000097          	auipc	ra,0x0
    8000142c:	e5e080e7          	jalr	-418(ra) # 80001286 <uvmunmap>
    80001430:	b7c5                	j	80001410 <uvmdealloc+0x26>

0000000080001432 <uvmalloc>:
  if(newsz < oldsz)
    80001432:	0ab66163          	bltu	a2,a1,800014d4 <uvmalloc+0xa2>
{
    80001436:	7139                	addi	sp,sp,-64
    80001438:	fc06                	sd	ra,56(sp)
    8000143a:	f822                	sd	s0,48(sp)
    8000143c:	f426                	sd	s1,40(sp)
    8000143e:	f04a                	sd	s2,32(sp)
    80001440:	ec4e                	sd	s3,24(sp)
    80001442:	e852                	sd	s4,16(sp)
    80001444:	e456                	sd	s5,8(sp)
    80001446:	0080                	addi	s0,sp,64
    80001448:	8aaa                	mv	s5,a0
    8000144a:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000144c:	6985                	lui	s3,0x1
    8000144e:	19fd                	addi	s3,s3,-1
    80001450:	95ce                	add	a1,a1,s3
    80001452:	79fd                	lui	s3,0xfffff
    80001454:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001458:	08c9f063          	bgeu	s3,a2,800014d8 <uvmalloc+0xa6>
    8000145c:	894e                	mv	s2,s3
    mem = kalloc();
    8000145e:	fffff097          	auipc	ra,0xfffff
    80001462:	6b8080e7          	jalr	1720(ra) # 80000b16 <kalloc>
    80001466:	84aa                	mv	s1,a0
    if(mem == 0){
    80001468:	c51d                	beqz	a0,80001496 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    8000146a:	6605                	lui	a2,0x1
    8000146c:	4581                	li	a1,0
    8000146e:	00000097          	auipc	ra,0x0
    80001472:	894080e7          	jalr	-1900(ra) # 80000d02 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80001476:	4779                	li	a4,30
    80001478:	86a6                	mv	a3,s1
    8000147a:	6605                	lui	a2,0x1
    8000147c:	85ca                	mv	a1,s2
    8000147e:	8556                	mv	a0,s5
    80001480:	00000097          	auipc	ra,0x0
    80001484:	c52080e7          	jalr	-942(ra) # 800010d2 <mappages>
    80001488:	e905                	bnez	a0,800014b8 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000148a:	6785                	lui	a5,0x1
    8000148c:	993e                	add	s2,s2,a5
    8000148e:	fd4968e3          	bltu	s2,s4,8000145e <uvmalloc+0x2c>
  return newsz;
    80001492:	8552                	mv	a0,s4
    80001494:	a809                	j	800014a6 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80001496:	864e                	mv	a2,s3
    80001498:	85ca                	mv	a1,s2
    8000149a:	8556                	mv	a0,s5
    8000149c:	00000097          	auipc	ra,0x0
    800014a0:	f4e080e7          	jalr	-178(ra) # 800013ea <uvmdealloc>
      return 0;
    800014a4:	4501                	li	a0,0
}
    800014a6:	70e2                	ld	ra,56(sp)
    800014a8:	7442                	ld	s0,48(sp)
    800014aa:	74a2                	ld	s1,40(sp)
    800014ac:	7902                	ld	s2,32(sp)
    800014ae:	69e2                	ld	s3,24(sp)
    800014b0:	6a42                	ld	s4,16(sp)
    800014b2:	6aa2                	ld	s5,8(sp)
    800014b4:	6121                	addi	sp,sp,64
    800014b6:	8082                	ret
      kfree(mem);
    800014b8:	8526                	mv	a0,s1
    800014ba:	fffff097          	auipc	ra,0xfffff
    800014be:	560080e7          	jalr	1376(ra) # 80000a1a <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800014c2:	864e                	mv	a2,s3
    800014c4:	85ca                	mv	a1,s2
    800014c6:	8556                	mv	a0,s5
    800014c8:	00000097          	auipc	ra,0x0
    800014cc:	f22080e7          	jalr	-222(ra) # 800013ea <uvmdealloc>
      return 0;
    800014d0:	4501                	li	a0,0
    800014d2:	bfd1                	j	800014a6 <uvmalloc+0x74>
    return oldsz;
    800014d4:	852e                	mv	a0,a1
}
    800014d6:	8082                	ret
  return newsz;
    800014d8:	8532                	mv	a0,a2
    800014da:	b7f1                	j	800014a6 <uvmalloc+0x74>

00000000800014dc <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800014dc:	7179                	addi	sp,sp,-48
    800014de:	f406                	sd	ra,40(sp)
    800014e0:	f022                	sd	s0,32(sp)
    800014e2:	ec26                	sd	s1,24(sp)
    800014e4:	e84a                	sd	s2,16(sp)
    800014e6:	e44e                	sd	s3,8(sp)
    800014e8:	e052                	sd	s4,0(sp)
    800014ea:	1800                	addi	s0,sp,48
    800014ec:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800014ee:	84aa                	mv	s1,a0
    800014f0:	6905                	lui	s2,0x1
    800014f2:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014f4:	4985                	li	s3,1
    800014f6:	a821                	j	8000150e <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800014f8:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800014fa:	0532                	slli	a0,a0,0xc
    800014fc:	00000097          	auipc	ra,0x0
    80001500:	fe0080e7          	jalr	-32(ra) # 800014dc <freewalk>
      pagetable[i] = 0;
    80001504:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001508:	04a1                	addi	s1,s1,8
    8000150a:	03248163          	beq	s1,s2,8000152c <freewalk+0x50>
    pte_t pte = pagetable[i];
    8000150e:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001510:	00f57793          	andi	a5,a0,15
    80001514:	ff3782e3          	beq	a5,s3,800014f8 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001518:	8905                	andi	a0,a0,1
    8000151a:	d57d                	beqz	a0,80001508 <freewalk+0x2c>
      panic("freewalk: leaf");
    8000151c:	00007517          	auipc	a0,0x7
    80001520:	c4450513          	addi	a0,a0,-956 # 80008160 <digits+0x120>
    80001524:	fffff097          	auipc	ra,0xfffff
    80001528:	026080e7          	jalr	38(ra) # 8000054a <panic>
    }
  }
  kfree((void*)pagetable);
    8000152c:	8552                	mv	a0,s4
    8000152e:	fffff097          	auipc	ra,0xfffff
    80001532:	4ec080e7          	jalr	1260(ra) # 80000a1a <kfree>
}
    80001536:	70a2                	ld	ra,40(sp)
    80001538:	7402                	ld	s0,32(sp)
    8000153a:	64e2                	ld	s1,24(sp)
    8000153c:	6942                	ld	s2,16(sp)
    8000153e:	69a2                	ld	s3,8(sp)
    80001540:	6a02                	ld	s4,0(sp)
    80001542:	6145                	addi	sp,sp,48
    80001544:	8082                	ret

0000000080001546 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001546:	1101                	addi	sp,sp,-32
    80001548:	ec06                	sd	ra,24(sp)
    8000154a:	e822                	sd	s0,16(sp)
    8000154c:	e426                	sd	s1,8(sp)
    8000154e:	1000                	addi	s0,sp,32
    80001550:	84aa                	mv	s1,a0
  if(sz > 0)
    80001552:	e999                	bnez	a1,80001568 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001554:	8526                	mv	a0,s1
    80001556:	00000097          	auipc	ra,0x0
    8000155a:	f86080e7          	jalr	-122(ra) # 800014dc <freewalk>
}
    8000155e:	60e2                	ld	ra,24(sp)
    80001560:	6442                	ld	s0,16(sp)
    80001562:	64a2                	ld	s1,8(sp)
    80001564:	6105                	addi	sp,sp,32
    80001566:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001568:	6605                	lui	a2,0x1
    8000156a:	167d                	addi	a2,a2,-1
    8000156c:	962e                	add	a2,a2,a1
    8000156e:	4685                	li	a3,1
    80001570:	8231                	srli	a2,a2,0xc
    80001572:	4581                	li	a1,0
    80001574:	00000097          	auipc	ra,0x0
    80001578:	d12080e7          	jalr	-750(ra) # 80001286 <uvmunmap>
    8000157c:	bfe1                	j	80001554 <uvmfree+0xe>

000000008000157e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000157e:	c679                	beqz	a2,8000164c <uvmcopy+0xce>
{
    80001580:	715d                	addi	sp,sp,-80
    80001582:	e486                	sd	ra,72(sp)
    80001584:	e0a2                	sd	s0,64(sp)
    80001586:	fc26                	sd	s1,56(sp)
    80001588:	f84a                	sd	s2,48(sp)
    8000158a:	f44e                	sd	s3,40(sp)
    8000158c:	f052                	sd	s4,32(sp)
    8000158e:	ec56                	sd	s5,24(sp)
    80001590:	e85a                	sd	s6,16(sp)
    80001592:	e45e                	sd	s7,8(sp)
    80001594:	0880                	addi	s0,sp,80
    80001596:	8b2a                	mv	s6,a0
    80001598:	8aae                	mv	s5,a1
    8000159a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000159c:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    8000159e:	4601                	li	a2,0
    800015a0:	85ce                	mv	a1,s3
    800015a2:	855a                	mv	a0,s6
    800015a4:	00000097          	auipc	ra,0x0
    800015a8:	a46080e7          	jalr	-1466(ra) # 80000fea <walk>
    800015ac:	c531                	beqz	a0,800015f8 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    800015ae:	6118                	ld	a4,0(a0)
    800015b0:	00177793          	andi	a5,a4,1
    800015b4:	cbb1                	beqz	a5,80001608 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800015b6:	00a75593          	srli	a1,a4,0xa
    800015ba:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800015be:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800015c2:	fffff097          	auipc	ra,0xfffff
    800015c6:	554080e7          	jalr	1364(ra) # 80000b16 <kalloc>
    800015ca:	892a                	mv	s2,a0
    800015cc:	c939                	beqz	a0,80001622 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800015ce:	6605                	lui	a2,0x1
    800015d0:	85de                	mv	a1,s7
    800015d2:	fffff097          	auipc	ra,0xfffff
    800015d6:	78c080e7          	jalr	1932(ra) # 80000d5e <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800015da:	8726                	mv	a4,s1
    800015dc:	86ca                	mv	a3,s2
    800015de:	6605                	lui	a2,0x1
    800015e0:	85ce                	mv	a1,s3
    800015e2:	8556                	mv	a0,s5
    800015e4:	00000097          	auipc	ra,0x0
    800015e8:	aee080e7          	jalr	-1298(ra) # 800010d2 <mappages>
    800015ec:	e515                	bnez	a0,80001618 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800015ee:	6785                	lui	a5,0x1
    800015f0:	99be                	add	s3,s3,a5
    800015f2:	fb49e6e3          	bltu	s3,s4,8000159e <uvmcopy+0x20>
    800015f6:	a081                	j	80001636 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    800015f8:	00007517          	auipc	a0,0x7
    800015fc:	b7850513          	addi	a0,a0,-1160 # 80008170 <digits+0x130>
    80001600:	fffff097          	auipc	ra,0xfffff
    80001604:	f4a080e7          	jalr	-182(ra) # 8000054a <panic>
      panic("uvmcopy: page not present");
    80001608:	00007517          	auipc	a0,0x7
    8000160c:	b8850513          	addi	a0,a0,-1144 # 80008190 <digits+0x150>
    80001610:	fffff097          	auipc	ra,0xfffff
    80001614:	f3a080e7          	jalr	-198(ra) # 8000054a <panic>
      kfree(mem);
    80001618:	854a                	mv	a0,s2
    8000161a:	fffff097          	auipc	ra,0xfffff
    8000161e:	400080e7          	jalr	1024(ra) # 80000a1a <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001622:	4685                	li	a3,1
    80001624:	00c9d613          	srli	a2,s3,0xc
    80001628:	4581                	li	a1,0
    8000162a:	8556                	mv	a0,s5
    8000162c:	00000097          	auipc	ra,0x0
    80001630:	c5a080e7          	jalr	-934(ra) # 80001286 <uvmunmap>
  return -1;
    80001634:	557d                	li	a0,-1
}
    80001636:	60a6                	ld	ra,72(sp)
    80001638:	6406                	ld	s0,64(sp)
    8000163a:	74e2                	ld	s1,56(sp)
    8000163c:	7942                	ld	s2,48(sp)
    8000163e:	79a2                	ld	s3,40(sp)
    80001640:	7a02                	ld	s4,32(sp)
    80001642:	6ae2                	ld	s5,24(sp)
    80001644:	6b42                	ld	s6,16(sp)
    80001646:	6ba2                	ld	s7,8(sp)
    80001648:	6161                	addi	sp,sp,80
    8000164a:	8082                	ret
  return 0;
    8000164c:	4501                	li	a0,0
}
    8000164e:	8082                	ret

0000000080001650 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001650:	1141                	addi	sp,sp,-16
    80001652:	e406                	sd	ra,8(sp)
    80001654:	e022                	sd	s0,0(sp)
    80001656:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001658:	4601                	li	a2,0
    8000165a:	00000097          	auipc	ra,0x0
    8000165e:	990080e7          	jalr	-1648(ra) # 80000fea <walk>
  if(pte == 0)
    80001662:	c901                	beqz	a0,80001672 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001664:	611c                	ld	a5,0(a0)
    80001666:	9bbd                	andi	a5,a5,-17
    80001668:	e11c                	sd	a5,0(a0)
}
    8000166a:	60a2                	ld	ra,8(sp)
    8000166c:	6402                	ld	s0,0(sp)
    8000166e:	0141                	addi	sp,sp,16
    80001670:	8082                	ret
    panic("uvmclear");
    80001672:	00007517          	auipc	a0,0x7
    80001676:	b3e50513          	addi	a0,a0,-1218 # 800081b0 <digits+0x170>
    8000167a:	fffff097          	auipc	ra,0xfffff
    8000167e:	ed0080e7          	jalr	-304(ra) # 8000054a <panic>

0000000080001682 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001682:	c6bd                	beqz	a3,800016f0 <copyout+0x6e>
{
    80001684:	715d                	addi	sp,sp,-80
    80001686:	e486                	sd	ra,72(sp)
    80001688:	e0a2                	sd	s0,64(sp)
    8000168a:	fc26                	sd	s1,56(sp)
    8000168c:	f84a                	sd	s2,48(sp)
    8000168e:	f44e                	sd	s3,40(sp)
    80001690:	f052                	sd	s4,32(sp)
    80001692:	ec56                	sd	s5,24(sp)
    80001694:	e85a                	sd	s6,16(sp)
    80001696:	e45e                	sd	s7,8(sp)
    80001698:	e062                	sd	s8,0(sp)
    8000169a:	0880                	addi	s0,sp,80
    8000169c:	8b2a                	mv	s6,a0
    8000169e:	8c2e                	mv	s8,a1
    800016a0:	8a32                	mv	s4,a2
    800016a2:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800016a4:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    800016a6:	6a85                	lui	s5,0x1
    800016a8:	a015                	j	800016cc <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800016aa:	9562                	add	a0,a0,s8
    800016ac:	0004861b          	sext.w	a2,s1
    800016b0:	85d2                	mv	a1,s4
    800016b2:	41250533          	sub	a0,a0,s2
    800016b6:	fffff097          	auipc	ra,0xfffff
    800016ba:	6a8080e7          	jalr	1704(ra) # 80000d5e <memmove>

    len -= n;
    800016be:	409989b3          	sub	s3,s3,s1
    src += n;
    800016c2:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    800016c4:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800016c8:	02098263          	beqz	s3,800016ec <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    800016cc:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800016d0:	85ca                	mv	a1,s2
    800016d2:	855a                	mv	a0,s6
    800016d4:	00000097          	auipc	ra,0x0
    800016d8:	9bc080e7          	jalr	-1604(ra) # 80001090 <walkaddr>
    if(pa0 == 0)
    800016dc:	cd01                	beqz	a0,800016f4 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    800016de:	418904b3          	sub	s1,s2,s8
    800016e2:	94d6                	add	s1,s1,s5
    if(n > len)
    800016e4:	fc99f3e3          	bgeu	s3,s1,800016aa <copyout+0x28>
    800016e8:	84ce                	mv	s1,s3
    800016ea:	b7c1                	j	800016aa <copyout+0x28>
  }
  return 0;
    800016ec:	4501                	li	a0,0
    800016ee:	a021                	j	800016f6 <copyout+0x74>
    800016f0:	4501                	li	a0,0
}
    800016f2:	8082                	ret
      return -1;
    800016f4:	557d                	li	a0,-1
}
    800016f6:	60a6                	ld	ra,72(sp)
    800016f8:	6406                	ld	s0,64(sp)
    800016fa:	74e2                	ld	s1,56(sp)
    800016fc:	7942                	ld	s2,48(sp)
    800016fe:	79a2                	ld	s3,40(sp)
    80001700:	7a02                	ld	s4,32(sp)
    80001702:	6ae2                	ld	s5,24(sp)
    80001704:	6b42                	ld	s6,16(sp)
    80001706:	6ba2                	ld	s7,8(sp)
    80001708:	6c02                	ld	s8,0(sp)
    8000170a:	6161                	addi	sp,sp,80
    8000170c:	8082                	ret

000000008000170e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000170e:	caa5                	beqz	a3,8000177e <copyin+0x70>
{
    80001710:	715d                	addi	sp,sp,-80
    80001712:	e486                	sd	ra,72(sp)
    80001714:	e0a2                	sd	s0,64(sp)
    80001716:	fc26                	sd	s1,56(sp)
    80001718:	f84a                	sd	s2,48(sp)
    8000171a:	f44e                	sd	s3,40(sp)
    8000171c:	f052                	sd	s4,32(sp)
    8000171e:	ec56                	sd	s5,24(sp)
    80001720:	e85a                	sd	s6,16(sp)
    80001722:	e45e                	sd	s7,8(sp)
    80001724:	e062                	sd	s8,0(sp)
    80001726:	0880                	addi	s0,sp,80
    80001728:	8b2a                	mv	s6,a0
    8000172a:	8a2e                	mv	s4,a1
    8000172c:	8c32                	mv	s8,a2
    8000172e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001730:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001732:	6a85                	lui	s5,0x1
    80001734:	a01d                	j	8000175a <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001736:	018505b3          	add	a1,a0,s8
    8000173a:	0004861b          	sext.w	a2,s1
    8000173e:	412585b3          	sub	a1,a1,s2
    80001742:	8552                	mv	a0,s4
    80001744:	fffff097          	auipc	ra,0xfffff
    80001748:	61a080e7          	jalr	1562(ra) # 80000d5e <memmove>

    len -= n;
    8000174c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001750:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001752:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001756:	02098263          	beqz	s3,8000177a <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    8000175a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000175e:	85ca                	mv	a1,s2
    80001760:	855a                	mv	a0,s6
    80001762:	00000097          	auipc	ra,0x0
    80001766:	92e080e7          	jalr	-1746(ra) # 80001090 <walkaddr>
    if(pa0 == 0)
    8000176a:	cd01                	beqz	a0,80001782 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    8000176c:	418904b3          	sub	s1,s2,s8
    80001770:	94d6                	add	s1,s1,s5
    if(n > len)
    80001772:	fc99f2e3          	bgeu	s3,s1,80001736 <copyin+0x28>
    80001776:	84ce                	mv	s1,s3
    80001778:	bf7d                	j	80001736 <copyin+0x28>
  }
  return 0;
    8000177a:	4501                	li	a0,0
    8000177c:	a021                	j	80001784 <copyin+0x76>
    8000177e:	4501                	li	a0,0
}
    80001780:	8082                	ret
      return -1;
    80001782:	557d                	li	a0,-1
}
    80001784:	60a6                	ld	ra,72(sp)
    80001786:	6406                	ld	s0,64(sp)
    80001788:	74e2                	ld	s1,56(sp)
    8000178a:	7942                	ld	s2,48(sp)
    8000178c:	79a2                	ld	s3,40(sp)
    8000178e:	7a02                	ld	s4,32(sp)
    80001790:	6ae2                	ld	s5,24(sp)
    80001792:	6b42                	ld	s6,16(sp)
    80001794:	6ba2                	ld	s7,8(sp)
    80001796:	6c02                	ld	s8,0(sp)
    80001798:	6161                	addi	sp,sp,80
    8000179a:	8082                	ret

000000008000179c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    8000179c:	c6c5                	beqz	a3,80001844 <copyinstr+0xa8>
{
    8000179e:	715d                	addi	sp,sp,-80
    800017a0:	e486                	sd	ra,72(sp)
    800017a2:	e0a2                	sd	s0,64(sp)
    800017a4:	fc26                	sd	s1,56(sp)
    800017a6:	f84a                	sd	s2,48(sp)
    800017a8:	f44e                	sd	s3,40(sp)
    800017aa:	f052                	sd	s4,32(sp)
    800017ac:	ec56                	sd	s5,24(sp)
    800017ae:	e85a                	sd	s6,16(sp)
    800017b0:	e45e                	sd	s7,8(sp)
    800017b2:	0880                	addi	s0,sp,80
    800017b4:	8a2a                	mv	s4,a0
    800017b6:	8b2e                	mv	s6,a1
    800017b8:	8bb2                	mv	s7,a2
    800017ba:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    800017bc:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017be:	6985                	lui	s3,0x1
    800017c0:	a035                	j	800017ec <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800017c2:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800017c6:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800017c8:	0017b793          	seqz	a5,a5
    800017cc:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800017d0:	60a6                	ld	ra,72(sp)
    800017d2:	6406                	ld	s0,64(sp)
    800017d4:	74e2                	ld	s1,56(sp)
    800017d6:	7942                	ld	s2,48(sp)
    800017d8:	79a2                	ld	s3,40(sp)
    800017da:	7a02                	ld	s4,32(sp)
    800017dc:	6ae2                	ld	s5,24(sp)
    800017de:	6b42                	ld	s6,16(sp)
    800017e0:	6ba2                	ld	s7,8(sp)
    800017e2:	6161                	addi	sp,sp,80
    800017e4:	8082                	ret
    srcva = va0 + PGSIZE;
    800017e6:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800017ea:	c8a9                	beqz	s1,8000183c <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    800017ec:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800017f0:	85ca                	mv	a1,s2
    800017f2:	8552                	mv	a0,s4
    800017f4:	00000097          	auipc	ra,0x0
    800017f8:	89c080e7          	jalr	-1892(ra) # 80001090 <walkaddr>
    if(pa0 == 0)
    800017fc:	c131                	beqz	a0,80001840 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    800017fe:	41790833          	sub	a6,s2,s7
    80001802:	984e                	add	a6,a6,s3
    if(n > max)
    80001804:	0104f363          	bgeu	s1,a6,8000180a <copyinstr+0x6e>
    80001808:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    8000180a:	955e                	add	a0,a0,s7
    8000180c:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80001810:	fc080be3          	beqz	a6,800017e6 <copyinstr+0x4a>
    80001814:	985a                	add	a6,a6,s6
    80001816:	87da                	mv	a5,s6
      if(*p == '\0'){
    80001818:	41650633          	sub	a2,a0,s6
    8000181c:	14fd                	addi	s1,s1,-1
    8000181e:	9b26                	add	s6,s6,s1
    80001820:	00f60733          	add	a4,a2,a5
    80001824:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd9000>
    80001828:	df49                	beqz	a4,800017c2 <copyinstr+0x26>
        *dst = *p;
    8000182a:	00e78023          	sb	a4,0(a5)
      --max;
    8000182e:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80001832:	0785                	addi	a5,a5,1
    while(n > 0){
    80001834:	ff0796e3          	bne	a5,a6,80001820 <copyinstr+0x84>
      dst++;
    80001838:	8b42                	mv	s6,a6
    8000183a:	b775                	j	800017e6 <copyinstr+0x4a>
    8000183c:	4781                	li	a5,0
    8000183e:	b769                	j	800017c8 <copyinstr+0x2c>
      return -1;
    80001840:	557d                	li	a0,-1
    80001842:	b779                	j	800017d0 <copyinstr+0x34>
  int got_null = 0;
    80001844:	4781                	li	a5,0
  if(got_null){
    80001846:	0017b793          	seqz	a5,a5
    8000184a:	40f00533          	neg	a0,a5
}
    8000184e:	8082                	ret

0000000080001850 <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    80001850:	1101                	addi	sp,sp,-32
    80001852:	ec06                	sd	ra,24(sp)
    80001854:	e822                	sd	s0,16(sp)
    80001856:	e426                	sd	s1,8(sp)
    80001858:	1000                	addi	s0,sp,32
    8000185a:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000185c:	fffff097          	auipc	ra,0xfffff
    80001860:	330080e7          	jalr	816(ra) # 80000b8c <holding>
    80001864:	c909                	beqz	a0,80001876 <wakeup1+0x26>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    80001866:	749c                	ld	a5,40(s1)
    80001868:	00978f63          	beq	a5,s1,80001886 <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    8000186c:	60e2                	ld	ra,24(sp)
    8000186e:	6442                	ld	s0,16(sp)
    80001870:	64a2                	ld	s1,8(sp)
    80001872:	6105                	addi	sp,sp,32
    80001874:	8082                	ret
    panic("wakeup1");
    80001876:	00007517          	auipc	a0,0x7
    8000187a:	94a50513          	addi	a0,a0,-1718 # 800081c0 <digits+0x180>
    8000187e:	fffff097          	auipc	ra,0xfffff
    80001882:	ccc080e7          	jalr	-820(ra) # 8000054a <panic>
  if(p->chan == p && p->state == SLEEPING) {
    80001886:	4c98                	lw	a4,24(s1)
    80001888:	4785                	li	a5,1
    8000188a:	fef711e3          	bne	a4,a5,8000186c <wakeup1+0x1c>
    p->state = RUNNABLE;
    8000188e:	4789                	li	a5,2
    80001890:	cc9c                	sw	a5,24(s1)
}
    80001892:	bfe9                	j	8000186c <wakeup1+0x1c>

0000000080001894 <proc_mapstacks>:
proc_mapstacks(pagetable_t kpgtbl) {
    80001894:	7139                	addi	sp,sp,-64
    80001896:	fc06                	sd	ra,56(sp)
    80001898:	f822                	sd	s0,48(sp)
    8000189a:	f426                	sd	s1,40(sp)
    8000189c:	f04a                	sd	s2,32(sp)
    8000189e:	ec4e                	sd	s3,24(sp)
    800018a0:	e852                	sd	s4,16(sp)
    800018a2:	e456                	sd	s5,8(sp)
    800018a4:	e05a                	sd	s6,0(sp)
    800018a6:	0080                	addi	s0,sp,64
    800018a8:	89aa                	mv	s3,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    800018aa:	00010497          	auipc	s1,0x10
    800018ae:	dfe48493          	addi	s1,s1,-514 # 800116a8 <proc>
    uint64 va = KSTACK((int) (p - proc));
    800018b2:	8b26                	mv	s6,s1
    800018b4:	00006a97          	auipc	s5,0x6
    800018b8:	74ca8a93          	addi	s5,s5,1868 # 80008000 <etext>
    800018bc:	04000937          	lui	s2,0x4000
    800018c0:	197d                	addi	s2,s2,-1
    800018c2:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800018c4:	00015a17          	auipc	s4,0x15
    800018c8:	7e4a0a13          	addi	s4,s4,2020 # 800170a8 <tickslock>
    char *pa = kalloc();
    800018cc:	fffff097          	auipc	ra,0xfffff
    800018d0:	24a080e7          	jalr	586(ra) # 80000b16 <kalloc>
    800018d4:	862a                	mv	a2,a0
    if(pa == 0)
    800018d6:	c131                	beqz	a0,8000191a <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    800018d8:	416485b3          	sub	a1,s1,s6
    800018dc:	858d                	srai	a1,a1,0x3
    800018de:	000ab783          	ld	a5,0(s5)
    800018e2:	02f585b3          	mul	a1,a1,a5
    800018e6:	2585                	addiw	a1,a1,1
    800018e8:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800018ec:	4719                	li	a4,6
    800018ee:	6685                	lui	a3,0x1
    800018f0:	40b905b3          	sub	a1,s2,a1
    800018f4:	854e                	mv	a0,s3
    800018f6:	00000097          	auipc	ra,0x0
    800018fa:	86a080e7          	jalr	-1942(ra) # 80001160 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800018fe:	16848493          	addi	s1,s1,360
    80001902:	fd4495e3          	bne	s1,s4,800018cc <proc_mapstacks+0x38>
}
    80001906:	70e2                	ld	ra,56(sp)
    80001908:	7442                	ld	s0,48(sp)
    8000190a:	74a2                	ld	s1,40(sp)
    8000190c:	7902                	ld	s2,32(sp)
    8000190e:	69e2                	ld	s3,24(sp)
    80001910:	6a42                	ld	s4,16(sp)
    80001912:	6aa2                	ld	s5,8(sp)
    80001914:	6b02                	ld	s6,0(sp)
    80001916:	6121                	addi	sp,sp,64
    80001918:	8082                	ret
      panic("kalloc");
    8000191a:	00007517          	auipc	a0,0x7
    8000191e:	8ae50513          	addi	a0,a0,-1874 # 800081c8 <digits+0x188>
    80001922:	fffff097          	auipc	ra,0xfffff
    80001926:	c28080e7          	jalr	-984(ra) # 8000054a <panic>

000000008000192a <procinit>:
{
    8000192a:	7139                	addi	sp,sp,-64
    8000192c:	fc06                	sd	ra,56(sp)
    8000192e:	f822                	sd	s0,48(sp)
    80001930:	f426                	sd	s1,40(sp)
    80001932:	f04a                	sd	s2,32(sp)
    80001934:	ec4e                	sd	s3,24(sp)
    80001936:	e852                	sd	s4,16(sp)
    80001938:	e456                	sd	s5,8(sp)
    8000193a:	e05a                	sd	s6,0(sp)
    8000193c:	0080                	addi	s0,sp,64
  initlock(&pid_lock, "nextpid");
    8000193e:	00007597          	auipc	a1,0x7
    80001942:	89258593          	addi	a1,a1,-1902 # 800081d0 <digits+0x190>
    80001946:	00010517          	auipc	a0,0x10
    8000194a:	94a50513          	addi	a0,a0,-1718 # 80011290 <pid_lock>
    8000194e:	fffff097          	auipc	ra,0xfffff
    80001952:	228080e7          	jalr	552(ra) # 80000b76 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001956:	00010497          	auipc	s1,0x10
    8000195a:	d5248493          	addi	s1,s1,-686 # 800116a8 <proc>
      initlock(&p->lock, "proc");
    8000195e:	00007b17          	auipc	s6,0x7
    80001962:	87ab0b13          	addi	s6,s6,-1926 # 800081d8 <digits+0x198>
      p->kstack = KSTACK((int) (p - proc));
    80001966:	8aa6                	mv	s5,s1
    80001968:	00006a17          	auipc	s4,0x6
    8000196c:	698a0a13          	addi	s4,s4,1688 # 80008000 <etext>
    80001970:	04000937          	lui	s2,0x4000
    80001974:	197d                	addi	s2,s2,-1
    80001976:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001978:	00015997          	auipc	s3,0x15
    8000197c:	73098993          	addi	s3,s3,1840 # 800170a8 <tickslock>
      initlock(&p->lock, "proc");
    80001980:	85da                	mv	a1,s6
    80001982:	8526                	mv	a0,s1
    80001984:	fffff097          	auipc	ra,0xfffff
    80001988:	1f2080e7          	jalr	498(ra) # 80000b76 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    8000198c:	415487b3          	sub	a5,s1,s5
    80001990:	878d                	srai	a5,a5,0x3
    80001992:	000a3703          	ld	a4,0(s4)
    80001996:	02e787b3          	mul	a5,a5,a4
    8000199a:	2785                	addiw	a5,a5,1
    8000199c:	00d7979b          	slliw	a5,a5,0xd
    800019a0:	40f907b3          	sub	a5,s2,a5
    800019a4:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800019a6:	16848493          	addi	s1,s1,360
    800019aa:	fd349be3          	bne	s1,s3,80001980 <procinit+0x56>
}
    800019ae:	70e2                	ld	ra,56(sp)
    800019b0:	7442                	ld	s0,48(sp)
    800019b2:	74a2                	ld	s1,40(sp)
    800019b4:	7902                	ld	s2,32(sp)
    800019b6:	69e2                	ld	s3,24(sp)
    800019b8:	6a42                	ld	s4,16(sp)
    800019ba:	6aa2                	ld	s5,8(sp)
    800019bc:	6b02                	ld	s6,0(sp)
    800019be:	6121                	addi	sp,sp,64
    800019c0:	8082                	ret

00000000800019c2 <cpuid>:
{
    800019c2:	1141                	addi	sp,sp,-16
    800019c4:	e422                	sd	s0,8(sp)
    800019c6:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800019c8:	8512                	mv	a0,tp
}
    800019ca:	2501                	sext.w	a0,a0
    800019cc:	6422                	ld	s0,8(sp)
    800019ce:	0141                	addi	sp,sp,16
    800019d0:	8082                	ret

00000000800019d2 <mycpu>:
mycpu(void) {
    800019d2:	1141                	addi	sp,sp,-16
    800019d4:	e422                	sd	s0,8(sp)
    800019d6:	0800                	addi	s0,sp,16
    800019d8:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    800019da:	2781                	sext.w	a5,a5
    800019dc:	079e                	slli	a5,a5,0x7
}
    800019de:	00010517          	auipc	a0,0x10
    800019e2:	8ca50513          	addi	a0,a0,-1846 # 800112a8 <cpus>
    800019e6:	953e                	add	a0,a0,a5
    800019e8:	6422                	ld	s0,8(sp)
    800019ea:	0141                	addi	sp,sp,16
    800019ec:	8082                	ret

00000000800019ee <myproc>:
myproc(void) {
    800019ee:	1101                	addi	sp,sp,-32
    800019f0:	ec06                	sd	ra,24(sp)
    800019f2:	e822                	sd	s0,16(sp)
    800019f4:	e426                	sd	s1,8(sp)
    800019f6:	1000                	addi	s0,sp,32
  push_off();
    800019f8:	fffff097          	auipc	ra,0xfffff
    800019fc:	1c2080e7          	jalr	450(ra) # 80000bba <push_off>
    80001a00:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80001a02:	2781                	sext.w	a5,a5
    80001a04:	079e                	slli	a5,a5,0x7
    80001a06:	00010717          	auipc	a4,0x10
    80001a0a:	88a70713          	addi	a4,a4,-1910 # 80011290 <pid_lock>
    80001a0e:	97ba                	add	a5,a5,a4
    80001a10:	6f84                	ld	s1,24(a5)
  pop_off();
    80001a12:	fffff097          	auipc	ra,0xfffff
    80001a16:	248080e7          	jalr	584(ra) # 80000c5a <pop_off>
}
    80001a1a:	8526                	mv	a0,s1
    80001a1c:	60e2                	ld	ra,24(sp)
    80001a1e:	6442                	ld	s0,16(sp)
    80001a20:	64a2                	ld	s1,8(sp)
    80001a22:	6105                	addi	sp,sp,32
    80001a24:	8082                	ret

0000000080001a26 <forkret>:
{
    80001a26:	1141                	addi	sp,sp,-16
    80001a28:	e406                	sd	ra,8(sp)
    80001a2a:	e022                	sd	s0,0(sp)
    80001a2c:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    80001a2e:	00000097          	auipc	ra,0x0
    80001a32:	fc0080e7          	jalr	-64(ra) # 800019ee <myproc>
    80001a36:	fffff097          	auipc	ra,0xfffff
    80001a3a:	284080e7          	jalr	644(ra) # 80000cba <release>
  if (first) {
    80001a3e:	00007797          	auipc	a5,0x7
    80001a42:	dc27a783          	lw	a5,-574(a5) # 80008800 <first.1>
    80001a46:	eb89                	bnez	a5,80001a58 <forkret+0x32>
  usertrapret();
    80001a48:	00001097          	auipc	ra,0x1
    80001a4c:	bf4080e7          	jalr	-1036(ra) # 8000263c <usertrapret>
}
    80001a50:	60a2                	ld	ra,8(sp)
    80001a52:	6402                	ld	s0,0(sp)
    80001a54:	0141                	addi	sp,sp,16
    80001a56:	8082                	ret
    first = 0;
    80001a58:	00007797          	auipc	a5,0x7
    80001a5c:	da07a423          	sw	zero,-600(a5) # 80008800 <first.1>
    fsinit(ROOTDEV);
    80001a60:	4505                	li	a0,1
    80001a62:	00002097          	auipc	ra,0x2
    80001a66:	91a080e7          	jalr	-1766(ra) # 8000337c <fsinit>
    80001a6a:	bff9                	j	80001a48 <forkret+0x22>

0000000080001a6c <allocpid>:
allocpid() {
    80001a6c:	1101                	addi	sp,sp,-32
    80001a6e:	ec06                	sd	ra,24(sp)
    80001a70:	e822                	sd	s0,16(sp)
    80001a72:	e426                	sd	s1,8(sp)
    80001a74:	e04a                	sd	s2,0(sp)
    80001a76:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001a78:	00010917          	auipc	s2,0x10
    80001a7c:	81890913          	addi	s2,s2,-2024 # 80011290 <pid_lock>
    80001a80:	854a                	mv	a0,s2
    80001a82:	fffff097          	auipc	ra,0xfffff
    80001a86:	184080e7          	jalr	388(ra) # 80000c06 <acquire>
  pid = nextpid;
    80001a8a:	00007797          	auipc	a5,0x7
    80001a8e:	d7a78793          	addi	a5,a5,-646 # 80008804 <nextpid>
    80001a92:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a94:	0014871b          	addiw	a4,s1,1
    80001a98:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a9a:	854a                	mv	a0,s2
    80001a9c:	fffff097          	auipc	ra,0xfffff
    80001aa0:	21e080e7          	jalr	542(ra) # 80000cba <release>
}
    80001aa4:	8526                	mv	a0,s1
    80001aa6:	60e2                	ld	ra,24(sp)
    80001aa8:	6442                	ld	s0,16(sp)
    80001aaa:	64a2                	ld	s1,8(sp)
    80001aac:	6902                	ld	s2,0(sp)
    80001aae:	6105                	addi	sp,sp,32
    80001ab0:	8082                	ret

0000000080001ab2 <proc_pagetable>:
{
    80001ab2:	1101                	addi	sp,sp,-32
    80001ab4:	ec06                	sd	ra,24(sp)
    80001ab6:	e822                	sd	s0,16(sp)
    80001ab8:	e426                	sd	s1,8(sp)
    80001aba:	e04a                	sd	s2,0(sp)
    80001abc:	1000                	addi	s0,sp,32
    80001abe:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001ac0:	00000097          	auipc	ra,0x0
    80001ac4:	88a080e7          	jalr	-1910(ra) # 8000134a <uvmcreate>
    80001ac8:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001aca:	c121                	beqz	a0,80001b0a <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001acc:	4729                	li	a4,10
    80001ace:	00005697          	auipc	a3,0x5
    80001ad2:	53268693          	addi	a3,a3,1330 # 80007000 <_trampoline>
    80001ad6:	6605                	lui	a2,0x1
    80001ad8:	040005b7          	lui	a1,0x4000
    80001adc:	15fd                	addi	a1,a1,-1
    80001ade:	05b2                	slli	a1,a1,0xc
    80001ae0:	fffff097          	auipc	ra,0xfffff
    80001ae4:	5f2080e7          	jalr	1522(ra) # 800010d2 <mappages>
    80001ae8:	02054863          	bltz	a0,80001b18 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001aec:	4719                	li	a4,6
    80001aee:	05893683          	ld	a3,88(s2)
    80001af2:	6605                	lui	a2,0x1
    80001af4:	020005b7          	lui	a1,0x2000
    80001af8:	15fd                	addi	a1,a1,-1
    80001afa:	05b6                	slli	a1,a1,0xd
    80001afc:	8526                	mv	a0,s1
    80001afe:	fffff097          	auipc	ra,0xfffff
    80001b02:	5d4080e7          	jalr	1492(ra) # 800010d2 <mappages>
    80001b06:	02054163          	bltz	a0,80001b28 <proc_pagetable+0x76>
}
    80001b0a:	8526                	mv	a0,s1
    80001b0c:	60e2                	ld	ra,24(sp)
    80001b0e:	6442                	ld	s0,16(sp)
    80001b10:	64a2                	ld	s1,8(sp)
    80001b12:	6902                	ld	s2,0(sp)
    80001b14:	6105                	addi	sp,sp,32
    80001b16:	8082                	ret
    uvmfree(pagetable, 0);
    80001b18:	4581                	li	a1,0
    80001b1a:	8526                	mv	a0,s1
    80001b1c:	00000097          	auipc	ra,0x0
    80001b20:	a2a080e7          	jalr	-1494(ra) # 80001546 <uvmfree>
    return 0;
    80001b24:	4481                	li	s1,0
    80001b26:	b7d5                	j	80001b0a <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b28:	4681                	li	a3,0
    80001b2a:	4605                	li	a2,1
    80001b2c:	040005b7          	lui	a1,0x4000
    80001b30:	15fd                	addi	a1,a1,-1
    80001b32:	05b2                	slli	a1,a1,0xc
    80001b34:	8526                	mv	a0,s1
    80001b36:	fffff097          	auipc	ra,0xfffff
    80001b3a:	750080e7          	jalr	1872(ra) # 80001286 <uvmunmap>
    uvmfree(pagetable, 0);
    80001b3e:	4581                	li	a1,0
    80001b40:	8526                	mv	a0,s1
    80001b42:	00000097          	auipc	ra,0x0
    80001b46:	a04080e7          	jalr	-1532(ra) # 80001546 <uvmfree>
    return 0;
    80001b4a:	4481                	li	s1,0
    80001b4c:	bf7d                	j	80001b0a <proc_pagetable+0x58>

0000000080001b4e <proc_freepagetable>:
{
    80001b4e:	1101                	addi	sp,sp,-32
    80001b50:	ec06                	sd	ra,24(sp)
    80001b52:	e822                	sd	s0,16(sp)
    80001b54:	e426                	sd	s1,8(sp)
    80001b56:	e04a                	sd	s2,0(sp)
    80001b58:	1000                	addi	s0,sp,32
    80001b5a:	84aa                	mv	s1,a0
    80001b5c:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b5e:	4681                	li	a3,0
    80001b60:	4605                	li	a2,1
    80001b62:	040005b7          	lui	a1,0x4000
    80001b66:	15fd                	addi	a1,a1,-1
    80001b68:	05b2                	slli	a1,a1,0xc
    80001b6a:	fffff097          	auipc	ra,0xfffff
    80001b6e:	71c080e7          	jalr	1820(ra) # 80001286 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b72:	4681                	li	a3,0
    80001b74:	4605                	li	a2,1
    80001b76:	020005b7          	lui	a1,0x2000
    80001b7a:	15fd                	addi	a1,a1,-1
    80001b7c:	05b6                	slli	a1,a1,0xd
    80001b7e:	8526                	mv	a0,s1
    80001b80:	fffff097          	auipc	ra,0xfffff
    80001b84:	706080e7          	jalr	1798(ra) # 80001286 <uvmunmap>
  uvmfree(pagetable, sz);
    80001b88:	85ca                	mv	a1,s2
    80001b8a:	8526                	mv	a0,s1
    80001b8c:	00000097          	auipc	ra,0x0
    80001b90:	9ba080e7          	jalr	-1606(ra) # 80001546 <uvmfree>
}
    80001b94:	60e2                	ld	ra,24(sp)
    80001b96:	6442                	ld	s0,16(sp)
    80001b98:	64a2                	ld	s1,8(sp)
    80001b9a:	6902                	ld	s2,0(sp)
    80001b9c:	6105                	addi	sp,sp,32
    80001b9e:	8082                	ret

0000000080001ba0 <freeproc>:
{
    80001ba0:	1101                	addi	sp,sp,-32
    80001ba2:	ec06                	sd	ra,24(sp)
    80001ba4:	e822                	sd	s0,16(sp)
    80001ba6:	e426                	sd	s1,8(sp)
    80001ba8:	1000                	addi	s0,sp,32
    80001baa:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001bac:	6d28                	ld	a0,88(a0)
    80001bae:	c509                	beqz	a0,80001bb8 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001bb0:	fffff097          	auipc	ra,0xfffff
    80001bb4:	e6a080e7          	jalr	-406(ra) # 80000a1a <kfree>
  p->trapframe = 0;
    80001bb8:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001bbc:	68a8                	ld	a0,80(s1)
    80001bbe:	c511                	beqz	a0,80001bca <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001bc0:	64ac                	ld	a1,72(s1)
    80001bc2:	00000097          	auipc	ra,0x0
    80001bc6:	f8c080e7          	jalr	-116(ra) # 80001b4e <proc_freepagetable>
  p->pagetable = 0;
    80001bca:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001bce:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001bd2:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001bd6:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80001bda:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001bde:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001be2:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001be6:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001bea:	0004ac23          	sw	zero,24(s1)
}
    80001bee:	60e2                	ld	ra,24(sp)
    80001bf0:	6442                	ld	s0,16(sp)
    80001bf2:	64a2                	ld	s1,8(sp)
    80001bf4:	6105                	addi	sp,sp,32
    80001bf6:	8082                	ret

0000000080001bf8 <allocproc>:
{
    80001bf8:	1101                	addi	sp,sp,-32
    80001bfa:	ec06                	sd	ra,24(sp)
    80001bfc:	e822                	sd	s0,16(sp)
    80001bfe:	e426                	sd	s1,8(sp)
    80001c00:	e04a                	sd	s2,0(sp)
    80001c02:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c04:	00010497          	auipc	s1,0x10
    80001c08:	aa448493          	addi	s1,s1,-1372 # 800116a8 <proc>
    80001c0c:	00015917          	auipc	s2,0x15
    80001c10:	49c90913          	addi	s2,s2,1180 # 800170a8 <tickslock>
    acquire(&p->lock);
    80001c14:	8526                	mv	a0,s1
    80001c16:	fffff097          	auipc	ra,0xfffff
    80001c1a:	ff0080e7          	jalr	-16(ra) # 80000c06 <acquire>
    if(p->state == UNUSED) {
    80001c1e:	4c9c                	lw	a5,24(s1)
    80001c20:	cf81                	beqz	a5,80001c38 <allocproc+0x40>
      release(&p->lock);
    80001c22:	8526                	mv	a0,s1
    80001c24:	fffff097          	auipc	ra,0xfffff
    80001c28:	096080e7          	jalr	150(ra) # 80000cba <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c2c:	16848493          	addi	s1,s1,360
    80001c30:	ff2492e3          	bne	s1,s2,80001c14 <allocproc+0x1c>
  return 0;
    80001c34:	4481                	li	s1,0
    80001c36:	a0b9                	j	80001c84 <allocproc+0x8c>
  p->pid = allocpid();
    80001c38:	00000097          	auipc	ra,0x0
    80001c3c:	e34080e7          	jalr	-460(ra) # 80001a6c <allocpid>
    80001c40:	dc88                	sw	a0,56(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001c42:	fffff097          	auipc	ra,0xfffff
    80001c46:	ed4080e7          	jalr	-300(ra) # 80000b16 <kalloc>
    80001c4a:	892a                	mv	s2,a0
    80001c4c:	eca8                	sd	a0,88(s1)
    80001c4e:	c131                	beqz	a0,80001c92 <allocproc+0x9a>
  p->pagetable = proc_pagetable(p);
    80001c50:	8526                	mv	a0,s1
    80001c52:	00000097          	auipc	ra,0x0
    80001c56:	e60080e7          	jalr	-416(ra) # 80001ab2 <proc_pagetable>
    80001c5a:	892a                	mv	s2,a0
    80001c5c:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001c5e:	c129                	beqz	a0,80001ca0 <allocproc+0xa8>
  memset(&p->context, 0, sizeof(p->context));
    80001c60:	07000613          	li	a2,112
    80001c64:	4581                	li	a1,0
    80001c66:	06048513          	addi	a0,s1,96
    80001c6a:	fffff097          	auipc	ra,0xfffff
    80001c6e:	098080e7          	jalr	152(ra) # 80000d02 <memset>
  p->context.ra = (uint64)forkret;
    80001c72:	00000797          	auipc	a5,0x0
    80001c76:	db478793          	addi	a5,a5,-588 # 80001a26 <forkret>
    80001c7a:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c7c:	60bc                	ld	a5,64(s1)
    80001c7e:	6705                	lui	a4,0x1
    80001c80:	97ba                	add	a5,a5,a4
    80001c82:	f4bc                	sd	a5,104(s1)
}
    80001c84:	8526                	mv	a0,s1
    80001c86:	60e2                	ld	ra,24(sp)
    80001c88:	6442                	ld	s0,16(sp)
    80001c8a:	64a2                	ld	s1,8(sp)
    80001c8c:	6902                	ld	s2,0(sp)
    80001c8e:	6105                	addi	sp,sp,32
    80001c90:	8082                	ret
    release(&p->lock);
    80001c92:	8526                	mv	a0,s1
    80001c94:	fffff097          	auipc	ra,0xfffff
    80001c98:	026080e7          	jalr	38(ra) # 80000cba <release>
    return 0;
    80001c9c:	84ca                	mv	s1,s2
    80001c9e:	b7dd                	j	80001c84 <allocproc+0x8c>
    freeproc(p);
    80001ca0:	8526                	mv	a0,s1
    80001ca2:	00000097          	auipc	ra,0x0
    80001ca6:	efe080e7          	jalr	-258(ra) # 80001ba0 <freeproc>
    release(&p->lock);
    80001caa:	8526                	mv	a0,s1
    80001cac:	fffff097          	auipc	ra,0xfffff
    80001cb0:	00e080e7          	jalr	14(ra) # 80000cba <release>
    return 0;
    80001cb4:	84ca                	mv	s1,s2
    80001cb6:	b7f9                	j	80001c84 <allocproc+0x8c>

0000000080001cb8 <userinit>:
{
    80001cb8:	1101                	addi	sp,sp,-32
    80001cba:	ec06                	sd	ra,24(sp)
    80001cbc:	e822                	sd	s0,16(sp)
    80001cbe:	e426                	sd	s1,8(sp)
    80001cc0:	1000                	addi	s0,sp,32
  p = allocproc();
    80001cc2:	00000097          	auipc	ra,0x0
    80001cc6:	f36080e7          	jalr	-202(ra) # 80001bf8 <allocproc>
    80001cca:	84aa                	mv	s1,a0
  initproc = p;
    80001ccc:	00007797          	auipc	a5,0x7
    80001cd0:	34a7b623          	sd	a0,844(a5) # 80009018 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001cd4:	03400613          	li	a2,52
    80001cd8:	00007597          	auipc	a1,0x7
    80001cdc:	b3858593          	addi	a1,a1,-1224 # 80008810 <initcode>
    80001ce0:	6928                	ld	a0,80(a0)
    80001ce2:	fffff097          	auipc	ra,0xfffff
    80001ce6:	696080e7          	jalr	1686(ra) # 80001378 <uvminit>
  p->sz = PGSIZE;
    80001cea:	6785                	lui	a5,0x1
    80001cec:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001cee:	6cb8                	ld	a4,88(s1)
    80001cf0:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001cf4:	6cb8                	ld	a4,88(s1)
    80001cf6:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001cf8:	4641                	li	a2,16
    80001cfa:	00006597          	auipc	a1,0x6
    80001cfe:	4e658593          	addi	a1,a1,1254 # 800081e0 <digits+0x1a0>
    80001d02:	15848513          	addi	a0,s1,344
    80001d06:	fffff097          	auipc	ra,0xfffff
    80001d0a:	14e080e7          	jalr	334(ra) # 80000e54 <safestrcpy>
  p->cwd = namei("/");
    80001d0e:	00006517          	auipc	a0,0x6
    80001d12:	4e250513          	addi	a0,a0,1250 # 800081f0 <digits+0x1b0>
    80001d16:	00002097          	auipc	ra,0x2
    80001d1a:	092080e7          	jalr	146(ra) # 80003da8 <namei>
    80001d1e:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001d22:	4789                	li	a5,2
    80001d24:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001d26:	8526                	mv	a0,s1
    80001d28:	fffff097          	auipc	ra,0xfffff
    80001d2c:	f92080e7          	jalr	-110(ra) # 80000cba <release>
}
    80001d30:	60e2                	ld	ra,24(sp)
    80001d32:	6442                	ld	s0,16(sp)
    80001d34:	64a2                	ld	s1,8(sp)
    80001d36:	6105                	addi	sp,sp,32
    80001d38:	8082                	ret

0000000080001d3a <growproc>:
{
    80001d3a:	1101                	addi	sp,sp,-32
    80001d3c:	ec06                	sd	ra,24(sp)
    80001d3e:	e822                	sd	s0,16(sp)
    80001d40:	e426                	sd	s1,8(sp)
    80001d42:	e04a                	sd	s2,0(sp)
    80001d44:	1000                	addi	s0,sp,32
    80001d46:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001d48:	00000097          	auipc	ra,0x0
    80001d4c:	ca6080e7          	jalr	-858(ra) # 800019ee <myproc>
    80001d50:	892a                	mv	s2,a0
  sz = p->sz;
    80001d52:	652c                	ld	a1,72(a0)
    80001d54:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001d58:	00904f63          	bgtz	s1,80001d76 <growproc+0x3c>
  } else if(n < 0){
    80001d5c:	0204cc63          	bltz	s1,80001d94 <growproc+0x5a>
  p->sz = sz;
    80001d60:	1602                	slli	a2,a2,0x20
    80001d62:	9201                	srli	a2,a2,0x20
    80001d64:	04c93423          	sd	a2,72(s2)
  return 0;
    80001d68:	4501                	li	a0,0
}
    80001d6a:	60e2                	ld	ra,24(sp)
    80001d6c:	6442                	ld	s0,16(sp)
    80001d6e:	64a2                	ld	s1,8(sp)
    80001d70:	6902                	ld	s2,0(sp)
    80001d72:	6105                	addi	sp,sp,32
    80001d74:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001d76:	9e25                	addw	a2,a2,s1
    80001d78:	1602                	slli	a2,a2,0x20
    80001d7a:	9201                	srli	a2,a2,0x20
    80001d7c:	1582                	slli	a1,a1,0x20
    80001d7e:	9181                	srli	a1,a1,0x20
    80001d80:	6928                	ld	a0,80(a0)
    80001d82:	fffff097          	auipc	ra,0xfffff
    80001d86:	6b0080e7          	jalr	1712(ra) # 80001432 <uvmalloc>
    80001d8a:	0005061b          	sext.w	a2,a0
    80001d8e:	fa69                	bnez	a2,80001d60 <growproc+0x26>
      return -1;
    80001d90:	557d                	li	a0,-1
    80001d92:	bfe1                	j	80001d6a <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001d94:	9e25                	addw	a2,a2,s1
    80001d96:	1602                	slli	a2,a2,0x20
    80001d98:	9201                	srli	a2,a2,0x20
    80001d9a:	1582                	slli	a1,a1,0x20
    80001d9c:	9181                	srli	a1,a1,0x20
    80001d9e:	6928                	ld	a0,80(a0)
    80001da0:	fffff097          	auipc	ra,0xfffff
    80001da4:	64a080e7          	jalr	1610(ra) # 800013ea <uvmdealloc>
    80001da8:	0005061b          	sext.w	a2,a0
    80001dac:	bf55                	j	80001d60 <growproc+0x26>

0000000080001dae <fork>:
{
    80001dae:	7139                	addi	sp,sp,-64
    80001db0:	fc06                	sd	ra,56(sp)
    80001db2:	f822                	sd	s0,48(sp)
    80001db4:	f426                	sd	s1,40(sp)
    80001db6:	f04a                	sd	s2,32(sp)
    80001db8:	ec4e                	sd	s3,24(sp)
    80001dba:	e852                	sd	s4,16(sp)
    80001dbc:	e456                	sd	s5,8(sp)
    80001dbe:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001dc0:	00000097          	auipc	ra,0x0
    80001dc4:	c2e080e7          	jalr	-978(ra) # 800019ee <myproc>
    80001dc8:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001dca:	00000097          	auipc	ra,0x0
    80001dce:	e2e080e7          	jalr	-466(ra) # 80001bf8 <allocproc>
    80001dd2:	c17d                	beqz	a0,80001eb8 <fork+0x10a>
    80001dd4:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001dd6:	048ab603          	ld	a2,72(s5)
    80001dda:	692c                	ld	a1,80(a0)
    80001ddc:	050ab503          	ld	a0,80(s5)
    80001de0:	fffff097          	auipc	ra,0xfffff
    80001de4:	79e080e7          	jalr	1950(ra) # 8000157e <uvmcopy>
    80001de8:	04054a63          	bltz	a0,80001e3c <fork+0x8e>
  np->sz = p->sz;
    80001dec:	048ab783          	ld	a5,72(s5)
    80001df0:	04fa3423          	sd	a5,72(s4)
  np->parent = p;
    80001df4:	035a3023          	sd	s5,32(s4)
  *(np->trapframe) = *(p->trapframe);
    80001df8:	058ab683          	ld	a3,88(s5)
    80001dfc:	87b6                	mv	a5,a3
    80001dfe:	058a3703          	ld	a4,88(s4)
    80001e02:	12068693          	addi	a3,a3,288
    80001e06:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001e0a:	6788                	ld	a0,8(a5)
    80001e0c:	6b8c                	ld	a1,16(a5)
    80001e0e:	6f90                	ld	a2,24(a5)
    80001e10:	01073023          	sd	a6,0(a4)
    80001e14:	e708                	sd	a0,8(a4)
    80001e16:	eb0c                	sd	a1,16(a4)
    80001e18:	ef10                	sd	a2,24(a4)
    80001e1a:	02078793          	addi	a5,a5,32
    80001e1e:	02070713          	addi	a4,a4,32
    80001e22:	fed792e3          	bne	a5,a3,80001e06 <fork+0x58>
  np->trapframe->a0 = 0;
    80001e26:	058a3783          	ld	a5,88(s4)
    80001e2a:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001e2e:	0d0a8493          	addi	s1,s5,208
    80001e32:	0d0a0913          	addi	s2,s4,208
    80001e36:	150a8993          	addi	s3,s5,336
    80001e3a:	a00d                	j	80001e5c <fork+0xae>
    freeproc(np);
    80001e3c:	8552                	mv	a0,s4
    80001e3e:	00000097          	auipc	ra,0x0
    80001e42:	d62080e7          	jalr	-670(ra) # 80001ba0 <freeproc>
    release(&np->lock);
    80001e46:	8552                	mv	a0,s4
    80001e48:	fffff097          	auipc	ra,0xfffff
    80001e4c:	e72080e7          	jalr	-398(ra) # 80000cba <release>
    return -1;
    80001e50:	54fd                	li	s1,-1
    80001e52:	a889                	j	80001ea4 <fork+0xf6>
  for(i = 0; i < NOFILE; i++)
    80001e54:	04a1                	addi	s1,s1,8
    80001e56:	0921                	addi	s2,s2,8
    80001e58:	01348b63          	beq	s1,s3,80001e6e <fork+0xc0>
    if(p->ofile[i])
    80001e5c:	6088                	ld	a0,0(s1)
    80001e5e:	d97d                	beqz	a0,80001e54 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001e60:	00002097          	auipc	ra,0x2
    80001e64:	5e6080e7          	jalr	1510(ra) # 80004446 <filedup>
    80001e68:	00a93023          	sd	a0,0(s2)
    80001e6c:	b7e5                	j	80001e54 <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001e6e:	150ab503          	ld	a0,336(s5)
    80001e72:	00001097          	auipc	ra,0x1
    80001e76:	744080e7          	jalr	1860(ra) # 800035b6 <idup>
    80001e7a:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001e7e:	4641                	li	a2,16
    80001e80:	158a8593          	addi	a1,s5,344
    80001e84:	158a0513          	addi	a0,s4,344
    80001e88:	fffff097          	auipc	ra,0xfffff
    80001e8c:	fcc080e7          	jalr	-52(ra) # 80000e54 <safestrcpy>
  pid = np->pid;
    80001e90:	038a2483          	lw	s1,56(s4)
  np->state = RUNNABLE;
    80001e94:	4789                	li	a5,2
    80001e96:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001e9a:	8552                	mv	a0,s4
    80001e9c:	fffff097          	auipc	ra,0xfffff
    80001ea0:	e1e080e7          	jalr	-482(ra) # 80000cba <release>
}
    80001ea4:	8526                	mv	a0,s1
    80001ea6:	70e2                	ld	ra,56(sp)
    80001ea8:	7442                	ld	s0,48(sp)
    80001eaa:	74a2                	ld	s1,40(sp)
    80001eac:	7902                	ld	s2,32(sp)
    80001eae:	69e2                	ld	s3,24(sp)
    80001eb0:	6a42                	ld	s4,16(sp)
    80001eb2:	6aa2                	ld	s5,8(sp)
    80001eb4:	6121                	addi	sp,sp,64
    80001eb6:	8082                	ret
    return -1;
    80001eb8:	54fd                	li	s1,-1
    80001eba:	b7ed                	j	80001ea4 <fork+0xf6>

0000000080001ebc <reparent>:
{
    80001ebc:	7179                	addi	sp,sp,-48
    80001ebe:	f406                	sd	ra,40(sp)
    80001ec0:	f022                	sd	s0,32(sp)
    80001ec2:	ec26                	sd	s1,24(sp)
    80001ec4:	e84a                	sd	s2,16(sp)
    80001ec6:	e44e                	sd	s3,8(sp)
    80001ec8:	e052                	sd	s4,0(sp)
    80001eca:	1800                	addi	s0,sp,48
    80001ecc:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ece:	0000f497          	auipc	s1,0xf
    80001ed2:	7da48493          	addi	s1,s1,2010 # 800116a8 <proc>
      pp->parent = initproc;
    80001ed6:	00007a17          	auipc	s4,0x7
    80001eda:	142a0a13          	addi	s4,s4,322 # 80009018 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ede:	00015997          	auipc	s3,0x15
    80001ee2:	1ca98993          	addi	s3,s3,458 # 800170a8 <tickslock>
    80001ee6:	a029                	j	80001ef0 <reparent+0x34>
    80001ee8:	16848493          	addi	s1,s1,360
    80001eec:	03348363          	beq	s1,s3,80001f12 <reparent+0x56>
    if(pp->parent == p){
    80001ef0:	709c                	ld	a5,32(s1)
    80001ef2:	ff279be3          	bne	a5,s2,80001ee8 <reparent+0x2c>
      acquire(&pp->lock);
    80001ef6:	8526                	mv	a0,s1
    80001ef8:	fffff097          	auipc	ra,0xfffff
    80001efc:	d0e080e7          	jalr	-754(ra) # 80000c06 <acquire>
      pp->parent = initproc;
    80001f00:	000a3783          	ld	a5,0(s4)
    80001f04:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    80001f06:	8526                	mv	a0,s1
    80001f08:	fffff097          	auipc	ra,0xfffff
    80001f0c:	db2080e7          	jalr	-590(ra) # 80000cba <release>
    80001f10:	bfe1                	j	80001ee8 <reparent+0x2c>
}
    80001f12:	70a2                	ld	ra,40(sp)
    80001f14:	7402                	ld	s0,32(sp)
    80001f16:	64e2                	ld	s1,24(sp)
    80001f18:	6942                	ld	s2,16(sp)
    80001f1a:	69a2                	ld	s3,8(sp)
    80001f1c:	6a02                	ld	s4,0(sp)
    80001f1e:	6145                	addi	sp,sp,48
    80001f20:	8082                	ret

0000000080001f22 <scheduler>:
{
    80001f22:	7139                	addi	sp,sp,-64
    80001f24:	fc06                	sd	ra,56(sp)
    80001f26:	f822                	sd	s0,48(sp)
    80001f28:	f426                	sd	s1,40(sp)
    80001f2a:	f04a                	sd	s2,32(sp)
    80001f2c:	ec4e                	sd	s3,24(sp)
    80001f2e:	e852                	sd	s4,16(sp)
    80001f30:	e456                	sd	s5,8(sp)
    80001f32:	e05a                	sd	s6,0(sp)
    80001f34:	0080                	addi	s0,sp,64
    80001f36:	8792                	mv	a5,tp
  int id = r_tp();
    80001f38:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001f3a:	00779a93          	slli	s5,a5,0x7
    80001f3e:	0000f717          	auipc	a4,0xf
    80001f42:	35270713          	addi	a4,a4,850 # 80011290 <pid_lock>
    80001f46:	9756                	add	a4,a4,s5
    80001f48:	00073c23          	sd	zero,24(a4)
        swtch(&c->context, &p->context);
    80001f4c:	0000f717          	auipc	a4,0xf
    80001f50:	36470713          	addi	a4,a4,868 # 800112b0 <cpus+0x8>
    80001f54:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001f56:	4989                	li	s3,2
        p->state = RUNNING;
    80001f58:	4b0d                	li	s6,3
        c->proc = p;
    80001f5a:	079e                	slli	a5,a5,0x7
    80001f5c:	0000fa17          	auipc	s4,0xf
    80001f60:	334a0a13          	addi	s4,s4,820 # 80011290 <pid_lock>
    80001f64:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f66:	00015917          	auipc	s2,0x15
    80001f6a:	14290913          	addi	s2,s2,322 # 800170a8 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f6e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f72:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f76:	10079073          	csrw	sstatus,a5
    80001f7a:	0000f497          	auipc	s1,0xf
    80001f7e:	72e48493          	addi	s1,s1,1838 # 800116a8 <proc>
    80001f82:	a811                	j	80001f96 <scheduler+0x74>
      release(&p->lock);
    80001f84:	8526                	mv	a0,s1
    80001f86:	fffff097          	auipc	ra,0xfffff
    80001f8a:	d34080e7          	jalr	-716(ra) # 80000cba <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f8e:	16848493          	addi	s1,s1,360
    80001f92:	fd248ee3          	beq	s1,s2,80001f6e <scheduler+0x4c>
      acquire(&p->lock);
    80001f96:	8526                	mv	a0,s1
    80001f98:	fffff097          	auipc	ra,0xfffff
    80001f9c:	c6e080e7          	jalr	-914(ra) # 80000c06 <acquire>
      if(p->state == RUNNABLE) {
    80001fa0:	4c9c                	lw	a5,24(s1)
    80001fa2:	ff3791e3          	bne	a5,s3,80001f84 <scheduler+0x62>
        p->state = RUNNING;
    80001fa6:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001faa:	009a3c23          	sd	s1,24(s4)
        swtch(&c->context, &p->context);
    80001fae:	06048593          	addi	a1,s1,96
    80001fb2:	8556                	mv	a0,s5
    80001fb4:	00000097          	auipc	ra,0x0
    80001fb8:	5de080e7          	jalr	1502(ra) # 80002592 <swtch>
        c->proc = 0;
    80001fbc:	000a3c23          	sd	zero,24(s4)
    80001fc0:	b7d1                	j	80001f84 <scheduler+0x62>

0000000080001fc2 <sched>:
{
    80001fc2:	7179                	addi	sp,sp,-48
    80001fc4:	f406                	sd	ra,40(sp)
    80001fc6:	f022                	sd	s0,32(sp)
    80001fc8:	ec26                	sd	s1,24(sp)
    80001fca:	e84a                	sd	s2,16(sp)
    80001fcc:	e44e                	sd	s3,8(sp)
    80001fce:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001fd0:	00000097          	auipc	ra,0x0
    80001fd4:	a1e080e7          	jalr	-1506(ra) # 800019ee <myproc>
    80001fd8:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001fda:	fffff097          	auipc	ra,0xfffff
    80001fde:	bb2080e7          	jalr	-1102(ra) # 80000b8c <holding>
    80001fe2:	c93d                	beqz	a0,80002058 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001fe4:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001fe6:	2781                	sext.w	a5,a5
    80001fe8:	079e                	slli	a5,a5,0x7
    80001fea:	0000f717          	auipc	a4,0xf
    80001fee:	2a670713          	addi	a4,a4,678 # 80011290 <pid_lock>
    80001ff2:	97ba                	add	a5,a5,a4
    80001ff4:	0907a703          	lw	a4,144(a5)
    80001ff8:	4785                	li	a5,1
    80001ffa:	06f71763          	bne	a4,a5,80002068 <sched+0xa6>
  if(p->state == RUNNING)
    80001ffe:	4c98                	lw	a4,24(s1)
    80002000:	478d                	li	a5,3
    80002002:	06f70b63          	beq	a4,a5,80002078 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002006:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000200a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000200c:	efb5                	bnez	a5,80002088 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000200e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002010:	0000f917          	auipc	s2,0xf
    80002014:	28090913          	addi	s2,s2,640 # 80011290 <pid_lock>
    80002018:	2781                	sext.w	a5,a5
    8000201a:	079e                	slli	a5,a5,0x7
    8000201c:	97ca                	add	a5,a5,s2
    8000201e:	0947a983          	lw	s3,148(a5)
    80002022:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002024:	2781                	sext.w	a5,a5
    80002026:	079e                	slli	a5,a5,0x7
    80002028:	0000f597          	auipc	a1,0xf
    8000202c:	28858593          	addi	a1,a1,648 # 800112b0 <cpus+0x8>
    80002030:	95be                	add	a1,a1,a5
    80002032:	06048513          	addi	a0,s1,96
    80002036:	00000097          	auipc	ra,0x0
    8000203a:	55c080e7          	jalr	1372(ra) # 80002592 <swtch>
    8000203e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002040:	2781                	sext.w	a5,a5
    80002042:	079e                	slli	a5,a5,0x7
    80002044:	97ca                	add	a5,a5,s2
    80002046:	0937aa23          	sw	s3,148(a5)
}
    8000204a:	70a2                	ld	ra,40(sp)
    8000204c:	7402                	ld	s0,32(sp)
    8000204e:	64e2                	ld	s1,24(sp)
    80002050:	6942                	ld	s2,16(sp)
    80002052:	69a2                	ld	s3,8(sp)
    80002054:	6145                	addi	sp,sp,48
    80002056:	8082                	ret
    panic("sched p->lock");
    80002058:	00006517          	auipc	a0,0x6
    8000205c:	1a050513          	addi	a0,a0,416 # 800081f8 <digits+0x1b8>
    80002060:	ffffe097          	auipc	ra,0xffffe
    80002064:	4ea080e7          	jalr	1258(ra) # 8000054a <panic>
    panic("sched locks");
    80002068:	00006517          	auipc	a0,0x6
    8000206c:	1a050513          	addi	a0,a0,416 # 80008208 <digits+0x1c8>
    80002070:	ffffe097          	auipc	ra,0xffffe
    80002074:	4da080e7          	jalr	1242(ra) # 8000054a <panic>
    panic("sched running");
    80002078:	00006517          	auipc	a0,0x6
    8000207c:	1a050513          	addi	a0,a0,416 # 80008218 <digits+0x1d8>
    80002080:	ffffe097          	auipc	ra,0xffffe
    80002084:	4ca080e7          	jalr	1226(ra) # 8000054a <panic>
    panic("sched interruptible");
    80002088:	00006517          	auipc	a0,0x6
    8000208c:	1a050513          	addi	a0,a0,416 # 80008228 <digits+0x1e8>
    80002090:	ffffe097          	auipc	ra,0xffffe
    80002094:	4ba080e7          	jalr	1210(ra) # 8000054a <panic>

0000000080002098 <exit>:
{
    80002098:	7179                	addi	sp,sp,-48
    8000209a:	f406                	sd	ra,40(sp)
    8000209c:	f022                	sd	s0,32(sp)
    8000209e:	ec26                	sd	s1,24(sp)
    800020a0:	e84a                	sd	s2,16(sp)
    800020a2:	e44e                	sd	s3,8(sp)
    800020a4:	e052                	sd	s4,0(sp)
    800020a6:	1800                	addi	s0,sp,48
    800020a8:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800020aa:	00000097          	auipc	ra,0x0
    800020ae:	944080e7          	jalr	-1724(ra) # 800019ee <myproc>
    800020b2:	89aa                	mv	s3,a0
  if(p == initproc)
    800020b4:	00007797          	auipc	a5,0x7
    800020b8:	f647b783          	ld	a5,-156(a5) # 80009018 <initproc>
    800020bc:	0d050493          	addi	s1,a0,208
    800020c0:	15050913          	addi	s2,a0,336
    800020c4:	02a79363          	bne	a5,a0,800020ea <exit+0x52>
    panic("init exiting");
    800020c8:	00006517          	auipc	a0,0x6
    800020cc:	17850513          	addi	a0,a0,376 # 80008240 <digits+0x200>
    800020d0:	ffffe097          	auipc	ra,0xffffe
    800020d4:	47a080e7          	jalr	1146(ra) # 8000054a <panic>
      fileclose(f);
    800020d8:	00002097          	auipc	ra,0x2
    800020dc:	3c0080e7          	jalr	960(ra) # 80004498 <fileclose>
      p->ofile[fd] = 0;
    800020e0:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800020e4:	04a1                	addi	s1,s1,8
    800020e6:	01248563          	beq	s1,s2,800020f0 <exit+0x58>
    if(p->ofile[fd]){
    800020ea:	6088                	ld	a0,0(s1)
    800020ec:	f575                	bnez	a0,800020d8 <exit+0x40>
    800020ee:	bfdd                	j	800020e4 <exit+0x4c>
  begin_op();
    800020f0:	00002097          	auipc	ra,0x2
    800020f4:	ed4080e7          	jalr	-300(ra) # 80003fc4 <begin_op>
  iput(p->cwd);
    800020f8:	1509b503          	ld	a0,336(s3)
    800020fc:	00001097          	auipc	ra,0x1
    80002100:	6b2080e7          	jalr	1714(ra) # 800037ae <iput>
  end_op();
    80002104:	00002097          	auipc	ra,0x2
    80002108:	f40080e7          	jalr	-192(ra) # 80004044 <end_op>
  p->cwd = 0;
    8000210c:	1409b823          	sd	zero,336(s3)
  acquire(&initproc->lock);
    80002110:	00007497          	auipc	s1,0x7
    80002114:	f0848493          	addi	s1,s1,-248 # 80009018 <initproc>
    80002118:	6088                	ld	a0,0(s1)
    8000211a:	fffff097          	auipc	ra,0xfffff
    8000211e:	aec080e7          	jalr	-1300(ra) # 80000c06 <acquire>
  wakeup1(initproc);
    80002122:	6088                	ld	a0,0(s1)
    80002124:	fffff097          	auipc	ra,0xfffff
    80002128:	72c080e7          	jalr	1836(ra) # 80001850 <wakeup1>
  release(&initproc->lock);
    8000212c:	6088                	ld	a0,0(s1)
    8000212e:	fffff097          	auipc	ra,0xfffff
    80002132:	b8c080e7          	jalr	-1140(ra) # 80000cba <release>
  acquire(&p->lock);
    80002136:	854e                	mv	a0,s3
    80002138:	fffff097          	auipc	ra,0xfffff
    8000213c:	ace080e7          	jalr	-1330(ra) # 80000c06 <acquire>
  struct proc *original_parent = p->parent;
    80002140:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    80002144:	854e                	mv	a0,s3
    80002146:	fffff097          	auipc	ra,0xfffff
    8000214a:	b74080e7          	jalr	-1164(ra) # 80000cba <release>
  acquire(&original_parent->lock);
    8000214e:	8526                	mv	a0,s1
    80002150:	fffff097          	auipc	ra,0xfffff
    80002154:	ab6080e7          	jalr	-1354(ra) # 80000c06 <acquire>
  acquire(&p->lock);
    80002158:	854e                	mv	a0,s3
    8000215a:	fffff097          	auipc	ra,0xfffff
    8000215e:	aac080e7          	jalr	-1364(ra) # 80000c06 <acquire>
  reparent(p);
    80002162:	854e                	mv	a0,s3
    80002164:	00000097          	auipc	ra,0x0
    80002168:	d58080e7          	jalr	-680(ra) # 80001ebc <reparent>
  wakeup1(original_parent);
    8000216c:	8526                	mv	a0,s1
    8000216e:	fffff097          	auipc	ra,0xfffff
    80002172:	6e2080e7          	jalr	1762(ra) # 80001850 <wakeup1>
  p->xstate = status;
    80002176:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    8000217a:	4791                	li	a5,4
    8000217c:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    80002180:	8526                	mv	a0,s1
    80002182:	fffff097          	auipc	ra,0xfffff
    80002186:	b38080e7          	jalr	-1224(ra) # 80000cba <release>
  sched();
    8000218a:	00000097          	auipc	ra,0x0
    8000218e:	e38080e7          	jalr	-456(ra) # 80001fc2 <sched>
  panic("zombie exit");
    80002192:	00006517          	auipc	a0,0x6
    80002196:	0be50513          	addi	a0,a0,190 # 80008250 <digits+0x210>
    8000219a:	ffffe097          	auipc	ra,0xffffe
    8000219e:	3b0080e7          	jalr	944(ra) # 8000054a <panic>

00000000800021a2 <yield>:
{
    800021a2:	1101                	addi	sp,sp,-32
    800021a4:	ec06                	sd	ra,24(sp)
    800021a6:	e822                	sd	s0,16(sp)
    800021a8:	e426                	sd	s1,8(sp)
    800021aa:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800021ac:	00000097          	auipc	ra,0x0
    800021b0:	842080e7          	jalr	-1982(ra) # 800019ee <myproc>
    800021b4:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800021b6:	fffff097          	auipc	ra,0xfffff
    800021ba:	a50080e7          	jalr	-1456(ra) # 80000c06 <acquire>
  p->state = RUNNABLE;
    800021be:	4789                	li	a5,2
    800021c0:	cc9c                	sw	a5,24(s1)
  sched();
    800021c2:	00000097          	auipc	ra,0x0
    800021c6:	e00080e7          	jalr	-512(ra) # 80001fc2 <sched>
  release(&p->lock);
    800021ca:	8526                	mv	a0,s1
    800021cc:	fffff097          	auipc	ra,0xfffff
    800021d0:	aee080e7          	jalr	-1298(ra) # 80000cba <release>
}
    800021d4:	60e2                	ld	ra,24(sp)
    800021d6:	6442                	ld	s0,16(sp)
    800021d8:	64a2                	ld	s1,8(sp)
    800021da:	6105                	addi	sp,sp,32
    800021dc:	8082                	ret

00000000800021de <sleep>:
{
    800021de:	7179                	addi	sp,sp,-48
    800021e0:	f406                	sd	ra,40(sp)
    800021e2:	f022                	sd	s0,32(sp)
    800021e4:	ec26                	sd	s1,24(sp)
    800021e6:	e84a                	sd	s2,16(sp)
    800021e8:	e44e                	sd	s3,8(sp)
    800021ea:	1800                	addi	s0,sp,48
    800021ec:	89aa                	mv	s3,a0
    800021ee:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800021f0:	fffff097          	auipc	ra,0xfffff
    800021f4:	7fe080e7          	jalr	2046(ra) # 800019ee <myproc>
    800021f8:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    800021fa:	05250663          	beq	a0,s2,80002246 <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    800021fe:	fffff097          	auipc	ra,0xfffff
    80002202:	a08080e7          	jalr	-1528(ra) # 80000c06 <acquire>
    release(lk);
    80002206:	854a                	mv	a0,s2
    80002208:	fffff097          	auipc	ra,0xfffff
    8000220c:	ab2080e7          	jalr	-1358(ra) # 80000cba <release>
  p->chan = chan;
    80002210:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    80002214:	4785                	li	a5,1
    80002216:	cc9c                	sw	a5,24(s1)
  sched();
    80002218:	00000097          	auipc	ra,0x0
    8000221c:	daa080e7          	jalr	-598(ra) # 80001fc2 <sched>
  p->chan = 0;
    80002220:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    80002224:	8526                	mv	a0,s1
    80002226:	fffff097          	auipc	ra,0xfffff
    8000222a:	a94080e7          	jalr	-1388(ra) # 80000cba <release>
    acquire(lk);
    8000222e:	854a                	mv	a0,s2
    80002230:	fffff097          	auipc	ra,0xfffff
    80002234:	9d6080e7          	jalr	-1578(ra) # 80000c06 <acquire>
}
    80002238:	70a2                	ld	ra,40(sp)
    8000223a:	7402                	ld	s0,32(sp)
    8000223c:	64e2                	ld	s1,24(sp)
    8000223e:	6942                	ld	s2,16(sp)
    80002240:	69a2                	ld	s3,8(sp)
    80002242:	6145                	addi	sp,sp,48
    80002244:	8082                	ret
  p->chan = chan;
    80002246:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    8000224a:	4785                	li	a5,1
    8000224c:	cd1c                	sw	a5,24(a0)
  sched();
    8000224e:	00000097          	auipc	ra,0x0
    80002252:	d74080e7          	jalr	-652(ra) # 80001fc2 <sched>
  p->chan = 0;
    80002256:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    8000225a:	bff9                	j	80002238 <sleep+0x5a>

000000008000225c <wait>:
{
    8000225c:	715d                	addi	sp,sp,-80
    8000225e:	e486                	sd	ra,72(sp)
    80002260:	e0a2                	sd	s0,64(sp)
    80002262:	fc26                	sd	s1,56(sp)
    80002264:	f84a                	sd	s2,48(sp)
    80002266:	f44e                	sd	s3,40(sp)
    80002268:	f052                	sd	s4,32(sp)
    8000226a:	ec56                	sd	s5,24(sp)
    8000226c:	e85a                	sd	s6,16(sp)
    8000226e:	e45e                	sd	s7,8(sp)
    80002270:	0880                	addi	s0,sp,80
    80002272:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002274:	fffff097          	auipc	ra,0xfffff
    80002278:	77a080e7          	jalr	1914(ra) # 800019ee <myproc>
    8000227c:	892a                	mv	s2,a0
  acquire(&p->lock);
    8000227e:	fffff097          	auipc	ra,0xfffff
    80002282:	988080e7          	jalr	-1656(ra) # 80000c06 <acquire>
    havekids = 0;
    80002286:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80002288:	4a11                	li	s4,4
        havekids = 1;
    8000228a:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    8000228c:	00015997          	auipc	s3,0x15
    80002290:	e1c98993          	addi	s3,s3,-484 # 800170a8 <tickslock>
    havekids = 0;
    80002294:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80002296:	0000f497          	auipc	s1,0xf
    8000229a:	41248493          	addi	s1,s1,1042 # 800116a8 <proc>
    8000229e:	a08d                	j	80002300 <wait+0xa4>
          pid = np->pid;
    800022a0:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800022a4:	000b0e63          	beqz	s6,800022c0 <wait+0x64>
    800022a8:	4691                	li	a3,4
    800022aa:	03448613          	addi	a2,s1,52
    800022ae:	85da                	mv	a1,s6
    800022b0:	05093503          	ld	a0,80(s2)
    800022b4:	fffff097          	auipc	ra,0xfffff
    800022b8:	3ce080e7          	jalr	974(ra) # 80001682 <copyout>
    800022bc:	02054263          	bltz	a0,800022e0 <wait+0x84>
          freeproc(np);
    800022c0:	8526                	mv	a0,s1
    800022c2:	00000097          	auipc	ra,0x0
    800022c6:	8de080e7          	jalr	-1826(ra) # 80001ba0 <freeproc>
          release(&np->lock);
    800022ca:	8526                	mv	a0,s1
    800022cc:	fffff097          	auipc	ra,0xfffff
    800022d0:	9ee080e7          	jalr	-1554(ra) # 80000cba <release>
          release(&p->lock);
    800022d4:	854a                	mv	a0,s2
    800022d6:	fffff097          	auipc	ra,0xfffff
    800022da:	9e4080e7          	jalr	-1564(ra) # 80000cba <release>
          return pid;
    800022de:	a8a9                	j	80002338 <wait+0xdc>
            release(&np->lock);
    800022e0:	8526                	mv	a0,s1
    800022e2:	fffff097          	auipc	ra,0xfffff
    800022e6:	9d8080e7          	jalr	-1576(ra) # 80000cba <release>
            release(&p->lock);
    800022ea:	854a                	mv	a0,s2
    800022ec:	fffff097          	auipc	ra,0xfffff
    800022f0:	9ce080e7          	jalr	-1586(ra) # 80000cba <release>
            return -1;
    800022f4:	59fd                	li	s3,-1
    800022f6:	a089                	j	80002338 <wait+0xdc>
    for(np = proc; np < &proc[NPROC]; np++){
    800022f8:	16848493          	addi	s1,s1,360
    800022fc:	03348463          	beq	s1,s3,80002324 <wait+0xc8>
      if(np->parent == p){
    80002300:	709c                	ld	a5,32(s1)
    80002302:	ff279be3          	bne	a5,s2,800022f8 <wait+0x9c>
        acquire(&np->lock);
    80002306:	8526                	mv	a0,s1
    80002308:	fffff097          	auipc	ra,0xfffff
    8000230c:	8fe080e7          	jalr	-1794(ra) # 80000c06 <acquire>
        if(np->state == ZOMBIE){
    80002310:	4c9c                	lw	a5,24(s1)
    80002312:	f94787e3          	beq	a5,s4,800022a0 <wait+0x44>
        release(&np->lock);
    80002316:	8526                	mv	a0,s1
    80002318:	fffff097          	auipc	ra,0xfffff
    8000231c:	9a2080e7          	jalr	-1630(ra) # 80000cba <release>
        havekids = 1;
    80002320:	8756                	mv	a4,s5
    80002322:	bfd9                	j	800022f8 <wait+0x9c>
    if(!havekids || p->killed){
    80002324:	c701                	beqz	a4,8000232c <wait+0xd0>
    80002326:	03092783          	lw	a5,48(s2)
    8000232a:	c39d                	beqz	a5,80002350 <wait+0xf4>
      release(&p->lock);
    8000232c:	854a                	mv	a0,s2
    8000232e:	fffff097          	auipc	ra,0xfffff
    80002332:	98c080e7          	jalr	-1652(ra) # 80000cba <release>
      return -1;
    80002336:	59fd                	li	s3,-1
}
    80002338:	854e                	mv	a0,s3
    8000233a:	60a6                	ld	ra,72(sp)
    8000233c:	6406                	ld	s0,64(sp)
    8000233e:	74e2                	ld	s1,56(sp)
    80002340:	7942                	ld	s2,48(sp)
    80002342:	79a2                	ld	s3,40(sp)
    80002344:	7a02                	ld	s4,32(sp)
    80002346:	6ae2                	ld	s5,24(sp)
    80002348:	6b42                	ld	s6,16(sp)
    8000234a:	6ba2                	ld	s7,8(sp)
    8000234c:	6161                	addi	sp,sp,80
    8000234e:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    80002350:	85ca                	mv	a1,s2
    80002352:	854a                	mv	a0,s2
    80002354:	00000097          	auipc	ra,0x0
    80002358:	e8a080e7          	jalr	-374(ra) # 800021de <sleep>
    havekids = 0;
    8000235c:	bf25                	j	80002294 <wait+0x38>

000000008000235e <wakeup>:
{
    8000235e:	7139                	addi	sp,sp,-64
    80002360:	fc06                	sd	ra,56(sp)
    80002362:	f822                	sd	s0,48(sp)
    80002364:	f426                	sd	s1,40(sp)
    80002366:	f04a                	sd	s2,32(sp)
    80002368:	ec4e                	sd	s3,24(sp)
    8000236a:	e852                	sd	s4,16(sp)
    8000236c:	e456                	sd	s5,8(sp)
    8000236e:	0080                	addi	s0,sp,64
    80002370:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    80002372:	0000f497          	auipc	s1,0xf
    80002376:	33648493          	addi	s1,s1,822 # 800116a8 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    8000237a:	4985                	li	s3,1
      p->state = RUNNABLE;
    8000237c:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    8000237e:	00015917          	auipc	s2,0x15
    80002382:	d2a90913          	addi	s2,s2,-726 # 800170a8 <tickslock>
    80002386:	a811                	j	8000239a <wakeup+0x3c>
    release(&p->lock);
    80002388:	8526                	mv	a0,s1
    8000238a:	fffff097          	auipc	ra,0xfffff
    8000238e:	930080e7          	jalr	-1744(ra) # 80000cba <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002392:	16848493          	addi	s1,s1,360
    80002396:	03248063          	beq	s1,s2,800023b6 <wakeup+0x58>
    acquire(&p->lock);
    8000239a:	8526                	mv	a0,s1
    8000239c:	fffff097          	auipc	ra,0xfffff
    800023a0:	86a080e7          	jalr	-1942(ra) # 80000c06 <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    800023a4:	4c9c                	lw	a5,24(s1)
    800023a6:	ff3791e3          	bne	a5,s3,80002388 <wakeup+0x2a>
    800023aa:	749c                	ld	a5,40(s1)
    800023ac:	fd479ee3          	bne	a5,s4,80002388 <wakeup+0x2a>
      p->state = RUNNABLE;
    800023b0:	0154ac23          	sw	s5,24(s1)
    800023b4:	bfd1                	j	80002388 <wakeup+0x2a>
}
    800023b6:	70e2                	ld	ra,56(sp)
    800023b8:	7442                	ld	s0,48(sp)
    800023ba:	74a2                	ld	s1,40(sp)
    800023bc:	7902                	ld	s2,32(sp)
    800023be:	69e2                	ld	s3,24(sp)
    800023c0:	6a42                	ld	s4,16(sp)
    800023c2:	6aa2                	ld	s5,8(sp)
    800023c4:	6121                	addi	sp,sp,64
    800023c6:	8082                	ret

00000000800023c8 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800023c8:	7179                	addi	sp,sp,-48
    800023ca:	f406                	sd	ra,40(sp)
    800023cc:	f022                	sd	s0,32(sp)
    800023ce:	ec26                	sd	s1,24(sp)
    800023d0:	e84a                	sd	s2,16(sp)
    800023d2:	e44e                	sd	s3,8(sp)
    800023d4:	1800                	addi	s0,sp,48
    800023d6:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800023d8:	0000f497          	auipc	s1,0xf
    800023dc:	2d048493          	addi	s1,s1,720 # 800116a8 <proc>
    800023e0:	00015997          	auipc	s3,0x15
    800023e4:	cc898993          	addi	s3,s3,-824 # 800170a8 <tickslock>
    acquire(&p->lock);
    800023e8:	8526                	mv	a0,s1
    800023ea:	fffff097          	auipc	ra,0xfffff
    800023ee:	81c080e7          	jalr	-2020(ra) # 80000c06 <acquire>
    if(p->pid == pid){
    800023f2:	5c9c                	lw	a5,56(s1)
    800023f4:	01278d63          	beq	a5,s2,8000240e <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800023f8:	8526                	mv	a0,s1
    800023fa:	fffff097          	auipc	ra,0xfffff
    800023fe:	8c0080e7          	jalr	-1856(ra) # 80000cba <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002402:	16848493          	addi	s1,s1,360
    80002406:	ff3491e3          	bne	s1,s3,800023e8 <kill+0x20>
  }
  return -1;
    8000240a:	557d                	li	a0,-1
    8000240c:	a821                	j	80002424 <kill+0x5c>
      p->killed = 1;
    8000240e:	4785                	li	a5,1
    80002410:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    80002412:	4c98                	lw	a4,24(s1)
    80002414:	00f70f63          	beq	a4,a5,80002432 <kill+0x6a>
      release(&p->lock);
    80002418:	8526                	mv	a0,s1
    8000241a:	fffff097          	auipc	ra,0xfffff
    8000241e:	8a0080e7          	jalr	-1888(ra) # 80000cba <release>
      return 0;
    80002422:	4501                	li	a0,0
}
    80002424:	70a2                	ld	ra,40(sp)
    80002426:	7402                	ld	s0,32(sp)
    80002428:	64e2                	ld	s1,24(sp)
    8000242a:	6942                	ld	s2,16(sp)
    8000242c:	69a2                	ld	s3,8(sp)
    8000242e:	6145                	addi	sp,sp,48
    80002430:	8082                	ret
        p->state = RUNNABLE;
    80002432:	4789                	li	a5,2
    80002434:	cc9c                	sw	a5,24(s1)
    80002436:	b7cd                	j	80002418 <kill+0x50>

0000000080002438 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002438:	7179                	addi	sp,sp,-48
    8000243a:	f406                	sd	ra,40(sp)
    8000243c:	f022                	sd	s0,32(sp)
    8000243e:	ec26                	sd	s1,24(sp)
    80002440:	e84a                	sd	s2,16(sp)
    80002442:	e44e                	sd	s3,8(sp)
    80002444:	e052                	sd	s4,0(sp)
    80002446:	1800                	addi	s0,sp,48
    80002448:	84aa                	mv	s1,a0
    8000244a:	892e                	mv	s2,a1
    8000244c:	89b2                	mv	s3,a2
    8000244e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002450:	fffff097          	auipc	ra,0xfffff
    80002454:	59e080e7          	jalr	1438(ra) # 800019ee <myproc>
  if(user_dst){
    80002458:	c08d                	beqz	s1,8000247a <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000245a:	86d2                	mv	a3,s4
    8000245c:	864e                	mv	a2,s3
    8000245e:	85ca                	mv	a1,s2
    80002460:	6928                	ld	a0,80(a0)
    80002462:	fffff097          	auipc	ra,0xfffff
    80002466:	220080e7          	jalr	544(ra) # 80001682 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000246a:	70a2                	ld	ra,40(sp)
    8000246c:	7402                	ld	s0,32(sp)
    8000246e:	64e2                	ld	s1,24(sp)
    80002470:	6942                	ld	s2,16(sp)
    80002472:	69a2                	ld	s3,8(sp)
    80002474:	6a02                	ld	s4,0(sp)
    80002476:	6145                	addi	sp,sp,48
    80002478:	8082                	ret
    memmove((char *)dst, src, len);
    8000247a:	000a061b          	sext.w	a2,s4
    8000247e:	85ce                	mv	a1,s3
    80002480:	854a                	mv	a0,s2
    80002482:	fffff097          	auipc	ra,0xfffff
    80002486:	8dc080e7          	jalr	-1828(ra) # 80000d5e <memmove>
    return 0;
    8000248a:	8526                	mv	a0,s1
    8000248c:	bff9                	j	8000246a <either_copyout+0x32>

000000008000248e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000248e:	7179                	addi	sp,sp,-48
    80002490:	f406                	sd	ra,40(sp)
    80002492:	f022                	sd	s0,32(sp)
    80002494:	ec26                	sd	s1,24(sp)
    80002496:	e84a                	sd	s2,16(sp)
    80002498:	e44e                	sd	s3,8(sp)
    8000249a:	e052                	sd	s4,0(sp)
    8000249c:	1800                	addi	s0,sp,48
    8000249e:	892a                	mv	s2,a0
    800024a0:	84ae                	mv	s1,a1
    800024a2:	89b2                	mv	s3,a2
    800024a4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800024a6:	fffff097          	auipc	ra,0xfffff
    800024aa:	548080e7          	jalr	1352(ra) # 800019ee <myproc>
  if(user_src){
    800024ae:	c08d                	beqz	s1,800024d0 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800024b0:	86d2                	mv	a3,s4
    800024b2:	864e                	mv	a2,s3
    800024b4:	85ca                	mv	a1,s2
    800024b6:	6928                	ld	a0,80(a0)
    800024b8:	fffff097          	auipc	ra,0xfffff
    800024bc:	256080e7          	jalr	598(ra) # 8000170e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800024c0:	70a2                	ld	ra,40(sp)
    800024c2:	7402                	ld	s0,32(sp)
    800024c4:	64e2                	ld	s1,24(sp)
    800024c6:	6942                	ld	s2,16(sp)
    800024c8:	69a2                	ld	s3,8(sp)
    800024ca:	6a02                	ld	s4,0(sp)
    800024cc:	6145                	addi	sp,sp,48
    800024ce:	8082                	ret
    memmove(dst, (char*)src, len);
    800024d0:	000a061b          	sext.w	a2,s4
    800024d4:	85ce                	mv	a1,s3
    800024d6:	854a                	mv	a0,s2
    800024d8:	fffff097          	auipc	ra,0xfffff
    800024dc:	886080e7          	jalr	-1914(ra) # 80000d5e <memmove>
    return 0;
    800024e0:	8526                	mv	a0,s1
    800024e2:	bff9                	j	800024c0 <either_copyin+0x32>

00000000800024e4 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800024e4:	715d                	addi	sp,sp,-80
    800024e6:	e486                	sd	ra,72(sp)
    800024e8:	e0a2                	sd	s0,64(sp)
    800024ea:	fc26                	sd	s1,56(sp)
    800024ec:	f84a                	sd	s2,48(sp)
    800024ee:	f44e                	sd	s3,40(sp)
    800024f0:	f052                	sd	s4,32(sp)
    800024f2:	ec56                	sd	s5,24(sp)
    800024f4:	e85a                	sd	s6,16(sp)
    800024f6:	e45e                	sd	s7,8(sp)
    800024f8:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800024fa:	00006517          	auipc	a0,0x6
    800024fe:	bce50513          	addi	a0,a0,-1074 # 800080c8 <digits+0x88>
    80002502:	ffffe097          	auipc	ra,0xffffe
    80002506:	092080e7          	jalr	146(ra) # 80000594 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000250a:	0000f497          	auipc	s1,0xf
    8000250e:	2f648493          	addi	s1,s1,758 # 80011800 <proc+0x158>
    80002512:	00015917          	auipc	s2,0x15
    80002516:	cee90913          	addi	s2,s2,-786 # 80017200 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000251a:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    8000251c:	00006997          	auipc	s3,0x6
    80002520:	d4498993          	addi	s3,s3,-700 # 80008260 <digits+0x220>
    printf("%d %s %s", p->pid, state, p->name);
    80002524:	00006a97          	auipc	s5,0x6
    80002528:	d44a8a93          	addi	s5,s5,-700 # 80008268 <digits+0x228>
    printf("\n");
    8000252c:	00006a17          	auipc	s4,0x6
    80002530:	b9ca0a13          	addi	s4,s4,-1124 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002534:	00006b97          	auipc	s7,0x6
    80002538:	d6cb8b93          	addi	s7,s7,-660 # 800082a0 <states.0>
    8000253c:	a00d                	j	8000255e <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    8000253e:	ee06a583          	lw	a1,-288(a3)
    80002542:	8556                	mv	a0,s5
    80002544:	ffffe097          	auipc	ra,0xffffe
    80002548:	050080e7          	jalr	80(ra) # 80000594 <printf>
    printf("\n");
    8000254c:	8552                	mv	a0,s4
    8000254e:	ffffe097          	auipc	ra,0xffffe
    80002552:	046080e7          	jalr	70(ra) # 80000594 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002556:	16848493          	addi	s1,s1,360
    8000255a:	03248163          	beq	s1,s2,8000257c <procdump+0x98>
    if(p->state == UNUSED)
    8000255e:	86a6                	mv	a3,s1
    80002560:	ec04a783          	lw	a5,-320(s1)
    80002564:	dbed                	beqz	a5,80002556 <procdump+0x72>
      state = "???";
    80002566:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002568:	fcfb6be3          	bltu	s6,a5,8000253e <procdump+0x5a>
    8000256c:	1782                	slli	a5,a5,0x20
    8000256e:	9381                	srli	a5,a5,0x20
    80002570:	078e                	slli	a5,a5,0x3
    80002572:	97de                	add	a5,a5,s7
    80002574:	6390                	ld	a2,0(a5)
    80002576:	f661                	bnez	a2,8000253e <procdump+0x5a>
      state = "???";
    80002578:	864e                	mv	a2,s3
    8000257a:	b7d1                	j	8000253e <procdump+0x5a>
  }
}
    8000257c:	60a6                	ld	ra,72(sp)
    8000257e:	6406                	ld	s0,64(sp)
    80002580:	74e2                	ld	s1,56(sp)
    80002582:	7942                	ld	s2,48(sp)
    80002584:	79a2                	ld	s3,40(sp)
    80002586:	7a02                	ld	s4,32(sp)
    80002588:	6ae2                	ld	s5,24(sp)
    8000258a:	6b42                	ld	s6,16(sp)
    8000258c:	6ba2                	ld	s7,8(sp)
    8000258e:	6161                	addi	sp,sp,80
    80002590:	8082                	ret

0000000080002592 <swtch>:
    80002592:	00153023          	sd	ra,0(a0)
    80002596:	00253423          	sd	sp,8(a0)
    8000259a:	e900                	sd	s0,16(a0)
    8000259c:	ed04                	sd	s1,24(a0)
    8000259e:	03253023          	sd	s2,32(a0)
    800025a2:	03353423          	sd	s3,40(a0)
    800025a6:	03453823          	sd	s4,48(a0)
    800025aa:	03553c23          	sd	s5,56(a0)
    800025ae:	05653023          	sd	s6,64(a0)
    800025b2:	05753423          	sd	s7,72(a0)
    800025b6:	05853823          	sd	s8,80(a0)
    800025ba:	05953c23          	sd	s9,88(a0)
    800025be:	07a53023          	sd	s10,96(a0)
    800025c2:	07b53423          	sd	s11,104(a0)
    800025c6:	0005b083          	ld	ra,0(a1)
    800025ca:	0085b103          	ld	sp,8(a1)
    800025ce:	6980                	ld	s0,16(a1)
    800025d0:	6d84                	ld	s1,24(a1)
    800025d2:	0205b903          	ld	s2,32(a1)
    800025d6:	0285b983          	ld	s3,40(a1)
    800025da:	0305ba03          	ld	s4,48(a1)
    800025de:	0385ba83          	ld	s5,56(a1)
    800025e2:	0405bb03          	ld	s6,64(a1)
    800025e6:	0485bb83          	ld	s7,72(a1)
    800025ea:	0505bc03          	ld	s8,80(a1)
    800025ee:	0585bc83          	ld	s9,88(a1)
    800025f2:	0605bd03          	ld	s10,96(a1)
    800025f6:	0685bd83          	ld	s11,104(a1)
    800025fa:	8082                	ret

00000000800025fc <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800025fc:	1141                	addi	sp,sp,-16
    800025fe:	e406                	sd	ra,8(sp)
    80002600:	e022                	sd	s0,0(sp)
    80002602:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002604:	00006597          	auipc	a1,0x6
    80002608:	cc458593          	addi	a1,a1,-828 # 800082c8 <states.0+0x28>
    8000260c:	00015517          	auipc	a0,0x15
    80002610:	a9c50513          	addi	a0,a0,-1380 # 800170a8 <tickslock>
    80002614:	ffffe097          	auipc	ra,0xffffe
    80002618:	562080e7          	jalr	1378(ra) # 80000b76 <initlock>
}
    8000261c:	60a2                	ld	ra,8(sp)
    8000261e:	6402                	ld	s0,0(sp)
    80002620:	0141                	addi	sp,sp,16
    80002622:	8082                	ret

0000000080002624 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002624:	1141                	addi	sp,sp,-16
    80002626:	e422                	sd	s0,8(sp)
    80002628:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000262a:	00003797          	auipc	a5,0x3
    8000262e:	4c678793          	addi	a5,a5,1222 # 80005af0 <kernelvec>
    80002632:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002636:	6422                	ld	s0,8(sp)
    80002638:	0141                	addi	sp,sp,16
    8000263a:	8082                	ret

000000008000263c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000263c:	1141                	addi	sp,sp,-16
    8000263e:	e406                	sd	ra,8(sp)
    80002640:	e022                	sd	s0,0(sp)
    80002642:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002644:	fffff097          	auipc	ra,0xfffff
    80002648:	3aa080e7          	jalr	938(ra) # 800019ee <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000264c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002650:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002652:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002656:	00005617          	auipc	a2,0x5
    8000265a:	9aa60613          	addi	a2,a2,-1622 # 80007000 <_trampoline>
    8000265e:	00005697          	auipc	a3,0x5
    80002662:	9a268693          	addi	a3,a3,-1630 # 80007000 <_trampoline>
    80002666:	8e91                	sub	a3,a3,a2
    80002668:	040007b7          	lui	a5,0x4000
    8000266c:	17fd                	addi	a5,a5,-1
    8000266e:	07b2                	slli	a5,a5,0xc
    80002670:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002672:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002676:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002678:	180026f3          	csrr	a3,satp
    8000267c:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000267e:	6d38                	ld	a4,88(a0)
    80002680:	6134                	ld	a3,64(a0)
    80002682:	6585                	lui	a1,0x1
    80002684:	96ae                	add	a3,a3,a1
    80002686:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002688:	6d38                	ld	a4,88(a0)
    8000268a:	00000697          	auipc	a3,0x0
    8000268e:	13868693          	addi	a3,a3,312 # 800027c2 <usertrap>
    80002692:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002694:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002696:	8692                	mv	a3,tp
    80002698:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000269a:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000269e:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800026a2:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026a6:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800026aa:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800026ac:	6f18                	ld	a4,24(a4)
    800026ae:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800026b2:	692c                	ld	a1,80(a0)
    800026b4:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    800026b6:	00005717          	auipc	a4,0x5
    800026ba:	9da70713          	addi	a4,a4,-1574 # 80007090 <userret>
    800026be:	8f11                	sub	a4,a4,a2
    800026c0:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    800026c2:	577d                	li	a4,-1
    800026c4:	177e                	slli	a4,a4,0x3f
    800026c6:	8dd9                	or	a1,a1,a4
    800026c8:	02000537          	lui	a0,0x2000
    800026cc:	157d                	addi	a0,a0,-1
    800026ce:	0536                	slli	a0,a0,0xd
    800026d0:	9782                	jalr	a5
}
    800026d2:	60a2                	ld	ra,8(sp)
    800026d4:	6402                	ld	s0,0(sp)
    800026d6:	0141                	addi	sp,sp,16
    800026d8:	8082                	ret

00000000800026da <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800026da:	1101                	addi	sp,sp,-32
    800026dc:	ec06                	sd	ra,24(sp)
    800026de:	e822                	sd	s0,16(sp)
    800026e0:	e426                	sd	s1,8(sp)
    800026e2:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    800026e4:	00015497          	auipc	s1,0x15
    800026e8:	9c448493          	addi	s1,s1,-1596 # 800170a8 <tickslock>
    800026ec:	8526                	mv	a0,s1
    800026ee:	ffffe097          	auipc	ra,0xffffe
    800026f2:	518080e7          	jalr	1304(ra) # 80000c06 <acquire>
  ticks++;
    800026f6:	00007517          	auipc	a0,0x7
    800026fa:	92a50513          	addi	a0,a0,-1750 # 80009020 <ticks>
    800026fe:	411c                	lw	a5,0(a0)
    80002700:	2785                	addiw	a5,a5,1
    80002702:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002704:	00000097          	auipc	ra,0x0
    80002708:	c5a080e7          	jalr	-934(ra) # 8000235e <wakeup>
  release(&tickslock);
    8000270c:	8526                	mv	a0,s1
    8000270e:	ffffe097          	auipc	ra,0xffffe
    80002712:	5ac080e7          	jalr	1452(ra) # 80000cba <release>
}
    80002716:	60e2                	ld	ra,24(sp)
    80002718:	6442                	ld	s0,16(sp)
    8000271a:	64a2                	ld	s1,8(sp)
    8000271c:	6105                	addi	sp,sp,32
    8000271e:	8082                	ret

0000000080002720 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002720:	1101                	addi	sp,sp,-32
    80002722:	ec06                	sd	ra,24(sp)
    80002724:	e822                	sd	s0,16(sp)
    80002726:	e426                	sd	s1,8(sp)
    80002728:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000272a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    8000272e:	00074d63          	bltz	a4,80002748 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80002732:	57fd                	li	a5,-1
    80002734:	17fe                	slli	a5,a5,0x3f
    80002736:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002738:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    8000273a:	06f70363          	beq	a4,a5,800027a0 <devintr+0x80>
  }
}
    8000273e:	60e2                	ld	ra,24(sp)
    80002740:	6442                	ld	s0,16(sp)
    80002742:	64a2                	ld	s1,8(sp)
    80002744:	6105                	addi	sp,sp,32
    80002746:	8082                	ret
     (scause & 0xff) == 9){
    80002748:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    8000274c:	46a5                	li	a3,9
    8000274e:	fed792e3          	bne	a5,a3,80002732 <devintr+0x12>
    int irq = plic_claim();
    80002752:	00003097          	auipc	ra,0x3
    80002756:	4a6080e7          	jalr	1190(ra) # 80005bf8 <plic_claim>
    8000275a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000275c:	47a9                	li	a5,10
    8000275e:	02f50763          	beq	a0,a5,8000278c <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80002762:	4785                	li	a5,1
    80002764:	02f50963          	beq	a0,a5,80002796 <devintr+0x76>
    return 1;
    80002768:	4505                	li	a0,1
    } else if(irq){
    8000276a:	d8f1                	beqz	s1,8000273e <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    8000276c:	85a6                	mv	a1,s1
    8000276e:	00006517          	auipc	a0,0x6
    80002772:	b6250513          	addi	a0,a0,-1182 # 800082d0 <states.0+0x30>
    80002776:	ffffe097          	auipc	ra,0xffffe
    8000277a:	e1e080e7          	jalr	-482(ra) # 80000594 <printf>
      plic_complete(irq);
    8000277e:	8526                	mv	a0,s1
    80002780:	00003097          	auipc	ra,0x3
    80002784:	49c080e7          	jalr	1180(ra) # 80005c1c <plic_complete>
    return 1;
    80002788:	4505                	li	a0,1
    8000278a:	bf55                	j	8000273e <devintr+0x1e>
      uartintr();
    8000278c:	ffffe097          	auipc	ra,0xffffe
    80002790:	23e080e7          	jalr	574(ra) # 800009ca <uartintr>
    80002794:	b7ed                	j	8000277e <devintr+0x5e>
      virtio_disk_intr();
    80002796:	00004097          	auipc	ra,0x4
    8000279a:	918080e7          	jalr	-1768(ra) # 800060ae <virtio_disk_intr>
    8000279e:	b7c5                	j	8000277e <devintr+0x5e>
    if(cpuid() == 0){
    800027a0:	fffff097          	auipc	ra,0xfffff
    800027a4:	222080e7          	jalr	546(ra) # 800019c2 <cpuid>
    800027a8:	c901                	beqz	a0,800027b8 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    800027aa:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    800027ae:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    800027b0:	14479073          	csrw	sip,a5
    return 2;
    800027b4:	4509                	li	a0,2
    800027b6:	b761                	j	8000273e <devintr+0x1e>
      clockintr();
    800027b8:	00000097          	auipc	ra,0x0
    800027bc:	f22080e7          	jalr	-222(ra) # 800026da <clockintr>
    800027c0:	b7ed                	j	800027aa <devintr+0x8a>

00000000800027c2 <usertrap>:
{
    800027c2:	1101                	addi	sp,sp,-32
    800027c4:	ec06                	sd	ra,24(sp)
    800027c6:	e822                	sd	s0,16(sp)
    800027c8:	e426                	sd	s1,8(sp)
    800027ca:	e04a                	sd	s2,0(sp)
    800027cc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027ce:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800027d2:	1007f793          	andi	a5,a5,256
    800027d6:	e3ad                	bnez	a5,80002838 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027d8:	00003797          	auipc	a5,0x3
    800027dc:	31878793          	addi	a5,a5,792 # 80005af0 <kernelvec>
    800027e0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800027e4:	fffff097          	auipc	ra,0xfffff
    800027e8:	20a080e7          	jalr	522(ra) # 800019ee <myproc>
    800027ec:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800027ee:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800027f0:	14102773          	csrr	a4,sepc
    800027f4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800027f6:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800027fa:	47a1                	li	a5,8
    800027fc:	04f71c63          	bne	a4,a5,80002854 <usertrap+0x92>
    if(p->killed)
    80002800:	591c                	lw	a5,48(a0)
    80002802:	e3b9                	bnez	a5,80002848 <usertrap+0x86>
    p->trapframe->epc += 4;
    80002804:	6cb8                	ld	a4,88(s1)
    80002806:	6f1c                	ld	a5,24(a4)
    80002808:	0791                	addi	a5,a5,4
    8000280a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000280c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002810:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002814:	10079073          	csrw	sstatus,a5
    syscall();
    80002818:	00000097          	auipc	ra,0x0
    8000281c:	2e0080e7          	jalr	736(ra) # 80002af8 <syscall>
  if(p->killed)
    80002820:	589c                	lw	a5,48(s1)
    80002822:	ebc1                	bnez	a5,800028b2 <usertrap+0xf0>
  usertrapret();
    80002824:	00000097          	auipc	ra,0x0
    80002828:	e18080e7          	jalr	-488(ra) # 8000263c <usertrapret>
}
    8000282c:	60e2                	ld	ra,24(sp)
    8000282e:	6442                	ld	s0,16(sp)
    80002830:	64a2                	ld	s1,8(sp)
    80002832:	6902                	ld	s2,0(sp)
    80002834:	6105                	addi	sp,sp,32
    80002836:	8082                	ret
    panic("usertrap: not from user mode");
    80002838:	00006517          	auipc	a0,0x6
    8000283c:	ab850513          	addi	a0,a0,-1352 # 800082f0 <states.0+0x50>
    80002840:	ffffe097          	auipc	ra,0xffffe
    80002844:	d0a080e7          	jalr	-758(ra) # 8000054a <panic>
      exit(-1);
    80002848:	557d                	li	a0,-1
    8000284a:	00000097          	auipc	ra,0x0
    8000284e:	84e080e7          	jalr	-1970(ra) # 80002098 <exit>
    80002852:	bf4d                	j	80002804 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002854:	00000097          	auipc	ra,0x0
    80002858:	ecc080e7          	jalr	-308(ra) # 80002720 <devintr>
    8000285c:	892a                	mv	s2,a0
    8000285e:	c501                	beqz	a0,80002866 <usertrap+0xa4>
  if(p->killed)
    80002860:	589c                	lw	a5,48(s1)
    80002862:	c3a1                	beqz	a5,800028a2 <usertrap+0xe0>
    80002864:	a815                	j	80002898 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002866:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    8000286a:	5c90                	lw	a2,56(s1)
    8000286c:	00006517          	auipc	a0,0x6
    80002870:	aa450513          	addi	a0,a0,-1372 # 80008310 <states.0+0x70>
    80002874:	ffffe097          	auipc	ra,0xffffe
    80002878:	d20080e7          	jalr	-736(ra) # 80000594 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000287c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002880:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002884:	00006517          	auipc	a0,0x6
    80002888:	abc50513          	addi	a0,a0,-1348 # 80008340 <states.0+0xa0>
    8000288c:	ffffe097          	auipc	ra,0xffffe
    80002890:	d08080e7          	jalr	-760(ra) # 80000594 <printf>
    p->killed = 1;
    80002894:	4785                	li	a5,1
    80002896:	d89c                	sw	a5,48(s1)
    exit(-1);
    80002898:	557d                	li	a0,-1
    8000289a:	fffff097          	auipc	ra,0xfffff
    8000289e:	7fe080e7          	jalr	2046(ra) # 80002098 <exit>
  if(which_dev == 2)
    800028a2:	4789                	li	a5,2
    800028a4:	f8f910e3          	bne	s2,a5,80002824 <usertrap+0x62>
    yield();
    800028a8:	00000097          	auipc	ra,0x0
    800028ac:	8fa080e7          	jalr	-1798(ra) # 800021a2 <yield>
    800028b0:	bf95                	j	80002824 <usertrap+0x62>
  int which_dev = 0;
    800028b2:	4901                	li	s2,0
    800028b4:	b7d5                	j	80002898 <usertrap+0xd6>

00000000800028b6 <kerneltrap>:
{
    800028b6:	7179                	addi	sp,sp,-48
    800028b8:	f406                	sd	ra,40(sp)
    800028ba:	f022                	sd	s0,32(sp)
    800028bc:	ec26                	sd	s1,24(sp)
    800028be:	e84a                	sd	s2,16(sp)
    800028c0:	e44e                	sd	s3,8(sp)
    800028c2:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028c4:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028c8:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028cc:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800028d0:	1004f793          	andi	a5,s1,256
    800028d4:	cb85                	beqz	a5,80002904 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028d6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800028da:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800028dc:	ef85                	bnez	a5,80002914 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    800028de:	00000097          	auipc	ra,0x0
    800028e2:	e42080e7          	jalr	-446(ra) # 80002720 <devintr>
    800028e6:	cd1d                	beqz	a0,80002924 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800028e8:	4789                	li	a5,2
    800028ea:	06f50a63          	beq	a0,a5,8000295e <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800028ee:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800028f2:	10049073          	csrw	sstatus,s1
}
    800028f6:	70a2                	ld	ra,40(sp)
    800028f8:	7402                	ld	s0,32(sp)
    800028fa:	64e2                	ld	s1,24(sp)
    800028fc:	6942                	ld	s2,16(sp)
    800028fe:	69a2                	ld	s3,8(sp)
    80002900:	6145                	addi	sp,sp,48
    80002902:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002904:	00006517          	auipc	a0,0x6
    80002908:	a5c50513          	addi	a0,a0,-1444 # 80008360 <states.0+0xc0>
    8000290c:	ffffe097          	auipc	ra,0xffffe
    80002910:	c3e080e7          	jalr	-962(ra) # 8000054a <panic>
    panic("kerneltrap: interrupts enabled");
    80002914:	00006517          	auipc	a0,0x6
    80002918:	a7450513          	addi	a0,a0,-1420 # 80008388 <states.0+0xe8>
    8000291c:	ffffe097          	auipc	ra,0xffffe
    80002920:	c2e080e7          	jalr	-978(ra) # 8000054a <panic>
    printf("scause %p\n", scause);
    80002924:	85ce                	mv	a1,s3
    80002926:	00006517          	auipc	a0,0x6
    8000292a:	a8250513          	addi	a0,a0,-1406 # 800083a8 <states.0+0x108>
    8000292e:	ffffe097          	auipc	ra,0xffffe
    80002932:	c66080e7          	jalr	-922(ra) # 80000594 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002936:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000293a:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000293e:	00006517          	auipc	a0,0x6
    80002942:	a7a50513          	addi	a0,a0,-1414 # 800083b8 <states.0+0x118>
    80002946:	ffffe097          	auipc	ra,0xffffe
    8000294a:	c4e080e7          	jalr	-946(ra) # 80000594 <printf>
    panic("kerneltrap");
    8000294e:	00006517          	auipc	a0,0x6
    80002952:	a8250513          	addi	a0,a0,-1406 # 800083d0 <states.0+0x130>
    80002956:	ffffe097          	auipc	ra,0xffffe
    8000295a:	bf4080e7          	jalr	-1036(ra) # 8000054a <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000295e:	fffff097          	auipc	ra,0xfffff
    80002962:	090080e7          	jalr	144(ra) # 800019ee <myproc>
    80002966:	d541                	beqz	a0,800028ee <kerneltrap+0x38>
    80002968:	fffff097          	auipc	ra,0xfffff
    8000296c:	086080e7          	jalr	134(ra) # 800019ee <myproc>
    80002970:	4d18                	lw	a4,24(a0)
    80002972:	478d                	li	a5,3
    80002974:	f6f71de3          	bne	a4,a5,800028ee <kerneltrap+0x38>
    yield();
    80002978:	00000097          	auipc	ra,0x0
    8000297c:	82a080e7          	jalr	-2006(ra) # 800021a2 <yield>
    80002980:	b7bd                	j	800028ee <kerneltrap+0x38>

0000000080002982 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002982:	1101                	addi	sp,sp,-32
    80002984:	ec06                	sd	ra,24(sp)
    80002986:	e822                	sd	s0,16(sp)
    80002988:	e426                	sd	s1,8(sp)
    8000298a:	1000                	addi	s0,sp,32
    8000298c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000298e:	fffff097          	auipc	ra,0xfffff
    80002992:	060080e7          	jalr	96(ra) # 800019ee <myproc>
  switch (n) {
    80002996:	4795                	li	a5,5
    80002998:	0497e163          	bltu	a5,s1,800029da <argraw+0x58>
    8000299c:	048a                	slli	s1,s1,0x2
    8000299e:	00006717          	auipc	a4,0x6
    800029a2:	a6a70713          	addi	a4,a4,-1430 # 80008408 <states.0+0x168>
    800029a6:	94ba                	add	s1,s1,a4
    800029a8:	409c                	lw	a5,0(s1)
    800029aa:	97ba                	add	a5,a5,a4
    800029ac:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800029ae:	6d3c                	ld	a5,88(a0)
    800029b0:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800029b2:	60e2                	ld	ra,24(sp)
    800029b4:	6442                	ld	s0,16(sp)
    800029b6:	64a2                	ld	s1,8(sp)
    800029b8:	6105                	addi	sp,sp,32
    800029ba:	8082                	ret
    return p->trapframe->a1;
    800029bc:	6d3c                	ld	a5,88(a0)
    800029be:	7fa8                	ld	a0,120(a5)
    800029c0:	bfcd                	j	800029b2 <argraw+0x30>
    return p->trapframe->a2;
    800029c2:	6d3c                	ld	a5,88(a0)
    800029c4:	63c8                	ld	a0,128(a5)
    800029c6:	b7f5                	j	800029b2 <argraw+0x30>
    return p->trapframe->a3;
    800029c8:	6d3c                	ld	a5,88(a0)
    800029ca:	67c8                	ld	a0,136(a5)
    800029cc:	b7dd                	j	800029b2 <argraw+0x30>
    return p->trapframe->a4;
    800029ce:	6d3c                	ld	a5,88(a0)
    800029d0:	6bc8                	ld	a0,144(a5)
    800029d2:	b7c5                	j	800029b2 <argraw+0x30>
    return p->trapframe->a5;
    800029d4:	6d3c                	ld	a5,88(a0)
    800029d6:	6fc8                	ld	a0,152(a5)
    800029d8:	bfe9                	j	800029b2 <argraw+0x30>
  panic("argraw");
    800029da:	00006517          	auipc	a0,0x6
    800029de:	a0650513          	addi	a0,a0,-1530 # 800083e0 <states.0+0x140>
    800029e2:	ffffe097          	auipc	ra,0xffffe
    800029e6:	b68080e7          	jalr	-1176(ra) # 8000054a <panic>

00000000800029ea <fetchaddr>:
{
    800029ea:	1101                	addi	sp,sp,-32
    800029ec:	ec06                	sd	ra,24(sp)
    800029ee:	e822                	sd	s0,16(sp)
    800029f0:	e426                	sd	s1,8(sp)
    800029f2:	e04a                	sd	s2,0(sp)
    800029f4:	1000                	addi	s0,sp,32
    800029f6:	84aa                	mv	s1,a0
    800029f8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800029fa:	fffff097          	auipc	ra,0xfffff
    800029fe:	ff4080e7          	jalr	-12(ra) # 800019ee <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002a02:	653c                	ld	a5,72(a0)
    80002a04:	02f4f863          	bgeu	s1,a5,80002a34 <fetchaddr+0x4a>
    80002a08:	00848713          	addi	a4,s1,8
    80002a0c:	02e7e663          	bltu	a5,a4,80002a38 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002a10:	46a1                	li	a3,8
    80002a12:	8626                	mv	a2,s1
    80002a14:	85ca                	mv	a1,s2
    80002a16:	6928                	ld	a0,80(a0)
    80002a18:	fffff097          	auipc	ra,0xfffff
    80002a1c:	cf6080e7          	jalr	-778(ra) # 8000170e <copyin>
    80002a20:	00a03533          	snez	a0,a0
    80002a24:	40a00533          	neg	a0,a0
}
    80002a28:	60e2                	ld	ra,24(sp)
    80002a2a:	6442                	ld	s0,16(sp)
    80002a2c:	64a2                	ld	s1,8(sp)
    80002a2e:	6902                	ld	s2,0(sp)
    80002a30:	6105                	addi	sp,sp,32
    80002a32:	8082                	ret
    return -1;
    80002a34:	557d                	li	a0,-1
    80002a36:	bfcd                	j	80002a28 <fetchaddr+0x3e>
    80002a38:	557d                	li	a0,-1
    80002a3a:	b7fd                	j	80002a28 <fetchaddr+0x3e>

0000000080002a3c <fetchstr>:
{
    80002a3c:	7179                	addi	sp,sp,-48
    80002a3e:	f406                	sd	ra,40(sp)
    80002a40:	f022                	sd	s0,32(sp)
    80002a42:	ec26                	sd	s1,24(sp)
    80002a44:	e84a                	sd	s2,16(sp)
    80002a46:	e44e                	sd	s3,8(sp)
    80002a48:	1800                	addi	s0,sp,48
    80002a4a:	892a                	mv	s2,a0
    80002a4c:	84ae                	mv	s1,a1
    80002a4e:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002a50:	fffff097          	auipc	ra,0xfffff
    80002a54:	f9e080e7          	jalr	-98(ra) # 800019ee <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002a58:	86ce                	mv	a3,s3
    80002a5a:	864a                	mv	a2,s2
    80002a5c:	85a6                	mv	a1,s1
    80002a5e:	6928                	ld	a0,80(a0)
    80002a60:	fffff097          	auipc	ra,0xfffff
    80002a64:	d3c080e7          	jalr	-708(ra) # 8000179c <copyinstr>
  if(err < 0)
    80002a68:	00054763          	bltz	a0,80002a76 <fetchstr+0x3a>
  return strlen(buf);
    80002a6c:	8526                	mv	a0,s1
    80002a6e:	ffffe097          	auipc	ra,0xffffe
    80002a72:	418080e7          	jalr	1048(ra) # 80000e86 <strlen>
}
    80002a76:	70a2                	ld	ra,40(sp)
    80002a78:	7402                	ld	s0,32(sp)
    80002a7a:	64e2                	ld	s1,24(sp)
    80002a7c:	6942                	ld	s2,16(sp)
    80002a7e:	69a2                	ld	s3,8(sp)
    80002a80:	6145                	addi	sp,sp,48
    80002a82:	8082                	ret

0000000080002a84 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002a84:	1101                	addi	sp,sp,-32
    80002a86:	ec06                	sd	ra,24(sp)
    80002a88:	e822                	sd	s0,16(sp)
    80002a8a:	e426                	sd	s1,8(sp)
    80002a8c:	1000                	addi	s0,sp,32
    80002a8e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002a90:	00000097          	auipc	ra,0x0
    80002a94:	ef2080e7          	jalr	-270(ra) # 80002982 <argraw>
    80002a98:	c088                	sw	a0,0(s1)
  return 0;
}
    80002a9a:	4501                	li	a0,0
    80002a9c:	60e2                	ld	ra,24(sp)
    80002a9e:	6442                	ld	s0,16(sp)
    80002aa0:	64a2                	ld	s1,8(sp)
    80002aa2:	6105                	addi	sp,sp,32
    80002aa4:	8082                	ret

0000000080002aa6 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002aa6:	1101                	addi	sp,sp,-32
    80002aa8:	ec06                	sd	ra,24(sp)
    80002aaa:	e822                	sd	s0,16(sp)
    80002aac:	e426                	sd	s1,8(sp)
    80002aae:	1000                	addi	s0,sp,32
    80002ab0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002ab2:	00000097          	auipc	ra,0x0
    80002ab6:	ed0080e7          	jalr	-304(ra) # 80002982 <argraw>
    80002aba:	e088                	sd	a0,0(s1)
  return 0;
}
    80002abc:	4501                	li	a0,0
    80002abe:	60e2                	ld	ra,24(sp)
    80002ac0:	6442                	ld	s0,16(sp)
    80002ac2:	64a2                	ld	s1,8(sp)
    80002ac4:	6105                	addi	sp,sp,32
    80002ac6:	8082                	ret

0000000080002ac8 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002ac8:	1101                	addi	sp,sp,-32
    80002aca:	ec06                	sd	ra,24(sp)
    80002acc:	e822                	sd	s0,16(sp)
    80002ace:	e426                	sd	s1,8(sp)
    80002ad0:	e04a                	sd	s2,0(sp)
    80002ad2:	1000                	addi	s0,sp,32
    80002ad4:	84ae                	mv	s1,a1
    80002ad6:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002ad8:	00000097          	auipc	ra,0x0
    80002adc:	eaa080e7          	jalr	-342(ra) # 80002982 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002ae0:	864a                	mv	a2,s2
    80002ae2:	85a6                	mv	a1,s1
    80002ae4:	00000097          	auipc	ra,0x0
    80002ae8:	f58080e7          	jalr	-168(ra) # 80002a3c <fetchstr>
}
    80002aec:	60e2                	ld	ra,24(sp)
    80002aee:	6442                	ld	s0,16(sp)
    80002af0:	64a2                	ld	s1,8(sp)
    80002af2:	6902                	ld	s2,0(sp)
    80002af4:	6105                	addi	sp,sp,32
    80002af6:	8082                	ret

0000000080002af8 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002af8:	1101                	addi	sp,sp,-32
    80002afa:	ec06                	sd	ra,24(sp)
    80002afc:	e822                	sd	s0,16(sp)
    80002afe:	e426                	sd	s1,8(sp)
    80002b00:	e04a                	sd	s2,0(sp)
    80002b02:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002b04:	fffff097          	auipc	ra,0xfffff
    80002b08:	eea080e7          	jalr	-278(ra) # 800019ee <myproc>
    80002b0c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002b0e:	05853903          	ld	s2,88(a0)
    80002b12:	0a893783          	ld	a5,168(s2)
    80002b16:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002b1a:	37fd                	addiw	a5,a5,-1
    80002b1c:	4751                	li	a4,20
    80002b1e:	00f76f63          	bltu	a4,a5,80002b3c <syscall+0x44>
    80002b22:	00369713          	slli	a4,a3,0x3
    80002b26:	00006797          	auipc	a5,0x6
    80002b2a:	8fa78793          	addi	a5,a5,-1798 # 80008420 <syscalls>
    80002b2e:	97ba                	add	a5,a5,a4
    80002b30:	639c                	ld	a5,0(a5)
    80002b32:	c789                	beqz	a5,80002b3c <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002b34:	9782                	jalr	a5
    80002b36:	06a93823          	sd	a0,112(s2)
    80002b3a:	a839                	j	80002b58 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002b3c:	15848613          	addi	a2,s1,344
    80002b40:	5c8c                	lw	a1,56(s1)
    80002b42:	00006517          	auipc	a0,0x6
    80002b46:	8a650513          	addi	a0,a0,-1882 # 800083e8 <states.0+0x148>
    80002b4a:	ffffe097          	auipc	ra,0xffffe
    80002b4e:	a4a080e7          	jalr	-1462(ra) # 80000594 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002b52:	6cbc                	ld	a5,88(s1)
    80002b54:	577d                	li	a4,-1
    80002b56:	fbb8                	sd	a4,112(a5)
  }
}
    80002b58:	60e2                	ld	ra,24(sp)
    80002b5a:	6442                	ld	s0,16(sp)
    80002b5c:	64a2                	ld	s1,8(sp)
    80002b5e:	6902                	ld	s2,0(sp)
    80002b60:	6105                	addi	sp,sp,32
    80002b62:	8082                	ret

0000000080002b64 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002b64:	1101                	addi	sp,sp,-32
    80002b66:	ec06                	sd	ra,24(sp)
    80002b68:	e822                	sd	s0,16(sp)
    80002b6a:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002b6c:	fec40593          	addi	a1,s0,-20
    80002b70:	4501                	li	a0,0
    80002b72:	00000097          	auipc	ra,0x0
    80002b76:	f12080e7          	jalr	-238(ra) # 80002a84 <argint>
    return -1;
    80002b7a:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002b7c:	00054963          	bltz	a0,80002b8e <sys_exit+0x2a>
  exit(n);
    80002b80:	fec42503          	lw	a0,-20(s0)
    80002b84:	fffff097          	auipc	ra,0xfffff
    80002b88:	514080e7          	jalr	1300(ra) # 80002098 <exit>
  return 0;  // not reached
    80002b8c:	4781                	li	a5,0
}
    80002b8e:	853e                	mv	a0,a5
    80002b90:	60e2                	ld	ra,24(sp)
    80002b92:	6442                	ld	s0,16(sp)
    80002b94:	6105                	addi	sp,sp,32
    80002b96:	8082                	ret

0000000080002b98 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002b98:	1141                	addi	sp,sp,-16
    80002b9a:	e406                	sd	ra,8(sp)
    80002b9c:	e022                	sd	s0,0(sp)
    80002b9e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002ba0:	fffff097          	auipc	ra,0xfffff
    80002ba4:	e4e080e7          	jalr	-434(ra) # 800019ee <myproc>
}
    80002ba8:	5d08                	lw	a0,56(a0)
    80002baa:	60a2                	ld	ra,8(sp)
    80002bac:	6402                	ld	s0,0(sp)
    80002bae:	0141                	addi	sp,sp,16
    80002bb0:	8082                	ret

0000000080002bb2 <sys_fork>:

uint64
sys_fork(void)
{
    80002bb2:	1141                	addi	sp,sp,-16
    80002bb4:	e406                	sd	ra,8(sp)
    80002bb6:	e022                	sd	s0,0(sp)
    80002bb8:	0800                	addi	s0,sp,16
  return fork();
    80002bba:	fffff097          	auipc	ra,0xfffff
    80002bbe:	1f4080e7          	jalr	500(ra) # 80001dae <fork>
}
    80002bc2:	60a2                	ld	ra,8(sp)
    80002bc4:	6402                	ld	s0,0(sp)
    80002bc6:	0141                	addi	sp,sp,16
    80002bc8:	8082                	ret

0000000080002bca <sys_wait>:

uint64
sys_wait(void)
{
    80002bca:	1101                	addi	sp,sp,-32
    80002bcc:	ec06                	sd	ra,24(sp)
    80002bce:	e822                	sd	s0,16(sp)
    80002bd0:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002bd2:	fe840593          	addi	a1,s0,-24
    80002bd6:	4501                	li	a0,0
    80002bd8:	00000097          	auipc	ra,0x0
    80002bdc:	ece080e7          	jalr	-306(ra) # 80002aa6 <argaddr>
    80002be0:	87aa                	mv	a5,a0
    return -1;
    80002be2:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002be4:	0007c863          	bltz	a5,80002bf4 <sys_wait+0x2a>
  return wait(p);
    80002be8:	fe843503          	ld	a0,-24(s0)
    80002bec:	fffff097          	auipc	ra,0xfffff
    80002bf0:	670080e7          	jalr	1648(ra) # 8000225c <wait>
}
    80002bf4:	60e2                	ld	ra,24(sp)
    80002bf6:	6442                	ld	s0,16(sp)
    80002bf8:	6105                	addi	sp,sp,32
    80002bfa:	8082                	ret

0000000080002bfc <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002bfc:	7179                	addi	sp,sp,-48
    80002bfe:	f406                	sd	ra,40(sp)
    80002c00:	f022                	sd	s0,32(sp)
    80002c02:	ec26                	sd	s1,24(sp)
    80002c04:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002c06:	fdc40593          	addi	a1,s0,-36
    80002c0a:	4501                	li	a0,0
    80002c0c:	00000097          	auipc	ra,0x0
    80002c10:	e78080e7          	jalr	-392(ra) # 80002a84 <argint>
    return -1;
    80002c14:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    80002c16:	00054f63          	bltz	a0,80002c34 <sys_sbrk+0x38>
  addr = myproc()->sz;
    80002c1a:	fffff097          	auipc	ra,0xfffff
    80002c1e:	dd4080e7          	jalr	-556(ra) # 800019ee <myproc>
    80002c22:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002c24:	fdc42503          	lw	a0,-36(s0)
    80002c28:	fffff097          	auipc	ra,0xfffff
    80002c2c:	112080e7          	jalr	274(ra) # 80001d3a <growproc>
    80002c30:	00054863          	bltz	a0,80002c40 <sys_sbrk+0x44>
    return -1;
  return addr;
}
    80002c34:	8526                	mv	a0,s1
    80002c36:	70a2                	ld	ra,40(sp)
    80002c38:	7402                	ld	s0,32(sp)
    80002c3a:	64e2                	ld	s1,24(sp)
    80002c3c:	6145                	addi	sp,sp,48
    80002c3e:	8082                	ret
    return -1;
    80002c40:	54fd                	li	s1,-1
    80002c42:	bfcd                	j	80002c34 <sys_sbrk+0x38>

0000000080002c44 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002c44:	7139                	addi	sp,sp,-64
    80002c46:	fc06                	sd	ra,56(sp)
    80002c48:	f822                	sd	s0,48(sp)
    80002c4a:	f426                	sd	s1,40(sp)
    80002c4c:	f04a                	sd	s2,32(sp)
    80002c4e:	ec4e                	sd	s3,24(sp)
    80002c50:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002c52:	fcc40593          	addi	a1,s0,-52
    80002c56:	4501                	li	a0,0
    80002c58:	00000097          	auipc	ra,0x0
    80002c5c:	e2c080e7          	jalr	-468(ra) # 80002a84 <argint>
    return -1;
    80002c60:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002c62:	06054563          	bltz	a0,80002ccc <sys_sleep+0x88>
  acquire(&tickslock);
    80002c66:	00014517          	auipc	a0,0x14
    80002c6a:	44250513          	addi	a0,a0,1090 # 800170a8 <tickslock>
    80002c6e:	ffffe097          	auipc	ra,0xffffe
    80002c72:	f98080e7          	jalr	-104(ra) # 80000c06 <acquire>
  ticks0 = ticks;
    80002c76:	00006917          	auipc	s2,0x6
    80002c7a:	3aa92903          	lw	s2,938(s2) # 80009020 <ticks>
  while(ticks - ticks0 < n){
    80002c7e:	fcc42783          	lw	a5,-52(s0)
    80002c82:	cf85                	beqz	a5,80002cba <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002c84:	00014997          	auipc	s3,0x14
    80002c88:	42498993          	addi	s3,s3,1060 # 800170a8 <tickslock>
    80002c8c:	00006497          	auipc	s1,0x6
    80002c90:	39448493          	addi	s1,s1,916 # 80009020 <ticks>
    if(myproc()->killed){
    80002c94:	fffff097          	auipc	ra,0xfffff
    80002c98:	d5a080e7          	jalr	-678(ra) # 800019ee <myproc>
    80002c9c:	591c                	lw	a5,48(a0)
    80002c9e:	ef9d                	bnez	a5,80002cdc <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002ca0:	85ce                	mv	a1,s3
    80002ca2:	8526                	mv	a0,s1
    80002ca4:	fffff097          	auipc	ra,0xfffff
    80002ca8:	53a080e7          	jalr	1338(ra) # 800021de <sleep>
  while(ticks - ticks0 < n){
    80002cac:	409c                	lw	a5,0(s1)
    80002cae:	412787bb          	subw	a5,a5,s2
    80002cb2:	fcc42703          	lw	a4,-52(s0)
    80002cb6:	fce7efe3          	bltu	a5,a4,80002c94 <sys_sleep+0x50>
  }
  release(&tickslock);
    80002cba:	00014517          	auipc	a0,0x14
    80002cbe:	3ee50513          	addi	a0,a0,1006 # 800170a8 <tickslock>
    80002cc2:	ffffe097          	auipc	ra,0xffffe
    80002cc6:	ff8080e7          	jalr	-8(ra) # 80000cba <release>
  return 0;
    80002cca:	4781                	li	a5,0
}
    80002ccc:	853e                	mv	a0,a5
    80002cce:	70e2                	ld	ra,56(sp)
    80002cd0:	7442                	ld	s0,48(sp)
    80002cd2:	74a2                	ld	s1,40(sp)
    80002cd4:	7902                	ld	s2,32(sp)
    80002cd6:	69e2                	ld	s3,24(sp)
    80002cd8:	6121                	addi	sp,sp,64
    80002cda:	8082                	ret
      release(&tickslock);
    80002cdc:	00014517          	auipc	a0,0x14
    80002ce0:	3cc50513          	addi	a0,a0,972 # 800170a8 <tickslock>
    80002ce4:	ffffe097          	auipc	ra,0xffffe
    80002ce8:	fd6080e7          	jalr	-42(ra) # 80000cba <release>
      return -1;
    80002cec:	57fd                	li	a5,-1
    80002cee:	bff9                	j	80002ccc <sys_sleep+0x88>

0000000080002cf0 <sys_kill>:

uint64
sys_kill(void)
{
    80002cf0:	1101                	addi	sp,sp,-32
    80002cf2:	ec06                	sd	ra,24(sp)
    80002cf4:	e822                	sd	s0,16(sp)
    80002cf6:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002cf8:	fec40593          	addi	a1,s0,-20
    80002cfc:	4501                	li	a0,0
    80002cfe:	00000097          	auipc	ra,0x0
    80002d02:	d86080e7          	jalr	-634(ra) # 80002a84 <argint>
    80002d06:	87aa                	mv	a5,a0
    return -1;
    80002d08:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002d0a:	0007c863          	bltz	a5,80002d1a <sys_kill+0x2a>
  return kill(pid);
    80002d0e:	fec42503          	lw	a0,-20(s0)
    80002d12:	fffff097          	auipc	ra,0xfffff
    80002d16:	6b6080e7          	jalr	1718(ra) # 800023c8 <kill>
}
    80002d1a:	60e2                	ld	ra,24(sp)
    80002d1c:	6442                	ld	s0,16(sp)
    80002d1e:	6105                	addi	sp,sp,32
    80002d20:	8082                	ret

0000000080002d22 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002d22:	1101                	addi	sp,sp,-32
    80002d24:	ec06                	sd	ra,24(sp)
    80002d26:	e822                	sd	s0,16(sp)
    80002d28:	e426                	sd	s1,8(sp)
    80002d2a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002d2c:	00014517          	auipc	a0,0x14
    80002d30:	37c50513          	addi	a0,a0,892 # 800170a8 <tickslock>
    80002d34:	ffffe097          	auipc	ra,0xffffe
    80002d38:	ed2080e7          	jalr	-302(ra) # 80000c06 <acquire>
  xticks = ticks;
    80002d3c:	00006497          	auipc	s1,0x6
    80002d40:	2e44a483          	lw	s1,740(s1) # 80009020 <ticks>
  release(&tickslock);
    80002d44:	00014517          	auipc	a0,0x14
    80002d48:	36450513          	addi	a0,a0,868 # 800170a8 <tickslock>
    80002d4c:	ffffe097          	auipc	ra,0xffffe
    80002d50:	f6e080e7          	jalr	-146(ra) # 80000cba <release>
  return xticks;
}
    80002d54:	02049513          	slli	a0,s1,0x20
    80002d58:	9101                	srli	a0,a0,0x20
    80002d5a:	60e2                	ld	ra,24(sp)
    80002d5c:	6442                	ld	s0,16(sp)
    80002d5e:	64a2                	ld	s1,8(sp)
    80002d60:	6105                	addi	sp,sp,32
    80002d62:	8082                	ret

0000000080002d64 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002d64:	7179                	addi	sp,sp,-48
    80002d66:	f406                	sd	ra,40(sp)
    80002d68:	f022                	sd	s0,32(sp)
    80002d6a:	ec26                	sd	s1,24(sp)
    80002d6c:	e84a                	sd	s2,16(sp)
    80002d6e:	e44e                	sd	s3,8(sp)
    80002d70:	e052                	sd	s4,0(sp)
    80002d72:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002d74:	00005597          	auipc	a1,0x5
    80002d78:	75c58593          	addi	a1,a1,1884 # 800084d0 <syscalls+0xb0>
    80002d7c:	00014517          	auipc	a0,0x14
    80002d80:	34450513          	addi	a0,a0,836 # 800170c0 <bcache>
    80002d84:	ffffe097          	auipc	ra,0xffffe
    80002d88:	df2080e7          	jalr	-526(ra) # 80000b76 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002d8c:	0001c797          	auipc	a5,0x1c
    80002d90:	33478793          	addi	a5,a5,820 # 8001f0c0 <bcache+0x8000>
    80002d94:	0001c717          	auipc	a4,0x1c
    80002d98:	59470713          	addi	a4,a4,1428 # 8001f328 <bcache+0x8268>
    80002d9c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002da0:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002da4:	00014497          	auipc	s1,0x14
    80002da8:	33448493          	addi	s1,s1,820 # 800170d8 <bcache+0x18>
    b->next = bcache.head.next;
    80002dac:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002dae:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002db0:	00005a17          	auipc	s4,0x5
    80002db4:	728a0a13          	addi	s4,s4,1832 # 800084d8 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002db8:	2b893783          	ld	a5,696(s2)
    80002dbc:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002dbe:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002dc2:	85d2                	mv	a1,s4
    80002dc4:	01048513          	addi	a0,s1,16
    80002dc8:	00001097          	auipc	ra,0x1
    80002dcc:	4c2080e7          	jalr	1218(ra) # 8000428a <initsleeplock>
    bcache.head.next->prev = b;
    80002dd0:	2b893783          	ld	a5,696(s2)
    80002dd4:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002dd6:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002dda:	45848493          	addi	s1,s1,1112
    80002dde:	fd349de3          	bne	s1,s3,80002db8 <binit+0x54>
  }
}
    80002de2:	70a2                	ld	ra,40(sp)
    80002de4:	7402                	ld	s0,32(sp)
    80002de6:	64e2                	ld	s1,24(sp)
    80002de8:	6942                	ld	s2,16(sp)
    80002dea:	69a2                	ld	s3,8(sp)
    80002dec:	6a02                	ld	s4,0(sp)
    80002dee:	6145                	addi	sp,sp,48
    80002df0:	8082                	ret

0000000080002df2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002df2:	7179                	addi	sp,sp,-48
    80002df4:	f406                	sd	ra,40(sp)
    80002df6:	f022                	sd	s0,32(sp)
    80002df8:	ec26                	sd	s1,24(sp)
    80002dfa:	e84a                	sd	s2,16(sp)
    80002dfc:	e44e                	sd	s3,8(sp)
    80002dfe:	1800                	addi	s0,sp,48
    80002e00:	892a                	mv	s2,a0
    80002e02:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002e04:	00014517          	auipc	a0,0x14
    80002e08:	2bc50513          	addi	a0,a0,700 # 800170c0 <bcache>
    80002e0c:	ffffe097          	auipc	ra,0xffffe
    80002e10:	dfa080e7          	jalr	-518(ra) # 80000c06 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002e14:	0001c497          	auipc	s1,0x1c
    80002e18:	5644b483          	ld	s1,1380(s1) # 8001f378 <bcache+0x82b8>
    80002e1c:	0001c797          	auipc	a5,0x1c
    80002e20:	50c78793          	addi	a5,a5,1292 # 8001f328 <bcache+0x8268>
    80002e24:	02f48f63          	beq	s1,a5,80002e62 <bread+0x70>
    80002e28:	873e                	mv	a4,a5
    80002e2a:	a021                	j	80002e32 <bread+0x40>
    80002e2c:	68a4                	ld	s1,80(s1)
    80002e2e:	02e48a63          	beq	s1,a4,80002e62 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002e32:	449c                	lw	a5,8(s1)
    80002e34:	ff279ce3          	bne	a5,s2,80002e2c <bread+0x3a>
    80002e38:	44dc                	lw	a5,12(s1)
    80002e3a:	ff3799e3          	bne	a5,s3,80002e2c <bread+0x3a>
      b->refcnt++;
    80002e3e:	40bc                	lw	a5,64(s1)
    80002e40:	2785                	addiw	a5,a5,1
    80002e42:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002e44:	00014517          	auipc	a0,0x14
    80002e48:	27c50513          	addi	a0,a0,636 # 800170c0 <bcache>
    80002e4c:	ffffe097          	auipc	ra,0xffffe
    80002e50:	e6e080e7          	jalr	-402(ra) # 80000cba <release>
      acquiresleep(&b->lock);
    80002e54:	01048513          	addi	a0,s1,16
    80002e58:	00001097          	auipc	ra,0x1
    80002e5c:	46c080e7          	jalr	1132(ra) # 800042c4 <acquiresleep>
      return b;
    80002e60:	a8b9                	j	80002ebe <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002e62:	0001c497          	auipc	s1,0x1c
    80002e66:	50e4b483          	ld	s1,1294(s1) # 8001f370 <bcache+0x82b0>
    80002e6a:	0001c797          	auipc	a5,0x1c
    80002e6e:	4be78793          	addi	a5,a5,1214 # 8001f328 <bcache+0x8268>
    80002e72:	00f48863          	beq	s1,a5,80002e82 <bread+0x90>
    80002e76:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002e78:	40bc                	lw	a5,64(s1)
    80002e7a:	cf81                	beqz	a5,80002e92 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002e7c:	64a4                	ld	s1,72(s1)
    80002e7e:	fee49de3          	bne	s1,a4,80002e78 <bread+0x86>
  panic("bget: no buffers");
    80002e82:	00005517          	auipc	a0,0x5
    80002e86:	65e50513          	addi	a0,a0,1630 # 800084e0 <syscalls+0xc0>
    80002e8a:	ffffd097          	auipc	ra,0xffffd
    80002e8e:	6c0080e7          	jalr	1728(ra) # 8000054a <panic>
      b->dev = dev;
    80002e92:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002e96:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002e9a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002e9e:	4785                	li	a5,1
    80002ea0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002ea2:	00014517          	auipc	a0,0x14
    80002ea6:	21e50513          	addi	a0,a0,542 # 800170c0 <bcache>
    80002eaa:	ffffe097          	auipc	ra,0xffffe
    80002eae:	e10080e7          	jalr	-496(ra) # 80000cba <release>
      acquiresleep(&b->lock);
    80002eb2:	01048513          	addi	a0,s1,16
    80002eb6:	00001097          	auipc	ra,0x1
    80002eba:	40e080e7          	jalr	1038(ra) # 800042c4 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002ebe:	409c                	lw	a5,0(s1)
    80002ec0:	cb89                	beqz	a5,80002ed2 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002ec2:	8526                	mv	a0,s1
    80002ec4:	70a2                	ld	ra,40(sp)
    80002ec6:	7402                	ld	s0,32(sp)
    80002ec8:	64e2                	ld	s1,24(sp)
    80002eca:	6942                	ld	s2,16(sp)
    80002ecc:	69a2                	ld	s3,8(sp)
    80002ece:	6145                	addi	sp,sp,48
    80002ed0:	8082                	ret
    virtio_disk_rw(b, 0);
    80002ed2:	4581                	li	a1,0
    80002ed4:	8526                	mv	a0,s1
    80002ed6:	00003097          	auipc	ra,0x3
    80002eda:	f50080e7          	jalr	-176(ra) # 80005e26 <virtio_disk_rw>
    b->valid = 1;
    80002ede:	4785                	li	a5,1
    80002ee0:	c09c                	sw	a5,0(s1)
  return b;
    80002ee2:	b7c5                	j	80002ec2 <bread+0xd0>

0000000080002ee4 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002ee4:	1101                	addi	sp,sp,-32
    80002ee6:	ec06                	sd	ra,24(sp)
    80002ee8:	e822                	sd	s0,16(sp)
    80002eea:	e426                	sd	s1,8(sp)
    80002eec:	1000                	addi	s0,sp,32
    80002eee:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002ef0:	0541                	addi	a0,a0,16
    80002ef2:	00001097          	auipc	ra,0x1
    80002ef6:	46c080e7          	jalr	1132(ra) # 8000435e <holdingsleep>
    80002efa:	cd01                	beqz	a0,80002f12 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002efc:	4585                	li	a1,1
    80002efe:	8526                	mv	a0,s1
    80002f00:	00003097          	auipc	ra,0x3
    80002f04:	f26080e7          	jalr	-218(ra) # 80005e26 <virtio_disk_rw>
}
    80002f08:	60e2                	ld	ra,24(sp)
    80002f0a:	6442                	ld	s0,16(sp)
    80002f0c:	64a2                	ld	s1,8(sp)
    80002f0e:	6105                	addi	sp,sp,32
    80002f10:	8082                	ret
    panic("bwrite");
    80002f12:	00005517          	auipc	a0,0x5
    80002f16:	5e650513          	addi	a0,a0,1510 # 800084f8 <syscalls+0xd8>
    80002f1a:	ffffd097          	auipc	ra,0xffffd
    80002f1e:	630080e7          	jalr	1584(ra) # 8000054a <panic>

0000000080002f22 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002f22:	1101                	addi	sp,sp,-32
    80002f24:	ec06                	sd	ra,24(sp)
    80002f26:	e822                	sd	s0,16(sp)
    80002f28:	e426                	sd	s1,8(sp)
    80002f2a:	e04a                	sd	s2,0(sp)
    80002f2c:	1000                	addi	s0,sp,32
    80002f2e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002f30:	01050913          	addi	s2,a0,16
    80002f34:	854a                	mv	a0,s2
    80002f36:	00001097          	auipc	ra,0x1
    80002f3a:	428080e7          	jalr	1064(ra) # 8000435e <holdingsleep>
    80002f3e:	c92d                	beqz	a0,80002fb0 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002f40:	854a                	mv	a0,s2
    80002f42:	00001097          	auipc	ra,0x1
    80002f46:	3d8080e7          	jalr	984(ra) # 8000431a <releasesleep>

  acquire(&bcache.lock);
    80002f4a:	00014517          	auipc	a0,0x14
    80002f4e:	17650513          	addi	a0,a0,374 # 800170c0 <bcache>
    80002f52:	ffffe097          	auipc	ra,0xffffe
    80002f56:	cb4080e7          	jalr	-844(ra) # 80000c06 <acquire>
  b->refcnt--;
    80002f5a:	40bc                	lw	a5,64(s1)
    80002f5c:	37fd                	addiw	a5,a5,-1
    80002f5e:	0007871b          	sext.w	a4,a5
    80002f62:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002f64:	eb05                	bnez	a4,80002f94 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002f66:	68bc                	ld	a5,80(s1)
    80002f68:	64b8                	ld	a4,72(s1)
    80002f6a:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002f6c:	64bc                	ld	a5,72(s1)
    80002f6e:	68b8                	ld	a4,80(s1)
    80002f70:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002f72:	0001c797          	auipc	a5,0x1c
    80002f76:	14e78793          	addi	a5,a5,334 # 8001f0c0 <bcache+0x8000>
    80002f7a:	2b87b703          	ld	a4,696(a5)
    80002f7e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002f80:	0001c717          	auipc	a4,0x1c
    80002f84:	3a870713          	addi	a4,a4,936 # 8001f328 <bcache+0x8268>
    80002f88:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002f8a:	2b87b703          	ld	a4,696(a5)
    80002f8e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002f90:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002f94:	00014517          	auipc	a0,0x14
    80002f98:	12c50513          	addi	a0,a0,300 # 800170c0 <bcache>
    80002f9c:	ffffe097          	auipc	ra,0xffffe
    80002fa0:	d1e080e7          	jalr	-738(ra) # 80000cba <release>
}
    80002fa4:	60e2                	ld	ra,24(sp)
    80002fa6:	6442                	ld	s0,16(sp)
    80002fa8:	64a2                	ld	s1,8(sp)
    80002faa:	6902                	ld	s2,0(sp)
    80002fac:	6105                	addi	sp,sp,32
    80002fae:	8082                	ret
    panic("brelse");
    80002fb0:	00005517          	auipc	a0,0x5
    80002fb4:	55050513          	addi	a0,a0,1360 # 80008500 <syscalls+0xe0>
    80002fb8:	ffffd097          	auipc	ra,0xffffd
    80002fbc:	592080e7          	jalr	1426(ra) # 8000054a <panic>

0000000080002fc0 <bpin>:

void
bpin(struct buf *b) {
    80002fc0:	1101                	addi	sp,sp,-32
    80002fc2:	ec06                	sd	ra,24(sp)
    80002fc4:	e822                	sd	s0,16(sp)
    80002fc6:	e426                	sd	s1,8(sp)
    80002fc8:	1000                	addi	s0,sp,32
    80002fca:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002fcc:	00014517          	auipc	a0,0x14
    80002fd0:	0f450513          	addi	a0,a0,244 # 800170c0 <bcache>
    80002fd4:	ffffe097          	auipc	ra,0xffffe
    80002fd8:	c32080e7          	jalr	-974(ra) # 80000c06 <acquire>
  b->refcnt++;
    80002fdc:	40bc                	lw	a5,64(s1)
    80002fde:	2785                	addiw	a5,a5,1
    80002fe0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002fe2:	00014517          	auipc	a0,0x14
    80002fe6:	0de50513          	addi	a0,a0,222 # 800170c0 <bcache>
    80002fea:	ffffe097          	auipc	ra,0xffffe
    80002fee:	cd0080e7          	jalr	-816(ra) # 80000cba <release>
}
    80002ff2:	60e2                	ld	ra,24(sp)
    80002ff4:	6442                	ld	s0,16(sp)
    80002ff6:	64a2                	ld	s1,8(sp)
    80002ff8:	6105                	addi	sp,sp,32
    80002ffa:	8082                	ret

0000000080002ffc <bunpin>:

void
bunpin(struct buf *b) {
    80002ffc:	1101                	addi	sp,sp,-32
    80002ffe:	ec06                	sd	ra,24(sp)
    80003000:	e822                	sd	s0,16(sp)
    80003002:	e426                	sd	s1,8(sp)
    80003004:	1000                	addi	s0,sp,32
    80003006:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003008:	00014517          	auipc	a0,0x14
    8000300c:	0b850513          	addi	a0,a0,184 # 800170c0 <bcache>
    80003010:	ffffe097          	auipc	ra,0xffffe
    80003014:	bf6080e7          	jalr	-1034(ra) # 80000c06 <acquire>
  b->refcnt--;
    80003018:	40bc                	lw	a5,64(s1)
    8000301a:	37fd                	addiw	a5,a5,-1
    8000301c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000301e:	00014517          	auipc	a0,0x14
    80003022:	0a250513          	addi	a0,a0,162 # 800170c0 <bcache>
    80003026:	ffffe097          	auipc	ra,0xffffe
    8000302a:	c94080e7          	jalr	-876(ra) # 80000cba <release>
}
    8000302e:	60e2                	ld	ra,24(sp)
    80003030:	6442                	ld	s0,16(sp)
    80003032:	64a2                	ld	s1,8(sp)
    80003034:	6105                	addi	sp,sp,32
    80003036:	8082                	ret

0000000080003038 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003038:	1101                	addi	sp,sp,-32
    8000303a:	ec06                	sd	ra,24(sp)
    8000303c:	e822                	sd	s0,16(sp)
    8000303e:	e426                	sd	s1,8(sp)
    80003040:	e04a                	sd	s2,0(sp)
    80003042:	1000                	addi	s0,sp,32
    80003044:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003046:	00d5d59b          	srliw	a1,a1,0xd
    8000304a:	0001c797          	auipc	a5,0x1c
    8000304e:	7527a783          	lw	a5,1874(a5) # 8001f79c <sb+0x1c>
    80003052:	9dbd                	addw	a1,a1,a5
    80003054:	00000097          	auipc	ra,0x0
    80003058:	d9e080e7          	jalr	-610(ra) # 80002df2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000305c:	0074f713          	andi	a4,s1,7
    80003060:	4785                	li	a5,1
    80003062:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003066:	14ce                	slli	s1,s1,0x33
    80003068:	90d9                	srli	s1,s1,0x36
    8000306a:	00950733          	add	a4,a0,s1
    8000306e:	05874703          	lbu	a4,88(a4)
    80003072:	00e7f6b3          	and	a3,a5,a4
    80003076:	c69d                	beqz	a3,800030a4 <bfree+0x6c>
    80003078:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000307a:	94aa                	add	s1,s1,a0
    8000307c:	fff7c793          	not	a5,a5
    80003080:	8ff9                	and	a5,a5,a4
    80003082:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80003086:	00001097          	auipc	ra,0x1
    8000308a:	116080e7          	jalr	278(ra) # 8000419c <log_write>
  brelse(bp);
    8000308e:	854a                	mv	a0,s2
    80003090:	00000097          	auipc	ra,0x0
    80003094:	e92080e7          	jalr	-366(ra) # 80002f22 <brelse>
}
    80003098:	60e2                	ld	ra,24(sp)
    8000309a:	6442                	ld	s0,16(sp)
    8000309c:	64a2                	ld	s1,8(sp)
    8000309e:	6902                	ld	s2,0(sp)
    800030a0:	6105                	addi	sp,sp,32
    800030a2:	8082                	ret
    panic("freeing free block");
    800030a4:	00005517          	auipc	a0,0x5
    800030a8:	46450513          	addi	a0,a0,1124 # 80008508 <syscalls+0xe8>
    800030ac:	ffffd097          	auipc	ra,0xffffd
    800030b0:	49e080e7          	jalr	1182(ra) # 8000054a <panic>

00000000800030b4 <balloc>:
{
    800030b4:	711d                	addi	sp,sp,-96
    800030b6:	ec86                	sd	ra,88(sp)
    800030b8:	e8a2                	sd	s0,80(sp)
    800030ba:	e4a6                	sd	s1,72(sp)
    800030bc:	e0ca                	sd	s2,64(sp)
    800030be:	fc4e                	sd	s3,56(sp)
    800030c0:	f852                	sd	s4,48(sp)
    800030c2:	f456                	sd	s5,40(sp)
    800030c4:	f05a                	sd	s6,32(sp)
    800030c6:	ec5e                	sd	s7,24(sp)
    800030c8:	e862                	sd	s8,16(sp)
    800030ca:	e466                	sd	s9,8(sp)
    800030cc:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800030ce:	0001c797          	auipc	a5,0x1c
    800030d2:	6b67a783          	lw	a5,1718(a5) # 8001f784 <sb+0x4>
    800030d6:	cbd1                	beqz	a5,8000316a <balloc+0xb6>
    800030d8:	8baa                	mv	s7,a0
    800030da:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800030dc:	0001cb17          	auipc	s6,0x1c
    800030e0:	6a4b0b13          	addi	s6,s6,1700 # 8001f780 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800030e4:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800030e6:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800030e8:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800030ea:	6c89                	lui	s9,0x2
    800030ec:	a831                	j	80003108 <balloc+0x54>
    brelse(bp);
    800030ee:	854a                	mv	a0,s2
    800030f0:	00000097          	auipc	ra,0x0
    800030f4:	e32080e7          	jalr	-462(ra) # 80002f22 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800030f8:	015c87bb          	addw	a5,s9,s5
    800030fc:	00078a9b          	sext.w	s5,a5
    80003100:	004b2703          	lw	a4,4(s6)
    80003104:	06eaf363          	bgeu	s5,a4,8000316a <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80003108:	41fad79b          	sraiw	a5,s5,0x1f
    8000310c:	0137d79b          	srliw	a5,a5,0x13
    80003110:	015787bb          	addw	a5,a5,s5
    80003114:	40d7d79b          	sraiw	a5,a5,0xd
    80003118:	01cb2583          	lw	a1,28(s6)
    8000311c:	9dbd                	addw	a1,a1,a5
    8000311e:	855e                	mv	a0,s7
    80003120:	00000097          	auipc	ra,0x0
    80003124:	cd2080e7          	jalr	-814(ra) # 80002df2 <bread>
    80003128:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000312a:	004b2503          	lw	a0,4(s6)
    8000312e:	000a849b          	sext.w	s1,s5
    80003132:	8662                	mv	a2,s8
    80003134:	faa4fde3          	bgeu	s1,a0,800030ee <balloc+0x3a>
      m = 1 << (bi % 8);
    80003138:	41f6579b          	sraiw	a5,a2,0x1f
    8000313c:	01d7d69b          	srliw	a3,a5,0x1d
    80003140:	00c6873b          	addw	a4,a3,a2
    80003144:	00777793          	andi	a5,a4,7
    80003148:	9f95                	subw	a5,a5,a3
    8000314a:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000314e:	4037571b          	sraiw	a4,a4,0x3
    80003152:	00e906b3          	add	a3,s2,a4
    80003156:	0586c683          	lbu	a3,88(a3)
    8000315a:	00d7f5b3          	and	a1,a5,a3
    8000315e:	cd91                	beqz	a1,8000317a <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003160:	2605                	addiw	a2,a2,1
    80003162:	2485                	addiw	s1,s1,1
    80003164:	fd4618e3          	bne	a2,s4,80003134 <balloc+0x80>
    80003168:	b759                	j	800030ee <balloc+0x3a>
  panic("balloc: out of blocks");
    8000316a:	00005517          	auipc	a0,0x5
    8000316e:	3b650513          	addi	a0,a0,950 # 80008520 <syscalls+0x100>
    80003172:	ffffd097          	auipc	ra,0xffffd
    80003176:	3d8080e7          	jalr	984(ra) # 8000054a <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000317a:	974a                	add	a4,a4,s2
    8000317c:	8fd5                	or	a5,a5,a3
    8000317e:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80003182:	854a                	mv	a0,s2
    80003184:	00001097          	auipc	ra,0x1
    80003188:	018080e7          	jalr	24(ra) # 8000419c <log_write>
        brelse(bp);
    8000318c:	854a                	mv	a0,s2
    8000318e:	00000097          	auipc	ra,0x0
    80003192:	d94080e7          	jalr	-620(ra) # 80002f22 <brelse>
  bp = bread(dev, bno);
    80003196:	85a6                	mv	a1,s1
    80003198:	855e                	mv	a0,s7
    8000319a:	00000097          	auipc	ra,0x0
    8000319e:	c58080e7          	jalr	-936(ra) # 80002df2 <bread>
    800031a2:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800031a4:	40000613          	li	a2,1024
    800031a8:	4581                	li	a1,0
    800031aa:	05850513          	addi	a0,a0,88
    800031ae:	ffffe097          	auipc	ra,0xffffe
    800031b2:	b54080e7          	jalr	-1196(ra) # 80000d02 <memset>
  log_write(bp);
    800031b6:	854a                	mv	a0,s2
    800031b8:	00001097          	auipc	ra,0x1
    800031bc:	fe4080e7          	jalr	-28(ra) # 8000419c <log_write>
  brelse(bp);
    800031c0:	854a                	mv	a0,s2
    800031c2:	00000097          	auipc	ra,0x0
    800031c6:	d60080e7          	jalr	-672(ra) # 80002f22 <brelse>
}
    800031ca:	8526                	mv	a0,s1
    800031cc:	60e6                	ld	ra,88(sp)
    800031ce:	6446                	ld	s0,80(sp)
    800031d0:	64a6                	ld	s1,72(sp)
    800031d2:	6906                	ld	s2,64(sp)
    800031d4:	79e2                	ld	s3,56(sp)
    800031d6:	7a42                	ld	s4,48(sp)
    800031d8:	7aa2                	ld	s5,40(sp)
    800031da:	7b02                	ld	s6,32(sp)
    800031dc:	6be2                	ld	s7,24(sp)
    800031de:	6c42                	ld	s8,16(sp)
    800031e0:	6ca2                	ld	s9,8(sp)
    800031e2:	6125                	addi	sp,sp,96
    800031e4:	8082                	ret

00000000800031e6 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800031e6:	7179                	addi	sp,sp,-48
    800031e8:	f406                	sd	ra,40(sp)
    800031ea:	f022                	sd	s0,32(sp)
    800031ec:	ec26                	sd	s1,24(sp)
    800031ee:	e84a                	sd	s2,16(sp)
    800031f0:	e44e                	sd	s3,8(sp)
    800031f2:	e052                	sd	s4,0(sp)
    800031f4:	1800                	addi	s0,sp,48
    800031f6:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800031f8:	47ad                	li	a5,11
    800031fa:	04b7fe63          	bgeu	a5,a1,80003256 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800031fe:	ff45849b          	addiw	s1,a1,-12
    80003202:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003206:	0ff00793          	li	a5,255
    8000320a:	0ae7e363          	bltu	a5,a4,800032b0 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000320e:	08052583          	lw	a1,128(a0)
    80003212:	c5ad                	beqz	a1,8000327c <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80003214:	00092503          	lw	a0,0(s2)
    80003218:	00000097          	auipc	ra,0x0
    8000321c:	bda080e7          	jalr	-1062(ra) # 80002df2 <bread>
    80003220:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003222:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003226:	02049593          	slli	a1,s1,0x20
    8000322a:	9181                	srli	a1,a1,0x20
    8000322c:	058a                	slli	a1,a1,0x2
    8000322e:	00b784b3          	add	s1,a5,a1
    80003232:	0004a983          	lw	s3,0(s1)
    80003236:	04098d63          	beqz	s3,80003290 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000323a:	8552                	mv	a0,s4
    8000323c:	00000097          	auipc	ra,0x0
    80003240:	ce6080e7          	jalr	-794(ra) # 80002f22 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003244:	854e                	mv	a0,s3
    80003246:	70a2                	ld	ra,40(sp)
    80003248:	7402                	ld	s0,32(sp)
    8000324a:	64e2                	ld	s1,24(sp)
    8000324c:	6942                	ld	s2,16(sp)
    8000324e:	69a2                	ld	s3,8(sp)
    80003250:	6a02                	ld	s4,0(sp)
    80003252:	6145                	addi	sp,sp,48
    80003254:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80003256:	02059493          	slli	s1,a1,0x20
    8000325a:	9081                	srli	s1,s1,0x20
    8000325c:	048a                	slli	s1,s1,0x2
    8000325e:	94aa                	add	s1,s1,a0
    80003260:	0504a983          	lw	s3,80(s1)
    80003264:	fe0990e3          	bnez	s3,80003244 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80003268:	4108                	lw	a0,0(a0)
    8000326a:	00000097          	auipc	ra,0x0
    8000326e:	e4a080e7          	jalr	-438(ra) # 800030b4 <balloc>
    80003272:	0005099b          	sext.w	s3,a0
    80003276:	0534a823          	sw	s3,80(s1)
    8000327a:	b7e9                	j	80003244 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000327c:	4108                	lw	a0,0(a0)
    8000327e:	00000097          	auipc	ra,0x0
    80003282:	e36080e7          	jalr	-458(ra) # 800030b4 <balloc>
    80003286:	0005059b          	sext.w	a1,a0
    8000328a:	08b92023          	sw	a1,128(s2)
    8000328e:	b759                	j	80003214 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80003290:	00092503          	lw	a0,0(s2)
    80003294:	00000097          	auipc	ra,0x0
    80003298:	e20080e7          	jalr	-480(ra) # 800030b4 <balloc>
    8000329c:	0005099b          	sext.w	s3,a0
    800032a0:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800032a4:	8552                	mv	a0,s4
    800032a6:	00001097          	auipc	ra,0x1
    800032aa:	ef6080e7          	jalr	-266(ra) # 8000419c <log_write>
    800032ae:	b771                	j	8000323a <bmap+0x54>
  panic("bmap: out of range");
    800032b0:	00005517          	auipc	a0,0x5
    800032b4:	28850513          	addi	a0,a0,648 # 80008538 <syscalls+0x118>
    800032b8:	ffffd097          	auipc	ra,0xffffd
    800032bc:	292080e7          	jalr	658(ra) # 8000054a <panic>

00000000800032c0 <iget>:
{
    800032c0:	7179                	addi	sp,sp,-48
    800032c2:	f406                	sd	ra,40(sp)
    800032c4:	f022                	sd	s0,32(sp)
    800032c6:	ec26                	sd	s1,24(sp)
    800032c8:	e84a                	sd	s2,16(sp)
    800032ca:	e44e                	sd	s3,8(sp)
    800032cc:	e052                	sd	s4,0(sp)
    800032ce:	1800                	addi	s0,sp,48
    800032d0:	89aa                	mv	s3,a0
    800032d2:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    800032d4:	0001c517          	auipc	a0,0x1c
    800032d8:	4cc50513          	addi	a0,a0,1228 # 8001f7a0 <icache>
    800032dc:	ffffe097          	auipc	ra,0xffffe
    800032e0:	92a080e7          	jalr	-1750(ra) # 80000c06 <acquire>
  empty = 0;
    800032e4:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800032e6:	0001c497          	auipc	s1,0x1c
    800032ea:	4d248493          	addi	s1,s1,1234 # 8001f7b8 <icache+0x18>
    800032ee:	0001e697          	auipc	a3,0x1e
    800032f2:	f5a68693          	addi	a3,a3,-166 # 80021248 <log>
    800032f6:	a039                	j	80003304 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800032f8:	02090b63          	beqz	s2,8000332e <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800032fc:	08848493          	addi	s1,s1,136
    80003300:	02d48a63          	beq	s1,a3,80003334 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003304:	449c                	lw	a5,8(s1)
    80003306:	fef059e3          	blez	a5,800032f8 <iget+0x38>
    8000330a:	4098                	lw	a4,0(s1)
    8000330c:	ff3716e3          	bne	a4,s3,800032f8 <iget+0x38>
    80003310:	40d8                	lw	a4,4(s1)
    80003312:	ff4713e3          	bne	a4,s4,800032f8 <iget+0x38>
      ip->ref++;
    80003316:	2785                	addiw	a5,a5,1
    80003318:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    8000331a:	0001c517          	auipc	a0,0x1c
    8000331e:	48650513          	addi	a0,a0,1158 # 8001f7a0 <icache>
    80003322:	ffffe097          	auipc	ra,0xffffe
    80003326:	998080e7          	jalr	-1640(ra) # 80000cba <release>
      return ip;
    8000332a:	8926                	mv	s2,s1
    8000332c:	a03d                	j	8000335a <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000332e:	f7f9                	bnez	a5,800032fc <iget+0x3c>
    80003330:	8926                	mv	s2,s1
    80003332:	b7e9                	j	800032fc <iget+0x3c>
  if(empty == 0)
    80003334:	02090c63          	beqz	s2,8000336c <iget+0xac>
  ip->dev = dev;
    80003338:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000333c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003340:	4785                	li	a5,1
    80003342:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003346:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    8000334a:	0001c517          	auipc	a0,0x1c
    8000334e:	45650513          	addi	a0,a0,1110 # 8001f7a0 <icache>
    80003352:	ffffe097          	auipc	ra,0xffffe
    80003356:	968080e7          	jalr	-1688(ra) # 80000cba <release>
}
    8000335a:	854a                	mv	a0,s2
    8000335c:	70a2                	ld	ra,40(sp)
    8000335e:	7402                	ld	s0,32(sp)
    80003360:	64e2                	ld	s1,24(sp)
    80003362:	6942                	ld	s2,16(sp)
    80003364:	69a2                	ld	s3,8(sp)
    80003366:	6a02                	ld	s4,0(sp)
    80003368:	6145                	addi	sp,sp,48
    8000336a:	8082                	ret
    panic("iget: no inodes");
    8000336c:	00005517          	auipc	a0,0x5
    80003370:	1e450513          	addi	a0,a0,484 # 80008550 <syscalls+0x130>
    80003374:	ffffd097          	auipc	ra,0xffffd
    80003378:	1d6080e7          	jalr	470(ra) # 8000054a <panic>

000000008000337c <fsinit>:
fsinit(int dev) {
    8000337c:	7179                	addi	sp,sp,-48
    8000337e:	f406                	sd	ra,40(sp)
    80003380:	f022                	sd	s0,32(sp)
    80003382:	ec26                	sd	s1,24(sp)
    80003384:	e84a                	sd	s2,16(sp)
    80003386:	e44e                	sd	s3,8(sp)
    80003388:	1800                	addi	s0,sp,48
    8000338a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000338c:	4585                	li	a1,1
    8000338e:	00000097          	auipc	ra,0x0
    80003392:	a64080e7          	jalr	-1436(ra) # 80002df2 <bread>
    80003396:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003398:	0001c997          	auipc	s3,0x1c
    8000339c:	3e898993          	addi	s3,s3,1000 # 8001f780 <sb>
    800033a0:	02000613          	li	a2,32
    800033a4:	05850593          	addi	a1,a0,88
    800033a8:	854e                	mv	a0,s3
    800033aa:	ffffe097          	auipc	ra,0xffffe
    800033ae:	9b4080e7          	jalr	-1612(ra) # 80000d5e <memmove>
  brelse(bp);
    800033b2:	8526                	mv	a0,s1
    800033b4:	00000097          	auipc	ra,0x0
    800033b8:	b6e080e7          	jalr	-1170(ra) # 80002f22 <brelse>
  if(sb.magic != FSMAGIC)
    800033bc:	0009a703          	lw	a4,0(s3)
    800033c0:	102037b7          	lui	a5,0x10203
    800033c4:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800033c8:	02f71263          	bne	a4,a5,800033ec <fsinit+0x70>
  initlog(dev, &sb);
    800033cc:	0001c597          	auipc	a1,0x1c
    800033d0:	3b458593          	addi	a1,a1,948 # 8001f780 <sb>
    800033d4:	854a                	mv	a0,s2
    800033d6:	00001097          	auipc	ra,0x1
    800033da:	b4a080e7          	jalr	-1206(ra) # 80003f20 <initlog>
}
    800033de:	70a2                	ld	ra,40(sp)
    800033e0:	7402                	ld	s0,32(sp)
    800033e2:	64e2                	ld	s1,24(sp)
    800033e4:	6942                	ld	s2,16(sp)
    800033e6:	69a2                	ld	s3,8(sp)
    800033e8:	6145                	addi	sp,sp,48
    800033ea:	8082                	ret
    panic("invalid file system");
    800033ec:	00005517          	auipc	a0,0x5
    800033f0:	17450513          	addi	a0,a0,372 # 80008560 <syscalls+0x140>
    800033f4:	ffffd097          	auipc	ra,0xffffd
    800033f8:	156080e7          	jalr	342(ra) # 8000054a <panic>

00000000800033fc <iinit>:
{
    800033fc:	7179                	addi	sp,sp,-48
    800033fe:	f406                	sd	ra,40(sp)
    80003400:	f022                	sd	s0,32(sp)
    80003402:	ec26                	sd	s1,24(sp)
    80003404:	e84a                	sd	s2,16(sp)
    80003406:	e44e                	sd	s3,8(sp)
    80003408:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    8000340a:	00005597          	auipc	a1,0x5
    8000340e:	16e58593          	addi	a1,a1,366 # 80008578 <syscalls+0x158>
    80003412:	0001c517          	auipc	a0,0x1c
    80003416:	38e50513          	addi	a0,a0,910 # 8001f7a0 <icache>
    8000341a:	ffffd097          	auipc	ra,0xffffd
    8000341e:	75c080e7          	jalr	1884(ra) # 80000b76 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003422:	0001c497          	auipc	s1,0x1c
    80003426:	3a648493          	addi	s1,s1,934 # 8001f7c8 <icache+0x28>
    8000342a:	0001e997          	auipc	s3,0x1e
    8000342e:	e2e98993          	addi	s3,s3,-466 # 80021258 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    80003432:	00005917          	auipc	s2,0x5
    80003436:	14e90913          	addi	s2,s2,334 # 80008580 <syscalls+0x160>
    8000343a:	85ca                	mv	a1,s2
    8000343c:	8526                	mv	a0,s1
    8000343e:	00001097          	auipc	ra,0x1
    80003442:	e4c080e7          	jalr	-436(ra) # 8000428a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003446:	08848493          	addi	s1,s1,136
    8000344a:	ff3498e3          	bne	s1,s3,8000343a <iinit+0x3e>
}
    8000344e:	70a2                	ld	ra,40(sp)
    80003450:	7402                	ld	s0,32(sp)
    80003452:	64e2                	ld	s1,24(sp)
    80003454:	6942                	ld	s2,16(sp)
    80003456:	69a2                	ld	s3,8(sp)
    80003458:	6145                	addi	sp,sp,48
    8000345a:	8082                	ret

000000008000345c <ialloc>:
{
    8000345c:	715d                	addi	sp,sp,-80
    8000345e:	e486                	sd	ra,72(sp)
    80003460:	e0a2                	sd	s0,64(sp)
    80003462:	fc26                	sd	s1,56(sp)
    80003464:	f84a                	sd	s2,48(sp)
    80003466:	f44e                	sd	s3,40(sp)
    80003468:	f052                	sd	s4,32(sp)
    8000346a:	ec56                	sd	s5,24(sp)
    8000346c:	e85a                	sd	s6,16(sp)
    8000346e:	e45e                	sd	s7,8(sp)
    80003470:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003472:	0001c717          	auipc	a4,0x1c
    80003476:	31a72703          	lw	a4,794(a4) # 8001f78c <sb+0xc>
    8000347a:	4785                	li	a5,1
    8000347c:	04e7fa63          	bgeu	a5,a4,800034d0 <ialloc+0x74>
    80003480:	8aaa                	mv	s5,a0
    80003482:	8bae                	mv	s7,a1
    80003484:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003486:	0001ca17          	auipc	s4,0x1c
    8000348a:	2faa0a13          	addi	s4,s4,762 # 8001f780 <sb>
    8000348e:	00048b1b          	sext.w	s6,s1
    80003492:	0044d793          	srli	a5,s1,0x4
    80003496:	018a2583          	lw	a1,24(s4)
    8000349a:	9dbd                	addw	a1,a1,a5
    8000349c:	8556                	mv	a0,s5
    8000349e:	00000097          	auipc	ra,0x0
    800034a2:	954080e7          	jalr	-1708(ra) # 80002df2 <bread>
    800034a6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800034a8:	05850993          	addi	s3,a0,88
    800034ac:	00f4f793          	andi	a5,s1,15
    800034b0:	079a                	slli	a5,a5,0x6
    800034b2:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800034b4:	00099783          	lh	a5,0(s3)
    800034b8:	c785                	beqz	a5,800034e0 <ialloc+0x84>
    brelse(bp);
    800034ba:	00000097          	auipc	ra,0x0
    800034be:	a68080e7          	jalr	-1432(ra) # 80002f22 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800034c2:	0485                	addi	s1,s1,1
    800034c4:	00ca2703          	lw	a4,12(s4)
    800034c8:	0004879b          	sext.w	a5,s1
    800034cc:	fce7e1e3          	bltu	a5,a4,8000348e <ialloc+0x32>
  panic("ialloc: no inodes");
    800034d0:	00005517          	auipc	a0,0x5
    800034d4:	0b850513          	addi	a0,a0,184 # 80008588 <syscalls+0x168>
    800034d8:	ffffd097          	auipc	ra,0xffffd
    800034dc:	072080e7          	jalr	114(ra) # 8000054a <panic>
      memset(dip, 0, sizeof(*dip));
    800034e0:	04000613          	li	a2,64
    800034e4:	4581                	li	a1,0
    800034e6:	854e                	mv	a0,s3
    800034e8:	ffffe097          	auipc	ra,0xffffe
    800034ec:	81a080e7          	jalr	-2022(ra) # 80000d02 <memset>
      dip->type = type;
    800034f0:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800034f4:	854a                	mv	a0,s2
    800034f6:	00001097          	auipc	ra,0x1
    800034fa:	ca6080e7          	jalr	-858(ra) # 8000419c <log_write>
      brelse(bp);
    800034fe:	854a                	mv	a0,s2
    80003500:	00000097          	auipc	ra,0x0
    80003504:	a22080e7          	jalr	-1502(ra) # 80002f22 <brelse>
      return iget(dev, inum);
    80003508:	85da                	mv	a1,s6
    8000350a:	8556                	mv	a0,s5
    8000350c:	00000097          	auipc	ra,0x0
    80003510:	db4080e7          	jalr	-588(ra) # 800032c0 <iget>
}
    80003514:	60a6                	ld	ra,72(sp)
    80003516:	6406                	ld	s0,64(sp)
    80003518:	74e2                	ld	s1,56(sp)
    8000351a:	7942                	ld	s2,48(sp)
    8000351c:	79a2                	ld	s3,40(sp)
    8000351e:	7a02                	ld	s4,32(sp)
    80003520:	6ae2                	ld	s5,24(sp)
    80003522:	6b42                	ld	s6,16(sp)
    80003524:	6ba2                	ld	s7,8(sp)
    80003526:	6161                	addi	sp,sp,80
    80003528:	8082                	ret

000000008000352a <iupdate>:
{
    8000352a:	1101                	addi	sp,sp,-32
    8000352c:	ec06                	sd	ra,24(sp)
    8000352e:	e822                	sd	s0,16(sp)
    80003530:	e426                	sd	s1,8(sp)
    80003532:	e04a                	sd	s2,0(sp)
    80003534:	1000                	addi	s0,sp,32
    80003536:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003538:	415c                	lw	a5,4(a0)
    8000353a:	0047d79b          	srliw	a5,a5,0x4
    8000353e:	0001c597          	auipc	a1,0x1c
    80003542:	25a5a583          	lw	a1,602(a1) # 8001f798 <sb+0x18>
    80003546:	9dbd                	addw	a1,a1,a5
    80003548:	4108                	lw	a0,0(a0)
    8000354a:	00000097          	auipc	ra,0x0
    8000354e:	8a8080e7          	jalr	-1880(ra) # 80002df2 <bread>
    80003552:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003554:	05850793          	addi	a5,a0,88
    80003558:	40c8                	lw	a0,4(s1)
    8000355a:	893d                	andi	a0,a0,15
    8000355c:	051a                	slli	a0,a0,0x6
    8000355e:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003560:	04449703          	lh	a4,68(s1)
    80003564:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003568:	04649703          	lh	a4,70(s1)
    8000356c:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003570:	04849703          	lh	a4,72(s1)
    80003574:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003578:	04a49703          	lh	a4,74(s1)
    8000357c:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003580:	44f8                	lw	a4,76(s1)
    80003582:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003584:	03400613          	li	a2,52
    80003588:	05048593          	addi	a1,s1,80
    8000358c:	0531                	addi	a0,a0,12
    8000358e:	ffffd097          	auipc	ra,0xffffd
    80003592:	7d0080e7          	jalr	2000(ra) # 80000d5e <memmove>
  log_write(bp);
    80003596:	854a                	mv	a0,s2
    80003598:	00001097          	auipc	ra,0x1
    8000359c:	c04080e7          	jalr	-1020(ra) # 8000419c <log_write>
  brelse(bp);
    800035a0:	854a                	mv	a0,s2
    800035a2:	00000097          	auipc	ra,0x0
    800035a6:	980080e7          	jalr	-1664(ra) # 80002f22 <brelse>
}
    800035aa:	60e2                	ld	ra,24(sp)
    800035ac:	6442                	ld	s0,16(sp)
    800035ae:	64a2                	ld	s1,8(sp)
    800035b0:	6902                	ld	s2,0(sp)
    800035b2:	6105                	addi	sp,sp,32
    800035b4:	8082                	ret

00000000800035b6 <idup>:
{
    800035b6:	1101                	addi	sp,sp,-32
    800035b8:	ec06                	sd	ra,24(sp)
    800035ba:	e822                	sd	s0,16(sp)
    800035bc:	e426                	sd	s1,8(sp)
    800035be:	1000                	addi	s0,sp,32
    800035c0:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800035c2:	0001c517          	auipc	a0,0x1c
    800035c6:	1de50513          	addi	a0,a0,478 # 8001f7a0 <icache>
    800035ca:	ffffd097          	auipc	ra,0xffffd
    800035ce:	63c080e7          	jalr	1596(ra) # 80000c06 <acquire>
  ip->ref++;
    800035d2:	449c                	lw	a5,8(s1)
    800035d4:	2785                	addiw	a5,a5,1
    800035d6:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800035d8:	0001c517          	auipc	a0,0x1c
    800035dc:	1c850513          	addi	a0,a0,456 # 8001f7a0 <icache>
    800035e0:	ffffd097          	auipc	ra,0xffffd
    800035e4:	6da080e7          	jalr	1754(ra) # 80000cba <release>
}
    800035e8:	8526                	mv	a0,s1
    800035ea:	60e2                	ld	ra,24(sp)
    800035ec:	6442                	ld	s0,16(sp)
    800035ee:	64a2                	ld	s1,8(sp)
    800035f0:	6105                	addi	sp,sp,32
    800035f2:	8082                	ret

00000000800035f4 <ilock>:
{
    800035f4:	1101                	addi	sp,sp,-32
    800035f6:	ec06                	sd	ra,24(sp)
    800035f8:	e822                	sd	s0,16(sp)
    800035fa:	e426                	sd	s1,8(sp)
    800035fc:	e04a                	sd	s2,0(sp)
    800035fe:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003600:	c115                	beqz	a0,80003624 <ilock+0x30>
    80003602:	84aa                	mv	s1,a0
    80003604:	451c                	lw	a5,8(a0)
    80003606:	00f05f63          	blez	a5,80003624 <ilock+0x30>
  acquiresleep(&ip->lock);
    8000360a:	0541                	addi	a0,a0,16
    8000360c:	00001097          	auipc	ra,0x1
    80003610:	cb8080e7          	jalr	-840(ra) # 800042c4 <acquiresleep>
  if(ip->valid == 0){
    80003614:	40bc                	lw	a5,64(s1)
    80003616:	cf99                	beqz	a5,80003634 <ilock+0x40>
}
    80003618:	60e2                	ld	ra,24(sp)
    8000361a:	6442                	ld	s0,16(sp)
    8000361c:	64a2                	ld	s1,8(sp)
    8000361e:	6902                	ld	s2,0(sp)
    80003620:	6105                	addi	sp,sp,32
    80003622:	8082                	ret
    panic("ilock");
    80003624:	00005517          	auipc	a0,0x5
    80003628:	f7c50513          	addi	a0,a0,-132 # 800085a0 <syscalls+0x180>
    8000362c:	ffffd097          	auipc	ra,0xffffd
    80003630:	f1e080e7          	jalr	-226(ra) # 8000054a <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003634:	40dc                	lw	a5,4(s1)
    80003636:	0047d79b          	srliw	a5,a5,0x4
    8000363a:	0001c597          	auipc	a1,0x1c
    8000363e:	15e5a583          	lw	a1,350(a1) # 8001f798 <sb+0x18>
    80003642:	9dbd                	addw	a1,a1,a5
    80003644:	4088                	lw	a0,0(s1)
    80003646:	fffff097          	auipc	ra,0xfffff
    8000364a:	7ac080e7          	jalr	1964(ra) # 80002df2 <bread>
    8000364e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003650:	05850593          	addi	a1,a0,88
    80003654:	40dc                	lw	a5,4(s1)
    80003656:	8bbd                	andi	a5,a5,15
    80003658:	079a                	slli	a5,a5,0x6
    8000365a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000365c:	00059783          	lh	a5,0(a1)
    80003660:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003664:	00259783          	lh	a5,2(a1)
    80003668:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000366c:	00459783          	lh	a5,4(a1)
    80003670:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003674:	00659783          	lh	a5,6(a1)
    80003678:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000367c:	459c                	lw	a5,8(a1)
    8000367e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003680:	03400613          	li	a2,52
    80003684:	05b1                	addi	a1,a1,12
    80003686:	05048513          	addi	a0,s1,80
    8000368a:	ffffd097          	auipc	ra,0xffffd
    8000368e:	6d4080e7          	jalr	1748(ra) # 80000d5e <memmove>
    brelse(bp);
    80003692:	854a                	mv	a0,s2
    80003694:	00000097          	auipc	ra,0x0
    80003698:	88e080e7          	jalr	-1906(ra) # 80002f22 <brelse>
    ip->valid = 1;
    8000369c:	4785                	li	a5,1
    8000369e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800036a0:	04449783          	lh	a5,68(s1)
    800036a4:	fbb5                	bnez	a5,80003618 <ilock+0x24>
      panic("ilock: no type");
    800036a6:	00005517          	auipc	a0,0x5
    800036aa:	f0250513          	addi	a0,a0,-254 # 800085a8 <syscalls+0x188>
    800036ae:	ffffd097          	auipc	ra,0xffffd
    800036b2:	e9c080e7          	jalr	-356(ra) # 8000054a <panic>

00000000800036b6 <iunlock>:
{
    800036b6:	1101                	addi	sp,sp,-32
    800036b8:	ec06                	sd	ra,24(sp)
    800036ba:	e822                	sd	s0,16(sp)
    800036bc:	e426                	sd	s1,8(sp)
    800036be:	e04a                	sd	s2,0(sp)
    800036c0:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800036c2:	c905                	beqz	a0,800036f2 <iunlock+0x3c>
    800036c4:	84aa                	mv	s1,a0
    800036c6:	01050913          	addi	s2,a0,16
    800036ca:	854a                	mv	a0,s2
    800036cc:	00001097          	auipc	ra,0x1
    800036d0:	c92080e7          	jalr	-878(ra) # 8000435e <holdingsleep>
    800036d4:	cd19                	beqz	a0,800036f2 <iunlock+0x3c>
    800036d6:	449c                	lw	a5,8(s1)
    800036d8:	00f05d63          	blez	a5,800036f2 <iunlock+0x3c>
  releasesleep(&ip->lock);
    800036dc:	854a                	mv	a0,s2
    800036de:	00001097          	auipc	ra,0x1
    800036e2:	c3c080e7          	jalr	-964(ra) # 8000431a <releasesleep>
}
    800036e6:	60e2                	ld	ra,24(sp)
    800036e8:	6442                	ld	s0,16(sp)
    800036ea:	64a2                	ld	s1,8(sp)
    800036ec:	6902                	ld	s2,0(sp)
    800036ee:	6105                	addi	sp,sp,32
    800036f0:	8082                	ret
    panic("iunlock");
    800036f2:	00005517          	auipc	a0,0x5
    800036f6:	ec650513          	addi	a0,a0,-314 # 800085b8 <syscalls+0x198>
    800036fa:	ffffd097          	auipc	ra,0xffffd
    800036fe:	e50080e7          	jalr	-432(ra) # 8000054a <panic>

0000000080003702 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003702:	7179                	addi	sp,sp,-48
    80003704:	f406                	sd	ra,40(sp)
    80003706:	f022                	sd	s0,32(sp)
    80003708:	ec26                	sd	s1,24(sp)
    8000370a:	e84a                	sd	s2,16(sp)
    8000370c:	e44e                	sd	s3,8(sp)
    8000370e:	e052                	sd	s4,0(sp)
    80003710:	1800                	addi	s0,sp,48
    80003712:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003714:	05050493          	addi	s1,a0,80
    80003718:	08050913          	addi	s2,a0,128
    8000371c:	a021                	j	80003724 <itrunc+0x22>
    8000371e:	0491                	addi	s1,s1,4
    80003720:	01248d63          	beq	s1,s2,8000373a <itrunc+0x38>
    if(ip->addrs[i]){
    80003724:	408c                	lw	a1,0(s1)
    80003726:	dde5                	beqz	a1,8000371e <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003728:	0009a503          	lw	a0,0(s3)
    8000372c:	00000097          	auipc	ra,0x0
    80003730:	90c080e7          	jalr	-1780(ra) # 80003038 <bfree>
      ip->addrs[i] = 0;
    80003734:	0004a023          	sw	zero,0(s1)
    80003738:	b7dd                	j	8000371e <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000373a:	0809a583          	lw	a1,128(s3)
    8000373e:	e185                	bnez	a1,8000375e <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003740:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003744:	854e                	mv	a0,s3
    80003746:	00000097          	auipc	ra,0x0
    8000374a:	de4080e7          	jalr	-540(ra) # 8000352a <iupdate>
}
    8000374e:	70a2                	ld	ra,40(sp)
    80003750:	7402                	ld	s0,32(sp)
    80003752:	64e2                	ld	s1,24(sp)
    80003754:	6942                	ld	s2,16(sp)
    80003756:	69a2                	ld	s3,8(sp)
    80003758:	6a02                	ld	s4,0(sp)
    8000375a:	6145                	addi	sp,sp,48
    8000375c:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000375e:	0009a503          	lw	a0,0(s3)
    80003762:	fffff097          	auipc	ra,0xfffff
    80003766:	690080e7          	jalr	1680(ra) # 80002df2 <bread>
    8000376a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000376c:	05850493          	addi	s1,a0,88
    80003770:	45850913          	addi	s2,a0,1112
    80003774:	a021                	j	8000377c <itrunc+0x7a>
    80003776:	0491                	addi	s1,s1,4
    80003778:	01248b63          	beq	s1,s2,8000378e <itrunc+0x8c>
      if(a[j])
    8000377c:	408c                	lw	a1,0(s1)
    8000377e:	dde5                	beqz	a1,80003776 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003780:	0009a503          	lw	a0,0(s3)
    80003784:	00000097          	auipc	ra,0x0
    80003788:	8b4080e7          	jalr	-1868(ra) # 80003038 <bfree>
    8000378c:	b7ed                	j	80003776 <itrunc+0x74>
    brelse(bp);
    8000378e:	8552                	mv	a0,s4
    80003790:	fffff097          	auipc	ra,0xfffff
    80003794:	792080e7          	jalr	1938(ra) # 80002f22 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003798:	0809a583          	lw	a1,128(s3)
    8000379c:	0009a503          	lw	a0,0(s3)
    800037a0:	00000097          	auipc	ra,0x0
    800037a4:	898080e7          	jalr	-1896(ra) # 80003038 <bfree>
    ip->addrs[NDIRECT] = 0;
    800037a8:	0809a023          	sw	zero,128(s3)
    800037ac:	bf51                	j	80003740 <itrunc+0x3e>

00000000800037ae <iput>:
{
    800037ae:	1101                	addi	sp,sp,-32
    800037b0:	ec06                	sd	ra,24(sp)
    800037b2:	e822                	sd	s0,16(sp)
    800037b4:	e426                	sd	s1,8(sp)
    800037b6:	e04a                	sd	s2,0(sp)
    800037b8:	1000                	addi	s0,sp,32
    800037ba:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800037bc:	0001c517          	auipc	a0,0x1c
    800037c0:	fe450513          	addi	a0,a0,-28 # 8001f7a0 <icache>
    800037c4:	ffffd097          	auipc	ra,0xffffd
    800037c8:	442080e7          	jalr	1090(ra) # 80000c06 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800037cc:	4498                	lw	a4,8(s1)
    800037ce:	4785                	li	a5,1
    800037d0:	02f70363          	beq	a4,a5,800037f6 <iput+0x48>
  ip->ref--;
    800037d4:	449c                	lw	a5,8(s1)
    800037d6:	37fd                	addiw	a5,a5,-1
    800037d8:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800037da:	0001c517          	auipc	a0,0x1c
    800037de:	fc650513          	addi	a0,a0,-58 # 8001f7a0 <icache>
    800037e2:	ffffd097          	auipc	ra,0xffffd
    800037e6:	4d8080e7          	jalr	1240(ra) # 80000cba <release>
}
    800037ea:	60e2                	ld	ra,24(sp)
    800037ec:	6442                	ld	s0,16(sp)
    800037ee:	64a2                	ld	s1,8(sp)
    800037f0:	6902                	ld	s2,0(sp)
    800037f2:	6105                	addi	sp,sp,32
    800037f4:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800037f6:	40bc                	lw	a5,64(s1)
    800037f8:	dff1                	beqz	a5,800037d4 <iput+0x26>
    800037fa:	04a49783          	lh	a5,74(s1)
    800037fe:	fbf9                	bnez	a5,800037d4 <iput+0x26>
    acquiresleep(&ip->lock);
    80003800:	01048913          	addi	s2,s1,16
    80003804:	854a                	mv	a0,s2
    80003806:	00001097          	auipc	ra,0x1
    8000380a:	abe080e7          	jalr	-1346(ra) # 800042c4 <acquiresleep>
    release(&icache.lock);
    8000380e:	0001c517          	auipc	a0,0x1c
    80003812:	f9250513          	addi	a0,a0,-110 # 8001f7a0 <icache>
    80003816:	ffffd097          	auipc	ra,0xffffd
    8000381a:	4a4080e7          	jalr	1188(ra) # 80000cba <release>
    itrunc(ip);
    8000381e:	8526                	mv	a0,s1
    80003820:	00000097          	auipc	ra,0x0
    80003824:	ee2080e7          	jalr	-286(ra) # 80003702 <itrunc>
    ip->type = 0;
    80003828:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000382c:	8526                	mv	a0,s1
    8000382e:	00000097          	auipc	ra,0x0
    80003832:	cfc080e7          	jalr	-772(ra) # 8000352a <iupdate>
    ip->valid = 0;
    80003836:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000383a:	854a                	mv	a0,s2
    8000383c:	00001097          	auipc	ra,0x1
    80003840:	ade080e7          	jalr	-1314(ra) # 8000431a <releasesleep>
    acquire(&icache.lock);
    80003844:	0001c517          	auipc	a0,0x1c
    80003848:	f5c50513          	addi	a0,a0,-164 # 8001f7a0 <icache>
    8000384c:	ffffd097          	auipc	ra,0xffffd
    80003850:	3ba080e7          	jalr	954(ra) # 80000c06 <acquire>
    80003854:	b741                	j	800037d4 <iput+0x26>

0000000080003856 <iunlockput>:
{
    80003856:	1101                	addi	sp,sp,-32
    80003858:	ec06                	sd	ra,24(sp)
    8000385a:	e822                	sd	s0,16(sp)
    8000385c:	e426                	sd	s1,8(sp)
    8000385e:	1000                	addi	s0,sp,32
    80003860:	84aa                	mv	s1,a0
  iunlock(ip);
    80003862:	00000097          	auipc	ra,0x0
    80003866:	e54080e7          	jalr	-428(ra) # 800036b6 <iunlock>
  iput(ip);
    8000386a:	8526                	mv	a0,s1
    8000386c:	00000097          	auipc	ra,0x0
    80003870:	f42080e7          	jalr	-190(ra) # 800037ae <iput>
}
    80003874:	60e2                	ld	ra,24(sp)
    80003876:	6442                	ld	s0,16(sp)
    80003878:	64a2                	ld	s1,8(sp)
    8000387a:	6105                	addi	sp,sp,32
    8000387c:	8082                	ret

000000008000387e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000387e:	1141                	addi	sp,sp,-16
    80003880:	e422                	sd	s0,8(sp)
    80003882:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003884:	411c                	lw	a5,0(a0)
    80003886:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003888:	415c                	lw	a5,4(a0)
    8000388a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000388c:	04451783          	lh	a5,68(a0)
    80003890:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003894:	04a51783          	lh	a5,74(a0)
    80003898:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000389c:	04c56783          	lwu	a5,76(a0)
    800038a0:	e99c                	sd	a5,16(a1)
}
    800038a2:	6422                	ld	s0,8(sp)
    800038a4:	0141                	addi	sp,sp,16
    800038a6:	8082                	ret

00000000800038a8 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800038a8:	457c                	lw	a5,76(a0)
    800038aa:	0ed7e963          	bltu	a5,a3,8000399c <readi+0xf4>
{
    800038ae:	7159                	addi	sp,sp,-112
    800038b0:	f486                	sd	ra,104(sp)
    800038b2:	f0a2                	sd	s0,96(sp)
    800038b4:	eca6                	sd	s1,88(sp)
    800038b6:	e8ca                	sd	s2,80(sp)
    800038b8:	e4ce                	sd	s3,72(sp)
    800038ba:	e0d2                	sd	s4,64(sp)
    800038bc:	fc56                	sd	s5,56(sp)
    800038be:	f85a                	sd	s6,48(sp)
    800038c0:	f45e                	sd	s7,40(sp)
    800038c2:	f062                	sd	s8,32(sp)
    800038c4:	ec66                	sd	s9,24(sp)
    800038c6:	e86a                	sd	s10,16(sp)
    800038c8:	e46e                	sd	s11,8(sp)
    800038ca:	1880                	addi	s0,sp,112
    800038cc:	8baa                	mv	s7,a0
    800038ce:	8c2e                	mv	s8,a1
    800038d0:	8ab2                	mv	s5,a2
    800038d2:	84b6                	mv	s1,a3
    800038d4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800038d6:	9f35                	addw	a4,a4,a3
    return 0;
    800038d8:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800038da:	0ad76063          	bltu	a4,a3,8000397a <readi+0xd2>
  if(off + n > ip->size)
    800038de:	00e7f463          	bgeu	a5,a4,800038e6 <readi+0x3e>
    n = ip->size - off;
    800038e2:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800038e6:	0a0b0963          	beqz	s6,80003998 <readi+0xf0>
    800038ea:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800038ec:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800038f0:	5cfd                	li	s9,-1
    800038f2:	a82d                	j	8000392c <readi+0x84>
    800038f4:	020a1d93          	slli	s11,s4,0x20
    800038f8:	020ddd93          	srli	s11,s11,0x20
    800038fc:	05890793          	addi	a5,s2,88
    80003900:	86ee                	mv	a3,s11
    80003902:	963e                	add	a2,a2,a5
    80003904:	85d6                	mv	a1,s5
    80003906:	8562                	mv	a0,s8
    80003908:	fffff097          	auipc	ra,0xfffff
    8000390c:	b30080e7          	jalr	-1232(ra) # 80002438 <either_copyout>
    80003910:	05950d63          	beq	a0,s9,8000396a <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003914:	854a                	mv	a0,s2
    80003916:	fffff097          	auipc	ra,0xfffff
    8000391a:	60c080e7          	jalr	1548(ra) # 80002f22 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000391e:	013a09bb          	addw	s3,s4,s3
    80003922:	009a04bb          	addw	s1,s4,s1
    80003926:	9aee                	add	s5,s5,s11
    80003928:	0569f763          	bgeu	s3,s6,80003976 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000392c:	000ba903          	lw	s2,0(s7)
    80003930:	00a4d59b          	srliw	a1,s1,0xa
    80003934:	855e                	mv	a0,s7
    80003936:	00000097          	auipc	ra,0x0
    8000393a:	8b0080e7          	jalr	-1872(ra) # 800031e6 <bmap>
    8000393e:	0005059b          	sext.w	a1,a0
    80003942:	854a                	mv	a0,s2
    80003944:	fffff097          	auipc	ra,0xfffff
    80003948:	4ae080e7          	jalr	1198(ra) # 80002df2 <bread>
    8000394c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000394e:	3ff4f613          	andi	a2,s1,1023
    80003952:	40cd07bb          	subw	a5,s10,a2
    80003956:	413b073b          	subw	a4,s6,s3
    8000395a:	8a3e                	mv	s4,a5
    8000395c:	2781                	sext.w	a5,a5
    8000395e:	0007069b          	sext.w	a3,a4
    80003962:	f8f6f9e3          	bgeu	a3,a5,800038f4 <readi+0x4c>
    80003966:	8a3a                	mv	s4,a4
    80003968:	b771                	j	800038f4 <readi+0x4c>
      brelse(bp);
    8000396a:	854a                	mv	a0,s2
    8000396c:	fffff097          	auipc	ra,0xfffff
    80003970:	5b6080e7          	jalr	1462(ra) # 80002f22 <brelse>
      tot = -1;
    80003974:	59fd                	li	s3,-1
  }
  return tot;
    80003976:	0009851b          	sext.w	a0,s3
}
    8000397a:	70a6                	ld	ra,104(sp)
    8000397c:	7406                	ld	s0,96(sp)
    8000397e:	64e6                	ld	s1,88(sp)
    80003980:	6946                	ld	s2,80(sp)
    80003982:	69a6                	ld	s3,72(sp)
    80003984:	6a06                	ld	s4,64(sp)
    80003986:	7ae2                	ld	s5,56(sp)
    80003988:	7b42                	ld	s6,48(sp)
    8000398a:	7ba2                	ld	s7,40(sp)
    8000398c:	7c02                	ld	s8,32(sp)
    8000398e:	6ce2                	ld	s9,24(sp)
    80003990:	6d42                	ld	s10,16(sp)
    80003992:	6da2                	ld	s11,8(sp)
    80003994:	6165                	addi	sp,sp,112
    80003996:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003998:	89da                	mv	s3,s6
    8000399a:	bff1                	j	80003976 <readi+0xce>
    return 0;
    8000399c:	4501                	li	a0,0
}
    8000399e:	8082                	ret

00000000800039a0 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800039a0:	457c                	lw	a5,76(a0)
    800039a2:	10d7e763          	bltu	a5,a3,80003ab0 <writei+0x110>
{
    800039a6:	7159                	addi	sp,sp,-112
    800039a8:	f486                	sd	ra,104(sp)
    800039aa:	f0a2                	sd	s0,96(sp)
    800039ac:	eca6                	sd	s1,88(sp)
    800039ae:	e8ca                	sd	s2,80(sp)
    800039b0:	e4ce                	sd	s3,72(sp)
    800039b2:	e0d2                	sd	s4,64(sp)
    800039b4:	fc56                	sd	s5,56(sp)
    800039b6:	f85a                	sd	s6,48(sp)
    800039b8:	f45e                	sd	s7,40(sp)
    800039ba:	f062                	sd	s8,32(sp)
    800039bc:	ec66                	sd	s9,24(sp)
    800039be:	e86a                	sd	s10,16(sp)
    800039c0:	e46e                	sd	s11,8(sp)
    800039c2:	1880                	addi	s0,sp,112
    800039c4:	8baa                	mv	s7,a0
    800039c6:	8c2e                	mv	s8,a1
    800039c8:	8ab2                	mv	s5,a2
    800039ca:	8936                	mv	s2,a3
    800039cc:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800039ce:	00e687bb          	addw	a5,a3,a4
    800039d2:	0ed7e163          	bltu	a5,a3,80003ab4 <writei+0x114>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800039d6:	00043737          	lui	a4,0x43
    800039da:	0cf76f63          	bltu	a4,a5,80003ab8 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800039de:	0a0b0863          	beqz	s6,80003a8e <writei+0xee>
    800039e2:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800039e4:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800039e8:	5cfd                	li	s9,-1
    800039ea:	a091                	j	80003a2e <writei+0x8e>
    800039ec:	02099d93          	slli	s11,s3,0x20
    800039f0:	020ddd93          	srli	s11,s11,0x20
    800039f4:	05848793          	addi	a5,s1,88
    800039f8:	86ee                	mv	a3,s11
    800039fa:	8656                	mv	a2,s5
    800039fc:	85e2                	mv	a1,s8
    800039fe:	953e                	add	a0,a0,a5
    80003a00:	fffff097          	auipc	ra,0xfffff
    80003a04:	a8e080e7          	jalr	-1394(ra) # 8000248e <either_copyin>
    80003a08:	07950263          	beq	a0,s9,80003a6c <writei+0xcc>
      brelse(bp);
      n = -1;
      break;
    }
    log_write(bp);
    80003a0c:	8526                	mv	a0,s1
    80003a0e:	00000097          	auipc	ra,0x0
    80003a12:	78e080e7          	jalr	1934(ra) # 8000419c <log_write>
    brelse(bp);
    80003a16:	8526                	mv	a0,s1
    80003a18:	fffff097          	auipc	ra,0xfffff
    80003a1c:	50a080e7          	jalr	1290(ra) # 80002f22 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003a20:	01498a3b          	addw	s4,s3,s4
    80003a24:	0129893b          	addw	s2,s3,s2
    80003a28:	9aee                	add	s5,s5,s11
    80003a2a:	056a7763          	bgeu	s4,s6,80003a78 <writei+0xd8>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003a2e:	000ba483          	lw	s1,0(s7)
    80003a32:	00a9559b          	srliw	a1,s2,0xa
    80003a36:	855e                	mv	a0,s7
    80003a38:	fffff097          	auipc	ra,0xfffff
    80003a3c:	7ae080e7          	jalr	1966(ra) # 800031e6 <bmap>
    80003a40:	0005059b          	sext.w	a1,a0
    80003a44:	8526                	mv	a0,s1
    80003a46:	fffff097          	auipc	ra,0xfffff
    80003a4a:	3ac080e7          	jalr	940(ra) # 80002df2 <bread>
    80003a4e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a50:	3ff97513          	andi	a0,s2,1023
    80003a54:	40ad07bb          	subw	a5,s10,a0
    80003a58:	414b073b          	subw	a4,s6,s4
    80003a5c:	89be                	mv	s3,a5
    80003a5e:	2781                	sext.w	a5,a5
    80003a60:	0007069b          	sext.w	a3,a4
    80003a64:	f8f6f4e3          	bgeu	a3,a5,800039ec <writei+0x4c>
    80003a68:	89ba                	mv	s3,a4
    80003a6a:	b749                	j	800039ec <writei+0x4c>
      brelse(bp);
    80003a6c:	8526                	mv	a0,s1
    80003a6e:	fffff097          	auipc	ra,0xfffff
    80003a72:	4b4080e7          	jalr	1204(ra) # 80002f22 <brelse>
      n = -1;
    80003a76:	5b7d                	li	s6,-1
  }

  if(n > 0){
    if(off > ip->size)
    80003a78:	04cba783          	lw	a5,76(s7)
    80003a7c:	0127f463          	bgeu	a5,s2,80003a84 <writei+0xe4>
      ip->size = off;
    80003a80:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003a84:	855e                	mv	a0,s7
    80003a86:	00000097          	auipc	ra,0x0
    80003a8a:	aa4080e7          	jalr	-1372(ra) # 8000352a <iupdate>
  }

  return n;
    80003a8e:	000b051b          	sext.w	a0,s6
}
    80003a92:	70a6                	ld	ra,104(sp)
    80003a94:	7406                	ld	s0,96(sp)
    80003a96:	64e6                	ld	s1,88(sp)
    80003a98:	6946                	ld	s2,80(sp)
    80003a9a:	69a6                	ld	s3,72(sp)
    80003a9c:	6a06                	ld	s4,64(sp)
    80003a9e:	7ae2                	ld	s5,56(sp)
    80003aa0:	7b42                	ld	s6,48(sp)
    80003aa2:	7ba2                	ld	s7,40(sp)
    80003aa4:	7c02                	ld	s8,32(sp)
    80003aa6:	6ce2                	ld	s9,24(sp)
    80003aa8:	6d42                	ld	s10,16(sp)
    80003aaa:	6da2                	ld	s11,8(sp)
    80003aac:	6165                	addi	sp,sp,112
    80003aae:	8082                	ret
    return -1;
    80003ab0:	557d                	li	a0,-1
}
    80003ab2:	8082                	ret
    return -1;
    80003ab4:	557d                	li	a0,-1
    80003ab6:	bff1                	j	80003a92 <writei+0xf2>
    return -1;
    80003ab8:	557d                	li	a0,-1
    80003aba:	bfe1                	j	80003a92 <writei+0xf2>

0000000080003abc <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003abc:	1141                	addi	sp,sp,-16
    80003abe:	e406                	sd	ra,8(sp)
    80003ac0:	e022                	sd	s0,0(sp)
    80003ac2:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003ac4:	4639                	li	a2,14
    80003ac6:	ffffd097          	auipc	ra,0xffffd
    80003aca:	314080e7          	jalr	788(ra) # 80000dda <strncmp>
}
    80003ace:	60a2                	ld	ra,8(sp)
    80003ad0:	6402                	ld	s0,0(sp)
    80003ad2:	0141                	addi	sp,sp,16
    80003ad4:	8082                	ret

0000000080003ad6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003ad6:	7139                	addi	sp,sp,-64
    80003ad8:	fc06                	sd	ra,56(sp)
    80003ada:	f822                	sd	s0,48(sp)
    80003adc:	f426                	sd	s1,40(sp)
    80003ade:	f04a                	sd	s2,32(sp)
    80003ae0:	ec4e                	sd	s3,24(sp)
    80003ae2:	e852                	sd	s4,16(sp)
    80003ae4:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003ae6:	04451703          	lh	a4,68(a0)
    80003aea:	4785                	li	a5,1
    80003aec:	00f71a63          	bne	a4,a5,80003b00 <dirlookup+0x2a>
    80003af0:	892a                	mv	s2,a0
    80003af2:	89ae                	mv	s3,a1
    80003af4:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003af6:	457c                	lw	a5,76(a0)
    80003af8:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003afa:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003afc:	e79d                	bnez	a5,80003b2a <dirlookup+0x54>
    80003afe:	a8a5                	j	80003b76 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003b00:	00005517          	auipc	a0,0x5
    80003b04:	ac050513          	addi	a0,a0,-1344 # 800085c0 <syscalls+0x1a0>
    80003b08:	ffffd097          	auipc	ra,0xffffd
    80003b0c:	a42080e7          	jalr	-1470(ra) # 8000054a <panic>
      panic("dirlookup read");
    80003b10:	00005517          	auipc	a0,0x5
    80003b14:	ac850513          	addi	a0,a0,-1336 # 800085d8 <syscalls+0x1b8>
    80003b18:	ffffd097          	auipc	ra,0xffffd
    80003b1c:	a32080e7          	jalr	-1486(ra) # 8000054a <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003b20:	24c1                	addiw	s1,s1,16
    80003b22:	04c92783          	lw	a5,76(s2)
    80003b26:	04f4f763          	bgeu	s1,a5,80003b74 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b2a:	4741                	li	a4,16
    80003b2c:	86a6                	mv	a3,s1
    80003b2e:	fc040613          	addi	a2,s0,-64
    80003b32:	4581                	li	a1,0
    80003b34:	854a                	mv	a0,s2
    80003b36:	00000097          	auipc	ra,0x0
    80003b3a:	d72080e7          	jalr	-654(ra) # 800038a8 <readi>
    80003b3e:	47c1                	li	a5,16
    80003b40:	fcf518e3          	bne	a0,a5,80003b10 <dirlookup+0x3a>
    if(de.inum == 0)
    80003b44:	fc045783          	lhu	a5,-64(s0)
    80003b48:	dfe1                	beqz	a5,80003b20 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003b4a:	fc240593          	addi	a1,s0,-62
    80003b4e:	854e                	mv	a0,s3
    80003b50:	00000097          	auipc	ra,0x0
    80003b54:	f6c080e7          	jalr	-148(ra) # 80003abc <namecmp>
    80003b58:	f561                	bnez	a0,80003b20 <dirlookup+0x4a>
      if(poff)
    80003b5a:	000a0463          	beqz	s4,80003b62 <dirlookup+0x8c>
        *poff = off;
    80003b5e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003b62:	fc045583          	lhu	a1,-64(s0)
    80003b66:	00092503          	lw	a0,0(s2)
    80003b6a:	fffff097          	auipc	ra,0xfffff
    80003b6e:	756080e7          	jalr	1878(ra) # 800032c0 <iget>
    80003b72:	a011                	j	80003b76 <dirlookup+0xa0>
  return 0;
    80003b74:	4501                	li	a0,0
}
    80003b76:	70e2                	ld	ra,56(sp)
    80003b78:	7442                	ld	s0,48(sp)
    80003b7a:	74a2                	ld	s1,40(sp)
    80003b7c:	7902                	ld	s2,32(sp)
    80003b7e:	69e2                	ld	s3,24(sp)
    80003b80:	6a42                	ld	s4,16(sp)
    80003b82:	6121                	addi	sp,sp,64
    80003b84:	8082                	ret

0000000080003b86 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003b86:	711d                	addi	sp,sp,-96
    80003b88:	ec86                	sd	ra,88(sp)
    80003b8a:	e8a2                	sd	s0,80(sp)
    80003b8c:	e4a6                	sd	s1,72(sp)
    80003b8e:	e0ca                	sd	s2,64(sp)
    80003b90:	fc4e                	sd	s3,56(sp)
    80003b92:	f852                	sd	s4,48(sp)
    80003b94:	f456                	sd	s5,40(sp)
    80003b96:	f05a                	sd	s6,32(sp)
    80003b98:	ec5e                	sd	s7,24(sp)
    80003b9a:	e862                	sd	s8,16(sp)
    80003b9c:	e466                	sd	s9,8(sp)
    80003b9e:	1080                	addi	s0,sp,96
    80003ba0:	84aa                	mv	s1,a0
    80003ba2:	8aae                	mv	s5,a1
    80003ba4:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003ba6:	00054703          	lbu	a4,0(a0)
    80003baa:	02f00793          	li	a5,47
    80003bae:	02f70363          	beq	a4,a5,80003bd4 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003bb2:	ffffe097          	auipc	ra,0xffffe
    80003bb6:	e3c080e7          	jalr	-452(ra) # 800019ee <myproc>
    80003bba:	15053503          	ld	a0,336(a0)
    80003bbe:	00000097          	auipc	ra,0x0
    80003bc2:	9f8080e7          	jalr	-1544(ra) # 800035b6 <idup>
    80003bc6:	89aa                	mv	s3,a0
  while(*path == '/')
    80003bc8:	02f00913          	li	s2,47
  len = path - s;
    80003bcc:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80003bce:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003bd0:	4b85                	li	s7,1
    80003bd2:	a865                	j	80003c8a <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003bd4:	4585                	li	a1,1
    80003bd6:	4505                	li	a0,1
    80003bd8:	fffff097          	auipc	ra,0xfffff
    80003bdc:	6e8080e7          	jalr	1768(ra) # 800032c0 <iget>
    80003be0:	89aa                	mv	s3,a0
    80003be2:	b7dd                	j	80003bc8 <namex+0x42>
      iunlockput(ip);
    80003be4:	854e                	mv	a0,s3
    80003be6:	00000097          	auipc	ra,0x0
    80003bea:	c70080e7          	jalr	-912(ra) # 80003856 <iunlockput>
      return 0;
    80003bee:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003bf0:	854e                	mv	a0,s3
    80003bf2:	60e6                	ld	ra,88(sp)
    80003bf4:	6446                	ld	s0,80(sp)
    80003bf6:	64a6                	ld	s1,72(sp)
    80003bf8:	6906                	ld	s2,64(sp)
    80003bfa:	79e2                	ld	s3,56(sp)
    80003bfc:	7a42                	ld	s4,48(sp)
    80003bfe:	7aa2                	ld	s5,40(sp)
    80003c00:	7b02                	ld	s6,32(sp)
    80003c02:	6be2                	ld	s7,24(sp)
    80003c04:	6c42                	ld	s8,16(sp)
    80003c06:	6ca2                	ld	s9,8(sp)
    80003c08:	6125                	addi	sp,sp,96
    80003c0a:	8082                	ret
      iunlock(ip);
    80003c0c:	854e                	mv	a0,s3
    80003c0e:	00000097          	auipc	ra,0x0
    80003c12:	aa8080e7          	jalr	-1368(ra) # 800036b6 <iunlock>
      return ip;
    80003c16:	bfe9                	j	80003bf0 <namex+0x6a>
      iunlockput(ip);
    80003c18:	854e                	mv	a0,s3
    80003c1a:	00000097          	auipc	ra,0x0
    80003c1e:	c3c080e7          	jalr	-964(ra) # 80003856 <iunlockput>
      return 0;
    80003c22:	89e6                	mv	s3,s9
    80003c24:	b7f1                	j	80003bf0 <namex+0x6a>
  len = path - s;
    80003c26:	40b48633          	sub	a2,s1,a1
    80003c2a:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003c2e:	099c5463          	bge	s8,s9,80003cb6 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003c32:	4639                	li	a2,14
    80003c34:	8552                	mv	a0,s4
    80003c36:	ffffd097          	auipc	ra,0xffffd
    80003c3a:	128080e7          	jalr	296(ra) # 80000d5e <memmove>
  while(*path == '/')
    80003c3e:	0004c783          	lbu	a5,0(s1)
    80003c42:	01279763          	bne	a5,s2,80003c50 <namex+0xca>
    path++;
    80003c46:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003c48:	0004c783          	lbu	a5,0(s1)
    80003c4c:	ff278de3          	beq	a5,s2,80003c46 <namex+0xc0>
    ilock(ip);
    80003c50:	854e                	mv	a0,s3
    80003c52:	00000097          	auipc	ra,0x0
    80003c56:	9a2080e7          	jalr	-1630(ra) # 800035f4 <ilock>
    if(ip->type != T_DIR){
    80003c5a:	04499783          	lh	a5,68(s3)
    80003c5e:	f97793e3          	bne	a5,s7,80003be4 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003c62:	000a8563          	beqz	s5,80003c6c <namex+0xe6>
    80003c66:	0004c783          	lbu	a5,0(s1)
    80003c6a:	d3cd                	beqz	a5,80003c0c <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003c6c:	865a                	mv	a2,s6
    80003c6e:	85d2                	mv	a1,s4
    80003c70:	854e                	mv	a0,s3
    80003c72:	00000097          	auipc	ra,0x0
    80003c76:	e64080e7          	jalr	-412(ra) # 80003ad6 <dirlookup>
    80003c7a:	8caa                	mv	s9,a0
    80003c7c:	dd51                	beqz	a0,80003c18 <namex+0x92>
    iunlockput(ip);
    80003c7e:	854e                	mv	a0,s3
    80003c80:	00000097          	auipc	ra,0x0
    80003c84:	bd6080e7          	jalr	-1066(ra) # 80003856 <iunlockput>
    ip = next;
    80003c88:	89e6                	mv	s3,s9
  while(*path == '/')
    80003c8a:	0004c783          	lbu	a5,0(s1)
    80003c8e:	05279763          	bne	a5,s2,80003cdc <namex+0x156>
    path++;
    80003c92:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003c94:	0004c783          	lbu	a5,0(s1)
    80003c98:	ff278de3          	beq	a5,s2,80003c92 <namex+0x10c>
  if(*path == 0)
    80003c9c:	c79d                	beqz	a5,80003cca <namex+0x144>
    path++;
    80003c9e:	85a6                	mv	a1,s1
  len = path - s;
    80003ca0:	8cda                	mv	s9,s6
    80003ca2:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80003ca4:	01278963          	beq	a5,s2,80003cb6 <namex+0x130>
    80003ca8:	dfbd                	beqz	a5,80003c26 <namex+0xa0>
    path++;
    80003caa:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003cac:	0004c783          	lbu	a5,0(s1)
    80003cb0:	ff279ce3          	bne	a5,s2,80003ca8 <namex+0x122>
    80003cb4:	bf8d                	j	80003c26 <namex+0xa0>
    memmove(name, s, len);
    80003cb6:	2601                	sext.w	a2,a2
    80003cb8:	8552                	mv	a0,s4
    80003cba:	ffffd097          	auipc	ra,0xffffd
    80003cbe:	0a4080e7          	jalr	164(ra) # 80000d5e <memmove>
    name[len] = 0;
    80003cc2:	9cd2                	add	s9,s9,s4
    80003cc4:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003cc8:	bf9d                	j	80003c3e <namex+0xb8>
  if(nameiparent){
    80003cca:	f20a83e3          	beqz	s5,80003bf0 <namex+0x6a>
    iput(ip);
    80003cce:	854e                	mv	a0,s3
    80003cd0:	00000097          	auipc	ra,0x0
    80003cd4:	ade080e7          	jalr	-1314(ra) # 800037ae <iput>
    return 0;
    80003cd8:	4981                	li	s3,0
    80003cda:	bf19                	j	80003bf0 <namex+0x6a>
  if(*path == 0)
    80003cdc:	d7fd                	beqz	a5,80003cca <namex+0x144>
  while(*path != '/' && *path != 0)
    80003cde:	0004c783          	lbu	a5,0(s1)
    80003ce2:	85a6                	mv	a1,s1
    80003ce4:	b7d1                	j	80003ca8 <namex+0x122>

0000000080003ce6 <dirlink>:
{
    80003ce6:	7139                	addi	sp,sp,-64
    80003ce8:	fc06                	sd	ra,56(sp)
    80003cea:	f822                	sd	s0,48(sp)
    80003cec:	f426                	sd	s1,40(sp)
    80003cee:	f04a                	sd	s2,32(sp)
    80003cf0:	ec4e                	sd	s3,24(sp)
    80003cf2:	e852                	sd	s4,16(sp)
    80003cf4:	0080                	addi	s0,sp,64
    80003cf6:	892a                	mv	s2,a0
    80003cf8:	8a2e                	mv	s4,a1
    80003cfa:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003cfc:	4601                	li	a2,0
    80003cfe:	00000097          	auipc	ra,0x0
    80003d02:	dd8080e7          	jalr	-552(ra) # 80003ad6 <dirlookup>
    80003d06:	e93d                	bnez	a0,80003d7c <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d08:	04c92483          	lw	s1,76(s2)
    80003d0c:	c49d                	beqz	s1,80003d3a <dirlink+0x54>
    80003d0e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d10:	4741                	li	a4,16
    80003d12:	86a6                	mv	a3,s1
    80003d14:	fc040613          	addi	a2,s0,-64
    80003d18:	4581                	li	a1,0
    80003d1a:	854a                	mv	a0,s2
    80003d1c:	00000097          	auipc	ra,0x0
    80003d20:	b8c080e7          	jalr	-1140(ra) # 800038a8 <readi>
    80003d24:	47c1                	li	a5,16
    80003d26:	06f51163          	bne	a0,a5,80003d88 <dirlink+0xa2>
    if(de.inum == 0)
    80003d2a:	fc045783          	lhu	a5,-64(s0)
    80003d2e:	c791                	beqz	a5,80003d3a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d30:	24c1                	addiw	s1,s1,16
    80003d32:	04c92783          	lw	a5,76(s2)
    80003d36:	fcf4ede3          	bltu	s1,a5,80003d10 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003d3a:	4639                	li	a2,14
    80003d3c:	85d2                	mv	a1,s4
    80003d3e:	fc240513          	addi	a0,s0,-62
    80003d42:	ffffd097          	auipc	ra,0xffffd
    80003d46:	0d4080e7          	jalr	212(ra) # 80000e16 <strncpy>
  de.inum = inum;
    80003d4a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d4e:	4741                	li	a4,16
    80003d50:	86a6                	mv	a3,s1
    80003d52:	fc040613          	addi	a2,s0,-64
    80003d56:	4581                	li	a1,0
    80003d58:	854a                	mv	a0,s2
    80003d5a:	00000097          	auipc	ra,0x0
    80003d5e:	c46080e7          	jalr	-954(ra) # 800039a0 <writei>
    80003d62:	872a                	mv	a4,a0
    80003d64:	47c1                	li	a5,16
  return 0;
    80003d66:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d68:	02f71863          	bne	a4,a5,80003d98 <dirlink+0xb2>
}
    80003d6c:	70e2                	ld	ra,56(sp)
    80003d6e:	7442                	ld	s0,48(sp)
    80003d70:	74a2                	ld	s1,40(sp)
    80003d72:	7902                	ld	s2,32(sp)
    80003d74:	69e2                	ld	s3,24(sp)
    80003d76:	6a42                	ld	s4,16(sp)
    80003d78:	6121                	addi	sp,sp,64
    80003d7a:	8082                	ret
    iput(ip);
    80003d7c:	00000097          	auipc	ra,0x0
    80003d80:	a32080e7          	jalr	-1486(ra) # 800037ae <iput>
    return -1;
    80003d84:	557d                	li	a0,-1
    80003d86:	b7dd                	j	80003d6c <dirlink+0x86>
      panic("dirlink read");
    80003d88:	00005517          	auipc	a0,0x5
    80003d8c:	86050513          	addi	a0,a0,-1952 # 800085e8 <syscalls+0x1c8>
    80003d90:	ffffc097          	auipc	ra,0xffffc
    80003d94:	7ba080e7          	jalr	1978(ra) # 8000054a <panic>
    panic("dirlink");
    80003d98:	00005517          	auipc	a0,0x5
    80003d9c:	97050513          	addi	a0,a0,-1680 # 80008708 <syscalls+0x2e8>
    80003da0:	ffffc097          	auipc	ra,0xffffc
    80003da4:	7aa080e7          	jalr	1962(ra) # 8000054a <panic>

0000000080003da8 <namei>:

struct inode*
namei(char *path)
{
    80003da8:	1101                	addi	sp,sp,-32
    80003daa:	ec06                	sd	ra,24(sp)
    80003dac:	e822                	sd	s0,16(sp)
    80003dae:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003db0:	fe040613          	addi	a2,s0,-32
    80003db4:	4581                	li	a1,0
    80003db6:	00000097          	auipc	ra,0x0
    80003dba:	dd0080e7          	jalr	-560(ra) # 80003b86 <namex>
}
    80003dbe:	60e2                	ld	ra,24(sp)
    80003dc0:	6442                	ld	s0,16(sp)
    80003dc2:	6105                	addi	sp,sp,32
    80003dc4:	8082                	ret

0000000080003dc6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003dc6:	1141                	addi	sp,sp,-16
    80003dc8:	e406                	sd	ra,8(sp)
    80003dca:	e022                	sd	s0,0(sp)
    80003dcc:	0800                	addi	s0,sp,16
    80003dce:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003dd0:	4585                	li	a1,1
    80003dd2:	00000097          	auipc	ra,0x0
    80003dd6:	db4080e7          	jalr	-588(ra) # 80003b86 <namex>
}
    80003dda:	60a2                	ld	ra,8(sp)
    80003ddc:	6402                	ld	s0,0(sp)
    80003dde:	0141                	addi	sp,sp,16
    80003de0:	8082                	ret

0000000080003de2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003de2:	1101                	addi	sp,sp,-32
    80003de4:	ec06                	sd	ra,24(sp)
    80003de6:	e822                	sd	s0,16(sp)
    80003de8:	e426                	sd	s1,8(sp)
    80003dea:	e04a                	sd	s2,0(sp)
    80003dec:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003dee:	0001d917          	auipc	s2,0x1d
    80003df2:	45a90913          	addi	s2,s2,1114 # 80021248 <log>
    80003df6:	01892583          	lw	a1,24(s2)
    80003dfa:	02892503          	lw	a0,40(s2)
    80003dfe:	fffff097          	auipc	ra,0xfffff
    80003e02:	ff4080e7          	jalr	-12(ra) # 80002df2 <bread>
    80003e06:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003e08:	02c92683          	lw	a3,44(s2)
    80003e0c:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003e0e:	02d05763          	blez	a3,80003e3c <write_head+0x5a>
    80003e12:	0001d797          	auipc	a5,0x1d
    80003e16:	46678793          	addi	a5,a5,1126 # 80021278 <log+0x30>
    80003e1a:	05c50713          	addi	a4,a0,92
    80003e1e:	36fd                	addiw	a3,a3,-1
    80003e20:	1682                	slli	a3,a3,0x20
    80003e22:	9281                	srli	a3,a3,0x20
    80003e24:	068a                	slli	a3,a3,0x2
    80003e26:	0001d617          	auipc	a2,0x1d
    80003e2a:	45660613          	addi	a2,a2,1110 # 8002127c <log+0x34>
    80003e2e:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003e30:	4390                	lw	a2,0(a5)
    80003e32:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003e34:	0791                	addi	a5,a5,4
    80003e36:	0711                	addi	a4,a4,4
    80003e38:	fed79ce3          	bne	a5,a3,80003e30 <write_head+0x4e>
  }
  bwrite(buf);
    80003e3c:	8526                	mv	a0,s1
    80003e3e:	fffff097          	auipc	ra,0xfffff
    80003e42:	0a6080e7          	jalr	166(ra) # 80002ee4 <bwrite>
  brelse(buf);
    80003e46:	8526                	mv	a0,s1
    80003e48:	fffff097          	auipc	ra,0xfffff
    80003e4c:	0da080e7          	jalr	218(ra) # 80002f22 <brelse>
}
    80003e50:	60e2                	ld	ra,24(sp)
    80003e52:	6442                	ld	s0,16(sp)
    80003e54:	64a2                	ld	s1,8(sp)
    80003e56:	6902                	ld	s2,0(sp)
    80003e58:	6105                	addi	sp,sp,32
    80003e5a:	8082                	ret

0000000080003e5c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e5c:	0001d797          	auipc	a5,0x1d
    80003e60:	4187a783          	lw	a5,1048(a5) # 80021274 <log+0x2c>
    80003e64:	0af05d63          	blez	a5,80003f1e <install_trans+0xc2>
{
    80003e68:	7139                	addi	sp,sp,-64
    80003e6a:	fc06                	sd	ra,56(sp)
    80003e6c:	f822                	sd	s0,48(sp)
    80003e6e:	f426                	sd	s1,40(sp)
    80003e70:	f04a                	sd	s2,32(sp)
    80003e72:	ec4e                	sd	s3,24(sp)
    80003e74:	e852                	sd	s4,16(sp)
    80003e76:	e456                	sd	s5,8(sp)
    80003e78:	e05a                	sd	s6,0(sp)
    80003e7a:	0080                	addi	s0,sp,64
    80003e7c:	8b2a                	mv	s6,a0
    80003e7e:	0001da97          	auipc	s5,0x1d
    80003e82:	3faa8a93          	addi	s5,s5,1018 # 80021278 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e86:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003e88:	0001d997          	auipc	s3,0x1d
    80003e8c:	3c098993          	addi	s3,s3,960 # 80021248 <log>
    80003e90:	a00d                	j	80003eb2 <install_trans+0x56>
    brelse(lbuf);
    80003e92:	854a                	mv	a0,s2
    80003e94:	fffff097          	auipc	ra,0xfffff
    80003e98:	08e080e7          	jalr	142(ra) # 80002f22 <brelse>
    brelse(dbuf);
    80003e9c:	8526                	mv	a0,s1
    80003e9e:	fffff097          	auipc	ra,0xfffff
    80003ea2:	084080e7          	jalr	132(ra) # 80002f22 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ea6:	2a05                	addiw	s4,s4,1
    80003ea8:	0a91                	addi	s5,s5,4
    80003eaa:	02c9a783          	lw	a5,44(s3)
    80003eae:	04fa5e63          	bge	s4,a5,80003f0a <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003eb2:	0189a583          	lw	a1,24(s3)
    80003eb6:	014585bb          	addw	a1,a1,s4
    80003eba:	2585                	addiw	a1,a1,1
    80003ebc:	0289a503          	lw	a0,40(s3)
    80003ec0:	fffff097          	auipc	ra,0xfffff
    80003ec4:	f32080e7          	jalr	-206(ra) # 80002df2 <bread>
    80003ec8:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003eca:	000aa583          	lw	a1,0(s5)
    80003ece:	0289a503          	lw	a0,40(s3)
    80003ed2:	fffff097          	auipc	ra,0xfffff
    80003ed6:	f20080e7          	jalr	-224(ra) # 80002df2 <bread>
    80003eda:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003edc:	40000613          	li	a2,1024
    80003ee0:	05890593          	addi	a1,s2,88
    80003ee4:	05850513          	addi	a0,a0,88
    80003ee8:	ffffd097          	auipc	ra,0xffffd
    80003eec:	e76080e7          	jalr	-394(ra) # 80000d5e <memmove>
    bwrite(dbuf);  // write dst to disk
    80003ef0:	8526                	mv	a0,s1
    80003ef2:	fffff097          	auipc	ra,0xfffff
    80003ef6:	ff2080e7          	jalr	-14(ra) # 80002ee4 <bwrite>
    if(recovering == 0)
    80003efa:	f80b1ce3          	bnez	s6,80003e92 <install_trans+0x36>
      bunpin(dbuf);
    80003efe:	8526                	mv	a0,s1
    80003f00:	fffff097          	auipc	ra,0xfffff
    80003f04:	0fc080e7          	jalr	252(ra) # 80002ffc <bunpin>
    80003f08:	b769                	j	80003e92 <install_trans+0x36>
}
    80003f0a:	70e2                	ld	ra,56(sp)
    80003f0c:	7442                	ld	s0,48(sp)
    80003f0e:	74a2                	ld	s1,40(sp)
    80003f10:	7902                	ld	s2,32(sp)
    80003f12:	69e2                	ld	s3,24(sp)
    80003f14:	6a42                	ld	s4,16(sp)
    80003f16:	6aa2                	ld	s5,8(sp)
    80003f18:	6b02                	ld	s6,0(sp)
    80003f1a:	6121                	addi	sp,sp,64
    80003f1c:	8082                	ret
    80003f1e:	8082                	ret

0000000080003f20 <initlog>:
{
    80003f20:	7179                	addi	sp,sp,-48
    80003f22:	f406                	sd	ra,40(sp)
    80003f24:	f022                	sd	s0,32(sp)
    80003f26:	ec26                	sd	s1,24(sp)
    80003f28:	e84a                	sd	s2,16(sp)
    80003f2a:	e44e                	sd	s3,8(sp)
    80003f2c:	1800                	addi	s0,sp,48
    80003f2e:	892a                	mv	s2,a0
    80003f30:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003f32:	0001d497          	auipc	s1,0x1d
    80003f36:	31648493          	addi	s1,s1,790 # 80021248 <log>
    80003f3a:	00004597          	auipc	a1,0x4
    80003f3e:	6be58593          	addi	a1,a1,1726 # 800085f8 <syscalls+0x1d8>
    80003f42:	8526                	mv	a0,s1
    80003f44:	ffffd097          	auipc	ra,0xffffd
    80003f48:	c32080e7          	jalr	-974(ra) # 80000b76 <initlock>
  log.start = sb->logstart;
    80003f4c:	0149a583          	lw	a1,20(s3)
    80003f50:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003f52:	0109a783          	lw	a5,16(s3)
    80003f56:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003f58:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003f5c:	854a                	mv	a0,s2
    80003f5e:	fffff097          	auipc	ra,0xfffff
    80003f62:	e94080e7          	jalr	-364(ra) # 80002df2 <bread>
  log.lh.n = lh->n;
    80003f66:	4d34                	lw	a3,88(a0)
    80003f68:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003f6a:	02d05563          	blez	a3,80003f94 <initlog+0x74>
    80003f6e:	05c50793          	addi	a5,a0,92
    80003f72:	0001d717          	auipc	a4,0x1d
    80003f76:	30670713          	addi	a4,a4,774 # 80021278 <log+0x30>
    80003f7a:	36fd                	addiw	a3,a3,-1
    80003f7c:	1682                	slli	a3,a3,0x20
    80003f7e:	9281                	srli	a3,a3,0x20
    80003f80:	068a                	slli	a3,a3,0x2
    80003f82:	06050613          	addi	a2,a0,96
    80003f86:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003f88:	4390                	lw	a2,0(a5)
    80003f8a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003f8c:	0791                	addi	a5,a5,4
    80003f8e:	0711                	addi	a4,a4,4
    80003f90:	fed79ce3          	bne	a5,a3,80003f88 <initlog+0x68>
  brelse(buf);
    80003f94:	fffff097          	auipc	ra,0xfffff
    80003f98:	f8e080e7          	jalr	-114(ra) # 80002f22 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003f9c:	4505                	li	a0,1
    80003f9e:	00000097          	auipc	ra,0x0
    80003fa2:	ebe080e7          	jalr	-322(ra) # 80003e5c <install_trans>
  log.lh.n = 0;
    80003fa6:	0001d797          	auipc	a5,0x1d
    80003faa:	2c07a723          	sw	zero,718(a5) # 80021274 <log+0x2c>
  write_head(); // clear the log
    80003fae:	00000097          	auipc	ra,0x0
    80003fb2:	e34080e7          	jalr	-460(ra) # 80003de2 <write_head>
}
    80003fb6:	70a2                	ld	ra,40(sp)
    80003fb8:	7402                	ld	s0,32(sp)
    80003fba:	64e2                	ld	s1,24(sp)
    80003fbc:	6942                	ld	s2,16(sp)
    80003fbe:	69a2                	ld	s3,8(sp)
    80003fc0:	6145                	addi	sp,sp,48
    80003fc2:	8082                	ret

0000000080003fc4 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003fc4:	1101                	addi	sp,sp,-32
    80003fc6:	ec06                	sd	ra,24(sp)
    80003fc8:	e822                	sd	s0,16(sp)
    80003fca:	e426                	sd	s1,8(sp)
    80003fcc:	e04a                	sd	s2,0(sp)
    80003fce:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003fd0:	0001d517          	auipc	a0,0x1d
    80003fd4:	27850513          	addi	a0,a0,632 # 80021248 <log>
    80003fd8:	ffffd097          	auipc	ra,0xffffd
    80003fdc:	c2e080e7          	jalr	-978(ra) # 80000c06 <acquire>
  while(1){
    if(log.committing){
    80003fe0:	0001d497          	auipc	s1,0x1d
    80003fe4:	26848493          	addi	s1,s1,616 # 80021248 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003fe8:	4979                	li	s2,30
    80003fea:	a039                	j	80003ff8 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003fec:	85a6                	mv	a1,s1
    80003fee:	8526                	mv	a0,s1
    80003ff0:	ffffe097          	auipc	ra,0xffffe
    80003ff4:	1ee080e7          	jalr	494(ra) # 800021de <sleep>
    if(log.committing){
    80003ff8:	50dc                	lw	a5,36(s1)
    80003ffa:	fbed                	bnez	a5,80003fec <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003ffc:	509c                	lw	a5,32(s1)
    80003ffe:	0017871b          	addiw	a4,a5,1
    80004002:	0007069b          	sext.w	a3,a4
    80004006:	0027179b          	slliw	a5,a4,0x2
    8000400a:	9fb9                	addw	a5,a5,a4
    8000400c:	0017979b          	slliw	a5,a5,0x1
    80004010:	54d8                	lw	a4,44(s1)
    80004012:	9fb9                	addw	a5,a5,a4
    80004014:	00f95963          	bge	s2,a5,80004026 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004018:	85a6                	mv	a1,s1
    8000401a:	8526                	mv	a0,s1
    8000401c:	ffffe097          	auipc	ra,0xffffe
    80004020:	1c2080e7          	jalr	450(ra) # 800021de <sleep>
    80004024:	bfd1                	j	80003ff8 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004026:	0001d517          	auipc	a0,0x1d
    8000402a:	22250513          	addi	a0,a0,546 # 80021248 <log>
    8000402e:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80004030:	ffffd097          	auipc	ra,0xffffd
    80004034:	c8a080e7          	jalr	-886(ra) # 80000cba <release>
      break;
    }
  }
}
    80004038:	60e2                	ld	ra,24(sp)
    8000403a:	6442                	ld	s0,16(sp)
    8000403c:	64a2                	ld	s1,8(sp)
    8000403e:	6902                	ld	s2,0(sp)
    80004040:	6105                	addi	sp,sp,32
    80004042:	8082                	ret

0000000080004044 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004044:	7139                	addi	sp,sp,-64
    80004046:	fc06                	sd	ra,56(sp)
    80004048:	f822                	sd	s0,48(sp)
    8000404a:	f426                	sd	s1,40(sp)
    8000404c:	f04a                	sd	s2,32(sp)
    8000404e:	ec4e                	sd	s3,24(sp)
    80004050:	e852                	sd	s4,16(sp)
    80004052:	e456                	sd	s5,8(sp)
    80004054:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004056:	0001d497          	auipc	s1,0x1d
    8000405a:	1f248493          	addi	s1,s1,498 # 80021248 <log>
    8000405e:	8526                	mv	a0,s1
    80004060:	ffffd097          	auipc	ra,0xffffd
    80004064:	ba6080e7          	jalr	-1114(ra) # 80000c06 <acquire>
  log.outstanding -= 1;
    80004068:	509c                	lw	a5,32(s1)
    8000406a:	37fd                	addiw	a5,a5,-1
    8000406c:	0007891b          	sext.w	s2,a5
    80004070:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004072:	50dc                	lw	a5,36(s1)
    80004074:	e7b9                	bnez	a5,800040c2 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80004076:	04091e63          	bnez	s2,800040d2 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000407a:	0001d497          	auipc	s1,0x1d
    8000407e:	1ce48493          	addi	s1,s1,462 # 80021248 <log>
    80004082:	4785                	li	a5,1
    80004084:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004086:	8526                	mv	a0,s1
    80004088:	ffffd097          	auipc	ra,0xffffd
    8000408c:	c32080e7          	jalr	-974(ra) # 80000cba <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004090:	54dc                	lw	a5,44(s1)
    80004092:	06f04763          	bgtz	a5,80004100 <end_op+0xbc>
    acquire(&log.lock);
    80004096:	0001d497          	auipc	s1,0x1d
    8000409a:	1b248493          	addi	s1,s1,434 # 80021248 <log>
    8000409e:	8526                	mv	a0,s1
    800040a0:	ffffd097          	auipc	ra,0xffffd
    800040a4:	b66080e7          	jalr	-1178(ra) # 80000c06 <acquire>
    log.committing = 0;
    800040a8:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800040ac:	8526                	mv	a0,s1
    800040ae:	ffffe097          	auipc	ra,0xffffe
    800040b2:	2b0080e7          	jalr	688(ra) # 8000235e <wakeup>
    release(&log.lock);
    800040b6:	8526                	mv	a0,s1
    800040b8:	ffffd097          	auipc	ra,0xffffd
    800040bc:	c02080e7          	jalr	-1022(ra) # 80000cba <release>
}
    800040c0:	a03d                	j	800040ee <end_op+0xaa>
    panic("log.committing");
    800040c2:	00004517          	auipc	a0,0x4
    800040c6:	53e50513          	addi	a0,a0,1342 # 80008600 <syscalls+0x1e0>
    800040ca:	ffffc097          	auipc	ra,0xffffc
    800040ce:	480080e7          	jalr	1152(ra) # 8000054a <panic>
    wakeup(&log);
    800040d2:	0001d497          	auipc	s1,0x1d
    800040d6:	17648493          	addi	s1,s1,374 # 80021248 <log>
    800040da:	8526                	mv	a0,s1
    800040dc:	ffffe097          	auipc	ra,0xffffe
    800040e0:	282080e7          	jalr	642(ra) # 8000235e <wakeup>
  release(&log.lock);
    800040e4:	8526                	mv	a0,s1
    800040e6:	ffffd097          	auipc	ra,0xffffd
    800040ea:	bd4080e7          	jalr	-1068(ra) # 80000cba <release>
}
    800040ee:	70e2                	ld	ra,56(sp)
    800040f0:	7442                	ld	s0,48(sp)
    800040f2:	74a2                	ld	s1,40(sp)
    800040f4:	7902                	ld	s2,32(sp)
    800040f6:	69e2                	ld	s3,24(sp)
    800040f8:	6a42                	ld	s4,16(sp)
    800040fa:	6aa2                	ld	s5,8(sp)
    800040fc:	6121                	addi	sp,sp,64
    800040fe:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80004100:	0001da97          	auipc	s5,0x1d
    80004104:	178a8a93          	addi	s5,s5,376 # 80021278 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004108:	0001da17          	auipc	s4,0x1d
    8000410c:	140a0a13          	addi	s4,s4,320 # 80021248 <log>
    80004110:	018a2583          	lw	a1,24(s4)
    80004114:	012585bb          	addw	a1,a1,s2
    80004118:	2585                	addiw	a1,a1,1
    8000411a:	028a2503          	lw	a0,40(s4)
    8000411e:	fffff097          	auipc	ra,0xfffff
    80004122:	cd4080e7          	jalr	-812(ra) # 80002df2 <bread>
    80004126:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004128:	000aa583          	lw	a1,0(s5)
    8000412c:	028a2503          	lw	a0,40(s4)
    80004130:	fffff097          	auipc	ra,0xfffff
    80004134:	cc2080e7          	jalr	-830(ra) # 80002df2 <bread>
    80004138:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000413a:	40000613          	li	a2,1024
    8000413e:	05850593          	addi	a1,a0,88
    80004142:	05848513          	addi	a0,s1,88
    80004146:	ffffd097          	auipc	ra,0xffffd
    8000414a:	c18080e7          	jalr	-1000(ra) # 80000d5e <memmove>
    bwrite(to);  // write the log
    8000414e:	8526                	mv	a0,s1
    80004150:	fffff097          	auipc	ra,0xfffff
    80004154:	d94080e7          	jalr	-620(ra) # 80002ee4 <bwrite>
    brelse(from);
    80004158:	854e                	mv	a0,s3
    8000415a:	fffff097          	auipc	ra,0xfffff
    8000415e:	dc8080e7          	jalr	-568(ra) # 80002f22 <brelse>
    brelse(to);
    80004162:	8526                	mv	a0,s1
    80004164:	fffff097          	auipc	ra,0xfffff
    80004168:	dbe080e7          	jalr	-578(ra) # 80002f22 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000416c:	2905                	addiw	s2,s2,1
    8000416e:	0a91                	addi	s5,s5,4
    80004170:	02ca2783          	lw	a5,44(s4)
    80004174:	f8f94ee3          	blt	s2,a5,80004110 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004178:	00000097          	auipc	ra,0x0
    8000417c:	c6a080e7          	jalr	-918(ra) # 80003de2 <write_head>
    install_trans(0); // Now install writes to home locations
    80004180:	4501                	li	a0,0
    80004182:	00000097          	auipc	ra,0x0
    80004186:	cda080e7          	jalr	-806(ra) # 80003e5c <install_trans>
    log.lh.n = 0;
    8000418a:	0001d797          	auipc	a5,0x1d
    8000418e:	0e07a523          	sw	zero,234(a5) # 80021274 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004192:	00000097          	auipc	ra,0x0
    80004196:	c50080e7          	jalr	-944(ra) # 80003de2 <write_head>
    8000419a:	bdf5                	j	80004096 <end_op+0x52>

000000008000419c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000419c:	1101                	addi	sp,sp,-32
    8000419e:	ec06                	sd	ra,24(sp)
    800041a0:	e822                	sd	s0,16(sp)
    800041a2:	e426                	sd	s1,8(sp)
    800041a4:	e04a                	sd	s2,0(sp)
    800041a6:	1000                	addi	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800041a8:	0001d717          	auipc	a4,0x1d
    800041ac:	0cc72703          	lw	a4,204(a4) # 80021274 <log+0x2c>
    800041b0:	47f5                	li	a5,29
    800041b2:	08e7c063          	blt	a5,a4,80004232 <log_write+0x96>
    800041b6:	84aa                	mv	s1,a0
    800041b8:	0001d797          	auipc	a5,0x1d
    800041bc:	0ac7a783          	lw	a5,172(a5) # 80021264 <log+0x1c>
    800041c0:	37fd                	addiw	a5,a5,-1
    800041c2:	06f75863          	bge	a4,a5,80004232 <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800041c6:	0001d797          	auipc	a5,0x1d
    800041ca:	0a27a783          	lw	a5,162(a5) # 80021268 <log+0x20>
    800041ce:	06f05a63          	blez	a5,80004242 <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    800041d2:	0001d917          	auipc	s2,0x1d
    800041d6:	07690913          	addi	s2,s2,118 # 80021248 <log>
    800041da:	854a                	mv	a0,s2
    800041dc:	ffffd097          	auipc	ra,0xffffd
    800041e0:	a2a080e7          	jalr	-1494(ra) # 80000c06 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    800041e4:	02c92603          	lw	a2,44(s2)
    800041e8:	06c05563          	blez	a2,80004252 <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800041ec:	44cc                	lw	a1,12(s1)
    800041ee:	0001d717          	auipc	a4,0x1d
    800041f2:	08a70713          	addi	a4,a4,138 # 80021278 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800041f6:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800041f8:	4314                	lw	a3,0(a4)
    800041fa:	04b68d63          	beq	a3,a1,80004254 <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    800041fe:	2785                	addiw	a5,a5,1
    80004200:	0711                	addi	a4,a4,4
    80004202:	fec79be3          	bne	a5,a2,800041f8 <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004206:	0621                	addi	a2,a2,8
    80004208:	060a                	slli	a2,a2,0x2
    8000420a:	0001d797          	auipc	a5,0x1d
    8000420e:	03e78793          	addi	a5,a5,62 # 80021248 <log>
    80004212:	963e                	add	a2,a2,a5
    80004214:	44dc                	lw	a5,12(s1)
    80004216:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004218:	8526                	mv	a0,s1
    8000421a:	fffff097          	auipc	ra,0xfffff
    8000421e:	da6080e7          	jalr	-602(ra) # 80002fc0 <bpin>
    log.lh.n++;
    80004222:	0001d717          	auipc	a4,0x1d
    80004226:	02670713          	addi	a4,a4,38 # 80021248 <log>
    8000422a:	575c                	lw	a5,44(a4)
    8000422c:	2785                	addiw	a5,a5,1
    8000422e:	d75c                	sw	a5,44(a4)
    80004230:	a83d                	j	8000426e <log_write+0xd2>
    panic("too big a transaction");
    80004232:	00004517          	auipc	a0,0x4
    80004236:	3de50513          	addi	a0,a0,990 # 80008610 <syscalls+0x1f0>
    8000423a:	ffffc097          	auipc	ra,0xffffc
    8000423e:	310080e7          	jalr	784(ra) # 8000054a <panic>
    panic("log_write outside of trans");
    80004242:	00004517          	auipc	a0,0x4
    80004246:	3e650513          	addi	a0,a0,998 # 80008628 <syscalls+0x208>
    8000424a:	ffffc097          	auipc	ra,0xffffc
    8000424e:	300080e7          	jalr	768(ra) # 8000054a <panic>
  for (i = 0; i < log.lh.n; i++) {
    80004252:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    80004254:	00878713          	addi	a4,a5,8
    80004258:	00271693          	slli	a3,a4,0x2
    8000425c:	0001d717          	auipc	a4,0x1d
    80004260:	fec70713          	addi	a4,a4,-20 # 80021248 <log>
    80004264:	9736                	add	a4,a4,a3
    80004266:	44d4                	lw	a3,12(s1)
    80004268:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000426a:	faf607e3          	beq	a2,a5,80004218 <log_write+0x7c>
  }
  release(&log.lock);
    8000426e:	0001d517          	auipc	a0,0x1d
    80004272:	fda50513          	addi	a0,a0,-38 # 80021248 <log>
    80004276:	ffffd097          	auipc	ra,0xffffd
    8000427a:	a44080e7          	jalr	-1468(ra) # 80000cba <release>
}
    8000427e:	60e2                	ld	ra,24(sp)
    80004280:	6442                	ld	s0,16(sp)
    80004282:	64a2                	ld	s1,8(sp)
    80004284:	6902                	ld	s2,0(sp)
    80004286:	6105                	addi	sp,sp,32
    80004288:	8082                	ret

000000008000428a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000428a:	1101                	addi	sp,sp,-32
    8000428c:	ec06                	sd	ra,24(sp)
    8000428e:	e822                	sd	s0,16(sp)
    80004290:	e426                	sd	s1,8(sp)
    80004292:	e04a                	sd	s2,0(sp)
    80004294:	1000                	addi	s0,sp,32
    80004296:	84aa                	mv	s1,a0
    80004298:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000429a:	00004597          	auipc	a1,0x4
    8000429e:	3ae58593          	addi	a1,a1,942 # 80008648 <syscalls+0x228>
    800042a2:	0521                	addi	a0,a0,8
    800042a4:	ffffd097          	auipc	ra,0xffffd
    800042a8:	8d2080e7          	jalr	-1838(ra) # 80000b76 <initlock>
  lk->name = name;
    800042ac:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800042b0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800042b4:	0204a423          	sw	zero,40(s1)
}
    800042b8:	60e2                	ld	ra,24(sp)
    800042ba:	6442                	ld	s0,16(sp)
    800042bc:	64a2                	ld	s1,8(sp)
    800042be:	6902                	ld	s2,0(sp)
    800042c0:	6105                	addi	sp,sp,32
    800042c2:	8082                	ret

00000000800042c4 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800042c4:	1101                	addi	sp,sp,-32
    800042c6:	ec06                	sd	ra,24(sp)
    800042c8:	e822                	sd	s0,16(sp)
    800042ca:	e426                	sd	s1,8(sp)
    800042cc:	e04a                	sd	s2,0(sp)
    800042ce:	1000                	addi	s0,sp,32
    800042d0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800042d2:	00850913          	addi	s2,a0,8
    800042d6:	854a                	mv	a0,s2
    800042d8:	ffffd097          	auipc	ra,0xffffd
    800042dc:	92e080e7          	jalr	-1746(ra) # 80000c06 <acquire>
  while (lk->locked) {
    800042e0:	409c                	lw	a5,0(s1)
    800042e2:	cb89                	beqz	a5,800042f4 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800042e4:	85ca                	mv	a1,s2
    800042e6:	8526                	mv	a0,s1
    800042e8:	ffffe097          	auipc	ra,0xffffe
    800042ec:	ef6080e7          	jalr	-266(ra) # 800021de <sleep>
  while (lk->locked) {
    800042f0:	409c                	lw	a5,0(s1)
    800042f2:	fbed                	bnez	a5,800042e4 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800042f4:	4785                	li	a5,1
    800042f6:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800042f8:	ffffd097          	auipc	ra,0xffffd
    800042fc:	6f6080e7          	jalr	1782(ra) # 800019ee <myproc>
    80004300:	5d1c                	lw	a5,56(a0)
    80004302:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004304:	854a                	mv	a0,s2
    80004306:	ffffd097          	auipc	ra,0xffffd
    8000430a:	9b4080e7          	jalr	-1612(ra) # 80000cba <release>
}
    8000430e:	60e2                	ld	ra,24(sp)
    80004310:	6442                	ld	s0,16(sp)
    80004312:	64a2                	ld	s1,8(sp)
    80004314:	6902                	ld	s2,0(sp)
    80004316:	6105                	addi	sp,sp,32
    80004318:	8082                	ret

000000008000431a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000431a:	1101                	addi	sp,sp,-32
    8000431c:	ec06                	sd	ra,24(sp)
    8000431e:	e822                	sd	s0,16(sp)
    80004320:	e426                	sd	s1,8(sp)
    80004322:	e04a                	sd	s2,0(sp)
    80004324:	1000                	addi	s0,sp,32
    80004326:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004328:	00850913          	addi	s2,a0,8
    8000432c:	854a                	mv	a0,s2
    8000432e:	ffffd097          	auipc	ra,0xffffd
    80004332:	8d8080e7          	jalr	-1832(ra) # 80000c06 <acquire>
  lk->locked = 0;
    80004336:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000433a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000433e:	8526                	mv	a0,s1
    80004340:	ffffe097          	auipc	ra,0xffffe
    80004344:	01e080e7          	jalr	30(ra) # 8000235e <wakeup>
  release(&lk->lk);
    80004348:	854a                	mv	a0,s2
    8000434a:	ffffd097          	auipc	ra,0xffffd
    8000434e:	970080e7          	jalr	-1680(ra) # 80000cba <release>
}
    80004352:	60e2                	ld	ra,24(sp)
    80004354:	6442                	ld	s0,16(sp)
    80004356:	64a2                	ld	s1,8(sp)
    80004358:	6902                	ld	s2,0(sp)
    8000435a:	6105                	addi	sp,sp,32
    8000435c:	8082                	ret

000000008000435e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000435e:	7179                	addi	sp,sp,-48
    80004360:	f406                	sd	ra,40(sp)
    80004362:	f022                	sd	s0,32(sp)
    80004364:	ec26                	sd	s1,24(sp)
    80004366:	e84a                	sd	s2,16(sp)
    80004368:	e44e                	sd	s3,8(sp)
    8000436a:	1800                	addi	s0,sp,48
    8000436c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000436e:	00850913          	addi	s2,a0,8
    80004372:	854a                	mv	a0,s2
    80004374:	ffffd097          	auipc	ra,0xffffd
    80004378:	892080e7          	jalr	-1902(ra) # 80000c06 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000437c:	409c                	lw	a5,0(s1)
    8000437e:	ef99                	bnez	a5,8000439c <holdingsleep+0x3e>
    80004380:	4481                	li	s1,0
  release(&lk->lk);
    80004382:	854a                	mv	a0,s2
    80004384:	ffffd097          	auipc	ra,0xffffd
    80004388:	936080e7          	jalr	-1738(ra) # 80000cba <release>
  return r;
}
    8000438c:	8526                	mv	a0,s1
    8000438e:	70a2                	ld	ra,40(sp)
    80004390:	7402                	ld	s0,32(sp)
    80004392:	64e2                	ld	s1,24(sp)
    80004394:	6942                	ld	s2,16(sp)
    80004396:	69a2                	ld	s3,8(sp)
    80004398:	6145                	addi	sp,sp,48
    8000439a:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000439c:	0284a983          	lw	s3,40(s1)
    800043a0:	ffffd097          	auipc	ra,0xffffd
    800043a4:	64e080e7          	jalr	1614(ra) # 800019ee <myproc>
    800043a8:	5d04                	lw	s1,56(a0)
    800043aa:	413484b3          	sub	s1,s1,s3
    800043ae:	0014b493          	seqz	s1,s1
    800043b2:	bfc1                	j	80004382 <holdingsleep+0x24>

00000000800043b4 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800043b4:	1141                	addi	sp,sp,-16
    800043b6:	e406                	sd	ra,8(sp)
    800043b8:	e022                	sd	s0,0(sp)
    800043ba:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800043bc:	00004597          	auipc	a1,0x4
    800043c0:	29c58593          	addi	a1,a1,668 # 80008658 <syscalls+0x238>
    800043c4:	0001d517          	auipc	a0,0x1d
    800043c8:	fcc50513          	addi	a0,a0,-52 # 80021390 <ftable>
    800043cc:	ffffc097          	auipc	ra,0xffffc
    800043d0:	7aa080e7          	jalr	1962(ra) # 80000b76 <initlock>
}
    800043d4:	60a2                	ld	ra,8(sp)
    800043d6:	6402                	ld	s0,0(sp)
    800043d8:	0141                	addi	sp,sp,16
    800043da:	8082                	ret

00000000800043dc <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800043dc:	1101                	addi	sp,sp,-32
    800043de:	ec06                	sd	ra,24(sp)
    800043e0:	e822                	sd	s0,16(sp)
    800043e2:	e426                	sd	s1,8(sp)
    800043e4:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800043e6:	0001d517          	auipc	a0,0x1d
    800043ea:	faa50513          	addi	a0,a0,-86 # 80021390 <ftable>
    800043ee:	ffffd097          	auipc	ra,0xffffd
    800043f2:	818080e7          	jalr	-2024(ra) # 80000c06 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800043f6:	0001d497          	auipc	s1,0x1d
    800043fa:	fb248493          	addi	s1,s1,-78 # 800213a8 <ftable+0x18>
    800043fe:	0001e717          	auipc	a4,0x1e
    80004402:	f4a70713          	addi	a4,a4,-182 # 80022348 <ftable+0xfb8>
    if(f->ref == 0){
    80004406:	40dc                	lw	a5,4(s1)
    80004408:	cf99                	beqz	a5,80004426 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000440a:	02848493          	addi	s1,s1,40
    8000440e:	fee49ce3          	bne	s1,a4,80004406 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004412:	0001d517          	auipc	a0,0x1d
    80004416:	f7e50513          	addi	a0,a0,-130 # 80021390 <ftable>
    8000441a:	ffffd097          	auipc	ra,0xffffd
    8000441e:	8a0080e7          	jalr	-1888(ra) # 80000cba <release>
  return 0;
    80004422:	4481                	li	s1,0
    80004424:	a819                	j	8000443a <filealloc+0x5e>
      f->ref = 1;
    80004426:	4785                	li	a5,1
    80004428:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000442a:	0001d517          	auipc	a0,0x1d
    8000442e:	f6650513          	addi	a0,a0,-154 # 80021390 <ftable>
    80004432:	ffffd097          	auipc	ra,0xffffd
    80004436:	888080e7          	jalr	-1912(ra) # 80000cba <release>
}
    8000443a:	8526                	mv	a0,s1
    8000443c:	60e2                	ld	ra,24(sp)
    8000443e:	6442                	ld	s0,16(sp)
    80004440:	64a2                	ld	s1,8(sp)
    80004442:	6105                	addi	sp,sp,32
    80004444:	8082                	ret

0000000080004446 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004446:	1101                	addi	sp,sp,-32
    80004448:	ec06                	sd	ra,24(sp)
    8000444a:	e822                	sd	s0,16(sp)
    8000444c:	e426                	sd	s1,8(sp)
    8000444e:	1000                	addi	s0,sp,32
    80004450:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004452:	0001d517          	auipc	a0,0x1d
    80004456:	f3e50513          	addi	a0,a0,-194 # 80021390 <ftable>
    8000445a:	ffffc097          	auipc	ra,0xffffc
    8000445e:	7ac080e7          	jalr	1964(ra) # 80000c06 <acquire>
  if(f->ref < 1)
    80004462:	40dc                	lw	a5,4(s1)
    80004464:	02f05263          	blez	a5,80004488 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004468:	2785                	addiw	a5,a5,1
    8000446a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000446c:	0001d517          	auipc	a0,0x1d
    80004470:	f2450513          	addi	a0,a0,-220 # 80021390 <ftable>
    80004474:	ffffd097          	auipc	ra,0xffffd
    80004478:	846080e7          	jalr	-1978(ra) # 80000cba <release>
  return f;
}
    8000447c:	8526                	mv	a0,s1
    8000447e:	60e2                	ld	ra,24(sp)
    80004480:	6442                	ld	s0,16(sp)
    80004482:	64a2                	ld	s1,8(sp)
    80004484:	6105                	addi	sp,sp,32
    80004486:	8082                	ret
    panic("filedup");
    80004488:	00004517          	auipc	a0,0x4
    8000448c:	1d850513          	addi	a0,a0,472 # 80008660 <syscalls+0x240>
    80004490:	ffffc097          	auipc	ra,0xffffc
    80004494:	0ba080e7          	jalr	186(ra) # 8000054a <panic>

0000000080004498 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004498:	7139                	addi	sp,sp,-64
    8000449a:	fc06                	sd	ra,56(sp)
    8000449c:	f822                	sd	s0,48(sp)
    8000449e:	f426                	sd	s1,40(sp)
    800044a0:	f04a                	sd	s2,32(sp)
    800044a2:	ec4e                	sd	s3,24(sp)
    800044a4:	e852                	sd	s4,16(sp)
    800044a6:	e456                	sd	s5,8(sp)
    800044a8:	0080                	addi	s0,sp,64
    800044aa:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800044ac:	0001d517          	auipc	a0,0x1d
    800044b0:	ee450513          	addi	a0,a0,-284 # 80021390 <ftable>
    800044b4:	ffffc097          	auipc	ra,0xffffc
    800044b8:	752080e7          	jalr	1874(ra) # 80000c06 <acquire>
  if(f->ref < 1)
    800044bc:	40dc                	lw	a5,4(s1)
    800044be:	06f05163          	blez	a5,80004520 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800044c2:	37fd                	addiw	a5,a5,-1
    800044c4:	0007871b          	sext.w	a4,a5
    800044c8:	c0dc                	sw	a5,4(s1)
    800044ca:	06e04363          	bgtz	a4,80004530 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800044ce:	0004a903          	lw	s2,0(s1)
    800044d2:	0094ca83          	lbu	s5,9(s1)
    800044d6:	0104ba03          	ld	s4,16(s1)
    800044da:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800044de:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800044e2:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800044e6:	0001d517          	auipc	a0,0x1d
    800044ea:	eaa50513          	addi	a0,a0,-342 # 80021390 <ftable>
    800044ee:	ffffc097          	auipc	ra,0xffffc
    800044f2:	7cc080e7          	jalr	1996(ra) # 80000cba <release>

  if(ff.type == FD_PIPE){
    800044f6:	4785                	li	a5,1
    800044f8:	04f90d63          	beq	s2,a5,80004552 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800044fc:	3979                	addiw	s2,s2,-2
    800044fe:	4785                	li	a5,1
    80004500:	0527e063          	bltu	a5,s2,80004540 <fileclose+0xa8>
    begin_op();
    80004504:	00000097          	auipc	ra,0x0
    80004508:	ac0080e7          	jalr	-1344(ra) # 80003fc4 <begin_op>
    iput(ff.ip);
    8000450c:	854e                	mv	a0,s3
    8000450e:	fffff097          	auipc	ra,0xfffff
    80004512:	2a0080e7          	jalr	672(ra) # 800037ae <iput>
    end_op();
    80004516:	00000097          	auipc	ra,0x0
    8000451a:	b2e080e7          	jalr	-1234(ra) # 80004044 <end_op>
    8000451e:	a00d                	j	80004540 <fileclose+0xa8>
    panic("fileclose");
    80004520:	00004517          	auipc	a0,0x4
    80004524:	14850513          	addi	a0,a0,328 # 80008668 <syscalls+0x248>
    80004528:	ffffc097          	auipc	ra,0xffffc
    8000452c:	022080e7          	jalr	34(ra) # 8000054a <panic>
    release(&ftable.lock);
    80004530:	0001d517          	auipc	a0,0x1d
    80004534:	e6050513          	addi	a0,a0,-416 # 80021390 <ftable>
    80004538:	ffffc097          	auipc	ra,0xffffc
    8000453c:	782080e7          	jalr	1922(ra) # 80000cba <release>
  }
}
    80004540:	70e2                	ld	ra,56(sp)
    80004542:	7442                	ld	s0,48(sp)
    80004544:	74a2                	ld	s1,40(sp)
    80004546:	7902                	ld	s2,32(sp)
    80004548:	69e2                	ld	s3,24(sp)
    8000454a:	6a42                	ld	s4,16(sp)
    8000454c:	6aa2                	ld	s5,8(sp)
    8000454e:	6121                	addi	sp,sp,64
    80004550:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004552:	85d6                	mv	a1,s5
    80004554:	8552                	mv	a0,s4
    80004556:	00000097          	auipc	ra,0x0
    8000455a:	372080e7          	jalr	882(ra) # 800048c8 <pipeclose>
    8000455e:	b7cd                	j	80004540 <fileclose+0xa8>

0000000080004560 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004560:	715d                	addi	sp,sp,-80
    80004562:	e486                	sd	ra,72(sp)
    80004564:	e0a2                	sd	s0,64(sp)
    80004566:	fc26                	sd	s1,56(sp)
    80004568:	f84a                	sd	s2,48(sp)
    8000456a:	f44e                	sd	s3,40(sp)
    8000456c:	0880                	addi	s0,sp,80
    8000456e:	84aa                	mv	s1,a0
    80004570:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004572:	ffffd097          	auipc	ra,0xffffd
    80004576:	47c080e7          	jalr	1148(ra) # 800019ee <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000457a:	409c                	lw	a5,0(s1)
    8000457c:	37f9                	addiw	a5,a5,-2
    8000457e:	4705                	li	a4,1
    80004580:	04f76763          	bltu	a4,a5,800045ce <filestat+0x6e>
    80004584:	892a                	mv	s2,a0
    ilock(f->ip);
    80004586:	6c88                	ld	a0,24(s1)
    80004588:	fffff097          	auipc	ra,0xfffff
    8000458c:	06c080e7          	jalr	108(ra) # 800035f4 <ilock>
    stati(f->ip, &st);
    80004590:	fb840593          	addi	a1,s0,-72
    80004594:	6c88                	ld	a0,24(s1)
    80004596:	fffff097          	auipc	ra,0xfffff
    8000459a:	2e8080e7          	jalr	744(ra) # 8000387e <stati>
    iunlock(f->ip);
    8000459e:	6c88                	ld	a0,24(s1)
    800045a0:	fffff097          	auipc	ra,0xfffff
    800045a4:	116080e7          	jalr	278(ra) # 800036b6 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800045a8:	46e1                	li	a3,24
    800045aa:	fb840613          	addi	a2,s0,-72
    800045ae:	85ce                	mv	a1,s3
    800045b0:	05093503          	ld	a0,80(s2)
    800045b4:	ffffd097          	auipc	ra,0xffffd
    800045b8:	0ce080e7          	jalr	206(ra) # 80001682 <copyout>
    800045bc:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800045c0:	60a6                	ld	ra,72(sp)
    800045c2:	6406                	ld	s0,64(sp)
    800045c4:	74e2                	ld	s1,56(sp)
    800045c6:	7942                	ld	s2,48(sp)
    800045c8:	79a2                	ld	s3,40(sp)
    800045ca:	6161                	addi	sp,sp,80
    800045cc:	8082                	ret
  return -1;
    800045ce:	557d                	li	a0,-1
    800045d0:	bfc5                	j	800045c0 <filestat+0x60>

00000000800045d2 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800045d2:	7179                	addi	sp,sp,-48
    800045d4:	f406                	sd	ra,40(sp)
    800045d6:	f022                	sd	s0,32(sp)
    800045d8:	ec26                	sd	s1,24(sp)
    800045da:	e84a                	sd	s2,16(sp)
    800045dc:	e44e                	sd	s3,8(sp)
    800045de:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800045e0:	00854783          	lbu	a5,8(a0)
    800045e4:	c3d5                	beqz	a5,80004688 <fileread+0xb6>
    800045e6:	84aa                	mv	s1,a0
    800045e8:	89ae                	mv	s3,a1
    800045ea:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800045ec:	411c                	lw	a5,0(a0)
    800045ee:	4705                	li	a4,1
    800045f0:	04e78963          	beq	a5,a4,80004642 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800045f4:	470d                	li	a4,3
    800045f6:	04e78d63          	beq	a5,a4,80004650 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800045fa:	4709                	li	a4,2
    800045fc:	06e79e63          	bne	a5,a4,80004678 <fileread+0xa6>
    ilock(f->ip);
    80004600:	6d08                	ld	a0,24(a0)
    80004602:	fffff097          	auipc	ra,0xfffff
    80004606:	ff2080e7          	jalr	-14(ra) # 800035f4 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000460a:	874a                	mv	a4,s2
    8000460c:	5094                	lw	a3,32(s1)
    8000460e:	864e                	mv	a2,s3
    80004610:	4585                	li	a1,1
    80004612:	6c88                	ld	a0,24(s1)
    80004614:	fffff097          	auipc	ra,0xfffff
    80004618:	294080e7          	jalr	660(ra) # 800038a8 <readi>
    8000461c:	892a                	mv	s2,a0
    8000461e:	00a05563          	blez	a0,80004628 <fileread+0x56>
      f->off += r;
    80004622:	509c                	lw	a5,32(s1)
    80004624:	9fa9                	addw	a5,a5,a0
    80004626:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004628:	6c88                	ld	a0,24(s1)
    8000462a:	fffff097          	auipc	ra,0xfffff
    8000462e:	08c080e7          	jalr	140(ra) # 800036b6 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004632:	854a                	mv	a0,s2
    80004634:	70a2                	ld	ra,40(sp)
    80004636:	7402                	ld	s0,32(sp)
    80004638:	64e2                	ld	s1,24(sp)
    8000463a:	6942                	ld	s2,16(sp)
    8000463c:	69a2                	ld	s3,8(sp)
    8000463e:	6145                	addi	sp,sp,48
    80004640:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004642:	6908                	ld	a0,16(a0)
    80004644:	00000097          	auipc	ra,0x0
    80004648:	3f4080e7          	jalr	1012(ra) # 80004a38 <piperead>
    8000464c:	892a                	mv	s2,a0
    8000464e:	b7d5                	j	80004632 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004650:	02451783          	lh	a5,36(a0)
    80004654:	03079693          	slli	a3,a5,0x30
    80004658:	92c1                	srli	a3,a3,0x30
    8000465a:	4725                	li	a4,9
    8000465c:	02d76863          	bltu	a4,a3,8000468c <fileread+0xba>
    80004660:	0792                	slli	a5,a5,0x4
    80004662:	0001d717          	auipc	a4,0x1d
    80004666:	c8e70713          	addi	a4,a4,-882 # 800212f0 <devsw>
    8000466a:	97ba                	add	a5,a5,a4
    8000466c:	639c                	ld	a5,0(a5)
    8000466e:	c38d                	beqz	a5,80004690 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004670:	4505                	li	a0,1
    80004672:	9782                	jalr	a5
    80004674:	892a                	mv	s2,a0
    80004676:	bf75                	j	80004632 <fileread+0x60>
    panic("fileread");
    80004678:	00004517          	auipc	a0,0x4
    8000467c:	00050513          	mv	a0,a0
    80004680:	ffffc097          	auipc	ra,0xffffc
    80004684:	eca080e7          	jalr	-310(ra) # 8000054a <panic>
    return -1;
    80004688:	597d                	li	s2,-1
    8000468a:	b765                	j	80004632 <fileread+0x60>
      return -1;
    8000468c:	597d                	li	s2,-1
    8000468e:	b755                	j	80004632 <fileread+0x60>
    80004690:	597d                	li	s2,-1
    80004692:	b745                	j	80004632 <fileread+0x60>

0000000080004694 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004694:	00954783          	lbu	a5,9(a0) # 80008681 <syscalls+0x261>
    80004698:	14078563          	beqz	a5,800047e2 <filewrite+0x14e>
{
    8000469c:	715d                	addi	sp,sp,-80
    8000469e:	e486                	sd	ra,72(sp)
    800046a0:	e0a2                	sd	s0,64(sp)
    800046a2:	fc26                	sd	s1,56(sp)
    800046a4:	f84a                	sd	s2,48(sp)
    800046a6:	f44e                	sd	s3,40(sp)
    800046a8:	f052                	sd	s4,32(sp)
    800046aa:	ec56                	sd	s5,24(sp)
    800046ac:	e85a                	sd	s6,16(sp)
    800046ae:	e45e                	sd	s7,8(sp)
    800046b0:	e062                	sd	s8,0(sp)
    800046b2:	0880                	addi	s0,sp,80
    800046b4:	892a                	mv	s2,a0
    800046b6:	8aae                	mv	s5,a1
    800046b8:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800046ba:	411c                	lw	a5,0(a0)
    800046bc:	4705                	li	a4,1
    800046be:	02e78263          	beq	a5,a4,800046e2 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800046c2:	470d                	li	a4,3
    800046c4:	02e78563          	beq	a5,a4,800046ee <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800046c8:	4709                	li	a4,2
    800046ca:	10e79463          	bne	a5,a4,800047d2 <filewrite+0x13e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800046ce:	0ec05e63          	blez	a2,800047ca <filewrite+0x136>
    int i = 0;
    800046d2:	4981                	li	s3,0
    800046d4:	6b05                	lui	s6,0x1
    800046d6:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    800046da:	6b85                	lui	s7,0x1
    800046dc:	c00b8b9b          	addiw	s7,s7,-1024
    800046e0:	a851                	j	80004774 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    800046e2:	6908                	ld	a0,16(a0)
    800046e4:	00000097          	auipc	ra,0x0
    800046e8:	254080e7          	jalr	596(ra) # 80004938 <pipewrite>
    800046ec:	a85d                	j	800047a2 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800046ee:	02451783          	lh	a5,36(a0)
    800046f2:	03079693          	slli	a3,a5,0x30
    800046f6:	92c1                	srli	a3,a3,0x30
    800046f8:	4725                	li	a4,9
    800046fa:	0ed76663          	bltu	a4,a3,800047e6 <filewrite+0x152>
    800046fe:	0792                	slli	a5,a5,0x4
    80004700:	0001d717          	auipc	a4,0x1d
    80004704:	bf070713          	addi	a4,a4,-1040 # 800212f0 <devsw>
    80004708:	97ba                	add	a5,a5,a4
    8000470a:	679c                	ld	a5,8(a5)
    8000470c:	cff9                	beqz	a5,800047ea <filewrite+0x156>
    ret = devsw[f->major].write(1, addr, n);
    8000470e:	4505                	li	a0,1
    80004710:	9782                	jalr	a5
    80004712:	a841                	j	800047a2 <filewrite+0x10e>
    80004714:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004718:	00000097          	auipc	ra,0x0
    8000471c:	8ac080e7          	jalr	-1876(ra) # 80003fc4 <begin_op>
      ilock(f->ip);
    80004720:	01893503          	ld	a0,24(s2)
    80004724:	fffff097          	auipc	ra,0xfffff
    80004728:	ed0080e7          	jalr	-304(ra) # 800035f4 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000472c:	8762                	mv	a4,s8
    8000472e:	02092683          	lw	a3,32(s2)
    80004732:	01598633          	add	a2,s3,s5
    80004736:	4585                	li	a1,1
    80004738:	01893503          	ld	a0,24(s2)
    8000473c:	fffff097          	auipc	ra,0xfffff
    80004740:	264080e7          	jalr	612(ra) # 800039a0 <writei>
    80004744:	84aa                	mv	s1,a0
    80004746:	02a05f63          	blez	a0,80004784 <filewrite+0xf0>
        f->off += r;
    8000474a:	02092783          	lw	a5,32(s2)
    8000474e:	9fa9                	addw	a5,a5,a0
    80004750:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004754:	01893503          	ld	a0,24(s2)
    80004758:	fffff097          	auipc	ra,0xfffff
    8000475c:	f5e080e7          	jalr	-162(ra) # 800036b6 <iunlock>
      end_op();
    80004760:	00000097          	auipc	ra,0x0
    80004764:	8e4080e7          	jalr	-1820(ra) # 80004044 <end_op>

      if(r < 0)
        break;
      if(r != n1)
    80004768:	049c1963          	bne	s8,s1,800047ba <filewrite+0x126>
        panic("short filewrite");
      i += r;
    8000476c:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004770:	0349d663          	bge	s3,s4,8000479c <filewrite+0x108>
      int n1 = n - i;
    80004774:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004778:	84be                	mv	s1,a5
    8000477a:	2781                	sext.w	a5,a5
    8000477c:	f8fb5ce3          	bge	s6,a5,80004714 <filewrite+0x80>
    80004780:	84de                	mv	s1,s7
    80004782:	bf49                	j	80004714 <filewrite+0x80>
      iunlock(f->ip);
    80004784:	01893503          	ld	a0,24(s2)
    80004788:	fffff097          	auipc	ra,0xfffff
    8000478c:	f2e080e7          	jalr	-210(ra) # 800036b6 <iunlock>
      end_op();
    80004790:	00000097          	auipc	ra,0x0
    80004794:	8b4080e7          	jalr	-1868(ra) # 80004044 <end_op>
      if(r < 0)
    80004798:	fc04d8e3          	bgez	s1,80004768 <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    8000479c:	8552                	mv	a0,s4
    8000479e:	033a1863          	bne	s4,s3,800047ce <filewrite+0x13a>
  } else {
    panic("filewrite");
  }

  return ret;
}
    800047a2:	60a6                	ld	ra,72(sp)
    800047a4:	6406                	ld	s0,64(sp)
    800047a6:	74e2                	ld	s1,56(sp)
    800047a8:	7942                	ld	s2,48(sp)
    800047aa:	79a2                	ld	s3,40(sp)
    800047ac:	7a02                	ld	s4,32(sp)
    800047ae:	6ae2                	ld	s5,24(sp)
    800047b0:	6b42                	ld	s6,16(sp)
    800047b2:	6ba2                	ld	s7,8(sp)
    800047b4:	6c02                	ld	s8,0(sp)
    800047b6:	6161                	addi	sp,sp,80
    800047b8:	8082                	ret
        panic("short filewrite");
    800047ba:	00004517          	auipc	a0,0x4
    800047be:	ece50513          	addi	a0,a0,-306 # 80008688 <syscalls+0x268>
    800047c2:	ffffc097          	auipc	ra,0xffffc
    800047c6:	d88080e7          	jalr	-632(ra) # 8000054a <panic>
    int i = 0;
    800047ca:	4981                	li	s3,0
    800047cc:	bfc1                	j	8000479c <filewrite+0x108>
    ret = (i == n ? n : -1);
    800047ce:	557d                	li	a0,-1
    800047d0:	bfc9                	j	800047a2 <filewrite+0x10e>
    panic("filewrite");
    800047d2:	00004517          	auipc	a0,0x4
    800047d6:	ec650513          	addi	a0,a0,-314 # 80008698 <syscalls+0x278>
    800047da:	ffffc097          	auipc	ra,0xffffc
    800047de:	d70080e7          	jalr	-656(ra) # 8000054a <panic>
    return -1;
    800047e2:	557d                	li	a0,-1
}
    800047e4:	8082                	ret
      return -1;
    800047e6:	557d                	li	a0,-1
    800047e8:	bf6d                	j	800047a2 <filewrite+0x10e>
    800047ea:	557d                	li	a0,-1
    800047ec:	bf5d                	j	800047a2 <filewrite+0x10e>

00000000800047ee <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800047ee:	7179                	addi	sp,sp,-48
    800047f0:	f406                	sd	ra,40(sp)
    800047f2:	f022                	sd	s0,32(sp)
    800047f4:	ec26                	sd	s1,24(sp)
    800047f6:	e84a                	sd	s2,16(sp)
    800047f8:	e44e                	sd	s3,8(sp)
    800047fa:	e052                	sd	s4,0(sp)
    800047fc:	1800                	addi	s0,sp,48
    800047fe:	84aa                	mv	s1,a0
    80004800:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004802:	0005b023          	sd	zero,0(a1)
    80004806:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000480a:	00000097          	auipc	ra,0x0
    8000480e:	bd2080e7          	jalr	-1070(ra) # 800043dc <filealloc>
    80004812:	e088                	sd	a0,0(s1)
    80004814:	c551                	beqz	a0,800048a0 <pipealloc+0xb2>
    80004816:	00000097          	auipc	ra,0x0
    8000481a:	bc6080e7          	jalr	-1082(ra) # 800043dc <filealloc>
    8000481e:	00aa3023          	sd	a0,0(s4)
    80004822:	c92d                	beqz	a0,80004894 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004824:	ffffc097          	auipc	ra,0xffffc
    80004828:	2f2080e7          	jalr	754(ra) # 80000b16 <kalloc>
    8000482c:	892a                	mv	s2,a0
    8000482e:	c125                	beqz	a0,8000488e <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004830:	4985                	li	s3,1
    80004832:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004836:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000483a:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000483e:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004842:	00004597          	auipc	a1,0x4
    80004846:	e6658593          	addi	a1,a1,-410 # 800086a8 <syscalls+0x288>
    8000484a:	ffffc097          	auipc	ra,0xffffc
    8000484e:	32c080e7          	jalr	812(ra) # 80000b76 <initlock>
  (*f0)->type = FD_PIPE;
    80004852:	609c                	ld	a5,0(s1)
    80004854:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004858:	609c                	ld	a5,0(s1)
    8000485a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000485e:	609c                	ld	a5,0(s1)
    80004860:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004864:	609c                	ld	a5,0(s1)
    80004866:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000486a:	000a3783          	ld	a5,0(s4)
    8000486e:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004872:	000a3783          	ld	a5,0(s4)
    80004876:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000487a:	000a3783          	ld	a5,0(s4)
    8000487e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004882:	000a3783          	ld	a5,0(s4)
    80004886:	0127b823          	sd	s2,16(a5)
  return 0;
    8000488a:	4501                	li	a0,0
    8000488c:	a025                	j	800048b4 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000488e:	6088                	ld	a0,0(s1)
    80004890:	e501                	bnez	a0,80004898 <pipealloc+0xaa>
    80004892:	a039                	j	800048a0 <pipealloc+0xb2>
    80004894:	6088                	ld	a0,0(s1)
    80004896:	c51d                	beqz	a0,800048c4 <pipealloc+0xd6>
    fileclose(*f0);
    80004898:	00000097          	auipc	ra,0x0
    8000489c:	c00080e7          	jalr	-1024(ra) # 80004498 <fileclose>
  if(*f1)
    800048a0:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800048a4:	557d                	li	a0,-1
  if(*f1)
    800048a6:	c799                	beqz	a5,800048b4 <pipealloc+0xc6>
    fileclose(*f1);
    800048a8:	853e                	mv	a0,a5
    800048aa:	00000097          	auipc	ra,0x0
    800048ae:	bee080e7          	jalr	-1042(ra) # 80004498 <fileclose>
  return -1;
    800048b2:	557d                	li	a0,-1
}
    800048b4:	70a2                	ld	ra,40(sp)
    800048b6:	7402                	ld	s0,32(sp)
    800048b8:	64e2                	ld	s1,24(sp)
    800048ba:	6942                	ld	s2,16(sp)
    800048bc:	69a2                	ld	s3,8(sp)
    800048be:	6a02                	ld	s4,0(sp)
    800048c0:	6145                	addi	sp,sp,48
    800048c2:	8082                	ret
  return -1;
    800048c4:	557d                	li	a0,-1
    800048c6:	b7fd                	j	800048b4 <pipealloc+0xc6>

00000000800048c8 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800048c8:	1101                	addi	sp,sp,-32
    800048ca:	ec06                	sd	ra,24(sp)
    800048cc:	e822                	sd	s0,16(sp)
    800048ce:	e426                	sd	s1,8(sp)
    800048d0:	e04a                	sd	s2,0(sp)
    800048d2:	1000                	addi	s0,sp,32
    800048d4:	84aa                	mv	s1,a0
    800048d6:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800048d8:	ffffc097          	auipc	ra,0xffffc
    800048dc:	32e080e7          	jalr	814(ra) # 80000c06 <acquire>
  if(writable){
    800048e0:	02090d63          	beqz	s2,8000491a <pipeclose+0x52>
    pi->writeopen = 0;
    800048e4:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800048e8:	21848513          	addi	a0,s1,536
    800048ec:	ffffe097          	auipc	ra,0xffffe
    800048f0:	a72080e7          	jalr	-1422(ra) # 8000235e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800048f4:	2204b783          	ld	a5,544(s1)
    800048f8:	eb95                	bnez	a5,8000492c <pipeclose+0x64>
    release(&pi->lock);
    800048fa:	8526                	mv	a0,s1
    800048fc:	ffffc097          	auipc	ra,0xffffc
    80004900:	3be080e7          	jalr	958(ra) # 80000cba <release>
    kfree((char*)pi);
    80004904:	8526                	mv	a0,s1
    80004906:	ffffc097          	auipc	ra,0xffffc
    8000490a:	114080e7          	jalr	276(ra) # 80000a1a <kfree>
  } else
    release(&pi->lock);
}
    8000490e:	60e2                	ld	ra,24(sp)
    80004910:	6442                	ld	s0,16(sp)
    80004912:	64a2                	ld	s1,8(sp)
    80004914:	6902                	ld	s2,0(sp)
    80004916:	6105                	addi	sp,sp,32
    80004918:	8082                	ret
    pi->readopen = 0;
    8000491a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000491e:	21c48513          	addi	a0,s1,540
    80004922:	ffffe097          	auipc	ra,0xffffe
    80004926:	a3c080e7          	jalr	-1476(ra) # 8000235e <wakeup>
    8000492a:	b7e9                	j	800048f4 <pipeclose+0x2c>
    release(&pi->lock);
    8000492c:	8526                	mv	a0,s1
    8000492e:	ffffc097          	auipc	ra,0xffffc
    80004932:	38c080e7          	jalr	908(ra) # 80000cba <release>
}
    80004936:	bfe1                	j	8000490e <pipeclose+0x46>

0000000080004938 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004938:	711d                	addi	sp,sp,-96
    8000493a:	ec86                	sd	ra,88(sp)
    8000493c:	e8a2                	sd	s0,80(sp)
    8000493e:	e4a6                	sd	s1,72(sp)
    80004940:	e0ca                	sd	s2,64(sp)
    80004942:	fc4e                	sd	s3,56(sp)
    80004944:	f852                	sd	s4,48(sp)
    80004946:	f456                	sd	s5,40(sp)
    80004948:	f05a                	sd	s6,32(sp)
    8000494a:	ec5e                	sd	s7,24(sp)
    8000494c:	e862                	sd	s8,16(sp)
    8000494e:	1080                	addi	s0,sp,96
    80004950:	84aa                	mv	s1,a0
    80004952:	8b2e                	mv	s6,a1
    80004954:	8ab2                	mv	s5,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    80004956:	ffffd097          	auipc	ra,0xffffd
    8000495a:	098080e7          	jalr	152(ra) # 800019ee <myproc>
    8000495e:	892a                	mv	s2,a0

  acquire(&pi->lock);
    80004960:	8526                	mv	a0,s1
    80004962:	ffffc097          	auipc	ra,0xffffc
    80004966:	2a4080e7          	jalr	676(ra) # 80000c06 <acquire>
  for(i = 0; i < n; i++){
    8000496a:	09505763          	blez	s5,800049f8 <pipewrite+0xc0>
    8000496e:	4b81                	li	s7,0
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || pr->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    80004970:	21848a13          	addi	s4,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004974:	21c48993          	addi	s3,s1,540
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004978:	5c7d                	li	s8,-1
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    8000497a:	2184a783          	lw	a5,536(s1)
    8000497e:	21c4a703          	lw	a4,540(s1)
    80004982:	2007879b          	addiw	a5,a5,512
    80004986:	02f71b63          	bne	a4,a5,800049bc <pipewrite+0x84>
      if(pi->readopen == 0 || pr->killed){
    8000498a:	2204a783          	lw	a5,544(s1)
    8000498e:	c3d1                	beqz	a5,80004a12 <pipewrite+0xda>
    80004990:	03092783          	lw	a5,48(s2)
    80004994:	efbd                	bnez	a5,80004a12 <pipewrite+0xda>
      wakeup(&pi->nread);
    80004996:	8552                	mv	a0,s4
    80004998:	ffffe097          	auipc	ra,0xffffe
    8000499c:	9c6080e7          	jalr	-1594(ra) # 8000235e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800049a0:	85a6                	mv	a1,s1
    800049a2:	854e                	mv	a0,s3
    800049a4:	ffffe097          	auipc	ra,0xffffe
    800049a8:	83a080e7          	jalr	-1990(ra) # 800021de <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    800049ac:	2184a783          	lw	a5,536(s1)
    800049b0:	21c4a703          	lw	a4,540(s1)
    800049b4:	2007879b          	addiw	a5,a5,512
    800049b8:	fcf709e3          	beq	a4,a5,8000498a <pipewrite+0x52>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800049bc:	4685                	li	a3,1
    800049be:	865a                	mv	a2,s6
    800049c0:	faf40593          	addi	a1,s0,-81
    800049c4:	05093503          	ld	a0,80(s2)
    800049c8:	ffffd097          	auipc	ra,0xffffd
    800049cc:	d46080e7          	jalr	-698(ra) # 8000170e <copyin>
    800049d0:	03850563          	beq	a0,s8,800049fa <pipewrite+0xc2>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800049d4:	21c4a783          	lw	a5,540(s1)
    800049d8:	0017871b          	addiw	a4,a5,1
    800049dc:	20e4ae23          	sw	a4,540(s1)
    800049e0:	1ff7f793          	andi	a5,a5,511
    800049e4:	97a6                	add	a5,a5,s1
    800049e6:	faf44703          	lbu	a4,-81(s0)
    800049ea:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    800049ee:	2b85                	addiw	s7,s7,1
    800049f0:	0b05                	addi	s6,s6,1
    800049f2:	f97a94e3          	bne	s5,s7,8000497a <pipewrite+0x42>
    800049f6:	a011                	j	800049fa <pipewrite+0xc2>
    800049f8:	4b81                	li	s7,0
  }
  wakeup(&pi->nread);
    800049fa:	21848513          	addi	a0,s1,536
    800049fe:	ffffe097          	auipc	ra,0xffffe
    80004a02:	960080e7          	jalr	-1696(ra) # 8000235e <wakeup>
  release(&pi->lock);
    80004a06:	8526                	mv	a0,s1
    80004a08:	ffffc097          	auipc	ra,0xffffc
    80004a0c:	2b2080e7          	jalr	690(ra) # 80000cba <release>
  return i;
    80004a10:	a039                	j	80004a1e <pipewrite+0xe6>
        release(&pi->lock);
    80004a12:	8526                	mv	a0,s1
    80004a14:	ffffc097          	auipc	ra,0xffffc
    80004a18:	2a6080e7          	jalr	678(ra) # 80000cba <release>
        return -1;
    80004a1c:	5bfd                	li	s7,-1
}
    80004a1e:	855e                	mv	a0,s7
    80004a20:	60e6                	ld	ra,88(sp)
    80004a22:	6446                	ld	s0,80(sp)
    80004a24:	64a6                	ld	s1,72(sp)
    80004a26:	6906                	ld	s2,64(sp)
    80004a28:	79e2                	ld	s3,56(sp)
    80004a2a:	7a42                	ld	s4,48(sp)
    80004a2c:	7aa2                	ld	s5,40(sp)
    80004a2e:	7b02                	ld	s6,32(sp)
    80004a30:	6be2                	ld	s7,24(sp)
    80004a32:	6c42                	ld	s8,16(sp)
    80004a34:	6125                	addi	sp,sp,96
    80004a36:	8082                	ret

0000000080004a38 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004a38:	715d                	addi	sp,sp,-80
    80004a3a:	e486                	sd	ra,72(sp)
    80004a3c:	e0a2                	sd	s0,64(sp)
    80004a3e:	fc26                	sd	s1,56(sp)
    80004a40:	f84a                	sd	s2,48(sp)
    80004a42:	f44e                	sd	s3,40(sp)
    80004a44:	f052                	sd	s4,32(sp)
    80004a46:	ec56                	sd	s5,24(sp)
    80004a48:	e85a                	sd	s6,16(sp)
    80004a4a:	0880                	addi	s0,sp,80
    80004a4c:	84aa                	mv	s1,a0
    80004a4e:	892e                	mv	s2,a1
    80004a50:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004a52:	ffffd097          	auipc	ra,0xffffd
    80004a56:	f9c080e7          	jalr	-100(ra) # 800019ee <myproc>
    80004a5a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004a5c:	8526                	mv	a0,s1
    80004a5e:	ffffc097          	auipc	ra,0xffffc
    80004a62:	1a8080e7          	jalr	424(ra) # 80000c06 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a66:	2184a703          	lw	a4,536(s1)
    80004a6a:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004a6e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a72:	02f71463          	bne	a4,a5,80004a9a <piperead+0x62>
    80004a76:	2244a783          	lw	a5,548(s1)
    80004a7a:	c385                	beqz	a5,80004a9a <piperead+0x62>
    if(pr->killed){
    80004a7c:	030a2783          	lw	a5,48(s4)
    80004a80:	ebc1                	bnez	a5,80004b10 <piperead+0xd8>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004a82:	85a6                	mv	a1,s1
    80004a84:	854e                	mv	a0,s3
    80004a86:	ffffd097          	auipc	ra,0xffffd
    80004a8a:	758080e7          	jalr	1880(ra) # 800021de <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a8e:	2184a703          	lw	a4,536(s1)
    80004a92:	21c4a783          	lw	a5,540(s1)
    80004a96:	fef700e3          	beq	a4,a5,80004a76 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004a9a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004a9c:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004a9e:	05505363          	blez	s5,80004ae4 <piperead+0xac>
    if(pi->nread == pi->nwrite)
    80004aa2:	2184a783          	lw	a5,536(s1)
    80004aa6:	21c4a703          	lw	a4,540(s1)
    80004aaa:	02f70d63          	beq	a4,a5,80004ae4 <piperead+0xac>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004aae:	0017871b          	addiw	a4,a5,1
    80004ab2:	20e4ac23          	sw	a4,536(s1)
    80004ab6:	1ff7f793          	andi	a5,a5,511
    80004aba:	97a6                	add	a5,a5,s1
    80004abc:	0187c783          	lbu	a5,24(a5)
    80004ac0:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004ac4:	4685                	li	a3,1
    80004ac6:	fbf40613          	addi	a2,s0,-65
    80004aca:	85ca                	mv	a1,s2
    80004acc:	050a3503          	ld	a0,80(s4)
    80004ad0:	ffffd097          	auipc	ra,0xffffd
    80004ad4:	bb2080e7          	jalr	-1102(ra) # 80001682 <copyout>
    80004ad8:	01650663          	beq	a0,s6,80004ae4 <piperead+0xac>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004adc:	2985                	addiw	s3,s3,1
    80004ade:	0905                	addi	s2,s2,1
    80004ae0:	fd3a91e3          	bne	s5,s3,80004aa2 <piperead+0x6a>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004ae4:	21c48513          	addi	a0,s1,540
    80004ae8:	ffffe097          	auipc	ra,0xffffe
    80004aec:	876080e7          	jalr	-1930(ra) # 8000235e <wakeup>
  release(&pi->lock);
    80004af0:	8526                	mv	a0,s1
    80004af2:	ffffc097          	auipc	ra,0xffffc
    80004af6:	1c8080e7          	jalr	456(ra) # 80000cba <release>
  return i;
}
    80004afa:	854e                	mv	a0,s3
    80004afc:	60a6                	ld	ra,72(sp)
    80004afe:	6406                	ld	s0,64(sp)
    80004b00:	74e2                	ld	s1,56(sp)
    80004b02:	7942                	ld	s2,48(sp)
    80004b04:	79a2                	ld	s3,40(sp)
    80004b06:	7a02                	ld	s4,32(sp)
    80004b08:	6ae2                	ld	s5,24(sp)
    80004b0a:	6b42                	ld	s6,16(sp)
    80004b0c:	6161                	addi	sp,sp,80
    80004b0e:	8082                	ret
      release(&pi->lock);
    80004b10:	8526                	mv	a0,s1
    80004b12:	ffffc097          	auipc	ra,0xffffc
    80004b16:	1a8080e7          	jalr	424(ra) # 80000cba <release>
      return -1;
    80004b1a:	59fd                	li	s3,-1
    80004b1c:	bff9                	j	80004afa <piperead+0xc2>

0000000080004b1e <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004b1e:	de010113          	addi	sp,sp,-544
    80004b22:	20113c23          	sd	ra,536(sp)
    80004b26:	20813823          	sd	s0,528(sp)
    80004b2a:	20913423          	sd	s1,520(sp)
    80004b2e:	21213023          	sd	s2,512(sp)
    80004b32:	ffce                	sd	s3,504(sp)
    80004b34:	fbd2                	sd	s4,496(sp)
    80004b36:	f7d6                	sd	s5,488(sp)
    80004b38:	f3da                	sd	s6,480(sp)
    80004b3a:	efde                	sd	s7,472(sp)
    80004b3c:	ebe2                	sd	s8,464(sp)
    80004b3e:	e7e6                	sd	s9,456(sp)
    80004b40:	e3ea                	sd	s10,448(sp)
    80004b42:	ff6e                	sd	s11,440(sp)
    80004b44:	1400                	addi	s0,sp,544
    80004b46:	892a                	mv	s2,a0
    80004b48:	dea43423          	sd	a0,-536(s0)
    80004b4c:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004b50:	ffffd097          	auipc	ra,0xffffd
    80004b54:	e9e080e7          	jalr	-354(ra) # 800019ee <myproc>
    80004b58:	84aa                	mv	s1,a0

  begin_op();
    80004b5a:	fffff097          	auipc	ra,0xfffff
    80004b5e:	46a080e7          	jalr	1130(ra) # 80003fc4 <begin_op>

  if((ip = namei(path)) == 0){
    80004b62:	854a                	mv	a0,s2
    80004b64:	fffff097          	auipc	ra,0xfffff
    80004b68:	244080e7          	jalr	580(ra) # 80003da8 <namei>
    80004b6c:	c93d                	beqz	a0,80004be2 <exec+0xc4>
    80004b6e:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004b70:	fffff097          	auipc	ra,0xfffff
    80004b74:	a84080e7          	jalr	-1404(ra) # 800035f4 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004b78:	04000713          	li	a4,64
    80004b7c:	4681                	li	a3,0
    80004b7e:	e4840613          	addi	a2,s0,-440
    80004b82:	4581                	li	a1,0
    80004b84:	8556                	mv	a0,s5
    80004b86:	fffff097          	auipc	ra,0xfffff
    80004b8a:	d22080e7          	jalr	-734(ra) # 800038a8 <readi>
    80004b8e:	04000793          	li	a5,64
    80004b92:	00f51a63          	bne	a0,a5,80004ba6 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004b96:	e4842703          	lw	a4,-440(s0)
    80004b9a:	464c47b7          	lui	a5,0x464c4
    80004b9e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004ba2:	04f70663          	beq	a4,a5,80004bee <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004ba6:	8556                	mv	a0,s5
    80004ba8:	fffff097          	auipc	ra,0xfffff
    80004bac:	cae080e7          	jalr	-850(ra) # 80003856 <iunlockput>
    end_op();
    80004bb0:	fffff097          	auipc	ra,0xfffff
    80004bb4:	494080e7          	jalr	1172(ra) # 80004044 <end_op>
  }
  return -1;
    80004bb8:	557d                	li	a0,-1
}
    80004bba:	21813083          	ld	ra,536(sp)
    80004bbe:	21013403          	ld	s0,528(sp)
    80004bc2:	20813483          	ld	s1,520(sp)
    80004bc6:	20013903          	ld	s2,512(sp)
    80004bca:	79fe                	ld	s3,504(sp)
    80004bcc:	7a5e                	ld	s4,496(sp)
    80004bce:	7abe                	ld	s5,488(sp)
    80004bd0:	7b1e                	ld	s6,480(sp)
    80004bd2:	6bfe                	ld	s7,472(sp)
    80004bd4:	6c5e                	ld	s8,464(sp)
    80004bd6:	6cbe                	ld	s9,456(sp)
    80004bd8:	6d1e                	ld	s10,448(sp)
    80004bda:	7dfa                	ld	s11,440(sp)
    80004bdc:	22010113          	addi	sp,sp,544
    80004be0:	8082                	ret
    end_op();
    80004be2:	fffff097          	auipc	ra,0xfffff
    80004be6:	462080e7          	jalr	1122(ra) # 80004044 <end_op>
    return -1;
    80004bea:	557d                	li	a0,-1
    80004bec:	b7f9                	j	80004bba <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004bee:	8526                	mv	a0,s1
    80004bf0:	ffffd097          	auipc	ra,0xffffd
    80004bf4:	ec2080e7          	jalr	-318(ra) # 80001ab2 <proc_pagetable>
    80004bf8:	8b2a                	mv	s6,a0
    80004bfa:	d555                	beqz	a0,80004ba6 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004bfc:	e6842783          	lw	a5,-408(s0)
    80004c00:	e8045703          	lhu	a4,-384(s0)
    80004c04:	c735                	beqz	a4,80004c70 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004c06:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004c08:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004c0c:	6a05                	lui	s4,0x1
    80004c0e:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004c12:	dee43023          	sd	a4,-544(s0)
  uint64 pa;

  if((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    80004c16:	6d85                	lui	s11,0x1
    80004c18:	7d7d                	lui	s10,0xfffff
    80004c1a:	ac1d                	j	80004e50 <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004c1c:	00004517          	auipc	a0,0x4
    80004c20:	a9450513          	addi	a0,a0,-1388 # 800086b0 <syscalls+0x290>
    80004c24:	ffffc097          	auipc	ra,0xffffc
    80004c28:	926080e7          	jalr	-1754(ra) # 8000054a <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004c2c:	874a                	mv	a4,s2
    80004c2e:	009c86bb          	addw	a3,s9,s1
    80004c32:	4581                	li	a1,0
    80004c34:	8556                	mv	a0,s5
    80004c36:	fffff097          	auipc	ra,0xfffff
    80004c3a:	c72080e7          	jalr	-910(ra) # 800038a8 <readi>
    80004c3e:	2501                	sext.w	a0,a0
    80004c40:	1aa91863          	bne	s2,a0,80004df0 <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    80004c44:	009d84bb          	addw	s1,s11,s1
    80004c48:	013d09bb          	addw	s3,s10,s3
    80004c4c:	1f74f263          	bgeu	s1,s7,80004e30 <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    80004c50:	02049593          	slli	a1,s1,0x20
    80004c54:	9181                	srli	a1,a1,0x20
    80004c56:	95e2                	add	a1,a1,s8
    80004c58:	855a                	mv	a0,s6
    80004c5a:	ffffc097          	auipc	ra,0xffffc
    80004c5e:	436080e7          	jalr	1078(ra) # 80001090 <walkaddr>
    80004c62:	862a                	mv	a2,a0
    if(pa == 0)
    80004c64:	dd45                	beqz	a0,80004c1c <exec+0xfe>
      n = PGSIZE;
    80004c66:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004c68:	fd49f2e3          	bgeu	s3,s4,80004c2c <exec+0x10e>
      n = sz - i;
    80004c6c:	894e                	mv	s2,s3
    80004c6e:	bf7d                	j	80004c2c <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004c70:	4481                	li	s1,0
  iunlockput(ip);
    80004c72:	8556                	mv	a0,s5
    80004c74:	fffff097          	auipc	ra,0xfffff
    80004c78:	be2080e7          	jalr	-1054(ra) # 80003856 <iunlockput>
  end_op();
    80004c7c:	fffff097          	auipc	ra,0xfffff
    80004c80:	3c8080e7          	jalr	968(ra) # 80004044 <end_op>
  p = myproc();
    80004c84:	ffffd097          	auipc	ra,0xffffd
    80004c88:	d6a080e7          	jalr	-662(ra) # 800019ee <myproc>
    80004c8c:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004c8e:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004c92:	6785                	lui	a5,0x1
    80004c94:	17fd                	addi	a5,a5,-1
    80004c96:	94be                	add	s1,s1,a5
    80004c98:	77fd                	lui	a5,0xfffff
    80004c9a:	8fe5                	and	a5,a5,s1
    80004c9c:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004ca0:	6609                	lui	a2,0x2
    80004ca2:	963e                	add	a2,a2,a5
    80004ca4:	85be                	mv	a1,a5
    80004ca6:	855a                	mv	a0,s6
    80004ca8:	ffffc097          	auipc	ra,0xffffc
    80004cac:	78a080e7          	jalr	1930(ra) # 80001432 <uvmalloc>
    80004cb0:	8c2a                	mv	s8,a0
  ip = 0;
    80004cb2:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004cb4:	12050e63          	beqz	a0,80004df0 <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004cb8:	75f9                	lui	a1,0xffffe
    80004cba:	95aa                	add	a1,a1,a0
    80004cbc:	855a                	mv	a0,s6
    80004cbe:	ffffd097          	auipc	ra,0xffffd
    80004cc2:	992080e7          	jalr	-1646(ra) # 80001650 <uvmclear>
  stackbase = sp - PGSIZE;
    80004cc6:	7afd                	lui	s5,0xfffff
    80004cc8:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004cca:	df043783          	ld	a5,-528(s0)
    80004cce:	6388                	ld	a0,0(a5)
    80004cd0:	c925                	beqz	a0,80004d40 <exec+0x222>
    80004cd2:	e8840993          	addi	s3,s0,-376
    80004cd6:	f8840c93          	addi	s9,s0,-120
  sp = sz;
    80004cda:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004cdc:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004cde:	ffffc097          	auipc	ra,0xffffc
    80004ce2:	1a8080e7          	jalr	424(ra) # 80000e86 <strlen>
    80004ce6:	0015079b          	addiw	a5,a0,1
    80004cea:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004cee:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004cf2:	13596363          	bltu	s2,s5,80004e18 <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004cf6:	df043d83          	ld	s11,-528(s0)
    80004cfa:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004cfe:	8552                	mv	a0,s4
    80004d00:	ffffc097          	auipc	ra,0xffffc
    80004d04:	186080e7          	jalr	390(ra) # 80000e86 <strlen>
    80004d08:	0015069b          	addiw	a3,a0,1
    80004d0c:	8652                	mv	a2,s4
    80004d0e:	85ca                	mv	a1,s2
    80004d10:	855a                	mv	a0,s6
    80004d12:	ffffd097          	auipc	ra,0xffffd
    80004d16:	970080e7          	jalr	-1680(ra) # 80001682 <copyout>
    80004d1a:	10054363          	bltz	a0,80004e20 <exec+0x302>
    ustack[argc] = sp;
    80004d1e:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004d22:	0485                	addi	s1,s1,1
    80004d24:	008d8793          	addi	a5,s11,8
    80004d28:	def43823          	sd	a5,-528(s0)
    80004d2c:	008db503          	ld	a0,8(s11)
    80004d30:	c911                	beqz	a0,80004d44 <exec+0x226>
    if(argc >= MAXARG)
    80004d32:	09a1                	addi	s3,s3,8
    80004d34:	fb3c95e3          	bne	s9,s3,80004cde <exec+0x1c0>
  sz = sz1;
    80004d38:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004d3c:	4a81                	li	s5,0
    80004d3e:	a84d                	j	80004df0 <exec+0x2d2>
  sp = sz;
    80004d40:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004d42:	4481                	li	s1,0
  ustack[argc] = 0;
    80004d44:	00349793          	slli	a5,s1,0x3
    80004d48:	f9040713          	addi	a4,s0,-112
    80004d4c:	97ba                	add	a5,a5,a4
    80004d4e:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffd8ef8>
  sp -= (argc+1) * sizeof(uint64);
    80004d52:	00148693          	addi	a3,s1,1
    80004d56:	068e                	slli	a3,a3,0x3
    80004d58:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004d5c:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004d60:	01597663          	bgeu	s2,s5,80004d6c <exec+0x24e>
  sz = sz1;
    80004d64:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004d68:	4a81                	li	s5,0
    80004d6a:	a059                	j	80004df0 <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004d6c:	e8840613          	addi	a2,s0,-376
    80004d70:	85ca                	mv	a1,s2
    80004d72:	855a                	mv	a0,s6
    80004d74:	ffffd097          	auipc	ra,0xffffd
    80004d78:	90e080e7          	jalr	-1778(ra) # 80001682 <copyout>
    80004d7c:	0a054663          	bltz	a0,80004e28 <exec+0x30a>
  p->trapframe->a1 = sp;
    80004d80:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    80004d84:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004d88:	de843783          	ld	a5,-536(s0)
    80004d8c:	0007c703          	lbu	a4,0(a5)
    80004d90:	cf11                	beqz	a4,80004dac <exec+0x28e>
    80004d92:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004d94:	02f00693          	li	a3,47
    80004d98:	a039                	j	80004da6 <exec+0x288>
      last = s+1;
    80004d9a:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004d9e:	0785                	addi	a5,a5,1
    80004da0:	fff7c703          	lbu	a4,-1(a5)
    80004da4:	c701                	beqz	a4,80004dac <exec+0x28e>
    if(*s == '/')
    80004da6:	fed71ce3          	bne	a4,a3,80004d9e <exec+0x280>
    80004daa:	bfc5                	j	80004d9a <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    80004dac:	4641                	li	a2,16
    80004dae:	de843583          	ld	a1,-536(s0)
    80004db2:	158b8513          	addi	a0,s7,344
    80004db6:	ffffc097          	auipc	ra,0xffffc
    80004dba:	09e080e7          	jalr	158(ra) # 80000e54 <safestrcpy>
  oldpagetable = p->pagetable;
    80004dbe:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004dc2:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004dc6:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004dca:	058bb783          	ld	a5,88(s7)
    80004dce:	e6043703          	ld	a4,-416(s0)
    80004dd2:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004dd4:	058bb783          	ld	a5,88(s7)
    80004dd8:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004ddc:	85ea                	mv	a1,s10
    80004dde:	ffffd097          	auipc	ra,0xffffd
    80004de2:	d70080e7          	jalr	-656(ra) # 80001b4e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004de6:	0004851b          	sext.w	a0,s1
    80004dea:	bbc1                	j	80004bba <exec+0x9c>
    80004dec:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004df0:	df843583          	ld	a1,-520(s0)
    80004df4:	855a                	mv	a0,s6
    80004df6:	ffffd097          	auipc	ra,0xffffd
    80004dfa:	d58080e7          	jalr	-680(ra) # 80001b4e <proc_freepagetable>
  if(ip){
    80004dfe:	da0a94e3          	bnez	s5,80004ba6 <exec+0x88>
  return -1;
    80004e02:	557d                	li	a0,-1
    80004e04:	bb5d                	j	80004bba <exec+0x9c>
    80004e06:	de943c23          	sd	s1,-520(s0)
    80004e0a:	b7dd                	j	80004df0 <exec+0x2d2>
    80004e0c:	de943c23          	sd	s1,-520(s0)
    80004e10:	b7c5                	j	80004df0 <exec+0x2d2>
    80004e12:	de943c23          	sd	s1,-520(s0)
    80004e16:	bfe9                	j	80004df0 <exec+0x2d2>
  sz = sz1;
    80004e18:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004e1c:	4a81                	li	s5,0
    80004e1e:	bfc9                	j	80004df0 <exec+0x2d2>
  sz = sz1;
    80004e20:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004e24:	4a81                	li	s5,0
    80004e26:	b7e9                	j	80004df0 <exec+0x2d2>
  sz = sz1;
    80004e28:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004e2c:	4a81                	li	s5,0
    80004e2e:	b7c9                	j	80004df0 <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004e30:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004e34:	e0843783          	ld	a5,-504(s0)
    80004e38:	0017869b          	addiw	a3,a5,1
    80004e3c:	e0d43423          	sd	a3,-504(s0)
    80004e40:	e0043783          	ld	a5,-512(s0)
    80004e44:	0387879b          	addiw	a5,a5,56
    80004e48:	e8045703          	lhu	a4,-384(s0)
    80004e4c:	e2e6d3e3          	bge	a3,a4,80004c72 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004e50:	2781                	sext.w	a5,a5
    80004e52:	e0f43023          	sd	a5,-512(s0)
    80004e56:	03800713          	li	a4,56
    80004e5a:	86be                	mv	a3,a5
    80004e5c:	e1040613          	addi	a2,s0,-496
    80004e60:	4581                	li	a1,0
    80004e62:	8556                	mv	a0,s5
    80004e64:	fffff097          	auipc	ra,0xfffff
    80004e68:	a44080e7          	jalr	-1468(ra) # 800038a8 <readi>
    80004e6c:	03800793          	li	a5,56
    80004e70:	f6f51ee3          	bne	a0,a5,80004dec <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    80004e74:	e1042783          	lw	a5,-496(s0)
    80004e78:	4705                	li	a4,1
    80004e7a:	fae79de3          	bne	a5,a4,80004e34 <exec+0x316>
    if(ph.memsz < ph.filesz)
    80004e7e:	e3843603          	ld	a2,-456(s0)
    80004e82:	e3043783          	ld	a5,-464(s0)
    80004e86:	f8f660e3          	bltu	a2,a5,80004e06 <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004e8a:	e2043783          	ld	a5,-480(s0)
    80004e8e:	963e                	add	a2,a2,a5
    80004e90:	f6f66ee3          	bltu	a2,a5,80004e0c <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004e94:	85a6                	mv	a1,s1
    80004e96:	855a                	mv	a0,s6
    80004e98:	ffffc097          	auipc	ra,0xffffc
    80004e9c:	59a080e7          	jalr	1434(ra) # 80001432 <uvmalloc>
    80004ea0:	dea43c23          	sd	a0,-520(s0)
    80004ea4:	d53d                	beqz	a0,80004e12 <exec+0x2f4>
    if(ph.vaddr % PGSIZE != 0)
    80004ea6:	e2043c03          	ld	s8,-480(s0)
    80004eaa:	de043783          	ld	a5,-544(s0)
    80004eae:	00fc77b3          	and	a5,s8,a5
    80004eb2:	ff9d                	bnez	a5,80004df0 <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004eb4:	e1842c83          	lw	s9,-488(s0)
    80004eb8:	e3042b83          	lw	s7,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004ebc:	f60b8ae3          	beqz	s7,80004e30 <exec+0x312>
    80004ec0:	89de                	mv	s3,s7
    80004ec2:	4481                	li	s1,0
    80004ec4:	b371                	j	80004c50 <exec+0x132>

0000000080004ec6 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004ec6:	7179                	addi	sp,sp,-48
    80004ec8:	f406                	sd	ra,40(sp)
    80004eca:	f022                	sd	s0,32(sp)
    80004ecc:	ec26                	sd	s1,24(sp)
    80004ece:	e84a                	sd	s2,16(sp)
    80004ed0:	1800                	addi	s0,sp,48
    80004ed2:	892e                	mv	s2,a1
    80004ed4:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004ed6:	fdc40593          	addi	a1,s0,-36
    80004eda:	ffffe097          	auipc	ra,0xffffe
    80004ede:	baa080e7          	jalr	-1110(ra) # 80002a84 <argint>
    80004ee2:	04054063          	bltz	a0,80004f22 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004ee6:	fdc42703          	lw	a4,-36(s0)
    80004eea:	47bd                	li	a5,15
    80004eec:	02e7ed63          	bltu	a5,a4,80004f26 <argfd+0x60>
    80004ef0:	ffffd097          	auipc	ra,0xffffd
    80004ef4:	afe080e7          	jalr	-1282(ra) # 800019ee <myproc>
    80004ef8:	fdc42703          	lw	a4,-36(s0)
    80004efc:	01a70793          	addi	a5,a4,26
    80004f00:	078e                	slli	a5,a5,0x3
    80004f02:	953e                	add	a0,a0,a5
    80004f04:	611c                	ld	a5,0(a0)
    80004f06:	c395                	beqz	a5,80004f2a <argfd+0x64>
    return -1;
  if(pfd)
    80004f08:	00090463          	beqz	s2,80004f10 <argfd+0x4a>
    *pfd = fd;
    80004f0c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004f10:	4501                	li	a0,0
  if(pf)
    80004f12:	c091                	beqz	s1,80004f16 <argfd+0x50>
    *pf = f;
    80004f14:	e09c                	sd	a5,0(s1)
}
    80004f16:	70a2                	ld	ra,40(sp)
    80004f18:	7402                	ld	s0,32(sp)
    80004f1a:	64e2                	ld	s1,24(sp)
    80004f1c:	6942                	ld	s2,16(sp)
    80004f1e:	6145                	addi	sp,sp,48
    80004f20:	8082                	ret
    return -1;
    80004f22:	557d                	li	a0,-1
    80004f24:	bfcd                	j	80004f16 <argfd+0x50>
    return -1;
    80004f26:	557d                	li	a0,-1
    80004f28:	b7fd                	j	80004f16 <argfd+0x50>
    80004f2a:	557d                	li	a0,-1
    80004f2c:	b7ed                	j	80004f16 <argfd+0x50>

0000000080004f2e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004f2e:	1101                	addi	sp,sp,-32
    80004f30:	ec06                	sd	ra,24(sp)
    80004f32:	e822                	sd	s0,16(sp)
    80004f34:	e426                	sd	s1,8(sp)
    80004f36:	1000                	addi	s0,sp,32
    80004f38:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004f3a:	ffffd097          	auipc	ra,0xffffd
    80004f3e:	ab4080e7          	jalr	-1356(ra) # 800019ee <myproc>
    80004f42:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004f44:	0d050793          	addi	a5,a0,208
    80004f48:	4501                	li	a0,0
    80004f4a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004f4c:	6398                	ld	a4,0(a5)
    80004f4e:	cb19                	beqz	a4,80004f64 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004f50:	2505                	addiw	a0,a0,1
    80004f52:	07a1                	addi	a5,a5,8
    80004f54:	fed51ce3          	bne	a0,a3,80004f4c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004f58:	557d                	li	a0,-1
}
    80004f5a:	60e2                	ld	ra,24(sp)
    80004f5c:	6442                	ld	s0,16(sp)
    80004f5e:	64a2                	ld	s1,8(sp)
    80004f60:	6105                	addi	sp,sp,32
    80004f62:	8082                	ret
      p->ofile[fd] = f;
    80004f64:	01a50793          	addi	a5,a0,26
    80004f68:	078e                	slli	a5,a5,0x3
    80004f6a:	963e                	add	a2,a2,a5
    80004f6c:	e204                	sd	s1,0(a2)
      return fd;
    80004f6e:	b7f5                	j	80004f5a <fdalloc+0x2c>

0000000080004f70 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004f70:	715d                	addi	sp,sp,-80
    80004f72:	e486                	sd	ra,72(sp)
    80004f74:	e0a2                	sd	s0,64(sp)
    80004f76:	fc26                	sd	s1,56(sp)
    80004f78:	f84a                	sd	s2,48(sp)
    80004f7a:	f44e                	sd	s3,40(sp)
    80004f7c:	f052                	sd	s4,32(sp)
    80004f7e:	ec56                	sd	s5,24(sp)
    80004f80:	0880                	addi	s0,sp,80
    80004f82:	89ae                	mv	s3,a1
    80004f84:	8ab2                	mv	s5,a2
    80004f86:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004f88:	fb040593          	addi	a1,s0,-80
    80004f8c:	fffff097          	auipc	ra,0xfffff
    80004f90:	e3a080e7          	jalr	-454(ra) # 80003dc6 <nameiparent>
    80004f94:	892a                	mv	s2,a0
    80004f96:	12050e63          	beqz	a0,800050d2 <create+0x162>
    return 0;

  ilock(dp);
    80004f9a:	ffffe097          	auipc	ra,0xffffe
    80004f9e:	65a080e7          	jalr	1626(ra) # 800035f4 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004fa2:	4601                	li	a2,0
    80004fa4:	fb040593          	addi	a1,s0,-80
    80004fa8:	854a                	mv	a0,s2
    80004faa:	fffff097          	auipc	ra,0xfffff
    80004fae:	b2c080e7          	jalr	-1236(ra) # 80003ad6 <dirlookup>
    80004fb2:	84aa                	mv	s1,a0
    80004fb4:	c921                	beqz	a0,80005004 <create+0x94>
    iunlockput(dp);
    80004fb6:	854a                	mv	a0,s2
    80004fb8:	fffff097          	auipc	ra,0xfffff
    80004fbc:	89e080e7          	jalr	-1890(ra) # 80003856 <iunlockput>
    ilock(ip);
    80004fc0:	8526                	mv	a0,s1
    80004fc2:	ffffe097          	auipc	ra,0xffffe
    80004fc6:	632080e7          	jalr	1586(ra) # 800035f4 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004fca:	2981                	sext.w	s3,s3
    80004fcc:	4789                	li	a5,2
    80004fce:	02f99463          	bne	s3,a5,80004ff6 <create+0x86>
    80004fd2:	0444d783          	lhu	a5,68(s1)
    80004fd6:	37f9                	addiw	a5,a5,-2
    80004fd8:	17c2                	slli	a5,a5,0x30
    80004fda:	93c1                	srli	a5,a5,0x30
    80004fdc:	4705                	li	a4,1
    80004fde:	00f76c63          	bltu	a4,a5,80004ff6 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004fe2:	8526                	mv	a0,s1
    80004fe4:	60a6                	ld	ra,72(sp)
    80004fe6:	6406                	ld	s0,64(sp)
    80004fe8:	74e2                	ld	s1,56(sp)
    80004fea:	7942                	ld	s2,48(sp)
    80004fec:	79a2                	ld	s3,40(sp)
    80004fee:	7a02                	ld	s4,32(sp)
    80004ff0:	6ae2                	ld	s5,24(sp)
    80004ff2:	6161                	addi	sp,sp,80
    80004ff4:	8082                	ret
    iunlockput(ip);
    80004ff6:	8526                	mv	a0,s1
    80004ff8:	fffff097          	auipc	ra,0xfffff
    80004ffc:	85e080e7          	jalr	-1954(ra) # 80003856 <iunlockput>
    return 0;
    80005000:	4481                	li	s1,0
    80005002:	b7c5                	j	80004fe2 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80005004:	85ce                	mv	a1,s3
    80005006:	00092503          	lw	a0,0(s2)
    8000500a:	ffffe097          	auipc	ra,0xffffe
    8000500e:	452080e7          	jalr	1106(ra) # 8000345c <ialloc>
    80005012:	84aa                	mv	s1,a0
    80005014:	c521                	beqz	a0,8000505c <create+0xec>
  ilock(ip);
    80005016:	ffffe097          	auipc	ra,0xffffe
    8000501a:	5de080e7          	jalr	1502(ra) # 800035f4 <ilock>
  ip->major = major;
    8000501e:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80005022:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80005026:	4a05                	li	s4,1
    80005028:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    8000502c:	8526                	mv	a0,s1
    8000502e:	ffffe097          	auipc	ra,0xffffe
    80005032:	4fc080e7          	jalr	1276(ra) # 8000352a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005036:	2981                	sext.w	s3,s3
    80005038:	03498a63          	beq	s3,s4,8000506c <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    8000503c:	40d0                	lw	a2,4(s1)
    8000503e:	fb040593          	addi	a1,s0,-80
    80005042:	854a                	mv	a0,s2
    80005044:	fffff097          	auipc	ra,0xfffff
    80005048:	ca2080e7          	jalr	-862(ra) # 80003ce6 <dirlink>
    8000504c:	06054b63          	bltz	a0,800050c2 <create+0x152>
  iunlockput(dp);
    80005050:	854a                	mv	a0,s2
    80005052:	fffff097          	auipc	ra,0xfffff
    80005056:	804080e7          	jalr	-2044(ra) # 80003856 <iunlockput>
  return ip;
    8000505a:	b761                	j	80004fe2 <create+0x72>
    panic("create: ialloc");
    8000505c:	00003517          	auipc	a0,0x3
    80005060:	67450513          	addi	a0,a0,1652 # 800086d0 <syscalls+0x2b0>
    80005064:	ffffb097          	auipc	ra,0xffffb
    80005068:	4e6080e7          	jalr	1254(ra) # 8000054a <panic>
    dp->nlink++;  // for ".."
    8000506c:	04a95783          	lhu	a5,74(s2)
    80005070:	2785                	addiw	a5,a5,1
    80005072:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80005076:	854a                	mv	a0,s2
    80005078:	ffffe097          	auipc	ra,0xffffe
    8000507c:	4b2080e7          	jalr	1202(ra) # 8000352a <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005080:	40d0                	lw	a2,4(s1)
    80005082:	00003597          	auipc	a1,0x3
    80005086:	65e58593          	addi	a1,a1,1630 # 800086e0 <syscalls+0x2c0>
    8000508a:	8526                	mv	a0,s1
    8000508c:	fffff097          	auipc	ra,0xfffff
    80005090:	c5a080e7          	jalr	-934(ra) # 80003ce6 <dirlink>
    80005094:	00054f63          	bltz	a0,800050b2 <create+0x142>
    80005098:	00492603          	lw	a2,4(s2)
    8000509c:	00003597          	auipc	a1,0x3
    800050a0:	64c58593          	addi	a1,a1,1612 # 800086e8 <syscalls+0x2c8>
    800050a4:	8526                	mv	a0,s1
    800050a6:	fffff097          	auipc	ra,0xfffff
    800050aa:	c40080e7          	jalr	-960(ra) # 80003ce6 <dirlink>
    800050ae:	f80557e3          	bgez	a0,8000503c <create+0xcc>
      panic("create dots");
    800050b2:	00003517          	auipc	a0,0x3
    800050b6:	63e50513          	addi	a0,a0,1598 # 800086f0 <syscalls+0x2d0>
    800050ba:	ffffb097          	auipc	ra,0xffffb
    800050be:	490080e7          	jalr	1168(ra) # 8000054a <panic>
    panic("create: dirlink");
    800050c2:	00003517          	auipc	a0,0x3
    800050c6:	63e50513          	addi	a0,a0,1598 # 80008700 <syscalls+0x2e0>
    800050ca:	ffffb097          	auipc	ra,0xffffb
    800050ce:	480080e7          	jalr	1152(ra) # 8000054a <panic>
    return 0;
    800050d2:	84aa                	mv	s1,a0
    800050d4:	b739                	j	80004fe2 <create+0x72>

00000000800050d6 <sys_dup>:
{
    800050d6:	7179                	addi	sp,sp,-48
    800050d8:	f406                	sd	ra,40(sp)
    800050da:	f022                	sd	s0,32(sp)
    800050dc:	ec26                	sd	s1,24(sp)
    800050de:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800050e0:	fd840613          	addi	a2,s0,-40
    800050e4:	4581                	li	a1,0
    800050e6:	4501                	li	a0,0
    800050e8:	00000097          	auipc	ra,0x0
    800050ec:	dde080e7          	jalr	-546(ra) # 80004ec6 <argfd>
    return -1;
    800050f0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800050f2:	02054363          	bltz	a0,80005118 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800050f6:	fd843503          	ld	a0,-40(s0)
    800050fa:	00000097          	auipc	ra,0x0
    800050fe:	e34080e7          	jalr	-460(ra) # 80004f2e <fdalloc>
    80005102:	84aa                	mv	s1,a0
    return -1;
    80005104:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005106:	00054963          	bltz	a0,80005118 <sys_dup+0x42>
  filedup(f);
    8000510a:	fd843503          	ld	a0,-40(s0)
    8000510e:	fffff097          	auipc	ra,0xfffff
    80005112:	338080e7          	jalr	824(ra) # 80004446 <filedup>
  return fd;
    80005116:	87a6                	mv	a5,s1
}
    80005118:	853e                	mv	a0,a5
    8000511a:	70a2                	ld	ra,40(sp)
    8000511c:	7402                	ld	s0,32(sp)
    8000511e:	64e2                	ld	s1,24(sp)
    80005120:	6145                	addi	sp,sp,48
    80005122:	8082                	ret

0000000080005124 <sys_read>:
{
    80005124:	7179                	addi	sp,sp,-48
    80005126:	f406                	sd	ra,40(sp)
    80005128:	f022                	sd	s0,32(sp)
    8000512a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000512c:	fe840613          	addi	a2,s0,-24
    80005130:	4581                	li	a1,0
    80005132:	4501                	li	a0,0
    80005134:	00000097          	auipc	ra,0x0
    80005138:	d92080e7          	jalr	-622(ra) # 80004ec6 <argfd>
    return -1;
    8000513c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000513e:	04054163          	bltz	a0,80005180 <sys_read+0x5c>
    80005142:	fe440593          	addi	a1,s0,-28
    80005146:	4509                	li	a0,2
    80005148:	ffffe097          	auipc	ra,0xffffe
    8000514c:	93c080e7          	jalr	-1732(ra) # 80002a84 <argint>
    return -1;
    80005150:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005152:	02054763          	bltz	a0,80005180 <sys_read+0x5c>
    80005156:	fd840593          	addi	a1,s0,-40
    8000515a:	4505                	li	a0,1
    8000515c:	ffffe097          	auipc	ra,0xffffe
    80005160:	94a080e7          	jalr	-1718(ra) # 80002aa6 <argaddr>
    return -1;
    80005164:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005166:	00054d63          	bltz	a0,80005180 <sys_read+0x5c>
  return fileread(f, p, n);
    8000516a:	fe442603          	lw	a2,-28(s0)
    8000516e:	fd843583          	ld	a1,-40(s0)
    80005172:	fe843503          	ld	a0,-24(s0)
    80005176:	fffff097          	auipc	ra,0xfffff
    8000517a:	45c080e7          	jalr	1116(ra) # 800045d2 <fileread>
    8000517e:	87aa                	mv	a5,a0
}
    80005180:	853e                	mv	a0,a5
    80005182:	70a2                	ld	ra,40(sp)
    80005184:	7402                	ld	s0,32(sp)
    80005186:	6145                	addi	sp,sp,48
    80005188:	8082                	ret

000000008000518a <sys_write>:
{
    8000518a:	7179                	addi	sp,sp,-48
    8000518c:	f406                	sd	ra,40(sp)
    8000518e:	f022                	sd	s0,32(sp)
    80005190:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005192:	fe840613          	addi	a2,s0,-24
    80005196:	4581                	li	a1,0
    80005198:	4501                	li	a0,0
    8000519a:	00000097          	auipc	ra,0x0
    8000519e:	d2c080e7          	jalr	-724(ra) # 80004ec6 <argfd>
    return -1;
    800051a2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800051a4:	04054163          	bltz	a0,800051e6 <sys_write+0x5c>
    800051a8:	fe440593          	addi	a1,s0,-28
    800051ac:	4509                	li	a0,2
    800051ae:	ffffe097          	auipc	ra,0xffffe
    800051b2:	8d6080e7          	jalr	-1834(ra) # 80002a84 <argint>
    return -1;
    800051b6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800051b8:	02054763          	bltz	a0,800051e6 <sys_write+0x5c>
    800051bc:	fd840593          	addi	a1,s0,-40
    800051c0:	4505                	li	a0,1
    800051c2:	ffffe097          	auipc	ra,0xffffe
    800051c6:	8e4080e7          	jalr	-1820(ra) # 80002aa6 <argaddr>
    return -1;
    800051ca:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800051cc:	00054d63          	bltz	a0,800051e6 <sys_write+0x5c>
  return filewrite(f, p, n);
    800051d0:	fe442603          	lw	a2,-28(s0)
    800051d4:	fd843583          	ld	a1,-40(s0)
    800051d8:	fe843503          	ld	a0,-24(s0)
    800051dc:	fffff097          	auipc	ra,0xfffff
    800051e0:	4b8080e7          	jalr	1208(ra) # 80004694 <filewrite>
    800051e4:	87aa                	mv	a5,a0
}
    800051e6:	853e                	mv	a0,a5
    800051e8:	70a2                	ld	ra,40(sp)
    800051ea:	7402                	ld	s0,32(sp)
    800051ec:	6145                	addi	sp,sp,48
    800051ee:	8082                	ret

00000000800051f0 <sys_close>:
{
    800051f0:	1101                	addi	sp,sp,-32
    800051f2:	ec06                	sd	ra,24(sp)
    800051f4:	e822                	sd	s0,16(sp)
    800051f6:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800051f8:	fe040613          	addi	a2,s0,-32
    800051fc:	fec40593          	addi	a1,s0,-20
    80005200:	4501                	li	a0,0
    80005202:	00000097          	auipc	ra,0x0
    80005206:	cc4080e7          	jalr	-828(ra) # 80004ec6 <argfd>
    return -1;
    8000520a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000520c:	02054463          	bltz	a0,80005234 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005210:	ffffc097          	auipc	ra,0xffffc
    80005214:	7de080e7          	jalr	2014(ra) # 800019ee <myproc>
    80005218:	fec42783          	lw	a5,-20(s0)
    8000521c:	07e9                	addi	a5,a5,26
    8000521e:	078e                	slli	a5,a5,0x3
    80005220:	97aa                	add	a5,a5,a0
    80005222:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80005226:	fe043503          	ld	a0,-32(s0)
    8000522a:	fffff097          	auipc	ra,0xfffff
    8000522e:	26e080e7          	jalr	622(ra) # 80004498 <fileclose>
  return 0;
    80005232:	4781                	li	a5,0
}
    80005234:	853e                	mv	a0,a5
    80005236:	60e2                	ld	ra,24(sp)
    80005238:	6442                	ld	s0,16(sp)
    8000523a:	6105                	addi	sp,sp,32
    8000523c:	8082                	ret

000000008000523e <sys_fstat>:
{
    8000523e:	1101                	addi	sp,sp,-32
    80005240:	ec06                	sd	ra,24(sp)
    80005242:	e822                	sd	s0,16(sp)
    80005244:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005246:	fe840613          	addi	a2,s0,-24
    8000524a:	4581                	li	a1,0
    8000524c:	4501                	li	a0,0
    8000524e:	00000097          	auipc	ra,0x0
    80005252:	c78080e7          	jalr	-904(ra) # 80004ec6 <argfd>
    return -1;
    80005256:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005258:	02054563          	bltz	a0,80005282 <sys_fstat+0x44>
    8000525c:	fe040593          	addi	a1,s0,-32
    80005260:	4505                	li	a0,1
    80005262:	ffffe097          	auipc	ra,0xffffe
    80005266:	844080e7          	jalr	-1980(ra) # 80002aa6 <argaddr>
    return -1;
    8000526a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000526c:	00054b63          	bltz	a0,80005282 <sys_fstat+0x44>
  return filestat(f, st);
    80005270:	fe043583          	ld	a1,-32(s0)
    80005274:	fe843503          	ld	a0,-24(s0)
    80005278:	fffff097          	auipc	ra,0xfffff
    8000527c:	2e8080e7          	jalr	744(ra) # 80004560 <filestat>
    80005280:	87aa                	mv	a5,a0
}
    80005282:	853e                	mv	a0,a5
    80005284:	60e2                	ld	ra,24(sp)
    80005286:	6442                	ld	s0,16(sp)
    80005288:	6105                	addi	sp,sp,32
    8000528a:	8082                	ret

000000008000528c <sys_link>:
{
    8000528c:	7169                	addi	sp,sp,-304
    8000528e:	f606                	sd	ra,296(sp)
    80005290:	f222                	sd	s0,288(sp)
    80005292:	ee26                	sd	s1,280(sp)
    80005294:	ea4a                	sd	s2,272(sp)
    80005296:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005298:	08000613          	li	a2,128
    8000529c:	ed040593          	addi	a1,s0,-304
    800052a0:	4501                	li	a0,0
    800052a2:	ffffe097          	auipc	ra,0xffffe
    800052a6:	826080e7          	jalr	-2010(ra) # 80002ac8 <argstr>
    return -1;
    800052aa:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800052ac:	10054e63          	bltz	a0,800053c8 <sys_link+0x13c>
    800052b0:	08000613          	li	a2,128
    800052b4:	f5040593          	addi	a1,s0,-176
    800052b8:	4505                	li	a0,1
    800052ba:	ffffe097          	auipc	ra,0xffffe
    800052be:	80e080e7          	jalr	-2034(ra) # 80002ac8 <argstr>
    return -1;
    800052c2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800052c4:	10054263          	bltz	a0,800053c8 <sys_link+0x13c>
  begin_op();
    800052c8:	fffff097          	auipc	ra,0xfffff
    800052cc:	cfc080e7          	jalr	-772(ra) # 80003fc4 <begin_op>
  if((ip = namei(old)) == 0){
    800052d0:	ed040513          	addi	a0,s0,-304
    800052d4:	fffff097          	auipc	ra,0xfffff
    800052d8:	ad4080e7          	jalr	-1324(ra) # 80003da8 <namei>
    800052dc:	84aa                	mv	s1,a0
    800052de:	c551                	beqz	a0,8000536a <sys_link+0xde>
  ilock(ip);
    800052e0:	ffffe097          	auipc	ra,0xffffe
    800052e4:	314080e7          	jalr	788(ra) # 800035f4 <ilock>
  if(ip->type == T_DIR){
    800052e8:	04449703          	lh	a4,68(s1)
    800052ec:	4785                	li	a5,1
    800052ee:	08f70463          	beq	a4,a5,80005376 <sys_link+0xea>
  ip->nlink++;
    800052f2:	04a4d783          	lhu	a5,74(s1)
    800052f6:	2785                	addiw	a5,a5,1
    800052f8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800052fc:	8526                	mv	a0,s1
    800052fe:	ffffe097          	auipc	ra,0xffffe
    80005302:	22c080e7          	jalr	556(ra) # 8000352a <iupdate>
  iunlock(ip);
    80005306:	8526                	mv	a0,s1
    80005308:	ffffe097          	auipc	ra,0xffffe
    8000530c:	3ae080e7          	jalr	942(ra) # 800036b6 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005310:	fd040593          	addi	a1,s0,-48
    80005314:	f5040513          	addi	a0,s0,-176
    80005318:	fffff097          	auipc	ra,0xfffff
    8000531c:	aae080e7          	jalr	-1362(ra) # 80003dc6 <nameiparent>
    80005320:	892a                	mv	s2,a0
    80005322:	c935                	beqz	a0,80005396 <sys_link+0x10a>
  ilock(dp);
    80005324:	ffffe097          	auipc	ra,0xffffe
    80005328:	2d0080e7          	jalr	720(ra) # 800035f4 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000532c:	00092703          	lw	a4,0(s2)
    80005330:	409c                	lw	a5,0(s1)
    80005332:	04f71d63          	bne	a4,a5,8000538c <sys_link+0x100>
    80005336:	40d0                	lw	a2,4(s1)
    80005338:	fd040593          	addi	a1,s0,-48
    8000533c:	854a                	mv	a0,s2
    8000533e:	fffff097          	auipc	ra,0xfffff
    80005342:	9a8080e7          	jalr	-1624(ra) # 80003ce6 <dirlink>
    80005346:	04054363          	bltz	a0,8000538c <sys_link+0x100>
  iunlockput(dp);
    8000534a:	854a                	mv	a0,s2
    8000534c:	ffffe097          	auipc	ra,0xffffe
    80005350:	50a080e7          	jalr	1290(ra) # 80003856 <iunlockput>
  iput(ip);
    80005354:	8526                	mv	a0,s1
    80005356:	ffffe097          	auipc	ra,0xffffe
    8000535a:	458080e7          	jalr	1112(ra) # 800037ae <iput>
  end_op();
    8000535e:	fffff097          	auipc	ra,0xfffff
    80005362:	ce6080e7          	jalr	-794(ra) # 80004044 <end_op>
  return 0;
    80005366:	4781                	li	a5,0
    80005368:	a085                	j	800053c8 <sys_link+0x13c>
    end_op();
    8000536a:	fffff097          	auipc	ra,0xfffff
    8000536e:	cda080e7          	jalr	-806(ra) # 80004044 <end_op>
    return -1;
    80005372:	57fd                	li	a5,-1
    80005374:	a891                	j	800053c8 <sys_link+0x13c>
    iunlockput(ip);
    80005376:	8526                	mv	a0,s1
    80005378:	ffffe097          	auipc	ra,0xffffe
    8000537c:	4de080e7          	jalr	1246(ra) # 80003856 <iunlockput>
    end_op();
    80005380:	fffff097          	auipc	ra,0xfffff
    80005384:	cc4080e7          	jalr	-828(ra) # 80004044 <end_op>
    return -1;
    80005388:	57fd                	li	a5,-1
    8000538a:	a83d                	j	800053c8 <sys_link+0x13c>
    iunlockput(dp);
    8000538c:	854a                	mv	a0,s2
    8000538e:	ffffe097          	auipc	ra,0xffffe
    80005392:	4c8080e7          	jalr	1224(ra) # 80003856 <iunlockput>
  ilock(ip);
    80005396:	8526                	mv	a0,s1
    80005398:	ffffe097          	auipc	ra,0xffffe
    8000539c:	25c080e7          	jalr	604(ra) # 800035f4 <ilock>
  ip->nlink--;
    800053a0:	04a4d783          	lhu	a5,74(s1)
    800053a4:	37fd                	addiw	a5,a5,-1
    800053a6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800053aa:	8526                	mv	a0,s1
    800053ac:	ffffe097          	auipc	ra,0xffffe
    800053b0:	17e080e7          	jalr	382(ra) # 8000352a <iupdate>
  iunlockput(ip);
    800053b4:	8526                	mv	a0,s1
    800053b6:	ffffe097          	auipc	ra,0xffffe
    800053ba:	4a0080e7          	jalr	1184(ra) # 80003856 <iunlockput>
  end_op();
    800053be:	fffff097          	auipc	ra,0xfffff
    800053c2:	c86080e7          	jalr	-890(ra) # 80004044 <end_op>
  return -1;
    800053c6:	57fd                	li	a5,-1
}
    800053c8:	853e                	mv	a0,a5
    800053ca:	70b2                	ld	ra,296(sp)
    800053cc:	7412                	ld	s0,288(sp)
    800053ce:	64f2                	ld	s1,280(sp)
    800053d0:	6952                	ld	s2,272(sp)
    800053d2:	6155                	addi	sp,sp,304
    800053d4:	8082                	ret

00000000800053d6 <sys_unlink>:
{
    800053d6:	7151                	addi	sp,sp,-240
    800053d8:	f586                	sd	ra,232(sp)
    800053da:	f1a2                	sd	s0,224(sp)
    800053dc:	eda6                	sd	s1,216(sp)
    800053de:	e9ca                	sd	s2,208(sp)
    800053e0:	e5ce                	sd	s3,200(sp)
    800053e2:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800053e4:	08000613          	li	a2,128
    800053e8:	f3040593          	addi	a1,s0,-208
    800053ec:	4501                	li	a0,0
    800053ee:	ffffd097          	auipc	ra,0xffffd
    800053f2:	6da080e7          	jalr	1754(ra) # 80002ac8 <argstr>
    800053f6:	18054163          	bltz	a0,80005578 <sys_unlink+0x1a2>
  begin_op();
    800053fa:	fffff097          	auipc	ra,0xfffff
    800053fe:	bca080e7          	jalr	-1078(ra) # 80003fc4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005402:	fb040593          	addi	a1,s0,-80
    80005406:	f3040513          	addi	a0,s0,-208
    8000540a:	fffff097          	auipc	ra,0xfffff
    8000540e:	9bc080e7          	jalr	-1604(ra) # 80003dc6 <nameiparent>
    80005412:	84aa                	mv	s1,a0
    80005414:	c979                	beqz	a0,800054ea <sys_unlink+0x114>
  ilock(dp);
    80005416:	ffffe097          	auipc	ra,0xffffe
    8000541a:	1de080e7          	jalr	478(ra) # 800035f4 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000541e:	00003597          	auipc	a1,0x3
    80005422:	2c258593          	addi	a1,a1,706 # 800086e0 <syscalls+0x2c0>
    80005426:	fb040513          	addi	a0,s0,-80
    8000542a:	ffffe097          	auipc	ra,0xffffe
    8000542e:	692080e7          	jalr	1682(ra) # 80003abc <namecmp>
    80005432:	14050a63          	beqz	a0,80005586 <sys_unlink+0x1b0>
    80005436:	00003597          	auipc	a1,0x3
    8000543a:	2b258593          	addi	a1,a1,690 # 800086e8 <syscalls+0x2c8>
    8000543e:	fb040513          	addi	a0,s0,-80
    80005442:	ffffe097          	auipc	ra,0xffffe
    80005446:	67a080e7          	jalr	1658(ra) # 80003abc <namecmp>
    8000544a:	12050e63          	beqz	a0,80005586 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000544e:	f2c40613          	addi	a2,s0,-212
    80005452:	fb040593          	addi	a1,s0,-80
    80005456:	8526                	mv	a0,s1
    80005458:	ffffe097          	auipc	ra,0xffffe
    8000545c:	67e080e7          	jalr	1662(ra) # 80003ad6 <dirlookup>
    80005460:	892a                	mv	s2,a0
    80005462:	12050263          	beqz	a0,80005586 <sys_unlink+0x1b0>
  ilock(ip);
    80005466:	ffffe097          	auipc	ra,0xffffe
    8000546a:	18e080e7          	jalr	398(ra) # 800035f4 <ilock>
  if(ip->nlink < 1)
    8000546e:	04a91783          	lh	a5,74(s2)
    80005472:	08f05263          	blez	a5,800054f6 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005476:	04491703          	lh	a4,68(s2)
    8000547a:	4785                	li	a5,1
    8000547c:	08f70563          	beq	a4,a5,80005506 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005480:	4641                	li	a2,16
    80005482:	4581                	li	a1,0
    80005484:	fc040513          	addi	a0,s0,-64
    80005488:	ffffc097          	auipc	ra,0xffffc
    8000548c:	87a080e7          	jalr	-1926(ra) # 80000d02 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005490:	4741                	li	a4,16
    80005492:	f2c42683          	lw	a3,-212(s0)
    80005496:	fc040613          	addi	a2,s0,-64
    8000549a:	4581                	li	a1,0
    8000549c:	8526                	mv	a0,s1
    8000549e:	ffffe097          	auipc	ra,0xffffe
    800054a2:	502080e7          	jalr	1282(ra) # 800039a0 <writei>
    800054a6:	47c1                	li	a5,16
    800054a8:	0af51563          	bne	a0,a5,80005552 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800054ac:	04491703          	lh	a4,68(s2)
    800054b0:	4785                	li	a5,1
    800054b2:	0af70863          	beq	a4,a5,80005562 <sys_unlink+0x18c>
  iunlockput(dp);
    800054b6:	8526                	mv	a0,s1
    800054b8:	ffffe097          	auipc	ra,0xffffe
    800054bc:	39e080e7          	jalr	926(ra) # 80003856 <iunlockput>
  ip->nlink--;
    800054c0:	04a95783          	lhu	a5,74(s2)
    800054c4:	37fd                	addiw	a5,a5,-1
    800054c6:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800054ca:	854a                	mv	a0,s2
    800054cc:	ffffe097          	auipc	ra,0xffffe
    800054d0:	05e080e7          	jalr	94(ra) # 8000352a <iupdate>
  iunlockput(ip);
    800054d4:	854a                	mv	a0,s2
    800054d6:	ffffe097          	auipc	ra,0xffffe
    800054da:	380080e7          	jalr	896(ra) # 80003856 <iunlockput>
  end_op();
    800054de:	fffff097          	auipc	ra,0xfffff
    800054e2:	b66080e7          	jalr	-1178(ra) # 80004044 <end_op>
  return 0;
    800054e6:	4501                	li	a0,0
    800054e8:	a84d                	j	8000559a <sys_unlink+0x1c4>
    end_op();
    800054ea:	fffff097          	auipc	ra,0xfffff
    800054ee:	b5a080e7          	jalr	-1190(ra) # 80004044 <end_op>
    return -1;
    800054f2:	557d                	li	a0,-1
    800054f4:	a05d                	j	8000559a <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800054f6:	00003517          	auipc	a0,0x3
    800054fa:	21a50513          	addi	a0,a0,538 # 80008710 <syscalls+0x2f0>
    800054fe:	ffffb097          	auipc	ra,0xffffb
    80005502:	04c080e7          	jalr	76(ra) # 8000054a <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005506:	04c92703          	lw	a4,76(s2)
    8000550a:	02000793          	li	a5,32
    8000550e:	f6e7f9e3          	bgeu	a5,a4,80005480 <sys_unlink+0xaa>
    80005512:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005516:	4741                	li	a4,16
    80005518:	86ce                	mv	a3,s3
    8000551a:	f1840613          	addi	a2,s0,-232
    8000551e:	4581                	li	a1,0
    80005520:	854a                	mv	a0,s2
    80005522:	ffffe097          	auipc	ra,0xffffe
    80005526:	386080e7          	jalr	902(ra) # 800038a8 <readi>
    8000552a:	47c1                	li	a5,16
    8000552c:	00f51b63          	bne	a0,a5,80005542 <sys_unlink+0x16c>
    if(de.inum != 0)
    80005530:	f1845783          	lhu	a5,-232(s0)
    80005534:	e7a1                	bnez	a5,8000557c <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005536:	29c1                	addiw	s3,s3,16
    80005538:	04c92783          	lw	a5,76(s2)
    8000553c:	fcf9ede3          	bltu	s3,a5,80005516 <sys_unlink+0x140>
    80005540:	b781                	j	80005480 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005542:	00003517          	auipc	a0,0x3
    80005546:	1e650513          	addi	a0,a0,486 # 80008728 <syscalls+0x308>
    8000554a:	ffffb097          	auipc	ra,0xffffb
    8000554e:	000080e7          	jalr	ra # 8000054a <panic>
    panic("unlink: writei");
    80005552:	00003517          	auipc	a0,0x3
    80005556:	1ee50513          	addi	a0,a0,494 # 80008740 <syscalls+0x320>
    8000555a:	ffffb097          	auipc	ra,0xffffb
    8000555e:	ff0080e7          	jalr	-16(ra) # 8000054a <panic>
    dp->nlink--;
    80005562:	04a4d783          	lhu	a5,74(s1)
    80005566:	37fd                	addiw	a5,a5,-1
    80005568:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000556c:	8526                	mv	a0,s1
    8000556e:	ffffe097          	auipc	ra,0xffffe
    80005572:	fbc080e7          	jalr	-68(ra) # 8000352a <iupdate>
    80005576:	b781                	j	800054b6 <sys_unlink+0xe0>
    return -1;
    80005578:	557d                	li	a0,-1
    8000557a:	a005                	j	8000559a <sys_unlink+0x1c4>
    iunlockput(ip);
    8000557c:	854a                	mv	a0,s2
    8000557e:	ffffe097          	auipc	ra,0xffffe
    80005582:	2d8080e7          	jalr	728(ra) # 80003856 <iunlockput>
  iunlockput(dp);
    80005586:	8526                	mv	a0,s1
    80005588:	ffffe097          	auipc	ra,0xffffe
    8000558c:	2ce080e7          	jalr	718(ra) # 80003856 <iunlockput>
  end_op();
    80005590:	fffff097          	auipc	ra,0xfffff
    80005594:	ab4080e7          	jalr	-1356(ra) # 80004044 <end_op>
  return -1;
    80005598:	557d                	li	a0,-1
}
    8000559a:	70ae                	ld	ra,232(sp)
    8000559c:	740e                	ld	s0,224(sp)
    8000559e:	64ee                	ld	s1,216(sp)
    800055a0:	694e                	ld	s2,208(sp)
    800055a2:	69ae                	ld	s3,200(sp)
    800055a4:	616d                	addi	sp,sp,240
    800055a6:	8082                	ret

00000000800055a8 <sys_open>:

uint64
sys_open(void)
{
    800055a8:	7131                	addi	sp,sp,-192
    800055aa:	fd06                	sd	ra,184(sp)
    800055ac:	f922                	sd	s0,176(sp)
    800055ae:	f526                	sd	s1,168(sp)
    800055b0:	f14a                	sd	s2,160(sp)
    800055b2:	ed4e                	sd	s3,152(sp)
    800055b4:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800055b6:	08000613          	li	a2,128
    800055ba:	f5040593          	addi	a1,s0,-176
    800055be:	4501                	li	a0,0
    800055c0:	ffffd097          	auipc	ra,0xffffd
    800055c4:	508080e7          	jalr	1288(ra) # 80002ac8 <argstr>
    return -1;
    800055c8:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800055ca:	0c054163          	bltz	a0,8000568c <sys_open+0xe4>
    800055ce:	f4c40593          	addi	a1,s0,-180
    800055d2:	4505                	li	a0,1
    800055d4:	ffffd097          	auipc	ra,0xffffd
    800055d8:	4b0080e7          	jalr	1200(ra) # 80002a84 <argint>
    800055dc:	0a054863          	bltz	a0,8000568c <sys_open+0xe4>

  begin_op();
    800055e0:	fffff097          	auipc	ra,0xfffff
    800055e4:	9e4080e7          	jalr	-1564(ra) # 80003fc4 <begin_op>

  if(omode & O_CREATE){
    800055e8:	f4c42783          	lw	a5,-180(s0)
    800055ec:	2007f793          	andi	a5,a5,512
    800055f0:	cbdd                	beqz	a5,800056a6 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    800055f2:	4681                	li	a3,0
    800055f4:	4601                	li	a2,0
    800055f6:	4589                	li	a1,2
    800055f8:	f5040513          	addi	a0,s0,-176
    800055fc:	00000097          	auipc	ra,0x0
    80005600:	974080e7          	jalr	-1676(ra) # 80004f70 <create>
    80005604:	892a                	mv	s2,a0
    if(ip == 0){
    80005606:	c959                	beqz	a0,8000569c <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005608:	04491703          	lh	a4,68(s2)
    8000560c:	478d                	li	a5,3
    8000560e:	00f71763          	bne	a4,a5,8000561c <sys_open+0x74>
    80005612:	04695703          	lhu	a4,70(s2)
    80005616:	47a5                	li	a5,9
    80005618:	0ce7ec63          	bltu	a5,a4,800056f0 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000561c:	fffff097          	auipc	ra,0xfffff
    80005620:	dc0080e7          	jalr	-576(ra) # 800043dc <filealloc>
    80005624:	89aa                	mv	s3,a0
    80005626:	10050263          	beqz	a0,8000572a <sys_open+0x182>
    8000562a:	00000097          	auipc	ra,0x0
    8000562e:	904080e7          	jalr	-1788(ra) # 80004f2e <fdalloc>
    80005632:	84aa                	mv	s1,a0
    80005634:	0e054663          	bltz	a0,80005720 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005638:	04491703          	lh	a4,68(s2)
    8000563c:	478d                	li	a5,3
    8000563e:	0cf70463          	beq	a4,a5,80005706 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005642:	4789                	li	a5,2
    80005644:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005648:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    8000564c:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005650:	f4c42783          	lw	a5,-180(s0)
    80005654:	0017c713          	xori	a4,a5,1
    80005658:	8b05                	andi	a4,a4,1
    8000565a:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000565e:	0037f713          	andi	a4,a5,3
    80005662:	00e03733          	snez	a4,a4
    80005666:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000566a:	4007f793          	andi	a5,a5,1024
    8000566e:	c791                	beqz	a5,8000567a <sys_open+0xd2>
    80005670:	04491703          	lh	a4,68(s2)
    80005674:	4789                	li	a5,2
    80005676:	08f70f63          	beq	a4,a5,80005714 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    8000567a:	854a                	mv	a0,s2
    8000567c:	ffffe097          	auipc	ra,0xffffe
    80005680:	03a080e7          	jalr	58(ra) # 800036b6 <iunlock>
  end_op();
    80005684:	fffff097          	auipc	ra,0xfffff
    80005688:	9c0080e7          	jalr	-1600(ra) # 80004044 <end_op>

  return fd;
}
    8000568c:	8526                	mv	a0,s1
    8000568e:	70ea                	ld	ra,184(sp)
    80005690:	744a                	ld	s0,176(sp)
    80005692:	74aa                	ld	s1,168(sp)
    80005694:	790a                	ld	s2,160(sp)
    80005696:	69ea                	ld	s3,152(sp)
    80005698:	6129                	addi	sp,sp,192
    8000569a:	8082                	ret
      end_op();
    8000569c:	fffff097          	auipc	ra,0xfffff
    800056a0:	9a8080e7          	jalr	-1624(ra) # 80004044 <end_op>
      return -1;
    800056a4:	b7e5                	j	8000568c <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    800056a6:	f5040513          	addi	a0,s0,-176
    800056aa:	ffffe097          	auipc	ra,0xffffe
    800056ae:	6fe080e7          	jalr	1790(ra) # 80003da8 <namei>
    800056b2:	892a                	mv	s2,a0
    800056b4:	c905                	beqz	a0,800056e4 <sys_open+0x13c>
    ilock(ip);
    800056b6:	ffffe097          	auipc	ra,0xffffe
    800056ba:	f3e080e7          	jalr	-194(ra) # 800035f4 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800056be:	04491703          	lh	a4,68(s2)
    800056c2:	4785                	li	a5,1
    800056c4:	f4f712e3          	bne	a4,a5,80005608 <sys_open+0x60>
    800056c8:	f4c42783          	lw	a5,-180(s0)
    800056cc:	dba1                	beqz	a5,8000561c <sys_open+0x74>
      iunlockput(ip);
    800056ce:	854a                	mv	a0,s2
    800056d0:	ffffe097          	auipc	ra,0xffffe
    800056d4:	186080e7          	jalr	390(ra) # 80003856 <iunlockput>
      end_op();
    800056d8:	fffff097          	auipc	ra,0xfffff
    800056dc:	96c080e7          	jalr	-1684(ra) # 80004044 <end_op>
      return -1;
    800056e0:	54fd                	li	s1,-1
    800056e2:	b76d                	j	8000568c <sys_open+0xe4>
      end_op();
    800056e4:	fffff097          	auipc	ra,0xfffff
    800056e8:	960080e7          	jalr	-1696(ra) # 80004044 <end_op>
      return -1;
    800056ec:	54fd                	li	s1,-1
    800056ee:	bf79                	j	8000568c <sys_open+0xe4>
    iunlockput(ip);
    800056f0:	854a                	mv	a0,s2
    800056f2:	ffffe097          	auipc	ra,0xffffe
    800056f6:	164080e7          	jalr	356(ra) # 80003856 <iunlockput>
    end_op();
    800056fa:	fffff097          	auipc	ra,0xfffff
    800056fe:	94a080e7          	jalr	-1718(ra) # 80004044 <end_op>
    return -1;
    80005702:	54fd                	li	s1,-1
    80005704:	b761                	j	8000568c <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005706:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    8000570a:	04691783          	lh	a5,70(s2)
    8000570e:	02f99223          	sh	a5,36(s3)
    80005712:	bf2d                	j	8000564c <sys_open+0xa4>
    itrunc(ip);
    80005714:	854a                	mv	a0,s2
    80005716:	ffffe097          	auipc	ra,0xffffe
    8000571a:	fec080e7          	jalr	-20(ra) # 80003702 <itrunc>
    8000571e:	bfb1                	j	8000567a <sys_open+0xd2>
      fileclose(f);
    80005720:	854e                	mv	a0,s3
    80005722:	fffff097          	auipc	ra,0xfffff
    80005726:	d76080e7          	jalr	-650(ra) # 80004498 <fileclose>
    iunlockput(ip);
    8000572a:	854a                	mv	a0,s2
    8000572c:	ffffe097          	auipc	ra,0xffffe
    80005730:	12a080e7          	jalr	298(ra) # 80003856 <iunlockput>
    end_op();
    80005734:	fffff097          	auipc	ra,0xfffff
    80005738:	910080e7          	jalr	-1776(ra) # 80004044 <end_op>
    return -1;
    8000573c:	54fd                	li	s1,-1
    8000573e:	b7b9                	j	8000568c <sys_open+0xe4>

0000000080005740 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005740:	7175                	addi	sp,sp,-144
    80005742:	e506                	sd	ra,136(sp)
    80005744:	e122                	sd	s0,128(sp)
    80005746:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005748:	fffff097          	auipc	ra,0xfffff
    8000574c:	87c080e7          	jalr	-1924(ra) # 80003fc4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005750:	08000613          	li	a2,128
    80005754:	f7040593          	addi	a1,s0,-144
    80005758:	4501                	li	a0,0
    8000575a:	ffffd097          	auipc	ra,0xffffd
    8000575e:	36e080e7          	jalr	878(ra) # 80002ac8 <argstr>
    80005762:	02054963          	bltz	a0,80005794 <sys_mkdir+0x54>
    80005766:	4681                	li	a3,0
    80005768:	4601                	li	a2,0
    8000576a:	4585                	li	a1,1
    8000576c:	f7040513          	addi	a0,s0,-144
    80005770:	00000097          	auipc	ra,0x0
    80005774:	800080e7          	jalr	-2048(ra) # 80004f70 <create>
    80005778:	cd11                	beqz	a0,80005794 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000577a:	ffffe097          	auipc	ra,0xffffe
    8000577e:	0dc080e7          	jalr	220(ra) # 80003856 <iunlockput>
  end_op();
    80005782:	fffff097          	auipc	ra,0xfffff
    80005786:	8c2080e7          	jalr	-1854(ra) # 80004044 <end_op>
  return 0;
    8000578a:	4501                	li	a0,0
}
    8000578c:	60aa                	ld	ra,136(sp)
    8000578e:	640a                	ld	s0,128(sp)
    80005790:	6149                	addi	sp,sp,144
    80005792:	8082                	ret
    end_op();
    80005794:	fffff097          	auipc	ra,0xfffff
    80005798:	8b0080e7          	jalr	-1872(ra) # 80004044 <end_op>
    return -1;
    8000579c:	557d                	li	a0,-1
    8000579e:	b7fd                	j	8000578c <sys_mkdir+0x4c>

00000000800057a0 <sys_mknod>:

uint64
sys_mknod(void)
{
    800057a0:	7135                	addi	sp,sp,-160
    800057a2:	ed06                	sd	ra,152(sp)
    800057a4:	e922                	sd	s0,144(sp)
    800057a6:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800057a8:	fffff097          	auipc	ra,0xfffff
    800057ac:	81c080e7          	jalr	-2020(ra) # 80003fc4 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800057b0:	08000613          	li	a2,128
    800057b4:	f7040593          	addi	a1,s0,-144
    800057b8:	4501                	li	a0,0
    800057ba:	ffffd097          	auipc	ra,0xffffd
    800057be:	30e080e7          	jalr	782(ra) # 80002ac8 <argstr>
    800057c2:	04054a63          	bltz	a0,80005816 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    800057c6:	f6c40593          	addi	a1,s0,-148
    800057ca:	4505                	li	a0,1
    800057cc:	ffffd097          	auipc	ra,0xffffd
    800057d0:	2b8080e7          	jalr	696(ra) # 80002a84 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800057d4:	04054163          	bltz	a0,80005816 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    800057d8:	f6840593          	addi	a1,s0,-152
    800057dc:	4509                	li	a0,2
    800057de:	ffffd097          	auipc	ra,0xffffd
    800057e2:	2a6080e7          	jalr	678(ra) # 80002a84 <argint>
     argint(1, &major) < 0 ||
    800057e6:	02054863          	bltz	a0,80005816 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800057ea:	f6841683          	lh	a3,-152(s0)
    800057ee:	f6c41603          	lh	a2,-148(s0)
    800057f2:	458d                	li	a1,3
    800057f4:	f7040513          	addi	a0,s0,-144
    800057f8:	fffff097          	auipc	ra,0xfffff
    800057fc:	778080e7          	jalr	1912(ra) # 80004f70 <create>
     argint(2, &minor) < 0 ||
    80005800:	c919                	beqz	a0,80005816 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005802:	ffffe097          	auipc	ra,0xffffe
    80005806:	054080e7          	jalr	84(ra) # 80003856 <iunlockput>
  end_op();
    8000580a:	fffff097          	auipc	ra,0xfffff
    8000580e:	83a080e7          	jalr	-1990(ra) # 80004044 <end_op>
  return 0;
    80005812:	4501                	li	a0,0
    80005814:	a031                	j	80005820 <sys_mknod+0x80>
    end_op();
    80005816:	fffff097          	auipc	ra,0xfffff
    8000581a:	82e080e7          	jalr	-2002(ra) # 80004044 <end_op>
    return -1;
    8000581e:	557d                	li	a0,-1
}
    80005820:	60ea                	ld	ra,152(sp)
    80005822:	644a                	ld	s0,144(sp)
    80005824:	610d                	addi	sp,sp,160
    80005826:	8082                	ret

0000000080005828 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005828:	7135                	addi	sp,sp,-160
    8000582a:	ed06                	sd	ra,152(sp)
    8000582c:	e922                	sd	s0,144(sp)
    8000582e:	e526                	sd	s1,136(sp)
    80005830:	e14a                	sd	s2,128(sp)
    80005832:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005834:	ffffc097          	auipc	ra,0xffffc
    80005838:	1ba080e7          	jalr	442(ra) # 800019ee <myproc>
    8000583c:	892a                	mv	s2,a0
  
  begin_op();
    8000583e:	ffffe097          	auipc	ra,0xffffe
    80005842:	786080e7          	jalr	1926(ra) # 80003fc4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005846:	08000613          	li	a2,128
    8000584a:	f6040593          	addi	a1,s0,-160
    8000584e:	4501                	li	a0,0
    80005850:	ffffd097          	auipc	ra,0xffffd
    80005854:	278080e7          	jalr	632(ra) # 80002ac8 <argstr>
    80005858:	04054b63          	bltz	a0,800058ae <sys_chdir+0x86>
    8000585c:	f6040513          	addi	a0,s0,-160
    80005860:	ffffe097          	auipc	ra,0xffffe
    80005864:	548080e7          	jalr	1352(ra) # 80003da8 <namei>
    80005868:	84aa                	mv	s1,a0
    8000586a:	c131                	beqz	a0,800058ae <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    8000586c:	ffffe097          	auipc	ra,0xffffe
    80005870:	d88080e7          	jalr	-632(ra) # 800035f4 <ilock>
  if(ip->type != T_DIR){
    80005874:	04449703          	lh	a4,68(s1)
    80005878:	4785                	li	a5,1
    8000587a:	04f71063          	bne	a4,a5,800058ba <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000587e:	8526                	mv	a0,s1
    80005880:	ffffe097          	auipc	ra,0xffffe
    80005884:	e36080e7          	jalr	-458(ra) # 800036b6 <iunlock>
  iput(p->cwd);
    80005888:	15093503          	ld	a0,336(s2)
    8000588c:	ffffe097          	auipc	ra,0xffffe
    80005890:	f22080e7          	jalr	-222(ra) # 800037ae <iput>
  end_op();
    80005894:	ffffe097          	auipc	ra,0xffffe
    80005898:	7b0080e7          	jalr	1968(ra) # 80004044 <end_op>
  p->cwd = ip;
    8000589c:	14993823          	sd	s1,336(s2)
  return 0;
    800058a0:	4501                	li	a0,0
}
    800058a2:	60ea                	ld	ra,152(sp)
    800058a4:	644a                	ld	s0,144(sp)
    800058a6:	64aa                	ld	s1,136(sp)
    800058a8:	690a                	ld	s2,128(sp)
    800058aa:	610d                	addi	sp,sp,160
    800058ac:	8082                	ret
    end_op();
    800058ae:	ffffe097          	auipc	ra,0xffffe
    800058b2:	796080e7          	jalr	1942(ra) # 80004044 <end_op>
    return -1;
    800058b6:	557d                	li	a0,-1
    800058b8:	b7ed                	j	800058a2 <sys_chdir+0x7a>
    iunlockput(ip);
    800058ba:	8526                	mv	a0,s1
    800058bc:	ffffe097          	auipc	ra,0xffffe
    800058c0:	f9a080e7          	jalr	-102(ra) # 80003856 <iunlockput>
    end_op();
    800058c4:	ffffe097          	auipc	ra,0xffffe
    800058c8:	780080e7          	jalr	1920(ra) # 80004044 <end_op>
    return -1;
    800058cc:	557d                	li	a0,-1
    800058ce:	bfd1                	j	800058a2 <sys_chdir+0x7a>

00000000800058d0 <sys_exec>:

uint64
sys_exec(void)
{
    800058d0:	7145                	addi	sp,sp,-464
    800058d2:	e786                	sd	ra,456(sp)
    800058d4:	e3a2                	sd	s0,448(sp)
    800058d6:	ff26                	sd	s1,440(sp)
    800058d8:	fb4a                	sd	s2,432(sp)
    800058da:	f74e                	sd	s3,424(sp)
    800058dc:	f352                	sd	s4,416(sp)
    800058de:	ef56                	sd	s5,408(sp)
    800058e0:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800058e2:	08000613          	li	a2,128
    800058e6:	f4040593          	addi	a1,s0,-192
    800058ea:	4501                	li	a0,0
    800058ec:	ffffd097          	auipc	ra,0xffffd
    800058f0:	1dc080e7          	jalr	476(ra) # 80002ac8 <argstr>
    return -1;
    800058f4:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800058f6:	0c054a63          	bltz	a0,800059ca <sys_exec+0xfa>
    800058fa:	e3840593          	addi	a1,s0,-456
    800058fe:	4505                	li	a0,1
    80005900:	ffffd097          	auipc	ra,0xffffd
    80005904:	1a6080e7          	jalr	422(ra) # 80002aa6 <argaddr>
    80005908:	0c054163          	bltz	a0,800059ca <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    8000590c:	10000613          	li	a2,256
    80005910:	4581                	li	a1,0
    80005912:	e4040513          	addi	a0,s0,-448
    80005916:	ffffb097          	auipc	ra,0xffffb
    8000591a:	3ec080e7          	jalr	1004(ra) # 80000d02 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000591e:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005922:	89a6                	mv	s3,s1
    80005924:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005926:	02000a13          	li	s4,32
    8000592a:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000592e:	00391793          	slli	a5,s2,0x3
    80005932:	e3040593          	addi	a1,s0,-464
    80005936:	e3843503          	ld	a0,-456(s0)
    8000593a:	953e                	add	a0,a0,a5
    8000593c:	ffffd097          	auipc	ra,0xffffd
    80005940:	0ae080e7          	jalr	174(ra) # 800029ea <fetchaddr>
    80005944:	02054a63          	bltz	a0,80005978 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005948:	e3043783          	ld	a5,-464(s0)
    8000594c:	c3b9                	beqz	a5,80005992 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000594e:	ffffb097          	auipc	ra,0xffffb
    80005952:	1c8080e7          	jalr	456(ra) # 80000b16 <kalloc>
    80005956:	85aa                	mv	a1,a0
    80005958:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000595c:	cd11                	beqz	a0,80005978 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000595e:	6605                	lui	a2,0x1
    80005960:	e3043503          	ld	a0,-464(s0)
    80005964:	ffffd097          	auipc	ra,0xffffd
    80005968:	0d8080e7          	jalr	216(ra) # 80002a3c <fetchstr>
    8000596c:	00054663          	bltz	a0,80005978 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005970:	0905                	addi	s2,s2,1
    80005972:	09a1                	addi	s3,s3,8
    80005974:	fb491be3          	bne	s2,s4,8000592a <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005978:	10048913          	addi	s2,s1,256
    8000597c:	6088                	ld	a0,0(s1)
    8000597e:	c529                	beqz	a0,800059c8 <sys_exec+0xf8>
    kfree(argv[i]);
    80005980:	ffffb097          	auipc	ra,0xffffb
    80005984:	09a080e7          	jalr	154(ra) # 80000a1a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005988:	04a1                	addi	s1,s1,8
    8000598a:	ff2499e3          	bne	s1,s2,8000597c <sys_exec+0xac>
  return -1;
    8000598e:	597d                	li	s2,-1
    80005990:	a82d                	j	800059ca <sys_exec+0xfa>
      argv[i] = 0;
    80005992:	0a8e                	slli	s5,s5,0x3
    80005994:	fc040793          	addi	a5,s0,-64
    80005998:	9abe                	add	s5,s5,a5
    8000599a:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd8e80>
  int ret = exec(path, argv);
    8000599e:	e4040593          	addi	a1,s0,-448
    800059a2:	f4040513          	addi	a0,s0,-192
    800059a6:	fffff097          	auipc	ra,0xfffff
    800059aa:	178080e7          	jalr	376(ra) # 80004b1e <exec>
    800059ae:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800059b0:	10048993          	addi	s3,s1,256
    800059b4:	6088                	ld	a0,0(s1)
    800059b6:	c911                	beqz	a0,800059ca <sys_exec+0xfa>
    kfree(argv[i]);
    800059b8:	ffffb097          	auipc	ra,0xffffb
    800059bc:	062080e7          	jalr	98(ra) # 80000a1a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800059c0:	04a1                	addi	s1,s1,8
    800059c2:	ff3499e3          	bne	s1,s3,800059b4 <sys_exec+0xe4>
    800059c6:	a011                	j	800059ca <sys_exec+0xfa>
  return -1;
    800059c8:	597d                	li	s2,-1
}
    800059ca:	854a                	mv	a0,s2
    800059cc:	60be                	ld	ra,456(sp)
    800059ce:	641e                	ld	s0,448(sp)
    800059d0:	74fa                	ld	s1,440(sp)
    800059d2:	795a                	ld	s2,432(sp)
    800059d4:	79ba                	ld	s3,424(sp)
    800059d6:	7a1a                	ld	s4,416(sp)
    800059d8:	6afa                	ld	s5,408(sp)
    800059da:	6179                	addi	sp,sp,464
    800059dc:	8082                	ret

00000000800059de <sys_pipe>:

uint64
sys_pipe(void)
{
    800059de:	7139                	addi	sp,sp,-64
    800059e0:	fc06                	sd	ra,56(sp)
    800059e2:	f822                	sd	s0,48(sp)
    800059e4:	f426                	sd	s1,40(sp)
    800059e6:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800059e8:	ffffc097          	auipc	ra,0xffffc
    800059ec:	006080e7          	jalr	6(ra) # 800019ee <myproc>
    800059f0:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800059f2:	fd840593          	addi	a1,s0,-40
    800059f6:	4501                	li	a0,0
    800059f8:	ffffd097          	auipc	ra,0xffffd
    800059fc:	0ae080e7          	jalr	174(ra) # 80002aa6 <argaddr>
    return -1;
    80005a00:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005a02:	0e054063          	bltz	a0,80005ae2 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005a06:	fc840593          	addi	a1,s0,-56
    80005a0a:	fd040513          	addi	a0,s0,-48
    80005a0e:	fffff097          	auipc	ra,0xfffff
    80005a12:	de0080e7          	jalr	-544(ra) # 800047ee <pipealloc>
    return -1;
    80005a16:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005a18:	0c054563          	bltz	a0,80005ae2 <sys_pipe+0x104>
  fd0 = -1;
    80005a1c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005a20:	fd043503          	ld	a0,-48(s0)
    80005a24:	fffff097          	auipc	ra,0xfffff
    80005a28:	50a080e7          	jalr	1290(ra) # 80004f2e <fdalloc>
    80005a2c:	fca42223          	sw	a0,-60(s0)
    80005a30:	08054c63          	bltz	a0,80005ac8 <sys_pipe+0xea>
    80005a34:	fc843503          	ld	a0,-56(s0)
    80005a38:	fffff097          	auipc	ra,0xfffff
    80005a3c:	4f6080e7          	jalr	1270(ra) # 80004f2e <fdalloc>
    80005a40:	fca42023          	sw	a0,-64(s0)
    80005a44:	06054863          	bltz	a0,80005ab4 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005a48:	4691                	li	a3,4
    80005a4a:	fc440613          	addi	a2,s0,-60
    80005a4e:	fd843583          	ld	a1,-40(s0)
    80005a52:	68a8                	ld	a0,80(s1)
    80005a54:	ffffc097          	auipc	ra,0xffffc
    80005a58:	c2e080e7          	jalr	-978(ra) # 80001682 <copyout>
    80005a5c:	02054063          	bltz	a0,80005a7c <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005a60:	4691                	li	a3,4
    80005a62:	fc040613          	addi	a2,s0,-64
    80005a66:	fd843583          	ld	a1,-40(s0)
    80005a6a:	0591                	addi	a1,a1,4
    80005a6c:	68a8                	ld	a0,80(s1)
    80005a6e:	ffffc097          	auipc	ra,0xffffc
    80005a72:	c14080e7          	jalr	-1004(ra) # 80001682 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005a76:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005a78:	06055563          	bgez	a0,80005ae2 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005a7c:	fc442783          	lw	a5,-60(s0)
    80005a80:	07e9                	addi	a5,a5,26
    80005a82:	078e                	slli	a5,a5,0x3
    80005a84:	97a6                	add	a5,a5,s1
    80005a86:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005a8a:	fc042503          	lw	a0,-64(s0)
    80005a8e:	0569                	addi	a0,a0,26
    80005a90:	050e                	slli	a0,a0,0x3
    80005a92:	9526                	add	a0,a0,s1
    80005a94:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005a98:	fd043503          	ld	a0,-48(s0)
    80005a9c:	fffff097          	auipc	ra,0xfffff
    80005aa0:	9fc080e7          	jalr	-1540(ra) # 80004498 <fileclose>
    fileclose(wf);
    80005aa4:	fc843503          	ld	a0,-56(s0)
    80005aa8:	fffff097          	auipc	ra,0xfffff
    80005aac:	9f0080e7          	jalr	-1552(ra) # 80004498 <fileclose>
    return -1;
    80005ab0:	57fd                	li	a5,-1
    80005ab2:	a805                	j	80005ae2 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005ab4:	fc442783          	lw	a5,-60(s0)
    80005ab8:	0007c863          	bltz	a5,80005ac8 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005abc:	01a78513          	addi	a0,a5,26
    80005ac0:	050e                	slli	a0,a0,0x3
    80005ac2:	9526                	add	a0,a0,s1
    80005ac4:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005ac8:	fd043503          	ld	a0,-48(s0)
    80005acc:	fffff097          	auipc	ra,0xfffff
    80005ad0:	9cc080e7          	jalr	-1588(ra) # 80004498 <fileclose>
    fileclose(wf);
    80005ad4:	fc843503          	ld	a0,-56(s0)
    80005ad8:	fffff097          	auipc	ra,0xfffff
    80005adc:	9c0080e7          	jalr	-1600(ra) # 80004498 <fileclose>
    return -1;
    80005ae0:	57fd                	li	a5,-1
}
    80005ae2:	853e                	mv	a0,a5
    80005ae4:	70e2                	ld	ra,56(sp)
    80005ae6:	7442                	ld	s0,48(sp)
    80005ae8:	74a2                	ld	s1,40(sp)
    80005aea:	6121                	addi	sp,sp,64
    80005aec:	8082                	ret
	...

0000000080005af0 <kernelvec>:
    80005af0:	7111                	addi	sp,sp,-256
    80005af2:	e006                	sd	ra,0(sp)
    80005af4:	e40a                	sd	sp,8(sp)
    80005af6:	e80e                	sd	gp,16(sp)
    80005af8:	ec12                	sd	tp,24(sp)
    80005afa:	f016                	sd	t0,32(sp)
    80005afc:	f41a                	sd	t1,40(sp)
    80005afe:	f81e                	sd	t2,48(sp)
    80005b00:	fc22                	sd	s0,56(sp)
    80005b02:	e0a6                	sd	s1,64(sp)
    80005b04:	e4aa                	sd	a0,72(sp)
    80005b06:	e8ae                	sd	a1,80(sp)
    80005b08:	ecb2                	sd	a2,88(sp)
    80005b0a:	f0b6                	sd	a3,96(sp)
    80005b0c:	f4ba                	sd	a4,104(sp)
    80005b0e:	f8be                	sd	a5,112(sp)
    80005b10:	fcc2                	sd	a6,120(sp)
    80005b12:	e146                	sd	a7,128(sp)
    80005b14:	e54a                	sd	s2,136(sp)
    80005b16:	e94e                	sd	s3,144(sp)
    80005b18:	ed52                	sd	s4,152(sp)
    80005b1a:	f156                	sd	s5,160(sp)
    80005b1c:	f55a                	sd	s6,168(sp)
    80005b1e:	f95e                	sd	s7,176(sp)
    80005b20:	fd62                	sd	s8,184(sp)
    80005b22:	e1e6                	sd	s9,192(sp)
    80005b24:	e5ea                	sd	s10,200(sp)
    80005b26:	e9ee                	sd	s11,208(sp)
    80005b28:	edf2                	sd	t3,216(sp)
    80005b2a:	f1f6                	sd	t4,224(sp)
    80005b2c:	f5fa                	sd	t5,232(sp)
    80005b2e:	f9fe                	sd	t6,240(sp)
    80005b30:	d87fc0ef          	jal	ra,800028b6 <kerneltrap>
    80005b34:	6082                	ld	ra,0(sp)
    80005b36:	6122                	ld	sp,8(sp)
    80005b38:	61c2                	ld	gp,16(sp)
    80005b3a:	7282                	ld	t0,32(sp)
    80005b3c:	7322                	ld	t1,40(sp)
    80005b3e:	73c2                	ld	t2,48(sp)
    80005b40:	7462                	ld	s0,56(sp)
    80005b42:	6486                	ld	s1,64(sp)
    80005b44:	6526                	ld	a0,72(sp)
    80005b46:	65c6                	ld	a1,80(sp)
    80005b48:	6666                	ld	a2,88(sp)
    80005b4a:	7686                	ld	a3,96(sp)
    80005b4c:	7726                	ld	a4,104(sp)
    80005b4e:	77c6                	ld	a5,112(sp)
    80005b50:	7866                	ld	a6,120(sp)
    80005b52:	688a                	ld	a7,128(sp)
    80005b54:	692a                	ld	s2,136(sp)
    80005b56:	69ca                	ld	s3,144(sp)
    80005b58:	6a6a                	ld	s4,152(sp)
    80005b5a:	7a8a                	ld	s5,160(sp)
    80005b5c:	7b2a                	ld	s6,168(sp)
    80005b5e:	7bca                	ld	s7,176(sp)
    80005b60:	7c6a                	ld	s8,184(sp)
    80005b62:	6c8e                	ld	s9,192(sp)
    80005b64:	6d2e                	ld	s10,200(sp)
    80005b66:	6dce                	ld	s11,208(sp)
    80005b68:	6e6e                	ld	t3,216(sp)
    80005b6a:	7e8e                	ld	t4,224(sp)
    80005b6c:	7f2e                	ld	t5,232(sp)
    80005b6e:	7fce                	ld	t6,240(sp)
    80005b70:	6111                	addi	sp,sp,256
    80005b72:	10200073          	sret
    80005b76:	00000013          	nop
    80005b7a:	00000013          	nop
    80005b7e:	0001                	nop

0000000080005b80 <timervec>:
    80005b80:	34051573          	csrrw	a0,mscratch,a0
    80005b84:	e10c                	sd	a1,0(a0)
    80005b86:	e510                	sd	a2,8(a0)
    80005b88:	e914                	sd	a3,16(a0)
    80005b8a:	6d0c                	ld	a1,24(a0)
    80005b8c:	7110                	ld	a2,32(a0)
    80005b8e:	6194                	ld	a3,0(a1)
    80005b90:	96b2                	add	a3,a3,a2
    80005b92:	e194                	sd	a3,0(a1)
    80005b94:	4589                	li	a1,2
    80005b96:	14459073          	csrw	sip,a1
    80005b9a:	6914                	ld	a3,16(a0)
    80005b9c:	6510                	ld	a2,8(a0)
    80005b9e:	610c                	ld	a1,0(a0)
    80005ba0:	34051573          	csrrw	a0,mscratch,a0
    80005ba4:	30200073          	mret
	...

0000000080005baa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005baa:	1141                	addi	sp,sp,-16
    80005bac:	e422                	sd	s0,8(sp)
    80005bae:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005bb0:	0c0007b7          	lui	a5,0xc000
    80005bb4:	4705                	li	a4,1
    80005bb6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005bb8:	c3d8                	sw	a4,4(a5)
}
    80005bba:	6422                	ld	s0,8(sp)
    80005bbc:	0141                	addi	sp,sp,16
    80005bbe:	8082                	ret

0000000080005bc0 <plicinithart>:

void
plicinithart(void)
{
    80005bc0:	1141                	addi	sp,sp,-16
    80005bc2:	e406                	sd	ra,8(sp)
    80005bc4:	e022                	sd	s0,0(sp)
    80005bc6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005bc8:	ffffc097          	auipc	ra,0xffffc
    80005bcc:	dfa080e7          	jalr	-518(ra) # 800019c2 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005bd0:	0085171b          	slliw	a4,a0,0x8
    80005bd4:	0c0027b7          	lui	a5,0xc002
    80005bd8:	97ba                	add	a5,a5,a4
    80005bda:	40200713          	li	a4,1026
    80005bde:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005be2:	00d5151b          	slliw	a0,a0,0xd
    80005be6:	0c2017b7          	lui	a5,0xc201
    80005bea:	953e                	add	a0,a0,a5
    80005bec:	00052023          	sw	zero,0(a0)
}
    80005bf0:	60a2                	ld	ra,8(sp)
    80005bf2:	6402                	ld	s0,0(sp)
    80005bf4:	0141                	addi	sp,sp,16
    80005bf6:	8082                	ret

0000000080005bf8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005bf8:	1141                	addi	sp,sp,-16
    80005bfa:	e406                	sd	ra,8(sp)
    80005bfc:	e022                	sd	s0,0(sp)
    80005bfe:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005c00:	ffffc097          	auipc	ra,0xffffc
    80005c04:	dc2080e7          	jalr	-574(ra) # 800019c2 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005c08:	00d5179b          	slliw	a5,a0,0xd
    80005c0c:	0c201537          	lui	a0,0xc201
    80005c10:	953e                	add	a0,a0,a5
  return irq;
}
    80005c12:	4148                	lw	a0,4(a0)
    80005c14:	60a2                	ld	ra,8(sp)
    80005c16:	6402                	ld	s0,0(sp)
    80005c18:	0141                	addi	sp,sp,16
    80005c1a:	8082                	ret

0000000080005c1c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005c1c:	1101                	addi	sp,sp,-32
    80005c1e:	ec06                	sd	ra,24(sp)
    80005c20:	e822                	sd	s0,16(sp)
    80005c22:	e426                	sd	s1,8(sp)
    80005c24:	1000                	addi	s0,sp,32
    80005c26:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005c28:	ffffc097          	auipc	ra,0xffffc
    80005c2c:	d9a080e7          	jalr	-614(ra) # 800019c2 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005c30:	00d5151b          	slliw	a0,a0,0xd
    80005c34:	0c2017b7          	lui	a5,0xc201
    80005c38:	97aa                	add	a5,a5,a0
    80005c3a:	c3c4                	sw	s1,4(a5)
}
    80005c3c:	60e2                	ld	ra,24(sp)
    80005c3e:	6442                	ld	s0,16(sp)
    80005c40:	64a2                	ld	s1,8(sp)
    80005c42:	6105                	addi	sp,sp,32
    80005c44:	8082                	ret

0000000080005c46 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005c46:	1141                	addi	sp,sp,-16
    80005c48:	e406                	sd	ra,8(sp)
    80005c4a:	e022                	sd	s0,0(sp)
    80005c4c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005c4e:	479d                	li	a5,7
    80005c50:	06a7c963          	blt	a5,a0,80005cc2 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005c54:	0001d797          	auipc	a5,0x1d
    80005c58:	3ac78793          	addi	a5,a5,940 # 80023000 <disk>
    80005c5c:	00a78733          	add	a4,a5,a0
    80005c60:	6789                	lui	a5,0x2
    80005c62:	97ba                	add	a5,a5,a4
    80005c64:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005c68:	e7ad                	bnez	a5,80005cd2 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005c6a:	00451793          	slli	a5,a0,0x4
    80005c6e:	0001f717          	auipc	a4,0x1f
    80005c72:	39270713          	addi	a4,a4,914 # 80025000 <disk+0x2000>
    80005c76:	6314                	ld	a3,0(a4)
    80005c78:	96be                	add	a3,a3,a5
    80005c7a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005c7e:	6314                	ld	a3,0(a4)
    80005c80:	96be                	add	a3,a3,a5
    80005c82:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005c86:	6314                	ld	a3,0(a4)
    80005c88:	96be                	add	a3,a3,a5
    80005c8a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005c8e:	6318                	ld	a4,0(a4)
    80005c90:	97ba                	add	a5,a5,a4
    80005c92:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005c96:	0001d797          	auipc	a5,0x1d
    80005c9a:	36a78793          	addi	a5,a5,874 # 80023000 <disk>
    80005c9e:	97aa                	add	a5,a5,a0
    80005ca0:	6509                	lui	a0,0x2
    80005ca2:	953e                	add	a0,a0,a5
    80005ca4:	4785                	li	a5,1
    80005ca6:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005caa:	0001f517          	auipc	a0,0x1f
    80005cae:	36e50513          	addi	a0,a0,878 # 80025018 <disk+0x2018>
    80005cb2:	ffffc097          	auipc	ra,0xffffc
    80005cb6:	6ac080e7          	jalr	1708(ra) # 8000235e <wakeup>
}
    80005cba:	60a2                	ld	ra,8(sp)
    80005cbc:	6402                	ld	s0,0(sp)
    80005cbe:	0141                	addi	sp,sp,16
    80005cc0:	8082                	ret
    panic("free_desc 1");
    80005cc2:	00003517          	auipc	a0,0x3
    80005cc6:	a8e50513          	addi	a0,a0,-1394 # 80008750 <syscalls+0x330>
    80005cca:	ffffb097          	auipc	ra,0xffffb
    80005cce:	880080e7          	jalr	-1920(ra) # 8000054a <panic>
    panic("free_desc 2");
    80005cd2:	00003517          	auipc	a0,0x3
    80005cd6:	a8e50513          	addi	a0,a0,-1394 # 80008760 <syscalls+0x340>
    80005cda:	ffffb097          	auipc	ra,0xffffb
    80005cde:	870080e7          	jalr	-1936(ra) # 8000054a <panic>

0000000080005ce2 <virtio_disk_init>:
{
    80005ce2:	1101                	addi	sp,sp,-32
    80005ce4:	ec06                	sd	ra,24(sp)
    80005ce6:	e822                	sd	s0,16(sp)
    80005ce8:	e426                	sd	s1,8(sp)
    80005cea:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005cec:	00003597          	auipc	a1,0x3
    80005cf0:	a8458593          	addi	a1,a1,-1404 # 80008770 <syscalls+0x350>
    80005cf4:	0001f517          	auipc	a0,0x1f
    80005cf8:	43450513          	addi	a0,a0,1076 # 80025128 <disk+0x2128>
    80005cfc:	ffffb097          	auipc	ra,0xffffb
    80005d00:	e7a080e7          	jalr	-390(ra) # 80000b76 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005d04:	100017b7          	lui	a5,0x10001
    80005d08:	4398                	lw	a4,0(a5)
    80005d0a:	2701                	sext.w	a4,a4
    80005d0c:	747277b7          	lui	a5,0x74727
    80005d10:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005d14:	0ef71163          	bne	a4,a5,80005df6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005d18:	100017b7          	lui	a5,0x10001
    80005d1c:	43dc                	lw	a5,4(a5)
    80005d1e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005d20:	4705                	li	a4,1
    80005d22:	0ce79a63          	bne	a5,a4,80005df6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005d26:	100017b7          	lui	a5,0x10001
    80005d2a:	479c                	lw	a5,8(a5)
    80005d2c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005d2e:	4709                	li	a4,2
    80005d30:	0ce79363          	bne	a5,a4,80005df6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005d34:	100017b7          	lui	a5,0x10001
    80005d38:	47d8                	lw	a4,12(a5)
    80005d3a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005d3c:	554d47b7          	lui	a5,0x554d4
    80005d40:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005d44:	0af71963          	bne	a4,a5,80005df6 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005d48:	100017b7          	lui	a5,0x10001
    80005d4c:	4705                	li	a4,1
    80005d4e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005d50:	470d                	li	a4,3
    80005d52:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005d54:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005d56:	c7ffe737          	lui	a4,0xc7ffe
    80005d5a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd875f>
    80005d5e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005d60:	2701                	sext.w	a4,a4
    80005d62:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005d64:	472d                	li	a4,11
    80005d66:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005d68:	473d                	li	a4,15
    80005d6a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005d6c:	6705                	lui	a4,0x1
    80005d6e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005d70:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005d74:	5bdc                	lw	a5,52(a5)
    80005d76:	2781                	sext.w	a5,a5
  if(max == 0)
    80005d78:	c7d9                	beqz	a5,80005e06 <virtio_disk_init+0x124>
  if(max < NUM)
    80005d7a:	471d                	li	a4,7
    80005d7c:	08f77d63          	bgeu	a4,a5,80005e16 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005d80:	100014b7          	lui	s1,0x10001
    80005d84:	47a1                	li	a5,8
    80005d86:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005d88:	6609                	lui	a2,0x2
    80005d8a:	4581                	li	a1,0
    80005d8c:	0001d517          	auipc	a0,0x1d
    80005d90:	27450513          	addi	a0,a0,628 # 80023000 <disk>
    80005d94:	ffffb097          	auipc	ra,0xffffb
    80005d98:	f6e080e7          	jalr	-146(ra) # 80000d02 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005d9c:	0001d717          	auipc	a4,0x1d
    80005da0:	26470713          	addi	a4,a4,612 # 80023000 <disk>
    80005da4:	00c75793          	srli	a5,a4,0xc
    80005da8:	2781                	sext.w	a5,a5
    80005daa:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005dac:	0001f797          	auipc	a5,0x1f
    80005db0:	25478793          	addi	a5,a5,596 # 80025000 <disk+0x2000>
    80005db4:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005db6:	0001d717          	auipc	a4,0x1d
    80005dba:	2ca70713          	addi	a4,a4,714 # 80023080 <disk+0x80>
    80005dbe:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005dc0:	0001e717          	auipc	a4,0x1e
    80005dc4:	24070713          	addi	a4,a4,576 # 80024000 <disk+0x1000>
    80005dc8:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005dca:	4705                	li	a4,1
    80005dcc:	00e78c23          	sb	a4,24(a5)
    80005dd0:	00e78ca3          	sb	a4,25(a5)
    80005dd4:	00e78d23          	sb	a4,26(a5)
    80005dd8:	00e78da3          	sb	a4,27(a5)
    80005ddc:	00e78e23          	sb	a4,28(a5)
    80005de0:	00e78ea3          	sb	a4,29(a5)
    80005de4:	00e78f23          	sb	a4,30(a5)
    80005de8:	00e78fa3          	sb	a4,31(a5)
}
    80005dec:	60e2                	ld	ra,24(sp)
    80005dee:	6442                	ld	s0,16(sp)
    80005df0:	64a2                	ld	s1,8(sp)
    80005df2:	6105                	addi	sp,sp,32
    80005df4:	8082                	ret
    panic("could not find virtio disk");
    80005df6:	00003517          	auipc	a0,0x3
    80005dfa:	98a50513          	addi	a0,a0,-1654 # 80008780 <syscalls+0x360>
    80005dfe:	ffffa097          	auipc	ra,0xffffa
    80005e02:	74c080e7          	jalr	1868(ra) # 8000054a <panic>
    panic("virtio disk has no queue 0");
    80005e06:	00003517          	auipc	a0,0x3
    80005e0a:	99a50513          	addi	a0,a0,-1638 # 800087a0 <syscalls+0x380>
    80005e0e:	ffffa097          	auipc	ra,0xffffa
    80005e12:	73c080e7          	jalr	1852(ra) # 8000054a <panic>
    panic("virtio disk max queue too short");
    80005e16:	00003517          	auipc	a0,0x3
    80005e1a:	9aa50513          	addi	a0,a0,-1622 # 800087c0 <syscalls+0x3a0>
    80005e1e:	ffffa097          	auipc	ra,0xffffa
    80005e22:	72c080e7          	jalr	1836(ra) # 8000054a <panic>

0000000080005e26 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005e26:	7119                	addi	sp,sp,-128
    80005e28:	fc86                	sd	ra,120(sp)
    80005e2a:	f8a2                	sd	s0,112(sp)
    80005e2c:	f4a6                	sd	s1,104(sp)
    80005e2e:	f0ca                	sd	s2,96(sp)
    80005e30:	ecce                	sd	s3,88(sp)
    80005e32:	e8d2                	sd	s4,80(sp)
    80005e34:	e4d6                	sd	s5,72(sp)
    80005e36:	e0da                	sd	s6,64(sp)
    80005e38:	fc5e                	sd	s7,56(sp)
    80005e3a:	f862                	sd	s8,48(sp)
    80005e3c:	f466                	sd	s9,40(sp)
    80005e3e:	f06a                	sd	s10,32(sp)
    80005e40:	ec6e                	sd	s11,24(sp)
    80005e42:	0100                	addi	s0,sp,128
    80005e44:	8aaa                	mv	s5,a0
    80005e46:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005e48:	00c52c83          	lw	s9,12(a0)
    80005e4c:	001c9c9b          	slliw	s9,s9,0x1
    80005e50:	1c82                	slli	s9,s9,0x20
    80005e52:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005e56:	0001f517          	auipc	a0,0x1f
    80005e5a:	2d250513          	addi	a0,a0,722 # 80025128 <disk+0x2128>
    80005e5e:	ffffb097          	auipc	ra,0xffffb
    80005e62:	da8080e7          	jalr	-600(ra) # 80000c06 <acquire>
  for(int i = 0; i < 3; i++){
    80005e66:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005e68:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005e6a:	0001dc17          	auipc	s8,0x1d
    80005e6e:	196c0c13          	addi	s8,s8,406 # 80023000 <disk>
    80005e72:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    80005e74:	4b0d                	li	s6,3
    80005e76:	a0ad                	j	80005ee0 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005e78:	00fc0733          	add	a4,s8,a5
    80005e7c:	975e                	add	a4,a4,s7
    80005e7e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005e82:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005e84:	0207c563          	bltz	a5,80005eae <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005e88:	2905                	addiw	s2,s2,1
    80005e8a:	0611                	addi	a2,a2,4
    80005e8c:	19690d63          	beq	s2,s6,80006026 <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    80005e90:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005e92:	0001f717          	auipc	a4,0x1f
    80005e96:	18670713          	addi	a4,a4,390 # 80025018 <disk+0x2018>
    80005e9a:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005e9c:	00074683          	lbu	a3,0(a4)
    80005ea0:	fee1                	bnez	a3,80005e78 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005ea2:	2785                	addiw	a5,a5,1
    80005ea4:	0705                	addi	a4,a4,1
    80005ea6:	fe979be3          	bne	a5,s1,80005e9c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005eaa:	57fd                	li	a5,-1
    80005eac:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005eae:	01205d63          	blez	s2,80005ec8 <virtio_disk_rw+0xa2>
    80005eb2:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005eb4:	000a2503          	lw	a0,0(s4)
    80005eb8:	00000097          	auipc	ra,0x0
    80005ebc:	d8e080e7          	jalr	-626(ra) # 80005c46 <free_desc>
      for(int j = 0; j < i; j++)
    80005ec0:	2d85                	addiw	s11,s11,1
    80005ec2:	0a11                	addi	s4,s4,4
    80005ec4:	ffb918e3          	bne	s2,s11,80005eb4 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005ec8:	0001f597          	auipc	a1,0x1f
    80005ecc:	26058593          	addi	a1,a1,608 # 80025128 <disk+0x2128>
    80005ed0:	0001f517          	auipc	a0,0x1f
    80005ed4:	14850513          	addi	a0,a0,328 # 80025018 <disk+0x2018>
    80005ed8:	ffffc097          	auipc	ra,0xffffc
    80005edc:	306080e7          	jalr	774(ra) # 800021de <sleep>
  for(int i = 0; i < 3; i++){
    80005ee0:	f8040a13          	addi	s4,s0,-128
{
    80005ee4:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005ee6:	894e                	mv	s2,s3
    80005ee8:	b765                	j	80005e90 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005eea:	0001f697          	auipc	a3,0x1f
    80005eee:	1166b683          	ld	a3,278(a3) # 80025000 <disk+0x2000>
    80005ef2:	96ba                	add	a3,a3,a4
    80005ef4:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005ef8:	0001d817          	auipc	a6,0x1d
    80005efc:	10880813          	addi	a6,a6,264 # 80023000 <disk>
    80005f00:	0001f697          	auipc	a3,0x1f
    80005f04:	10068693          	addi	a3,a3,256 # 80025000 <disk+0x2000>
    80005f08:	6290                	ld	a2,0(a3)
    80005f0a:	963a                	add	a2,a2,a4
    80005f0c:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    80005f10:	0015e593          	ori	a1,a1,1
    80005f14:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80005f18:	f8842603          	lw	a2,-120(s0)
    80005f1c:	628c                	ld	a1,0(a3)
    80005f1e:	972e                	add	a4,a4,a1
    80005f20:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005f24:	20050593          	addi	a1,a0,512
    80005f28:	0592                	slli	a1,a1,0x4
    80005f2a:	95c2                	add	a1,a1,a6
    80005f2c:	577d                	li	a4,-1
    80005f2e:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005f32:	00461713          	slli	a4,a2,0x4
    80005f36:	6290                	ld	a2,0(a3)
    80005f38:	963a                	add	a2,a2,a4
    80005f3a:	03078793          	addi	a5,a5,48
    80005f3e:	97c2                	add	a5,a5,a6
    80005f40:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    80005f42:	629c                	ld	a5,0(a3)
    80005f44:	97ba                	add	a5,a5,a4
    80005f46:	4605                	li	a2,1
    80005f48:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005f4a:	629c                	ld	a5,0(a3)
    80005f4c:	97ba                	add	a5,a5,a4
    80005f4e:	4809                	li	a6,2
    80005f50:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005f54:	629c                	ld	a5,0(a3)
    80005f56:	973e                	add	a4,a4,a5
    80005f58:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005f5c:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80005f60:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005f64:	6698                	ld	a4,8(a3)
    80005f66:	00275783          	lhu	a5,2(a4)
    80005f6a:	8b9d                	andi	a5,a5,7
    80005f6c:	0786                	slli	a5,a5,0x1
    80005f6e:	97ba                	add	a5,a5,a4
    80005f70:	00a79223          	sh	a0,4(a5)

  __sync_synchronize();
    80005f74:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005f78:	6698                	ld	a4,8(a3)
    80005f7a:	00275783          	lhu	a5,2(a4)
    80005f7e:	2785                	addiw	a5,a5,1
    80005f80:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005f84:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005f88:	100017b7          	lui	a5,0x10001
    80005f8c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005f90:	004aa783          	lw	a5,4(s5)
    80005f94:	02c79163          	bne	a5,a2,80005fb6 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80005f98:	0001f917          	auipc	s2,0x1f
    80005f9c:	19090913          	addi	s2,s2,400 # 80025128 <disk+0x2128>
  while(b->disk == 1) {
    80005fa0:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005fa2:	85ca                	mv	a1,s2
    80005fa4:	8556                	mv	a0,s5
    80005fa6:	ffffc097          	auipc	ra,0xffffc
    80005faa:	238080e7          	jalr	568(ra) # 800021de <sleep>
  while(b->disk == 1) {
    80005fae:	004aa783          	lw	a5,4(s5)
    80005fb2:	fe9788e3          	beq	a5,s1,80005fa2 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80005fb6:	f8042903          	lw	s2,-128(s0)
    80005fba:	20090793          	addi	a5,s2,512
    80005fbe:	00479713          	slli	a4,a5,0x4
    80005fc2:	0001d797          	auipc	a5,0x1d
    80005fc6:	03e78793          	addi	a5,a5,62 # 80023000 <disk>
    80005fca:	97ba                	add	a5,a5,a4
    80005fcc:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005fd0:	0001f997          	auipc	s3,0x1f
    80005fd4:	03098993          	addi	s3,s3,48 # 80025000 <disk+0x2000>
    80005fd8:	00491713          	slli	a4,s2,0x4
    80005fdc:	0009b783          	ld	a5,0(s3)
    80005fe0:	97ba                	add	a5,a5,a4
    80005fe2:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005fe6:	854a                	mv	a0,s2
    80005fe8:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005fec:	00000097          	auipc	ra,0x0
    80005ff0:	c5a080e7          	jalr	-934(ra) # 80005c46 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005ff4:	8885                	andi	s1,s1,1
    80005ff6:	f0ed                	bnez	s1,80005fd8 <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005ff8:	0001f517          	auipc	a0,0x1f
    80005ffc:	13050513          	addi	a0,a0,304 # 80025128 <disk+0x2128>
    80006000:	ffffb097          	auipc	ra,0xffffb
    80006004:	cba080e7          	jalr	-838(ra) # 80000cba <release>
}
    80006008:	70e6                	ld	ra,120(sp)
    8000600a:	7446                	ld	s0,112(sp)
    8000600c:	74a6                	ld	s1,104(sp)
    8000600e:	7906                	ld	s2,96(sp)
    80006010:	69e6                	ld	s3,88(sp)
    80006012:	6a46                	ld	s4,80(sp)
    80006014:	6aa6                	ld	s5,72(sp)
    80006016:	6b06                	ld	s6,64(sp)
    80006018:	7be2                	ld	s7,56(sp)
    8000601a:	7c42                	ld	s8,48(sp)
    8000601c:	7ca2                	ld	s9,40(sp)
    8000601e:	7d02                	ld	s10,32(sp)
    80006020:	6de2                	ld	s11,24(sp)
    80006022:	6109                	addi	sp,sp,128
    80006024:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006026:	f8042503          	lw	a0,-128(s0)
    8000602a:	20050793          	addi	a5,a0,512
    8000602e:	0792                	slli	a5,a5,0x4
  if(write)
    80006030:	0001d817          	auipc	a6,0x1d
    80006034:	fd080813          	addi	a6,a6,-48 # 80023000 <disk>
    80006038:	00f80733          	add	a4,a6,a5
    8000603c:	01a036b3          	snez	a3,s10
    80006040:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    80006044:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80006048:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000604c:	7679                	lui	a2,0xffffe
    8000604e:	963e                	add	a2,a2,a5
    80006050:	0001f697          	auipc	a3,0x1f
    80006054:	fb068693          	addi	a3,a3,-80 # 80025000 <disk+0x2000>
    80006058:	6298                	ld	a4,0(a3)
    8000605a:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000605c:	0a878593          	addi	a1,a5,168
    80006060:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006062:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006064:	6298                	ld	a4,0(a3)
    80006066:	9732                	add	a4,a4,a2
    80006068:	45c1                	li	a1,16
    8000606a:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000606c:	6298                	ld	a4,0(a3)
    8000606e:	9732                	add	a4,a4,a2
    80006070:	4585                	li	a1,1
    80006072:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80006076:	f8442703          	lw	a4,-124(s0)
    8000607a:	628c                	ld	a1,0(a3)
    8000607c:	962e                	add	a2,a2,a1
    8000607e:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd800e>
  disk.desc[idx[1]].addr = (uint64) b->data;
    80006082:	0712                	slli	a4,a4,0x4
    80006084:	6290                	ld	a2,0(a3)
    80006086:	963a                	add	a2,a2,a4
    80006088:	058a8593          	addi	a1,s5,88
    8000608c:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    8000608e:	6294                	ld	a3,0(a3)
    80006090:	96ba                	add	a3,a3,a4
    80006092:	40000613          	li	a2,1024
    80006096:	c690                	sw	a2,8(a3)
  if(write)
    80006098:	e40d19e3          	bnez	s10,80005eea <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000609c:	0001f697          	auipc	a3,0x1f
    800060a0:	f646b683          	ld	a3,-156(a3) # 80025000 <disk+0x2000>
    800060a4:	96ba                	add	a3,a3,a4
    800060a6:	4609                	li	a2,2
    800060a8:	00c69623          	sh	a2,12(a3)
    800060ac:	b5b1                	j	80005ef8 <virtio_disk_rw+0xd2>

00000000800060ae <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800060ae:	1101                	addi	sp,sp,-32
    800060b0:	ec06                	sd	ra,24(sp)
    800060b2:	e822                	sd	s0,16(sp)
    800060b4:	e426                	sd	s1,8(sp)
    800060b6:	e04a                	sd	s2,0(sp)
    800060b8:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800060ba:	0001f517          	auipc	a0,0x1f
    800060be:	06e50513          	addi	a0,a0,110 # 80025128 <disk+0x2128>
    800060c2:	ffffb097          	auipc	ra,0xffffb
    800060c6:	b44080e7          	jalr	-1212(ra) # 80000c06 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800060ca:	10001737          	lui	a4,0x10001
    800060ce:	533c                	lw	a5,96(a4)
    800060d0:	8b8d                	andi	a5,a5,3
    800060d2:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800060d4:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800060d8:	0001f797          	auipc	a5,0x1f
    800060dc:	f2878793          	addi	a5,a5,-216 # 80025000 <disk+0x2000>
    800060e0:	6b94                	ld	a3,16(a5)
    800060e2:	0207d703          	lhu	a4,32(a5)
    800060e6:	0026d783          	lhu	a5,2(a3)
    800060ea:	06f70163          	beq	a4,a5,8000614c <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800060ee:	0001d917          	auipc	s2,0x1d
    800060f2:	f1290913          	addi	s2,s2,-238 # 80023000 <disk>
    800060f6:	0001f497          	auipc	s1,0x1f
    800060fa:	f0a48493          	addi	s1,s1,-246 # 80025000 <disk+0x2000>
    __sync_synchronize();
    800060fe:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006102:	6898                	ld	a4,16(s1)
    80006104:	0204d783          	lhu	a5,32(s1)
    80006108:	8b9d                	andi	a5,a5,7
    8000610a:	078e                	slli	a5,a5,0x3
    8000610c:	97ba                	add	a5,a5,a4
    8000610e:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006110:	20078713          	addi	a4,a5,512
    80006114:	0712                	slli	a4,a4,0x4
    80006116:	974a                	add	a4,a4,s2
    80006118:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000611c:	e731                	bnez	a4,80006168 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000611e:	20078793          	addi	a5,a5,512
    80006122:	0792                	slli	a5,a5,0x4
    80006124:	97ca                	add	a5,a5,s2
    80006126:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80006128:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000612c:	ffffc097          	auipc	ra,0xffffc
    80006130:	232080e7          	jalr	562(ra) # 8000235e <wakeup>

    disk.used_idx += 1;
    80006134:	0204d783          	lhu	a5,32(s1)
    80006138:	2785                	addiw	a5,a5,1
    8000613a:	17c2                	slli	a5,a5,0x30
    8000613c:	93c1                	srli	a5,a5,0x30
    8000613e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006142:	6898                	ld	a4,16(s1)
    80006144:	00275703          	lhu	a4,2(a4)
    80006148:	faf71be3          	bne	a4,a5,800060fe <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000614c:	0001f517          	auipc	a0,0x1f
    80006150:	fdc50513          	addi	a0,a0,-36 # 80025128 <disk+0x2128>
    80006154:	ffffb097          	auipc	ra,0xffffb
    80006158:	b66080e7          	jalr	-1178(ra) # 80000cba <release>
}
    8000615c:	60e2                	ld	ra,24(sp)
    8000615e:	6442                	ld	s0,16(sp)
    80006160:	64a2                	ld	s1,8(sp)
    80006162:	6902                	ld	s2,0(sp)
    80006164:	6105                	addi	sp,sp,32
    80006166:	8082                	ret
      panic("virtio_disk_intr status");
    80006168:	00002517          	auipc	a0,0x2
    8000616c:	67850513          	addi	a0,a0,1656 # 800087e0 <syscalls+0x3c0>
    80006170:	ffffa097          	auipc	ra,0xffffa
    80006174:	3da080e7          	jalr	986(ra) # 8000054a <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
