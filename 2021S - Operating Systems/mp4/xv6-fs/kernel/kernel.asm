
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
    80000016:	076000ef          	jal	ra,8000008c <start>

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
    80000022:	f1402773          	csrr	a4,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	2701                	sext.w	a4,a4

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80000028:	0037161b          	slliw	a2,a4,0x3
    8000002c:	020047b7          	lui	a5,0x2004
    80000030:	963e                	add	a2,a2,a5
    80000032:	0200c7b7          	lui	a5,0x200c
    80000036:	ff87b783          	ld	a5,-8(a5) # 200bff8 <_entry-0x7dff4008>
    8000003a:	000f46b7          	lui	a3,0xf4
    8000003e:	24068693          	addi	a3,a3,576 # f4240 <_entry-0x7ff0bdc0>
    80000042:	97b6                	add	a5,a5,a3
    80000044:	e21c                	sd	a5,0(a2)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000046:	00271793          	slli	a5,a4,0x2
    8000004a:	97ba                	add	a5,a5,a4
    8000004c:	00379713          	slli	a4,a5,0x3
    80000050:	00009797          	auipc	a5,0x9
    80000054:	ff078793          	addi	a5,a5,-16 # 80009040 <timer_scratch>
    80000058:	97ba                	add	a5,a5,a4
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef90                	sd	a2,24(a5)
  scratch[4] = interval;
    8000005c:	f394                	sd	a3,32(a5)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005e:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	fee78793          	addi	a5,a5,-18 # 80006050 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000076:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000082:	30479073          	csrw	mie,a5
}
    80000086:	6422                	ld	s0,8(sp)
    80000088:	0141                	addi	sp,sp,16
    8000008a:	8082                	ret

000000008000008c <start>:
{
    8000008c:	1141                	addi	sp,sp,-16
    8000008e:	e406                	sd	ra,8(sp)
    80000090:	e022                	sd	s0,0(sp)
    80000092:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000094:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000098:	7779                	lui	a4,0xffffe
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd87ff>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	e8478793          	addi	a5,a5,-380 # 80000f30 <main>
    800000b4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b8:	4781                	li	a5,0
    800000ba:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000be:	67c1                	lui	a5,0x10
    800000c0:	17fd                	addi	a5,a5,-1
    800000c2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000ca:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000ce:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d2:	10479073          	csrw	sie,a5
  timerinit();
    800000d6:	00000097          	auipc	ra,0x0
    800000da:	f46080e7          	jalr	-186(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000de:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000e2:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000e4:	823e                	mv	tp,a5
  asm volatile("mret");
    800000e6:	30200073          	mret
}
    800000ea:	60a2                	ld	ra,8(sp)
    800000ec:	6402                	ld	s0,0(sp)
    800000ee:	0141                	addi	sp,sp,16
    800000f0:	8082                	ret

00000000800000f2 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000f2:	715d                	addi	sp,sp,-80
    800000f4:	e486                	sd	ra,72(sp)
    800000f6:	e0a2                	sd	s0,64(sp)
    800000f8:	fc26                	sd	s1,56(sp)
    800000fa:	f84a                	sd	s2,48(sp)
    800000fc:	f44e                	sd	s3,40(sp)
    800000fe:	f052                	sd	s4,32(sp)
    80000100:	ec56                	sd	s5,24(sp)
    80000102:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000104:	04c05663          	blez	a2,80000150 <consolewrite+0x5e>
    80000108:	8a2a                	mv	s4,a0
    8000010a:	892e                	mv	s2,a1
    8000010c:	89b2                	mv	s3,a2
    8000010e:	4481                	li	s1,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000110:	5afd                	li	s5,-1
    80000112:	4685                	li	a3,1
    80000114:	864a                	mv	a2,s2
    80000116:	85d2                	mv	a1,s4
    80000118:	fbf40513          	addi	a0,s0,-65
    8000011c:	00002097          	auipc	ra,0x2
    80000120:	3fc080e7          	jalr	1020(ra) # 80002518 <either_copyin>
    80000124:	01550c63          	beq	a0,s5,8000013c <consolewrite+0x4a>
      break;
    uartputc(c);
    80000128:	fbf44503          	lbu	a0,-65(s0)
    8000012c:	00000097          	auipc	ra,0x0
    80000130:	7d2080e7          	jalr	2002(ra) # 800008fe <uartputc>
  for(i = 0; i < n; i++){
    80000134:	2485                	addiw	s1,s1,1
    80000136:	0905                	addi	s2,s2,1
    80000138:	fc999de3          	bne	s3,s1,80000112 <consolewrite+0x20>
  }

  return i;
}
    8000013c:	8526                	mv	a0,s1
    8000013e:	60a6                	ld	ra,72(sp)
    80000140:	6406                	ld	s0,64(sp)
    80000142:	74e2                	ld	s1,56(sp)
    80000144:	7942                	ld	s2,48(sp)
    80000146:	79a2                	ld	s3,40(sp)
    80000148:	7a02                	ld	s4,32(sp)
    8000014a:	6ae2                	ld	s5,24(sp)
    8000014c:	6161                	addi	sp,sp,80
    8000014e:	8082                	ret
  for(i = 0; i < n; i++){
    80000150:	4481                	li	s1,0
    80000152:	b7ed                	j	8000013c <consolewrite+0x4a>

0000000080000154 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000154:	7119                	addi	sp,sp,-128
    80000156:	fc86                	sd	ra,120(sp)
    80000158:	f8a2                	sd	s0,112(sp)
    8000015a:	f4a6                	sd	s1,104(sp)
    8000015c:	f0ca                	sd	s2,96(sp)
    8000015e:	ecce                	sd	s3,88(sp)
    80000160:	e8d2                	sd	s4,80(sp)
    80000162:	e4d6                	sd	s5,72(sp)
    80000164:	e0da                	sd	s6,64(sp)
    80000166:	fc5e                	sd	s7,56(sp)
    80000168:	f862                	sd	s8,48(sp)
    8000016a:	f466                	sd	s9,40(sp)
    8000016c:	f06a                	sd	s10,32(sp)
    8000016e:	ec6e                	sd	s11,24(sp)
    80000170:	0100                	addi	s0,sp,128
    80000172:	8caa                	mv	s9,a0
    80000174:	8aae                	mv	s5,a1
    80000176:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000178:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000017c:	00011517          	auipc	a0,0x11
    80000180:	00450513          	addi	a0,a0,4 # 80011180 <cons>
    80000184:	00001097          	auipc	ra,0x1
    80000188:	a9c080e7          	jalr	-1380(ra) # 80000c20 <acquire>
  while(n > 0){
    8000018c:	09405663          	blez	s4,80000218 <consoleread+0xc4>
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000190:	00011497          	auipc	s1,0x11
    80000194:	ff048493          	addi	s1,s1,-16 # 80011180 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000198:	89a6                	mv	s3,s1
    8000019a:	00011917          	auipc	s2,0x11
    8000019e:	07e90913          	addi	s2,s2,126 # 80011218 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800001a2:	4c11                	li	s8,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001a4:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001a6:	4da9                	li	s11,10
    while(cons.r == cons.w){
    800001a8:	0984a783          	lw	a5,152(s1)
    800001ac:	09c4a703          	lw	a4,156(s1)
    800001b0:	02f71463          	bne	a4,a5,800001d8 <consoleread+0x84>
      if(myproc()->killed){
    800001b4:	00002097          	auipc	ra,0x2
    800001b8:	8a4080e7          	jalr	-1884(ra) # 80001a58 <myproc>
    800001bc:	551c                	lw	a5,40(a0)
    800001be:	eba5                	bnez	a5,8000022e <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    800001c0:	85ce                	mv	a1,s3
    800001c2:	854a                	mv	a0,s2
    800001c4:	00002097          	auipc	ra,0x2
    800001c8:	f58080e7          	jalr	-168(ra) # 8000211c <sleep>
    while(cons.r == cons.w){
    800001cc:	0984a783          	lw	a5,152(s1)
    800001d0:	09c4a703          	lw	a4,156(s1)
    800001d4:	fef700e3          	beq	a4,a5,800001b4 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800001d8:	0017871b          	addiw	a4,a5,1
    800001dc:	08e4ac23          	sw	a4,152(s1)
    800001e0:	07f7f713          	andi	a4,a5,127
    800001e4:	9726                	add	a4,a4,s1
    800001e6:	01874703          	lbu	a4,24(a4)
    800001ea:	00070b9b          	sext.w	s7,a4
    if(c == C('D')){  // end-of-file
    800001ee:	078b8863          	beq	s7,s8,8000025e <consoleread+0x10a>
    cbuf = c;
    800001f2:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001f6:	4685                	li	a3,1
    800001f8:	f8f40613          	addi	a2,s0,-113
    800001fc:	85d6                	mv	a1,s5
    800001fe:	8566                	mv	a0,s9
    80000200:	00002097          	auipc	ra,0x2
    80000204:	2c2080e7          	jalr	706(ra) # 800024c2 <either_copyout>
    80000208:	01a50863          	beq	a0,s10,80000218 <consoleread+0xc4>
    dst++;
    8000020c:	0a85                	addi	s5,s5,1
    --n;
    8000020e:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80000210:	01bb8463          	beq	s7,s11,80000218 <consoleread+0xc4>
  while(n > 0){
    80000214:	f80a1ae3          	bnez	s4,800001a8 <consoleread+0x54>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000218:	00011517          	auipc	a0,0x11
    8000021c:	f6850513          	addi	a0,a0,-152 # 80011180 <cons>
    80000220:	00001097          	auipc	ra,0x1
    80000224:	ab4080e7          	jalr	-1356(ra) # 80000cd4 <release>

  return target - n;
    80000228:	414b053b          	subw	a0,s6,s4
    8000022c:	a811                	j	80000240 <consoleread+0xec>
        release(&cons.lock);
    8000022e:	00011517          	auipc	a0,0x11
    80000232:	f5250513          	addi	a0,a0,-174 # 80011180 <cons>
    80000236:	00001097          	auipc	ra,0x1
    8000023a:	a9e080e7          	jalr	-1378(ra) # 80000cd4 <release>
        return -1;
    8000023e:	557d                	li	a0,-1
}
    80000240:	70e6                	ld	ra,120(sp)
    80000242:	7446                	ld	s0,112(sp)
    80000244:	74a6                	ld	s1,104(sp)
    80000246:	7906                	ld	s2,96(sp)
    80000248:	69e6                	ld	s3,88(sp)
    8000024a:	6a46                	ld	s4,80(sp)
    8000024c:	6aa6                	ld	s5,72(sp)
    8000024e:	6b06                	ld	s6,64(sp)
    80000250:	7be2                	ld	s7,56(sp)
    80000252:	7c42                	ld	s8,48(sp)
    80000254:	7ca2                	ld	s9,40(sp)
    80000256:	7d02                	ld	s10,32(sp)
    80000258:	6de2                	ld	s11,24(sp)
    8000025a:	6109                	addi	sp,sp,128
    8000025c:	8082                	ret
      if(n < target){
    8000025e:	000a071b          	sext.w	a4,s4
    80000262:	fb677be3          	bleu	s6,a4,80000218 <consoleread+0xc4>
        cons.r--;
    80000266:	00011717          	auipc	a4,0x11
    8000026a:	faf72923          	sw	a5,-78(a4) # 80011218 <cons+0x98>
    8000026e:	b76d                	j	80000218 <consoleread+0xc4>

0000000080000270 <consputc>:
{
    80000270:	1141                	addi	sp,sp,-16
    80000272:	e406                	sd	ra,8(sp)
    80000274:	e022                	sd	s0,0(sp)
    80000276:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000278:	10000793          	li	a5,256
    8000027c:	00f50a63          	beq	a0,a5,80000290 <consputc+0x20>
    uartputc_sync(c);
    80000280:	00000097          	auipc	ra,0x0
    80000284:	58a080e7          	jalr	1418(ra) # 8000080a <uartputc_sync>
}
    80000288:	60a2                	ld	ra,8(sp)
    8000028a:	6402                	ld	s0,0(sp)
    8000028c:	0141                	addi	sp,sp,16
    8000028e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000290:	4521                	li	a0,8
    80000292:	00000097          	auipc	ra,0x0
    80000296:	578080e7          	jalr	1400(ra) # 8000080a <uartputc_sync>
    8000029a:	02000513          	li	a0,32
    8000029e:	00000097          	auipc	ra,0x0
    800002a2:	56c080e7          	jalr	1388(ra) # 8000080a <uartputc_sync>
    800002a6:	4521                	li	a0,8
    800002a8:	00000097          	auipc	ra,0x0
    800002ac:	562080e7          	jalr	1378(ra) # 8000080a <uartputc_sync>
    800002b0:	bfe1                	j	80000288 <consputc+0x18>

00000000800002b2 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002b2:	1101                	addi	sp,sp,-32
    800002b4:	ec06                	sd	ra,24(sp)
    800002b6:	e822                	sd	s0,16(sp)
    800002b8:	e426                	sd	s1,8(sp)
    800002ba:	e04a                	sd	s2,0(sp)
    800002bc:	1000                	addi	s0,sp,32
    800002be:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002c0:	00011517          	auipc	a0,0x11
    800002c4:	ec050513          	addi	a0,a0,-320 # 80011180 <cons>
    800002c8:	00001097          	auipc	ra,0x1
    800002cc:	958080e7          	jalr	-1704(ra) # 80000c20 <acquire>

  switch(c){
    800002d0:	47c1                	li	a5,16
    800002d2:	12f48463          	beq	s1,a5,800003fa <consoleintr+0x148>
    800002d6:	0297df63          	ble	s1,a5,80000314 <consoleintr+0x62>
    800002da:	47d5                	li	a5,21
    800002dc:	0af48863          	beq	s1,a5,8000038c <consoleintr+0xda>
    800002e0:	07f00793          	li	a5,127
    800002e4:	02f49b63          	bne	s1,a5,8000031a <consoleintr+0x68>
      consputc(BACKSPACE);
    }
    break;
  case C('H'): // Backspace
  case '\x7f':
    if(cons.e != cons.w){
    800002e8:	00011717          	auipc	a4,0x11
    800002ec:	e9870713          	addi	a4,a4,-360 # 80011180 <cons>
    800002f0:	0a072783          	lw	a5,160(a4)
    800002f4:	09c72703          	lw	a4,156(a4)
    800002f8:	10f70563          	beq	a4,a5,80000402 <consoleintr+0x150>
      cons.e--;
    800002fc:	37fd                	addiw	a5,a5,-1
    800002fe:	00011717          	auipc	a4,0x11
    80000302:	f2f72123          	sw	a5,-222(a4) # 80011220 <cons+0xa0>
      consputc(BACKSPACE);
    80000306:	10000513          	li	a0,256
    8000030a:	00000097          	auipc	ra,0x0
    8000030e:	f66080e7          	jalr	-154(ra) # 80000270 <consputc>
    80000312:	a8c5                	j	80000402 <consoleintr+0x150>
  switch(c){
    80000314:	47a1                	li	a5,8
    80000316:	fcf489e3          	beq	s1,a5,800002e8 <consoleintr+0x36>
    }
    break;
  default:
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000031a:	c4e5                	beqz	s1,80000402 <consoleintr+0x150>
    8000031c:	00011717          	auipc	a4,0x11
    80000320:	e6470713          	addi	a4,a4,-412 # 80011180 <cons>
    80000324:	0a072783          	lw	a5,160(a4)
    80000328:	09872703          	lw	a4,152(a4)
    8000032c:	9f99                	subw	a5,a5,a4
    8000032e:	07f00713          	li	a4,127
    80000332:	0cf76863          	bltu	a4,a5,80000402 <consoleintr+0x150>
      c = (c == '\r') ? '\n' : c;
    80000336:	47b5                	li	a5,13
    80000338:	0ef48363          	beq	s1,a5,8000041e <consoleintr+0x16c>

      // echo back to the user.
      consputc(c);
    8000033c:	8526                	mv	a0,s1
    8000033e:	00000097          	auipc	ra,0x0
    80000342:	f32080e7          	jalr	-206(ra) # 80000270 <consputc>

      // store for consumption by consoleread().
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000346:	00011797          	auipc	a5,0x11
    8000034a:	e3a78793          	addi	a5,a5,-454 # 80011180 <cons>
    8000034e:	0a07a703          	lw	a4,160(a5)
    80000352:	0017069b          	addiw	a3,a4,1
    80000356:	0006861b          	sext.w	a2,a3
    8000035a:	0ad7a023          	sw	a3,160(a5)
    8000035e:	07f77713          	andi	a4,a4,127
    80000362:	97ba                	add	a5,a5,a4
    80000364:	00978c23          	sb	s1,24(a5)

      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80000368:	47a9                	li	a5,10
    8000036a:	0ef48163          	beq	s1,a5,8000044c <consoleintr+0x19a>
    8000036e:	4791                	li	a5,4
    80000370:	0cf48e63          	beq	s1,a5,8000044c <consoleintr+0x19a>
    80000374:	00011797          	auipc	a5,0x11
    80000378:	e0c78793          	addi	a5,a5,-500 # 80011180 <cons>
    8000037c:	0987a783          	lw	a5,152(a5)
    80000380:	0807879b          	addiw	a5,a5,128
    80000384:	06f61f63          	bne	a2,a5,80000402 <consoleintr+0x150>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000388:	863e                	mv	a2,a5
    8000038a:	a0c9                	j	8000044c <consoleintr+0x19a>
    while(cons.e != cons.w &&
    8000038c:	00011717          	auipc	a4,0x11
    80000390:	df470713          	addi	a4,a4,-524 # 80011180 <cons>
    80000394:	0a072783          	lw	a5,160(a4)
    80000398:	09c72703          	lw	a4,156(a4)
    8000039c:	06f70363          	beq	a4,a5,80000402 <consoleintr+0x150>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003a0:	37fd                	addiw	a5,a5,-1
    800003a2:	0007871b          	sext.w	a4,a5
    800003a6:	07f7f793          	andi	a5,a5,127
    800003aa:	00011697          	auipc	a3,0x11
    800003ae:	dd668693          	addi	a3,a3,-554 # 80011180 <cons>
    800003b2:	97b6                	add	a5,a5,a3
    while(cons.e != cons.w &&
    800003b4:	0187c683          	lbu	a3,24(a5)
    800003b8:	47a9                	li	a5,10
      cons.e--;
    800003ba:	00011497          	auipc	s1,0x11
    800003be:	dc648493          	addi	s1,s1,-570 # 80011180 <cons>
    while(cons.e != cons.w &&
    800003c2:	4929                	li	s2,10
    800003c4:	02f68f63          	beq	a3,a5,80000402 <consoleintr+0x150>
      cons.e--;
    800003c8:	0ae4a023          	sw	a4,160(s1)
      consputc(BACKSPACE);
    800003cc:	10000513          	li	a0,256
    800003d0:	00000097          	auipc	ra,0x0
    800003d4:	ea0080e7          	jalr	-352(ra) # 80000270 <consputc>
    while(cons.e != cons.w &&
    800003d8:	0a04a783          	lw	a5,160(s1)
    800003dc:	09c4a703          	lw	a4,156(s1)
    800003e0:	02f70163          	beq	a4,a5,80000402 <consoleintr+0x150>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003e4:	37fd                	addiw	a5,a5,-1
    800003e6:	0007871b          	sext.w	a4,a5
    800003ea:	07f7f793          	andi	a5,a5,127
    800003ee:	97a6                	add	a5,a5,s1
    while(cons.e != cons.w &&
    800003f0:	0187c783          	lbu	a5,24(a5)
    800003f4:	fd279ae3          	bne	a5,s2,800003c8 <consoleintr+0x116>
    800003f8:	a029                	j	80000402 <consoleintr+0x150>
    procdump();
    800003fa:	00002097          	auipc	ra,0x2
    800003fe:	174080e7          	jalr	372(ra) # 8000256e <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80000402:	00011517          	auipc	a0,0x11
    80000406:	d7e50513          	addi	a0,a0,-642 # 80011180 <cons>
    8000040a:	00001097          	auipc	ra,0x1
    8000040e:	8ca080e7          	jalr	-1846(ra) # 80000cd4 <release>
}
    80000412:	60e2                	ld	ra,24(sp)
    80000414:	6442                	ld	s0,16(sp)
    80000416:	64a2                	ld	s1,8(sp)
    80000418:	6902                	ld	s2,0(sp)
    8000041a:	6105                	addi	sp,sp,32
    8000041c:	8082                	ret
      consputc(c);
    8000041e:	4529                	li	a0,10
    80000420:	00000097          	auipc	ra,0x0
    80000424:	e50080e7          	jalr	-432(ra) # 80000270 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000428:	00011797          	auipc	a5,0x11
    8000042c:	d5878793          	addi	a5,a5,-680 # 80011180 <cons>
    80000430:	0a07a703          	lw	a4,160(a5)
    80000434:	0017069b          	addiw	a3,a4,1
    80000438:	0006861b          	sext.w	a2,a3
    8000043c:	0ad7a023          	sw	a3,160(a5)
    80000440:	07f77713          	andi	a4,a4,127
    80000444:	97ba                	add	a5,a5,a4
    80000446:	4729                	li	a4,10
    80000448:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000044c:	00011797          	auipc	a5,0x11
    80000450:	dcc7a823          	sw	a2,-560(a5) # 8001121c <cons+0x9c>
        wakeup(&cons.r);
    80000454:	00011517          	auipc	a0,0x11
    80000458:	dc450513          	addi	a0,a0,-572 # 80011218 <cons+0x98>
    8000045c:	00002097          	auipc	ra,0x2
    80000460:	e4c080e7          	jalr	-436(ra) # 800022a8 <wakeup>
    80000464:	bf79                	j	80000402 <consoleintr+0x150>

0000000080000466 <consoleinit>:

void
consoleinit(void)
{
    80000466:	1141                	addi	sp,sp,-16
    80000468:	e406                	sd	ra,8(sp)
    8000046a:	e022                	sd	s0,0(sp)
    8000046c:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000046e:	00008597          	auipc	a1,0x8
    80000472:	ba258593          	addi	a1,a1,-1118 # 80008010 <etext+0x10>
    80000476:	00011517          	auipc	a0,0x11
    8000047a:	d0a50513          	addi	a0,a0,-758 # 80011180 <cons>
    8000047e:	00000097          	auipc	ra,0x0
    80000482:	712080e7          	jalr	1810(ra) # 80000b90 <initlock>

  uartinit();
    80000486:	00000097          	auipc	ra,0x0
    8000048a:	334080e7          	jalr	820(ra) # 800007ba <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000048e:	00021797          	auipc	a5,0x21
    80000492:	e8a78793          	addi	a5,a5,-374 # 80021318 <devsw>
    80000496:	00000717          	auipc	a4,0x0
    8000049a:	cbe70713          	addi	a4,a4,-834 # 80000154 <consoleread>
    8000049e:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800004a0:	00000717          	auipc	a4,0x0
    800004a4:	c5270713          	addi	a4,a4,-942 # 800000f2 <consolewrite>
    800004a8:	ef98                	sd	a4,24(a5)
}
    800004aa:	60a2                	ld	ra,8(sp)
    800004ac:	6402                	ld	s0,0(sp)
    800004ae:	0141                	addi	sp,sp,16
    800004b0:	8082                	ret

00000000800004b2 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004b2:	7179                	addi	sp,sp,-48
    800004b4:	f406                	sd	ra,40(sp)
    800004b6:	f022                	sd	s0,32(sp)
    800004b8:	ec26                	sd	s1,24(sp)
    800004ba:	e84a                	sd	s2,16(sp)
    800004bc:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004be:	c219                	beqz	a2,800004c4 <printint+0x12>
    800004c0:	00054d63          	bltz	a0,800004da <printint+0x28>
    x = -xx;
  else
    x = xx;
    800004c4:	2501                	sext.w	a0,a0
    800004c6:	4881                	li	a7,0
    800004c8:	fd040713          	addi	a4,s0,-48

  i = 0;
    800004cc:	4601                	li	a2,0
  do {
    buf[i++] = digits[x % base];
    800004ce:	2581                	sext.w	a1,a1
    800004d0:	00008817          	auipc	a6,0x8
    800004d4:	b4880813          	addi	a6,a6,-1208 # 80008018 <digits>
    800004d8:	a801                	j	800004e8 <printint+0x36>
    x = -xx;
    800004da:	40a0053b          	negw	a0,a0
    800004de:	2501                	sext.w	a0,a0
  if(sign && (sign = xx < 0))
    800004e0:	4885                	li	a7,1
    x = -xx;
    800004e2:	b7dd                	j	800004c8 <printint+0x16>
  } while((x /= base) != 0);
    800004e4:	853e                	mv	a0,a5
    buf[i++] = digits[x % base];
    800004e6:	8636                	mv	a2,a3
    800004e8:	0016069b          	addiw	a3,a2,1
    800004ec:	02b577bb          	remuw	a5,a0,a1
    800004f0:	1782                	slli	a5,a5,0x20
    800004f2:	9381                	srli	a5,a5,0x20
    800004f4:	97c2                	add	a5,a5,a6
    800004f6:	0007c783          	lbu	a5,0(a5)
    800004fa:	00f70023          	sb	a5,0(a4)
    800004fe:	0705                	addi	a4,a4,1
  } while((x /= base) != 0);
    80000500:	02b557bb          	divuw	a5,a0,a1
    80000504:	feb570e3          	bleu	a1,a0,800004e4 <printint+0x32>

  if(sign)
    80000508:	00088b63          	beqz	a7,8000051e <printint+0x6c>
    buf[i++] = '-';
    8000050c:	fe040793          	addi	a5,s0,-32
    80000510:	96be                	add	a3,a3,a5
    80000512:	02d00793          	li	a5,45
    80000516:	fef68823          	sb	a5,-16(a3)
    8000051a:	0026069b          	addiw	a3,a2,2

  while(--i >= 0)
    8000051e:	02d05763          	blez	a3,8000054c <printint+0x9a>
    80000522:	fd040793          	addi	a5,s0,-48
    80000526:	00d784b3          	add	s1,a5,a3
    8000052a:	fff78913          	addi	s2,a5,-1
    8000052e:	9936                	add	s2,s2,a3
    80000530:	36fd                	addiw	a3,a3,-1
    80000532:	1682                	slli	a3,a3,0x20
    80000534:	9281                	srli	a3,a3,0x20
    80000536:	40d90933          	sub	s2,s2,a3
    consputc(buf[i]);
    8000053a:	fff4c503          	lbu	a0,-1(s1)
    8000053e:	00000097          	auipc	ra,0x0
    80000542:	d32080e7          	jalr	-718(ra) # 80000270 <consputc>
    80000546:	14fd                	addi	s1,s1,-1
  while(--i >= 0)
    80000548:	ff2499e3          	bne	s1,s2,8000053a <printint+0x88>
}
    8000054c:	70a2                	ld	ra,40(sp)
    8000054e:	7402                	ld	s0,32(sp)
    80000550:	64e2                	ld	s1,24(sp)
    80000552:	6942                	ld	s2,16(sp)
    80000554:	6145                	addi	sp,sp,48
    80000556:	8082                	ret

0000000080000558 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000558:	1101                	addi	sp,sp,-32
    8000055a:	ec06                	sd	ra,24(sp)
    8000055c:	e822                	sd	s0,16(sp)
    8000055e:	e426                	sd	s1,8(sp)
    80000560:	1000                	addi	s0,sp,32
    80000562:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000564:	00011797          	auipc	a5,0x11
    80000568:	cc07ae23          	sw	zero,-804(a5) # 80011240 <pr+0x18>
  printf("panic: ");
    8000056c:	00008517          	auipc	a0,0x8
    80000570:	ac450513          	addi	a0,a0,-1340 # 80008030 <digits+0x18>
    80000574:	00000097          	auipc	ra,0x0
    80000578:	02e080e7          	jalr	46(ra) # 800005a2 <printf>
  printf(s);
    8000057c:	8526                	mv	a0,s1
    8000057e:	00000097          	auipc	ra,0x0
    80000582:	024080e7          	jalr	36(ra) # 800005a2 <printf>
  printf("\n");
    80000586:	00008517          	auipc	a0,0x8
    8000058a:	b4250513          	addi	a0,a0,-1214 # 800080c8 <digits+0xb0>
    8000058e:	00000097          	auipc	ra,0x0
    80000592:	014080e7          	jalr	20(ra) # 800005a2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000596:	4785                	li	a5,1
    80000598:	00009717          	auipc	a4,0x9
    8000059c:	a6f72423          	sw	a5,-1432(a4) # 80009000 <panicked>
  for(;;)
    ;
    800005a0:	a001                	j	800005a0 <panic+0x48>

00000000800005a2 <printf>:
{
    800005a2:	7131                	addi	sp,sp,-192
    800005a4:	fc86                	sd	ra,120(sp)
    800005a6:	f8a2                	sd	s0,112(sp)
    800005a8:	f4a6                	sd	s1,104(sp)
    800005aa:	f0ca                	sd	s2,96(sp)
    800005ac:	ecce                	sd	s3,88(sp)
    800005ae:	e8d2                	sd	s4,80(sp)
    800005b0:	e4d6                	sd	s5,72(sp)
    800005b2:	e0da                	sd	s6,64(sp)
    800005b4:	fc5e                	sd	s7,56(sp)
    800005b6:	f862                	sd	s8,48(sp)
    800005b8:	f466                	sd	s9,40(sp)
    800005ba:	f06a                	sd	s10,32(sp)
    800005bc:	ec6e                	sd	s11,24(sp)
    800005be:	0100                	addi	s0,sp,128
    800005c0:	8aaa                	mv	s5,a0
    800005c2:	e40c                	sd	a1,8(s0)
    800005c4:	e810                	sd	a2,16(s0)
    800005c6:	ec14                	sd	a3,24(s0)
    800005c8:	f018                	sd	a4,32(s0)
    800005ca:	f41c                	sd	a5,40(s0)
    800005cc:	03043823          	sd	a6,48(s0)
    800005d0:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005d4:	00011797          	auipc	a5,0x11
    800005d8:	c5478793          	addi	a5,a5,-940 # 80011228 <pr>
    800005dc:	0187ad83          	lw	s11,24(a5)
  if(locking)
    800005e0:	020d9b63          	bnez	s11,80000616 <printf+0x74>
  if (fmt == 0)
    800005e4:	020a8f63          	beqz	s5,80000622 <printf+0x80>
  va_start(ap, fmt);
    800005e8:	00840793          	addi	a5,s0,8
    800005ec:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005f0:	000ac503          	lbu	a0,0(s5)
    800005f4:	16050063          	beqz	a0,80000754 <printf+0x1b2>
    800005f8:	4481                	li	s1,0
    if(c != '%'){
    800005fa:	02500a13          	li	s4,37
    switch(c){
    800005fe:	07000b13          	li	s6,112
  consputc('x');
    80000602:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000604:	00008b97          	auipc	s7,0x8
    80000608:	a14b8b93          	addi	s7,s7,-1516 # 80008018 <digits>
    switch(c){
    8000060c:	07300c93          	li	s9,115
    80000610:	06400c13          	li	s8,100
    80000614:	a815                	j	80000648 <printf+0xa6>
    acquire(&pr.lock);
    80000616:	853e                	mv	a0,a5
    80000618:	00000097          	auipc	ra,0x0
    8000061c:	608080e7          	jalr	1544(ra) # 80000c20 <acquire>
    80000620:	b7d1                	j	800005e4 <printf+0x42>
    panic("null fmt");
    80000622:	00008517          	auipc	a0,0x8
    80000626:	a1e50513          	addi	a0,a0,-1506 # 80008040 <digits+0x28>
    8000062a:	00000097          	auipc	ra,0x0
    8000062e:	f2e080e7          	jalr	-210(ra) # 80000558 <panic>
      consputc(c);
    80000632:	00000097          	auipc	ra,0x0
    80000636:	c3e080e7          	jalr	-962(ra) # 80000270 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000063a:	2485                	addiw	s1,s1,1
    8000063c:	009a87b3          	add	a5,s5,s1
    80000640:	0007c503          	lbu	a0,0(a5)
    80000644:	10050863          	beqz	a0,80000754 <printf+0x1b2>
    if(c != '%'){
    80000648:	ff4515e3          	bne	a0,s4,80000632 <printf+0x90>
    c = fmt[++i] & 0xff;
    8000064c:	2485                	addiw	s1,s1,1
    8000064e:	009a87b3          	add	a5,s5,s1
    80000652:	0007c783          	lbu	a5,0(a5)
    80000656:	0007891b          	sext.w	s2,a5
    if(c == 0)
    8000065a:	0e090d63          	beqz	s2,80000754 <printf+0x1b2>
    switch(c){
    8000065e:	05678a63          	beq	a5,s6,800006b2 <printf+0x110>
    80000662:	02fb7663          	bleu	a5,s6,8000068e <printf+0xec>
    80000666:	09978963          	beq	a5,s9,800006f8 <printf+0x156>
    8000066a:	07800713          	li	a4,120
    8000066e:	0ce79863          	bne	a5,a4,8000073e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80000672:	f8843783          	ld	a5,-120(s0)
    80000676:	00878713          	addi	a4,a5,8
    8000067a:	f8e43423          	sd	a4,-120(s0)
    8000067e:	4605                	li	a2,1
    80000680:	85ea                	mv	a1,s10
    80000682:	4388                	lw	a0,0(a5)
    80000684:	00000097          	auipc	ra,0x0
    80000688:	e2e080e7          	jalr	-466(ra) # 800004b2 <printint>
      break;
    8000068c:	b77d                	j	8000063a <printf+0x98>
    switch(c){
    8000068e:	0b478263          	beq	a5,s4,80000732 <printf+0x190>
    80000692:	0b879663          	bne	a5,s8,8000073e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80000696:	f8843783          	ld	a5,-120(s0)
    8000069a:	00878713          	addi	a4,a5,8
    8000069e:	f8e43423          	sd	a4,-120(s0)
    800006a2:	4605                	li	a2,1
    800006a4:	45a9                	li	a1,10
    800006a6:	4388                	lw	a0,0(a5)
    800006a8:	00000097          	auipc	ra,0x0
    800006ac:	e0a080e7          	jalr	-502(ra) # 800004b2 <printint>
      break;
    800006b0:	b769                	j	8000063a <printf+0x98>
      printptr(va_arg(ap, uint64));
    800006b2:	f8843783          	ld	a5,-120(s0)
    800006b6:	00878713          	addi	a4,a5,8
    800006ba:	f8e43423          	sd	a4,-120(s0)
    800006be:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006c2:	03000513          	li	a0,48
    800006c6:	00000097          	auipc	ra,0x0
    800006ca:	baa080e7          	jalr	-1110(ra) # 80000270 <consputc>
  consputc('x');
    800006ce:	07800513          	li	a0,120
    800006d2:	00000097          	auipc	ra,0x0
    800006d6:	b9e080e7          	jalr	-1122(ra) # 80000270 <consputc>
    800006da:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006dc:	03c9d793          	srli	a5,s3,0x3c
    800006e0:	97de                	add	a5,a5,s7
    800006e2:	0007c503          	lbu	a0,0(a5)
    800006e6:	00000097          	auipc	ra,0x0
    800006ea:	b8a080e7          	jalr	-1142(ra) # 80000270 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006ee:	0992                	slli	s3,s3,0x4
    800006f0:	397d                	addiw	s2,s2,-1
    800006f2:	fe0915e3          	bnez	s2,800006dc <printf+0x13a>
    800006f6:	b791                	j	8000063a <printf+0x98>
      if((s = va_arg(ap, char*)) == 0)
    800006f8:	f8843783          	ld	a5,-120(s0)
    800006fc:	00878713          	addi	a4,a5,8
    80000700:	f8e43423          	sd	a4,-120(s0)
    80000704:	0007b903          	ld	s2,0(a5)
    80000708:	00090e63          	beqz	s2,80000724 <printf+0x182>
      for(; *s; s++)
    8000070c:	00094503          	lbu	a0,0(s2)
    80000710:	d50d                	beqz	a0,8000063a <printf+0x98>
        consputc(*s);
    80000712:	00000097          	auipc	ra,0x0
    80000716:	b5e080e7          	jalr	-1186(ra) # 80000270 <consputc>
      for(; *s; s++)
    8000071a:	0905                	addi	s2,s2,1
    8000071c:	00094503          	lbu	a0,0(s2)
    80000720:	f96d                	bnez	a0,80000712 <printf+0x170>
    80000722:	bf21                	j	8000063a <printf+0x98>
        s = "(null)";
    80000724:	00008917          	auipc	s2,0x8
    80000728:	91490913          	addi	s2,s2,-1772 # 80008038 <digits+0x20>
      for(; *s; s++)
    8000072c:	02800513          	li	a0,40
    80000730:	b7cd                	j	80000712 <printf+0x170>
      consputc('%');
    80000732:	8552                	mv	a0,s4
    80000734:	00000097          	auipc	ra,0x0
    80000738:	b3c080e7          	jalr	-1220(ra) # 80000270 <consputc>
      break;
    8000073c:	bdfd                	j	8000063a <printf+0x98>
      consputc('%');
    8000073e:	8552                	mv	a0,s4
    80000740:	00000097          	auipc	ra,0x0
    80000744:	b30080e7          	jalr	-1232(ra) # 80000270 <consputc>
      consputc(c);
    80000748:	854a                	mv	a0,s2
    8000074a:	00000097          	auipc	ra,0x0
    8000074e:	b26080e7          	jalr	-1242(ra) # 80000270 <consputc>
      break;
    80000752:	b5e5                	j	8000063a <printf+0x98>
  if(locking)
    80000754:	020d9163          	bnez	s11,80000776 <printf+0x1d4>
}
    80000758:	70e6                	ld	ra,120(sp)
    8000075a:	7446                	ld	s0,112(sp)
    8000075c:	74a6                	ld	s1,104(sp)
    8000075e:	7906                	ld	s2,96(sp)
    80000760:	69e6                	ld	s3,88(sp)
    80000762:	6a46                	ld	s4,80(sp)
    80000764:	6aa6                	ld	s5,72(sp)
    80000766:	6b06                	ld	s6,64(sp)
    80000768:	7be2                	ld	s7,56(sp)
    8000076a:	7c42                	ld	s8,48(sp)
    8000076c:	7ca2                	ld	s9,40(sp)
    8000076e:	7d02                	ld	s10,32(sp)
    80000770:	6de2                	ld	s11,24(sp)
    80000772:	6129                	addi	sp,sp,192
    80000774:	8082                	ret
    release(&pr.lock);
    80000776:	00011517          	auipc	a0,0x11
    8000077a:	ab250513          	addi	a0,a0,-1358 # 80011228 <pr>
    8000077e:	00000097          	auipc	ra,0x0
    80000782:	556080e7          	jalr	1366(ra) # 80000cd4 <release>
}
    80000786:	bfc9                	j	80000758 <printf+0x1b6>

0000000080000788 <printfinit>:
}

void
printfinit(void)
{
    80000788:	1101                	addi	sp,sp,-32
    8000078a:	ec06                	sd	ra,24(sp)
    8000078c:	e822                	sd	s0,16(sp)
    8000078e:	e426                	sd	s1,8(sp)
    80000790:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80000792:	00011497          	auipc	s1,0x11
    80000796:	a9648493          	addi	s1,s1,-1386 # 80011228 <pr>
    8000079a:	00008597          	auipc	a1,0x8
    8000079e:	8b658593          	addi	a1,a1,-1866 # 80008050 <digits+0x38>
    800007a2:	8526                	mv	a0,s1
    800007a4:	00000097          	auipc	ra,0x0
    800007a8:	3ec080e7          	jalr	1004(ra) # 80000b90 <initlock>
  pr.locking = 1;
    800007ac:	4785                	li	a5,1
    800007ae:	cc9c                	sw	a5,24(s1)
}
    800007b0:	60e2                	ld	ra,24(sp)
    800007b2:	6442                	ld	s0,16(sp)
    800007b4:	64a2                	ld	s1,8(sp)
    800007b6:	6105                	addi	sp,sp,32
    800007b8:	8082                	ret

00000000800007ba <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007ba:	1141                	addi	sp,sp,-16
    800007bc:	e406                	sd	ra,8(sp)
    800007be:	e022                	sd	s0,0(sp)
    800007c0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007c2:	100007b7          	lui	a5,0x10000
    800007c6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007ca:	f8000713          	li	a4,-128
    800007ce:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007d2:	470d                	li	a4,3
    800007d4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007d8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007dc:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007e0:	469d                	li	a3,7
    800007e2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007e6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007ea:	00008597          	auipc	a1,0x8
    800007ee:	86e58593          	addi	a1,a1,-1938 # 80008058 <digits+0x40>
    800007f2:	00011517          	auipc	a0,0x11
    800007f6:	a5650513          	addi	a0,a0,-1450 # 80011248 <uart_tx_lock>
    800007fa:	00000097          	auipc	ra,0x0
    800007fe:	396080e7          	jalr	918(ra) # 80000b90 <initlock>
}
    80000802:	60a2                	ld	ra,8(sp)
    80000804:	6402                	ld	s0,0(sp)
    80000806:	0141                	addi	sp,sp,16
    80000808:	8082                	ret

000000008000080a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000080a:	1101                	addi	sp,sp,-32
    8000080c:	ec06                	sd	ra,24(sp)
    8000080e:	e822                	sd	s0,16(sp)
    80000810:	e426                	sd	s1,8(sp)
    80000812:	1000                	addi	s0,sp,32
    80000814:	84aa                	mv	s1,a0
  push_off();
    80000816:	00000097          	auipc	ra,0x0
    8000081a:	3be080e7          	jalr	958(ra) # 80000bd4 <push_off>

  if(panicked){
    8000081e:	00008797          	auipc	a5,0x8
    80000822:	7e278793          	addi	a5,a5,2018 # 80009000 <panicked>
    80000826:	439c                	lw	a5,0(a5)
    80000828:	2781                	sext.w	a5,a5
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000082a:	10000737          	lui	a4,0x10000
  if(panicked){
    8000082e:	c391                	beqz	a5,80000832 <uartputc_sync+0x28>
      ;
    80000830:	a001                	j	80000830 <uartputc_sync+0x26>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000832:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000836:	0ff7f793          	andi	a5,a5,255
    8000083a:	0207f793          	andi	a5,a5,32
    8000083e:	dbf5                	beqz	a5,80000832 <uartputc_sync+0x28>
    ;
  WriteReg(THR, c);
    80000840:	0ff4f793          	andi	a5,s1,255
    80000844:	10000737          	lui	a4,0x10000
    80000848:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    8000084c:	00000097          	auipc	ra,0x0
    80000850:	428080e7          	jalr	1064(ra) # 80000c74 <pop_off>
}
    80000854:	60e2                	ld	ra,24(sp)
    80000856:	6442                	ld	s0,16(sp)
    80000858:	64a2                	ld	s1,8(sp)
    8000085a:	6105                	addi	sp,sp,32
    8000085c:	8082                	ret

000000008000085e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000085e:	00008797          	auipc	a5,0x8
    80000862:	7aa78793          	addi	a5,a5,1962 # 80009008 <uart_tx_r>
    80000866:	639c                	ld	a5,0(a5)
    80000868:	00008717          	auipc	a4,0x8
    8000086c:	7a870713          	addi	a4,a4,1960 # 80009010 <uart_tx_w>
    80000870:	6318                	ld	a4,0(a4)
    80000872:	08f70563          	beq	a4,a5,800008fc <uartstart+0x9e>
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000876:	10000737          	lui	a4,0x10000
    8000087a:	00574703          	lbu	a4,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000087e:	0ff77713          	andi	a4,a4,255
    80000882:	02077713          	andi	a4,a4,32
    80000886:	cb3d                	beqz	a4,800008fc <uartstart+0x9e>
{
    80000888:	7139                	addi	sp,sp,-64
    8000088a:	fc06                	sd	ra,56(sp)
    8000088c:	f822                	sd	s0,48(sp)
    8000088e:	f426                	sd	s1,40(sp)
    80000890:	f04a                	sd	s2,32(sp)
    80000892:	ec4e                	sd	s3,24(sp)
    80000894:	e852                	sd	s4,16(sp)
    80000896:	e456                	sd	s5,8(sp)
    80000898:	0080                	addi	s0,sp,64
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000089a:	00011a17          	auipc	s4,0x11
    8000089e:	9aea0a13          	addi	s4,s4,-1618 # 80011248 <uart_tx_lock>
    uart_tx_r += 1;
    800008a2:	00008497          	auipc	s1,0x8
    800008a6:	76648493          	addi	s1,s1,1894 # 80009008 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008aa:	10000937          	lui	s2,0x10000
    if(uart_tx_w == uart_tx_r){
    800008ae:	00008997          	auipc	s3,0x8
    800008b2:	76298993          	addi	s3,s3,1890 # 80009010 <uart_tx_w>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008b6:	01f7f713          	andi	a4,a5,31
    800008ba:	9752                	add	a4,a4,s4
    800008bc:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    800008c0:	0785                	addi	a5,a5,1
    800008c2:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800008c4:	8526                	mv	a0,s1
    800008c6:	00002097          	auipc	ra,0x2
    800008ca:	9e2080e7          	jalr	-1566(ra) # 800022a8 <wakeup>
    WriteReg(THR, c);
    800008ce:	01590023          	sb	s5,0(s2) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800008d2:	609c                	ld	a5,0(s1)
    800008d4:	0009b703          	ld	a4,0(s3)
    800008d8:	00f70963          	beq	a4,a5,800008ea <uartstart+0x8c>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008dc:	00594703          	lbu	a4,5(s2)
    800008e0:	0ff77713          	andi	a4,a4,255
    800008e4:	02077713          	andi	a4,a4,32
    800008e8:	f779                	bnez	a4,800008b6 <uartstart+0x58>
  }
}
    800008ea:	70e2                	ld	ra,56(sp)
    800008ec:	7442                	ld	s0,48(sp)
    800008ee:	74a2                	ld	s1,40(sp)
    800008f0:	7902                	ld	s2,32(sp)
    800008f2:	69e2                	ld	s3,24(sp)
    800008f4:	6a42                	ld	s4,16(sp)
    800008f6:	6aa2                	ld	s5,8(sp)
    800008f8:	6121                	addi	sp,sp,64
    800008fa:	8082                	ret
    800008fc:	8082                	ret

00000000800008fe <uartputc>:
{
    800008fe:	7179                	addi	sp,sp,-48
    80000900:	f406                	sd	ra,40(sp)
    80000902:	f022                	sd	s0,32(sp)
    80000904:	ec26                	sd	s1,24(sp)
    80000906:	e84a                	sd	s2,16(sp)
    80000908:	e44e                	sd	s3,8(sp)
    8000090a:	e052                	sd	s4,0(sp)
    8000090c:	1800                	addi	s0,sp,48
    8000090e:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80000910:	00011517          	auipc	a0,0x11
    80000914:	93850513          	addi	a0,a0,-1736 # 80011248 <uart_tx_lock>
    80000918:	00000097          	auipc	ra,0x0
    8000091c:	308080e7          	jalr	776(ra) # 80000c20 <acquire>
  if(panicked){
    80000920:	00008797          	auipc	a5,0x8
    80000924:	6e078793          	addi	a5,a5,1760 # 80009000 <panicked>
    80000928:	439c                	lw	a5,0(a5)
    8000092a:	2781                	sext.w	a5,a5
    8000092c:	c391                	beqz	a5,80000930 <uartputc+0x32>
      ;
    8000092e:	a001                	j	8000092e <uartputc+0x30>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000930:	00008797          	auipc	a5,0x8
    80000934:	6e078793          	addi	a5,a5,1760 # 80009010 <uart_tx_w>
    80000938:	639c                	ld	a5,0(a5)
    8000093a:	00008717          	auipc	a4,0x8
    8000093e:	6ce70713          	addi	a4,a4,1742 # 80009008 <uart_tx_r>
    80000942:	6318                	ld	a4,0(a4)
    80000944:	02070713          	addi	a4,a4,32
    80000948:	02f71b63          	bne	a4,a5,8000097e <uartputc+0x80>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000094c:	00011a17          	auipc	s4,0x11
    80000950:	8fca0a13          	addi	s4,s4,-1796 # 80011248 <uart_tx_lock>
    80000954:	00008497          	auipc	s1,0x8
    80000958:	6b448493          	addi	s1,s1,1716 # 80009008 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000095c:	00008917          	auipc	s2,0x8
    80000960:	6b490913          	addi	s2,s2,1716 # 80009010 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000964:	85d2                	mv	a1,s4
    80000966:	8526                	mv	a0,s1
    80000968:	00001097          	auipc	ra,0x1
    8000096c:	7b4080e7          	jalr	1972(ra) # 8000211c <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000970:	00093783          	ld	a5,0(s2)
    80000974:	6098                	ld	a4,0(s1)
    80000976:	02070713          	addi	a4,a4,32
    8000097a:	fef705e3          	beq	a4,a5,80000964 <uartputc+0x66>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000097e:	00011497          	auipc	s1,0x11
    80000982:	8ca48493          	addi	s1,s1,-1846 # 80011248 <uart_tx_lock>
    80000986:	01f7f713          	andi	a4,a5,31
    8000098a:	9726                	add	a4,a4,s1
    8000098c:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    80000990:	0785                	addi	a5,a5,1
    80000992:	00008717          	auipc	a4,0x8
    80000996:	66f73f23          	sd	a5,1662(a4) # 80009010 <uart_tx_w>
      uartstart();
    8000099a:	00000097          	auipc	ra,0x0
    8000099e:	ec4080e7          	jalr	-316(ra) # 8000085e <uartstart>
      release(&uart_tx_lock);
    800009a2:	8526                	mv	a0,s1
    800009a4:	00000097          	auipc	ra,0x0
    800009a8:	330080e7          	jalr	816(ra) # 80000cd4 <release>
}
    800009ac:	70a2                	ld	ra,40(sp)
    800009ae:	7402                	ld	s0,32(sp)
    800009b0:	64e2                	ld	s1,24(sp)
    800009b2:	6942                	ld	s2,16(sp)
    800009b4:	69a2                	ld	s3,8(sp)
    800009b6:	6a02                	ld	s4,0(sp)
    800009b8:	6145                	addi	sp,sp,48
    800009ba:	8082                	ret

00000000800009bc <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009bc:	1141                	addi	sp,sp,-16
    800009be:	e422                	sd	s0,8(sp)
    800009c0:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009c2:	100007b7          	lui	a5,0x10000
    800009c6:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009ca:	8b85                	andi	a5,a5,1
    800009cc:	cb81                	beqz	a5,800009dc <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800009ce:	100007b7          	lui	a5,0x10000
    800009d2:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009d6:	6422                	ld	s0,8(sp)
    800009d8:	0141                	addi	sp,sp,16
    800009da:	8082                	ret
    return -1;
    800009dc:	557d                	li	a0,-1
    800009de:	bfe5                	j	800009d6 <uartgetc+0x1a>

00000000800009e0 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800009e0:	1101                	addi	sp,sp,-32
    800009e2:	ec06                	sd	ra,24(sp)
    800009e4:	e822                	sd	s0,16(sp)
    800009e6:	e426                	sd	s1,8(sp)
    800009e8:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009ea:	54fd                	li	s1,-1
    int c = uartgetc();
    800009ec:	00000097          	auipc	ra,0x0
    800009f0:	fd0080e7          	jalr	-48(ra) # 800009bc <uartgetc>
    if(c == -1)
    800009f4:	00950763          	beq	a0,s1,80000a02 <uartintr+0x22>
      break;
    consoleintr(c);
    800009f8:	00000097          	auipc	ra,0x0
    800009fc:	8ba080e7          	jalr	-1862(ra) # 800002b2 <consoleintr>
  while(1){
    80000a00:	b7f5                	j	800009ec <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a02:	00011497          	auipc	s1,0x11
    80000a06:	84648493          	addi	s1,s1,-1978 # 80011248 <uart_tx_lock>
    80000a0a:	8526                	mv	a0,s1
    80000a0c:	00000097          	auipc	ra,0x0
    80000a10:	214080e7          	jalr	532(ra) # 80000c20 <acquire>
  uartstart();
    80000a14:	00000097          	auipc	ra,0x0
    80000a18:	e4a080e7          	jalr	-438(ra) # 8000085e <uartstart>
  release(&uart_tx_lock);
    80000a1c:	8526                	mv	a0,s1
    80000a1e:	00000097          	auipc	ra,0x0
    80000a22:	2b6080e7          	jalr	694(ra) # 80000cd4 <release>
}
    80000a26:	60e2                	ld	ra,24(sp)
    80000a28:	6442                	ld	s0,16(sp)
    80000a2a:	64a2                	ld	s1,8(sp)
    80000a2c:	6105                	addi	sp,sp,32
    80000a2e:	8082                	ret

0000000080000a30 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a30:	1101                	addi	sp,sp,-32
    80000a32:	ec06                	sd	ra,24(sp)
    80000a34:	e822                	sd	s0,16(sp)
    80000a36:	e426                	sd	s1,8(sp)
    80000a38:	e04a                	sd	s2,0(sp)
    80000a3a:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a3c:	6785                	lui	a5,0x1
    80000a3e:	17fd                	addi	a5,a5,-1
    80000a40:	8fe9                	and	a5,a5,a0
    80000a42:	ebb9                	bnez	a5,80000a98 <kfree+0x68>
    80000a44:	84aa                	mv	s1,a0
    80000a46:	00025797          	auipc	a5,0x25
    80000a4a:	5ba78793          	addi	a5,a5,1466 # 80026000 <end>
    80000a4e:	04f56563          	bltu	a0,a5,80000a98 <kfree+0x68>
    80000a52:	47c5                	li	a5,17
    80000a54:	07ee                	slli	a5,a5,0x1b
    80000a56:	04f57163          	bleu	a5,a0,80000a98 <kfree+0x68>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a5a:	6605                	lui	a2,0x1
    80000a5c:	4585                	li	a1,1
    80000a5e:	00000097          	auipc	ra,0x0
    80000a62:	2be080e7          	jalr	702(ra) # 80000d1c <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a66:	00011917          	auipc	s2,0x11
    80000a6a:	81a90913          	addi	s2,s2,-2022 # 80011280 <kmem>
    80000a6e:	854a                	mv	a0,s2
    80000a70:	00000097          	auipc	ra,0x0
    80000a74:	1b0080e7          	jalr	432(ra) # 80000c20 <acquire>
  r->next = kmem.freelist;
    80000a78:	01893783          	ld	a5,24(s2)
    80000a7c:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a7e:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a82:	854a                	mv	a0,s2
    80000a84:	00000097          	auipc	ra,0x0
    80000a88:	250080e7          	jalr	592(ra) # 80000cd4 <release>
}
    80000a8c:	60e2                	ld	ra,24(sp)
    80000a8e:	6442                	ld	s0,16(sp)
    80000a90:	64a2                	ld	s1,8(sp)
    80000a92:	6902                	ld	s2,0(sp)
    80000a94:	6105                	addi	sp,sp,32
    80000a96:	8082                	ret
    panic("kfree");
    80000a98:	00007517          	auipc	a0,0x7
    80000a9c:	5c850513          	addi	a0,a0,1480 # 80008060 <digits+0x48>
    80000aa0:	00000097          	auipc	ra,0x0
    80000aa4:	ab8080e7          	jalr	-1352(ra) # 80000558 <panic>

0000000080000aa8 <freerange>:
{
    80000aa8:	7179                	addi	sp,sp,-48
    80000aaa:	f406                	sd	ra,40(sp)
    80000aac:	f022                	sd	s0,32(sp)
    80000aae:	ec26                	sd	s1,24(sp)
    80000ab0:	e84a                	sd	s2,16(sp)
    80000ab2:	e44e                	sd	s3,8(sp)
    80000ab4:	e052                	sd	s4,0(sp)
    80000ab6:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ab8:	6705                	lui	a4,0x1
    80000aba:	fff70793          	addi	a5,a4,-1 # fff <_entry-0x7ffff001>
    80000abe:	00f504b3          	add	s1,a0,a5
    80000ac2:	77fd                	lui	a5,0xfffff
    80000ac4:	8cfd                	and	s1,s1,a5
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ac6:	94ba                	add	s1,s1,a4
    80000ac8:	0095ee63          	bltu	a1,s1,80000ae4 <freerange+0x3c>
    80000acc:	892e                	mv	s2,a1
    kfree(p);
    80000ace:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ad0:	6985                	lui	s3,0x1
    kfree(p);
    80000ad2:	01448533          	add	a0,s1,s4
    80000ad6:	00000097          	auipc	ra,0x0
    80000ada:	f5a080e7          	jalr	-166(ra) # 80000a30 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ade:	94ce                	add	s1,s1,s3
    80000ae0:	fe9979e3          	bleu	s1,s2,80000ad2 <freerange+0x2a>
}
    80000ae4:	70a2                	ld	ra,40(sp)
    80000ae6:	7402                	ld	s0,32(sp)
    80000ae8:	64e2                	ld	s1,24(sp)
    80000aea:	6942                	ld	s2,16(sp)
    80000aec:	69a2                	ld	s3,8(sp)
    80000aee:	6a02                	ld	s4,0(sp)
    80000af0:	6145                	addi	sp,sp,48
    80000af2:	8082                	ret

0000000080000af4 <kinit>:
{
    80000af4:	1141                	addi	sp,sp,-16
    80000af6:	e406                	sd	ra,8(sp)
    80000af8:	e022                	sd	s0,0(sp)
    80000afa:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000afc:	00007597          	auipc	a1,0x7
    80000b00:	56c58593          	addi	a1,a1,1388 # 80008068 <digits+0x50>
    80000b04:	00010517          	auipc	a0,0x10
    80000b08:	77c50513          	addi	a0,a0,1916 # 80011280 <kmem>
    80000b0c:	00000097          	auipc	ra,0x0
    80000b10:	084080e7          	jalr	132(ra) # 80000b90 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b14:	45c5                	li	a1,17
    80000b16:	05ee                	slli	a1,a1,0x1b
    80000b18:	00025517          	auipc	a0,0x25
    80000b1c:	4e850513          	addi	a0,a0,1256 # 80026000 <end>
    80000b20:	00000097          	auipc	ra,0x0
    80000b24:	f88080e7          	jalr	-120(ra) # 80000aa8 <freerange>
}
    80000b28:	60a2                	ld	ra,8(sp)
    80000b2a:	6402                	ld	s0,0(sp)
    80000b2c:	0141                	addi	sp,sp,16
    80000b2e:	8082                	ret

0000000080000b30 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b30:	1101                	addi	sp,sp,-32
    80000b32:	ec06                	sd	ra,24(sp)
    80000b34:	e822                	sd	s0,16(sp)
    80000b36:	e426                	sd	s1,8(sp)
    80000b38:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b3a:	00010497          	auipc	s1,0x10
    80000b3e:	74648493          	addi	s1,s1,1862 # 80011280 <kmem>
    80000b42:	8526                	mv	a0,s1
    80000b44:	00000097          	auipc	ra,0x0
    80000b48:	0dc080e7          	jalr	220(ra) # 80000c20 <acquire>
  r = kmem.freelist;
    80000b4c:	6c84                	ld	s1,24(s1)
  if(r)
    80000b4e:	c885                	beqz	s1,80000b7e <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b50:	609c                	ld	a5,0(s1)
    80000b52:	00010517          	auipc	a0,0x10
    80000b56:	72e50513          	addi	a0,a0,1838 # 80011280 <kmem>
    80000b5a:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b5c:	00000097          	auipc	ra,0x0
    80000b60:	178080e7          	jalr	376(ra) # 80000cd4 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b64:	6605                	lui	a2,0x1
    80000b66:	4595                	li	a1,5
    80000b68:	8526                	mv	a0,s1
    80000b6a:	00000097          	auipc	ra,0x0
    80000b6e:	1b2080e7          	jalr	434(ra) # 80000d1c <memset>
  return (void*)r;
}
    80000b72:	8526                	mv	a0,s1
    80000b74:	60e2                	ld	ra,24(sp)
    80000b76:	6442                	ld	s0,16(sp)
    80000b78:	64a2                	ld	s1,8(sp)
    80000b7a:	6105                	addi	sp,sp,32
    80000b7c:	8082                	ret
  release(&kmem.lock);
    80000b7e:	00010517          	auipc	a0,0x10
    80000b82:	70250513          	addi	a0,a0,1794 # 80011280 <kmem>
    80000b86:	00000097          	auipc	ra,0x0
    80000b8a:	14e080e7          	jalr	334(ra) # 80000cd4 <release>
  if(r)
    80000b8e:	b7d5                	j	80000b72 <kalloc+0x42>

0000000080000b90 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b90:	1141                	addi	sp,sp,-16
    80000b92:	e422                	sd	s0,8(sp)
    80000b94:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b96:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b98:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b9c:	00053823          	sd	zero,16(a0)
}
    80000ba0:	6422                	ld	s0,8(sp)
    80000ba2:	0141                	addi	sp,sp,16
    80000ba4:	8082                	ret

0000000080000ba6 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000ba6:	411c                	lw	a5,0(a0)
    80000ba8:	e399                	bnez	a5,80000bae <holding+0x8>
    80000baa:	4501                	li	a0,0
  return r;
}
    80000bac:	8082                	ret
{
    80000bae:	1101                	addi	sp,sp,-32
    80000bb0:	ec06                	sd	ra,24(sp)
    80000bb2:	e822                	sd	s0,16(sp)
    80000bb4:	e426                	sd	s1,8(sp)
    80000bb6:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000bb8:	6904                	ld	s1,16(a0)
    80000bba:	00001097          	auipc	ra,0x1
    80000bbe:	e82080e7          	jalr	-382(ra) # 80001a3c <mycpu>
    80000bc2:	40a48533          	sub	a0,s1,a0
    80000bc6:	00153513          	seqz	a0,a0
}
    80000bca:	60e2                	ld	ra,24(sp)
    80000bcc:	6442                	ld	s0,16(sp)
    80000bce:	64a2                	ld	s1,8(sp)
    80000bd0:	6105                	addi	sp,sp,32
    80000bd2:	8082                	ret

0000000080000bd4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bd4:	1101                	addi	sp,sp,-32
    80000bd6:	ec06                	sd	ra,24(sp)
    80000bd8:	e822                	sd	s0,16(sp)
    80000bda:	e426                	sd	s1,8(sp)
    80000bdc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bde:	100024f3          	csrr	s1,sstatus
    80000be2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000be6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000be8:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bec:	00001097          	auipc	ra,0x1
    80000bf0:	e50080e7          	jalr	-432(ra) # 80001a3c <mycpu>
    80000bf4:	5d3c                	lw	a5,120(a0)
    80000bf6:	cf89                	beqz	a5,80000c10 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bf8:	00001097          	auipc	ra,0x1
    80000bfc:	e44080e7          	jalr	-444(ra) # 80001a3c <mycpu>
    80000c00:	5d3c                	lw	a5,120(a0)
    80000c02:	2785                	addiw	a5,a5,1
    80000c04:	dd3c                	sw	a5,120(a0)
}
    80000c06:	60e2                	ld	ra,24(sp)
    80000c08:	6442                	ld	s0,16(sp)
    80000c0a:	64a2                	ld	s1,8(sp)
    80000c0c:	6105                	addi	sp,sp,32
    80000c0e:	8082                	ret
    mycpu()->intena = old;
    80000c10:	00001097          	auipc	ra,0x1
    80000c14:	e2c080e7          	jalr	-468(ra) # 80001a3c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000c18:	8085                	srli	s1,s1,0x1
    80000c1a:	8885                	andi	s1,s1,1
    80000c1c:	dd64                	sw	s1,124(a0)
    80000c1e:	bfe9                	j	80000bf8 <push_off+0x24>

0000000080000c20 <acquire>:
{
    80000c20:	1101                	addi	sp,sp,-32
    80000c22:	ec06                	sd	ra,24(sp)
    80000c24:	e822                	sd	s0,16(sp)
    80000c26:	e426                	sd	s1,8(sp)
    80000c28:	1000                	addi	s0,sp,32
    80000c2a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c2c:	00000097          	auipc	ra,0x0
    80000c30:	fa8080e7          	jalr	-88(ra) # 80000bd4 <push_off>
  if(holding(lk))
    80000c34:	8526                	mv	a0,s1
    80000c36:	00000097          	auipc	ra,0x0
    80000c3a:	f70080e7          	jalr	-144(ra) # 80000ba6 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c3e:	4705                	li	a4,1
  if(holding(lk))
    80000c40:	e115                	bnez	a0,80000c64 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c42:	87ba                	mv	a5,a4
    80000c44:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c48:	2781                	sext.w	a5,a5
    80000c4a:	ffe5                	bnez	a5,80000c42 <acquire+0x22>
  __sync_synchronize();
    80000c4c:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c50:	00001097          	auipc	ra,0x1
    80000c54:	dec080e7          	jalr	-532(ra) # 80001a3c <mycpu>
    80000c58:	e888                	sd	a0,16(s1)
}
    80000c5a:	60e2                	ld	ra,24(sp)
    80000c5c:	6442                	ld	s0,16(sp)
    80000c5e:	64a2                	ld	s1,8(sp)
    80000c60:	6105                	addi	sp,sp,32
    80000c62:	8082                	ret
    panic("acquire");
    80000c64:	00007517          	auipc	a0,0x7
    80000c68:	40c50513          	addi	a0,a0,1036 # 80008070 <digits+0x58>
    80000c6c:	00000097          	auipc	ra,0x0
    80000c70:	8ec080e7          	jalr	-1812(ra) # 80000558 <panic>

0000000080000c74 <pop_off>:

void
pop_off(void)
{
    80000c74:	1141                	addi	sp,sp,-16
    80000c76:	e406                	sd	ra,8(sp)
    80000c78:	e022                	sd	s0,0(sp)
    80000c7a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c7c:	00001097          	auipc	ra,0x1
    80000c80:	dc0080e7          	jalr	-576(ra) # 80001a3c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c84:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c88:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c8a:	e78d                	bnez	a5,80000cb4 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c8c:	5d3c                	lw	a5,120(a0)
    80000c8e:	02f05b63          	blez	a5,80000cc4 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c92:	37fd                	addiw	a5,a5,-1
    80000c94:	0007871b          	sext.w	a4,a5
    80000c98:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c9a:	eb09                	bnez	a4,80000cac <pop_off+0x38>
    80000c9c:	5d7c                	lw	a5,124(a0)
    80000c9e:	c799                	beqz	a5,80000cac <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000ca0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000ca4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000ca8:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000cac:	60a2                	ld	ra,8(sp)
    80000cae:	6402                	ld	s0,0(sp)
    80000cb0:	0141                	addi	sp,sp,16
    80000cb2:	8082                	ret
    panic("pop_off - interruptible");
    80000cb4:	00007517          	auipc	a0,0x7
    80000cb8:	3c450513          	addi	a0,a0,964 # 80008078 <digits+0x60>
    80000cbc:	00000097          	auipc	ra,0x0
    80000cc0:	89c080e7          	jalr	-1892(ra) # 80000558 <panic>
    panic("pop_off");
    80000cc4:	00007517          	auipc	a0,0x7
    80000cc8:	3cc50513          	addi	a0,a0,972 # 80008090 <digits+0x78>
    80000ccc:	00000097          	auipc	ra,0x0
    80000cd0:	88c080e7          	jalr	-1908(ra) # 80000558 <panic>

0000000080000cd4 <release>:
{
    80000cd4:	1101                	addi	sp,sp,-32
    80000cd6:	ec06                	sd	ra,24(sp)
    80000cd8:	e822                	sd	s0,16(sp)
    80000cda:	e426                	sd	s1,8(sp)
    80000cdc:	1000                	addi	s0,sp,32
    80000cde:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000ce0:	00000097          	auipc	ra,0x0
    80000ce4:	ec6080e7          	jalr	-314(ra) # 80000ba6 <holding>
    80000ce8:	c115                	beqz	a0,80000d0c <release+0x38>
  lk->cpu = 0;
    80000cea:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000cee:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000cf2:	0f50000f          	fence	iorw,ow
    80000cf6:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000cfa:	00000097          	auipc	ra,0x0
    80000cfe:	f7a080e7          	jalr	-134(ra) # 80000c74 <pop_off>
}
    80000d02:	60e2                	ld	ra,24(sp)
    80000d04:	6442                	ld	s0,16(sp)
    80000d06:	64a2                	ld	s1,8(sp)
    80000d08:	6105                	addi	sp,sp,32
    80000d0a:	8082                	ret
    panic("release");
    80000d0c:	00007517          	auipc	a0,0x7
    80000d10:	38c50513          	addi	a0,a0,908 # 80008098 <digits+0x80>
    80000d14:	00000097          	auipc	ra,0x0
    80000d18:	844080e7          	jalr	-1980(ra) # 80000558 <panic>

0000000080000d1c <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000d1c:	1141                	addi	sp,sp,-16
    80000d1e:	e422                	sd	s0,8(sp)
    80000d20:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d22:	ce09                	beqz	a2,80000d3c <memset+0x20>
    80000d24:	87aa                	mv	a5,a0
    80000d26:	fff6071b          	addiw	a4,a2,-1
    80000d2a:	1702                	slli	a4,a4,0x20
    80000d2c:	9301                	srli	a4,a4,0x20
    80000d2e:	0705                	addi	a4,a4,1
    80000d30:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000d32:	00b78023          	sb	a1,0(a5) # fffffffffffff000 <end+0xffffffff7ffd9000>
    80000d36:	0785                	addi	a5,a5,1
  for(i = 0; i < n; i++){
    80000d38:	fee79de3          	bne	a5,a4,80000d32 <memset+0x16>
  }
  return dst;
}
    80000d3c:	6422                	ld	s0,8(sp)
    80000d3e:	0141                	addi	sp,sp,16
    80000d40:	8082                	ret

0000000080000d42 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d42:	1141                	addi	sp,sp,-16
    80000d44:	e422                	sd	s0,8(sp)
    80000d46:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d48:	ce15                	beqz	a2,80000d84 <memcmp+0x42>
    80000d4a:	fff6069b          	addiw	a3,a2,-1
    if(*s1 != *s2)
    80000d4e:	00054783          	lbu	a5,0(a0)
    80000d52:	0005c703          	lbu	a4,0(a1)
    80000d56:	02e79063          	bne	a5,a4,80000d76 <memcmp+0x34>
    80000d5a:	1682                	slli	a3,a3,0x20
    80000d5c:	9281                	srli	a3,a3,0x20
    80000d5e:	0685                	addi	a3,a3,1
    80000d60:	96aa                	add	a3,a3,a0
      return *s1 - *s2;
    s1++, s2++;
    80000d62:	0505                	addi	a0,a0,1
    80000d64:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d66:	00d50d63          	beq	a0,a3,80000d80 <memcmp+0x3e>
    if(*s1 != *s2)
    80000d6a:	00054783          	lbu	a5,0(a0)
    80000d6e:	0005c703          	lbu	a4,0(a1)
    80000d72:	fee788e3          	beq	a5,a4,80000d62 <memcmp+0x20>
      return *s1 - *s2;
    80000d76:	40e7853b          	subw	a0,a5,a4
  }

  return 0;
}
    80000d7a:	6422                	ld	s0,8(sp)
    80000d7c:	0141                	addi	sp,sp,16
    80000d7e:	8082                	ret
  return 0;
    80000d80:	4501                	li	a0,0
    80000d82:	bfe5                	j	80000d7a <memcmp+0x38>
    80000d84:	4501                	li	a0,0
    80000d86:	bfd5                	j	80000d7a <memcmp+0x38>

0000000080000d88 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d88:	1141                	addi	sp,sp,-16
    80000d8a:	e422                	sd	s0,8(sp)
    80000d8c:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d8e:	00a5f963          	bleu	a0,a1,80000da0 <memmove+0x18>
    80000d92:	02061713          	slli	a4,a2,0x20
    80000d96:	9301                	srli	a4,a4,0x20
    80000d98:	00e587b3          	add	a5,a1,a4
    80000d9c:	02f56563          	bltu	a0,a5,80000dc6 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000da0:	fff6069b          	addiw	a3,a2,-1
    80000da4:	ce11                	beqz	a2,80000dc0 <memmove+0x38>
    80000da6:	1682                	slli	a3,a3,0x20
    80000da8:	9281                	srli	a3,a3,0x20
    80000daa:	0685                	addi	a3,a3,1
    80000dac:	96ae                	add	a3,a3,a1
    80000dae:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000db0:	0585                	addi	a1,a1,1
    80000db2:	0785                	addi	a5,a5,1
    80000db4:	fff5c703          	lbu	a4,-1(a1)
    80000db8:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000dbc:	fed59ae3          	bne	a1,a3,80000db0 <memmove+0x28>

  return dst;
}
    80000dc0:	6422                	ld	s0,8(sp)
    80000dc2:	0141                	addi	sp,sp,16
    80000dc4:	8082                	ret
    d += n;
    80000dc6:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000dc8:	fff6069b          	addiw	a3,a2,-1
    80000dcc:	da75                	beqz	a2,80000dc0 <memmove+0x38>
    80000dce:	02069613          	slli	a2,a3,0x20
    80000dd2:	9201                	srli	a2,a2,0x20
    80000dd4:	fff64613          	not	a2,a2
    80000dd8:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000dda:	17fd                	addi	a5,a5,-1
    80000ddc:	177d                	addi	a4,a4,-1
    80000dde:	0007c683          	lbu	a3,0(a5)
    80000de2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000de6:	fef61ae3          	bne	a2,a5,80000dda <memmove+0x52>
    80000dea:	bfd9                	j	80000dc0 <memmove+0x38>

0000000080000dec <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000dec:	1141                	addi	sp,sp,-16
    80000dee:	e406                	sd	ra,8(sp)
    80000df0:	e022                	sd	s0,0(sp)
    80000df2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000df4:	00000097          	auipc	ra,0x0
    80000df8:	f94080e7          	jalr	-108(ra) # 80000d88 <memmove>
}
    80000dfc:	60a2                	ld	ra,8(sp)
    80000dfe:	6402                	ld	s0,0(sp)
    80000e00:	0141                	addi	sp,sp,16
    80000e02:	8082                	ret

0000000080000e04 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000e04:	1141                	addi	sp,sp,-16
    80000e06:	e422                	sd	s0,8(sp)
    80000e08:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000e0a:	c229                	beqz	a2,80000e4c <strncmp+0x48>
    80000e0c:	00054783          	lbu	a5,0(a0)
    80000e10:	c795                	beqz	a5,80000e3c <strncmp+0x38>
    80000e12:	0005c703          	lbu	a4,0(a1)
    80000e16:	02f71363          	bne	a4,a5,80000e3c <strncmp+0x38>
    80000e1a:	fff6071b          	addiw	a4,a2,-1
    80000e1e:	1702                	slli	a4,a4,0x20
    80000e20:	9301                	srli	a4,a4,0x20
    80000e22:	0705                	addi	a4,a4,1
    80000e24:	972a                	add	a4,a4,a0
    n--, p++, q++;
    80000e26:	0505                	addi	a0,a0,1
    80000e28:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000e2a:	02e50363          	beq	a0,a4,80000e50 <strncmp+0x4c>
    80000e2e:	00054783          	lbu	a5,0(a0)
    80000e32:	c789                	beqz	a5,80000e3c <strncmp+0x38>
    80000e34:	0005c683          	lbu	a3,0(a1)
    80000e38:	fef687e3          	beq	a3,a5,80000e26 <strncmp+0x22>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
    80000e3c:	00054503          	lbu	a0,0(a0)
    80000e40:	0005c783          	lbu	a5,0(a1)
    80000e44:	9d1d                	subw	a0,a0,a5
}
    80000e46:	6422                	ld	s0,8(sp)
    80000e48:	0141                	addi	sp,sp,16
    80000e4a:	8082                	ret
    return 0;
    80000e4c:	4501                	li	a0,0
    80000e4e:	bfe5                	j	80000e46 <strncmp+0x42>
    80000e50:	4501                	li	a0,0
    80000e52:	bfd5                	j	80000e46 <strncmp+0x42>

0000000080000e54 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e54:	1141                	addi	sp,sp,-16
    80000e56:	e422                	sd	s0,8(sp)
    80000e58:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e5a:	872a                	mv	a4,a0
    80000e5c:	a011                	j	80000e60 <strncpy+0xc>
    80000e5e:	8636                	mv	a2,a3
    80000e60:	fff6069b          	addiw	a3,a2,-1
    80000e64:	00c05963          	blez	a2,80000e76 <strncpy+0x22>
    80000e68:	0705                	addi	a4,a4,1
    80000e6a:	0005c783          	lbu	a5,0(a1)
    80000e6e:	fef70fa3          	sb	a5,-1(a4)
    80000e72:	0585                	addi	a1,a1,1
    80000e74:	f7ed                	bnez	a5,80000e5e <strncpy+0xa>
    ;
  while(n-- > 0)
    80000e76:	00d05c63          	blez	a3,80000e8e <strncpy+0x3a>
    80000e7a:	86ba                	mv	a3,a4
    *s++ = 0;
    80000e7c:	0685                	addi	a3,a3,1
    80000e7e:	fe068fa3          	sb	zero,-1(a3)
    80000e82:	fff6c793          	not	a5,a3
    80000e86:	9fb9                	addw	a5,a5,a4
  while(n-- > 0)
    80000e88:	9fb1                	addw	a5,a5,a2
    80000e8a:	fef049e3          	bgtz	a5,80000e7c <strncpy+0x28>
  return os;
}
    80000e8e:	6422                	ld	s0,8(sp)
    80000e90:	0141                	addi	sp,sp,16
    80000e92:	8082                	ret

0000000080000e94 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e94:	1141                	addi	sp,sp,-16
    80000e96:	e422                	sd	s0,8(sp)
    80000e98:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e9a:	02c05363          	blez	a2,80000ec0 <safestrcpy+0x2c>
    80000e9e:	fff6069b          	addiw	a3,a2,-1
    80000ea2:	1682                	slli	a3,a3,0x20
    80000ea4:	9281                	srli	a3,a3,0x20
    80000ea6:	96ae                	add	a3,a3,a1
    80000ea8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000eaa:	00d58963          	beq	a1,a3,80000ebc <safestrcpy+0x28>
    80000eae:	0585                	addi	a1,a1,1
    80000eb0:	0785                	addi	a5,a5,1
    80000eb2:	fff5c703          	lbu	a4,-1(a1)
    80000eb6:	fee78fa3          	sb	a4,-1(a5)
    80000eba:	fb65                	bnez	a4,80000eaa <safestrcpy+0x16>
    ;
  *s = 0;
    80000ebc:	00078023          	sb	zero,0(a5)
  return os;
}
    80000ec0:	6422                	ld	s0,8(sp)
    80000ec2:	0141                	addi	sp,sp,16
    80000ec4:	8082                	ret

0000000080000ec6 <strlen>:

int
strlen(const char *s)
{
    80000ec6:	1141                	addi	sp,sp,-16
    80000ec8:	e422                	sd	s0,8(sp)
    80000eca:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000ecc:	00054783          	lbu	a5,0(a0)
    80000ed0:	cf91                	beqz	a5,80000eec <strlen+0x26>
    80000ed2:	0505                	addi	a0,a0,1
    80000ed4:	87aa                	mv	a5,a0
    80000ed6:	4685                	li	a3,1
    80000ed8:	9e89                	subw	a3,a3,a0
    ;
    80000eda:	00f6853b          	addw	a0,a3,a5
    80000ede:	0785                	addi	a5,a5,1
  for(n = 0; s[n]; n++)
    80000ee0:	fff7c703          	lbu	a4,-1(a5)
    80000ee4:	fb7d                	bnez	a4,80000eda <strlen+0x14>
  return n;
}
    80000ee6:	6422                	ld	s0,8(sp)
    80000ee8:	0141                	addi	sp,sp,16
    80000eea:	8082                	ret
  for(n = 0; s[n]; n++)
    80000eec:	4501                	li	a0,0
    80000eee:	bfe5                	j	80000ee6 <strlen+0x20>

0000000080000ef0 <strcat>:

char* 
strcat(char* destination, const char* source)
{
    80000ef0:	1101                	addi	sp,sp,-32
    80000ef2:	ec06                	sd	ra,24(sp)
    80000ef4:	e822                	sd	s0,16(sp)
    80000ef6:	e426                	sd	s1,8(sp)
    80000ef8:	e04a                	sd	s2,0(sp)
    80000efa:	1000                	addi	s0,sp,32
    80000efc:	892a                	mv	s2,a0
    80000efe:	84ae                	mv	s1,a1
  char* ptr = destination + strlen(destination);
    80000f00:	00000097          	auipc	ra,0x0
    80000f04:	fc6080e7          	jalr	-58(ra) # 80000ec6 <strlen>
    80000f08:	954a                	add	a0,a0,s2

  while (*source != '\0')
    80000f0a:	0004c783          	lbu	a5,0(s1)
    80000f0e:	cb81                	beqz	a5,80000f1e <strcat+0x2e>
    *ptr++ = *source++;
    80000f10:	0485                	addi	s1,s1,1
    80000f12:	0505                	addi	a0,a0,1
    80000f14:	fef50fa3          	sb	a5,-1(a0)
  while (*source != '\0')
    80000f18:	0004c783          	lbu	a5,0(s1)
    80000f1c:	fbf5                	bnez	a5,80000f10 <strcat+0x20>

  *ptr = '\0';
    80000f1e:	00050023          	sb	zero,0(a0)

  return destination;
}
    80000f22:	854a                	mv	a0,s2
    80000f24:	60e2                	ld	ra,24(sp)
    80000f26:	6442                	ld	s0,16(sp)
    80000f28:	64a2                	ld	s1,8(sp)
    80000f2a:	6902                	ld	s2,0(sp)
    80000f2c:	6105                	addi	sp,sp,32
    80000f2e:	8082                	ret

0000000080000f30 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000f30:	1141                	addi	sp,sp,-16
    80000f32:	e406                	sd	ra,8(sp)
    80000f34:	e022                	sd	s0,0(sp)
    80000f36:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000f38:	00001097          	auipc	ra,0x1
    80000f3c:	af4080e7          	jalr	-1292(ra) # 80001a2c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000f40:	00008717          	auipc	a4,0x8
    80000f44:	0d870713          	addi	a4,a4,216 # 80009018 <started>
  if(cpuid() == 0){
    80000f48:	c139                	beqz	a0,80000f8e <main+0x5e>
    while(started == 0)
    80000f4a:	431c                	lw	a5,0(a4)
    80000f4c:	2781                	sext.w	a5,a5
    80000f4e:	dff5                	beqz	a5,80000f4a <main+0x1a>
      ;
    __sync_synchronize();
    80000f50:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000f54:	00001097          	auipc	ra,0x1
    80000f58:	ad8080e7          	jalr	-1320(ra) # 80001a2c <cpuid>
    80000f5c:	85aa                	mv	a1,a0
    80000f5e:	00007517          	auipc	a0,0x7
    80000f62:	15a50513          	addi	a0,a0,346 # 800080b8 <digits+0xa0>
    80000f66:	fffff097          	auipc	ra,0xfffff
    80000f6a:	63c080e7          	jalr	1596(ra) # 800005a2 <printf>
    kvminithart();    // turn on paging
    80000f6e:	00000097          	auipc	ra,0x0
    80000f72:	0d8080e7          	jalr	216(ra) # 80001046 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000f76:	00001097          	auipc	ra,0x1
    80000f7a:	73a080e7          	jalr	1850(ra) # 800026b0 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f7e:	00005097          	auipc	ra,0x5
    80000f82:	112080e7          	jalr	274(ra) # 80006090 <plicinithart>
  }

  scheduler();        
    80000f86:	00001097          	auipc	ra,0x1
    80000f8a:	fe2080e7          	jalr	-30(ra) # 80001f68 <scheduler>
    consoleinit();
    80000f8e:	fffff097          	auipc	ra,0xfffff
    80000f92:	4d8080e7          	jalr	1240(ra) # 80000466 <consoleinit>
    printfinit();
    80000f96:	fffff097          	auipc	ra,0xfffff
    80000f9a:	7f2080e7          	jalr	2034(ra) # 80000788 <printfinit>
    printf("\n");
    80000f9e:	00007517          	auipc	a0,0x7
    80000fa2:	12a50513          	addi	a0,a0,298 # 800080c8 <digits+0xb0>
    80000fa6:	fffff097          	auipc	ra,0xfffff
    80000faa:	5fc080e7          	jalr	1532(ra) # 800005a2 <printf>
    printf("xv6 kernel is booting\n");
    80000fae:	00007517          	auipc	a0,0x7
    80000fb2:	0f250513          	addi	a0,a0,242 # 800080a0 <digits+0x88>
    80000fb6:	fffff097          	auipc	ra,0xfffff
    80000fba:	5ec080e7          	jalr	1516(ra) # 800005a2 <printf>
    printf("\n");
    80000fbe:	00007517          	auipc	a0,0x7
    80000fc2:	10a50513          	addi	a0,a0,266 # 800080c8 <digits+0xb0>
    80000fc6:	fffff097          	auipc	ra,0xfffff
    80000fca:	5dc080e7          	jalr	1500(ra) # 800005a2 <printf>
    kinit();         // physical page allocator
    80000fce:	00000097          	auipc	ra,0x0
    80000fd2:	b26080e7          	jalr	-1242(ra) # 80000af4 <kinit>
    kvminit();       // create kernel page table
    80000fd6:	00000097          	auipc	ra,0x0
    80000fda:	310080e7          	jalr	784(ra) # 800012e6 <kvminit>
    kvminithart();   // turn on paging
    80000fde:	00000097          	auipc	ra,0x0
    80000fe2:	068080e7          	jalr	104(ra) # 80001046 <kvminithart>
    procinit();      // process table
    80000fe6:	00001097          	auipc	ra,0x1
    80000fea:	996080e7          	jalr	-1642(ra) # 8000197c <procinit>
    trapinit();      // trap vectors
    80000fee:	00001097          	auipc	ra,0x1
    80000ff2:	69a080e7          	jalr	1690(ra) # 80002688 <trapinit>
    trapinithart();  // install kernel trap vector
    80000ff6:	00001097          	auipc	ra,0x1
    80000ffa:	6ba080e7          	jalr	1722(ra) # 800026b0 <trapinithart>
    plicinit();      // set up interrupt controller
    80000ffe:	00005097          	auipc	ra,0x5
    80001002:	07c080e7          	jalr	124(ra) # 8000607a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80001006:	00005097          	auipc	ra,0x5
    8000100a:	08a080e7          	jalr	138(ra) # 80006090 <plicinithart>
    binit();         // buffer cache
    8000100e:	00002097          	auipc	ra,0x2
    80001012:	df2080e7          	jalr	-526(ra) # 80002e00 <binit>
    iinit();         // inode cache
    80001016:	00002097          	auipc	ra,0x2
    8000101a:	5ac080e7          	jalr	1452(ra) # 800035c2 <iinit>
    fileinit();      // file table
    8000101e:	00003097          	auipc	ra,0x3
    80001022:	6aa080e7          	jalr	1706(ra) # 800046c8 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80001026:	00005097          	auipc	ra,0x5
    8000102a:	18c080e7          	jalr	396(ra) # 800061b2 <virtio_disk_init>
    userinit();      // first user process
    8000102e:	00001097          	auipc	ra,0x1
    80001032:	d04080e7          	jalr	-764(ra) # 80001d32 <userinit>
    __sync_synchronize();
    80001036:	0ff0000f          	fence
    started = 1;
    8000103a:	4785                	li	a5,1
    8000103c:	00008717          	auipc	a4,0x8
    80001040:	fcf72e23          	sw	a5,-36(a4) # 80009018 <started>
    80001044:	b789                	j	80000f86 <main+0x56>

0000000080001046 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80001046:	1141                	addi	sp,sp,-16
    80001048:	e422                	sd	s0,8(sp)
    8000104a:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000104c:	00008797          	auipc	a5,0x8
    80001050:	fd478793          	addi	a5,a5,-44 # 80009020 <kernel_pagetable>
    80001054:	639c                	ld	a5,0(a5)
    80001056:	83b1                	srli	a5,a5,0xc
    80001058:	577d                	li	a4,-1
    8000105a:	177e                	slli	a4,a4,0x3f
    8000105c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000105e:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80001062:	12000073          	sfence.vma
  sfence_vma();
}
    80001066:	6422                	ld	s0,8(sp)
    80001068:	0141                	addi	sp,sp,16
    8000106a:	8082                	ret

000000008000106c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000106c:	7139                	addi	sp,sp,-64
    8000106e:	fc06                	sd	ra,56(sp)
    80001070:	f822                	sd	s0,48(sp)
    80001072:	f426                	sd	s1,40(sp)
    80001074:	f04a                	sd	s2,32(sp)
    80001076:	ec4e                	sd	s3,24(sp)
    80001078:	e852                	sd	s4,16(sp)
    8000107a:	e456                	sd	s5,8(sp)
    8000107c:	e05a                	sd	s6,0(sp)
    8000107e:	0080                	addi	s0,sp,64
    80001080:	84aa                	mv	s1,a0
    80001082:	89ae                	mv	s3,a1
    80001084:	8b32                	mv	s6,a2
  if(va >= MAXVA)
    80001086:	57fd                	li	a5,-1
    80001088:	83e9                	srli	a5,a5,0x1a
    8000108a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000108c:	4ab1                	li	s5,12
  if(va >= MAXVA)
    8000108e:	04b7f263          	bleu	a1,a5,800010d2 <walk+0x66>
    panic("walk");
    80001092:	00007517          	auipc	a0,0x7
    80001096:	03e50513          	addi	a0,a0,62 # 800080d0 <digits+0xb8>
    8000109a:	fffff097          	auipc	ra,0xfffff
    8000109e:	4be080e7          	jalr	1214(ra) # 80000558 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800010a2:	060b0663          	beqz	s6,8000110e <walk+0xa2>
    800010a6:	00000097          	auipc	ra,0x0
    800010aa:	a8a080e7          	jalr	-1398(ra) # 80000b30 <kalloc>
    800010ae:	84aa                	mv	s1,a0
    800010b0:	c529                	beqz	a0,800010fa <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800010b2:	6605                	lui	a2,0x1
    800010b4:	4581                	li	a1,0
    800010b6:	00000097          	auipc	ra,0x0
    800010ba:	c66080e7          	jalr	-922(ra) # 80000d1c <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800010be:	00c4d793          	srli	a5,s1,0xc
    800010c2:	07aa                	slli	a5,a5,0xa
    800010c4:	0017e793          	ori	a5,a5,1
    800010c8:	00f93023          	sd	a5,0(s2)
    800010cc:	3a5d                	addiw	s4,s4,-9
  for(int level = 2; level > 0; level--) {
    800010ce:	035a0063          	beq	s4,s5,800010ee <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800010d2:	0149d933          	srl	s2,s3,s4
    800010d6:	1ff97913          	andi	s2,s2,511
    800010da:	090e                	slli	s2,s2,0x3
    800010dc:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800010de:	00093483          	ld	s1,0(s2)
    800010e2:	0014f793          	andi	a5,s1,1
    800010e6:	dfd5                	beqz	a5,800010a2 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800010e8:	80a9                	srli	s1,s1,0xa
    800010ea:	04b2                	slli	s1,s1,0xc
    800010ec:	b7c5                	j	800010cc <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800010ee:	00c9d513          	srli	a0,s3,0xc
    800010f2:	1ff57513          	andi	a0,a0,511
    800010f6:	050e                	slli	a0,a0,0x3
    800010f8:	9526                	add	a0,a0,s1
}
    800010fa:	70e2                	ld	ra,56(sp)
    800010fc:	7442                	ld	s0,48(sp)
    800010fe:	74a2                	ld	s1,40(sp)
    80001100:	7902                	ld	s2,32(sp)
    80001102:	69e2                	ld	s3,24(sp)
    80001104:	6a42                	ld	s4,16(sp)
    80001106:	6aa2                	ld	s5,8(sp)
    80001108:	6b02                	ld	s6,0(sp)
    8000110a:	6121                	addi	sp,sp,64
    8000110c:	8082                	ret
        return 0;
    8000110e:	4501                	li	a0,0
    80001110:	b7ed                	j	800010fa <walk+0x8e>

0000000080001112 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001112:	57fd                	li	a5,-1
    80001114:	83e9                	srli	a5,a5,0x1a
    80001116:	00b7f463          	bleu	a1,a5,8000111e <walkaddr+0xc>
    return 0;
    8000111a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000111c:	8082                	ret
{
    8000111e:	1141                	addi	sp,sp,-16
    80001120:	e406                	sd	ra,8(sp)
    80001122:	e022                	sd	s0,0(sp)
    80001124:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001126:	4601                	li	a2,0
    80001128:	00000097          	auipc	ra,0x0
    8000112c:	f44080e7          	jalr	-188(ra) # 8000106c <walk>
  if(pte == 0)
    80001130:	c105                	beqz	a0,80001150 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80001132:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001134:	0117f693          	andi	a3,a5,17
    80001138:	4745                	li	a4,17
    return 0;
    8000113a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000113c:	00e68663          	beq	a3,a4,80001148 <walkaddr+0x36>
}
    80001140:	60a2                	ld	ra,8(sp)
    80001142:	6402                	ld	s0,0(sp)
    80001144:	0141                	addi	sp,sp,16
    80001146:	8082                	ret
  pa = PTE2PA(*pte);
    80001148:	00a7d513          	srli	a0,a5,0xa
    8000114c:	0532                	slli	a0,a0,0xc
  return pa;
    8000114e:	bfcd                	j	80001140 <walkaddr+0x2e>
    return 0;
    80001150:	4501                	li	a0,0
    80001152:	b7fd                	j	80001140 <walkaddr+0x2e>

0000000080001154 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001154:	715d                	addi	sp,sp,-80
    80001156:	e486                	sd	ra,72(sp)
    80001158:	e0a2                	sd	s0,64(sp)
    8000115a:	fc26                	sd	s1,56(sp)
    8000115c:	f84a                	sd	s2,48(sp)
    8000115e:	f44e                	sd	s3,40(sp)
    80001160:	f052                	sd	s4,32(sp)
    80001162:	ec56                	sd	s5,24(sp)
    80001164:	e85a                	sd	s6,16(sp)
    80001166:	e45e                	sd	s7,8(sp)
    80001168:	0880                	addi	s0,sp,80
    8000116a:	8aaa                	mv	s5,a0
    8000116c:	8b3a                	mv	s6,a4
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
    8000116e:	79fd                	lui	s3,0xfffff
    80001170:	0135fa33          	and	s4,a1,s3
  last = PGROUNDDOWN(va + size - 1);
    80001174:	167d                	addi	a2,a2,-1
    80001176:	962e                	add	a2,a2,a1
    80001178:	013679b3          	and	s3,a2,s3
  a = PGROUNDDOWN(va);
    8000117c:	8952                	mv	s2,s4
    8000117e:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001182:	6b85                	lui	s7,0x1
    80001184:	a811                	j	80001198 <mappages+0x44>
      panic("remap");
    80001186:	00007517          	auipc	a0,0x7
    8000118a:	f5250513          	addi	a0,a0,-174 # 800080d8 <digits+0xc0>
    8000118e:	fffff097          	auipc	ra,0xfffff
    80001192:	3ca080e7          	jalr	970(ra) # 80000558 <panic>
    a += PGSIZE;
    80001196:	995e                	add	s2,s2,s7
    pa += PGSIZE;
    80001198:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000119c:	4605                	li	a2,1
    8000119e:	85ca                	mv	a1,s2
    800011a0:	8556                	mv	a0,s5
    800011a2:	00000097          	auipc	ra,0x0
    800011a6:	eca080e7          	jalr	-310(ra) # 8000106c <walk>
    800011aa:	cd19                	beqz	a0,800011c8 <mappages+0x74>
    if(*pte & PTE_V)
    800011ac:	611c                	ld	a5,0(a0)
    800011ae:	8b85                	andi	a5,a5,1
    800011b0:	fbf9                	bnez	a5,80001186 <mappages+0x32>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800011b2:	80b1                	srli	s1,s1,0xc
    800011b4:	04aa                	slli	s1,s1,0xa
    800011b6:	0164e4b3          	or	s1,s1,s6
    800011ba:	0014e493          	ori	s1,s1,1
    800011be:	e104                	sd	s1,0(a0)
    if(a == last)
    800011c0:	fd391be3          	bne	s2,s3,80001196 <mappages+0x42>
  }
  return 0;
    800011c4:	4501                	li	a0,0
    800011c6:	a011                	j	800011ca <mappages+0x76>
      return -1;
    800011c8:	557d                	li	a0,-1
}
    800011ca:	60a6                	ld	ra,72(sp)
    800011cc:	6406                	ld	s0,64(sp)
    800011ce:	74e2                	ld	s1,56(sp)
    800011d0:	7942                	ld	s2,48(sp)
    800011d2:	79a2                	ld	s3,40(sp)
    800011d4:	7a02                	ld	s4,32(sp)
    800011d6:	6ae2                	ld	s5,24(sp)
    800011d8:	6b42                	ld	s6,16(sp)
    800011da:	6ba2                	ld	s7,8(sp)
    800011dc:	6161                	addi	sp,sp,80
    800011de:	8082                	ret

00000000800011e0 <kvmmap>:
{
    800011e0:	1141                	addi	sp,sp,-16
    800011e2:	e406                	sd	ra,8(sp)
    800011e4:	e022                	sd	s0,0(sp)
    800011e6:	0800                	addi	s0,sp,16
    800011e8:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800011ea:	86b2                	mv	a3,a2
    800011ec:	863e                	mv	a2,a5
    800011ee:	00000097          	auipc	ra,0x0
    800011f2:	f66080e7          	jalr	-154(ra) # 80001154 <mappages>
    800011f6:	e509                	bnez	a0,80001200 <kvmmap+0x20>
}
    800011f8:	60a2                	ld	ra,8(sp)
    800011fa:	6402                	ld	s0,0(sp)
    800011fc:	0141                	addi	sp,sp,16
    800011fe:	8082                	ret
    panic("kvmmap");
    80001200:	00007517          	auipc	a0,0x7
    80001204:	ee050513          	addi	a0,a0,-288 # 800080e0 <digits+0xc8>
    80001208:	fffff097          	auipc	ra,0xfffff
    8000120c:	350080e7          	jalr	848(ra) # 80000558 <panic>

0000000080001210 <kvmmake>:
{
    80001210:	1101                	addi	sp,sp,-32
    80001212:	ec06                	sd	ra,24(sp)
    80001214:	e822                	sd	s0,16(sp)
    80001216:	e426                	sd	s1,8(sp)
    80001218:	e04a                	sd	s2,0(sp)
    8000121a:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000121c:	00000097          	auipc	ra,0x0
    80001220:	914080e7          	jalr	-1772(ra) # 80000b30 <kalloc>
    80001224:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001226:	6605                	lui	a2,0x1
    80001228:	4581                	li	a1,0
    8000122a:	00000097          	auipc	ra,0x0
    8000122e:	af2080e7          	jalr	-1294(ra) # 80000d1c <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001232:	4719                	li	a4,6
    80001234:	6685                	lui	a3,0x1
    80001236:	10000637          	lui	a2,0x10000
    8000123a:	100005b7          	lui	a1,0x10000
    8000123e:	8526                	mv	a0,s1
    80001240:	00000097          	auipc	ra,0x0
    80001244:	fa0080e7          	jalr	-96(ra) # 800011e0 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001248:	4719                	li	a4,6
    8000124a:	6685                	lui	a3,0x1
    8000124c:	10001637          	lui	a2,0x10001
    80001250:	100015b7          	lui	a1,0x10001
    80001254:	8526                	mv	a0,s1
    80001256:	00000097          	auipc	ra,0x0
    8000125a:	f8a080e7          	jalr	-118(ra) # 800011e0 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000125e:	4719                	li	a4,6
    80001260:	004006b7          	lui	a3,0x400
    80001264:	0c000637          	lui	a2,0xc000
    80001268:	0c0005b7          	lui	a1,0xc000
    8000126c:	8526                	mv	a0,s1
    8000126e:	00000097          	auipc	ra,0x0
    80001272:	f72080e7          	jalr	-142(ra) # 800011e0 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001276:	00007917          	auipc	s2,0x7
    8000127a:	d8a90913          	addi	s2,s2,-630 # 80008000 <etext>
    8000127e:	4729                	li	a4,10
    80001280:	80007697          	auipc	a3,0x80007
    80001284:	d8068693          	addi	a3,a3,-640 # 8000 <_entry-0x7fff8000>
    80001288:	4605                	li	a2,1
    8000128a:	067e                	slli	a2,a2,0x1f
    8000128c:	85b2                	mv	a1,a2
    8000128e:	8526                	mv	a0,s1
    80001290:	00000097          	auipc	ra,0x0
    80001294:	f50080e7          	jalr	-176(ra) # 800011e0 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001298:	4719                	li	a4,6
    8000129a:	46c5                	li	a3,17
    8000129c:	06ee                	slli	a3,a3,0x1b
    8000129e:	412686b3          	sub	a3,a3,s2
    800012a2:	864a                	mv	a2,s2
    800012a4:	85ca                	mv	a1,s2
    800012a6:	8526                	mv	a0,s1
    800012a8:	00000097          	auipc	ra,0x0
    800012ac:	f38080e7          	jalr	-200(ra) # 800011e0 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800012b0:	4729                	li	a4,10
    800012b2:	6685                	lui	a3,0x1
    800012b4:	00006617          	auipc	a2,0x6
    800012b8:	d4c60613          	addi	a2,a2,-692 # 80007000 <_trampoline>
    800012bc:	040005b7          	lui	a1,0x4000
    800012c0:	15fd                	addi	a1,a1,-1
    800012c2:	05b2                	slli	a1,a1,0xc
    800012c4:	8526                	mv	a0,s1
    800012c6:	00000097          	auipc	ra,0x0
    800012ca:	f1a080e7          	jalr	-230(ra) # 800011e0 <kvmmap>
  proc_mapstacks(kpgtbl);
    800012ce:	8526                	mv	a0,s1
    800012d0:	00000097          	auipc	ra,0x0
    800012d4:	616080e7          	jalr	1558(ra) # 800018e6 <proc_mapstacks>
}
    800012d8:	8526                	mv	a0,s1
    800012da:	60e2                	ld	ra,24(sp)
    800012dc:	6442                	ld	s0,16(sp)
    800012de:	64a2                	ld	s1,8(sp)
    800012e0:	6902                	ld	s2,0(sp)
    800012e2:	6105                	addi	sp,sp,32
    800012e4:	8082                	ret

00000000800012e6 <kvminit>:
{
    800012e6:	1141                	addi	sp,sp,-16
    800012e8:	e406                	sd	ra,8(sp)
    800012ea:	e022                	sd	s0,0(sp)
    800012ec:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800012ee:	00000097          	auipc	ra,0x0
    800012f2:	f22080e7          	jalr	-222(ra) # 80001210 <kvmmake>
    800012f6:	00008797          	auipc	a5,0x8
    800012fa:	d2a7b523          	sd	a0,-726(a5) # 80009020 <kernel_pagetable>
}
    800012fe:	60a2                	ld	ra,8(sp)
    80001300:	6402                	ld	s0,0(sp)
    80001302:	0141                	addi	sp,sp,16
    80001304:	8082                	ret

0000000080001306 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001306:	715d                	addi	sp,sp,-80
    80001308:	e486                	sd	ra,72(sp)
    8000130a:	e0a2                	sd	s0,64(sp)
    8000130c:	fc26                	sd	s1,56(sp)
    8000130e:	f84a                	sd	s2,48(sp)
    80001310:	f44e                	sd	s3,40(sp)
    80001312:	f052                	sd	s4,32(sp)
    80001314:	ec56                	sd	s5,24(sp)
    80001316:	e85a                	sd	s6,16(sp)
    80001318:	e45e                	sd	s7,8(sp)
    8000131a:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000131c:	6785                	lui	a5,0x1
    8000131e:	17fd                	addi	a5,a5,-1
    80001320:	8fed                	and	a5,a5,a1
    80001322:	e795                	bnez	a5,8000134e <uvmunmap+0x48>
    80001324:	8a2a                	mv	s4,a0
    80001326:	84ae                	mv	s1,a1
    80001328:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000132a:	0632                	slli	a2,a2,0xc
    8000132c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001330:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001332:	6b05                	lui	s6,0x1
    80001334:	0735e863          	bltu	a1,s3,800013a4 <uvmunmap+0x9e>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80001338:	60a6                	ld	ra,72(sp)
    8000133a:	6406                	ld	s0,64(sp)
    8000133c:	74e2                	ld	s1,56(sp)
    8000133e:	7942                	ld	s2,48(sp)
    80001340:	79a2                	ld	s3,40(sp)
    80001342:	7a02                	ld	s4,32(sp)
    80001344:	6ae2                	ld	s5,24(sp)
    80001346:	6b42                	ld	s6,16(sp)
    80001348:	6ba2                	ld	s7,8(sp)
    8000134a:	6161                	addi	sp,sp,80
    8000134c:	8082                	ret
    panic("uvmunmap: not aligned");
    8000134e:	00007517          	auipc	a0,0x7
    80001352:	d9a50513          	addi	a0,a0,-614 # 800080e8 <digits+0xd0>
    80001356:	fffff097          	auipc	ra,0xfffff
    8000135a:	202080e7          	jalr	514(ra) # 80000558 <panic>
      panic("uvmunmap: walk");
    8000135e:	00007517          	auipc	a0,0x7
    80001362:	da250513          	addi	a0,a0,-606 # 80008100 <digits+0xe8>
    80001366:	fffff097          	auipc	ra,0xfffff
    8000136a:	1f2080e7          	jalr	498(ra) # 80000558 <panic>
      panic("uvmunmap: not mapped");
    8000136e:	00007517          	auipc	a0,0x7
    80001372:	da250513          	addi	a0,a0,-606 # 80008110 <digits+0xf8>
    80001376:	fffff097          	auipc	ra,0xfffff
    8000137a:	1e2080e7          	jalr	482(ra) # 80000558 <panic>
      panic("uvmunmap: not a leaf");
    8000137e:	00007517          	auipc	a0,0x7
    80001382:	daa50513          	addi	a0,a0,-598 # 80008128 <digits+0x110>
    80001386:	fffff097          	auipc	ra,0xfffff
    8000138a:	1d2080e7          	jalr	466(ra) # 80000558 <panic>
      uint64 pa = PTE2PA(*pte);
    8000138e:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001390:	0532                	slli	a0,a0,0xc
    80001392:	fffff097          	auipc	ra,0xfffff
    80001396:	69e080e7          	jalr	1694(ra) # 80000a30 <kfree>
    *pte = 0;
    8000139a:	00093023          	sd	zero,0(s2)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000139e:	94da                	add	s1,s1,s6
    800013a0:	f934fce3          	bleu	s3,s1,80001338 <uvmunmap+0x32>
    if((pte = walk(pagetable, a, 0)) == 0)
    800013a4:	4601                	li	a2,0
    800013a6:	85a6                	mv	a1,s1
    800013a8:	8552                	mv	a0,s4
    800013aa:	00000097          	auipc	ra,0x0
    800013ae:	cc2080e7          	jalr	-830(ra) # 8000106c <walk>
    800013b2:	892a                	mv	s2,a0
    800013b4:	d54d                	beqz	a0,8000135e <uvmunmap+0x58>
    if((*pte & PTE_V) == 0)
    800013b6:	6108                	ld	a0,0(a0)
    800013b8:	00157793          	andi	a5,a0,1
    800013bc:	dbcd                	beqz	a5,8000136e <uvmunmap+0x68>
    if(PTE_FLAGS(*pte) == PTE_V)
    800013be:	3ff57793          	andi	a5,a0,1023
    800013c2:	fb778ee3          	beq	a5,s7,8000137e <uvmunmap+0x78>
    if(do_free){
    800013c6:	fc0a8ae3          	beqz	s5,8000139a <uvmunmap+0x94>
    800013ca:	b7d1                	j	8000138e <uvmunmap+0x88>

00000000800013cc <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800013cc:	1101                	addi	sp,sp,-32
    800013ce:	ec06                	sd	ra,24(sp)
    800013d0:	e822                	sd	s0,16(sp)
    800013d2:	e426                	sd	s1,8(sp)
    800013d4:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800013d6:	fffff097          	auipc	ra,0xfffff
    800013da:	75a080e7          	jalr	1882(ra) # 80000b30 <kalloc>
    800013de:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800013e0:	c519                	beqz	a0,800013ee <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800013e2:	6605                	lui	a2,0x1
    800013e4:	4581                	li	a1,0
    800013e6:	00000097          	auipc	ra,0x0
    800013ea:	936080e7          	jalr	-1738(ra) # 80000d1c <memset>
  return pagetable;
}
    800013ee:	8526                	mv	a0,s1
    800013f0:	60e2                	ld	ra,24(sp)
    800013f2:	6442                	ld	s0,16(sp)
    800013f4:	64a2                	ld	s1,8(sp)
    800013f6:	6105                	addi	sp,sp,32
    800013f8:	8082                	ret

00000000800013fa <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800013fa:	7179                	addi	sp,sp,-48
    800013fc:	f406                	sd	ra,40(sp)
    800013fe:	f022                	sd	s0,32(sp)
    80001400:	ec26                	sd	s1,24(sp)
    80001402:	e84a                	sd	s2,16(sp)
    80001404:	e44e                	sd	s3,8(sp)
    80001406:	e052                	sd	s4,0(sp)
    80001408:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000140a:	6785                	lui	a5,0x1
    8000140c:	04f67863          	bleu	a5,a2,8000145c <uvminit+0x62>
    80001410:	8a2a                	mv	s4,a0
    80001412:	89ae                	mv	s3,a1
    80001414:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80001416:	fffff097          	auipc	ra,0xfffff
    8000141a:	71a080e7          	jalr	1818(ra) # 80000b30 <kalloc>
    8000141e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001420:	6605                	lui	a2,0x1
    80001422:	4581                	li	a1,0
    80001424:	00000097          	auipc	ra,0x0
    80001428:	8f8080e7          	jalr	-1800(ra) # 80000d1c <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000142c:	4779                	li	a4,30
    8000142e:	86ca                	mv	a3,s2
    80001430:	6605                	lui	a2,0x1
    80001432:	4581                	li	a1,0
    80001434:	8552                	mv	a0,s4
    80001436:	00000097          	auipc	ra,0x0
    8000143a:	d1e080e7          	jalr	-738(ra) # 80001154 <mappages>
  memmove(mem, src, sz);
    8000143e:	8626                	mv	a2,s1
    80001440:	85ce                	mv	a1,s3
    80001442:	854a                	mv	a0,s2
    80001444:	00000097          	auipc	ra,0x0
    80001448:	944080e7          	jalr	-1724(ra) # 80000d88 <memmove>
}
    8000144c:	70a2                	ld	ra,40(sp)
    8000144e:	7402                	ld	s0,32(sp)
    80001450:	64e2                	ld	s1,24(sp)
    80001452:	6942                	ld	s2,16(sp)
    80001454:	69a2                	ld	s3,8(sp)
    80001456:	6a02                	ld	s4,0(sp)
    80001458:	6145                	addi	sp,sp,48
    8000145a:	8082                	ret
    panic("inituvm: more than a page");
    8000145c:	00007517          	auipc	a0,0x7
    80001460:	ce450513          	addi	a0,a0,-796 # 80008140 <digits+0x128>
    80001464:	fffff097          	auipc	ra,0xfffff
    80001468:	0f4080e7          	jalr	244(ra) # 80000558 <panic>

000000008000146c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000146c:	1101                	addi	sp,sp,-32
    8000146e:	ec06                	sd	ra,24(sp)
    80001470:	e822                	sd	s0,16(sp)
    80001472:	e426                	sd	s1,8(sp)
    80001474:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001476:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001478:	00b67d63          	bleu	a1,a2,80001492 <uvmdealloc+0x26>
    8000147c:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000147e:	6605                	lui	a2,0x1
    80001480:	167d                	addi	a2,a2,-1
    80001482:	00c487b3          	add	a5,s1,a2
    80001486:	777d                	lui	a4,0xfffff
    80001488:	8ff9                	and	a5,a5,a4
    8000148a:	962e                	add	a2,a2,a1
    8000148c:	8e79                	and	a2,a2,a4
    8000148e:	00c7e863          	bltu	a5,a2,8000149e <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001492:	8526                	mv	a0,s1
    80001494:	60e2                	ld	ra,24(sp)
    80001496:	6442                	ld	s0,16(sp)
    80001498:	64a2                	ld	s1,8(sp)
    8000149a:	6105                	addi	sp,sp,32
    8000149c:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000149e:	8e1d                	sub	a2,a2,a5
    800014a0:	8231                	srli	a2,a2,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800014a2:	4685                	li	a3,1
    800014a4:	2601                	sext.w	a2,a2
    800014a6:	85be                	mv	a1,a5
    800014a8:	00000097          	auipc	ra,0x0
    800014ac:	e5e080e7          	jalr	-418(ra) # 80001306 <uvmunmap>
    800014b0:	b7cd                	j	80001492 <uvmdealloc+0x26>

00000000800014b2 <uvmalloc>:
  if(newsz < oldsz)
    800014b2:	0ab66163          	bltu	a2,a1,80001554 <uvmalloc+0xa2>
{
    800014b6:	7139                	addi	sp,sp,-64
    800014b8:	fc06                	sd	ra,56(sp)
    800014ba:	f822                	sd	s0,48(sp)
    800014bc:	f426                	sd	s1,40(sp)
    800014be:	f04a                	sd	s2,32(sp)
    800014c0:	ec4e                	sd	s3,24(sp)
    800014c2:	e852                	sd	s4,16(sp)
    800014c4:	e456                	sd	s5,8(sp)
    800014c6:	0080                	addi	s0,sp,64
  oldsz = PGROUNDUP(oldsz);
    800014c8:	6a05                	lui	s4,0x1
    800014ca:	1a7d                	addi	s4,s4,-1
    800014cc:	95d2                	add	a1,a1,s4
    800014ce:	7a7d                	lui	s4,0xfffff
    800014d0:	0145fa33          	and	s4,a1,s4
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014d4:	08ca7263          	bleu	a2,s4,80001558 <uvmalloc+0xa6>
    800014d8:	89b2                	mv	s3,a2
    800014da:	8aaa                	mv	s5,a0
    800014dc:	8952                	mv	s2,s4
    mem = kalloc();
    800014de:	fffff097          	auipc	ra,0xfffff
    800014e2:	652080e7          	jalr	1618(ra) # 80000b30 <kalloc>
    800014e6:	84aa                	mv	s1,a0
    if(mem == 0){
    800014e8:	c51d                	beqz	a0,80001516 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800014ea:	6605                	lui	a2,0x1
    800014ec:	4581                	li	a1,0
    800014ee:	00000097          	auipc	ra,0x0
    800014f2:	82e080e7          	jalr	-2002(ra) # 80000d1c <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800014f6:	4779                	li	a4,30
    800014f8:	86a6                	mv	a3,s1
    800014fa:	6605                	lui	a2,0x1
    800014fc:	85ca                	mv	a1,s2
    800014fe:	8556                	mv	a0,s5
    80001500:	00000097          	auipc	ra,0x0
    80001504:	c54080e7          	jalr	-940(ra) # 80001154 <mappages>
    80001508:	e905                	bnez	a0,80001538 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000150a:	6785                	lui	a5,0x1
    8000150c:	993e                	add	s2,s2,a5
    8000150e:	fd3968e3          	bltu	s2,s3,800014de <uvmalloc+0x2c>
  return newsz;
    80001512:	854e                	mv	a0,s3
    80001514:	a809                	j	80001526 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80001516:	8652                	mv	a2,s4
    80001518:	85ca                	mv	a1,s2
    8000151a:	8556                	mv	a0,s5
    8000151c:	00000097          	auipc	ra,0x0
    80001520:	f50080e7          	jalr	-176(ra) # 8000146c <uvmdealloc>
      return 0;
    80001524:	4501                	li	a0,0
}
    80001526:	70e2                	ld	ra,56(sp)
    80001528:	7442                	ld	s0,48(sp)
    8000152a:	74a2                	ld	s1,40(sp)
    8000152c:	7902                	ld	s2,32(sp)
    8000152e:	69e2                	ld	s3,24(sp)
    80001530:	6a42                	ld	s4,16(sp)
    80001532:	6aa2                	ld	s5,8(sp)
    80001534:	6121                	addi	sp,sp,64
    80001536:	8082                	ret
      kfree(mem);
    80001538:	8526                	mv	a0,s1
    8000153a:	fffff097          	auipc	ra,0xfffff
    8000153e:	4f6080e7          	jalr	1270(ra) # 80000a30 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001542:	8652                	mv	a2,s4
    80001544:	85ca                	mv	a1,s2
    80001546:	8556                	mv	a0,s5
    80001548:	00000097          	auipc	ra,0x0
    8000154c:	f24080e7          	jalr	-220(ra) # 8000146c <uvmdealloc>
      return 0;
    80001550:	4501                	li	a0,0
    80001552:	bfd1                	j	80001526 <uvmalloc+0x74>
    return oldsz;
    80001554:	852e                	mv	a0,a1
}
    80001556:	8082                	ret
  return newsz;
    80001558:	8532                	mv	a0,a2
    8000155a:	b7f1                	j	80001526 <uvmalloc+0x74>

000000008000155c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000155c:	7179                	addi	sp,sp,-48
    8000155e:	f406                	sd	ra,40(sp)
    80001560:	f022                	sd	s0,32(sp)
    80001562:	ec26                	sd	s1,24(sp)
    80001564:	e84a                	sd	s2,16(sp)
    80001566:	e44e                	sd	s3,8(sp)
    80001568:	e052                	sd	s4,0(sp)
    8000156a:	1800                	addi	s0,sp,48
    8000156c:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000156e:	84aa                	mv	s1,a0
    80001570:	6905                	lui	s2,0x1
    80001572:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001574:	4985                	li	s3,1
    80001576:	a821                	j	8000158e <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001578:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    8000157a:	0532                	slli	a0,a0,0xc
    8000157c:	00000097          	auipc	ra,0x0
    80001580:	fe0080e7          	jalr	-32(ra) # 8000155c <freewalk>
      pagetable[i] = 0;
    80001584:	0004b023          	sd	zero,0(s1)
    80001588:	04a1                	addi	s1,s1,8
  for(int i = 0; i < 512; i++){
    8000158a:	03248163          	beq	s1,s2,800015ac <freewalk+0x50>
    pte_t pte = pagetable[i];
    8000158e:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001590:	00f57793          	andi	a5,a0,15
    80001594:	ff3782e3          	beq	a5,s3,80001578 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001598:	8905                	andi	a0,a0,1
    8000159a:	d57d                	beqz	a0,80001588 <freewalk+0x2c>
      panic("freewalk: leaf");
    8000159c:	00007517          	auipc	a0,0x7
    800015a0:	bc450513          	addi	a0,a0,-1084 # 80008160 <digits+0x148>
    800015a4:	fffff097          	auipc	ra,0xfffff
    800015a8:	fb4080e7          	jalr	-76(ra) # 80000558 <panic>
    }
  }
  kfree((void*)pagetable);
    800015ac:	8552                	mv	a0,s4
    800015ae:	fffff097          	auipc	ra,0xfffff
    800015b2:	482080e7          	jalr	1154(ra) # 80000a30 <kfree>
}
    800015b6:	70a2                	ld	ra,40(sp)
    800015b8:	7402                	ld	s0,32(sp)
    800015ba:	64e2                	ld	s1,24(sp)
    800015bc:	6942                	ld	s2,16(sp)
    800015be:	69a2                	ld	s3,8(sp)
    800015c0:	6a02                	ld	s4,0(sp)
    800015c2:	6145                	addi	sp,sp,48
    800015c4:	8082                	ret

00000000800015c6 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800015c6:	1101                	addi	sp,sp,-32
    800015c8:	ec06                	sd	ra,24(sp)
    800015ca:	e822                	sd	s0,16(sp)
    800015cc:	e426                	sd	s1,8(sp)
    800015ce:	1000                	addi	s0,sp,32
    800015d0:	84aa                	mv	s1,a0
  if(sz > 0)
    800015d2:	e999                	bnez	a1,800015e8 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800015d4:	8526                	mv	a0,s1
    800015d6:	00000097          	auipc	ra,0x0
    800015da:	f86080e7          	jalr	-122(ra) # 8000155c <freewalk>
}
    800015de:	60e2                	ld	ra,24(sp)
    800015e0:	6442                	ld	s0,16(sp)
    800015e2:	64a2                	ld	s1,8(sp)
    800015e4:	6105                	addi	sp,sp,32
    800015e6:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800015e8:	6605                	lui	a2,0x1
    800015ea:	167d                	addi	a2,a2,-1
    800015ec:	962e                	add	a2,a2,a1
    800015ee:	4685                	li	a3,1
    800015f0:	8231                	srli	a2,a2,0xc
    800015f2:	4581                	li	a1,0
    800015f4:	00000097          	auipc	ra,0x0
    800015f8:	d12080e7          	jalr	-750(ra) # 80001306 <uvmunmap>
    800015fc:	bfe1                	j	800015d4 <uvmfree+0xe>

00000000800015fe <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800015fe:	c679                	beqz	a2,800016cc <uvmcopy+0xce>
{
    80001600:	715d                	addi	sp,sp,-80
    80001602:	e486                	sd	ra,72(sp)
    80001604:	e0a2                	sd	s0,64(sp)
    80001606:	fc26                	sd	s1,56(sp)
    80001608:	f84a                	sd	s2,48(sp)
    8000160a:	f44e                	sd	s3,40(sp)
    8000160c:	f052                	sd	s4,32(sp)
    8000160e:	ec56                	sd	s5,24(sp)
    80001610:	e85a                	sd	s6,16(sp)
    80001612:	e45e                	sd	s7,8(sp)
    80001614:	0880                	addi	s0,sp,80
    80001616:	8ab2                	mv	s5,a2
    80001618:	8b2e                	mv	s6,a1
    8000161a:	8baa                	mv	s7,a0
  for(i = 0; i < sz; i += PGSIZE){
    8000161c:	4901                	li	s2,0
    if((pte = walk(old, i, 0)) == 0)
    8000161e:	4601                	li	a2,0
    80001620:	85ca                	mv	a1,s2
    80001622:	855e                	mv	a0,s7
    80001624:	00000097          	auipc	ra,0x0
    80001628:	a48080e7          	jalr	-1464(ra) # 8000106c <walk>
    8000162c:	c531                	beqz	a0,80001678 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    8000162e:	6118                	ld	a4,0(a0)
    80001630:	00177793          	andi	a5,a4,1
    80001634:	cbb1                	beqz	a5,80001688 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001636:	00a75593          	srli	a1,a4,0xa
    8000163a:	00c59993          	slli	s3,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000163e:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001642:	fffff097          	auipc	ra,0xfffff
    80001646:	4ee080e7          	jalr	1262(ra) # 80000b30 <kalloc>
    8000164a:	8a2a                	mv	s4,a0
    8000164c:	c939                	beqz	a0,800016a2 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    8000164e:	6605                	lui	a2,0x1
    80001650:	85ce                	mv	a1,s3
    80001652:	fffff097          	auipc	ra,0xfffff
    80001656:	736080e7          	jalr	1846(ra) # 80000d88 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000165a:	8726                	mv	a4,s1
    8000165c:	86d2                	mv	a3,s4
    8000165e:	6605                	lui	a2,0x1
    80001660:	85ca                	mv	a1,s2
    80001662:	855a                	mv	a0,s6
    80001664:	00000097          	auipc	ra,0x0
    80001668:	af0080e7          	jalr	-1296(ra) # 80001154 <mappages>
    8000166c:	e515                	bnez	a0,80001698 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    8000166e:	6785                	lui	a5,0x1
    80001670:	993e                	add	s2,s2,a5
    80001672:	fb5966e3          	bltu	s2,s5,8000161e <uvmcopy+0x20>
    80001676:	a081                	j	800016b6 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80001678:	00007517          	auipc	a0,0x7
    8000167c:	af850513          	addi	a0,a0,-1288 # 80008170 <digits+0x158>
    80001680:	fffff097          	auipc	ra,0xfffff
    80001684:	ed8080e7          	jalr	-296(ra) # 80000558 <panic>
      panic("uvmcopy: page not present");
    80001688:	00007517          	auipc	a0,0x7
    8000168c:	b0850513          	addi	a0,a0,-1272 # 80008190 <digits+0x178>
    80001690:	fffff097          	auipc	ra,0xfffff
    80001694:	ec8080e7          	jalr	-312(ra) # 80000558 <panic>
      kfree(mem);
    80001698:	8552                	mv	a0,s4
    8000169a:	fffff097          	auipc	ra,0xfffff
    8000169e:	396080e7          	jalr	918(ra) # 80000a30 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800016a2:	4685                	li	a3,1
    800016a4:	00c95613          	srli	a2,s2,0xc
    800016a8:	4581                	li	a1,0
    800016aa:	855a                	mv	a0,s6
    800016ac:	00000097          	auipc	ra,0x0
    800016b0:	c5a080e7          	jalr	-934(ra) # 80001306 <uvmunmap>
  return -1;
    800016b4:	557d                	li	a0,-1
}
    800016b6:	60a6                	ld	ra,72(sp)
    800016b8:	6406                	ld	s0,64(sp)
    800016ba:	74e2                	ld	s1,56(sp)
    800016bc:	7942                	ld	s2,48(sp)
    800016be:	79a2                	ld	s3,40(sp)
    800016c0:	7a02                	ld	s4,32(sp)
    800016c2:	6ae2                	ld	s5,24(sp)
    800016c4:	6b42                	ld	s6,16(sp)
    800016c6:	6ba2                	ld	s7,8(sp)
    800016c8:	6161                	addi	sp,sp,80
    800016ca:	8082                	ret
  return 0;
    800016cc:	4501                	li	a0,0
}
    800016ce:	8082                	ret

00000000800016d0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800016d0:	1141                	addi	sp,sp,-16
    800016d2:	e406                	sd	ra,8(sp)
    800016d4:	e022                	sd	s0,0(sp)
    800016d6:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800016d8:	4601                	li	a2,0
    800016da:	00000097          	auipc	ra,0x0
    800016de:	992080e7          	jalr	-1646(ra) # 8000106c <walk>
  if(pte == 0)
    800016e2:	c901                	beqz	a0,800016f2 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800016e4:	611c                	ld	a5,0(a0)
    800016e6:	9bbd                	andi	a5,a5,-17
    800016e8:	e11c                	sd	a5,0(a0)
}
    800016ea:	60a2                	ld	ra,8(sp)
    800016ec:	6402                	ld	s0,0(sp)
    800016ee:	0141                	addi	sp,sp,16
    800016f0:	8082                	ret
    panic("uvmclear");
    800016f2:	00007517          	auipc	a0,0x7
    800016f6:	abe50513          	addi	a0,a0,-1346 # 800081b0 <digits+0x198>
    800016fa:	fffff097          	auipc	ra,0xfffff
    800016fe:	e5e080e7          	jalr	-418(ra) # 80000558 <panic>

0000000080001702 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001702:	c6bd                	beqz	a3,80001770 <copyout+0x6e>
{
    80001704:	715d                	addi	sp,sp,-80
    80001706:	e486                	sd	ra,72(sp)
    80001708:	e0a2                	sd	s0,64(sp)
    8000170a:	fc26                	sd	s1,56(sp)
    8000170c:	f84a                	sd	s2,48(sp)
    8000170e:	f44e                	sd	s3,40(sp)
    80001710:	f052                	sd	s4,32(sp)
    80001712:	ec56                	sd	s5,24(sp)
    80001714:	e85a                	sd	s6,16(sp)
    80001716:	e45e                	sd	s7,8(sp)
    80001718:	e062                	sd	s8,0(sp)
    8000171a:	0880                	addi	s0,sp,80
    8000171c:	8baa                	mv	s7,a0
    8000171e:	8a2e                	mv	s4,a1
    80001720:	8ab2                	mv	s5,a2
    80001722:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001724:	7c7d                	lui	s8,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001726:	6b05                	lui	s6,0x1
    80001728:	a015                	j	8000174c <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    8000172a:	9552                	add	a0,a0,s4
    8000172c:	0004861b          	sext.w	a2,s1
    80001730:	85d6                	mv	a1,s5
    80001732:	41250533          	sub	a0,a0,s2
    80001736:	fffff097          	auipc	ra,0xfffff
    8000173a:	652080e7          	jalr	1618(ra) # 80000d88 <memmove>

    len -= n;
    8000173e:	409989b3          	sub	s3,s3,s1
    src += n;
    80001742:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;
    80001744:	01690a33          	add	s4,s2,s6
  while(len > 0){
    80001748:	02098263          	beqz	s3,8000176c <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    8000174c:	018a7933          	and	s2,s4,s8
    pa0 = walkaddr(pagetable, va0);
    80001750:	85ca                	mv	a1,s2
    80001752:	855e                	mv	a0,s7
    80001754:	00000097          	auipc	ra,0x0
    80001758:	9be080e7          	jalr	-1602(ra) # 80001112 <walkaddr>
    if(pa0 == 0)
    8000175c:	cd01                	beqz	a0,80001774 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    8000175e:	414904b3          	sub	s1,s2,s4
    80001762:	94da                	add	s1,s1,s6
    if(n > len)
    80001764:	fc99f3e3          	bleu	s1,s3,8000172a <copyout+0x28>
    80001768:	84ce                	mv	s1,s3
    8000176a:	b7c1                	j	8000172a <copyout+0x28>
  }
  return 0;
    8000176c:	4501                	li	a0,0
    8000176e:	a021                	j	80001776 <copyout+0x74>
    80001770:	4501                	li	a0,0
}
    80001772:	8082                	ret
      return -1;
    80001774:	557d                	li	a0,-1
}
    80001776:	60a6                	ld	ra,72(sp)
    80001778:	6406                	ld	s0,64(sp)
    8000177a:	74e2                	ld	s1,56(sp)
    8000177c:	7942                	ld	s2,48(sp)
    8000177e:	79a2                	ld	s3,40(sp)
    80001780:	7a02                	ld	s4,32(sp)
    80001782:	6ae2                	ld	s5,24(sp)
    80001784:	6b42                	ld	s6,16(sp)
    80001786:	6ba2                	ld	s7,8(sp)
    80001788:	6c02                	ld	s8,0(sp)
    8000178a:	6161                	addi	sp,sp,80
    8000178c:	8082                	ret

000000008000178e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000178e:	caa5                	beqz	a3,800017fe <copyin+0x70>
{
    80001790:	715d                	addi	sp,sp,-80
    80001792:	e486                	sd	ra,72(sp)
    80001794:	e0a2                	sd	s0,64(sp)
    80001796:	fc26                	sd	s1,56(sp)
    80001798:	f84a                	sd	s2,48(sp)
    8000179a:	f44e                	sd	s3,40(sp)
    8000179c:	f052                	sd	s4,32(sp)
    8000179e:	ec56                	sd	s5,24(sp)
    800017a0:	e85a                	sd	s6,16(sp)
    800017a2:	e45e                	sd	s7,8(sp)
    800017a4:	e062                	sd	s8,0(sp)
    800017a6:	0880                	addi	s0,sp,80
    800017a8:	8baa                	mv	s7,a0
    800017aa:	8aae                	mv	s5,a1
    800017ac:	8a32                	mv	s4,a2
    800017ae:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800017b0:	7c7d                	lui	s8,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017b2:	6b05                	lui	s6,0x1
    800017b4:	a01d                	j	800017da <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800017b6:	014505b3          	add	a1,a0,s4
    800017ba:	0004861b          	sext.w	a2,s1
    800017be:	412585b3          	sub	a1,a1,s2
    800017c2:	8556                	mv	a0,s5
    800017c4:	fffff097          	auipc	ra,0xfffff
    800017c8:	5c4080e7          	jalr	1476(ra) # 80000d88 <memmove>

    len -= n;
    800017cc:	409989b3          	sub	s3,s3,s1
    dst += n;
    800017d0:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    800017d2:	01690a33          	add	s4,s2,s6
  while(len > 0){
    800017d6:	02098263          	beqz	s3,800017fa <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    800017da:	018a7933          	and	s2,s4,s8
    pa0 = walkaddr(pagetable, va0);
    800017de:	85ca                	mv	a1,s2
    800017e0:	855e                	mv	a0,s7
    800017e2:	00000097          	auipc	ra,0x0
    800017e6:	930080e7          	jalr	-1744(ra) # 80001112 <walkaddr>
    if(pa0 == 0)
    800017ea:	cd01                	beqz	a0,80001802 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    800017ec:	414904b3          	sub	s1,s2,s4
    800017f0:	94da                	add	s1,s1,s6
    if(n > len)
    800017f2:	fc99f2e3          	bleu	s1,s3,800017b6 <copyin+0x28>
    800017f6:	84ce                	mv	s1,s3
    800017f8:	bf7d                	j	800017b6 <copyin+0x28>
  }
  return 0;
    800017fa:	4501                	li	a0,0
    800017fc:	a021                	j	80001804 <copyin+0x76>
    800017fe:	4501                	li	a0,0
}
    80001800:	8082                	ret
      return -1;
    80001802:	557d                	li	a0,-1
}
    80001804:	60a6                	ld	ra,72(sp)
    80001806:	6406                	ld	s0,64(sp)
    80001808:	74e2                	ld	s1,56(sp)
    8000180a:	7942                	ld	s2,48(sp)
    8000180c:	79a2                	ld	s3,40(sp)
    8000180e:	7a02                	ld	s4,32(sp)
    80001810:	6ae2                	ld	s5,24(sp)
    80001812:	6b42                	ld	s6,16(sp)
    80001814:	6ba2                	ld	s7,8(sp)
    80001816:	6c02                	ld	s8,0(sp)
    80001818:	6161                	addi	sp,sp,80
    8000181a:	8082                	ret

000000008000181c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    8000181c:	ced5                	beqz	a3,800018d8 <copyinstr+0xbc>
{
    8000181e:	715d                	addi	sp,sp,-80
    80001820:	e486                	sd	ra,72(sp)
    80001822:	e0a2                	sd	s0,64(sp)
    80001824:	fc26                	sd	s1,56(sp)
    80001826:	f84a                	sd	s2,48(sp)
    80001828:	f44e                	sd	s3,40(sp)
    8000182a:	f052                	sd	s4,32(sp)
    8000182c:	ec56                	sd	s5,24(sp)
    8000182e:	e85a                	sd	s6,16(sp)
    80001830:	e45e                	sd	s7,8(sp)
    80001832:	e062                	sd	s8,0(sp)
    80001834:	0880                	addi	s0,sp,80
    80001836:	8aaa                	mv	s5,a0
    80001838:	84ae                	mv	s1,a1
    8000183a:	8c32                	mv	s8,a2
    8000183c:	8bb6                	mv	s7,a3
    va0 = PGROUNDDOWN(srcva);
    8000183e:	7a7d                	lui	s4,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001840:	6985                	lui	s3,0x1
    80001842:	4b05                	li	s6,1
    80001844:	a801                	j	80001854 <copyinstr+0x38>
    if(n > max)
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
    80001846:	87a6                	mv	a5,s1
    80001848:	a085                	j	800018a8 <copyinstr+0x8c>
        *dst = *p;
      }
      --n;
      --max;
      p++;
      dst++;
    8000184a:	84b2                	mv	s1,a2
    }

    srcva = va0 + PGSIZE;
    8000184c:	01390c33          	add	s8,s2,s3
  while(got_null == 0 && max > 0){
    80001850:	080b8063          	beqz	s7,800018d0 <copyinstr+0xb4>
    va0 = PGROUNDDOWN(srcva);
    80001854:	014c7933          	and	s2,s8,s4
    pa0 = walkaddr(pagetable, va0);
    80001858:	85ca                	mv	a1,s2
    8000185a:	8556                	mv	a0,s5
    8000185c:	00000097          	auipc	ra,0x0
    80001860:	8b6080e7          	jalr	-1866(ra) # 80001112 <walkaddr>
    if(pa0 == 0)
    80001864:	c925                	beqz	a0,800018d4 <copyinstr+0xb8>
    n = PGSIZE - (srcva - va0);
    80001866:	41890633          	sub	a2,s2,s8
    8000186a:	964e                	add	a2,a2,s3
    if(n > max)
    8000186c:	00cbf363          	bleu	a2,s7,80001872 <copyinstr+0x56>
    80001870:	865e                	mv	a2,s7
    char *p = (char *) (pa0 + (srcva - va0));
    80001872:	9562                	add	a0,a0,s8
    80001874:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80001878:	da71                	beqz	a2,8000184c <copyinstr+0x30>
      if(*p == '\0'){
    8000187a:	00054703          	lbu	a4,0(a0)
    8000187e:	d761                	beqz	a4,80001846 <copyinstr+0x2a>
    80001880:	9626                	add	a2,a2,s1
    80001882:	87a6                	mv	a5,s1
    80001884:	1bfd                	addi	s7,s7,-1
    80001886:	009b86b3          	add	a3,s7,s1
    8000188a:	409b04b3          	sub	s1,s6,s1
    8000188e:	94aa                	add	s1,s1,a0
        *dst = *p;
    80001890:	00e78023          	sb	a4,0(a5) # 1000 <_entry-0x7ffff000>
      --max;
    80001894:	40f68bb3          	sub	s7,a3,a5
      p++;
    80001898:	00f48733          	add	a4,s1,a5
      dst++;
    8000189c:	0785                	addi	a5,a5,1
    while(n > 0){
    8000189e:	faf606e3          	beq	a2,a5,8000184a <copyinstr+0x2e>
      if(*p == '\0'){
    800018a2:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd9000>
    800018a6:	f76d                	bnez	a4,80001890 <copyinstr+0x74>
        *dst = '\0';
    800018a8:	00078023          	sb	zero,0(a5)
    800018ac:	4785                	li	a5,1
  }
  if(got_null){
    800018ae:	0017b513          	seqz	a0,a5
    800018b2:	40a0053b          	negw	a0,a0
    800018b6:	2501                	sext.w	a0,a0
    return 0;
  } else {
    return -1;
  }
}
    800018b8:	60a6                	ld	ra,72(sp)
    800018ba:	6406                	ld	s0,64(sp)
    800018bc:	74e2                	ld	s1,56(sp)
    800018be:	7942                	ld	s2,48(sp)
    800018c0:	79a2                	ld	s3,40(sp)
    800018c2:	7a02                	ld	s4,32(sp)
    800018c4:	6ae2                	ld	s5,24(sp)
    800018c6:	6b42                	ld	s6,16(sp)
    800018c8:	6ba2                	ld	s7,8(sp)
    800018ca:	6c02                	ld	s8,0(sp)
    800018cc:	6161                	addi	sp,sp,80
    800018ce:	8082                	ret
    800018d0:	4781                	li	a5,0
    800018d2:	bff1                	j	800018ae <copyinstr+0x92>
      return -1;
    800018d4:	557d                	li	a0,-1
    800018d6:	b7cd                	j	800018b8 <copyinstr+0x9c>
  int got_null = 0;
    800018d8:	4781                	li	a5,0
  if(got_null){
    800018da:	0017b513          	seqz	a0,a5
    800018de:	40a0053b          	negw	a0,a0
    800018e2:	2501                	sext.w	a0,a0
}
    800018e4:	8082                	ret

00000000800018e6 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    800018e6:	7139                	addi	sp,sp,-64
    800018e8:	fc06                	sd	ra,56(sp)
    800018ea:	f822                	sd	s0,48(sp)
    800018ec:	f426                	sd	s1,40(sp)
    800018ee:	f04a                	sd	s2,32(sp)
    800018f0:	ec4e                	sd	s3,24(sp)
    800018f2:	e852                	sd	s4,16(sp)
    800018f4:	e456                	sd	s5,8(sp)
    800018f6:	e05a                	sd	s6,0(sp)
    800018f8:	0080                	addi	s0,sp,64
    800018fa:	8b2a                	mv	s6,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    800018fc:	00010497          	auipc	s1,0x10
    80001900:	dd448493          	addi	s1,s1,-556 # 800116d0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001904:	8aa6                	mv	s5,s1
    80001906:	00006a17          	auipc	s4,0x6
    8000190a:	6faa0a13          	addi	s4,s4,1786 # 80008000 <etext>
    8000190e:	04000937          	lui	s2,0x4000
    80001912:	197d                	addi	s2,s2,-1
    80001914:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001916:	00015997          	auipc	s3,0x15
    8000191a:	7ba98993          	addi	s3,s3,1978 # 800170d0 <tickslock>
    char *pa = kalloc();
    8000191e:	fffff097          	auipc	ra,0xfffff
    80001922:	212080e7          	jalr	530(ra) # 80000b30 <kalloc>
    80001926:	862a                	mv	a2,a0
    if(pa == 0)
    80001928:	c131                	beqz	a0,8000196c <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    8000192a:	415485b3          	sub	a1,s1,s5
    8000192e:	858d                	srai	a1,a1,0x3
    80001930:	000a3783          	ld	a5,0(s4)
    80001934:	02f585b3          	mul	a1,a1,a5
    80001938:	2585                	addiw	a1,a1,1
    8000193a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000193e:	4719                	li	a4,6
    80001940:	6685                	lui	a3,0x1
    80001942:	40b905b3          	sub	a1,s2,a1
    80001946:	855a                	mv	a0,s6
    80001948:	00000097          	auipc	ra,0x0
    8000194c:	898080e7          	jalr	-1896(ra) # 800011e0 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001950:	16848493          	addi	s1,s1,360
    80001954:	fd3495e3          	bne	s1,s3,8000191e <proc_mapstacks+0x38>
  }
}
    80001958:	70e2                	ld	ra,56(sp)
    8000195a:	7442                	ld	s0,48(sp)
    8000195c:	74a2                	ld	s1,40(sp)
    8000195e:	7902                	ld	s2,32(sp)
    80001960:	69e2                	ld	s3,24(sp)
    80001962:	6a42                	ld	s4,16(sp)
    80001964:	6aa2                	ld	s5,8(sp)
    80001966:	6b02                	ld	s6,0(sp)
    80001968:	6121                	addi	sp,sp,64
    8000196a:	8082                	ret
      panic("kalloc");
    8000196c:	00007517          	auipc	a0,0x7
    80001970:	88450513          	addi	a0,a0,-1916 # 800081f0 <states.1728+0x30>
    80001974:	fffff097          	auipc	ra,0xfffff
    80001978:	be4080e7          	jalr	-1052(ra) # 80000558 <panic>

000000008000197c <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    8000197c:	7139                	addi	sp,sp,-64
    8000197e:	fc06                	sd	ra,56(sp)
    80001980:	f822                	sd	s0,48(sp)
    80001982:	f426                	sd	s1,40(sp)
    80001984:	f04a                	sd	s2,32(sp)
    80001986:	ec4e                	sd	s3,24(sp)
    80001988:	e852                	sd	s4,16(sp)
    8000198a:	e456                	sd	s5,8(sp)
    8000198c:	e05a                	sd	s6,0(sp)
    8000198e:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001990:	00007597          	auipc	a1,0x7
    80001994:	86858593          	addi	a1,a1,-1944 # 800081f8 <states.1728+0x38>
    80001998:	00010517          	auipc	a0,0x10
    8000199c:	90850513          	addi	a0,a0,-1784 # 800112a0 <pid_lock>
    800019a0:	fffff097          	auipc	ra,0xfffff
    800019a4:	1f0080e7          	jalr	496(ra) # 80000b90 <initlock>
  initlock(&wait_lock, "wait_lock");
    800019a8:	00007597          	auipc	a1,0x7
    800019ac:	85858593          	addi	a1,a1,-1960 # 80008200 <states.1728+0x40>
    800019b0:	00010517          	auipc	a0,0x10
    800019b4:	90850513          	addi	a0,a0,-1784 # 800112b8 <wait_lock>
    800019b8:	fffff097          	auipc	ra,0xfffff
    800019bc:	1d8080e7          	jalr	472(ra) # 80000b90 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    800019c0:	00010497          	auipc	s1,0x10
    800019c4:	d1048493          	addi	s1,s1,-752 # 800116d0 <proc>
      initlock(&p->lock, "proc");
    800019c8:	00007b17          	auipc	s6,0x7
    800019cc:	848b0b13          	addi	s6,s6,-1976 # 80008210 <states.1728+0x50>
      p->kstack = KSTACK((int) (p - proc));
    800019d0:	8aa6                	mv	s5,s1
    800019d2:	00006a17          	auipc	s4,0x6
    800019d6:	62ea0a13          	addi	s4,s4,1582 # 80008000 <etext>
    800019da:	04000937          	lui	s2,0x4000
    800019de:	197d                	addi	s2,s2,-1
    800019e0:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800019e2:	00015997          	auipc	s3,0x15
    800019e6:	6ee98993          	addi	s3,s3,1774 # 800170d0 <tickslock>
      initlock(&p->lock, "proc");
    800019ea:	85da                	mv	a1,s6
    800019ec:	8526                	mv	a0,s1
    800019ee:	fffff097          	auipc	ra,0xfffff
    800019f2:	1a2080e7          	jalr	418(ra) # 80000b90 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    800019f6:	415487b3          	sub	a5,s1,s5
    800019fa:	878d                	srai	a5,a5,0x3
    800019fc:	000a3703          	ld	a4,0(s4)
    80001a00:	02e787b3          	mul	a5,a5,a4
    80001a04:	2785                	addiw	a5,a5,1
    80001a06:	00d7979b          	slliw	a5,a5,0xd
    80001a0a:	40f907b3          	sub	a5,s2,a5
    80001a0e:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a10:	16848493          	addi	s1,s1,360
    80001a14:	fd349be3          	bne	s1,s3,800019ea <procinit+0x6e>
  }
}
    80001a18:	70e2                	ld	ra,56(sp)
    80001a1a:	7442                	ld	s0,48(sp)
    80001a1c:	74a2                	ld	s1,40(sp)
    80001a1e:	7902                	ld	s2,32(sp)
    80001a20:	69e2                	ld	s3,24(sp)
    80001a22:	6a42                	ld	s4,16(sp)
    80001a24:	6aa2                	ld	s5,8(sp)
    80001a26:	6b02                	ld	s6,0(sp)
    80001a28:	6121                	addi	sp,sp,64
    80001a2a:	8082                	ret

0000000080001a2c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001a2c:	1141                	addi	sp,sp,-16
    80001a2e:	e422                	sd	s0,8(sp)
    80001a30:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001a32:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001a34:	2501                	sext.w	a0,a0
    80001a36:	6422                	ld	s0,8(sp)
    80001a38:	0141                	addi	sp,sp,16
    80001a3a:	8082                	ret

0000000080001a3c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80001a3c:	1141                	addi	sp,sp,-16
    80001a3e:	e422                	sd	s0,8(sp)
    80001a40:	0800                	addi	s0,sp,16
    80001a42:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001a44:	2781                	sext.w	a5,a5
    80001a46:	079e                	slli	a5,a5,0x7
  return c;
}
    80001a48:	00010517          	auipc	a0,0x10
    80001a4c:	88850513          	addi	a0,a0,-1912 # 800112d0 <cpus>
    80001a50:	953e                	add	a0,a0,a5
    80001a52:	6422                	ld	s0,8(sp)
    80001a54:	0141                	addi	sp,sp,16
    80001a56:	8082                	ret

0000000080001a58 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80001a58:	1101                	addi	sp,sp,-32
    80001a5a:	ec06                	sd	ra,24(sp)
    80001a5c:	e822                	sd	s0,16(sp)
    80001a5e:	e426                	sd	s1,8(sp)
    80001a60:	1000                	addi	s0,sp,32
  push_off();
    80001a62:	fffff097          	auipc	ra,0xfffff
    80001a66:	172080e7          	jalr	370(ra) # 80000bd4 <push_off>
    80001a6a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001a6c:	2781                	sext.w	a5,a5
    80001a6e:	079e                	slli	a5,a5,0x7
    80001a70:	00010717          	auipc	a4,0x10
    80001a74:	83070713          	addi	a4,a4,-2000 # 800112a0 <pid_lock>
    80001a78:	97ba                	add	a5,a5,a4
    80001a7a:	7b84                	ld	s1,48(a5)
  pop_off();
    80001a7c:	fffff097          	auipc	ra,0xfffff
    80001a80:	1f8080e7          	jalr	504(ra) # 80000c74 <pop_off>
  return p;
}
    80001a84:	8526                	mv	a0,s1
    80001a86:	60e2                	ld	ra,24(sp)
    80001a88:	6442                	ld	s0,16(sp)
    80001a8a:	64a2                	ld	s1,8(sp)
    80001a8c:	6105                	addi	sp,sp,32
    80001a8e:	8082                	ret

0000000080001a90 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001a90:	1141                	addi	sp,sp,-16
    80001a92:	e406                	sd	ra,8(sp)
    80001a94:	e022                	sd	s0,0(sp)
    80001a96:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001a98:	00000097          	auipc	ra,0x0
    80001a9c:	fc0080e7          	jalr	-64(ra) # 80001a58 <myproc>
    80001aa0:	fffff097          	auipc	ra,0xfffff
    80001aa4:	234080e7          	jalr	564(ra) # 80000cd4 <release>

  if (first) {
    80001aa8:	00007797          	auipc	a5,0x7
    80001aac:	d6878793          	addi	a5,a5,-664 # 80008810 <first.1691>
    80001ab0:	439c                	lw	a5,0(a5)
    80001ab2:	eb89                	bnez	a5,80001ac4 <forkret+0x34>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001ab4:	00001097          	auipc	ra,0x1
    80001ab8:	c14080e7          	jalr	-1004(ra) # 800026c8 <usertrapret>
}
    80001abc:	60a2                	ld	ra,8(sp)
    80001abe:	6402                	ld	s0,0(sp)
    80001ac0:	0141                	addi	sp,sp,16
    80001ac2:	8082                	ret
    first = 0;
    80001ac4:	00007797          	auipc	a5,0x7
    80001ac8:	d407a623          	sw	zero,-692(a5) # 80008810 <first.1691>
    fsinit(ROOTDEV);
    80001acc:	4505                	li	a0,1
    80001ace:	00002097          	auipc	ra,0x2
    80001ad2:	a76080e7          	jalr	-1418(ra) # 80003544 <fsinit>
    80001ad6:	bff9                	j	80001ab4 <forkret+0x24>

0000000080001ad8 <allocpid>:
allocpid() {
    80001ad8:	1101                	addi	sp,sp,-32
    80001ada:	ec06                	sd	ra,24(sp)
    80001adc:	e822                	sd	s0,16(sp)
    80001ade:	e426                	sd	s1,8(sp)
    80001ae0:	e04a                	sd	s2,0(sp)
    80001ae2:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001ae4:	0000f917          	auipc	s2,0xf
    80001ae8:	7bc90913          	addi	s2,s2,1980 # 800112a0 <pid_lock>
    80001aec:	854a                	mv	a0,s2
    80001aee:	fffff097          	auipc	ra,0xfffff
    80001af2:	132080e7          	jalr	306(ra) # 80000c20 <acquire>
  pid = nextpid;
    80001af6:	00007797          	auipc	a5,0x7
    80001afa:	d1e78793          	addi	a5,a5,-738 # 80008814 <nextpid>
    80001afe:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001b00:	0014871b          	addiw	a4,s1,1
    80001b04:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001b06:	854a                	mv	a0,s2
    80001b08:	fffff097          	auipc	ra,0xfffff
    80001b0c:	1cc080e7          	jalr	460(ra) # 80000cd4 <release>
}
    80001b10:	8526                	mv	a0,s1
    80001b12:	60e2                	ld	ra,24(sp)
    80001b14:	6442                	ld	s0,16(sp)
    80001b16:	64a2                	ld	s1,8(sp)
    80001b18:	6902                	ld	s2,0(sp)
    80001b1a:	6105                	addi	sp,sp,32
    80001b1c:	8082                	ret

0000000080001b1e <proc_pagetable>:
{
    80001b1e:	1101                	addi	sp,sp,-32
    80001b20:	ec06                	sd	ra,24(sp)
    80001b22:	e822                	sd	s0,16(sp)
    80001b24:	e426                	sd	s1,8(sp)
    80001b26:	e04a                	sd	s2,0(sp)
    80001b28:	1000                	addi	s0,sp,32
    80001b2a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001b2c:	00000097          	auipc	ra,0x0
    80001b30:	8a0080e7          	jalr	-1888(ra) # 800013cc <uvmcreate>
    80001b34:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001b36:	c121                	beqz	a0,80001b76 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001b38:	4729                	li	a4,10
    80001b3a:	00005697          	auipc	a3,0x5
    80001b3e:	4c668693          	addi	a3,a3,1222 # 80007000 <_trampoline>
    80001b42:	6605                	lui	a2,0x1
    80001b44:	040005b7          	lui	a1,0x4000
    80001b48:	15fd                	addi	a1,a1,-1
    80001b4a:	05b2                	slli	a1,a1,0xc
    80001b4c:	fffff097          	auipc	ra,0xfffff
    80001b50:	608080e7          	jalr	1544(ra) # 80001154 <mappages>
    80001b54:	02054863          	bltz	a0,80001b84 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001b58:	4719                	li	a4,6
    80001b5a:	05893683          	ld	a3,88(s2)
    80001b5e:	6605                	lui	a2,0x1
    80001b60:	020005b7          	lui	a1,0x2000
    80001b64:	15fd                	addi	a1,a1,-1
    80001b66:	05b6                	slli	a1,a1,0xd
    80001b68:	8526                	mv	a0,s1
    80001b6a:	fffff097          	auipc	ra,0xfffff
    80001b6e:	5ea080e7          	jalr	1514(ra) # 80001154 <mappages>
    80001b72:	02054163          	bltz	a0,80001b94 <proc_pagetable+0x76>
}
    80001b76:	8526                	mv	a0,s1
    80001b78:	60e2                	ld	ra,24(sp)
    80001b7a:	6442                	ld	s0,16(sp)
    80001b7c:	64a2                	ld	s1,8(sp)
    80001b7e:	6902                	ld	s2,0(sp)
    80001b80:	6105                	addi	sp,sp,32
    80001b82:	8082                	ret
    uvmfree(pagetable, 0);
    80001b84:	4581                	li	a1,0
    80001b86:	8526                	mv	a0,s1
    80001b88:	00000097          	auipc	ra,0x0
    80001b8c:	a3e080e7          	jalr	-1474(ra) # 800015c6 <uvmfree>
    return 0;
    80001b90:	4481                	li	s1,0
    80001b92:	b7d5                	j	80001b76 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b94:	4681                	li	a3,0
    80001b96:	4605                	li	a2,1
    80001b98:	040005b7          	lui	a1,0x4000
    80001b9c:	15fd                	addi	a1,a1,-1
    80001b9e:	05b2                	slli	a1,a1,0xc
    80001ba0:	8526                	mv	a0,s1
    80001ba2:	fffff097          	auipc	ra,0xfffff
    80001ba6:	764080e7          	jalr	1892(ra) # 80001306 <uvmunmap>
    uvmfree(pagetable, 0);
    80001baa:	4581                	li	a1,0
    80001bac:	8526                	mv	a0,s1
    80001bae:	00000097          	auipc	ra,0x0
    80001bb2:	a18080e7          	jalr	-1512(ra) # 800015c6 <uvmfree>
    return 0;
    80001bb6:	4481                	li	s1,0
    80001bb8:	bf7d                	j	80001b76 <proc_pagetable+0x58>

0000000080001bba <proc_freepagetable>:
{
    80001bba:	1101                	addi	sp,sp,-32
    80001bbc:	ec06                	sd	ra,24(sp)
    80001bbe:	e822                	sd	s0,16(sp)
    80001bc0:	e426                	sd	s1,8(sp)
    80001bc2:	e04a                	sd	s2,0(sp)
    80001bc4:	1000                	addi	s0,sp,32
    80001bc6:	84aa                	mv	s1,a0
    80001bc8:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001bca:	4681                	li	a3,0
    80001bcc:	4605                	li	a2,1
    80001bce:	040005b7          	lui	a1,0x4000
    80001bd2:	15fd                	addi	a1,a1,-1
    80001bd4:	05b2                	slli	a1,a1,0xc
    80001bd6:	fffff097          	auipc	ra,0xfffff
    80001bda:	730080e7          	jalr	1840(ra) # 80001306 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001bde:	4681                	li	a3,0
    80001be0:	4605                	li	a2,1
    80001be2:	020005b7          	lui	a1,0x2000
    80001be6:	15fd                	addi	a1,a1,-1
    80001be8:	05b6                	slli	a1,a1,0xd
    80001bea:	8526                	mv	a0,s1
    80001bec:	fffff097          	auipc	ra,0xfffff
    80001bf0:	71a080e7          	jalr	1818(ra) # 80001306 <uvmunmap>
  uvmfree(pagetable, sz);
    80001bf4:	85ca                	mv	a1,s2
    80001bf6:	8526                	mv	a0,s1
    80001bf8:	00000097          	auipc	ra,0x0
    80001bfc:	9ce080e7          	jalr	-1586(ra) # 800015c6 <uvmfree>
}
    80001c00:	60e2                	ld	ra,24(sp)
    80001c02:	6442                	ld	s0,16(sp)
    80001c04:	64a2                	ld	s1,8(sp)
    80001c06:	6902                	ld	s2,0(sp)
    80001c08:	6105                	addi	sp,sp,32
    80001c0a:	8082                	ret

0000000080001c0c <freeproc>:
{
    80001c0c:	1101                	addi	sp,sp,-32
    80001c0e:	ec06                	sd	ra,24(sp)
    80001c10:	e822                	sd	s0,16(sp)
    80001c12:	e426                	sd	s1,8(sp)
    80001c14:	1000                	addi	s0,sp,32
    80001c16:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001c18:	6d28                	ld	a0,88(a0)
    80001c1a:	c509                	beqz	a0,80001c24 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001c1c:	fffff097          	auipc	ra,0xfffff
    80001c20:	e14080e7          	jalr	-492(ra) # 80000a30 <kfree>
  p->trapframe = 0;
    80001c24:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001c28:	68a8                	ld	a0,80(s1)
    80001c2a:	c511                	beqz	a0,80001c36 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001c2c:	64ac                	ld	a1,72(s1)
    80001c2e:	00000097          	auipc	ra,0x0
    80001c32:	f8c080e7          	jalr	-116(ra) # 80001bba <proc_freepagetable>
  p->pagetable = 0;
    80001c36:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001c3a:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001c3e:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001c42:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001c46:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001c4a:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001c4e:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001c52:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001c56:	0004ac23          	sw	zero,24(s1)
}
    80001c5a:	60e2                	ld	ra,24(sp)
    80001c5c:	6442                	ld	s0,16(sp)
    80001c5e:	64a2                	ld	s1,8(sp)
    80001c60:	6105                	addi	sp,sp,32
    80001c62:	8082                	ret

0000000080001c64 <allocproc>:
{
    80001c64:	1101                	addi	sp,sp,-32
    80001c66:	ec06                	sd	ra,24(sp)
    80001c68:	e822                	sd	s0,16(sp)
    80001c6a:	e426                	sd	s1,8(sp)
    80001c6c:	e04a                	sd	s2,0(sp)
    80001c6e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c70:	00010497          	auipc	s1,0x10
    80001c74:	a6048493          	addi	s1,s1,-1440 # 800116d0 <proc>
    80001c78:	00015917          	auipc	s2,0x15
    80001c7c:	45890913          	addi	s2,s2,1112 # 800170d0 <tickslock>
    acquire(&p->lock);
    80001c80:	8526                	mv	a0,s1
    80001c82:	fffff097          	auipc	ra,0xfffff
    80001c86:	f9e080e7          	jalr	-98(ra) # 80000c20 <acquire>
    if(p->state == UNUSED) {
    80001c8a:	4c9c                	lw	a5,24(s1)
    80001c8c:	cf81                	beqz	a5,80001ca4 <allocproc+0x40>
      release(&p->lock);
    80001c8e:	8526                	mv	a0,s1
    80001c90:	fffff097          	auipc	ra,0xfffff
    80001c94:	044080e7          	jalr	68(ra) # 80000cd4 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c98:	16848493          	addi	s1,s1,360
    80001c9c:	ff2492e3          	bne	s1,s2,80001c80 <allocproc+0x1c>
  return 0;
    80001ca0:	4481                	li	s1,0
    80001ca2:	a889                	j	80001cf4 <allocproc+0x90>
  p->pid = allocpid();
    80001ca4:	00000097          	auipc	ra,0x0
    80001ca8:	e34080e7          	jalr	-460(ra) # 80001ad8 <allocpid>
    80001cac:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001cae:	4785                	li	a5,1
    80001cb0:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001cb2:	fffff097          	auipc	ra,0xfffff
    80001cb6:	e7e080e7          	jalr	-386(ra) # 80000b30 <kalloc>
    80001cba:	892a                	mv	s2,a0
    80001cbc:	eca8                	sd	a0,88(s1)
    80001cbe:	c131                	beqz	a0,80001d02 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001cc0:	8526                	mv	a0,s1
    80001cc2:	00000097          	auipc	ra,0x0
    80001cc6:	e5c080e7          	jalr	-420(ra) # 80001b1e <proc_pagetable>
    80001cca:	892a                	mv	s2,a0
    80001ccc:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001cce:	c531                	beqz	a0,80001d1a <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001cd0:	07000613          	li	a2,112
    80001cd4:	4581                	li	a1,0
    80001cd6:	06048513          	addi	a0,s1,96
    80001cda:	fffff097          	auipc	ra,0xfffff
    80001cde:	042080e7          	jalr	66(ra) # 80000d1c <memset>
  p->context.ra = (uint64)forkret;
    80001ce2:	00000797          	auipc	a5,0x0
    80001ce6:	dae78793          	addi	a5,a5,-594 # 80001a90 <forkret>
    80001cea:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001cec:	60bc                	ld	a5,64(s1)
    80001cee:	6705                	lui	a4,0x1
    80001cf0:	97ba                	add	a5,a5,a4
    80001cf2:	f4bc                	sd	a5,104(s1)
}
    80001cf4:	8526                	mv	a0,s1
    80001cf6:	60e2                	ld	ra,24(sp)
    80001cf8:	6442                	ld	s0,16(sp)
    80001cfa:	64a2                	ld	s1,8(sp)
    80001cfc:	6902                	ld	s2,0(sp)
    80001cfe:	6105                	addi	sp,sp,32
    80001d00:	8082                	ret
    freeproc(p);
    80001d02:	8526                	mv	a0,s1
    80001d04:	00000097          	auipc	ra,0x0
    80001d08:	f08080e7          	jalr	-248(ra) # 80001c0c <freeproc>
    release(&p->lock);
    80001d0c:	8526                	mv	a0,s1
    80001d0e:	fffff097          	auipc	ra,0xfffff
    80001d12:	fc6080e7          	jalr	-58(ra) # 80000cd4 <release>
    return 0;
    80001d16:	84ca                	mv	s1,s2
    80001d18:	bff1                	j	80001cf4 <allocproc+0x90>
    freeproc(p);
    80001d1a:	8526                	mv	a0,s1
    80001d1c:	00000097          	auipc	ra,0x0
    80001d20:	ef0080e7          	jalr	-272(ra) # 80001c0c <freeproc>
    release(&p->lock);
    80001d24:	8526                	mv	a0,s1
    80001d26:	fffff097          	auipc	ra,0xfffff
    80001d2a:	fae080e7          	jalr	-82(ra) # 80000cd4 <release>
    return 0;
    80001d2e:	84ca                	mv	s1,s2
    80001d30:	b7d1                	j	80001cf4 <allocproc+0x90>

0000000080001d32 <userinit>:
{
    80001d32:	1101                	addi	sp,sp,-32
    80001d34:	ec06                	sd	ra,24(sp)
    80001d36:	e822                	sd	s0,16(sp)
    80001d38:	e426                	sd	s1,8(sp)
    80001d3a:	1000                	addi	s0,sp,32
  p = allocproc();
    80001d3c:	00000097          	auipc	ra,0x0
    80001d40:	f28080e7          	jalr	-216(ra) # 80001c64 <allocproc>
    80001d44:	84aa                	mv	s1,a0
  initproc = p;
    80001d46:	00007797          	auipc	a5,0x7
    80001d4a:	2ea7b123          	sd	a0,738(a5) # 80009028 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001d4e:	03400613          	li	a2,52
    80001d52:	00007597          	auipc	a1,0x7
    80001d56:	ace58593          	addi	a1,a1,-1330 # 80008820 <initcode>
    80001d5a:	6928                	ld	a0,80(a0)
    80001d5c:	fffff097          	auipc	ra,0xfffff
    80001d60:	69e080e7          	jalr	1694(ra) # 800013fa <uvminit>
  p->sz = PGSIZE;
    80001d64:	6785                	lui	a5,0x1
    80001d66:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001d68:	6cb8                	ld	a4,88(s1)
    80001d6a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001d6e:	6cb8                	ld	a4,88(s1)
    80001d70:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001d72:	4641                	li	a2,16
    80001d74:	00006597          	auipc	a1,0x6
    80001d78:	4a458593          	addi	a1,a1,1188 # 80008218 <states.1728+0x58>
    80001d7c:	15848513          	addi	a0,s1,344
    80001d80:	fffff097          	auipc	ra,0xfffff
    80001d84:	114080e7          	jalr	276(ra) # 80000e94 <safestrcpy>
  p->cwd = namei("/");
    80001d88:	00006517          	auipc	a0,0x6
    80001d8c:	4a050513          	addi	a0,a0,1184 # 80008228 <states.1728+0x68>
    80001d90:	00002097          	auipc	ra,0x2
    80001d94:	13e080e7          	jalr	318(ra) # 80003ece <namei>
    80001d98:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001d9c:	478d                	li	a5,3
    80001d9e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001da0:	8526                	mv	a0,s1
    80001da2:	fffff097          	auipc	ra,0xfffff
    80001da6:	f32080e7          	jalr	-206(ra) # 80000cd4 <release>
}
    80001daa:	60e2                	ld	ra,24(sp)
    80001dac:	6442                	ld	s0,16(sp)
    80001dae:	64a2                	ld	s1,8(sp)
    80001db0:	6105                	addi	sp,sp,32
    80001db2:	8082                	ret

0000000080001db4 <growproc>:
{
    80001db4:	1101                	addi	sp,sp,-32
    80001db6:	ec06                	sd	ra,24(sp)
    80001db8:	e822                	sd	s0,16(sp)
    80001dba:	e426                	sd	s1,8(sp)
    80001dbc:	e04a                	sd	s2,0(sp)
    80001dbe:	1000                	addi	s0,sp,32
    80001dc0:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001dc2:	00000097          	auipc	ra,0x0
    80001dc6:	c96080e7          	jalr	-874(ra) # 80001a58 <myproc>
    80001dca:	892a                	mv	s2,a0
  sz = p->sz;
    80001dcc:	652c                	ld	a1,72(a0)
    80001dce:	0005851b          	sext.w	a0,a1
  if(n > 0){
    80001dd2:	00904f63          	bgtz	s1,80001df0 <growproc+0x3c>
  } else if(n < 0){
    80001dd6:	0204cd63          	bltz	s1,80001e10 <growproc+0x5c>
  p->sz = sz;
    80001dda:	1502                	slli	a0,a0,0x20
    80001ddc:	9101                	srli	a0,a0,0x20
    80001dde:	04a93423          	sd	a0,72(s2)
  return 0;
    80001de2:	4501                	li	a0,0
}
    80001de4:	60e2                	ld	ra,24(sp)
    80001de6:	6442                	ld	s0,16(sp)
    80001de8:	64a2                	ld	s1,8(sp)
    80001dea:	6902                	ld	s2,0(sp)
    80001dec:	6105                	addi	sp,sp,32
    80001dee:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001df0:	00a4863b          	addw	a2,s1,a0
    80001df4:	1602                	slli	a2,a2,0x20
    80001df6:	9201                	srli	a2,a2,0x20
    80001df8:	1582                	slli	a1,a1,0x20
    80001dfa:	9181                	srli	a1,a1,0x20
    80001dfc:	05093503          	ld	a0,80(s2)
    80001e00:	fffff097          	auipc	ra,0xfffff
    80001e04:	6b2080e7          	jalr	1714(ra) # 800014b2 <uvmalloc>
    80001e08:	2501                	sext.w	a0,a0
    80001e0a:	f961                	bnez	a0,80001dda <growproc+0x26>
      return -1;
    80001e0c:	557d                	li	a0,-1
    80001e0e:	bfd9                	j	80001de4 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001e10:	00a4863b          	addw	a2,s1,a0
    80001e14:	1602                	slli	a2,a2,0x20
    80001e16:	9201                	srli	a2,a2,0x20
    80001e18:	1582                	slli	a1,a1,0x20
    80001e1a:	9181                	srli	a1,a1,0x20
    80001e1c:	05093503          	ld	a0,80(s2)
    80001e20:	fffff097          	auipc	ra,0xfffff
    80001e24:	64c080e7          	jalr	1612(ra) # 8000146c <uvmdealloc>
    80001e28:	2501                	sext.w	a0,a0
    80001e2a:	bf45                	j	80001dda <growproc+0x26>

0000000080001e2c <fork>:
{
    80001e2c:	7179                	addi	sp,sp,-48
    80001e2e:	f406                	sd	ra,40(sp)
    80001e30:	f022                	sd	s0,32(sp)
    80001e32:	ec26                	sd	s1,24(sp)
    80001e34:	e84a                	sd	s2,16(sp)
    80001e36:	e44e                	sd	s3,8(sp)
    80001e38:	e052                	sd	s4,0(sp)
    80001e3a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001e3c:	00000097          	auipc	ra,0x0
    80001e40:	c1c080e7          	jalr	-996(ra) # 80001a58 <myproc>
    80001e44:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001e46:	00000097          	auipc	ra,0x0
    80001e4a:	e1e080e7          	jalr	-482(ra) # 80001c64 <allocproc>
    80001e4e:	10050b63          	beqz	a0,80001f64 <fork+0x138>
    80001e52:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001e54:	04893603          	ld	a2,72(s2)
    80001e58:	692c                	ld	a1,80(a0)
    80001e5a:	05093503          	ld	a0,80(s2)
    80001e5e:	fffff097          	auipc	ra,0xfffff
    80001e62:	7a0080e7          	jalr	1952(ra) # 800015fe <uvmcopy>
    80001e66:	04054663          	bltz	a0,80001eb2 <fork+0x86>
  np->sz = p->sz;
    80001e6a:	04893783          	ld	a5,72(s2)
    80001e6e:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001e72:	05893683          	ld	a3,88(s2)
    80001e76:	87b6                	mv	a5,a3
    80001e78:	0589b703          	ld	a4,88(s3)
    80001e7c:	12068693          	addi	a3,a3,288
    80001e80:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001e84:	6788                	ld	a0,8(a5)
    80001e86:	6b8c                	ld	a1,16(a5)
    80001e88:	6f90                	ld	a2,24(a5)
    80001e8a:	01073023          	sd	a6,0(a4)
    80001e8e:	e708                	sd	a0,8(a4)
    80001e90:	eb0c                	sd	a1,16(a4)
    80001e92:	ef10                	sd	a2,24(a4)
    80001e94:	02078793          	addi	a5,a5,32
    80001e98:	02070713          	addi	a4,a4,32
    80001e9c:	fed792e3          	bne	a5,a3,80001e80 <fork+0x54>
  np->trapframe->a0 = 0;
    80001ea0:	0589b783          	ld	a5,88(s3)
    80001ea4:	0607b823          	sd	zero,112(a5)
    80001ea8:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001eac:	15000a13          	li	s4,336
    80001eb0:	a03d                	j	80001ede <fork+0xb2>
    freeproc(np);
    80001eb2:	854e                	mv	a0,s3
    80001eb4:	00000097          	auipc	ra,0x0
    80001eb8:	d58080e7          	jalr	-680(ra) # 80001c0c <freeproc>
    release(&np->lock);
    80001ebc:	854e                	mv	a0,s3
    80001ebe:	fffff097          	auipc	ra,0xfffff
    80001ec2:	e16080e7          	jalr	-490(ra) # 80000cd4 <release>
    return -1;
    80001ec6:	5a7d                	li	s4,-1
    80001ec8:	a069                	j	80001f52 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    80001eca:	00003097          	auipc	ra,0x3
    80001ece:	8a4080e7          	jalr	-1884(ra) # 8000476e <filedup>
    80001ed2:	009987b3          	add	a5,s3,s1
    80001ed6:	e388                	sd	a0,0(a5)
    80001ed8:	04a1                	addi	s1,s1,8
  for(i = 0; i < NOFILE; i++)
    80001eda:	01448763          	beq	s1,s4,80001ee8 <fork+0xbc>
    if(p->ofile[i])
    80001ede:	009907b3          	add	a5,s2,s1
    80001ee2:	6388                	ld	a0,0(a5)
    80001ee4:	f17d                	bnez	a0,80001eca <fork+0x9e>
    80001ee6:	bfcd                	j	80001ed8 <fork+0xac>
  np->cwd = idup(p->cwd);
    80001ee8:	15093503          	ld	a0,336(s2)
    80001eec:	00002097          	auipc	ra,0x2
    80001ef0:	894080e7          	jalr	-1900(ra) # 80003780 <idup>
    80001ef4:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001ef8:	4641                	li	a2,16
    80001efa:	15890593          	addi	a1,s2,344
    80001efe:	15898513          	addi	a0,s3,344
    80001f02:	fffff097          	auipc	ra,0xfffff
    80001f06:	f92080e7          	jalr	-110(ra) # 80000e94 <safestrcpy>
  pid = np->pid;
    80001f0a:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001f0e:	854e                	mv	a0,s3
    80001f10:	fffff097          	auipc	ra,0xfffff
    80001f14:	dc4080e7          	jalr	-572(ra) # 80000cd4 <release>
  acquire(&wait_lock);
    80001f18:	0000f497          	auipc	s1,0xf
    80001f1c:	3a048493          	addi	s1,s1,928 # 800112b8 <wait_lock>
    80001f20:	8526                	mv	a0,s1
    80001f22:	fffff097          	auipc	ra,0xfffff
    80001f26:	cfe080e7          	jalr	-770(ra) # 80000c20 <acquire>
  np->parent = p;
    80001f2a:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001f2e:	8526                	mv	a0,s1
    80001f30:	fffff097          	auipc	ra,0xfffff
    80001f34:	da4080e7          	jalr	-604(ra) # 80000cd4 <release>
  acquire(&np->lock);
    80001f38:	854e                	mv	a0,s3
    80001f3a:	fffff097          	auipc	ra,0xfffff
    80001f3e:	ce6080e7          	jalr	-794(ra) # 80000c20 <acquire>
  np->state = RUNNABLE;
    80001f42:	478d                	li	a5,3
    80001f44:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001f48:	854e                	mv	a0,s3
    80001f4a:	fffff097          	auipc	ra,0xfffff
    80001f4e:	d8a080e7          	jalr	-630(ra) # 80000cd4 <release>
}
    80001f52:	8552                	mv	a0,s4
    80001f54:	70a2                	ld	ra,40(sp)
    80001f56:	7402                	ld	s0,32(sp)
    80001f58:	64e2                	ld	s1,24(sp)
    80001f5a:	6942                	ld	s2,16(sp)
    80001f5c:	69a2                	ld	s3,8(sp)
    80001f5e:	6a02                	ld	s4,0(sp)
    80001f60:	6145                	addi	sp,sp,48
    80001f62:	8082                	ret
    return -1;
    80001f64:	5a7d                	li	s4,-1
    80001f66:	b7f5                	j	80001f52 <fork+0x126>

0000000080001f68 <scheduler>:
{
    80001f68:	7139                	addi	sp,sp,-64
    80001f6a:	fc06                	sd	ra,56(sp)
    80001f6c:	f822                	sd	s0,48(sp)
    80001f6e:	f426                	sd	s1,40(sp)
    80001f70:	f04a                	sd	s2,32(sp)
    80001f72:	ec4e                	sd	s3,24(sp)
    80001f74:	e852                	sd	s4,16(sp)
    80001f76:	e456                	sd	s5,8(sp)
    80001f78:	e05a                	sd	s6,0(sp)
    80001f7a:	0080                	addi	s0,sp,64
    80001f7c:	8792                	mv	a5,tp
  int id = r_tp();
    80001f7e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001f80:	00779a93          	slli	s5,a5,0x7
    80001f84:	0000f717          	auipc	a4,0xf
    80001f88:	31c70713          	addi	a4,a4,796 # 800112a0 <pid_lock>
    80001f8c:	9756                	add	a4,a4,s5
    80001f8e:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001f92:	0000f717          	auipc	a4,0xf
    80001f96:	34670713          	addi	a4,a4,838 # 800112d8 <cpus+0x8>
    80001f9a:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001f9c:	498d                	li	s3,3
        p->state = RUNNING;
    80001f9e:	4b11                	li	s6,4
        c->proc = p;
    80001fa0:	079e                	slli	a5,a5,0x7
    80001fa2:	0000fa17          	auipc	s4,0xf
    80001fa6:	2fea0a13          	addi	s4,s4,766 # 800112a0 <pid_lock>
    80001faa:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001fac:	00015917          	auipc	s2,0x15
    80001fb0:	12490913          	addi	s2,s2,292 # 800170d0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fb4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001fb8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fbc:	10079073          	csrw	sstatus,a5
    80001fc0:	0000f497          	auipc	s1,0xf
    80001fc4:	71048493          	addi	s1,s1,1808 # 800116d0 <proc>
    80001fc8:	a03d                	j	80001ff6 <scheduler+0x8e>
        p->state = RUNNING;
    80001fca:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001fce:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001fd2:	06048593          	addi	a1,s1,96
    80001fd6:	8556                	mv	a0,s5
    80001fd8:	00000097          	auipc	ra,0x0
    80001fdc:	646080e7          	jalr	1606(ra) # 8000261e <swtch>
        c->proc = 0;
    80001fe0:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80001fe4:	8526                	mv	a0,s1
    80001fe6:	fffff097          	auipc	ra,0xfffff
    80001fea:	cee080e7          	jalr	-786(ra) # 80000cd4 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001fee:	16848493          	addi	s1,s1,360
    80001ff2:	fd2481e3          	beq	s1,s2,80001fb4 <scheduler+0x4c>
      acquire(&p->lock);
    80001ff6:	8526                	mv	a0,s1
    80001ff8:	fffff097          	auipc	ra,0xfffff
    80001ffc:	c28080e7          	jalr	-984(ra) # 80000c20 <acquire>
      if(p->state == RUNNABLE) {
    80002000:	4c9c                	lw	a5,24(s1)
    80002002:	ff3791e3          	bne	a5,s3,80001fe4 <scheduler+0x7c>
    80002006:	b7d1                	j	80001fca <scheduler+0x62>

0000000080002008 <sched>:
{
    80002008:	7179                	addi	sp,sp,-48
    8000200a:	f406                	sd	ra,40(sp)
    8000200c:	f022                	sd	s0,32(sp)
    8000200e:	ec26                	sd	s1,24(sp)
    80002010:	e84a                	sd	s2,16(sp)
    80002012:	e44e                	sd	s3,8(sp)
    80002014:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002016:	00000097          	auipc	ra,0x0
    8000201a:	a42080e7          	jalr	-1470(ra) # 80001a58 <myproc>
    8000201e:	892a                	mv	s2,a0
  if(!holding(&p->lock))
    80002020:	fffff097          	auipc	ra,0xfffff
    80002024:	b86080e7          	jalr	-1146(ra) # 80000ba6 <holding>
    80002028:	cd25                	beqz	a0,800020a0 <sched+0x98>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000202a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000202c:	2781                	sext.w	a5,a5
    8000202e:	079e                	slli	a5,a5,0x7
    80002030:	0000f717          	auipc	a4,0xf
    80002034:	27070713          	addi	a4,a4,624 # 800112a0 <pid_lock>
    80002038:	97ba                	add	a5,a5,a4
    8000203a:	0a87a703          	lw	a4,168(a5)
    8000203e:	4785                	li	a5,1
    80002040:	06f71863          	bne	a4,a5,800020b0 <sched+0xa8>
  if(p->state == RUNNING)
    80002044:	01892703          	lw	a4,24(s2)
    80002048:	4791                	li	a5,4
    8000204a:	06f70b63          	beq	a4,a5,800020c0 <sched+0xb8>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000204e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002052:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002054:	efb5                	bnez	a5,800020d0 <sched+0xc8>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002056:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002058:	0000f497          	auipc	s1,0xf
    8000205c:	24848493          	addi	s1,s1,584 # 800112a0 <pid_lock>
    80002060:	2781                	sext.w	a5,a5
    80002062:	079e                	slli	a5,a5,0x7
    80002064:	97a6                	add	a5,a5,s1
    80002066:	0ac7a983          	lw	s3,172(a5)
    8000206a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000206c:	2781                	sext.w	a5,a5
    8000206e:	079e                	slli	a5,a5,0x7
    80002070:	0000f597          	auipc	a1,0xf
    80002074:	26858593          	addi	a1,a1,616 # 800112d8 <cpus+0x8>
    80002078:	95be                	add	a1,a1,a5
    8000207a:	06090513          	addi	a0,s2,96
    8000207e:	00000097          	auipc	ra,0x0
    80002082:	5a0080e7          	jalr	1440(ra) # 8000261e <swtch>
    80002086:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002088:	2781                	sext.w	a5,a5
    8000208a:	079e                	slli	a5,a5,0x7
    8000208c:	97a6                	add	a5,a5,s1
    8000208e:	0b37a623          	sw	s3,172(a5)
}
    80002092:	70a2                	ld	ra,40(sp)
    80002094:	7402                	ld	s0,32(sp)
    80002096:	64e2                	ld	s1,24(sp)
    80002098:	6942                	ld	s2,16(sp)
    8000209a:	69a2                	ld	s3,8(sp)
    8000209c:	6145                	addi	sp,sp,48
    8000209e:	8082                	ret
    panic("sched p->lock");
    800020a0:	00006517          	auipc	a0,0x6
    800020a4:	19050513          	addi	a0,a0,400 # 80008230 <states.1728+0x70>
    800020a8:	ffffe097          	auipc	ra,0xffffe
    800020ac:	4b0080e7          	jalr	1200(ra) # 80000558 <panic>
    panic("sched locks");
    800020b0:	00006517          	auipc	a0,0x6
    800020b4:	19050513          	addi	a0,a0,400 # 80008240 <states.1728+0x80>
    800020b8:	ffffe097          	auipc	ra,0xffffe
    800020bc:	4a0080e7          	jalr	1184(ra) # 80000558 <panic>
    panic("sched running");
    800020c0:	00006517          	auipc	a0,0x6
    800020c4:	19050513          	addi	a0,a0,400 # 80008250 <states.1728+0x90>
    800020c8:	ffffe097          	auipc	ra,0xffffe
    800020cc:	490080e7          	jalr	1168(ra) # 80000558 <panic>
    panic("sched interruptible");
    800020d0:	00006517          	auipc	a0,0x6
    800020d4:	19050513          	addi	a0,a0,400 # 80008260 <states.1728+0xa0>
    800020d8:	ffffe097          	auipc	ra,0xffffe
    800020dc:	480080e7          	jalr	1152(ra) # 80000558 <panic>

00000000800020e0 <yield>:
{
    800020e0:	1101                	addi	sp,sp,-32
    800020e2:	ec06                	sd	ra,24(sp)
    800020e4:	e822                	sd	s0,16(sp)
    800020e6:	e426                	sd	s1,8(sp)
    800020e8:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800020ea:	00000097          	auipc	ra,0x0
    800020ee:	96e080e7          	jalr	-1682(ra) # 80001a58 <myproc>
    800020f2:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800020f4:	fffff097          	auipc	ra,0xfffff
    800020f8:	b2c080e7          	jalr	-1236(ra) # 80000c20 <acquire>
  p->state = RUNNABLE;
    800020fc:	478d                	li	a5,3
    800020fe:	cc9c                	sw	a5,24(s1)
  sched();
    80002100:	00000097          	auipc	ra,0x0
    80002104:	f08080e7          	jalr	-248(ra) # 80002008 <sched>
  release(&p->lock);
    80002108:	8526                	mv	a0,s1
    8000210a:	fffff097          	auipc	ra,0xfffff
    8000210e:	bca080e7          	jalr	-1078(ra) # 80000cd4 <release>
}
    80002112:	60e2                	ld	ra,24(sp)
    80002114:	6442                	ld	s0,16(sp)
    80002116:	64a2                	ld	s1,8(sp)
    80002118:	6105                	addi	sp,sp,32
    8000211a:	8082                	ret

000000008000211c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000211c:	7179                	addi	sp,sp,-48
    8000211e:	f406                	sd	ra,40(sp)
    80002120:	f022                	sd	s0,32(sp)
    80002122:	ec26                	sd	s1,24(sp)
    80002124:	e84a                	sd	s2,16(sp)
    80002126:	e44e                	sd	s3,8(sp)
    80002128:	1800                	addi	s0,sp,48
    8000212a:	89aa                	mv	s3,a0
    8000212c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000212e:	00000097          	auipc	ra,0x0
    80002132:	92a080e7          	jalr	-1750(ra) # 80001a58 <myproc>
    80002136:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80002138:	fffff097          	auipc	ra,0xfffff
    8000213c:	ae8080e7          	jalr	-1304(ra) # 80000c20 <acquire>
  release(lk);
    80002140:	854a                	mv	a0,s2
    80002142:	fffff097          	auipc	ra,0xfffff
    80002146:	b92080e7          	jalr	-1134(ra) # 80000cd4 <release>

  // Go to sleep.
  p->chan = chan;
    8000214a:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000214e:	4789                	li	a5,2
    80002150:	cc9c                	sw	a5,24(s1)

  sched();
    80002152:	00000097          	auipc	ra,0x0
    80002156:	eb6080e7          	jalr	-330(ra) # 80002008 <sched>

  // Tidy up.
  p->chan = 0;
    8000215a:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000215e:	8526                	mv	a0,s1
    80002160:	fffff097          	auipc	ra,0xfffff
    80002164:	b74080e7          	jalr	-1164(ra) # 80000cd4 <release>
  acquire(lk);
    80002168:	854a                	mv	a0,s2
    8000216a:	fffff097          	auipc	ra,0xfffff
    8000216e:	ab6080e7          	jalr	-1354(ra) # 80000c20 <acquire>
}
    80002172:	70a2                	ld	ra,40(sp)
    80002174:	7402                	ld	s0,32(sp)
    80002176:	64e2                	ld	s1,24(sp)
    80002178:	6942                	ld	s2,16(sp)
    8000217a:	69a2                	ld	s3,8(sp)
    8000217c:	6145                	addi	sp,sp,48
    8000217e:	8082                	ret

0000000080002180 <wait>:
{
    80002180:	715d                	addi	sp,sp,-80
    80002182:	e486                	sd	ra,72(sp)
    80002184:	e0a2                	sd	s0,64(sp)
    80002186:	fc26                	sd	s1,56(sp)
    80002188:	f84a                	sd	s2,48(sp)
    8000218a:	f44e                	sd	s3,40(sp)
    8000218c:	f052                	sd	s4,32(sp)
    8000218e:	ec56                	sd	s5,24(sp)
    80002190:	e85a                	sd	s6,16(sp)
    80002192:	e45e                	sd	s7,8(sp)
    80002194:	e062                	sd	s8,0(sp)
    80002196:	0880                	addi	s0,sp,80
    80002198:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    8000219a:	00000097          	auipc	ra,0x0
    8000219e:	8be080e7          	jalr	-1858(ra) # 80001a58 <myproc>
    800021a2:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800021a4:	0000f517          	auipc	a0,0xf
    800021a8:	11450513          	addi	a0,a0,276 # 800112b8 <wait_lock>
    800021ac:	fffff097          	auipc	ra,0xfffff
    800021b0:	a74080e7          	jalr	-1420(ra) # 80000c20 <acquire>
    havekids = 0;
    800021b4:	4b01                	li	s6,0
        if(np->state == ZOMBIE){
    800021b6:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800021b8:	00015997          	auipc	s3,0x15
    800021bc:	f1898993          	addi	s3,s3,-232 # 800170d0 <tickslock>
        havekids = 1;
    800021c0:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800021c2:	0000fc17          	auipc	s8,0xf
    800021c6:	0f6c0c13          	addi	s8,s8,246 # 800112b8 <wait_lock>
    havekids = 0;
    800021ca:	875a                	mv	a4,s6
    for(np = proc; np < &proc[NPROC]; np++){
    800021cc:	0000f497          	auipc	s1,0xf
    800021d0:	50448493          	addi	s1,s1,1284 # 800116d0 <proc>
    800021d4:	a0bd                	j	80002242 <wait+0xc2>
          pid = np->pid;
    800021d6:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800021da:	000b8e63          	beqz	s7,800021f6 <wait+0x76>
    800021de:	4691                	li	a3,4
    800021e0:	02c48613          	addi	a2,s1,44
    800021e4:	85de                	mv	a1,s7
    800021e6:	05093503          	ld	a0,80(s2)
    800021ea:	fffff097          	auipc	ra,0xfffff
    800021ee:	518080e7          	jalr	1304(ra) # 80001702 <copyout>
    800021f2:	02054563          	bltz	a0,8000221c <wait+0x9c>
          freeproc(np);
    800021f6:	8526                	mv	a0,s1
    800021f8:	00000097          	auipc	ra,0x0
    800021fc:	a14080e7          	jalr	-1516(ra) # 80001c0c <freeproc>
          release(&np->lock);
    80002200:	8526                	mv	a0,s1
    80002202:	fffff097          	auipc	ra,0xfffff
    80002206:	ad2080e7          	jalr	-1326(ra) # 80000cd4 <release>
          release(&wait_lock);
    8000220a:	0000f517          	auipc	a0,0xf
    8000220e:	0ae50513          	addi	a0,a0,174 # 800112b8 <wait_lock>
    80002212:	fffff097          	auipc	ra,0xfffff
    80002216:	ac2080e7          	jalr	-1342(ra) # 80000cd4 <release>
          return pid;
    8000221a:	a09d                	j	80002280 <wait+0x100>
            release(&np->lock);
    8000221c:	8526                	mv	a0,s1
    8000221e:	fffff097          	auipc	ra,0xfffff
    80002222:	ab6080e7          	jalr	-1354(ra) # 80000cd4 <release>
            release(&wait_lock);
    80002226:	0000f517          	auipc	a0,0xf
    8000222a:	09250513          	addi	a0,a0,146 # 800112b8 <wait_lock>
    8000222e:	fffff097          	auipc	ra,0xfffff
    80002232:	aa6080e7          	jalr	-1370(ra) # 80000cd4 <release>
            return -1;
    80002236:	59fd                	li	s3,-1
    80002238:	a0a1                	j	80002280 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    8000223a:	16848493          	addi	s1,s1,360
    8000223e:	03348463          	beq	s1,s3,80002266 <wait+0xe6>
      if(np->parent == p){
    80002242:	7c9c                	ld	a5,56(s1)
    80002244:	ff279be3          	bne	a5,s2,8000223a <wait+0xba>
        acquire(&np->lock);
    80002248:	8526                	mv	a0,s1
    8000224a:	fffff097          	auipc	ra,0xfffff
    8000224e:	9d6080e7          	jalr	-1578(ra) # 80000c20 <acquire>
        if(np->state == ZOMBIE){
    80002252:	4c9c                	lw	a5,24(s1)
    80002254:	f94781e3          	beq	a5,s4,800021d6 <wait+0x56>
        release(&np->lock);
    80002258:	8526                	mv	a0,s1
    8000225a:	fffff097          	auipc	ra,0xfffff
    8000225e:	a7a080e7          	jalr	-1414(ra) # 80000cd4 <release>
        havekids = 1;
    80002262:	8756                	mv	a4,s5
    80002264:	bfd9                	j	8000223a <wait+0xba>
    if(!havekids || p->killed){
    80002266:	c701                	beqz	a4,8000226e <wait+0xee>
    80002268:	02892783          	lw	a5,40(s2)
    8000226c:	c79d                	beqz	a5,8000229a <wait+0x11a>
      release(&wait_lock);
    8000226e:	0000f517          	auipc	a0,0xf
    80002272:	04a50513          	addi	a0,a0,74 # 800112b8 <wait_lock>
    80002276:	fffff097          	auipc	ra,0xfffff
    8000227a:	a5e080e7          	jalr	-1442(ra) # 80000cd4 <release>
      return -1;
    8000227e:	59fd                	li	s3,-1
}
    80002280:	854e                	mv	a0,s3
    80002282:	60a6                	ld	ra,72(sp)
    80002284:	6406                	ld	s0,64(sp)
    80002286:	74e2                	ld	s1,56(sp)
    80002288:	7942                	ld	s2,48(sp)
    8000228a:	79a2                	ld	s3,40(sp)
    8000228c:	7a02                	ld	s4,32(sp)
    8000228e:	6ae2                	ld	s5,24(sp)
    80002290:	6b42                	ld	s6,16(sp)
    80002292:	6ba2                	ld	s7,8(sp)
    80002294:	6c02                	ld	s8,0(sp)
    80002296:	6161                	addi	sp,sp,80
    80002298:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000229a:	85e2                	mv	a1,s8
    8000229c:	854a                	mv	a0,s2
    8000229e:	00000097          	auipc	ra,0x0
    800022a2:	e7e080e7          	jalr	-386(ra) # 8000211c <sleep>
    havekids = 0;
    800022a6:	b715                	j	800021ca <wait+0x4a>

00000000800022a8 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800022a8:	7139                	addi	sp,sp,-64
    800022aa:	fc06                	sd	ra,56(sp)
    800022ac:	f822                	sd	s0,48(sp)
    800022ae:	f426                	sd	s1,40(sp)
    800022b0:	f04a                	sd	s2,32(sp)
    800022b2:	ec4e                	sd	s3,24(sp)
    800022b4:	e852                	sd	s4,16(sp)
    800022b6:	e456                	sd	s5,8(sp)
    800022b8:	0080                	addi	s0,sp,64
    800022ba:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800022bc:	0000f497          	auipc	s1,0xf
    800022c0:	41448493          	addi	s1,s1,1044 # 800116d0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800022c4:	4989                	li	s3,2
        p->state = RUNNABLE;
    800022c6:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800022c8:	00015917          	auipc	s2,0x15
    800022cc:	e0890913          	addi	s2,s2,-504 # 800170d0 <tickslock>
    800022d0:	a821                	j	800022e8 <wakeup+0x40>
        p->state = RUNNABLE;
    800022d2:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    800022d6:	8526                	mv	a0,s1
    800022d8:	fffff097          	auipc	ra,0xfffff
    800022dc:	9fc080e7          	jalr	-1540(ra) # 80000cd4 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800022e0:	16848493          	addi	s1,s1,360
    800022e4:	03248463          	beq	s1,s2,8000230c <wakeup+0x64>
    if(p != myproc()){
    800022e8:	fffff097          	auipc	ra,0xfffff
    800022ec:	770080e7          	jalr	1904(ra) # 80001a58 <myproc>
    800022f0:	fea488e3          	beq	s1,a0,800022e0 <wakeup+0x38>
      acquire(&p->lock);
    800022f4:	8526                	mv	a0,s1
    800022f6:	fffff097          	auipc	ra,0xfffff
    800022fa:	92a080e7          	jalr	-1750(ra) # 80000c20 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800022fe:	4c9c                	lw	a5,24(s1)
    80002300:	fd379be3          	bne	a5,s3,800022d6 <wakeup+0x2e>
    80002304:	709c                	ld	a5,32(s1)
    80002306:	fd4798e3          	bne	a5,s4,800022d6 <wakeup+0x2e>
    8000230a:	b7e1                	j	800022d2 <wakeup+0x2a>
    }
  }
}
    8000230c:	70e2                	ld	ra,56(sp)
    8000230e:	7442                	ld	s0,48(sp)
    80002310:	74a2                	ld	s1,40(sp)
    80002312:	7902                	ld	s2,32(sp)
    80002314:	69e2                	ld	s3,24(sp)
    80002316:	6a42                	ld	s4,16(sp)
    80002318:	6aa2                	ld	s5,8(sp)
    8000231a:	6121                	addi	sp,sp,64
    8000231c:	8082                	ret

000000008000231e <reparent>:
{
    8000231e:	7179                	addi	sp,sp,-48
    80002320:	f406                	sd	ra,40(sp)
    80002322:	f022                	sd	s0,32(sp)
    80002324:	ec26                	sd	s1,24(sp)
    80002326:	e84a                	sd	s2,16(sp)
    80002328:	e44e                	sd	s3,8(sp)
    8000232a:	e052                	sd	s4,0(sp)
    8000232c:	1800                	addi	s0,sp,48
    8000232e:	89aa                	mv	s3,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002330:	0000f497          	auipc	s1,0xf
    80002334:	3a048493          	addi	s1,s1,928 # 800116d0 <proc>
      pp->parent = initproc;
    80002338:	00007a17          	auipc	s4,0x7
    8000233c:	cf0a0a13          	addi	s4,s4,-784 # 80009028 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002340:	00015917          	auipc	s2,0x15
    80002344:	d9090913          	addi	s2,s2,-624 # 800170d0 <tickslock>
    80002348:	a029                	j	80002352 <reparent+0x34>
    8000234a:	16848493          	addi	s1,s1,360
    8000234e:	01248d63          	beq	s1,s2,80002368 <reparent+0x4a>
    if(pp->parent == p){
    80002352:	7c9c                	ld	a5,56(s1)
    80002354:	ff379be3          	bne	a5,s3,8000234a <reparent+0x2c>
      pp->parent = initproc;
    80002358:	000a3503          	ld	a0,0(s4)
    8000235c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000235e:	00000097          	auipc	ra,0x0
    80002362:	f4a080e7          	jalr	-182(ra) # 800022a8 <wakeup>
    80002366:	b7d5                	j	8000234a <reparent+0x2c>
}
    80002368:	70a2                	ld	ra,40(sp)
    8000236a:	7402                	ld	s0,32(sp)
    8000236c:	64e2                	ld	s1,24(sp)
    8000236e:	6942                	ld	s2,16(sp)
    80002370:	69a2                	ld	s3,8(sp)
    80002372:	6a02                	ld	s4,0(sp)
    80002374:	6145                	addi	sp,sp,48
    80002376:	8082                	ret

0000000080002378 <exit>:
{
    80002378:	7179                	addi	sp,sp,-48
    8000237a:	f406                	sd	ra,40(sp)
    8000237c:	f022                	sd	s0,32(sp)
    8000237e:	ec26                	sd	s1,24(sp)
    80002380:	e84a                	sd	s2,16(sp)
    80002382:	e44e                	sd	s3,8(sp)
    80002384:	e052                	sd	s4,0(sp)
    80002386:	1800                	addi	s0,sp,48
    80002388:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000238a:	fffff097          	auipc	ra,0xfffff
    8000238e:	6ce080e7          	jalr	1742(ra) # 80001a58 <myproc>
    80002392:	89aa                	mv	s3,a0
  if(p == initproc)
    80002394:	00007797          	auipc	a5,0x7
    80002398:	c9478793          	addi	a5,a5,-876 # 80009028 <initproc>
    8000239c:	639c                	ld	a5,0(a5)
    8000239e:	0d050493          	addi	s1,a0,208
    800023a2:	15050913          	addi	s2,a0,336
    800023a6:	02a79363          	bne	a5,a0,800023cc <exit+0x54>
    panic("init exiting");
    800023aa:	00006517          	auipc	a0,0x6
    800023ae:	ece50513          	addi	a0,a0,-306 # 80008278 <states.1728+0xb8>
    800023b2:	ffffe097          	auipc	ra,0xffffe
    800023b6:	1a6080e7          	jalr	422(ra) # 80000558 <panic>
      fileclose(f);
    800023ba:	00002097          	auipc	ra,0x2
    800023be:	406080e7          	jalr	1030(ra) # 800047c0 <fileclose>
      p->ofile[fd] = 0;
    800023c2:	0004b023          	sd	zero,0(s1)
    800023c6:	04a1                	addi	s1,s1,8
  for(int fd = 0; fd < NOFILE; fd++){
    800023c8:	01248563          	beq	s1,s2,800023d2 <exit+0x5a>
    if(p->ofile[fd]){
    800023cc:	6088                	ld	a0,0(s1)
    800023ce:	f575                	bnez	a0,800023ba <exit+0x42>
    800023d0:	bfdd                	j	800023c6 <exit+0x4e>
  begin_op();
    800023d2:	00002097          	auipc	ra,0x2
    800023d6:	ef4080e7          	jalr	-268(ra) # 800042c6 <begin_op>
  iput(p->cwd);
    800023da:	1509b503          	ld	a0,336(s3)
    800023de:	00001097          	auipc	ra,0x1
    800023e2:	652080e7          	jalr	1618(ra) # 80003a30 <iput>
  end_op();
    800023e6:	00002097          	auipc	ra,0x2
    800023ea:	f60080e7          	jalr	-160(ra) # 80004346 <end_op>
  p->cwd = 0;
    800023ee:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800023f2:	0000f497          	auipc	s1,0xf
    800023f6:	ec648493          	addi	s1,s1,-314 # 800112b8 <wait_lock>
    800023fa:	8526                	mv	a0,s1
    800023fc:	fffff097          	auipc	ra,0xfffff
    80002400:	824080e7          	jalr	-2012(ra) # 80000c20 <acquire>
  reparent(p);
    80002404:	854e                	mv	a0,s3
    80002406:	00000097          	auipc	ra,0x0
    8000240a:	f18080e7          	jalr	-232(ra) # 8000231e <reparent>
  wakeup(p->parent);
    8000240e:	0389b503          	ld	a0,56(s3)
    80002412:	00000097          	auipc	ra,0x0
    80002416:	e96080e7          	jalr	-362(ra) # 800022a8 <wakeup>
  acquire(&p->lock);
    8000241a:	854e                	mv	a0,s3
    8000241c:	fffff097          	auipc	ra,0xfffff
    80002420:	804080e7          	jalr	-2044(ra) # 80000c20 <acquire>
  p->xstate = status;
    80002424:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002428:	4795                	li	a5,5
    8000242a:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000242e:	8526                	mv	a0,s1
    80002430:	fffff097          	auipc	ra,0xfffff
    80002434:	8a4080e7          	jalr	-1884(ra) # 80000cd4 <release>
  sched();
    80002438:	00000097          	auipc	ra,0x0
    8000243c:	bd0080e7          	jalr	-1072(ra) # 80002008 <sched>
  panic("zombie exit");
    80002440:	00006517          	auipc	a0,0x6
    80002444:	e4850513          	addi	a0,a0,-440 # 80008288 <states.1728+0xc8>
    80002448:	ffffe097          	auipc	ra,0xffffe
    8000244c:	110080e7          	jalr	272(ra) # 80000558 <panic>

0000000080002450 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002450:	7179                	addi	sp,sp,-48
    80002452:	f406                	sd	ra,40(sp)
    80002454:	f022                	sd	s0,32(sp)
    80002456:	ec26                	sd	s1,24(sp)
    80002458:	e84a                	sd	s2,16(sp)
    8000245a:	e44e                	sd	s3,8(sp)
    8000245c:	1800                	addi	s0,sp,48
    8000245e:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002460:	0000f497          	auipc	s1,0xf
    80002464:	27048493          	addi	s1,s1,624 # 800116d0 <proc>
    80002468:	00015997          	auipc	s3,0x15
    8000246c:	c6898993          	addi	s3,s3,-920 # 800170d0 <tickslock>
    acquire(&p->lock);
    80002470:	8526                	mv	a0,s1
    80002472:	ffffe097          	auipc	ra,0xffffe
    80002476:	7ae080e7          	jalr	1966(ra) # 80000c20 <acquire>
    if(p->pid == pid){
    8000247a:	589c                	lw	a5,48(s1)
    8000247c:	01278d63          	beq	a5,s2,80002496 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002480:	8526                	mv	a0,s1
    80002482:	fffff097          	auipc	ra,0xfffff
    80002486:	852080e7          	jalr	-1966(ra) # 80000cd4 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000248a:	16848493          	addi	s1,s1,360
    8000248e:	ff3491e3          	bne	s1,s3,80002470 <kill+0x20>
  }
  return -1;
    80002492:	557d                	li	a0,-1
    80002494:	a829                	j	800024ae <kill+0x5e>
      p->killed = 1;
    80002496:	4785                	li	a5,1
    80002498:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000249a:	4c98                	lw	a4,24(s1)
    8000249c:	4789                	li	a5,2
    8000249e:	00f70f63          	beq	a4,a5,800024bc <kill+0x6c>
      release(&p->lock);
    800024a2:	8526                	mv	a0,s1
    800024a4:	fffff097          	auipc	ra,0xfffff
    800024a8:	830080e7          	jalr	-2000(ra) # 80000cd4 <release>
      return 0;
    800024ac:	4501                	li	a0,0
}
    800024ae:	70a2                	ld	ra,40(sp)
    800024b0:	7402                	ld	s0,32(sp)
    800024b2:	64e2                	ld	s1,24(sp)
    800024b4:	6942                	ld	s2,16(sp)
    800024b6:	69a2                	ld	s3,8(sp)
    800024b8:	6145                	addi	sp,sp,48
    800024ba:	8082                	ret
        p->state = RUNNABLE;
    800024bc:	478d                	li	a5,3
    800024be:	cc9c                	sw	a5,24(s1)
    800024c0:	b7cd                	j	800024a2 <kill+0x52>

00000000800024c2 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800024c2:	7179                	addi	sp,sp,-48
    800024c4:	f406                	sd	ra,40(sp)
    800024c6:	f022                	sd	s0,32(sp)
    800024c8:	ec26                	sd	s1,24(sp)
    800024ca:	e84a                	sd	s2,16(sp)
    800024cc:	e44e                	sd	s3,8(sp)
    800024ce:	e052                	sd	s4,0(sp)
    800024d0:	1800                	addi	s0,sp,48
    800024d2:	84aa                	mv	s1,a0
    800024d4:	892e                	mv	s2,a1
    800024d6:	89b2                	mv	s3,a2
    800024d8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800024da:	fffff097          	auipc	ra,0xfffff
    800024de:	57e080e7          	jalr	1406(ra) # 80001a58 <myproc>
  if(user_dst){
    800024e2:	c08d                	beqz	s1,80002504 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800024e4:	86d2                	mv	a3,s4
    800024e6:	864e                	mv	a2,s3
    800024e8:	85ca                	mv	a1,s2
    800024ea:	6928                	ld	a0,80(a0)
    800024ec:	fffff097          	auipc	ra,0xfffff
    800024f0:	216080e7          	jalr	534(ra) # 80001702 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800024f4:	70a2                	ld	ra,40(sp)
    800024f6:	7402                	ld	s0,32(sp)
    800024f8:	64e2                	ld	s1,24(sp)
    800024fa:	6942                	ld	s2,16(sp)
    800024fc:	69a2                	ld	s3,8(sp)
    800024fe:	6a02                	ld	s4,0(sp)
    80002500:	6145                	addi	sp,sp,48
    80002502:	8082                	ret
    memmove((char *)dst, src, len);
    80002504:	000a061b          	sext.w	a2,s4
    80002508:	85ce                	mv	a1,s3
    8000250a:	854a                	mv	a0,s2
    8000250c:	fffff097          	auipc	ra,0xfffff
    80002510:	87c080e7          	jalr	-1924(ra) # 80000d88 <memmove>
    return 0;
    80002514:	8526                	mv	a0,s1
    80002516:	bff9                	j	800024f4 <either_copyout+0x32>

0000000080002518 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002518:	7179                	addi	sp,sp,-48
    8000251a:	f406                	sd	ra,40(sp)
    8000251c:	f022                	sd	s0,32(sp)
    8000251e:	ec26                	sd	s1,24(sp)
    80002520:	e84a                	sd	s2,16(sp)
    80002522:	e44e                	sd	s3,8(sp)
    80002524:	e052                	sd	s4,0(sp)
    80002526:	1800                	addi	s0,sp,48
    80002528:	892a                	mv	s2,a0
    8000252a:	84ae                	mv	s1,a1
    8000252c:	89b2                	mv	s3,a2
    8000252e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002530:	fffff097          	auipc	ra,0xfffff
    80002534:	528080e7          	jalr	1320(ra) # 80001a58 <myproc>
  if(user_src){
    80002538:	c08d                	beqz	s1,8000255a <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000253a:	86d2                	mv	a3,s4
    8000253c:	864e                	mv	a2,s3
    8000253e:	85ca                	mv	a1,s2
    80002540:	6928                	ld	a0,80(a0)
    80002542:	fffff097          	auipc	ra,0xfffff
    80002546:	24c080e7          	jalr	588(ra) # 8000178e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000254a:	70a2                	ld	ra,40(sp)
    8000254c:	7402                	ld	s0,32(sp)
    8000254e:	64e2                	ld	s1,24(sp)
    80002550:	6942                	ld	s2,16(sp)
    80002552:	69a2                	ld	s3,8(sp)
    80002554:	6a02                	ld	s4,0(sp)
    80002556:	6145                	addi	sp,sp,48
    80002558:	8082                	ret
    memmove(dst, (char*)src, len);
    8000255a:	000a061b          	sext.w	a2,s4
    8000255e:	85ce                	mv	a1,s3
    80002560:	854a                	mv	a0,s2
    80002562:	fffff097          	auipc	ra,0xfffff
    80002566:	826080e7          	jalr	-2010(ra) # 80000d88 <memmove>
    return 0;
    8000256a:	8526                	mv	a0,s1
    8000256c:	bff9                	j	8000254a <either_copyin+0x32>

000000008000256e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000256e:	715d                	addi	sp,sp,-80
    80002570:	e486                	sd	ra,72(sp)
    80002572:	e0a2                	sd	s0,64(sp)
    80002574:	fc26                	sd	s1,56(sp)
    80002576:	f84a                	sd	s2,48(sp)
    80002578:	f44e                	sd	s3,40(sp)
    8000257a:	f052                	sd	s4,32(sp)
    8000257c:	ec56                	sd	s5,24(sp)
    8000257e:	e85a                	sd	s6,16(sp)
    80002580:	e45e                	sd	s7,8(sp)
    80002582:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002584:	00006517          	auipc	a0,0x6
    80002588:	b4450513          	addi	a0,a0,-1212 # 800080c8 <digits+0xb0>
    8000258c:	ffffe097          	auipc	ra,0xffffe
    80002590:	016080e7          	jalr	22(ra) # 800005a2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002594:	0000f497          	auipc	s1,0xf
    80002598:	29448493          	addi	s1,s1,660 # 80011828 <proc+0x158>
    8000259c:	00015917          	auipc	s2,0x15
    800025a0:	c8c90913          	addi	s2,s2,-884 # 80017228 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025a4:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800025a6:	00006997          	auipc	s3,0x6
    800025aa:	cf298993          	addi	s3,s3,-782 # 80008298 <states.1728+0xd8>
    printf("%d %s %s", p->pid, state, p->name);
    800025ae:	00006a97          	auipc	s5,0x6
    800025b2:	cf2a8a93          	addi	s5,s5,-782 # 800082a0 <states.1728+0xe0>
    printf("\n");
    800025b6:	00006a17          	auipc	s4,0x6
    800025ba:	b12a0a13          	addi	s4,s4,-1262 # 800080c8 <digits+0xb0>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025be:	00006b97          	auipc	s7,0x6
    800025c2:	c02b8b93          	addi	s7,s7,-1022 # 800081c0 <states.1728>
    800025c6:	a015                	j	800025ea <procdump+0x7c>
    printf("%d %s %s", p->pid, state, p->name);
    800025c8:	86ba                	mv	a3,a4
    800025ca:	ed872583          	lw	a1,-296(a4)
    800025ce:	8556                	mv	a0,s5
    800025d0:	ffffe097          	auipc	ra,0xffffe
    800025d4:	fd2080e7          	jalr	-46(ra) # 800005a2 <printf>
    printf("\n");
    800025d8:	8552                	mv	a0,s4
    800025da:	ffffe097          	auipc	ra,0xffffe
    800025de:	fc8080e7          	jalr	-56(ra) # 800005a2 <printf>
    800025e2:	16848493          	addi	s1,s1,360
  for(p = proc; p < &proc[NPROC]; p++){
    800025e6:	03248163          	beq	s1,s2,80002608 <procdump+0x9a>
    if(p->state == UNUSED)
    800025ea:	8726                	mv	a4,s1
    800025ec:	ec04a783          	lw	a5,-320(s1)
    800025f0:	dbed                	beqz	a5,800025e2 <procdump+0x74>
      state = "???";
    800025f2:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025f4:	fcfb6ae3          	bltu	s6,a5,800025c8 <procdump+0x5a>
    800025f8:	1782                	slli	a5,a5,0x20
    800025fa:	9381                	srli	a5,a5,0x20
    800025fc:	078e                	slli	a5,a5,0x3
    800025fe:	97de                	add	a5,a5,s7
    80002600:	6390                	ld	a2,0(a5)
    80002602:	f279                	bnez	a2,800025c8 <procdump+0x5a>
      state = "???";
    80002604:	864e                	mv	a2,s3
    80002606:	b7c9                	j	800025c8 <procdump+0x5a>
  }
}
    80002608:	60a6                	ld	ra,72(sp)
    8000260a:	6406                	ld	s0,64(sp)
    8000260c:	74e2                	ld	s1,56(sp)
    8000260e:	7942                	ld	s2,48(sp)
    80002610:	79a2                	ld	s3,40(sp)
    80002612:	7a02                	ld	s4,32(sp)
    80002614:	6ae2                	ld	s5,24(sp)
    80002616:	6b42                	ld	s6,16(sp)
    80002618:	6ba2                	ld	s7,8(sp)
    8000261a:	6161                	addi	sp,sp,80
    8000261c:	8082                	ret

000000008000261e <swtch>:
    8000261e:	00153023          	sd	ra,0(a0)
    80002622:	00253423          	sd	sp,8(a0)
    80002626:	e900                	sd	s0,16(a0)
    80002628:	ed04                	sd	s1,24(a0)
    8000262a:	03253023          	sd	s2,32(a0)
    8000262e:	03353423          	sd	s3,40(a0)
    80002632:	03453823          	sd	s4,48(a0)
    80002636:	03553c23          	sd	s5,56(a0)
    8000263a:	05653023          	sd	s6,64(a0)
    8000263e:	05753423          	sd	s7,72(a0)
    80002642:	05853823          	sd	s8,80(a0)
    80002646:	05953c23          	sd	s9,88(a0)
    8000264a:	07a53023          	sd	s10,96(a0)
    8000264e:	07b53423          	sd	s11,104(a0)
    80002652:	0005b083          	ld	ra,0(a1)
    80002656:	0085b103          	ld	sp,8(a1)
    8000265a:	6980                	ld	s0,16(a1)
    8000265c:	6d84                	ld	s1,24(a1)
    8000265e:	0205b903          	ld	s2,32(a1)
    80002662:	0285b983          	ld	s3,40(a1)
    80002666:	0305ba03          	ld	s4,48(a1)
    8000266a:	0385ba83          	ld	s5,56(a1)
    8000266e:	0405bb03          	ld	s6,64(a1)
    80002672:	0485bb83          	ld	s7,72(a1)
    80002676:	0505bc03          	ld	s8,80(a1)
    8000267a:	0585bc83          	ld	s9,88(a1)
    8000267e:	0605bd03          	ld	s10,96(a1)
    80002682:	0685bd83          	ld	s11,104(a1)
    80002686:	8082                	ret

0000000080002688 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002688:	1141                	addi	sp,sp,-16
    8000268a:	e406                	sd	ra,8(sp)
    8000268c:	e022                	sd	s0,0(sp)
    8000268e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002690:	00006597          	auipc	a1,0x6
    80002694:	c4858593          	addi	a1,a1,-952 # 800082d8 <states.1728+0x118>
    80002698:	00015517          	auipc	a0,0x15
    8000269c:	a3850513          	addi	a0,a0,-1480 # 800170d0 <tickslock>
    800026a0:	ffffe097          	auipc	ra,0xffffe
    800026a4:	4f0080e7          	jalr	1264(ra) # 80000b90 <initlock>
}
    800026a8:	60a2                	ld	ra,8(sp)
    800026aa:	6402                	ld	s0,0(sp)
    800026ac:	0141                	addi	sp,sp,16
    800026ae:	8082                	ret

00000000800026b0 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800026b0:	1141                	addi	sp,sp,-16
    800026b2:	e422                	sd	s0,8(sp)
    800026b4:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800026b6:	00004797          	auipc	a5,0x4
    800026ba:	90a78793          	addi	a5,a5,-1782 # 80005fc0 <kernelvec>
    800026be:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800026c2:	6422                	ld	s0,8(sp)
    800026c4:	0141                	addi	sp,sp,16
    800026c6:	8082                	ret

00000000800026c8 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800026c8:	1141                	addi	sp,sp,-16
    800026ca:	e406                	sd	ra,8(sp)
    800026cc:	e022                	sd	s0,0(sp)
    800026ce:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800026d0:	fffff097          	auipc	ra,0xfffff
    800026d4:	388080e7          	jalr	904(ra) # 80001a58 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026d8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800026dc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026de:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    800026e2:	00005617          	auipc	a2,0x5
    800026e6:	91e60613          	addi	a2,a2,-1762 # 80007000 <_trampoline>
    800026ea:	00005697          	auipc	a3,0x5
    800026ee:	91668693          	addi	a3,a3,-1770 # 80007000 <_trampoline>
    800026f2:	8e91                	sub	a3,a3,a2
    800026f4:	040007b7          	lui	a5,0x4000
    800026f8:	17fd                	addi	a5,a5,-1
    800026fa:	07b2                	slli	a5,a5,0xc
    800026fc:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800026fe:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002702:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002704:	180026f3          	csrr	a3,satp
    80002708:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000270a:	6d38                	ld	a4,88(a0)
    8000270c:	6134                	ld	a3,64(a0)
    8000270e:	6585                	lui	a1,0x1
    80002710:	96ae                	add	a3,a3,a1
    80002712:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002714:	6d38                	ld	a4,88(a0)
    80002716:	00000697          	auipc	a3,0x0
    8000271a:	13868693          	addi	a3,a3,312 # 8000284e <usertrap>
    8000271e:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002720:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002722:	8692                	mv	a3,tp
    80002724:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002726:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000272a:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000272e:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002732:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002736:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002738:	6f18                	ld	a4,24(a4)
    8000273a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    8000273e:	692c                	ld	a1,80(a0)
    80002740:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002742:	00005717          	auipc	a4,0x5
    80002746:	94e70713          	addi	a4,a4,-1714 # 80007090 <userret>
    8000274a:	8f11                	sub	a4,a4,a2
    8000274c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    8000274e:	577d                	li	a4,-1
    80002750:	177e                	slli	a4,a4,0x3f
    80002752:	8dd9                	or	a1,a1,a4
    80002754:	02000537          	lui	a0,0x2000
    80002758:	157d                	addi	a0,a0,-1
    8000275a:	0536                	slli	a0,a0,0xd
    8000275c:	9782                	jalr	a5
}
    8000275e:	60a2                	ld	ra,8(sp)
    80002760:	6402                	ld	s0,0(sp)
    80002762:	0141                	addi	sp,sp,16
    80002764:	8082                	ret

0000000080002766 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002766:	1101                	addi	sp,sp,-32
    80002768:	ec06                	sd	ra,24(sp)
    8000276a:	e822                	sd	s0,16(sp)
    8000276c:	e426                	sd	s1,8(sp)
    8000276e:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002770:	00015497          	auipc	s1,0x15
    80002774:	96048493          	addi	s1,s1,-1696 # 800170d0 <tickslock>
    80002778:	8526                	mv	a0,s1
    8000277a:	ffffe097          	auipc	ra,0xffffe
    8000277e:	4a6080e7          	jalr	1190(ra) # 80000c20 <acquire>
  ticks++;
    80002782:	00007517          	auipc	a0,0x7
    80002786:	8ae50513          	addi	a0,a0,-1874 # 80009030 <ticks>
    8000278a:	411c                	lw	a5,0(a0)
    8000278c:	2785                	addiw	a5,a5,1
    8000278e:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002790:	00000097          	auipc	ra,0x0
    80002794:	b18080e7          	jalr	-1256(ra) # 800022a8 <wakeup>
  release(&tickslock);
    80002798:	8526                	mv	a0,s1
    8000279a:	ffffe097          	auipc	ra,0xffffe
    8000279e:	53a080e7          	jalr	1338(ra) # 80000cd4 <release>
}
    800027a2:	60e2                	ld	ra,24(sp)
    800027a4:	6442                	ld	s0,16(sp)
    800027a6:	64a2                	ld	s1,8(sp)
    800027a8:	6105                	addi	sp,sp,32
    800027aa:	8082                	ret

00000000800027ac <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800027ac:	1101                	addi	sp,sp,-32
    800027ae:	ec06                	sd	ra,24(sp)
    800027b0:	e822                	sd	s0,16(sp)
    800027b2:	e426                	sd	s1,8(sp)
    800027b4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800027b6:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    800027ba:	00074d63          	bltz	a4,800027d4 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    800027be:	57fd                	li	a5,-1
    800027c0:	17fe                	slli	a5,a5,0x3f
    800027c2:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    800027c4:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    800027c6:	06f70363          	beq	a4,a5,8000282c <devintr+0x80>
  }
}
    800027ca:	60e2                	ld	ra,24(sp)
    800027cc:	6442                	ld	s0,16(sp)
    800027ce:	64a2                	ld	s1,8(sp)
    800027d0:	6105                	addi	sp,sp,32
    800027d2:	8082                	ret
     (scause & 0xff) == 9){
    800027d4:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    800027d8:	46a5                	li	a3,9
    800027da:	fed792e3          	bne	a5,a3,800027be <devintr+0x12>
    int irq = plic_claim();
    800027de:	00004097          	auipc	ra,0x4
    800027e2:	8ea080e7          	jalr	-1814(ra) # 800060c8 <plic_claim>
    800027e6:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800027e8:	47a9                	li	a5,10
    800027ea:	02f50763          	beq	a0,a5,80002818 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    800027ee:	4785                	li	a5,1
    800027f0:	02f50963          	beq	a0,a5,80002822 <devintr+0x76>
    return 1;
    800027f4:	4505                	li	a0,1
    } else if(irq){
    800027f6:	d8f1                	beqz	s1,800027ca <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    800027f8:	85a6                	mv	a1,s1
    800027fa:	00006517          	auipc	a0,0x6
    800027fe:	ae650513          	addi	a0,a0,-1306 # 800082e0 <states.1728+0x120>
    80002802:	ffffe097          	auipc	ra,0xffffe
    80002806:	da0080e7          	jalr	-608(ra) # 800005a2 <printf>
      plic_complete(irq);
    8000280a:	8526                	mv	a0,s1
    8000280c:	00004097          	auipc	ra,0x4
    80002810:	8e0080e7          	jalr	-1824(ra) # 800060ec <plic_complete>
    return 1;
    80002814:	4505                	li	a0,1
    80002816:	bf55                	j	800027ca <devintr+0x1e>
      uartintr();
    80002818:	ffffe097          	auipc	ra,0xffffe
    8000281c:	1c8080e7          	jalr	456(ra) # 800009e0 <uartintr>
    80002820:	b7ed                	j	8000280a <devintr+0x5e>
      virtio_disk_intr();
    80002822:	00004097          	auipc	ra,0x4
    80002826:	dc8080e7          	jalr	-568(ra) # 800065ea <virtio_disk_intr>
    8000282a:	b7c5                	j	8000280a <devintr+0x5e>
    if(cpuid() == 0){
    8000282c:	fffff097          	auipc	ra,0xfffff
    80002830:	200080e7          	jalr	512(ra) # 80001a2c <cpuid>
    80002834:	c901                	beqz	a0,80002844 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002836:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    8000283a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    8000283c:	14479073          	csrw	sip,a5
    return 2;
    80002840:	4509                	li	a0,2
    80002842:	b761                	j	800027ca <devintr+0x1e>
      clockintr();
    80002844:	00000097          	auipc	ra,0x0
    80002848:	f22080e7          	jalr	-222(ra) # 80002766 <clockintr>
    8000284c:	b7ed                	j	80002836 <devintr+0x8a>

000000008000284e <usertrap>:
{
    8000284e:	1101                	addi	sp,sp,-32
    80002850:	ec06                	sd	ra,24(sp)
    80002852:	e822                	sd	s0,16(sp)
    80002854:	e426                	sd	s1,8(sp)
    80002856:	e04a                	sd	s2,0(sp)
    80002858:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000285a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    8000285e:	1007f793          	andi	a5,a5,256
    80002862:	e3ad                	bnez	a5,800028c4 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002864:	00003797          	auipc	a5,0x3
    80002868:	75c78793          	addi	a5,a5,1884 # 80005fc0 <kernelvec>
    8000286c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002870:	fffff097          	auipc	ra,0xfffff
    80002874:	1e8080e7          	jalr	488(ra) # 80001a58 <myproc>
    80002878:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000287a:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000287c:	14102773          	csrr	a4,sepc
    80002880:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002882:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002886:	47a1                	li	a5,8
    80002888:	04f71c63          	bne	a4,a5,800028e0 <usertrap+0x92>
    if(p->killed)
    8000288c:	551c                	lw	a5,40(a0)
    8000288e:	e3b9                	bnez	a5,800028d4 <usertrap+0x86>
    p->trapframe->epc += 4;
    80002890:	6cb8                	ld	a4,88(s1)
    80002892:	6f1c                	ld	a5,24(a4)
    80002894:	0791                	addi	a5,a5,4
    80002896:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002898:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000289c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800028a0:	10079073          	csrw	sstatus,a5
    syscall();
    800028a4:	00000097          	auipc	ra,0x0
    800028a8:	2e6080e7          	jalr	742(ra) # 80002b8a <syscall>
  if(p->killed)
    800028ac:	549c                	lw	a5,40(s1)
    800028ae:	ebc1                	bnez	a5,8000293e <usertrap+0xf0>
  usertrapret();
    800028b0:	00000097          	auipc	ra,0x0
    800028b4:	e18080e7          	jalr	-488(ra) # 800026c8 <usertrapret>
}
    800028b8:	60e2                	ld	ra,24(sp)
    800028ba:	6442                	ld	s0,16(sp)
    800028bc:	64a2                	ld	s1,8(sp)
    800028be:	6902                	ld	s2,0(sp)
    800028c0:	6105                	addi	sp,sp,32
    800028c2:	8082                	ret
    panic("usertrap: not from user mode");
    800028c4:	00006517          	auipc	a0,0x6
    800028c8:	a3c50513          	addi	a0,a0,-1476 # 80008300 <states.1728+0x140>
    800028cc:	ffffe097          	auipc	ra,0xffffe
    800028d0:	c8c080e7          	jalr	-884(ra) # 80000558 <panic>
      exit(-1);
    800028d4:	557d                	li	a0,-1
    800028d6:	00000097          	auipc	ra,0x0
    800028da:	aa2080e7          	jalr	-1374(ra) # 80002378 <exit>
    800028de:	bf4d                	j	80002890 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    800028e0:	00000097          	auipc	ra,0x0
    800028e4:	ecc080e7          	jalr	-308(ra) # 800027ac <devintr>
    800028e8:	892a                	mv	s2,a0
    800028ea:	c501                	beqz	a0,800028f2 <usertrap+0xa4>
  if(p->killed)
    800028ec:	549c                	lw	a5,40(s1)
    800028ee:	c3a1                	beqz	a5,8000292e <usertrap+0xe0>
    800028f0:	a815                	j	80002924 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028f2:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    800028f6:	5890                	lw	a2,48(s1)
    800028f8:	00006517          	auipc	a0,0x6
    800028fc:	a2850513          	addi	a0,a0,-1496 # 80008320 <states.1728+0x160>
    80002900:	ffffe097          	auipc	ra,0xffffe
    80002904:	ca2080e7          	jalr	-862(ra) # 800005a2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002908:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000290c:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002910:	00006517          	auipc	a0,0x6
    80002914:	a4050513          	addi	a0,a0,-1472 # 80008350 <states.1728+0x190>
    80002918:	ffffe097          	auipc	ra,0xffffe
    8000291c:	c8a080e7          	jalr	-886(ra) # 800005a2 <printf>
    p->killed = 1;
    80002920:	4785                	li	a5,1
    80002922:	d49c                	sw	a5,40(s1)
    exit(-1);
    80002924:	557d                	li	a0,-1
    80002926:	00000097          	auipc	ra,0x0
    8000292a:	a52080e7          	jalr	-1454(ra) # 80002378 <exit>
  if(which_dev == 2)
    8000292e:	4789                	li	a5,2
    80002930:	f8f910e3          	bne	s2,a5,800028b0 <usertrap+0x62>
    yield();
    80002934:	fffff097          	auipc	ra,0xfffff
    80002938:	7ac080e7          	jalr	1964(ra) # 800020e0 <yield>
    8000293c:	bf95                	j	800028b0 <usertrap+0x62>
  int which_dev = 0;
    8000293e:	4901                	li	s2,0
    80002940:	b7d5                	j	80002924 <usertrap+0xd6>

0000000080002942 <kerneltrap>:
{
    80002942:	7179                	addi	sp,sp,-48
    80002944:	f406                	sd	ra,40(sp)
    80002946:	f022                	sd	s0,32(sp)
    80002948:	ec26                	sd	s1,24(sp)
    8000294a:	e84a                	sd	s2,16(sp)
    8000294c:	e44e                	sd	s3,8(sp)
    8000294e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002950:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002954:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002958:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    8000295c:	1004f793          	andi	a5,s1,256
    80002960:	cb85                	beqz	a5,80002990 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002962:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002966:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002968:	ef85                	bnez	a5,800029a0 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    8000296a:	00000097          	auipc	ra,0x0
    8000296e:	e42080e7          	jalr	-446(ra) # 800027ac <devintr>
    80002972:	cd1d                	beqz	a0,800029b0 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002974:	4789                	li	a5,2
    80002976:	06f50a63          	beq	a0,a5,800029ea <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000297a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000297e:	10049073          	csrw	sstatus,s1
}
    80002982:	70a2                	ld	ra,40(sp)
    80002984:	7402                	ld	s0,32(sp)
    80002986:	64e2                	ld	s1,24(sp)
    80002988:	6942                	ld	s2,16(sp)
    8000298a:	69a2                	ld	s3,8(sp)
    8000298c:	6145                	addi	sp,sp,48
    8000298e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002990:	00006517          	auipc	a0,0x6
    80002994:	9e050513          	addi	a0,a0,-1568 # 80008370 <states.1728+0x1b0>
    80002998:	ffffe097          	auipc	ra,0xffffe
    8000299c:	bc0080e7          	jalr	-1088(ra) # 80000558 <panic>
    panic("kerneltrap: interrupts enabled");
    800029a0:	00006517          	auipc	a0,0x6
    800029a4:	9f850513          	addi	a0,a0,-1544 # 80008398 <states.1728+0x1d8>
    800029a8:	ffffe097          	auipc	ra,0xffffe
    800029ac:	bb0080e7          	jalr	-1104(ra) # 80000558 <panic>
    printf("scause %p\n", scause);
    800029b0:	85ce                	mv	a1,s3
    800029b2:	00006517          	auipc	a0,0x6
    800029b6:	a0650513          	addi	a0,a0,-1530 # 800083b8 <states.1728+0x1f8>
    800029ba:	ffffe097          	auipc	ra,0xffffe
    800029be:	be8080e7          	jalr	-1048(ra) # 800005a2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800029c2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800029c6:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800029ca:	00006517          	auipc	a0,0x6
    800029ce:	9fe50513          	addi	a0,a0,-1538 # 800083c8 <states.1728+0x208>
    800029d2:	ffffe097          	auipc	ra,0xffffe
    800029d6:	bd0080e7          	jalr	-1072(ra) # 800005a2 <printf>
    panic("kerneltrap");
    800029da:	00006517          	auipc	a0,0x6
    800029de:	a0650513          	addi	a0,a0,-1530 # 800083e0 <states.1728+0x220>
    800029e2:	ffffe097          	auipc	ra,0xffffe
    800029e6:	b76080e7          	jalr	-1162(ra) # 80000558 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800029ea:	fffff097          	auipc	ra,0xfffff
    800029ee:	06e080e7          	jalr	110(ra) # 80001a58 <myproc>
    800029f2:	d541                	beqz	a0,8000297a <kerneltrap+0x38>
    800029f4:	fffff097          	auipc	ra,0xfffff
    800029f8:	064080e7          	jalr	100(ra) # 80001a58 <myproc>
    800029fc:	4d18                	lw	a4,24(a0)
    800029fe:	4791                	li	a5,4
    80002a00:	f6f71de3          	bne	a4,a5,8000297a <kerneltrap+0x38>
    yield();
    80002a04:	fffff097          	auipc	ra,0xfffff
    80002a08:	6dc080e7          	jalr	1756(ra) # 800020e0 <yield>
    80002a0c:	b7bd                	j	8000297a <kerneltrap+0x38>

0000000080002a0e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002a0e:	1101                	addi	sp,sp,-32
    80002a10:	ec06                	sd	ra,24(sp)
    80002a12:	e822                	sd	s0,16(sp)
    80002a14:	e426                	sd	s1,8(sp)
    80002a16:	1000                	addi	s0,sp,32
    80002a18:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002a1a:	fffff097          	auipc	ra,0xfffff
    80002a1e:	03e080e7          	jalr	62(ra) # 80001a58 <myproc>
  switch (n) {
    80002a22:	4795                	li	a5,5
    80002a24:	0497e363          	bltu	a5,s1,80002a6a <argraw+0x5c>
    80002a28:	1482                	slli	s1,s1,0x20
    80002a2a:	9081                	srli	s1,s1,0x20
    80002a2c:	048a                	slli	s1,s1,0x2
    80002a2e:	00006717          	auipc	a4,0x6
    80002a32:	9c270713          	addi	a4,a4,-1598 # 800083f0 <states.1728+0x230>
    80002a36:	94ba                	add	s1,s1,a4
    80002a38:	409c                	lw	a5,0(s1)
    80002a3a:	97ba                	add	a5,a5,a4
    80002a3c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002a3e:	6d3c                	ld	a5,88(a0)
    80002a40:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002a42:	60e2                	ld	ra,24(sp)
    80002a44:	6442                	ld	s0,16(sp)
    80002a46:	64a2                	ld	s1,8(sp)
    80002a48:	6105                	addi	sp,sp,32
    80002a4a:	8082                	ret
    return p->trapframe->a1;
    80002a4c:	6d3c                	ld	a5,88(a0)
    80002a4e:	7fa8                	ld	a0,120(a5)
    80002a50:	bfcd                	j	80002a42 <argraw+0x34>
    return p->trapframe->a2;
    80002a52:	6d3c                	ld	a5,88(a0)
    80002a54:	63c8                	ld	a0,128(a5)
    80002a56:	b7f5                	j	80002a42 <argraw+0x34>
    return p->trapframe->a3;
    80002a58:	6d3c                	ld	a5,88(a0)
    80002a5a:	67c8                	ld	a0,136(a5)
    80002a5c:	b7dd                	j	80002a42 <argraw+0x34>
    return p->trapframe->a4;
    80002a5e:	6d3c                	ld	a5,88(a0)
    80002a60:	6bc8                	ld	a0,144(a5)
    80002a62:	b7c5                	j	80002a42 <argraw+0x34>
    return p->trapframe->a5;
    80002a64:	6d3c                	ld	a5,88(a0)
    80002a66:	6fc8                	ld	a0,152(a5)
    80002a68:	bfe9                	j	80002a42 <argraw+0x34>
  panic("argraw");
    80002a6a:	00006517          	auipc	a0,0x6
    80002a6e:	a5650513          	addi	a0,a0,-1450 # 800084c0 <syscalls+0xb8>
    80002a72:	ffffe097          	auipc	ra,0xffffe
    80002a76:	ae6080e7          	jalr	-1306(ra) # 80000558 <panic>

0000000080002a7a <fetchaddr>:
{
    80002a7a:	1101                	addi	sp,sp,-32
    80002a7c:	ec06                	sd	ra,24(sp)
    80002a7e:	e822                	sd	s0,16(sp)
    80002a80:	e426                	sd	s1,8(sp)
    80002a82:	e04a                	sd	s2,0(sp)
    80002a84:	1000                	addi	s0,sp,32
    80002a86:	84aa                	mv	s1,a0
    80002a88:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002a8a:	fffff097          	auipc	ra,0xfffff
    80002a8e:	fce080e7          	jalr	-50(ra) # 80001a58 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002a92:	653c                	ld	a5,72(a0)
    80002a94:	02f4f963          	bleu	a5,s1,80002ac6 <fetchaddr+0x4c>
    80002a98:	00848713          	addi	a4,s1,8
    80002a9c:	02e7e763          	bltu	a5,a4,80002aca <fetchaddr+0x50>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002aa0:	46a1                	li	a3,8
    80002aa2:	8626                	mv	a2,s1
    80002aa4:	85ca                	mv	a1,s2
    80002aa6:	6928                	ld	a0,80(a0)
    80002aa8:	fffff097          	auipc	ra,0xfffff
    80002aac:	ce6080e7          	jalr	-794(ra) # 8000178e <copyin>
    80002ab0:	00a03533          	snez	a0,a0
    80002ab4:	40a0053b          	negw	a0,a0
    80002ab8:	2501                	sext.w	a0,a0
}
    80002aba:	60e2                	ld	ra,24(sp)
    80002abc:	6442                	ld	s0,16(sp)
    80002abe:	64a2                	ld	s1,8(sp)
    80002ac0:	6902                	ld	s2,0(sp)
    80002ac2:	6105                	addi	sp,sp,32
    80002ac4:	8082                	ret
    return -1;
    80002ac6:	557d                	li	a0,-1
    80002ac8:	bfcd                	j	80002aba <fetchaddr+0x40>
    80002aca:	557d                	li	a0,-1
    80002acc:	b7fd                	j	80002aba <fetchaddr+0x40>

0000000080002ace <fetchstr>:
{
    80002ace:	7179                	addi	sp,sp,-48
    80002ad0:	f406                	sd	ra,40(sp)
    80002ad2:	f022                	sd	s0,32(sp)
    80002ad4:	ec26                	sd	s1,24(sp)
    80002ad6:	e84a                	sd	s2,16(sp)
    80002ad8:	e44e                	sd	s3,8(sp)
    80002ada:	1800                	addi	s0,sp,48
    80002adc:	892a                	mv	s2,a0
    80002ade:	84ae                	mv	s1,a1
    80002ae0:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002ae2:	fffff097          	auipc	ra,0xfffff
    80002ae6:	f76080e7          	jalr	-138(ra) # 80001a58 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002aea:	86ce                	mv	a3,s3
    80002aec:	864a                	mv	a2,s2
    80002aee:	85a6                	mv	a1,s1
    80002af0:	6928                	ld	a0,80(a0)
    80002af2:	fffff097          	auipc	ra,0xfffff
    80002af6:	d2a080e7          	jalr	-726(ra) # 8000181c <copyinstr>
  if(err < 0)
    80002afa:	00054763          	bltz	a0,80002b08 <fetchstr+0x3a>
  return strlen(buf);
    80002afe:	8526                	mv	a0,s1
    80002b00:	ffffe097          	auipc	ra,0xffffe
    80002b04:	3c6080e7          	jalr	966(ra) # 80000ec6 <strlen>
}
    80002b08:	70a2                	ld	ra,40(sp)
    80002b0a:	7402                	ld	s0,32(sp)
    80002b0c:	64e2                	ld	s1,24(sp)
    80002b0e:	6942                	ld	s2,16(sp)
    80002b10:	69a2                	ld	s3,8(sp)
    80002b12:	6145                	addi	sp,sp,48
    80002b14:	8082                	ret

0000000080002b16 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002b16:	1101                	addi	sp,sp,-32
    80002b18:	ec06                	sd	ra,24(sp)
    80002b1a:	e822                	sd	s0,16(sp)
    80002b1c:	e426                	sd	s1,8(sp)
    80002b1e:	1000                	addi	s0,sp,32
    80002b20:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002b22:	00000097          	auipc	ra,0x0
    80002b26:	eec080e7          	jalr	-276(ra) # 80002a0e <argraw>
    80002b2a:	c088                	sw	a0,0(s1)
  return 0;
}
    80002b2c:	4501                	li	a0,0
    80002b2e:	60e2                	ld	ra,24(sp)
    80002b30:	6442                	ld	s0,16(sp)
    80002b32:	64a2                	ld	s1,8(sp)
    80002b34:	6105                	addi	sp,sp,32
    80002b36:	8082                	ret

0000000080002b38 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002b38:	1101                	addi	sp,sp,-32
    80002b3a:	ec06                	sd	ra,24(sp)
    80002b3c:	e822                	sd	s0,16(sp)
    80002b3e:	e426                	sd	s1,8(sp)
    80002b40:	1000                	addi	s0,sp,32
    80002b42:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002b44:	00000097          	auipc	ra,0x0
    80002b48:	eca080e7          	jalr	-310(ra) # 80002a0e <argraw>
    80002b4c:	e088                	sd	a0,0(s1)
  return 0;
}
    80002b4e:	4501                	li	a0,0
    80002b50:	60e2                	ld	ra,24(sp)
    80002b52:	6442                	ld	s0,16(sp)
    80002b54:	64a2                	ld	s1,8(sp)
    80002b56:	6105                	addi	sp,sp,32
    80002b58:	8082                	ret

0000000080002b5a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002b5a:	1101                	addi	sp,sp,-32
    80002b5c:	ec06                	sd	ra,24(sp)
    80002b5e:	e822                	sd	s0,16(sp)
    80002b60:	e426                	sd	s1,8(sp)
    80002b62:	e04a                	sd	s2,0(sp)
    80002b64:	1000                	addi	s0,sp,32
    80002b66:	84ae                	mv	s1,a1
    80002b68:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002b6a:	00000097          	auipc	ra,0x0
    80002b6e:	ea4080e7          	jalr	-348(ra) # 80002a0e <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002b72:	864a                	mv	a2,s2
    80002b74:	85a6                	mv	a1,s1
    80002b76:	00000097          	auipc	ra,0x0
    80002b7a:	f58080e7          	jalr	-168(ra) # 80002ace <fetchstr>
}
    80002b7e:	60e2                	ld	ra,24(sp)
    80002b80:	6442                	ld	s0,16(sp)
    80002b82:	64a2                	ld	s1,8(sp)
    80002b84:	6902                	ld	s2,0(sp)
    80002b86:	6105                	addi	sp,sp,32
    80002b88:	8082                	ret

0000000080002b8a <syscall>:
[SYS_symlink]   sys_symlink,
};

void
syscall(void)
{
    80002b8a:	1101                	addi	sp,sp,-32
    80002b8c:	ec06                	sd	ra,24(sp)
    80002b8e:	e822                	sd	s0,16(sp)
    80002b90:	e426                	sd	s1,8(sp)
    80002b92:	e04a                	sd	s2,0(sp)
    80002b94:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002b96:	fffff097          	auipc	ra,0xfffff
    80002b9a:	ec2080e7          	jalr	-318(ra) # 80001a58 <myproc>
    80002b9e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002ba0:	05853903          	ld	s2,88(a0)
    80002ba4:	0a893783          	ld	a5,168(s2)
    80002ba8:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002bac:	37fd                	addiw	a5,a5,-1
    80002bae:	4755                	li	a4,21
    80002bb0:	00f76f63          	bltu	a4,a5,80002bce <syscall+0x44>
    80002bb4:	00369713          	slli	a4,a3,0x3
    80002bb8:	00006797          	auipc	a5,0x6
    80002bbc:	85078793          	addi	a5,a5,-1968 # 80008408 <syscalls>
    80002bc0:	97ba                	add	a5,a5,a4
    80002bc2:	639c                	ld	a5,0(a5)
    80002bc4:	c789                	beqz	a5,80002bce <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002bc6:	9782                	jalr	a5
    80002bc8:	06a93823          	sd	a0,112(s2)
    80002bcc:	a839                	j	80002bea <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002bce:	15848613          	addi	a2,s1,344
    80002bd2:	588c                	lw	a1,48(s1)
    80002bd4:	00006517          	auipc	a0,0x6
    80002bd8:	8f450513          	addi	a0,a0,-1804 # 800084c8 <syscalls+0xc0>
    80002bdc:	ffffe097          	auipc	ra,0xffffe
    80002be0:	9c6080e7          	jalr	-1594(ra) # 800005a2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002be4:	6cbc                	ld	a5,88(s1)
    80002be6:	577d                	li	a4,-1
    80002be8:	fbb8                	sd	a4,112(a5)
  }
}
    80002bea:	60e2                	ld	ra,24(sp)
    80002bec:	6442                	ld	s0,16(sp)
    80002bee:	64a2                	ld	s1,8(sp)
    80002bf0:	6902                	ld	s2,0(sp)
    80002bf2:	6105                	addi	sp,sp,32
    80002bf4:	8082                	ret

0000000080002bf6 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002bf6:	1101                	addi	sp,sp,-32
    80002bf8:	ec06                	sd	ra,24(sp)
    80002bfa:	e822                	sd	s0,16(sp)
    80002bfc:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002bfe:	fec40593          	addi	a1,s0,-20
    80002c02:	4501                	li	a0,0
    80002c04:	00000097          	auipc	ra,0x0
    80002c08:	f12080e7          	jalr	-238(ra) # 80002b16 <argint>
    return -1;
    80002c0c:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002c0e:	00054963          	bltz	a0,80002c20 <sys_exit+0x2a>
  exit(n);
    80002c12:	fec42503          	lw	a0,-20(s0)
    80002c16:	fffff097          	auipc	ra,0xfffff
    80002c1a:	762080e7          	jalr	1890(ra) # 80002378 <exit>
  return 0;  // not reached
    80002c1e:	4781                	li	a5,0
}
    80002c20:	853e                	mv	a0,a5
    80002c22:	60e2                	ld	ra,24(sp)
    80002c24:	6442                	ld	s0,16(sp)
    80002c26:	6105                	addi	sp,sp,32
    80002c28:	8082                	ret

0000000080002c2a <sys_getpid>:

uint64
sys_getpid(void)
{
    80002c2a:	1141                	addi	sp,sp,-16
    80002c2c:	e406                	sd	ra,8(sp)
    80002c2e:	e022                	sd	s0,0(sp)
    80002c30:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002c32:	fffff097          	auipc	ra,0xfffff
    80002c36:	e26080e7          	jalr	-474(ra) # 80001a58 <myproc>
}
    80002c3a:	5908                	lw	a0,48(a0)
    80002c3c:	60a2                	ld	ra,8(sp)
    80002c3e:	6402                	ld	s0,0(sp)
    80002c40:	0141                	addi	sp,sp,16
    80002c42:	8082                	ret

0000000080002c44 <sys_fork>:

uint64
sys_fork(void)
{
    80002c44:	1141                	addi	sp,sp,-16
    80002c46:	e406                	sd	ra,8(sp)
    80002c48:	e022                	sd	s0,0(sp)
    80002c4a:	0800                	addi	s0,sp,16
  return fork();
    80002c4c:	fffff097          	auipc	ra,0xfffff
    80002c50:	1e0080e7          	jalr	480(ra) # 80001e2c <fork>
}
    80002c54:	60a2                	ld	ra,8(sp)
    80002c56:	6402                	ld	s0,0(sp)
    80002c58:	0141                	addi	sp,sp,16
    80002c5a:	8082                	ret

0000000080002c5c <sys_wait>:

uint64
sys_wait(void)
{
    80002c5c:	1101                	addi	sp,sp,-32
    80002c5e:	ec06                	sd	ra,24(sp)
    80002c60:	e822                	sd	s0,16(sp)
    80002c62:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002c64:	fe840593          	addi	a1,s0,-24
    80002c68:	4501                	li	a0,0
    80002c6a:	00000097          	auipc	ra,0x0
    80002c6e:	ece080e7          	jalr	-306(ra) # 80002b38 <argaddr>
    return -1;
    80002c72:	57fd                	li	a5,-1
  if(argaddr(0, &p) < 0)
    80002c74:	00054963          	bltz	a0,80002c86 <sys_wait+0x2a>
  return wait(p);
    80002c78:	fe843503          	ld	a0,-24(s0)
    80002c7c:	fffff097          	auipc	ra,0xfffff
    80002c80:	504080e7          	jalr	1284(ra) # 80002180 <wait>
    80002c84:	87aa                	mv	a5,a0
}
    80002c86:	853e                	mv	a0,a5
    80002c88:	60e2                	ld	ra,24(sp)
    80002c8a:	6442                	ld	s0,16(sp)
    80002c8c:	6105                	addi	sp,sp,32
    80002c8e:	8082                	ret

0000000080002c90 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002c90:	7179                	addi	sp,sp,-48
    80002c92:	f406                	sd	ra,40(sp)
    80002c94:	f022                	sd	s0,32(sp)
    80002c96:	ec26                	sd	s1,24(sp)
    80002c98:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002c9a:	fdc40593          	addi	a1,s0,-36
    80002c9e:	4501                	li	a0,0
    80002ca0:	00000097          	auipc	ra,0x0
    80002ca4:	e76080e7          	jalr	-394(ra) # 80002b16 <argint>
    return -1;
    80002ca8:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    80002caa:	00054f63          	bltz	a0,80002cc8 <sys_sbrk+0x38>
  addr = myproc()->sz;
    80002cae:	fffff097          	auipc	ra,0xfffff
    80002cb2:	daa080e7          	jalr	-598(ra) # 80001a58 <myproc>
    80002cb6:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002cb8:	fdc42503          	lw	a0,-36(s0)
    80002cbc:	fffff097          	auipc	ra,0xfffff
    80002cc0:	0f8080e7          	jalr	248(ra) # 80001db4 <growproc>
    80002cc4:	00054863          	bltz	a0,80002cd4 <sys_sbrk+0x44>
    return -1;
  return addr;
}
    80002cc8:	8526                	mv	a0,s1
    80002cca:	70a2                	ld	ra,40(sp)
    80002ccc:	7402                	ld	s0,32(sp)
    80002cce:	64e2                	ld	s1,24(sp)
    80002cd0:	6145                	addi	sp,sp,48
    80002cd2:	8082                	ret
    return -1;
    80002cd4:	54fd                	li	s1,-1
    80002cd6:	bfcd                	j	80002cc8 <sys_sbrk+0x38>

0000000080002cd8 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002cd8:	7139                	addi	sp,sp,-64
    80002cda:	fc06                	sd	ra,56(sp)
    80002cdc:	f822                	sd	s0,48(sp)
    80002cde:	f426                	sd	s1,40(sp)
    80002ce0:	f04a                	sd	s2,32(sp)
    80002ce2:	ec4e                	sd	s3,24(sp)
    80002ce4:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002ce6:	fcc40593          	addi	a1,s0,-52
    80002cea:	4501                	li	a0,0
    80002cec:	00000097          	auipc	ra,0x0
    80002cf0:	e2a080e7          	jalr	-470(ra) # 80002b16 <argint>
    return -1;
    80002cf4:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002cf6:	06054763          	bltz	a0,80002d64 <sys_sleep+0x8c>
  acquire(&tickslock);
    80002cfa:	00014517          	auipc	a0,0x14
    80002cfe:	3d650513          	addi	a0,a0,982 # 800170d0 <tickslock>
    80002d02:	ffffe097          	auipc	ra,0xffffe
    80002d06:	f1e080e7          	jalr	-226(ra) # 80000c20 <acquire>
  ticks0 = ticks;
    80002d0a:	00006797          	auipc	a5,0x6
    80002d0e:	32678793          	addi	a5,a5,806 # 80009030 <ticks>
    80002d12:	0007a903          	lw	s2,0(a5)
  while(ticks - ticks0 < n){
    80002d16:	fcc42783          	lw	a5,-52(s0)
    80002d1a:	cf85                	beqz	a5,80002d52 <sys_sleep+0x7a>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002d1c:	00014997          	auipc	s3,0x14
    80002d20:	3b498993          	addi	s3,s3,948 # 800170d0 <tickslock>
    80002d24:	00006497          	auipc	s1,0x6
    80002d28:	30c48493          	addi	s1,s1,780 # 80009030 <ticks>
    if(myproc()->killed){
    80002d2c:	fffff097          	auipc	ra,0xfffff
    80002d30:	d2c080e7          	jalr	-724(ra) # 80001a58 <myproc>
    80002d34:	551c                	lw	a5,40(a0)
    80002d36:	ef9d                	bnez	a5,80002d74 <sys_sleep+0x9c>
    sleep(&ticks, &tickslock);
    80002d38:	85ce                	mv	a1,s3
    80002d3a:	8526                	mv	a0,s1
    80002d3c:	fffff097          	auipc	ra,0xfffff
    80002d40:	3e0080e7          	jalr	992(ra) # 8000211c <sleep>
  while(ticks - ticks0 < n){
    80002d44:	409c                	lw	a5,0(s1)
    80002d46:	412787bb          	subw	a5,a5,s2
    80002d4a:	fcc42703          	lw	a4,-52(s0)
    80002d4e:	fce7efe3          	bltu	a5,a4,80002d2c <sys_sleep+0x54>
  }
  release(&tickslock);
    80002d52:	00014517          	auipc	a0,0x14
    80002d56:	37e50513          	addi	a0,a0,894 # 800170d0 <tickslock>
    80002d5a:	ffffe097          	auipc	ra,0xffffe
    80002d5e:	f7a080e7          	jalr	-134(ra) # 80000cd4 <release>
  return 0;
    80002d62:	4781                	li	a5,0
}
    80002d64:	853e                	mv	a0,a5
    80002d66:	70e2                	ld	ra,56(sp)
    80002d68:	7442                	ld	s0,48(sp)
    80002d6a:	74a2                	ld	s1,40(sp)
    80002d6c:	7902                	ld	s2,32(sp)
    80002d6e:	69e2                	ld	s3,24(sp)
    80002d70:	6121                	addi	sp,sp,64
    80002d72:	8082                	ret
      release(&tickslock);
    80002d74:	00014517          	auipc	a0,0x14
    80002d78:	35c50513          	addi	a0,a0,860 # 800170d0 <tickslock>
    80002d7c:	ffffe097          	auipc	ra,0xffffe
    80002d80:	f58080e7          	jalr	-168(ra) # 80000cd4 <release>
      return -1;
    80002d84:	57fd                	li	a5,-1
    80002d86:	bff9                	j	80002d64 <sys_sleep+0x8c>

0000000080002d88 <sys_kill>:

uint64
sys_kill(void)
{
    80002d88:	1101                	addi	sp,sp,-32
    80002d8a:	ec06                	sd	ra,24(sp)
    80002d8c:	e822                	sd	s0,16(sp)
    80002d8e:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002d90:	fec40593          	addi	a1,s0,-20
    80002d94:	4501                	li	a0,0
    80002d96:	00000097          	auipc	ra,0x0
    80002d9a:	d80080e7          	jalr	-640(ra) # 80002b16 <argint>
    return -1;
    80002d9e:	57fd                	li	a5,-1
  if(argint(0, &pid) < 0)
    80002da0:	00054963          	bltz	a0,80002db2 <sys_kill+0x2a>
  return kill(pid);
    80002da4:	fec42503          	lw	a0,-20(s0)
    80002da8:	fffff097          	auipc	ra,0xfffff
    80002dac:	6a8080e7          	jalr	1704(ra) # 80002450 <kill>
    80002db0:	87aa                	mv	a5,a0
}
    80002db2:	853e                	mv	a0,a5
    80002db4:	60e2                	ld	ra,24(sp)
    80002db6:	6442                	ld	s0,16(sp)
    80002db8:	6105                	addi	sp,sp,32
    80002dba:	8082                	ret

0000000080002dbc <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002dbc:	1101                	addi	sp,sp,-32
    80002dbe:	ec06                	sd	ra,24(sp)
    80002dc0:	e822                	sd	s0,16(sp)
    80002dc2:	e426                	sd	s1,8(sp)
    80002dc4:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002dc6:	00014517          	auipc	a0,0x14
    80002dca:	30a50513          	addi	a0,a0,778 # 800170d0 <tickslock>
    80002dce:	ffffe097          	auipc	ra,0xffffe
    80002dd2:	e52080e7          	jalr	-430(ra) # 80000c20 <acquire>
  xticks = ticks;
    80002dd6:	00006797          	auipc	a5,0x6
    80002dda:	25a78793          	addi	a5,a5,602 # 80009030 <ticks>
    80002dde:	4384                	lw	s1,0(a5)
  release(&tickslock);
    80002de0:	00014517          	auipc	a0,0x14
    80002de4:	2f050513          	addi	a0,a0,752 # 800170d0 <tickslock>
    80002de8:	ffffe097          	auipc	ra,0xffffe
    80002dec:	eec080e7          	jalr	-276(ra) # 80000cd4 <release>
  return xticks;
}
    80002df0:	02049513          	slli	a0,s1,0x20
    80002df4:	9101                	srli	a0,a0,0x20
    80002df6:	60e2                	ld	ra,24(sp)
    80002df8:	6442                	ld	s0,16(sp)
    80002dfa:	64a2                	ld	s1,8(sp)
    80002dfc:	6105                	addi	sp,sp,32
    80002dfe:	8082                	ret

0000000080002e00 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002e00:	7179                	addi	sp,sp,-48
    80002e02:	f406                	sd	ra,40(sp)
    80002e04:	f022                	sd	s0,32(sp)
    80002e06:	ec26                	sd	s1,24(sp)
    80002e08:	e84a                	sd	s2,16(sp)
    80002e0a:	e44e                	sd	s3,8(sp)
    80002e0c:	e052                	sd	s4,0(sp)
    80002e0e:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002e10:	00005597          	auipc	a1,0x5
    80002e14:	6d858593          	addi	a1,a1,1752 # 800084e8 <syscalls+0xe0>
    80002e18:	00014517          	auipc	a0,0x14
    80002e1c:	2d050513          	addi	a0,a0,720 # 800170e8 <bcache>
    80002e20:	ffffe097          	auipc	ra,0xffffe
    80002e24:	d70080e7          	jalr	-656(ra) # 80000b90 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002e28:	0001c797          	auipc	a5,0x1c
    80002e2c:	2c078793          	addi	a5,a5,704 # 8001f0e8 <bcache+0x8000>
    80002e30:	0001c717          	auipc	a4,0x1c
    80002e34:	52070713          	addi	a4,a4,1312 # 8001f350 <bcache+0x8268>
    80002e38:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002e3c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002e40:	00014497          	auipc	s1,0x14
    80002e44:	2c048493          	addi	s1,s1,704 # 80017100 <bcache+0x18>
    b->next = bcache.head.next;
    80002e48:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002e4a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002e4c:	00005a17          	auipc	s4,0x5
    80002e50:	6a4a0a13          	addi	s4,s4,1700 # 800084f0 <syscalls+0xe8>
    b->next = bcache.head.next;
    80002e54:	2b893783          	ld	a5,696(s2)
    80002e58:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002e5a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002e5e:	85d2                	mv	a1,s4
    80002e60:	01048513          	addi	a0,s1,16
    80002e64:	00001097          	auipc	ra,0x1
    80002e68:	73a080e7          	jalr	1850(ra) # 8000459e <initsleeplock>
    bcache.head.next->prev = b;
    80002e6c:	2b893783          	ld	a5,696(s2)
    80002e70:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002e72:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002e76:	45848493          	addi	s1,s1,1112
    80002e7a:	fd349de3          	bne	s1,s3,80002e54 <binit+0x54>
  }
}
    80002e7e:	70a2                	ld	ra,40(sp)
    80002e80:	7402                	ld	s0,32(sp)
    80002e82:	64e2                	ld	s1,24(sp)
    80002e84:	6942                	ld	s2,16(sp)
    80002e86:	69a2                	ld	s3,8(sp)
    80002e88:	6a02                	ld	s4,0(sp)
    80002e8a:	6145                	addi	sp,sp,48
    80002e8c:	8082                	ret

0000000080002e8e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002e8e:	7179                	addi	sp,sp,-48
    80002e90:	f406                	sd	ra,40(sp)
    80002e92:	f022                	sd	s0,32(sp)
    80002e94:	ec26                	sd	s1,24(sp)
    80002e96:	e84a                	sd	s2,16(sp)
    80002e98:	e44e                	sd	s3,8(sp)
    80002e9a:	1800                	addi	s0,sp,48
    80002e9c:	89aa                	mv	s3,a0
    80002e9e:	892e                	mv	s2,a1
  acquire(&bcache.lock); // must hold atomic in case repeated cache
    80002ea0:	00014517          	auipc	a0,0x14
    80002ea4:	24850513          	addi	a0,a0,584 # 800170e8 <bcache>
    80002ea8:	ffffe097          	auipc	ra,0xffffe
    80002eac:	d78080e7          	jalr	-648(ra) # 80000c20 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002eb0:	0001c797          	auipc	a5,0x1c
    80002eb4:	23878793          	addi	a5,a5,568 # 8001f0e8 <bcache+0x8000>
    80002eb8:	2b87b483          	ld	s1,696(a5)
    80002ebc:	0001c797          	auipc	a5,0x1c
    80002ec0:	49478793          	addi	a5,a5,1172 # 8001f350 <bcache+0x8268>
    80002ec4:	02f48f63          	beq	s1,a5,80002f02 <bread+0x74>
    80002ec8:	873e                	mv	a4,a5
    80002eca:	a021                	j	80002ed2 <bread+0x44>
    80002ecc:	68a4                	ld	s1,80(s1)
    80002ece:	02e48a63          	beq	s1,a4,80002f02 <bread+0x74>
    if(b->dev == dev && b->blockno == blockno){
    80002ed2:	449c                	lw	a5,8(s1)
    80002ed4:	ff379ce3          	bne	a5,s3,80002ecc <bread+0x3e>
    80002ed8:	44dc                	lw	a5,12(s1)
    80002eda:	ff2799e3          	bne	a5,s2,80002ecc <bread+0x3e>
      b->refcnt++;
    80002ede:	40bc                	lw	a5,64(s1)
    80002ee0:	2785                	addiw	a5,a5,1
    80002ee2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002ee4:	00014517          	auipc	a0,0x14
    80002ee8:	20450513          	addi	a0,a0,516 # 800170e8 <bcache>
    80002eec:	ffffe097          	auipc	ra,0xffffe
    80002ef0:	de8080e7          	jalr	-536(ra) # 80000cd4 <release>
      acquiresleep(&b->lock);
    80002ef4:	01048513          	addi	a0,s1,16
    80002ef8:	00001097          	auipc	ra,0x1
    80002efc:	6e0080e7          	jalr	1760(ra) # 800045d8 <acquiresleep>
      return b;
    80002f00:	a8b1                	j	80002f5c <bread+0xce>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002f02:	0001c797          	auipc	a5,0x1c
    80002f06:	1e678793          	addi	a5,a5,486 # 8001f0e8 <bcache+0x8000>
    80002f0a:	2b07b483          	ld	s1,688(a5)
    80002f0e:	0001c797          	auipc	a5,0x1c
    80002f12:	44278793          	addi	a5,a5,1090 # 8001f350 <bcache+0x8268>
    80002f16:	04f48d63          	beq	s1,a5,80002f70 <bread+0xe2>
    if(b->refcnt == 0) { // this can be reused
    80002f1a:	40bc                	lw	a5,64(s1)
    80002f1c:	cb91                	beqz	a5,80002f30 <bread+0xa2>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002f1e:	0001c717          	auipc	a4,0x1c
    80002f22:	43270713          	addi	a4,a4,1074 # 8001f350 <bcache+0x8268>
    80002f26:	64a4                	ld	s1,72(s1)
    80002f28:	04e48463          	beq	s1,a4,80002f70 <bread+0xe2>
    if(b->refcnt == 0) { // this can be reused
    80002f2c:	40bc                	lw	a5,64(s1)
    80002f2e:	ffe5                	bnez	a5,80002f26 <bread+0x98>
      b->dev = dev;
    80002f30:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002f34:	0124a623          	sw	s2,12(s1)
      b->valid = 0; // in case we use the previous data from disk
    80002f38:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002f3c:	4785                	li	a5,1
    80002f3e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002f40:	00014517          	auipc	a0,0x14
    80002f44:	1a850513          	addi	a0,a0,424 # 800170e8 <bcache>
    80002f48:	ffffe097          	auipc	ra,0xffffe
    80002f4c:	d8c080e7          	jalr	-628(ra) # 80000cd4 <release>
      acquiresleep(&b->lock); // sleeplock is on.
    80002f50:	01048513          	addi	a0,s1,16
    80002f54:	00001097          	auipc	ra,0x1
    80002f58:	684080e7          	jalr	1668(ra) # 800045d8 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002f5c:	409c                	lw	a5,0(s1)
    80002f5e:	c38d                	beqz	a5,80002f80 <bread+0xf2>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002f60:	8526                	mv	a0,s1
    80002f62:	70a2                	ld	ra,40(sp)
    80002f64:	7402                	ld	s0,32(sp)
    80002f66:	64e2                	ld	s1,24(sp)
    80002f68:	6942                	ld	s2,16(sp)
    80002f6a:	69a2                	ld	s3,8(sp)
    80002f6c:	6145                	addi	sp,sp,48
    80002f6e:	8082                	ret
  panic("bget: no buffers");
    80002f70:	00005517          	auipc	a0,0x5
    80002f74:	58850513          	addi	a0,a0,1416 # 800084f8 <syscalls+0xf0>
    80002f78:	ffffd097          	auipc	ra,0xffffd
    80002f7c:	5e0080e7          	jalr	1504(ra) # 80000558 <panic>
    virtio_disk_rw(b, 0);
    80002f80:	4581                	li	a1,0
    80002f82:	8526                	mv	a0,s1
    80002f84:	00003097          	auipc	ra,0x3
    80002f88:	372080e7          	jalr	882(ra) # 800062f6 <virtio_disk_rw>
    b->valid = 1;
    80002f8c:	4785                	li	a5,1
    80002f8e:	c09c                	sw	a5,0(s1)
  return b;
    80002f90:	bfc1                	j	80002f60 <bread+0xd2>

0000000080002f92 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002f92:	1101                	addi	sp,sp,-32
    80002f94:	ec06                	sd	ra,24(sp)
    80002f96:	e822                	sd	s0,16(sp)
    80002f98:	e426                	sd	s1,8(sp)
    80002f9a:	1000                	addi	s0,sp,32
    80002f9c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002f9e:	0541                	addi	a0,a0,16
    80002fa0:	00001097          	auipc	ra,0x1
    80002fa4:	6d2080e7          	jalr	1746(ra) # 80004672 <holdingsleep>
    80002fa8:	cd01                	beqz	a0,80002fc0 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002faa:	4585                	li	a1,1
    80002fac:	8526                	mv	a0,s1
    80002fae:	00003097          	auipc	ra,0x3
    80002fb2:	348080e7          	jalr	840(ra) # 800062f6 <virtio_disk_rw>
}
    80002fb6:	60e2                	ld	ra,24(sp)
    80002fb8:	6442                	ld	s0,16(sp)
    80002fba:	64a2                	ld	s1,8(sp)
    80002fbc:	6105                	addi	sp,sp,32
    80002fbe:	8082                	ret
    panic("bwrite");
    80002fc0:	00005517          	auipc	a0,0x5
    80002fc4:	55050513          	addi	a0,a0,1360 # 80008510 <syscalls+0x108>
    80002fc8:	ffffd097          	auipc	ra,0xffffd
    80002fcc:	590080e7          	jalr	1424(ra) # 80000558 <panic>

0000000080002fd0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002fd0:	1101                	addi	sp,sp,-32
    80002fd2:	ec06                	sd	ra,24(sp)
    80002fd4:	e822                	sd	s0,16(sp)
    80002fd6:	e426                	sd	s1,8(sp)
    80002fd8:	e04a                	sd	s2,0(sp)
    80002fda:	1000                	addi	s0,sp,32
    80002fdc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002fde:	01050913          	addi	s2,a0,16
    80002fe2:	854a                	mv	a0,s2
    80002fe4:	00001097          	auipc	ra,0x1
    80002fe8:	68e080e7          	jalr	1678(ra) # 80004672 <holdingsleep>
    80002fec:	c92d                	beqz	a0,8000305e <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002fee:	854a                	mv	a0,s2
    80002ff0:	00001097          	auipc	ra,0x1
    80002ff4:	63e080e7          	jalr	1598(ra) # 8000462e <releasesleep>

  acquire(&bcache.lock);
    80002ff8:	00014517          	auipc	a0,0x14
    80002ffc:	0f050513          	addi	a0,a0,240 # 800170e8 <bcache>
    80003000:	ffffe097          	auipc	ra,0xffffe
    80003004:	c20080e7          	jalr	-992(ra) # 80000c20 <acquire>
  b->refcnt--;
    80003008:	40bc                	lw	a5,64(s1)
    8000300a:	37fd                	addiw	a5,a5,-1
    8000300c:	0007871b          	sext.w	a4,a5
    80003010:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003012:	eb05                	bnez	a4,80003042 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003014:	68bc                	ld	a5,80(s1)
    80003016:	64b8                	ld	a4,72(s1)
    80003018:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000301a:	64bc                	ld	a5,72(s1)
    8000301c:	68b8                	ld	a4,80(s1)
    8000301e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003020:	0001c797          	auipc	a5,0x1c
    80003024:	0c878793          	addi	a5,a5,200 # 8001f0e8 <bcache+0x8000>
    80003028:	2b87b703          	ld	a4,696(a5)
    8000302c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000302e:	0001c717          	auipc	a4,0x1c
    80003032:	32270713          	addi	a4,a4,802 # 8001f350 <bcache+0x8268>
    80003036:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003038:	2b87b703          	ld	a4,696(a5)
    8000303c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000303e:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    80003042:	00014517          	auipc	a0,0x14
    80003046:	0a650513          	addi	a0,a0,166 # 800170e8 <bcache>
    8000304a:	ffffe097          	auipc	ra,0xffffe
    8000304e:	c8a080e7          	jalr	-886(ra) # 80000cd4 <release>
}
    80003052:	60e2                	ld	ra,24(sp)
    80003054:	6442                	ld	s0,16(sp)
    80003056:	64a2                	ld	s1,8(sp)
    80003058:	6902                	ld	s2,0(sp)
    8000305a:	6105                	addi	sp,sp,32
    8000305c:	8082                	ret
    panic("brelse");
    8000305e:	00005517          	auipc	a0,0x5
    80003062:	4ba50513          	addi	a0,a0,1210 # 80008518 <syscalls+0x110>
    80003066:	ffffd097          	auipc	ra,0xffffd
    8000306a:	4f2080e7          	jalr	1266(ra) # 80000558 <panic>

000000008000306e <bpin>:

void
bpin(struct buf *b) {
    8000306e:	1101                	addi	sp,sp,-32
    80003070:	ec06                	sd	ra,24(sp)
    80003072:	e822                	sd	s0,16(sp)
    80003074:	e426                	sd	s1,8(sp)
    80003076:	1000                	addi	s0,sp,32
    80003078:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000307a:	00014517          	auipc	a0,0x14
    8000307e:	06e50513          	addi	a0,a0,110 # 800170e8 <bcache>
    80003082:	ffffe097          	auipc	ra,0xffffe
    80003086:	b9e080e7          	jalr	-1122(ra) # 80000c20 <acquire>
  b->refcnt++;
    8000308a:	40bc                	lw	a5,64(s1)
    8000308c:	2785                	addiw	a5,a5,1
    8000308e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003090:	00014517          	auipc	a0,0x14
    80003094:	05850513          	addi	a0,a0,88 # 800170e8 <bcache>
    80003098:	ffffe097          	auipc	ra,0xffffe
    8000309c:	c3c080e7          	jalr	-964(ra) # 80000cd4 <release>
}
    800030a0:	60e2                	ld	ra,24(sp)
    800030a2:	6442                	ld	s0,16(sp)
    800030a4:	64a2                	ld	s1,8(sp)
    800030a6:	6105                	addi	sp,sp,32
    800030a8:	8082                	ret

00000000800030aa <bunpin>:

void
bunpin(struct buf *b) {
    800030aa:	1101                	addi	sp,sp,-32
    800030ac:	ec06                	sd	ra,24(sp)
    800030ae:	e822                	sd	s0,16(sp)
    800030b0:	e426                	sd	s1,8(sp)
    800030b2:	1000                	addi	s0,sp,32
    800030b4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800030b6:	00014517          	auipc	a0,0x14
    800030ba:	03250513          	addi	a0,a0,50 # 800170e8 <bcache>
    800030be:	ffffe097          	auipc	ra,0xffffe
    800030c2:	b62080e7          	jalr	-1182(ra) # 80000c20 <acquire>
  b->refcnt--;
    800030c6:	40bc                	lw	a5,64(s1)
    800030c8:	37fd                	addiw	a5,a5,-1
    800030ca:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800030cc:	00014517          	auipc	a0,0x14
    800030d0:	01c50513          	addi	a0,a0,28 # 800170e8 <bcache>
    800030d4:	ffffe097          	auipc	ra,0xffffe
    800030d8:	c00080e7          	jalr	-1024(ra) # 80000cd4 <release>
}
    800030dc:	60e2                	ld	ra,24(sp)
    800030de:	6442                	ld	s0,16(sp)
    800030e0:	64a2                	ld	s1,8(sp)
    800030e2:	6105                	addi	sp,sp,32
    800030e4:	8082                	ret

00000000800030e6 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800030e6:	1101                	addi	sp,sp,-32
    800030e8:	ec06                	sd	ra,24(sp)
    800030ea:	e822                	sd	s0,16(sp)
    800030ec:	e426                	sd	s1,8(sp)
    800030ee:	e04a                	sd	s2,0(sp)
    800030f0:	1000                	addi	s0,sp,32
    800030f2:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800030f4:	00d5d59b          	srliw	a1,a1,0xd
    800030f8:	0001c797          	auipc	a5,0x1c
    800030fc:	6b078793          	addi	a5,a5,1712 # 8001f7a8 <sb>
    80003100:	4fdc                	lw	a5,28(a5)
    80003102:	9dbd                	addw	a1,a1,a5
    80003104:	00000097          	auipc	ra,0x0
    80003108:	d8a080e7          	jalr	-630(ra) # 80002e8e <bread>
  bi = b % BPB;
    8000310c:	2481                	sext.w	s1,s1
  m = 1 << (bi % 8);
    8000310e:	0074f793          	andi	a5,s1,7
    80003112:	4705                	li	a4,1
    80003114:	00f7173b          	sllw	a4,a4,a5
  bi = b % BPB;
    80003118:	6789                	lui	a5,0x2
    8000311a:	17fd                	addi	a5,a5,-1
    8000311c:	8cfd                	and	s1,s1,a5
  if((bp->data[bi/8] & m) == 0)
    8000311e:	41f4d79b          	sraiw	a5,s1,0x1f
    80003122:	01d7d79b          	srliw	a5,a5,0x1d
    80003126:	9fa5                	addw	a5,a5,s1
    80003128:	4037d79b          	sraiw	a5,a5,0x3
    8000312c:	00f506b3          	add	a3,a0,a5
    80003130:	0586c683          	lbu	a3,88(a3)
    80003134:	00d77633          	and	a2,a4,a3
    80003138:	c61d                	beqz	a2,80003166 <bfree+0x80>
    8000313a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000313c:	97aa                	add	a5,a5,a0
    8000313e:	fff74713          	not	a4,a4
    80003142:	8f75                	and	a4,a4,a3
    80003144:	04e78c23          	sb	a4,88(a5) # 2058 <_entry-0x7fffdfa8>
  log_write(bp);
    80003148:	00001097          	auipc	ra,0x1
    8000314c:	35c080e7          	jalr	860(ra) # 800044a4 <log_write>
  brelse(bp);
    80003150:	854a                	mv	a0,s2
    80003152:	00000097          	auipc	ra,0x0
    80003156:	e7e080e7          	jalr	-386(ra) # 80002fd0 <brelse>
}
    8000315a:	60e2                	ld	ra,24(sp)
    8000315c:	6442                	ld	s0,16(sp)
    8000315e:	64a2                	ld	s1,8(sp)
    80003160:	6902                	ld	s2,0(sp)
    80003162:	6105                	addi	sp,sp,32
    80003164:	8082                	ret
    panic("freeing free block");
    80003166:	00005517          	auipc	a0,0x5
    8000316a:	3ba50513          	addi	a0,a0,954 # 80008520 <syscalls+0x118>
    8000316e:	ffffd097          	auipc	ra,0xffffd
    80003172:	3ea080e7          	jalr	1002(ra) # 80000558 <panic>

0000000080003176 <balloc>:
{
    80003176:	711d                	addi	sp,sp,-96
    80003178:	ec86                	sd	ra,88(sp)
    8000317a:	e8a2                	sd	s0,80(sp)
    8000317c:	e4a6                	sd	s1,72(sp)
    8000317e:	e0ca                	sd	s2,64(sp)
    80003180:	fc4e                	sd	s3,56(sp)
    80003182:	f852                	sd	s4,48(sp)
    80003184:	f456                	sd	s5,40(sp)
    80003186:	f05a                	sd	s6,32(sp)
    80003188:	ec5e                	sd	s7,24(sp)
    8000318a:	e862                	sd	s8,16(sp)
    8000318c:	e466                	sd	s9,8(sp)
    8000318e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003190:	0001c797          	auipc	a5,0x1c
    80003194:	61878793          	addi	a5,a5,1560 # 8001f7a8 <sb>
    80003198:	43dc                	lw	a5,4(a5)
    8000319a:	10078e63          	beqz	a5,800032b6 <balloc+0x140>
    8000319e:	8baa                	mv	s7,a0
    800031a0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800031a2:	0001cb17          	auipc	s6,0x1c
    800031a6:	606b0b13          	addi	s6,s6,1542 # 8001f7a8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800031aa:	4c05                	li	s8,1
      m = 1 << (bi % 8);
    800031ac:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800031ae:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800031b0:	6c89                	lui	s9,0x2
    800031b2:	a079                	j	80003240 <balloc+0xca>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800031b4:	8942                	mv	s2,a6
      m = 1 << (bi % 8);
    800031b6:	4705                	li	a4,1
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800031b8:	4681                	li	a3,0
        bp->data[bi/8] |= m;  // Mark block in use.
    800031ba:	96a6                	add	a3,a3,s1
    800031bc:	8f51                	or	a4,a4,a2
    800031be:	04e68c23          	sb	a4,88(a3)
        log_write(bp);
    800031c2:	8526                	mv	a0,s1
    800031c4:	00001097          	auipc	ra,0x1
    800031c8:	2e0080e7          	jalr	736(ra) # 800044a4 <log_write>
        brelse(bp);
    800031cc:	8526                	mv	a0,s1
    800031ce:	00000097          	auipc	ra,0x0
    800031d2:	e02080e7          	jalr	-510(ra) # 80002fd0 <brelse>
  bp = bread(dev, bno);
    800031d6:	85ca                	mv	a1,s2
    800031d8:	855e                	mv	a0,s7
    800031da:	00000097          	auipc	ra,0x0
    800031de:	cb4080e7          	jalr	-844(ra) # 80002e8e <bread>
    800031e2:	84aa                	mv	s1,a0
  memset(bp->data, 0, BSIZE);
    800031e4:	40000613          	li	a2,1024
    800031e8:	4581                	li	a1,0
    800031ea:	05850513          	addi	a0,a0,88
    800031ee:	ffffe097          	auipc	ra,0xffffe
    800031f2:	b2e080e7          	jalr	-1234(ra) # 80000d1c <memset>
  log_write(bp);
    800031f6:	8526                	mv	a0,s1
    800031f8:	00001097          	auipc	ra,0x1
    800031fc:	2ac080e7          	jalr	684(ra) # 800044a4 <log_write>
  brelse(bp);
    80003200:	8526                	mv	a0,s1
    80003202:	00000097          	auipc	ra,0x0
    80003206:	dce080e7          	jalr	-562(ra) # 80002fd0 <brelse>
}
    8000320a:	854a                	mv	a0,s2
    8000320c:	60e6                	ld	ra,88(sp)
    8000320e:	6446                	ld	s0,80(sp)
    80003210:	64a6                	ld	s1,72(sp)
    80003212:	6906                	ld	s2,64(sp)
    80003214:	79e2                	ld	s3,56(sp)
    80003216:	7a42                	ld	s4,48(sp)
    80003218:	7aa2                	ld	s5,40(sp)
    8000321a:	7b02                	ld	s6,32(sp)
    8000321c:	6be2                	ld	s7,24(sp)
    8000321e:	6c42                	ld	s8,16(sp)
    80003220:	6ca2                	ld	s9,8(sp)
    80003222:	6125                	addi	sp,sp,96
    80003224:	8082                	ret
    brelse(bp);
    80003226:	8526                	mv	a0,s1
    80003228:	00000097          	auipc	ra,0x0
    8000322c:	da8080e7          	jalr	-600(ra) # 80002fd0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003230:	015c87bb          	addw	a5,s9,s5
    80003234:	00078a9b          	sext.w	s5,a5
    80003238:	004b2703          	lw	a4,4(s6)
    8000323c:	06eafd63          	bleu	a4,s5,800032b6 <balloc+0x140>
    bp = bread(dev, BBLOCK(b, sb));
    80003240:	41fad79b          	sraiw	a5,s5,0x1f
    80003244:	0137d79b          	srliw	a5,a5,0x13
    80003248:	015787bb          	addw	a5,a5,s5
    8000324c:	40d7d79b          	sraiw	a5,a5,0xd
    80003250:	01cb2583          	lw	a1,28(s6)
    80003254:	9dbd                	addw	a1,a1,a5
    80003256:	855e                	mv	a0,s7
    80003258:	00000097          	auipc	ra,0x0
    8000325c:	c36080e7          	jalr	-970(ra) # 80002e8e <bread>
    80003260:	84aa                	mv	s1,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003262:	000a881b          	sext.w	a6,s5
    80003266:	004b2503          	lw	a0,4(s6)
    8000326a:	faa87ee3          	bleu	a0,a6,80003226 <balloc+0xb0>
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000326e:	0584c603          	lbu	a2,88(s1)
    80003272:	00167793          	andi	a5,a2,1
    80003276:	df9d                	beqz	a5,800031b4 <balloc+0x3e>
    80003278:	4105053b          	subw	a0,a0,a6
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000327c:	87e2                	mv	a5,s8
    8000327e:	0107893b          	addw	s2,a5,a6
    80003282:	faa782e3          	beq	a5,a0,80003226 <balloc+0xb0>
      m = 1 << (bi % 8);
    80003286:	41f7d71b          	sraiw	a4,a5,0x1f
    8000328a:	01d7561b          	srliw	a2,a4,0x1d
    8000328e:	00f606bb          	addw	a3,a2,a5
    80003292:	0076f713          	andi	a4,a3,7
    80003296:	9f11                	subw	a4,a4,a2
    80003298:	00e9973b          	sllw	a4,s3,a4
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000329c:	4036d69b          	sraiw	a3,a3,0x3
    800032a0:	00d48633          	add	a2,s1,a3
    800032a4:	05864603          	lbu	a2,88(a2)
    800032a8:	00c775b3          	and	a1,a4,a2
    800032ac:	d599                	beqz	a1,800031ba <balloc+0x44>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800032ae:	2785                	addiw	a5,a5,1
    800032b0:	fd4797e3          	bne	a5,s4,8000327e <balloc+0x108>
    800032b4:	bf8d                	j	80003226 <balloc+0xb0>
  panic("balloc: out of blocks");
    800032b6:	00005517          	auipc	a0,0x5
    800032ba:	28250513          	addi	a0,a0,642 # 80008538 <syscalls+0x130>
    800032be:	ffffd097          	auipc	ra,0xffffd
    800032c2:	29a080e7          	jalr	666(ra) # 80000558 <panic>

00000000800032c6 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
    800032c6:	7179                	addi	sp,sp,-48
    800032c8:	f406                	sd	ra,40(sp)
    800032ca:	f022                	sd	s0,32(sp)
    800032cc:	ec26                	sd	s1,24(sp)
    800032ce:	e84a                	sd	s2,16(sp)
    800032d0:	e44e                	sd	s3,8(sp)
    800032d2:	e052                	sd	s4,0(sp)
    800032d4:	1800                	addi	s0,sp,48
    800032d6:	89aa                	mv	s3,a0
    800032d8:	8a2e                	mv	s4,a1
  struct inode *ip, *empty;

  acquire(&itable.lock);
    800032da:	0001c517          	auipc	a0,0x1c
    800032de:	4ee50513          	addi	a0,a0,1262 # 8001f7c8 <itable>
    800032e2:	ffffe097          	auipc	ra,0xffffe
    800032e6:	93e080e7          	jalr	-1730(ra) # 80000c20 <acquire>

  // Is the inode already in the table?
  empty = 0;
    800032ea:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800032ec:	0001c497          	auipc	s1,0x1c
    800032f0:	4f448493          	addi	s1,s1,1268 # 8001f7e0 <itable+0x18>
    800032f4:	0001e697          	auipc	a3,0x1e
    800032f8:	f7c68693          	addi	a3,a3,-132 # 80021270 <log>
    800032fc:	a039                	j	8000330a <iget+0x44>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&itable.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800032fe:	02090b63          	beqz	s2,80003334 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003302:	08848493          	addi	s1,s1,136
    80003306:	02d48a63          	beq	s1,a3,8000333a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000330a:	449c                	lw	a5,8(s1)
    8000330c:	fef059e3          	blez	a5,800032fe <iget+0x38>
    80003310:	4098                	lw	a4,0(s1)
    80003312:	ff3716e3          	bne	a4,s3,800032fe <iget+0x38>
    80003316:	40d8                	lw	a4,4(s1)
    80003318:	ff4713e3          	bne	a4,s4,800032fe <iget+0x38>
      ip->ref++;
    8000331c:	2785                	addiw	a5,a5,1
    8000331e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003320:	0001c517          	auipc	a0,0x1c
    80003324:	4a850513          	addi	a0,a0,1192 # 8001f7c8 <itable>
    80003328:	ffffe097          	auipc	ra,0xffffe
    8000332c:	9ac080e7          	jalr	-1620(ra) # 80000cd4 <release>
      return ip;
    80003330:	8926                	mv	s2,s1
    80003332:	a03d                	j	80003360 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003334:	f7f9                	bnez	a5,80003302 <iget+0x3c>
    80003336:	8926                	mv	s2,s1
    80003338:	b7e9                	j	80003302 <iget+0x3c>
      empty = ip;
  }

  // Recycle an inode entry.
  if(empty == 0)
    8000333a:	02090c63          	beqz	s2,80003372 <iget+0xac>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
    8000333e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003342:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003346:	4785                	li	a5,1
    80003348:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000334c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003350:	0001c517          	auipc	a0,0x1c
    80003354:	47850513          	addi	a0,a0,1144 # 8001f7c8 <itable>
    80003358:	ffffe097          	auipc	ra,0xffffe
    8000335c:	97c080e7          	jalr	-1668(ra) # 80000cd4 <release>

  return ip;
}
    80003360:	854a                	mv	a0,s2
    80003362:	70a2                	ld	ra,40(sp)
    80003364:	7402                	ld	s0,32(sp)
    80003366:	64e2                	ld	s1,24(sp)
    80003368:	6942                	ld	s2,16(sp)
    8000336a:	69a2                	ld	s3,8(sp)
    8000336c:	6a02                	ld	s4,0(sp)
    8000336e:	6145                	addi	sp,sp,48
    80003370:	8082                	ret
    panic("iget: no inodes");
    80003372:	00005517          	auipc	a0,0x5
    80003376:	1de50513          	addi	a0,a0,478 # 80008550 <syscalls+0x148>
    8000337a:	ffffd097          	auipc	ra,0xffffd
    8000337e:	1de080e7          	jalr	478(ra) # 80000558 <panic>

0000000080003382 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80003382:	7139                	addi	sp,sp,-64
    80003384:	fc06                	sd	ra,56(sp)
    80003386:	f822                	sd	s0,48(sp)
    80003388:	f426                	sd	s1,40(sp)
    8000338a:	f04a                	sd	s2,32(sp)
    8000338c:	ec4e                	sd	s3,24(sp)
    8000338e:	e852                	sd	s4,16(sp)
    80003390:	e456                	sd	s5,8(sp)
    80003392:	0080                	addi	s0,sp,64
    80003394:	892a                	mv	s2,a0
  // You should modify bmap(),
  // so that it can handle doubly indirect inode.
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003396:	4799                	li	a5,6
    80003398:	08b7ff63          	bleu	a1,a5,80003436 <bmap+0xb4>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000339c:	ff95879b          	addiw	a5,a1,-7
    800033a0:	0007869b          	sext.w	a3,a5

  if(bn < NINDIRECT){
    800033a4:	4ff00713          	li	a4,1279
    800033a8:	0ad77a63          	bleu	a3,a4,8000345c <bmap+0xda>
    }
    brelse(bp);
    return addr;
  }

  bn -= NINDIRECT;
    800033ac:	af95859b          	addiw	a1,a1,-1287
    800033b0:	0005879b          	sext.w	a5,a1
  if(bn < NINDIRECT2){
    800033b4:	6741                	lui	a4,0x10
    800033b6:	16e7f663          	bleu	a4,a5,80003522 <bmap+0x1a0>
    uint first_p = 12;
    uint second_p = bn / 256;
    800033ba:	0085d99b          	srliw	s3,a1,0x8
    uint third_p = bn % 256;
    800033be:	0ff5f493          	andi	s1,a1,255

    uint *b;
    struct buf *bp2;

    if((addr = ip->addrs[first_p]) == 0)
    800033c2:	08052583          	lw	a1,128(a0)
    800033c6:	10058463          	beqz	a1,800034ce <bmap+0x14c>
      ip->addrs[first_p] = addr = balloc(ip->dev);

    bp = bread(ip->dev, addr);
    800033ca:	00092503          	lw	a0,0(s2)
    800033ce:	00000097          	auipc	ra,0x0
    800033d2:	ac0080e7          	jalr	-1344(ra) # 80002e8e <bread>
    800033d6:	8aaa                	mv	s5,a0
    a = (uint*)bp->data;
    800033d8:	05850793          	addi	a5,a0,88
    if((addr = a[second_p]) == 0){
    800033dc:	1982                	slli	s3,s3,0x20
    800033de:	0209d993          	srli	s3,s3,0x20
    800033e2:	098a                	slli	s3,s3,0x2
    800033e4:	99be                	add	s3,s3,a5
    800033e6:	0009aa03          	lw	s4,0(s3)
    800033ea:	0e0a0c63          	beqz	s4,800034e2 <bmap+0x160>
      a[second_p] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800033ee:	8556                	mv	a0,s5
    800033f0:	00000097          	auipc	ra,0x0
    800033f4:	be0080e7          	jalr	-1056(ra) # 80002fd0 <brelse>

    bp2 = bread(ip->dev, addr);
    800033f8:	85d2                	mv	a1,s4
    800033fa:	00092503          	lw	a0,0(s2)
    800033fe:	00000097          	auipc	ra,0x0
    80003402:	a90080e7          	jalr	-1392(ra) # 80002e8e <bread>
    80003406:	8a2a                	mv	s4,a0
    b = (uint*)bp2->data;
    80003408:	05850793          	addi	a5,a0,88
    if((addr = b[third_p]) == 0){
    8000340c:	048a                	slli	s1,s1,0x2
    8000340e:	94be                	add	s1,s1,a5
    80003410:	0004a983          	lw	s3,0(s1)
    80003414:	0e098763          	beqz	s3,80003502 <bmap+0x180>
      b[third_p] = addr = balloc(ip->dev);
      log_write(bp2);
    }
    brelse(bp2);
    80003418:	8552                	mv	a0,s4
    8000341a:	00000097          	auipc	ra,0x0
    8000341e:	bb6080e7          	jalr	-1098(ra) # 80002fd0 <brelse>
    return addr;
  }

  printf("bn= %d\n", bn);
  panic("bmap: out of range");
}
    80003422:	854e                	mv	a0,s3
    80003424:	70e2                	ld	ra,56(sp)
    80003426:	7442                	ld	s0,48(sp)
    80003428:	74a2                	ld	s1,40(sp)
    8000342a:	7902                	ld	s2,32(sp)
    8000342c:	69e2                	ld	s3,24(sp)
    8000342e:	6a42                	ld	s4,16(sp)
    80003430:	6aa2                	ld	s5,8(sp)
    80003432:	6121                	addi	sp,sp,64
    80003434:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80003436:	02059493          	slli	s1,a1,0x20
    8000343a:	9081                	srli	s1,s1,0x20
    8000343c:	048a                	slli	s1,s1,0x2
    8000343e:	94aa                	add	s1,s1,a0
    80003440:	0504a983          	lw	s3,80(s1)
    80003444:	fc099fe3          	bnez	s3,80003422 <bmap+0xa0>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80003448:	4108                	lw	a0,0(a0)
    8000344a:	00000097          	auipc	ra,0x0
    8000344e:	d2c080e7          	jalr	-724(ra) # 80003176 <balloc>
    80003452:	0005099b          	sext.w	s3,a0
    80003456:	0534a823          	sw	s3,80(s1)
    8000345a:	b7e1                	j	80003422 <bmap+0xa0>
    uint second_p = bn % 256;
    8000345c:	0ff7f993          	andi	s3,a5,255
    uint first_p = NDIRECT + bn / 256;
    80003460:	0087d49b          	srliw	s1,a5,0x8
    80003464:	249d                	addiw	s1,s1,7
    80003466:	1482                	slli	s1,s1,0x20
    80003468:	9081                	srli	s1,s1,0x20
    8000346a:	048a                	slli	s1,s1,0x2
    8000346c:	94aa                	add	s1,s1,a0
    if((addr = ip->addrs[first_p]) == 0) // addrs[first_p] is indirect pointer
    8000346e:	48ac                	lw	a1,80(s1)
    80003470:	c595                	beqz	a1,8000349c <bmap+0x11a>
    bp = bread(ip->dev, addr);
    80003472:	00092503          	lw	a0,0(s2)
    80003476:	00000097          	auipc	ra,0x0
    8000347a:	a18080e7          	jalr	-1512(ra) # 80002e8e <bread>
    8000347e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data; // data of block @ addr
    80003480:	05850493          	addi	s1,a0,88
    if((addr = a[second_p]) == 0){
    80003484:	098a                	slli	s3,s3,0x2
    80003486:	94ce                	add	s1,s1,s3
    80003488:	0004a983          	lw	s3,0(s1)
    8000348c:	02098163          	beqz	s3,800034ae <bmap+0x12c>
    brelse(bp);
    80003490:	8552                	mv	a0,s4
    80003492:	00000097          	auipc	ra,0x0
    80003496:	b3e080e7          	jalr	-1218(ra) # 80002fd0 <brelse>
    return addr;
    8000349a:	b761                	j	80003422 <bmap+0xa0>
      ip->addrs[first_p] = addr = balloc(ip->dev);
    8000349c:	4108                	lw	a0,0(a0)
    8000349e:	00000097          	auipc	ra,0x0
    800034a2:	cd8080e7          	jalr	-808(ra) # 80003176 <balloc>
    800034a6:	0005059b          	sext.w	a1,a0
    800034aa:	c8ac                	sw	a1,80(s1)
    800034ac:	b7d9                	j	80003472 <bmap+0xf0>
      a[second_p] = addr = balloc(ip->dev); // data[second_p] put address of block
    800034ae:	00092503          	lw	a0,0(s2)
    800034b2:	00000097          	auipc	ra,0x0
    800034b6:	cc4080e7          	jalr	-828(ra) # 80003176 <balloc>
    800034ba:	0005099b          	sext.w	s3,a0
    800034be:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800034c2:	8552                	mv	a0,s4
    800034c4:	00001097          	auipc	ra,0x1
    800034c8:	fe0080e7          	jalr	-32(ra) # 800044a4 <log_write>
    800034cc:	b7d1                	j	80003490 <bmap+0x10e>
      ip->addrs[first_p] = addr = balloc(ip->dev);
    800034ce:	4108                	lw	a0,0(a0)
    800034d0:	00000097          	auipc	ra,0x0
    800034d4:	ca6080e7          	jalr	-858(ra) # 80003176 <balloc>
    800034d8:	0005059b          	sext.w	a1,a0
    800034dc:	08b92023          	sw	a1,128(s2)
    800034e0:	b5ed                	j	800033ca <bmap+0x48>
      a[second_p] = addr = balloc(ip->dev);
    800034e2:	00092503          	lw	a0,0(s2)
    800034e6:	00000097          	auipc	ra,0x0
    800034ea:	c90080e7          	jalr	-880(ra) # 80003176 <balloc>
    800034ee:	00050a1b          	sext.w	s4,a0
    800034f2:	0149a023          	sw	s4,0(s3)
      log_write(bp);
    800034f6:	8556                	mv	a0,s5
    800034f8:	00001097          	auipc	ra,0x1
    800034fc:	fac080e7          	jalr	-84(ra) # 800044a4 <log_write>
    80003500:	b5fd                	j	800033ee <bmap+0x6c>
      b[third_p] = addr = balloc(ip->dev);
    80003502:	00092503          	lw	a0,0(s2)
    80003506:	00000097          	auipc	ra,0x0
    8000350a:	c70080e7          	jalr	-912(ra) # 80003176 <balloc>
    8000350e:	0005099b          	sext.w	s3,a0
    80003512:	0134a023          	sw	s3,0(s1)
      log_write(bp2);
    80003516:	8552                	mv	a0,s4
    80003518:	00001097          	auipc	ra,0x1
    8000351c:	f8c080e7          	jalr	-116(ra) # 800044a4 <log_write>
    80003520:	bde5                	j	80003418 <bmap+0x96>
  printf("bn= %d\n", bn);
    80003522:	85be                	mv	a1,a5
    80003524:	00005517          	auipc	a0,0x5
    80003528:	03c50513          	addi	a0,a0,60 # 80008560 <syscalls+0x158>
    8000352c:	ffffd097          	auipc	ra,0xffffd
    80003530:	076080e7          	jalr	118(ra) # 800005a2 <printf>
  panic("bmap: out of range");
    80003534:	00005517          	auipc	a0,0x5
    80003538:	03450513          	addi	a0,a0,52 # 80008568 <syscalls+0x160>
    8000353c:	ffffd097          	auipc	ra,0xffffd
    80003540:	01c080e7          	jalr	28(ra) # 80000558 <panic>

0000000080003544 <fsinit>:
fsinit(int dev) {
    80003544:	7179                	addi	sp,sp,-48
    80003546:	f406                	sd	ra,40(sp)
    80003548:	f022                	sd	s0,32(sp)
    8000354a:	ec26                	sd	s1,24(sp)
    8000354c:	e84a                	sd	s2,16(sp)
    8000354e:	e44e                	sd	s3,8(sp)
    80003550:	1800                	addi	s0,sp,48
    80003552:	89aa                	mv	s3,a0
  bp = bread(dev, 1);
    80003554:	4585                	li	a1,1
    80003556:	00000097          	auipc	ra,0x0
    8000355a:	938080e7          	jalr	-1736(ra) # 80002e8e <bread>
    8000355e:	892a                	mv	s2,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003560:	0001c497          	auipc	s1,0x1c
    80003564:	24848493          	addi	s1,s1,584 # 8001f7a8 <sb>
    80003568:	02000613          	li	a2,32
    8000356c:	05850593          	addi	a1,a0,88
    80003570:	8526                	mv	a0,s1
    80003572:	ffffe097          	auipc	ra,0xffffe
    80003576:	816080e7          	jalr	-2026(ra) # 80000d88 <memmove>
  brelse(bp);
    8000357a:	854a                	mv	a0,s2
    8000357c:	00000097          	auipc	ra,0x0
    80003580:	a54080e7          	jalr	-1452(ra) # 80002fd0 <brelse>
  if(sb.magic != FSMAGIC)
    80003584:	4098                	lw	a4,0(s1)
    80003586:	102037b7          	lui	a5,0x10203
    8000358a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000358e:	02f71263          	bne	a4,a5,800035b2 <fsinit+0x6e>
  initlog(dev, &sb);
    80003592:	0001c597          	auipc	a1,0x1c
    80003596:	21658593          	addi	a1,a1,534 # 8001f7a8 <sb>
    8000359a:	854e                	mv	a0,s3
    8000359c:	00001097          	auipc	ra,0x1
    800035a0:	c86080e7          	jalr	-890(ra) # 80004222 <initlog>
}
    800035a4:	70a2                	ld	ra,40(sp)
    800035a6:	7402                	ld	s0,32(sp)
    800035a8:	64e2                	ld	s1,24(sp)
    800035aa:	6942                	ld	s2,16(sp)
    800035ac:	69a2                	ld	s3,8(sp)
    800035ae:	6145                	addi	sp,sp,48
    800035b0:	8082                	ret
    panic("invalid file system");
    800035b2:	00005517          	auipc	a0,0x5
    800035b6:	fce50513          	addi	a0,a0,-50 # 80008580 <syscalls+0x178>
    800035ba:	ffffd097          	auipc	ra,0xffffd
    800035be:	f9e080e7          	jalr	-98(ra) # 80000558 <panic>

00000000800035c2 <iinit>:
{
    800035c2:	7179                	addi	sp,sp,-48
    800035c4:	f406                	sd	ra,40(sp)
    800035c6:	f022                	sd	s0,32(sp)
    800035c8:	ec26                	sd	s1,24(sp)
    800035ca:	e84a                	sd	s2,16(sp)
    800035cc:	e44e                	sd	s3,8(sp)
    800035ce:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800035d0:	00005597          	auipc	a1,0x5
    800035d4:	fc858593          	addi	a1,a1,-56 # 80008598 <syscalls+0x190>
    800035d8:	0001c517          	auipc	a0,0x1c
    800035dc:	1f050513          	addi	a0,a0,496 # 8001f7c8 <itable>
    800035e0:	ffffd097          	auipc	ra,0xffffd
    800035e4:	5b0080e7          	jalr	1456(ra) # 80000b90 <initlock>
  for(i = 0; i < NINODE; i++) {
    800035e8:	0001c497          	auipc	s1,0x1c
    800035ec:	20848493          	addi	s1,s1,520 # 8001f7f0 <itable+0x28>
    800035f0:	0001e997          	auipc	s3,0x1e
    800035f4:	c9098993          	addi	s3,s3,-880 # 80021280 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800035f8:	00005917          	auipc	s2,0x5
    800035fc:	fa890913          	addi	s2,s2,-88 # 800085a0 <syscalls+0x198>
    80003600:	85ca                	mv	a1,s2
    80003602:	8526                	mv	a0,s1
    80003604:	00001097          	auipc	ra,0x1
    80003608:	f9a080e7          	jalr	-102(ra) # 8000459e <initsleeplock>
    8000360c:	08848493          	addi	s1,s1,136
  for(i = 0; i < NINODE; i++) {
    80003610:	ff3498e3          	bne	s1,s3,80003600 <iinit+0x3e>
}
    80003614:	70a2                	ld	ra,40(sp)
    80003616:	7402                	ld	s0,32(sp)
    80003618:	64e2                	ld	s1,24(sp)
    8000361a:	6942                	ld	s2,16(sp)
    8000361c:	69a2                	ld	s3,8(sp)
    8000361e:	6145                	addi	sp,sp,48
    80003620:	8082                	ret

0000000080003622 <ialloc>:
{
    80003622:	715d                	addi	sp,sp,-80
    80003624:	e486                	sd	ra,72(sp)
    80003626:	e0a2                	sd	s0,64(sp)
    80003628:	fc26                	sd	s1,56(sp)
    8000362a:	f84a                	sd	s2,48(sp)
    8000362c:	f44e                	sd	s3,40(sp)
    8000362e:	f052                	sd	s4,32(sp)
    80003630:	ec56                	sd	s5,24(sp)
    80003632:	e85a                	sd	s6,16(sp)
    80003634:	e45e                	sd	s7,8(sp)
    80003636:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003638:	0001c797          	auipc	a5,0x1c
    8000363c:	17078793          	addi	a5,a5,368 # 8001f7a8 <sb>
    80003640:	47d8                	lw	a4,12(a5)
    80003642:	4785                	li	a5,1
    80003644:	04e7fa63          	bleu	a4,a5,80003698 <ialloc+0x76>
    80003648:	8a2a                	mv	s4,a0
    8000364a:	8b2e                	mv	s6,a1
    8000364c:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000364e:	0001c997          	auipc	s3,0x1c
    80003652:	15a98993          	addi	s3,s3,346 # 8001f7a8 <sb>
    80003656:	00048a9b          	sext.w	s5,s1
    8000365a:	0044d593          	srli	a1,s1,0x4
    8000365e:	0189a783          	lw	a5,24(s3)
    80003662:	9dbd                	addw	a1,a1,a5
    80003664:	8552                	mv	a0,s4
    80003666:	00000097          	auipc	ra,0x0
    8000366a:	828080e7          	jalr	-2008(ra) # 80002e8e <bread>
    8000366e:	8baa                	mv	s7,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003670:	05850913          	addi	s2,a0,88
    80003674:	00f4f793          	andi	a5,s1,15
    80003678:	079a                	slli	a5,a5,0x6
    8000367a:	993e                	add	s2,s2,a5
    if(dip->type == 0){  // a free inode
    8000367c:	00091783          	lh	a5,0(s2)
    80003680:	c785                	beqz	a5,800036a8 <ialloc+0x86>
    brelse(bp);
    80003682:	00000097          	auipc	ra,0x0
    80003686:	94e080e7          	jalr	-1714(ra) # 80002fd0 <brelse>
    8000368a:	0485                	addi	s1,s1,1
  for(inum = 1; inum < sb.ninodes; inum++){
    8000368c:	00c9a703          	lw	a4,12(s3)
    80003690:	0004879b          	sext.w	a5,s1
    80003694:	fce7e1e3          	bltu	a5,a4,80003656 <ialloc+0x34>
  panic("ialloc: no inodes");
    80003698:	00005517          	auipc	a0,0x5
    8000369c:	f1050513          	addi	a0,a0,-240 # 800085a8 <syscalls+0x1a0>
    800036a0:	ffffd097          	auipc	ra,0xffffd
    800036a4:	eb8080e7          	jalr	-328(ra) # 80000558 <panic>
      memset(dip, 0, sizeof(*dip));
    800036a8:	04000613          	li	a2,64
    800036ac:	4581                	li	a1,0
    800036ae:	854a                	mv	a0,s2
    800036b0:	ffffd097          	auipc	ra,0xffffd
    800036b4:	66c080e7          	jalr	1644(ra) # 80000d1c <memset>
      dip->type = type;
    800036b8:	01691023          	sh	s6,0(s2)
      log_write(bp);   // mark it allocated on the disk
    800036bc:	855e                	mv	a0,s7
    800036be:	00001097          	auipc	ra,0x1
    800036c2:	de6080e7          	jalr	-538(ra) # 800044a4 <log_write>
      brelse(bp);
    800036c6:	855e                	mv	a0,s7
    800036c8:	00000097          	auipc	ra,0x0
    800036cc:	908080e7          	jalr	-1784(ra) # 80002fd0 <brelse>
      return iget(dev, inum);
    800036d0:	85d6                	mv	a1,s5
    800036d2:	8552                	mv	a0,s4
    800036d4:	00000097          	auipc	ra,0x0
    800036d8:	bf2080e7          	jalr	-1038(ra) # 800032c6 <iget>
}
    800036dc:	60a6                	ld	ra,72(sp)
    800036de:	6406                	ld	s0,64(sp)
    800036e0:	74e2                	ld	s1,56(sp)
    800036e2:	7942                	ld	s2,48(sp)
    800036e4:	79a2                	ld	s3,40(sp)
    800036e6:	7a02                	ld	s4,32(sp)
    800036e8:	6ae2                	ld	s5,24(sp)
    800036ea:	6b42                	ld	s6,16(sp)
    800036ec:	6ba2                	ld	s7,8(sp)
    800036ee:	6161                	addi	sp,sp,80
    800036f0:	8082                	ret

00000000800036f2 <iupdate>:
{
    800036f2:	1101                	addi	sp,sp,-32
    800036f4:	ec06                	sd	ra,24(sp)
    800036f6:	e822                	sd	s0,16(sp)
    800036f8:	e426                	sd	s1,8(sp)
    800036fa:	e04a                	sd	s2,0(sp)
    800036fc:	1000                	addi	s0,sp,32
    800036fe:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003700:	415c                	lw	a5,4(a0)
    80003702:	0047d79b          	srliw	a5,a5,0x4
    80003706:	0001c717          	auipc	a4,0x1c
    8000370a:	0a270713          	addi	a4,a4,162 # 8001f7a8 <sb>
    8000370e:	4f0c                	lw	a1,24(a4)
    80003710:	9dbd                	addw	a1,a1,a5
    80003712:	4108                	lw	a0,0(a0)
    80003714:	fffff097          	auipc	ra,0xfffff
    80003718:	77a080e7          	jalr	1914(ra) # 80002e8e <bread>
    8000371c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000371e:	05850513          	addi	a0,a0,88
    80003722:	40dc                	lw	a5,4(s1)
    80003724:	8bbd                	andi	a5,a5,15
    80003726:	079a                	slli	a5,a5,0x6
    80003728:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    8000372a:	04449783          	lh	a5,68(s1)
    8000372e:	00f51023          	sh	a5,0(a0)
  dip->major = ip->major;
    80003732:	04649783          	lh	a5,70(s1)
    80003736:	00f51123          	sh	a5,2(a0)
  dip->minor = ip->minor;
    8000373a:	04849783          	lh	a5,72(s1)
    8000373e:	00f51223          	sh	a5,4(a0)
  dip->nlink = ip->nlink;
    80003742:	04a49783          	lh	a5,74(s1)
    80003746:	00f51323          	sh	a5,6(a0)
  dip->size = ip->size;
    8000374a:	44fc                	lw	a5,76(s1)
    8000374c:	c51c                	sw	a5,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000374e:	03400613          	li	a2,52
    80003752:	05048593          	addi	a1,s1,80
    80003756:	0531                	addi	a0,a0,12
    80003758:	ffffd097          	auipc	ra,0xffffd
    8000375c:	630080e7          	jalr	1584(ra) # 80000d88 <memmove>
  log_write(bp);
    80003760:	854a                	mv	a0,s2
    80003762:	00001097          	auipc	ra,0x1
    80003766:	d42080e7          	jalr	-702(ra) # 800044a4 <log_write>
  brelse(bp);
    8000376a:	854a                	mv	a0,s2
    8000376c:	00000097          	auipc	ra,0x0
    80003770:	864080e7          	jalr	-1948(ra) # 80002fd0 <brelse>
}
    80003774:	60e2                	ld	ra,24(sp)
    80003776:	6442                	ld	s0,16(sp)
    80003778:	64a2                	ld	s1,8(sp)
    8000377a:	6902                	ld	s2,0(sp)
    8000377c:	6105                	addi	sp,sp,32
    8000377e:	8082                	ret

0000000080003780 <idup>:
{
    80003780:	1101                	addi	sp,sp,-32
    80003782:	ec06                	sd	ra,24(sp)
    80003784:	e822                	sd	s0,16(sp)
    80003786:	e426                	sd	s1,8(sp)
    80003788:	1000                	addi	s0,sp,32
    8000378a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000378c:	0001c517          	auipc	a0,0x1c
    80003790:	03c50513          	addi	a0,a0,60 # 8001f7c8 <itable>
    80003794:	ffffd097          	auipc	ra,0xffffd
    80003798:	48c080e7          	jalr	1164(ra) # 80000c20 <acquire>
  ip->ref++;
    8000379c:	449c                	lw	a5,8(s1)
    8000379e:	2785                	addiw	a5,a5,1
    800037a0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800037a2:	0001c517          	auipc	a0,0x1c
    800037a6:	02650513          	addi	a0,a0,38 # 8001f7c8 <itable>
    800037aa:	ffffd097          	auipc	ra,0xffffd
    800037ae:	52a080e7          	jalr	1322(ra) # 80000cd4 <release>
}
    800037b2:	8526                	mv	a0,s1
    800037b4:	60e2                	ld	ra,24(sp)
    800037b6:	6442                	ld	s0,16(sp)
    800037b8:	64a2                	ld	s1,8(sp)
    800037ba:	6105                	addi	sp,sp,32
    800037bc:	8082                	ret

00000000800037be <ilock>:
{
    800037be:	1101                	addi	sp,sp,-32
    800037c0:	ec06                	sd	ra,24(sp)
    800037c2:	e822                	sd	s0,16(sp)
    800037c4:	e426                	sd	s1,8(sp)
    800037c6:	e04a                	sd	s2,0(sp)
    800037c8:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800037ca:	c115                	beqz	a0,800037ee <ilock+0x30>
    800037cc:	84aa                	mv	s1,a0
    800037ce:	451c                	lw	a5,8(a0)
    800037d0:	00f05f63          	blez	a5,800037ee <ilock+0x30>
  acquiresleep(&ip->lock);
    800037d4:	0541                	addi	a0,a0,16
    800037d6:	00001097          	auipc	ra,0x1
    800037da:	e02080e7          	jalr	-510(ra) # 800045d8 <acquiresleep>
  if(ip->valid == 0){
    800037de:	40bc                	lw	a5,64(s1)
    800037e0:	cf99                	beqz	a5,800037fe <ilock+0x40>
}
    800037e2:	60e2                	ld	ra,24(sp)
    800037e4:	6442                	ld	s0,16(sp)
    800037e6:	64a2                	ld	s1,8(sp)
    800037e8:	6902                	ld	s2,0(sp)
    800037ea:	6105                	addi	sp,sp,32
    800037ec:	8082                	ret
    panic("ilock");
    800037ee:	00005517          	auipc	a0,0x5
    800037f2:	dd250513          	addi	a0,a0,-558 # 800085c0 <syscalls+0x1b8>
    800037f6:	ffffd097          	auipc	ra,0xffffd
    800037fa:	d62080e7          	jalr	-670(ra) # 80000558 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800037fe:	40dc                	lw	a5,4(s1)
    80003800:	0047d79b          	srliw	a5,a5,0x4
    80003804:	0001c717          	auipc	a4,0x1c
    80003808:	fa470713          	addi	a4,a4,-92 # 8001f7a8 <sb>
    8000380c:	4f0c                	lw	a1,24(a4)
    8000380e:	9dbd                	addw	a1,a1,a5
    80003810:	4088                	lw	a0,0(s1)
    80003812:	fffff097          	auipc	ra,0xfffff
    80003816:	67c080e7          	jalr	1660(ra) # 80002e8e <bread>
    8000381a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000381c:	05850593          	addi	a1,a0,88
    80003820:	40dc                	lw	a5,4(s1)
    80003822:	8bbd                	andi	a5,a5,15
    80003824:	079a                	slli	a5,a5,0x6
    80003826:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003828:	00059783          	lh	a5,0(a1)
    8000382c:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003830:	00259783          	lh	a5,2(a1)
    80003834:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003838:	00459783          	lh	a5,4(a1)
    8000383c:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003840:	00659783          	lh	a5,6(a1)
    80003844:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003848:	459c                	lw	a5,8(a1)
    8000384a:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000384c:	03400613          	li	a2,52
    80003850:	05b1                	addi	a1,a1,12
    80003852:	05048513          	addi	a0,s1,80
    80003856:	ffffd097          	auipc	ra,0xffffd
    8000385a:	532080e7          	jalr	1330(ra) # 80000d88 <memmove>
    brelse(bp);
    8000385e:	854a                	mv	a0,s2
    80003860:	fffff097          	auipc	ra,0xfffff
    80003864:	770080e7          	jalr	1904(ra) # 80002fd0 <brelse>
    ip->valid = 1;
    80003868:	4785                	li	a5,1
    8000386a:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000386c:	04449783          	lh	a5,68(s1)
    80003870:	fbad                	bnez	a5,800037e2 <ilock+0x24>
      panic("ilock: no type");
    80003872:	00005517          	auipc	a0,0x5
    80003876:	d5650513          	addi	a0,a0,-682 # 800085c8 <syscalls+0x1c0>
    8000387a:	ffffd097          	auipc	ra,0xffffd
    8000387e:	cde080e7          	jalr	-802(ra) # 80000558 <panic>

0000000080003882 <iunlock>:
{
    80003882:	1101                	addi	sp,sp,-32
    80003884:	ec06                	sd	ra,24(sp)
    80003886:	e822                	sd	s0,16(sp)
    80003888:	e426                	sd	s1,8(sp)
    8000388a:	e04a                	sd	s2,0(sp)
    8000388c:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000388e:	c905                	beqz	a0,800038be <iunlock+0x3c>
    80003890:	84aa                	mv	s1,a0
    80003892:	01050913          	addi	s2,a0,16
    80003896:	854a                	mv	a0,s2
    80003898:	00001097          	auipc	ra,0x1
    8000389c:	dda080e7          	jalr	-550(ra) # 80004672 <holdingsleep>
    800038a0:	cd19                	beqz	a0,800038be <iunlock+0x3c>
    800038a2:	449c                	lw	a5,8(s1)
    800038a4:	00f05d63          	blez	a5,800038be <iunlock+0x3c>
  releasesleep(&ip->lock);
    800038a8:	854a                	mv	a0,s2
    800038aa:	00001097          	auipc	ra,0x1
    800038ae:	d84080e7          	jalr	-636(ra) # 8000462e <releasesleep>
}
    800038b2:	60e2                	ld	ra,24(sp)
    800038b4:	6442                	ld	s0,16(sp)
    800038b6:	64a2                	ld	s1,8(sp)
    800038b8:	6902                	ld	s2,0(sp)
    800038ba:	6105                	addi	sp,sp,32
    800038bc:	8082                	ret
    panic("iunlock");
    800038be:	00005517          	auipc	a0,0x5
    800038c2:	d1a50513          	addi	a0,a0,-742 # 800085d8 <syscalls+0x1d0>
    800038c6:	ffffd097          	auipc	ra,0xffffd
    800038ca:	c92080e7          	jalr	-878(ra) # 80000558 <panic>

00000000800038ce <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800038ce:	715d                	addi	sp,sp,-80
    800038d0:	e486                	sd	ra,72(sp)
    800038d2:	e0a2                	sd	s0,64(sp)
    800038d4:	fc26                	sd	s1,56(sp)
    800038d6:	f84a                	sd	s2,48(sp)
    800038d8:	f44e                	sd	s3,40(sp)
    800038da:	f052                	sd	s4,32(sp)
    800038dc:	ec56                	sd	s5,24(sp)
    800038de:	e85a                	sd	s6,16(sp)
    800038e0:	e45e                	sd	s7,8(sp)
    800038e2:	e062                	sd	s8,0(sp)
    800038e4:	0880                	addi	s0,sp,80
    800038e6:	89aa                	mv	s3,a0
  // so that it can handle doubly indirect inode.
  int i, j, k; // i:first pointer, j:second pointer, k: third pointer
  struct buf *bp, *bp2;
  uint *a, *b;

  for(i = 0; i < NDIRECT; i++){
    800038e8:	05050493          	addi	s1,a0,80
    800038ec:	06c50913          	addi	s2,a0,108
    800038f0:	a021                	j	800038f8 <itrunc+0x2a>
    800038f2:	0491                	addi	s1,s1,4
    800038f4:	01248d63          	beq	s1,s2,8000390e <itrunc+0x40>
    if(ip->addrs[i]){
    800038f8:	408c                	lw	a1,0(s1)
    800038fa:	dde5                	beqz	a1,800038f2 <itrunc+0x24>
      bfree(ip->dev, ip->addrs[i]);
    800038fc:	0009a503          	lw	a0,0(s3)
    80003900:	fffff097          	auipc	ra,0xfffff
    80003904:	7e6080e7          	jalr	2022(ra) # 800030e6 <bfree>
      ip->addrs[i] = 0;
    80003908:	0004a023          	sw	zero,0(s1)
    8000390c:	b7dd                	j	800038f2 <itrunc+0x24>
    8000390e:	06c98a13          	addi	s4,s3,108
    80003912:	08098b13          	addi	s6,s3,128
    }
  }

  for(i = NDIRECT; i < NDIRECT + 5; i++){
    if(ip->addrs[i]){
    80003916:	8ad2                	mv	s5,s4
    80003918:	000a2583          	lw	a1,0(s4) # 2000 <_entry-0x7fffe000>
    8000391c:	e995                	bnez	a1,80003950 <itrunc+0x82>
    8000391e:	0a11                	addi	s4,s4,4
  for(i = NDIRECT; i < NDIRECT + 5; i++){
    80003920:	ff6a1be3          	bne	s4,s6,80003916 <itrunc+0x48>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  i++;
  if(ip->addrs[i]){
    80003924:	0849a583          	lw	a1,132(s3)
    80003928:	eda5                	bnez	a1,800039a0 <itrunc+0xd2>
    brelse(bp);
    bfree(ip->dev, ip->addrs[i]);
    ip->addrs[i] = 0;
  }

  ip->size = 0;
    8000392a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000392e:	854e                	mv	a0,s3
    80003930:	00000097          	auipc	ra,0x0
    80003934:	dc2080e7          	jalr	-574(ra) # 800036f2 <iupdate>
}
    80003938:	60a6                	ld	ra,72(sp)
    8000393a:	6406                	ld	s0,64(sp)
    8000393c:	74e2                	ld	s1,56(sp)
    8000393e:	7942                	ld	s2,48(sp)
    80003940:	79a2                	ld	s3,40(sp)
    80003942:	7a02                	ld	s4,32(sp)
    80003944:	6ae2                	ld	s5,24(sp)
    80003946:	6b42                	ld	s6,16(sp)
    80003948:	6ba2                	ld	s7,8(sp)
    8000394a:	6c02                	ld	s8,0(sp)
    8000394c:	6161                	addi	sp,sp,80
    8000394e:	8082                	ret
      bp = bread(ip->dev, ip->addrs[i]);
    80003950:	0009a503          	lw	a0,0(s3)
    80003954:	fffff097          	auipc	ra,0xfffff
    80003958:	53a080e7          	jalr	1338(ra) # 80002e8e <bread>
    8000395c:	8baa                	mv	s7,a0
      for(j = 0; j < 256; j++){
    8000395e:	05850493          	addi	s1,a0,88
    80003962:	45850913          	addi	s2,a0,1112
    80003966:	a811                	j	8000397a <itrunc+0xac>
          bfree(ip->dev, a[j]);
    80003968:	0009a503          	lw	a0,0(s3)
    8000396c:	fffff097          	auipc	ra,0xfffff
    80003970:	77a080e7          	jalr	1914(ra) # 800030e6 <bfree>
    80003974:	0491                	addi	s1,s1,4
      for(j = 0; j < 256; j++){
    80003976:	01248563          	beq	s1,s2,80003980 <itrunc+0xb2>
        if(a[j])
    8000397a:	408c                	lw	a1,0(s1)
    8000397c:	dde5                	beqz	a1,80003974 <itrunc+0xa6>
    8000397e:	b7ed                	j	80003968 <itrunc+0x9a>
      brelse(bp);
    80003980:	855e                	mv	a0,s7
    80003982:	fffff097          	auipc	ra,0xfffff
    80003986:	64e080e7          	jalr	1614(ra) # 80002fd0 <brelse>
      bfree(ip->dev, ip->addrs[i]);
    8000398a:	000aa583          	lw	a1,0(s5)
    8000398e:	0009a503          	lw	a0,0(s3)
    80003992:	fffff097          	auipc	ra,0xfffff
    80003996:	754080e7          	jalr	1876(ra) # 800030e6 <bfree>
      ip->addrs[i] = 0;
    8000399a:	000aa023          	sw	zero,0(s5)
    8000399e:	b741                	j	8000391e <itrunc+0x50>
    bp = bread(ip->dev, ip->addrs[i]);
    800039a0:	0009a503          	lw	a0,0(s3)
    800039a4:	fffff097          	auipc	ra,0xfffff
    800039a8:	4ea080e7          	jalr	1258(ra) # 80002e8e <bread>
    800039ac:	8c2a                	mv	s8,a0
    for(int j = 0; j < 256; j++){
    800039ae:	05850a13          	addi	s4,a0,88
    800039b2:	45850b13          	addi	s6,a0,1112
    800039b6:	a82d                	j	800039f0 <itrunc+0x122>
            bfree(ip->dev, b[k]);
    800039b8:	0009a503          	lw	a0,0(s3)
    800039bc:	fffff097          	auipc	ra,0xfffff
    800039c0:	72a080e7          	jalr	1834(ra) # 800030e6 <bfree>
    800039c4:	0491                	addi	s1,s1,4
        for(k = 0; k < 256; k++){
    800039c6:	01248563          	beq	s1,s2,800039d0 <itrunc+0x102>
          if(b[k])
    800039ca:	408c                	lw	a1,0(s1)
    800039cc:	dde5                	beqz	a1,800039c4 <itrunc+0xf6>
    800039ce:	b7ed                	j	800039b8 <itrunc+0xea>
        brelse(bp2);
    800039d0:	855e                	mv	a0,s7
    800039d2:	fffff097          	auipc	ra,0xfffff
    800039d6:	5fe080e7          	jalr	1534(ra) # 80002fd0 <brelse>
        bfree(ip->dev, a[j]);
    800039da:	000aa583          	lw	a1,0(s5)
    800039de:	0009a503          	lw	a0,0(s3)
    800039e2:	fffff097          	auipc	ra,0xfffff
    800039e6:	704080e7          	jalr	1796(ra) # 800030e6 <bfree>
    800039ea:	0a11                	addi	s4,s4,4
    for(int j = 0; j < 256; j++){
    800039ec:	034b0263          	beq	s6,s4,80003a10 <itrunc+0x142>
      if(a[j]){
    800039f0:	8ad2                	mv	s5,s4
    800039f2:	000a2583          	lw	a1,0(s4)
    800039f6:	d9f5                	beqz	a1,800039ea <itrunc+0x11c>
        bp2 = bread(ip->dev, a[j]);
    800039f8:	0009a503          	lw	a0,0(s3)
    800039fc:	fffff097          	auipc	ra,0xfffff
    80003a00:	492080e7          	jalr	1170(ra) # 80002e8e <bread>
    80003a04:	8baa                	mv	s7,a0
        for(k = 0; k < 256; k++){
    80003a06:	05850493          	addi	s1,a0,88
    80003a0a:	45850913          	addi	s2,a0,1112
    80003a0e:	bf75                	j	800039ca <itrunc+0xfc>
    brelse(bp);
    80003a10:	8562                	mv	a0,s8
    80003a12:	fffff097          	auipc	ra,0xfffff
    80003a16:	5be080e7          	jalr	1470(ra) # 80002fd0 <brelse>
    bfree(ip->dev, ip->addrs[i]);
    80003a1a:	0849a583          	lw	a1,132(s3)
    80003a1e:	0009a503          	lw	a0,0(s3)
    80003a22:	fffff097          	auipc	ra,0xfffff
    80003a26:	6c4080e7          	jalr	1732(ra) # 800030e6 <bfree>
    ip->addrs[i] = 0;
    80003a2a:	0809a223          	sw	zero,132(s3)
    80003a2e:	bdf5                	j	8000392a <itrunc+0x5c>

0000000080003a30 <iput>:
{
    80003a30:	1101                	addi	sp,sp,-32
    80003a32:	ec06                	sd	ra,24(sp)
    80003a34:	e822                	sd	s0,16(sp)
    80003a36:	e426                	sd	s1,8(sp)
    80003a38:	e04a                	sd	s2,0(sp)
    80003a3a:	1000                	addi	s0,sp,32
    80003a3c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003a3e:	0001c517          	auipc	a0,0x1c
    80003a42:	d8a50513          	addi	a0,a0,-630 # 8001f7c8 <itable>
    80003a46:	ffffd097          	auipc	ra,0xffffd
    80003a4a:	1da080e7          	jalr	474(ra) # 80000c20 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003a4e:	4498                	lw	a4,8(s1)
    80003a50:	4785                	li	a5,1
    80003a52:	02f70363          	beq	a4,a5,80003a78 <iput+0x48>
  ip->ref--;
    80003a56:	449c                	lw	a5,8(s1)
    80003a58:	37fd                	addiw	a5,a5,-1
    80003a5a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003a5c:	0001c517          	auipc	a0,0x1c
    80003a60:	d6c50513          	addi	a0,a0,-660 # 8001f7c8 <itable>
    80003a64:	ffffd097          	auipc	ra,0xffffd
    80003a68:	270080e7          	jalr	624(ra) # 80000cd4 <release>
}
    80003a6c:	60e2                	ld	ra,24(sp)
    80003a6e:	6442                	ld	s0,16(sp)
    80003a70:	64a2                	ld	s1,8(sp)
    80003a72:	6902                	ld	s2,0(sp)
    80003a74:	6105                	addi	sp,sp,32
    80003a76:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003a78:	40bc                	lw	a5,64(s1)
    80003a7a:	dff1                	beqz	a5,80003a56 <iput+0x26>
    80003a7c:	04a49783          	lh	a5,74(s1)
    80003a80:	fbf9                	bnez	a5,80003a56 <iput+0x26>
    acquiresleep(&ip->lock);
    80003a82:	01048913          	addi	s2,s1,16
    80003a86:	854a                	mv	a0,s2
    80003a88:	00001097          	auipc	ra,0x1
    80003a8c:	b50080e7          	jalr	-1200(ra) # 800045d8 <acquiresleep>
    release(&itable.lock);
    80003a90:	0001c517          	auipc	a0,0x1c
    80003a94:	d3850513          	addi	a0,a0,-712 # 8001f7c8 <itable>
    80003a98:	ffffd097          	auipc	ra,0xffffd
    80003a9c:	23c080e7          	jalr	572(ra) # 80000cd4 <release>
    itrunc(ip);
    80003aa0:	8526                	mv	a0,s1
    80003aa2:	00000097          	auipc	ra,0x0
    80003aa6:	e2c080e7          	jalr	-468(ra) # 800038ce <itrunc>
    ip->type = 0;
    80003aaa:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003aae:	8526                	mv	a0,s1
    80003ab0:	00000097          	auipc	ra,0x0
    80003ab4:	c42080e7          	jalr	-958(ra) # 800036f2 <iupdate>
    ip->valid = 0;
    80003ab8:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003abc:	854a                	mv	a0,s2
    80003abe:	00001097          	auipc	ra,0x1
    80003ac2:	b70080e7          	jalr	-1168(ra) # 8000462e <releasesleep>
    acquire(&itable.lock);
    80003ac6:	0001c517          	auipc	a0,0x1c
    80003aca:	d0250513          	addi	a0,a0,-766 # 8001f7c8 <itable>
    80003ace:	ffffd097          	auipc	ra,0xffffd
    80003ad2:	152080e7          	jalr	338(ra) # 80000c20 <acquire>
    80003ad6:	b741                	j	80003a56 <iput+0x26>

0000000080003ad8 <iunlockput>:
{
    80003ad8:	1101                	addi	sp,sp,-32
    80003ada:	ec06                	sd	ra,24(sp)
    80003adc:	e822                	sd	s0,16(sp)
    80003ade:	e426                	sd	s1,8(sp)
    80003ae0:	1000                	addi	s0,sp,32
    80003ae2:	84aa                	mv	s1,a0
  iunlock(ip);
    80003ae4:	00000097          	auipc	ra,0x0
    80003ae8:	d9e080e7          	jalr	-610(ra) # 80003882 <iunlock>
  iput(ip);
    80003aec:	8526                	mv	a0,s1
    80003aee:	00000097          	auipc	ra,0x0
    80003af2:	f42080e7          	jalr	-190(ra) # 80003a30 <iput>
}
    80003af6:	60e2                	ld	ra,24(sp)
    80003af8:	6442                	ld	s0,16(sp)
    80003afa:	64a2                	ld	s1,8(sp)
    80003afc:	6105                	addi	sp,sp,32
    80003afe:	8082                	ret

0000000080003b00 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003b00:	1141                	addi	sp,sp,-16
    80003b02:	e422                	sd	s0,8(sp)
    80003b04:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003b06:	411c                	lw	a5,0(a0)
    80003b08:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003b0a:	415c                	lw	a5,4(a0)
    80003b0c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003b0e:	04451783          	lh	a5,68(a0)
    80003b12:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003b16:	04a51783          	lh	a5,74(a0)
    80003b1a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003b1e:	04c56783          	lwu	a5,76(a0)
    80003b22:	e99c                	sd	a5,16(a1)
}
    80003b24:	6422                	ld	s0,8(sp)
    80003b26:	0141                	addi	sp,sp,16
    80003b28:	8082                	ret

0000000080003b2a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003b2a:	457c                	lw	a5,76(a0)
    80003b2c:	0ed7e963          	bltu	a5,a3,80003c1e <readi+0xf4>
{
    80003b30:	7159                	addi	sp,sp,-112
    80003b32:	f486                	sd	ra,104(sp)
    80003b34:	f0a2                	sd	s0,96(sp)
    80003b36:	eca6                	sd	s1,88(sp)
    80003b38:	e8ca                	sd	s2,80(sp)
    80003b3a:	e4ce                	sd	s3,72(sp)
    80003b3c:	e0d2                	sd	s4,64(sp)
    80003b3e:	fc56                	sd	s5,56(sp)
    80003b40:	f85a                	sd	s6,48(sp)
    80003b42:	f45e                	sd	s7,40(sp)
    80003b44:	f062                	sd	s8,32(sp)
    80003b46:	ec66                	sd	s9,24(sp)
    80003b48:	e86a                	sd	s10,16(sp)
    80003b4a:	e46e                	sd	s11,8(sp)
    80003b4c:	1880                	addi	s0,sp,112
    80003b4e:	8baa                	mv	s7,a0
    80003b50:	8c2e                	mv	s8,a1
    80003b52:	8a32                	mv	s4,a2
    80003b54:	84b6                	mv	s1,a3
    80003b56:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003b58:	9f35                	addw	a4,a4,a3
    return 0;
    80003b5a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003b5c:	0ad76063          	bltu	a4,a3,80003bfc <readi+0xd2>
  if(off + n > ip->size)
    80003b60:	00e7f463          	bleu	a4,a5,80003b68 <readi+0x3e>
    n = ip->size - off;
    80003b64:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b68:	0a0b0963          	beqz	s6,80003c1a <readi+0xf0>
    80003b6c:	4901                	li	s2,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b6e:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003b72:	5cfd                	li	s9,-1
    80003b74:	a82d                	j	80003bae <readi+0x84>
    80003b76:	02099d93          	slli	s11,s3,0x20
    80003b7a:	020ddd93          	srli	s11,s11,0x20
    80003b7e:	058a8613          	addi	a2,s5,88
    80003b82:	86ee                	mv	a3,s11
    80003b84:	963a                	add	a2,a2,a4
    80003b86:	85d2                	mv	a1,s4
    80003b88:	8562                	mv	a0,s8
    80003b8a:	fffff097          	auipc	ra,0xfffff
    80003b8e:	938080e7          	jalr	-1736(ra) # 800024c2 <either_copyout>
    80003b92:	05950d63          	beq	a0,s9,80003bec <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003b96:	8556                	mv	a0,s5
    80003b98:	fffff097          	auipc	ra,0xfffff
    80003b9c:	438080e7          	jalr	1080(ra) # 80002fd0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003ba0:	0129893b          	addw	s2,s3,s2
    80003ba4:	009984bb          	addw	s1,s3,s1
    80003ba8:	9a6e                	add	s4,s4,s11
    80003baa:	05697763          	bleu	s6,s2,80003bf8 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003bae:	000ba983          	lw	s3,0(s7)
    80003bb2:	00a4d59b          	srliw	a1,s1,0xa
    80003bb6:	855e                	mv	a0,s7
    80003bb8:	fffff097          	auipc	ra,0xfffff
    80003bbc:	7ca080e7          	jalr	1994(ra) # 80003382 <bmap>
    80003bc0:	0005059b          	sext.w	a1,a0
    80003bc4:	854e                	mv	a0,s3
    80003bc6:	fffff097          	auipc	ra,0xfffff
    80003bca:	2c8080e7          	jalr	712(ra) # 80002e8e <bread>
    80003bce:	8aaa                	mv	s5,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003bd0:	3ff4f713          	andi	a4,s1,1023
    80003bd4:	40ed07bb          	subw	a5,s10,a4
    80003bd8:	412b06bb          	subw	a3,s6,s2
    80003bdc:	89be                	mv	s3,a5
    80003bde:	2781                	sext.w	a5,a5
    80003be0:	0006861b          	sext.w	a2,a3
    80003be4:	f8f679e3          	bleu	a5,a2,80003b76 <readi+0x4c>
    80003be8:	89b6                	mv	s3,a3
    80003bea:	b771                	j	80003b76 <readi+0x4c>
      brelse(bp);
    80003bec:	8556                	mv	a0,s5
    80003bee:	fffff097          	auipc	ra,0xfffff
    80003bf2:	3e2080e7          	jalr	994(ra) # 80002fd0 <brelse>
      tot = -1;
    80003bf6:	597d                	li	s2,-1
  }
  return tot;
    80003bf8:	0009051b          	sext.w	a0,s2
}
    80003bfc:	70a6                	ld	ra,104(sp)
    80003bfe:	7406                	ld	s0,96(sp)
    80003c00:	64e6                	ld	s1,88(sp)
    80003c02:	6946                	ld	s2,80(sp)
    80003c04:	69a6                	ld	s3,72(sp)
    80003c06:	6a06                	ld	s4,64(sp)
    80003c08:	7ae2                	ld	s5,56(sp)
    80003c0a:	7b42                	ld	s6,48(sp)
    80003c0c:	7ba2                	ld	s7,40(sp)
    80003c0e:	7c02                	ld	s8,32(sp)
    80003c10:	6ce2                	ld	s9,24(sp)
    80003c12:	6d42                	ld	s10,16(sp)
    80003c14:	6da2                	ld	s11,8(sp)
    80003c16:	6165                	addi	sp,sp,112
    80003c18:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003c1a:	895a                	mv	s2,s6
    80003c1c:	bff1                	j	80003bf8 <readi+0xce>
    return 0;
    80003c1e:	4501                	li	a0,0
}
    80003c20:	8082                	ret

0000000080003c22 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003c22:	457c                	lw	a5,76(a0)
    80003c24:	10d7e963          	bltu	a5,a3,80003d36 <writei+0x114>
{
    80003c28:	7159                	addi	sp,sp,-112
    80003c2a:	f486                	sd	ra,104(sp)
    80003c2c:	f0a2                	sd	s0,96(sp)
    80003c2e:	eca6                	sd	s1,88(sp)
    80003c30:	e8ca                	sd	s2,80(sp)
    80003c32:	e4ce                	sd	s3,72(sp)
    80003c34:	e0d2                	sd	s4,64(sp)
    80003c36:	fc56                	sd	s5,56(sp)
    80003c38:	f85a                	sd	s6,48(sp)
    80003c3a:	f45e                	sd	s7,40(sp)
    80003c3c:	f062                	sd	s8,32(sp)
    80003c3e:	ec66                	sd	s9,24(sp)
    80003c40:	e86a                	sd	s10,16(sp)
    80003c42:	e46e                	sd	s11,8(sp)
    80003c44:	1880                	addi	s0,sp,112
    80003c46:	8b2a                	mv	s6,a0
    80003c48:	8c2e                	mv	s8,a1
    80003c4a:	8ab2                	mv	s5,a2
    80003c4c:	84b6                	mv	s1,a3
    80003c4e:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003c50:	9f35                	addw	a4,a4,a3
    80003c52:	0ed76463          	bltu	a4,a3,80003d3a <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003c56:	041427b7          	lui	a5,0x4142
    80003c5a:	c0078793          	addi	a5,a5,-1024 # 4141c00 <_entry-0x7bebe400>
    80003c5e:	0ee7e063          	bltu	a5,a4,80003d3e <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c62:	0c0b8863          	beqz	s7,80003d32 <writei+0x110>
    80003c66:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003c68:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003c6c:	5cfd                	li	s9,-1
    80003c6e:	a091                	j	80003cb2 <writei+0x90>
    80003c70:	02091d93          	slli	s11,s2,0x20
    80003c74:	020ddd93          	srli	s11,s11,0x20
    80003c78:	058a0513          	addi	a0,s4,88
    80003c7c:	86ee                	mv	a3,s11
    80003c7e:	8656                	mv	a2,s5
    80003c80:	85e2                	mv	a1,s8
    80003c82:	953a                	add	a0,a0,a4
    80003c84:	fffff097          	auipc	ra,0xfffff
    80003c88:	894080e7          	jalr	-1900(ra) # 80002518 <either_copyin>
    80003c8c:	07950263          	beq	a0,s9,80003cf0 <writei+0xce>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003c90:	8552                	mv	a0,s4
    80003c92:	00001097          	auipc	ra,0x1
    80003c96:	812080e7          	jalr	-2030(ra) # 800044a4 <log_write>
    brelse(bp);
    80003c9a:	8552                	mv	a0,s4
    80003c9c:	fffff097          	auipc	ra,0xfffff
    80003ca0:	334080e7          	jalr	820(ra) # 80002fd0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003ca4:	013909bb          	addw	s3,s2,s3
    80003ca8:	009904bb          	addw	s1,s2,s1
    80003cac:	9aee                	add	s5,s5,s11
    80003cae:	0579f663          	bleu	s7,s3,80003cfa <writei+0xd8>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003cb2:	000b2903          	lw	s2,0(s6)
    80003cb6:	00a4d59b          	srliw	a1,s1,0xa
    80003cba:	855a                	mv	a0,s6
    80003cbc:	fffff097          	auipc	ra,0xfffff
    80003cc0:	6c6080e7          	jalr	1734(ra) # 80003382 <bmap>
    80003cc4:	0005059b          	sext.w	a1,a0
    80003cc8:	854a                	mv	a0,s2
    80003cca:	fffff097          	auipc	ra,0xfffff
    80003cce:	1c4080e7          	jalr	452(ra) # 80002e8e <bread>
    80003cd2:	8a2a                	mv	s4,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003cd4:	3ff4f713          	andi	a4,s1,1023
    80003cd8:	40ed07bb          	subw	a5,s10,a4
    80003cdc:	413b86bb          	subw	a3,s7,s3
    80003ce0:	893e                	mv	s2,a5
    80003ce2:	2781                	sext.w	a5,a5
    80003ce4:	0006861b          	sext.w	a2,a3
    80003ce8:	f8f674e3          	bleu	a5,a2,80003c70 <writei+0x4e>
    80003cec:	8936                	mv	s2,a3
    80003cee:	b749                	j	80003c70 <writei+0x4e>
      brelse(bp);
    80003cf0:	8552                	mv	a0,s4
    80003cf2:	fffff097          	auipc	ra,0xfffff
    80003cf6:	2de080e7          	jalr	734(ra) # 80002fd0 <brelse>
  }

  if(off > ip->size)
    80003cfa:	04cb2783          	lw	a5,76(s6)
    80003cfe:	0097f463          	bleu	s1,a5,80003d06 <writei+0xe4>
    ip->size = off;
    80003d02:	049b2623          	sw	s1,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003d06:	855a                	mv	a0,s6
    80003d08:	00000097          	auipc	ra,0x0
    80003d0c:	9ea080e7          	jalr	-1558(ra) # 800036f2 <iupdate>

  return tot;
    80003d10:	0009851b          	sext.w	a0,s3
}
    80003d14:	70a6                	ld	ra,104(sp)
    80003d16:	7406                	ld	s0,96(sp)
    80003d18:	64e6                	ld	s1,88(sp)
    80003d1a:	6946                	ld	s2,80(sp)
    80003d1c:	69a6                	ld	s3,72(sp)
    80003d1e:	6a06                	ld	s4,64(sp)
    80003d20:	7ae2                	ld	s5,56(sp)
    80003d22:	7b42                	ld	s6,48(sp)
    80003d24:	7ba2                	ld	s7,40(sp)
    80003d26:	7c02                	ld	s8,32(sp)
    80003d28:	6ce2                	ld	s9,24(sp)
    80003d2a:	6d42                	ld	s10,16(sp)
    80003d2c:	6da2                	ld	s11,8(sp)
    80003d2e:	6165                	addi	sp,sp,112
    80003d30:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003d32:	89de                	mv	s3,s7
    80003d34:	bfc9                	j	80003d06 <writei+0xe4>
    return -1;
    80003d36:	557d                	li	a0,-1
}
    80003d38:	8082                	ret
    return -1;
    80003d3a:	557d                	li	a0,-1
    80003d3c:	bfe1                	j	80003d14 <writei+0xf2>
    return -1;
    80003d3e:	557d                	li	a0,-1
    80003d40:	bfd1                	j	80003d14 <writei+0xf2>

0000000080003d42 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003d42:	1141                	addi	sp,sp,-16
    80003d44:	e406                	sd	ra,8(sp)
    80003d46:	e022                	sd	s0,0(sp)
    80003d48:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003d4a:	4639                	li	a2,14
    80003d4c:	ffffd097          	auipc	ra,0xffffd
    80003d50:	0b8080e7          	jalr	184(ra) # 80000e04 <strncmp>
}
    80003d54:	60a2                	ld	ra,8(sp)
    80003d56:	6402                	ld	s0,0(sp)
    80003d58:	0141                	addi	sp,sp,16
    80003d5a:	8082                	ret

0000000080003d5c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003d5c:	7139                	addi	sp,sp,-64
    80003d5e:	fc06                	sd	ra,56(sp)
    80003d60:	f822                	sd	s0,48(sp)
    80003d62:	f426                	sd	s1,40(sp)
    80003d64:	f04a                	sd	s2,32(sp)
    80003d66:	ec4e                	sd	s3,24(sp)
    80003d68:	e852                	sd	s4,16(sp)
    80003d6a:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003d6c:	04451703          	lh	a4,68(a0)
    80003d70:	4785                	li	a5,1
    80003d72:	00f71a63          	bne	a4,a5,80003d86 <dirlookup+0x2a>
    80003d76:	892a                	mv	s2,a0
    80003d78:	89ae                	mv	s3,a1
    80003d7a:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d7c:	457c                	lw	a5,76(a0)
    80003d7e:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003d80:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d82:	e79d                	bnez	a5,80003db0 <dirlookup+0x54>
    80003d84:	a8a5                	j	80003dfc <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003d86:	00005517          	auipc	a0,0x5
    80003d8a:	85a50513          	addi	a0,a0,-1958 # 800085e0 <syscalls+0x1d8>
    80003d8e:	ffffc097          	auipc	ra,0xffffc
    80003d92:	7ca080e7          	jalr	1994(ra) # 80000558 <panic>
      panic("dirlookup read");
    80003d96:	00005517          	auipc	a0,0x5
    80003d9a:	86250513          	addi	a0,a0,-1950 # 800085f8 <syscalls+0x1f0>
    80003d9e:	ffffc097          	auipc	ra,0xffffc
    80003da2:	7ba080e7          	jalr	1978(ra) # 80000558 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003da6:	24c1                	addiw	s1,s1,16
    80003da8:	04c92783          	lw	a5,76(s2)
    80003dac:	04f4f763          	bleu	a5,s1,80003dfa <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003db0:	4741                	li	a4,16
    80003db2:	86a6                	mv	a3,s1
    80003db4:	fc040613          	addi	a2,s0,-64
    80003db8:	4581                	li	a1,0
    80003dba:	854a                	mv	a0,s2
    80003dbc:	00000097          	auipc	ra,0x0
    80003dc0:	d6e080e7          	jalr	-658(ra) # 80003b2a <readi>
    80003dc4:	47c1                	li	a5,16
    80003dc6:	fcf518e3          	bne	a0,a5,80003d96 <dirlookup+0x3a>
    if(de.inum == 0)
    80003dca:	fc045783          	lhu	a5,-64(s0)
    80003dce:	dfe1                	beqz	a5,80003da6 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003dd0:	fc240593          	addi	a1,s0,-62
    80003dd4:	854e                	mv	a0,s3
    80003dd6:	00000097          	auipc	ra,0x0
    80003dda:	f6c080e7          	jalr	-148(ra) # 80003d42 <namecmp>
    80003dde:	f561                	bnez	a0,80003da6 <dirlookup+0x4a>
      if(poff)
    80003de0:	000a0463          	beqz	s4,80003de8 <dirlookup+0x8c>
        *poff = off;
    80003de4:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003de8:	fc045583          	lhu	a1,-64(s0)
    80003dec:	00092503          	lw	a0,0(s2)
    80003df0:	fffff097          	auipc	ra,0xfffff
    80003df4:	4d6080e7          	jalr	1238(ra) # 800032c6 <iget>
    80003df8:	a011                	j	80003dfc <dirlookup+0xa0>
  return 0;
    80003dfa:	4501                	li	a0,0
}
    80003dfc:	70e2                	ld	ra,56(sp)
    80003dfe:	7442                	ld	s0,48(sp)
    80003e00:	74a2                	ld	s1,40(sp)
    80003e02:	7902                	ld	s2,32(sp)
    80003e04:	69e2                	ld	s3,24(sp)
    80003e06:	6a42                	ld	s4,16(sp)
    80003e08:	6121                	addi	sp,sp,64
    80003e0a:	8082                	ret

0000000080003e0c <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
    80003e0c:	7139                	addi	sp,sp,-64
    80003e0e:	fc06                	sd	ra,56(sp)
    80003e10:	f822                	sd	s0,48(sp)
    80003e12:	f426                	sd	s1,40(sp)
    80003e14:	f04a                	sd	s2,32(sp)
    80003e16:	ec4e                	sd	s3,24(sp)
    80003e18:	e852                	sd	s4,16(sp)
    80003e1a:	0080                	addi	s0,sp,64
    80003e1c:	892a                	mv	s2,a0
    80003e1e:	8a2e                	mv	s4,a1
    80003e20:	89b2                	mv	s3,a2
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e22:	4601                	li	a2,0
    80003e24:	00000097          	auipc	ra,0x0
    80003e28:	f38080e7          	jalr	-200(ra) # 80003d5c <dirlookup>
    80003e2c:	e93d                	bnez	a0,80003ea2 <dirlink+0x96>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e2e:	04c92483          	lw	s1,76(s2)
    80003e32:	c49d                	beqz	s1,80003e60 <dirlink+0x54>
    80003e34:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e36:	4741                	li	a4,16
    80003e38:	86a6                	mv	a3,s1
    80003e3a:	fc040613          	addi	a2,s0,-64
    80003e3e:	4581                	li	a1,0
    80003e40:	854a                	mv	a0,s2
    80003e42:	00000097          	auipc	ra,0x0
    80003e46:	ce8080e7          	jalr	-792(ra) # 80003b2a <readi>
    80003e4a:	47c1                	li	a5,16
    80003e4c:	06f51163          	bne	a0,a5,80003eae <dirlink+0xa2>
      panic("dirlink read");
    if(de.inum == 0)
    80003e50:	fc045783          	lhu	a5,-64(s0)
    80003e54:	c791                	beqz	a5,80003e60 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e56:	24c1                	addiw	s1,s1,16
    80003e58:	04c92783          	lw	a5,76(s2)
    80003e5c:	fcf4ede3          	bltu	s1,a5,80003e36 <dirlink+0x2a>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
    80003e60:	4639                	li	a2,14
    80003e62:	85d2                	mv	a1,s4
    80003e64:	fc240513          	addi	a0,s0,-62
    80003e68:	ffffd097          	auipc	ra,0xffffd
    80003e6c:	fec080e7          	jalr	-20(ra) # 80000e54 <strncpy>
  de.inum = inum;
    80003e70:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e74:	4741                	li	a4,16
    80003e76:	86a6                	mv	a3,s1
    80003e78:	fc040613          	addi	a2,s0,-64
    80003e7c:	4581                	li	a1,0
    80003e7e:	854a                	mv	a0,s2
    80003e80:	00000097          	auipc	ra,0x0
    80003e84:	da2080e7          	jalr	-606(ra) # 80003c22 <writei>
    80003e88:	4741                	li	a4,16
    panic("dirlink");

  return 0;
    80003e8a:	4781                	li	a5,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e8c:	02e51963          	bne	a0,a4,80003ebe <dirlink+0xb2>
}
    80003e90:	853e                	mv	a0,a5
    80003e92:	70e2                	ld	ra,56(sp)
    80003e94:	7442                	ld	s0,48(sp)
    80003e96:	74a2                	ld	s1,40(sp)
    80003e98:	7902                	ld	s2,32(sp)
    80003e9a:	69e2                	ld	s3,24(sp)
    80003e9c:	6a42                	ld	s4,16(sp)
    80003e9e:	6121                	addi	sp,sp,64
    80003ea0:	8082                	ret
    iput(ip);
    80003ea2:	00000097          	auipc	ra,0x0
    80003ea6:	b8e080e7          	jalr	-1138(ra) # 80003a30 <iput>
    return -1;
    80003eaa:	57fd                	li	a5,-1
    80003eac:	b7d5                	j	80003e90 <dirlink+0x84>
      panic("dirlink read");
    80003eae:	00004517          	auipc	a0,0x4
    80003eb2:	75a50513          	addi	a0,a0,1882 # 80008608 <syscalls+0x200>
    80003eb6:	ffffc097          	auipc	ra,0xffffc
    80003eba:	6a2080e7          	jalr	1698(ra) # 80000558 <panic>
    panic("dirlink");
    80003ebe:	00005517          	auipc	a0,0x5
    80003ec2:	85a50513          	addi	a0,a0,-1958 # 80008718 <syscalls+0x310>
    80003ec6:	ffffc097          	auipc	ra,0xffffc
    80003eca:	692080e7          	jalr	1682(ra) # 80000558 <panic>

0000000080003ece <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
    80003ece:	1101                	addi	sp,sp,-32
    80003ed0:	ec06                	sd	ra,24(sp)
    80003ed2:	e822                	sd	s0,16(sp)
    80003ed4:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003ed6:	fe040613          	addi	a2,s0,-32
    80003eda:	4581                	li	a1,0
    80003edc:	00000097          	auipc	ra,0x0
    80003ee0:	010080e7          	jalr	16(ra) # 80003eec <namex>
}
    80003ee4:	60e2                	ld	ra,24(sp)
    80003ee6:	6442                	ld	s0,16(sp)
    80003ee8:	6105                	addi	sp,sp,32
    80003eea:	8082                	ret

0000000080003eec <namex>:
{
    80003eec:	7151                	addi	sp,sp,-240
    80003eee:	f586                	sd	ra,232(sp)
    80003ef0:	f1a2                	sd	s0,224(sp)
    80003ef2:	eda6                	sd	s1,216(sp)
    80003ef4:	e9ca                	sd	s2,208(sp)
    80003ef6:	e5ce                	sd	s3,200(sp)
    80003ef8:	e1d2                	sd	s4,192(sp)
    80003efa:	fd56                	sd	s5,184(sp)
    80003efc:	f95a                	sd	s6,176(sp)
    80003efe:	f55e                	sd	s7,168(sp)
    80003f00:	f162                	sd	s8,160(sp)
    80003f02:	ed66                	sd	s9,152(sp)
    80003f04:	e96a                	sd	s10,144(sp)
    80003f06:	e56e                	sd	s11,136(sp)
    80003f08:	1980                	addi	s0,sp,240
    80003f0a:	84aa                	mv	s1,a0
    80003f0c:	8cae                	mv	s9,a1
    80003f0e:	8bb2                	mv	s7,a2
  if(*path == '/')
    80003f10:	00054703          	lbu	a4,0(a0)
    80003f14:	02f00793          	li	a5,47
    80003f18:	02f70463          	beq	a4,a5,80003f40 <namex+0x54>
    ip = idup(myproc()->cwd);
    80003f1c:	ffffe097          	auipc	ra,0xffffe
    80003f20:	b3c080e7          	jalr	-1220(ra) # 80001a58 <myproc>
    80003f24:	15053503          	ld	a0,336(a0)
    80003f28:	00000097          	auipc	ra,0x0
    80003f2c:	858080e7          	jalr	-1960(ra) # 80003780 <idup>
    80003f30:	892a                	mv	s2,a0
  while(*path == '/')
    80003f32:	02f00993          	li	s3,47
  len = path - s;
    80003f36:	4a81                	li	s5,0
  if(len >= DIRSIZ)
    80003f38:	4db5                	li	s11,13
    if(ip->type == T_SYMLINK){
    80003f3a:	4c11                	li	s8,4
    if(ip->type != T_DIR){
    80003f3c:	4d05                	li	s10,1
    80003f3e:	aa39                	j	8000405c <namex+0x170>
    ip = iget(ROOTDEV, ROOTINO);
    80003f40:	4585                	li	a1,1
    80003f42:	4505                	li	a0,1
    80003f44:	fffff097          	auipc	ra,0xfffff
    80003f48:	382080e7          	jalr	898(ra) # 800032c6 <iget>
    80003f4c:	892a                	mv	s2,a0
    80003f4e:	b7d5                	j	80003f32 <namex+0x46>
    80003f50:	4a29                	li	s4,10
        readi(ip, 0, (uint64)target_path, 0, MAXPATH);
    80003f52:	08000713          	li	a4,128
    80003f56:	86d6                	mv	a3,s5
    80003f58:	f1040613          	addi	a2,s0,-240
    80003f5c:	85d6                	mv	a1,s5
    80003f5e:	854a                	mv	a0,s2
    80003f60:	00000097          	auipc	ra,0x0
    80003f64:	bca080e7          	jalr	-1078(ra) # 80003b2a <readi>
        iunlockput(ip);
    80003f68:	854a                	mv	a0,s2
    80003f6a:	00000097          	auipc	ra,0x0
    80003f6e:	b6e080e7          	jalr	-1170(ra) # 80003ad8 <iunlockput>
        if((ip = namei(target_path)) == 0){
    80003f72:	f1040513          	addi	a0,s0,-240
    80003f76:	00000097          	auipc	ra,0x0
    80003f7a:	f58080e7          	jalr	-168(ra) # 80003ece <namei>
    80003f7e:	892a                	mv	s2,a0
    80003f80:	c10d                	beqz	a0,80003fa2 <namex+0xb6>
        ilock(ip);
    80003f82:	00000097          	auipc	ra,0x0
    80003f86:	83c080e7          	jalr	-1988(ra) # 800037be <ilock>
      while(ip->type == T_SYMLINK){
    80003f8a:	04491783          	lh	a5,68(s2)
    80003f8e:	09879f63          	bne	a5,s8,8000402c <namex+0x140>
        if(depth == 10){
    80003f92:	3a7d                	addiw	s4,s4,-1
    80003f94:	fa0a1fe3          	bnez	s4,80003f52 <namex+0x66>
          iunlockput(ip);
    80003f98:	854a                	mv	a0,s2
    80003f9a:	00000097          	auipc	ra,0x0
    80003f9e:	b3e080e7          	jalr	-1218(ra) # 80003ad8 <iunlockput>
          return 0;
    80003fa2:	4901                	li	s2,0
}
    80003fa4:	854a                	mv	a0,s2
    80003fa6:	70ae                	ld	ra,232(sp)
    80003fa8:	740e                	ld	s0,224(sp)
    80003faa:	64ee                	ld	s1,216(sp)
    80003fac:	694e                	ld	s2,208(sp)
    80003fae:	69ae                	ld	s3,200(sp)
    80003fb0:	6a0e                	ld	s4,192(sp)
    80003fb2:	7aea                	ld	s5,184(sp)
    80003fb4:	7b4a                	ld	s6,176(sp)
    80003fb6:	7baa                	ld	s7,168(sp)
    80003fb8:	7c0a                	ld	s8,160(sp)
    80003fba:	6cea                	ld	s9,152(sp)
    80003fbc:	6d4a                	ld	s10,144(sp)
    80003fbe:	6daa                	ld	s11,136(sp)
    80003fc0:	616d                	addi	sp,sp,240
    80003fc2:	8082                	ret
      iunlockput(ip);
    80003fc4:	854a                	mv	a0,s2
    80003fc6:	00000097          	auipc	ra,0x0
    80003fca:	b12080e7          	jalr	-1262(ra) # 80003ad8 <iunlockput>
      return 0;
    80003fce:	4901                	li	s2,0
    80003fd0:	bfd1                	j	80003fa4 <namex+0xb8>
      iunlock(ip);
    80003fd2:	854a                	mv	a0,s2
    80003fd4:	00000097          	auipc	ra,0x0
    80003fd8:	8ae080e7          	jalr	-1874(ra) # 80003882 <iunlock>
      return ip;
    80003fdc:	b7e1                	j	80003fa4 <namex+0xb8>
      iunlockput(ip);
    80003fde:	854a                	mv	a0,s2
    80003fe0:	00000097          	auipc	ra,0x0
    80003fe4:	af8080e7          	jalr	-1288(ra) # 80003ad8 <iunlockput>
      return 0;
    80003fe8:	8952                	mv	s2,s4
    80003fea:	bf6d                	j	80003fa4 <namex+0xb8>
  len = path - s;
    80003fec:	409a0633          	sub	a2,s4,s1
    80003ff0:	00060b1b          	sext.w	s6,a2
  if(len >= DIRSIZ)
    80003ff4:	096ddc63          	ble	s6,s11,8000408c <namex+0x1a0>
    memmove(name, s, DIRSIZ);
    80003ff8:	4639                	li	a2,14
    80003ffa:	85a6                	mv	a1,s1
    80003ffc:	855e                	mv	a0,s7
    80003ffe:	ffffd097          	auipc	ra,0xffffd
    80004002:	d8a080e7          	jalr	-630(ra) # 80000d88 <memmove>
    80004006:	84d2                	mv	s1,s4
  while(*path == '/')
    80004008:	0004c783          	lbu	a5,0(s1)
    8000400c:	01379763          	bne	a5,s3,8000401a <namex+0x12e>
    path++;
    80004010:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004012:	0004c783          	lbu	a5,0(s1)
    80004016:	ff378de3          	beq	a5,s3,80004010 <namex+0x124>
    ilock(ip);
    8000401a:	854a                	mv	a0,s2
    8000401c:	fffff097          	auipc	ra,0xfffff
    80004020:	7a2080e7          	jalr	1954(ra) # 800037be <ilock>
    if(ip->type == T_SYMLINK){
    80004024:	04491783          	lh	a5,68(s2)
    80004028:	f38784e3          	beq	a5,s8,80003f50 <namex+0x64>
    if(ip->type != T_DIR){
    8000402c:	04491783          	lh	a5,68(s2)
    80004030:	f9a79ae3          	bne	a5,s10,80003fc4 <namex+0xd8>
    if(nameiparent && *path == '\0'){
    80004034:	000c8563          	beqz	s9,8000403e <namex+0x152>
    80004038:	0004c783          	lbu	a5,0(s1)
    8000403c:	dbd9                	beqz	a5,80003fd2 <namex+0xe6>
    if((next = dirlookup(ip, name, 0)) == 0){ //ip dir指到下一個
    8000403e:	8656                	mv	a2,s5
    80004040:	85de                	mv	a1,s7
    80004042:	854a                	mv	a0,s2
    80004044:	00000097          	auipc	ra,0x0
    80004048:	d18080e7          	jalr	-744(ra) # 80003d5c <dirlookup>
    8000404c:	8a2a                	mv	s4,a0
    8000404e:	d941                	beqz	a0,80003fde <namex+0xf2>
    iunlockput(ip);
    80004050:	854a                	mv	a0,s2
    80004052:	00000097          	auipc	ra,0x0
    80004056:	a86080e7          	jalr	-1402(ra) # 80003ad8 <iunlockput>
    ip = next;
    8000405a:	8952                	mv	s2,s4
  while(*path == '/')
    8000405c:	0004c783          	lbu	a5,0(s1)
    80004060:	05379f63          	bne	a5,s3,800040be <namex+0x1d2>
    path++;
    80004064:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004066:	0004c783          	lbu	a5,0(s1)
    8000406a:	ff378de3          	beq	a5,s3,80004064 <namex+0x178>
  if(*path == 0)
    8000406e:	cf9d                	beqz	a5,800040ac <namex+0x1c0>
  while(*path != '/' && *path != 0)
    80004070:	01378b63          	beq	a5,s3,80004086 <namex+0x19a>
    80004074:	cb85                	beqz	a5,800040a4 <namex+0x1b8>
    80004076:	8a26                	mv	s4,s1
    path++;
    80004078:	0a05                	addi	s4,s4,1
  while(*path != '/' && *path != 0)
    8000407a:	000a4783          	lbu	a5,0(s4)
    8000407e:	f73787e3          	beq	a5,s3,80003fec <namex+0x100>
    80004082:	fbfd                	bnez	a5,80004078 <namex+0x18c>
    80004084:	b7a5                	j	80003fec <namex+0x100>
    path++;
    80004086:	8a26                	mv	s4,s1
  len = path - s;
    80004088:	8b56                	mv	s6,s5
    8000408a:	8656                	mv	a2,s5
    memmove(name, s, len);
    8000408c:	2601                	sext.w	a2,a2
    8000408e:	85a6                	mv	a1,s1
    80004090:	855e                	mv	a0,s7
    80004092:	ffffd097          	auipc	ra,0xffffd
    80004096:	cf6080e7          	jalr	-778(ra) # 80000d88 <memmove>
    name[len] = 0;
    8000409a:	9b5e                	add	s6,s6,s7
    8000409c:	000b0023          	sb	zero,0(s6)
    800040a0:	84d2                	mv	s1,s4
    800040a2:	b79d                	j	80004008 <namex+0x11c>
  while(*path != '/' && *path != 0)
    800040a4:	8a26                	mv	s4,s1
  len = path - s;
    800040a6:	8b56                	mv	s6,s5
    800040a8:	8656                	mv	a2,s5
    800040aa:	b7cd                	j	8000408c <namex+0x1a0>
  if(nameiparent){
    800040ac:	ee0c8ce3          	beqz	s9,80003fa4 <namex+0xb8>
    iput(ip);
    800040b0:	854a                	mv	a0,s2
    800040b2:	00000097          	auipc	ra,0x0
    800040b6:	97e080e7          	jalr	-1666(ra) # 80003a30 <iput>
    return 0;
    800040ba:	4901                	li	s2,0
    800040bc:	b5e5                	j	80003fa4 <namex+0xb8>
  if(*path == 0)
    800040be:	d7fd                	beqz	a5,800040ac <namex+0x1c0>
  while(*path != '/' && *path != 0)
    800040c0:	0004c783          	lbu	a5,0(s1)
    800040c4:	bf45                	j	80004074 <namex+0x188>

00000000800040c6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800040c6:	1141                	addi	sp,sp,-16
    800040c8:	e406                	sd	ra,8(sp)
    800040ca:	e022                	sd	s0,0(sp)
    800040cc:	0800                	addi	s0,sp,16
  return namex(path, 1, name);
    800040ce:	862e                	mv	a2,a1
    800040d0:	4585                	li	a1,1
    800040d2:	00000097          	auipc	ra,0x0
    800040d6:	e1a080e7          	jalr	-486(ra) # 80003eec <namex>
}
    800040da:	60a2                	ld	ra,8(sp)
    800040dc:	6402                	ld	s0,0(sp)
    800040de:	0141                	addi	sp,sp,16
    800040e0:	8082                	ret

00000000800040e2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800040e2:	1101                	addi	sp,sp,-32
    800040e4:	ec06                	sd	ra,24(sp)
    800040e6:	e822                	sd	s0,16(sp)
    800040e8:	e426                	sd	s1,8(sp)
    800040ea:	e04a                	sd	s2,0(sp)
    800040ec:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800040ee:	0001d917          	auipc	s2,0x1d
    800040f2:	18290913          	addi	s2,s2,386 # 80021270 <log>
    800040f6:	01892583          	lw	a1,24(s2)
    800040fa:	02892503          	lw	a0,40(s2)
    800040fe:	fffff097          	auipc	ra,0xfffff
    80004102:	d90080e7          	jalr	-624(ra) # 80002e8e <bread>
    80004106:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004108:	02c92683          	lw	a3,44(s2)
    8000410c:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000410e:	02d05763          	blez	a3,8000413c <write_head+0x5a>
    80004112:	0001d797          	auipc	a5,0x1d
    80004116:	18e78793          	addi	a5,a5,398 # 800212a0 <log+0x30>
    8000411a:	05c50713          	addi	a4,a0,92
    8000411e:	36fd                	addiw	a3,a3,-1
    80004120:	1682                	slli	a3,a3,0x20
    80004122:	9281                	srli	a3,a3,0x20
    80004124:	068a                	slli	a3,a3,0x2
    80004126:	0001d617          	auipc	a2,0x1d
    8000412a:	17e60613          	addi	a2,a2,382 # 800212a4 <log+0x34>
    8000412e:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80004130:	4390                	lw	a2,0(a5)
    80004132:	c310                	sw	a2,0(a4)
    80004134:	0791                	addi	a5,a5,4
    80004136:	0711                	addi	a4,a4,4
  for (i = 0; i < log.lh.n; i++) {
    80004138:	fed79ce3          	bne	a5,a3,80004130 <write_head+0x4e>
  }
  bwrite(buf);
    8000413c:	8526                	mv	a0,s1
    8000413e:	fffff097          	auipc	ra,0xfffff
    80004142:	e54080e7          	jalr	-428(ra) # 80002f92 <bwrite>
  brelse(buf);
    80004146:	8526                	mv	a0,s1
    80004148:	fffff097          	auipc	ra,0xfffff
    8000414c:	e88080e7          	jalr	-376(ra) # 80002fd0 <brelse>
}
    80004150:	60e2                	ld	ra,24(sp)
    80004152:	6442                	ld	s0,16(sp)
    80004154:	64a2                	ld	s1,8(sp)
    80004156:	6902                	ld	s2,0(sp)
    80004158:	6105                	addi	sp,sp,32
    8000415a:	8082                	ret

000000008000415c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000415c:	0001d797          	auipc	a5,0x1d
    80004160:	11478793          	addi	a5,a5,276 # 80021270 <log>
    80004164:	57dc                	lw	a5,44(a5)
    80004166:	0af05d63          	blez	a5,80004220 <install_trans+0xc4>
{
    8000416a:	7139                	addi	sp,sp,-64
    8000416c:	fc06                	sd	ra,56(sp)
    8000416e:	f822                	sd	s0,48(sp)
    80004170:	f426                	sd	s1,40(sp)
    80004172:	f04a                	sd	s2,32(sp)
    80004174:	ec4e                	sd	s3,24(sp)
    80004176:	e852                	sd	s4,16(sp)
    80004178:	e456                	sd	s5,8(sp)
    8000417a:	e05a                	sd	s6,0(sp)
    8000417c:	0080                	addi	s0,sp,64
    8000417e:	8b2a                	mv	s6,a0
    80004180:	0001da17          	auipc	s4,0x1d
    80004184:	120a0a13          	addi	s4,s4,288 # 800212a0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004188:	4981                	li	s3,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000418a:	0001d917          	auipc	s2,0x1d
    8000418e:	0e690913          	addi	s2,s2,230 # 80021270 <log>
    80004192:	a035                	j	800041be <install_trans+0x62>
      bunpin(dbuf);
    80004194:	8526                	mv	a0,s1
    80004196:	fffff097          	auipc	ra,0xfffff
    8000419a:	f14080e7          	jalr	-236(ra) # 800030aa <bunpin>
    brelse(lbuf);
    8000419e:	8556                	mv	a0,s5
    800041a0:	fffff097          	auipc	ra,0xfffff
    800041a4:	e30080e7          	jalr	-464(ra) # 80002fd0 <brelse>
    brelse(dbuf);
    800041a8:	8526                	mv	a0,s1
    800041aa:	fffff097          	auipc	ra,0xfffff
    800041ae:	e26080e7          	jalr	-474(ra) # 80002fd0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800041b2:	2985                	addiw	s3,s3,1
    800041b4:	0a11                	addi	s4,s4,4
    800041b6:	02c92783          	lw	a5,44(s2)
    800041ba:	04f9d963          	ble	a5,s3,8000420c <install_trans+0xb0>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800041be:	01892583          	lw	a1,24(s2)
    800041c2:	013585bb          	addw	a1,a1,s3
    800041c6:	2585                	addiw	a1,a1,1
    800041c8:	02892503          	lw	a0,40(s2)
    800041cc:	fffff097          	auipc	ra,0xfffff
    800041d0:	cc2080e7          	jalr	-830(ra) # 80002e8e <bread>
    800041d4:	8aaa                	mv	s5,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800041d6:	000a2583          	lw	a1,0(s4)
    800041da:	02892503          	lw	a0,40(s2)
    800041de:	fffff097          	auipc	ra,0xfffff
    800041e2:	cb0080e7          	jalr	-848(ra) # 80002e8e <bread>
    800041e6:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800041e8:	40000613          	li	a2,1024
    800041ec:	058a8593          	addi	a1,s5,88
    800041f0:	05850513          	addi	a0,a0,88
    800041f4:	ffffd097          	auipc	ra,0xffffd
    800041f8:	b94080e7          	jalr	-1132(ra) # 80000d88 <memmove>
    bwrite(dbuf);  // write dst to disk
    800041fc:	8526                	mv	a0,s1
    800041fe:	fffff097          	auipc	ra,0xfffff
    80004202:	d94080e7          	jalr	-620(ra) # 80002f92 <bwrite>
    if(recovering == 0)
    80004206:	f80b1ce3          	bnez	s6,8000419e <install_trans+0x42>
    8000420a:	b769                	j	80004194 <install_trans+0x38>
}
    8000420c:	70e2                	ld	ra,56(sp)
    8000420e:	7442                	ld	s0,48(sp)
    80004210:	74a2                	ld	s1,40(sp)
    80004212:	7902                	ld	s2,32(sp)
    80004214:	69e2                	ld	s3,24(sp)
    80004216:	6a42                	ld	s4,16(sp)
    80004218:	6aa2                	ld	s5,8(sp)
    8000421a:	6b02                	ld	s6,0(sp)
    8000421c:	6121                	addi	sp,sp,64
    8000421e:	8082                	ret
    80004220:	8082                	ret

0000000080004222 <initlog>:
{
    80004222:	7179                	addi	sp,sp,-48
    80004224:	f406                	sd	ra,40(sp)
    80004226:	f022                	sd	s0,32(sp)
    80004228:	ec26                	sd	s1,24(sp)
    8000422a:	e84a                	sd	s2,16(sp)
    8000422c:	e44e                	sd	s3,8(sp)
    8000422e:	1800                	addi	s0,sp,48
    80004230:	892a                	mv	s2,a0
    80004232:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004234:	0001d497          	auipc	s1,0x1d
    80004238:	03c48493          	addi	s1,s1,60 # 80021270 <log>
    8000423c:	00004597          	auipc	a1,0x4
    80004240:	3dc58593          	addi	a1,a1,988 # 80008618 <syscalls+0x210>
    80004244:	8526                	mv	a0,s1
    80004246:	ffffd097          	auipc	ra,0xffffd
    8000424a:	94a080e7          	jalr	-1718(ra) # 80000b90 <initlock>
  log.start = sb->logstart;
    8000424e:	0149a583          	lw	a1,20(s3)
    80004252:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004254:	0109a783          	lw	a5,16(s3)
    80004258:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000425a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000425e:	854a                	mv	a0,s2
    80004260:	fffff097          	auipc	ra,0xfffff
    80004264:	c2e080e7          	jalr	-978(ra) # 80002e8e <bread>
  log.lh.n = lh->n;
    80004268:	4d3c                	lw	a5,88(a0)
    8000426a:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000426c:	02f05563          	blez	a5,80004296 <initlog+0x74>
    80004270:	05c50713          	addi	a4,a0,92
    80004274:	0001d697          	auipc	a3,0x1d
    80004278:	02c68693          	addi	a3,a3,44 # 800212a0 <log+0x30>
    8000427c:	37fd                	addiw	a5,a5,-1
    8000427e:	1782                	slli	a5,a5,0x20
    80004280:	9381                	srli	a5,a5,0x20
    80004282:	078a                	slli	a5,a5,0x2
    80004284:	06050613          	addi	a2,a0,96
    80004288:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    8000428a:	4310                	lw	a2,0(a4)
    8000428c:	c290                	sw	a2,0(a3)
    8000428e:	0711                	addi	a4,a4,4
    80004290:	0691                	addi	a3,a3,4
  for (i = 0; i < log.lh.n; i++) {
    80004292:	fef71ce3          	bne	a4,a5,8000428a <initlog+0x68>
  brelse(buf);
    80004296:	fffff097          	auipc	ra,0xfffff
    8000429a:	d3a080e7          	jalr	-710(ra) # 80002fd0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000429e:	4505                	li	a0,1
    800042a0:	00000097          	auipc	ra,0x0
    800042a4:	ebc080e7          	jalr	-324(ra) # 8000415c <install_trans>
  log.lh.n = 0;
    800042a8:	0001d797          	auipc	a5,0x1d
    800042ac:	fe07aa23          	sw	zero,-12(a5) # 8002129c <log+0x2c>
  write_head(); // clear the log
    800042b0:	00000097          	auipc	ra,0x0
    800042b4:	e32080e7          	jalr	-462(ra) # 800040e2 <write_head>
}
    800042b8:	70a2                	ld	ra,40(sp)
    800042ba:	7402                	ld	s0,32(sp)
    800042bc:	64e2                	ld	s1,24(sp)
    800042be:	6942                	ld	s2,16(sp)
    800042c0:	69a2                	ld	s3,8(sp)
    800042c2:	6145                	addi	sp,sp,48
    800042c4:	8082                	ret

00000000800042c6 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800042c6:	1101                	addi	sp,sp,-32
    800042c8:	ec06                	sd	ra,24(sp)
    800042ca:	e822                	sd	s0,16(sp)
    800042cc:	e426                	sd	s1,8(sp)
    800042ce:	e04a                	sd	s2,0(sp)
    800042d0:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800042d2:	0001d517          	auipc	a0,0x1d
    800042d6:	f9e50513          	addi	a0,a0,-98 # 80021270 <log>
    800042da:	ffffd097          	auipc	ra,0xffffd
    800042de:	946080e7          	jalr	-1722(ra) # 80000c20 <acquire>
  while(1){
    if(log.committing){
    800042e2:	0001d497          	auipc	s1,0x1d
    800042e6:	f8e48493          	addi	s1,s1,-114 # 80021270 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800042ea:	4979                	li	s2,30
    800042ec:	a039                	j	800042fa <begin_op+0x34>
      sleep(&log, &log.lock);
    800042ee:	85a6                	mv	a1,s1
    800042f0:	8526                	mv	a0,s1
    800042f2:	ffffe097          	auipc	ra,0xffffe
    800042f6:	e2a080e7          	jalr	-470(ra) # 8000211c <sleep>
    if(log.committing){
    800042fa:	50dc                	lw	a5,36(s1)
    800042fc:	fbed                	bnez	a5,800042ee <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800042fe:	509c                	lw	a5,32(s1)
    80004300:	0017871b          	addiw	a4,a5,1
    80004304:	0007069b          	sext.w	a3,a4
    80004308:	0027179b          	slliw	a5,a4,0x2
    8000430c:	9fb9                	addw	a5,a5,a4
    8000430e:	0017979b          	slliw	a5,a5,0x1
    80004312:	54d8                	lw	a4,44(s1)
    80004314:	9fb9                	addw	a5,a5,a4
    80004316:	00f95963          	ble	a5,s2,80004328 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000431a:	85a6                	mv	a1,s1
    8000431c:	8526                	mv	a0,s1
    8000431e:	ffffe097          	auipc	ra,0xffffe
    80004322:	dfe080e7          	jalr	-514(ra) # 8000211c <sleep>
    80004326:	bfd1                	j	800042fa <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004328:	0001d517          	auipc	a0,0x1d
    8000432c:	f4850513          	addi	a0,a0,-184 # 80021270 <log>
    80004330:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80004332:	ffffd097          	auipc	ra,0xffffd
    80004336:	9a2080e7          	jalr	-1630(ra) # 80000cd4 <release>
      break;
    }
  }
}
    8000433a:	60e2                	ld	ra,24(sp)
    8000433c:	6442                	ld	s0,16(sp)
    8000433e:	64a2                	ld	s1,8(sp)
    80004340:	6902                	ld	s2,0(sp)
    80004342:	6105                	addi	sp,sp,32
    80004344:	8082                	ret

0000000080004346 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004346:	7139                	addi	sp,sp,-64
    80004348:	fc06                	sd	ra,56(sp)
    8000434a:	f822                	sd	s0,48(sp)
    8000434c:	f426                	sd	s1,40(sp)
    8000434e:	f04a                	sd	s2,32(sp)
    80004350:	ec4e                	sd	s3,24(sp)
    80004352:	e852                	sd	s4,16(sp)
    80004354:	e456                	sd	s5,8(sp)
    80004356:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004358:	0001d917          	auipc	s2,0x1d
    8000435c:	f1890913          	addi	s2,s2,-232 # 80021270 <log>
    80004360:	854a                	mv	a0,s2
    80004362:	ffffd097          	auipc	ra,0xffffd
    80004366:	8be080e7          	jalr	-1858(ra) # 80000c20 <acquire>
  log.outstanding -= 1;
    8000436a:	02092783          	lw	a5,32(s2)
    8000436e:	37fd                	addiw	a5,a5,-1
    80004370:	0007849b          	sext.w	s1,a5
    80004374:	02f92023          	sw	a5,32(s2)
  if(log.committing)
    80004378:	02492783          	lw	a5,36(s2)
    8000437c:	eba1                	bnez	a5,800043cc <end_op+0x86>
    panic("log.committing");
  if(log.outstanding == 0){
    8000437e:	ecb9                	bnez	s1,800043dc <end_op+0x96>
    do_commit = 1;
    log.committing = 1;
    80004380:	0001d917          	auipc	s2,0x1d
    80004384:	ef090913          	addi	s2,s2,-272 # 80021270 <log>
    80004388:	4785                	li	a5,1
    8000438a:	02f92223          	sw	a5,36(s2)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000438e:	854a                	mv	a0,s2
    80004390:	ffffd097          	auipc	ra,0xffffd
    80004394:	944080e7          	jalr	-1724(ra) # 80000cd4 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004398:	02c92783          	lw	a5,44(s2)
    8000439c:	06f04763          	bgtz	a5,8000440a <end_op+0xc4>
    acquire(&log.lock);
    800043a0:	0001d497          	auipc	s1,0x1d
    800043a4:	ed048493          	addi	s1,s1,-304 # 80021270 <log>
    800043a8:	8526                	mv	a0,s1
    800043aa:	ffffd097          	auipc	ra,0xffffd
    800043ae:	876080e7          	jalr	-1930(ra) # 80000c20 <acquire>
    log.committing = 0;
    800043b2:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800043b6:	8526                	mv	a0,s1
    800043b8:	ffffe097          	auipc	ra,0xffffe
    800043bc:	ef0080e7          	jalr	-272(ra) # 800022a8 <wakeup>
    release(&log.lock);
    800043c0:	8526                	mv	a0,s1
    800043c2:	ffffd097          	auipc	ra,0xffffd
    800043c6:	912080e7          	jalr	-1774(ra) # 80000cd4 <release>
}
    800043ca:	a03d                	j	800043f8 <end_op+0xb2>
    panic("log.committing");
    800043cc:	00004517          	auipc	a0,0x4
    800043d0:	25450513          	addi	a0,a0,596 # 80008620 <syscalls+0x218>
    800043d4:	ffffc097          	auipc	ra,0xffffc
    800043d8:	184080e7          	jalr	388(ra) # 80000558 <panic>
    wakeup(&log);
    800043dc:	0001d497          	auipc	s1,0x1d
    800043e0:	e9448493          	addi	s1,s1,-364 # 80021270 <log>
    800043e4:	8526                	mv	a0,s1
    800043e6:	ffffe097          	auipc	ra,0xffffe
    800043ea:	ec2080e7          	jalr	-318(ra) # 800022a8 <wakeup>
  release(&log.lock);
    800043ee:	8526                	mv	a0,s1
    800043f0:	ffffd097          	auipc	ra,0xffffd
    800043f4:	8e4080e7          	jalr	-1820(ra) # 80000cd4 <release>
}
    800043f8:	70e2                	ld	ra,56(sp)
    800043fa:	7442                	ld	s0,48(sp)
    800043fc:	74a2                	ld	s1,40(sp)
    800043fe:	7902                	ld	s2,32(sp)
    80004400:	69e2                	ld	s3,24(sp)
    80004402:	6a42                	ld	s4,16(sp)
    80004404:	6aa2                	ld	s5,8(sp)
    80004406:	6121                	addi	sp,sp,64
    80004408:	8082                	ret
    8000440a:	0001da17          	auipc	s4,0x1d
    8000440e:	e96a0a13          	addi	s4,s4,-362 # 800212a0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004412:	0001d917          	auipc	s2,0x1d
    80004416:	e5e90913          	addi	s2,s2,-418 # 80021270 <log>
    8000441a:	01892583          	lw	a1,24(s2)
    8000441e:	9da5                	addw	a1,a1,s1
    80004420:	2585                	addiw	a1,a1,1
    80004422:	02892503          	lw	a0,40(s2)
    80004426:	fffff097          	auipc	ra,0xfffff
    8000442a:	a68080e7          	jalr	-1432(ra) # 80002e8e <bread>
    8000442e:	89aa                	mv	s3,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004430:	000a2583          	lw	a1,0(s4)
    80004434:	02892503          	lw	a0,40(s2)
    80004438:	fffff097          	auipc	ra,0xfffff
    8000443c:	a56080e7          	jalr	-1450(ra) # 80002e8e <bread>
    80004440:	8aaa                	mv	s5,a0
    memmove(to->data, from->data, BSIZE);
    80004442:	40000613          	li	a2,1024
    80004446:	05850593          	addi	a1,a0,88
    8000444a:	05898513          	addi	a0,s3,88
    8000444e:	ffffd097          	auipc	ra,0xffffd
    80004452:	93a080e7          	jalr	-1734(ra) # 80000d88 <memmove>
    bwrite(to);  // write the log
    80004456:	854e                	mv	a0,s3
    80004458:	fffff097          	auipc	ra,0xfffff
    8000445c:	b3a080e7          	jalr	-1222(ra) # 80002f92 <bwrite>
    brelse(from);
    80004460:	8556                	mv	a0,s5
    80004462:	fffff097          	auipc	ra,0xfffff
    80004466:	b6e080e7          	jalr	-1170(ra) # 80002fd0 <brelse>
    brelse(to);
    8000446a:	854e                	mv	a0,s3
    8000446c:	fffff097          	auipc	ra,0xfffff
    80004470:	b64080e7          	jalr	-1180(ra) # 80002fd0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004474:	2485                	addiw	s1,s1,1
    80004476:	0a11                	addi	s4,s4,4
    80004478:	02c92783          	lw	a5,44(s2)
    8000447c:	f8f4cfe3          	blt	s1,a5,8000441a <end_op+0xd4>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004480:	00000097          	auipc	ra,0x0
    80004484:	c62080e7          	jalr	-926(ra) # 800040e2 <write_head>
    install_trans(0); // Now install writes to home locations
    80004488:	4501                	li	a0,0
    8000448a:	00000097          	auipc	ra,0x0
    8000448e:	cd2080e7          	jalr	-814(ra) # 8000415c <install_trans>
    log.lh.n = 0;
    80004492:	0001d797          	auipc	a5,0x1d
    80004496:	e007a523          	sw	zero,-502(a5) # 8002129c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000449a:	00000097          	auipc	ra,0x0
    8000449e:	c48080e7          	jalr	-952(ra) # 800040e2 <write_head>
    800044a2:	bdfd                	j	800043a0 <end_op+0x5a>

00000000800044a4 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800044a4:	1101                	addi	sp,sp,-32
    800044a6:	ec06                	sd	ra,24(sp)
    800044a8:	e822                	sd	s0,16(sp)
    800044aa:	e426                	sd	s1,8(sp)
    800044ac:	e04a                	sd	s2,0(sp)
    800044ae:	1000                	addi	s0,sp,32
    800044b0:	892a                	mv	s2,a0
  int i;

  acquire(&log.lock);
    800044b2:	0001d497          	auipc	s1,0x1d
    800044b6:	dbe48493          	addi	s1,s1,-578 # 80021270 <log>
    800044ba:	8526                	mv	a0,s1
    800044bc:	ffffc097          	auipc	ra,0xffffc
    800044c0:	764080e7          	jalr	1892(ra) # 80000c20 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800044c4:	54d0                	lw	a2,44(s1)
    800044c6:	47f5                	li	a5,29
    800044c8:	06c7ca63          	blt	a5,a2,8000453c <log_write+0x98>
    800044cc:	4cdc                	lw	a5,28(s1)
    800044ce:	37fd                	addiw	a5,a5,-1
    800044d0:	06f65663          	ble	a5,a2,8000453c <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800044d4:	0001d797          	auipc	a5,0x1d
    800044d8:	d9c78793          	addi	a5,a5,-612 # 80021270 <log>
    800044dc:	539c                	lw	a5,32(a5)
    800044de:	06f05763          	blez	a5,8000454c <log_write+0xa8>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800044e2:	06c05d63          	blez	a2,8000455c <log_write+0xb8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800044e6:	00c92583          	lw	a1,12(s2)
    800044ea:	0001d797          	auipc	a5,0x1d
    800044ee:	d8678793          	addi	a5,a5,-634 # 80021270 <log>
    800044f2:	5b9c                	lw	a5,48(a5)
    800044f4:	06b78c63          	beq	a5,a1,8000456c <log_write+0xc8>
    800044f8:	0001d717          	auipc	a4,0x1d
    800044fc:	dac70713          	addi	a4,a4,-596 # 800212a4 <log+0x34>
  for (i = 0; i < log.lh.n; i++) {
    80004500:	4781                	li	a5,0
    80004502:	2785                	addiw	a5,a5,1
    80004504:	06f60663          	beq	a2,a5,80004570 <log_write+0xcc>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004508:	4314                	lw	a3,0(a4)
    8000450a:	0711                	addi	a4,a4,4
    8000450c:	feb69be3          	bne	a3,a1,80004502 <log_write+0x5e>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004510:	07a1                	addi	a5,a5,8
    80004512:	078a                	slli	a5,a5,0x2
    80004514:	0001d717          	auipc	a4,0x1d
    80004518:	d5c70713          	addi	a4,a4,-676 # 80021270 <log>
    8000451c:	97ba                	add	a5,a5,a4
    8000451e:	cb8c                	sw	a1,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    log.lh.n++;
  }
  release(&log.lock);
    80004520:	0001d517          	auipc	a0,0x1d
    80004524:	d5050513          	addi	a0,a0,-688 # 80021270 <log>
    80004528:	ffffc097          	auipc	ra,0xffffc
    8000452c:	7ac080e7          	jalr	1964(ra) # 80000cd4 <release>
}
    80004530:	60e2                	ld	ra,24(sp)
    80004532:	6442                	ld	s0,16(sp)
    80004534:	64a2                	ld	s1,8(sp)
    80004536:	6902                	ld	s2,0(sp)
    80004538:	6105                	addi	sp,sp,32
    8000453a:	8082                	ret
    panic("too big a transaction");
    8000453c:	00004517          	auipc	a0,0x4
    80004540:	0f450513          	addi	a0,a0,244 # 80008630 <syscalls+0x228>
    80004544:	ffffc097          	auipc	ra,0xffffc
    80004548:	014080e7          	jalr	20(ra) # 80000558 <panic>
    panic("log_write outside of trans");
    8000454c:	00004517          	auipc	a0,0x4
    80004550:	0fc50513          	addi	a0,a0,252 # 80008648 <syscalls+0x240>
    80004554:	ffffc097          	auipc	ra,0xffffc
    80004558:	004080e7          	jalr	4(ra) # 80000558 <panic>
  log.lh.block[i] = b->blockno;
    8000455c:	00c92783          	lw	a5,12(s2)
    80004560:	0001d717          	auipc	a4,0x1d
    80004564:	d4f72023          	sw	a5,-704(a4) # 800212a0 <log+0x30>
  if (i == log.lh.n) {  // Add new block to log?
    80004568:	fe45                	bnez	a2,80004520 <log_write+0x7c>
    8000456a:	a829                	j	80004584 <log_write+0xe0>
  for (i = 0; i < log.lh.n; i++) {
    8000456c:	4781                	li	a5,0
    8000456e:	b74d                	j	80004510 <log_write+0x6c>
  log.lh.block[i] = b->blockno;
    80004570:	0621                	addi	a2,a2,8
    80004572:	060a                	slli	a2,a2,0x2
    80004574:	0001d797          	auipc	a5,0x1d
    80004578:	cfc78793          	addi	a5,a5,-772 # 80021270 <log>
    8000457c:	963e                	add	a2,a2,a5
    8000457e:	00c92783          	lw	a5,12(s2)
    80004582:	ca1c                	sw	a5,16(a2)
    bpin(b);
    80004584:	854a                	mv	a0,s2
    80004586:	fffff097          	auipc	ra,0xfffff
    8000458a:	ae8080e7          	jalr	-1304(ra) # 8000306e <bpin>
    log.lh.n++;
    8000458e:	0001d717          	auipc	a4,0x1d
    80004592:	ce270713          	addi	a4,a4,-798 # 80021270 <log>
    80004596:	575c                	lw	a5,44(a4)
    80004598:	2785                	addiw	a5,a5,1
    8000459a:	d75c                	sw	a5,44(a4)
    8000459c:	b751                	j	80004520 <log_write+0x7c>

000000008000459e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000459e:	1101                	addi	sp,sp,-32
    800045a0:	ec06                	sd	ra,24(sp)
    800045a2:	e822                	sd	s0,16(sp)
    800045a4:	e426                	sd	s1,8(sp)
    800045a6:	e04a                	sd	s2,0(sp)
    800045a8:	1000                	addi	s0,sp,32
    800045aa:	84aa                	mv	s1,a0
    800045ac:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800045ae:	00004597          	auipc	a1,0x4
    800045b2:	0ba58593          	addi	a1,a1,186 # 80008668 <syscalls+0x260>
    800045b6:	0521                	addi	a0,a0,8
    800045b8:	ffffc097          	auipc	ra,0xffffc
    800045bc:	5d8080e7          	jalr	1496(ra) # 80000b90 <initlock>
  lk->name = name;
    800045c0:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800045c4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800045c8:	0204a423          	sw	zero,40(s1)
}
    800045cc:	60e2                	ld	ra,24(sp)
    800045ce:	6442                	ld	s0,16(sp)
    800045d0:	64a2                	ld	s1,8(sp)
    800045d2:	6902                	ld	s2,0(sp)
    800045d4:	6105                	addi	sp,sp,32
    800045d6:	8082                	ret

00000000800045d8 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800045d8:	1101                	addi	sp,sp,-32
    800045da:	ec06                	sd	ra,24(sp)
    800045dc:	e822                	sd	s0,16(sp)
    800045de:	e426                	sd	s1,8(sp)
    800045e0:	e04a                	sd	s2,0(sp)
    800045e2:	1000                	addi	s0,sp,32
    800045e4:	84aa                	mv	s1,a0
  acquire(&lk->lk); // lock spinlock of sleeplock *lk
    800045e6:	00850913          	addi	s2,a0,8
    800045ea:	854a                	mv	a0,s2
    800045ec:	ffffc097          	auipc	ra,0xffffc
    800045f0:	634080e7          	jalr	1588(ra) # 80000c20 <acquire>
  while (lk->locked) {
    800045f4:	409c                	lw	a5,0(s1)
    800045f6:	cb89                	beqz	a5,80004608 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800045f8:	85ca                	mv	a1,s2
    800045fa:	8526                	mv	a0,s1
    800045fc:	ffffe097          	auipc	ra,0xffffe
    80004600:	b20080e7          	jalr	-1248(ra) # 8000211c <sleep>
  while (lk->locked) {
    80004604:	409c                	lw	a5,0(s1)
    80004606:	fbed                	bnez	a5,800045f8 <acquiresleep+0x20>
  }
  lk->locked = 1; // lock the sleeplock
    80004608:	4785                	li	a5,1
    8000460a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000460c:	ffffd097          	auipc	ra,0xffffd
    80004610:	44c080e7          	jalr	1100(ra) # 80001a58 <myproc>
    80004614:	591c                	lw	a5,48(a0)
    80004616:	d49c                	sw	a5,40(s1)
  release(&lk->lk); // relase spinlock
    80004618:	854a                	mv	a0,s2
    8000461a:	ffffc097          	auipc	ra,0xffffc
    8000461e:	6ba080e7          	jalr	1722(ra) # 80000cd4 <release>
}
    80004622:	60e2                	ld	ra,24(sp)
    80004624:	6442                	ld	s0,16(sp)
    80004626:	64a2                	ld	s1,8(sp)
    80004628:	6902                	ld	s2,0(sp)
    8000462a:	6105                	addi	sp,sp,32
    8000462c:	8082                	ret

000000008000462e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000462e:	1101                	addi	sp,sp,-32
    80004630:	ec06                	sd	ra,24(sp)
    80004632:	e822                	sd	s0,16(sp)
    80004634:	e426                	sd	s1,8(sp)
    80004636:	e04a                	sd	s2,0(sp)
    80004638:	1000                	addi	s0,sp,32
    8000463a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000463c:	00850913          	addi	s2,a0,8
    80004640:	854a                	mv	a0,s2
    80004642:	ffffc097          	auipc	ra,0xffffc
    80004646:	5de080e7          	jalr	1502(ra) # 80000c20 <acquire>
  lk->locked = 0;
    8000464a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000464e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004652:	8526                	mv	a0,s1
    80004654:	ffffe097          	auipc	ra,0xffffe
    80004658:	c54080e7          	jalr	-940(ra) # 800022a8 <wakeup>
  release(&lk->lk);
    8000465c:	854a                	mv	a0,s2
    8000465e:	ffffc097          	auipc	ra,0xffffc
    80004662:	676080e7          	jalr	1654(ra) # 80000cd4 <release>
}
    80004666:	60e2                	ld	ra,24(sp)
    80004668:	6442                	ld	s0,16(sp)
    8000466a:	64a2                	ld	s1,8(sp)
    8000466c:	6902                	ld	s2,0(sp)
    8000466e:	6105                	addi	sp,sp,32
    80004670:	8082                	ret

0000000080004672 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004672:	7179                	addi	sp,sp,-48
    80004674:	f406                	sd	ra,40(sp)
    80004676:	f022                	sd	s0,32(sp)
    80004678:	ec26                	sd	s1,24(sp)
    8000467a:	e84a                	sd	s2,16(sp)
    8000467c:	e44e                	sd	s3,8(sp)
    8000467e:	1800                	addi	s0,sp,48
    80004680:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    80004682:	00850913          	addi	s2,a0,8
    80004686:	854a                	mv	a0,s2
    80004688:	ffffc097          	auipc	ra,0xffffc
    8000468c:	598080e7          	jalr	1432(ra) # 80000c20 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004690:	409c                	lw	a5,0(s1)
    80004692:	ef99                	bnez	a5,800046b0 <holdingsleep+0x3e>
    80004694:	4481                	li	s1,0
  release(&lk->lk);
    80004696:	854a                	mv	a0,s2
    80004698:	ffffc097          	auipc	ra,0xffffc
    8000469c:	63c080e7          	jalr	1596(ra) # 80000cd4 <release>
  return r;
}
    800046a0:	8526                	mv	a0,s1
    800046a2:	70a2                	ld	ra,40(sp)
    800046a4:	7402                	ld	s0,32(sp)
    800046a6:	64e2                	ld	s1,24(sp)
    800046a8:	6942                	ld	s2,16(sp)
    800046aa:	69a2                	ld	s3,8(sp)
    800046ac:	6145                	addi	sp,sp,48
    800046ae:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800046b0:	0284a983          	lw	s3,40(s1)
    800046b4:	ffffd097          	auipc	ra,0xffffd
    800046b8:	3a4080e7          	jalr	932(ra) # 80001a58 <myproc>
    800046bc:	5904                	lw	s1,48(a0)
    800046be:	413484b3          	sub	s1,s1,s3
    800046c2:	0014b493          	seqz	s1,s1
    800046c6:	bfc1                	j	80004696 <holdingsleep+0x24>

00000000800046c8 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800046c8:	1141                	addi	sp,sp,-16
    800046ca:	e406                	sd	ra,8(sp)
    800046cc:	e022                	sd	s0,0(sp)
    800046ce:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800046d0:	00004597          	auipc	a1,0x4
    800046d4:	fa858593          	addi	a1,a1,-88 # 80008678 <syscalls+0x270>
    800046d8:	0001d517          	auipc	a0,0x1d
    800046dc:	ce050513          	addi	a0,a0,-800 # 800213b8 <ftable>
    800046e0:	ffffc097          	auipc	ra,0xffffc
    800046e4:	4b0080e7          	jalr	1200(ra) # 80000b90 <initlock>
}
    800046e8:	60a2                	ld	ra,8(sp)
    800046ea:	6402                	ld	s0,0(sp)
    800046ec:	0141                	addi	sp,sp,16
    800046ee:	8082                	ret

00000000800046f0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800046f0:	1101                	addi	sp,sp,-32
    800046f2:	ec06                	sd	ra,24(sp)
    800046f4:	e822                	sd	s0,16(sp)
    800046f6:	e426                	sd	s1,8(sp)
    800046f8:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800046fa:	0001d517          	auipc	a0,0x1d
    800046fe:	cbe50513          	addi	a0,a0,-834 # 800213b8 <ftable>
    80004702:	ffffc097          	auipc	ra,0xffffc
    80004706:	51e080e7          	jalr	1310(ra) # 80000c20 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
    8000470a:	0001d797          	auipc	a5,0x1d
    8000470e:	cae78793          	addi	a5,a5,-850 # 800213b8 <ftable>
    80004712:	4fdc                	lw	a5,28(a5)
    80004714:	cb8d                	beqz	a5,80004746 <filealloc+0x56>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004716:	0001d497          	auipc	s1,0x1d
    8000471a:	ce248493          	addi	s1,s1,-798 # 800213f8 <ftable+0x40>
    8000471e:	0001e717          	auipc	a4,0x1e
    80004722:	c5270713          	addi	a4,a4,-942 # 80022370 <ftable+0xfb8>
    if(f->ref == 0){
    80004726:	40dc                	lw	a5,4(s1)
    80004728:	c39d                	beqz	a5,8000474e <filealloc+0x5e>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000472a:	02848493          	addi	s1,s1,40
    8000472e:	fee49ce3          	bne	s1,a4,80004726 <filealloc+0x36>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004732:	0001d517          	auipc	a0,0x1d
    80004736:	c8650513          	addi	a0,a0,-890 # 800213b8 <ftable>
    8000473a:	ffffc097          	auipc	ra,0xffffc
    8000473e:	59a080e7          	jalr	1434(ra) # 80000cd4 <release>
  return 0;
    80004742:	4481                	li	s1,0
    80004744:	a839                	j	80004762 <filealloc+0x72>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004746:	0001d497          	auipc	s1,0x1d
    8000474a:	c8a48493          	addi	s1,s1,-886 # 800213d0 <ftable+0x18>
      f->ref = 1;
    8000474e:	4785                	li	a5,1
    80004750:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004752:	0001d517          	auipc	a0,0x1d
    80004756:	c6650513          	addi	a0,a0,-922 # 800213b8 <ftable>
    8000475a:	ffffc097          	auipc	ra,0xffffc
    8000475e:	57a080e7          	jalr	1402(ra) # 80000cd4 <release>
}
    80004762:	8526                	mv	a0,s1
    80004764:	60e2                	ld	ra,24(sp)
    80004766:	6442                	ld	s0,16(sp)
    80004768:	64a2                	ld	s1,8(sp)
    8000476a:	6105                	addi	sp,sp,32
    8000476c:	8082                	ret

000000008000476e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000476e:	1101                	addi	sp,sp,-32
    80004770:	ec06                	sd	ra,24(sp)
    80004772:	e822                	sd	s0,16(sp)
    80004774:	e426                	sd	s1,8(sp)
    80004776:	1000                	addi	s0,sp,32
    80004778:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000477a:	0001d517          	auipc	a0,0x1d
    8000477e:	c3e50513          	addi	a0,a0,-962 # 800213b8 <ftable>
    80004782:	ffffc097          	auipc	ra,0xffffc
    80004786:	49e080e7          	jalr	1182(ra) # 80000c20 <acquire>
  if(f->ref < 1)
    8000478a:	40dc                	lw	a5,4(s1)
    8000478c:	02f05263          	blez	a5,800047b0 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004790:	2785                	addiw	a5,a5,1
    80004792:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004794:	0001d517          	auipc	a0,0x1d
    80004798:	c2450513          	addi	a0,a0,-988 # 800213b8 <ftable>
    8000479c:	ffffc097          	auipc	ra,0xffffc
    800047a0:	538080e7          	jalr	1336(ra) # 80000cd4 <release>
  return f;
}
    800047a4:	8526                	mv	a0,s1
    800047a6:	60e2                	ld	ra,24(sp)
    800047a8:	6442                	ld	s0,16(sp)
    800047aa:	64a2                	ld	s1,8(sp)
    800047ac:	6105                	addi	sp,sp,32
    800047ae:	8082                	ret
    panic("filedup");
    800047b0:	00004517          	auipc	a0,0x4
    800047b4:	ed050513          	addi	a0,a0,-304 # 80008680 <syscalls+0x278>
    800047b8:	ffffc097          	auipc	ra,0xffffc
    800047bc:	da0080e7          	jalr	-608(ra) # 80000558 <panic>

00000000800047c0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800047c0:	7139                	addi	sp,sp,-64
    800047c2:	fc06                	sd	ra,56(sp)
    800047c4:	f822                	sd	s0,48(sp)
    800047c6:	f426                	sd	s1,40(sp)
    800047c8:	f04a                	sd	s2,32(sp)
    800047ca:	ec4e                	sd	s3,24(sp)
    800047cc:	e852                	sd	s4,16(sp)
    800047ce:	e456                	sd	s5,8(sp)
    800047d0:	0080                	addi	s0,sp,64
    800047d2:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800047d4:	0001d517          	auipc	a0,0x1d
    800047d8:	be450513          	addi	a0,a0,-1052 # 800213b8 <ftable>
    800047dc:	ffffc097          	auipc	ra,0xffffc
    800047e0:	444080e7          	jalr	1092(ra) # 80000c20 <acquire>
  if(f->ref < 1)
    800047e4:	40dc                	lw	a5,4(s1)
    800047e6:	06f05163          	blez	a5,80004848 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800047ea:	37fd                	addiw	a5,a5,-1
    800047ec:	0007871b          	sext.w	a4,a5
    800047f0:	c0dc                	sw	a5,4(s1)
    800047f2:	06e04363          	bgtz	a4,80004858 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800047f6:	0004a903          	lw	s2,0(s1)
    800047fa:	0094ca83          	lbu	s5,9(s1)
    800047fe:	0104ba03          	ld	s4,16(s1)
    80004802:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004806:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000480a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000480e:	0001d517          	auipc	a0,0x1d
    80004812:	baa50513          	addi	a0,a0,-1110 # 800213b8 <ftable>
    80004816:	ffffc097          	auipc	ra,0xffffc
    8000481a:	4be080e7          	jalr	1214(ra) # 80000cd4 <release>

  if(ff.type == FD_PIPE){
    8000481e:	4785                	li	a5,1
    80004820:	04f90d63          	beq	s2,a5,8000487a <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004824:	3979                	addiw	s2,s2,-2
    80004826:	4785                	li	a5,1
    80004828:	0527e063          	bltu	a5,s2,80004868 <fileclose+0xa8>
    begin_op();
    8000482c:	00000097          	auipc	ra,0x0
    80004830:	a9a080e7          	jalr	-1382(ra) # 800042c6 <begin_op>
    iput(ff.ip);
    80004834:	854e                	mv	a0,s3
    80004836:	fffff097          	auipc	ra,0xfffff
    8000483a:	1fa080e7          	jalr	506(ra) # 80003a30 <iput>
    end_op();
    8000483e:	00000097          	auipc	ra,0x0
    80004842:	b08080e7          	jalr	-1272(ra) # 80004346 <end_op>
    80004846:	a00d                	j	80004868 <fileclose+0xa8>
    panic("fileclose");
    80004848:	00004517          	auipc	a0,0x4
    8000484c:	e4050513          	addi	a0,a0,-448 # 80008688 <syscalls+0x280>
    80004850:	ffffc097          	auipc	ra,0xffffc
    80004854:	d08080e7          	jalr	-760(ra) # 80000558 <panic>
    release(&ftable.lock);
    80004858:	0001d517          	auipc	a0,0x1d
    8000485c:	b6050513          	addi	a0,a0,-1184 # 800213b8 <ftable>
    80004860:	ffffc097          	auipc	ra,0xffffc
    80004864:	474080e7          	jalr	1140(ra) # 80000cd4 <release>
  }
}
    80004868:	70e2                	ld	ra,56(sp)
    8000486a:	7442                	ld	s0,48(sp)
    8000486c:	74a2                	ld	s1,40(sp)
    8000486e:	7902                	ld	s2,32(sp)
    80004870:	69e2                	ld	s3,24(sp)
    80004872:	6a42                	ld	s4,16(sp)
    80004874:	6aa2                	ld	s5,8(sp)
    80004876:	6121                	addi	sp,sp,64
    80004878:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000487a:	85d6                	mv	a1,s5
    8000487c:	8552                	mv	a0,s4
    8000487e:	00000097          	auipc	ra,0x0
    80004882:	340080e7          	jalr	832(ra) # 80004bbe <pipeclose>
    80004886:	b7cd                	j	80004868 <fileclose+0xa8>

0000000080004888 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004888:	715d                	addi	sp,sp,-80
    8000488a:	e486                	sd	ra,72(sp)
    8000488c:	e0a2                	sd	s0,64(sp)
    8000488e:	fc26                	sd	s1,56(sp)
    80004890:	f84a                	sd	s2,48(sp)
    80004892:	f44e                	sd	s3,40(sp)
    80004894:	0880                	addi	s0,sp,80
    80004896:	84aa                	mv	s1,a0
    80004898:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000489a:	ffffd097          	auipc	ra,0xffffd
    8000489e:	1be080e7          	jalr	446(ra) # 80001a58 <myproc>
  struct stat st;

  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800048a2:	409c                	lw	a5,0(s1)
    800048a4:	37f9                	addiw	a5,a5,-2
    800048a6:	4705                	li	a4,1
    800048a8:	04f76763          	bltu	a4,a5,800048f6 <filestat+0x6e>
    800048ac:	892a                	mv	s2,a0
    ilock(f->ip);
    800048ae:	6c88                	ld	a0,24(s1)
    800048b0:	fffff097          	auipc	ra,0xfffff
    800048b4:	f0e080e7          	jalr	-242(ra) # 800037be <ilock>
    stati(f->ip, &st);
    800048b8:	fb840593          	addi	a1,s0,-72
    800048bc:	6c88                	ld	a0,24(s1)
    800048be:	fffff097          	auipc	ra,0xfffff
    800048c2:	242080e7          	jalr	578(ra) # 80003b00 <stati>
    iunlock(f->ip);
    800048c6:	6c88                	ld	a0,24(s1)
    800048c8:	fffff097          	auipc	ra,0xfffff
    800048cc:	fba080e7          	jalr	-70(ra) # 80003882 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800048d0:	46e1                	li	a3,24
    800048d2:	fb840613          	addi	a2,s0,-72
    800048d6:	85ce                	mv	a1,s3
    800048d8:	05093503          	ld	a0,80(s2)
    800048dc:	ffffd097          	auipc	ra,0xffffd
    800048e0:	e26080e7          	jalr	-474(ra) # 80001702 <copyout>
    800048e4:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800048e8:	60a6                	ld	ra,72(sp)
    800048ea:	6406                	ld	s0,64(sp)
    800048ec:	74e2                	ld	s1,56(sp)
    800048ee:	7942                	ld	s2,48(sp)
    800048f0:	79a2                	ld	s3,40(sp)
    800048f2:	6161                	addi	sp,sp,80
    800048f4:	8082                	ret
  return -1;
    800048f6:	557d                	li	a0,-1
    800048f8:	bfc5                	j	800048e8 <filestat+0x60>

00000000800048fa <fileread>:
// Read from file f.
// addr is a user virtual address.

int
fileread(struct file *f, uint64 addr, int n)
{
    800048fa:	7179                	addi	sp,sp,-48
    800048fc:	f406                	sd	ra,40(sp)
    800048fe:	f022                	sd	s0,32(sp)
    80004900:	ec26                	sd	s1,24(sp)
    80004902:	e84a                	sd	s2,16(sp)
    80004904:	e44e                	sd	s3,8(sp)
    80004906:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004908:	00854783          	lbu	a5,8(a0)
    8000490c:	c3d5                	beqz	a5,800049b0 <fileread+0xb6>
    8000490e:	89b2                	mv	s3,a2
    80004910:	892e                	mv	s2,a1
    80004912:	84aa                	mv	s1,a0
    return -1;

  if(f->type == FD_PIPE){
    80004914:	411c                	lw	a5,0(a0)
    80004916:	4705                	li	a4,1
    80004918:	04e78963          	beq	a5,a4,8000496a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000491c:	470d                	li	a4,3
    8000491e:	04e78d63          	beq	a5,a4,80004978 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004922:	4709                	li	a4,2
    80004924:	06e79e63          	bne	a5,a4,800049a0 <fileread+0xa6>
    ilock(f->ip);
    80004928:	6d08                	ld	a0,24(a0)
    8000492a:	fffff097          	auipc	ra,0xfffff
    8000492e:	e94080e7          	jalr	-364(ra) # 800037be <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004932:	874e                	mv	a4,s3
    80004934:	5094                	lw	a3,32(s1)
    80004936:	864a                	mv	a2,s2
    80004938:	4585                	li	a1,1
    8000493a:	6c88                	ld	a0,24(s1)
    8000493c:	fffff097          	auipc	ra,0xfffff
    80004940:	1ee080e7          	jalr	494(ra) # 80003b2a <readi>
    80004944:	892a                	mv	s2,a0
    80004946:	00a05563          	blez	a0,80004950 <fileread+0x56>
      f->off += r;
    8000494a:	509c                	lw	a5,32(s1)
    8000494c:	9fa9                	addw	a5,a5,a0
    8000494e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004950:	6c88                	ld	a0,24(s1)
    80004952:	fffff097          	auipc	ra,0xfffff
    80004956:	f30080e7          	jalr	-208(ra) # 80003882 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    8000495a:	854a                	mv	a0,s2
    8000495c:	70a2                	ld	ra,40(sp)
    8000495e:	7402                	ld	s0,32(sp)
    80004960:	64e2                	ld	s1,24(sp)
    80004962:	6942                	ld	s2,16(sp)
    80004964:	69a2                	ld	s3,8(sp)
    80004966:	6145                	addi	sp,sp,48
    80004968:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000496a:	6908                	ld	a0,16(a0)
    8000496c:	00000097          	auipc	ra,0x0
    80004970:	3c8080e7          	jalr	968(ra) # 80004d34 <piperead>
    80004974:	892a                	mv	s2,a0
    80004976:	b7d5                	j	8000495a <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004978:	02451783          	lh	a5,36(a0)
    8000497c:	03079693          	slli	a3,a5,0x30
    80004980:	92c1                	srli	a3,a3,0x30
    80004982:	4725                	li	a4,9
    80004984:	02d76863          	bltu	a4,a3,800049b4 <fileread+0xba>
    80004988:	0792                	slli	a5,a5,0x4
    8000498a:	0001d717          	auipc	a4,0x1d
    8000498e:	98e70713          	addi	a4,a4,-1650 # 80021318 <devsw>
    80004992:	97ba                	add	a5,a5,a4
    80004994:	639c                	ld	a5,0(a5)
    80004996:	c38d                	beqz	a5,800049b8 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004998:	4505                	li	a0,1
    8000499a:	9782                	jalr	a5
    8000499c:	892a                	mv	s2,a0
    8000499e:	bf75                	j	8000495a <fileread+0x60>
    panic("fileread");
    800049a0:	00004517          	auipc	a0,0x4
    800049a4:	cf850513          	addi	a0,a0,-776 # 80008698 <syscalls+0x290>
    800049a8:	ffffc097          	auipc	ra,0xffffc
    800049ac:	bb0080e7          	jalr	-1104(ra) # 80000558 <panic>
    return -1;
    800049b0:	597d                	li	s2,-1
    800049b2:	b765                	j	8000495a <fileread+0x60>
      return -1;
    800049b4:	597d                	li	s2,-1
    800049b6:	b755                	j	8000495a <fileread+0x60>
    800049b8:	597d                	li	s2,-1
    800049ba:	b745                	j	8000495a <fileread+0x60>

00000000800049bc <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    800049bc:	715d                	addi	sp,sp,-80
    800049be:	e486                	sd	ra,72(sp)
    800049c0:	e0a2                	sd	s0,64(sp)
    800049c2:	fc26                	sd	s1,56(sp)
    800049c4:	f84a                	sd	s2,48(sp)
    800049c6:	f44e                	sd	s3,40(sp)
    800049c8:	f052                	sd	s4,32(sp)
    800049ca:	ec56                	sd	s5,24(sp)
    800049cc:	e85a                	sd	s6,16(sp)
    800049ce:	e45e                	sd	s7,8(sp)
    800049d0:	e062                	sd	s8,0(sp)
    800049d2:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    800049d4:	00954783          	lbu	a5,9(a0)
    800049d8:	10078063          	beqz	a5,80004ad8 <filewrite+0x11c>
    800049dc:	84aa                	mv	s1,a0
    800049de:	8bae                	mv	s7,a1
    800049e0:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    800049e2:	411c                	lw	a5,0(a0)
    800049e4:	4705                	li	a4,1
    800049e6:	02e78263          	beq	a5,a4,80004a0a <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800049ea:	470d                	li	a4,3
    800049ec:	02e78663          	beq	a5,a4,80004a18 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800049f0:	4709                	li	a4,2
    800049f2:	0ce79b63          	bne	a5,a4,80004ac8 <filewrite+0x10c>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800049f6:	0ac05763          	blez	a2,80004aa4 <filewrite+0xe8>
    int i = 0;
    800049fa:	4901                	li	s2,0
    800049fc:	6b05                	lui	s6,0x1
    800049fe:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004a02:	6c05                	lui	s8,0x1
    80004a04:	c00c0c1b          	addiw	s8,s8,-1024
    80004a08:	a071                	j	80004a94 <filewrite+0xd8>
    ret = pipewrite(f->pipe, addr, n);
    80004a0a:	6908                	ld	a0,16(a0)
    80004a0c:	00000097          	auipc	ra,0x0
    80004a10:	222080e7          	jalr	546(ra) # 80004c2e <pipewrite>
    80004a14:	8aaa                	mv	s5,a0
    80004a16:	a851                	j	80004aaa <filewrite+0xee>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004a18:	02451783          	lh	a5,36(a0)
    80004a1c:	03079693          	slli	a3,a5,0x30
    80004a20:	92c1                	srli	a3,a3,0x30
    80004a22:	4725                	li	a4,9
    80004a24:	0ad76c63          	bltu	a4,a3,80004adc <filewrite+0x120>
    80004a28:	0792                	slli	a5,a5,0x4
    80004a2a:	0001d717          	auipc	a4,0x1d
    80004a2e:	8ee70713          	addi	a4,a4,-1810 # 80021318 <devsw>
    80004a32:	97ba                	add	a5,a5,a4
    80004a34:	679c                	ld	a5,8(a5)
    80004a36:	c7cd                	beqz	a5,80004ae0 <filewrite+0x124>
    ret = devsw[f->major].write(1, addr, n);
    80004a38:	4505                	li	a0,1
    80004a3a:	9782                	jalr	a5
    80004a3c:	8aaa                	mv	s5,a0
    80004a3e:	a0b5                	j	80004aaa <filewrite+0xee>
    80004a40:	00098a1b          	sext.w	s4,s3
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004a44:	00000097          	auipc	ra,0x0
    80004a48:	882080e7          	jalr	-1918(ra) # 800042c6 <begin_op>
      ilock(f->ip);
    80004a4c:	6c88                	ld	a0,24(s1)
    80004a4e:	fffff097          	auipc	ra,0xfffff
    80004a52:	d70080e7          	jalr	-656(ra) # 800037be <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004a56:	8752                	mv	a4,s4
    80004a58:	5094                	lw	a3,32(s1)
    80004a5a:	01790633          	add	a2,s2,s7
    80004a5e:	4585                	li	a1,1
    80004a60:	6c88                	ld	a0,24(s1)
    80004a62:	fffff097          	auipc	ra,0xfffff
    80004a66:	1c0080e7          	jalr	448(ra) # 80003c22 <writei>
    80004a6a:	89aa                	mv	s3,a0
    80004a6c:	00a05563          	blez	a0,80004a76 <filewrite+0xba>
        f->off += r;
    80004a70:	509c                	lw	a5,32(s1)
    80004a72:	9fa9                	addw	a5,a5,a0
    80004a74:	d09c                	sw	a5,32(s1)
      iunlock(f->ip);
    80004a76:	6c88                	ld	a0,24(s1)
    80004a78:	fffff097          	auipc	ra,0xfffff
    80004a7c:	e0a080e7          	jalr	-502(ra) # 80003882 <iunlock>
      end_op();
    80004a80:	00000097          	auipc	ra,0x0
    80004a84:	8c6080e7          	jalr	-1850(ra) # 80004346 <end_op>

      if(r != n1){
    80004a88:	01499f63          	bne	s3,s4,80004aa6 <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    80004a8c:	012a093b          	addw	s2,s4,s2
    while(i < n){
    80004a90:	01595b63          	ble	s5,s2,80004aa6 <filewrite+0xea>
      int n1 = n - i;
    80004a94:	412a87bb          	subw	a5,s5,s2
      if(n1 > max)
    80004a98:	89be                	mv	s3,a5
    80004a9a:	2781                	sext.w	a5,a5
    80004a9c:	fafb52e3          	ble	a5,s6,80004a40 <filewrite+0x84>
    80004aa0:	89e2                	mv	s3,s8
    80004aa2:	bf79                	j	80004a40 <filewrite+0x84>
    int i = 0;
    80004aa4:	4901                	li	s2,0
    }
    ret = (i == n ? n : -1);
    80004aa6:	012a9f63          	bne	s5,s2,80004ac4 <filewrite+0x108>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004aaa:	8556                	mv	a0,s5
    80004aac:	60a6                	ld	ra,72(sp)
    80004aae:	6406                	ld	s0,64(sp)
    80004ab0:	74e2                	ld	s1,56(sp)
    80004ab2:	7942                	ld	s2,48(sp)
    80004ab4:	79a2                	ld	s3,40(sp)
    80004ab6:	7a02                	ld	s4,32(sp)
    80004ab8:	6ae2                	ld	s5,24(sp)
    80004aba:	6b42                	ld	s6,16(sp)
    80004abc:	6ba2                	ld	s7,8(sp)
    80004abe:	6c02                	ld	s8,0(sp)
    80004ac0:	6161                	addi	sp,sp,80
    80004ac2:	8082                	ret
    ret = (i == n ? n : -1);
    80004ac4:	5afd                	li	s5,-1
    80004ac6:	b7d5                	j	80004aaa <filewrite+0xee>
    panic("filewrite");
    80004ac8:	00004517          	auipc	a0,0x4
    80004acc:	be050513          	addi	a0,a0,-1056 # 800086a8 <syscalls+0x2a0>
    80004ad0:	ffffc097          	auipc	ra,0xffffc
    80004ad4:	a88080e7          	jalr	-1400(ra) # 80000558 <panic>
    return -1;
    80004ad8:	5afd                	li	s5,-1
    80004ada:	bfc1                	j	80004aaa <filewrite+0xee>
      return -1;
    80004adc:	5afd                	li	s5,-1
    80004ade:	b7f1                	j	80004aaa <filewrite+0xee>
    80004ae0:	5afd                	li	s5,-1
    80004ae2:	b7e1                	j	80004aaa <filewrite+0xee>

0000000080004ae4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004ae4:	7179                	addi	sp,sp,-48
    80004ae6:	f406                	sd	ra,40(sp)
    80004ae8:	f022                	sd	s0,32(sp)
    80004aea:	ec26                	sd	s1,24(sp)
    80004aec:	e84a                	sd	s2,16(sp)
    80004aee:	e44e                	sd	s3,8(sp)
    80004af0:	e052                	sd	s4,0(sp)
    80004af2:	1800                	addi	s0,sp,48
    80004af4:	84aa                	mv	s1,a0
    80004af6:	892e                	mv	s2,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004af8:	0005b023          	sd	zero,0(a1)
    80004afc:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004b00:	00000097          	auipc	ra,0x0
    80004b04:	bf0080e7          	jalr	-1040(ra) # 800046f0 <filealloc>
    80004b08:	e088                	sd	a0,0(s1)
    80004b0a:	c551                	beqz	a0,80004b96 <pipealloc+0xb2>
    80004b0c:	00000097          	auipc	ra,0x0
    80004b10:	be4080e7          	jalr	-1052(ra) # 800046f0 <filealloc>
    80004b14:	00a93023          	sd	a0,0(s2)
    80004b18:	c92d                	beqz	a0,80004b8a <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004b1a:	ffffc097          	auipc	ra,0xffffc
    80004b1e:	016080e7          	jalr	22(ra) # 80000b30 <kalloc>
    80004b22:	89aa                	mv	s3,a0
    80004b24:	c125                	beqz	a0,80004b84 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004b26:	4a05                	li	s4,1
    80004b28:	23452023          	sw	s4,544(a0)
  pi->writeopen = 1;
    80004b2c:	23452223          	sw	s4,548(a0)
  pi->nwrite = 0;
    80004b30:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004b34:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004b38:	00004597          	auipc	a1,0x4
    80004b3c:	b8058593          	addi	a1,a1,-1152 # 800086b8 <syscalls+0x2b0>
    80004b40:	ffffc097          	auipc	ra,0xffffc
    80004b44:	050080e7          	jalr	80(ra) # 80000b90 <initlock>
  (*f0)->type = FD_PIPE;
    80004b48:	609c                	ld	a5,0(s1)
    80004b4a:	0147a023          	sw	s4,0(a5)
  (*f0)->readable = 1;
    80004b4e:	609c                	ld	a5,0(s1)
    80004b50:	01478423          	sb	s4,8(a5)
  (*f0)->writable = 0;
    80004b54:	609c                	ld	a5,0(s1)
    80004b56:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004b5a:	609c                	ld	a5,0(s1)
    80004b5c:	0137b823          	sd	s3,16(a5)
  (*f1)->type = FD_PIPE;
    80004b60:	00093783          	ld	a5,0(s2)
    80004b64:	0147a023          	sw	s4,0(a5)
  (*f1)->readable = 0;
    80004b68:	00093783          	ld	a5,0(s2)
    80004b6c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004b70:	00093783          	ld	a5,0(s2)
    80004b74:	014784a3          	sb	s4,9(a5)
  (*f1)->pipe = pi;
    80004b78:	00093783          	ld	a5,0(s2)
    80004b7c:	0137b823          	sd	s3,16(a5)
  return 0;
    80004b80:	4501                	li	a0,0
    80004b82:	a025                	j	80004baa <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004b84:	6088                	ld	a0,0(s1)
    80004b86:	e501                	bnez	a0,80004b8e <pipealloc+0xaa>
    80004b88:	a039                	j	80004b96 <pipealloc+0xb2>
    80004b8a:	6088                	ld	a0,0(s1)
    80004b8c:	c51d                	beqz	a0,80004bba <pipealloc+0xd6>
    fileclose(*f0);
    80004b8e:	00000097          	auipc	ra,0x0
    80004b92:	c32080e7          	jalr	-974(ra) # 800047c0 <fileclose>
  if(*f1)
    80004b96:	00093783          	ld	a5,0(s2)
    fileclose(*f1);
  return -1;
    80004b9a:	557d                	li	a0,-1
  if(*f1)
    80004b9c:	c799                	beqz	a5,80004baa <pipealloc+0xc6>
    fileclose(*f1);
    80004b9e:	853e                	mv	a0,a5
    80004ba0:	00000097          	auipc	ra,0x0
    80004ba4:	c20080e7          	jalr	-992(ra) # 800047c0 <fileclose>
  return -1;
    80004ba8:	557d                	li	a0,-1
}
    80004baa:	70a2                	ld	ra,40(sp)
    80004bac:	7402                	ld	s0,32(sp)
    80004bae:	64e2                	ld	s1,24(sp)
    80004bb0:	6942                	ld	s2,16(sp)
    80004bb2:	69a2                	ld	s3,8(sp)
    80004bb4:	6a02                	ld	s4,0(sp)
    80004bb6:	6145                	addi	sp,sp,48
    80004bb8:	8082                	ret
  return -1;
    80004bba:	557d                	li	a0,-1
    80004bbc:	b7fd                	j	80004baa <pipealloc+0xc6>

0000000080004bbe <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004bbe:	1101                	addi	sp,sp,-32
    80004bc0:	ec06                	sd	ra,24(sp)
    80004bc2:	e822                	sd	s0,16(sp)
    80004bc4:	e426                	sd	s1,8(sp)
    80004bc6:	e04a                	sd	s2,0(sp)
    80004bc8:	1000                	addi	s0,sp,32
    80004bca:	84aa                	mv	s1,a0
    80004bcc:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004bce:	ffffc097          	auipc	ra,0xffffc
    80004bd2:	052080e7          	jalr	82(ra) # 80000c20 <acquire>
  if(writable){
    80004bd6:	02090d63          	beqz	s2,80004c10 <pipeclose+0x52>
    pi->writeopen = 0;
    80004bda:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004bde:	21848513          	addi	a0,s1,536
    80004be2:	ffffd097          	auipc	ra,0xffffd
    80004be6:	6c6080e7          	jalr	1734(ra) # 800022a8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004bea:	2204b783          	ld	a5,544(s1)
    80004bee:	eb95                	bnez	a5,80004c22 <pipeclose+0x64>
    release(&pi->lock);
    80004bf0:	8526                	mv	a0,s1
    80004bf2:	ffffc097          	auipc	ra,0xffffc
    80004bf6:	0e2080e7          	jalr	226(ra) # 80000cd4 <release>
    kfree((char*)pi);
    80004bfa:	8526                	mv	a0,s1
    80004bfc:	ffffc097          	auipc	ra,0xffffc
    80004c00:	e34080e7          	jalr	-460(ra) # 80000a30 <kfree>
  } else
    release(&pi->lock);
}
    80004c04:	60e2                	ld	ra,24(sp)
    80004c06:	6442                	ld	s0,16(sp)
    80004c08:	64a2                	ld	s1,8(sp)
    80004c0a:	6902                	ld	s2,0(sp)
    80004c0c:	6105                	addi	sp,sp,32
    80004c0e:	8082                	ret
    pi->readopen = 0;
    80004c10:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004c14:	21c48513          	addi	a0,s1,540
    80004c18:	ffffd097          	auipc	ra,0xffffd
    80004c1c:	690080e7          	jalr	1680(ra) # 800022a8 <wakeup>
    80004c20:	b7e9                	j	80004bea <pipeclose+0x2c>
    release(&pi->lock);
    80004c22:	8526                	mv	a0,s1
    80004c24:	ffffc097          	auipc	ra,0xffffc
    80004c28:	0b0080e7          	jalr	176(ra) # 80000cd4 <release>
}
    80004c2c:	bfe1                	j	80004c04 <pipeclose+0x46>

0000000080004c2e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004c2e:	7159                	addi	sp,sp,-112
    80004c30:	f486                	sd	ra,104(sp)
    80004c32:	f0a2                	sd	s0,96(sp)
    80004c34:	eca6                	sd	s1,88(sp)
    80004c36:	e8ca                	sd	s2,80(sp)
    80004c38:	e4ce                	sd	s3,72(sp)
    80004c3a:	e0d2                	sd	s4,64(sp)
    80004c3c:	fc56                	sd	s5,56(sp)
    80004c3e:	f85a                	sd	s6,48(sp)
    80004c40:	f45e                	sd	s7,40(sp)
    80004c42:	f062                	sd	s8,32(sp)
    80004c44:	ec66                	sd	s9,24(sp)
    80004c46:	1880                	addi	s0,sp,112
    80004c48:	84aa                	mv	s1,a0
    80004c4a:	8aae                	mv	s5,a1
    80004c4c:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004c4e:	ffffd097          	auipc	ra,0xffffd
    80004c52:	e0a080e7          	jalr	-502(ra) # 80001a58 <myproc>
    80004c56:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004c58:	8526                	mv	a0,s1
    80004c5a:	ffffc097          	auipc	ra,0xffffc
    80004c5e:	fc6080e7          	jalr	-58(ra) # 80000c20 <acquire>
  while(i < n){
    80004c62:	0d405763          	blez	s4,80004d30 <pipewrite+0x102>
    80004c66:	8ba6                	mv	s7,s1
    if(pi->readopen == 0 || pr->killed){
    80004c68:	2204a783          	lw	a5,544(s1)
    80004c6c:	cb99                	beqz	a5,80004c82 <pipewrite+0x54>
    80004c6e:	0289a903          	lw	s2,40(s3)
    80004c72:	00091863          	bnez	s2,80004c82 <pipewrite+0x54>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004c76:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004c78:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004c7c:	21c48c13          	addi	s8,s1,540
    80004c80:	a0bd                	j	80004cee <pipewrite+0xc0>
      release(&pi->lock);
    80004c82:	8526                	mv	a0,s1
    80004c84:	ffffc097          	auipc	ra,0xffffc
    80004c88:	050080e7          	jalr	80(ra) # 80000cd4 <release>
      return -1;
    80004c8c:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004c8e:	854a                	mv	a0,s2
    80004c90:	70a6                	ld	ra,104(sp)
    80004c92:	7406                	ld	s0,96(sp)
    80004c94:	64e6                	ld	s1,88(sp)
    80004c96:	6946                	ld	s2,80(sp)
    80004c98:	69a6                	ld	s3,72(sp)
    80004c9a:	6a06                	ld	s4,64(sp)
    80004c9c:	7ae2                	ld	s5,56(sp)
    80004c9e:	7b42                	ld	s6,48(sp)
    80004ca0:	7ba2                	ld	s7,40(sp)
    80004ca2:	7c02                	ld	s8,32(sp)
    80004ca4:	6ce2                	ld	s9,24(sp)
    80004ca6:	6165                	addi	sp,sp,112
    80004ca8:	8082                	ret
      wakeup(&pi->nread);
    80004caa:	8566                	mv	a0,s9
    80004cac:	ffffd097          	auipc	ra,0xffffd
    80004cb0:	5fc080e7          	jalr	1532(ra) # 800022a8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004cb4:	85de                	mv	a1,s7
    80004cb6:	8562                	mv	a0,s8
    80004cb8:	ffffd097          	auipc	ra,0xffffd
    80004cbc:	464080e7          	jalr	1124(ra) # 8000211c <sleep>
    80004cc0:	a839                	j	80004cde <pipewrite+0xb0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004cc2:	21c4a783          	lw	a5,540(s1)
    80004cc6:	0017871b          	addiw	a4,a5,1
    80004cca:	20e4ae23          	sw	a4,540(s1)
    80004cce:	1ff7f793          	andi	a5,a5,511
    80004cd2:	97a6                	add	a5,a5,s1
    80004cd4:	f9f44703          	lbu	a4,-97(s0)
    80004cd8:	00e78c23          	sb	a4,24(a5)
      i++;
    80004cdc:	2905                	addiw	s2,s2,1
  while(i < n){
    80004cde:	03495d63          	ble	s4,s2,80004d18 <pipewrite+0xea>
    if(pi->readopen == 0 || pr->killed){
    80004ce2:	2204a783          	lw	a5,544(s1)
    80004ce6:	dfd1                	beqz	a5,80004c82 <pipewrite+0x54>
    80004ce8:	0289a783          	lw	a5,40(s3)
    80004cec:	fbd9                	bnez	a5,80004c82 <pipewrite+0x54>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004cee:	2184a783          	lw	a5,536(s1)
    80004cf2:	21c4a703          	lw	a4,540(s1)
    80004cf6:	2007879b          	addiw	a5,a5,512
    80004cfa:	faf708e3          	beq	a4,a5,80004caa <pipewrite+0x7c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004cfe:	4685                	li	a3,1
    80004d00:	01590633          	add	a2,s2,s5
    80004d04:	f9f40593          	addi	a1,s0,-97
    80004d08:	0509b503          	ld	a0,80(s3)
    80004d0c:	ffffd097          	auipc	ra,0xffffd
    80004d10:	a82080e7          	jalr	-1406(ra) # 8000178e <copyin>
    80004d14:	fb6517e3          	bne	a0,s6,80004cc2 <pipewrite+0x94>
  wakeup(&pi->nread);
    80004d18:	21848513          	addi	a0,s1,536
    80004d1c:	ffffd097          	auipc	ra,0xffffd
    80004d20:	58c080e7          	jalr	1420(ra) # 800022a8 <wakeup>
  release(&pi->lock);
    80004d24:	8526                	mv	a0,s1
    80004d26:	ffffc097          	auipc	ra,0xffffc
    80004d2a:	fae080e7          	jalr	-82(ra) # 80000cd4 <release>
  return i;
    80004d2e:	b785                	j	80004c8e <pipewrite+0x60>
  int i = 0;
    80004d30:	4901                	li	s2,0
    80004d32:	b7dd                	j	80004d18 <pipewrite+0xea>

0000000080004d34 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004d34:	715d                	addi	sp,sp,-80
    80004d36:	e486                	sd	ra,72(sp)
    80004d38:	e0a2                	sd	s0,64(sp)
    80004d3a:	fc26                	sd	s1,56(sp)
    80004d3c:	f84a                	sd	s2,48(sp)
    80004d3e:	f44e                	sd	s3,40(sp)
    80004d40:	f052                	sd	s4,32(sp)
    80004d42:	ec56                	sd	s5,24(sp)
    80004d44:	e85a                	sd	s6,16(sp)
    80004d46:	0880                	addi	s0,sp,80
    80004d48:	84aa                	mv	s1,a0
    80004d4a:	89ae                	mv	s3,a1
    80004d4c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004d4e:	ffffd097          	auipc	ra,0xffffd
    80004d52:	d0a080e7          	jalr	-758(ra) # 80001a58 <myproc>
    80004d56:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004d58:	8526                	mv	a0,s1
    80004d5a:	ffffc097          	auipc	ra,0xffffc
    80004d5e:	ec6080e7          	jalr	-314(ra) # 80000c20 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004d62:	2184a703          	lw	a4,536(s1)
    80004d66:	21c4a783          	lw	a5,540(s1)
    80004d6a:	06f71b63          	bne	a4,a5,80004de0 <piperead+0xac>
    80004d6e:	8926                	mv	s2,s1
    80004d70:	2244a783          	lw	a5,548(s1)
    80004d74:	cf9d                	beqz	a5,80004db2 <piperead+0x7e>
    if(pr->killed){
    80004d76:	028a2783          	lw	a5,40(s4)
    80004d7a:	e78d                	bnez	a5,80004da4 <piperead+0x70>
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004d7c:	21848b13          	addi	s6,s1,536
    80004d80:	85ca                	mv	a1,s2
    80004d82:	855a                	mv	a0,s6
    80004d84:	ffffd097          	auipc	ra,0xffffd
    80004d88:	398080e7          	jalr	920(ra) # 8000211c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004d8c:	2184a703          	lw	a4,536(s1)
    80004d90:	21c4a783          	lw	a5,540(s1)
    80004d94:	04f71663          	bne	a4,a5,80004de0 <piperead+0xac>
    80004d98:	2244a783          	lw	a5,548(s1)
    80004d9c:	cb99                	beqz	a5,80004db2 <piperead+0x7e>
    if(pr->killed){
    80004d9e:	028a2783          	lw	a5,40(s4)
    80004da2:	dff9                	beqz	a5,80004d80 <piperead+0x4c>
      release(&pi->lock);
    80004da4:	8526                	mv	a0,s1
    80004da6:	ffffc097          	auipc	ra,0xffffc
    80004daa:	f2e080e7          	jalr	-210(ra) # 80000cd4 <release>
      return -1;
    80004dae:	597d                	li	s2,-1
    80004db0:	a829                	j	80004dca <piperead+0x96>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    if(pi->nread == pi->nwrite)
    80004db2:	4901                	li	s2,0
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004db4:	21c48513          	addi	a0,s1,540
    80004db8:	ffffd097          	auipc	ra,0xffffd
    80004dbc:	4f0080e7          	jalr	1264(ra) # 800022a8 <wakeup>
  release(&pi->lock);
    80004dc0:	8526                	mv	a0,s1
    80004dc2:	ffffc097          	auipc	ra,0xffffc
    80004dc6:	f12080e7          	jalr	-238(ra) # 80000cd4 <release>
  return i;
}
    80004dca:	854a                	mv	a0,s2
    80004dcc:	60a6                	ld	ra,72(sp)
    80004dce:	6406                	ld	s0,64(sp)
    80004dd0:	74e2                	ld	s1,56(sp)
    80004dd2:	7942                	ld	s2,48(sp)
    80004dd4:	79a2                	ld	s3,40(sp)
    80004dd6:	7a02                	ld	s4,32(sp)
    80004dd8:	6ae2                	ld	s5,24(sp)
    80004dda:	6b42                	ld	s6,16(sp)
    80004ddc:	6161                	addi	sp,sp,80
    80004dde:	8082                	ret
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004de0:	4901                	li	s2,0
    80004de2:	fd5059e3          	blez	s5,80004db4 <piperead+0x80>
    if(pi->nread == pi->nwrite)
    80004de6:	2184a783          	lw	a5,536(s1)
    80004dea:	4901                	li	s2,0
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004dec:	5b7d                	li	s6,-1
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004dee:	0017871b          	addiw	a4,a5,1
    80004df2:	20e4ac23          	sw	a4,536(s1)
    80004df6:	1ff7f793          	andi	a5,a5,511
    80004dfa:	97a6                	add	a5,a5,s1
    80004dfc:	0187c783          	lbu	a5,24(a5)
    80004e00:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004e04:	4685                	li	a3,1
    80004e06:	fbf40613          	addi	a2,s0,-65
    80004e0a:	85ce                	mv	a1,s3
    80004e0c:	050a3503          	ld	a0,80(s4)
    80004e10:	ffffd097          	auipc	ra,0xffffd
    80004e14:	8f2080e7          	jalr	-1806(ra) # 80001702 <copyout>
    80004e18:	f9650ee3          	beq	a0,s6,80004db4 <piperead+0x80>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004e1c:	2905                	addiw	s2,s2,1
    80004e1e:	f92a8be3          	beq	s5,s2,80004db4 <piperead+0x80>
    if(pi->nread == pi->nwrite)
    80004e22:	2184a783          	lw	a5,536(s1)
    80004e26:	0985                	addi	s3,s3,1
    80004e28:	21c4a703          	lw	a4,540(s1)
    80004e2c:	fcf711e3          	bne	a4,a5,80004dee <piperead+0xba>
    80004e30:	b751                	j	80004db4 <piperead+0x80>

0000000080004e32 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004e32:	de010113          	addi	sp,sp,-544
    80004e36:	20113c23          	sd	ra,536(sp)
    80004e3a:	20813823          	sd	s0,528(sp)
    80004e3e:	20913423          	sd	s1,520(sp)
    80004e42:	21213023          	sd	s2,512(sp)
    80004e46:	ffce                	sd	s3,504(sp)
    80004e48:	fbd2                	sd	s4,496(sp)
    80004e4a:	f7d6                	sd	s5,488(sp)
    80004e4c:	f3da                	sd	s6,480(sp)
    80004e4e:	efde                	sd	s7,472(sp)
    80004e50:	ebe2                	sd	s8,464(sp)
    80004e52:	e7e6                	sd	s9,456(sp)
    80004e54:	e3ea                	sd	s10,448(sp)
    80004e56:	ff6e                	sd	s11,440(sp)
    80004e58:	1400                	addi	s0,sp,544
    80004e5a:	892a                	mv	s2,a0
    80004e5c:	dea43823          	sd	a0,-528(s0)
    80004e60:	deb43c23          	sd	a1,-520(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004e64:	ffffd097          	auipc	ra,0xffffd
    80004e68:	bf4080e7          	jalr	-1036(ra) # 80001a58 <myproc>
    80004e6c:	84aa                	mv	s1,a0

  begin_op();
    80004e6e:	fffff097          	auipc	ra,0xfffff
    80004e72:	458080e7          	jalr	1112(ra) # 800042c6 <begin_op>

  if((ip = namei(path)) == 0){
    80004e76:	854a                	mv	a0,s2
    80004e78:	fffff097          	auipc	ra,0xfffff
    80004e7c:	056080e7          	jalr	86(ra) # 80003ece <namei>
    80004e80:	c93d                	beqz	a0,80004ef6 <exec+0xc4>
    80004e82:	892a                	mv	s2,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004e84:	fffff097          	auipc	ra,0xfffff
    80004e88:	93a080e7          	jalr	-1734(ra) # 800037be <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004e8c:	04000713          	li	a4,64
    80004e90:	4681                	li	a3,0
    80004e92:	e4840613          	addi	a2,s0,-440
    80004e96:	4581                	li	a1,0
    80004e98:	854a                	mv	a0,s2
    80004e9a:	fffff097          	auipc	ra,0xfffff
    80004e9e:	c90080e7          	jalr	-880(ra) # 80003b2a <readi>
    80004ea2:	04000793          	li	a5,64
    80004ea6:	00f51a63          	bne	a0,a5,80004eba <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004eaa:	e4842703          	lw	a4,-440(s0)
    80004eae:	464c47b7          	lui	a5,0x464c4
    80004eb2:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004eb6:	04f70663          	beq	a4,a5,80004f02 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004eba:	854a                	mv	a0,s2
    80004ebc:	fffff097          	auipc	ra,0xfffff
    80004ec0:	c1c080e7          	jalr	-996(ra) # 80003ad8 <iunlockput>
    end_op();
    80004ec4:	fffff097          	auipc	ra,0xfffff
    80004ec8:	482080e7          	jalr	1154(ra) # 80004346 <end_op>
  }
  return -1;
    80004ecc:	557d                	li	a0,-1
}
    80004ece:	21813083          	ld	ra,536(sp)
    80004ed2:	21013403          	ld	s0,528(sp)
    80004ed6:	20813483          	ld	s1,520(sp)
    80004eda:	20013903          	ld	s2,512(sp)
    80004ede:	79fe                	ld	s3,504(sp)
    80004ee0:	7a5e                	ld	s4,496(sp)
    80004ee2:	7abe                	ld	s5,488(sp)
    80004ee4:	7b1e                	ld	s6,480(sp)
    80004ee6:	6bfe                	ld	s7,472(sp)
    80004ee8:	6c5e                	ld	s8,464(sp)
    80004eea:	6cbe                	ld	s9,456(sp)
    80004eec:	6d1e                	ld	s10,448(sp)
    80004eee:	7dfa                	ld	s11,440(sp)
    80004ef0:	22010113          	addi	sp,sp,544
    80004ef4:	8082                	ret
    end_op();
    80004ef6:	fffff097          	auipc	ra,0xfffff
    80004efa:	450080e7          	jalr	1104(ra) # 80004346 <end_op>
    return -1;
    80004efe:	557d                	li	a0,-1
    80004f00:	b7f9                	j	80004ece <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004f02:	8526                	mv	a0,s1
    80004f04:	ffffd097          	auipc	ra,0xffffd
    80004f08:	c1a080e7          	jalr	-998(ra) # 80001b1e <proc_pagetable>
    80004f0c:	e0a43423          	sd	a0,-504(s0)
    80004f10:	d54d                	beqz	a0,80004eba <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004f12:	e6842983          	lw	s3,-408(s0)
    80004f16:	e8045783          	lhu	a5,-384(s0)
    80004f1a:	c7ad                	beqz	a5,80004f84 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004f1c:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004f1e:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    80004f20:	6c05                	lui	s8,0x1
    80004f22:	fffc0793          	addi	a5,s8,-1 # fff <_entry-0x7ffff001>
    80004f26:	def43423          	sd	a5,-536(s0)
    80004f2a:	7cfd                	lui	s9,0xfffff
    80004f2c:	ac1d                	j	80005162 <exec+0x330>
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004f2e:	00003517          	auipc	a0,0x3
    80004f32:	79250513          	addi	a0,a0,1938 # 800086c0 <syscalls+0x2b8>
    80004f36:	ffffb097          	auipc	ra,0xffffb
    80004f3a:	622080e7          	jalr	1570(ra) # 80000558 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004f3e:	8756                	mv	a4,s5
    80004f40:	009d86bb          	addw	a3,s11,s1
    80004f44:	4581                	li	a1,0
    80004f46:	854a                	mv	a0,s2
    80004f48:	fffff097          	auipc	ra,0xfffff
    80004f4c:	be2080e7          	jalr	-1054(ra) # 80003b2a <readi>
    80004f50:	2501                	sext.w	a0,a0
    80004f52:	1aaa9e63          	bne	s5,a0,8000510e <exec+0x2dc>
  for(i = 0; i < sz; i += PGSIZE){
    80004f56:	6785                	lui	a5,0x1
    80004f58:	9cbd                	addw	s1,s1,a5
    80004f5a:	014c8a3b          	addw	s4,s9,s4
    80004f5e:	1f74f963          	bleu	s7,s1,80005150 <exec+0x31e>
    pa = walkaddr(pagetable, va + i);
    80004f62:	02049593          	slli	a1,s1,0x20
    80004f66:	9181                	srli	a1,a1,0x20
    80004f68:	95ea                	add	a1,a1,s10
    80004f6a:	e0843503          	ld	a0,-504(s0)
    80004f6e:	ffffc097          	auipc	ra,0xffffc
    80004f72:	1a4080e7          	jalr	420(ra) # 80001112 <walkaddr>
    80004f76:	862a                	mv	a2,a0
    if(pa == 0)
    80004f78:	d95d                	beqz	a0,80004f2e <exec+0xfc>
      n = PGSIZE;
    80004f7a:	8ae2                	mv	s5,s8
    if(sz - i < PGSIZE)
    80004f7c:	fd8a71e3          	bleu	s8,s4,80004f3e <exec+0x10c>
      n = sz - i;
    80004f80:	8ad2                	mv	s5,s4
    80004f82:	bf75                	j	80004f3e <exec+0x10c>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004f84:	4481                	li	s1,0
  iunlockput(ip);
    80004f86:	854a                	mv	a0,s2
    80004f88:	fffff097          	auipc	ra,0xfffff
    80004f8c:	b50080e7          	jalr	-1200(ra) # 80003ad8 <iunlockput>
  end_op();
    80004f90:	fffff097          	auipc	ra,0xfffff
    80004f94:	3b6080e7          	jalr	950(ra) # 80004346 <end_op>
  p = myproc();
    80004f98:	ffffd097          	auipc	ra,0xffffd
    80004f9c:	ac0080e7          	jalr	-1344(ra) # 80001a58 <myproc>
    80004fa0:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004fa2:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004fa6:	6785                	lui	a5,0x1
    80004fa8:	17fd                	addi	a5,a5,-1
    80004faa:	94be                	add	s1,s1,a5
    80004fac:	77fd                	lui	a5,0xfffff
    80004fae:	8fe5                	and	a5,a5,s1
    80004fb0:	e0f43023          	sd	a5,-512(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004fb4:	6609                	lui	a2,0x2
    80004fb6:	963e                	add	a2,a2,a5
    80004fb8:	85be                	mv	a1,a5
    80004fba:	e0843483          	ld	s1,-504(s0)
    80004fbe:	8526                	mv	a0,s1
    80004fc0:	ffffc097          	auipc	ra,0xffffc
    80004fc4:	4f2080e7          	jalr	1266(ra) # 800014b2 <uvmalloc>
    80004fc8:	8b2a                	mv	s6,a0
  ip = 0;
    80004fca:	4901                	li	s2,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004fcc:	14050163          	beqz	a0,8000510e <exec+0x2dc>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004fd0:	75f9                	lui	a1,0xffffe
    80004fd2:	95aa                	add	a1,a1,a0
    80004fd4:	8526                	mv	a0,s1
    80004fd6:	ffffc097          	auipc	ra,0xffffc
    80004fda:	6fa080e7          	jalr	1786(ra) # 800016d0 <uvmclear>
  stackbase = sp - PGSIZE;
    80004fde:	7bfd                	lui	s7,0xfffff
    80004fe0:	9bda                	add	s7,s7,s6
  for(argc = 0; argv[argc]; argc++) {
    80004fe2:	df843783          	ld	a5,-520(s0)
    80004fe6:	6388                	ld	a0,0(a5)
    80004fe8:	c925                	beqz	a0,80005058 <exec+0x226>
    80004fea:	e8840993          	addi	s3,s0,-376
    80004fee:	f8840c13          	addi	s8,s0,-120
  sp = sz;
    80004ff2:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004ff4:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004ff6:	ffffc097          	auipc	ra,0xffffc
    80004ffa:	ed0080e7          	jalr	-304(ra) # 80000ec6 <strlen>
    80004ffe:	2505                	addiw	a0,a0,1
    80005000:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005004:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80005008:	13796863          	bltu	s2,s7,80005138 <exec+0x306>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000500c:	df843c83          	ld	s9,-520(s0)
    80005010:	000cba03          	ld	s4,0(s9) # fffffffffffff000 <end+0xffffffff7ffd9000>
    80005014:	8552                	mv	a0,s4
    80005016:	ffffc097          	auipc	ra,0xffffc
    8000501a:	eb0080e7          	jalr	-336(ra) # 80000ec6 <strlen>
    8000501e:	0015069b          	addiw	a3,a0,1
    80005022:	8652                	mv	a2,s4
    80005024:	85ca                	mv	a1,s2
    80005026:	e0843503          	ld	a0,-504(s0)
    8000502a:	ffffc097          	auipc	ra,0xffffc
    8000502e:	6d8080e7          	jalr	1752(ra) # 80001702 <copyout>
    80005032:	10054763          	bltz	a0,80005140 <exec+0x30e>
    ustack[argc] = sp;
    80005036:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000503a:	0485                	addi	s1,s1,1
    8000503c:	008c8793          	addi	a5,s9,8
    80005040:	def43c23          	sd	a5,-520(s0)
    80005044:	008cb503          	ld	a0,8(s9)
    80005048:	c911                	beqz	a0,8000505c <exec+0x22a>
    if(argc >= MAXARG)
    8000504a:	09a1                	addi	s3,s3,8
    8000504c:	fb8995e3          	bne	s3,s8,80004ff6 <exec+0x1c4>
  sz = sz1;
    80005050:	e1643023          	sd	s6,-512(s0)
  ip = 0;
    80005054:	4901                	li	s2,0
    80005056:	a865                	j	8000510e <exec+0x2dc>
  sp = sz;
    80005058:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    8000505a:	4481                	li	s1,0
  ustack[argc] = 0;
    8000505c:	00349793          	slli	a5,s1,0x3
    80005060:	f9040713          	addi	a4,s0,-112
    80005064:	97ba                	add	a5,a5,a4
    80005066:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffd8ef8>
  sp -= (argc+1) * sizeof(uint64);
    8000506a:	00148693          	addi	a3,s1,1
    8000506e:	068e                	slli	a3,a3,0x3
    80005070:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005074:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80005078:	01797663          	bleu	s7,s2,80005084 <exec+0x252>
  sz = sz1;
    8000507c:	e1643023          	sd	s6,-512(s0)
  ip = 0;
    80005080:	4901                	li	s2,0
    80005082:	a071                	j	8000510e <exec+0x2dc>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005084:	e8840613          	addi	a2,s0,-376
    80005088:	85ca                	mv	a1,s2
    8000508a:	e0843503          	ld	a0,-504(s0)
    8000508e:	ffffc097          	auipc	ra,0xffffc
    80005092:	674080e7          	jalr	1652(ra) # 80001702 <copyout>
    80005096:	0a054963          	bltz	a0,80005148 <exec+0x316>
  p->trapframe->a1 = sp;
    8000509a:	058ab783          	ld	a5,88(s5)
    8000509e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800050a2:	df043783          	ld	a5,-528(s0)
    800050a6:	0007c703          	lbu	a4,0(a5)
    800050aa:	cf11                	beqz	a4,800050c6 <exec+0x294>
    800050ac:	0785                	addi	a5,a5,1
    if(*s == '/')
    800050ae:	02f00693          	li	a3,47
    800050b2:	a029                	j	800050bc <exec+0x28a>
    800050b4:	0785                	addi	a5,a5,1
  for(last=s=path; *s; s++)
    800050b6:	fff7c703          	lbu	a4,-1(a5)
    800050ba:	c711                	beqz	a4,800050c6 <exec+0x294>
    if(*s == '/')
    800050bc:	fed71ce3          	bne	a4,a3,800050b4 <exec+0x282>
      last = s+1;
    800050c0:	def43823          	sd	a5,-528(s0)
    800050c4:	bfc5                	j	800050b4 <exec+0x282>
  safestrcpy(p->name, last, sizeof(p->name));
    800050c6:	4641                	li	a2,16
    800050c8:	df043583          	ld	a1,-528(s0)
    800050cc:	158a8513          	addi	a0,s5,344
    800050d0:	ffffc097          	auipc	ra,0xffffc
    800050d4:	dc4080e7          	jalr	-572(ra) # 80000e94 <safestrcpy>
  oldpagetable = p->pagetable;
    800050d8:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800050dc:	e0843783          	ld	a5,-504(s0)
    800050e0:	04fab823          	sd	a5,80(s5)
  p->sz = sz;
    800050e4:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800050e8:	058ab783          	ld	a5,88(s5)
    800050ec:	e6043703          	ld	a4,-416(s0)
    800050f0:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800050f2:	058ab783          	ld	a5,88(s5)
    800050f6:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800050fa:	85ea                	mv	a1,s10
    800050fc:	ffffd097          	auipc	ra,0xffffd
    80005100:	abe080e7          	jalr	-1346(ra) # 80001bba <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005104:	0004851b          	sext.w	a0,s1
    80005108:	b3d9                	j	80004ece <exec+0x9c>
    8000510a:	e0943023          	sd	s1,-512(s0)
    proc_freepagetable(pagetable, sz);
    8000510e:	e0043583          	ld	a1,-512(s0)
    80005112:	e0843503          	ld	a0,-504(s0)
    80005116:	ffffd097          	auipc	ra,0xffffd
    8000511a:	aa4080e7          	jalr	-1372(ra) # 80001bba <proc_freepagetable>
  if(ip){
    8000511e:	d8091ee3          	bnez	s2,80004eba <exec+0x88>
  return -1;
    80005122:	557d                	li	a0,-1
    80005124:	b36d                	j	80004ece <exec+0x9c>
    80005126:	e0943023          	sd	s1,-512(s0)
    8000512a:	b7d5                	j	8000510e <exec+0x2dc>
    8000512c:	e0943023          	sd	s1,-512(s0)
    80005130:	bff9                	j	8000510e <exec+0x2dc>
    80005132:	e0943023          	sd	s1,-512(s0)
    80005136:	bfe1                	j	8000510e <exec+0x2dc>
  sz = sz1;
    80005138:	e1643023          	sd	s6,-512(s0)
  ip = 0;
    8000513c:	4901                	li	s2,0
    8000513e:	bfc1                	j	8000510e <exec+0x2dc>
  sz = sz1;
    80005140:	e1643023          	sd	s6,-512(s0)
  ip = 0;
    80005144:	4901                	li	s2,0
    80005146:	b7e1                	j	8000510e <exec+0x2dc>
  sz = sz1;
    80005148:	e1643023          	sd	s6,-512(s0)
  ip = 0;
    8000514c:	4901                	li	s2,0
    8000514e:	b7c1                	j	8000510e <exec+0x2dc>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80005150:	e0043483          	ld	s1,-512(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005154:	2b05                	addiw	s6,s6,1
    80005156:	0389899b          	addiw	s3,s3,56
    8000515a:	e8045783          	lhu	a5,-384(s0)
    8000515e:	e2fb54e3          	ble	a5,s6,80004f86 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005162:	2981                	sext.w	s3,s3
    80005164:	03800713          	li	a4,56
    80005168:	86ce                	mv	a3,s3
    8000516a:	e1040613          	addi	a2,s0,-496
    8000516e:	4581                	li	a1,0
    80005170:	854a                	mv	a0,s2
    80005172:	fffff097          	auipc	ra,0xfffff
    80005176:	9b8080e7          	jalr	-1608(ra) # 80003b2a <readi>
    8000517a:	03800793          	li	a5,56
    8000517e:	f8f516e3          	bne	a0,a5,8000510a <exec+0x2d8>
    if(ph.type != ELF_PROG_LOAD)
    80005182:	e1042783          	lw	a5,-496(s0)
    80005186:	4705                	li	a4,1
    80005188:	fce796e3          	bne	a5,a4,80005154 <exec+0x322>
    if(ph.memsz < ph.filesz)
    8000518c:	e3843603          	ld	a2,-456(s0)
    80005190:	e3043783          	ld	a5,-464(s0)
    80005194:	f8f669e3          	bltu	a2,a5,80005126 <exec+0x2f4>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005198:	e2043783          	ld	a5,-480(s0)
    8000519c:	963e                	add	a2,a2,a5
    8000519e:	f8f667e3          	bltu	a2,a5,8000512c <exec+0x2fa>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800051a2:	85a6                	mv	a1,s1
    800051a4:	e0843503          	ld	a0,-504(s0)
    800051a8:	ffffc097          	auipc	ra,0xffffc
    800051ac:	30a080e7          	jalr	778(ra) # 800014b2 <uvmalloc>
    800051b0:	e0a43023          	sd	a0,-512(s0)
    800051b4:	dd3d                	beqz	a0,80005132 <exec+0x300>
    if(ph.vaddr % PGSIZE != 0)
    800051b6:	e2043d03          	ld	s10,-480(s0)
    800051ba:	de843783          	ld	a5,-536(s0)
    800051be:	00fd77b3          	and	a5,s10,a5
    800051c2:	f7b1                	bnez	a5,8000510e <exec+0x2dc>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800051c4:	e1842d83          	lw	s11,-488(s0)
    800051c8:	e3042b83          	lw	s7,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800051cc:	f80b82e3          	beqz	s7,80005150 <exec+0x31e>
    800051d0:	8a5e                	mv	s4,s7
    800051d2:	4481                	li	s1,0
    800051d4:	b379                	j	80004f62 <exec+0x130>

00000000800051d6 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800051d6:	7179                	addi	sp,sp,-48
    800051d8:	f406                	sd	ra,40(sp)
    800051da:	f022                	sd	s0,32(sp)
    800051dc:	ec26                	sd	s1,24(sp)
    800051de:	e84a                	sd	s2,16(sp)
    800051e0:	1800                	addi	s0,sp,48
    800051e2:	892e                	mv	s2,a1
    800051e4:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800051e6:	fdc40593          	addi	a1,s0,-36
    800051ea:	ffffe097          	auipc	ra,0xffffe
    800051ee:	92c080e7          	jalr	-1748(ra) # 80002b16 <argint>
    800051f2:	04054063          	bltz	a0,80005232 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800051f6:	fdc42703          	lw	a4,-36(s0)
    800051fa:	47bd                	li	a5,15
    800051fc:	02e7ed63          	bltu	a5,a4,80005236 <argfd+0x60>
    80005200:	ffffd097          	auipc	ra,0xffffd
    80005204:	858080e7          	jalr	-1960(ra) # 80001a58 <myproc>
    80005208:	fdc42703          	lw	a4,-36(s0)
    8000520c:	01a70793          	addi	a5,a4,26
    80005210:	078e                	slli	a5,a5,0x3
    80005212:	953e                	add	a0,a0,a5
    80005214:	611c                	ld	a5,0(a0)
    80005216:	c395                	beqz	a5,8000523a <argfd+0x64>
    return -1;
  if(pfd)
    80005218:	00090463          	beqz	s2,80005220 <argfd+0x4a>
    *pfd = fd;
    8000521c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005220:	4501                	li	a0,0
  if(pf)
    80005222:	c091                	beqz	s1,80005226 <argfd+0x50>
    *pf = f;
    80005224:	e09c                	sd	a5,0(s1)
}
    80005226:	70a2                	ld	ra,40(sp)
    80005228:	7402                	ld	s0,32(sp)
    8000522a:	64e2                	ld	s1,24(sp)
    8000522c:	6942                	ld	s2,16(sp)
    8000522e:	6145                	addi	sp,sp,48
    80005230:	8082                	ret
    return -1;
    80005232:	557d                	li	a0,-1
    80005234:	bfcd                	j	80005226 <argfd+0x50>
    return -1;
    80005236:	557d                	li	a0,-1
    80005238:	b7fd                	j	80005226 <argfd+0x50>
    8000523a:	557d                	li	a0,-1
    8000523c:	b7ed                	j	80005226 <argfd+0x50>

000000008000523e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000523e:	1101                	addi	sp,sp,-32
    80005240:	ec06                	sd	ra,24(sp)
    80005242:	e822                	sd	s0,16(sp)
    80005244:	e426                	sd	s1,8(sp)
    80005246:	1000                	addi	s0,sp,32
    80005248:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000524a:	ffffd097          	auipc	ra,0xffffd
    8000524e:	80e080e7          	jalr	-2034(ra) # 80001a58 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(p->ofile[fd] == 0){
    80005252:	697c                	ld	a5,208(a0)
    80005254:	c395                	beqz	a5,80005278 <fdalloc+0x3a>
    80005256:	0d850713          	addi	a4,a0,216
  for(fd = 0; fd < NOFILE; fd++){
    8000525a:	4785                	li	a5,1
    8000525c:	4641                	li	a2,16
    if(p->ofile[fd] == 0){
    8000525e:	6314                	ld	a3,0(a4)
    80005260:	ce89                	beqz	a3,8000527a <fdalloc+0x3c>
  for(fd = 0; fd < NOFILE; fd++){
    80005262:	2785                	addiw	a5,a5,1
    80005264:	0721                	addi	a4,a4,8
    80005266:	fec79ce3          	bne	a5,a2,8000525e <fdalloc+0x20>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000526a:	57fd                	li	a5,-1
}
    8000526c:	853e                	mv	a0,a5
    8000526e:	60e2                	ld	ra,24(sp)
    80005270:	6442                	ld	s0,16(sp)
    80005272:	64a2                	ld	s1,8(sp)
    80005274:	6105                	addi	sp,sp,32
    80005276:	8082                	ret
  for(fd = 0; fd < NOFILE; fd++){
    80005278:	4781                	li	a5,0
      p->ofile[fd] = f;
    8000527a:	01a78713          	addi	a4,a5,26
    8000527e:	070e                	slli	a4,a4,0x3
    80005280:	953a                	add	a0,a0,a4
    80005282:	e104                	sd	s1,0(a0)
      return fd;
    80005284:	b7e5                	j	8000526c <fdalloc+0x2e>

0000000080005286 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005286:	715d                	addi	sp,sp,-80
    80005288:	e486                	sd	ra,72(sp)
    8000528a:	e0a2                	sd	s0,64(sp)
    8000528c:	fc26                	sd	s1,56(sp)
    8000528e:	f84a                	sd	s2,48(sp)
    80005290:	f44e                	sd	s3,40(sp)
    80005292:	f052                	sd	s4,32(sp)
    80005294:	ec56                	sd	s5,24(sp)
    80005296:	0880                	addi	s0,sp,80
    80005298:	89ae                	mv	s3,a1
    8000529a:	8ab2                	mv	s5,a2
    8000529c:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000529e:	fb040593          	addi	a1,s0,-80
    800052a2:	fffff097          	auipc	ra,0xfffff
    800052a6:	e24080e7          	jalr	-476(ra) # 800040c6 <nameiparent>
    800052aa:	892a                	mv	s2,a0
    800052ac:	12050f63          	beqz	a0,800053ea <create+0x164>
    return 0;

  ilock(dp);
    800052b0:	ffffe097          	auipc	ra,0xffffe
    800052b4:	50e080e7          	jalr	1294(ra) # 800037be <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800052b8:	4601                	li	a2,0
    800052ba:	fb040593          	addi	a1,s0,-80
    800052be:	854a                	mv	a0,s2
    800052c0:	fffff097          	auipc	ra,0xfffff
    800052c4:	a9c080e7          	jalr	-1380(ra) # 80003d5c <dirlookup>
    800052c8:	84aa                	mv	s1,a0
    800052ca:	c921                	beqz	a0,8000531a <create+0x94>
    iunlockput(dp);
    800052cc:	854a                	mv	a0,s2
    800052ce:	fffff097          	auipc	ra,0xfffff
    800052d2:	80a080e7          	jalr	-2038(ra) # 80003ad8 <iunlockput>
    ilock(ip);
    800052d6:	8526                	mv	a0,s1
    800052d8:	ffffe097          	auipc	ra,0xffffe
    800052dc:	4e6080e7          	jalr	1254(ra) # 800037be <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800052e0:	2981                	sext.w	s3,s3
    800052e2:	4789                	li	a5,2
    800052e4:	02f99463          	bne	s3,a5,8000530c <create+0x86>
    800052e8:	0444d783          	lhu	a5,68(s1)
    800052ec:	37f9                	addiw	a5,a5,-2
    800052ee:	17c2                	slli	a5,a5,0x30
    800052f0:	93c1                	srli	a5,a5,0x30
    800052f2:	4705                	li	a4,1
    800052f4:	00f76c63          	bltu	a4,a5,8000530c <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800052f8:	8526                	mv	a0,s1
    800052fa:	60a6                	ld	ra,72(sp)
    800052fc:	6406                	ld	s0,64(sp)
    800052fe:	74e2                	ld	s1,56(sp)
    80005300:	7942                	ld	s2,48(sp)
    80005302:	79a2                	ld	s3,40(sp)
    80005304:	7a02                	ld	s4,32(sp)
    80005306:	6ae2                	ld	s5,24(sp)
    80005308:	6161                	addi	sp,sp,80
    8000530a:	8082                	ret
    iunlockput(ip);
    8000530c:	8526                	mv	a0,s1
    8000530e:	ffffe097          	auipc	ra,0xffffe
    80005312:	7ca080e7          	jalr	1994(ra) # 80003ad8 <iunlockput>
    return 0;
    80005316:	4481                	li	s1,0
    80005318:	b7c5                	j	800052f8 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000531a:	85ce                	mv	a1,s3
    8000531c:	00092503          	lw	a0,0(s2)
    80005320:	ffffe097          	auipc	ra,0xffffe
    80005324:	302080e7          	jalr	770(ra) # 80003622 <ialloc>
    80005328:	84aa                	mv	s1,a0
    8000532a:	c529                	beqz	a0,80005374 <create+0xee>
  ilock(ip);
    8000532c:	ffffe097          	auipc	ra,0xffffe
    80005330:	492080e7          	jalr	1170(ra) # 800037be <ilock>
  ip->major = major;
    80005334:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80005338:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    8000533c:	4785                	li	a5,1
    8000533e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005342:	8526                	mv	a0,s1
    80005344:	ffffe097          	auipc	ra,0xffffe
    80005348:	3ae080e7          	jalr	942(ra) # 800036f2 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000534c:	2981                	sext.w	s3,s3
    8000534e:	4785                	li	a5,1
    80005350:	02f98a63          	beq	s3,a5,80005384 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80005354:	40d0                	lw	a2,4(s1)
    80005356:	fb040593          	addi	a1,s0,-80
    8000535a:	854a                	mv	a0,s2
    8000535c:	fffff097          	auipc	ra,0xfffff
    80005360:	ab0080e7          	jalr	-1360(ra) # 80003e0c <dirlink>
    80005364:	06054b63          	bltz	a0,800053da <create+0x154>
  iunlockput(dp);
    80005368:	854a                	mv	a0,s2
    8000536a:	ffffe097          	auipc	ra,0xffffe
    8000536e:	76e080e7          	jalr	1902(ra) # 80003ad8 <iunlockput>
  return ip;
    80005372:	b759                	j	800052f8 <create+0x72>
    panic("create: ialloc");
    80005374:	00003517          	auipc	a0,0x3
    80005378:	36c50513          	addi	a0,a0,876 # 800086e0 <syscalls+0x2d8>
    8000537c:	ffffb097          	auipc	ra,0xffffb
    80005380:	1dc080e7          	jalr	476(ra) # 80000558 <panic>
    dp->nlink++;  // for ".."
    80005384:	04a95783          	lhu	a5,74(s2)
    80005388:	2785                	addiw	a5,a5,1
    8000538a:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000538e:	854a                	mv	a0,s2
    80005390:	ffffe097          	auipc	ra,0xffffe
    80005394:	362080e7          	jalr	866(ra) # 800036f2 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005398:	40d0                	lw	a2,4(s1)
    8000539a:	00003597          	auipc	a1,0x3
    8000539e:	35658593          	addi	a1,a1,854 # 800086f0 <syscalls+0x2e8>
    800053a2:	8526                	mv	a0,s1
    800053a4:	fffff097          	auipc	ra,0xfffff
    800053a8:	a68080e7          	jalr	-1432(ra) # 80003e0c <dirlink>
    800053ac:	00054f63          	bltz	a0,800053ca <create+0x144>
    800053b0:	00492603          	lw	a2,4(s2)
    800053b4:	00003597          	auipc	a1,0x3
    800053b8:	34458593          	addi	a1,a1,836 # 800086f8 <syscalls+0x2f0>
    800053bc:	8526                	mv	a0,s1
    800053be:	fffff097          	auipc	ra,0xfffff
    800053c2:	a4e080e7          	jalr	-1458(ra) # 80003e0c <dirlink>
    800053c6:	f80557e3          	bgez	a0,80005354 <create+0xce>
      panic("create dots");
    800053ca:	00003517          	auipc	a0,0x3
    800053ce:	33650513          	addi	a0,a0,822 # 80008700 <syscalls+0x2f8>
    800053d2:	ffffb097          	auipc	ra,0xffffb
    800053d6:	186080e7          	jalr	390(ra) # 80000558 <panic>
    panic("create: dirlink");
    800053da:	00003517          	auipc	a0,0x3
    800053de:	33650513          	addi	a0,a0,822 # 80008710 <syscalls+0x308>
    800053e2:	ffffb097          	auipc	ra,0xffffb
    800053e6:	176080e7          	jalr	374(ra) # 80000558 <panic>
    return 0;
    800053ea:	84aa                	mv	s1,a0
    800053ec:	b731                	j	800052f8 <create+0x72>

00000000800053ee <sys_dup>:
{
    800053ee:	7179                	addi	sp,sp,-48
    800053f0:	f406                	sd	ra,40(sp)
    800053f2:	f022                	sd	s0,32(sp)
    800053f4:	ec26                	sd	s1,24(sp)
    800053f6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800053f8:	fd840613          	addi	a2,s0,-40
    800053fc:	4581                	li	a1,0
    800053fe:	4501                	li	a0,0
    80005400:	00000097          	auipc	ra,0x0
    80005404:	dd6080e7          	jalr	-554(ra) # 800051d6 <argfd>
    return -1;
    80005408:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000540a:	02054363          	bltz	a0,80005430 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000540e:	fd843503          	ld	a0,-40(s0)
    80005412:	00000097          	auipc	ra,0x0
    80005416:	e2c080e7          	jalr	-468(ra) # 8000523e <fdalloc>
    8000541a:	84aa                	mv	s1,a0
    return -1;
    8000541c:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000541e:	00054963          	bltz	a0,80005430 <sys_dup+0x42>
  filedup(f);
    80005422:	fd843503          	ld	a0,-40(s0)
    80005426:	fffff097          	auipc	ra,0xfffff
    8000542a:	348080e7          	jalr	840(ra) # 8000476e <filedup>
  return fd;
    8000542e:	87a6                	mv	a5,s1
}
    80005430:	853e                	mv	a0,a5
    80005432:	70a2                	ld	ra,40(sp)
    80005434:	7402                	ld	s0,32(sp)
    80005436:	64e2                	ld	s1,24(sp)
    80005438:	6145                	addi	sp,sp,48
    8000543a:	8082                	ret

000000008000543c <sys_read>:
{
    8000543c:	7179                	addi	sp,sp,-48
    8000543e:	f406                	sd	ra,40(sp)
    80005440:	f022                	sd	s0,32(sp)
    80005442:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005444:	fe840613          	addi	a2,s0,-24
    80005448:	4581                	li	a1,0
    8000544a:	4501                	li	a0,0
    8000544c:	00000097          	auipc	ra,0x0
    80005450:	d8a080e7          	jalr	-630(ra) # 800051d6 <argfd>
    return -1;
    80005454:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005456:	04054163          	bltz	a0,80005498 <sys_read+0x5c>
    8000545a:	fe440593          	addi	a1,s0,-28
    8000545e:	4509                	li	a0,2
    80005460:	ffffd097          	auipc	ra,0xffffd
    80005464:	6b6080e7          	jalr	1718(ra) # 80002b16 <argint>
    return -1;
    80005468:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000546a:	02054763          	bltz	a0,80005498 <sys_read+0x5c>
    8000546e:	fd840593          	addi	a1,s0,-40
    80005472:	4505                	li	a0,1
    80005474:	ffffd097          	auipc	ra,0xffffd
    80005478:	6c4080e7          	jalr	1732(ra) # 80002b38 <argaddr>
    return -1;
    8000547c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000547e:	00054d63          	bltz	a0,80005498 <sys_read+0x5c>
  return fileread(f, p, n);
    80005482:	fe442603          	lw	a2,-28(s0)
    80005486:	fd843583          	ld	a1,-40(s0)
    8000548a:	fe843503          	ld	a0,-24(s0)
    8000548e:	fffff097          	auipc	ra,0xfffff
    80005492:	46c080e7          	jalr	1132(ra) # 800048fa <fileread>
    80005496:	87aa                	mv	a5,a0
}
    80005498:	853e                	mv	a0,a5
    8000549a:	70a2                	ld	ra,40(sp)
    8000549c:	7402                	ld	s0,32(sp)
    8000549e:	6145                	addi	sp,sp,48
    800054a0:	8082                	ret

00000000800054a2 <sys_write>:
{
    800054a2:	7179                	addi	sp,sp,-48
    800054a4:	f406                	sd	ra,40(sp)
    800054a6:	f022                	sd	s0,32(sp)
    800054a8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800054aa:	fe840613          	addi	a2,s0,-24
    800054ae:	4581                	li	a1,0
    800054b0:	4501                	li	a0,0
    800054b2:	00000097          	auipc	ra,0x0
    800054b6:	d24080e7          	jalr	-732(ra) # 800051d6 <argfd>
    return -1;
    800054ba:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800054bc:	04054163          	bltz	a0,800054fe <sys_write+0x5c>
    800054c0:	fe440593          	addi	a1,s0,-28
    800054c4:	4509                	li	a0,2
    800054c6:	ffffd097          	auipc	ra,0xffffd
    800054ca:	650080e7          	jalr	1616(ra) # 80002b16 <argint>
    return -1;
    800054ce:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800054d0:	02054763          	bltz	a0,800054fe <sys_write+0x5c>
    800054d4:	fd840593          	addi	a1,s0,-40
    800054d8:	4505                	li	a0,1
    800054da:	ffffd097          	auipc	ra,0xffffd
    800054de:	65e080e7          	jalr	1630(ra) # 80002b38 <argaddr>
    return -1;
    800054e2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800054e4:	00054d63          	bltz	a0,800054fe <sys_write+0x5c>
  return filewrite(f, p, n);
    800054e8:	fe442603          	lw	a2,-28(s0)
    800054ec:	fd843583          	ld	a1,-40(s0)
    800054f0:	fe843503          	ld	a0,-24(s0)
    800054f4:	fffff097          	auipc	ra,0xfffff
    800054f8:	4c8080e7          	jalr	1224(ra) # 800049bc <filewrite>
    800054fc:	87aa                	mv	a5,a0
}
    800054fe:	853e                	mv	a0,a5
    80005500:	70a2                	ld	ra,40(sp)
    80005502:	7402                	ld	s0,32(sp)
    80005504:	6145                	addi	sp,sp,48
    80005506:	8082                	ret

0000000080005508 <sys_close>:
{
    80005508:	1101                	addi	sp,sp,-32
    8000550a:	ec06                	sd	ra,24(sp)
    8000550c:	e822                	sd	s0,16(sp)
    8000550e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005510:	fe040613          	addi	a2,s0,-32
    80005514:	fec40593          	addi	a1,s0,-20
    80005518:	4501                	li	a0,0
    8000551a:	00000097          	auipc	ra,0x0
    8000551e:	cbc080e7          	jalr	-836(ra) # 800051d6 <argfd>
    return -1;
    80005522:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005524:	02054463          	bltz	a0,8000554c <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005528:	ffffc097          	auipc	ra,0xffffc
    8000552c:	530080e7          	jalr	1328(ra) # 80001a58 <myproc>
    80005530:	fec42783          	lw	a5,-20(s0)
    80005534:	07e9                	addi	a5,a5,26
    80005536:	078e                	slli	a5,a5,0x3
    80005538:	953e                	add	a0,a0,a5
    8000553a:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000553e:	fe043503          	ld	a0,-32(s0)
    80005542:	fffff097          	auipc	ra,0xfffff
    80005546:	27e080e7          	jalr	638(ra) # 800047c0 <fileclose>
  return 0;
    8000554a:	4781                	li	a5,0
}
    8000554c:	853e                	mv	a0,a5
    8000554e:	60e2                	ld	ra,24(sp)
    80005550:	6442                	ld	s0,16(sp)
    80005552:	6105                	addi	sp,sp,32
    80005554:	8082                	ret

0000000080005556 <sys_fstat>:
{
    80005556:	1101                	addi	sp,sp,-32
    80005558:	ec06                	sd	ra,24(sp)
    8000555a:	e822                	sd	s0,16(sp)
    8000555c:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000555e:	fe840613          	addi	a2,s0,-24
    80005562:	4581                	li	a1,0
    80005564:	4501                	li	a0,0
    80005566:	00000097          	auipc	ra,0x0
    8000556a:	c70080e7          	jalr	-912(ra) # 800051d6 <argfd>
    return -1;
    8000556e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005570:	02054563          	bltz	a0,8000559a <sys_fstat+0x44>
    80005574:	fe040593          	addi	a1,s0,-32
    80005578:	4505                	li	a0,1
    8000557a:	ffffd097          	auipc	ra,0xffffd
    8000557e:	5be080e7          	jalr	1470(ra) # 80002b38 <argaddr>
    return -1;
    80005582:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005584:	00054b63          	bltz	a0,8000559a <sys_fstat+0x44>
  return filestat(f, st);
    80005588:	fe043583          	ld	a1,-32(s0)
    8000558c:	fe843503          	ld	a0,-24(s0)
    80005590:	fffff097          	auipc	ra,0xfffff
    80005594:	2f8080e7          	jalr	760(ra) # 80004888 <filestat>
    80005598:	87aa                	mv	a5,a0
}
    8000559a:	853e                	mv	a0,a5
    8000559c:	60e2                	ld	ra,24(sp)
    8000559e:	6442                	ld	s0,16(sp)
    800055a0:	6105                	addi	sp,sp,32
    800055a2:	8082                	ret

00000000800055a4 <sys_link>:
{
    800055a4:	7169                	addi	sp,sp,-304
    800055a6:	f606                	sd	ra,296(sp)
    800055a8:	f222                	sd	s0,288(sp)
    800055aa:	ee26                	sd	s1,280(sp)
    800055ac:	ea4a                	sd	s2,272(sp)
    800055ae:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800055b0:	08000613          	li	a2,128
    800055b4:	ed040593          	addi	a1,s0,-304
    800055b8:	4501                	li	a0,0
    800055ba:	ffffd097          	auipc	ra,0xffffd
    800055be:	5a0080e7          	jalr	1440(ra) # 80002b5a <argstr>
    return -1;
    800055c2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800055c4:	10054e63          	bltz	a0,800056e0 <sys_link+0x13c>
    800055c8:	08000613          	li	a2,128
    800055cc:	f5040593          	addi	a1,s0,-176
    800055d0:	4505                	li	a0,1
    800055d2:	ffffd097          	auipc	ra,0xffffd
    800055d6:	588080e7          	jalr	1416(ra) # 80002b5a <argstr>
    return -1;
    800055da:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800055dc:	10054263          	bltz	a0,800056e0 <sys_link+0x13c>
  begin_op();
    800055e0:	fffff097          	auipc	ra,0xfffff
    800055e4:	ce6080e7          	jalr	-794(ra) # 800042c6 <begin_op>
  if((ip = namei(old)) == 0){
    800055e8:	ed040513          	addi	a0,s0,-304
    800055ec:	fffff097          	auipc	ra,0xfffff
    800055f0:	8e2080e7          	jalr	-1822(ra) # 80003ece <namei>
    800055f4:	84aa                	mv	s1,a0
    800055f6:	c551                	beqz	a0,80005682 <sys_link+0xde>
  ilock(ip);
    800055f8:	ffffe097          	auipc	ra,0xffffe
    800055fc:	1c6080e7          	jalr	454(ra) # 800037be <ilock>
  if(ip->type == T_DIR){
    80005600:	04449703          	lh	a4,68(s1)
    80005604:	4785                	li	a5,1
    80005606:	08f70463          	beq	a4,a5,8000568e <sys_link+0xea>
  ip->nlink++;
    8000560a:	04a4d783          	lhu	a5,74(s1)
    8000560e:	2785                	addiw	a5,a5,1
    80005610:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005614:	8526                	mv	a0,s1
    80005616:	ffffe097          	auipc	ra,0xffffe
    8000561a:	0dc080e7          	jalr	220(ra) # 800036f2 <iupdate>
  iunlock(ip);
    8000561e:	8526                	mv	a0,s1
    80005620:	ffffe097          	auipc	ra,0xffffe
    80005624:	262080e7          	jalr	610(ra) # 80003882 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005628:	fd040593          	addi	a1,s0,-48
    8000562c:	f5040513          	addi	a0,s0,-176
    80005630:	fffff097          	auipc	ra,0xfffff
    80005634:	a96080e7          	jalr	-1386(ra) # 800040c6 <nameiparent>
    80005638:	892a                	mv	s2,a0
    8000563a:	c935                	beqz	a0,800056ae <sys_link+0x10a>
  ilock(dp);
    8000563c:	ffffe097          	auipc	ra,0xffffe
    80005640:	182080e7          	jalr	386(ra) # 800037be <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005644:	00092703          	lw	a4,0(s2)
    80005648:	409c                	lw	a5,0(s1)
    8000564a:	04f71d63          	bne	a4,a5,800056a4 <sys_link+0x100>
    8000564e:	40d0                	lw	a2,4(s1)
    80005650:	fd040593          	addi	a1,s0,-48
    80005654:	854a                	mv	a0,s2
    80005656:	ffffe097          	auipc	ra,0xffffe
    8000565a:	7b6080e7          	jalr	1974(ra) # 80003e0c <dirlink>
    8000565e:	04054363          	bltz	a0,800056a4 <sys_link+0x100>
  iunlockput(dp);
    80005662:	854a                	mv	a0,s2
    80005664:	ffffe097          	auipc	ra,0xffffe
    80005668:	474080e7          	jalr	1140(ra) # 80003ad8 <iunlockput>
  iput(ip);
    8000566c:	8526                	mv	a0,s1
    8000566e:	ffffe097          	auipc	ra,0xffffe
    80005672:	3c2080e7          	jalr	962(ra) # 80003a30 <iput>
  end_op();
    80005676:	fffff097          	auipc	ra,0xfffff
    8000567a:	cd0080e7          	jalr	-816(ra) # 80004346 <end_op>
  return 0;
    8000567e:	4781                	li	a5,0
    80005680:	a085                	j	800056e0 <sys_link+0x13c>
    end_op();
    80005682:	fffff097          	auipc	ra,0xfffff
    80005686:	cc4080e7          	jalr	-828(ra) # 80004346 <end_op>
    return -1;
    8000568a:	57fd                	li	a5,-1
    8000568c:	a891                	j	800056e0 <sys_link+0x13c>
    iunlockput(ip);
    8000568e:	8526                	mv	a0,s1
    80005690:	ffffe097          	auipc	ra,0xffffe
    80005694:	448080e7          	jalr	1096(ra) # 80003ad8 <iunlockput>
    end_op();
    80005698:	fffff097          	auipc	ra,0xfffff
    8000569c:	cae080e7          	jalr	-850(ra) # 80004346 <end_op>
    return -1;
    800056a0:	57fd                	li	a5,-1
    800056a2:	a83d                	j	800056e0 <sys_link+0x13c>
    iunlockput(dp);
    800056a4:	854a                	mv	a0,s2
    800056a6:	ffffe097          	auipc	ra,0xffffe
    800056aa:	432080e7          	jalr	1074(ra) # 80003ad8 <iunlockput>
  ilock(ip);
    800056ae:	8526                	mv	a0,s1
    800056b0:	ffffe097          	auipc	ra,0xffffe
    800056b4:	10e080e7          	jalr	270(ra) # 800037be <ilock>
  ip->nlink--;
    800056b8:	04a4d783          	lhu	a5,74(s1)
    800056bc:	37fd                	addiw	a5,a5,-1
    800056be:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800056c2:	8526                	mv	a0,s1
    800056c4:	ffffe097          	auipc	ra,0xffffe
    800056c8:	02e080e7          	jalr	46(ra) # 800036f2 <iupdate>
  iunlockput(ip);
    800056cc:	8526                	mv	a0,s1
    800056ce:	ffffe097          	auipc	ra,0xffffe
    800056d2:	40a080e7          	jalr	1034(ra) # 80003ad8 <iunlockput>
  end_op();
    800056d6:	fffff097          	auipc	ra,0xfffff
    800056da:	c70080e7          	jalr	-912(ra) # 80004346 <end_op>
  return -1;
    800056de:	57fd                	li	a5,-1
}
    800056e0:	853e                	mv	a0,a5
    800056e2:	70b2                	ld	ra,296(sp)
    800056e4:	7412                	ld	s0,288(sp)
    800056e6:	64f2                	ld	s1,280(sp)
    800056e8:	6952                	ld	s2,272(sp)
    800056ea:	6155                	addi	sp,sp,304
    800056ec:	8082                	ret

00000000800056ee <sys_unlink>:
{
    800056ee:	7151                	addi	sp,sp,-240
    800056f0:	f586                	sd	ra,232(sp)
    800056f2:	f1a2                	sd	s0,224(sp)
    800056f4:	eda6                	sd	s1,216(sp)
    800056f6:	e9ca                	sd	s2,208(sp)
    800056f8:	e5ce                	sd	s3,200(sp)
    800056fa:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800056fc:	08000613          	li	a2,128
    80005700:	f3040593          	addi	a1,s0,-208
    80005704:	4501                	li	a0,0
    80005706:	ffffd097          	auipc	ra,0xffffd
    8000570a:	454080e7          	jalr	1108(ra) # 80002b5a <argstr>
    8000570e:	16054f63          	bltz	a0,8000588c <sys_unlink+0x19e>
  begin_op();
    80005712:	fffff097          	auipc	ra,0xfffff
    80005716:	bb4080e7          	jalr	-1100(ra) # 800042c6 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000571a:	fb040593          	addi	a1,s0,-80
    8000571e:	f3040513          	addi	a0,s0,-208
    80005722:	fffff097          	auipc	ra,0xfffff
    80005726:	9a4080e7          	jalr	-1628(ra) # 800040c6 <nameiparent>
    8000572a:	89aa                	mv	s3,a0
    8000572c:	c979                	beqz	a0,80005802 <sys_unlink+0x114>
  ilock(dp);
    8000572e:	ffffe097          	auipc	ra,0xffffe
    80005732:	090080e7          	jalr	144(ra) # 800037be <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005736:	00003597          	auipc	a1,0x3
    8000573a:	fba58593          	addi	a1,a1,-70 # 800086f0 <syscalls+0x2e8>
    8000573e:	fb040513          	addi	a0,s0,-80
    80005742:	ffffe097          	auipc	ra,0xffffe
    80005746:	600080e7          	jalr	1536(ra) # 80003d42 <namecmp>
    8000574a:	14050863          	beqz	a0,8000589a <sys_unlink+0x1ac>
    8000574e:	00003597          	auipc	a1,0x3
    80005752:	faa58593          	addi	a1,a1,-86 # 800086f8 <syscalls+0x2f0>
    80005756:	fb040513          	addi	a0,s0,-80
    8000575a:	ffffe097          	auipc	ra,0xffffe
    8000575e:	5e8080e7          	jalr	1512(ra) # 80003d42 <namecmp>
    80005762:	12050c63          	beqz	a0,8000589a <sys_unlink+0x1ac>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005766:	f2c40613          	addi	a2,s0,-212
    8000576a:	fb040593          	addi	a1,s0,-80
    8000576e:	854e                	mv	a0,s3
    80005770:	ffffe097          	auipc	ra,0xffffe
    80005774:	5ec080e7          	jalr	1516(ra) # 80003d5c <dirlookup>
    80005778:	84aa                	mv	s1,a0
    8000577a:	12050063          	beqz	a0,8000589a <sys_unlink+0x1ac>
  ilock(ip);
    8000577e:	ffffe097          	auipc	ra,0xffffe
    80005782:	040080e7          	jalr	64(ra) # 800037be <ilock>
  if(ip->nlink < 1)
    80005786:	04a49783          	lh	a5,74(s1)
    8000578a:	08f05263          	blez	a5,8000580e <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000578e:	04449703          	lh	a4,68(s1)
    80005792:	4785                	li	a5,1
    80005794:	08f70563          	beq	a4,a5,8000581e <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005798:	4641                	li	a2,16
    8000579a:	4581                	li	a1,0
    8000579c:	fc040513          	addi	a0,s0,-64
    800057a0:	ffffb097          	auipc	ra,0xffffb
    800057a4:	57c080e7          	jalr	1404(ra) # 80000d1c <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800057a8:	4741                	li	a4,16
    800057aa:	f2c42683          	lw	a3,-212(s0)
    800057ae:	fc040613          	addi	a2,s0,-64
    800057b2:	4581                	li	a1,0
    800057b4:	854e                	mv	a0,s3
    800057b6:	ffffe097          	auipc	ra,0xffffe
    800057ba:	46c080e7          	jalr	1132(ra) # 80003c22 <writei>
    800057be:	47c1                	li	a5,16
    800057c0:	0af51363          	bne	a0,a5,80005866 <sys_unlink+0x178>
  if(ip->type == T_DIR){
    800057c4:	04449703          	lh	a4,68(s1)
    800057c8:	4785                	li	a5,1
    800057ca:	0af70663          	beq	a4,a5,80005876 <sys_unlink+0x188>
  iunlockput(dp);
    800057ce:	854e                	mv	a0,s3
    800057d0:	ffffe097          	auipc	ra,0xffffe
    800057d4:	308080e7          	jalr	776(ra) # 80003ad8 <iunlockput>
  ip->nlink--;
    800057d8:	04a4d783          	lhu	a5,74(s1)
    800057dc:	37fd                	addiw	a5,a5,-1
    800057de:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800057e2:	8526                	mv	a0,s1
    800057e4:	ffffe097          	auipc	ra,0xffffe
    800057e8:	f0e080e7          	jalr	-242(ra) # 800036f2 <iupdate>
  iunlockput(ip);
    800057ec:	8526                	mv	a0,s1
    800057ee:	ffffe097          	auipc	ra,0xffffe
    800057f2:	2ea080e7          	jalr	746(ra) # 80003ad8 <iunlockput>
  end_op();
    800057f6:	fffff097          	auipc	ra,0xfffff
    800057fa:	b50080e7          	jalr	-1200(ra) # 80004346 <end_op>
  return 0;
    800057fe:	4501                	li	a0,0
    80005800:	a07d                	j	800058ae <sys_unlink+0x1c0>
    end_op();
    80005802:	fffff097          	auipc	ra,0xfffff
    80005806:	b44080e7          	jalr	-1212(ra) # 80004346 <end_op>
    return -1;
    8000580a:	557d                	li	a0,-1
    8000580c:	a04d                	j	800058ae <sys_unlink+0x1c0>
    panic("unlink: nlink < 1");
    8000580e:	00003517          	auipc	a0,0x3
    80005812:	f1250513          	addi	a0,a0,-238 # 80008720 <syscalls+0x318>
    80005816:	ffffb097          	auipc	ra,0xffffb
    8000581a:	d42080e7          	jalr	-702(ra) # 80000558 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000581e:	44f8                	lw	a4,76(s1)
    80005820:	02000793          	li	a5,32
    80005824:	f6e7fae3          	bleu	a4,a5,80005798 <sys_unlink+0xaa>
    80005828:	02000913          	li	s2,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000582c:	4741                	li	a4,16
    8000582e:	86ca                	mv	a3,s2
    80005830:	f1840613          	addi	a2,s0,-232
    80005834:	4581                	li	a1,0
    80005836:	8526                	mv	a0,s1
    80005838:	ffffe097          	auipc	ra,0xffffe
    8000583c:	2f2080e7          	jalr	754(ra) # 80003b2a <readi>
    80005840:	47c1                	li	a5,16
    80005842:	00f51a63          	bne	a0,a5,80005856 <sys_unlink+0x168>
    if(de.inum != 0)
    80005846:	f1845783          	lhu	a5,-232(s0)
    8000584a:	e3b9                	bnez	a5,80005890 <sys_unlink+0x1a2>
    8000584c:	2941                	addiw	s2,s2,16
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000584e:	44fc                	lw	a5,76(s1)
    80005850:	fcf96ee3          	bltu	s2,a5,8000582c <sys_unlink+0x13e>
    80005854:	b791                	j	80005798 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005856:	00003517          	auipc	a0,0x3
    8000585a:	ee250513          	addi	a0,a0,-286 # 80008738 <syscalls+0x330>
    8000585e:	ffffb097          	auipc	ra,0xffffb
    80005862:	cfa080e7          	jalr	-774(ra) # 80000558 <panic>
    panic("unlink: writei");
    80005866:	00003517          	auipc	a0,0x3
    8000586a:	eea50513          	addi	a0,a0,-278 # 80008750 <syscalls+0x348>
    8000586e:	ffffb097          	auipc	ra,0xffffb
    80005872:	cea080e7          	jalr	-790(ra) # 80000558 <panic>
    dp->nlink--;
    80005876:	04a9d783          	lhu	a5,74(s3)
    8000587a:	37fd                	addiw	a5,a5,-1
    8000587c:	04f99523          	sh	a5,74(s3)
    iupdate(dp);
    80005880:	854e                	mv	a0,s3
    80005882:	ffffe097          	auipc	ra,0xffffe
    80005886:	e70080e7          	jalr	-400(ra) # 800036f2 <iupdate>
    8000588a:	b791                	j	800057ce <sys_unlink+0xe0>
    return -1;
    8000588c:	557d                	li	a0,-1
    8000588e:	a005                	j	800058ae <sys_unlink+0x1c0>
    iunlockput(ip);
    80005890:	8526                	mv	a0,s1
    80005892:	ffffe097          	auipc	ra,0xffffe
    80005896:	246080e7          	jalr	582(ra) # 80003ad8 <iunlockput>
  iunlockput(dp);
    8000589a:	854e                	mv	a0,s3
    8000589c:	ffffe097          	auipc	ra,0xffffe
    800058a0:	23c080e7          	jalr	572(ra) # 80003ad8 <iunlockput>
  end_op();
    800058a4:	fffff097          	auipc	ra,0xfffff
    800058a8:	aa2080e7          	jalr	-1374(ra) # 80004346 <end_op>
  return -1;
    800058ac:	557d                	li	a0,-1
}
    800058ae:	70ae                	ld	ra,232(sp)
    800058b0:	740e                	ld	s0,224(sp)
    800058b2:	64ee                	ld	s1,216(sp)
    800058b4:	694e                	ld	s2,208(sp)
    800058b6:	69ae                	ld	s3,200(sp)
    800058b8:	616d                	addi	sp,sp,240
    800058ba:	8082                	ret

00000000800058bc <sys_open>:

uint64
sys_open(void)
{
    800058bc:	7129                	addi	sp,sp,-320
    800058be:	fe06                	sd	ra,312(sp)
    800058c0:	fa22                	sd	s0,304(sp)
    800058c2:	f626                	sd	s1,296(sp)
    800058c4:	f24a                	sd	s2,288(sp)
    800058c6:	ee4e                	sd	s3,280(sp)
    800058c8:	0280                	addi	s0,sp,320
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800058ca:	08000613          	li	a2,128
    800058ce:	f5040593          	addi	a1,s0,-176
    800058d2:	4501                	li	a0,0
    800058d4:	ffffd097          	auipc	ra,0xffffd
    800058d8:	286080e7          	jalr	646(ra) # 80002b5a <argstr>
    return -1;
    800058dc:	597d                	li	s2,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800058de:	0c054663          	bltz	a0,800059aa <sys_open+0xee>
    800058e2:	f4c40593          	addi	a1,s0,-180
    800058e6:	4505                	li	a0,1
    800058e8:	ffffd097          	auipc	ra,0xffffd
    800058ec:	22e080e7          	jalr	558(ra) # 80002b16 <argint>
    800058f0:	0a054d63          	bltz	a0,800059aa <sys_open+0xee>

  begin_op();
    800058f4:	fffff097          	auipc	ra,0xfffff
    800058f8:	9d2080e7          	jalr	-1582(ra) # 800042c6 <begin_op>

  if(omode & O_CREATE){
    800058fc:	f4c42783          	lw	a5,-180(s0)
    80005900:	2007f793          	andi	a5,a5,512
    80005904:	c3e1                	beqz	a5,800059c4 <sys_open+0x108>
    ip = create(path, T_FILE, 0, 0);
    80005906:	4681                	li	a3,0
    80005908:	4601                	li	a2,0
    8000590a:	4589                	li	a1,2
    8000590c:	f5040513          	addi	a0,s0,-176
    80005910:	00000097          	auipc	ra,0x0
    80005914:	976080e7          	jalr	-1674(ra) # 80005286 <create>
    80005918:	84aa                	mv	s1,a0
    if(ip == 0){
    8000591a:	c145                	beqz	a0,800059ba <sys_open+0xfe>
  // if the ip is soft_link, read the target_path in it.
  // change ip to the target_path
  // if ip of target_path is also soft_link,
  // loop to the final "ip" that is not sotf_link
  // limit depth = 10
  if(ip->type == T_SYMLINK && !(omode & O_NOFOLLOW)){
    8000591c:	04449703          	lh	a4,68(s1)
    80005920:	4791                	li	a5,4
    80005922:	0ef70763          	beq	a4,a5,80005a10 <sys_open+0x154>
      ilock(ip);
      depth ++;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005926:	04449703          	lh	a4,68(s1)
    8000592a:	478d                	li	a5,3
    8000592c:	00f71763          	bne	a4,a5,8000593a <sys_open+0x7e>
    80005930:	0464d703          	lhu	a4,70(s1)
    80005934:	47a5                	li	a5,9
    80005936:	14e7e663          	bltu	a5,a4,80005a82 <sys_open+0x1c6>
    end_op();
    return -1;
  }

  // open a file f with fd
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000593a:	fffff097          	auipc	ra,0xfffff
    8000593e:	db6080e7          	jalr	-586(ra) # 800046f0 <filealloc>
    80005942:	89aa                	mv	s3,a0
    80005944:	16050c63          	beqz	a0,80005abc <sys_open+0x200>
    80005948:	00000097          	auipc	ra,0x0
    8000594c:	8f6080e7          	jalr	-1802(ra) # 8000523e <fdalloc>
    80005950:	892a                	mv	s2,a0
    80005952:	16054063          	bltz	a0,80005ab2 <sys_open+0x1f6>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005956:	04449703          	lh	a4,68(s1)
    8000595a:	478d                	li	a5,3
    8000595c:	12f70e63          	beq	a4,a5,80005a98 <sys_open+0x1dc>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005960:	4789                	li	a5,2
    80005962:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005966:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    8000596a:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    8000596e:	f4c42783          	lw	a5,-180(s0)
    80005972:	0017c713          	xori	a4,a5,1
    80005976:	8b05                	andi	a4,a4,1
    80005978:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000597c:	0037f713          	andi	a4,a5,3
    80005980:	00e03733          	snez	a4,a4
    80005984:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005988:	4007f793          	andi	a5,a5,1024
    8000598c:	c791                	beqz	a5,80005998 <sys_open+0xdc>
    8000598e:	04449703          	lh	a4,68(s1)
    80005992:	4789                	li	a5,2
    80005994:	10f70963          	beq	a4,a5,80005aa6 <sys_open+0x1ea>
    itrunc(ip);
  }

  iunlock(ip);
    80005998:	8526                	mv	a0,s1
    8000599a:	ffffe097          	auipc	ra,0xffffe
    8000599e:	ee8080e7          	jalr	-280(ra) # 80003882 <iunlock>
  end_op();
    800059a2:	fffff097          	auipc	ra,0xfffff
    800059a6:	9a4080e7          	jalr	-1628(ra) # 80004346 <end_op>

  return fd;
}
    800059aa:	854a                	mv	a0,s2
    800059ac:	70f2                	ld	ra,312(sp)
    800059ae:	7452                	ld	s0,304(sp)
    800059b0:	74b2                	ld	s1,296(sp)
    800059b2:	7912                	ld	s2,288(sp)
    800059b4:	69f2                	ld	s3,280(sp)
    800059b6:	6131                	addi	sp,sp,320
    800059b8:	8082                	ret
      end_op();
    800059ba:	fffff097          	auipc	ra,0xfffff
    800059be:	98c080e7          	jalr	-1652(ra) # 80004346 <end_op>
      return -1;
    800059c2:	b7e5                	j	800059aa <sys_open+0xee>
    if((ip = namei(path)) == 0){
    800059c4:	f5040513          	addi	a0,s0,-176
    800059c8:	ffffe097          	auipc	ra,0xffffe
    800059cc:	506080e7          	jalr	1286(ra) # 80003ece <namei>
    800059d0:	84aa                	mv	s1,a0
    800059d2:	c90d                	beqz	a0,80005a04 <sys_open+0x148>
    ilock(ip);
    800059d4:	ffffe097          	auipc	ra,0xffffe
    800059d8:	dea080e7          	jalr	-534(ra) # 800037be <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY && omode != O_NOFOLLOW){ //
    800059dc:	04449703          	lh	a4,68(s1)
    800059e0:	4785                	li	a5,1
    800059e2:	f2f71de3          	bne	a4,a5,8000591c <sys_open+0x60>
    800059e6:	f4c42783          	lw	a5,-180(s0)
    800059ea:	9bed                	andi	a5,a5,-5
    800059ec:	d7b9                	beqz	a5,8000593a <sys_open+0x7e>
      iunlockput(ip);
    800059ee:	8526                	mv	a0,s1
    800059f0:	ffffe097          	auipc	ra,0xffffe
    800059f4:	0e8080e7          	jalr	232(ra) # 80003ad8 <iunlockput>
      end_op();
    800059f8:	fffff097          	auipc	ra,0xfffff
    800059fc:	94e080e7          	jalr	-1714(ra) # 80004346 <end_op>
      return -1;
    80005a00:	597d                	li	s2,-1
    80005a02:	b765                	j	800059aa <sys_open+0xee>
      end_op();
    80005a04:	fffff097          	auipc	ra,0xfffff
    80005a08:	942080e7          	jalr	-1726(ra) # 80004346 <end_op>
      return -1;
    80005a0c:	597d                	li	s2,-1
    80005a0e:	bf71                	j	800059aa <sys_open+0xee>
  if(ip->type == T_SYMLINK && !(omode & O_NOFOLLOW)){
    80005a10:	f4c42783          	lw	a5,-180(s0)
    80005a14:	8b91                	andi	a5,a5,4
    80005a16:	f395                	bnez	a5,8000593a <sys_open+0x7e>
    80005a18:	4929                	li	s2,10
    while(ip->type == T_SYMLINK){
    80005a1a:	4991                	li	s3,4
      readi(ip, 0, (uint64)target_path, 0, MAXPATH);
    80005a1c:	08000713          	li	a4,128
    80005a20:	4681                	li	a3,0
    80005a22:	ec840613          	addi	a2,s0,-312
    80005a26:	4581                	li	a1,0
    80005a28:	8526                	mv	a0,s1
    80005a2a:	ffffe097          	auipc	ra,0xffffe
    80005a2e:	100080e7          	jalr	256(ra) # 80003b2a <readi>
      iunlockput(ip);
    80005a32:	8526                	mv	a0,s1
    80005a34:	ffffe097          	auipc	ra,0xffffe
    80005a38:	0a4080e7          	jalr	164(ra) # 80003ad8 <iunlockput>
      if((ip = namei(target_path)) == 0){
    80005a3c:	ec840513          	addi	a0,s0,-312
    80005a40:	ffffe097          	auipc	ra,0xffffe
    80005a44:	48e080e7          	jalr	1166(ra) # 80003ece <namei>
    80005a48:	84aa                	mv	s1,a0
    80005a4a:	c51d                	beqz	a0,80005a78 <sys_open+0x1bc>
      ilock(ip);
    80005a4c:	ffffe097          	auipc	ra,0xffffe
    80005a50:	d72080e7          	jalr	-654(ra) # 800037be <ilock>
    while(ip->type == T_SYMLINK){
    80005a54:	04449783          	lh	a5,68(s1)
    80005a58:	ed3797e3          	bne	a5,s3,80005926 <sys_open+0x6a>
      if(depth == 10){
    80005a5c:	397d                	addiw	s2,s2,-1
    80005a5e:	fa091fe3          	bnez	s2,80005a1c <sys_open+0x160>
        iunlockput(ip);
    80005a62:	8526                	mv	a0,s1
    80005a64:	ffffe097          	auipc	ra,0xffffe
    80005a68:	074080e7          	jalr	116(ra) # 80003ad8 <iunlockput>
        end_op();
    80005a6c:	fffff097          	auipc	ra,0xfffff
    80005a70:	8da080e7          	jalr	-1830(ra) # 80004346 <end_op>
        return -1;
    80005a74:	597d                	li	s2,-1
    80005a76:	bf15                	j	800059aa <sys_open+0xee>
        end_op();
    80005a78:	fffff097          	auipc	ra,0xfffff
    80005a7c:	8ce080e7          	jalr	-1842(ra) # 80004346 <end_op>
        return -1;
    80005a80:	bfd5                	j	80005a74 <sys_open+0x1b8>
    iunlockput(ip);
    80005a82:	8526                	mv	a0,s1
    80005a84:	ffffe097          	auipc	ra,0xffffe
    80005a88:	054080e7          	jalr	84(ra) # 80003ad8 <iunlockput>
    end_op();
    80005a8c:	fffff097          	auipc	ra,0xfffff
    80005a90:	8ba080e7          	jalr	-1862(ra) # 80004346 <end_op>
    return -1;
    80005a94:	597d                	li	s2,-1
    80005a96:	bf11                	j	800059aa <sys_open+0xee>
    f->type = FD_DEVICE;
    80005a98:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005a9c:	04649783          	lh	a5,70(s1)
    80005aa0:	02f99223          	sh	a5,36(s3)
    80005aa4:	b5d9                	j	8000596a <sys_open+0xae>
    itrunc(ip);
    80005aa6:	8526                	mv	a0,s1
    80005aa8:	ffffe097          	auipc	ra,0xffffe
    80005aac:	e26080e7          	jalr	-474(ra) # 800038ce <itrunc>
    80005ab0:	b5e5                	j	80005998 <sys_open+0xdc>
      fileclose(f);
    80005ab2:	854e                	mv	a0,s3
    80005ab4:	fffff097          	auipc	ra,0xfffff
    80005ab8:	d0c080e7          	jalr	-756(ra) # 800047c0 <fileclose>
    iunlockput(ip);
    80005abc:	8526                	mv	a0,s1
    80005abe:	ffffe097          	auipc	ra,0xffffe
    80005ac2:	01a080e7          	jalr	26(ra) # 80003ad8 <iunlockput>
    end_op();
    80005ac6:	fffff097          	auipc	ra,0xfffff
    80005aca:	880080e7          	jalr	-1920(ra) # 80004346 <end_op>
    return -1;
    80005ace:	597d                	li	s2,-1
    80005ad0:	bde9                	j	800059aa <sys_open+0xee>

0000000080005ad2 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005ad2:	7175                	addi	sp,sp,-144
    80005ad4:	e506                	sd	ra,136(sp)
    80005ad6:	e122                	sd	s0,128(sp)
    80005ad8:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005ada:	ffffe097          	auipc	ra,0xffffe
    80005ade:	7ec080e7          	jalr	2028(ra) # 800042c6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005ae2:	08000613          	li	a2,128
    80005ae6:	f7040593          	addi	a1,s0,-144
    80005aea:	4501                	li	a0,0
    80005aec:	ffffd097          	auipc	ra,0xffffd
    80005af0:	06e080e7          	jalr	110(ra) # 80002b5a <argstr>
    80005af4:	02054963          	bltz	a0,80005b26 <sys_mkdir+0x54>
    80005af8:	4681                	li	a3,0
    80005afa:	4601                	li	a2,0
    80005afc:	4585                	li	a1,1
    80005afe:	f7040513          	addi	a0,s0,-144
    80005b02:	fffff097          	auipc	ra,0xfffff
    80005b06:	784080e7          	jalr	1924(ra) # 80005286 <create>
    80005b0a:	cd11                	beqz	a0,80005b26 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005b0c:	ffffe097          	auipc	ra,0xffffe
    80005b10:	fcc080e7          	jalr	-52(ra) # 80003ad8 <iunlockput>
  end_op();
    80005b14:	fffff097          	auipc	ra,0xfffff
    80005b18:	832080e7          	jalr	-1998(ra) # 80004346 <end_op>
  return 0;
    80005b1c:	4501                	li	a0,0
}
    80005b1e:	60aa                	ld	ra,136(sp)
    80005b20:	640a                	ld	s0,128(sp)
    80005b22:	6149                	addi	sp,sp,144
    80005b24:	8082                	ret
    end_op();
    80005b26:	fffff097          	auipc	ra,0xfffff
    80005b2a:	820080e7          	jalr	-2016(ra) # 80004346 <end_op>
    return -1;
    80005b2e:	557d                	li	a0,-1
    80005b30:	b7fd                	j	80005b1e <sys_mkdir+0x4c>

0000000080005b32 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005b32:	7135                	addi	sp,sp,-160
    80005b34:	ed06                	sd	ra,152(sp)
    80005b36:	e922                	sd	s0,144(sp)
    80005b38:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005b3a:	ffffe097          	auipc	ra,0xffffe
    80005b3e:	78c080e7          	jalr	1932(ra) # 800042c6 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005b42:	08000613          	li	a2,128
    80005b46:	f7040593          	addi	a1,s0,-144
    80005b4a:	4501                	li	a0,0
    80005b4c:	ffffd097          	auipc	ra,0xffffd
    80005b50:	00e080e7          	jalr	14(ra) # 80002b5a <argstr>
    80005b54:	04054a63          	bltz	a0,80005ba8 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005b58:	f6c40593          	addi	a1,s0,-148
    80005b5c:	4505                	li	a0,1
    80005b5e:	ffffd097          	auipc	ra,0xffffd
    80005b62:	fb8080e7          	jalr	-72(ra) # 80002b16 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005b66:	04054163          	bltz	a0,80005ba8 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005b6a:	f6840593          	addi	a1,s0,-152
    80005b6e:	4509                	li	a0,2
    80005b70:	ffffd097          	auipc	ra,0xffffd
    80005b74:	fa6080e7          	jalr	-90(ra) # 80002b16 <argint>
     argint(1, &major) < 0 ||
    80005b78:	02054863          	bltz	a0,80005ba8 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005b7c:	f6841683          	lh	a3,-152(s0)
    80005b80:	f6c41603          	lh	a2,-148(s0)
    80005b84:	458d                	li	a1,3
    80005b86:	f7040513          	addi	a0,s0,-144
    80005b8a:	fffff097          	auipc	ra,0xfffff
    80005b8e:	6fc080e7          	jalr	1788(ra) # 80005286 <create>
     argint(2, &minor) < 0 ||
    80005b92:	c919                	beqz	a0,80005ba8 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005b94:	ffffe097          	auipc	ra,0xffffe
    80005b98:	f44080e7          	jalr	-188(ra) # 80003ad8 <iunlockput>
  end_op();
    80005b9c:	ffffe097          	auipc	ra,0xffffe
    80005ba0:	7aa080e7          	jalr	1962(ra) # 80004346 <end_op>
  return 0;
    80005ba4:	4501                	li	a0,0
    80005ba6:	a031                	j	80005bb2 <sys_mknod+0x80>
    end_op();
    80005ba8:	ffffe097          	auipc	ra,0xffffe
    80005bac:	79e080e7          	jalr	1950(ra) # 80004346 <end_op>
    return -1;
    80005bb0:	557d                	li	a0,-1
}
    80005bb2:	60ea                	ld	ra,152(sp)
    80005bb4:	644a                	ld	s0,144(sp)
    80005bb6:	610d                	addi	sp,sp,160
    80005bb8:	8082                	ret

0000000080005bba <sys_chdir>:

uint64
sys_chdir(void)
{
    80005bba:	7169                	addi	sp,sp,-304
    80005bbc:	f606                	sd	ra,296(sp)
    80005bbe:	f222                	sd	s0,288(sp)
    80005bc0:	ee26                	sd	s1,280(sp)
    80005bc2:	ea4a                	sd	s2,272(sp)
    80005bc4:	e64e                	sd	s3,264(sp)
    80005bc6:	e252                	sd	s4,256(sp)
    80005bc8:	1a00                	addi	s0,sp,304
  // You can modify this to cd into a symbolic link
  // The modification may not be necessary,
  // depending on you implementation.
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005bca:	ffffc097          	auipc	ra,0xffffc
    80005bce:	e8e080e7          	jalr	-370(ra) # 80001a58 <myproc>
    80005bd2:	89aa                	mv	s3,a0

  begin_op();
    80005bd4:	ffffe097          	auipc	ra,0xffffe
    80005bd8:	6f2080e7          	jalr	1778(ra) # 800042c6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005bdc:	08000613          	li	a2,128
    80005be0:	f5040593          	addi	a1,s0,-176
    80005be4:	4501                	li	a0,0
    80005be6:	ffffd097          	auipc	ra,0xffffd
    80005bea:	f74080e7          	jalr	-140(ra) # 80002b5a <argstr>
    80005bee:	06054263          	bltz	a0,80005c52 <sys_chdir+0x98>
    80005bf2:	f5040513          	addi	a0,s0,-176
    80005bf6:	ffffe097          	auipc	ra,0xffffe
    80005bfa:	2d8080e7          	jalr	728(ra) # 80003ece <namei>
    80005bfe:	84aa                	mv	s1,a0
    80005c00:	c929                	beqz	a0,80005c52 <sys_chdir+0x98>
    end_op();
    return -1;
  }
  ilock(ip);
    80005c02:	ffffe097          	auipc	ra,0xffffe
    80005c06:	bbc080e7          	jalr	-1092(ra) # 800037be <ilock>
  //為何需要檢查阿 namei(path)實該就會回傳不是link的ip了...
  if(ip->type == T_SYMLINK){
    80005c0a:	04449703          	lh	a4,68(s1)
    80005c0e:	4791                	li	a5,4
    80005c10:	04f70763          	beq	a4,a5,80005c5e <sys_chdir+0xa4>
      ilock(ip);
      depth ++;
    }
  }

  if(ip->type != T_DIR){
    80005c14:	04449703          	lh	a4,68(s1)
    80005c18:	4785                	li	a5,1
    80005c1a:	0af71763          	bne	a4,a5,80005cc8 <sys_chdir+0x10e>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005c1e:	8526                	mv	a0,s1
    80005c20:	ffffe097          	auipc	ra,0xffffe
    80005c24:	c62080e7          	jalr	-926(ra) # 80003882 <iunlock>
  iput(p->cwd);
    80005c28:	1509b503          	ld	a0,336(s3)
    80005c2c:	ffffe097          	auipc	ra,0xffffe
    80005c30:	e04080e7          	jalr	-508(ra) # 80003a30 <iput>
  end_op();
    80005c34:	ffffe097          	auipc	ra,0xffffe
    80005c38:	712080e7          	jalr	1810(ra) # 80004346 <end_op>
  p->cwd = ip;
    80005c3c:	1499b823          	sd	s1,336(s3)
  return 0;
    80005c40:	4501                	li	a0,0
}
    80005c42:	70b2                	ld	ra,296(sp)
    80005c44:	7412                	ld	s0,288(sp)
    80005c46:	64f2                	ld	s1,280(sp)
    80005c48:	6952                	ld	s2,272(sp)
    80005c4a:	69b2                	ld	s3,264(sp)
    80005c4c:	6a12                	ld	s4,256(sp)
    80005c4e:	6155                	addi	sp,sp,304
    80005c50:	8082                	ret
    end_op();
    80005c52:	ffffe097          	auipc	ra,0xffffe
    80005c56:	6f4080e7          	jalr	1780(ra) # 80004346 <end_op>
    return -1;
    80005c5a:	557d                	li	a0,-1
    80005c5c:	b7dd                	j	80005c42 <sys_chdir+0x88>
    80005c5e:	4929                	li	s2,10
    while(ip->type == T_SYMLINK){
    80005c60:	4a11                	li	s4,4
      readi(ip, 0, (uint64)target_path, 0, MAXPATH);
    80005c62:	08000713          	li	a4,128
    80005c66:	4681                	li	a3,0
    80005c68:	ed040613          	addi	a2,s0,-304
    80005c6c:	4581                	li	a1,0
    80005c6e:	8526                	mv	a0,s1
    80005c70:	ffffe097          	auipc	ra,0xffffe
    80005c74:	eba080e7          	jalr	-326(ra) # 80003b2a <readi>
      iunlockput(ip);
    80005c78:	8526                	mv	a0,s1
    80005c7a:	ffffe097          	auipc	ra,0xffffe
    80005c7e:	e5e080e7          	jalr	-418(ra) # 80003ad8 <iunlockput>
      if((ip = namei(target_path)) == 0){
    80005c82:	ed040513          	addi	a0,s0,-304
    80005c86:	ffffe097          	auipc	ra,0xffffe
    80005c8a:	248080e7          	jalr	584(ra) # 80003ece <namei>
    80005c8e:	84aa                	mv	s1,a0
    80005c90:	c51d                	beqz	a0,80005cbe <sys_chdir+0x104>
      ilock(ip);
    80005c92:	ffffe097          	auipc	ra,0xffffe
    80005c96:	b2c080e7          	jalr	-1236(ra) # 800037be <ilock>
    while(ip->type == T_SYMLINK){
    80005c9a:	04449783          	lh	a5,68(s1)
    80005c9e:	f7479be3          	bne	a5,s4,80005c14 <sys_chdir+0x5a>
      if(depth == 10){
    80005ca2:	397d                	addiw	s2,s2,-1
    80005ca4:	fa091fe3          	bnez	s2,80005c62 <sys_chdir+0xa8>
        iunlockput(ip);
    80005ca8:	8526                	mv	a0,s1
    80005caa:	ffffe097          	auipc	ra,0xffffe
    80005cae:	e2e080e7          	jalr	-466(ra) # 80003ad8 <iunlockput>
        end_op();
    80005cb2:	ffffe097          	auipc	ra,0xffffe
    80005cb6:	694080e7          	jalr	1684(ra) # 80004346 <end_op>
        return -1;
    80005cba:	557d                	li	a0,-1
    80005cbc:	b759                	j	80005c42 <sys_chdir+0x88>
        end_op();
    80005cbe:	ffffe097          	auipc	ra,0xffffe
    80005cc2:	688080e7          	jalr	1672(ra) # 80004346 <end_op>
        return -1;
    80005cc6:	bfd5                	j	80005cba <sys_chdir+0x100>
    iunlockput(ip);
    80005cc8:	8526                	mv	a0,s1
    80005cca:	ffffe097          	auipc	ra,0xffffe
    80005cce:	e0e080e7          	jalr	-498(ra) # 80003ad8 <iunlockput>
    end_op();
    80005cd2:	ffffe097          	auipc	ra,0xffffe
    80005cd6:	674080e7          	jalr	1652(ra) # 80004346 <end_op>
    return -1;
    80005cda:	557d                	li	a0,-1
    80005cdc:	b79d                	j	80005c42 <sys_chdir+0x88>

0000000080005cde <sys_exec>:

uint64
sys_exec(void)
{
    80005cde:	7145                	addi	sp,sp,-464
    80005ce0:	e786                	sd	ra,456(sp)
    80005ce2:	e3a2                	sd	s0,448(sp)
    80005ce4:	ff26                	sd	s1,440(sp)
    80005ce6:	fb4a                	sd	s2,432(sp)
    80005ce8:	f74e                	sd	s3,424(sp)
    80005cea:	f352                	sd	s4,416(sp)
    80005cec:	ef56                	sd	s5,408(sp)
    80005cee:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005cf0:	08000613          	li	a2,128
    80005cf4:	f4040593          	addi	a1,s0,-192
    80005cf8:	4501                	li	a0,0
    80005cfa:	ffffd097          	auipc	ra,0xffffd
    80005cfe:	e60080e7          	jalr	-416(ra) # 80002b5a <argstr>
    return -1;
    80005d02:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005d04:	0e054c63          	bltz	a0,80005dfc <sys_exec+0x11e>
    80005d08:	e3840593          	addi	a1,s0,-456
    80005d0c:	4505                	li	a0,1
    80005d0e:	ffffd097          	auipc	ra,0xffffd
    80005d12:	e2a080e7          	jalr	-470(ra) # 80002b38 <argaddr>
    80005d16:	0e054363          	bltz	a0,80005dfc <sys_exec+0x11e>
  }
  memset(argv, 0, sizeof(argv));
    80005d1a:	e4040913          	addi	s2,s0,-448
    80005d1e:	10000613          	li	a2,256
    80005d22:	4581                	li	a1,0
    80005d24:	854a                	mv	a0,s2
    80005d26:	ffffb097          	auipc	ra,0xffffb
    80005d2a:	ff6080e7          	jalr	-10(ra) # 80000d1c <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005d2e:	89ca                	mv	s3,s2
  memset(argv, 0, sizeof(argv));
    80005d30:	4481                	li	s1,0
    if(i >= NELEM(argv)){
    80005d32:	02000a93          	li	s5,32
    80005d36:	00048a1b          	sext.w	s4,s1
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005d3a:	00349513          	slli	a0,s1,0x3
    80005d3e:	e3040593          	addi	a1,s0,-464
    80005d42:	e3843783          	ld	a5,-456(s0)
    80005d46:	953e                	add	a0,a0,a5
    80005d48:	ffffd097          	auipc	ra,0xffffd
    80005d4c:	d32080e7          	jalr	-718(ra) # 80002a7a <fetchaddr>
    80005d50:	02054a63          	bltz	a0,80005d84 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80005d54:	e3043783          	ld	a5,-464(s0)
    80005d58:	cfa9                	beqz	a5,80005db2 <sys_exec+0xd4>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005d5a:	ffffb097          	auipc	ra,0xffffb
    80005d5e:	dd6080e7          	jalr	-554(ra) # 80000b30 <kalloc>
    80005d62:	00a93023          	sd	a0,0(s2)
    if(argv[i] == 0)
    80005d66:	cd19                	beqz	a0,80005d84 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005d68:	6605                	lui	a2,0x1
    80005d6a:	85aa                	mv	a1,a0
    80005d6c:	e3043503          	ld	a0,-464(s0)
    80005d70:	ffffd097          	auipc	ra,0xffffd
    80005d74:	d5e080e7          	jalr	-674(ra) # 80002ace <fetchstr>
    80005d78:	00054663          	bltz	a0,80005d84 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80005d7c:	0485                	addi	s1,s1,1
    80005d7e:	0921                	addi	s2,s2,8
    80005d80:	fb549be3          	bne	s1,s5,80005d36 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d84:	e4043503          	ld	a0,-448(s0)
    kfree(argv[i]);
  return -1;
    80005d88:	597d                	li	s2,-1
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d8a:	c92d                	beqz	a0,80005dfc <sys_exec+0x11e>
    kfree(argv[i]);
    80005d8c:	ffffb097          	auipc	ra,0xffffb
    80005d90:	ca4080e7          	jalr	-860(ra) # 80000a30 <kfree>
    80005d94:	e4840493          	addi	s1,s0,-440
    80005d98:	10098993          	addi	s3,s3,256
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d9c:	6088                	ld	a0,0(s1)
    80005d9e:	cd31                	beqz	a0,80005dfa <sys_exec+0x11c>
    kfree(argv[i]);
    80005da0:	ffffb097          	auipc	ra,0xffffb
    80005da4:	c90080e7          	jalr	-880(ra) # 80000a30 <kfree>
    80005da8:	04a1                	addi	s1,s1,8
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005daa:	ff3499e3          	bne	s1,s3,80005d9c <sys_exec+0xbe>
  return -1;
    80005dae:	597d                	li	s2,-1
    80005db0:	a0b1                	j	80005dfc <sys_exec+0x11e>
      argv[i] = 0;
    80005db2:	0a0e                	slli	s4,s4,0x3
    80005db4:	fc040793          	addi	a5,s0,-64
    80005db8:	9a3e                	add	s4,s4,a5
    80005dba:	e80a3023          	sd	zero,-384(s4)
  int ret = exec(path, argv);
    80005dbe:	e4040593          	addi	a1,s0,-448
    80005dc2:	f4040513          	addi	a0,s0,-192
    80005dc6:	fffff097          	auipc	ra,0xfffff
    80005dca:	06c080e7          	jalr	108(ra) # 80004e32 <exec>
    80005dce:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005dd0:	e4043503          	ld	a0,-448(s0)
    80005dd4:	c505                	beqz	a0,80005dfc <sys_exec+0x11e>
    kfree(argv[i]);
    80005dd6:	ffffb097          	auipc	ra,0xffffb
    80005dda:	c5a080e7          	jalr	-934(ra) # 80000a30 <kfree>
    80005dde:	e4840493          	addi	s1,s0,-440
    80005de2:	10098993          	addi	s3,s3,256
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005de6:	6088                	ld	a0,0(s1)
    80005de8:	c911                	beqz	a0,80005dfc <sys_exec+0x11e>
    kfree(argv[i]);
    80005dea:	ffffb097          	auipc	ra,0xffffb
    80005dee:	c46080e7          	jalr	-954(ra) # 80000a30 <kfree>
    80005df2:	04a1                	addi	s1,s1,8
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005df4:	ff3499e3          	bne	s1,s3,80005de6 <sys_exec+0x108>
    80005df8:	a011                	j	80005dfc <sys_exec+0x11e>
  return -1;
    80005dfa:	597d                	li	s2,-1
}
    80005dfc:	854a                	mv	a0,s2
    80005dfe:	60be                	ld	ra,456(sp)
    80005e00:	641e                	ld	s0,448(sp)
    80005e02:	74fa                	ld	s1,440(sp)
    80005e04:	795a                	ld	s2,432(sp)
    80005e06:	79ba                	ld	s3,424(sp)
    80005e08:	7a1a                	ld	s4,416(sp)
    80005e0a:	6afa                	ld	s5,408(sp)
    80005e0c:	6179                	addi	sp,sp,464
    80005e0e:	8082                	ret

0000000080005e10 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005e10:	7139                	addi	sp,sp,-64
    80005e12:	fc06                	sd	ra,56(sp)
    80005e14:	f822                	sd	s0,48(sp)
    80005e16:	f426                	sd	s1,40(sp)
    80005e18:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005e1a:	ffffc097          	auipc	ra,0xffffc
    80005e1e:	c3e080e7          	jalr	-962(ra) # 80001a58 <myproc>
    80005e22:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005e24:	fd840593          	addi	a1,s0,-40
    80005e28:	4501                	li	a0,0
    80005e2a:	ffffd097          	auipc	ra,0xffffd
    80005e2e:	d0e080e7          	jalr	-754(ra) # 80002b38 <argaddr>
    return -1;
    80005e32:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005e34:	0c054f63          	bltz	a0,80005f12 <sys_pipe+0x102>
  if(pipealloc(&rf, &wf) < 0)
    80005e38:	fc840593          	addi	a1,s0,-56
    80005e3c:	fd040513          	addi	a0,s0,-48
    80005e40:	fffff097          	auipc	ra,0xfffff
    80005e44:	ca4080e7          	jalr	-860(ra) # 80004ae4 <pipealloc>
    return -1;
    80005e48:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005e4a:	0c054463          	bltz	a0,80005f12 <sys_pipe+0x102>
  fd0 = -1;
    80005e4e:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005e52:	fd043503          	ld	a0,-48(s0)
    80005e56:	fffff097          	auipc	ra,0xfffff
    80005e5a:	3e8080e7          	jalr	1000(ra) # 8000523e <fdalloc>
    80005e5e:	fca42223          	sw	a0,-60(s0)
    80005e62:	08054b63          	bltz	a0,80005ef8 <sys_pipe+0xe8>
    80005e66:	fc843503          	ld	a0,-56(s0)
    80005e6a:	fffff097          	auipc	ra,0xfffff
    80005e6e:	3d4080e7          	jalr	980(ra) # 8000523e <fdalloc>
    80005e72:	fca42023          	sw	a0,-64(s0)
    80005e76:	06054863          	bltz	a0,80005ee6 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005e7a:	4691                	li	a3,4
    80005e7c:	fc440613          	addi	a2,s0,-60
    80005e80:	fd843583          	ld	a1,-40(s0)
    80005e84:	68a8                	ld	a0,80(s1)
    80005e86:	ffffc097          	auipc	ra,0xffffc
    80005e8a:	87c080e7          	jalr	-1924(ra) # 80001702 <copyout>
    80005e8e:	02054063          	bltz	a0,80005eae <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005e92:	4691                	li	a3,4
    80005e94:	fc040613          	addi	a2,s0,-64
    80005e98:	fd843583          	ld	a1,-40(s0)
    80005e9c:	0591                	addi	a1,a1,4
    80005e9e:	68a8                	ld	a0,80(s1)
    80005ea0:	ffffc097          	auipc	ra,0xffffc
    80005ea4:	862080e7          	jalr	-1950(ra) # 80001702 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005ea8:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005eaa:	06055463          	bgez	a0,80005f12 <sys_pipe+0x102>
    p->ofile[fd0] = 0;
    80005eae:	fc442783          	lw	a5,-60(s0)
    80005eb2:	07e9                	addi	a5,a5,26
    80005eb4:	078e                	slli	a5,a5,0x3
    80005eb6:	97a6                	add	a5,a5,s1
    80005eb8:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005ebc:	fc042783          	lw	a5,-64(s0)
    80005ec0:	07e9                	addi	a5,a5,26
    80005ec2:	078e                	slli	a5,a5,0x3
    80005ec4:	94be                	add	s1,s1,a5
    80005ec6:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005eca:	fd043503          	ld	a0,-48(s0)
    80005ece:	fffff097          	auipc	ra,0xfffff
    80005ed2:	8f2080e7          	jalr	-1806(ra) # 800047c0 <fileclose>
    fileclose(wf);
    80005ed6:	fc843503          	ld	a0,-56(s0)
    80005eda:	fffff097          	auipc	ra,0xfffff
    80005ede:	8e6080e7          	jalr	-1818(ra) # 800047c0 <fileclose>
    return -1;
    80005ee2:	57fd                	li	a5,-1
    80005ee4:	a03d                	j	80005f12 <sys_pipe+0x102>
    if(fd0 >= 0)
    80005ee6:	fc442783          	lw	a5,-60(s0)
    80005eea:	0007c763          	bltz	a5,80005ef8 <sys_pipe+0xe8>
      p->ofile[fd0] = 0;
    80005eee:	07e9                	addi	a5,a5,26
    80005ef0:	078e                	slli	a5,a5,0x3
    80005ef2:	94be                	add	s1,s1,a5
    80005ef4:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005ef8:	fd043503          	ld	a0,-48(s0)
    80005efc:	fffff097          	auipc	ra,0xfffff
    80005f00:	8c4080e7          	jalr	-1852(ra) # 800047c0 <fileclose>
    fileclose(wf);
    80005f04:	fc843503          	ld	a0,-56(s0)
    80005f08:	fffff097          	auipc	ra,0xfffff
    80005f0c:	8b8080e7          	jalr	-1864(ra) # 800047c0 <fileclose>
    return -1;
    80005f10:	57fd                	li	a5,-1
}
    80005f12:	853e                	mv	a0,a5
    80005f14:	70e2                	ld	ra,56(sp)
    80005f16:	7442                	ld	s0,48(sp)
    80005f18:	74a2                	ld	s1,40(sp)
    80005f1a:	6121                	addi	sp,sp,64
    80005f1c:	8082                	ret

0000000080005f1e <sys_symlink>:

uint64
sys_symlink(void)
{
    80005f1e:	712d                	addi	sp,sp,-288
    80005f20:	ee06                	sd	ra,280(sp)
    80005f22:	ea22                	sd	s0,272(sp)
    80005f24:	e626                	sd	s1,264(sp)
    80005f26:	1200                	addi	s0,sp,288
  char target[MAXPATH], path[MAXPATH];
  // int fd; // why I need this???
  // struct file *f;
  struct inode *ip;

  if(argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0)
    80005f28:	08000613          	li	a2,128
    80005f2c:	f6040593          	addi	a1,s0,-160
    80005f30:	4501                	li	a0,0
    80005f32:	ffffd097          	auipc	ra,0xffffd
    80005f36:	c28080e7          	jalr	-984(ra) # 80002b5a <argstr>
    return -1;
    80005f3a:	57fd                	li	a5,-1
  if(argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0)
    80005f3c:	06054163          	bltz	a0,80005f9e <sys_symlink+0x80>
    80005f40:	08000613          	li	a2,128
    80005f44:	ee040593          	addi	a1,s0,-288
    80005f48:	4505                	li	a0,1
    80005f4a:	ffffd097          	auipc	ra,0xffffd
    80005f4e:	c10080e7          	jalr	-1008(ra) # 80002b5a <argstr>
    return -1;
    80005f52:	57fd                	li	a5,-1
  if(argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0)
    80005f54:	04054563          	bltz	a0,80005f9e <sys_symlink+0x80>

  begin_op();
    80005f58:	ffffe097          	auipc	ra,0xffffe
    80005f5c:	36e080e7          	jalr	878(ra) # 800042c6 <begin_op>
  ip = create(path, T_SYMLINK, 0, 0);
    80005f60:	4681                	li	a3,0
    80005f62:	4601                	li	a2,0
    80005f64:	4591                	li	a1,4
    80005f66:	ee040513          	addi	a0,s0,-288
    80005f6a:	fffff097          	auipc	ra,0xfffff
    80005f6e:	31c080e7          	jalr	796(ra) # 80005286 <create>
    80005f72:	84aa                	mv	s1,a0
  if(ip == 0){
    80005f74:	c91d                	beqz	a0,80005faa <sys_symlink+0x8c>

  // printf("**** <symlink> writing the target path...");
  // if(filewrite(f, (uint64)target, MAXPATH) < 0)
  //   return -1;
  uint64 addr = (uint64)target;
  writei(ip, 0, addr, 0, MAXPATH); // MAXPATH won't exceed maximum log transaction size. only one writei() is o.k.
    80005f76:	08000713          	li	a4,128
    80005f7a:	4681                	li	a3,0
    80005f7c:	f6040613          	addi	a2,s0,-160
    80005f80:	4581                	li	a1,0
    80005f82:	ffffe097          	auipc	ra,0xffffe
    80005f86:	ca0080e7          	jalr	-864(ra) # 80003c22 <writei>

  // printf("done.\n");
  iunlock(ip);
    80005f8a:	8526                	mv	a0,s1
    80005f8c:	ffffe097          	auipc	ra,0xffffe
    80005f90:	8f6080e7          	jalr	-1802(ra) # 80003882 <iunlock>
  end_op();
    80005f94:	ffffe097          	auipc	ra,0xffffe
    80005f98:	3b2080e7          	jalr	946(ra) # 80004346 <end_op>
  return 0;
    80005f9c:	4781                	li	a5,0
    80005f9e:	853e                	mv	a0,a5
    80005fa0:	60f2                	ld	ra,280(sp)
    80005fa2:	6452                	ld	s0,272(sp)
    80005fa4:	64b2                	ld	s1,264(sp)
    80005fa6:	6115                	addi	sp,sp,288
    80005fa8:	8082                	ret
    end_op();
    80005faa:	ffffe097          	auipc	ra,0xffffe
    80005fae:	39c080e7          	jalr	924(ra) # 80004346 <end_op>
    return -1;
    80005fb2:	57fd                	li	a5,-1
    80005fb4:	b7ed                	j	80005f9e <sys_symlink+0x80>
	...

0000000080005fc0 <kernelvec>:
    80005fc0:	7111                	addi	sp,sp,-256
    80005fc2:	e006                	sd	ra,0(sp)
    80005fc4:	e40a                	sd	sp,8(sp)
    80005fc6:	e80e                	sd	gp,16(sp)
    80005fc8:	ec12                	sd	tp,24(sp)
    80005fca:	f016                	sd	t0,32(sp)
    80005fcc:	f41a                	sd	t1,40(sp)
    80005fce:	f81e                	sd	t2,48(sp)
    80005fd0:	fc22                	sd	s0,56(sp)
    80005fd2:	e0a6                	sd	s1,64(sp)
    80005fd4:	e4aa                	sd	a0,72(sp)
    80005fd6:	e8ae                	sd	a1,80(sp)
    80005fd8:	ecb2                	sd	a2,88(sp)
    80005fda:	f0b6                	sd	a3,96(sp)
    80005fdc:	f4ba                	sd	a4,104(sp)
    80005fde:	f8be                	sd	a5,112(sp)
    80005fe0:	fcc2                	sd	a6,120(sp)
    80005fe2:	e146                	sd	a7,128(sp)
    80005fe4:	e54a                	sd	s2,136(sp)
    80005fe6:	e94e                	sd	s3,144(sp)
    80005fe8:	ed52                	sd	s4,152(sp)
    80005fea:	f156                	sd	s5,160(sp)
    80005fec:	f55a                	sd	s6,168(sp)
    80005fee:	f95e                	sd	s7,176(sp)
    80005ff0:	fd62                	sd	s8,184(sp)
    80005ff2:	e1e6                	sd	s9,192(sp)
    80005ff4:	e5ea                	sd	s10,200(sp)
    80005ff6:	e9ee                	sd	s11,208(sp)
    80005ff8:	edf2                	sd	t3,216(sp)
    80005ffa:	f1f6                	sd	t4,224(sp)
    80005ffc:	f5fa                	sd	t5,232(sp)
    80005ffe:	f9fe                	sd	t6,240(sp)
    80006000:	943fc0ef          	jal	ra,80002942 <kerneltrap>
    80006004:	6082                	ld	ra,0(sp)
    80006006:	6122                	ld	sp,8(sp)
    80006008:	61c2                	ld	gp,16(sp)
    8000600a:	7282                	ld	t0,32(sp)
    8000600c:	7322                	ld	t1,40(sp)
    8000600e:	73c2                	ld	t2,48(sp)
    80006010:	7462                	ld	s0,56(sp)
    80006012:	6486                	ld	s1,64(sp)
    80006014:	6526                	ld	a0,72(sp)
    80006016:	65c6                	ld	a1,80(sp)
    80006018:	6666                	ld	a2,88(sp)
    8000601a:	7686                	ld	a3,96(sp)
    8000601c:	7726                	ld	a4,104(sp)
    8000601e:	77c6                	ld	a5,112(sp)
    80006020:	7866                	ld	a6,120(sp)
    80006022:	688a                	ld	a7,128(sp)
    80006024:	692a                	ld	s2,136(sp)
    80006026:	69ca                	ld	s3,144(sp)
    80006028:	6a6a                	ld	s4,152(sp)
    8000602a:	7a8a                	ld	s5,160(sp)
    8000602c:	7b2a                	ld	s6,168(sp)
    8000602e:	7bca                	ld	s7,176(sp)
    80006030:	7c6a                	ld	s8,184(sp)
    80006032:	6c8e                	ld	s9,192(sp)
    80006034:	6d2e                	ld	s10,200(sp)
    80006036:	6dce                	ld	s11,208(sp)
    80006038:	6e6e                	ld	t3,216(sp)
    8000603a:	7e8e                	ld	t4,224(sp)
    8000603c:	7f2e                	ld	t5,232(sp)
    8000603e:	7fce                	ld	t6,240(sp)
    80006040:	6111                	addi	sp,sp,256
    80006042:	10200073          	sret
    80006046:	00000013          	nop
    8000604a:	00000013          	nop
    8000604e:	0001                	nop

0000000080006050 <timervec>:
    80006050:	34051573          	csrrw	a0,mscratch,a0
    80006054:	e10c                	sd	a1,0(a0)
    80006056:	e510                	sd	a2,8(a0)
    80006058:	e914                	sd	a3,16(a0)
    8000605a:	6d0c                	ld	a1,24(a0)
    8000605c:	7110                	ld	a2,32(a0)
    8000605e:	6194                	ld	a3,0(a1)
    80006060:	96b2                	add	a3,a3,a2
    80006062:	e194                	sd	a3,0(a1)
    80006064:	4589                	li	a1,2
    80006066:	14459073          	csrw	sip,a1
    8000606a:	6914                	ld	a3,16(a0)
    8000606c:	6510                	ld	a2,8(a0)
    8000606e:	610c                	ld	a1,0(a0)
    80006070:	34051573          	csrrw	a0,mscratch,a0
    80006074:	30200073          	mret
	...

000000008000607a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000607a:	1141                	addi	sp,sp,-16
    8000607c:	e422                	sd	s0,8(sp)
    8000607e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006080:	0c0007b7          	lui	a5,0xc000
    80006084:	4705                	li	a4,1
    80006086:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006088:	c3d8                	sw	a4,4(a5)
}
    8000608a:	6422                	ld	s0,8(sp)
    8000608c:	0141                	addi	sp,sp,16
    8000608e:	8082                	ret

0000000080006090 <plicinithart>:

void
plicinithart(void)
{
    80006090:	1141                	addi	sp,sp,-16
    80006092:	e406                	sd	ra,8(sp)
    80006094:	e022                	sd	s0,0(sp)
    80006096:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006098:	ffffc097          	auipc	ra,0xffffc
    8000609c:	994080e7          	jalr	-1644(ra) # 80001a2c <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800060a0:	0085171b          	slliw	a4,a0,0x8
    800060a4:	0c0027b7          	lui	a5,0xc002
    800060a8:	97ba                	add	a5,a5,a4
    800060aa:	40200713          	li	a4,1026
    800060ae:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800060b2:	00d5151b          	slliw	a0,a0,0xd
    800060b6:	0c2017b7          	lui	a5,0xc201
    800060ba:	953e                	add	a0,a0,a5
    800060bc:	00052023          	sw	zero,0(a0)
}
    800060c0:	60a2                	ld	ra,8(sp)
    800060c2:	6402                	ld	s0,0(sp)
    800060c4:	0141                	addi	sp,sp,16
    800060c6:	8082                	ret

00000000800060c8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800060c8:	1141                	addi	sp,sp,-16
    800060ca:	e406                	sd	ra,8(sp)
    800060cc:	e022                	sd	s0,0(sp)
    800060ce:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800060d0:	ffffc097          	auipc	ra,0xffffc
    800060d4:	95c080e7          	jalr	-1700(ra) # 80001a2c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800060d8:	00d5151b          	slliw	a0,a0,0xd
    800060dc:	0c2017b7          	lui	a5,0xc201
    800060e0:	97aa                	add	a5,a5,a0
  return irq;
}
    800060e2:	43c8                	lw	a0,4(a5)
    800060e4:	60a2                	ld	ra,8(sp)
    800060e6:	6402                	ld	s0,0(sp)
    800060e8:	0141                	addi	sp,sp,16
    800060ea:	8082                	ret

00000000800060ec <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800060ec:	1101                	addi	sp,sp,-32
    800060ee:	ec06                	sd	ra,24(sp)
    800060f0:	e822                	sd	s0,16(sp)
    800060f2:	e426                	sd	s1,8(sp)
    800060f4:	1000                	addi	s0,sp,32
    800060f6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800060f8:	ffffc097          	auipc	ra,0xffffc
    800060fc:	934080e7          	jalr	-1740(ra) # 80001a2c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006100:	00d5151b          	slliw	a0,a0,0xd
    80006104:	0c2017b7          	lui	a5,0xc201
    80006108:	97aa                	add	a5,a5,a0
    8000610a:	c3c4                	sw	s1,4(a5)
}
    8000610c:	60e2                	ld	ra,24(sp)
    8000610e:	6442                	ld	s0,16(sp)
    80006110:	64a2                	ld	s1,8(sp)
    80006112:	6105                	addi	sp,sp,32
    80006114:	8082                	ret

0000000080006116 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006116:	1141                	addi	sp,sp,-16
    80006118:	e406                	sd	ra,8(sp)
    8000611a:	e022                	sd	s0,0(sp)
    8000611c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000611e:	479d                	li	a5,7
    80006120:	06a7c963          	blt	a5,a0,80006192 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80006124:	0001d797          	auipc	a5,0x1d
    80006128:	edc78793          	addi	a5,a5,-292 # 80023000 <disk>
    8000612c:	00a78733          	add	a4,a5,a0
    80006130:	6789                	lui	a5,0x2
    80006132:	97ba                	add	a5,a5,a4
    80006134:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80006138:	e7ad                	bnez	a5,800061a2 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000613a:	00451793          	slli	a5,a0,0x4
    8000613e:	0001f717          	auipc	a4,0x1f
    80006142:	ec270713          	addi	a4,a4,-318 # 80025000 <disk+0x2000>
    80006146:	6314                	ld	a3,0(a4)
    80006148:	96be                	add	a3,a3,a5
    8000614a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000614e:	6314                	ld	a3,0(a4)
    80006150:	96be                	add	a3,a3,a5
    80006152:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80006156:	6314                	ld	a3,0(a4)
    80006158:	96be                	add	a3,a3,a5
    8000615a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000615e:	6318                	ld	a4,0(a4)
    80006160:	97ba                	add	a5,a5,a4
    80006162:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80006166:	0001d797          	auipc	a5,0x1d
    8000616a:	e9a78793          	addi	a5,a5,-358 # 80023000 <disk>
    8000616e:	97aa                	add	a5,a5,a0
    80006170:	6509                	lui	a0,0x2
    80006172:	953e                	add	a0,a0,a5
    80006174:	4785                	li	a5,1
    80006176:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000617a:	0001f517          	auipc	a0,0x1f
    8000617e:	e9e50513          	addi	a0,a0,-354 # 80025018 <disk+0x2018>
    80006182:	ffffc097          	auipc	ra,0xffffc
    80006186:	126080e7          	jalr	294(ra) # 800022a8 <wakeup>
}
    8000618a:	60a2                	ld	ra,8(sp)
    8000618c:	6402                	ld	s0,0(sp)
    8000618e:	0141                	addi	sp,sp,16
    80006190:	8082                	ret
    panic("free_desc 1");
    80006192:	00002517          	auipc	a0,0x2
    80006196:	5ce50513          	addi	a0,a0,1486 # 80008760 <syscalls+0x358>
    8000619a:	ffffa097          	auipc	ra,0xffffa
    8000619e:	3be080e7          	jalr	958(ra) # 80000558 <panic>
    panic("free_desc 2");
    800061a2:	00002517          	auipc	a0,0x2
    800061a6:	5ce50513          	addi	a0,a0,1486 # 80008770 <syscalls+0x368>
    800061aa:	ffffa097          	auipc	ra,0xffffa
    800061ae:	3ae080e7          	jalr	942(ra) # 80000558 <panic>

00000000800061b2 <virtio_disk_init>:
{
    800061b2:	1101                	addi	sp,sp,-32
    800061b4:	ec06                	sd	ra,24(sp)
    800061b6:	e822                	sd	s0,16(sp)
    800061b8:	e426                	sd	s1,8(sp)
    800061ba:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800061bc:	00002597          	auipc	a1,0x2
    800061c0:	5c458593          	addi	a1,a1,1476 # 80008780 <syscalls+0x378>
    800061c4:	0001f517          	auipc	a0,0x1f
    800061c8:	f6450513          	addi	a0,a0,-156 # 80025128 <disk+0x2128>
    800061cc:	ffffb097          	auipc	ra,0xffffb
    800061d0:	9c4080e7          	jalr	-1596(ra) # 80000b90 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800061d4:	100017b7          	lui	a5,0x10001
    800061d8:	4398                	lw	a4,0(a5)
    800061da:	2701                	sext.w	a4,a4
    800061dc:	747277b7          	lui	a5,0x74727
    800061e0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800061e4:	0ef71163          	bne	a4,a5,800062c6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800061e8:	100017b7          	lui	a5,0x10001
    800061ec:	43dc                	lw	a5,4(a5)
    800061ee:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800061f0:	4705                	li	a4,1
    800061f2:	0ce79a63          	bne	a5,a4,800062c6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800061f6:	100017b7          	lui	a5,0x10001
    800061fa:	479c                	lw	a5,8(a5)
    800061fc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800061fe:	4709                	li	a4,2
    80006200:	0ce79363          	bne	a5,a4,800062c6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006204:	100017b7          	lui	a5,0x10001
    80006208:	47d8                	lw	a4,12(a5)
    8000620a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000620c:	554d47b7          	lui	a5,0x554d4
    80006210:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006214:	0af71963          	bne	a4,a5,800062c6 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006218:	100017b7          	lui	a5,0x10001
    8000621c:	4705                	li	a4,1
    8000621e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006220:	470d                	li	a4,3
    80006222:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006224:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006226:	c7ffe737          	lui	a4,0xc7ffe
    8000622a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd875f>
    8000622e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006230:	2701                	sext.w	a4,a4
    80006232:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006234:	472d                	li	a4,11
    80006236:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006238:	473d                	li	a4,15
    8000623a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000623c:	6705                	lui	a4,0x1
    8000623e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006240:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006244:	5bdc                	lw	a5,52(a5)
    80006246:	2781                	sext.w	a5,a5
  if(max == 0)
    80006248:	c7d9                	beqz	a5,800062d6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000624a:	471d                	li	a4,7
    8000624c:	08f77d63          	bleu	a5,a4,800062e6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006250:	100014b7          	lui	s1,0x10001
    80006254:	47a1                	li	a5,8
    80006256:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80006258:	6609                	lui	a2,0x2
    8000625a:	4581                	li	a1,0
    8000625c:	0001d517          	auipc	a0,0x1d
    80006260:	da450513          	addi	a0,a0,-604 # 80023000 <disk>
    80006264:	ffffb097          	auipc	ra,0xffffb
    80006268:	ab8080e7          	jalr	-1352(ra) # 80000d1c <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000626c:	0001d717          	auipc	a4,0x1d
    80006270:	d9470713          	addi	a4,a4,-620 # 80023000 <disk>
    80006274:	00c75793          	srli	a5,a4,0xc
    80006278:	2781                	sext.w	a5,a5
    8000627a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000627c:	0001f797          	auipc	a5,0x1f
    80006280:	d8478793          	addi	a5,a5,-636 # 80025000 <disk+0x2000>
    80006284:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80006286:	0001d717          	auipc	a4,0x1d
    8000628a:	dfa70713          	addi	a4,a4,-518 # 80023080 <disk+0x80>
    8000628e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80006290:	0001e717          	auipc	a4,0x1e
    80006294:	d7070713          	addi	a4,a4,-656 # 80024000 <disk+0x1000>
    80006298:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000629a:	4705                	li	a4,1
    8000629c:	00e78c23          	sb	a4,24(a5)
    800062a0:	00e78ca3          	sb	a4,25(a5)
    800062a4:	00e78d23          	sb	a4,26(a5)
    800062a8:	00e78da3          	sb	a4,27(a5)
    800062ac:	00e78e23          	sb	a4,28(a5)
    800062b0:	00e78ea3          	sb	a4,29(a5)
    800062b4:	00e78f23          	sb	a4,30(a5)
    800062b8:	00e78fa3          	sb	a4,31(a5)
}
    800062bc:	60e2                	ld	ra,24(sp)
    800062be:	6442                	ld	s0,16(sp)
    800062c0:	64a2                	ld	s1,8(sp)
    800062c2:	6105                	addi	sp,sp,32
    800062c4:	8082                	ret
    panic("could not find virtio disk");
    800062c6:	00002517          	auipc	a0,0x2
    800062ca:	4ca50513          	addi	a0,a0,1226 # 80008790 <syscalls+0x388>
    800062ce:	ffffa097          	auipc	ra,0xffffa
    800062d2:	28a080e7          	jalr	650(ra) # 80000558 <panic>
    panic("virtio disk has no queue 0");
    800062d6:	00002517          	auipc	a0,0x2
    800062da:	4da50513          	addi	a0,a0,1242 # 800087b0 <syscalls+0x3a8>
    800062de:	ffffa097          	auipc	ra,0xffffa
    800062e2:	27a080e7          	jalr	634(ra) # 80000558 <panic>
    panic("virtio disk max queue too short");
    800062e6:	00002517          	auipc	a0,0x2
    800062ea:	4ea50513          	addi	a0,a0,1258 # 800087d0 <syscalls+0x3c8>
    800062ee:	ffffa097          	auipc	ra,0xffffa
    800062f2:	26a080e7          	jalr	618(ra) # 80000558 <panic>

00000000800062f6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800062f6:	711d                	addi	sp,sp,-96
    800062f8:	ec86                	sd	ra,88(sp)
    800062fa:	e8a2                	sd	s0,80(sp)
    800062fc:	e4a6                	sd	s1,72(sp)
    800062fe:	e0ca                	sd	s2,64(sp)
    80006300:	fc4e                	sd	s3,56(sp)
    80006302:	f852                	sd	s4,48(sp)
    80006304:	f456                	sd	s5,40(sp)
    80006306:	f05a                	sd	s6,32(sp)
    80006308:	ec5e                	sd	s7,24(sp)
    8000630a:	e862                	sd	s8,16(sp)
    8000630c:	1080                	addi	s0,sp,96
    8000630e:	892a                	mv	s2,a0
    80006310:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006312:	00c52b83          	lw	s7,12(a0)
    80006316:	001b9b9b          	slliw	s7,s7,0x1
    8000631a:	1b82                	slli	s7,s7,0x20
    8000631c:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80006320:	0001f517          	auipc	a0,0x1f
    80006324:	e0850513          	addi	a0,a0,-504 # 80025128 <disk+0x2128>
    80006328:	ffffb097          	auipc	ra,0xffffb
    8000632c:	8f8080e7          	jalr	-1800(ra) # 80000c20 <acquire>
    if(disk.free[i]){
    80006330:	0001f997          	auipc	s3,0x1f
    80006334:	cd098993          	addi	s3,s3,-816 # 80025000 <disk+0x2000>
  for(int i = 0; i < NUM; i++){
    80006338:	4b21                	li	s6,8
      disk.free[i] = 0;
    8000633a:	0001da97          	auipc	s5,0x1d
    8000633e:	cc6a8a93          	addi	s5,s5,-826 # 80023000 <disk>
  for(int i = 0; i < 3; i++){
    80006342:	4a0d                	li	s4,3
    80006344:	a079                	j	800063d2 <virtio_disk_rw+0xdc>
      disk.free[i] = 0;
    80006346:	00fa86b3          	add	a3,s5,a5
    8000634a:	96ae                	add	a3,a3,a1
    8000634c:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80006350:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80006352:	0207ca63          	bltz	a5,80006386 <virtio_disk_rw+0x90>
  for(int i = 0; i < 3; i++){
    80006356:	2485                	addiw	s1,s1,1
    80006358:	0711                	addi	a4,a4,4
    8000635a:	25448b63          	beq	s1,s4,800065b0 <virtio_disk_rw+0x2ba>
    idx[i] = alloc_desc();
    8000635e:	863a                	mv	a2,a4
    if(disk.free[i]){
    80006360:	0189c783          	lbu	a5,24(s3)
    80006364:	26079e63          	bnez	a5,800065e0 <virtio_disk_rw+0x2ea>
    80006368:	0001f697          	auipc	a3,0x1f
    8000636c:	cb168693          	addi	a3,a3,-847 # 80025019 <disk+0x2019>
  for(int i = 0; i < NUM; i++){
    80006370:	87aa                	mv	a5,a0
    if(disk.free[i]){
    80006372:	0006c803          	lbu	a6,0(a3)
    80006376:	fc0818e3          	bnez	a6,80006346 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    8000637a:	2785                	addiw	a5,a5,1
    8000637c:	0685                	addi	a3,a3,1
    8000637e:	ff679ae3          	bne	a5,s6,80006372 <virtio_disk_rw+0x7c>
    idx[i] = alloc_desc();
    80006382:	57fd                	li	a5,-1
    80006384:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80006386:	02905a63          	blez	s1,800063ba <virtio_disk_rw+0xc4>
        free_desc(idx[j]);
    8000638a:	fa042503          	lw	a0,-96(s0)
    8000638e:	00000097          	auipc	ra,0x0
    80006392:	d88080e7          	jalr	-632(ra) # 80006116 <free_desc>
      for(int j = 0; j < i; j++)
    80006396:	4785                	li	a5,1
    80006398:	0297d163          	ble	s1,a5,800063ba <virtio_disk_rw+0xc4>
        free_desc(idx[j]);
    8000639c:	fa442503          	lw	a0,-92(s0)
    800063a0:	00000097          	auipc	ra,0x0
    800063a4:	d76080e7          	jalr	-650(ra) # 80006116 <free_desc>
      for(int j = 0; j < i; j++)
    800063a8:	4789                	li	a5,2
    800063aa:	0097d863          	ble	s1,a5,800063ba <virtio_disk_rw+0xc4>
        free_desc(idx[j]);
    800063ae:	fa842503          	lw	a0,-88(s0)
    800063b2:	00000097          	auipc	ra,0x0
    800063b6:	d64080e7          	jalr	-668(ra) # 80006116 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800063ba:	0001f597          	auipc	a1,0x1f
    800063be:	d6e58593          	addi	a1,a1,-658 # 80025128 <disk+0x2128>
    800063c2:	0001f517          	auipc	a0,0x1f
    800063c6:	c5650513          	addi	a0,a0,-938 # 80025018 <disk+0x2018>
    800063ca:	ffffc097          	auipc	ra,0xffffc
    800063ce:	d52080e7          	jalr	-686(ra) # 8000211c <sleep>
  for(int i = 0; i < 3; i++){
    800063d2:	fa040713          	addi	a4,s0,-96
    800063d6:	4481                	li	s1,0
  for(int i = 0; i < NUM; i++){
    800063d8:	4505                	li	a0,1
      disk.free[i] = 0;
    800063da:	6589                	lui	a1,0x2
    800063dc:	b749                	j	8000635e <virtio_disk_rw+0x68>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800063de:	20058793          	addi	a5,a1,512 # 2200 <_entry-0x7fffde00>
    800063e2:	00479613          	slli	a2,a5,0x4
    800063e6:	0001d797          	auipc	a5,0x1d
    800063ea:	c1a78793          	addi	a5,a5,-998 # 80023000 <disk>
    800063ee:	97b2                	add	a5,a5,a2
    800063f0:	4605                	li	a2,1
    800063f2:	0ac7a423          	sw	a2,168(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800063f6:	20058793          	addi	a5,a1,512
    800063fa:	00479613          	slli	a2,a5,0x4
    800063fe:	0001d797          	auipc	a5,0x1d
    80006402:	c0278793          	addi	a5,a5,-1022 # 80023000 <disk>
    80006406:	97b2                	add	a5,a5,a2
    80006408:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    8000640c:	0b77b823          	sd	s7,176(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006410:	0001f797          	auipc	a5,0x1f
    80006414:	bf078793          	addi	a5,a5,-1040 # 80025000 <disk+0x2000>
    80006418:	6390                	ld	a2,0(a5)
    8000641a:	963a                	add	a2,a2,a4
    8000641c:	7779                	lui	a4,0xffffe
    8000641e:	9732                	add	a4,a4,a2
    80006420:	e314                	sd	a3,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006422:	00459713          	slli	a4,a1,0x4
    80006426:	6394                	ld	a3,0(a5)
    80006428:	96ba                	add	a3,a3,a4
    8000642a:	4641                	li	a2,16
    8000642c:	c690                	sw	a2,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000642e:	6394                	ld	a3,0(a5)
    80006430:	96ba                	add	a3,a3,a4
    80006432:	4605                	li	a2,1
    80006434:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80006438:	fa442683          	lw	a3,-92(s0)
    8000643c:	6390                	ld	a2,0(a5)
    8000643e:	963a                	add	a2,a2,a4
    80006440:	00d61723          	sh	a3,14(a2) # 200e <_entry-0x7fffdff2>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006444:	0692                	slli	a3,a3,0x4
    80006446:	6390                	ld	a2,0(a5)
    80006448:	9636                	add	a2,a2,a3
    8000644a:	05890513          	addi	a0,s2,88
    8000644e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80006450:	639c                	ld	a5,0(a5)
    80006452:	97b6                	add	a5,a5,a3
    80006454:	40000613          	li	a2,1024
    80006458:	c790                	sw	a2,8(a5)
  if(write)
    8000645a:	140c0163          	beqz	s8,8000659c <virtio_disk_rw+0x2a6>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000645e:	0001f797          	auipc	a5,0x1f
    80006462:	ba278793          	addi	a5,a5,-1118 # 80025000 <disk+0x2000>
    80006466:	639c                	ld	a5,0(a5)
    80006468:	97b6                	add	a5,a5,a3
    8000646a:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000646e:	0001d897          	auipc	a7,0x1d
    80006472:	b9288893          	addi	a7,a7,-1134 # 80023000 <disk>
    80006476:	0001f797          	auipc	a5,0x1f
    8000647a:	b8a78793          	addi	a5,a5,-1142 # 80025000 <disk+0x2000>
    8000647e:	6390                	ld	a2,0(a5)
    80006480:	9636                	add	a2,a2,a3
    80006482:	00c65503          	lhu	a0,12(a2)
    80006486:	00156513          	ori	a0,a0,1
    8000648a:	00a61623          	sh	a0,12(a2)
  disk.desc[idx[1]].next = idx[2];
    8000648e:	fa842603          	lw	a2,-88(s0)
    80006492:	6388                	ld	a0,0(a5)
    80006494:	96aa                	add	a3,a3,a0
    80006496:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000649a:	20058513          	addi	a0,a1,512
    8000649e:	0512                	slli	a0,a0,0x4
    800064a0:	9546                	add	a0,a0,a7
    800064a2:	56fd                	li	a3,-1
    800064a4:	02d50823          	sb	a3,48(a0)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800064a8:	00461693          	slli	a3,a2,0x4
    800064ac:	6390                	ld	a2,0(a5)
    800064ae:	9636                	add	a2,a2,a3
    800064b0:	6809                	lui	a6,0x2
    800064b2:	03080813          	addi	a6,a6,48 # 2030 <_entry-0x7fffdfd0>
    800064b6:	9742                	add	a4,a4,a6
    800064b8:	9746                	add	a4,a4,a7
    800064ba:	e218                	sd	a4,0(a2)
  disk.desc[idx[2]].len = 1;
    800064bc:	6398                	ld	a4,0(a5)
    800064be:	9736                	add	a4,a4,a3
    800064c0:	4605                	li	a2,1
    800064c2:	c710                	sw	a2,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800064c4:	6398                	ld	a4,0(a5)
    800064c6:	9736                	add	a4,a4,a3
    800064c8:	4809                	li	a6,2
    800064ca:	01071623          	sh	a6,12(a4) # ffffffffffffe00c <end+0xffffffff7ffd800c>
  disk.desc[idx[2]].next = 0;
    800064ce:	6398                	ld	a4,0(a5)
    800064d0:	96ba                	add	a3,a3,a4
    800064d2:	00069723          	sh	zero,14(a3)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800064d6:	00c92223          	sw	a2,4(s2)
  disk.info[idx[0]].b = b;
    800064da:	03253423          	sd	s2,40(a0)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800064de:	6794                	ld	a3,8(a5)
    800064e0:	0026d703          	lhu	a4,2(a3)
    800064e4:	8b1d                	andi	a4,a4,7
    800064e6:	0706                	slli	a4,a4,0x1
    800064e8:	9736                	add	a4,a4,a3
    800064ea:	00b71223          	sh	a1,4(a4)

  __sync_synchronize();
    800064ee:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800064f2:	6798                	ld	a4,8(a5)
    800064f4:	00275783          	lhu	a5,2(a4)
    800064f8:	2785                	addiw	a5,a5,1
    800064fa:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800064fe:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006502:	100017b7          	lui	a5,0x10001
    80006506:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000650a:	00492703          	lw	a4,4(s2)
    8000650e:	4785                	li	a5,1
    80006510:	02f71163          	bne	a4,a5,80006532 <virtio_disk_rw+0x23c>
    sleep(b, &disk.vdisk_lock);
    80006514:	0001f997          	auipc	s3,0x1f
    80006518:	c1498993          	addi	s3,s3,-1004 # 80025128 <disk+0x2128>
  while(b->disk == 1) {
    8000651c:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000651e:	85ce                	mv	a1,s3
    80006520:	854a                	mv	a0,s2
    80006522:	ffffc097          	auipc	ra,0xffffc
    80006526:	bfa080e7          	jalr	-1030(ra) # 8000211c <sleep>
  while(b->disk == 1) {
    8000652a:	00492783          	lw	a5,4(s2)
    8000652e:	fe9788e3          	beq	a5,s1,8000651e <virtio_disk_rw+0x228>
  }

  disk.info[idx[0]].b = 0;
    80006532:	fa042503          	lw	a0,-96(s0)
    80006536:	20050793          	addi	a5,a0,512
    8000653a:	00479713          	slli	a4,a5,0x4
    8000653e:	0001d797          	auipc	a5,0x1d
    80006542:	ac278793          	addi	a5,a5,-1342 # 80023000 <disk>
    80006546:	97ba                	add	a5,a5,a4
    80006548:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    8000654c:	0001f997          	auipc	s3,0x1f
    80006550:	ab498993          	addi	s3,s3,-1356 # 80025000 <disk+0x2000>
    80006554:	00451713          	slli	a4,a0,0x4
    80006558:	0009b783          	ld	a5,0(s3)
    8000655c:	97ba                	add	a5,a5,a4
    8000655e:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006562:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006566:	00000097          	auipc	ra,0x0
    8000656a:	bb0080e7          	jalr	-1104(ra) # 80006116 <free_desc>
      i = nxt;
    8000656e:	854a                	mv	a0,s2
    if(flag & VRING_DESC_F_NEXT)
    80006570:	8885                	andi	s1,s1,1
    80006572:	f0ed                	bnez	s1,80006554 <virtio_disk_rw+0x25e>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006574:	0001f517          	auipc	a0,0x1f
    80006578:	bb450513          	addi	a0,a0,-1100 # 80025128 <disk+0x2128>
    8000657c:	ffffa097          	auipc	ra,0xffffa
    80006580:	758080e7          	jalr	1880(ra) # 80000cd4 <release>
}
    80006584:	60e6                	ld	ra,88(sp)
    80006586:	6446                	ld	s0,80(sp)
    80006588:	64a6                	ld	s1,72(sp)
    8000658a:	6906                	ld	s2,64(sp)
    8000658c:	79e2                	ld	s3,56(sp)
    8000658e:	7a42                	ld	s4,48(sp)
    80006590:	7aa2                	ld	s5,40(sp)
    80006592:	7b02                	ld	s6,32(sp)
    80006594:	6be2                	ld	s7,24(sp)
    80006596:	6c42                	ld	s8,16(sp)
    80006598:	6125                	addi	sp,sp,96
    8000659a:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000659c:	0001f797          	auipc	a5,0x1f
    800065a0:	a6478793          	addi	a5,a5,-1436 # 80025000 <disk+0x2000>
    800065a4:	639c                	ld	a5,0(a5)
    800065a6:	97b6                	add	a5,a5,a3
    800065a8:	4609                	li	a2,2
    800065aa:	00c79623          	sh	a2,12(a5)
    800065ae:	b5c1                	j	8000646e <virtio_disk_rw+0x178>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800065b0:	fa042583          	lw	a1,-96(s0)
    800065b4:	20058713          	addi	a4,a1,512
    800065b8:	0712                	slli	a4,a4,0x4
    800065ba:	0001d697          	auipc	a3,0x1d
    800065be:	aee68693          	addi	a3,a3,-1298 # 800230a8 <disk+0xa8>
    800065c2:	96ba                	add	a3,a3,a4
  if(write)
    800065c4:	e00c1de3          	bnez	s8,800063de <virtio_disk_rw+0xe8>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800065c8:	20058793          	addi	a5,a1,512
    800065cc:	00479613          	slli	a2,a5,0x4
    800065d0:	0001d797          	auipc	a5,0x1d
    800065d4:	a3078793          	addi	a5,a5,-1488 # 80023000 <disk>
    800065d8:	97b2                	add	a5,a5,a2
    800065da:	0a07a423          	sw	zero,168(a5)
    800065de:	bd21                	j	800063f6 <virtio_disk_rw+0x100>
      disk.free[i] = 0;
    800065e0:	00098c23          	sb	zero,24(s3)
    idx[i] = alloc_desc();
    800065e4:	00072023          	sw	zero,0(a4)
    if(idx[i] < 0){
    800065e8:	b3bd                	j	80006356 <virtio_disk_rw+0x60>

00000000800065ea <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800065ea:	1101                	addi	sp,sp,-32
    800065ec:	ec06                	sd	ra,24(sp)
    800065ee:	e822                	sd	s0,16(sp)
    800065f0:	e426                	sd	s1,8(sp)
    800065f2:	e04a                	sd	s2,0(sp)
    800065f4:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800065f6:	0001f517          	auipc	a0,0x1f
    800065fa:	b3250513          	addi	a0,a0,-1230 # 80025128 <disk+0x2128>
    800065fe:	ffffa097          	auipc	ra,0xffffa
    80006602:	622080e7          	jalr	1570(ra) # 80000c20 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006606:	10001737          	lui	a4,0x10001
    8000660a:	533c                	lw	a5,96(a4)
    8000660c:	8b8d                	andi	a5,a5,3
    8000660e:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006610:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006614:	0001f797          	auipc	a5,0x1f
    80006618:	9ec78793          	addi	a5,a5,-1556 # 80025000 <disk+0x2000>
    8000661c:	6b94                	ld	a3,16(a5)
    8000661e:	0207d703          	lhu	a4,32(a5)
    80006622:	0026d783          	lhu	a5,2(a3)
    80006626:	06f70163          	beq	a4,a5,80006688 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000662a:	0001d917          	auipc	s2,0x1d
    8000662e:	9d690913          	addi	s2,s2,-1578 # 80023000 <disk>
    80006632:	0001f497          	auipc	s1,0x1f
    80006636:	9ce48493          	addi	s1,s1,-1586 # 80025000 <disk+0x2000>
    __sync_synchronize();
    8000663a:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000663e:	6898                	ld	a4,16(s1)
    80006640:	0204d783          	lhu	a5,32(s1)
    80006644:	8b9d                	andi	a5,a5,7
    80006646:	078e                	slli	a5,a5,0x3
    80006648:	97ba                	add	a5,a5,a4
    8000664a:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000664c:	20078713          	addi	a4,a5,512
    80006650:	0712                	slli	a4,a4,0x4
    80006652:	974a                	add	a4,a4,s2
    80006654:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80006658:	e731                	bnez	a4,800066a4 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000665a:	20078793          	addi	a5,a5,512
    8000665e:	0792                	slli	a5,a5,0x4
    80006660:	97ca                	add	a5,a5,s2
    80006662:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80006664:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006668:	ffffc097          	auipc	ra,0xffffc
    8000666c:	c40080e7          	jalr	-960(ra) # 800022a8 <wakeup>

    disk.used_idx += 1;
    80006670:	0204d783          	lhu	a5,32(s1)
    80006674:	2785                	addiw	a5,a5,1
    80006676:	17c2                	slli	a5,a5,0x30
    80006678:	93c1                	srli	a5,a5,0x30
    8000667a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000667e:	6898                	ld	a4,16(s1)
    80006680:	00275703          	lhu	a4,2(a4)
    80006684:	faf71be3          	bne	a4,a5,8000663a <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80006688:	0001f517          	auipc	a0,0x1f
    8000668c:	aa050513          	addi	a0,a0,-1376 # 80025128 <disk+0x2128>
    80006690:	ffffa097          	auipc	ra,0xffffa
    80006694:	644080e7          	jalr	1604(ra) # 80000cd4 <release>
}
    80006698:	60e2                	ld	ra,24(sp)
    8000669a:	6442                	ld	s0,16(sp)
    8000669c:	64a2                	ld	s1,8(sp)
    8000669e:	6902                	ld	s2,0(sp)
    800066a0:	6105                	addi	sp,sp,32
    800066a2:	8082                	ret
      panic("virtio_disk_intr status");
    800066a4:	00002517          	auipc	a0,0x2
    800066a8:	14c50513          	addi	a0,a0,332 # 800087f0 <syscalls+0x3e8>
    800066ac:	ffffa097          	auipc	ra,0xffffa
    800066b0:	eac080e7          	jalr	-340(ra) # 80000558 <panic>
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
