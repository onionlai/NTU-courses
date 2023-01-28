
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	86013103          	ld	sp,-1952(sp) # 80008860 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    80000068:	09c78793          	addi	a5,a5,156 # 80006100 <timervec>
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
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ff977ff>
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
    80000132:	44a080e7          	jalr	1098(ra) # 80002578 <either_copyin>
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
    800001d6:	83c080e7          	jalr	-1988(ra) # 80001a0e <myproc>
    800001da:	591c                	lw	a5,48(a0)
    800001dc:	e7b5                	bnez	a5,80000248 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800001de:	85a6                	mv	a1,s1
    800001e0:	854a                	mv	a0,s2
    800001e2:	00002097          	auipc	ra,0x2
    800001e6:	0ce080e7          	jalr	206(ra) # 800022b0 <sleep>
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
    80000222:	300080e7          	jalr	768(ra) # 8000251e <either_copyout>
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
    80000302:	2d4080e7          	jalr	724(ra) # 800025d2 <procdump>
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
    80000456:	fe2080e7          	jalr	-30(ra) # 80002434 <wakeup>
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
    80000484:	00062797          	auipc	a5,0x62
    80000488:	26c78793          	addi	a5,a5,620 # 800626f0 <devsw>
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
    800008ae:	b8a080e7          	jalr	-1142(ra) # 80002434 <wakeup>
    
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
    80000948:	96c080e7          	jalr	-1684(ra) # 800022b0 <sleep>
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
    80000a2e:	00066797          	auipc	a5,0x66
    80000a32:	5d278793          	addi	a5,a5,1490 # 80067000 <end>
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
    80000afe:	00066517          	auipc	a0,0x66
    80000b02:	50250513          	addi	a0,a0,1282 # 80067000 <end>
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
    80000ba4:	e52080e7          	jalr	-430(ra) # 800019f2 <mycpu>
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
    80000bd6:	e20080e7          	jalr	-480(ra) # 800019f2 <mycpu>
    80000bda:	5d3c                	lw	a5,120(a0)
    80000bdc:	cf89                	beqz	a5,80000bf6 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bde:	00001097          	auipc	ra,0x1
    80000be2:	e14080e7          	jalr	-492(ra) # 800019f2 <mycpu>
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
    80000bfa:	dfc080e7          	jalr	-516(ra) # 800019f2 <mycpu>
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
    80000c3a:	dbc080e7          	jalr	-580(ra) # 800019f2 <mycpu>
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
    80000c66:	d90080e7          	jalr	-624(ra) # 800019f2 <mycpu>
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
    80000ebc:	b2a080e7          	jalr	-1238(ra) # 800019e2 <cpuid>
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
    80000ed8:	b0e080e7          	jalr	-1266(ra) # 800019e2 <cpuid>
    80000edc:	85aa                	mv	a1,a0
    80000ede:	00007517          	auipc	a0,0x7
    80000ee2:	1da50513          	addi	a0,a0,474 # 800080b8 <digits+0x78>
    80000ee6:	fffff097          	auipc	ra,0xfffff
    80000eea:	6ae080e7          	jalr	1710(ra) # 80000594 <printf>
    kvminithart();    // turn on paging
    80000eee:	00000097          	auipc	ra,0x0
    80000ef2:	0d8080e7          	jalr	216(ra) # 80000fc6 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ef6:	00002097          	auipc	ra,0x2
    80000efa:	97c080e7          	jalr	-1668(ra) # 80002872 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000efe:	00005097          	auipc	ra,0x5
    80000f02:	242080e7          	jalr	578(ra) # 80006140 <plicinithart>
  }

  scheduler();        
    80000f06:	00001097          	auipc	ra,0x1
    80000f0a:	0d6080e7          	jalr	214(ra) # 80001fdc <scheduler>
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
    80000f6a:	9d0080e7          	jalr	-1584(ra) # 80001936 <procinit>
    trapinit();      // trap vectors
    80000f6e:	00002097          	auipc	ra,0x2
    80000f72:	8dc080e7          	jalr	-1828(ra) # 8000284a <trapinit>
    trapinithart();  // install kernel trap vector
    80000f76:	00002097          	auipc	ra,0x2
    80000f7a:	8fc080e7          	jalr	-1796(ra) # 80002872 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f7e:	00005097          	auipc	ra,0x5
    80000f82:	1ac080e7          	jalr	428(ra) # 8000612a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f86:	00005097          	auipc	ra,0x5
    80000f8a:	1ba080e7          	jalr	442(ra) # 80006140 <plicinithart>
    binit();         // buffer cache
    80000f8e:	00002097          	auipc	ra,0x2
    80000f92:	31c080e7          	jalr	796(ra) # 800032aa <binit>
    iinit();         // inode cache
    80000f96:	00003097          	auipc	ra,0x3
    80000f9a:	9ac080e7          	jalr	-1620(ra) # 80003942 <iinit>
    fileinit();      // file table
    80000f9e:	00004097          	auipc	ra,0x4
    80000fa2:	960080e7          	jalr	-1696(ra) # 800048fe <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fa6:	00005097          	auipc	ra,0x5
    80000faa:	2bc080e7          	jalr	700(ra) # 80006262 <virtio_disk_init>
    userinit();      // first user process
    80000fae:	00001097          	auipc	ra,0x1
    80000fb2:	d78080e7          	jalr	-648(ra) # 80001d26 <userinit>
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
    80001824:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ff98000>
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
    80001894:	715d                	addi	sp,sp,-80
    80001896:	e486                	sd	ra,72(sp)
    80001898:	e0a2                	sd	s0,64(sp)
    8000189a:	fc26                	sd	s1,56(sp)
    8000189c:	f84a                	sd	s2,48(sp)
    8000189e:	f44e                	sd	s3,40(sp)
    800018a0:	f052                	sd	s4,32(sp)
    800018a2:	ec56                	sd	s5,24(sp)
    800018a4:	e85a                	sd	s6,16(sp)
    800018a6:	e45e                	sd	s7,8(sp)
    800018a8:	e062                	sd	s8,0(sp)
    800018aa:	0880                	addi	s0,sp,80
    800018ac:	89aa                	mv	s3,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    800018ae:	00010497          	auipc	s1,0x10
    800018b2:	dfa48493          	addi	s1,s1,-518 # 800116a8 <proc>
    uint64 va = KSTACK((int) (p - proc));
    800018b6:	8c26                	mv	s8,s1
    800018b8:	00006b97          	auipc	s7,0x6
    800018bc:	748b8b93          	addi	s7,s7,1864 # 80008000 <etext>
    800018c0:	04000937          	lui	s2,0x4000
    800018c4:	197d                	addi	s2,s2,-1
    800018c6:	0932                	slli	s2,s2,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800018c8:	6a05                	lui	s4,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    800018ca:	1b8a0b13          	addi	s6,s4,440 # 11b8 <_entry-0x7fffee48>
    800018ce:	00057a97          	auipc	s5,0x57
    800018d2:	bdaa8a93          	addi	s5,s5,-1062 # 800584a8 <tickslock>
    char *pa = kalloc();
    800018d6:	fffff097          	auipc	ra,0xfffff
    800018da:	240080e7          	jalr	576(ra) # 80000b16 <kalloc>
    800018de:	862a                	mv	a2,a0
    if(pa == 0)
    800018e0:	c139                	beqz	a0,80001926 <proc_mapstacks+0x92>
    uint64 va = KSTACK((int) (p - proc));
    800018e2:	418485b3          	sub	a1,s1,s8
    800018e6:	858d                	srai	a1,a1,0x3
    800018e8:	000bb783          	ld	a5,0(s7)
    800018ec:	02f585b3          	mul	a1,a1,a5
    800018f0:	2585                	addiw	a1,a1,1
    800018f2:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800018f6:	4719                	li	a4,6
    800018f8:	86d2                	mv	a3,s4
    800018fa:	40b905b3          	sub	a1,s2,a1
    800018fe:	854e                	mv	a0,s3
    80001900:	00000097          	auipc	ra,0x0
    80001904:	860080e7          	jalr	-1952(ra) # 80001160 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001908:	94da                	add	s1,s1,s6
    8000190a:	fd5496e3          	bne	s1,s5,800018d6 <proc_mapstacks+0x42>
}
    8000190e:	60a6                	ld	ra,72(sp)
    80001910:	6406                	ld	s0,64(sp)
    80001912:	74e2                	ld	s1,56(sp)
    80001914:	7942                	ld	s2,48(sp)
    80001916:	79a2                	ld	s3,40(sp)
    80001918:	7a02                	ld	s4,32(sp)
    8000191a:	6ae2                	ld	s5,24(sp)
    8000191c:	6b42                	ld	s6,16(sp)
    8000191e:	6ba2                	ld	s7,8(sp)
    80001920:	6c02                	ld	s8,0(sp)
    80001922:	6161                	addi	sp,sp,80
    80001924:	8082                	ret
      panic("kalloc");
    80001926:	00007517          	auipc	a0,0x7
    8000192a:	8a250513          	addi	a0,a0,-1886 # 800081c8 <digits+0x188>
    8000192e:	fffff097          	auipc	ra,0xfffff
    80001932:	c1c080e7          	jalr	-996(ra) # 8000054a <panic>

0000000080001936 <procinit>:
{
    80001936:	715d                	addi	sp,sp,-80
    80001938:	e486                	sd	ra,72(sp)
    8000193a:	e0a2                	sd	s0,64(sp)
    8000193c:	fc26                	sd	s1,56(sp)
    8000193e:	f84a                	sd	s2,48(sp)
    80001940:	f44e                	sd	s3,40(sp)
    80001942:	f052                	sd	s4,32(sp)
    80001944:	ec56                	sd	s5,24(sp)
    80001946:	e85a                	sd	s6,16(sp)
    80001948:	e45e                	sd	s7,8(sp)
    8000194a:	e062                	sd	s8,0(sp)
    8000194c:	0880                	addi	s0,sp,80
  initlock(&pid_lock, "nextpid");
    8000194e:	00007597          	auipc	a1,0x7
    80001952:	88258593          	addi	a1,a1,-1918 # 800081d0 <digits+0x190>
    80001956:	00010517          	auipc	a0,0x10
    8000195a:	93a50513          	addi	a0,a0,-1734 # 80011290 <pid_lock>
    8000195e:	fffff097          	auipc	ra,0xfffff
    80001962:	218080e7          	jalr	536(ra) # 80000b76 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001966:	00010497          	auipc	s1,0x10
    8000196a:	d4248493          	addi	s1,s1,-702 # 800116a8 <proc>
      initlock(&p->lock, "proc");
    8000196e:	00007c17          	auipc	s8,0x7
    80001972:	86ac0c13          	addi	s8,s8,-1942 # 800081d8 <digits+0x198>
      p->kstack = KSTACK((int) (p - proc));
    80001976:	6985                	lui	s3,0x1
    80001978:	09098b93          	addi	s7,s3,144 # 1090 <_entry-0x7fffef70>
    8000197c:	8b26                	mv	s6,s1
    8000197e:	00006a97          	auipc	s5,0x6
    80001982:	682a8a93          	addi	s5,s5,1666 # 80008000 <etext>
    80001986:	04000937          	lui	s2,0x4000
    8000198a:	197d                	addi	s2,s2,-1
    8000198c:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000198e:	1b898993          	addi	s3,s3,440
    80001992:	00057a17          	auipc	s4,0x57
    80001996:	b16a0a13          	addi	s4,s4,-1258 # 800584a8 <tickslock>
      initlock(&p->lock, "proc");
    8000199a:	85e2                	mv	a1,s8
    8000199c:	8526                	mv	a0,s1
    8000199e:	fffff097          	auipc	ra,0xfffff
    800019a2:	1d8080e7          	jalr	472(ra) # 80000b76 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    800019a6:	01748733          	add	a4,s1,s7
    800019aa:	416487b3          	sub	a5,s1,s6
    800019ae:	878d                	srai	a5,a5,0x3
    800019b0:	000ab683          	ld	a3,0(s5)
    800019b4:	02d787b3          	mul	a5,a5,a3
    800019b8:	2785                	addiw	a5,a5,1
    800019ba:	00d7979b          	slliw	a5,a5,0xd
    800019be:	40f907b3          	sub	a5,s2,a5
    800019c2:	e31c                	sd	a5,0(a4)
  for(p = proc; p < &proc[NPROC]; p++) {
    800019c4:	94ce                	add	s1,s1,s3
    800019c6:	fd449ae3          	bne	s1,s4,8000199a <procinit+0x64>
}
    800019ca:	60a6                	ld	ra,72(sp)
    800019cc:	6406                	ld	s0,64(sp)
    800019ce:	74e2                	ld	s1,56(sp)
    800019d0:	7942                	ld	s2,48(sp)
    800019d2:	79a2                	ld	s3,40(sp)
    800019d4:	7a02                	ld	s4,32(sp)
    800019d6:	6ae2                	ld	s5,24(sp)
    800019d8:	6b42                	ld	s6,16(sp)
    800019da:	6ba2                	ld	s7,8(sp)
    800019dc:	6c02                	ld	s8,0(sp)
    800019de:	6161                	addi	sp,sp,80
    800019e0:	8082                	ret

00000000800019e2 <cpuid>:
{
    800019e2:	1141                	addi	sp,sp,-16
    800019e4:	e422                	sd	s0,8(sp)
    800019e6:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800019e8:	8512                	mv	a0,tp
}
    800019ea:	2501                	sext.w	a0,a0
    800019ec:	6422                	ld	s0,8(sp)
    800019ee:	0141                	addi	sp,sp,16
    800019f0:	8082                	ret

00000000800019f2 <mycpu>:
mycpu(void) {
    800019f2:	1141                	addi	sp,sp,-16
    800019f4:	e422                	sd	s0,8(sp)
    800019f6:	0800                	addi	s0,sp,16
    800019f8:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    800019fa:	2781                	sext.w	a5,a5
    800019fc:	079e                	slli	a5,a5,0x7
}
    800019fe:	00010517          	auipc	a0,0x10
    80001a02:	8aa50513          	addi	a0,a0,-1878 # 800112a8 <cpus>
    80001a06:	953e                	add	a0,a0,a5
    80001a08:	6422                	ld	s0,8(sp)
    80001a0a:	0141                	addi	sp,sp,16
    80001a0c:	8082                	ret

0000000080001a0e <myproc>:
myproc(void) {
    80001a0e:	1101                	addi	sp,sp,-32
    80001a10:	ec06                	sd	ra,24(sp)
    80001a12:	e822                	sd	s0,16(sp)
    80001a14:	e426                	sd	s1,8(sp)
    80001a16:	1000                	addi	s0,sp,32
  push_off();
    80001a18:	fffff097          	auipc	ra,0xfffff
    80001a1c:	1a2080e7          	jalr	418(ra) # 80000bba <push_off>
    80001a20:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80001a22:	2781                	sext.w	a5,a5
    80001a24:	079e                	slli	a5,a5,0x7
    80001a26:	00010717          	auipc	a4,0x10
    80001a2a:	86a70713          	addi	a4,a4,-1942 # 80011290 <pid_lock>
    80001a2e:	97ba                	add	a5,a5,a4
    80001a30:	6f84                	ld	s1,24(a5)
  pop_off();
    80001a32:	fffff097          	auipc	ra,0xfffff
    80001a36:	228080e7          	jalr	552(ra) # 80000c5a <pop_off>
}
    80001a3a:	8526                	mv	a0,s1
    80001a3c:	60e2                	ld	ra,24(sp)
    80001a3e:	6442                	ld	s0,16(sp)
    80001a40:	64a2                	ld	s1,8(sp)
    80001a42:	6105                	addi	sp,sp,32
    80001a44:	8082                	ret

0000000080001a46 <forkret>:
{
    80001a46:	1141                	addi	sp,sp,-16
    80001a48:	e406                	sd	ra,8(sp)
    80001a4a:	e022                	sd	s0,0(sp)
    80001a4c:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    80001a4e:	00000097          	auipc	ra,0x0
    80001a52:	fc0080e7          	jalr	-64(ra) # 80001a0e <myproc>
    80001a56:	fffff097          	auipc	ra,0xfffff
    80001a5a:	264080e7          	jalr	612(ra) # 80000cba <release>
  if (first) {
    80001a5e:	00007797          	auipc	a5,0x7
    80001a62:	db27a783          	lw	a5,-590(a5) # 80008810 <first.1>
    80001a66:	eb89                	bnez	a5,80001a78 <forkret+0x32>
  usertrapret();
    80001a68:	00001097          	auipc	ra,0x1
    80001a6c:	e22080e7          	jalr	-478(ra) # 8000288a <usertrapret>
}
    80001a70:	60a2                	ld	ra,8(sp)
    80001a72:	6402                	ld	s0,0(sp)
    80001a74:	0141                	addi	sp,sp,16
    80001a76:	8082                	ret
    first = 0;
    80001a78:	00007797          	auipc	a5,0x7
    80001a7c:	d807ac23          	sw	zero,-616(a5) # 80008810 <first.1>
    fsinit(ROOTDEV);
    80001a80:	4505                	li	a0,1
    80001a82:	00002097          	auipc	ra,0x2
    80001a86:	e40080e7          	jalr	-448(ra) # 800038c2 <fsinit>
    80001a8a:	bff9                	j	80001a68 <forkret+0x22>

0000000080001a8c <allocpid>:
allocpid() {
    80001a8c:	1101                	addi	sp,sp,-32
    80001a8e:	ec06                	sd	ra,24(sp)
    80001a90:	e822                	sd	s0,16(sp)
    80001a92:	e426                	sd	s1,8(sp)
    80001a94:	e04a                	sd	s2,0(sp)
    80001a96:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001a98:	0000f917          	auipc	s2,0xf
    80001a9c:	7f890913          	addi	s2,s2,2040 # 80011290 <pid_lock>
    80001aa0:	854a                	mv	a0,s2
    80001aa2:	fffff097          	auipc	ra,0xfffff
    80001aa6:	164080e7          	jalr	356(ra) # 80000c06 <acquire>
  pid = nextpid;
    80001aaa:	00007797          	auipc	a5,0x7
    80001aae:	d6a78793          	addi	a5,a5,-662 # 80008814 <nextpid>
    80001ab2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001ab4:	0014871b          	addiw	a4,s1,1
    80001ab8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001aba:	854a                	mv	a0,s2
    80001abc:	fffff097          	auipc	ra,0xfffff
    80001ac0:	1fe080e7          	jalr	510(ra) # 80000cba <release>
}
    80001ac4:	8526                	mv	a0,s1
    80001ac6:	60e2                	ld	ra,24(sp)
    80001ac8:	6442                	ld	s0,16(sp)
    80001aca:	64a2                	ld	s1,8(sp)
    80001acc:	6902                	ld	s2,0(sp)
    80001ace:	6105                	addi	sp,sp,32
    80001ad0:	8082                	ret

0000000080001ad2 <proc_pagetable>:
{
    80001ad2:	1101                	addi	sp,sp,-32
    80001ad4:	ec06                	sd	ra,24(sp)
    80001ad6:	e822                	sd	s0,16(sp)
    80001ad8:	e426                	sd	s1,8(sp)
    80001ada:	e04a                	sd	s2,0(sp)
    80001adc:	1000                	addi	s0,sp,32
    80001ade:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001ae0:	00000097          	auipc	ra,0x0
    80001ae4:	86a080e7          	jalr	-1942(ra) # 8000134a <uvmcreate>
    80001ae8:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001aea:	c129                	beqz	a0,80001b2c <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001aec:	4729                	li	a4,10
    80001aee:	00005697          	auipc	a3,0x5
    80001af2:	51268693          	addi	a3,a3,1298 # 80007000 <_trampoline>
    80001af6:	6605                	lui	a2,0x1
    80001af8:	040005b7          	lui	a1,0x4000
    80001afc:	15fd                	addi	a1,a1,-1
    80001afe:	05b2                	slli	a1,a1,0xc
    80001b00:	fffff097          	auipc	ra,0xfffff
    80001b04:	5d2080e7          	jalr	1490(ra) # 800010d2 <mappages>
    80001b08:	02054963          	bltz	a0,80001b3a <proc_pagetable+0x68>
              (uint64)(p->trapframe), PTE_R | PTE_W) < 0){
    80001b0c:	6505                	lui	a0,0x1
    80001b0e:	954a                	add	a0,a0,s2
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001b10:	4719                	li	a4,6
    80001b12:	7554                	ld	a3,168(a0)
    80001b14:	6605                	lui	a2,0x1
    80001b16:	020005b7          	lui	a1,0x2000
    80001b1a:	15fd                	addi	a1,a1,-1
    80001b1c:	05b6                	slli	a1,a1,0xd
    80001b1e:	8526                	mv	a0,s1
    80001b20:	fffff097          	auipc	ra,0xfffff
    80001b24:	5b2080e7          	jalr	1458(ra) # 800010d2 <mappages>
    80001b28:	02054163          	bltz	a0,80001b4a <proc_pagetable+0x78>
}
    80001b2c:	8526                	mv	a0,s1
    80001b2e:	60e2                	ld	ra,24(sp)
    80001b30:	6442                	ld	s0,16(sp)
    80001b32:	64a2                	ld	s1,8(sp)
    80001b34:	6902                	ld	s2,0(sp)
    80001b36:	6105                	addi	sp,sp,32
    80001b38:	8082                	ret
    uvmfree(pagetable, 0);
    80001b3a:	4581                	li	a1,0
    80001b3c:	8526                	mv	a0,s1
    80001b3e:	00000097          	auipc	ra,0x0
    80001b42:	a08080e7          	jalr	-1528(ra) # 80001546 <uvmfree>
    return 0;
    80001b46:	4481                	li	s1,0
    80001b48:	b7d5                	j	80001b2c <proc_pagetable+0x5a>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b4a:	4681                	li	a3,0
    80001b4c:	4605                	li	a2,1
    80001b4e:	040005b7          	lui	a1,0x4000
    80001b52:	15fd                	addi	a1,a1,-1
    80001b54:	05b2                	slli	a1,a1,0xc
    80001b56:	8526                	mv	a0,s1
    80001b58:	fffff097          	auipc	ra,0xfffff
    80001b5c:	72e080e7          	jalr	1838(ra) # 80001286 <uvmunmap>
    uvmfree(pagetable, 0);
    80001b60:	4581                	li	a1,0
    80001b62:	8526                	mv	a0,s1
    80001b64:	00000097          	auipc	ra,0x0
    80001b68:	9e2080e7          	jalr	-1566(ra) # 80001546 <uvmfree>
    return 0;
    80001b6c:	4481                	li	s1,0
    80001b6e:	bf7d                	j	80001b2c <proc_pagetable+0x5a>

0000000080001b70 <proc_freepagetable>:
{
    80001b70:	1101                	addi	sp,sp,-32
    80001b72:	ec06                	sd	ra,24(sp)
    80001b74:	e822                	sd	s0,16(sp)
    80001b76:	e426                	sd	s1,8(sp)
    80001b78:	e04a                	sd	s2,0(sp)
    80001b7a:	1000                	addi	s0,sp,32
    80001b7c:	84aa                	mv	s1,a0
    80001b7e:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b80:	4681                	li	a3,0
    80001b82:	4605                	li	a2,1
    80001b84:	040005b7          	lui	a1,0x4000
    80001b88:	15fd                	addi	a1,a1,-1
    80001b8a:	05b2                	slli	a1,a1,0xc
    80001b8c:	fffff097          	auipc	ra,0xfffff
    80001b90:	6fa080e7          	jalr	1786(ra) # 80001286 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b94:	4681                	li	a3,0
    80001b96:	4605                	li	a2,1
    80001b98:	020005b7          	lui	a1,0x2000
    80001b9c:	15fd                	addi	a1,a1,-1
    80001b9e:	05b6                	slli	a1,a1,0xd
    80001ba0:	8526                	mv	a0,s1
    80001ba2:	fffff097          	auipc	ra,0xfffff
    80001ba6:	6e4080e7          	jalr	1764(ra) # 80001286 <uvmunmap>
  uvmfree(pagetable, sz);
    80001baa:	85ca                	mv	a1,s2
    80001bac:	8526                	mv	a0,s1
    80001bae:	00000097          	auipc	ra,0x0
    80001bb2:	998080e7          	jalr	-1640(ra) # 80001546 <uvmfree>
}
    80001bb6:	60e2                	ld	ra,24(sp)
    80001bb8:	6442                	ld	s0,16(sp)
    80001bba:	64a2                	ld	s1,8(sp)
    80001bbc:	6902                	ld	s2,0(sp)
    80001bbe:	6105                	addi	sp,sp,32
    80001bc0:	8082                	ret

0000000080001bc2 <freeproc>:
{
    80001bc2:	1101                	addi	sp,sp,-32
    80001bc4:	ec06                	sd	ra,24(sp)
    80001bc6:	e822                	sd	s0,16(sp)
    80001bc8:	e426                	sd	s1,8(sp)
    80001bca:	1000                	addi	s0,sp,32
    80001bcc:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001bce:	6785                	lui	a5,0x1
    80001bd0:	97aa                	add	a5,a5,a0
    80001bd2:	77c8                	ld	a0,168(a5)
    80001bd4:	c509                	beqz	a0,80001bde <freeproc+0x1c>
    kfree((void*)p->trapframe);
    80001bd6:	fffff097          	auipc	ra,0xfffff
    80001bda:	e44080e7          	jalr	-444(ra) # 80000a1a <kfree>
  p->trapframe = 0;
    80001bde:	6785                	lui	a5,0x1
    80001be0:	97a6                	add	a5,a5,s1
    80001be2:	0a07b423          	sd	zero,168(a5) # 10a8 <_entry-0x7fffef58>
  if(p->pagetable)
    80001be6:	73c8                	ld	a0,160(a5)
    80001be8:	c901                	beqz	a0,80001bf8 <freeproc+0x36>
    proc_freepagetable(p->pagetable, p->sz);
    80001bea:	6785                	lui	a5,0x1
    80001bec:	97a6                	add	a5,a5,s1
    80001bee:	6fcc                	ld	a1,152(a5)
    80001bf0:	00000097          	auipc	ra,0x0
    80001bf4:	f80080e7          	jalr	-128(ra) # 80001b70 <proc_freepagetable>
  p->pagetable = 0;
    80001bf8:	6785                	lui	a5,0x1
    80001bfa:	97a6                	add	a5,a5,s1
    80001bfc:	0a07b023          	sd	zero,160(a5) # 10a0 <_entry-0x7fffef60>
  p->sz = 0;
    80001c00:	0807bc23          	sd	zero,152(a5)
  p->pid = 0;
    80001c04:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001c08:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80001c0c:	1a078423          	sb	zero,424(a5)
  p->chan = 0;
    80001c10:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001c14:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001c18:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001c1c:	0004ac23          	sw	zero,24(s1)
}
    80001c20:	60e2                	ld	ra,24(sp)
    80001c22:	6442                	ld	s0,16(sp)
    80001c24:	64a2                	ld	s1,8(sp)
    80001c26:	6105                	addi	sp,sp,32
    80001c28:	8082                	ret

0000000080001c2a <allocproc>:
{
    80001c2a:	7179                	addi	sp,sp,-48
    80001c2c:	f406                	sd	ra,40(sp)
    80001c2e:	f022                	sd	s0,32(sp)
    80001c30:	ec26                	sd	s1,24(sp)
    80001c32:	e84a                	sd	s2,16(sp)
    80001c34:	e44e                	sd	s3,8(sp)
    80001c36:	e052                	sd	s4,0(sp)
    80001c38:	1800                	addi	s0,sp,48
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c3a:	00010497          	auipc	s1,0x10
    80001c3e:	a6e48493          	addi	s1,s1,-1426 # 800116a8 <proc>
    80001c42:	6985                	lui	s3,0x1
    80001c44:	1b898993          	addi	s3,s3,440 # 11b8 <_entry-0x7fffee48>
    80001c48:	00057a17          	auipc	s4,0x57
    80001c4c:	860a0a13          	addi	s4,s4,-1952 # 800584a8 <tickslock>
    acquire(&p->lock);
    80001c50:	8526                	mv	a0,s1
    80001c52:	fffff097          	auipc	ra,0xfffff
    80001c56:	fb4080e7          	jalr	-76(ra) # 80000c06 <acquire>
    if(p->state == UNUSED) {
    80001c5a:	4c9c                	lw	a5,24(s1)
    80001c5c:	cb99                	beqz	a5,80001c72 <allocproc+0x48>
      release(&p->lock);
    80001c5e:	8526                	mv	a0,s1
    80001c60:	fffff097          	auipc	ra,0xfffff
    80001c64:	05a080e7          	jalr	90(ra) # 80000cba <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c68:	94ce                	add	s1,s1,s3
    80001c6a:	ff4493e3          	bne	s1,s4,80001c50 <allocproc+0x26>
  return 0;
    80001c6e:	4481                	li	s1,0
    80001c70:	a8bd                	j	80001cee <allocproc+0xc4>
  p->pid = allocpid();
    80001c72:	00000097          	auipc	ra,0x0
    80001c76:	e1a080e7          	jalr	-486(ra) # 80001a8c <allocpid>
    80001c7a:	dc88                	sw	a0,56(s1)
  p->thrdstop_ticks = 0;
    80001c7c:	0204ae23          	sw	zero,60(s1)
  p->thrdstop_interval = -1;
    80001c80:	57fd                	li	a5,-1
    80001c82:	c0bc                	sw	a5,64(s1)
  for (i = 0; i < MAX_THRD_NUM; i++)
    80001c84:	6705                	lui	a4,0x1
    80001c86:	05070793          	addi	a5,a4,80 # 1050 <_entry-0x7fffefb0>
    80001c8a:	97a6                	add	a5,a5,s1
    80001c8c:	09070713          	addi	a4,a4,144
    80001c90:	00e48933          	add	s2,s1,a4
    p->thrdstop_context_used[i] = 0;
    80001c94:	0007a023          	sw	zero,0(a5)
  for (i = 0; i < MAX_THRD_NUM; i++)
    80001c98:	0791                	addi	a5,a5,4
    80001c9a:	ff279de3          	bne	a5,s2,80001c94 <allocproc+0x6a>
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001c9e:	fffff097          	auipc	ra,0xfffff
    80001ca2:	e78080e7          	jalr	-392(ra) # 80000b16 <kalloc>
    80001ca6:	892a                	mv	s2,a0
    80001ca8:	6785                	lui	a5,0x1
    80001caa:	97a6                	add	a5,a5,s1
    80001cac:	f7c8                	sd	a0,168(a5)
    80001cae:	c929                	beqz	a0,80001d00 <allocproc+0xd6>
  p->pagetable = proc_pagetable(p);
    80001cb0:	8526                	mv	a0,s1
    80001cb2:	00000097          	auipc	ra,0x0
    80001cb6:	e20080e7          	jalr	-480(ra) # 80001ad2 <proc_pagetable>
    80001cba:	892a                	mv	s2,a0
    80001cbc:	6785                	lui	a5,0x1
    80001cbe:	97a6                	add	a5,a5,s1
    80001cc0:	f3c8                	sd	a0,160(a5)
  if(p->pagetable == 0){
    80001cc2:	c531                	beqz	a0,80001d0e <allocproc+0xe4>
  memset(&p->context, 0, sizeof(p->context));
    80001cc4:	6905                	lui	s2,0x1
    80001cc6:	0b090513          	addi	a0,s2,176 # 10b0 <_entry-0x7fffef50>
    80001cca:	07000613          	li	a2,112
    80001cce:	4581                	li	a1,0
    80001cd0:	9526                	add	a0,a0,s1
    80001cd2:	fffff097          	auipc	ra,0xfffff
    80001cd6:	030080e7          	jalr	48(ra) # 80000d02 <memset>
  p->context.ra = (uint64)forkret;
    80001cda:	012487b3          	add	a5,s1,s2
    80001cde:	00000717          	auipc	a4,0x0
    80001ce2:	d6870713          	addi	a4,a4,-664 # 80001a46 <forkret>
    80001ce6:	fbd8                	sd	a4,176(a5)
  p->context.sp = p->kstack + PGSIZE;
    80001ce8:	6bd8                	ld	a4,144(a5)
    80001cea:	974a                	add	a4,a4,s2
    80001cec:	ffd8                	sd	a4,184(a5)
}
    80001cee:	8526                	mv	a0,s1
    80001cf0:	70a2                	ld	ra,40(sp)
    80001cf2:	7402                	ld	s0,32(sp)
    80001cf4:	64e2                	ld	s1,24(sp)
    80001cf6:	6942                	ld	s2,16(sp)
    80001cf8:	69a2                	ld	s3,8(sp)
    80001cfa:	6a02                	ld	s4,0(sp)
    80001cfc:	6145                	addi	sp,sp,48
    80001cfe:	8082                	ret
    release(&p->lock);
    80001d00:	8526                	mv	a0,s1
    80001d02:	fffff097          	auipc	ra,0xfffff
    80001d06:	fb8080e7          	jalr	-72(ra) # 80000cba <release>
    return 0;
    80001d0a:	84ca                	mv	s1,s2
    80001d0c:	b7cd                	j	80001cee <allocproc+0xc4>
    freeproc(p);
    80001d0e:	8526                	mv	a0,s1
    80001d10:	00000097          	auipc	ra,0x0
    80001d14:	eb2080e7          	jalr	-334(ra) # 80001bc2 <freeproc>
    release(&p->lock);
    80001d18:	8526                	mv	a0,s1
    80001d1a:	fffff097          	auipc	ra,0xfffff
    80001d1e:	fa0080e7          	jalr	-96(ra) # 80000cba <release>
    return 0;
    80001d22:	84ca                	mv	s1,s2
    80001d24:	b7e9                	j	80001cee <allocproc+0xc4>

0000000080001d26 <userinit>:
{
    80001d26:	7179                	addi	sp,sp,-48
    80001d28:	f406                	sd	ra,40(sp)
    80001d2a:	f022                	sd	s0,32(sp)
    80001d2c:	ec26                	sd	s1,24(sp)
    80001d2e:	e84a                	sd	s2,16(sp)
    80001d30:	e44e                	sd	s3,8(sp)
    80001d32:	1800                	addi	s0,sp,48
  p = allocproc();
    80001d34:	00000097          	auipc	ra,0x0
    80001d38:	ef6080e7          	jalr	-266(ra) # 80001c2a <allocproc>
    80001d3c:	84aa                	mv	s1,a0
  initproc = p;
    80001d3e:	00007797          	auipc	a5,0x7
    80001d42:	2ca7bd23          	sd	a0,730(a5) # 80009018 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001d46:	6905                	lui	s2,0x1
    80001d48:	012509b3          	add	s3,a0,s2
    80001d4c:	03400613          	li	a2,52
    80001d50:	00007597          	auipc	a1,0x7
    80001d54:	ad058593          	addi	a1,a1,-1328 # 80008820 <initcode>
    80001d58:	0a09b503          	ld	a0,160(s3)
    80001d5c:	fffff097          	auipc	ra,0xfffff
    80001d60:	61c080e7          	jalr	1564(ra) # 80001378 <uvminit>
  p->sz = PGSIZE;
    80001d64:	0929bc23          	sd	s2,152(s3)
  p->trapframe->epc = 0;      // user program counter
    80001d68:	0a89b783          	ld	a5,168(s3)
    80001d6c:	0007bc23          	sd	zero,24(a5)
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001d70:	0a89b783          	ld	a5,168(s3)
    80001d74:	0327b823          	sd	s2,48(a5)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001d78:	1a890513          	addi	a0,s2,424 # 11a8 <_entry-0x7fffee58>
    80001d7c:	4641                	li	a2,16
    80001d7e:	00006597          	auipc	a1,0x6
    80001d82:	46258593          	addi	a1,a1,1122 # 800081e0 <digits+0x1a0>
    80001d86:	9526                	add	a0,a0,s1
    80001d88:	fffff097          	auipc	ra,0xfffff
    80001d8c:	0cc080e7          	jalr	204(ra) # 80000e54 <safestrcpy>
  p->cwd = namei("/");
    80001d90:	00006517          	auipc	a0,0x6
    80001d94:	46050513          	addi	a0,a0,1120 # 800081f0 <digits+0x1b0>
    80001d98:	00002097          	auipc	ra,0x2
    80001d9c:	55a080e7          	jalr	1370(ra) # 800042f2 <namei>
    80001da0:	1aa9b023          	sd	a0,416(s3)
  p->state = RUNNABLE;
    80001da4:	4789                	li	a5,2
    80001da6:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001da8:	8526                	mv	a0,s1
    80001daa:	fffff097          	auipc	ra,0xfffff
    80001dae:	f10080e7          	jalr	-240(ra) # 80000cba <release>
}
    80001db2:	70a2                	ld	ra,40(sp)
    80001db4:	7402                	ld	s0,32(sp)
    80001db6:	64e2                	ld	s1,24(sp)
    80001db8:	6942                	ld	s2,16(sp)
    80001dba:	69a2                	ld	s3,8(sp)
    80001dbc:	6145                	addi	sp,sp,48
    80001dbe:	8082                	ret

0000000080001dc0 <growproc>:
{
    80001dc0:	1101                	addi	sp,sp,-32
    80001dc2:	ec06                	sd	ra,24(sp)
    80001dc4:	e822                	sd	s0,16(sp)
    80001dc6:	e426                	sd	s1,8(sp)
    80001dc8:	e04a                	sd	s2,0(sp)
    80001dca:	1000                	addi	s0,sp,32
    80001dcc:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001dce:	00000097          	auipc	ra,0x0
    80001dd2:	c40080e7          	jalr	-960(ra) # 80001a0e <myproc>
    80001dd6:	84aa                	mv	s1,a0
  sz = p->sz;
    80001dd8:	6785                	lui	a5,0x1
    80001dda:	97aa                	add	a5,a5,a0
    80001ddc:	6fcc                	ld	a1,152(a5)
    80001dde:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001de2:	03204063          	bgtz	s2,80001e02 <growproc+0x42>
  } else if(n < 0){
    80001de6:	04094063          	bltz	s2,80001e26 <growproc+0x66>
  p->sz = sz;
    80001dea:	6505                	lui	a0,0x1
    80001dec:	94aa                	add	s1,s1,a0
    80001dee:	1602                	slli	a2,a2,0x20
    80001df0:	9201                	srli	a2,a2,0x20
    80001df2:	ecd0                	sd	a2,152(s1)
  return 0;
    80001df4:	4501                	li	a0,0
}
    80001df6:	60e2                	ld	ra,24(sp)
    80001df8:	6442                	ld	s0,16(sp)
    80001dfa:	64a2                	ld	s1,8(sp)
    80001dfc:	6902                	ld	s2,0(sp)
    80001dfe:	6105                	addi	sp,sp,32
    80001e00:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001e02:	00c9063b          	addw	a2,s2,a2
    80001e06:	6785                	lui	a5,0x1
    80001e08:	97aa                	add	a5,a5,a0
    80001e0a:	1602                	slli	a2,a2,0x20
    80001e0c:	9201                	srli	a2,a2,0x20
    80001e0e:	1582                	slli	a1,a1,0x20
    80001e10:	9181                	srli	a1,a1,0x20
    80001e12:	73c8                	ld	a0,160(a5)
    80001e14:	fffff097          	auipc	ra,0xfffff
    80001e18:	61e080e7          	jalr	1566(ra) # 80001432 <uvmalloc>
    80001e1c:	0005061b          	sext.w	a2,a0
    80001e20:	f669                	bnez	a2,80001dea <growproc+0x2a>
      return -1;
    80001e22:	557d                	li	a0,-1
    80001e24:	bfc9                	j	80001df6 <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001e26:	00c9063b          	addw	a2,s2,a2
    80001e2a:	6785                	lui	a5,0x1
    80001e2c:	97aa                	add	a5,a5,a0
    80001e2e:	1602                	slli	a2,a2,0x20
    80001e30:	9201                	srli	a2,a2,0x20
    80001e32:	1582                	slli	a1,a1,0x20
    80001e34:	9181                	srli	a1,a1,0x20
    80001e36:	73c8                	ld	a0,160(a5)
    80001e38:	fffff097          	auipc	ra,0xfffff
    80001e3c:	5b2080e7          	jalr	1458(ra) # 800013ea <uvmdealloc>
    80001e40:	0005061b          	sext.w	a2,a0
    80001e44:	b75d                	j	80001dea <growproc+0x2a>

0000000080001e46 <fork>:
{
    80001e46:	7139                	addi	sp,sp,-64
    80001e48:	fc06                	sd	ra,56(sp)
    80001e4a:	f822                	sd	s0,48(sp)
    80001e4c:	f426                	sd	s1,40(sp)
    80001e4e:	f04a                	sd	s2,32(sp)
    80001e50:	ec4e                	sd	s3,24(sp)
    80001e52:	e852                	sd	s4,16(sp)
    80001e54:	e456                	sd	s5,8(sp)
    80001e56:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001e58:	00000097          	auipc	ra,0x0
    80001e5c:	bb6080e7          	jalr	-1098(ra) # 80001a0e <myproc>
    80001e60:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001e62:	00000097          	auipc	ra,0x0
    80001e66:	dc8080e7          	jalr	-568(ra) # 80001c2a <allocproc>
    80001e6a:	10050063          	beqz	a0,80001f6a <fork+0x124>
    80001e6e:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001e70:	6785                	lui	a5,0x1
    80001e72:	00fa8733          	add	a4,s5,a5
    80001e76:	97aa                	add	a5,a5,a0
    80001e78:	6f50                	ld	a2,152(a4)
    80001e7a:	73cc                	ld	a1,160(a5)
    80001e7c:	7348                	ld	a0,160(a4)
    80001e7e:	fffff097          	auipc	ra,0xfffff
    80001e82:	700080e7          	jalr	1792(ra) # 8000157e <uvmcopy>
    80001e86:	04054e63          	bltz	a0,80001ee2 <fork+0x9c>
  np->sz = p->sz;
    80001e8a:	6705                	lui	a4,0x1
    80001e8c:	00ea87b3          	add	a5,s5,a4
    80001e90:	6fd4                	ld	a3,152(a5)
    80001e92:	9752                	add	a4,a4,s4
    80001e94:	ef54                	sd	a3,152(a4)
  np->parent = p;
    80001e96:	035a3023          	sd	s5,32(s4)
  *(np->trapframe) = *(p->trapframe);
    80001e9a:	77d4                	ld	a3,168(a5)
    80001e9c:	87b6                	mv	a5,a3
    80001e9e:	7758                	ld	a4,168(a4)
    80001ea0:	12068693          	addi	a3,a3,288
    80001ea4:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001ea8:	6788                	ld	a0,8(a5)
    80001eaa:	6b8c                	ld	a1,16(a5)
    80001eac:	6f90                	ld	a2,24(a5)
    80001eae:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    80001eb2:	e708                	sd	a0,8(a4)
    80001eb4:	eb0c                	sd	a1,16(a4)
    80001eb6:	ef10                	sd	a2,24(a4)
    80001eb8:	02078793          	addi	a5,a5,32
    80001ebc:	02070713          	addi	a4,a4,32
    80001ec0:	fed792e3          	bne	a5,a3,80001ea4 <fork+0x5e>
  np->trapframe->a0 = 0;
    80001ec4:	6985                	lui	s3,0x1
    80001ec6:	013a07b3          	add	a5,s4,s3
    80001eca:	77dc                	ld	a5,168(a5)
    80001ecc:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001ed0:	12098913          	addi	s2,s3,288 # 1120 <_entry-0x7fffeee0>
    80001ed4:	012a84b3          	add	s1,s5,s2
    80001ed8:	9952                	add	s2,s2,s4
    80001eda:	1a098993          	addi	s3,s3,416
    80001ede:	99d6                	add	s3,s3,s5
    80001ee0:	a00d                	j	80001f02 <fork+0xbc>
    freeproc(np);
    80001ee2:	8552                	mv	a0,s4
    80001ee4:	00000097          	auipc	ra,0x0
    80001ee8:	cde080e7          	jalr	-802(ra) # 80001bc2 <freeproc>
    release(&np->lock);
    80001eec:	8552                	mv	a0,s4
    80001eee:	fffff097          	auipc	ra,0xfffff
    80001ef2:	dcc080e7          	jalr	-564(ra) # 80000cba <release>
    return -1;
    80001ef6:	54fd                	li	s1,-1
    80001ef8:	a8b9                	j	80001f56 <fork+0x110>
  for(i = 0; i < NOFILE; i++)
    80001efa:	04a1                	addi	s1,s1,8
    80001efc:	0921                	addi	s2,s2,8
    80001efe:	01348b63          	beq	s1,s3,80001f14 <fork+0xce>
    if(p->ofile[i])
    80001f02:	6088                	ld	a0,0(s1)
    80001f04:	d97d                	beqz	a0,80001efa <fork+0xb4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001f06:	00003097          	auipc	ra,0x3
    80001f0a:	a8a080e7          	jalr	-1398(ra) # 80004990 <filedup>
    80001f0e:	00a93023          	sd	a0,0(s2)
    80001f12:	b7e5                	j	80001efa <fork+0xb4>
  np->cwd = idup(p->cwd);
    80001f14:	6485                	lui	s1,0x1
    80001f16:	009a87b3          	add	a5,s5,s1
    80001f1a:	1a07b503          	ld	a0,416(a5)
    80001f1e:	00002097          	auipc	ra,0x2
    80001f22:	bde080e7          	jalr	-1058(ra) # 80003afc <idup>
    80001f26:	009a07b3          	add	a5,s4,s1
    80001f2a:	1aa7b023          	sd	a0,416(a5)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001f2e:	1a848513          	addi	a0,s1,424 # 11a8 <_entry-0x7fffee58>
    80001f32:	4641                	li	a2,16
    80001f34:	00aa85b3          	add	a1,s5,a0
    80001f38:	9552                	add	a0,a0,s4
    80001f3a:	fffff097          	auipc	ra,0xfffff
    80001f3e:	f1a080e7          	jalr	-230(ra) # 80000e54 <safestrcpy>
  pid = np->pid;
    80001f42:	038a2483          	lw	s1,56(s4)
  np->state = RUNNABLE;
    80001f46:	4789                	li	a5,2
    80001f48:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001f4c:	8552                	mv	a0,s4
    80001f4e:	fffff097          	auipc	ra,0xfffff
    80001f52:	d6c080e7          	jalr	-660(ra) # 80000cba <release>
}
    80001f56:	8526                	mv	a0,s1
    80001f58:	70e2                	ld	ra,56(sp)
    80001f5a:	7442                	ld	s0,48(sp)
    80001f5c:	74a2                	ld	s1,40(sp)
    80001f5e:	7902                	ld	s2,32(sp)
    80001f60:	69e2                	ld	s3,24(sp)
    80001f62:	6a42                	ld	s4,16(sp)
    80001f64:	6aa2                	ld	s5,8(sp)
    80001f66:	6121                	addi	sp,sp,64
    80001f68:	8082                	ret
    return -1;
    80001f6a:	54fd                	li	s1,-1
    80001f6c:	b7ed                	j	80001f56 <fork+0x110>

0000000080001f6e <reparent>:
{
    80001f6e:	7139                	addi	sp,sp,-64
    80001f70:	fc06                	sd	ra,56(sp)
    80001f72:	f822                	sd	s0,48(sp)
    80001f74:	f426                	sd	s1,40(sp)
    80001f76:	f04a                	sd	s2,32(sp)
    80001f78:	ec4e                	sd	s3,24(sp)
    80001f7a:	e852                	sd	s4,16(sp)
    80001f7c:	e456                	sd	s5,8(sp)
    80001f7e:	0080                	addi	s0,sp,64
    80001f80:	89aa                	mv	s3,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f82:	0000f497          	auipc	s1,0xf
    80001f86:	72648493          	addi	s1,s1,1830 # 800116a8 <proc>
      pp->parent = initproc;
    80001f8a:	00007a97          	auipc	s5,0x7
    80001f8e:	08ea8a93          	addi	s5,s5,142 # 80009018 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f92:	6905                	lui	s2,0x1
    80001f94:	1b890913          	addi	s2,s2,440 # 11b8 <_entry-0x7fffee48>
    80001f98:	00056a17          	auipc	s4,0x56
    80001f9c:	510a0a13          	addi	s4,s4,1296 # 800584a8 <tickslock>
    80001fa0:	a021                	j	80001fa8 <reparent+0x3a>
    80001fa2:	94ca                	add	s1,s1,s2
    80001fa4:	03448363          	beq	s1,s4,80001fca <reparent+0x5c>
    if(pp->parent == p){
    80001fa8:	709c                	ld	a5,32(s1)
    80001faa:	ff379ce3          	bne	a5,s3,80001fa2 <reparent+0x34>
      acquire(&pp->lock);
    80001fae:	8526                	mv	a0,s1
    80001fb0:	fffff097          	auipc	ra,0xfffff
    80001fb4:	c56080e7          	jalr	-938(ra) # 80000c06 <acquire>
      pp->parent = initproc;
    80001fb8:	000ab783          	ld	a5,0(s5)
    80001fbc:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    80001fbe:	8526                	mv	a0,s1
    80001fc0:	fffff097          	auipc	ra,0xfffff
    80001fc4:	cfa080e7          	jalr	-774(ra) # 80000cba <release>
    80001fc8:	bfe9                	j	80001fa2 <reparent+0x34>
}
    80001fca:	70e2                	ld	ra,56(sp)
    80001fcc:	7442                	ld	s0,48(sp)
    80001fce:	74a2                	ld	s1,40(sp)
    80001fd0:	7902                	ld	s2,32(sp)
    80001fd2:	69e2                	ld	s3,24(sp)
    80001fd4:	6a42                	ld	s4,16(sp)
    80001fd6:	6aa2                	ld	s5,8(sp)
    80001fd8:	6121                	addi	sp,sp,64
    80001fda:	8082                	ret

0000000080001fdc <scheduler>:
{
    80001fdc:	715d                	addi	sp,sp,-80
    80001fde:	e486                	sd	ra,72(sp)
    80001fe0:	e0a2                	sd	s0,64(sp)
    80001fe2:	fc26                	sd	s1,56(sp)
    80001fe4:	f84a                	sd	s2,48(sp)
    80001fe6:	f44e                	sd	s3,40(sp)
    80001fe8:	f052                	sd	s4,32(sp)
    80001fea:	ec56                	sd	s5,24(sp)
    80001fec:	e85a                	sd	s6,16(sp)
    80001fee:	e45e                	sd	s7,8(sp)
    80001ff0:	0880                	addi	s0,sp,80
    80001ff2:	8792                	mv	a5,tp
  int id = r_tp();
    80001ff4:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001ff6:	00779b13          	slli	s6,a5,0x7
    80001ffa:	0000f717          	auipc	a4,0xf
    80001ffe:	29670713          	addi	a4,a4,662 # 80011290 <pid_lock>
    80002002:	975a                	add	a4,a4,s6
    80002004:	00073c23          	sd	zero,24(a4)
        swtch(&c->context, &p->context);
    80002008:	0000f717          	auipc	a4,0xf
    8000200c:	2a870713          	addi	a4,a4,680 # 800112b0 <cpus+0x8>
    80002010:	9b3a                	add	s6,s6,a4
        c->proc = p;
    80002012:	079e                	slli	a5,a5,0x7
    80002014:	0000fa97          	auipc	s5,0xf
    80002018:	27ca8a93          	addi	s5,s5,636 # 80011290 <pid_lock>
    8000201c:	9abe                	add	s5,s5,a5
        swtch(&c->context, &p->context);
    8000201e:	6a05                	lui	s4,0x1
    80002020:	0b0a0b93          	addi	s7,s4,176 # 10b0 <_entry-0x7fffef50>
    for(p = proc; p < &proc[NPROC]; p++) {
    80002024:	1b8a0a13          	addi	s4,s4,440
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002028:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000202c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002030:	10079073          	csrw	sstatus,a5
    80002034:	0000f497          	auipc	s1,0xf
    80002038:	67448493          	addi	s1,s1,1652 # 800116a8 <proc>
      if(p->state == RUNNABLE) {
    8000203c:	4989                	li	s3,2
    for(p = proc; p < &proc[NPROC]; p++) {
    8000203e:	00056917          	auipc	s2,0x56
    80002042:	46a90913          	addi	s2,s2,1130 # 800584a8 <tickslock>
    80002046:	a809                	j	80002058 <scheduler+0x7c>
      release(&p->lock);
    80002048:	8526                	mv	a0,s1
    8000204a:	fffff097          	auipc	ra,0xfffff
    8000204e:	c70080e7          	jalr	-912(ra) # 80000cba <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80002052:	94d2                	add	s1,s1,s4
    80002054:	fd248ae3          	beq	s1,s2,80002028 <scheduler+0x4c>
      acquire(&p->lock);
    80002058:	8526                	mv	a0,s1
    8000205a:	fffff097          	auipc	ra,0xfffff
    8000205e:	bac080e7          	jalr	-1108(ra) # 80000c06 <acquire>
      if(p->state == RUNNABLE) {
    80002062:	4c9c                	lw	a5,24(s1)
    80002064:	ff3792e3          	bne	a5,s3,80002048 <scheduler+0x6c>
        p->state = RUNNING;
    80002068:	478d                	li	a5,3
    8000206a:	cc9c                	sw	a5,24(s1)
        c->proc = p;
    8000206c:	009abc23          	sd	s1,24(s5)
        swtch(&c->context, &p->context);
    80002070:	017485b3          	add	a1,s1,s7
    80002074:	855a                	mv	a0,s6
    80002076:	00000097          	auipc	ra,0x0
    8000207a:	76a080e7          	jalr	1898(ra) # 800027e0 <swtch>
        c->proc = 0;
    8000207e:	000abc23          	sd	zero,24(s5)
    80002082:	b7d9                	j	80002048 <scheduler+0x6c>

0000000080002084 <sched>:
{
    80002084:	7179                	addi	sp,sp,-48
    80002086:	f406                	sd	ra,40(sp)
    80002088:	f022                	sd	s0,32(sp)
    8000208a:	ec26                	sd	s1,24(sp)
    8000208c:	e84a                	sd	s2,16(sp)
    8000208e:	e44e                	sd	s3,8(sp)
    80002090:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002092:	00000097          	auipc	ra,0x0
    80002096:	97c080e7          	jalr	-1668(ra) # 80001a0e <myproc>
    8000209a:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000209c:	fffff097          	auipc	ra,0xfffff
    800020a0:	af0080e7          	jalr	-1296(ra) # 80000b8c <holding>
    800020a4:	cd2d                	beqz	a0,8000211e <sched+0x9a>
  asm volatile("mv %0, tp" : "=r" (x) );
    800020a6:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800020a8:	2781                	sext.w	a5,a5
    800020aa:	079e                	slli	a5,a5,0x7
    800020ac:	0000f717          	auipc	a4,0xf
    800020b0:	1e470713          	addi	a4,a4,484 # 80011290 <pid_lock>
    800020b4:	97ba                	add	a5,a5,a4
    800020b6:	0907a703          	lw	a4,144(a5)
    800020ba:	4785                	li	a5,1
    800020bc:	06f71963          	bne	a4,a5,8000212e <sched+0xaa>
  if(p->state == RUNNING)
    800020c0:	4c98                	lw	a4,24(s1)
    800020c2:	478d                	li	a5,3
    800020c4:	06f70d63          	beq	a4,a5,8000213e <sched+0xba>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800020c8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800020cc:	8b89                	andi	a5,a5,2
  if(intr_get())
    800020ce:	e3c1                	bnez	a5,8000214e <sched+0xca>
  asm volatile("mv %0, tp" : "=r" (x) );
    800020d0:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800020d2:	0000f917          	auipc	s2,0xf
    800020d6:	1be90913          	addi	s2,s2,446 # 80011290 <pid_lock>
    800020da:	2781                	sext.w	a5,a5
    800020dc:	079e                	slli	a5,a5,0x7
    800020de:	97ca                	add	a5,a5,s2
    800020e0:	0947a983          	lw	s3,148(a5)
    800020e4:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800020e6:	2781                	sext.w	a5,a5
    800020e8:	079e                	slli	a5,a5,0x7
    800020ea:	0000f597          	auipc	a1,0xf
    800020ee:	1c658593          	addi	a1,a1,454 # 800112b0 <cpus+0x8>
    800020f2:	95be                	add	a1,a1,a5
    800020f4:	6505                	lui	a0,0x1
    800020f6:	0b050513          	addi	a0,a0,176 # 10b0 <_entry-0x7fffef50>
    800020fa:	9526                	add	a0,a0,s1
    800020fc:	00000097          	auipc	ra,0x0
    80002100:	6e4080e7          	jalr	1764(ra) # 800027e0 <swtch>
    80002104:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002106:	2781                	sext.w	a5,a5
    80002108:	079e                	slli	a5,a5,0x7
    8000210a:	97ca                	add	a5,a5,s2
    8000210c:	0937aa23          	sw	s3,148(a5)
}
    80002110:	70a2                	ld	ra,40(sp)
    80002112:	7402                	ld	s0,32(sp)
    80002114:	64e2                	ld	s1,24(sp)
    80002116:	6942                	ld	s2,16(sp)
    80002118:	69a2                	ld	s3,8(sp)
    8000211a:	6145                	addi	sp,sp,48
    8000211c:	8082                	ret
    panic("sched p->lock");
    8000211e:	00006517          	auipc	a0,0x6
    80002122:	0da50513          	addi	a0,a0,218 # 800081f8 <digits+0x1b8>
    80002126:	ffffe097          	auipc	ra,0xffffe
    8000212a:	424080e7          	jalr	1060(ra) # 8000054a <panic>
    panic("sched locks");
    8000212e:	00006517          	auipc	a0,0x6
    80002132:	0da50513          	addi	a0,a0,218 # 80008208 <digits+0x1c8>
    80002136:	ffffe097          	auipc	ra,0xffffe
    8000213a:	414080e7          	jalr	1044(ra) # 8000054a <panic>
    panic("sched running");
    8000213e:	00006517          	auipc	a0,0x6
    80002142:	0da50513          	addi	a0,a0,218 # 80008218 <digits+0x1d8>
    80002146:	ffffe097          	auipc	ra,0xffffe
    8000214a:	404080e7          	jalr	1028(ra) # 8000054a <panic>
    panic("sched interruptible");
    8000214e:	00006517          	auipc	a0,0x6
    80002152:	0da50513          	addi	a0,a0,218 # 80008228 <digits+0x1e8>
    80002156:	ffffe097          	auipc	ra,0xffffe
    8000215a:	3f4080e7          	jalr	1012(ra) # 8000054a <panic>

000000008000215e <exit>:
{
    8000215e:	7179                	addi	sp,sp,-48
    80002160:	f406                	sd	ra,40(sp)
    80002162:	f022                	sd	s0,32(sp)
    80002164:	ec26                	sd	s1,24(sp)
    80002166:	e84a                	sd	s2,16(sp)
    80002168:	e44e                	sd	s3,8(sp)
    8000216a:	e052                	sd	s4,0(sp)
    8000216c:	1800                	addi	s0,sp,48
    8000216e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002170:	00000097          	auipc	ra,0x0
    80002174:	89e080e7          	jalr	-1890(ra) # 80001a0e <myproc>
  if(p == initproc)
    80002178:	00007797          	auipc	a5,0x7
    8000217c:	ea07b783          	ld	a5,-352(a5) # 80009018 <initproc>
    80002180:	00a78b63          	beq	a5,a0,80002196 <exit+0x38>
    80002184:	89aa                	mv	s3,a0
    80002186:	6905                	lui	s2,0x1
    80002188:	12090493          	addi	s1,s2,288 # 1120 <_entry-0x7fffeee0>
    8000218c:	94aa                	add	s1,s1,a0
    8000218e:	1a090913          	addi	s2,s2,416
    80002192:	992a                	add	s2,s2,a0
    80002194:	a015                	j	800021b8 <exit+0x5a>
    panic("init exiting");
    80002196:	00006517          	auipc	a0,0x6
    8000219a:	0aa50513          	addi	a0,a0,170 # 80008240 <digits+0x200>
    8000219e:	ffffe097          	auipc	ra,0xffffe
    800021a2:	3ac080e7          	jalr	940(ra) # 8000054a <panic>
      fileclose(f);
    800021a6:	00003097          	auipc	ra,0x3
    800021aa:	83c080e7          	jalr	-1988(ra) # 800049e2 <fileclose>
      p->ofile[fd] = 0;
    800021ae:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800021b2:	04a1                	addi	s1,s1,8
    800021b4:	01248563          	beq	s1,s2,800021be <exit+0x60>
    if(p->ofile[fd]){
    800021b8:	6088                	ld	a0,0(s1)
    800021ba:	f575                	bnez	a0,800021a6 <exit+0x48>
    800021bc:	bfdd                	j	800021b2 <exit+0x54>
  begin_op();
    800021be:	00002097          	auipc	ra,0x2
    800021c2:	350080e7          	jalr	848(ra) # 8000450e <begin_op>
  iput(p->cwd);
    800021c6:	6485                	lui	s1,0x1
    800021c8:	94ce                	add	s1,s1,s3
    800021ca:	1a04b503          	ld	a0,416(s1) # 11a0 <_entry-0x7fffee60>
    800021ce:	00002097          	auipc	ra,0x2
    800021d2:	b26080e7          	jalr	-1242(ra) # 80003cf4 <iput>
  end_op();
    800021d6:	00002097          	auipc	ra,0x2
    800021da:	3b8080e7          	jalr	952(ra) # 8000458e <end_op>
  p->cwd = 0;
    800021de:	1a04b023          	sd	zero,416(s1)
  acquire(&initproc->lock);
    800021e2:	00007497          	auipc	s1,0x7
    800021e6:	e3648493          	addi	s1,s1,-458 # 80009018 <initproc>
    800021ea:	6088                	ld	a0,0(s1)
    800021ec:	fffff097          	auipc	ra,0xfffff
    800021f0:	a1a080e7          	jalr	-1510(ra) # 80000c06 <acquire>
  wakeup1(initproc);
    800021f4:	6088                	ld	a0,0(s1)
    800021f6:	fffff097          	auipc	ra,0xfffff
    800021fa:	65a080e7          	jalr	1626(ra) # 80001850 <wakeup1>
  release(&initproc->lock);
    800021fe:	6088                	ld	a0,0(s1)
    80002200:	fffff097          	auipc	ra,0xfffff
    80002204:	aba080e7          	jalr	-1350(ra) # 80000cba <release>
  acquire(&p->lock);
    80002208:	854e                	mv	a0,s3
    8000220a:	fffff097          	auipc	ra,0xfffff
    8000220e:	9fc080e7          	jalr	-1540(ra) # 80000c06 <acquire>
  struct proc *original_parent = p->parent;
    80002212:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    80002216:	854e                	mv	a0,s3
    80002218:	fffff097          	auipc	ra,0xfffff
    8000221c:	aa2080e7          	jalr	-1374(ra) # 80000cba <release>
  acquire(&original_parent->lock);
    80002220:	8526                	mv	a0,s1
    80002222:	fffff097          	auipc	ra,0xfffff
    80002226:	9e4080e7          	jalr	-1564(ra) # 80000c06 <acquire>
  acquire(&p->lock);
    8000222a:	854e                	mv	a0,s3
    8000222c:	fffff097          	auipc	ra,0xfffff
    80002230:	9da080e7          	jalr	-1574(ra) # 80000c06 <acquire>
  reparent(p);
    80002234:	854e                	mv	a0,s3
    80002236:	00000097          	auipc	ra,0x0
    8000223a:	d38080e7          	jalr	-712(ra) # 80001f6e <reparent>
  wakeup1(original_parent);
    8000223e:	8526                	mv	a0,s1
    80002240:	fffff097          	auipc	ra,0xfffff
    80002244:	610080e7          	jalr	1552(ra) # 80001850 <wakeup1>
  p->xstate = status;
    80002248:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    8000224c:	4791                	li	a5,4
    8000224e:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    80002252:	8526                	mv	a0,s1
    80002254:	fffff097          	auipc	ra,0xfffff
    80002258:	a66080e7          	jalr	-1434(ra) # 80000cba <release>
  sched();
    8000225c:	00000097          	auipc	ra,0x0
    80002260:	e28080e7          	jalr	-472(ra) # 80002084 <sched>
  panic("zombie exit");
    80002264:	00006517          	auipc	a0,0x6
    80002268:	fec50513          	addi	a0,a0,-20 # 80008250 <digits+0x210>
    8000226c:	ffffe097          	auipc	ra,0xffffe
    80002270:	2de080e7          	jalr	734(ra) # 8000054a <panic>

0000000080002274 <yield>:
{
    80002274:	1101                	addi	sp,sp,-32
    80002276:	ec06                	sd	ra,24(sp)
    80002278:	e822                	sd	s0,16(sp)
    8000227a:	e426                	sd	s1,8(sp)
    8000227c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000227e:	fffff097          	auipc	ra,0xfffff
    80002282:	790080e7          	jalr	1936(ra) # 80001a0e <myproc>
    80002286:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002288:	fffff097          	auipc	ra,0xfffff
    8000228c:	97e080e7          	jalr	-1666(ra) # 80000c06 <acquire>
  p->state = RUNNABLE;
    80002290:	4789                	li	a5,2
    80002292:	cc9c                	sw	a5,24(s1)
  sched();
    80002294:	00000097          	auipc	ra,0x0
    80002298:	df0080e7          	jalr	-528(ra) # 80002084 <sched>
  release(&p->lock);
    8000229c:	8526                	mv	a0,s1
    8000229e:	fffff097          	auipc	ra,0xfffff
    800022a2:	a1c080e7          	jalr	-1508(ra) # 80000cba <release>
}
    800022a6:	60e2                	ld	ra,24(sp)
    800022a8:	6442                	ld	s0,16(sp)
    800022aa:	64a2                	ld	s1,8(sp)
    800022ac:	6105                	addi	sp,sp,32
    800022ae:	8082                	ret

00000000800022b0 <sleep>:
{
    800022b0:	7179                	addi	sp,sp,-48
    800022b2:	f406                	sd	ra,40(sp)
    800022b4:	f022                	sd	s0,32(sp)
    800022b6:	ec26                	sd	s1,24(sp)
    800022b8:	e84a                	sd	s2,16(sp)
    800022ba:	e44e                	sd	s3,8(sp)
    800022bc:	1800                	addi	s0,sp,48
    800022be:	89aa                	mv	s3,a0
    800022c0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800022c2:	fffff097          	auipc	ra,0xfffff
    800022c6:	74c080e7          	jalr	1868(ra) # 80001a0e <myproc>
    800022ca:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    800022cc:	05250663          	beq	a0,s2,80002318 <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    800022d0:	fffff097          	auipc	ra,0xfffff
    800022d4:	936080e7          	jalr	-1738(ra) # 80000c06 <acquire>
    release(lk);
    800022d8:	854a                	mv	a0,s2
    800022da:	fffff097          	auipc	ra,0xfffff
    800022de:	9e0080e7          	jalr	-1568(ra) # 80000cba <release>
  p->chan = chan;
    800022e2:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    800022e6:	4785                	li	a5,1
    800022e8:	cc9c                	sw	a5,24(s1)
  sched();
    800022ea:	00000097          	auipc	ra,0x0
    800022ee:	d9a080e7          	jalr	-614(ra) # 80002084 <sched>
  p->chan = 0;
    800022f2:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    800022f6:	8526                	mv	a0,s1
    800022f8:	fffff097          	auipc	ra,0xfffff
    800022fc:	9c2080e7          	jalr	-1598(ra) # 80000cba <release>
    acquire(lk);
    80002300:	854a                	mv	a0,s2
    80002302:	fffff097          	auipc	ra,0xfffff
    80002306:	904080e7          	jalr	-1788(ra) # 80000c06 <acquire>
}
    8000230a:	70a2                	ld	ra,40(sp)
    8000230c:	7402                	ld	s0,32(sp)
    8000230e:	64e2                	ld	s1,24(sp)
    80002310:	6942                	ld	s2,16(sp)
    80002312:	69a2                	ld	s3,8(sp)
    80002314:	6145                	addi	sp,sp,48
    80002316:	8082                	ret
  p->chan = chan;
    80002318:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    8000231c:	4785                	li	a5,1
    8000231e:	cd1c                	sw	a5,24(a0)
  sched();
    80002320:	00000097          	auipc	ra,0x0
    80002324:	d64080e7          	jalr	-668(ra) # 80002084 <sched>
  p->chan = 0;
    80002328:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    8000232c:	bff9                	j	8000230a <sleep+0x5a>

000000008000232e <wait>:
{
    8000232e:	715d                	addi	sp,sp,-80
    80002330:	e486                	sd	ra,72(sp)
    80002332:	e0a2                	sd	s0,64(sp)
    80002334:	fc26                	sd	s1,56(sp)
    80002336:	f84a                	sd	s2,48(sp)
    80002338:	f44e                	sd	s3,40(sp)
    8000233a:	f052                	sd	s4,32(sp)
    8000233c:	ec56                	sd	s5,24(sp)
    8000233e:	e85a                	sd	s6,16(sp)
    80002340:	e45e                	sd	s7,8(sp)
    80002342:	0880                	addi	s0,sp,80
    80002344:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    80002346:	fffff097          	auipc	ra,0xfffff
    8000234a:	6c8080e7          	jalr	1736(ra) # 80001a0e <myproc>
    8000234e:	892a                	mv	s2,a0
  acquire(&p->lock);
    80002350:	fffff097          	auipc	ra,0xfffff
    80002354:	8b6080e7          	jalr	-1866(ra) # 80000c06 <acquire>
        if(np->state == ZOMBIE){
    80002358:	4a91                	li	s5,4
        havekids = 1;
    8000235a:	4b05                	li	s6,1
    for(np = proc; np < &proc[NPROC]; np++){
    8000235c:	6985                	lui	s3,0x1
    8000235e:	1b898993          	addi	s3,s3,440 # 11b8 <_entry-0x7fffee48>
    80002362:	00056a17          	auipc	s4,0x56
    80002366:	146a0a13          	addi	s4,s4,326 # 800584a8 <tickslock>
    havekids = 0;
    8000236a:	4701                	li	a4,0
    for(np = proc; np < &proc[NPROC]; np++){
    8000236c:	0000f497          	auipc	s1,0xf
    80002370:	33c48493          	addi	s1,s1,828 # 800116a8 <proc>
    80002374:	a08d                	j	800023d6 <wait+0xa8>
          pid = np->pid;
    80002376:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000237a:	000b8f63          	beqz	s7,80002398 <wait+0x6a>
    8000237e:	6785                	lui	a5,0x1
    80002380:	97ca                	add	a5,a5,s2
    80002382:	4691                	li	a3,4
    80002384:	03448613          	addi	a2,s1,52
    80002388:	85de                	mv	a1,s7
    8000238a:	73c8                	ld	a0,160(a5)
    8000238c:	fffff097          	auipc	ra,0xfffff
    80002390:	2f6080e7          	jalr	758(ra) # 80001682 <copyout>
    80002394:	02054263          	bltz	a0,800023b8 <wait+0x8a>
          freeproc(np);
    80002398:	8526                	mv	a0,s1
    8000239a:	00000097          	auipc	ra,0x0
    8000239e:	828080e7          	jalr	-2008(ra) # 80001bc2 <freeproc>
          release(&np->lock);
    800023a2:	8526                	mv	a0,s1
    800023a4:	fffff097          	auipc	ra,0xfffff
    800023a8:	916080e7          	jalr	-1770(ra) # 80000cba <release>
          release(&p->lock);
    800023ac:	854a                	mv	a0,s2
    800023ae:	fffff097          	auipc	ra,0xfffff
    800023b2:	90c080e7          	jalr	-1780(ra) # 80000cba <release>
          return pid;
    800023b6:	a8a1                	j	8000240e <wait+0xe0>
            release(&np->lock);
    800023b8:	8526                	mv	a0,s1
    800023ba:	fffff097          	auipc	ra,0xfffff
    800023be:	900080e7          	jalr	-1792(ra) # 80000cba <release>
            release(&p->lock);
    800023c2:	854a                	mv	a0,s2
    800023c4:	fffff097          	auipc	ra,0xfffff
    800023c8:	8f6080e7          	jalr	-1802(ra) # 80000cba <release>
            return -1;
    800023cc:	59fd                	li	s3,-1
    800023ce:	a081                	j	8000240e <wait+0xe0>
    for(np = proc; np < &proc[NPROC]; np++){
    800023d0:	94ce                	add	s1,s1,s3
    800023d2:	03448463          	beq	s1,s4,800023fa <wait+0xcc>
      if(np->parent == p){
    800023d6:	709c                	ld	a5,32(s1)
    800023d8:	ff279ce3          	bne	a5,s2,800023d0 <wait+0xa2>
        acquire(&np->lock);
    800023dc:	8526                	mv	a0,s1
    800023de:	fffff097          	auipc	ra,0xfffff
    800023e2:	828080e7          	jalr	-2008(ra) # 80000c06 <acquire>
        if(np->state == ZOMBIE){
    800023e6:	4c9c                	lw	a5,24(s1)
    800023e8:	f95787e3          	beq	a5,s5,80002376 <wait+0x48>
        release(&np->lock);
    800023ec:	8526                	mv	a0,s1
    800023ee:	fffff097          	auipc	ra,0xfffff
    800023f2:	8cc080e7          	jalr	-1844(ra) # 80000cba <release>
        havekids = 1;
    800023f6:	875a                	mv	a4,s6
    800023f8:	bfe1                	j	800023d0 <wait+0xa2>
    if(!havekids || p->killed){
    800023fa:	c701                	beqz	a4,80002402 <wait+0xd4>
    800023fc:	03092783          	lw	a5,48(s2)
    80002400:	c39d                	beqz	a5,80002426 <wait+0xf8>
      release(&p->lock);
    80002402:	854a                	mv	a0,s2
    80002404:	fffff097          	auipc	ra,0xfffff
    80002408:	8b6080e7          	jalr	-1866(ra) # 80000cba <release>
      return -1;
    8000240c:	59fd                	li	s3,-1
}
    8000240e:	854e                	mv	a0,s3
    80002410:	60a6                	ld	ra,72(sp)
    80002412:	6406                	ld	s0,64(sp)
    80002414:	74e2                	ld	s1,56(sp)
    80002416:	7942                	ld	s2,48(sp)
    80002418:	79a2                	ld	s3,40(sp)
    8000241a:	7a02                	ld	s4,32(sp)
    8000241c:	6ae2                	ld	s5,24(sp)
    8000241e:	6b42                	ld	s6,16(sp)
    80002420:	6ba2                	ld	s7,8(sp)
    80002422:	6161                	addi	sp,sp,80
    80002424:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    80002426:	85ca                	mv	a1,s2
    80002428:	854a                	mv	a0,s2
    8000242a:	00000097          	auipc	ra,0x0
    8000242e:	e86080e7          	jalr	-378(ra) # 800022b0 <sleep>
    havekids = 0;
    80002432:	bf25                	j	8000236a <wait+0x3c>

0000000080002434 <wakeup>:
{
    80002434:	7139                	addi	sp,sp,-64
    80002436:	fc06                	sd	ra,56(sp)
    80002438:	f822                	sd	s0,48(sp)
    8000243a:	f426                	sd	s1,40(sp)
    8000243c:	f04a                	sd	s2,32(sp)
    8000243e:	ec4e                	sd	s3,24(sp)
    80002440:	e852                	sd	s4,16(sp)
    80002442:	e456                	sd	s5,8(sp)
    80002444:	e05a                	sd	s6,0(sp)
    80002446:	0080                	addi	s0,sp,64
    80002448:	8aaa                	mv	s5,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    8000244a:	0000f497          	auipc	s1,0xf
    8000244e:	25e48493          	addi	s1,s1,606 # 800116a8 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    80002452:	4a05                	li	s4,1
      p->state = RUNNABLE;
    80002454:	4b09                	li	s6,2
  for(p = proc; p < &proc[NPROC]; p++) {
    80002456:	6905                	lui	s2,0x1
    80002458:	1b890913          	addi	s2,s2,440 # 11b8 <_entry-0x7fffee48>
    8000245c:	00056997          	auipc	s3,0x56
    80002460:	04c98993          	addi	s3,s3,76 # 800584a8 <tickslock>
    80002464:	a809                	j	80002476 <wakeup+0x42>
    release(&p->lock);
    80002466:	8526                	mv	a0,s1
    80002468:	fffff097          	auipc	ra,0xfffff
    8000246c:	852080e7          	jalr	-1966(ra) # 80000cba <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002470:	94ca                	add	s1,s1,s2
    80002472:	03348063          	beq	s1,s3,80002492 <wakeup+0x5e>
    acquire(&p->lock);
    80002476:	8526                	mv	a0,s1
    80002478:	ffffe097          	auipc	ra,0xffffe
    8000247c:	78e080e7          	jalr	1934(ra) # 80000c06 <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    80002480:	4c9c                	lw	a5,24(s1)
    80002482:	ff4792e3          	bne	a5,s4,80002466 <wakeup+0x32>
    80002486:	749c                	ld	a5,40(s1)
    80002488:	fd579fe3          	bne	a5,s5,80002466 <wakeup+0x32>
      p->state = RUNNABLE;
    8000248c:	0164ac23          	sw	s6,24(s1)
    80002490:	bfd9                	j	80002466 <wakeup+0x32>
}
    80002492:	70e2                	ld	ra,56(sp)
    80002494:	7442                	ld	s0,48(sp)
    80002496:	74a2                	ld	s1,40(sp)
    80002498:	7902                	ld	s2,32(sp)
    8000249a:	69e2                	ld	s3,24(sp)
    8000249c:	6a42                	ld	s4,16(sp)
    8000249e:	6aa2                	ld	s5,8(sp)
    800024a0:	6b02                	ld	s6,0(sp)
    800024a2:	6121                	addi	sp,sp,64
    800024a4:	8082                	ret

00000000800024a6 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800024a6:	7179                	addi	sp,sp,-48
    800024a8:	f406                	sd	ra,40(sp)
    800024aa:	f022                	sd	s0,32(sp)
    800024ac:	ec26                	sd	s1,24(sp)
    800024ae:	e84a                	sd	s2,16(sp)
    800024b0:	e44e                	sd	s3,8(sp)
    800024b2:	e052                	sd	s4,0(sp)
    800024b4:	1800                	addi	s0,sp,48
    800024b6:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800024b8:	0000f497          	auipc	s1,0xf
    800024bc:	1f048493          	addi	s1,s1,496 # 800116a8 <proc>
    800024c0:	6985                	lui	s3,0x1
    800024c2:	1b898993          	addi	s3,s3,440 # 11b8 <_entry-0x7fffee48>
    800024c6:	00056a17          	auipc	s4,0x56
    800024ca:	fe2a0a13          	addi	s4,s4,-30 # 800584a8 <tickslock>
    acquire(&p->lock);
    800024ce:	8526                	mv	a0,s1
    800024d0:	ffffe097          	auipc	ra,0xffffe
    800024d4:	736080e7          	jalr	1846(ra) # 80000c06 <acquire>
    if(p->pid == pid){
    800024d8:	5c9c                	lw	a5,56(s1)
    800024da:	01278c63          	beq	a5,s2,800024f2 <kill+0x4c>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800024de:	8526                	mv	a0,s1
    800024e0:	ffffe097          	auipc	ra,0xffffe
    800024e4:	7da080e7          	jalr	2010(ra) # 80000cba <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800024e8:	94ce                	add	s1,s1,s3
    800024ea:	ff4492e3          	bne	s1,s4,800024ce <kill+0x28>
  }
  return -1;
    800024ee:	557d                	li	a0,-1
    800024f0:	a821                	j	80002508 <kill+0x62>
      p->killed = 1;
    800024f2:	4785                	li	a5,1
    800024f4:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    800024f6:	4c98                	lw	a4,24(s1)
    800024f8:	02f70063          	beq	a4,a5,80002518 <kill+0x72>
      release(&p->lock);
    800024fc:	8526                	mv	a0,s1
    800024fe:	ffffe097          	auipc	ra,0xffffe
    80002502:	7bc080e7          	jalr	1980(ra) # 80000cba <release>
      return 0;
    80002506:	4501                	li	a0,0
}
    80002508:	70a2                	ld	ra,40(sp)
    8000250a:	7402                	ld	s0,32(sp)
    8000250c:	64e2                	ld	s1,24(sp)
    8000250e:	6942                	ld	s2,16(sp)
    80002510:	69a2                	ld	s3,8(sp)
    80002512:	6a02                	ld	s4,0(sp)
    80002514:	6145                	addi	sp,sp,48
    80002516:	8082                	ret
        p->state = RUNNABLE;
    80002518:	4789                	li	a5,2
    8000251a:	cc9c                	sw	a5,24(s1)
    8000251c:	b7c5                	j	800024fc <kill+0x56>

000000008000251e <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000251e:	7179                	addi	sp,sp,-48
    80002520:	f406                	sd	ra,40(sp)
    80002522:	f022                	sd	s0,32(sp)
    80002524:	ec26                	sd	s1,24(sp)
    80002526:	e84a                	sd	s2,16(sp)
    80002528:	e44e                	sd	s3,8(sp)
    8000252a:	e052                	sd	s4,0(sp)
    8000252c:	1800                	addi	s0,sp,48
    8000252e:	84aa                	mv	s1,a0
    80002530:	892e                	mv	s2,a1
    80002532:	89b2                	mv	s3,a2
    80002534:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002536:	fffff097          	auipc	ra,0xfffff
    8000253a:	4d8080e7          	jalr	1240(ra) # 80001a0e <myproc>
  if(user_dst){
    8000253e:	c09d                	beqz	s1,80002564 <either_copyout+0x46>
    return copyout(p->pagetable, dst, src, len);
    80002540:	6785                	lui	a5,0x1
    80002542:	953e                	add	a0,a0,a5
    80002544:	86d2                	mv	a3,s4
    80002546:	864e                	mv	a2,s3
    80002548:	85ca                	mv	a1,s2
    8000254a:	7148                	ld	a0,160(a0)
    8000254c:	fffff097          	auipc	ra,0xfffff
    80002550:	136080e7          	jalr	310(ra) # 80001682 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002554:	70a2                	ld	ra,40(sp)
    80002556:	7402                	ld	s0,32(sp)
    80002558:	64e2                	ld	s1,24(sp)
    8000255a:	6942                	ld	s2,16(sp)
    8000255c:	69a2                	ld	s3,8(sp)
    8000255e:	6a02                	ld	s4,0(sp)
    80002560:	6145                	addi	sp,sp,48
    80002562:	8082                	ret
    memmove((char *)dst, src, len);
    80002564:	000a061b          	sext.w	a2,s4
    80002568:	85ce                	mv	a1,s3
    8000256a:	854a                	mv	a0,s2
    8000256c:	ffffe097          	auipc	ra,0xffffe
    80002570:	7f2080e7          	jalr	2034(ra) # 80000d5e <memmove>
    return 0;
    80002574:	8526                	mv	a0,s1
    80002576:	bff9                	j	80002554 <either_copyout+0x36>

0000000080002578 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002578:	7179                	addi	sp,sp,-48
    8000257a:	f406                	sd	ra,40(sp)
    8000257c:	f022                	sd	s0,32(sp)
    8000257e:	ec26                	sd	s1,24(sp)
    80002580:	e84a                	sd	s2,16(sp)
    80002582:	e44e                	sd	s3,8(sp)
    80002584:	e052                	sd	s4,0(sp)
    80002586:	1800                	addi	s0,sp,48
    80002588:	892a                	mv	s2,a0
    8000258a:	84ae                	mv	s1,a1
    8000258c:	89b2                	mv	s3,a2
    8000258e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002590:	fffff097          	auipc	ra,0xfffff
    80002594:	47e080e7          	jalr	1150(ra) # 80001a0e <myproc>
  if(user_src){
    80002598:	c09d                	beqz	s1,800025be <either_copyin+0x46>
    return copyin(p->pagetable, dst, src, len);
    8000259a:	6785                	lui	a5,0x1
    8000259c:	97aa                	add	a5,a5,a0
    8000259e:	86d2                	mv	a3,s4
    800025a0:	864e                	mv	a2,s3
    800025a2:	85ca                	mv	a1,s2
    800025a4:	73c8                	ld	a0,160(a5)
    800025a6:	fffff097          	auipc	ra,0xfffff
    800025aa:	168080e7          	jalr	360(ra) # 8000170e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800025ae:	70a2                	ld	ra,40(sp)
    800025b0:	7402                	ld	s0,32(sp)
    800025b2:	64e2                	ld	s1,24(sp)
    800025b4:	6942                	ld	s2,16(sp)
    800025b6:	69a2                	ld	s3,8(sp)
    800025b8:	6a02                	ld	s4,0(sp)
    800025ba:	6145                	addi	sp,sp,48
    800025bc:	8082                	ret
    memmove(dst, (char*)src, len);
    800025be:	000a061b          	sext.w	a2,s4
    800025c2:	85ce                	mv	a1,s3
    800025c4:	854a                	mv	a0,s2
    800025c6:	ffffe097          	auipc	ra,0xffffe
    800025ca:	798080e7          	jalr	1944(ra) # 80000d5e <memmove>
    return 0;
    800025ce:	8526                	mv	a0,s1
    800025d0:	bff9                	j	800025ae <either_copyin+0x36>

00000000800025d2 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800025d2:	715d                	addi	sp,sp,-80
    800025d4:	e486                	sd	ra,72(sp)
    800025d6:	e0a2                	sd	s0,64(sp)
    800025d8:	fc26                	sd	s1,56(sp)
    800025da:	f84a                	sd	s2,48(sp)
    800025dc:	f44e                	sd	s3,40(sp)
    800025de:	f052                	sd	s4,32(sp)
    800025e0:	ec56                	sd	s5,24(sp)
    800025e2:	e85a                	sd	s6,16(sp)
    800025e4:	e45e                	sd	s7,8(sp)
    800025e6:	e062                	sd	s8,0(sp)
    800025e8:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800025ea:	00006517          	auipc	a0,0x6
    800025ee:	ade50513          	addi	a0,a0,-1314 # 800080c8 <digits+0x88>
    800025f2:	ffffe097          	auipc	ra,0xffffe
    800025f6:	fa2080e7          	jalr	-94(ra) # 80000594 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800025fa:	0000f497          	auipc	s1,0xf
    800025fe:	0ae48493          	addi	s1,s1,174 # 800116a8 <proc>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002602:	4b91                	li	s7,4
      state = states[p->state];
    else
      state = "???";
    80002604:	00006a17          	auipc	s4,0x6
    80002608:	c5ca0a13          	addi	s4,s4,-932 # 80008260 <digits+0x220>
    printf("%d %s %s", p->pid, state, p->name);
    8000260c:	6905                	lui	s2,0x1
    8000260e:	1a890b13          	addi	s6,s2,424 # 11a8 <_entry-0x7fffee58>
    80002612:	00006a97          	auipc	s5,0x6
    80002616:	c56a8a93          	addi	s5,s5,-938 # 80008268 <digits+0x228>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000261a:	00006c17          	auipc	s8,0x6
    8000261e:	c86c0c13          	addi	s8,s8,-890 # 800082a0 <states.0>
  for(p = proc; p < &proc[NPROC]; p++){
    80002622:	1b890913          	addi	s2,s2,440
    80002626:	00056997          	auipc	s3,0x56
    8000262a:	e8298993          	addi	s3,s3,-382 # 800584a8 <tickslock>
    8000262e:	a025                	j	80002656 <procdump+0x84>
    printf("%d %s %s", p->pid, state, p->name);
    80002630:	016486b3          	add	a3,s1,s6
    80002634:	5c8c                	lw	a1,56(s1)
    80002636:	8556                	mv	a0,s5
    80002638:	ffffe097          	auipc	ra,0xffffe
    8000263c:	f5c080e7          	jalr	-164(ra) # 80000594 <printf>
    printf("\n");
    80002640:	00006517          	auipc	a0,0x6
    80002644:	a8850513          	addi	a0,a0,-1400 # 800080c8 <digits+0x88>
    80002648:	ffffe097          	auipc	ra,0xffffe
    8000264c:	f4c080e7          	jalr	-180(ra) # 80000594 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002650:	94ca                	add	s1,s1,s2
    80002652:	01348f63          	beq	s1,s3,80002670 <procdump+0x9e>
    if(p->state == UNUSED)
    80002656:	4c9c                	lw	a5,24(s1)
    80002658:	dfe5                	beqz	a5,80002650 <procdump+0x7e>
      state = "???";
    8000265a:	8652                	mv	a2,s4
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000265c:	fcfbeae3          	bltu	s7,a5,80002630 <procdump+0x5e>
    80002660:	1782                	slli	a5,a5,0x20
    80002662:	9381                	srli	a5,a5,0x20
    80002664:	078e                	slli	a5,a5,0x3
    80002666:	97e2                	add	a5,a5,s8
    80002668:	6390                	ld	a2,0(a5)
    8000266a:	f279                	bnez	a2,80002630 <procdump+0x5e>
      state = "???";
    8000266c:	8652                	mv	a2,s4
    8000266e:	b7c9                	j	80002630 <procdump+0x5e>
  }
}
    80002670:	60a6                	ld	ra,72(sp)
    80002672:	6406                	ld	s0,64(sp)
    80002674:	74e2                	ld	s1,56(sp)
    80002676:	7942                	ld	s2,48(sp)
    80002678:	79a2                	ld	s3,40(sp)
    8000267a:	7a02                	ld	s4,32(sp)
    8000267c:	6ae2                	ld	s5,24(sp)
    8000267e:	6b42                	ld	s6,16(sp)
    80002680:	6ba2                	ld	s7,8(sp)
    80002682:	6c02                	ld	s8,0(sp)
    80002684:	6161                	addi	sp,sp,80
    80002686:	8082                	ret

0000000080002688 <store_trapframe>:

void
store_trapframe(struct thrd_context_data *data)
{
    80002688:	1101                	addi	sp,sp,-32
    8000268a:	ec06                	sd	ra,24(sp)
    8000268c:	e822                	sd	s0,16(sp)
    8000268e:	e426                	sd	s1,8(sp)
    80002690:	1000                	addi	s0,sp,32
    80002692:	84aa                	mv	s1,a0
  struct trapframe *tf = myproc()->trapframe;
    80002694:	fffff097          	auipc	ra,0xfffff
    80002698:	37a080e7          	jalr	890(ra) # 80001a0e <myproc>
    8000269c:	6785                	lui	a5,0x1
    8000269e:	953e                	add	a0,a0,a5
    800026a0:	755c                	ld	a5,168(a0)
  data->s_regs[0] = tf->s0;
    800026a2:	73b8                	ld	a4,96(a5)
    800026a4:	e098                	sd	a4,0(s1)
  data->s_regs[1] = tf->s1;
    800026a6:	77b8                	ld	a4,104(a5)
    800026a8:	e498                	sd	a4,8(s1)
  data->s_regs[2] = tf->s2;
    800026aa:	7bd8                	ld	a4,176(a5)
    800026ac:	e898                	sd	a4,16(s1)
  data->s_regs[3] = tf->s3;
    800026ae:	7fd8                	ld	a4,184(a5)
    800026b0:	ec98                	sd	a4,24(s1)
  data->s_regs[4] = tf->s4;
    800026b2:	63f8                	ld	a4,192(a5)
    800026b4:	f098                	sd	a4,32(s1)
  data->s_regs[5] = tf->s5;
    800026b6:	67f8                	ld	a4,200(a5)
    800026b8:	f498                	sd	a4,40(s1)
  data->s_regs[6] = tf->s6;
    800026ba:	6bf8                	ld	a4,208(a5)
    800026bc:	f898                	sd	a4,48(s1)
  data->s_regs[7] = tf->s7;
    800026be:	6ff8                	ld	a4,216(a5)
    800026c0:	fc98                	sd	a4,56(s1)
  data->s_regs[8] = tf->s8;
    800026c2:	73f8                	ld	a4,224(a5)
    800026c4:	e0b8                	sd	a4,64(s1)
  data->s_regs[9] = tf->s9;
    800026c6:	77f8                	ld	a4,232(a5)
    800026c8:	e4b8                	sd	a4,72(s1)
  data->s_regs[10] = tf->s10;
    800026ca:	7bf8                	ld	a4,240(a5)
    800026cc:	e8b8                	sd	a4,80(s1)
  data->s_regs[11] = tf->s11;
    800026ce:	7ff8                	ld	a4,248(a5)
    800026d0:	ecb8                	sd	a4,88(s1)

  data->ra = tf->ra;
    800026d2:	7798                	ld	a4,40(a5)
    800026d4:	f0b8                	sd	a4,96(s1)
  data->sp = tf->sp;
    800026d6:	7b98                	ld	a4,48(a5)
    800026d8:	f4b8                	sd	a4,104(s1)
  data->t_regs[0] = tf->t0;
    800026da:	67b8                	ld	a4,72(a5)
    800026dc:	f8b8                	sd	a4,112(s1)
  data->t_regs[1] = tf->t1;
    800026de:	6bb8                	ld	a4,80(a5)
    800026e0:	fcb8                	sd	a4,120(s1)
  data->t_regs[2] = tf->t2;
    800026e2:	6fb8                	ld	a4,88(a5)
    800026e4:	e0d8                	sd	a4,128(s1)
  data->t_regs[3] = tf->t3;
    800026e6:	1007b703          	ld	a4,256(a5) # 1100 <_entry-0x7fffef00>
    800026ea:	e4d8                	sd	a4,136(s1)
  data->t_regs[4] = tf->t4;
    800026ec:	1087b703          	ld	a4,264(a5)
    800026f0:	e8d8                	sd	a4,144(s1)
  data->t_regs[5] = tf->t5;
    800026f2:	1107b703          	ld	a4,272(a5)
    800026f6:	ecd8                	sd	a4,152(s1)
  data->t_regs[6] = tf->t6;
    800026f8:	1187b703          	ld	a4,280(a5)
    800026fc:	f0d8                	sd	a4,160(s1)

  data->a_regs[0] = tf->a0;
    800026fe:	7bb8                	ld	a4,112(a5)
    80002700:	f4d8                	sd	a4,168(s1)
  data->a_regs[1] = tf->a1;
    80002702:	7fb8                	ld	a4,120(a5)
    80002704:	f8d8                	sd	a4,176(s1)
  data->a_regs[2] = tf->a2;
    80002706:	63d8                	ld	a4,128(a5)
    80002708:	fcd8                	sd	a4,184(s1)
  data->a_regs[3] = tf->a3;
    8000270a:	67d8                	ld	a4,136(a5)
    8000270c:	e0f8                	sd	a4,192(s1)
  data->a_regs[4] = tf->a4;
    8000270e:	6bd8                	ld	a4,144(a5)
    80002710:	e4f8                	sd	a4,200(s1)
  data->a_regs[5] = tf->a5;
    80002712:	6fd8                	ld	a4,152(a5)
    80002714:	e8f8                	sd	a4,208(s1)
  data->a_regs[6] = tf->a6;
    80002716:	73d8                	ld	a4,160(a5)
    80002718:	ecf8                	sd	a4,216(s1)
  data->a_regs[7] = tf->a7;
    8000271a:	77d8                	ld	a4,168(a5)
    8000271c:	f0f8                	sd	a4,224(s1)

  data->gp = tf->gp;
    8000271e:	7f98                	ld	a4,56(a5)
    80002720:	f4f8                	sd	a4,232(s1)
  data->tp = tf->tp;
    80002722:	63b8                	ld	a4,64(a5)
    80002724:	f8f8                	sd	a4,240(s1)
  data->epc = tf->epc;
    80002726:	6f9c                	ld	a5,24(a5)
    80002728:	fcfc                	sd	a5,248(s1)
}
    8000272a:	60e2                	ld	ra,24(sp)
    8000272c:	6442                	ld	s0,16(sp)
    8000272e:	64a2                	ld	s1,8(sp)
    80002730:	6105                	addi	sp,sp,32
    80002732:	8082                	ret

0000000080002734 <restore_trapframe>:


void
restore_trapframe(struct thrd_context_data *data)
{
    80002734:	1101                	addi	sp,sp,-32
    80002736:	ec06                	sd	ra,24(sp)
    80002738:	e822                	sd	s0,16(sp)
    8000273a:	e426                	sd	s1,8(sp)
    8000273c:	1000                	addi	s0,sp,32
    8000273e:	84aa                	mv	s1,a0
  struct trapframe *tf = myproc()->trapframe;
    80002740:	fffff097          	auipc	ra,0xfffff
    80002744:	2ce080e7          	jalr	718(ra) # 80001a0e <myproc>
    80002748:	6785                	lui	a5,0x1
    8000274a:	953e                	add	a0,a0,a5
    8000274c:	755c                	ld	a5,168(a0)
  tf->s0 = data->s_regs[0];
    8000274e:	6098                	ld	a4,0(s1)
    80002750:	f3b8                	sd	a4,96(a5)
  tf->s1 = data->s_regs[1];
    80002752:	6498                	ld	a4,8(s1)
    80002754:	f7b8                	sd	a4,104(a5)
  tf->s2 = data->s_regs[2];
    80002756:	6898                	ld	a4,16(s1)
    80002758:	fbd8                	sd	a4,176(a5)
  tf->s3 = data->s_regs[3];
    8000275a:	6c98                	ld	a4,24(s1)
    8000275c:	ffd8                	sd	a4,184(a5)
  tf->s4 = data->s_regs[4];
    8000275e:	7098                	ld	a4,32(s1)
    80002760:	e3f8                	sd	a4,192(a5)
  tf->s5 = data->s_regs[5];
    80002762:	7498                	ld	a4,40(s1)
    80002764:	e7f8                	sd	a4,200(a5)
  tf->s6 = data->s_regs[6];
    80002766:	7898                	ld	a4,48(s1)
    80002768:	ebf8                	sd	a4,208(a5)
  tf->s7 = data->s_regs[7];
    8000276a:	7c98                	ld	a4,56(s1)
    8000276c:	eff8                	sd	a4,216(a5)
  tf->s8 = data->s_regs[8];
    8000276e:	60b8                	ld	a4,64(s1)
    80002770:	f3f8                	sd	a4,224(a5)
  tf->s9 = data->s_regs[9];
    80002772:	64b8                	ld	a4,72(s1)
    80002774:	f7f8                	sd	a4,232(a5)
  tf->s10 = data->s_regs[10];
    80002776:	68b8                	ld	a4,80(s1)
    80002778:	fbf8                	sd	a4,240(a5)
  tf->s11 = data->s_regs[11];
    8000277a:	6cb8                	ld	a4,88(s1)
    8000277c:	fff8                	sd	a4,248(a5)

  tf->ra = data->ra;
    8000277e:	70b8                	ld	a4,96(s1)
    80002780:	f798                	sd	a4,40(a5)
  tf->sp = data->sp;
    80002782:	74b8                	ld	a4,104(s1)
    80002784:	fb98                	sd	a4,48(a5)
  tf->t0 = data->t_regs[0];
    80002786:	78b8                	ld	a4,112(s1)
    80002788:	e7b8                	sd	a4,72(a5)
  tf->t1 = data->t_regs[1];
    8000278a:	7cb8                	ld	a4,120(s1)
    8000278c:	ebb8                	sd	a4,80(a5)
  tf->t2 = data->t_regs[2];
    8000278e:	60d8                	ld	a4,128(s1)
    80002790:	efb8                	sd	a4,88(a5)
  tf->t3 = data->t_regs[3];
    80002792:	64d8                	ld	a4,136(s1)
    80002794:	10e7b023          	sd	a4,256(a5) # 1100 <_entry-0x7fffef00>
  tf->t4 = data->t_regs[4];
    80002798:	68d8                	ld	a4,144(s1)
    8000279a:	10e7b423          	sd	a4,264(a5)
  tf->t5 = data->t_regs[5];
    8000279e:	6cd8                	ld	a4,152(s1)
    800027a0:	10e7b823          	sd	a4,272(a5)
  tf->t6 = data->t_regs[6];
    800027a4:	70d8                	ld	a4,160(s1)
    800027a6:	10e7bc23          	sd	a4,280(a5)

  tf->a0 = data->a_regs[0];
    800027aa:	74d8                	ld	a4,168(s1)
    800027ac:	fbb8                	sd	a4,112(a5)
  tf->a1 = data->a_regs[1];
    800027ae:	78d8                	ld	a4,176(s1)
    800027b0:	ffb8                	sd	a4,120(a5)
  tf->a2 = data->a_regs[2];
    800027b2:	7cd8                	ld	a4,184(s1)
    800027b4:	e3d8                	sd	a4,128(a5)
  tf->a3 = data->a_regs[3];
    800027b6:	60f8                	ld	a4,192(s1)
    800027b8:	e7d8                	sd	a4,136(a5)
  tf->a4 = data->a_regs[4];
    800027ba:	64f8                	ld	a4,200(s1)
    800027bc:	ebd8                	sd	a4,144(a5)
  tf->a5 = data->a_regs[5];
    800027be:	68f8                	ld	a4,208(s1)
    800027c0:	efd8                	sd	a4,152(a5)
  tf->a6 = data->a_regs[6];
    800027c2:	6cf8                	ld	a4,216(s1)
    800027c4:	f3d8                	sd	a4,160(a5)
  tf->a7 = data->a_regs[7];
    800027c6:	70f8                	ld	a4,224(s1)
    800027c8:	f7d8                	sd	a4,168(a5)

  tf->gp = data->gp;
    800027ca:	74f8                	ld	a4,232(s1)
    800027cc:	ff98                	sd	a4,56(a5)
  tf->tp = data->tp;
    800027ce:	78f8                	ld	a4,240(s1)
    800027d0:	e3b8                	sd	a4,64(a5)
  tf->epc = data->epc;
    800027d2:	7cf8                	ld	a4,248(s1)
    800027d4:	ef98                	sd	a4,24(a5)
    800027d6:	60e2                	ld	ra,24(sp)
    800027d8:	6442                	ld	s0,16(sp)
    800027da:	64a2                	ld	s1,8(sp)
    800027dc:	6105                	addi	sp,sp,32
    800027de:	8082                	ret

00000000800027e0 <swtch>:
    800027e0:	00153023          	sd	ra,0(a0)
    800027e4:	00253423          	sd	sp,8(a0)
    800027e8:	e900                	sd	s0,16(a0)
    800027ea:	ed04                	sd	s1,24(a0)
    800027ec:	03253023          	sd	s2,32(a0)
    800027f0:	03353423          	sd	s3,40(a0)
    800027f4:	03453823          	sd	s4,48(a0)
    800027f8:	03553c23          	sd	s5,56(a0)
    800027fc:	05653023          	sd	s6,64(a0)
    80002800:	05753423          	sd	s7,72(a0)
    80002804:	05853823          	sd	s8,80(a0)
    80002808:	05953c23          	sd	s9,88(a0)
    8000280c:	07a53023          	sd	s10,96(a0)
    80002810:	07b53423          	sd	s11,104(a0)
    80002814:	0005b083          	ld	ra,0(a1)
    80002818:	0085b103          	ld	sp,8(a1)
    8000281c:	6980                	ld	s0,16(a1)
    8000281e:	6d84                	ld	s1,24(a1)
    80002820:	0205b903          	ld	s2,32(a1)
    80002824:	0285b983          	ld	s3,40(a1)
    80002828:	0305ba03          	ld	s4,48(a1)
    8000282c:	0385ba83          	ld	s5,56(a1)
    80002830:	0405bb03          	ld	s6,64(a1)
    80002834:	0485bb83          	ld	s7,72(a1)
    80002838:	0505bc03          	ld	s8,80(a1)
    8000283c:	0585bc83          	ld	s9,88(a1)
    80002840:	0605bd03          	ld	s10,96(a1)
    80002844:	0685bd83          	ld	s11,104(a1)
    80002848:	8082                	ret

000000008000284a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000284a:	1141                	addi	sp,sp,-16
    8000284c:	e406                	sd	ra,8(sp)
    8000284e:	e022                	sd	s0,0(sp)
    80002850:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002852:	00006597          	auipc	a1,0x6
    80002856:	a7658593          	addi	a1,a1,-1418 # 800082c8 <states.0+0x28>
    8000285a:	00056517          	auipc	a0,0x56
    8000285e:	c4e50513          	addi	a0,a0,-946 # 800584a8 <tickslock>
    80002862:	ffffe097          	auipc	ra,0xffffe
    80002866:	314080e7          	jalr	788(ra) # 80000b76 <initlock>
}
    8000286a:	60a2                	ld	ra,8(sp)
    8000286c:	6402                	ld	s0,0(sp)
    8000286e:	0141                	addi	sp,sp,16
    80002870:	8082                	ret

0000000080002872 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002872:	1141                	addi	sp,sp,-16
    80002874:	e422                	sd	s0,8(sp)
    80002876:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002878:	00003797          	auipc	a5,0x3
    8000287c:	7f878793          	addi	a5,a5,2040 # 80006070 <kernelvec>
    80002880:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002884:	6422                	ld	s0,8(sp)
    80002886:	0141                	addi	sp,sp,16
    80002888:	8082                	ret

000000008000288a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000288a:	1141                	addi	sp,sp,-16
    8000288c:	e406                	sd	ra,8(sp)
    8000288e:	e022                	sd	s0,0(sp)
    80002890:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002892:	fffff097          	auipc	ra,0xfffff
    80002896:	17c080e7          	jalr	380(ra) # 80001a0e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000289a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000289e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800028a0:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    800028a4:	00004617          	auipc	a2,0x4
    800028a8:	75c60613          	addi	a2,a2,1884 # 80007000 <_trampoline>
    800028ac:	00004697          	auipc	a3,0x4
    800028b0:	75468693          	addi	a3,a3,1876 # 80007000 <_trampoline>
    800028b4:	8e91                	sub	a3,a3,a2
    800028b6:	040007b7          	lui	a5,0x4000
    800028ba:	17fd                	addi	a5,a5,-1
    800028bc:	07b2                	slli	a5,a5,0xc
    800028be:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800028c0:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800028c4:	6705                	lui	a4,0x1
    800028c6:	953a                	add	a0,a0,a4
    800028c8:	7554                	ld	a3,168(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800028ca:	180025f3          	csrr	a1,satp
    800028ce:	e28c                	sd	a1,0(a3)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800028d0:	754c                	ld	a1,168(a0)
    800028d2:	6954                	ld	a3,144(a0)
    800028d4:	96ba                	add	a3,a3,a4
    800028d6:	e594                	sd	a3,8(a1)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800028d8:	7558                	ld	a4,168(a0)
    800028da:	00000697          	auipc	a3,0x0
    800028de:	13868693          	addi	a3,a3,312 # 80002a12 <usertrap>
    800028e2:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800028e4:	7558                	ld	a4,168(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800028e6:	8692                	mv	a3,tp
    800028e8:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028ea:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800028ee:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800028f2:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800028f6:	10069073          	csrw	sstatus,a3
  w_sstatus(x);


  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800028fa:	7558                	ld	a4,168(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800028fc:	6f18                	ld	a4,24(a4)
    800028fe:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002902:	714c                	ld	a1,160(a0)
    80002904:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002906:	00004717          	auipc	a4,0x4
    8000290a:	78a70713          	addi	a4,a4,1930 # 80007090 <userret>
    8000290e:	8f11                	sub	a4,a4,a2
    80002910:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80002912:	577d                	li	a4,-1
    80002914:	177e                	slli	a4,a4,0x3f
    80002916:	8dd9                	or	a1,a1,a4
    80002918:	02000537          	lui	a0,0x2000
    8000291c:	157d                	addi	a0,a0,-1
    8000291e:	0536                	slli	a0,a0,0xd
    80002920:	9782                	jalr	a5
}
    80002922:	60a2                	ld	ra,8(sp)
    80002924:	6402                	ld	s0,0(sp)
    80002926:	0141                	addi	sp,sp,16
    80002928:	8082                	ret

000000008000292a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000292a:	1101                	addi	sp,sp,-32
    8000292c:	ec06                	sd	ra,24(sp)
    8000292e:	e822                	sd	s0,16(sp)
    80002930:	e426                	sd	s1,8(sp)
    80002932:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002934:	00056497          	auipc	s1,0x56
    80002938:	b7448493          	addi	s1,s1,-1164 # 800584a8 <tickslock>
    8000293c:	8526                	mv	a0,s1
    8000293e:	ffffe097          	auipc	ra,0xffffe
    80002942:	2c8080e7          	jalr	712(ra) # 80000c06 <acquire>
  ticks++;
    80002946:	00006517          	auipc	a0,0x6
    8000294a:	6da50513          	addi	a0,a0,1754 # 80009020 <ticks>
    8000294e:	411c                	lw	a5,0(a0)
    80002950:	2785                	addiw	a5,a5,1
    80002952:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002954:	00000097          	auipc	ra,0x0
    80002958:	ae0080e7          	jalr	-1312(ra) # 80002434 <wakeup>
  release(&tickslock);
    8000295c:	8526                	mv	a0,s1
    8000295e:	ffffe097          	auipc	ra,0xffffe
    80002962:	35c080e7          	jalr	860(ra) # 80000cba <release>
}
    80002966:	60e2                	ld	ra,24(sp)
    80002968:	6442                	ld	s0,16(sp)
    8000296a:	64a2                	ld	s1,8(sp)
    8000296c:	6105                	addi	sp,sp,32
    8000296e:	8082                	ret

0000000080002970 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002970:	1101                	addi	sp,sp,-32
    80002972:	ec06                	sd	ra,24(sp)
    80002974:	e822                	sd	s0,16(sp)
    80002976:	e426                	sd	s1,8(sp)
    80002978:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000297a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    8000297e:	00074d63          	bltz	a4,80002998 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80002982:	57fd                	li	a5,-1
    80002984:	17fe                	slli	a5,a5,0x3f
    80002986:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002988:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    8000298a:	06f70363          	beq	a4,a5,800029f0 <devintr+0x80>
  }
}
    8000298e:	60e2                	ld	ra,24(sp)
    80002990:	6442                	ld	s0,16(sp)
    80002992:	64a2                	ld	s1,8(sp)
    80002994:	6105                	addi	sp,sp,32
    80002996:	8082                	ret
     (scause & 0xff) == 9){
    80002998:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    8000299c:	46a5                	li	a3,9
    8000299e:	fed792e3          	bne	a5,a3,80002982 <devintr+0x12>
    int irq = plic_claim();
    800029a2:	00003097          	auipc	ra,0x3
    800029a6:	7d6080e7          	jalr	2006(ra) # 80006178 <plic_claim>
    800029aa:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800029ac:	47a9                	li	a5,10
    800029ae:	02f50763          	beq	a0,a5,800029dc <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    800029b2:	4785                	li	a5,1
    800029b4:	02f50963          	beq	a0,a5,800029e6 <devintr+0x76>
    return 1;
    800029b8:	4505                	li	a0,1
    } else if(irq){
    800029ba:	d8f1                	beqz	s1,8000298e <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    800029bc:	85a6                	mv	a1,s1
    800029be:	00006517          	auipc	a0,0x6
    800029c2:	91250513          	addi	a0,a0,-1774 # 800082d0 <states.0+0x30>
    800029c6:	ffffe097          	auipc	ra,0xffffe
    800029ca:	bce080e7          	jalr	-1074(ra) # 80000594 <printf>
      plic_complete(irq);
    800029ce:	8526                	mv	a0,s1
    800029d0:	00003097          	auipc	ra,0x3
    800029d4:	7cc080e7          	jalr	1996(ra) # 8000619c <plic_complete>
    return 1;
    800029d8:	4505                	li	a0,1
    800029da:	bf55                	j	8000298e <devintr+0x1e>
      uartintr();
    800029dc:	ffffe097          	auipc	ra,0xffffe
    800029e0:	fee080e7          	jalr	-18(ra) # 800009ca <uartintr>
    800029e4:	b7ed                	j	800029ce <devintr+0x5e>
      virtio_disk_intr();
    800029e6:	00004097          	auipc	ra,0x4
    800029ea:	c48080e7          	jalr	-952(ra) # 8000662e <virtio_disk_intr>
    800029ee:	b7c5                	j	800029ce <devintr+0x5e>
    if(cpuid() == 0){
    800029f0:	fffff097          	auipc	ra,0xfffff
    800029f4:	ff2080e7          	jalr	-14(ra) # 800019e2 <cpuid>
    800029f8:	c901                	beqz	a0,80002a08 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    800029fa:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    800029fe:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002a00:	14479073          	csrw	sip,a5
    return 2;
    80002a04:	4509                	li	a0,2
    80002a06:	b761                	j	8000298e <devintr+0x1e>
      clockintr();
    80002a08:	00000097          	auipc	ra,0x0
    80002a0c:	f22080e7          	jalr	-222(ra) # 8000292a <clockintr>
    80002a10:	b7ed                	j	800029fa <devintr+0x8a>

0000000080002a12 <usertrap>:
{
    80002a12:	1101                	addi	sp,sp,-32
    80002a14:	ec06                	sd	ra,24(sp)
    80002a16:	e822                	sd	s0,16(sp)
    80002a18:	e426                	sd	s1,8(sp)
    80002a1a:	e04a                	sd	s2,0(sp)
    80002a1c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a1e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002a22:	1007f793          	andi	a5,a5,256
    80002a26:	e7ad                	bnez	a5,80002a90 <usertrap+0x7e>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002a28:	00003797          	auipc	a5,0x3
    80002a2c:	64878793          	addi	a5,a5,1608 # 80006070 <kernelvec>
    80002a30:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002a34:	fffff097          	auipc	ra,0xfffff
    80002a38:	fda080e7          	jalr	-38(ra) # 80001a0e <myproc>
    80002a3c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002a3e:	6785                	lui	a5,0x1
    80002a40:	97aa                	add	a5,a5,a0
    80002a42:	77dc                	ld	a5,168(a5)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a44:	14102773          	csrr	a4,sepc
    80002a48:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a4a:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002a4e:	47a1                	li	a5,8
    80002a50:	04f71e63          	bne	a4,a5,80002aac <usertrap+0x9a>
    if(p->killed)
    80002a54:	591c                	lw	a5,48(a0)
    80002a56:	e7a9                	bnez	a5,80002aa0 <usertrap+0x8e>
    p->trapframe->epc += 4;
    80002a58:	6785                	lui	a5,0x1
    80002a5a:	97a6                	add	a5,a5,s1
    80002a5c:	77d8                	ld	a4,168(a5)
    80002a5e:	6f1c                	ld	a5,24(a4)
    80002a60:	0791                	addi	a5,a5,4
    80002a62:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a64:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002a68:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a6c:	10079073          	csrw	sstatus,a5
    syscall();
    80002a70:	00000097          	auipc	ra,0x0
    80002a74:	37e080e7          	jalr	894(ra) # 80002dee <syscall>
  if(p->killed)
    80002a78:	589c                	lw	a5,48(s1)
    80002a7a:	e3c5                	bnez	a5,80002b1a <usertrap+0x108>
  usertrapret();
    80002a7c:	00000097          	auipc	ra,0x0
    80002a80:	e0e080e7          	jalr	-498(ra) # 8000288a <usertrapret>
}
    80002a84:	60e2                	ld	ra,24(sp)
    80002a86:	6442                	ld	s0,16(sp)
    80002a88:	64a2                	ld	s1,8(sp)
    80002a8a:	6902                	ld	s2,0(sp)
    80002a8c:	6105                	addi	sp,sp,32
    80002a8e:	8082                	ret
    panic("usertrap: not from user mode");
    80002a90:	00006517          	auipc	a0,0x6
    80002a94:	86050513          	addi	a0,a0,-1952 # 800082f0 <states.0+0x50>
    80002a98:	ffffe097          	auipc	ra,0xffffe
    80002a9c:	ab2080e7          	jalr	-1358(ra) # 8000054a <panic>
      exit(-1);
    80002aa0:	557d                	li	a0,-1
    80002aa2:	fffff097          	auipc	ra,0xfffff
    80002aa6:	6bc080e7          	jalr	1724(ra) # 8000215e <exit>
    80002aaa:	b77d                	j	80002a58 <usertrap+0x46>
  } else if((which_dev = devintr()) != 0){
    80002aac:	00000097          	auipc	ra,0x0
    80002ab0:	ec4080e7          	jalr	-316(ra) # 80002970 <devintr>
    80002ab4:	892a                	mv	s2,a0
    80002ab6:	c501                	beqz	a0,80002abe <usertrap+0xac>
  if(p->killed)
    80002ab8:	589c                	lw	a5,48(s1)
    80002aba:	c3a1                	beqz	a5,80002afa <usertrap+0xe8>
    80002abc:	a815                	j	80002af0 <usertrap+0xde>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002abe:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002ac2:	5c90                	lw	a2,56(s1)
    80002ac4:	00006517          	auipc	a0,0x6
    80002ac8:	84c50513          	addi	a0,a0,-1972 # 80008310 <states.0+0x70>
    80002acc:	ffffe097          	auipc	ra,0xffffe
    80002ad0:	ac8080e7          	jalr	-1336(ra) # 80000594 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ad4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002ad8:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002adc:	00006517          	auipc	a0,0x6
    80002ae0:	86450513          	addi	a0,a0,-1948 # 80008340 <states.0+0xa0>
    80002ae4:	ffffe097          	auipc	ra,0xffffe
    80002ae8:	ab0080e7          	jalr	-1360(ra) # 80000594 <printf>
    p->killed = 1;
    80002aec:	4785                	li	a5,1
    80002aee:	d89c                	sw	a5,48(s1)
    exit(-1);
    80002af0:	557d                	li	a0,-1
    80002af2:	fffff097          	auipc	ra,0xfffff
    80002af6:	66c080e7          	jalr	1644(ra) # 8000215e <exit>
  if(which_dev == 2)
    80002afa:	4789                	li	a5,2
    80002afc:	f8f910e3          	bne	s2,a5,80002a7c <usertrap+0x6a>
    p->thrdstop_ticks ++;
    80002b00:	5cdc                	lw	a5,60(s1)
    80002b02:	2785                	addiw	a5,a5,1
    80002b04:	0007871b          	sext.w	a4,a5
    80002b08:	dcdc                	sw	a5,60(s1)
    if(p->thrdstop_ticks == p->thrdstop_interval){
    80002b0a:	40bc                	lw	a5,64(s1)
    80002b0c:	00e78963          	beq	a5,a4,80002b1e <usertrap+0x10c>
    yield();
    80002b10:	fffff097          	auipc	ra,0xfffff
    80002b14:	764080e7          	jalr	1892(ra) # 80002274 <yield>
    80002b18:	b795                	j	80002a7c <usertrap+0x6a>
  int which_dev = 0;
    80002b1a:	4901                	li	s2,0
    80002b1c:	bfd1                	j	80002af0 <usertrap+0xde>
      store_trapframe(&(p->thrdstop_context[p->thrdstop_context_id]));
    80002b1e:	40e8                	lw	a0,68(s1)
    80002b20:	0522                	slli	a0,a0,0x8
    80002b22:	05050513          	addi	a0,a0,80
    80002b26:	9526                	add	a0,a0,s1
    80002b28:	00000097          	auipc	ra,0x0
    80002b2c:	b60080e7          	jalr	-1184(ra) # 80002688 <store_trapframe>
      p->trapframe->epc = p->thrdstop_handler_pointer; // not sure
    80002b30:	6785                	lui	a5,0x1
    80002b32:	97a6                	add	a5,a5,s1
    80002b34:	77dc                	ld	a5,168(a5)
    80002b36:	64b8                	ld	a4,72(s1)
    80002b38:	ef98                	sd	a4,24(a5)
      p->thrdstop_ticks = 0;
    80002b3a:	0204ae23          	sw	zero,60(s1)
      p->thrdstop_interval = -1;
    80002b3e:	57fd                	li	a5,-1
    80002b40:	c0bc                	sw	a5,64(s1)
    80002b42:	b7f9                	j	80002b10 <usertrap+0xfe>

0000000080002b44 <kerneltrap>:
{
    80002b44:	7179                	addi	sp,sp,-48
    80002b46:	f406                	sd	ra,40(sp)
    80002b48:	f022                	sd	s0,32(sp)
    80002b4a:	ec26                	sd	s1,24(sp)
    80002b4c:	e84a                	sd	s2,16(sp)
    80002b4e:	e44e                	sd	s3,8(sp)
    80002b50:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002b52:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b56:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002b5a:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002b5e:	1004f793          	andi	a5,s1,256
    80002b62:	cb85                	beqz	a5,80002b92 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b64:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002b68:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002b6a:	ef85                	bnez	a5,80002ba2 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002b6c:	00000097          	auipc	ra,0x0
    80002b70:	e04080e7          	jalr	-508(ra) # 80002970 <devintr>
    80002b74:	cd1d                	beqz	a0,80002bb2 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002b76:	4789                	li	a5,2
    80002b78:	06f50a63          	beq	a0,a5,80002bec <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002b7c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002b80:	10049073          	csrw	sstatus,s1
}
    80002b84:	70a2                	ld	ra,40(sp)
    80002b86:	7402                	ld	s0,32(sp)
    80002b88:	64e2                	ld	s1,24(sp)
    80002b8a:	6942                	ld	s2,16(sp)
    80002b8c:	69a2                	ld	s3,8(sp)
    80002b8e:	6145                	addi	sp,sp,48
    80002b90:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002b92:	00005517          	auipc	a0,0x5
    80002b96:	7ce50513          	addi	a0,a0,1998 # 80008360 <states.0+0xc0>
    80002b9a:	ffffe097          	auipc	ra,0xffffe
    80002b9e:	9b0080e7          	jalr	-1616(ra) # 8000054a <panic>
    panic("kerneltrap: interrupts enabled");
    80002ba2:	00005517          	auipc	a0,0x5
    80002ba6:	7e650513          	addi	a0,a0,2022 # 80008388 <states.0+0xe8>
    80002baa:	ffffe097          	auipc	ra,0xffffe
    80002bae:	9a0080e7          	jalr	-1632(ra) # 8000054a <panic>
    printf("scause %p\n", scause);
    80002bb2:	85ce                	mv	a1,s3
    80002bb4:	00005517          	auipc	a0,0x5
    80002bb8:	7f450513          	addi	a0,a0,2036 # 800083a8 <states.0+0x108>
    80002bbc:	ffffe097          	auipc	ra,0xffffe
    80002bc0:	9d8080e7          	jalr	-1576(ra) # 80000594 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002bc4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002bc8:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002bcc:	00005517          	auipc	a0,0x5
    80002bd0:	7ec50513          	addi	a0,a0,2028 # 800083b8 <states.0+0x118>
    80002bd4:	ffffe097          	auipc	ra,0xffffe
    80002bd8:	9c0080e7          	jalr	-1600(ra) # 80000594 <printf>
    panic("kerneltrap");
    80002bdc:	00005517          	auipc	a0,0x5
    80002be0:	7f450513          	addi	a0,a0,2036 # 800083d0 <states.0+0x130>
    80002be4:	ffffe097          	auipc	ra,0xffffe
    80002be8:	966080e7          	jalr	-1690(ra) # 8000054a <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002bec:	fffff097          	auipc	ra,0xfffff
    80002bf0:	e22080e7          	jalr	-478(ra) # 80001a0e <myproc>
    80002bf4:	d541                	beqz	a0,80002b7c <kerneltrap+0x38>
    80002bf6:	fffff097          	auipc	ra,0xfffff
    80002bfa:	e18080e7          	jalr	-488(ra) # 80001a0e <myproc>
    80002bfe:	4d18                	lw	a4,24(a0)
    80002c00:	478d                	li	a5,3
    80002c02:	f6f71de3          	bne	a4,a5,80002b7c <kerneltrap+0x38>
    struct proc *p = myproc();
    80002c06:	fffff097          	auipc	ra,0xfffff
    80002c0a:	e08080e7          	jalr	-504(ra) # 80001a0e <myproc>
    80002c0e:	89aa                	mv	s3,a0
    p->thrdstop_ticks ++;
    80002c10:	5d5c                	lw	a5,60(a0)
    80002c12:	2785                	addiw	a5,a5,1
    80002c14:	0007871b          	sext.w	a4,a5
    80002c18:	dd5c                	sw	a5,60(a0)
    if(p->thrdstop_ticks == p->thrdstop_interval){
    80002c1a:	413c                	lw	a5,64(a0)
    80002c1c:	00e78763          	beq	a5,a4,80002c2a <kerneltrap+0xe6>
    yield();
    80002c20:	fffff097          	auipc	ra,0xfffff
    80002c24:	654080e7          	jalr	1620(ra) # 80002274 <yield>
    80002c28:	bf91                	j	80002b7c <kerneltrap+0x38>
      store_trapframe(&(p->thrdstop_context[p->thrdstop_context_id]));
    80002c2a:	4168                	lw	a0,68(a0)
    80002c2c:	0522                	slli	a0,a0,0x8
    80002c2e:	05050513          	addi	a0,a0,80
    80002c32:	954e                	add	a0,a0,s3
    80002c34:	00000097          	auipc	ra,0x0
    80002c38:	a54080e7          	jalr	-1452(ra) # 80002688 <store_trapframe>
      p->trapframe->epc = p->thrdstop_handler_pointer; // not sure
    80002c3c:	6785                	lui	a5,0x1
    80002c3e:	97ce                	add	a5,a5,s3
    80002c40:	77dc                	ld	a5,168(a5)
    80002c42:	0489b703          	ld	a4,72(s3)
    80002c46:	ef98                	sd	a4,24(a5)
      p->thrdstop_ticks = 0;
    80002c48:	0209ae23          	sw	zero,60(s3)
      p->thrdstop_interval = -1;
    80002c4c:	57fd                	li	a5,-1
    80002c4e:	04f9a023          	sw	a5,64(s3)
    80002c52:	b7f9                	j	80002c20 <kerneltrap+0xdc>

0000000080002c54 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002c54:	1101                	addi	sp,sp,-32
    80002c56:	ec06                	sd	ra,24(sp)
    80002c58:	e822                	sd	s0,16(sp)
    80002c5a:	e426                	sd	s1,8(sp)
    80002c5c:	1000                	addi	s0,sp,32
    80002c5e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002c60:	fffff097          	auipc	ra,0xfffff
    80002c64:	dae080e7          	jalr	-594(ra) # 80001a0e <myproc>
  switch (n) {
    80002c68:	4795                	li	a5,5
    80002c6a:	0497ed63          	bltu	a5,s1,80002cc4 <argraw+0x70>
    80002c6e:	048a                	slli	s1,s1,0x2
    80002c70:	00005717          	auipc	a4,0x5
    80002c74:	79870713          	addi	a4,a4,1944 # 80008408 <states.0+0x168>
    80002c78:	94ba                	add	s1,s1,a4
    80002c7a:	409c                	lw	a5,0(s1)
    80002c7c:	97ba                	add	a5,a5,a4
    80002c7e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002c80:	6785                	lui	a5,0x1
    80002c82:	953e                	add	a0,a0,a5
    80002c84:	755c                	ld	a5,168(a0)
    80002c86:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002c88:	60e2                	ld	ra,24(sp)
    80002c8a:	6442                	ld	s0,16(sp)
    80002c8c:	64a2                	ld	s1,8(sp)
    80002c8e:	6105                	addi	sp,sp,32
    80002c90:	8082                	ret
    return p->trapframe->a1;
    80002c92:	6785                	lui	a5,0x1
    80002c94:	953e                	add	a0,a0,a5
    80002c96:	755c                	ld	a5,168(a0)
    80002c98:	7fa8                	ld	a0,120(a5)
    80002c9a:	b7fd                	j	80002c88 <argraw+0x34>
    return p->trapframe->a2;
    80002c9c:	6785                	lui	a5,0x1
    80002c9e:	953e                	add	a0,a0,a5
    80002ca0:	755c                	ld	a5,168(a0)
    80002ca2:	63c8                	ld	a0,128(a5)
    80002ca4:	b7d5                	j	80002c88 <argraw+0x34>
    return p->trapframe->a3;
    80002ca6:	6785                	lui	a5,0x1
    80002ca8:	953e                	add	a0,a0,a5
    80002caa:	755c                	ld	a5,168(a0)
    80002cac:	67c8                	ld	a0,136(a5)
    80002cae:	bfe9                	j	80002c88 <argraw+0x34>
    return p->trapframe->a4;
    80002cb0:	6785                	lui	a5,0x1
    80002cb2:	953e                	add	a0,a0,a5
    80002cb4:	755c                	ld	a5,168(a0)
    80002cb6:	6bc8                	ld	a0,144(a5)
    80002cb8:	bfc1                	j	80002c88 <argraw+0x34>
    return p->trapframe->a5;
    80002cba:	6785                	lui	a5,0x1
    80002cbc:	953e                	add	a0,a0,a5
    80002cbe:	755c                	ld	a5,168(a0)
    80002cc0:	6fc8                	ld	a0,152(a5)
    80002cc2:	b7d9                	j	80002c88 <argraw+0x34>
  panic("argraw");
    80002cc4:	00005517          	auipc	a0,0x5
    80002cc8:	71c50513          	addi	a0,a0,1820 # 800083e0 <states.0+0x140>
    80002ccc:	ffffe097          	auipc	ra,0xffffe
    80002cd0:	87e080e7          	jalr	-1922(ra) # 8000054a <panic>

0000000080002cd4 <fetchaddr>:
{
    80002cd4:	1101                	addi	sp,sp,-32
    80002cd6:	ec06                	sd	ra,24(sp)
    80002cd8:	e822                	sd	s0,16(sp)
    80002cda:	e426                	sd	s1,8(sp)
    80002cdc:	e04a                	sd	s2,0(sp)
    80002cde:	1000                	addi	s0,sp,32
    80002ce0:	84aa                	mv	s1,a0
    80002ce2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002ce4:	fffff097          	auipc	ra,0xfffff
    80002ce8:	d2a080e7          	jalr	-726(ra) # 80001a0e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002cec:	6785                	lui	a5,0x1
    80002cee:	97aa                	add	a5,a5,a0
    80002cf0:	6fdc                	ld	a5,152(a5)
    80002cf2:	02f4fa63          	bgeu	s1,a5,80002d26 <fetchaddr+0x52>
    80002cf6:	00848713          	addi	a4,s1,8
    80002cfa:	02e7e863          	bltu	a5,a4,80002d2a <fetchaddr+0x56>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002cfe:	6785                	lui	a5,0x1
    80002d00:	97aa                	add	a5,a5,a0
    80002d02:	46a1                	li	a3,8
    80002d04:	8626                	mv	a2,s1
    80002d06:	85ca                	mv	a1,s2
    80002d08:	73c8                	ld	a0,160(a5)
    80002d0a:	fffff097          	auipc	ra,0xfffff
    80002d0e:	a04080e7          	jalr	-1532(ra) # 8000170e <copyin>
    80002d12:	00a03533          	snez	a0,a0
    80002d16:	40a00533          	neg	a0,a0
}
    80002d1a:	60e2                	ld	ra,24(sp)
    80002d1c:	6442                	ld	s0,16(sp)
    80002d1e:	64a2                	ld	s1,8(sp)
    80002d20:	6902                	ld	s2,0(sp)
    80002d22:	6105                	addi	sp,sp,32
    80002d24:	8082                	ret
    return -1;
    80002d26:	557d                	li	a0,-1
    80002d28:	bfcd                	j	80002d1a <fetchaddr+0x46>
    80002d2a:	557d                	li	a0,-1
    80002d2c:	b7fd                	j	80002d1a <fetchaddr+0x46>

0000000080002d2e <fetchstr>:
{
    80002d2e:	7179                	addi	sp,sp,-48
    80002d30:	f406                	sd	ra,40(sp)
    80002d32:	f022                	sd	s0,32(sp)
    80002d34:	ec26                	sd	s1,24(sp)
    80002d36:	e84a                	sd	s2,16(sp)
    80002d38:	e44e                	sd	s3,8(sp)
    80002d3a:	1800                	addi	s0,sp,48
    80002d3c:	892a                	mv	s2,a0
    80002d3e:	84ae                	mv	s1,a1
    80002d40:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002d42:	fffff097          	auipc	ra,0xfffff
    80002d46:	ccc080e7          	jalr	-820(ra) # 80001a0e <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002d4a:	6785                	lui	a5,0x1
    80002d4c:	97aa                	add	a5,a5,a0
    80002d4e:	86ce                	mv	a3,s3
    80002d50:	864a                	mv	a2,s2
    80002d52:	85a6                	mv	a1,s1
    80002d54:	73c8                	ld	a0,160(a5)
    80002d56:	fffff097          	auipc	ra,0xfffff
    80002d5a:	a46080e7          	jalr	-1466(ra) # 8000179c <copyinstr>
  if(err < 0)
    80002d5e:	00054763          	bltz	a0,80002d6c <fetchstr+0x3e>
  return strlen(buf);
    80002d62:	8526                	mv	a0,s1
    80002d64:	ffffe097          	auipc	ra,0xffffe
    80002d68:	122080e7          	jalr	290(ra) # 80000e86 <strlen>
}
    80002d6c:	70a2                	ld	ra,40(sp)
    80002d6e:	7402                	ld	s0,32(sp)
    80002d70:	64e2                	ld	s1,24(sp)
    80002d72:	6942                	ld	s2,16(sp)
    80002d74:	69a2                	ld	s3,8(sp)
    80002d76:	6145                	addi	sp,sp,48
    80002d78:	8082                	ret

0000000080002d7a <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002d7a:	1101                	addi	sp,sp,-32
    80002d7c:	ec06                	sd	ra,24(sp)
    80002d7e:	e822                	sd	s0,16(sp)
    80002d80:	e426                	sd	s1,8(sp)
    80002d82:	1000                	addi	s0,sp,32
    80002d84:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002d86:	00000097          	auipc	ra,0x0
    80002d8a:	ece080e7          	jalr	-306(ra) # 80002c54 <argraw>
    80002d8e:	c088                	sw	a0,0(s1)
  return 0;
}
    80002d90:	4501                	li	a0,0
    80002d92:	60e2                	ld	ra,24(sp)
    80002d94:	6442                	ld	s0,16(sp)
    80002d96:	64a2                	ld	s1,8(sp)
    80002d98:	6105                	addi	sp,sp,32
    80002d9a:	8082                	ret

0000000080002d9c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002d9c:	1101                	addi	sp,sp,-32
    80002d9e:	ec06                	sd	ra,24(sp)
    80002da0:	e822                	sd	s0,16(sp)
    80002da2:	e426                	sd	s1,8(sp)
    80002da4:	1000                	addi	s0,sp,32
    80002da6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002da8:	00000097          	auipc	ra,0x0
    80002dac:	eac080e7          	jalr	-340(ra) # 80002c54 <argraw>
    80002db0:	e088                	sd	a0,0(s1)
  return 0;
}
    80002db2:	4501                	li	a0,0
    80002db4:	60e2                	ld	ra,24(sp)
    80002db6:	6442                	ld	s0,16(sp)
    80002db8:	64a2                	ld	s1,8(sp)
    80002dba:	6105                	addi	sp,sp,32
    80002dbc:	8082                	ret

0000000080002dbe <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002dbe:	1101                	addi	sp,sp,-32
    80002dc0:	ec06                	sd	ra,24(sp)
    80002dc2:	e822                	sd	s0,16(sp)
    80002dc4:	e426                	sd	s1,8(sp)
    80002dc6:	e04a                	sd	s2,0(sp)
    80002dc8:	1000                	addi	s0,sp,32
    80002dca:	84ae                	mv	s1,a1
    80002dcc:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002dce:	00000097          	auipc	ra,0x0
    80002dd2:	e86080e7          	jalr	-378(ra) # 80002c54 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002dd6:	864a                	mv	a2,s2
    80002dd8:	85a6                	mv	a1,s1
    80002dda:	00000097          	auipc	ra,0x0
    80002dde:	f54080e7          	jalr	-172(ra) # 80002d2e <fetchstr>
}
    80002de2:	60e2                	ld	ra,24(sp)
    80002de4:	6442                	ld	s0,16(sp)
    80002de6:	64a2                	ld	s1,8(sp)
    80002de8:	6902                	ld	s2,0(sp)
    80002dea:	6105                	addi	sp,sp,32
    80002dec:	8082                	ret

0000000080002dee <syscall>:
[SYS_cancelthrdstop]   sys_cancelthrdstop,
};

void
syscall(void)
{
    80002dee:	1101                	addi	sp,sp,-32
    80002df0:	ec06                	sd	ra,24(sp)
    80002df2:	e822                	sd	s0,16(sp)
    80002df4:	e426                	sd	s1,8(sp)
    80002df6:	e04a                	sd	s2,0(sp)
    80002df8:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002dfa:	fffff097          	auipc	ra,0xfffff
    80002dfe:	c14080e7          	jalr	-1004(ra) # 80001a0e <myproc>
    80002e02:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002e04:	6785                	lui	a5,0x1
    80002e06:	97aa                	add	a5,a5,a0
    80002e08:	0a87b903          	ld	s2,168(a5) # 10a8 <_entry-0x7fffef58>
    80002e0c:	0a893783          	ld	a5,168(s2)
    80002e10:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002e14:	37fd                	addiw	a5,a5,-1
    80002e16:	475d                	li	a4,23
    80002e18:	00f76f63          	bltu	a4,a5,80002e36 <syscall+0x48>
    80002e1c:	00369713          	slli	a4,a3,0x3
    80002e20:	00005797          	auipc	a5,0x5
    80002e24:	60078793          	addi	a5,a5,1536 # 80008420 <syscalls>
    80002e28:	97ba                	add	a5,a5,a4
    80002e2a:	639c                	ld	a5,0(a5)
    80002e2c:	c789                	beqz	a5,80002e36 <syscall+0x48>
    p->trapframe->a0 = syscalls[num]();
    80002e2e:	9782                	jalr	a5
    80002e30:	06a93823          	sd	a0,112(s2)
    80002e34:	a015                	j	80002e58 <syscall+0x6a>
  } else {
    printf("%d %s: unknown sys call %d\n",
            p->pid, p->name, num);
    80002e36:	6905                	lui	s2,0x1
    80002e38:	1a890613          	addi	a2,s2,424 # 11a8 <_entry-0x7fffee58>
    printf("%d %s: unknown sys call %d\n",
    80002e3c:	9626                	add	a2,a2,s1
    80002e3e:	5c8c                	lw	a1,56(s1)
    80002e40:	00005517          	auipc	a0,0x5
    80002e44:	5a850513          	addi	a0,a0,1448 # 800083e8 <states.0+0x148>
    80002e48:	ffffd097          	auipc	ra,0xffffd
    80002e4c:	74c080e7          	jalr	1868(ra) # 80000594 <printf>
    p->trapframe->a0 = -1;
    80002e50:	94ca                	add	s1,s1,s2
    80002e52:	74dc                	ld	a5,168(s1)
    80002e54:	577d                	li	a4,-1
    80002e56:	fbb8                	sd	a4,112(a5)
  }
}
    80002e58:	60e2                	ld	ra,24(sp)
    80002e5a:	6442                	ld	s0,16(sp)
    80002e5c:	64a2                	ld	s1,8(sp)
    80002e5e:	6902                	ld	s2,0(sp)
    80002e60:	6105                	addi	sp,sp,32
    80002e62:	8082                	ret

0000000080002e64 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002e64:	1101                	addi	sp,sp,-32
    80002e66:	ec06                	sd	ra,24(sp)
    80002e68:	e822                	sd	s0,16(sp)
    80002e6a:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002e6c:	fec40593          	addi	a1,s0,-20
    80002e70:	4501                	li	a0,0
    80002e72:	00000097          	auipc	ra,0x0
    80002e76:	f08080e7          	jalr	-248(ra) # 80002d7a <argint>
    return -1;
    80002e7a:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002e7c:	00054963          	bltz	a0,80002e8e <sys_exit+0x2a>
  exit(n);
    80002e80:	fec42503          	lw	a0,-20(s0)
    80002e84:	fffff097          	auipc	ra,0xfffff
    80002e88:	2da080e7          	jalr	730(ra) # 8000215e <exit>
  return 0;  // not reached
    80002e8c:	4781                	li	a5,0
}
    80002e8e:	853e                	mv	a0,a5
    80002e90:	60e2                	ld	ra,24(sp)
    80002e92:	6442                	ld	s0,16(sp)
    80002e94:	6105                	addi	sp,sp,32
    80002e96:	8082                	ret

0000000080002e98 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002e98:	1141                	addi	sp,sp,-16
    80002e9a:	e406                	sd	ra,8(sp)
    80002e9c:	e022                	sd	s0,0(sp)
    80002e9e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002ea0:	fffff097          	auipc	ra,0xfffff
    80002ea4:	b6e080e7          	jalr	-1170(ra) # 80001a0e <myproc>
}
    80002ea8:	5d08                	lw	a0,56(a0)
    80002eaa:	60a2                	ld	ra,8(sp)
    80002eac:	6402                	ld	s0,0(sp)
    80002eae:	0141                	addi	sp,sp,16
    80002eb0:	8082                	ret

0000000080002eb2 <sys_fork>:

uint64
sys_fork(void)
{
    80002eb2:	1141                	addi	sp,sp,-16
    80002eb4:	e406                	sd	ra,8(sp)
    80002eb6:	e022                	sd	s0,0(sp)
    80002eb8:	0800                	addi	s0,sp,16
  return fork();
    80002eba:	fffff097          	auipc	ra,0xfffff
    80002ebe:	f8c080e7          	jalr	-116(ra) # 80001e46 <fork>
}
    80002ec2:	60a2                	ld	ra,8(sp)
    80002ec4:	6402                	ld	s0,0(sp)
    80002ec6:	0141                	addi	sp,sp,16
    80002ec8:	8082                	ret

0000000080002eca <sys_wait>:

uint64
sys_wait(void)
{
    80002eca:	1101                	addi	sp,sp,-32
    80002ecc:	ec06                	sd	ra,24(sp)
    80002ece:	e822                	sd	s0,16(sp)
    80002ed0:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002ed2:	fe840593          	addi	a1,s0,-24
    80002ed6:	4501                	li	a0,0
    80002ed8:	00000097          	auipc	ra,0x0
    80002edc:	ec4080e7          	jalr	-316(ra) # 80002d9c <argaddr>
    80002ee0:	87aa                	mv	a5,a0
    return -1;
    80002ee2:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002ee4:	0007c863          	bltz	a5,80002ef4 <sys_wait+0x2a>
  return wait(p);
    80002ee8:	fe843503          	ld	a0,-24(s0)
    80002eec:	fffff097          	auipc	ra,0xfffff
    80002ef0:	442080e7          	jalr	1090(ra) # 8000232e <wait>
}
    80002ef4:	60e2                	ld	ra,24(sp)
    80002ef6:	6442                	ld	s0,16(sp)
    80002ef8:	6105                	addi	sp,sp,32
    80002efa:	8082                	ret

0000000080002efc <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002efc:	7179                	addi	sp,sp,-48
    80002efe:	f406                	sd	ra,40(sp)
    80002f00:	f022                	sd	s0,32(sp)
    80002f02:	ec26                	sd	s1,24(sp)
    80002f04:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002f06:	fdc40593          	addi	a1,s0,-36
    80002f0a:	4501                	li	a0,0
    80002f0c:	00000097          	auipc	ra,0x0
    80002f10:	e6e080e7          	jalr	-402(ra) # 80002d7a <argint>
    return -1;
    80002f14:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    80002f16:	02054263          	bltz	a0,80002f3a <sys_sbrk+0x3e>
  addr = myproc()->sz;
    80002f1a:	fffff097          	auipc	ra,0xfffff
    80002f1e:	af4080e7          	jalr	-1292(ra) # 80001a0e <myproc>
    80002f22:	6785                	lui	a5,0x1
    80002f24:	953e                	add	a0,a0,a5
    80002f26:	09852483          	lw	s1,152(a0)
  if(growproc(n) < 0)
    80002f2a:	fdc42503          	lw	a0,-36(s0)
    80002f2e:	fffff097          	auipc	ra,0xfffff
    80002f32:	e92080e7          	jalr	-366(ra) # 80001dc0 <growproc>
    80002f36:	00054863          	bltz	a0,80002f46 <sys_sbrk+0x4a>
    return -1;
  return addr;
}
    80002f3a:	8526                	mv	a0,s1
    80002f3c:	70a2                	ld	ra,40(sp)
    80002f3e:	7402                	ld	s0,32(sp)
    80002f40:	64e2                	ld	s1,24(sp)
    80002f42:	6145                	addi	sp,sp,48
    80002f44:	8082                	ret
    return -1;
    80002f46:	54fd                	li	s1,-1
    80002f48:	bfcd                	j	80002f3a <sys_sbrk+0x3e>

0000000080002f4a <sys_sleep>:

uint64
sys_sleep(void)
{
    80002f4a:	7139                	addi	sp,sp,-64
    80002f4c:	fc06                	sd	ra,56(sp)
    80002f4e:	f822                	sd	s0,48(sp)
    80002f50:	f426                	sd	s1,40(sp)
    80002f52:	f04a                	sd	s2,32(sp)
    80002f54:	ec4e                	sd	s3,24(sp)
    80002f56:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002f58:	fcc40593          	addi	a1,s0,-52
    80002f5c:	4501                	li	a0,0
    80002f5e:	00000097          	auipc	ra,0x0
    80002f62:	e1c080e7          	jalr	-484(ra) # 80002d7a <argint>
    return -1;
    80002f66:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002f68:	06054563          	bltz	a0,80002fd2 <sys_sleep+0x88>
  acquire(&tickslock);
    80002f6c:	00055517          	auipc	a0,0x55
    80002f70:	53c50513          	addi	a0,a0,1340 # 800584a8 <tickslock>
    80002f74:	ffffe097          	auipc	ra,0xffffe
    80002f78:	c92080e7          	jalr	-878(ra) # 80000c06 <acquire>
  ticks0 = ticks;
    80002f7c:	00006917          	auipc	s2,0x6
    80002f80:	0a492903          	lw	s2,164(s2) # 80009020 <ticks>
  while(ticks - ticks0 < n){
    80002f84:	fcc42783          	lw	a5,-52(s0)
    80002f88:	cf85                	beqz	a5,80002fc0 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002f8a:	00055997          	auipc	s3,0x55
    80002f8e:	51e98993          	addi	s3,s3,1310 # 800584a8 <tickslock>
    80002f92:	00006497          	auipc	s1,0x6
    80002f96:	08e48493          	addi	s1,s1,142 # 80009020 <ticks>
    if(myproc()->killed){
    80002f9a:	fffff097          	auipc	ra,0xfffff
    80002f9e:	a74080e7          	jalr	-1420(ra) # 80001a0e <myproc>
    80002fa2:	591c                	lw	a5,48(a0)
    80002fa4:	ef9d                	bnez	a5,80002fe2 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002fa6:	85ce                	mv	a1,s3
    80002fa8:	8526                	mv	a0,s1
    80002faa:	fffff097          	auipc	ra,0xfffff
    80002fae:	306080e7          	jalr	774(ra) # 800022b0 <sleep>
  while(ticks - ticks0 < n){
    80002fb2:	409c                	lw	a5,0(s1)
    80002fb4:	412787bb          	subw	a5,a5,s2
    80002fb8:	fcc42703          	lw	a4,-52(s0)
    80002fbc:	fce7efe3          	bltu	a5,a4,80002f9a <sys_sleep+0x50>
  }
  release(&tickslock);
    80002fc0:	00055517          	auipc	a0,0x55
    80002fc4:	4e850513          	addi	a0,a0,1256 # 800584a8 <tickslock>
    80002fc8:	ffffe097          	auipc	ra,0xffffe
    80002fcc:	cf2080e7          	jalr	-782(ra) # 80000cba <release>
  return 0;
    80002fd0:	4781                	li	a5,0
}
    80002fd2:	853e                	mv	a0,a5
    80002fd4:	70e2                	ld	ra,56(sp)
    80002fd6:	7442                	ld	s0,48(sp)
    80002fd8:	74a2                	ld	s1,40(sp)
    80002fda:	7902                	ld	s2,32(sp)
    80002fdc:	69e2                	ld	s3,24(sp)
    80002fde:	6121                	addi	sp,sp,64
    80002fe0:	8082                	ret
      release(&tickslock);
    80002fe2:	00055517          	auipc	a0,0x55
    80002fe6:	4c650513          	addi	a0,a0,1222 # 800584a8 <tickslock>
    80002fea:	ffffe097          	auipc	ra,0xffffe
    80002fee:	cd0080e7          	jalr	-816(ra) # 80000cba <release>
      return -1;
    80002ff2:	57fd                	li	a5,-1
    80002ff4:	bff9                	j	80002fd2 <sys_sleep+0x88>

0000000080002ff6 <sys_kill>:

uint64
sys_kill(void)
{
    80002ff6:	1101                	addi	sp,sp,-32
    80002ff8:	ec06                	sd	ra,24(sp)
    80002ffa:	e822                	sd	s0,16(sp)
    80002ffc:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002ffe:	fec40593          	addi	a1,s0,-20
    80003002:	4501                	li	a0,0
    80003004:	00000097          	auipc	ra,0x0
    80003008:	d76080e7          	jalr	-650(ra) # 80002d7a <argint>
    8000300c:	87aa                	mv	a5,a0
    return -1;
    8000300e:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80003010:	0007c863          	bltz	a5,80003020 <sys_kill+0x2a>
  return kill(pid);
    80003014:	fec42503          	lw	a0,-20(s0)
    80003018:	fffff097          	auipc	ra,0xfffff
    8000301c:	48e080e7          	jalr	1166(ra) # 800024a6 <kill>
}
    80003020:	60e2                	ld	ra,24(sp)
    80003022:	6442                	ld	s0,16(sp)
    80003024:	6105                	addi	sp,sp,32
    80003026:	8082                	ret

0000000080003028 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80003028:	1101                	addi	sp,sp,-32
    8000302a:	ec06                	sd	ra,24(sp)
    8000302c:	e822                	sd	s0,16(sp)
    8000302e:	e426                	sd	s1,8(sp)
    80003030:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003032:	00055517          	auipc	a0,0x55
    80003036:	47650513          	addi	a0,a0,1142 # 800584a8 <tickslock>
    8000303a:	ffffe097          	auipc	ra,0xffffe
    8000303e:	bcc080e7          	jalr	-1076(ra) # 80000c06 <acquire>
  xticks = ticks;
    80003042:	00006497          	auipc	s1,0x6
    80003046:	fde4a483          	lw	s1,-34(s1) # 80009020 <ticks>
  release(&tickslock);
    8000304a:	00055517          	auipc	a0,0x55
    8000304e:	45e50513          	addi	a0,a0,1118 # 800584a8 <tickslock>
    80003052:	ffffe097          	auipc	ra,0xffffe
    80003056:	c68080e7          	jalr	-920(ra) # 80000cba <release>
  return xticks;
}
    8000305a:	02049513          	slli	a0,s1,0x20
    8000305e:	9101                	srli	a0,a0,0x20
    80003060:	60e2                	ld	ra,24(sp)
    80003062:	6442                	ld	s0,16(sp)
    80003064:	64a2                	ld	s1,8(sp)
    80003066:	6105                	addi	sp,sp,32
    80003068:	8082                	ret

000000008000306a <sys_thrdstop>:


// for mp3
uint64
sys_thrdstop(void)
{
    8000306a:	7179                	addi	sp,sp,-48
    8000306c:	f406                	sd	ra,40(sp)
    8000306e:	f022                	sd	s0,32(sp)
    80003070:	ec26                	sd	s1,24(sp)
    80003072:	e84a                	sd	s2,16(sp)
    80003074:	1800                	addi	s0,sp,48
  int interval, thrdstop_context_id;
  uint64 handler;
  if (argint(0, &interval) < 0)
    80003076:	fdc40593          	addi	a1,s0,-36
    8000307a:	4501                	li	a0,0
    8000307c:	00000097          	auipc	ra,0x0
    80003080:	cfe080e7          	jalr	-770(ra) # 80002d7a <argint>
    return -1;
    80003084:	54fd                	li	s1,-1
  if (argint(0, &interval) < 0)
    80003086:	0e054263          	bltz	a0,8000316a <sys_thrdstop+0x100>
  if (argint(1, &thrdstop_context_id) < 0)
    8000308a:	fd840593          	addi	a1,s0,-40
    8000308e:	4505                	li	a0,1
    80003090:	00000097          	auipc	ra,0x0
    80003094:	cea080e7          	jalr	-790(ra) # 80002d7a <argint>
    80003098:	0c054963          	bltz	a0,8000316a <sys_thrdstop+0x100>
    return -1;
  if (argaddr(2, &handler) < 0)
    8000309c:	fd040593          	addi	a1,s0,-48
    800030a0:	4509                	li	a0,2
    800030a2:	00000097          	auipc	ra,0x0
    800030a6:	cfa080e7          	jalr	-774(ra) # 80002d9c <argaddr>
    800030aa:	0c054063          	bltz	a0,8000316a <sys_thrdstop+0x100>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800030ae:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800030b2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800030b4:	10079073          	csrw	sstatus,a5
    return -1;

  intr_off();
  myproc()->thrdstop_interval = interval;
    800030b8:	fffff097          	auipc	ra,0xfffff
    800030bc:	956080e7          	jalr	-1706(ra) # 80001a0e <myproc>
    800030c0:	fdc42783          	lw	a5,-36(s0)
    800030c4:	c13c                	sw	a5,64(a0)
  myproc()->thrdstop_handler_pointer = handler;
    800030c6:	fffff097          	auipc	ra,0xfffff
    800030ca:	948080e7          	jalr	-1720(ra) # 80001a0e <myproc>
    800030ce:	fd043783          	ld	a5,-48(s0)
    800030d2:	e53c                	sd	a5,72(a0)
  myproc()->thrdstop_ticks = 0;
    800030d4:	fffff097          	auipc	ra,0xfffff
    800030d8:	93a080e7          	jalr	-1734(ra) # 80001a0e <myproc>
    800030dc:	02052e23          	sw	zero,60(a0)

  if(thrdstop_context_id == -1){
    800030e0:	fd842703          	lw	a4,-40(s0)
    800030e4:	57fd                	li	a5,-1
    800030e6:	04f71963          	bne	a4,a5,80003138 <sys_thrdstop+0xce>
    for(int i = 0; i < MAX_THRD_NUM; i++){
    800030ea:	4481                	li	s1,0
    800030ec:	4941                	li	s2,16
      if(myproc()->thrdstop_context_used[i] == 0){
    800030ee:	fffff097          	auipc	ra,0xfffff
    800030f2:	920080e7          	jalr	-1760(ra) # 80001a0e <myproc>
    800030f6:	41448793          	addi	a5,s1,1044
    800030fa:	078a                	slli	a5,a5,0x2
    800030fc:	953e                	add	a0,a0,a5
    800030fe:	411c                	lw	a5,0(a0)
    80003100:	c791                	beqz	a5,8000310c <sys_thrdstop+0xa2>
    for(int i = 0; i < MAX_THRD_NUM; i++){
    80003102:	2485                	addiw	s1,s1,1
    80003104:	ff2495e3          	bne	s1,s2,800030ee <sys_thrdstop+0x84>
    myproc()->thrdstop_context_used[thrdstop_context_id] = 1;
    intr_on();
    return thrdstop_context_id;
  }

  return -1;
    80003108:	54fd                	li	s1,-1
    8000310a:	a085                	j	8000316a <sys_thrdstop+0x100>
        myproc()->thrdstop_context_id = i;
    8000310c:	fffff097          	auipc	ra,0xfffff
    80003110:	902080e7          	jalr	-1790(ra) # 80001a0e <myproc>
    80003114:	c164                	sw	s1,68(a0)
        myproc()->thrdstop_context_used[i] = 1;
    80003116:	fffff097          	auipc	ra,0xfffff
    8000311a:	8f8080e7          	jalr	-1800(ra) # 80001a0e <myproc>
    8000311e:	41448793          	addi	a5,s1,1044
    80003122:	078a                	slli	a5,a5,0x2
    80003124:	953e                	add	a0,a0,a5
    80003126:	4785                	li	a5,1
    80003128:	c11c                	sw	a5,0(a0)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000312a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000312e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003132:	10079073          	csrw	sstatus,a5
        return i;
    80003136:	a815                	j	8000316a <sys_thrdstop+0x100>
    myproc()->thrdstop_context_id = thrdstop_context_id;
    80003138:	fffff097          	auipc	ra,0xfffff
    8000313c:	8d6080e7          	jalr	-1834(ra) # 80001a0e <myproc>
    80003140:	fd842783          	lw	a5,-40(s0)
    80003144:	c17c                	sw	a5,68(a0)
    myproc()->thrdstop_context_used[thrdstop_context_id] = 1;
    80003146:	fffff097          	auipc	ra,0xfffff
    8000314a:	8c8080e7          	jalr	-1848(ra) # 80001a0e <myproc>
    8000314e:	fd842483          	lw	s1,-40(s0)
    80003152:	41448793          	addi	a5,s1,1044
    80003156:	078a                	slli	a5,a5,0x2
    80003158:	953e                	add	a0,a0,a5
    8000315a:	4785                	li	a5,1
    8000315c:	c11c                	sw	a5,0(a0)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000315e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80003162:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003166:	10079073          	csrw	sstatus,a5
}
    8000316a:	8526                	mv	a0,s1
    8000316c:	70a2                	ld	ra,40(sp)
    8000316e:	7402                	ld	s0,32(sp)
    80003170:	64e2                	ld	s1,24(sp)
    80003172:	6942                	ld	s2,16(sp)
    80003174:	6145                	addi	sp,sp,48
    80003176:	8082                	ret

0000000080003178 <sys_cancelthrdstop>:

// for mp3
uint64
sys_cancelthrdstop(void)
{
    80003178:	7179                	addi	sp,sp,-48
    8000317a:	f406                	sd	ra,40(sp)
    8000317c:	f022                	sd	s0,32(sp)
    8000317e:	ec26                	sd	s1,24(sp)
    80003180:	1800                	addi	s0,sp,48
  int thrdstop_context_id;
  if (argint(0, &thrdstop_context_id) < 0)
    80003182:	fdc40593          	addi	a1,s0,-36
    80003186:	4501                	li	a0,0
    80003188:	00000097          	auipc	ra,0x0
    8000318c:	bf2080e7          	jalr	-1038(ra) # 80002d7a <argint>
    80003190:	06054b63          	bltz	a0,80003206 <sys_cancelthrdstop+0x8e>
    return -1;

  if(thrdstop_context_id >= MAX_THRD_NUM)
    80003194:	fdc42703          	lw	a4,-36(s0)
    80003198:	47bd                	li	a5,15
    return -1;
    8000319a:	557d                	li	a0,-1
  if(thrdstop_context_id >= MAX_THRD_NUM)
    8000319c:	02e7cf63          	blt	a5,a4,800031da <sys_cancelthrdstop+0x62>

  myproc()->thrdstop_interval = -1;
    800031a0:	fffff097          	auipc	ra,0xfffff
    800031a4:	86e080e7          	jalr	-1938(ra) # 80001a0e <myproc>
    800031a8:	57fd                	li	a5,-1
    800031aa:	c13c                	sw	a5,64(a0)

  if(thrdstop_context_id != -1){
    800031ac:	fdc42703          	lw	a4,-36(s0)
    800031b0:	02f70a63          	beq	a4,a5,800031e4 <sys_cancelthrdstop+0x6c>
    store_trapframe(&(myproc()->thrdstop_context[thrdstop_context_id]));
    800031b4:	fffff097          	auipc	ra,0xfffff
    800031b8:	85a080e7          	jalr	-1958(ra) # 80001a0e <myproc>
    800031bc:	fdc42783          	lw	a5,-36(s0)
    800031c0:	07a2                	slli	a5,a5,0x8
    800031c2:	05078793          	addi	a5,a5,80 # 1050 <_entry-0x7fffefb0>
    800031c6:	953e                	add	a0,a0,a5
    800031c8:	fffff097          	auipc	ra,0xfffff
    800031cc:	4c0080e7          	jalr	1216(ra) # 80002688 <store_trapframe>
  }else{
    myproc()->thrdstop_context_used[myproc()->thrdstop_context_id] = 0;
  }

  return myproc()->thrdstop_ticks;
    800031d0:	fffff097          	auipc	ra,0xfffff
    800031d4:	83e080e7          	jalr	-1986(ra) # 80001a0e <myproc>
    800031d8:	5d48                	lw	a0,60(a0)
}
    800031da:	70a2                	ld	ra,40(sp)
    800031dc:	7402                	ld	s0,32(sp)
    800031de:	64e2                	ld	s1,24(sp)
    800031e0:	6145                	addi	sp,sp,48
    800031e2:	8082                	ret
    myproc()->thrdstop_context_used[myproc()->thrdstop_context_id] = 0;
    800031e4:	fffff097          	auipc	ra,0xfffff
    800031e8:	82a080e7          	jalr	-2006(ra) # 80001a0e <myproc>
    800031ec:	84aa                	mv	s1,a0
    800031ee:	fffff097          	auipc	ra,0xfffff
    800031f2:	820080e7          	jalr	-2016(ra) # 80001a0e <myproc>
    800031f6:	4168                	lw	a0,68(a0)
    800031f8:	41450513          	addi	a0,a0,1044
    800031fc:	050a                	slli	a0,a0,0x2
    800031fe:	94aa                	add	s1,s1,a0
    80003200:	0004a023          	sw	zero,0(s1)
    80003204:	b7f1                	j	800031d0 <sys_cancelthrdstop+0x58>
    return -1;
    80003206:	557d                	li	a0,-1
    80003208:	bfc9                	j	800031da <sys_cancelthrdstop+0x62>

000000008000320a <sys_thrdresume>:

// for mp3
uint64
sys_thrdresume(void)
{
    8000320a:	1101                	addi	sp,sp,-32
    8000320c:	ec06                	sd	ra,24(sp)
    8000320e:	e822                	sd	s0,16(sp)
    80003210:	1000                	addi	s0,sp,32
  int  thrdstop_context_id, is_exit;
  if (argint(0, &thrdstop_context_id) < 0)
    80003212:	fec40593          	addi	a1,s0,-20
    80003216:	4501                	li	a0,0
    80003218:	00000097          	auipc	ra,0x0
    8000321c:	b62080e7          	jalr	-1182(ra) # 80002d7a <argint>
    return -1;
    80003220:	57fd                	li	a5,-1
  if (argint(0, &thrdstop_context_id) < 0)
    80003222:	04054963          	bltz	a0,80003274 <sys_thrdresume+0x6a>
  if (argint(1, &is_exit) < 0)
    80003226:	fe840593          	addi	a1,s0,-24
    8000322a:	4505                	li	a0,1
    8000322c:	00000097          	auipc	ra,0x0
    80003230:	b4e080e7          	jalr	-1202(ra) # 80002d7a <argint>
    80003234:	06054963          	bltz	a0,800032a6 <sys_thrdresume+0x9c>
    return -1;

  if(is_exit == 0){ // jump back
    80003238:	fe842783          	lw	a5,-24(s0)
    8000323c:	e3a9                	bnez	a5,8000327e <sys_thrdresume+0x74>
    restore_trapframe(&(myproc()->thrdstop_context[thrdstop_context_id]));
    8000323e:	ffffe097          	auipc	ra,0xffffe
    80003242:	7d0080e7          	jalr	2000(ra) # 80001a0e <myproc>
    80003246:	fec42783          	lw	a5,-20(s0)
    8000324a:	07a2                	slli	a5,a5,0x8
    8000324c:	05078793          	addi	a5,a5,80
    80003250:	953e                	add	a0,a0,a5
    80003252:	fffff097          	auipc	ra,0xfffff
    80003256:	4e2080e7          	jalr	1250(ra) # 80002734 <restore_trapframe>
    myproc()->thrdstop_context_used[thrdstop_context_id] = 0;
    8000325a:	ffffe097          	auipc	ra,0xffffe
    8000325e:	7b4080e7          	jalr	1972(ra) # 80001a0e <myproc>
    80003262:	fec42783          	lw	a5,-20(s0)
    80003266:	41478793          	addi	a5,a5,1044
    8000326a:	078a                	slli	a5,a5,0x2
    8000326c:	97aa                	add	a5,a5,a0
    8000326e:	0007a023          	sw	zero,0(a5)
  }else{ // for thread exit
    myproc()->thrdstop_interval = -1;
    myproc()->thrdstop_context_used[thrdstop_context_id] = 0;
  }
  return 0;
    80003272:	4781                	li	a5,0
}
    80003274:	853e                	mv	a0,a5
    80003276:	60e2                	ld	ra,24(sp)
    80003278:	6442                	ld	s0,16(sp)
    8000327a:	6105                	addi	sp,sp,32
    8000327c:	8082                	ret
    myproc()->thrdstop_interval = -1;
    8000327e:	ffffe097          	auipc	ra,0xffffe
    80003282:	790080e7          	jalr	1936(ra) # 80001a0e <myproc>
    80003286:	57fd                	li	a5,-1
    80003288:	c13c                	sw	a5,64(a0)
    myproc()->thrdstop_context_used[thrdstop_context_id] = 0;
    8000328a:	ffffe097          	auipc	ra,0xffffe
    8000328e:	784080e7          	jalr	1924(ra) # 80001a0e <myproc>
    80003292:	fec42783          	lw	a5,-20(s0)
    80003296:	41478793          	addi	a5,a5,1044
    8000329a:	078a                	slli	a5,a5,0x2
    8000329c:	97aa                	add	a5,a5,a0
    8000329e:	0007a023          	sw	zero,0(a5)
  return 0;
    800032a2:	4781                	li	a5,0
    800032a4:	bfc1                	j	80003274 <sys_thrdresume+0x6a>
    return -1;
    800032a6:	57fd                	li	a5,-1
    800032a8:	b7f1                	j	80003274 <sys_thrdresume+0x6a>

00000000800032aa <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800032aa:	7179                	addi	sp,sp,-48
    800032ac:	f406                	sd	ra,40(sp)
    800032ae:	f022                	sd	s0,32(sp)
    800032b0:	ec26                	sd	s1,24(sp)
    800032b2:	e84a                	sd	s2,16(sp)
    800032b4:	e44e                	sd	s3,8(sp)
    800032b6:	e052                	sd	s4,0(sp)
    800032b8:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800032ba:	00005597          	auipc	a1,0x5
    800032be:	22e58593          	addi	a1,a1,558 # 800084e8 <syscalls+0xc8>
    800032c2:	00055517          	auipc	a0,0x55
    800032c6:	1fe50513          	addi	a0,a0,510 # 800584c0 <bcache>
    800032ca:	ffffe097          	auipc	ra,0xffffe
    800032ce:	8ac080e7          	jalr	-1876(ra) # 80000b76 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800032d2:	0005d797          	auipc	a5,0x5d
    800032d6:	1ee78793          	addi	a5,a5,494 # 800604c0 <bcache+0x8000>
    800032da:	0005d717          	auipc	a4,0x5d
    800032de:	44e70713          	addi	a4,a4,1102 # 80060728 <bcache+0x8268>
    800032e2:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800032e6:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800032ea:	00055497          	auipc	s1,0x55
    800032ee:	1ee48493          	addi	s1,s1,494 # 800584d8 <bcache+0x18>
    b->next = bcache.head.next;
    800032f2:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800032f4:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800032f6:	00005a17          	auipc	s4,0x5
    800032fa:	1faa0a13          	addi	s4,s4,506 # 800084f0 <syscalls+0xd0>
    b->next = bcache.head.next;
    800032fe:	2b893783          	ld	a5,696(s2)
    80003302:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003304:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003308:	85d2                	mv	a1,s4
    8000330a:	01048513          	addi	a0,s1,16
    8000330e:	00001097          	auipc	ra,0x1
    80003312:	4c6080e7          	jalr	1222(ra) # 800047d4 <initsleeplock>
    bcache.head.next->prev = b;
    80003316:	2b893783          	ld	a5,696(s2)
    8000331a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000331c:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003320:	45848493          	addi	s1,s1,1112
    80003324:	fd349de3          	bne	s1,s3,800032fe <binit+0x54>
  }
}
    80003328:	70a2                	ld	ra,40(sp)
    8000332a:	7402                	ld	s0,32(sp)
    8000332c:	64e2                	ld	s1,24(sp)
    8000332e:	6942                	ld	s2,16(sp)
    80003330:	69a2                	ld	s3,8(sp)
    80003332:	6a02                	ld	s4,0(sp)
    80003334:	6145                	addi	sp,sp,48
    80003336:	8082                	ret

0000000080003338 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003338:	7179                	addi	sp,sp,-48
    8000333a:	f406                	sd	ra,40(sp)
    8000333c:	f022                	sd	s0,32(sp)
    8000333e:	ec26                	sd	s1,24(sp)
    80003340:	e84a                	sd	s2,16(sp)
    80003342:	e44e                	sd	s3,8(sp)
    80003344:	1800                	addi	s0,sp,48
    80003346:	892a                	mv	s2,a0
    80003348:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000334a:	00055517          	auipc	a0,0x55
    8000334e:	17650513          	addi	a0,a0,374 # 800584c0 <bcache>
    80003352:	ffffe097          	auipc	ra,0xffffe
    80003356:	8b4080e7          	jalr	-1868(ra) # 80000c06 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000335a:	0005d497          	auipc	s1,0x5d
    8000335e:	41e4b483          	ld	s1,1054(s1) # 80060778 <bcache+0x82b8>
    80003362:	0005d797          	auipc	a5,0x5d
    80003366:	3c678793          	addi	a5,a5,966 # 80060728 <bcache+0x8268>
    8000336a:	02f48f63          	beq	s1,a5,800033a8 <bread+0x70>
    8000336e:	873e                	mv	a4,a5
    80003370:	a021                	j	80003378 <bread+0x40>
    80003372:	68a4                	ld	s1,80(s1)
    80003374:	02e48a63          	beq	s1,a4,800033a8 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80003378:	449c                	lw	a5,8(s1)
    8000337a:	ff279ce3          	bne	a5,s2,80003372 <bread+0x3a>
    8000337e:	44dc                	lw	a5,12(s1)
    80003380:	ff3799e3          	bne	a5,s3,80003372 <bread+0x3a>
      b->refcnt++;
    80003384:	40bc                	lw	a5,64(s1)
    80003386:	2785                	addiw	a5,a5,1
    80003388:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000338a:	00055517          	auipc	a0,0x55
    8000338e:	13650513          	addi	a0,a0,310 # 800584c0 <bcache>
    80003392:	ffffe097          	auipc	ra,0xffffe
    80003396:	928080e7          	jalr	-1752(ra) # 80000cba <release>
      acquiresleep(&b->lock);
    8000339a:	01048513          	addi	a0,s1,16
    8000339e:	00001097          	auipc	ra,0x1
    800033a2:	470080e7          	jalr	1136(ra) # 8000480e <acquiresleep>
      return b;
    800033a6:	a8b9                	j	80003404 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800033a8:	0005d497          	auipc	s1,0x5d
    800033ac:	3c84b483          	ld	s1,968(s1) # 80060770 <bcache+0x82b0>
    800033b0:	0005d797          	auipc	a5,0x5d
    800033b4:	37878793          	addi	a5,a5,888 # 80060728 <bcache+0x8268>
    800033b8:	00f48863          	beq	s1,a5,800033c8 <bread+0x90>
    800033bc:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800033be:	40bc                	lw	a5,64(s1)
    800033c0:	cf81                	beqz	a5,800033d8 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800033c2:	64a4                	ld	s1,72(s1)
    800033c4:	fee49de3          	bne	s1,a4,800033be <bread+0x86>
  panic("bget: no buffers");
    800033c8:	00005517          	auipc	a0,0x5
    800033cc:	13050513          	addi	a0,a0,304 # 800084f8 <syscalls+0xd8>
    800033d0:	ffffd097          	auipc	ra,0xffffd
    800033d4:	17a080e7          	jalr	378(ra) # 8000054a <panic>
      b->dev = dev;
    800033d8:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800033dc:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800033e0:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800033e4:	4785                	li	a5,1
    800033e6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800033e8:	00055517          	auipc	a0,0x55
    800033ec:	0d850513          	addi	a0,a0,216 # 800584c0 <bcache>
    800033f0:	ffffe097          	auipc	ra,0xffffe
    800033f4:	8ca080e7          	jalr	-1846(ra) # 80000cba <release>
      acquiresleep(&b->lock);
    800033f8:	01048513          	addi	a0,s1,16
    800033fc:	00001097          	auipc	ra,0x1
    80003400:	412080e7          	jalr	1042(ra) # 8000480e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003404:	409c                	lw	a5,0(s1)
    80003406:	cb89                	beqz	a5,80003418 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003408:	8526                	mv	a0,s1
    8000340a:	70a2                	ld	ra,40(sp)
    8000340c:	7402                	ld	s0,32(sp)
    8000340e:	64e2                	ld	s1,24(sp)
    80003410:	6942                	ld	s2,16(sp)
    80003412:	69a2                	ld	s3,8(sp)
    80003414:	6145                	addi	sp,sp,48
    80003416:	8082                	ret
    virtio_disk_rw(b, 0);
    80003418:	4581                	li	a1,0
    8000341a:	8526                	mv	a0,s1
    8000341c:	00003097          	auipc	ra,0x3
    80003420:	f8a080e7          	jalr	-118(ra) # 800063a6 <virtio_disk_rw>
    b->valid = 1;
    80003424:	4785                	li	a5,1
    80003426:	c09c                	sw	a5,0(s1)
  return b;
    80003428:	b7c5                	j	80003408 <bread+0xd0>

000000008000342a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000342a:	1101                	addi	sp,sp,-32
    8000342c:	ec06                	sd	ra,24(sp)
    8000342e:	e822                	sd	s0,16(sp)
    80003430:	e426                	sd	s1,8(sp)
    80003432:	1000                	addi	s0,sp,32
    80003434:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003436:	0541                	addi	a0,a0,16
    80003438:	00001097          	auipc	ra,0x1
    8000343c:	470080e7          	jalr	1136(ra) # 800048a8 <holdingsleep>
    80003440:	cd01                	beqz	a0,80003458 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003442:	4585                	li	a1,1
    80003444:	8526                	mv	a0,s1
    80003446:	00003097          	auipc	ra,0x3
    8000344a:	f60080e7          	jalr	-160(ra) # 800063a6 <virtio_disk_rw>
}
    8000344e:	60e2                	ld	ra,24(sp)
    80003450:	6442                	ld	s0,16(sp)
    80003452:	64a2                	ld	s1,8(sp)
    80003454:	6105                	addi	sp,sp,32
    80003456:	8082                	ret
    panic("bwrite");
    80003458:	00005517          	auipc	a0,0x5
    8000345c:	0b850513          	addi	a0,a0,184 # 80008510 <syscalls+0xf0>
    80003460:	ffffd097          	auipc	ra,0xffffd
    80003464:	0ea080e7          	jalr	234(ra) # 8000054a <panic>

0000000080003468 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003468:	1101                	addi	sp,sp,-32
    8000346a:	ec06                	sd	ra,24(sp)
    8000346c:	e822                	sd	s0,16(sp)
    8000346e:	e426                	sd	s1,8(sp)
    80003470:	e04a                	sd	s2,0(sp)
    80003472:	1000                	addi	s0,sp,32
    80003474:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003476:	01050913          	addi	s2,a0,16
    8000347a:	854a                	mv	a0,s2
    8000347c:	00001097          	auipc	ra,0x1
    80003480:	42c080e7          	jalr	1068(ra) # 800048a8 <holdingsleep>
    80003484:	c92d                	beqz	a0,800034f6 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80003486:	854a                	mv	a0,s2
    80003488:	00001097          	auipc	ra,0x1
    8000348c:	3dc080e7          	jalr	988(ra) # 80004864 <releasesleep>

  acquire(&bcache.lock);
    80003490:	00055517          	auipc	a0,0x55
    80003494:	03050513          	addi	a0,a0,48 # 800584c0 <bcache>
    80003498:	ffffd097          	auipc	ra,0xffffd
    8000349c:	76e080e7          	jalr	1902(ra) # 80000c06 <acquire>
  b->refcnt--;
    800034a0:	40bc                	lw	a5,64(s1)
    800034a2:	37fd                	addiw	a5,a5,-1
    800034a4:	0007871b          	sext.w	a4,a5
    800034a8:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800034aa:	eb05                	bnez	a4,800034da <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800034ac:	68bc                	ld	a5,80(s1)
    800034ae:	64b8                	ld	a4,72(s1)
    800034b0:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800034b2:	64bc                	ld	a5,72(s1)
    800034b4:	68b8                	ld	a4,80(s1)
    800034b6:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800034b8:	0005d797          	auipc	a5,0x5d
    800034bc:	00878793          	addi	a5,a5,8 # 800604c0 <bcache+0x8000>
    800034c0:	2b87b703          	ld	a4,696(a5)
    800034c4:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800034c6:	0005d717          	auipc	a4,0x5d
    800034ca:	26270713          	addi	a4,a4,610 # 80060728 <bcache+0x8268>
    800034ce:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800034d0:	2b87b703          	ld	a4,696(a5)
    800034d4:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800034d6:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800034da:	00055517          	auipc	a0,0x55
    800034de:	fe650513          	addi	a0,a0,-26 # 800584c0 <bcache>
    800034e2:	ffffd097          	auipc	ra,0xffffd
    800034e6:	7d8080e7          	jalr	2008(ra) # 80000cba <release>
}
    800034ea:	60e2                	ld	ra,24(sp)
    800034ec:	6442                	ld	s0,16(sp)
    800034ee:	64a2                	ld	s1,8(sp)
    800034f0:	6902                	ld	s2,0(sp)
    800034f2:	6105                	addi	sp,sp,32
    800034f4:	8082                	ret
    panic("brelse");
    800034f6:	00005517          	auipc	a0,0x5
    800034fa:	02250513          	addi	a0,a0,34 # 80008518 <syscalls+0xf8>
    800034fe:	ffffd097          	auipc	ra,0xffffd
    80003502:	04c080e7          	jalr	76(ra) # 8000054a <panic>

0000000080003506 <bpin>:

void
bpin(struct buf *b) {
    80003506:	1101                	addi	sp,sp,-32
    80003508:	ec06                	sd	ra,24(sp)
    8000350a:	e822                	sd	s0,16(sp)
    8000350c:	e426                	sd	s1,8(sp)
    8000350e:	1000                	addi	s0,sp,32
    80003510:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003512:	00055517          	auipc	a0,0x55
    80003516:	fae50513          	addi	a0,a0,-82 # 800584c0 <bcache>
    8000351a:	ffffd097          	auipc	ra,0xffffd
    8000351e:	6ec080e7          	jalr	1772(ra) # 80000c06 <acquire>
  b->refcnt++;
    80003522:	40bc                	lw	a5,64(s1)
    80003524:	2785                	addiw	a5,a5,1
    80003526:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003528:	00055517          	auipc	a0,0x55
    8000352c:	f9850513          	addi	a0,a0,-104 # 800584c0 <bcache>
    80003530:	ffffd097          	auipc	ra,0xffffd
    80003534:	78a080e7          	jalr	1930(ra) # 80000cba <release>
}
    80003538:	60e2                	ld	ra,24(sp)
    8000353a:	6442                	ld	s0,16(sp)
    8000353c:	64a2                	ld	s1,8(sp)
    8000353e:	6105                	addi	sp,sp,32
    80003540:	8082                	ret

0000000080003542 <bunpin>:

void
bunpin(struct buf *b) {
    80003542:	1101                	addi	sp,sp,-32
    80003544:	ec06                	sd	ra,24(sp)
    80003546:	e822                	sd	s0,16(sp)
    80003548:	e426                	sd	s1,8(sp)
    8000354a:	1000                	addi	s0,sp,32
    8000354c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000354e:	00055517          	auipc	a0,0x55
    80003552:	f7250513          	addi	a0,a0,-142 # 800584c0 <bcache>
    80003556:	ffffd097          	auipc	ra,0xffffd
    8000355a:	6b0080e7          	jalr	1712(ra) # 80000c06 <acquire>
  b->refcnt--;
    8000355e:	40bc                	lw	a5,64(s1)
    80003560:	37fd                	addiw	a5,a5,-1
    80003562:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003564:	00055517          	auipc	a0,0x55
    80003568:	f5c50513          	addi	a0,a0,-164 # 800584c0 <bcache>
    8000356c:	ffffd097          	auipc	ra,0xffffd
    80003570:	74e080e7          	jalr	1870(ra) # 80000cba <release>
}
    80003574:	60e2                	ld	ra,24(sp)
    80003576:	6442                	ld	s0,16(sp)
    80003578:	64a2                	ld	s1,8(sp)
    8000357a:	6105                	addi	sp,sp,32
    8000357c:	8082                	ret

000000008000357e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000357e:	1101                	addi	sp,sp,-32
    80003580:	ec06                	sd	ra,24(sp)
    80003582:	e822                	sd	s0,16(sp)
    80003584:	e426                	sd	s1,8(sp)
    80003586:	e04a                	sd	s2,0(sp)
    80003588:	1000                	addi	s0,sp,32
    8000358a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000358c:	00d5d59b          	srliw	a1,a1,0xd
    80003590:	0005d797          	auipc	a5,0x5d
    80003594:	60c7a783          	lw	a5,1548(a5) # 80060b9c <sb+0x1c>
    80003598:	9dbd                	addw	a1,a1,a5
    8000359a:	00000097          	auipc	ra,0x0
    8000359e:	d9e080e7          	jalr	-610(ra) # 80003338 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800035a2:	0074f713          	andi	a4,s1,7
    800035a6:	4785                	li	a5,1
    800035a8:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800035ac:	14ce                	slli	s1,s1,0x33
    800035ae:	90d9                	srli	s1,s1,0x36
    800035b0:	00950733          	add	a4,a0,s1
    800035b4:	05874703          	lbu	a4,88(a4)
    800035b8:	00e7f6b3          	and	a3,a5,a4
    800035bc:	c69d                	beqz	a3,800035ea <bfree+0x6c>
    800035be:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800035c0:	94aa                	add	s1,s1,a0
    800035c2:	fff7c793          	not	a5,a5
    800035c6:	8ff9                	and	a5,a5,a4
    800035c8:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800035cc:	00001097          	auipc	ra,0x1
    800035d0:	11a080e7          	jalr	282(ra) # 800046e6 <log_write>
  brelse(bp);
    800035d4:	854a                	mv	a0,s2
    800035d6:	00000097          	auipc	ra,0x0
    800035da:	e92080e7          	jalr	-366(ra) # 80003468 <brelse>
}
    800035de:	60e2                	ld	ra,24(sp)
    800035e0:	6442                	ld	s0,16(sp)
    800035e2:	64a2                	ld	s1,8(sp)
    800035e4:	6902                	ld	s2,0(sp)
    800035e6:	6105                	addi	sp,sp,32
    800035e8:	8082                	ret
    panic("freeing free block");
    800035ea:	00005517          	auipc	a0,0x5
    800035ee:	f3650513          	addi	a0,a0,-202 # 80008520 <syscalls+0x100>
    800035f2:	ffffd097          	auipc	ra,0xffffd
    800035f6:	f58080e7          	jalr	-168(ra) # 8000054a <panic>

00000000800035fa <balloc>:
{
    800035fa:	711d                	addi	sp,sp,-96
    800035fc:	ec86                	sd	ra,88(sp)
    800035fe:	e8a2                	sd	s0,80(sp)
    80003600:	e4a6                	sd	s1,72(sp)
    80003602:	e0ca                	sd	s2,64(sp)
    80003604:	fc4e                	sd	s3,56(sp)
    80003606:	f852                	sd	s4,48(sp)
    80003608:	f456                	sd	s5,40(sp)
    8000360a:	f05a                	sd	s6,32(sp)
    8000360c:	ec5e                	sd	s7,24(sp)
    8000360e:	e862                	sd	s8,16(sp)
    80003610:	e466                	sd	s9,8(sp)
    80003612:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003614:	0005d797          	auipc	a5,0x5d
    80003618:	5707a783          	lw	a5,1392(a5) # 80060b84 <sb+0x4>
    8000361c:	cbd1                	beqz	a5,800036b0 <balloc+0xb6>
    8000361e:	8baa                	mv	s7,a0
    80003620:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003622:	0005db17          	auipc	s6,0x5d
    80003626:	55eb0b13          	addi	s6,s6,1374 # 80060b80 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000362a:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000362c:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000362e:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003630:	6c89                	lui	s9,0x2
    80003632:	a831                	j	8000364e <balloc+0x54>
    brelse(bp);
    80003634:	854a                	mv	a0,s2
    80003636:	00000097          	auipc	ra,0x0
    8000363a:	e32080e7          	jalr	-462(ra) # 80003468 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000363e:	015c87bb          	addw	a5,s9,s5
    80003642:	00078a9b          	sext.w	s5,a5
    80003646:	004b2703          	lw	a4,4(s6)
    8000364a:	06eaf363          	bgeu	s5,a4,800036b0 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    8000364e:	41fad79b          	sraiw	a5,s5,0x1f
    80003652:	0137d79b          	srliw	a5,a5,0x13
    80003656:	015787bb          	addw	a5,a5,s5
    8000365a:	40d7d79b          	sraiw	a5,a5,0xd
    8000365e:	01cb2583          	lw	a1,28(s6)
    80003662:	9dbd                	addw	a1,a1,a5
    80003664:	855e                	mv	a0,s7
    80003666:	00000097          	auipc	ra,0x0
    8000366a:	cd2080e7          	jalr	-814(ra) # 80003338 <bread>
    8000366e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003670:	004b2503          	lw	a0,4(s6)
    80003674:	000a849b          	sext.w	s1,s5
    80003678:	8662                	mv	a2,s8
    8000367a:	faa4fde3          	bgeu	s1,a0,80003634 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000367e:	41f6579b          	sraiw	a5,a2,0x1f
    80003682:	01d7d69b          	srliw	a3,a5,0x1d
    80003686:	00c6873b          	addw	a4,a3,a2
    8000368a:	00777793          	andi	a5,a4,7
    8000368e:	9f95                	subw	a5,a5,a3
    80003690:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003694:	4037571b          	sraiw	a4,a4,0x3
    80003698:	00e906b3          	add	a3,s2,a4
    8000369c:	0586c683          	lbu	a3,88(a3)
    800036a0:	00d7f5b3          	and	a1,a5,a3
    800036a4:	cd91                	beqz	a1,800036c0 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800036a6:	2605                	addiw	a2,a2,1
    800036a8:	2485                	addiw	s1,s1,1
    800036aa:	fd4618e3          	bne	a2,s4,8000367a <balloc+0x80>
    800036ae:	b759                	j	80003634 <balloc+0x3a>
  panic("balloc: out of blocks");
    800036b0:	00005517          	auipc	a0,0x5
    800036b4:	e8850513          	addi	a0,a0,-376 # 80008538 <syscalls+0x118>
    800036b8:	ffffd097          	auipc	ra,0xffffd
    800036bc:	e92080e7          	jalr	-366(ra) # 8000054a <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800036c0:	974a                	add	a4,a4,s2
    800036c2:	8fd5                	or	a5,a5,a3
    800036c4:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800036c8:	854a                	mv	a0,s2
    800036ca:	00001097          	auipc	ra,0x1
    800036ce:	01c080e7          	jalr	28(ra) # 800046e6 <log_write>
        brelse(bp);
    800036d2:	854a                	mv	a0,s2
    800036d4:	00000097          	auipc	ra,0x0
    800036d8:	d94080e7          	jalr	-620(ra) # 80003468 <brelse>
  bp = bread(dev, bno);
    800036dc:	85a6                	mv	a1,s1
    800036de:	855e                	mv	a0,s7
    800036e0:	00000097          	auipc	ra,0x0
    800036e4:	c58080e7          	jalr	-936(ra) # 80003338 <bread>
    800036e8:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800036ea:	40000613          	li	a2,1024
    800036ee:	4581                	li	a1,0
    800036f0:	05850513          	addi	a0,a0,88
    800036f4:	ffffd097          	auipc	ra,0xffffd
    800036f8:	60e080e7          	jalr	1550(ra) # 80000d02 <memset>
  log_write(bp);
    800036fc:	854a                	mv	a0,s2
    800036fe:	00001097          	auipc	ra,0x1
    80003702:	fe8080e7          	jalr	-24(ra) # 800046e6 <log_write>
  brelse(bp);
    80003706:	854a                	mv	a0,s2
    80003708:	00000097          	auipc	ra,0x0
    8000370c:	d60080e7          	jalr	-672(ra) # 80003468 <brelse>
}
    80003710:	8526                	mv	a0,s1
    80003712:	60e6                	ld	ra,88(sp)
    80003714:	6446                	ld	s0,80(sp)
    80003716:	64a6                	ld	s1,72(sp)
    80003718:	6906                	ld	s2,64(sp)
    8000371a:	79e2                	ld	s3,56(sp)
    8000371c:	7a42                	ld	s4,48(sp)
    8000371e:	7aa2                	ld	s5,40(sp)
    80003720:	7b02                	ld	s6,32(sp)
    80003722:	6be2                	ld	s7,24(sp)
    80003724:	6c42                	ld	s8,16(sp)
    80003726:	6ca2                	ld	s9,8(sp)
    80003728:	6125                	addi	sp,sp,96
    8000372a:	8082                	ret

000000008000372c <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000372c:	7179                	addi	sp,sp,-48
    8000372e:	f406                	sd	ra,40(sp)
    80003730:	f022                	sd	s0,32(sp)
    80003732:	ec26                	sd	s1,24(sp)
    80003734:	e84a                	sd	s2,16(sp)
    80003736:	e44e                	sd	s3,8(sp)
    80003738:	e052                	sd	s4,0(sp)
    8000373a:	1800                	addi	s0,sp,48
    8000373c:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000373e:	47ad                	li	a5,11
    80003740:	04b7fe63          	bgeu	a5,a1,8000379c <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80003744:	ff45849b          	addiw	s1,a1,-12
    80003748:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000374c:	0ff00793          	li	a5,255
    80003750:	0ae7e363          	bltu	a5,a4,800037f6 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80003754:	08052583          	lw	a1,128(a0)
    80003758:	c5ad                	beqz	a1,800037c2 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000375a:	00092503          	lw	a0,0(s2)
    8000375e:	00000097          	auipc	ra,0x0
    80003762:	bda080e7          	jalr	-1062(ra) # 80003338 <bread>
    80003766:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003768:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000376c:	02049593          	slli	a1,s1,0x20
    80003770:	9181                	srli	a1,a1,0x20
    80003772:	058a                	slli	a1,a1,0x2
    80003774:	00b784b3          	add	s1,a5,a1
    80003778:	0004a983          	lw	s3,0(s1)
    8000377c:	04098d63          	beqz	s3,800037d6 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003780:	8552                	mv	a0,s4
    80003782:	00000097          	auipc	ra,0x0
    80003786:	ce6080e7          	jalr	-794(ra) # 80003468 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000378a:	854e                	mv	a0,s3
    8000378c:	70a2                	ld	ra,40(sp)
    8000378e:	7402                	ld	s0,32(sp)
    80003790:	64e2                	ld	s1,24(sp)
    80003792:	6942                	ld	s2,16(sp)
    80003794:	69a2                	ld	s3,8(sp)
    80003796:	6a02                	ld	s4,0(sp)
    80003798:	6145                	addi	sp,sp,48
    8000379a:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000379c:	02059493          	slli	s1,a1,0x20
    800037a0:	9081                	srli	s1,s1,0x20
    800037a2:	048a                	slli	s1,s1,0x2
    800037a4:	94aa                	add	s1,s1,a0
    800037a6:	0504a983          	lw	s3,80(s1)
    800037aa:	fe0990e3          	bnez	s3,8000378a <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800037ae:	4108                	lw	a0,0(a0)
    800037b0:	00000097          	auipc	ra,0x0
    800037b4:	e4a080e7          	jalr	-438(ra) # 800035fa <balloc>
    800037b8:	0005099b          	sext.w	s3,a0
    800037bc:	0534a823          	sw	s3,80(s1)
    800037c0:	b7e9                	j	8000378a <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800037c2:	4108                	lw	a0,0(a0)
    800037c4:	00000097          	auipc	ra,0x0
    800037c8:	e36080e7          	jalr	-458(ra) # 800035fa <balloc>
    800037cc:	0005059b          	sext.w	a1,a0
    800037d0:	08b92023          	sw	a1,128(s2)
    800037d4:	b759                	j	8000375a <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800037d6:	00092503          	lw	a0,0(s2)
    800037da:	00000097          	auipc	ra,0x0
    800037de:	e20080e7          	jalr	-480(ra) # 800035fa <balloc>
    800037e2:	0005099b          	sext.w	s3,a0
    800037e6:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800037ea:	8552                	mv	a0,s4
    800037ec:	00001097          	auipc	ra,0x1
    800037f0:	efa080e7          	jalr	-262(ra) # 800046e6 <log_write>
    800037f4:	b771                	j	80003780 <bmap+0x54>
  panic("bmap: out of range");
    800037f6:	00005517          	auipc	a0,0x5
    800037fa:	d5a50513          	addi	a0,a0,-678 # 80008550 <syscalls+0x130>
    800037fe:	ffffd097          	auipc	ra,0xffffd
    80003802:	d4c080e7          	jalr	-692(ra) # 8000054a <panic>

0000000080003806 <iget>:
{
    80003806:	7179                	addi	sp,sp,-48
    80003808:	f406                	sd	ra,40(sp)
    8000380a:	f022                	sd	s0,32(sp)
    8000380c:	ec26                	sd	s1,24(sp)
    8000380e:	e84a                	sd	s2,16(sp)
    80003810:	e44e                	sd	s3,8(sp)
    80003812:	e052                	sd	s4,0(sp)
    80003814:	1800                	addi	s0,sp,48
    80003816:	89aa                	mv	s3,a0
    80003818:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    8000381a:	0005d517          	auipc	a0,0x5d
    8000381e:	38650513          	addi	a0,a0,902 # 80060ba0 <icache>
    80003822:	ffffd097          	auipc	ra,0xffffd
    80003826:	3e4080e7          	jalr	996(ra) # 80000c06 <acquire>
  empty = 0;
    8000382a:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    8000382c:	0005d497          	auipc	s1,0x5d
    80003830:	38c48493          	addi	s1,s1,908 # 80060bb8 <icache+0x18>
    80003834:	0005f697          	auipc	a3,0x5f
    80003838:	e1468693          	addi	a3,a3,-492 # 80062648 <log>
    8000383c:	a039                	j	8000384a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000383e:	02090b63          	beqz	s2,80003874 <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003842:	08848493          	addi	s1,s1,136
    80003846:	02d48a63          	beq	s1,a3,8000387a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000384a:	449c                	lw	a5,8(s1)
    8000384c:	fef059e3          	blez	a5,8000383e <iget+0x38>
    80003850:	4098                	lw	a4,0(s1)
    80003852:	ff3716e3          	bne	a4,s3,8000383e <iget+0x38>
    80003856:	40d8                	lw	a4,4(s1)
    80003858:	ff4713e3          	bne	a4,s4,8000383e <iget+0x38>
      ip->ref++;
    8000385c:	2785                	addiw	a5,a5,1
    8000385e:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    80003860:	0005d517          	auipc	a0,0x5d
    80003864:	34050513          	addi	a0,a0,832 # 80060ba0 <icache>
    80003868:	ffffd097          	auipc	ra,0xffffd
    8000386c:	452080e7          	jalr	1106(ra) # 80000cba <release>
      return ip;
    80003870:	8926                	mv	s2,s1
    80003872:	a03d                	j	800038a0 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003874:	f7f9                	bnez	a5,80003842 <iget+0x3c>
    80003876:	8926                	mv	s2,s1
    80003878:	b7e9                	j	80003842 <iget+0x3c>
  if(empty == 0)
    8000387a:	02090c63          	beqz	s2,800038b2 <iget+0xac>
  ip->dev = dev;
    8000387e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003882:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003886:	4785                	li	a5,1
    80003888:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000388c:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    80003890:	0005d517          	auipc	a0,0x5d
    80003894:	31050513          	addi	a0,a0,784 # 80060ba0 <icache>
    80003898:	ffffd097          	auipc	ra,0xffffd
    8000389c:	422080e7          	jalr	1058(ra) # 80000cba <release>
}
    800038a0:	854a                	mv	a0,s2
    800038a2:	70a2                	ld	ra,40(sp)
    800038a4:	7402                	ld	s0,32(sp)
    800038a6:	64e2                	ld	s1,24(sp)
    800038a8:	6942                	ld	s2,16(sp)
    800038aa:	69a2                	ld	s3,8(sp)
    800038ac:	6a02                	ld	s4,0(sp)
    800038ae:	6145                	addi	sp,sp,48
    800038b0:	8082                	ret
    panic("iget: no inodes");
    800038b2:	00005517          	auipc	a0,0x5
    800038b6:	cb650513          	addi	a0,a0,-842 # 80008568 <syscalls+0x148>
    800038ba:	ffffd097          	auipc	ra,0xffffd
    800038be:	c90080e7          	jalr	-880(ra) # 8000054a <panic>

00000000800038c2 <fsinit>:
fsinit(int dev) {
    800038c2:	7179                	addi	sp,sp,-48
    800038c4:	f406                	sd	ra,40(sp)
    800038c6:	f022                	sd	s0,32(sp)
    800038c8:	ec26                	sd	s1,24(sp)
    800038ca:	e84a                	sd	s2,16(sp)
    800038cc:	e44e                	sd	s3,8(sp)
    800038ce:	1800                	addi	s0,sp,48
    800038d0:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800038d2:	4585                	li	a1,1
    800038d4:	00000097          	auipc	ra,0x0
    800038d8:	a64080e7          	jalr	-1436(ra) # 80003338 <bread>
    800038dc:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800038de:	0005d997          	auipc	s3,0x5d
    800038e2:	2a298993          	addi	s3,s3,674 # 80060b80 <sb>
    800038e6:	02000613          	li	a2,32
    800038ea:	05850593          	addi	a1,a0,88
    800038ee:	854e                	mv	a0,s3
    800038f0:	ffffd097          	auipc	ra,0xffffd
    800038f4:	46e080e7          	jalr	1134(ra) # 80000d5e <memmove>
  brelse(bp);
    800038f8:	8526                	mv	a0,s1
    800038fa:	00000097          	auipc	ra,0x0
    800038fe:	b6e080e7          	jalr	-1170(ra) # 80003468 <brelse>
  if(sb.magic != FSMAGIC)
    80003902:	0009a703          	lw	a4,0(s3)
    80003906:	102037b7          	lui	a5,0x10203
    8000390a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000390e:	02f71263          	bne	a4,a5,80003932 <fsinit+0x70>
  initlog(dev, &sb);
    80003912:	0005d597          	auipc	a1,0x5d
    80003916:	26e58593          	addi	a1,a1,622 # 80060b80 <sb>
    8000391a:	854a                	mv	a0,s2
    8000391c:	00001097          	auipc	ra,0x1
    80003920:	b4e080e7          	jalr	-1202(ra) # 8000446a <initlog>
}
    80003924:	70a2                	ld	ra,40(sp)
    80003926:	7402                	ld	s0,32(sp)
    80003928:	64e2                	ld	s1,24(sp)
    8000392a:	6942                	ld	s2,16(sp)
    8000392c:	69a2                	ld	s3,8(sp)
    8000392e:	6145                	addi	sp,sp,48
    80003930:	8082                	ret
    panic("invalid file system");
    80003932:	00005517          	auipc	a0,0x5
    80003936:	c4650513          	addi	a0,a0,-954 # 80008578 <syscalls+0x158>
    8000393a:	ffffd097          	auipc	ra,0xffffd
    8000393e:	c10080e7          	jalr	-1008(ra) # 8000054a <panic>

0000000080003942 <iinit>:
{
    80003942:	7179                	addi	sp,sp,-48
    80003944:	f406                	sd	ra,40(sp)
    80003946:	f022                	sd	s0,32(sp)
    80003948:	ec26                	sd	s1,24(sp)
    8000394a:	e84a                	sd	s2,16(sp)
    8000394c:	e44e                	sd	s3,8(sp)
    8000394e:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    80003950:	00005597          	auipc	a1,0x5
    80003954:	c4058593          	addi	a1,a1,-960 # 80008590 <syscalls+0x170>
    80003958:	0005d517          	auipc	a0,0x5d
    8000395c:	24850513          	addi	a0,a0,584 # 80060ba0 <icache>
    80003960:	ffffd097          	auipc	ra,0xffffd
    80003964:	216080e7          	jalr	534(ra) # 80000b76 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003968:	0005d497          	auipc	s1,0x5d
    8000396c:	26048493          	addi	s1,s1,608 # 80060bc8 <icache+0x28>
    80003970:	0005f997          	auipc	s3,0x5f
    80003974:	ce898993          	addi	s3,s3,-792 # 80062658 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    80003978:	00005917          	auipc	s2,0x5
    8000397c:	c2090913          	addi	s2,s2,-992 # 80008598 <syscalls+0x178>
    80003980:	85ca                	mv	a1,s2
    80003982:	8526                	mv	a0,s1
    80003984:	00001097          	auipc	ra,0x1
    80003988:	e50080e7          	jalr	-432(ra) # 800047d4 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000398c:	08848493          	addi	s1,s1,136
    80003990:	ff3498e3          	bne	s1,s3,80003980 <iinit+0x3e>
}
    80003994:	70a2                	ld	ra,40(sp)
    80003996:	7402                	ld	s0,32(sp)
    80003998:	64e2                	ld	s1,24(sp)
    8000399a:	6942                	ld	s2,16(sp)
    8000399c:	69a2                	ld	s3,8(sp)
    8000399e:	6145                	addi	sp,sp,48
    800039a0:	8082                	ret

00000000800039a2 <ialloc>:
{
    800039a2:	715d                	addi	sp,sp,-80
    800039a4:	e486                	sd	ra,72(sp)
    800039a6:	e0a2                	sd	s0,64(sp)
    800039a8:	fc26                	sd	s1,56(sp)
    800039aa:	f84a                	sd	s2,48(sp)
    800039ac:	f44e                	sd	s3,40(sp)
    800039ae:	f052                	sd	s4,32(sp)
    800039b0:	ec56                	sd	s5,24(sp)
    800039b2:	e85a                	sd	s6,16(sp)
    800039b4:	e45e                	sd	s7,8(sp)
    800039b6:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800039b8:	0005d717          	auipc	a4,0x5d
    800039bc:	1d472703          	lw	a4,468(a4) # 80060b8c <sb+0xc>
    800039c0:	4785                	li	a5,1
    800039c2:	04e7fa63          	bgeu	a5,a4,80003a16 <ialloc+0x74>
    800039c6:	8aaa                	mv	s5,a0
    800039c8:	8bae                	mv	s7,a1
    800039ca:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800039cc:	0005da17          	auipc	s4,0x5d
    800039d0:	1b4a0a13          	addi	s4,s4,436 # 80060b80 <sb>
    800039d4:	00048b1b          	sext.w	s6,s1
    800039d8:	0044d793          	srli	a5,s1,0x4
    800039dc:	018a2583          	lw	a1,24(s4)
    800039e0:	9dbd                	addw	a1,a1,a5
    800039e2:	8556                	mv	a0,s5
    800039e4:	00000097          	auipc	ra,0x0
    800039e8:	954080e7          	jalr	-1708(ra) # 80003338 <bread>
    800039ec:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800039ee:	05850993          	addi	s3,a0,88
    800039f2:	00f4f793          	andi	a5,s1,15
    800039f6:	079a                	slli	a5,a5,0x6
    800039f8:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800039fa:	00099783          	lh	a5,0(s3)
    800039fe:	c785                	beqz	a5,80003a26 <ialloc+0x84>
    brelse(bp);
    80003a00:	00000097          	auipc	ra,0x0
    80003a04:	a68080e7          	jalr	-1432(ra) # 80003468 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003a08:	0485                	addi	s1,s1,1
    80003a0a:	00ca2703          	lw	a4,12(s4)
    80003a0e:	0004879b          	sext.w	a5,s1
    80003a12:	fce7e1e3          	bltu	a5,a4,800039d4 <ialloc+0x32>
  panic("ialloc: no inodes");
    80003a16:	00005517          	auipc	a0,0x5
    80003a1a:	b8a50513          	addi	a0,a0,-1142 # 800085a0 <syscalls+0x180>
    80003a1e:	ffffd097          	auipc	ra,0xffffd
    80003a22:	b2c080e7          	jalr	-1236(ra) # 8000054a <panic>
      memset(dip, 0, sizeof(*dip));
    80003a26:	04000613          	li	a2,64
    80003a2a:	4581                	li	a1,0
    80003a2c:	854e                	mv	a0,s3
    80003a2e:	ffffd097          	auipc	ra,0xffffd
    80003a32:	2d4080e7          	jalr	724(ra) # 80000d02 <memset>
      dip->type = type;
    80003a36:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003a3a:	854a                	mv	a0,s2
    80003a3c:	00001097          	auipc	ra,0x1
    80003a40:	caa080e7          	jalr	-854(ra) # 800046e6 <log_write>
      brelse(bp);
    80003a44:	854a                	mv	a0,s2
    80003a46:	00000097          	auipc	ra,0x0
    80003a4a:	a22080e7          	jalr	-1502(ra) # 80003468 <brelse>
      return iget(dev, inum);
    80003a4e:	85da                	mv	a1,s6
    80003a50:	8556                	mv	a0,s5
    80003a52:	00000097          	auipc	ra,0x0
    80003a56:	db4080e7          	jalr	-588(ra) # 80003806 <iget>
}
    80003a5a:	60a6                	ld	ra,72(sp)
    80003a5c:	6406                	ld	s0,64(sp)
    80003a5e:	74e2                	ld	s1,56(sp)
    80003a60:	7942                	ld	s2,48(sp)
    80003a62:	79a2                	ld	s3,40(sp)
    80003a64:	7a02                	ld	s4,32(sp)
    80003a66:	6ae2                	ld	s5,24(sp)
    80003a68:	6b42                	ld	s6,16(sp)
    80003a6a:	6ba2                	ld	s7,8(sp)
    80003a6c:	6161                	addi	sp,sp,80
    80003a6e:	8082                	ret

0000000080003a70 <iupdate>:
{
    80003a70:	1101                	addi	sp,sp,-32
    80003a72:	ec06                	sd	ra,24(sp)
    80003a74:	e822                	sd	s0,16(sp)
    80003a76:	e426                	sd	s1,8(sp)
    80003a78:	e04a                	sd	s2,0(sp)
    80003a7a:	1000                	addi	s0,sp,32
    80003a7c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003a7e:	415c                	lw	a5,4(a0)
    80003a80:	0047d79b          	srliw	a5,a5,0x4
    80003a84:	0005d597          	auipc	a1,0x5d
    80003a88:	1145a583          	lw	a1,276(a1) # 80060b98 <sb+0x18>
    80003a8c:	9dbd                	addw	a1,a1,a5
    80003a8e:	4108                	lw	a0,0(a0)
    80003a90:	00000097          	auipc	ra,0x0
    80003a94:	8a8080e7          	jalr	-1880(ra) # 80003338 <bread>
    80003a98:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003a9a:	05850793          	addi	a5,a0,88
    80003a9e:	40c8                	lw	a0,4(s1)
    80003aa0:	893d                	andi	a0,a0,15
    80003aa2:	051a                	slli	a0,a0,0x6
    80003aa4:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003aa6:	04449703          	lh	a4,68(s1)
    80003aaa:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003aae:	04649703          	lh	a4,70(s1)
    80003ab2:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003ab6:	04849703          	lh	a4,72(s1)
    80003aba:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003abe:	04a49703          	lh	a4,74(s1)
    80003ac2:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003ac6:	44f8                	lw	a4,76(s1)
    80003ac8:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003aca:	03400613          	li	a2,52
    80003ace:	05048593          	addi	a1,s1,80
    80003ad2:	0531                	addi	a0,a0,12
    80003ad4:	ffffd097          	auipc	ra,0xffffd
    80003ad8:	28a080e7          	jalr	650(ra) # 80000d5e <memmove>
  log_write(bp);
    80003adc:	854a                	mv	a0,s2
    80003ade:	00001097          	auipc	ra,0x1
    80003ae2:	c08080e7          	jalr	-1016(ra) # 800046e6 <log_write>
  brelse(bp);
    80003ae6:	854a                	mv	a0,s2
    80003ae8:	00000097          	auipc	ra,0x0
    80003aec:	980080e7          	jalr	-1664(ra) # 80003468 <brelse>
}
    80003af0:	60e2                	ld	ra,24(sp)
    80003af2:	6442                	ld	s0,16(sp)
    80003af4:	64a2                	ld	s1,8(sp)
    80003af6:	6902                	ld	s2,0(sp)
    80003af8:	6105                	addi	sp,sp,32
    80003afa:	8082                	ret

0000000080003afc <idup>:
{
    80003afc:	1101                	addi	sp,sp,-32
    80003afe:	ec06                	sd	ra,24(sp)
    80003b00:	e822                	sd	s0,16(sp)
    80003b02:	e426                	sd	s1,8(sp)
    80003b04:	1000                	addi	s0,sp,32
    80003b06:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003b08:	0005d517          	auipc	a0,0x5d
    80003b0c:	09850513          	addi	a0,a0,152 # 80060ba0 <icache>
    80003b10:	ffffd097          	auipc	ra,0xffffd
    80003b14:	0f6080e7          	jalr	246(ra) # 80000c06 <acquire>
  ip->ref++;
    80003b18:	449c                	lw	a5,8(s1)
    80003b1a:	2785                	addiw	a5,a5,1
    80003b1c:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003b1e:	0005d517          	auipc	a0,0x5d
    80003b22:	08250513          	addi	a0,a0,130 # 80060ba0 <icache>
    80003b26:	ffffd097          	auipc	ra,0xffffd
    80003b2a:	194080e7          	jalr	404(ra) # 80000cba <release>
}
    80003b2e:	8526                	mv	a0,s1
    80003b30:	60e2                	ld	ra,24(sp)
    80003b32:	6442                	ld	s0,16(sp)
    80003b34:	64a2                	ld	s1,8(sp)
    80003b36:	6105                	addi	sp,sp,32
    80003b38:	8082                	ret

0000000080003b3a <ilock>:
{
    80003b3a:	1101                	addi	sp,sp,-32
    80003b3c:	ec06                	sd	ra,24(sp)
    80003b3e:	e822                	sd	s0,16(sp)
    80003b40:	e426                	sd	s1,8(sp)
    80003b42:	e04a                	sd	s2,0(sp)
    80003b44:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003b46:	c115                	beqz	a0,80003b6a <ilock+0x30>
    80003b48:	84aa                	mv	s1,a0
    80003b4a:	451c                	lw	a5,8(a0)
    80003b4c:	00f05f63          	blez	a5,80003b6a <ilock+0x30>
  acquiresleep(&ip->lock);
    80003b50:	0541                	addi	a0,a0,16
    80003b52:	00001097          	auipc	ra,0x1
    80003b56:	cbc080e7          	jalr	-836(ra) # 8000480e <acquiresleep>
  if(ip->valid == 0){
    80003b5a:	40bc                	lw	a5,64(s1)
    80003b5c:	cf99                	beqz	a5,80003b7a <ilock+0x40>
}
    80003b5e:	60e2                	ld	ra,24(sp)
    80003b60:	6442                	ld	s0,16(sp)
    80003b62:	64a2                	ld	s1,8(sp)
    80003b64:	6902                	ld	s2,0(sp)
    80003b66:	6105                	addi	sp,sp,32
    80003b68:	8082                	ret
    panic("ilock");
    80003b6a:	00005517          	auipc	a0,0x5
    80003b6e:	a4e50513          	addi	a0,a0,-1458 # 800085b8 <syscalls+0x198>
    80003b72:	ffffd097          	auipc	ra,0xffffd
    80003b76:	9d8080e7          	jalr	-1576(ra) # 8000054a <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003b7a:	40dc                	lw	a5,4(s1)
    80003b7c:	0047d79b          	srliw	a5,a5,0x4
    80003b80:	0005d597          	auipc	a1,0x5d
    80003b84:	0185a583          	lw	a1,24(a1) # 80060b98 <sb+0x18>
    80003b88:	9dbd                	addw	a1,a1,a5
    80003b8a:	4088                	lw	a0,0(s1)
    80003b8c:	fffff097          	auipc	ra,0xfffff
    80003b90:	7ac080e7          	jalr	1964(ra) # 80003338 <bread>
    80003b94:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003b96:	05850593          	addi	a1,a0,88
    80003b9a:	40dc                	lw	a5,4(s1)
    80003b9c:	8bbd                	andi	a5,a5,15
    80003b9e:	079a                	slli	a5,a5,0x6
    80003ba0:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003ba2:	00059783          	lh	a5,0(a1)
    80003ba6:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003baa:	00259783          	lh	a5,2(a1)
    80003bae:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003bb2:	00459783          	lh	a5,4(a1)
    80003bb6:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003bba:	00659783          	lh	a5,6(a1)
    80003bbe:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003bc2:	459c                	lw	a5,8(a1)
    80003bc4:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003bc6:	03400613          	li	a2,52
    80003bca:	05b1                	addi	a1,a1,12
    80003bcc:	05048513          	addi	a0,s1,80
    80003bd0:	ffffd097          	auipc	ra,0xffffd
    80003bd4:	18e080e7          	jalr	398(ra) # 80000d5e <memmove>
    brelse(bp);
    80003bd8:	854a                	mv	a0,s2
    80003bda:	00000097          	auipc	ra,0x0
    80003bde:	88e080e7          	jalr	-1906(ra) # 80003468 <brelse>
    ip->valid = 1;
    80003be2:	4785                	li	a5,1
    80003be4:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003be6:	04449783          	lh	a5,68(s1)
    80003bea:	fbb5                	bnez	a5,80003b5e <ilock+0x24>
      panic("ilock: no type");
    80003bec:	00005517          	auipc	a0,0x5
    80003bf0:	9d450513          	addi	a0,a0,-1580 # 800085c0 <syscalls+0x1a0>
    80003bf4:	ffffd097          	auipc	ra,0xffffd
    80003bf8:	956080e7          	jalr	-1706(ra) # 8000054a <panic>

0000000080003bfc <iunlock>:
{
    80003bfc:	1101                	addi	sp,sp,-32
    80003bfe:	ec06                	sd	ra,24(sp)
    80003c00:	e822                	sd	s0,16(sp)
    80003c02:	e426                	sd	s1,8(sp)
    80003c04:	e04a                	sd	s2,0(sp)
    80003c06:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003c08:	c905                	beqz	a0,80003c38 <iunlock+0x3c>
    80003c0a:	84aa                	mv	s1,a0
    80003c0c:	01050913          	addi	s2,a0,16
    80003c10:	854a                	mv	a0,s2
    80003c12:	00001097          	auipc	ra,0x1
    80003c16:	c96080e7          	jalr	-874(ra) # 800048a8 <holdingsleep>
    80003c1a:	cd19                	beqz	a0,80003c38 <iunlock+0x3c>
    80003c1c:	449c                	lw	a5,8(s1)
    80003c1e:	00f05d63          	blez	a5,80003c38 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003c22:	854a                	mv	a0,s2
    80003c24:	00001097          	auipc	ra,0x1
    80003c28:	c40080e7          	jalr	-960(ra) # 80004864 <releasesleep>
}
    80003c2c:	60e2                	ld	ra,24(sp)
    80003c2e:	6442                	ld	s0,16(sp)
    80003c30:	64a2                	ld	s1,8(sp)
    80003c32:	6902                	ld	s2,0(sp)
    80003c34:	6105                	addi	sp,sp,32
    80003c36:	8082                	ret
    panic("iunlock");
    80003c38:	00005517          	auipc	a0,0x5
    80003c3c:	99850513          	addi	a0,a0,-1640 # 800085d0 <syscalls+0x1b0>
    80003c40:	ffffd097          	auipc	ra,0xffffd
    80003c44:	90a080e7          	jalr	-1782(ra) # 8000054a <panic>

0000000080003c48 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003c48:	7179                	addi	sp,sp,-48
    80003c4a:	f406                	sd	ra,40(sp)
    80003c4c:	f022                	sd	s0,32(sp)
    80003c4e:	ec26                	sd	s1,24(sp)
    80003c50:	e84a                	sd	s2,16(sp)
    80003c52:	e44e                	sd	s3,8(sp)
    80003c54:	e052                	sd	s4,0(sp)
    80003c56:	1800                	addi	s0,sp,48
    80003c58:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003c5a:	05050493          	addi	s1,a0,80
    80003c5e:	08050913          	addi	s2,a0,128
    80003c62:	a021                	j	80003c6a <itrunc+0x22>
    80003c64:	0491                	addi	s1,s1,4
    80003c66:	01248d63          	beq	s1,s2,80003c80 <itrunc+0x38>
    if(ip->addrs[i]){
    80003c6a:	408c                	lw	a1,0(s1)
    80003c6c:	dde5                	beqz	a1,80003c64 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003c6e:	0009a503          	lw	a0,0(s3)
    80003c72:	00000097          	auipc	ra,0x0
    80003c76:	90c080e7          	jalr	-1780(ra) # 8000357e <bfree>
      ip->addrs[i] = 0;
    80003c7a:	0004a023          	sw	zero,0(s1)
    80003c7e:	b7dd                	j	80003c64 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003c80:	0809a583          	lw	a1,128(s3)
    80003c84:	e185                	bnez	a1,80003ca4 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003c86:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003c8a:	854e                	mv	a0,s3
    80003c8c:	00000097          	auipc	ra,0x0
    80003c90:	de4080e7          	jalr	-540(ra) # 80003a70 <iupdate>
}
    80003c94:	70a2                	ld	ra,40(sp)
    80003c96:	7402                	ld	s0,32(sp)
    80003c98:	64e2                	ld	s1,24(sp)
    80003c9a:	6942                	ld	s2,16(sp)
    80003c9c:	69a2                	ld	s3,8(sp)
    80003c9e:	6a02                	ld	s4,0(sp)
    80003ca0:	6145                	addi	sp,sp,48
    80003ca2:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003ca4:	0009a503          	lw	a0,0(s3)
    80003ca8:	fffff097          	auipc	ra,0xfffff
    80003cac:	690080e7          	jalr	1680(ra) # 80003338 <bread>
    80003cb0:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003cb2:	05850493          	addi	s1,a0,88
    80003cb6:	45850913          	addi	s2,a0,1112
    80003cba:	a021                	j	80003cc2 <itrunc+0x7a>
    80003cbc:	0491                	addi	s1,s1,4
    80003cbe:	01248b63          	beq	s1,s2,80003cd4 <itrunc+0x8c>
      if(a[j])
    80003cc2:	408c                	lw	a1,0(s1)
    80003cc4:	dde5                	beqz	a1,80003cbc <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003cc6:	0009a503          	lw	a0,0(s3)
    80003cca:	00000097          	auipc	ra,0x0
    80003cce:	8b4080e7          	jalr	-1868(ra) # 8000357e <bfree>
    80003cd2:	b7ed                	j	80003cbc <itrunc+0x74>
    brelse(bp);
    80003cd4:	8552                	mv	a0,s4
    80003cd6:	fffff097          	auipc	ra,0xfffff
    80003cda:	792080e7          	jalr	1938(ra) # 80003468 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003cde:	0809a583          	lw	a1,128(s3)
    80003ce2:	0009a503          	lw	a0,0(s3)
    80003ce6:	00000097          	auipc	ra,0x0
    80003cea:	898080e7          	jalr	-1896(ra) # 8000357e <bfree>
    ip->addrs[NDIRECT] = 0;
    80003cee:	0809a023          	sw	zero,128(s3)
    80003cf2:	bf51                	j	80003c86 <itrunc+0x3e>

0000000080003cf4 <iput>:
{
    80003cf4:	1101                	addi	sp,sp,-32
    80003cf6:	ec06                	sd	ra,24(sp)
    80003cf8:	e822                	sd	s0,16(sp)
    80003cfa:	e426                	sd	s1,8(sp)
    80003cfc:	e04a                	sd	s2,0(sp)
    80003cfe:	1000                	addi	s0,sp,32
    80003d00:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003d02:	0005d517          	auipc	a0,0x5d
    80003d06:	e9e50513          	addi	a0,a0,-354 # 80060ba0 <icache>
    80003d0a:	ffffd097          	auipc	ra,0xffffd
    80003d0e:	efc080e7          	jalr	-260(ra) # 80000c06 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003d12:	4498                	lw	a4,8(s1)
    80003d14:	4785                	li	a5,1
    80003d16:	02f70363          	beq	a4,a5,80003d3c <iput+0x48>
  ip->ref--;
    80003d1a:	449c                	lw	a5,8(s1)
    80003d1c:	37fd                	addiw	a5,a5,-1
    80003d1e:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003d20:	0005d517          	auipc	a0,0x5d
    80003d24:	e8050513          	addi	a0,a0,-384 # 80060ba0 <icache>
    80003d28:	ffffd097          	auipc	ra,0xffffd
    80003d2c:	f92080e7          	jalr	-110(ra) # 80000cba <release>
}
    80003d30:	60e2                	ld	ra,24(sp)
    80003d32:	6442                	ld	s0,16(sp)
    80003d34:	64a2                	ld	s1,8(sp)
    80003d36:	6902                	ld	s2,0(sp)
    80003d38:	6105                	addi	sp,sp,32
    80003d3a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003d3c:	40bc                	lw	a5,64(s1)
    80003d3e:	dff1                	beqz	a5,80003d1a <iput+0x26>
    80003d40:	04a49783          	lh	a5,74(s1)
    80003d44:	fbf9                	bnez	a5,80003d1a <iput+0x26>
    acquiresleep(&ip->lock);
    80003d46:	01048913          	addi	s2,s1,16
    80003d4a:	854a                	mv	a0,s2
    80003d4c:	00001097          	auipc	ra,0x1
    80003d50:	ac2080e7          	jalr	-1342(ra) # 8000480e <acquiresleep>
    release(&icache.lock);
    80003d54:	0005d517          	auipc	a0,0x5d
    80003d58:	e4c50513          	addi	a0,a0,-436 # 80060ba0 <icache>
    80003d5c:	ffffd097          	auipc	ra,0xffffd
    80003d60:	f5e080e7          	jalr	-162(ra) # 80000cba <release>
    itrunc(ip);
    80003d64:	8526                	mv	a0,s1
    80003d66:	00000097          	auipc	ra,0x0
    80003d6a:	ee2080e7          	jalr	-286(ra) # 80003c48 <itrunc>
    ip->type = 0;
    80003d6e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003d72:	8526                	mv	a0,s1
    80003d74:	00000097          	auipc	ra,0x0
    80003d78:	cfc080e7          	jalr	-772(ra) # 80003a70 <iupdate>
    ip->valid = 0;
    80003d7c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003d80:	854a                	mv	a0,s2
    80003d82:	00001097          	auipc	ra,0x1
    80003d86:	ae2080e7          	jalr	-1310(ra) # 80004864 <releasesleep>
    acquire(&icache.lock);
    80003d8a:	0005d517          	auipc	a0,0x5d
    80003d8e:	e1650513          	addi	a0,a0,-490 # 80060ba0 <icache>
    80003d92:	ffffd097          	auipc	ra,0xffffd
    80003d96:	e74080e7          	jalr	-396(ra) # 80000c06 <acquire>
    80003d9a:	b741                	j	80003d1a <iput+0x26>

0000000080003d9c <iunlockput>:
{
    80003d9c:	1101                	addi	sp,sp,-32
    80003d9e:	ec06                	sd	ra,24(sp)
    80003da0:	e822                	sd	s0,16(sp)
    80003da2:	e426                	sd	s1,8(sp)
    80003da4:	1000                	addi	s0,sp,32
    80003da6:	84aa                	mv	s1,a0
  iunlock(ip);
    80003da8:	00000097          	auipc	ra,0x0
    80003dac:	e54080e7          	jalr	-428(ra) # 80003bfc <iunlock>
  iput(ip);
    80003db0:	8526                	mv	a0,s1
    80003db2:	00000097          	auipc	ra,0x0
    80003db6:	f42080e7          	jalr	-190(ra) # 80003cf4 <iput>
}
    80003dba:	60e2                	ld	ra,24(sp)
    80003dbc:	6442                	ld	s0,16(sp)
    80003dbe:	64a2                	ld	s1,8(sp)
    80003dc0:	6105                	addi	sp,sp,32
    80003dc2:	8082                	ret

0000000080003dc4 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003dc4:	1141                	addi	sp,sp,-16
    80003dc6:	e422                	sd	s0,8(sp)
    80003dc8:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003dca:	411c                	lw	a5,0(a0)
    80003dcc:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003dce:	415c                	lw	a5,4(a0)
    80003dd0:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003dd2:	04451783          	lh	a5,68(a0)
    80003dd6:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003dda:	04a51783          	lh	a5,74(a0)
    80003dde:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003de2:	04c56783          	lwu	a5,76(a0)
    80003de6:	e99c                	sd	a5,16(a1)
}
    80003de8:	6422                	ld	s0,8(sp)
    80003dea:	0141                	addi	sp,sp,16
    80003dec:	8082                	ret

0000000080003dee <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003dee:	457c                	lw	a5,76(a0)
    80003df0:	0ed7e963          	bltu	a5,a3,80003ee2 <readi+0xf4>
{
    80003df4:	7159                	addi	sp,sp,-112
    80003df6:	f486                	sd	ra,104(sp)
    80003df8:	f0a2                	sd	s0,96(sp)
    80003dfa:	eca6                	sd	s1,88(sp)
    80003dfc:	e8ca                	sd	s2,80(sp)
    80003dfe:	e4ce                	sd	s3,72(sp)
    80003e00:	e0d2                	sd	s4,64(sp)
    80003e02:	fc56                	sd	s5,56(sp)
    80003e04:	f85a                	sd	s6,48(sp)
    80003e06:	f45e                	sd	s7,40(sp)
    80003e08:	f062                	sd	s8,32(sp)
    80003e0a:	ec66                	sd	s9,24(sp)
    80003e0c:	e86a                	sd	s10,16(sp)
    80003e0e:	e46e                	sd	s11,8(sp)
    80003e10:	1880                	addi	s0,sp,112
    80003e12:	8baa                	mv	s7,a0
    80003e14:	8c2e                	mv	s8,a1
    80003e16:	8ab2                	mv	s5,a2
    80003e18:	84b6                	mv	s1,a3
    80003e1a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003e1c:	9f35                	addw	a4,a4,a3
    return 0;
    80003e1e:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003e20:	0ad76063          	bltu	a4,a3,80003ec0 <readi+0xd2>
  if(off + n > ip->size)
    80003e24:	00e7f463          	bgeu	a5,a4,80003e2c <readi+0x3e>
    n = ip->size - off;
    80003e28:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003e2c:	0a0b0963          	beqz	s6,80003ede <readi+0xf0>
    80003e30:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003e32:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003e36:	5cfd                	li	s9,-1
    80003e38:	a82d                	j	80003e72 <readi+0x84>
    80003e3a:	020a1d93          	slli	s11,s4,0x20
    80003e3e:	020ddd93          	srli	s11,s11,0x20
    80003e42:	05890793          	addi	a5,s2,88
    80003e46:	86ee                	mv	a3,s11
    80003e48:	963e                	add	a2,a2,a5
    80003e4a:	85d6                	mv	a1,s5
    80003e4c:	8562                	mv	a0,s8
    80003e4e:	ffffe097          	auipc	ra,0xffffe
    80003e52:	6d0080e7          	jalr	1744(ra) # 8000251e <either_copyout>
    80003e56:	05950d63          	beq	a0,s9,80003eb0 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003e5a:	854a                	mv	a0,s2
    80003e5c:	fffff097          	auipc	ra,0xfffff
    80003e60:	60c080e7          	jalr	1548(ra) # 80003468 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003e64:	013a09bb          	addw	s3,s4,s3
    80003e68:	009a04bb          	addw	s1,s4,s1
    80003e6c:	9aee                	add	s5,s5,s11
    80003e6e:	0569f763          	bgeu	s3,s6,80003ebc <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003e72:	000ba903          	lw	s2,0(s7)
    80003e76:	00a4d59b          	srliw	a1,s1,0xa
    80003e7a:	855e                	mv	a0,s7
    80003e7c:	00000097          	auipc	ra,0x0
    80003e80:	8b0080e7          	jalr	-1872(ra) # 8000372c <bmap>
    80003e84:	0005059b          	sext.w	a1,a0
    80003e88:	854a                	mv	a0,s2
    80003e8a:	fffff097          	auipc	ra,0xfffff
    80003e8e:	4ae080e7          	jalr	1198(ra) # 80003338 <bread>
    80003e92:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003e94:	3ff4f613          	andi	a2,s1,1023
    80003e98:	40cd07bb          	subw	a5,s10,a2
    80003e9c:	413b073b          	subw	a4,s6,s3
    80003ea0:	8a3e                	mv	s4,a5
    80003ea2:	2781                	sext.w	a5,a5
    80003ea4:	0007069b          	sext.w	a3,a4
    80003ea8:	f8f6f9e3          	bgeu	a3,a5,80003e3a <readi+0x4c>
    80003eac:	8a3a                	mv	s4,a4
    80003eae:	b771                	j	80003e3a <readi+0x4c>
      brelse(bp);
    80003eb0:	854a                	mv	a0,s2
    80003eb2:	fffff097          	auipc	ra,0xfffff
    80003eb6:	5b6080e7          	jalr	1462(ra) # 80003468 <brelse>
      tot = -1;
    80003eba:	59fd                	li	s3,-1
  }
  return tot;
    80003ebc:	0009851b          	sext.w	a0,s3
}
    80003ec0:	70a6                	ld	ra,104(sp)
    80003ec2:	7406                	ld	s0,96(sp)
    80003ec4:	64e6                	ld	s1,88(sp)
    80003ec6:	6946                	ld	s2,80(sp)
    80003ec8:	69a6                	ld	s3,72(sp)
    80003eca:	6a06                	ld	s4,64(sp)
    80003ecc:	7ae2                	ld	s5,56(sp)
    80003ece:	7b42                	ld	s6,48(sp)
    80003ed0:	7ba2                	ld	s7,40(sp)
    80003ed2:	7c02                	ld	s8,32(sp)
    80003ed4:	6ce2                	ld	s9,24(sp)
    80003ed6:	6d42                	ld	s10,16(sp)
    80003ed8:	6da2                	ld	s11,8(sp)
    80003eda:	6165                	addi	sp,sp,112
    80003edc:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003ede:	89da                	mv	s3,s6
    80003ee0:	bff1                	j	80003ebc <readi+0xce>
    return 0;
    80003ee2:	4501                	li	a0,0
}
    80003ee4:	8082                	ret

0000000080003ee6 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003ee6:	457c                	lw	a5,76(a0)
    80003ee8:	10d7e763          	bltu	a5,a3,80003ff6 <writei+0x110>
{
    80003eec:	7159                	addi	sp,sp,-112
    80003eee:	f486                	sd	ra,104(sp)
    80003ef0:	f0a2                	sd	s0,96(sp)
    80003ef2:	eca6                	sd	s1,88(sp)
    80003ef4:	e8ca                	sd	s2,80(sp)
    80003ef6:	e4ce                	sd	s3,72(sp)
    80003ef8:	e0d2                	sd	s4,64(sp)
    80003efa:	fc56                	sd	s5,56(sp)
    80003efc:	f85a                	sd	s6,48(sp)
    80003efe:	f45e                	sd	s7,40(sp)
    80003f00:	f062                	sd	s8,32(sp)
    80003f02:	ec66                	sd	s9,24(sp)
    80003f04:	e86a                	sd	s10,16(sp)
    80003f06:	e46e                	sd	s11,8(sp)
    80003f08:	1880                	addi	s0,sp,112
    80003f0a:	8baa                	mv	s7,a0
    80003f0c:	8c2e                	mv	s8,a1
    80003f0e:	8ab2                	mv	s5,a2
    80003f10:	8936                	mv	s2,a3
    80003f12:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003f14:	00e687bb          	addw	a5,a3,a4
    80003f18:	0ed7e163          	bltu	a5,a3,80003ffa <writei+0x114>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003f1c:	00043737          	lui	a4,0x43
    80003f20:	0cf76f63          	bltu	a4,a5,80003ffe <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003f24:	0a0b0863          	beqz	s6,80003fd4 <writei+0xee>
    80003f28:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f2a:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003f2e:	5cfd                	li	s9,-1
    80003f30:	a091                	j	80003f74 <writei+0x8e>
    80003f32:	02099d93          	slli	s11,s3,0x20
    80003f36:	020ddd93          	srli	s11,s11,0x20
    80003f3a:	05848793          	addi	a5,s1,88
    80003f3e:	86ee                	mv	a3,s11
    80003f40:	8656                	mv	a2,s5
    80003f42:	85e2                	mv	a1,s8
    80003f44:	953e                	add	a0,a0,a5
    80003f46:	ffffe097          	auipc	ra,0xffffe
    80003f4a:	632080e7          	jalr	1586(ra) # 80002578 <either_copyin>
    80003f4e:	07950263          	beq	a0,s9,80003fb2 <writei+0xcc>
      brelse(bp);
      n = -1;
      break;
    }
    log_write(bp);
    80003f52:	8526                	mv	a0,s1
    80003f54:	00000097          	auipc	ra,0x0
    80003f58:	792080e7          	jalr	1938(ra) # 800046e6 <log_write>
    brelse(bp);
    80003f5c:	8526                	mv	a0,s1
    80003f5e:	fffff097          	auipc	ra,0xfffff
    80003f62:	50a080e7          	jalr	1290(ra) # 80003468 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003f66:	01498a3b          	addw	s4,s3,s4
    80003f6a:	0129893b          	addw	s2,s3,s2
    80003f6e:	9aee                	add	s5,s5,s11
    80003f70:	056a7763          	bgeu	s4,s6,80003fbe <writei+0xd8>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003f74:	000ba483          	lw	s1,0(s7)
    80003f78:	00a9559b          	srliw	a1,s2,0xa
    80003f7c:	855e                	mv	a0,s7
    80003f7e:	fffff097          	auipc	ra,0xfffff
    80003f82:	7ae080e7          	jalr	1966(ra) # 8000372c <bmap>
    80003f86:	0005059b          	sext.w	a1,a0
    80003f8a:	8526                	mv	a0,s1
    80003f8c:	fffff097          	auipc	ra,0xfffff
    80003f90:	3ac080e7          	jalr	940(ra) # 80003338 <bread>
    80003f94:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f96:	3ff97513          	andi	a0,s2,1023
    80003f9a:	40ad07bb          	subw	a5,s10,a0
    80003f9e:	414b073b          	subw	a4,s6,s4
    80003fa2:	89be                	mv	s3,a5
    80003fa4:	2781                	sext.w	a5,a5
    80003fa6:	0007069b          	sext.w	a3,a4
    80003faa:	f8f6f4e3          	bgeu	a3,a5,80003f32 <writei+0x4c>
    80003fae:	89ba                	mv	s3,a4
    80003fb0:	b749                	j	80003f32 <writei+0x4c>
      brelse(bp);
    80003fb2:	8526                	mv	a0,s1
    80003fb4:	fffff097          	auipc	ra,0xfffff
    80003fb8:	4b4080e7          	jalr	1204(ra) # 80003468 <brelse>
      n = -1;
    80003fbc:	5b7d                	li	s6,-1
  }

  if(n > 0){
    if(off > ip->size)
    80003fbe:	04cba783          	lw	a5,76(s7)
    80003fc2:	0127f463          	bgeu	a5,s2,80003fca <writei+0xe4>
      ip->size = off;
    80003fc6:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003fca:	855e                	mv	a0,s7
    80003fcc:	00000097          	auipc	ra,0x0
    80003fd0:	aa4080e7          	jalr	-1372(ra) # 80003a70 <iupdate>
  }

  return n;
    80003fd4:	000b051b          	sext.w	a0,s6
}
    80003fd8:	70a6                	ld	ra,104(sp)
    80003fda:	7406                	ld	s0,96(sp)
    80003fdc:	64e6                	ld	s1,88(sp)
    80003fde:	6946                	ld	s2,80(sp)
    80003fe0:	69a6                	ld	s3,72(sp)
    80003fe2:	6a06                	ld	s4,64(sp)
    80003fe4:	7ae2                	ld	s5,56(sp)
    80003fe6:	7b42                	ld	s6,48(sp)
    80003fe8:	7ba2                	ld	s7,40(sp)
    80003fea:	7c02                	ld	s8,32(sp)
    80003fec:	6ce2                	ld	s9,24(sp)
    80003fee:	6d42                	ld	s10,16(sp)
    80003ff0:	6da2                	ld	s11,8(sp)
    80003ff2:	6165                	addi	sp,sp,112
    80003ff4:	8082                	ret
    return -1;
    80003ff6:	557d                	li	a0,-1
}
    80003ff8:	8082                	ret
    return -1;
    80003ffa:	557d                	li	a0,-1
    80003ffc:	bff1                	j	80003fd8 <writei+0xf2>
    return -1;
    80003ffe:	557d                	li	a0,-1
    80004000:	bfe1                	j	80003fd8 <writei+0xf2>

0000000080004002 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004002:	1141                	addi	sp,sp,-16
    80004004:	e406                	sd	ra,8(sp)
    80004006:	e022                	sd	s0,0(sp)
    80004008:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000400a:	4639                	li	a2,14
    8000400c:	ffffd097          	auipc	ra,0xffffd
    80004010:	dce080e7          	jalr	-562(ra) # 80000dda <strncmp>
}
    80004014:	60a2                	ld	ra,8(sp)
    80004016:	6402                	ld	s0,0(sp)
    80004018:	0141                	addi	sp,sp,16
    8000401a:	8082                	ret

000000008000401c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000401c:	7139                	addi	sp,sp,-64
    8000401e:	fc06                	sd	ra,56(sp)
    80004020:	f822                	sd	s0,48(sp)
    80004022:	f426                	sd	s1,40(sp)
    80004024:	f04a                	sd	s2,32(sp)
    80004026:	ec4e                	sd	s3,24(sp)
    80004028:	e852                	sd	s4,16(sp)
    8000402a:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000402c:	04451703          	lh	a4,68(a0)
    80004030:	4785                	li	a5,1
    80004032:	00f71a63          	bne	a4,a5,80004046 <dirlookup+0x2a>
    80004036:	892a                	mv	s2,a0
    80004038:	89ae                	mv	s3,a1
    8000403a:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000403c:	457c                	lw	a5,76(a0)
    8000403e:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004040:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004042:	e79d                	bnez	a5,80004070 <dirlookup+0x54>
    80004044:	a8a5                	j	800040bc <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80004046:	00004517          	auipc	a0,0x4
    8000404a:	59250513          	addi	a0,a0,1426 # 800085d8 <syscalls+0x1b8>
    8000404e:	ffffc097          	auipc	ra,0xffffc
    80004052:	4fc080e7          	jalr	1276(ra) # 8000054a <panic>
      panic("dirlookup read");
    80004056:	00004517          	auipc	a0,0x4
    8000405a:	59a50513          	addi	a0,a0,1434 # 800085f0 <syscalls+0x1d0>
    8000405e:	ffffc097          	auipc	ra,0xffffc
    80004062:	4ec080e7          	jalr	1260(ra) # 8000054a <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004066:	24c1                	addiw	s1,s1,16
    80004068:	04c92783          	lw	a5,76(s2)
    8000406c:	04f4f763          	bgeu	s1,a5,800040ba <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004070:	4741                	li	a4,16
    80004072:	86a6                	mv	a3,s1
    80004074:	fc040613          	addi	a2,s0,-64
    80004078:	4581                	li	a1,0
    8000407a:	854a                	mv	a0,s2
    8000407c:	00000097          	auipc	ra,0x0
    80004080:	d72080e7          	jalr	-654(ra) # 80003dee <readi>
    80004084:	47c1                	li	a5,16
    80004086:	fcf518e3          	bne	a0,a5,80004056 <dirlookup+0x3a>
    if(de.inum == 0)
    8000408a:	fc045783          	lhu	a5,-64(s0)
    8000408e:	dfe1                	beqz	a5,80004066 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80004090:	fc240593          	addi	a1,s0,-62
    80004094:	854e                	mv	a0,s3
    80004096:	00000097          	auipc	ra,0x0
    8000409a:	f6c080e7          	jalr	-148(ra) # 80004002 <namecmp>
    8000409e:	f561                	bnez	a0,80004066 <dirlookup+0x4a>
      if(poff)
    800040a0:	000a0463          	beqz	s4,800040a8 <dirlookup+0x8c>
        *poff = off;
    800040a4:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800040a8:	fc045583          	lhu	a1,-64(s0)
    800040ac:	00092503          	lw	a0,0(s2)
    800040b0:	fffff097          	auipc	ra,0xfffff
    800040b4:	756080e7          	jalr	1878(ra) # 80003806 <iget>
    800040b8:	a011                	j	800040bc <dirlookup+0xa0>
  return 0;
    800040ba:	4501                	li	a0,0
}
    800040bc:	70e2                	ld	ra,56(sp)
    800040be:	7442                	ld	s0,48(sp)
    800040c0:	74a2                	ld	s1,40(sp)
    800040c2:	7902                	ld	s2,32(sp)
    800040c4:	69e2                	ld	s3,24(sp)
    800040c6:	6a42                	ld	s4,16(sp)
    800040c8:	6121                	addi	sp,sp,64
    800040ca:	8082                	ret

00000000800040cc <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800040cc:	711d                	addi	sp,sp,-96
    800040ce:	ec86                	sd	ra,88(sp)
    800040d0:	e8a2                	sd	s0,80(sp)
    800040d2:	e4a6                	sd	s1,72(sp)
    800040d4:	e0ca                	sd	s2,64(sp)
    800040d6:	fc4e                	sd	s3,56(sp)
    800040d8:	f852                	sd	s4,48(sp)
    800040da:	f456                	sd	s5,40(sp)
    800040dc:	f05a                	sd	s6,32(sp)
    800040de:	ec5e                	sd	s7,24(sp)
    800040e0:	e862                	sd	s8,16(sp)
    800040e2:	e466                	sd	s9,8(sp)
    800040e4:	1080                	addi	s0,sp,96
    800040e6:	84aa                	mv	s1,a0
    800040e8:	8aae                	mv	s5,a1
    800040ea:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    800040ec:	00054703          	lbu	a4,0(a0)
    800040f0:	02f00793          	li	a5,47
    800040f4:	02f70563          	beq	a4,a5,8000411e <namex+0x52>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800040f8:	ffffe097          	auipc	ra,0xffffe
    800040fc:	916080e7          	jalr	-1770(ra) # 80001a0e <myproc>
    80004100:	6785                	lui	a5,0x1
    80004102:	97aa                	add	a5,a5,a0
    80004104:	1a07b503          	ld	a0,416(a5) # 11a0 <_entry-0x7fffee60>
    80004108:	00000097          	auipc	ra,0x0
    8000410c:	9f4080e7          	jalr	-1548(ra) # 80003afc <idup>
    80004110:	89aa                	mv	s3,a0
  while(*path == '/')
    80004112:	02f00913          	li	s2,47
  len = path - s;
    80004116:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80004118:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000411a:	4b85                	li	s7,1
    8000411c:	a865                	j	800041d4 <namex+0x108>
    ip = iget(ROOTDEV, ROOTINO);
    8000411e:	4585                	li	a1,1
    80004120:	4505                	li	a0,1
    80004122:	fffff097          	auipc	ra,0xfffff
    80004126:	6e4080e7          	jalr	1764(ra) # 80003806 <iget>
    8000412a:	89aa                	mv	s3,a0
    8000412c:	b7dd                	j	80004112 <namex+0x46>
      iunlockput(ip);
    8000412e:	854e                	mv	a0,s3
    80004130:	00000097          	auipc	ra,0x0
    80004134:	c6c080e7          	jalr	-916(ra) # 80003d9c <iunlockput>
      return 0;
    80004138:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000413a:	854e                	mv	a0,s3
    8000413c:	60e6                	ld	ra,88(sp)
    8000413e:	6446                	ld	s0,80(sp)
    80004140:	64a6                	ld	s1,72(sp)
    80004142:	6906                	ld	s2,64(sp)
    80004144:	79e2                	ld	s3,56(sp)
    80004146:	7a42                	ld	s4,48(sp)
    80004148:	7aa2                	ld	s5,40(sp)
    8000414a:	7b02                	ld	s6,32(sp)
    8000414c:	6be2                	ld	s7,24(sp)
    8000414e:	6c42                	ld	s8,16(sp)
    80004150:	6ca2                	ld	s9,8(sp)
    80004152:	6125                	addi	sp,sp,96
    80004154:	8082                	ret
      iunlock(ip);
    80004156:	854e                	mv	a0,s3
    80004158:	00000097          	auipc	ra,0x0
    8000415c:	aa4080e7          	jalr	-1372(ra) # 80003bfc <iunlock>
      return ip;
    80004160:	bfe9                	j	8000413a <namex+0x6e>
      iunlockput(ip);
    80004162:	854e                	mv	a0,s3
    80004164:	00000097          	auipc	ra,0x0
    80004168:	c38080e7          	jalr	-968(ra) # 80003d9c <iunlockput>
      return 0;
    8000416c:	89e6                	mv	s3,s9
    8000416e:	b7f1                	j	8000413a <namex+0x6e>
  len = path - s;
    80004170:	40b48633          	sub	a2,s1,a1
    80004174:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80004178:	099c5463          	bge	s8,s9,80004200 <namex+0x134>
    memmove(name, s, DIRSIZ);
    8000417c:	4639                	li	a2,14
    8000417e:	8552                	mv	a0,s4
    80004180:	ffffd097          	auipc	ra,0xffffd
    80004184:	bde080e7          	jalr	-1058(ra) # 80000d5e <memmove>
  while(*path == '/')
    80004188:	0004c783          	lbu	a5,0(s1)
    8000418c:	01279763          	bne	a5,s2,8000419a <namex+0xce>
    path++;
    80004190:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004192:	0004c783          	lbu	a5,0(s1)
    80004196:	ff278de3          	beq	a5,s2,80004190 <namex+0xc4>
    ilock(ip);
    8000419a:	854e                	mv	a0,s3
    8000419c:	00000097          	auipc	ra,0x0
    800041a0:	99e080e7          	jalr	-1634(ra) # 80003b3a <ilock>
    if(ip->type != T_DIR){
    800041a4:	04499783          	lh	a5,68(s3)
    800041a8:	f97793e3          	bne	a5,s7,8000412e <namex+0x62>
    if(nameiparent && *path == '\0'){
    800041ac:	000a8563          	beqz	s5,800041b6 <namex+0xea>
    800041b0:	0004c783          	lbu	a5,0(s1)
    800041b4:	d3cd                	beqz	a5,80004156 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    800041b6:	865a                	mv	a2,s6
    800041b8:	85d2                	mv	a1,s4
    800041ba:	854e                	mv	a0,s3
    800041bc:	00000097          	auipc	ra,0x0
    800041c0:	e60080e7          	jalr	-416(ra) # 8000401c <dirlookup>
    800041c4:	8caa                	mv	s9,a0
    800041c6:	dd51                	beqz	a0,80004162 <namex+0x96>
    iunlockput(ip);
    800041c8:	854e                	mv	a0,s3
    800041ca:	00000097          	auipc	ra,0x0
    800041ce:	bd2080e7          	jalr	-1070(ra) # 80003d9c <iunlockput>
    ip = next;
    800041d2:	89e6                	mv	s3,s9
  while(*path == '/')
    800041d4:	0004c783          	lbu	a5,0(s1)
    800041d8:	05279763          	bne	a5,s2,80004226 <namex+0x15a>
    path++;
    800041dc:	0485                	addi	s1,s1,1
  while(*path == '/')
    800041de:	0004c783          	lbu	a5,0(s1)
    800041e2:	ff278de3          	beq	a5,s2,800041dc <namex+0x110>
  if(*path == 0)
    800041e6:	c79d                	beqz	a5,80004214 <namex+0x148>
    path++;
    800041e8:	85a6                	mv	a1,s1
  len = path - s;
    800041ea:	8cda                	mv	s9,s6
    800041ec:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    800041ee:	01278963          	beq	a5,s2,80004200 <namex+0x134>
    800041f2:	dfbd                	beqz	a5,80004170 <namex+0xa4>
    path++;
    800041f4:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800041f6:	0004c783          	lbu	a5,0(s1)
    800041fa:	ff279ce3          	bne	a5,s2,800041f2 <namex+0x126>
    800041fe:	bf8d                	j	80004170 <namex+0xa4>
    memmove(name, s, len);
    80004200:	2601                	sext.w	a2,a2
    80004202:	8552                	mv	a0,s4
    80004204:	ffffd097          	auipc	ra,0xffffd
    80004208:	b5a080e7          	jalr	-1190(ra) # 80000d5e <memmove>
    name[len] = 0;
    8000420c:	9cd2                	add	s9,s9,s4
    8000420e:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80004212:	bf9d                	j	80004188 <namex+0xbc>
  if(nameiparent){
    80004214:	f20a83e3          	beqz	s5,8000413a <namex+0x6e>
    iput(ip);
    80004218:	854e                	mv	a0,s3
    8000421a:	00000097          	auipc	ra,0x0
    8000421e:	ada080e7          	jalr	-1318(ra) # 80003cf4 <iput>
    return 0;
    80004222:	4981                	li	s3,0
    80004224:	bf19                	j	8000413a <namex+0x6e>
  if(*path == 0)
    80004226:	d7fd                	beqz	a5,80004214 <namex+0x148>
  while(*path != '/' && *path != 0)
    80004228:	0004c783          	lbu	a5,0(s1)
    8000422c:	85a6                	mv	a1,s1
    8000422e:	b7d1                	j	800041f2 <namex+0x126>

0000000080004230 <dirlink>:
{
    80004230:	7139                	addi	sp,sp,-64
    80004232:	fc06                	sd	ra,56(sp)
    80004234:	f822                	sd	s0,48(sp)
    80004236:	f426                	sd	s1,40(sp)
    80004238:	f04a                	sd	s2,32(sp)
    8000423a:	ec4e                	sd	s3,24(sp)
    8000423c:	e852                	sd	s4,16(sp)
    8000423e:	0080                	addi	s0,sp,64
    80004240:	892a                	mv	s2,a0
    80004242:	8a2e                	mv	s4,a1
    80004244:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004246:	4601                	li	a2,0
    80004248:	00000097          	auipc	ra,0x0
    8000424c:	dd4080e7          	jalr	-556(ra) # 8000401c <dirlookup>
    80004250:	e93d                	bnez	a0,800042c6 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004252:	04c92483          	lw	s1,76(s2)
    80004256:	c49d                	beqz	s1,80004284 <dirlink+0x54>
    80004258:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000425a:	4741                	li	a4,16
    8000425c:	86a6                	mv	a3,s1
    8000425e:	fc040613          	addi	a2,s0,-64
    80004262:	4581                	li	a1,0
    80004264:	854a                	mv	a0,s2
    80004266:	00000097          	auipc	ra,0x0
    8000426a:	b88080e7          	jalr	-1144(ra) # 80003dee <readi>
    8000426e:	47c1                	li	a5,16
    80004270:	06f51163          	bne	a0,a5,800042d2 <dirlink+0xa2>
    if(de.inum == 0)
    80004274:	fc045783          	lhu	a5,-64(s0)
    80004278:	c791                	beqz	a5,80004284 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000427a:	24c1                	addiw	s1,s1,16
    8000427c:	04c92783          	lw	a5,76(s2)
    80004280:	fcf4ede3          	bltu	s1,a5,8000425a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80004284:	4639                	li	a2,14
    80004286:	85d2                	mv	a1,s4
    80004288:	fc240513          	addi	a0,s0,-62
    8000428c:	ffffd097          	auipc	ra,0xffffd
    80004290:	b8a080e7          	jalr	-1142(ra) # 80000e16 <strncpy>
  de.inum = inum;
    80004294:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004298:	4741                	li	a4,16
    8000429a:	86a6                	mv	a3,s1
    8000429c:	fc040613          	addi	a2,s0,-64
    800042a0:	4581                	li	a1,0
    800042a2:	854a                	mv	a0,s2
    800042a4:	00000097          	auipc	ra,0x0
    800042a8:	c42080e7          	jalr	-958(ra) # 80003ee6 <writei>
    800042ac:	872a                	mv	a4,a0
    800042ae:	47c1                	li	a5,16
  return 0;
    800042b0:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042b2:	02f71863          	bne	a4,a5,800042e2 <dirlink+0xb2>
}
    800042b6:	70e2                	ld	ra,56(sp)
    800042b8:	7442                	ld	s0,48(sp)
    800042ba:	74a2                	ld	s1,40(sp)
    800042bc:	7902                	ld	s2,32(sp)
    800042be:	69e2                	ld	s3,24(sp)
    800042c0:	6a42                	ld	s4,16(sp)
    800042c2:	6121                	addi	sp,sp,64
    800042c4:	8082                	ret
    iput(ip);
    800042c6:	00000097          	auipc	ra,0x0
    800042ca:	a2e080e7          	jalr	-1490(ra) # 80003cf4 <iput>
    return -1;
    800042ce:	557d                	li	a0,-1
    800042d0:	b7dd                	j	800042b6 <dirlink+0x86>
      panic("dirlink read");
    800042d2:	00004517          	auipc	a0,0x4
    800042d6:	32e50513          	addi	a0,a0,814 # 80008600 <syscalls+0x1e0>
    800042da:	ffffc097          	auipc	ra,0xffffc
    800042de:	270080e7          	jalr	624(ra) # 8000054a <panic>
    panic("dirlink");
    800042e2:	00004517          	auipc	a0,0x4
    800042e6:	43e50513          	addi	a0,a0,1086 # 80008720 <syscalls+0x300>
    800042ea:	ffffc097          	auipc	ra,0xffffc
    800042ee:	260080e7          	jalr	608(ra) # 8000054a <panic>

00000000800042f2 <namei>:

struct inode*
namei(char *path)
{
    800042f2:	1101                	addi	sp,sp,-32
    800042f4:	ec06                	sd	ra,24(sp)
    800042f6:	e822                	sd	s0,16(sp)
    800042f8:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800042fa:	fe040613          	addi	a2,s0,-32
    800042fe:	4581                	li	a1,0
    80004300:	00000097          	auipc	ra,0x0
    80004304:	dcc080e7          	jalr	-564(ra) # 800040cc <namex>
}
    80004308:	60e2                	ld	ra,24(sp)
    8000430a:	6442                	ld	s0,16(sp)
    8000430c:	6105                	addi	sp,sp,32
    8000430e:	8082                	ret

0000000080004310 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004310:	1141                	addi	sp,sp,-16
    80004312:	e406                	sd	ra,8(sp)
    80004314:	e022                	sd	s0,0(sp)
    80004316:	0800                	addi	s0,sp,16
    80004318:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000431a:	4585                	li	a1,1
    8000431c:	00000097          	auipc	ra,0x0
    80004320:	db0080e7          	jalr	-592(ra) # 800040cc <namex>
}
    80004324:	60a2                	ld	ra,8(sp)
    80004326:	6402                	ld	s0,0(sp)
    80004328:	0141                	addi	sp,sp,16
    8000432a:	8082                	ret

000000008000432c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000432c:	1101                	addi	sp,sp,-32
    8000432e:	ec06                	sd	ra,24(sp)
    80004330:	e822                	sd	s0,16(sp)
    80004332:	e426                	sd	s1,8(sp)
    80004334:	e04a                	sd	s2,0(sp)
    80004336:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004338:	0005e917          	auipc	s2,0x5e
    8000433c:	31090913          	addi	s2,s2,784 # 80062648 <log>
    80004340:	01892583          	lw	a1,24(s2)
    80004344:	02892503          	lw	a0,40(s2)
    80004348:	fffff097          	auipc	ra,0xfffff
    8000434c:	ff0080e7          	jalr	-16(ra) # 80003338 <bread>
    80004350:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004352:	02c92683          	lw	a3,44(s2)
    80004356:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004358:	02d05763          	blez	a3,80004386 <write_head+0x5a>
    8000435c:	0005e797          	auipc	a5,0x5e
    80004360:	31c78793          	addi	a5,a5,796 # 80062678 <log+0x30>
    80004364:	05c50713          	addi	a4,a0,92
    80004368:	36fd                	addiw	a3,a3,-1
    8000436a:	1682                	slli	a3,a3,0x20
    8000436c:	9281                	srli	a3,a3,0x20
    8000436e:	068a                	slli	a3,a3,0x2
    80004370:	0005e617          	auipc	a2,0x5e
    80004374:	30c60613          	addi	a2,a2,780 # 8006267c <log+0x34>
    80004378:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000437a:	4390                	lw	a2,0(a5)
    8000437c:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000437e:	0791                	addi	a5,a5,4
    80004380:	0711                	addi	a4,a4,4
    80004382:	fed79ce3          	bne	a5,a3,8000437a <write_head+0x4e>
  }
  bwrite(buf);
    80004386:	8526                	mv	a0,s1
    80004388:	fffff097          	auipc	ra,0xfffff
    8000438c:	0a2080e7          	jalr	162(ra) # 8000342a <bwrite>
  brelse(buf);
    80004390:	8526                	mv	a0,s1
    80004392:	fffff097          	auipc	ra,0xfffff
    80004396:	0d6080e7          	jalr	214(ra) # 80003468 <brelse>
}
    8000439a:	60e2                	ld	ra,24(sp)
    8000439c:	6442                	ld	s0,16(sp)
    8000439e:	64a2                	ld	s1,8(sp)
    800043a0:	6902                	ld	s2,0(sp)
    800043a2:	6105                	addi	sp,sp,32
    800043a4:	8082                	ret

00000000800043a6 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800043a6:	0005e797          	auipc	a5,0x5e
    800043aa:	2ce7a783          	lw	a5,718(a5) # 80062674 <log+0x2c>
    800043ae:	0af05d63          	blez	a5,80004468 <install_trans+0xc2>
{
    800043b2:	7139                	addi	sp,sp,-64
    800043b4:	fc06                	sd	ra,56(sp)
    800043b6:	f822                	sd	s0,48(sp)
    800043b8:	f426                	sd	s1,40(sp)
    800043ba:	f04a                	sd	s2,32(sp)
    800043bc:	ec4e                	sd	s3,24(sp)
    800043be:	e852                	sd	s4,16(sp)
    800043c0:	e456                	sd	s5,8(sp)
    800043c2:	e05a                	sd	s6,0(sp)
    800043c4:	0080                	addi	s0,sp,64
    800043c6:	8b2a                	mv	s6,a0
    800043c8:	0005ea97          	auipc	s5,0x5e
    800043cc:	2b0a8a93          	addi	s5,s5,688 # 80062678 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800043d0:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800043d2:	0005e997          	auipc	s3,0x5e
    800043d6:	27698993          	addi	s3,s3,630 # 80062648 <log>
    800043da:	a00d                	j	800043fc <install_trans+0x56>
    brelse(lbuf);
    800043dc:	854a                	mv	a0,s2
    800043de:	fffff097          	auipc	ra,0xfffff
    800043e2:	08a080e7          	jalr	138(ra) # 80003468 <brelse>
    brelse(dbuf);
    800043e6:	8526                	mv	a0,s1
    800043e8:	fffff097          	auipc	ra,0xfffff
    800043ec:	080080e7          	jalr	128(ra) # 80003468 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800043f0:	2a05                	addiw	s4,s4,1
    800043f2:	0a91                	addi	s5,s5,4
    800043f4:	02c9a783          	lw	a5,44(s3)
    800043f8:	04fa5e63          	bge	s4,a5,80004454 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800043fc:	0189a583          	lw	a1,24(s3)
    80004400:	014585bb          	addw	a1,a1,s4
    80004404:	2585                	addiw	a1,a1,1
    80004406:	0289a503          	lw	a0,40(s3)
    8000440a:	fffff097          	auipc	ra,0xfffff
    8000440e:	f2e080e7          	jalr	-210(ra) # 80003338 <bread>
    80004412:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004414:	000aa583          	lw	a1,0(s5)
    80004418:	0289a503          	lw	a0,40(s3)
    8000441c:	fffff097          	auipc	ra,0xfffff
    80004420:	f1c080e7          	jalr	-228(ra) # 80003338 <bread>
    80004424:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004426:	40000613          	li	a2,1024
    8000442a:	05890593          	addi	a1,s2,88
    8000442e:	05850513          	addi	a0,a0,88
    80004432:	ffffd097          	auipc	ra,0xffffd
    80004436:	92c080e7          	jalr	-1748(ra) # 80000d5e <memmove>
    bwrite(dbuf);  // write dst to disk
    8000443a:	8526                	mv	a0,s1
    8000443c:	fffff097          	auipc	ra,0xfffff
    80004440:	fee080e7          	jalr	-18(ra) # 8000342a <bwrite>
    if(recovering == 0)
    80004444:	f80b1ce3          	bnez	s6,800043dc <install_trans+0x36>
      bunpin(dbuf);
    80004448:	8526                	mv	a0,s1
    8000444a:	fffff097          	auipc	ra,0xfffff
    8000444e:	0f8080e7          	jalr	248(ra) # 80003542 <bunpin>
    80004452:	b769                	j	800043dc <install_trans+0x36>
}
    80004454:	70e2                	ld	ra,56(sp)
    80004456:	7442                	ld	s0,48(sp)
    80004458:	74a2                	ld	s1,40(sp)
    8000445a:	7902                	ld	s2,32(sp)
    8000445c:	69e2                	ld	s3,24(sp)
    8000445e:	6a42                	ld	s4,16(sp)
    80004460:	6aa2                	ld	s5,8(sp)
    80004462:	6b02                	ld	s6,0(sp)
    80004464:	6121                	addi	sp,sp,64
    80004466:	8082                	ret
    80004468:	8082                	ret

000000008000446a <initlog>:
{
    8000446a:	7179                	addi	sp,sp,-48
    8000446c:	f406                	sd	ra,40(sp)
    8000446e:	f022                	sd	s0,32(sp)
    80004470:	ec26                	sd	s1,24(sp)
    80004472:	e84a                	sd	s2,16(sp)
    80004474:	e44e                	sd	s3,8(sp)
    80004476:	1800                	addi	s0,sp,48
    80004478:	892a                	mv	s2,a0
    8000447a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000447c:	0005e497          	auipc	s1,0x5e
    80004480:	1cc48493          	addi	s1,s1,460 # 80062648 <log>
    80004484:	00004597          	auipc	a1,0x4
    80004488:	18c58593          	addi	a1,a1,396 # 80008610 <syscalls+0x1f0>
    8000448c:	8526                	mv	a0,s1
    8000448e:	ffffc097          	auipc	ra,0xffffc
    80004492:	6e8080e7          	jalr	1768(ra) # 80000b76 <initlock>
  log.start = sb->logstart;
    80004496:	0149a583          	lw	a1,20(s3)
    8000449a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000449c:	0109a783          	lw	a5,16(s3)
    800044a0:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800044a2:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800044a6:	854a                	mv	a0,s2
    800044a8:	fffff097          	auipc	ra,0xfffff
    800044ac:	e90080e7          	jalr	-368(ra) # 80003338 <bread>
  log.lh.n = lh->n;
    800044b0:	4d34                	lw	a3,88(a0)
    800044b2:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800044b4:	02d05563          	blez	a3,800044de <initlog+0x74>
    800044b8:	05c50793          	addi	a5,a0,92
    800044bc:	0005e717          	auipc	a4,0x5e
    800044c0:	1bc70713          	addi	a4,a4,444 # 80062678 <log+0x30>
    800044c4:	36fd                	addiw	a3,a3,-1
    800044c6:	1682                	slli	a3,a3,0x20
    800044c8:	9281                	srli	a3,a3,0x20
    800044ca:	068a                	slli	a3,a3,0x2
    800044cc:	06050613          	addi	a2,a0,96
    800044d0:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800044d2:	4390                	lw	a2,0(a5)
    800044d4:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800044d6:	0791                	addi	a5,a5,4
    800044d8:	0711                	addi	a4,a4,4
    800044da:	fed79ce3          	bne	a5,a3,800044d2 <initlog+0x68>
  brelse(buf);
    800044de:	fffff097          	auipc	ra,0xfffff
    800044e2:	f8a080e7          	jalr	-118(ra) # 80003468 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800044e6:	4505                	li	a0,1
    800044e8:	00000097          	auipc	ra,0x0
    800044ec:	ebe080e7          	jalr	-322(ra) # 800043a6 <install_trans>
  log.lh.n = 0;
    800044f0:	0005e797          	auipc	a5,0x5e
    800044f4:	1807a223          	sw	zero,388(a5) # 80062674 <log+0x2c>
  write_head(); // clear the log
    800044f8:	00000097          	auipc	ra,0x0
    800044fc:	e34080e7          	jalr	-460(ra) # 8000432c <write_head>
}
    80004500:	70a2                	ld	ra,40(sp)
    80004502:	7402                	ld	s0,32(sp)
    80004504:	64e2                	ld	s1,24(sp)
    80004506:	6942                	ld	s2,16(sp)
    80004508:	69a2                	ld	s3,8(sp)
    8000450a:	6145                	addi	sp,sp,48
    8000450c:	8082                	ret

000000008000450e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000450e:	1101                	addi	sp,sp,-32
    80004510:	ec06                	sd	ra,24(sp)
    80004512:	e822                	sd	s0,16(sp)
    80004514:	e426                	sd	s1,8(sp)
    80004516:	e04a                	sd	s2,0(sp)
    80004518:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000451a:	0005e517          	auipc	a0,0x5e
    8000451e:	12e50513          	addi	a0,a0,302 # 80062648 <log>
    80004522:	ffffc097          	auipc	ra,0xffffc
    80004526:	6e4080e7          	jalr	1764(ra) # 80000c06 <acquire>
  while(1){
    if(log.committing){
    8000452a:	0005e497          	auipc	s1,0x5e
    8000452e:	11e48493          	addi	s1,s1,286 # 80062648 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004532:	4979                	li	s2,30
    80004534:	a039                	j	80004542 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004536:	85a6                	mv	a1,s1
    80004538:	8526                	mv	a0,s1
    8000453a:	ffffe097          	auipc	ra,0xffffe
    8000453e:	d76080e7          	jalr	-650(ra) # 800022b0 <sleep>
    if(log.committing){
    80004542:	50dc                	lw	a5,36(s1)
    80004544:	fbed                	bnez	a5,80004536 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004546:	509c                	lw	a5,32(s1)
    80004548:	0017871b          	addiw	a4,a5,1
    8000454c:	0007069b          	sext.w	a3,a4
    80004550:	0027179b          	slliw	a5,a4,0x2
    80004554:	9fb9                	addw	a5,a5,a4
    80004556:	0017979b          	slliw	a5,a5,0x1
    8000455a:	54d8                	lw	a4,44(s1)
    8000455c:	9fb9                	addw	a5,a5,a4
    8000455e:	00f95963          	bge	s2,a5,80004570 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004562:	85a6                	mv	a1,s1
    80004564:	8526                	mv	a0,s1
    80004566:	ffffe097          	auipc	ra,0xffffe
    8000456a:	d4a080e7          	jalr	-694(ra) # 800022b0 <sleep>
    8000456e:	bfd1                	j	80004542 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004570:	0005e517          	auipc	a0,0x5e
    80004574:	0d850513          	addi	a0,a0,216 # 80062648 <log>
    80004578:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000457a:	ffffc097          	auipc	ra,0xffffc
    8000457e:	740080e7          	jalr	1856(ra) # 80000cba <release>
      break;
    }
  }
}
    80004582:	60e2                	ld	ra,24(sp)
    80004584:	6442                	ld	s0,16(sp)
    80004586:	64a2                	ld	s1,8(sp)
    80004588:	6902                	ld	s2,0(sp)
    8000458a:	6105                	addi	sp,sp,32
    8000458c:	8082                	ret

000000008000458e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000458e:	7139                	addi	sp,sp,-64
    80004590:	fc06                	sd	ra,56(sp)
    80004592:	f822                	sd	s0,48(sp)
    80004594:	f426                	sd	s1,40(sp)
    80004596:	f04a                	sd	s2,32(sp)
    80004598:	ec4e                	sd	s3,24(sp)
    8000459a:	e852                	sd	s4,16(sp)
    8000459c:	e456                	sd	s5,8(sp)
    8000459e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800045a0:	0005e497          	auipc	s1,0x5e
    800045a4:	0a848493          	addi	s1,s1,168 # 80062648 <log>
    800045a8:	8526                	mv	a0,s1
    800045aa:	ffffc097          	auipc	ra,0xffffc
    800045ae:	65c080e7          	jalr	1628(ra) # 80000c06 <acquire>
  log.outstanding -= 1;
    800045b2:	509c                	lw	a5,32(s1)
    800045b4:	37fd                	addiw	a5,a5,-1
    800045b6:	0007891b          	sext.w	s2,a5
    800045ba:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800045bc:	50dc                	lw	a5,36(s1)
    800045be:	e7b9                	bnez	a5,8000460c <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800045c0:	04091e63          	bnez	s2,8000461c <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800045c4:	0005e497          	auipc	s1,0x5e
    800045c8:	08448493          	addi	s1,s1,132 # 80062648 <log>
    800045cc:	4785                	li	a5,1
    800045ce:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800045d0:	8526                	mv	a0,s1
    800045d2:	ffffc097          	auipc	ra,0xffffc
    800045d6:	6e8080e7          	jalr	1768(ra) # 80000cba <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800045da:	54dc                	lw	a5,44(s1)
    800045dc:	06f04763          	bgtz	a5,8000464a <end_op+0xbc>
    acquire(&log.lock);
    800045e0:	0005e497          	auipc	s1,0x5e
    800045e4:	06848493          	addi	s1,s1,104 # 80062648 <log>
    800045e8:	8526                	mv	a0,s1
    800045ea:	ffffc097          	auipc	ra,0xffffc
    800045ee:	61c080e7          	jalr	1564(ra) # 80000c06 <acquire>
    log.committing = 0;
    800045f2:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800045f6:	8526                	mv	a0,s1
    800045f8:	ffffe097          	auipc	ra,0xffffe
    800045fc:	e3c080e7          	jalr	-452(ra) # 80002434 <wakeup>
    release(&log.lock);
    80004600:	8526                	mv	a0,s1
    80004602:	ffffc097          	auipc	ra,0xffffc
    80004606:	6b8080e7          	jalr	1720(ra) # 80000cba <release>
}
    8000460a:	a03d                	j	80004638 <end_op+0xaa>
    panic("log.committing");
    8000460c:	00004517          	auipc	a0,0x4
    80004610:	00c50513          	addi	a0,a0,12 # 80008618 <syscalls+0x1f8>
    80004614:	ffffc097          	auipc	ra,0xffffc
    80004618:	f36080e7          	jalr	-202(ra) # 8000054a <panic>
    wakeup(&log);
    8000461c:	0005e497          	auipc	s1,0x5e
    80004620:	02c48493          	addi	s1,s1,44 # 80062648 <log>
    80004624:	8526                	mv	a0,s1
    80004626:	ffffe097          	auipc	ra,0xffffe
    8000462a:	e0e080e7          	jalr	-498(ra) # 80002434 <wakeup>
  release(&log.lock);
    8000462e:	8526                	mv	a0,s1
    80004630:	ffffc097          	auipc	ra,0xffffc
    80004634:	68a080e7          	jalr	1674(ra) # 80000cba <release>
}
    80004638:	70e2                	ld	ra,56(sp)
    8000463a:	7442                	ld	s0,48(sp)
    8000463c:	74a2                	ld	s1,40(sp)
    8000463e:	7902                	ld	s2,32(sp)
    80004640:	69e2                	ld	s3,24(sp)
    80004642:	6a42                	ld	s4,16(sp)
    80004644:	6aa2                	ld	s5,8(sp)
    80004646:	6121                	addi	sp,sp,64
    80004648:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    8000464a:	0005ea97          	auipc	s5,0x5e
    8000464e:	02ea8a93          	addi	s5,s5,46 # 80062678 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004652:	0005ea17          	auipc	s4,0x5e
    80004656:	ff6a0a13          	addi	s4,s4,-10 # 80062648 <log>
    8000465a:	018a2583          	lw	a1,24(s4)
    8000465e:	012585bb          	addw	a1,a1,s2
    80004662:	2585                	addiw	a1,a1,1
    80004664:	028a2503          	lw	a0,40(s4)
    80004668:	fffff097          	auipc	ra,0xfffff
    8000466c:	cd0080e7          	jalr	-816(ra) # 80003338 <bread>
    80004670:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004672:	000aa583          	lw	a1,0(s5)
    80004676:	028a2503          	lw	a0,40(s4)
    8000467a:	fffff097          	auipc	ra,0xfffff
    8000467e:	cbe080e7          	jalr	-834(ra) # 80003338 <bread>
    80004682:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004684:	40000613          	li	a2,1024
    80004688:	05850593          	addi	a1,a0,88
    8000468c:	05848513          	addi	a0,s1,88
    80004690:	ffffc097          	auipc	ra,0xffffc
    80004694:	6ce080e7          	jalr	1742(ra) # 80000d5e <memmove>
    bwrite(to);  // write the log
    80004698:	8526                	mv	a0,s1
    8000469a:	fffff097          	auipc	ra,0xfffff
    8000469e:	d90080e7          	jalr	-624(ra) # 8000342a <bwrite>
    brelse(from);
    800046a2:	854e                	mv	a0,s3
    800046a4:	fffff097          	auipc	ra,0xfffff
    800046a8:	dc4080e7          	jalr	-572(ra) # 80003468 <brelse>
    brelse(to);
    800046ac:	8526                	mv	a0,s1
    800046ae:	fffff097          	auipc	ra,0xfffff
    800046b2:	dba080e7          	jalr	-582(ra) # 80003468 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800046b6:	2905                	addiw	s2,s2,1
    800046b8:	0a91                	addi	s5,s5,4
    800046ba:	02ca2783          	lw	a5,44(s4)
    800046be:	f8f94ee3          	blt	s2,a5,8000465a <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800046c2:	00000097          	auipc	ra,0x0
    800046c6:	c6a080e7          	jalr	-918(ra) # 8000432c <write_head>
    install_trans(0); // Now install writes to home locations
    800046ca:	4501                	li	a0,0
    800046cc:	00000097          	auipc	ra,0x0
    800046d0:	cda080e7          	jalr	-806(ra) # 800043a6 <install_trans>
    log.lh.n = 0;
    800046d4:	0005e797          	auipc	a5,0x5e
    800046d8:	fa07a023          	sw	zero,-96(a5) # 80062674 <log+0x2c>
    write_head();    // Erase the transaction from the log
    800046dc:	00000097          	auipc	ra,0x0
    800046e0:	c50080e7          	jalr	-944(ra) # 8000432c <write_head>
    800046e4:	bdf5                	j	800045e0 <end_op+0x52>

00000000800046e6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800046e6:	1101                	addi	sp,sp,-32
    800046e8:	ec06                	sd	ra,24(sp)
    800046ea:	e822                	sd	s0,16(sp)
    800046ec:	e426                	sd	s1,8(sp)
    800046ee:	e04a                	sd	s2,0(sp)
    800046f0:	1000                	addi	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800046f2:	0005e717          	auipc	a4,0x5e
    800046f6:	f8272703          	lw	a4,-126(a4) # 80062674 <log+0x2c>
    800046fa:	47f5                	li	a5,29
    800046fc:	08e7c063          	blt	a5,a4,8000477c <log_write+0x96>
    80004700:	84aa                	mv	s1,a0
    80004702:	0005e797          	auipc	a5,0x5e
    80004706:	f627a783          	lw	a5,-158(a5) # 80062664 <log+0x1c>
    8000470a:	37fd                	addiw	a5,a5,-1
    8000470c:	06f75863          	bge	a4,a5,8000477c <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004710:	0005e797          	auipc	a5,0x5e
    80004714:	f587a783          	lw	a5,-168(a5) # 80062668 <log+0x20>
    80004718:	06f05a63          	blez	a5,8000478c <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    8000471c:	0005e917          	auipc	s2,0x5e
    80004720:	f2c90913          	addi	s2,s2,-212 # 80062648 <log>
    80004724:	854a                	mv	a0,s2
    80004726:	ffffc097          	auipc	ra,0xffffc
    8000472a:	4e0080e7          	jalr	1248(ra) # 80000c06 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    8000472e:	02c92603          	lw	a2,44(s2)
    80004732:	06c05563          	blez	a2,8000479c <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004736:	44cc                	lw	a1,12(s1)
    80004738:	0005e717          	auipc	a4,0x5e
    8000473c:	f4070713          	addi	a4,a4,-192 # 80062678 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004740:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004742:	4314                	lw	a3,0(a4)
    80004744:	04b68d63          	beq	a3,a1,8000479e <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    80004748:	2785                	addiw	a5,a5,1
    8000474a:	0711                	addi	a4,a4,4
    8000474c:	fec79be3          	bne	a5,a2,80004742 <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004750:	0621                	addi	a2,a2,8
    80004752:	060a                	slli	a2,a2,0x2
    80004754:	0005e797          	auipc	a5,0x5e
    80004758:	ef478793          	addi	a5,a5,-268 # 80062648 <log>
    8000475c:	963e                	add	a2,a2,a5
    8000475e:	44dc                	lw	a5,12(s1)
    80004760:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004762:	8526                	mv	a0,s1
    80004764:	fffff097          	auipc	ra,0xfffff
    80004768:	da2080e7          	jalr	-606(ra) # 80003506 <bpin>
    log.lh.n++;
    8000476c:	0005e717          	auipc	a4,0x5e
    80004770:	edc70713          	addi	a4,a4,-292 # 80062648 <log>
    80004774:	575c                	lw	a5,44(a4)
    80004776:	2785                	addiw	a5,a5,1
    80004778:	d75c                	sw	a5,44(a4)
    8000477a:	a83d                	j	800047b8 <log_write+0xd2>
    panic("too big a transaction");
    8000477c:	00004517          	auipc	a0,0x4
    80004780:	eac50513          	addi	a0,a0,-340 # 80008628 <syscalls+0x208>
    80004784:	ffffc097          	auipc	ra,0xffffc
    80004788:	dc6080e7          	jalr	-570(ra) # 8000054a <panic>
    panic("log_write outside of trans");
    8000478c:	00004517          	auipc	a0,0x4
    80004790:	eb450513          	addi	a0,a0,-332 # 80008640 <syscalls+0x220>
    80004794:	ffffc097          	auipc	ra,0xffffc
    80004798:	db6080e7          	jalr	-586(ra) # 8000054a <panic>
  for (i = 0; i < log.lh.n; i++) {
    8000479c:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    8000479e:	00878713          	addi	a4,a5,8
    800047a2:	00271693          	slli	a3,a4,0x2
    800047a6:	0005e717          	auipc	a4,0x5e
    800047aa:	ea270713          	addi	a4,a4,-350 # 80062648 <log>
    800047ae:	9736                	add	a4,a4,a3
    800047b0:	44d4                	lw	a3,12(s1)
    800047b2:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800047b4:	faf607e3          	beq	a2,a5,80004762 <log_write+0x7c>
  }
  release(&log.lock);
    800047b8:	0005e517          	auipc	a0,0x5e
    800047bc:	e9050513          	addi	a0,a0,-368 # 80062648 <log>
    800047c0:	ffffc097          	auipc	ra,0xffffc
    800047c4:	4fa080e7          	jalr	1274(ra) # 80000cba <release>
}
    800047c8:	60e2                	ld	ra,24(sp)
    800047ca:	6442                	ld	s0,16(sp)
    800047cc:	64a2                	ld	s1,8(sp)
    800047ce:	6902                	ld	s2,0(sp)
    800047d0:	6105                	addi	sp,sp,32
    800047d2:	8082                	ret

00000000800047d4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800047d4:	1101                	addi	sp,sp,-32
    800047d6:	ec06                	sd	ra,24(sp)
    800047d8:	e822                	sd	s0,16(sp)
    800047da:	e426                	sd	s1,8(sp)
    800047dc:	e04a                	sd	s2,0(sp)
    800047de:	1000                	addi	s0,sp,32
    800047e0:	84aa                	mv	s1,a0
    800047e2:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800047e4:	00004597          	auipc	a1,0x4
    800047e8:	e7c58593          	addi	a1,a1,-388 # 80008660 <syscalls+0x240>
    800047ec:	0521                	addi	a0,a0,8
    800047ee:	ffffc097          	auipc	ra,0xffffc
    800047f2:	388080e7          	jalr	904(ra) # 80000b76 <initlock>
  lk->name = name;
    800047f6:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800047fa:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800047fe:	0204a423          	sw	zero,40(s1)
}
    80004802:	60e2                	ld	ra,24(sp)
    80004804:	6442                	ld	s0,16(sp)
    80004806:	64a2                	ld	s1,8(sp)
    80004808:	6902                	ld	s2,0(sp)
    8000480a:	6105                	addi	sp,sp,32
    8000480c:	8082                	ret

000000008000480e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000480e:	1101                	addi	sp,sp,-32
    80004810:	ec06                	sd	ra,24(sp)
    80004812:	e822                	sd	s0,16(sp)
    80004814:	e426                	sd	s1,8(sp)
    80004816:	e04a                	sd	s2,0(sp)
    80004818:	1000                	addi	s0,sp,32
    8000481a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000481c:	00850913          	addi	s2,a0,8
    80004820:	854a                	mv	a0,s2
    80004822:	ffffc097          	auipc	ra,0xffffc
    80004826:	3e4080e7          	jalr	996(ra) # 80000c06 <acquire>
  while (lk->locked) {
    8000482a:	409c                	lw	a5,0(s1)
    8000482c:	cb89                	beqz	a5,8000483e <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000482e:	85ca                	mv	a1,s2
    80004830:	8526                	mv	a0,s1
    80004832:	ffffe097          	auipc	ra,0xffffe
    80004836:	a7e080e7          	jalr	-1410(ra) # 800022b0 <sleep>
  while (lk->locked) {
    8000483a:	409c                	lw	a5,0(s1)
    8000483c:	fbed                	bnez	a5,8000482e <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000483e:	4785                	li	a5,1
    80004840:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004842:	ffffd097          	auipc	ra,0xffffd
    80004846:	1cc080e7          	jalr	460(ra) # 80001a0e <myproc>
    8000484a:	5d1c                	lw	a5,56(a0)
    8000484c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000484e:	854a                	mv	a0,s2
    80004850:	ffffc097          	auipc	ra,0xffffc
    80004854:	46a080e7          	jalr	1130(ra) # 80000cba <release>
}
    80004858:	60e2                	ld	ra,24(sp)
    8000485a:	6442                	ld	s0,16(sp)
    8000485c:	64a2                	ld	s1,8(sp)
    8000485e:	6902                	ld	s2,0(sp)
    80004860:	6105                	addi	sp,sp,32
    80004862:	8082                	ret

0000000080004864 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004864:	1101                	addi	sp,sp,-32
    80004866:	ec06                	sd	ra,24(sp)
    80004868:	e822                	sd	s0,16(sp)
    8000486a:	e426                	sd	s1,8(sp)
    8000486c:	e04a                	sd	s2,0(sp)
    8000486e:	1000                	addi	s0,sp,32
    80004870:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004872:	00850913          	addi	s2,a0,8
    80004876:	854a                	mv	a0,s2
    80004878:	ffffc097          	auipc	ra,0xffffc
    8000487c:	38e080e7          	jalr	910(ra) # 80000c06 <acquire>
  lk->locked = 0;
    80004880:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004884:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004888:	8526                	mv	a0,s1
    8000488a:	ffffe097          	auipc	ra,0xffffe
    8000488e:	baa080e7          	jalr	-1110(ra) # 80002434 <wakeup>
  release(&lk->lk);
    80004892:	854a                	mv	a0,s2
    80004894:	ffffc097          	auipc	ra,0xffffc
    80004898:	426080e7          	jalr	1062(ra) # 80000cba <release>
}
    8000489c:	60e2                	ld	ra,24(sp)
    8000489e:	6442                	ld	s0,16(sp)
    800048a0:	64a2                	ld	s1,8(sp)
    800048a2:	6902                	ld	s2,0(sp)
    800048a4:	6105                	addi	sp,sp,32
    800048a6:	8082                	ret

00000000800048a8 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800048a8:	7179                	addi	sp,sp,-48
    800048aa:	f406                	sd	ra,40(sp)
    800048ac:	f022                	sd	s0,32(sp)
    800048ae:	ec26                	sd	s1,24(sp)
    800048b0:	e84a                	sd	s2,16(sp)
    800048b2:	e44e                	sd	s3,8(sp)
    800048b4:	1800                	addi	s0,sp,48
    800048b6:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800048b8:	00850913          	addi	s2,a0,8
    800048bc:	854a                	mv	a0,s2
    800048be:	ffffc097          	auipc	ra,0xffffc
    800048c2:	348080e7          	jalr	840(ra) # 80000c06 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800048c6:	409c                	lw	a5,0(s1)
    800048c8:	ef99                	bnez	a5,800048e6 <holdingsleep+0x3e>
    800048ca:	4481                	li	s1,0
  release(&lk->lk);
    800048cc:	854a                	mv	a0,s2
    800048ce:	ffffc097          	auipc	ra,0xffffc
    800048d2:	3ec080e7          	jalr	1004(ra) # 80000cba <release>
  return r;
}
    800048d6:	8526                	mv	a0,s1
    800048d8:	70a2                	ld	ra,40(sp)
    800048da:	7402                	ld	s0,32(sp)
    800048dc:	64e2                	ld	s1,24(sp)
    800048de:	6942                	ld	s2,16(sp)
    800048e0:	69a2                	ld	s3,8(sp)
    800048e2:	6145                	addi	sp,sp,48
    800048e4:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800048e6:	0284a983          	lw	s3,40(s1)
    800048ea:	ffffd097          	auipc	ra,0xffffd
    800048ee:	124080e7          	jalr	292(ra) # 80001a0e <myproc>
    800048f2:	5d04                	lw	s1,56(a0)
    800048f4:	413484b3          	sub	s1,s1,s3
    800048f8:	0014b493          	seqz	s1,s1
    800048fc:	bfc1                	j	800048cc <holdingsleep+0x24>

00000000800048fe <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800048fe:	1141                	addi	sp,sp,-16
    80004900:	e406                	sd	ra,8(sp)
    80004902:	e022                	sd	s0,0(sp)
    80004904:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004906:	00004597          	auipc	a1,0x4
    8000490a:	d6a58593          	addi	a1,a1,-662 # 80008670 <syscalls+0x250>
    8000490e:	0005e517          	auipc	a0,0x5e
    80004912:	e8250513          	addi	a0,a0,-382 # 80062790 <ftable>
    80004916:	ffffc097          	auipc	ra,0xffffc
    8000491a:	260080e7          	jalr	608(ra) # 80000b76 <initlock>
}
    8000491e:	60a2                	ld	ra,8(sp)
    80004920:	6402                	ld	s0,0(sp)
    80004922:	0141                	addi	sp,sp,16
    80004924:	8082                	ret

0000000080004926 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004926:	1101                	addi	sp,sp,-32
    80004928:	ec06                	sd	ra,24(sp)
    8000492a:	e822                	sd	s0,16(sp)
    8000492c:	e426                	sd	s1,8(sp)
    8000492e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004930:	0005e517          	auipc	a0,0x5e
    80004934:	e6050513          	addi	a0,a0,-416 # 80062790 <ftable>
    80004938:	ffffc097          	auipc	ra,0xffffc
    8000493c:	2ce080e7          	jalr	718(ra) # 80000c06 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004940:	0005e497          	auipc	s1,0x5e
    80004944:	e6848493          	addi	s1,s1,-408 # 800627a8 <ftable+0x18>
    80004948:	0005f717          	auipc	a4,0x5f
    8000494c:	e0070713          	addi	a4,a4,-512 # 80063748 <ftable+0xfb8>
    if(f->ref == 0){
    80004950:	40dc                	lw	a5,4(s1)
    80004952:	cf99                	beqz	a5,80004970 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004954:	02848493          	addi	s1,s1,40
    80004958:	fee49ce3          	bne	s1,a4,80004950 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000495c:	0005e517          	auipc	a0,0x5e
    80004960:	e3450513          	addi	a0,a0,-460 # 80062790 <ftable>
    80004964:	ffffc097          	auipc	ra,0xffffc
    80004968:	356080e7          	jalr	854(ra) # 80000cba <release>
  return 0;
    8000496c:	4481                	li	s1,0
    8000496e:	a819                	j	80004984 <filealloc+0x5e>
      f->ref = 1;
    80004970:	4785                	li	a5,1
    80004972:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004974:	0005e517          	auipc	a0,0x5e
    80004978:	e1c50513          	addi	a0,a0,-484 # 80062790 <ftable>
    8000497c:	ffffc097          	auipc	ra,0xffffc
    80004980:	33e080e7          	jalr	830(ra) # 80000cba <release>
}
    80004984:	8526                	mv	a0,s1
    80004986:	60e2                	ld	ra,24(sp)
    80004988:	6442                	ld	s0,16(sp)
    8000498a:	64a2                	ld	s1,8(sp)
    8000498c:	6105                	addi	sp,sp,32
    8000498e:	8082                	ret

0000000080004990 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004990:	1101                	addi	sp,sp,-32
    80004992:	ec06                	sd	ra,24(sp)
    80004994:	e822                	sd	s0,16(sp)
    80004996:	e426                	sd	s1,8(sp)
    80004998:	1000                	addi	s0,sp,32
    8000499a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000499c:	0005e517          	auipc	a0,0x5e
    800049a0:	df450513          	addi	a0,a0,-524 # 80062790 <ftable>
    800049a4:	ffffc097          	auipc	ra,0xffffc
    800049a8:	262080e7          	jalr	610(ra) # 80000c06 <acquire>
  if(f->ref < 1)
    800049ac:	40dc                	lw	a5,4(s1)
    800049ae:	02f05263          	blez	a5,800049d2 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800049b2:	2785                	addiw	a5,a5,1
    800049b4:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800049b6:	0005e517          	auipc	a0,0x5e
    800049ba:	dda50513          	addi	a0,a0,-550 # 80062790 <ftable>
    800049be:	ffffc097          	auipc	ra,0xffffc
    800049c2:	2fc080e7          	jalr	764(ra) # 80000cba <release>
  return f;
}
    800049c6:	8526                	mv	a0,s1
    800049c8:	60e2                	ld	ra,24(sp)
    800049ca:	6442                	ld	s0,16(sp)
    800049cc:	64a2                	ld	s1,8(sp)
    800049ce:	6105                	addi	sp,sp,32
    800049d0:	8082                	ret
    panic("filedup");
    800049d2:	00004517          	auipc	a0,0x4
    800049d6:	ca650513          	addi	a0,a0,-858 # 80008678 <syscalls+0x258>
    800049da:	ffffc097          	auipc	ra,0xffffc
    800049de:	b70080e7          	jalr	-1168(ra) # 8000054a <panic>

00000000800049e2 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800049e2:	7139                	addi	sp,sp,-64
    800049e4:	fc06                	sd	ra,56(sp)
    800049e6:	f822                	sd	s0,48(sp)
    800049e8:	f426                	sd	s1,40(sp)
    800049ea:	f04a                	sd	s2,32(sp)
    800049ec:	ec4e                	sd	s3,24(sp)
    800049ee:	e852                	sd	s4,16(sp)
    800049f0:	e456                	sd	s5,8(sp)
    800049f2:	0080                	addi	s0,sp,64
    800049f4:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800049f6:	0005e517          	auipc	a0,0x5e
    800049fa:	d9a50513          	addi	a0,a0,-614 # 80062790 <ftable>
    800049fe:	ffffc097          	auipc	ra,0xffffc
    80004a02:	208080e7          	jalr	520(ra) # 80000c06 <acquire>
  if(f->ref < 1)
    80004a06:	40dc                	lw	a5,4(s1)
    80004a08:	06f05163          	blez	a5,80004a6a <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004a0c:	37fd                	addiw	a5,a5,-1
    80004a0e:	0007871b          	sext.w	a4,a5
    80004a12:	c0dc                	sw	a5,4(s1)
    80004a14:	06e04363          	bgtz	a4,80004a7a <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004a18:	0004a903          	lw	s2,0(s1)
    80004a1c:	0094ca83          	lbu	s5,9(s1)
    80004a20:	0104ba03          	ld	s4,16(s1)
    80004a24:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004a28:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004a2c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004a30:	0005e517          	auipc	a0,0x5e
    80004a34:	d6050513          	addi	a0,a0,-672 # 80062790 <ftable>
    80004a38:	ffffc097          	auipc	ra,0xffffc
    80004a3c:	282080e7          	jalr	642(ra) # 80000cba <release>

  if(ff.type == FD_PIPE){
    80004a40:	4785                	li	a5,1
    80004a42:	04f90d63          	beq	s2,a5,80004a9c <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004a46:	3979                	addiw	s2,s2,-2
    80004a48:	4785                	li	a5,1
    80004a4a:	0527e063          	bltu	a5,s2,80004a8a <fileclose+0xa8>
    begin_op();
    80004a4e:	00000097          	auipc	ra,0x0
    80004a52:	ac0080e7          	jalr	-1344(ra) # 8000450e <begin_op>
    iput(ff.ip);
    80004a56:	854e                	mv	a0,s3
    80004a58:	fffff097          	auipc	ra,0xfffff
    80004a5c:	29c080e7          	jalr	668(ra) # 80003cf4 <iput>
    end_op();
    80004a60:	00000097          	auipc	ra,0x0
    80004a64:	b2e080e7          	jalr	-1234(ra) # 8000458e <end_op>
    80004a68:	a00d                	j	80004a8a <fileclose+0xa8>
    panic("fileclose");
    80004a6a:	00004517          	auipc	a0,0x4
    80004a6e:	c1650513          	addi	a0,a0,-1002 # 80008680 <syscalls+0x260>
    80004a72:	ffffc097          	auipc	ra,0xffffc
    80004a76:	ad8080e7          	jalr	-1320(ra) # 8000054a <panic>
    release(&ftable.lock);
    80004a7a:	0005e517          	auipc	a0,0x5e
    80004a7e:	d1650513          	addi	a0,a0,-746 # 80062790 <ftable>
    80004a82:	ffffc097          	auipc	ra,0xffffc
    80004a86:	238080e7          	jalr	568(ra) # 80000cba <release>
  }
}
    80004a8a:	70e2                	ld	ra,56(sp)
    80004a8c:	7442                	ld	s0,48(sp)
    80004a8e:	74a2                	ld	s1,40(sp)
    80004a90:	7902                	ld	s2,32(sp)
    80004a92:	69e2                	ld	s3,24(sp)
    80004a94:	6a42                	ld	s4,16(sp)
    80004a96:	6aa2                	ld	s5,8(sp)
    80004a98:	6121                	addi	sp,sp,64
    80004a9a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004a9c:	85d6                	mv	a1,s5
    80004a9e:	8552                	mv	a0,s4
    80004aa0:	00000097          	auipc	ra,0x0
    80004aa4:	374080e7          	jalr	884(ra) # 80004e14 <pipeclose>
    80004aa8:	b7cd                	j	80004a8a <fileclose+0xa8>

0000000080004aaa <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004aaa:	715d                	addi	sp,sp,-80
    80004aac:	e486                	sd	ra,72(sp)
    80004aae:	e0a2                	sd	s0,64(sp)
    80004ab0:	fc26                	sd	s1,56(sp)
    80004ab2:	f84a                	sd	s2,48(sp)
    80004ab4:	f44e                	sd	s3,40(sp)
    80004ab6:	0880                	addi	s0,sp,80
    80004ab8:	84aa                	mv	s1,a0
    80004aba:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004abc:	ffffd097          	auipc	ra,0xffffd
    80004ac0:	f52080e7          	jalr	-174(ra) # 80001a0e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004ac4:	409c                	lw	a5,0(s1)
    80004ac6:	37f9                	addiw	a5,a5,-2
    80004ac8:	4705                	li	a4,1
    80004aca:	04f76863          	bltu	a4,a5,80004b1a <filestat+0x70>
    80004ace:	892a                	mv	s2,a0
    ilock(f->ip);
    80004ad0:	6c88                	ld	a0,24(s1)
    80004ad2:	fffff097          	auipc	ra,0xfffff
    80004ad6:	068080e7          	jalr	104(ra) # 80003b3a <ilock>
    stati(f->ip, &st);
    80004ada:	fb840593          	addi	a1,s0,-72
    80004ade:	6c88                	ld	a0,24(s1)
    80004ae0:	fffff097          	auipc	ra,0xfffff
    80004ae4:	2e4080e7          	jalr	740(ra) # 80003dc4 <stati>
    iunlock(f->ip);
    80004ae8:	6c88                	ld	a0,24(s1)
    80004aea:	fffff097          	auipc	ra,0xfffff
    80004aee:	112080e7          	jalr	274(ra) # 80003bfc <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004af2:	6505                	lui	a0,0x1
    80004af4:	954a                	add	a0,a0,s2
    80004af6:	46e1                	li	a3,24
    80004af8:	fb840613          	addi	a2,s0,-72
    80004afc:	85ce                	mv	a1,s3
    80004afe:	7148                	ld	a0,160(a0)
    80004b00:	ffffd097          	auipc	ra,0xffffd
    80004b04:	b82080e7          	jalr	-1150(ra) # 80001682 <copyout>
    80004b08:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004b0c:	60a6                	ld	ra,72(sp)
    80004b0e:	6406                	ld	s0,64(sp)
    80004b10:	74e2                	ld	s1,56(sp)
    80004b12:	7942                	ld	s2,48(sp)
    80004b14:	79a2                	ld	s3,40(sp)
    80004b16:	6161                	addi	sp,sp,80
    80004b18:	8082                	ret
  return -1;
    80004b1a:	557d                	li	a0,-1
    80004b1c:	bfc5                	j	80004b0c <filestat+0x62>

0000000080004b1e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004b1e:	7179                	addi	sp,sp,-48
    80004b20:	f406                	sd	ra,40(sp)
    80004b22:	f022                	sd	s0,32(sp)
    80004b24:	ec26                	sd	s1,24(sp)
    80004b26:	e84a                	sd	s2,16(sp)
    80004b28:	e44e                	sd	s3,8(sp)
    80004b2a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004b2c:	00854783          	lbu	a5,8(a0) # 1008 <_entry-0x7fffeff8>
    80004b30:	c3d5                	beqz	a5,80004bd4 <fileread+0xb6>
    80004b32:	84aa                	mv	s1,a0
    80004b34:	89ae                	mv	s3,a1
    80004b36:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004b38:	411c                	lw	a5,0(a0)
    80004b3a:	4705                	li	a4,1
    80004b3c:	04e78963          	beq	a5,a4,80004b8e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004b40:	470d                	li	a4,3
    80004b42:	04e78d63          	beq	a5,a4,80004b9c <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004b46:	4709                	li	a4,2
    80004b48:	06e79e63          	bne	a5,a4,80004bc4 <fileread+0xa6>
    ilock(f->ip);
    80004b4c:	6d08                	ld	a0,24(a0)
    80004b4e:	fffff097          	auipc	ra,0xfffff
    80004b52:	fec080e7          	jalr	-20(ra) # 80003b3a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004b56:	874a                	mv	a4,s2
    80004b58:	5094                	lw	a3,32(s1)
    80004b5a:	864e                	mv	a2,s3
    80004b5c:	4585                	li	a1,1
    80004b5e:	6c88                	ld	a0,24(s1)
    80004b60:	fffff097          	auipc	ra,0xfffff
    80004b64:	28e080e7          	jalr	654(ra) # 80003dee <readi>
    80004b68:	892a                	mv	s2,a0
    80004b6a:	00a05563          	blez	a0,80004b74 <fileread+0x56>
      f->off += r;
    80004b6e:	509c                	lw	a5,32(s1)
    80004b70:	9fa9                	addw	a5,a5,a0
    80004b72:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004b74:	6c88                	ld	a0,24(s1)
    80004b76:	fffff097          	auipc	ra,0xfffff
    80004b7a:	086080e7          	jalr	134(ra) # 80003bfc <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004b7e:	854a                	mv	a0,s2
    80004b80:	70a2                	ld	ra,40(sp)
    80004b82:	7402                	ld	s0,32(sp)
    80004b84:	64e2                	ld	s1,24(sp)
    80004b86:	6942                	ld	s2,16(sp)
    80004b88:	69a2                	ld	s3,8(sp)
    80004b8a:	6145                	addi	sp,sp,48
    80004b8c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004b8e:	6908                	ld	a0,16(a0)
    80004b90:	00000097          	auipc	ra,0x0
    80004b94:	3fc080e7          	jalr	1020(ra) # 80004f8c <piperead>
    80004b98:	892a                	mv	s2,a0
    80004b9a:	b7d5                	j	80004b7e <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004b9c:	02451783          	lh	a5,36(a0)
    80004ba0:	03079693          	slli	a3,a5,0x30
    80004ba4:	92c1                	srli	a3,a3,0x30
    80004ba6:	4725                	li	a4,9
    80004ba8:	02d76863          	bltu	a4,a3,80004bd8 <fileread+0xba>
    80004bac:	0792                	slli	a5,a5,0x4
    80004bae:	0005e717          	auipc	a4,0x5e
    80004bb2:	b4270713          	addi	a4,a4,-1214 # 800626f0 <devsw>
    80004bb6:	97ba                	add	a5,a5,a4
    80004bb8:	639c                	ld	a5,0(a5)
    80004bba:	c38d                	beqz	a5,80004bdc <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004bbc:	4505                	li	a0,1
    80004bbe:	9782                	jalr	a5
    80004bc0:	892a                	mv	s2,a0
    80004bc2:	bf75                	j	80004b7e <fileread+0x60>
    panic("fileread");
    80004bc4:	00004517          	auipc	a0,0x4
    80004bc8:	acc50513          	addi	a0,a0,-1332 # 80008690 <syscalls+0x270>
    80004bcc:	ffffc097          	auipc	ra,0xffffc
    80004bd0:	97e080e7          	jalr	-1666(ra) # 8000054a <panic>
    return -1;
    80004bd4:	597d                	li	s2,-1
    80004bd6:	b765                	j	80004b7e <fileread+0x60>
      return -1;
    80004bd8:	597d                	li	s2,-1
    80004bda:	b755                	j	80004b7e <fileread+0x60>
    80004bdc:	597d                	li	s2,-1
    80004bde:	b745                	j	80004b7e <fileread+0x60>

0000000080004be0 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004be0:	00954783          	lbu	a5,9(a0)
    80004be4:	14078563          	beqz	a5,80004d2e <filewrite+0x14e>
{
    80004be8:	715d                	addi	sp,sp,-80
    80004bea:	e486                	sd	ra,72(sp)
    80004bec:	e0a2                	sd	s0,64(sp)
    80004bee:	fc26                	sd	s1,56(sp)
    80004bf0:	f84a                	sd	s2,48(sp)
    80004bf2:	f44e                	sd	s3,40(sp)
    80004bf4:	f052                	sd	s4,32(sp)
    80004bf6:	ec56                	sd	s5,24(sp)
    80004bf8:	e85a                	sd	s6,16(sp)
    80004bfa:	e45e                	sd	s7,8(sp)
    80004bfc:	e062                	sd	s8,0(sp)
    80004bfe:	0880                	addi	s0,sp,80
    80004c00:	892a                	mv	s2,a0
    80004c02:	8aae                	mv	s5,a1
    80004c04:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004c06:	411c                	lw	a5,0(a0)
    80004c08:	4705                	li	a4,1
    80004c0a:	02e78263          	beq	a5,a4,80004c2e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004c0e:	470d                	li	a4,3
    80004c10:	02e78563          	beq	a5,a4,80004c3a <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004c14:	4709                	li	a4,2
    80004c16:	10e79463          	bne	a5,a4,80004d1e <filewrite+0x13e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004c1a:	0ec05e63          	blez	a2,80004d16 <filewrite+0x136>
    int i = 0;
    80004c1e:	4981                	li	s3,0
    80004c20:	6b05                	lui	s6,0x1
    80004c22:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004c26:	6b85                	lui	s7,0x1
    80004c28:	c00b8b9b          	addiw	s7,s7,-1024
    80004c2c:	a851                	j	80004cc0 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004c2e:	6908                	ld	a0,16(a0)
    80004c30:	00000097          	auipc	ra,0x0
    80004c34:	254080e7          	jalr	596(ra) # 80004e84 <pipewrite>
    80004c38:	a85d                	j	80004cee <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004c3a:	02451783          	lh	a5,36(a0)
    80004c3e:	03079693          	slli	a3,a5,0x30
    80004c42:	92c1                	srli	a3,a3,0x30
    80004c44:	4725                	li	a4,9
    80004c46:	0ed76663          	bltu	a4,a3,80004d32 <filewrite+0x152>
    80004c4a:	0792                	slli	a5,a5,0x4
    80004c4c:	0005e717          	auipc	a4,0x5e
    80004c50:	aa470713          	addi	a4,a4,-1372 # 800626f0 <devsw>
    80004c54:	97ba                	add	a5,a5,a4
    80004c56:	679c                	ld	a5,8(a5)
    80004c58:	cff9                	beqz	a5,80004d36 <filewrite+0x156>
    ret = devsw[f->major].write(1, addr, n);
    80004c5a:	4505                	li	a0,1
    80004c5c:	9782                	jalr	a5
    80004c5e:	a841                	j	80004cee <filewrite+0x10e>
    80004c60:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004c64:	00000097          	auipc	ra,0x0
    80004c68:	8aa080e7          	jalr	-1878(ra) # 8000450e <begin_op>
      ilock(f->ip);
    80004c6c:	01893503          	ld	a0,24(s2)
    80004c70:	fffff097          	auipc	ra,0xfffff
    80004c74:	eca080e7          	jalr	-310(ra) # 80003b3a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004c78:	8762                	mv	a4,s8
    80004c7a:	02092683          	lw	a3,32(s2)
    80004c7e:	01598633          	add	a2,s3,s5
    80004c82:	4585                	li	a1,1
    80004c84:	01893503          	ld	a0,24(s2)
    80004c88:	fffff097          	auipc	ra,0xfffff
    80004c8c:	25e080e7          	jalr	606(ra) # 80003ee6 <writei>
    80004c90:	84aa                	mv	s1,a0
    80004c92:	02a05f63          	blez	a0,80004cd0 <filewrite+0xf0>
        f->off += r;
    80004c96:	02092783          	lw	a5,32(s2)
    80004c9a:	9fa9                	addw	a5,a5,a0
    80004c9c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004ca0:	01893503          	ld	a0,24(s2)
    80004ca4:	fffff097          	auipc	ra,0xfffff
    80004ca8:	f58080e7          	jalr	-168(ra) # 80003bfc <iunlock>
      end_op();
    80004cac:	00000097          	auipc	ra,0x0
    80004cb0:	8e2080e7          	jalr	-1822(ra) # 8000458e <end_op>

      if(r < 0)
        break;
      if(r != n1)
    80004cb4:	049c1963          	bne	s8,s1,80004d06 <filewrite+0x126>
        panic("short filewrite");
      i += r;
    80004cb8:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004cbc:	0349d663          	bge	s3,s4,80004ce8 <filewrite+0x108>
      int n1 = n - i;
    80004cc0:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004cc4:	84be                	mv	s1,a5
    80004cc6:	2781                	sext.w	a5,a5
    80004cc8:	f8fb5ce3          	bge	s6,a5,80004c60 <filewrite+0x80>
    80004ccc:	84de                	mv	s1,s7
    80004cce:	bf49                	j	80004c60 <filewrite+0x80>
      iunlock(f->ip);
    80004cd0:	01893503          	ld	a0,24(s2)
    80004cd4:	fffff097          	auipc	ra,0xfffff
    80004cd8:	f28080e7          	jalr	-216(ra) # 80003bfc <iunlock>
      end_op();
    80004cdc:	00000097          	auipc	ra,0x0
    80004ce0:	8b2080e7          	jalr	-1870(ra) # 8000458e <end_op>
      if(r < 0)
    80004ce4:	fc04d8e3          	bgez	s1,80004cb4 <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    80004ce8:	8552                	mv	a0,s4
    80004cea:	033a1863          	bne	s4,s3,80004d1a <filewrite+0x13a>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004cee:	60a6                	ld	ra,72(sp)
    80004cf0:	6406                	ld	s0,64(sp)
    80004cf2:	74e2                	ld	s1,56(sp)
    80004cf4:	7942                	ld	s2,48(sp)
    80004cf6:	79a2                	ld	s3,40(sp)
    80004cf8:	7a02                	ld	s4,32(sp)
    80004cfa:	6ae2                	ld	s5,24(sp)
    80004cfc:	6b42                	ld	s6,16(sp)
    80004cfe:	6ba2                	ld	s7,8(sp)
    80004d00:	6c02                	ld	s8,0(sp)
    80004d02:	6161                	addi	sp,sp,80
    80004d04:	8082                	ret
        panic("short filewrite");
    80004d06:	00004517          	auipc	a0,0x4
    80004d0a:	99a50513          	addi	a0,a0,-1638 # 800086a0 <syscalls+0x280>
    80004d0e:	ffffc097          	auipc	ra,0xffffc
    80004d12:	83c080e7          	jalr	-1988(ra) # 8000054a <panic>
    int i = 0;
    80004d16:	4981                	li	s3,0
    80004d18:	bfc1                	j	80004ce8 <filewrite+0x108>
    ret = (i == n ? n : -1);
    80004d1a:	557d                	li	a0,-1
    80004d1c:	bfc9                	j	80004cee <filewrite+0x10e>
    panic("filewrite");
    80004d1e:	00004517          	auipc	a0,0x4
    80004d22:	99250513          	addi	a0,a0,-1646 # 800086b0 <syscalls+0x290>
    80004d26:	ffffc097          	auipc	ra,0xffffc
    80004d2a:	824080e7          	jalr	-2012(ra) # 8000054a <panic>
    return -1;
    80004d2e:	557d                	li	a0,-1
}
    80004d30:	8082                	ret
      return -1;
    80004d32:	557d                	li	a0,-1
    80004d34:	bf6d                	j	80004cee <filewrite+0x10e>
    80004d36:	557d                	li	a0,-1
    80004d38:	bf5d                	j	80004cee <filewrite+0x10e>

0000000080004d3a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004d3a:	7179                	addi	sp,sp,-48
    80004d3c:	f406                	sd	ra,40(sp)
    80004d3e:	f022                	sd	s0,32(sp)
    80004d40:	ec26                	sd	s1,24(sp)
    80004d42:	e84a                	sd	s2,16(sp)
    80004d44:	e44e                	sd	s3,8(sp)
    80004d46:	e052                	sd	s4,0(sp)
    80004d48:	1800                	addi	s0,sp,48
    80004d4a:	84aa                	mv	s1,a0
    80004d4c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004d4e:	0005b023          	sd	zero,0(a1)
    80004d52:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004d56:	00000097          	auipc	ra,0x0
    80004d5a:	bd0080e7          	jalr	-1072(ra) # 80004926 <filealloc>
    80004d5e:	e088                	sd	a0,0(s1)
    80004d60:	c551                	beqz	a0,80004dec <pipealloc+0xb2>
    80004d62:	00000097          	auipc	ra,0x0
    80004d66:	bc4080e7          	jalr	-1084(ra) # 80004926 <filealloc>
    80004d6a:	00aa3023          	sd	a0,0(s4)
    80004d6e:	c92d                	beqz	a0,80004de0 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004d70:	ffffc097          	auipc	ra,0xffffc
    80004d74:	da6080e7          	jalr	-602(ra) # 80000b16 <kalloc>
    80004d78:	892a                	mv	s2,a0
    80004d7a:	c125                	beqz	a0,80004dda <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004d7c:	4985                	li	s3,1
    80004d7e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004d82:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004d86:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004d8a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004d8e:	00004597          	auipc	a1,0x4
    80004d92:	93258593          	addi	a1,a1,-1742 # 800086c0 <syscalls+0x2a0>
    80004d96:	ffffc097          	auipc	ra,0xffffc
    80004d9a:	de0080e7          	jalr	-544(ra) # 80000b76 <initlock>
  (*f0)->type = FD_PIPE;
    80004d9e:	609c                	ld	a5,0(s1)
    80004da0:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004da4:	609c                	ld	a5,0(s1)
    80004da6:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004daa:	609c                	ld	a5,0(s1)
    80004dac:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004db0:	609c                	ld	a5,0(s1)
    80004db2:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004db6:	000a3783          	ld	a5,0(s4)
    80004dba:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004dbe:	000a3783          	ld	a5,0(s4)
    80004dc2:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004dc6:	000a3783          	ld	a5,0(s4)
    80004dca:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004dce:	000a3783          	ld	a5,0(s4)
    80004dd2:	0127b823          	sd	s2,16(a5)
  return 0;
    80004dd6:	4501                	li	a0,0
    80004dd8:	a025                	j	80004e00 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004dda:	6088                	ld	a0,0(s1)
    80004ddc:	e501                	bnez	a0,80004de4 <pipealloc+0xaa>
    80004dde:	a039                	j	80004dec <pipealloc+0xb2>
    80004de0:	6088                	ld	a0,0(s1)
    80004de2:	c51d                	beqz	a0,80004e10 <pipealloc+0xd6>
    fileclose(*f0);
    80004de4:	00000097          	auipc	ra,0x0
    80004de8:	bfe080e7          	jalr	-1026(ra) # 800049e2 <fileclose>
  if(*f1)
    80004dec:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004df0:	557d                	li	a0,-1
  if(*f1)
    80004df2:	c799                	beqz	a5,80004e00 <pipealloc+0xc6>
    fileclose(*f1);
    80004df4:	853e                	mv	a0,a5
    80004df6:	00000097          	auipc	ra,0x0
    80004dfa:	bec080e7          	jalr	-1044(ra) # 800049e2 <fileclose>
  return -1;
    80004dfe:	557d                	li	a0,-1
}
    80004e00:	70a2                	ld	ra,40(sp)
    80004e02:	7402                	ld	s0,32(sp)
    80004e04:	64e2                	ld	s1,24(sp)
    80004e06:	6942                	ld	s2,16(sp)
    80004e08:	69a2                	ld	s3,8(sp)
    80004e0a:	6a02                	ld	s4,0(sp)
    80004e0c:	6145                	addi	sp,sp,48
    80004e0e:	8082                	ret
  return -1;
    80004e10:	557d                	li	a0,-1
    80004e12:	b7fd                	j	80004e00 <pipealloc+0xc6>

0000000080004e14 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004e14:	1101                	addi	sp,sp,-32
    80004e16:	ec06                	sd	ra,24(sp)
    80004e18:	e822                	sd	s0,16(sp)
    80004e1a:	e426                	sd	s1,8(sp)
    80004e1c:	e04a                	sd	s2,0(sp)
    80004e1e:	1000                	addi	s0,sp,32
    80004e20:	84aa                	mv	s1,a0
    80004e22:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004e24:	ffffc097          	auipc	ra,0xffffc
    80004e28:	de2080e7          	jalr	-542(ra) # 80000c06 <acquire>
  if(writable){
    80004e2c:	02090d63          	beqz	s2,80004e66 <pipeclose+0x52>
    pi->writeopen = 0;
    80004e30:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004e34:	21848513          	addi	a0,s1,536
    80004e38:	ffffd097          	auipc	ra,0xffffd
    80004e3c:	5fc080e7          	jalr	1532(ra) # 80002434 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004e40:	2204b783          	ld	a5,544(s1)
    80004e44:	eb95                	bnez	a5,80004e78 <pipeclose+0x64>
    release(&pi->lock);
    80004e46:	8526                	mv	a0,s1
    80004e48:	ffffc097          	auipc	ra,0xffffc
    80004e4c:	e72080e7          	jalr	-398(ra) # 80000cba <release>
    kfree((char*)pi);
    80004e50:	8526                	mv	a0,s1
    80004e52:	ffffc097          	auipc	ra,0xffffc
    80004e56:	bc8080e7          	jalr	-1080(ra) # 80000a1a <kfree>
  } else
    release(&pi->lock);
}
    80004e5a:	60e2                	ld	ra,24(sp)
    80004e5c:	6442                	ld	s0,16(sp)
    80004e5e:	64a2                	ld	s1,8(sp)
    80004e60:	6902                	ld	s2,0(sp)
    80004e62:	6105                	addi	sp,sp,32
    80004e64:	8082                	ret
    pi->readopen = 0;
    80004e66:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004e6a:	21c48513          	addi	a0,s1,540
    80004e6e:	ffffd097          	auipc	ra,0xffffd
    80004e72:	5c6080e7          	jalr	1478(ra) # 80002434 <wakeup>
    80004e76:	b7e9                	j	80004e40 <pipeclose+0x2c>
    release(&pi->lock);
    80004e78:	8526                	mv	a0,s1
    80004e7a:	ffffc097          	auipc	ra,0xffffc
    80004e7e:	e40080e7          	jalr	-448(ra) # 80000cba <release>
}
    80004e82:	bfe1                	j	80004e5a <pipeclose+0x46>

0000000080004e84 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004e84:	7159                	addi	sp,sp,-112
    80004e86:	f486                	sd	ra,104(sp)
    80004e88:	f0a2                	sd	s0,96(sp)
    80004e8a:	eca6                	sd	s1,88(sp)
    80004e8c:	e8ca                	sd	s2,80(sp)
    80004e8e:	e4ce                	sd	s3,72(sp)
    80004e90:	e0d2                	sd	s4,64(sp)
    80004e92:	fc56                	sd	s5,56(sp)
    80004e94:	f85a                	sd	s6,48(sp)
    80004e96:	f45e                	sd	s7,40(sp)
    80004e98:	f062                	sd	s8,32(sp)
    80004e9a:	ec66                	sd	s9,24(sp)
    80004e9c:	1880                	addi	s0,sp,112
    80004e9e:	84aa                	mv	s1,a0
    80004ea0:	8b2e                	mv	s6,a1
    80004ea2:	8ab2                	mv	s5,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    80004ea4:	ffffd097          	auipc	ra,0xffffd
    80004ea8:	b6a080e7          	jalr	-1174(ra) # 80001a0e <myproc>
    80004eac:	892a                	mv	s2,a0

  acquire(&pi->lock);
    80004eae:	8526                	mv	a0,s1
    80004eb0:	ffffc097          	auipc	ra,0xffffc
    80004eb4:	d56080e7          	jalr	-682(ra) # 80000c06 <acquire>
  for(i = 0; i < n; i++){
    80004eb8:	09505963          	blez	s5,80004f4a <pipewrite+0xc6>
    80004ebc:	4b81                	li	s7,0
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || pr->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    80004ebe:	21848a13          	addi	s4,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004ec2:	21c48993          	addi	s3,s1,540
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004ec6:	6c05                	lui	s8,0x1
    80004ec8:	9c4a                	add	s8,s8,s2
    80004eca:	5cfd                	li	s9,-1
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004ecc:	2184a783          	lw	a5,536(s1)
    80004ed0:	21c4a703          	lw	a4,540(s1)
    80004ed4:	2007879b          	addiw	a5,a5,512
    80004ed8:	02f71b63          	bne	a4,a5,80004f0e <pipewrite+0x8a>
      if(pi->readopen == 0 || pr->killed){
    80004edc:	2204a783          	lw	a5,544(s1)
    80004ee0:	c3d1                	beqz	a5,80004f64 <pipewrite+0xe0>
    80004ee2:	03092783          	lw	a5,48(s2)
    80004ee6:	efbd                	bnez	a5,80004f64 <pipewrite+0xe0>
      wakeup(&pi->nread);
    80004ee8:	8552                	mv	a0,s4
    80004eea:	ffffd097          	auipc	ra,0xffffd
    80004eee:	54a080e7          	jalr	1354(ra) # 80002434 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004ef2:	85a6                	mv	a1,s1
    80004ef4:	854e                	mv	a0,s3
    80004ef6:	ffffd097          	auipc	ra,0xffffd
    80004efa:	3ba080e7          	jalr	954(ra) # 800022b0 <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004efe:	2184a783          	lw	a5,536(s1)
    80004f02:	21c4a703          	lw	a4,540(s1)
    80004f06:	2007879b          	addiw	a5,a5,512
    80004f0a:	fcf709e3          	beq	a4,a5,80004edc <pipewrite+0x58>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004f0e:	4685                	li	a3,1
    80004f10:	865a                	mv	a2,s6
    80004f12:	f9f40593          	addi	a1,s0,-97
    80004f16:	0a0c3503          	ld	a0,160(s8) # 10a0 <_entry-0x7fffef60>
    80004f1a:	ffffc097          	auipc	ra,0xffffc
    80004f1e:	7f4080e7          	jalr	2036(ra) # 8000170e <copyin>
    80004f22:	03950563          	beq	a0,s9,80004f4c <pipewrite+0xc8>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004f26:	21c4a783          	lw	a5,540(s1)
    80004f2a:	0017871b          	addiw	a4,a5,1
    80004f2e:	20e4ae23          	sw	a4,540(s1)
    80004f32:	1ff7f793          	andi	a5,a5,511
    80004f36:	97a6                	add	a5,a5,s1
    80004f38:	f9f44703          	lbu	a4,-97(s0)
    80004f3c:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    80004f40:	2b85                	addiw	s7,s7,1
    80004f42:	0b05                	addi	s6,s6,1
    80004f44:	f97a94e3          	bne	s5,s7,80004ecc <pipewrite+0x48>
    80004f48:	a011                	j	80004f4c <pipewrite+0xc8>
    80004f4a:	4b81                	li	s7,0
  }
  wakeup(&pi->nread);
    80004f4c:	21848513          	addi	a0,s1,536
    80004f50:	ffffd097          	auipc	ra,0xffffd
    80004f54:	4e4080e7          	jalr	1252(ra) # 80002434 <wakeup>
  release(&pi->lock);
    80004f58:	8526                	mv	a0,s1
    80004f5a:	ffffc097          	auipc	ra,0xffffc
    80004f5e:	d60080e7          	jalr	-672(ra) # 80000cba <release>
  return i;
    80004f62:	a039                	j	80004f70 <pipewrite+0xec>
        release(&pi->lock);
    80004f64:	8526                	mv	a0,s1
    80004f66:	ffffc097          	auipc	ra,0xffffc
    80004f6a:	d54080e7          	jalr	-684(ra) # 80000cba <release>
        return -1;
    80004f6e:	5bfd                	li	s7,-1
}
    80004f70:	855e                	mv	a0,s7
    80004f72:	70a6                	ld	ra,104(sp)
    80004f74:	7406                	ld	s0,96(sp)
    80004f76:	64e6                	ld	s1,88(sp)
    80004f78:	6946                	ld	s2,80(sp)
    80004f7a:	69a6                	ld	s3,72(sp)
    80004f7c:	6a06                	ld	s4,64(sp)
    80004f7e:	7ae2                	ld	s5,56(sp)
    80004f80:	7b42                	ld	s6,48(sp)
    80004f82:	7ba2                	ld	s7,40(sp)
    80004f84:	7c02                	ld	s8,32(sp)
    80004f86:	6ce2                	ld	s9,24(sp)
    80004f88:	6165                	addi	sp,sp,112
    80004f8a:	8082                	ret

0000000080004f8c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004f8c:	715d                	addi	sp,sp,-80
    80004f8e:	e486                	sd	ra,72(sp)
    80004f90:	e0a2                	sd	s0,64(sp)
    80004f92:	fc26                	sd	s1,56(sp)
    80004f94:	f84a                	sd	s2,48(sp)
    80004f96:	f44e                	sd	s3,40(sp)
    80004f98:	f052                	sd	s4,32(sp)
    80004f9a:	ec56                	sd	s5,24(sp)
    80004f9c:	e85a                	sd	s6,16(sp)
    80004f9e:	0880                	addi	s0,sp,80
    80004fa0:	84aa                	mv	s1,a0
    80004fa2:	892e                	mv	s2,a1
    80004fa4:	8a32                	mv	s4,a2
  int i;
  struct proc *pr = myproc();
    80004fa6:	ffffd097          	auipc	ra,0xffffd
    80004faa:	a68080e7          	jalr	-1432(ra) # 80001a0e <myproc>
    80004fae:	8aaa                	mv	s5,a0
  char ch;

  acquire(&pi->lock);
    80004fb0:	8526                	mv	a0,s1
    80004fb2:	ffffc097          	auipc	ra,0xffffc
    80004fb6:	c54080e7          	jalr	-940(ra) # 80000c06 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004fba:	2184a703          	lw	a4,536(s1)
    80004fbe:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004fc2:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004fc6:	02f71463          	bne	a4,a5,80004fee <piperead+0x62>
    80004fca:	2244a783          	lw	a5,548(s1)
    80004fce:	c385                	beqz	a5,80004fee <piperead+0x62>
    if(pr->killed){
    80004fd0:	030aa783          	lw	a5,48(s5)
    80004fd4:	ebd1                	bnez	a5,80005068 <piperead+0xdc>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004fd6:	85a6                	mv	a1,s1
    80004fd8:	854e                	mv	a0,s3
    80004fda:	ffffd097          	auipc	ra,0xffffd
    80004fde:	2d6080e7          	jalr	726(ra) # 800022b0 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004fe2:	2184a703          	lw	a4,536(s1)
    80004fe6:	21c4a783          	lw	a5,540(s1)
    80004fea:	fef700e3          	beq	a4,a5,80004fca <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004fee:	4981                	li	s3,0
    80004ff0:	09405363          	blez	s4,80005076 <piperead+0xea>
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004ff4:	6505                	lui	a0,0x1
    80004ff6:	9aaa                	add	s5,s5,a0
    80004ff8:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004ffa:	2184a783          	lw	a5,536(s1)
    80004ffe:	21c4a703          	lw	a4,540(s1)
    80005002:	02f70d63          	beq	a4,a5,8000503c <piperead+0xb0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80005006:	0017871b          	addiw	a4,a5,1
    8000500a:	20e4ac23          	sw	a4,536(s1)
    8000500e:	1ff7f793          	andi	a5,a5,511
    80005012:	97a6                	add	a5,a5,s1
    80005014:	0187c783          	lbu	a5,24(a5)
    80005018:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000501c:	4685                	li	a3,1
    8000501e:	fbf40613          	addi	a2,s0,-65
    80005022:	85ca                	mv	a1,s2
    80005024:	0a0ab503          	ld	a0,160(s5)
    80005028:	ffffc097          	auipc	ra,0xffffc
    8000502c:	65a080e7          	jalr	1626(ra) # 80001682 <copyout>
    80005030:	01650663          	beq	a0,s6,8000503c <piperead+0xb0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005034:	2985                	addiw	s3,s3,1
    80005036:	0905                	addi	s2,s2,1
    80005038:	fd3a11e3          	bne	s4,s3,80004ffa <piperead+0x6e>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000503c:	21c48513          	addi	a0,s1,540
    80005040:	ffffd097          	auipc	ra,0xffffd
    80005044:	3f4080e7          	jalr	1012(ra) # 80002434 <wakeup>
  release(&pi->lock);
    80005048:	8526                	mv	a0,s1
    8000504a:	ffffc097          	auipc	ra,0xffffc
    8000504e:	c70080e7          	jalr	-912(ra) # 80000cba <release>
  return i;
}
    80005052:	854e                	mv	a0,s3
    80005054:	60a6                	ld	ra,72(sp)
    80005056:	6406                	ld	s0,64(sp)
    80005058:	74e2                	ld	s1,56(sp)
    8000505a:	7942                	ld	s2,48(sp)
    8000505c:	79a2                	ld	s3,40(sp)
    8000505e:	7a02                	ld	s4,32(sp)
    80005060:	6ae2                	ld	s5,24(sp)
    80005062:	6b42                	ld	s6,16(sp)
    80005064:	6161                	addi	sp,sp,80
    80005066:	8082                	ret
      release(&pi->lock);
    80005068:	8526                	mv	a0,s1
    8000506a:	ffffc097          	auipc	ra,0xffffc
    8000506e:	c50080e7          	jalr	-944(ra) # 80000cba <release>
      return -1;
    80005072:	59fd                	li	s3,-1
    80005074:	bff9                	j	80005052 <piperead+0xc6>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005076:	4981                	li	s3,0
    80005078:	b7d1                	j	8000503c <piperead+0xb0>

000000008000507a <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000507a:	de010113          	addi	sp,sp,-544
    8000507e:	20113c23          	sd	ra,536(sp)
    80005082:	20813823          	sd	s0,528(sp)
    80005086:	20913423          	sd	s1,520(sp)
    8000508a:	21213023          	sd	s2,512(sp)
    8000508e:	ffce                	sd	s3,504(sp)
    80005090:	fbd2                	sd	s4,496(sp)
    80005092:	f7d6                	sd	s5,488(sp)
    80005094:	f3da                	sd	s6,480(sp)
    80005096:	efde                	sd	s7,472(sp)
    80005098:	ebe2                	sd	s8,464(sp)
    8000509a:	e7e6                	sd	s9,456(sp)
    8000509c:	e3ea                	sd	s10,448(sp)
    8000509e:	ff6e                	sd	s11,440(sp)
    800050a0:	1400                	addi	s0,sp,544
    800050a2:	892a                	mv	s2,a0
    800050a4:	dea43423          	sd	a0,-536(s0)
    800050a8:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800050ac:	ffffd097          	auipc	ra,0xffffd
    800050b0:	962080e7          	jalr	-1694(ra) # 80001a0e <myproc>
    800050b4:	84aa                	mv	s1,a0

  begin_op();
    800050b6:	fffff097          	auipc	ra,0xfffff
    800050ba:	458080e7          	jalr	1112(ra) # 8000450e <begin_op>

  if((ip = namei(path)) == 0){
    800050be:	854a                	mv	a0,s2
    800050c0:	fffff097          	auipc	ra,0xfffff
    800050c4:	232080e7          	jalr	562(ra) # 800042f2 <namei>
    800050c8:	c93d                	beqz	a0,8000513e <exec+0xc4>
    800050ca:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800050cc:	fffff097          	auipc	ra,0xfffff
    800050d0:	a6e080e7          	jalr	-1426(ra) # 80003b3a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800050d4:	04000713          	li	a4,64
    800050d8:	4681                	li	a3,0
    800050da:	e4840613          	addi	a2,s0,-440
    800050de:	4581                	li	a1,0
    800050e0:	8556                	mv	a0,s5
    800050e2:	fffff097          	auipc	ra,0xfffff
    800050e6:	d0c080e7          	jalr	-756(ra) # 80003dee <readi>
    800050ea:	04000793          	li	a5,64
    800050ee:	00f51a63          	bne	a0,a5,80005102 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800050f2:	e4842703          	lw	a4,-440(s0)
    800050f6:	464c47b7          	lui	a5,0x464c4
    800050fa:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800050fe:	04f70663          	beq	a4,a5,8000514a <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005102:	8556                	mv	a0,s5
    80005104:	fffff097          	auipc	ra,0xfffff
    80005108:	c98080e7          	jalr	-872(ra) # 80003d9c <iunlockput>
    end_op();
    8000510c:	fffff097          	auipc	ra,0xfffff
    80005110:	482080e7          	jalr	1154(ra) # 8000458e <end_op>
  }
  return -1;
    80005114:	557d                	li	a0,-1
}
    80005116:	21813083          	ld	ra,536(sp)
    8000511a:	21013403          	ld	s0,528(sp)
    8000511e:	20813483          	ld	s1,520(sp)
    80005122:	20013903          	ld	s2,512(sp)
    80005126:	79fe                	ld	s3,504(sp)
    80005128:	7a5e                	ld	s4,496(sp)
    8000512a:	7abe                	ld	s5,488(sp)
    8000512c:	7b1e                	ld	s6,480(sp)
    8000512e:	6bfe                	ld	s7,472(sp)
    80005130:	6c5e                	ld	s8,464(sp)
    80005132:	6cbe                	ld	s9,456(sp)
    80005134:	6d1e                	ld	s10,448(sp)
    80005136:	7dfa                	ld	s11,440(sp)
    80005138:	22010113          	addi	sp,sp,544
    8000513c:	8082                	ret
    end_op();
    8000513e:	fffff097          	auipc	ra,0xfffff
    80005142:	450080e7          	jalr	1104(ra) # 8000458e <end_op>
    return -1;
    80005146:	557d                	li	a0,-1
    80005148:	b7f9                	j	80005116 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    8000514a:	8526                	mv	a0,s1
    8000514c:	ffffd097          	auipc	ra,0xffffd
    80005150:	986080e7          	jalr	-1658(ra) # 80001ad2 <proc_pagetable>
    80005154:	8b2a                	mv	s6,a0
    80005156:	d555                	beqz	a0,80005102 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005158:	e6842783          	lw	a5,-408(s0)
    8000515c:	e8045703          	lhu	a4,-384(s0)
    80005160:	c735                	beqz	a4,800051cc <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80005162:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005164:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80005168:	6a05                	lui	s4,0x1
    8000516a:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    8000516e:	dee43023          	sd	a4,-544(s0)
  uint64 pa;

  if((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    80005172:	6d85                	lui	s11,0x1
    80005174:	7d7d                	lui	s10,0xfffff
    80005176:	a489                	j	800053b8 <exec+0x33e>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80005178:	00003517          	auipc	a0,0x3
    8000517c:	55050513          	addi	a0,a0,1360 # 800086c8 <syscalls+0x2a8>
    80005180:	ffffb097          	auipc	ra,0xffffb
    80005184:	3ca080e7          	jalr	970(ra) # 8000054a <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005188:	874a                	mv	a4,s2
    8000518a:	009c86bb          	addw	a3,s9,s1
    8000518e:	4581                	li	a1,0
    80005190:	8556                	mv	a0,s5
    80005192:	fffff097          	auipc	ra,0xfffff
    80005196:	c5c080e7          	jalr	-932(ra) # 80003dee <readi>
    8000519a:	2501                	sext.w	a0,a0
    8000519c:	1aa91e63          	bne	s2,a0,80005358 <exec+0x2de>
  for(i = 0; i < sz; i += PGSIZE){
    800051a0:	009d84bb          	addw	s1,s11,s1
    800051a4:	013d09bb          	addw	s3,s10,s3
    800051a8:	1f74f863          	bgeu	s1,s7,80005398 <exec+0x31e>
    pa = walkaddr(pagetable, va + i);
    800051ac:	02049593          	slli	a1,s1,0x20
    800051b0:	9181                	srli	a1,a1,0x20
    800051b2:	95e2                	add	a1,a1,s8
    800051b4:	855a                	mv	a0,s6
    800051b6:	ffffc097          	auipc	ra,0xffffc
    800051ba:	eda080e7          	jalr	-294(ra) # 80001090 <walkaddr>
    800051be:	862a                	mv	a2,a0
    if(pa == 0)
    800051c0:	dd45                	beqz	a0,80005178 <exec+0xfe>
      n = PGSIZE;
    800051c2:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800051c4:	fd49f2e3          	bgeu	s3,s4,80005188 <exec+0x10e>
      n = sz - i;
    800051c8:	894e                	mv	s2,s3
    800051ca:	bf7d                	j	80005188 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    800051cc:	4481                	li	s1,0
  iunlockput(ip);
    800051ce:	8556                	mv	a0,s5
    800051d0:	fffff097          	auipc	ra,0xfffff
    800051d4:	bcc080e7          	jalr	-1076(ra) # 80003d9c <iunlockput>
  end_op();
    800051d8:	fffff097          	auipc	ra,0xfffff
    800051dc:	3b6080e7          	jalr	950(ra) # 8000458e <end_op>
  p = myproc();
    800051e0:	ffffd097          	auipc	ra,0xffffd
    800051e4:	82e080e7          	jalr	-2002(ra) # 80001a0e <myproc>
    800051e8:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800051ea:	6785                	lui	a5,0x1
    800051ec:	00f50733          	add	a4,a0,a5
    800051f0:	09873d03          	ld	s10,152(a4)
  sz = PGROUNDUP(sz);
    800051f4:	17fd                	addi	a5,a5,-1
    800051f6:	94be                	add	s1,s1,a5
    800051f8:	77fd                	lui	a5,0xfffff
    800051fa:	8fe5                	and	a5,a5,s1
    800051fc:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80005200:	6609                	lui	a2,0x2
    80005202:	963e                	add	a2,a2,a5
    80005204:	85be                	mv	a1,a5
    80005206:	855a                	mv	a0,s6
    80005208:	ffffc097          	auipc	ra,0xffffc
    8000520c:	22a080e7          	jalr	554(ra) # 80001432 <uvmalloc>
    80005210:	8c2a                	mv	s8,a0
  ip = 0;
    80005212:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80005214:	14050263          	beqz	a0,80005358 <exec+0x2de>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005218:	75f9                	lui	a1,0xffffe
    8000521a:	95aa                	add	a1,a1,a0
    8000521c:	855a                	mv	a0,s6
    8000521e:	ffffc097          	auipc	ra,0xffffc
    80005222:	432080e7          	jalr	1074(ra) # 80001650 <uvmclear>
  stackbase = sp - PGSIZE;
    80005226:	7afd                	lui	s5,0xfffff
    80005228:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    8000522a:	df043783          	ld	a5,-528(s0)
    8000522e:	6388                	ld	a0,0(a5)
    80005230:	c925                	beqz	a0,800052a0 <exec+0x226>
    80005232:	e8840993          	addi	s3,s0,-376
    80005236:	f8840c93          	addi	s9,s0,-120
  sp = sz;
    8000523a:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000523c:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000523e:	ffffc097          	auipc	ra,0xffffc
    80005242:	c48080e7          	jalr	-952(ra) # 80000e86 <strlen>
    80005246:	0015079b          	addiw	a5,a0,1
    8000524a:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000524e:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80005252:	13596763          	bltu	s2,s5,80005380 <exec+0x306>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005256:	df043d83          	ld	s11,-528(s0)
    8000525a:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    8000525e:	8552                	mv	a0,s4
    80005260:	ffffc097          	auipc	ra,0xffffc
    80005264:	c26080e7          	jalr	-986(ra) # 80000e86 <strlen>
    80005268:	0015069b          	addiw	a3,a0,1
    8000526c:	8652                	mv	a2,s4
    8000526e:	85ca                	mv	a1,s2
    80005270:	855a                	mv	a0,s6
    80005272:	ffffc097          	auipc	ra,0xffffc
    80005276:	410080e7          	jalr	1040(ra) # 80001682 <copyout>
    8000527a:	10054763          	bltz	a0,80005388 <exec+0x30e>
    ustack[argc] = sp;
    8000527e:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80005282:	0485                	addi	s1,s1,1
    80005284:	008d8793          	addi	a5,s11,8
    80005288:	def43823          	sd	a5,-528(s0)
    8000528c:	008db503          	ld	a0,8(s11)
    80005290:	c911                	beqz	a0,800052a4 <exec+0x22a>
    if(argc >= MAXARG)
    80005292:	09a1                	addi	s3,s3,8
    80005294:	fb3c95e3          	bne	s9,s3,8000523e <exec+0x1c4>
  sz = sz1;
    80005298:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000529c:	4a81                	li	s5,0
    8000529e:	a86d                	j	80005358 <exec+0x2de>
  sp = sz;
    800052a0:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800052a2:	4481                	li	s1,0
  ustack[argc] = 0;
    800052a4:	00349793          	slli	a5,s1,0x3
    800052a8:	f9040713          	addi	a4,s0,-112
    800052ac:	97ba                	add	a5,a5,a4
    800052ae:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ff97ef8>
  sp -= (argc+1) * sizeof(uint64);
    800052b2:	00148693          	addi	a3,s1,1
    800052b6:	068e                	slli	a3,a3,0x3
    800052b8:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800052bc:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800052c0:	01597663          	bgeu	s2,s5,800052cc <exec+0x252>
  sz = sz1;
    800052c4:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800052c8:	4a81                	li	s5,0
    800052ca:	a079                	j	80005358 <exec+0x2de>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800052cc:	e8840613          	addi	a2,s0,-376
    800052d0:	85ca                	mv	a1,s2
    800052d2:	855a                	mv	a0,s6
    800052d4:	ffffc097          	auipc	ra,0xffffc
    800052d8:	3ae080e7          	jalr	942(ra) # 80001682 <copyout>
    800052dc:	0a054a63          	bltz	a0,80005390 <exec+0x316>
  p->trapframe->a1 = sp;
    800052e0:	6785                	lui	a5,0x1
    800052e2:	97de                	add	a5,a5,s7
    800052e4:	77dc                	ld	a5,168(a5)
    800052e6:	0727bc23          	sd	s2,120(a5) # 1078 <_entry-0x7fffef88>
  for(last=s=path; *s; s++)
    800052ea:	de843783          	ld	a5,-536(s0)
    800052ee:	0007c703          	lbu	a4,0(a5)
    800052f2:	cf11                	beqz	a4,8000530e <exec+0x294>
    800052f4:	0785                	addi	a5,a5,1
    if(*s == '/')
    800052f6:	02f00693          	li	a3,47
    800052fa:	a039                	j	80005308 <exec+0x28e>
      last = s+1;
    800052fc:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80005300:	0785                	addi	a5,a5,1
    80005302:	fff7c703          	lbu	a4,-1(a5)
    80005306:	c701                	beqz	a4,8000530e <exec+0x294>
    if(*s == '/')
    80005308:	fed71ce3          	bne	a4,a3,80005300 <exec+0x286>
    8000530c:	bfc5                	j	800052fc <exec+0x282>
  safestrcpy(p->name, last, sizeof(p->name));
    8000530e:	6985                	lui	s3,0x1
    80005310:	1a898513          	addi	a0,s3,424 # 11a8 <_entry-0x7fffee58>
    80005314:	4641                	li	a2,16
    80005316:	de843583          	ld	a1,-536(s0)
    8000531a:	955e                	add	a0,a0,s7
    8000531c:	ffffc097          	auipc	ra,0xffffc
    80005320:	b38080e7          	jalr	-1224(ra) # 80000e54 <safestrcpy>
  oldpagetable = p->pagetable;
    80005324:	9bce                	add	s7,s7,s3
    80005326:	0a0bb503          	ld	a0,160(s7) # 10a0 <_entry-0x7fffef60>
  p->pagetable = pagetable;
    8000532a:	0b6bb023          	sd	s6,160(s7)
  p->sz = sz;
    8000532e:	098bbc23          	sd	s8,152(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005332:	0a8bb783          	ld	a5,168(s7)
    80005336:	e6043703          	ld	a4,-416(s0)
    8000533a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000533c:	0a8bb783          	ld	a5,168(s7)
    80005340:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005344:	85ea                	mv	a1,s10
    80005346:	ffffd097          	auipc	ra,0xffffd
    8000534a:	82a080e7          	jalr	-2006(ra) # 80001b70 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000534e:	0004851b          	sext.w	a0,s1
    80005352:	b3d1                	j	80005116 <exec+0x9c>
    80005354:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005358:	df843583          	ld	a1,-520(s0)
    8000535c:	855a                	mv	a0,s6
    8000535e:	ffffd097          	auipc	ra,0xffffd
    80005362:	812080e7          	jalr	-2030(ra) # 80001b70 <proc_freepagetable>
  if(ip){
    80005366:	d80a9ee3          	bnez	s5,80005102 <exec+0x88>
  return -1;
    8000536a:	557d                	li	a0,-1
    8000536c:	b36d                	j	80005116 <exec+0x9c>
    8000536e:	de943c23          	sd	s1,-520(s0)
    80005372:	b7dd                	j	80005358 <exec+0x2de>
    80005374:	de943c23          	sd	s1,-520(s0)
    80005378:	b7c5                	j	80005358 <exec+0x2de>
    8000537a:	de943c23          	sd	s1,-520(s0)
    8000537e:	bfe9                	j	80005358 <exec+0x2de>
  sz = sz1;
    80005380:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005384:	4a81                	li	s5,0
    80005386:	bfc9                	j	80005358 <exec+0x2de>
  sz = sz1;
    80005388:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000538c:	4a81                	li	s5,0
    8000538e:	b7e9                	j	80005358 <exec+0x2de>
  sz = sz1;
    80005390:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005394:	4a81                	li	s5,0
    80005396:	b7c9                	j	80005358 <exec+0x2de>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80005398:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000539c:	e0843783          	ld	a5,-504(s0)
    800053a0:	0017869b          	addiw	a3,a5,1
    800053a4:	e0d43423          	sd	a3,-504(s0)
    800053a8:	e0043783          	ld	a5,-512(s0)
    800053ac:	0387879b          	addiw	a5,a5,56
    800053b0:	e8045703          	lhu	a4,-384(s0)
    800053b4:	e0e6dde3          	bge	a3,a4,800051ce <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800053b8:	2781                	sext.w	a5,a5
    800053ba:	e0f43023          	sd	a5,-512(s0)
    800053be:	03800713          	li	a4,56
    800053c2:	86be                	mv	a3,a5
    800053c4:	e1040613          	addi	a2,s0,-496
    800053c8:	4581                	li	a1,0
    800053ca:	8556                	mv	a0,s5
    800053cc:	fffff097          	auipc	ra,0xfffff
    800053d0:	a22080e7          	jalr	-1502(ra) # 80003dee <readi>
    800053d4:	03800793          	li	a5,56
    800053d8:	f6f51ee3          	bne	a0,a5,80005354 <exec+0x2da>
    if(ph.type != ELF_PROG_LOAD)
    800053dc:	e1042783          	lw	a5,-496(s0)
    800053e0:	4705                	li	a4,1
    800053e2:	fae79de3          	bne	a5,a4,8000539c <exec+0x322>
    if(ph.memsz < ph.filesz)
    800053e6:	e3843603          	ld	a2,-456(s0)
    800053ea:	e3043783          	ld	a5,-464(s0)
    800053ee:	f8f660e3          	bltu	a2,a5,8000536e <exec+0x2f4>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800053f2:	e2043783          	ld	a5,-480(s0)
    800053f6:	963e                	add	a2,a2,a5
    800053f8:	f6f66ee3          	bltu	a2,a5,80005374 <exec+0x2fa>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800053fc:	85a6                	mv	a1,s1
    800053fe:	855a                	mv	a0,s6
    80005400:	ffffc097          	auipc	ra,0xffffc
    80005404:	032080e7          	jalr	50(ra) # 80001432 <uvmalloc>
    80005408:	dea43c23          	sd	a0,-520(s0)
    8000540c:	d53d                	beqz	a0,8000537a <exec+0x300>
    if(ph.vaddr % PGSIZE != 0)
    8000540e:	e2043c03          	ld	s8,-480(s0)
    80005412:	de043783          	ld	a5,-544(s0)
    80005416:	00fc77b3          	and	a5,s8,a5
    8000541a:	ff9d                	bnez	a5,80005358 <exec+0x2de>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000541c:	e1842c83          	lw	s9,-488(s0)
    80005420:	e3042b83          	lw	s7,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005424:	f60b8ae3          	beqz	s7,80005398 <exec+0x31e>
    80005428:	89de                	mv	s3,s7
    8000542a:	4481                	li	s1,0
    8000542c:	b341                	j	800051ac <exec+0x132>

000000008000542e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000542e:	7179                	addi	sp,sp,-48
    80005430:	f406                	sd	ra,40(sp)
    80005432:	f022                	sd	s0,32(sp)
    80005434:	ec26                	sd	s1,24(sp)
    80005436:	e84a                	sd	s2,16(sp)
    80005438:	1800                	addi	s0,sp,48
    8000543a:	892e                	mv	s2,a1
    8000543c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000543e:	fdc40593          	addi	a1,s0,-36
    80005442:	ffffe097          	auipc	ra,0xffffe
    80005446:	938080e7          	jalr	-1736(ra) # 80002d7a <argint>
    8000544a:	04054063          	bltz	a0,8000548a <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000544e:	fdc42703          	lw	a4,-36(s0)
    80005452:	47bd                	li	a5,15
    80005454:	02e7ed63          	bltu	a5,a4,8000548e <argfd+0x60>
    80005458:	ffffc097          	auipc	ra,0xffffc
    8000545c:	5b6080e7          	jalr	1462(ra) # 80001a0e <myproc>
    80005460:	fdc42703          	lw	a4,-36(s0)
    80005464:	22470793          	addi	a5,a4,548
    80005468:	078e                	slli	a5,a5,0x3
    8000546a:	953e                	add	a0,a0,a5
    8000546c:	611c                	ld	a5,0(a0)
    8000546e:	c395                	beqz	a5,80005492 <argfd+0x64>
    return -1;
  if(pfd)
    80005470:	00090463          	beqz	s2,80005478 <argfd+0x4a>
    *pfd = fd;
    80005474:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005478:	4501                	li	a0,0
  if(pf)
    8000547a:	c091                	beqz	s1,8000547e <argfd+0x50>
    *pf = f;
    8000547c:	e09c                	sd	a5,0(s1)
}
    8000547e:	70a2                	ld	ra,40(sp)
    80005480:	7402                	ld	s0,32(sp)
    80005482:	64e2                	ld	s1,24(sp)
    80005484:	6942                	ld	s2,16(sp)
    80005486:	6145                	addi	sp,sp,48
    80005488:	8082                	ret
    return -1;
    8000548a:	557d                	li	a0,-1
    8000548c:	bfcd                	j	8000547e <argfd+0x50>
    return -1;
    8000548e:	557d                	li	a0,-1
    80005490:	b7fd                	j	8000547e <argfd+0x50>
    80005492:	557d                	li	a0,-1
    80005494:	b7ed                	j	8000547e <argfd+0x50>

0000000080005496 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005496:	1101                	addi	sp,sp,-32
    80005498:	ec06                	sd	ra,24(sp)
    8000549a:	e822                	sd	s0,16(sp)
    8000549c:	e426                	sd	s1,8(sp)
    8000549e:	1000                	addi	s0,sp,32
    800054a0:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800054a2:	ffffc097          	auipc	ra,0xffffc
    800054a6:	56c080e7          	jalr	1388(ra) # 80001a0e <myproc>
    800054aa:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800054ac:	6785                	lui	a5,0x1
    800054ae:	12078793          	addi	a5,a5,288 # 1120 <_entry-0x7fffeee0>
    800054b2:	97aa                	add	a5,a5,a0
    800054b4:	4501                	li	a0,0
    800054b6:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800054b8:	6398                	ld	a4,0(a5)
    800054ba:	cb19                	beqz	a4,800054d0 <fdalloc+0x3a>
  for(fd = 0; fd < NOFILE; fd++){
    800054bc:	2505                	addiw	a0,a0,1
    800054be:	07a1                	addi	a5,a5,8
    800054c0:	fed51ce3          	bne	a0,a3,800054b8 <fdalloc+0x22>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800054c4:	557d                	li	a0,-1
}
    800054c6:	60e2                	ld	ra,24(sp)
    800054c8:	6442                	ld	s0,16(sp)
    800054ca:	64a2                	ld	s1,8(sp)
    800054cc:	6105                	addi	sp,sp,32
    800054ce:	8082                	ret
      p->ofile[fd] = f;
    800054d0:	22450793          	addi	a5,a0,548
    800054d4:	078e                	slli	a5,a5,0x3
    800054d6:	963e                	add	a2,a2,a5
    800054d8:	e204                	sd	s1,0(a2)
      return fd;
    800054da:	b7f5                	j	800054c6 <fdalloc+0x30>

00000000800054dc <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800054dc:	715d                	addi	sp,sp,-80
    800054de:	e486                	sd	ra,72(sp)
    800054e0:	e0a2                	sd	s0,64(sp)
    800054e2:	fc26                	sd	s1,56(sp)
    800054e4:	f84a                	sd	s2,48(sp)
    800054e6:	f44e                	sd	s3,40(sp)
    800054e8:	f052                	sd	s4,32(sp)
    800054ea:	ec56                	sd	s5,24(sp)
    800054ec:	0880                	addi	s0,sp,80
    800054ee:	89ae                	mv	s3,a1
    800054f0:	8ab2                	mv	s5,a2
    800054f2:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800054f4:	fb040593          	addi	a1,s0,-80
    800054f8:	fffff097          	auipc	ra,0xfffff
    800054fc:	e18080e7          	jalr	-488(ra) # 80004310 <nameiparent>
    80005500:	892a                	mv	s2,a0
    80005502:	12050e63          	beqz	a0,8000563e <create+0x162>
    return 0;

  ilock(dp);
    80005506:	ffffe097          	auipc	ra,0xffffe
    8000550a:	634080e7          	jalr	1588(ra) # 80003b3a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000550e:	4601                	li	a2,0
    80005510:	fb040593          	addi	a1,s0,-80
    80005514:	854a                	mv	a0,s2
    80005516:	fffff097          	auipc	ra,0xfffff
    8000551a:	b06080e7          	jalr	-1274(ra) # 8000401c <dirlookup>
    8000551e:	84aa                	mv	s1,a0
    80005520:	c921                	beqz	a0,80005570 <create+0x94>
    iunlockput(dp);
    80005522:	854a                	mv	a0,s2
    80005524:	fffff097          	auipc	ra,0xfffff
    80005528:	878080e7          	jalr	-1928(ra) # 80003d9c <iunlockput>
    ilock(ip);
    8000552c:	8526                	mv	a0,s1
    8000552e:	ffffe097          	auipc	ra,0xffffe
    80005532:	60c080e7          	jalr	1548(ra) # 80003b3a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005536:	2981                	sext.w	s3,s3
    80005538:	4789                	li	a5,2
    8000553a:	02f99463          	bne	s3,a5,80005562 <create+0x86>
    8000553e:	0444d783          	lhu	a5,68(s1)
    80005542:	37f9                	addiw	a5,a5,-2
    80005544:	17c2                	slli	a5,a5,0x30
    80005546:	93c1                	srli	a5,a5,0x30
    80005548:	4705                	li	a4,1
    8000554a:	00f76c63          	bltu	a4,a5,80005562 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000554e:	8526                	mv	a0,s1
    80005550:	60a6                	ld	ra,72(sp)
    80005552:	6406                	ld	s0,64(sp)
    80005554:	74e2                	ld	s1,56(sp)
    80005556:	7942                	ld	s2,48(sp)
    80005558:	79a2                	ld	s3,40(sp)
    8000555a:	7a02                	ld	s4,32(sp)
    8000555c:	6ae2                	ld	s5,24(sp)
    8000555e:	6161                	addi	sp,sp,80
    80005560:	8082                	ret
    iunlockput(ip);
    80005562:	8526                	mv	a0,s1
    80005564:	fffff097          	auipc	ra,0xfffff
    80005568:	838080e7          	jalr	-1992(ra) # 80003d9c <iunlockput>
    return 0;
    8000556c:	4481                	li	s1,0
    8000556e:	b7c5                	j	8000554e <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80005570:	85ce                	mv	a1,s3
    80005572:	00092503          	lw	a0,0(s2)
    80005576:	ffffe097          	auipc	ra,0xffffe
    8000557a:	42c080e7          	jalr	1068(ra) # 800039a2 <ialloc>
    8000557e:	84aa                	mv	s1,a0
    80005580:	c521                	beqz	a0,800055c8 <create+0xec>
  ilock(ip);
    80005582:	ffffe097          	auipc	ra,0xffffe
    80005586:	5b8080e7          	jalr	1464(ra) # 80003b3a <ilock>
  ip->major = major;
    8000558a:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    8000558e:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80005592:	4a05                	li	s4,1
    80005594:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80005598:	8526                	mv	a0,s1
    8000559a:	ffffe097          	auipc	ra,0xffffe
    8000559e:	4d6080e7          	jalr	1238(ra) # 80003a70 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800055a2:	2981                	sext.w	s3,s3
    800055a4:	03498a63          	beq	s3,s4,800055d8 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800055a8:	40d0                	lw	a2,4(s1)
    800055aa:	fb040593          	addi	a1,s0,-80
    800055ae:	854a                	mv	a0,s2
    800055b0:	fffff097          	auipc	ra,0xfffff
    800055b4:	c80080e7          	jalr	-896(ra) # 80004230 <dirlink>
    800055b8:	06054b63          	bltz	a0,8000562e <create+0x152>
  iunlockput(dp);
    800055bc:	854a                	mv	a0,s2
    800055be:	ffffe097          	auipc	ra,0xffffe
    800055c2:	7de080e7          	jalr	2014(ra) # 80003d9c <iunlockput>
  return ip;
    800055c6:	b761                	j	8000554e <create+0x72>
    panic("create: ialloc");
    800055c8:	00003517          	auipc	a0,0x3
    800055cc:	12050513          	addi	a0,a0,288 # 800086e8 <syscalls+0x2c8>
    800055d0:	ffffb097          	auipc	ra,0xffffb
    800055d4:	f7a080e7          	jalr	-134(ra) # 8000054a <panic>
    dp->nlink++;  // for ".."
    800055d8:	04a95783          	lhu	a5,74(s2)
    800055dc:	2785                	addiw	a5,a5,1
    800055de:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800055e2:	854a                	mv	a0,s2
    800055e4:	ffffe097          	auipc	ra,0xffffe
    800055e8:	48c080e7          	jalr	1164(ra) # 80003a70 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800055ec:	40d0                	lw	a2,4(s1)
    800055ee:	00003597          	auipc	a1,0x3
    800055f2:	10a58593          	addi	a1,a1,266 # 800086f8 <syscalls+0x2d8>
    800055f6:	8526                	mv	a0,s1
    800055f8:	fffff097          	auipc	ra,0xfffff
    800055fc:	c38080e7          	jalr	-968(ra) # 80004230 <dirlink>
    80005600:	00054f63          	bltz	a0,8000561e <create+0x142>
    80005604:	00492603          	lw	a2,4(s2)
    80005608:	00003597          	auipc	a1,0x3
    8000560c:	0f858593          	addi	a1,a1,248 # 80008700 <syscalls+0x2e0>
    80005610:	8526                	mv	a0,s1
    80005612:	fffff097          	auipc	ra,0xfffff
    80005616:	c1e080e7          	jalr	-994(ra) # 80004230 <dirlink>
    8000561a:	f80557e3          	bgez	a0,800055a8 <create+0xcc>
      panic("create dots");
    8000561e:	00003517          	auipc	a0,0x3
    80005622:	0ea50513          	addi	a0,a0,234 # 80008708 <syscalls+0x2e8>
    80005626:	ffffb097          	auipc	ra,0xffffb
    8000562a:	f24080e7          	jalr	-220(ra) # 8000054a <panic>
    panic("create: dirlink");
    8000562e:	00003517          	auipc	a0,0x3
    80005632:	0ea50513          	addi	a0,a0,234 # 80008718 <syscalls+0x2f8>
    80005636:	ffffb097          	auipc	ra,0xffffb
    8000563a:	f14080e7          	jalr	-236(ra) # 8000054a <panic>
    return 0;
    8000563e:	84aa                	mv	s1,a0
    80005640:	b739                	j	8000554e <create+0x72>

0000000080005642 <sys_dup>:
{
    80005642:	7179                	addi	sp,sp,-48
    80005644:	f406                	sd	ra,40(sp)
    80005646:	f022                	sd	s0,32(sp)
    80005648:	ec26                	sd	s1,24(sp)
    8000564a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000564c:	fd840613          	addi	a2,s0,-40
    80005650:	4581                	li	a1,0
    80005652:	4501                	li	a0,0
    80005654:	00000097          	auipc	ra,0x0
    80005658:	dda080e7          	jalr	-550(ra) # 8000542e <argfd>
    return -1;
    8000565c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000565e:	02054363          	bltz	a0,80005684 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80005662:	fd843503          	ld	a0,-40(s0)
    80005666:	00000097          	auipc	ra,0x0
    8000566a:	e30080e7          	jalr	-464(ra) # 80005496 <fdalloc>
    8000566e:	84aa                	mv	s1,a0
    return -1;
    80005670:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005672:	00054963          	bltz	a0,80005684 <sys_dup+0x42>
  filedup(f);
    80005676:	fd843503          	ld	a0,-40(s0)
    8000567a:	fffff097          	auipc	ra,0xfffff
    8000567e:	316080e7          	jalr	790(ra) # 80004990 <filedup>
  return fd;
    80005682:	87a6                	mv	a5,s1
}
    80005684:	853e                	mv	a0,a5
    80005686:	70a2                	ld	ra,40(sp)
    80005688:	7402                	ld	s0,32(sp)
    8000568a:	64e2                	ld	s1,24(sp)
    8000568c:	6145                	addi	sp,sp,48
    8000568e:	8082                	ret

0000000080005690 <sys_read>:
{
    80005690:	7179                	addi	sp,sp,-48
    80005692:	f406                	sd	ra,40(sp)
    80005694:	f022                	sd	s0,32(sp)
    80005696:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005698:	fe840613          	addi	a2,s0,-24
    8000569c:	4581                	li	a1,0
    8000569e:	4501                	li	a0,0
    800056a0:	00000097          	auipc	ra,0x0
    800056a4:	d8e080e7          	jalr	-626(ra) # 8000542e <argfd>
    return -1;
    800056a8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800056aa:	04054163          	bltz	a0,800056ec <sys_read+0x5c>
    800056ae:	fe440593          	addi	a1,s0,-28
    800056b2:	4509                	li	a0,2
    800056b4:	ffffd097          	auipc	ra,0xffffd
    800056b8:	6c6080e7          	jalr	1734(ra) # 80002d7a <argint>
    return -1;
    800056bc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800056be:	02054763          	bltz	a0,800056ec <sys_read+0x5c>
    800056c2:	fd840593          	addi	a1,s0,-40
    800056c6:	4505                	li	a0,1
    800056c8:	ffffd097          	auipc	ra,0xffffd
    800056cc:	6d4080e7          	jalr	1748(ra) # 80002d9c <argaddr>
    return -1;
    800056d0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800056d2:	00054d63          	bltz	a0,800056ec <sys_read+0x5c>
  return fileread(f, p, n);
    800056d6:	fe442603          	lw	a2,-28(s0)
    800056da:	fd843583          	ld	a1,-40(s0)
    800056de:	fe843503          	ld	a0,-24(s0)
    800056e2:	fffff097          	auipc	ra,0xfffff
    800056e6:	43c080e7          	jalr	1084(ra) # 80004b1e <fileread>
    800056ea:	87aa                	mv	a5,a0
}
    800056ec:	853e                	mv	a0,a5
    800056ee:	70a2                	ld	ra,40(sp)
    800056f0:	7402                	ld	s0,32(sp)
    800056f2:	6145                	addi	sp,sp,48
    800056f4:	8082                	ret

00000000800056f6 <sys_write>:
{
    800056f6:	7179                	addi	sp,sp,-48
    800056f8:	f406                	sd	ra,40(sp)
    800056fa:	f022                	sd	s0,32(sp)
    800056fc:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800056fe:	fe840613          	addi	a2,s0,-24
    80005702:	4581                	li	a1,0
    80005704:	4501                	li	a0,0
    80005706:	00000097          	auipc	ra,0x0
    8000570a:	d28080e7          	jalr	-728(ra) # 8000542e <argfd>
    return -1;
    8000570e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005710:	04054163          	bltz	a0,80005752 <sys_write+0x5c>
    80005714:	fe440593          	addi	a1,s0,-28
    80005718:	4509                	li	a0,2
    8000571a:	ffffd097          	auipc	ra,0xffffd
    8000571e:	660080e7          	jalr	1632(ra) # 80002d7a <argint>
    return -1;
    80005722:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005724:	02054763          	bltz	a0,80005752 <sys_write+0x5c>
    80005728:	fd840593          	addi	a1,s0,-40
    8000572c:	4505                	li	a0,1
    8000572e:	ffffd097          	auipc	ra,0xffffd
    80005732:	66e080e7          	jalr	1646(ra) # 80002d9c <argaddr>
    return -1;
    80005736:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005738:	00054d63          	bltz	a0,80005752 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000573c:	fe442603          	lw	a2,-28(s0)
    80005740:	fd843583          	ld	a1,-40(s0)
    80005744:	fe843503          	ld	a0,-24(s0)
    80005748:	fffff097          	auipc	ra,0xfffff
    8000574c:	498080e7          	jalr	1176(ra) # 80004be0 <filewrite>
    80005750:	87aa                	mv	a5,a0
}
    80005752:	853e                	mv	a0,a5
    80005754:	70a2                	ld	ra,40(sp)
    80005756:	7402                	ld	s0,32(sp)
    80005758:	6145                	addi	sp,sp,48
    8000575a:	8082                	ret

000000008000575c <sys_close>:
{
    8000575c:	1101                	addi	sp,sp,-32
    8000575e:	ec06                	sd	ra,24(sp)
    80005760:	e822                	sd	s0,16(sp)
    80005762:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005764:	fe040613          	addi	a2,s0,-32
    80005768:	fec40593          	addi	a1,s0,-20
    8000576c:	4501                	li	a0,0
    8000576e:	00000097          	auipc	ra,0x0
    80005772:	cc0080e7          	jalr	-832(ra) # 8000542e <argfd>
    return -1;
    80005776:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005778:	02054563          	bltz	a0,800057a2 <sys_close+0x46>
  myproc()->ofile[fd] = 0;
    8000577c:	ffffc097          	auipc	ra,0xffffc
    80005780:	292080e7          	jalr	658(ra) # 80001a0e <myproc>
    80005784:	fec42783          	lw	a5,-20(s0)
    80005788:	22478793          	addi	a5,a5,548
    8000578c:	078e                	slli	a5,a5,0x3
    8000578e:	97aa                	add	a5,a5,a0
    80005790:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80005794:	fe043503          	ld	a0,-32(s0)
    80005798:	fffff097          	auipc	ra,0xfffff
    8000579c:	24a080e7          	jalr	586(ra) # 800049e2 <fileclose>
  return 0;
    800057a0:	4781                	li	a5,0
}
    800057a2:	853e                	mv	a0,a5
    800057a4:	60e2                	ld	ra,24(sp)
    800057a6:	6442                	ld	s0,16(sp)
    800057a8:	6105                	addi	sp,sp,32
    800057aa:	8082                	ret

00000000800057ac <sys_fstat>:
{
    800057ac:	1101                	addi	sp,sp,-32
    800057ae:	ec06                	sd	ra,24(sp)
    800057b0:	e822                	sd	s0,16(sp)
    800057b2:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800057b4:	fe840613          	addi	a2,s0,-24
    800057b8:	4581                	li	a1,0
    800057ba:	4501                	li	a0,0
    800057bc:	00000097          	auipc	ra,0x0
    800057c0:	c72080e7          	jalr	-910(ra) # 8000542e <argfd>
    return -1;
    800057c4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800057c6:	02054563          	bltz	a0,800057f0 <sys_fstat+0x44>
    800057ca:	fe040593          	addi	a1,s0,-32
    800057ce:	4505                	li	a0,1
    800057d0:	ffffd097          	auipc	ra,0xffffd
    800057d4:	5cc080e7          	jalr	1484(ra) # 80002d9c <argaddr>
    return -1;
    800057d8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800057da:	00054b63          	bltz	a0,800057f0 <sys_fstat+0x44>
  return filestat(f, st);
    800057de:	fe043583          	ld	a1,-32(s0)
    800057e2:	fe843503          	ld	a0,-24(s0)
    800057e6:	fffff097          	auipc	ra,0xfffff
    800057ea:	2c4080e7          	jalr	708(ra) # 80004aaa <filestat>
    800057ee:	87aa                	mv	a5,a0
}
    800057f0:	853e                	mv	a0,a5
    800057f2:	60e2                	ld	ra,24(sp)
    800057f4:	6442                	ld	s0,16(sp)
    800057f6:	6105                	addi	sp,sp,32
    800057f8:	8082                	ret

00000000800057fa <sys_link>:
{
    800057fa:	7169                	addi	sp,sp,-304
    800057fc:	f606                	sd	ra,296(sp)
    800057fe:	f222                	sd	s0,288(sp)
    80005800:	ee26                	sd	s1,280(sp)
    80005802:	ea4a                	sd	s2,272(sp)
    80005804:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005806:	08000613          	li	a2,128
    8000580a:	ed040593          	addi	a1,s0,-304
    8000580e:	4501                	li	a0,0
    80005810:	ffffd097          	auipc	ra,0xffffd
    80005814:	5ae080e7          	jalr	1454(ra) # 80002dbe <argstr>
    return -1;
    80005818:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000581a:	10054e63          	bltz	a0,80005936 <sys_link+0x13c>
    8000581e:	08000613          	li	a2,128
    80005822:	f5040593          	addi	a1,s0,-176
    80005826:	4505                	li	a0,1
    80005828:	ffffd097          	auipc	ra,0xffffd
    8000582c:	596080e7          	jalr	1430(ra) # 80002dbe <argstr>
    return -1;
    80005830:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005832:	10054263          	bltz	a0,80005936 <sys_link+0x13c>
  begin_op();
    80005836:	fffff097          	auipc	ra,0xfffff
    8000583a:	cd8080e7          	jalr	-808(ra) # 8000450e <begin_op>
  if((ip = namei(old)) == 0){
    8000583e:	ed040513          	addi	a0,s0,-304
    80005842:	fffff097          	auipc	ra,0xfffff
    80005846:	ab0080e7          	jalr	-1360(ra) # 800042f2 <namei>
    8000584a:	84aa                	mv	s1,a0
    8000584c:	c551                	beqz	a0,800058d8 <sys_link+0xde>
  ilock(ip);
    8000584e:	ffffe097          	auipc	ra,0xffffe
    80005852:	2ec080e7          	jalr	748(ra) # 80003b3a <ilock>
  if(ip->type == T_DIR){
    80005856:	04449703          	lh	a4,68(s1)
    8000585a:	4785                	li	a5,1
    8000585c:	08f70463          	beq	a4,a5,800058e4 <sys_link+0xea>
  ip->nlink++;
    80005860:	04a4d783          	lhu	a5,74(s1)
    80005864:	2785                	addiw	a5,a5,1
    80005866:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000586a:	8526                	mv	a0,s1
    8000586c:	ffffe097          	auipc	ra,0xffffe
    80005870:	204080e7          	jalr	516(ra) # 80003a70 <iupdate>
  iunlock(ip);
    80005874:	8526                	mv	a0,s1
    80005876:	ffffe097          	auipc	ra,0xffffe
    8000587a:	386080e7          	jalr	902(ra) # 80003bfc <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000587e:	fd040593          	addi	a1,s0,-48
    80005882:	f5040513          	addi	a0,s0,-176
    80005886:	fffff097          	auipc	ra,0xfffff
    8000588a:	a8a080e7          	jalr	-1398(ra) # 80004310 <nameiparent>
    8000588e:	892a                	mv	s2,a0
    80005890:	c935                	beqz	a0,80005904 <sys_link+0x10a>
  ilock(dp);
    80005892:	ffffe097          	auipc	ra,0xffffe
    80005896:	2a8080e7          	jalr	680(ra) # 80003b3a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000589a:	00092703          	lw	a4,0(s2)
    8000589e:	409c                	lw	a5,0(s1)
    800058a0:	04f71d63          	bne	a4,a5,800058fa <sys_link+0x100>
    800058a4:	40d0                	lw	a2,4(s1)
    800058a6:	fd040593          	addi	a1,s0,-48
    800058aa:	854a                	mv	a0,s2
    800058ac:	fffff097          	auipc	ra,0xfffff
    800058b0:	984080e7          	jalr	-1660(ra) # 80004230 <dirlink>
    800058b4:	04054363          	bltz	a0,800058fa <sys_link+0x100>
  iunlockput(dp);
    800058b8:	854a                	mv	a0,s2
    800058ba:	ffffe097          	auipc	ra,0xffffe
    800058be:	4e2080e7          	jalr	1250(ra) # 80003d9c <iunlockput>
  iput(ip);
    800058c2:	8526                	mv	a0,s1
    800058c4:	ffffe097          	auipc	ra,0xffffe
    800058c8:	430080e7          	jalr	1072(ra) # 80003cf4 <iput>
  end_op();
    800058cc:	fffff097          	auipc	ra,0xfffff
    800058d0:	cc2080e7          	jalr	-830(ra) # 8000458e <end_op>
  return 0;
    800058d4:	4781                	li	a5,0
    800058d6:	a085                	j	80005936 <sys_link+0x13c>
    end_op();
    800058d8:	fffff097          	auipc	ra,0xfffff
    800058dc:	cb6080e7          	jalr	-842(ra) # 8000458e <end_op>
    return -1;
    800058e0:	57fd                	li	a5,-1
    800058e2:	a891                	j	80005936 <sys_link+0x13c>
    iunlockput(ip);
    800058e4:	8526                	mv	a0,s1
    800058e6:	ffffe097          	auipc	ra,0xffffe
    800058ea:	4b6080e7          	jalr	1206(ra) # 80003d9c <iunlockput>
    end_op();
    800058ee:	fffff097          	auipc	ra,0xfffff
    800058f2:	ca0080e7          	jalr	-864(ra) # 8000458e <end_op>
    return -1;
    800058f6:	57fd                	li	a5,-1
    800058f8:	a83d                	j	80005936 <sys_link+0x13c>
    iunlockput(dp);
    800058fa:	854a                	mv	a0,s2
    800058fc:	ffffe097          	auipc	ra,0xffffe
    80005900:	4a0080e7          	jalr	1184(ra) # 80003d9c <iunlockput>
  ilock(ip);
    80005904:	8526                	mv	a0,s1
    80005906:	ffffe097          	auipc	ra,0xffffe
    8000590a:	234080e7          	jalr	564(ra) # 80003b3a <ilock>
  ip->nlink--;
    8000590e:	04a4d783          	lhu	a5,74(s1)
    80005912:	37fd                	addiw	a5,a5,-1
    80005914:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005918:	8526                	mv	a0,s1
    8000591a:	ffffe097          	auipc	ra,0xffffe
    8000591e:	156080e7          	jalr	342(ra) # 80003a70 <iupdate>
  iunlockput(ip);
    80005922:	8526                	mv	a0,s1
    80005924:	ffffe097          	auipc	ra,0xffffe
    80005928:	478080e7          	jalr	1144(ra) # 80003d9c <iunlockput>
  end_op();
    8000592c:	fffff097          	auipc	ra,0xfffff
    80005930:	c62080e7          	jalr	-926(ra) # 8000458e <end_op>
  return -1;
    80005934:	57fd                	li	a5,-1
}
    80005936:	853e                	mv	a0,a5
    80005938:	70b2                	ld	ra,296(sp)
    8000593a:	7412                	ld	s0,288(sp)
    8000593c:	64f2                	ld	s1,280(sp)
    8000593e:	6952                	ld	s2,272(sp)
    80005940:	6155                	addi	sp,sp,304
    80005942:	8082                	ret

0000000080005944 <sys_unlink>:
{
    80005944:	7151                	addi	sp,sp,-240
    80005946:	f586                	sd	ra,232(sp)
    80005948:	f1a2                	sd	s0,224(sp)
    8000594a:	eda6                	sd	s1,216(sp)
    8000594c:	e9ca                	sd	s2,208(sp)
    8000594e:	e5ce                	sd	s3,200(sp)
    80005950:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005952:	08000613          	li	a2,128
    80005956:	f3040593          	addi	a1,s0,-208
    8000595a:	4501                	li	a0,0
    8000595c:	ffffd097          	auipc	ra,0xffffd
    80005960:	462080e7          	jalr	1122(ra) # 80002dbe <argstr>
    80005964:	18054163          	bltz	a0,80005ae6 <sys_unlink+0x1a2>
  begin_op();
    80005968:	fffff097          	auipc	ra,0xfffff
    8000596c:	ba6080e7          	jalr	-1114(ra) # 8000450e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005970:	fb040593          	addi	a1,s0,-80
    80005974:	f3040513          	addi	a0,s0,-208
    80005978:	fffff097          	auipc	ra,0xfffff
    8000597c:	998080e7          	jalr	-1640(ra) # 80004310 <nameiparent>
    80005980:	84aa                	mv	s1,a0
    80005982:	c979                	beqz	a0,80005a58 <sys_unlink+0x114>
  ilock(dp);
    80005984:	ffffe097          	auipc	ra,0xffffe
    80005988:	1b6080e7          	jalr	438(ra) # 80003b3a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000598c:	00003597          	auipc	a1,0x3
    80005990:	d6c58593          	addi	a1,a1,-660 # 800086f8 <syscalls+0x2d8>
    80005994:	fb040513          	addi	a0,s0,-80
    80005998:	ffffe097          	auipc	ra,0xffffe
    8000599c:	66a080e7          	jalr	1642(ra) # 80004002 <namecmp>
    800059a0:	14050a63          	beqz	a0,80005af4 <sys_unlink+0x1b0>
    800059a4:	00003597          	auipc	a1,0x3
    800059a8:	d5c58593          	addi	a1,a1,-676 # 80008700 <syscalls+0x2e0>
    800059ac:	fb040513          	addi	a0,s0,-80
    800059b0:	ffffe097          	auipc	ra,0xffffe
    800059b4:	652080e7          	jalr	1618(ra) # 80004002 <namecmp>
    800059b8:	12050e63          	beqz	a0,80005af4 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800059bc:	f2c40613          	addi	a2,s0,-212
    800059c0:	fb040593          	addi	a1,s0,-80
    800059c4:	8526                	mv	a0,s1
    800059c6:	ffffe097          	auipc	ra,0xffffe
    800059ca:	656080e7          	jalr	1622(ra) # 8000401c <dirlookup>
    800059ce:	892a                	mv	s2,a0
    800059d0:	12050263          	beqz	a0,80005af4 <sys_unlink+0x1b0>
  ilock(ip);
    800059d4:	ffffe097          	auipc	ra,0xffffe
    800059d8:	166080e7          	jalr	358(ra) # 80003b3a <ilock>
  if(ip->nlink < 1)
    800059dc:	04a91783          	lh	a5,74(s2)
    800059e0:	08f05263          	blez	a5,80005a64 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800059e4:	04491703          	lh	a4,68(s2)
    800059e8:	4785                	li	a5,1
    800059ea:	08f70563          	beq	a4,a5,80005a74 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800059ee:	4641                	li	a2,16
    800059f0:	4581                	li	a1,0
    800059f2:	fc040513          	addi	a0,s0,-64
    800059f6:	ffffb097          	auipc	ra,0xffffb
    800059fa:	30c080e7          	jalr	780(ra) # 80000d02 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800059fe:	4741                	li	a4,16
    80005a00:	f2c42683          	lw	a3,-212(s0)
    80005a04:	fc040613          	addi	a2,s0,-64
    80005a08:	4581                	li	a1,0
    80005a0a:	8526                	mv	a0,s1
    80005a0c:	ffffe097          	auipc	ra,0xffffe
    80005a10:	4da080e7          	jalr	1242(ra) # 80003ee6 <writei>
    80005a14:	47c1                	li	a5,16
    80005a16:	0af51563          	bne	a0,a5,80005ac0 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005a1a:	04491703          	lh	a4,68(s2)
    80005a1e:	4785                	li	a5,1
    80005a20:	0af70863          	beq	a4,a5,80005ad0 <sys_unlink+0x18c>
  iunlockput(dp);
    80005a24:	8526                	mv	a0,s1
    80005a26:	ffffe097          	auipc	ra,0xffffe
    80005a2a:	376080e7          	jalr	886(ra) # 80003d9c <iunlockput>
  ip->nlink--;
    80005a2e:	04a95783          	lhu	a5,74(s2)
    80005a32:	37fd                	addiw	a5,a5,-1
    80005a34:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005a38:	854a                	mv	a0,s2
    80005a3a:	ffffe097          	auipc	ra,0xffffe
    80005a3e:	036080e7          	jalr	54(ra) # 80003a70 <iupdate>
  iunlockput(ip);
    80005a42:	854a                	mv	a0,s2
    80005a44:	ffffe097          	auipc	ra,0xffffe
    80005a48:	358080e7          	jalr	856(ra) # 80003d9c <iunlockput>
  end_op();
    80005a4c:	fffff097          	auipc	ra,0xfffff
    80005a50:	b42080e7          	jalr	-1214(ra) # 8000458e <end_op>
  return 0;
    80005a54:	4501                	li	a0,0
    80005a56:	a84d                	j	80005b08 <sys_unlink+0x1c4>
    end_op();
    80005a58:	fffff097          	auipc	ra,0xfffff
    80005a5c:	b36080e7          	jalr	-1226(ra) # 8000458e <end_op>
    return -1;
    80005a60:	557d                	li	a0,-1
    80005a62:	a05d                	j	80005b08 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005a64:	00003517          	auipc	a0,0x3
    80005a68:	cc450513          	addi	a0,a0,-828 # 80008728 <syscalls+0x308>
    80005a6c:	ffffb097          	auipc	ra,0xffffb
    80005a70:	ade080e7          	jalr	-1314(ra) # 8000054a <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005a74:	04c92703          	lw	a4,76(s2)
    80005a78:	02000793          	li	a5,32
    80005a7c:	f6e7f9e3          	bgeu	a5,a4,800059ee <sys_unlink+0xaa>
    80005a80:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005a84:	4741                	li	a4,16
    80005a86:	86ce                	mv	a3,s3
    80005a88:	f1840613          	addi	a2,s0,-232
    80005a8c:	4581                	li	a1,0
    80005a8e:	854a                	mv	a0,s2
    80005a90:	ffffe097          	auipc	ra,0xffffe
    80005a94:	35e080e7          	jalr	862(ra) # 80003dee <readi>
    80005a98:	47c1                	li	a5,16
    80005a9a:	00f51b63          	bne	a0,a5,80005ab0 <sys_unlink+0x16c>
    if(de.inum != 0)
    80005a9e:	f1845783          	lhu	a5,-232(s0)
    80005aa2:	e7a1                	bnez	a5,80005aea <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005aa4:	29c1                	addiw	s3,s3,16
    80005aa6:	04c92783          	lw	a5,76(s2)
    80005aaa:	fcf9ede3          	bltu	s3,a5,80005a84 <sys_unlink+0x140>
    80005aae:	b781                	j	800059ee <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005ab0:	00003517          	auipc	a0,0x3
    80005ab4:	c9050513          	addi	a0,a0,-880 # 80008740 <syscalls+0x320>
    80005ab8:	ffffb097          	auipc	ra,0xffffb
    80005abc:	a92080e7          	jalr	-1390(ra) # 8000054a <panic>
    panic("unlink: writei");
    80005ac0:	00003517          	auipc	a0,0x3
    80005ac4:	c9850513          	addi	a0,a0,-872 # 80008758 <syscalls+0x338>
    80005ac8:	ffffb097          	auipc	ra,0xffffb
    80005acc:	a82080e7          	jalr	-1406(ra) # 8000054a <panic>
    dp->nlink--;
    80005ad0:	04a4d783          	lhu	a5,74(s1)
    80005ad4:	37fd                	addiw	a5,a5,-1
    80005ad6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005ada:	8526                	mv	a0,s1
    80005adc:	ffffe097          	auipc	ra,0xffffe
    80005ae0:	f94080e7          	jalr	-108(ra) # 80003a70 <iupdate>
    80005ae4:	b781                	j	80005a24 <sys_unlink+0xe0>
    return -1;
    80005ae6:	557d                	li	a0,-1
    80005ae8:	a005                	j	80005b08 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005aea:	854a                	mv	a0,s2
    80005aec:	ffffe097          	auipc	ra,0xffffe
    80005af0:	2b0080e7          	jalr	688(ra) # 80003d9c <iunlockput>
  iunlockput(dp);
    80005af4:	8526                	mv	a0,s1
    80005af6:	ffffe097          	auipc	ra,0xffffe
    80005afa:	2a6080e7          	jalr	678(ra) # 80003d9c <iunlockput>
  end_op();
    80005afe:	fffff097          	auipc	ra,0xfffff
    80005b02:	a90080e7          	jalr	-1392(ra) # 8000458e <end_op>
  return -1;
    80005b06:	557d                	li	a0,-1
}
    80005b08:	70ae                	ld	ra,232(sp)
    80005b0a:	740e                	ld	s0,224(sp)
    80005b0c:	64ee                	ld	s1,216(sp)
    80005b0e:	694e                	ld	s2,208(sp)
    80005b10:	69ae                	ld	s3,200(sp)
    80005b12:	616d                	addi	sp,sp,240
    80005b14:	8082                	ret

0000000080005b16 <sys_open>:

uint64
sys_open(void)
{
    80005b16:	7131                	addi	sp,sp,-192
    80005b18:	fd06                	sd	ra,184(sp)
    80005b1a:	f922                	sd	s0,176(sp)
    80005b1c:	f526                	sd	s1,168(sp)
    80005b1e:	f14a                	sd	s2,160(sp)
    80005b20:	ed4e                	sd	s3,152(sp)
    80005b22:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005b24:	08000613          	li	a2,128
    80005b28:	f5040593          	addi	a1,s0,-176
    80005b2c:	4501                	li	a0,0
    80005b2e:	ffffd097          	auipc	ra,0xffffd
    80005b32:	290080e7          	jalr	656(ra) # 80002dbe <argstr>
    return -1;
    80005b36:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005b38:	0c054163          	bltz	a0,80005bfa <sys_open+0xe4>
    80005b3c:	f4c40593          	addi	a1,s0,-180
    80005b40:	4505                	li	a0,1
    80005b42:	ffffd097          	auipc	ra,0xffffd
    80005b46:	238080e7          	jalr	568(ra) # 80002d7a <argint>
    80005b4a:	0a054863          	bltz	a0,80005bfa <sys_open+0xe4>

  begin_op();
    80005b4e:	fffff097          	auipc	ra,0xfffff
    80005b52:	9c0080e7          	jalr	-1600(ra) # 8000450e <begin_op>

  if(omode & O_CREATE){
    80005b56:	f4c42783          	lw	a5,-180(s0)
    80005b5a:	2007f793          	andi	a5,a5,512
    80005b5e:	cbdd                	beqz	a5,80005c14 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005b60:	4681                	li	a3,0
    80005b62:	4601                	li	a2,0
    80005b64:	4589                	li	a1,2
    80005b66:	f5040513          	addi	a0,s0,-176
    80005b6a:	00000097          	auipc	ra,0x0
    80005b6e:	972080e7          	jalr	-1678(ra) # 800054dc <create>
    80005b72:	892a                	mv	s2,a0
    if(ip == 0){
    80005b74:	c959                	beqz	a0,80005c0a <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005b76:	04491703          	lh	a4,68(s2)
    80005b7a:	478d                	li	a5,3
    80005b7c:	00f71763          	bne	a4,a5,80005b8a <sys_open+0x74>
    80005b80:	04695703          	lhu	a4,70(s2)
    80005b84:	47a5                	li	a5,9
    80005b86:	0ce7ec63          	bltu	a5,a4,80005c5e <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005b8a:	fffff097          	auipc	ra,0xfffff
    80005b8e:	d9c080e7          	jalr	-612(ra) # 80004926 <filealloc>
    80005b92:	89aa                	mv	s3,a0
    80005b94:	10050263          	beqz	a0,80005c98 <sys_open+0x182>
    80005b98:	00000097          	auipc	ra,0x0
    80005b9c:	8fe080e7          	jalr	-1794(ra) # 80005496 <fdalloc>
    80005ba0:	84aa                	mv	s1,a0
    80005ba2:	0e054663          	bltz	a0,80005c8e <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005ba6:	04491703          	lh	a4,68(s2)
    80005baa:	478d                	li	a5,3
    80005bac:	0cf70463          	beq	a4,a5,80005c74 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005bb0:	4789                	li	a5,2
    80005bb2:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005bb6:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005bba:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005bbe:	f4c42783          	lw	a5,-180(s0)
    80005bc2:	0017c713          	xori	a4,a5,1
    80005bc6:	8b05                	andi	a4,a4,1
    80005bc8:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005bcc:	0037f713          	andi	a4,a5,3
    80005bd0:	00e03733          	snez	a4,a4
    80005bd4:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005bd8:	4007f793          	andi	a5,a5,1024
    80005bdc:	c791                	beqz	a5,80005be8 <sys_open+0xd2>
    80005bde:	04491703          	lh	a4,68(s2)
    80005be2:	4789                	li	a5,2
    80005be4:	08f70f63          	beq	a4,a5,80005c82 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005be8:	854a                	mv	a0,s2
    80005bea:	ffffe097          	auipc	ra,0xffffe
    80005bee:	012080e7          	jalr	18(ra) # 80003bfc <iunlock>
  end_op();
    80005bf2:	fffff097          	auipc	ra,0xfffff
    80005bf6:	99c080e7          	jalr	-1636(ra) # 8000458e <end_op>

  return fd;
}
    80005bfa:	8526                	mv	a0,s1
    80005bfc:	70ea                	ld	ra,184(sp)
    80005bfe:	744a                	ld	s0,176(sp)
    80005c00:	74aa                	ld	s1,168(sp)
    80005c02:	790a                	ld	s2,160(sp)
    80005c04:	69ea                	ld	s3,152(sp)
    80005c06:	6129                	addi	sp,sp,192
    80005c08:	8082                	ret
      end_op();
    80005c0a:	fffff097          	auipc	ra,0xfffff
    80005c0e:	984080e7          	jalr	-1660(ra) # 8000458e <end_op>
      return -1;
    80005c12:	b7e5                	j	80005bfa <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005c14:	f5040513          	addi	a0,s0,-176
    80005c18:	ffffe097          	auipc	ra,0xffffe
    80005c1c:	6da080e7          	jalr	1754(ra) # 800042f2 <namei>
    80005c20:	892a                	mv	s2,a0
    80005c22:	c905                	beqz	a0,80005c52 <sys_open+0x13c>
    ilock(ip);
    80005c24:	ffffe097          	auipc	ra,0xffffe
    80005c28:	f16080e7          	jalr	-234(ra) # 80003b3a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005c2c:	04491703          	lh	a4,68(s2)
    80005c30:	4785                	li	a5,1
    80005c32:	f4f712e3          	bne	a4,a5,80005b76 <sys_open+0x60>
    80005c36:	f4c42783          	lw	a5,-180(s0)
    80005c3a:	dba1                	beqz	a5,80005b8a <sys_open+0x74>
      iunlockput(ip);
    80005c3c:	854a                	mv	a0,s2
    80005c3e:	ffffe097          	auipc	ra,0xffffe
    80005c42:	15e080e7          	jalr	350(ra) # 80003d9c <iunlockput>
      end_op();
    80005c46:	fffff097          	auipc	ra,0xfffff
    80005c4a:	948080e7          	jalr	-1720(ra) # 8000458e <end_op>
      return -1;
    80005c4e:	54fd                	li	s1,-1
    80005c50:	b76d                	j	80005bfa <sys_open+0xe4>
      end_op();
    80005c52:	fffff097          	auipc	ra,0xfffff
    80005c56:	93c080e7          	jalr	-1732(ra) # 8000458e <end_op>
      return -1;
    80005c5a:	54fd                	li	s1,-1
    80005c5c:	bf79                	j	80005bfa <sys_open+0xe4>
    iunlockput(ip);
    80005c5e:	854a                	mv	a0,s2
    80005c60:	ffffe097          	auipc	ra,0xffffe
    80005c64:	13c080e7          	jalr	316(ra) # 80003d9c <iunlockput>
    end_op();
    80005c68:	fffff097          	auipc	ra,0xfffff
    80005c6c:	926080e7          	jalr	-1754(ra) # 8000458e <end_op>
    return -1;
    80005c70:	54fd                	li	s1,-1
    80005c72:	b761                	j	80005bfa <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005c74:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005c78:	04691783          	lh	a5,70(s2)
    80005c7c:	02f99223          	sh	a5,36(s3)
    80005c80:	bf2d                	j	80005bba <sys_open+0xa4>
    itrunc(ip);
    80005c82:	854a                	mv	a0,s2
    80005c84:	ffffe097          	auipc	ra,0xffffe
    80005c88:	fc4080e7          	jalr	-60(ra) # 80003c48 <itrunc>
    80005c8c:	bfb1                	j	80005be8 <sys_open+0xd2>
      fileclose(f);
    80005c8e:	854e                	mv	a0,s3
    80005c90:	fffff097          	auipc	ra,0xfffff
    80005c94:	d52080e7          	jalr	-686(ra) # 800049e2 <fileclose>
    iunlockput(ip);
    80005c98:	854a                	mv	a0,s2
    80005c9a:	ffffe097          	auipc	ra,0xffffe
    80005c9e:	102080e7          	jalr	258(ra) # 80003d9c <iunlockput>
    end_op();
    80005ca2:	fffff097          	auipc	ra,0xfffff
    80005ca6:	8ec080e7          	jalr	-1812(ra) # 8000458e <end_op>
    return -1;
    80005caa:	54fd                	li	s1,-1
    80005cac:	b7b9                	j	80005bfa <sys_open+0xe4>

0000000080005cae <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005cae:	7175                	addi	sp,sp,-144
    80005cb0:	e506                	sd	ra,136(sp)
    80005cb2:	e122                	sd	s0,128(sp)
    80005cb4:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005cb6:	fffff097          	auipc	ra,0xfffff
    80005cba:	858080e7          	jalr	-1960(ra) # 8000450e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005cbe:	08000613          	li	a2,128
    80005cc2:	f7040593          	addi	a1,s0,-144
    80005cc6:	4501                	li	a0,0
    80005cc8:	ffffd097          	auipc	ra,0xffffd
    80005ccc:	0f6080e7          	jalr	246(ra) # 80002dbe <argstr>
    80005cd0:	02054963          	bltz	a0,80005d02 <sys_mkdir+0x54>
    80005cd4:	4681                	li	a3,0
    80005cd6:	4601                	li	a2,0
    80005cd8:	4585                	li	a1,1
    80005cda:	f7040513          	addi	a0,s0,-144
    80005cde:	fffff097          	auipc	ra,0xfffff
    80005ce2:	7fe080e7          	jalr	2046(ra) # 800054dc <create>
    80005ce6:	cd11                	beqz	a0,80005d02 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005ce8:	ffffe097          	auipc	ra,0xffffe
    80005cec:	0b4080e7          	jalr	180(ra) # 80003d9c <iunlockput>
  end_op();
    80005cf0:	fffff097          	auipc	ra,0xfffff
    80005cf4:	89e080e7          	jalr	-1890(ra) # 8000458e <end_op>
  return 0;
    80005cf8:	4501                	li	a0,0
}
    80005cfa:	60aa                	ld	ra,136(sp)
    80005cfc:	640a                	ld	s0,128(sp)
    80005cfe:	6149                	addi	sp,sp,144
    80005d00:	8082                	ret
    end_op();
    80005d02:	fffff097          	auipc	ra,0xfffff
    80005d06:	88c080e7          	jalr	-1908(ra) # 8000458e <end_op>
    return -1;
    80005d0a:	557d                	li	a0,-1
    80005d0c:	b7fd                	j	80005cfa <sys_mkdir+0x4c>

0000000080005d0e <sys_mknod>:

uint64
sys_mknod(void)
{
    80005d0e:	7135                	addi	sp,sp,-160
    80005d10:	ed06                	sd	ra,152(sp)
    80005d12:	e922                	sd	s0,144(sp)
    80005d14:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005d16:	ffffe097          	auipc	ra,0xffffe
    80005d1a:	7f8080e7          	jalr	2040(ra) # 8000450e <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005d1e:	08000613          	li	a2,128
    80005d22:	f7040593          	addi	a1,s0,-144
    80005d26:	4501                	li	a0,0
    80005d28:	ffffd097          	auipc	ra,0xffffd
    80005d2c:	096080e7          	jalr	150(ra) # 80002dbe <argstr>
    80005d30:	04054a63          	bltz	a0,80005d84 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005d34:	f6c40593          	addi	a1,s0,-148
    80005d38:	4505                	li	a0,1
    80005d3a:	ffffd097          	auipc	ra,0xffffd
    80005d3e:	040080e7          	jalr	64(ra) # 80002d7a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005d42:	04054163          	bltz	a0,80005d84 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005d46:	f6840593          	addi	a1,s0,-152
    80005d4a:	4509                	li	a0,2
    80005d4c:	ffffd097          	auipc	ra,0xffffd
    80005d50:	02e080e7          	jalr	46(ra) # 80002d7a <argint>
     argint(1, &major) < 0 ||
    80005d54:	02054863          	bltz	a0,80005d84 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005d58:	f6841683          	lh	a3,-152(s0)
    80005d5c:	f6c41603          	lh	a2,-148(s0)
    80005d60:	458d                	li	a1,3
    80005d62:	f7040513          	addi	a0,s0,-144
    80005d66:	fffff097          	auipc	ra,0xfffff
    80005d6a:	776080e7          	jalr	1910(ra) # 800054dc <create>
     argint(2, &minor) < 0 ||
    80005d6e:	c919                	beqz	a0,80005d84 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005d70:	ffffe097          	auipc	ra,0xffffe
    80005d74:	02c080e7          	jalr	44(ra) # 80003d9c <iunlockput>
  end_op();
    80005d78:	fffff097          	auipc	ra,0xfffff
    80005d7c:	816080e7          	jalr	-2026(ra) # 8000458e <end_op>
  return 0;
    80005d80:	4501                	li	a0,0
    80005d82:	a031                	j	80005d8e <sys_mknod+0x80>
    end_op();
    80005d84:	fffff097          	auipc	ra,0xfffff
    80005d88:	80a080e7          	jalr	-2038(ra) # 8000458e <end_op>
    return -1;
    80005d8c:	557d                	li	a0,-1
}
    80005d8e:	60ea                	ld	ra,152(sp)
    80005d90:	644a                	ld	s0,144(sp)
    80005d92:	610d                	addi	sp,sp,160
    80005d94:	8082                	ret

0000000080005d96 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005d96:	7135                	addi	sp,sp,-160
    80005d98:	ed06                	sd	ra,152(sp)
    80005d9a:	e922                	sd	s0,144(sp)
    80005d9c:	e526                	sd	s1,136(sp)
    80005d9e:	e14a                	sd	s2,128(sp)
    80005da0:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005da2:	ffffc097          	auipc	ra,0xffffc
    80005da6:	c6c080e7          	jalr	-916(ra) # 80001a0e <myproc>
    80005daa:	892a                	mv	s2,a0
  
  begin_op();
    80005dac:	ffffe097          	auipc	ra,0xffffe
    80005db0:	762080e7          	jalr	1890(ra) # 8000450e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005db4:	08000613          	li	a2,128
    80005db8:	f6040593          	addi	a1,s0,-160
    80005dbc:	4501                	li	a0,0
    80005dbe:	ffffd097          	auipc	ra,0xffffd
    80005dc2:	000080e7          	jalr	ra # 80002dbe <argstr>
    80005dc6:	04054d63          	bltz	a0,80005e20 <sys_chdir+0x8a>
    80005dca:	f6040513          	addi	a0,s0,-160
    80005dce:	ffffe097          	auipc	ra,0xffffe
    80005dd2:	524080e7          	jalr	1316(ra) # 800042f2 <namei>
    80005dd6:	84aa                	mv	s1,a0
    80005dd8:	c521                	beqz	a0,80005e20 <sys_chdir+0x8a>
    end_op();
    return -1;
  }
  ilock(ip);
    80005dda:	ffffe097          	auipc	ra,0xffffe
    80005dde:	d60080e7          	jalr	-672(ra) # 80003b3a <ilock>
  if(ip->type != T_DIR){
    80005de2:	04449703          	lh	a4,68(s1)
    80005de6:	4785                	li	a5,1
    80005de8:	04f71263          	bne	a4,a5,80005e2c <sys_chdir+0x96>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005dec:	8526                	mv	a0,s1
    80005dee:	ffffe097          	auipc	ra,0xffffe
    80005df2:	e0e080e7          	jalr	-498(ra) # 80003bfc <iunlock>
  iput(p->cwd);
    80005df6:	6505                	lui	a0,0x1
    80005df8:	992a                	add	s2,s2,a0
    80005dfa:	1a093503          	ld	a0,416(s2)
    80005dfe:	ffffe097          	auipc	ra,0xffffe
    80005e02:	ef6080e7          	jalr	-266(ra) # 80003cf4 <iput>
  end_op();
    80005e06:	ffffe097          	auipc	ra,0xffffe
    80005e0a:	788080e7          	jalr	1928(ra) # 8000458e <end_op>
  p->cwd = ip;
    80005e0e:	1a993023          	sd	s1,416(s2)
  return 0;
    80005e12:	4501                	li	a0,0
}
    80005e14:	60ea                	ld	ra,152(sp)
    80005e16:	644a                	ld	s0,144(sp)
    80005e18:	64aa                	ld	s1,136(sp)
    80005e1a:	690a                	ld	s2,128(sp)
    80005e1c:	610d                	addi	sp,sp,160
    80005e1e:	8082                	ret
    end_op();
    80005e20:	ffffe097          	auipc	ra,0xffffe
    80005e24:	76e080e7          	jalr	1902(ra) # 8000458e <end_op>
    return -1;
    80005e28:	557d                	li	a0,-1
    80005e2a:	b7ed                	j	80005e14 <sys_chdir+0x7e>
    iunlockput(ip);
    80005e2c:	8526                	mv	a0,s1
    80005e2e:	ffffe097          	auipc	ra,0xffffe
    80005e32:	f6e080e7          	jalr	-146(ra) # 80003d9c <iunlockput>
    end_op();
    80005e36:	ffffe097          	auipc	ra,0xffffe
    80005e3a:	758080e7          	jalr	1880(ra) # 8000458e <end_op>
    return -1;
    80005e3e:	557d                	li	a0,-1
    80005e40:	bfd1                	j	80005e14 <sys_chdir+0x7e>

0000000080005e42 <sys_exec>:

uint64
sys_exec(void)
{
    80005e42:	7145                	addi	sp,sp,-464
    80005e44:	e786                	sd	ra,456(sp)
    80005e46:	e3a2                	sd	s0,448(sp)
    80005e48:	ff26                	sd	s1,440(sp)
    80005e4a:	fb4a                	sd	s2,432(sp)
    80005e4c:	f74e                	sd	s3,424(sp)
    80005e4e:	f352                	sd	s4,416(sp)
    80005e50:	ef56                	sd	s5,408(sp)
    80005e52:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005e54:	08000613          	li	a2,128
    80005e58:	f4040593          	addi	a1,s0,-192
    80005e5c:	4501                	li	a0,0
    80005e5e:	ffffd097          	auipc	ra,0xffffd
    80005e62:	f60080e7          	jalr	-160(ra) # 80002dbe <argstr>
    return -1;
    80005e66:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005e68:	0c054a63          	bltz	a0,80005f3c <sys_exec+0xfa>
    80005e6c:	e3840593          	addi	a1,s0,-456
    80005e70:	4505                	li	a0,1
    80005e72:	ffffd097          	auipc	ra,0xffffd
    80005e76:	f2a080e7          	jalr	-214(ra) # 80002d9c <argaddr>
    80005e7a:	0c054163          	bltz	a0,80005f3c <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005e7e:	10000613          	li	a2,256
    80005e82:	4581                	li	a1,0
    80005e84:	e4040513          	addi	a0,s0,-448
    80005e88:	ffffb097          	auipc	ra,0xffffb
    80005e8c:	e7a080e7          	jalr	-390(ra) # 80000d02 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005e90:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005e94:	89a6                	mv	s3,s1
    80005e96:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005e98:	02000a13          	li	s4,32
    80005e9c:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005ea0:	00391793          	slli	a5,s2,0x3
    80005ea4:	e3040593          	addi	a1,s0,-464
    80005ea8:	e3843503          	ld	a0,-456(s0)
    80005eac:	953e                	add	a0,a0,a5
    80005eae:	ffffd097          	auipc	ra,0xffffd
    80005eb2:	e26080e7          	jalr	-474(ra) # 80002cd4 <fetchaddr>
    80005eb6:	02054a63          	bltz	a0,80005eea <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005eba:	e3043783          	ld	a5,-464(s0)
    80005ebe:	c3b9                	beqz	a5,80005f04 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005ec0:	ffffb097          	auipc	ra,0xffffb
    80005ec4:	c56080e7          	jalr	-938(ra) # 80000b16 <kalloc>
    80005ec8:	85aa                	mv	a1,a0
    80005eca:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005ece:	cd11                	beqz	a0,80005eea <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005ed0:	6605                	lui	a2,0x1
    80005ed2:	e3043503          	ld	a0,-464(s0)
    80005ed6:	ffffd097          	auipc	ra,0xffffd
    80005eda:	e58080e7          	jalr	-424(ra) # 80002d2e <fetchstr>
    80005ede:	00054663          	bltz	a0,80005eea <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005ee2:	0905                	addi	s2,s2,1
    80005ee4:	09a1                	addi	s3,s3,8
    80005ee6:	fb491be3          	bne	s2,s4,80005e9c <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005eea:	10048913          	addi	s2,s1,256
    80005eee:	6088                	ld	a0,0(s1)
    80005ef0:	c529                	beqz	a0,80005f3a <sys_exec+0xf8>
    kfree(argv[i]);
    80005ef2:	ffffb097          	auipc	ra,0xffffb
    80005ef6:	b28080e7          	jalr	-1240(ra) # 80000a1a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005efa:	04a1                	addi	s1,s1,8
    80005efc:	ff2499e3          	bne	s1,s2,80005eee <sys_exec+0xac>
  return -1;
    80005f00:	597d                	li	s2,-1
    80005f02:	a82d                	j	80005f3c <sys_exec+0xfa>
      argv[i] = 0;
    80005f04:	0a8e                	slli	s5,s5,0x3
    80005f06:	fc040793          	addi	a5,s0,-64
    80005f0a:	9abe                	add	s5,s5,a5
    80005f0c:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ff97e80>
  int ret = exec(path, argv);
    80005f10:	e4040593          	addi	a1,s0,-448
    80005f14:	f4040513          	addi	a0,s0,-192
    80005f18:	fffff097          	auipc	ra,0xfffff
    80005f1c:	162080e7          	jalr	354(ra) # 8000507a <exec>
    80005f20:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005f22:	10048993          	addi	s3,s1,256
    80005f26:	6088                	ld	a0,0(s1)
    80005f28:	c911                	beqz	a0,80005f3c <sys_exec+0xfa>
    kfree(argv[i]);
    80005f2a:	ffffb097          	auipc	ra,0xffffb
    80005f2e:	af0080e7          	jalr	-1296(ra) # 80000a1a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005f32:	04a1                	addi	s1,s1,8
    80005f34:	ff3499e3          	bne	s1,s3,80005f26 <sys_exec+0xe4>
    80005f38:	a011                	j	80005f3c <sys_exec+0xfa>
  return -1;
    80005f3a:	597d                	li	s2,-1
}
    80005f3c:	854a                	mv	a0,s2
    80005f3e:	60be                	ld	ra,456(sp)
    80005f40:	641e                	ld	s0,448(sp)
    80005f42:	74fa                	ld	s1,440(sp)
    80005f44:	795a                	ld	s2,432(sp)
    80005f46:	79ba                	ld	s3,424(sp)
    80005f48:	7a1a                	ld	s4,416(sp)
    80005f4a:	6afa                	ld	s5,408(sp)
    80005f4c:	6179                	addi	sp,sp,464
    80005f4e:	8082                	ret

0000000080005f50 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005f50:	7139                	addi	sp,sp,-64
    80005f52:	fc06                	sd	ra,56(sp)
    80005f54:	f822                	sd	s0,48(sp)
    80005f56:	f426                	sd	s1,40(sp)
    80005f58:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005f5a:	ffffc097          	auipc	ra,0xffffc
    80005f5e:	ab4080e7          	jalr	-1356(ra) # 80001a0e <myproc>
    80005f62:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005f64:	fd840593          	addi	a1,s0,-40
    80005f68:	4501                	li	a0,0
    80005f6a:	ffffd097          	auipc	ra,0xffffd
    80005f6e:	e32080e7          	jalr	-462(ra) # 80002d9c <argaddr>
    return -1;
    80005f72:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005f74:	0e054663          	bltz	a0,80006060 <sys_pipe+0x110>
  if(pipealloc(&rf, &wf) < 0)
    80005f78:	fc840593          	addi	a1,s0,-56
    80005f7c:	fd040513          	addi	a0,s0,-48
    80005f80:	fffff097          	auipc	ra,0xfffff
    80005f84:	dba080e7          	jalr	-582(ra) # 80004d3a <pipealloc>
    return -1;
    80005f88:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005f8a:	0c054b63          	bltz	a0,80006060 <sys_pipe+0x110>
  fd0 = -1;
    80005f8e:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005f92:	fd043503          	ld	a0,-48(s0)
    80005f96:	fffff097          	auipc	ra,0xfffff
    80005f9a:	500080e7          	jalr	1280(ra) # 80005496 <fdalloc>
    80005f9e:	fca42223          	sw	a0,-60(s0)
    80005fa2:	0a054263          	bltz	a0,80006046 <sys_pipe+0xf6>
    80005fa6:	fc843503          	ld	a0,-56(s0)
    80005faa:	fffff097          	auipc	ra,0xfffff
    80005fae:	4ec080e7          	jalr	1260(ra) # 80005496 <fdalloc>
    80005fb2:	fca42023          	sw	a0,-64(s0)
    80005fb6:	06054e63          	bltz	a0,80006032 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005fba:	6785                	lui	a5,0x1
    80005fbc:	97a6                	add	a5,a5,s1
    80005fbe:	4691                	li	a3,4
    80005fc0:	fc440613          	addi	a2,s0,-60
    80005fc4:	fd843583          	ld	a1,-40(s0)
    80005fc8:	73c8                	ld	a0,160(a5)
    80005fca:	ffffb097          	auipc	ra,0xffffb
    80005fce:	6b8080e7          	jalr	1720(ra) # 80001682 <copyout>
    80005fd2:	02054263          	bltz	a0,80005ff6 <sys_pipe+0xa6>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005fd6:	6785                	lui	a5,0x1
    80005fd8:	97a6                	add	a5,a5,s1
    80005fda:	4691                	li	a3,4
    80005fdc:	fc040613          	addi	a2,s0,-64
    80005fe0:	fd843583          	ld	a1,-40(s0)
    80005fe4:	0591                	addi	a1,a1,4
    80005fe6:	73c8                	ld	a0,160(a5)
    80005fe8:	ffffb097          	auipc	ra,0xffffb
    80005fec:	69a080e7          	jalr	1690(ra) # 80001682 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005ff0:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005ff2:	06055763          	bgez	a0,80006060 <sys_pipe+0x110>
    p->ofile[fd0] = 0;
    80005ff6:	fc442783          	lw	a5,-60(s0)
    80005ffa:	22478793          	addi	a5,a5,548 # 1224 <_entry-0x7fffeddc>
    80005ffe:	078e                	slli	a5,a5,0x3
    80006000:	97a6                	add	a5,a5,s1
    80006002:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80006006:	fc042503          	lw	a0,-64(s0)
    8000600a:	22450513          	addi	a0,a0,548 # 1224 <_entry-0x7fffeddc>
    8000600e:	050e                	slli	a0,a0,0x3
    80006010:	9526                	add	a0,a0,s1
    80006012:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80006016:	fd043503          	ld	a0,-48(s0)
    8000601a:	fffff097          	auipc	ra,0xfffff
    8000601e:	9c8080e7          	jalr	-1592(ra) # 800049e2 <fileclose>
    fileclose(wf);
    80006022:	fc843503          	ld	a0,-56(s0)
    80006026:	fffff097          	auipc	ra,0xfffff
    8000602a:	9bc080e7          	jalr	-1604(ra) # 800049e2 <fileclose>
    return -1;
    8000602e:	57fd                	li	a5,-1
    80006030:	a805                	j	80006060 <sys_pipe+0x110>
    if(fd0 >= 0)
    80006032:	fc442783          	lw	a5,-60(s0)
    80006036:	0007c863          	bltz	a5,80006046 <sys_pipe+0xf6>
      p->ofile[fd0] = 0;
    8000603a:	22478513          	addi	a0,a5,548
    8000603e:	050e                	slli	a0,a0,0x3
    80006040:	9526                	add	a0,a0,s1
    80006042:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80006046:	fd043503          	ld	a0,-48(s0)
    8000604a:	fffff097          	auipc	ra,0xfffff
    8000604e:	998080e7          	jalr	-1640(ra) # 800049e2 <fileclose>
    fileclose(wf);
    80006052:	fc843503          	ld	a0,-56(s0)
    80006056:	fffff097          	auipc	ra,0xfffff
    8000605a:	98c080e7          	jalr	-1652(ra) # 800049e2 <fileclose>
    return -1;
    8000605e:	57fd                	li	a5,-1
}
    80006060:	853e                	mv	a0,a5
    80006062:	70e2                	ld	ra,56(sp)
    80006064:	7442                	ld	s0,48(sp)
    80006066:	74a2                	ld	s1,40(sp)
    80006068:	6121                	addi	sp,sp,64
    8000606a:	8082                	ret
    8000606c:	0000                	unimp
	...

0000000080006070 <kernelvec>:
    80006070:	7111                	addi	sp,sp,-256
    80006072:	e006                	sd	ra,0(sp)
    80006074:	e40a                	sd	sp,8(sp)
    80006076:	e80e                	sd	gp,16(sp)
    80006078:	ec12                	sd	tp,24(sp)
    8000607a:	f016                	sd	t0,32(sp)
    8000607c:	f41a                	sd	t1,40(sp)
    8000607e:	f81e                	sd	t2,48(sp)
    80006080:	fc22                	sd	s0,56(sp)
    80006082:	e0a6                	sd	s1,64(sp)
    80006084:	e4aa                	sd	a0,72(sp)
    80006086:	e8ae                	sd	a1,80(sp)
    80006088:	ecb2                	sd	a2,88(sp)
    8000608a:	f0b6                	sd	a3,96(sp)
    8000608c:	f4ba                	sd	a4,104(sp)
    8000608e:	f8be                	sd	a5,112(sp)
    80006090:	fcc2                	sd	a6,120(sp)
    80006092:	e146                	sd	a7,128(sp)
    80006094:	e54a                	sd	s2,136(sp)
    80006096:	e94e                	sd	s3,144(sp)
    80006098:	ed52                	sd	s4,152(sp)
    8000609a:	f156                	sd	s5,160(sp)
    8000609c:	f55a                	sd	s6,168(sp)
    8000609e:	f95e                	sd	s7,176(sp)
    800060a0:	fd62                	sd	s8,184(sp)
    800060a2:	e1e6                	sd	s9,192(sp)
    800060a4:	e5ea                	sd	s10,200(sp)
    800060a6:	e9ee                	sd	s11,208(sp)
    800060a8:	edf2                	sd	t3,216(sp)
    800060aa:	f1f6                	sd	t4,224(sp)
    800060ac:	f5fa                	sd	t5,232(sp)
    800060ae:	f9fe                	sd	t6,240(sp)
    800060b0:	a95fc0ef          	jal	ra,80002b44 <kerneltrap>
    800060b4:	6082                	ld	ra,0(sp)
    800060b6:	6122                	ld	sp,8(sp)
    800060b8:	61c2                	ld	gp,16(sp)
    800060ba:	7282                	ld	t0,32(sp)
    800060bc:	7322                	ld	t1,40(sp)
    800060be:	73c2                	ld	t2,48(sp)
    800060c0:	7462                	ld	s0,56(sp)
    800060c2:	6486                	ld	s1,64(sp)
    800060c4:	6526                	ld	a0,72(sp)
    800060c6:	65c6                	ld	a1,80(sp)
    800060c8:	6666                	ld	a2,88(sp)
    800060ca:	7686                	ld	a3,96(sp)
    800060cc:	7726                	ld	a4,104(sp)
    800060ce:	77c6                	ld	a5,112(sp)
    800060d0:	7866                	ld	a6,120(sp)
    800060d2:	688a                	ld	a7,128(sp)
    800060d4:	692a                	ld	s2,136(sp)
    800060d6:	69ca                	ld	s3,144(sp)
    800060d8:	6a6a                	ld	s4,152(sp)
    800060da:	7a8a                	ld	s5,160(sp)
    800060dc:	7b2a                	ld	s6,168(sp)
    800060de:	7bca                	ld	s7,176(sp)
    800060e0:	7c6a                	ld	s8,184(sp)
    800060e2:	6c8e                	ld	s9,192(sp)
    800060e4:	6d2e                	ld	s10,200(sp)
    800060e6:	6dce                	ld	s11,208(sp)
    800060e8:	6e6e                	ld	t3,216(sp)
    800060ea:	7e8e                	ld	t4,224(sp)
    800060ec:	7f2e                	ld	t5,232(sp)
    800060ee:	7fce                	ld	t6,240(sp)
    800060f0:	6111                	addi	sp,sp,256
    800060f2:	10200073          	sret
    800060f6:	00000013          	nop
    800060fa:	00000013          	nop
    800060fe:	0001                	nop

0000000080006100 <timervec>:
    80006100:	34051573          	csrrw	a0,mscratch,a0
    80006104:	e10c                	sd	a1,0(a0)
    80006106:	e510                	sd	a2,8(a0)
    80006108:	e914                	sd	a3,16(a0)
    8000610a:	6d0c                	ld	a1,24(a0)
    8000610c:	7110                	ld	a2,32(a0)
    8000610e:	6194                	ld	a3,0(a1)
    80006110:	96b2                	add	a3,a3,a2
    80006112:	e194                	sd	a3,0(a1)
    80006114:	4589                	li	a1,2
    80006116:	14459073          	csrw	sip,a1
    8000611a:	6914                	ld	a3,16(a0)
    8000611c:	6510                	ld	a2,8(a0)
    8000611e:	610c                	ld	a1,0(a0)
    80006120:	34051573          	csrrw	a0,mscratch,a0
    80006124:	30200073          	mret
	...

000000008000612a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000612a:	1141                	addi	sp,sp,-16
    8000612c:	e422                	sd	s0,8(sp)
    8000612e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006130:	0c0007b7          	lui	a5,0xc000
    80006134:	4705                	li	a4,1
    80006136:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006138:	c3d8                	sw	a4,4(a5)
}
    8000613a:	6422                	ld	s0,8(sp)
    8000613c:	0141                	addi	sp,sp,16
    8000613e:	8082                	ret

0000000080006140 <plicinithart>:

void
plicinithart(void)
{
    80006140:	1141                	addi	sp,sp,-16
    80006142:	e406                	sd	ra,8(sp)
    80006144:	e022                	sd	s0,0(sp)
    80006146:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006148:	ffffc097          	auipc	ra,0xffffc
    8000614c:	89a080e7          	jalr	-1894(ra) # 800019e2 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006150:	0085171b          	slliw	a4,a0,0x8
    80006154:	0c0027b7          	lui	a5,0xc002
    80006158:	97ba                	add	a5,a5,a4
    8000615a:	40200713          	li	a4,1026
    8000615e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006162:	00d5151b          	slliw	a0,a0,0xd
    80006166:	0c2017b7          	lui	a5,0xc201
    8000616a:	953e                	add	a0,a0,a5
    8000616c:	00052023          	sw	zero,0(a0)
}
    80006170:	60a2                	ld	ra,8(sp)
    80006172:	6402                	ld	s0,0(sp)
    80006174:	0141                	addi	sp,sp,16
    80006176:	8082                	ret

0000000080006178 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006178:	1141                	addi	sp,sp,-16
    8000617a:	e406                	sd	ra,8(sp)
    8000617c:	e022                	sd	s0,0(sp)
    8000617e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006180:	ffffc097          	auipc	ra,0xffffc
    80006184:	862080e7          	jalr	-1950(ra) # 800019e2 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006188:	00d5179b          	slliw	a5,a0,0xd
    8000618c:	0c201537          	lui	a0,0xc201
    80006190:	953e                	add	a0,a0,a5
  return irq;
}
    80006192:	4148                	lw	a0,4(a0)
    80006194:	60a2                	ld	ra,8(sp)
    80006196:	6402                	ld	s0,0(sp)
    80006198:	0141                	addi	sp,sp,16
    8000619a:	8082                	ret

000000008000619c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000619c:	1101                	addi	sp,sp,-32
    8000619e:	ec06                	sd	ra,24(sp)
    800061a0:	e822                	sd	s0,16(sp)
    800061a2:	e426                	sd	s1,8(sp)
    800061a4:	1000                	addi	s0,sp,32
    800061a6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800061a8:	ffffc097          	auipc	ra,0xffffc
    800061ac:	83a080e7          	jalr	-1990(ra) # 800019e2 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800061b0:	00d5151b          	slliw	a0,a0,0xd
    800061b4:	0c2017b7          	lui	a5,0xc201
    800061b8:	97aa                	add	a5,a5,a0
    800061ba:	c3c4                	sw	s1,4(a5)
}
    800061bc:	60e2                	ld	ra,24(sp)
    800061be:	6442                	ld	s0,16(sp)
    800061c0:	64a2                	ld	s1,8(sp)
    800061c2:	6105                	addi	sp,sp,32
    800061c4:	8082                	ret

00000000800061c6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800061c6:	1141                	addi	sp,sp,-16
    800061c8:	e406                	sd	ra,8(sp)
    800061ca:	e022                	sd	s0,0(sp)
    800061cc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800061ce:	479d                	li	a5,7
    800061d0:	06a7c963          	blt	a5,a0,80006242 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800061d4:	0005e797          	auipc	a5,0x5e
    800061d8:	e2c78793          	addi	a5,a5,-468 # 80064000 <disk>
    800061dc:	00a78733          	add	a4,a5,a0
    800061e0:	6789                	lui	a5,0x2
    800061e2:	97ba                	add	a5,a5,a4
    800061e4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800061e8:	e7ad                	bnez	a5,80006252 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800061ea:	00451793          	slli	a5,a0,0x4
    800061ee:	00060717          	auipc	a4,0x60
    800061f2:	e1270713          	addi	a4,a4,-494 # 80066000 <disk+0x2000>
    800061f6:	6314                	ld	a3,0(a4)
    800061f8:	96be                	add	a3,a3,a5
    800061fa:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800061fe:	6314                	ld	a3,0(a4)
    80006200:	96be                	add	a3,a3,a5
    80006202:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80006206:	6314                	ld	a3,0(a4)
    80006208:	96be                	add	a3,a3,a5
    8000620a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000620e:	6318                	ld	a4,0(a4)
    80006210:	97ba                	add	a5,a5,a4
    80006212:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80006216:	0005e797          	auipc	a5,0x5e
    8000621a:	dea78793          	addi	a5,a5,-534 # 80064000 <disk>
    8000621e:	97aa                	add	a5,a5,a0
    80006220:	6509                	lui	a0,0x2
    80006222:	953e                	add	a0,a0,a5
    80006224:	4785                	li	a5,1
    80006226:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000622a:	00060517          	auipc	a0,0x60
    8000622e:	dee50513          	addi	a0,a0,-530 # 80066018 <disk+0x2018>
    80006232:	ffffc097          	auipc	ra,0xffffc
    80006236:	202080e7          	jalr	514(ra) # 80002434 <wakeup>
}
    8000623a:	60a2                	ld	ra,8(sp)
    8000623c:	6402                	ld	s0,0(sp)
    8000623e:	0141                	addi	sp,sp,16
    80006240:	8082                	ret
    panic("free_desc 1");
    80006242:	00002517          	auipc	a0,0x2
    80006246:	52650513          	addi	a0,a0,1318 # 80008768 <syscalls+0x348>
    8000624a:	ffffa097          	auipc	ra,0xffffa
    8000624e:	300080e7          	jalr	768(ra) # 8000054a <panic>
    panic("free_desc 2");
    80006252:	00002517          	auipc	a0,0x2
    80006256:	52650513          	addi	a0,a0,1318 # 80008778 <syscalls+0x358>
    8000625a:	ffffa097          	auipc	ra,0xffffa
    8000625e:	2f0080e7          	jalr	752(ra) # 8000054a <panic>

0000000080006262 <virtio_disk_init>:
{
    80006262:	1101                	addi	sp,sp,-32
    80006264:	ec06                	sd	ra,24(sp)
    80006266:	e822                	sd	s0,16(sp)
    80006268:	e426                	sd	s1,8(sp)
    8000626a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000626c:	00002597          	auipc	a1,0x2
    80006270:	51c58593          	addi	a1,a1,1308 # 80008788 <syscalls+0x368>
    80006274:	00060517          	auipc	a0,0x60
    80006278:	eb450513          	addi	a0,a0,-332 # 80066128 <disk+0x2128>
    8000627c:	ffffb097          	auipc	ra,0xffffb
    80006280:	8fa080e7          	jalr	-1798(ra) # 80000b76 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006284:	100017b7          	lui	a5,0x10001
    80006288:	4398                	lw	a4,0(a5)
    8000628a:	2701                	sext.w	a4,a4
    8000628c:	747277b7          	lui	a5,0x74727
    80006290:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006294:	0ef71163          	bne	a4,a5,80006376 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80006298:	100017b7          	lui	a5,0x10001
    8000629c:	43dc                	lw	a5,4(a5)
    8000629e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800062a0:	4705                	li	a4,1
    800062a2:	0ce79a63          	bne	a5,a4,80006376 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800062a6:	100017b7          	lui	a5,0x10001
    800062aa:	479c                	lw	a5,8(a5)
    800062ac:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800062ae:	4709                	li	a4,2
    800062b0:	0ce79363          	bne	a5,a4,80006376 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800062b4:	100017b7          	lui	a5,0x10001
    800062b8:	47d8                	lw	a4,12(a5)
    800062ba:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800062bc:	554d47b7          	lui	a5,0x554d4
    800062c0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800062c4:	0af71963          	bne	a4,a5,80006376 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800062c8:	100017b7          	lui	a5,0x10001
    800062cc:	4705                	li	a4,1
    800062ce:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800062d0:	470d                	li	a4,3
    800062d2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800062d4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800062d6:	c7ffe737          	lui	a4,0xc7ffe
    800062da:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47f9775f>
    800062de:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800062e0:	2701                	sext.w	a4,a4
    800062e2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800062e4:	472d                	li	a4,11
    800062e6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800062e8:	473d                	li	a4,15
    800062ea:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800062ec:	6705                	lui	a4,0x1
    800062ee:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800062f0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800062f4:	5bdc                	lw	a5,52(a5)
    800062f6:	2781                	sext.w	a5,a5
  if(max == 0)
    800062f8:	c7d9                	beqz	a5,80006386 <virtio_disk_init+0x124>
  if(max < NUM)
    800062fa:	471d                	li	a4,7
    800062fc:	08f77d63          	bgeu	a4,a5,80006396 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006300:	100014b7          	lui	s1,0x10001
    80006304:	47a1                	li	a5,8
    80006306:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80006308:	6609                	lui	a2,0x2
    8000630a:	4581                	li	a1,0
    8000630c:	0005e517          	auipc	a0,0x5e
    80006310:	cf450513          	addi	a0,a0,-780 # 80064000 <disk>
    80006314:	ffffb097          	auipc	ra,0xffffb
    80006318:	9ee080e7          	jalr	-1554(ra) # 80000d02 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000631c:	0005e717          	auipc	a4,0x5e
    80006320:	ce470713          	addi	a4,a4,-796 # 80064000 <disk>
    80006324:	00c75793          	srli	a5,a4,0xc
    80006328:	2781                	sext.w	a5,a5
    8000632a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000632c:	00060797          	auipc	a5,0x60
    80006330:	cd478793          	addi	a5,a5,-812 # 80066000 <disk+0x2000>
    80006334:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80006336:	0005e717          	auipc	a4,0x5e
    8000633a:	d4a70713          	addi	a4,a4,-694 # 80064080 <disk+0x80>
    8000633e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80006340:	0005f717          	auipc	a4,0x5f
    80006344:	cc070713          	addi	a4,a4,-832 # 80065000 <disk+0x1000>
    80006348:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000634a:	4705                	li	a4,1
    8000634c:	00e78c23          	sb	a4,24(a5)
    80006350:	00e78ca3          	sb	a4,25(a5)
    80006354:	00e78d23          	sb	a4,26(a5)
    80006358:	00e78da3          	sb	a4,27(a5)
    8000635c:	00e78e23          	sb	a4,28(a5)
    80006360:	00e78ea3          	sb	a4,29(a5)
    80006364:	00e78f23          	sb	a4,30(a5)
    80006368:	00e78fa3          	sb	a4,31(a5)
}
    8000636c:	60e2                	ld	ra,24(sp)
    8000636e:	6442                	ld	s0,16(sp)
    80006370:	64a2                	ld	s1,8(sp)
    80006372:	6105                	addi	sp,sp,32
    80006374:	8082                	ret
    panic("could not find virtio disk");
    80006376:	00002517          	auipc	a0,0x2
    8000637a:	42250513          	addi	a0,a0,1058 # 80008798 <syscalls+0x378>
    8000637e:	ffffa097          	auipc	ra,0xffffa
    80006382:	1cc080e7          	jalr	460(ra) # 8000054a <panic>
    panic("virtio disk has no queue 0");
    80006386:	00002517          	auipc	a0,0x2
    8000638a:	43250513          	addi	a0,a0,1074 # 800087b8 <syscalls+0x398>
    8000638e:	ffffa097          	auipc	ra,0xffffa
    80006392:	1bc080e7          	jalr	444(ra) # 8000054a <panic>
    panic("virtio disk max queue too short");
    80006396:	00002517          	auipc	a0,0x2
    8000639a:	44250513          	addi	a0,a0,1090 # 800087d8 <syscalls+0x3b8>
    8000639e:	ffffa097          	auipc	ra,0xffffa
    800063a2:	1ac080e7          	jalr	428(ra) # 8000054a <panic>

00000000800063a6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800063a6:	7119                	addi	sp,sp,-128
    800063a8:	fc86                	sd	ra,120(sp)
    800063aa:	f8a2                	sd	s0,112(sp)
    800063ac:	f4a6                	sd	s1,104(sp)
    800063ae:	f0ca                	sd	s2,96(sp)
    800063b0:	ecce                	sd	s3,88(sp)
    800063b2:	e8d2                	sd	s4,80(sp)
    800063b4:	e4d6                	sd	s5,72(sp)
    800063b6:	e0da                	sd	s6,64(sp)
    800063b8:	fc5e                	sd	s7,56(sp)
    800063ba:	f862                	sd	s8,48(sp)
    800063bc:	f466                	sd	s9,40(sp)
    800063be:	f06a                	sd	s10,32(sp)
    800063c0:	ec6e                	sd	s11,24(sp)
    800063c2:	0100                	addi	s0,sp,128
    800063c4:	8aaa                	mv	s5,a0
    800063c6:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800063c8:	00c52c83          	lw	s9,12(a0)
    800063cc:	001c9c9b          	slliw	s9,s9,0x1
    800063d0:	1c82                	slli	s9,s9,0x20
    800063d2:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800063d6:	00060517          	auipc	a0,0x60
    800063da:	d5250513          	addi	a0,a0,-686 # 80066128 <disk+0x2128>
    800063de:	ffffb097          	auipc	ra,0xffffb
    800063e2:	828080e7          	jalr	-2008(ra) # 80000c06 <acquire>
  for(int i = 0; i < 3; i++){
    800063e6:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800063e8:	44a1                	li	s1,8
      disk.free[i] = 0;
    800063ea:	0005ec17          	auipc	s8,0x5e
    800063ee:	c16c0c13          	addi	s8,s8,-1002 # 80064000 <disk>
    800063f2:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    800063f4:	4b0d                	li	s6,3
    800063f6:	a0ad                	j	80006460 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    800063f8:	00fc0733          	add	a4,s8,a5
    800063fc:	975e                	add	a4,a4,s7
    800063fe:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006402:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006404:	0207c563          	bltz	a5,8000642e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80006408:	2905                	addiw	s2,s2,1
    8000640a:	0611                	addi	a2,a2,4
    8000640c:	19690d63          	beq	s2,s6,800065a6 <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    80006410:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006412:	00060717          	auipc	a4,0x60
    80006416:	c0670713          	addi	a4,a4,-1018 # 80066018 <disk+0x2018>
    8000641a:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000641c:	00074683          	lbu	a3,0(a4)
    80006420:	fee1                	bnez	a3,800063f8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80006422:	2785                	addiw	a5,a5,1
    80006424:	0705                	addi	a4,a4,1
    80006426:	fe979be3          	bne	a5,s1,8000641c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000642a:	57fd                	li	a5,-1
    8000642c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000642e:	01205d63          	blez	s2,80006448 <virtio_disk_rw+0xa2>
    80006432:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80006434:	000a2503          	lw	a0,0(s4)
    80006438:	00000097          	auipc	ra,0x0
    8000643c:	d8e080e7          	jalr	-626(ra) # 800061c6 <free_desc>
      for(int j = 0; j < i; j++)
    80006440:	2d85                	addiw	s11,s11,1
    80006442:	0a11                	addi	s4,s4,4
    80006444:	ffb918e3          	bne	s2,s11,80006434 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006448:	00060597          	auipc	a1,0x60
    8000644c:	ce058593          	addi	a1,a1,-800 # 80066128 <disk+0x2128>
    80006450:	00060517          	auipc	a0,0x60
    80006454:	bc850513          	addi	a0,a0,-1080 # 80066018 <disk+0x2018>
    80006458:	ffffc097          	auipc	ra,0xffffc
    8000645c:	e58080e7          	jalr	-424(ra) # 800022b0 <sleep>
  for(int i = 0; i < 3; i++){
    80006460:	f8040a13          	addi	s4,s0,-128
{
    80006464:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80006466:	894e                	mv	s2,s3
    80006468:	b765                	j	80006410 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000646a:	00060697          	auipc	a3,0x60
    8000646e:	b966b683          	ld	a3,-1130(a3) # 80066000 <disk+0x2000>
    80006472:	96ba                	add	a3,a3,a4
    80006474:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006478:	0005e817          	auipc	a6,0x5e
    8000647c:	b8880813          	addi	a6,a6,-1144 # 80064000 <disk>
    80006480:	00060697          	auipc	a3,0x60
    80006484:	b8068693          	addi	a3,a3,-1152 # 80066000 <disk+0x2000>
    80006488:	6290                	ld	a2,0(a3)
    8000648a:	963a                	add	a2,a2,a4
    8000648c:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    80006490:	0015e593          	ori	a1,a1,1
    80006494:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80006498:	f8842603          	lw	a2,-120(s0)
    8000649c:	628c                	ld	a1,0(a3)
    8000649e:	972e                	add	a4,a4,a1
    800064a0:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800064a4:	20050593          	addi	a1,a0,512
    800064a8:	0592                	slli	a1,a1,0x4
    800064aa:	95c2                	add	a1,a1,a6
    800064ac:	577d                	li	a4,-1
    800064ae:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800064b2:	00461713          	slli	a4,a2,0x4
    800064b6:	6290                	ld	a2,0(a3)
    800064b8:	963a                	add	a2,a2,a4
    800064ba:	03078793          	addi	a5,a5,48
    800064be:	97c2                	add	a5,a5,a6
    800064c0:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    800064c2:	629c                	ld	a5,0(a3)
    800064c4:	97ba                	add	a5,a5,a4
    800064c6:	4605                	li	a2,1
    800064c8:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800064ca:	629c                	ld	a5,0(a3)
    800064cc:	97ba                	add	a5,a5,a4
    800064ce:	4809                	li	a6,2
    800064d0:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800064d4:	629c                	ld	a5,0(a3)
    800064d6:	973e                	add	a4,a4,a5
    800064d8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800064dc:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800064e0:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800064e4:	6698                	ld	a4,8(a3)
    800064e6:	00275783          	lhu	a5,2(a4)
    800064ea:	8b9d                	andi	a5,a5,7
    800064ec:	0786                	slli	a5,a5,0x1
    800064ee:	97ba                	add	a5,a5,a4
    800064f0:	00a79223          	sh	a0,4(a5)

  __sync_synchronize();
    800064f4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800064f8:	6698                	ld	a4,8(a3)
    800064fa:	00275783          	lhu	a5,2(a4)
    800064fe:	2785                	addiw	a5,a5,1
    80006500:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006504:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006508:	100017b7          	lui	a5,0x10001
    8000650c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006510:	004aa783          	lw	a5,4(s5)
    80006514:	02c79163          	bne	a5,a2,80006536 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80006518:	00060917          	auipc	s2,0x60
    8000651c:	c1090913          	addi	s2,s2,-1008 # 80066128 <disk+0x2128>
  while(b->disk == 1) {
    80006520:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006522:	85ca                	mv	a1,s2
    80006524:	8556                	mv	a0,s5
    80006526:	ffffc097          	auipc	ra,0xffffc
    8000652a:	d8a080e7          	jalr	-630(ra) # 800022b0 <sleep>
  while(b->disk == 1) {
    8000652e:	004aa783          	lw	a5,4(s5)
    80006532:	fe9788e3          	beq	a5,s1,80006522 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80006536:	f8042903          	lw	s2,-128(s0)
    8000653a:	20090793          	addi	a5,s2,512
    8000653e:	00479713          	slli	a4,a5,0x4
    80006542:	0005e797          	auipc	a5,0x5e
    80006546:	abe78793          	addi	a5,a5,-1346 # 80064000 <disk>
    8000654a:	97ba                	add	a5,a5,a4
    8000654c:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80006550:	00060997          	auipc	s3,0x60
    80006554:	ab098993          	addi	s3,s3,-1360 # 80066000 <disk+0x2000>
    80006558:	00491713          	slli	a4,s2,0x4
    8000655c:	0009b783          	ld	a5,0(s3)
    80006560:	97ba                	add	a5,a5,a4
    80006562:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006566:	854a                	mv	a0,s2
    80006568:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000656c:	00000097          	auipc	ra,0x0
    80006570:	c5a080e7          	jalr	-934(ra) # 800061c6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006574:	8885                	andi	s1,s1,1
    80006576:	f0ed                	bnez	s1,80006558 <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006578:	00060517          	auipc	a0,0x60
    8000657c:	bb050513          	addi	a0,a0,-1104 # 80066128 <disk+0x2128>
    80006580:	ffffa097          	auipc	ra,0xffffa
    80006584:	73a080e7          	jalr	1850(ra) # 80000cba <release>
}
    80006588:	70e6                	ld	ra,120(sp)
    8000658a:	7446                	ld	s0,112(sp)
    8000658c:	74a6                	ld	s1,104(sp)
    8000658e:	7906                	ld	s2,96(sp)
    80006590:	69e6                	ld	s3,88(sp)
    80006592:	6a46                	ld	s4,80(sp)
    80006594:	6aa6                	ld	s5,72(sp)
    80006596:	6b06                	ld	s6,64(sp)
    80006598:	7be2                	ld	s7,56(sp)
    8000659a:	7c42                	ld	s8,48(sp)
    8000659c:	7ca2                	ld	s9,40(sp)
    8000659e:	7d02                	ld	s10,32(sp)
    800065a0:	6de2                	ld	s11,24(sp)
    800065a2:	6109                	addi	sp,sp,128
    800065a4:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800065a6:	f8042503          	lw	a0,-128(s0)
    800065aa:	20050793          	addi	a5,a0,512
    800065ae:	0792                	slli	a5,a5,0x4
  if(write)
    800065b0:	0005e817          	auipc	a6,0x5e
    800065b4:	a5080813          	addi	a6,a6,-1456 # 80064000 <disk>
    800065b8:	00f80733          	add	a4,a6,a5
    800065bc:	01a036b3          	snez	a3,s10
    800065c0:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    800065c4:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800065c8:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800065cc:	7679                	lui	a2,0xffffe
    800065ce:	963e                	add	a2,a2,a5
    800065d0:	00060697          	auipc	a3,0x60
    800065d4:	a3068693          	addi	a3,a3,-1488 # 80066000 <disk+0x2000>
    800065d8:	6298                	ld	a4,0(a3)
    800065da:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800065dc:	0a878593          	addi	a1,a5,168
    800065e0:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    800065e2:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800065e4:	6298                	ld	a4,0(a3)
    800065e6:	9732                	add	a4,a4,a2
    800065e8:	45c1                	li	a1,16
    800065ea:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800065ec:	6298                	ld	a4,0(a3)
    800065ee:	9732                	add	a4,a4,a2
    800065f0:	4585                	li	a1,1
    800065f2:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800065f6:	f8442703          	lw	a4,-124(s0)
    800065fa:	628c                	ld	a1,0(a3)
    800065fc:	962e                	add	a2,a2,a1
    800065fe:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ff9700e>
  disk.desc[idx[1]].addr = (uint64) b->data;
    80006602:	0712                	slli	a4,a4,0x4
    80006604:	6290                	ld	a2,0(a3)
    80006606:	963a                	add	a2,a2,a4
    80006608:	058a8593          	addi	a1,s5,88
    8000660c:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    8000660e:	6294                	ld	a3,0(a3)
    80006610:	96ba                	add	a3,a3,a4
    80006612:	40000613          	li	a2,1024
    80006616:	c690                	sw	a2,8(a3)
  if(write)
    80006618:	e40d19e3          	bnez	s10,8000646a <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000661c:	00060697          	auipc	a3,0x60
    80006620:	9e46b683          	ld	a3,-1564(a3) # 80066000 <disk+0x2000>
    80006624:	96ba                	add	a3,a3,a4
    80006626:	4609                	li	a2,2
    80006628:	00c69623          	sh	a2,12(a3)
    8000662c:	b5b1                	j	80006478 <virtio_disk_rw+0xd2>

000000008000662e <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000662e:	1101                	addi	sp,sp,-32
    80006630:	ec06                	sd	ra,24(sp)
    80006632:	e822                	sd	s0,16(sp)
    80006634:	e426                	sd	s1,8(sp)
    80006636:	e04a                	sd	s2,0(sp)
    80006638:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000663a:	00060517          	auipc	a0,0x60
    8000663e:	aee50513          	addi	a0,a0,-1298 # 80066128 <disk+0x2128>
    80006642:	ffffa097          	auipc	ra,0xffffa
    80006646:	5c4080e7          	jalr	1476(ra) # 80000c06 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000664a:	10001737          	lui	a4,0x10001
    8000664e:	533c                	lw	a5,96(a4)
    80006650:	8b8d                	andi	a5,a5,3
    80006652:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006654:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006658:	00060797          	auipc	a5,0x60
    8000665c:	9a878793          	addi	a5,a5,-1624 # 80066000 <disk+0x2000>
    80006660:	6b94                	ld	a3,16(a5)
    80006662:	0207d703          	lhu	a4,32(a5)
    80006666:	0026d783          	lhu	a5,2(a3)
    8000666a:	06f70163          	beq	a4,a5,800066cc <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000666e:	0005e917          	auipc	s2,0x5e
    80006672:	99290913          	addi	s2,s2,-1646 # 80064000 <disk>
    80006676:	00060497          	auipc	s1,0x60
    8000667a:	98a48493          	addi	s1,s1,-1654 # 80066000 <disk+0x2000>
    __sync_synchronize();
    8000667e:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006682:	6898                	ld	a4,16(s1)
    80006684:	0204d783          	lhu	a5,32(s1)
    80006688:	8b9d                	andi	a5,a5,7
    8000668a:	078e                	slli	a5,a5,0x3
    8000668c:	97ba                	add	a5,a5,a4
    8000668e:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006690:	20078713          	addi	a4,a5,512
    80006694:	0712                	slli	a4,a4,0x4
    80006696:	974a                	add	a4,a4,s2
    80006698:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000669c:	e731                	bnez	a4,800066e8 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000669e:	20078793          	addi	a5,a5,512
    800066a2:	0792                	slli	a5,a5,0x4
    800066a4:	97ca                	add	a5,a5,s2
    800066a6:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800066a8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800066ac:	ffffc097          	auipc	ra,0xffffc
    800066b0:	d88080e7          	jalr	-632(ra) # 80002434 <wakeup>

    disk.used_idx += 1;
    800066b4:	0204d783          	lhu	a5,32(s1)
    800066b8:	2785                	addiw	a5,a5,1
    800066ba:	17c2                	slli	a5,a5,0x30
    800066bc:	93c1                	srli	a5,a5,0x30
    800066be:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800066c2:	6898                	ld	a4,16(s1)
    800066c4:	00275703          	lhu	a4,2(a4)
    800066c8:	faf71be3          	bne	a4,a5,8000667e <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800066cc:	00060517          	auipc	a0,0x60
    800066d0:	a5c50513          	addi	a0,a0,-1444 # 80066128 <disk+0x2128>
    800066d4:	ffffa097          	auipc	ra,0xffffa
    800066d8:	5e6080e7          	jalr	1510(ra) # 80000cba <release>
}
    800066dc:	60e2                	ld	ra,24(sp)
    800066de:	6442                	ld	s0,16(sp)
    800066e0:	64a2                	ld	s1,8(sp)
    800066e2:	6902                	ld	s2,0(sp)
    800066e4:	6105                	addi	sp,sp,32
    800066e6:	8082                	ret
      panic("virtio_disk_intr status");
    800066e8:	00002517          	auipc	a0,0x2
    800066ec:	11050513          	addi	a0,a0,272 # 800087f8 <syscalls+0x3d8>
    800066f0:	ffffa097          	auipc	ra,0xffffa
    800066f4:	e5a080e7          	jalr	-422(ra) # 8000054a <panic>
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
