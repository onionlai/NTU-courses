
user/_threads:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thread_create>:
static struct thread* current_thread = NULL;
static int id = 1;
static jmp_buf env_st;
//static jmp_buf env_tmp;

struct thread *thread_create(void (*f)(void *), void *arg){
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
  10:	892e                	mv	s2,a1
    struct thread *t = (struct thread*) malloc(sizeof(struct thread));
  12:	0a800513          	li	a0,168
  16:	00001097          	auipc	ra,0x1
  1a:	88a080e7          	jalr	-1910(ra) # 8a0 <malloc>
  1e:	84aa                	mv	s1,a0
    //unsigned long stack_p = 0;
    unsigned long new_stack_p;
    unsigned long new_stack;
    new_stack = (unsigned long) malloc(sizeof(unsigned long)*0x100);
  20:	6505                	lui	a0,0x1
  22:	80050513          	addi	a0,a0,-2048 # 800 <printf+0x1e>
  26:	00001097          	auipc	ra,0x1
  2a:	87a080e7          	jalr	-1926(ra) # 8a0 <malloc>
    new_stack_p = new_stack +0x100*8-0x2*8;
    t->fp = f;
  2e:	0134b023          	sd	s3,0(s1)
    t->arg = arg;
  32:	0124b423          	sd	s2,8(s1)
    t->ID  = id;
  36:	00001717          	auipc	a4,0x1
  3a:	9e670713          	addi	a4,a4,-1562 # a1c <id>
  3e:	431c                	lw	a5,0(a4)
  40:	08f4a823          	sw	a5,144(s1)
    t->buf_set = 0;
  44:	0804aa23          	sw	zero,148(s1)
    t->stack = (void*) new_stack;
  48:	e888                	sd	a0,16(s1)
    new_stack_p = new_stack +0x100*8-0x2*8;
  4a:	7f050513          	addi	a0,a0,2032
    t->stack_p = (void*) new_stack_p;
  4e:	ec88                	sd	a0,24(s1)
    id++;
  50:	2785                	addiw	a5,a5,1
  52:	c31c                	sw	a5,0(a4)
    return t;
}
  54:	8526                	mv	a0,s1
  56:	70a2                	ld	ra,40(sp)
  58:	7402                	ld	s0,32(sp)
  5a:	64e2                	ld	s1,24(sp)
  5c:	6942                	ld	s2,16(sp)
  5e:	69a2                	ld	s3,8(sp)
  60:	6145                	addi	sp,sp,48
  62:	8082                	ret

0000000000000064 <thread_add_runqueue>:
void thread_add_runqueue(struct thread *t){
  64:	1141                	addi	sp,sp,-16
  66:	e422                	sd	s0,8(sp)
  68:	0800                	addi	s0,sp,16
    if(current_thread == NULL){
  6a:	00001797          	auipc	a5,0x1
  6e:	9b67b783          	ld	a5,-1610(a5) # a20 <current_thread>
  72:	cb91                	beqz	a5,86 <thread_add_runqueue+0x22>
        current_thread = t;
        current_thread->previous = t;
        current_thread->next = t;
    }
    else{
        current_thread->previous->next = t;
  74:	6fd8                	ld	a4,152(a5)
  76:	f348                	sd	a0,160(a4)
        t->previous = current_thread->previous;
  78:	6fd8                	ld	a4,152(a5)
  7a:	ed58                	sd	a4,152(a0)
        t->next = current_thread;
  7c:	f15c                	sd	a5,160(a0)
        current_thread->previous = t;
  7e:	efc8                	sd	a0,152(a5)
    }
}
  80:	6422                	ld	s0,8(sp)
  82:	0141                	addi	sp,sp,16
  84:	8082                	ret
        current_thread = t;
  86:	00001797          	auipc	a5,0x1
  8a:	98a7bd23          	sd	a0,-1638(a5) # a20 <current_thread>
        current_thread->previous = t;
  8e:	ed48                	sd	a0,152(a0)
        current_thread->next = t;
  90:	f148                	sd	a0,160(a0)
  92:	b7fd                	j	80 <thread_add_runqueue+0x1c>

0000000000000094 <schedule>:
    }
    else{
        longjmp(current_thread->env, 1);
    }
}
void schedule(void){
  94:	1141                	addi	sp,sp,-16
  96:	e422                	sd	s0,8(sp)
  98:	0800                	addi	s0,sp,16
    current_thread = current_thread->next;
  9a:	00001797          	auipc	a5,0x1
  9e:	98678793          	addi	a5,a5,-1658 # a20 <current_thread>
  a2:	6398                	ld	a4,0(a5)
  a4:	7358                	ld	a4,160(a4)
  a6:	e398                	sd	a4,0(a5)
}
  a8:	6422                	ld	s0,8(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <thread_exit>:
void thread_exit(void){
  ae:	1101                	addi	sp,sp,-32
  b0:	ec06                	sd	ra,24(sp)
  b2:	e822                	sd	s0,16(sp)
  b4:	e426                	sd	s1,8(sp)
  b6:	e04a                	sd	s2,0(sp)
  b8:	1000                	addi	s0,sp,32
    if(current_thread->next != current_thread){
  ba:	00001797          	auipc	a5,0x1
  be:	9667b783          	ld	a5,-1690(a5) # a20 <current_thread>
  c2:	73d8                	ld	a4,160(a5)
  c4:	04e78263          	beq	a5,a4,108 <thread_exit+0x5a>
        // TODO
        current_thread->previous->next = current_thread->next;
  c8:	6fd4                	ld	a3,152(a5)
  ca:	f2d8                	sd	a4,160(a3)
        current_thread->next->previous = current_thread->previous;
  cc:	6fd4                	ld	a3,152(a5)
  ce:	ef54                	sd	a3,152(a4)
        struct thread *next = current_thread->next;
  d0:	0a07b903          	ld	s2,160(a5)
        // free the thread
        free(current_thread->stack);
  d4:	6b88                	ld	a0,16(a5)
  d6:	00000097          	auipc	ra,0x0
  da:	742080e7          	jalr	1858(ra) # 818 <free>
        free(current_thread);
  de:	00001497          	auipc	s1,0x1
  e2:	94248493          	addi	s1,s1,-1726 # a20 <current_thread>
  e6:	6088                	ld	a0,0(s1)
  e8:	00000097          	auipc	ra,0x0
  ec:	730080e7          	jalr	1840(ra) # 818 <free>
        current_thread = next;
  f0:	0124b023          	sd	s2,0(s1)
        // schedule();
        dispatch();
  f4:	00000097          	auipc	ra,0x0
  f8:	028080e7          	jalr	40(ra) # 11c <dispatch>
        // TODO
        // Hint: No more thread to execute
        longjmp(env_st, 1);
        return;
    }
}
  fc:	60e2                	ld	ra,24(sp)
  fe:	6442                	ld	s0,16(sp)
 100:	64a2                	ld	s1,8(sp)
 102:	6902                	ld	s2,0(sp)
 104:	6105                	addi	sp,sp,32
 106:	8082                	ret
        longjmp(env_st, 1);
 108:	4585                	li	a1,1
 10a:	00001517          	auipc	a0,0x1
 10e:	92650513          	addi	a0,a0,-1754 # a30 <env_st>
 112:	00001097          	auipc	ra,0x1
 116:	8aa080e7          	jalr	-1878(ra) # 9bc <longjmp>
        return;
 11a:	b7cd                	j	fc <thread_exit+0x4e>

000000000000011c <dispatch>:
void dispatch(void){
 11c:	1141                	addi	sp,sp,-16
 11e:	e406                	sd	ra,8(sp)
 120:	e022                	sd	s0,0(sp)
 122:	0800                	addi	s0,sp,16
    if(current_thread->buf_set == 0){ //not yet initialized
 124:	00001517          	auipc	a0,0x1
 128:	8fc53503          	ld	a0,-1796(a0) # a20 <current_thread>
 12c:	09452783          	lw	a5,148(a0)
 130:	eba1                	bnez	a5,180 <dispatch+0x64>
        current_thread->buf_set = 1;
 132:	4785                	li	a5,1
 134:	08f52a23          	sw	a5,148(a0)
        if(setjmp(current_thread->env) == 0){
 138:	02050513          	addi	a0,a0,32
 13c:	00001097          	auipc	ra,0x1
 140:	848080e7          	jalr	-1976(ra) # 984 <setjmp>
 144:	c105                	beqz	a0,164 <dispatch+0x48>
            current_thread->fp(current_thread->arg);
 146:	00001797          	auipc	a5,0x1
 14a:	8da7b783          	ld	a5,-1830(a5) # a20 <current_thread>
 14e:	6398                	ld	a4,0(a5)
 150:	6788                	ld	a0,8(a5)
 152:	9702                	jalr	a4
            thread_exit();
 154:	00000097          	auipc	ra,0x0
 158:	f5a080e7          	jalr	-166(ra) # ae <thread_exit>
}
 15c:	60a2                	ld	ra,8(sp)
 15e:	6402                	ld	s0,0(sp)
 160:	0141                	addi	sp,sp,16
 162:	8082                	ret
            current_thread->env->sp = (unsigned long)current_thread->stack_p;
 164:	00001517          	auipc	a0,0x1
 168:	8bc53503          	ld	a0,-1860(a0) # a20 <current_thread>
 16c:	6d1c                	ld	a5,24(a0)
 16e:	e55c                	sd	a5,136(a0)
            longjmp(current_thread->env, 1);
 170:	4585                	li	a1,1
 172:	02050513          	addi	a0,a0,32
 176:	00001097          	auipc	ra,0x1
 17a:	846080e7          	jalr	-1978(ra) # 9bc <longjmp>
 17e:	bff9                	j	15c <dispatch+0x40>
        longjmp(current_thread->env, 1);
 180:	4585                	li	a1,1
 182:	02050513          	addi	a0,a0,32
 186:	00001097          	auipc	ra,0x1
 18a:	836080e7          	jalr	-1994(ra) # 9bc <longjmp>
}
 18e:	b7f9                	j	15c <dispatch+0x40>

0000000000000190 <thread_yield>:
void thread_yield(void){
 190:	1141                	addi	sp,sp,-16
 192:	e406                	sd	ra,8(sp)
 194:	e022                	sd	s0,0(sp)
 196:	0800                	addi	s0,sp,16
    if(setjmp(current_thread->env) == 0){ //從function裡叫thread_yield
 198:	00001517          	auipc	a0,0x1
 19c:	88853503          	ld	a0,-1912(a0) # a20 <current_thread>
 1a0:	02050513          	addi	a0,a0,32
 1a4:	00000097          	auipc	ra,0x0
 1a8:	7e0080e7          	jalr	2016(ra) # 984 <setjmp>
 1ac:	c509                	beqz	a0,1b6 <thread_yield+0x26>
}
 1ae:	60a2                	ld	ra,8(sp)
 1b0:	6402                	ld	s0,0(sp)
 1b2:	0141                	addi	sp,sp,16
 1b4:	8082                	ret
        schedule();
 1b6:	00000097          	auipc	ra,0x0
 1ba:	ede080e7          	jalr	-290(ra) # 94 <schedule>
        dispatch();
 1be:	00000097          	auipc	ra,0x0
 1c2:	f5e080e7          	jalr	-162(ra) # 11c <dispatch>
 1c6:	b7e5                	j	1ae <thread_yield+0x1e>

00000000000001c8 <thread_start_threading>:
void thread_start_threading(void){
 1c8:	1141                	addi	sp,sp,-16
 1ca:	e406                	sd	ra,8(sp)
 1cc:	e022                	sd	s0,0(sp)
 1ce:	0800                	addi	s0,sp,16
    // TODO
    if(setjmp(env_st) == 0){ // main thread
 1d0:	00001517          	auipc	a0,0x1
 1d4:	86050513          	addi	a0,a0,-1952 # a30 <env_st>
 1d8:	00000097          	auipc	ra,0x0
 1dc:	7ac080e7          	jalr	1964(ra) # 984 <setjmp>
 1e0:	c509                	beqz	a0,1ea <thread_start_threading+0x22>
        dispatch();
    }
    else{
        return;
    }
}
 1e2:	60a2                	ld	ra,8(sp)
 1e4:	6402                	ld	s0,0(sp)
 1e6:	0141                	addi	sp,sp,16
 1e8:	8082                	ret
        schedule();
 1ea:	00000097          	auipc	ra,0x0
 1ee:	eaa080e7          	jalr	-342(ra) # 94 <schedule>
        dispatch();
 1f2:	00000097          	auipc	ra,0x0
 1f6:	f2a080e7          	jalr	-214(ra) # 11c <dispatch>
 1fa:	b7e5                	j	1e2 <thread_start_threading+0x1a>

00000000000001fc <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 1fc:	1141                	addi	sp,sp,-16
 1fe:	e422                	sd	s0,8(sp)
 200:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 202:	87aa                	mv	a5,a0
 204:	0585                	addi	a1,a1,1
 206:	0785                	addi	a5,a5,1
 208:	fff5c703          	lbu	a4,-1(a1)
 20c:	fee78fa3          	sb	a4,-1(a5)
 210:	fb75                	bnez	a4,204 <strcpy+0x8>
    ;
  return os;
}
 212:	6422                	ld	s0,8(sp)
 214:	0141                	addi	sp,sp,16
 216:	8082                	ret

0000000000000218 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 218:	1141                	addi	sp,sp,-16
 21a:	e422                	sd	s0,8(sp)
 21c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 21e:	00054783          	lbu	a5,0(a0)
 222:	cb91                	beqz	a5,236 <strcmp+0x1e>
 224:	0005c703          	lbu	a4,0(a1)
 228:	00f71763          	bne	a4,a5,236 <strcmp+0x1e>
    p++, q++;
 22c:	0505                	addi	a0,a0,1
 22e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 230:	00054783          	lbu	a5,0(a0)
 234:	fbe5                	bnez	a5,224 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 236:	0005c503          	lbu	a0,0(a1)
}
 23a:	40a7853b          	subw	a0,a5,a0
 23e:	6422                	ld	s0,8(sp)
 240:	0141                	addi	sp,sp,16
 242:	8082                	ret

0000000000000244 <strlen>:

uint
strlen(const char *s)
{
 244:	1141                	addi	sp,sp,-16
 246:	e422                	sd	s0,8(sp)
 248:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 24a:	00054783          	lbu	a5,0(a0)
 24e:	cf91                	beqz	a5,26a <strlen+0x26>
 250:	0505                	addi	a0,a0,1
 252:	87aa                	mv	a5,a0
 254:	4685                	li	a3,1
 256:	9e89                	subw	a3,a3,a0
 258:	00f6853b          	addw	a0,a3,a5
 25c:	0785                	addi	a5,a5,1
 25e:	fff7c703          	lbu	a4,-1(a5)
 262:	fb7d                	bnez	a4,258 <strlen+0x14>
    ;
  return n;
}
 264:	6422                	ld	s0,8(sp)
 266:	0141                	addi	sp,sp,16
 268:	8082                	ret
  for(n = 0; s[n]; n++)
 26a:	4501                	li	a0,0
 26c:	bfe5                	j	264 <strlen+0x20>

000000000000026e <memset>:

void*
memset(void *dst, int c, uint n)
{
 26e:	1141                	addi	sp,sp,-16
 270:	e422                	sd	s0,8(sp)
 272:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 274:	ca19                	beqz	a2,28a <memset+0x1c>
 276:	87aa                	mv	a5,a0
 278:	1602                	slli	a2,a2,0x20
 27a:	9201                	srli	a2,a2,0x20
 27c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 280:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 284:	0785                	addi	a5,a5,1
 286:	fee79de3          	bne	a5,a4,280 <memset+0x12>
  }
  return dst;
}
 28a:	6422                	ld	s0,8(sp)
 28c:	0141                	addi	sp,sp,16
 28e:	8082                	ret

0000000000000290 <strchr>:

char*
strchr(const char *s, char c)
{
 290:	1141                	addi	sp,sp,-16
 292:	e422                	sd	s0,8(sp)
 294:	0800                	addi	s0,sp,16
  for(; *s; s++)
 296:	00054783          	lbu	a5,0(a0)
 29a:	cb99                	beqz	a5,2b0 <strchr+0x20>
    if(*s == c)
 29c:	00f58763          	beq	a1,a5,2aa <strchr+0x1a>
  for(; *s; s++)
 2a0:	0505                	addi	a0,a0,1
 2a2:	00054783          	lbu	a5,0(a0)
 2a6:	fbfd                	bnez	a5,29c <strchr+0xc>
      return (char*)s;
  return 0;
 2a8:	4501                	li	a0,0
}
 2aa:	6422                	ld	s0,8(sp)
 2ac:	0141                	addi	sp,sp,16
 2ae:	8082                	ret
  return 0;
 2b0:	4501                	li	a0,0
 2b2:	bfe5                	j	2aa <strchr+0x1a>

00000000000002b4 <gets>:

char*
gets(char *buf, int max)
{
 2b4:	711d                	addi	sp,sp,-96
 2b6:	ec86                	sd	ra,88(sp)
 2b8:	e8a2                	sd	s0,80(sp)
 2ba:	e4a6                	sd	s1,72(sp)
 2bc:	e0ca                	sd	s2,64(sp)
 2be:	fc4e                	sd	s3,56(sp)
 2c0:	f852                	sd	s4,48(sp)
 2c2:	f456                	sd	s5,40(sp)
 2c4:	f05a                	sd	s6,32(sp)
 2c6:	ec5e                	sd	s7,24(sp)
 2c8:	1080                	addi	s0,sp,96
 2ca:	8baa                	mv	s7,a0
 2cc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ce:	892a                	mv	s2,a0
 2d0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2d2:	4aa9                	li	s5,10
 2d4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2d6:	89a6                	mv	s3,s1
 2d8:	2485                	addiw	s1,s1,1
 2da:	0344d863          	bge	s1,s4,30a <gets+0x56>
    cc = read(0, &c, 1);
 2de:	4605                	li	a2,1
 2e0:	faf40593          	addi	a1,s0,-81
 2e4:	4501                	li	a0,0
 2e6:	00000097          	auipc	ra,0x0
 2ea:	19c080e7          	jalr	412(ra) # 482 <read>
    if(cc < 1)
 2ee:	00a05e63          	blez	a0,30a <gets+0x56>
    buf[i++] = c;
 2f2:	faf44783          	lbu	a5,-81(s0)
 2f6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2fa:	01578763          	beq	a5,s5,308 <gets+0x54>
 2fe:	0905                	addi	s2,s2,1
 300:	fd679be3          	bne	a5,s6,2d6 <gets+0x22>
  for(i=0; i+1 < max; ){
 304:	89a6                	mv	s3,s1
 306:	a011                	j	30a <gets+0x56>
 308:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 30a:	99de                	add	s3,s3,s7
 30c:	00098023          	sb	zero,0(s3)
  return buf;
}
 310:	855e                	mv	a0,s7
 312:	60e6                	ld	ra,88(sp)
 314:	6446                	ld	s0,80(sp)
 316:	64a6                	ld	s1,72(sp)
 318:	6906                	ld	s2,64(sp)
 31a:	79e2                	ld	s3,56(sp)
 31c:	7a42                	ld	s4,48(sp)
 31e:	7aa2                	ld	s5,40(sp)
 320:	7b02                	ld	s6,32(sp)
 322:	6be2                	ld	s7,24(sp)
 324:	6125                	addi	sp,sp,96
 326:	8082                	ret

0000000000000328 <stat>:

int
stat(const char *n, struct stat *st)
{
 328:	1101                	addi	sp,sp,-32
 32a:	ec06                	sd	ra,24(sp)
 32c:	e822                	sd	s0,16(sp)
 32e:	e426                	sd	s1,8(sp)
 330:	e04a                	sd	s2,0(sp)
 332:	1000                	addi	s0,sp,32
 334:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 336:	4581                	li	a1,0
 338:	00000097          	auipc	ra,0x0
 33c:	172080e7          	jalr	370(ra) # 4aa <open>
  if(fd < 0)
 340:	02054563          	bltz	a0,36a <stat+0x42>
 344:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 346:	85ca                	mv	a1,s2
 348:	00000097          	auipc	ra,0x0
 34c:	17a080e7          	jalr	378(ra) # 4c2 <fstat>
 350:	892a                	mv	s2,a0
  close(fd);
 352:	8526                	mv	a0,s1
 354:	00000097          	auipc	ra,0x0
 358:	13e080e7          	jalr	318(ra) # 492 <close>
  return r;
}
 35c:	854a                	mv	a0,s2
 35e:	60e2                	ld	ra,24(sp)
 360:	6442                	ld	s0,16(sp)
 362:	64a2                	ld	s1,8(sp)
 364:	6902                	ld	s2,0(sp)
 366:	6105                	addi	sp,sp,32
 368:	8082                	ret
    return -1;
 36a:	597d                	li	s2,-1
 36c:	bfc5                	j	35c <stat+0x34>

000000000000036e <atoi>:

int
atoi(const char *s)
{
 36e:	1141                	addi	sp,sp,-16
 370:	e422                	sd	s0,8(sp)
 372:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 374:	00054603          	lbu	a2,0(a0)
 378:	fd06079b          	addiw	a5,a2,-48
 37c:	0ff7f793          	andi	a5,a5,255
 380:	4725                	li	a4,9
 382:	02f76963          	bltu	a4,a5,3b4 <atoi+0x46>
 386:	86aa                	mv	a3,a0
  n = 0;
 388:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 38a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 38c:	0685                	addi	a3,a3,1
 38e:	0025179b          	slliw	a5,a0,0x2
 392:	9fa9                	addw	a5,a5,a0
 394:	0017979b          	slliw	a5,a5,0x1
 398:	9fb1                	addw	a5,a5,a2
 39a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 39e:	0006c603          	lbu	a2,0(a3)
 3a2:	fd06071b          	addiw	a4,a2,-48
 3a6:	0ff77713          	andi	a4,a4,255
 3aa:	fee5f1e3          	bgeu	a1,a4,38c <atoi+0x1e>
  return n;
}
 3ae:	6422                	ld	s0,8(sp)
 3b0:	0141                	addi	sp,sp,16
 3b2:	8082                	ret
  n = 0;
 3b4:	4501                	li	a0,0
 3b6:	bfe5                	j	3ae <atoi+0x40>

00000000000003b8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3b8:	1141                	addi	sp,sp,-16
 3ba:	e422                	sd	s0,8(sp)
 3bc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3be:	02b57463          	bgeu	a0,a1,3e6 <memmove+0x2e>
    while(n-- > 0)
 3c2:	00c05f63          	blez	a2,3e0 <memmove+0x28>
 3c6:	1602                	slli	a2,a2,0x20
 3c8:	9201                	srli	a2,a2,0x20
 3ca:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3ce:	872a                	mv	a4,a0
      *dst++ = *src++;
 3d0:	0585                	addi	a1,a1,1
 3d2:	0705                	addi	a4,a4,1
 3d4:	fff5c683          	lbu	a3,-1(a1)
 3d8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3dc:	fee79ae3          	bne	a5,a4,3d0 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3e0:	6422                	ld	s0,8(sp)
 3e2:	0141                	addi	sp,sp,16
 3e4:	8082                	ret
    dst += n;
 3e6:	00c50733          	add	a4,a0,a2
    src += n;
 3ea:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3ec:	fec05ae3          	blez	a2,3e0 <memmove+0x28>
 3f0:	fff6079b          	addiw	a5,a2,-1
 3f4:	1782                	slli	a5,a5,0x20
 3f6:	9381                	srli	a5,a5,0x20
 3f8:	fff7c793          	not	a5,a5
 3fc:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3fe:	15fd                	addi	a1,a1,-1
 400:	177d                	addi	a4,a4,-1
 402:	0005c683          	lbu	a3,0(a1)
 406:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 40a:	fee79ae3          	bne	a5,a4,3fe <memmove+0x46>
 40e:	bfc9                	j	3e0 <memmove+0x28>

0000000000000410 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 410:	1141                	addi	sp,sp,-16
 412:	e422                	sd	s0,8(sp)
 414:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 416:	ca05                	beqz	a2,446 <memcmp+0x36>
 418:	fff6069b          	addiw	a3,a2,-1
 41c:	1682                	slli	a3,a3,0x20
 41e:	9281                	srli	a3,a3,0x20
 420:	0685                	addi	a3,a3,1
 422:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 424:	00054783          	lbu	a5,0(a0)
 428:	0005c703          	lbu	a4,0(a1)
 42c:	00e79863          	bne	a5,a4,43c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 430:	0505                	addi	a0,a0,1
    p2++;
 432:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 434:	fed518e3          	bne	a0,a3,424 <memcmp+0x14>
  }
  return 0;
 438:	4501                	li	a0,0
 43a:	a019                	j	440 <memcmp+0x30>
      return *p1 - *p2;
 43c:	40e7853b          	subw	a0,a5,a4
}
 440:	6422                	ld	s0,8(sp)
 442:	0141                	addi	sp,sp,16
 444:	8082                	ret
  return 0;
 446:	4501                	li	a0,0
 448:	bfe5                	j	440 <memcmp+0x30>

000000000000044a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 44a:	1141                	addi	sp,sp,-16
 44c:	e406                	sd	ra,8(sp)
 44e:	e022                	sd	s0,0(sp)
 450:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 452:	00000097          	auipc	ra,0x0
 456:	f66080e7          	jalr	-154(ra) # 3b8 <memmove>
}
 45a:	60a2                	ld	ra,8(sp)
 45c:	6402                	ld	s0,0(sp)
 45e:	0141                	addi	sp,sp,16
 460:	8082                	ret

0000000000000462 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 462:	4885                	li	a7,1
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <exit>:
.global exit
exit:
 li a7, SYS_exit
 46a:	4889                	li	a7,2
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <wait>:
.global wait
wait:
 li a7, SYS_wait
 472:	488d                	li	a7,3
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 47a:	4891                	li	a7,4
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <read>:
.global read
read:
 li a7, SYS_read
 482:	4895                	li	a7,5
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <write>:
.global write
write:
 li a7, SYS_write
 48a:	48c1                	li	a7,16
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <close>:
.global close
close:
 li a7, SYS_close
 492:	48d5                	li	a7,21
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <kill>:
.global kill
kill:
 li a7, SYS_kill
 49a:	4899                	li	a7,6
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4a2:	489d                	li	a7,7
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <open>:
.global open
open:
 li a7, SYS_open
 4aa:	48bd                	li	a7,15
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4b2:	48c5                	li	a7,17
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4ba:	48c9                	li	a7,18
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4c2:	48a1                	li	a7,8
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <link>:
.global link
link:
 li a7, SYS_link
 4ca:	48cd                	li	a7,19
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4d2:	48d1                	li	a7,20
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4da:	48a5                	li	a7,9
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4e2:	48a9                	li	a7,10
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4ea:	48ad                	li	a7,11
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4f2:	48b1                	li	a7,12
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4fa:	48b5                	li	a7,13
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 502:	48b9                	li	a7,14
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 50a:	1101                	addi	sp,sp,-32
 50c:	ec06                	sd	ra,24(sp)
 50e:	e822                	sd	s0,16(sp)
 510:	1000                	addi	s0,sp,32
 512:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 516:	4605                	li	a2,1
 518:	fef40593          	addi	a1,s0,-17
 51c:	00000097          	auipc	ra,0x0
 520:	f6e080e7          	jalr	-146(ra) # 48a <write>
}
 524:	60e2                	ld	ra,24(sp)
 526:	6442                	ld	s0,16(sp)
 528:	6105                	addi	sp,sp,32
 52a:	8082                	ret

000000000000052c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 52c:	7139                	addi	sp,sp,-64
 52e:	fc06                	sd	ra,56(sp)
 530:	f822                	sd	s0,48(sp)
 532:	f426                	sd	s1,40(sp)
 534:	f04a                	sd	s2,32(sp)
 536:	ec4e                	sd	s3,24(sp)
 538:	0080                	addi	s0,sp,64
 53a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 53c:	c299                	beqz	a3,542 <printint+0x16>
 53e:	0805c863          	bltz	a1,5ce <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 542:	2581                	sext.w	a1,a1
  neg = 0;
 544:	4881                	li	a7,0
 546:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 54a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 54c:	2601                	sext.w	a2,a2
 54e:	00000517          	auipc	a0,0x0
 552:	4ba50513          	addi	a0,a0,1210 # a08 <digits>
 556:	883a                	mv	a6,a4
 558:	2705                	addiw	a4,a4,1
 55a:	02c5f7bb          	remuw	a5,a1,a2
 55e:	1782                	slli	a5,a5,0x20
 560:	9381                	srli	a5,a5,0x20
 562:	97aa                	add	a5,a5,a0
 564:	0007c783          	lbu	a5,0(a5)
 568:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 56c:	0005879b          	sext.w	a5,a1
 570:	02c5d5bb          	divuw	a1,a1,a2
 574:	0685                	addi	a3,a3,1
 576:	fec7f0e3          	bgeu	a5,a2,556 <printint+0x2a>
  if(neg)
 57a:	00088b63          	beqz	a7,590 <printint+0x64>
    buf[i++] = '-';
 57e:	fd040793          	addi	a5,s0,-48
 582:	973e                	add	a4,a4,a5
 584:	02d00793          	li	a5,45
 588:	fef70823          	sb	a5,-16(a4)
 58c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 590:	02e05863          	blez	a4,5c0 <printint+0x94>
 594:	fc040793          	addi	a5,s0,-64
 598:	00e78933          	add	s2,a5,a4
 59c:	fff78993          	addi	s3,a5,-1
 5a0:	99ba                	add	s3,s3,a4
 5a2:	377d                	addiw	a4,a4,-1
 5a4:	1702                	slli	a4,a4,0x20
 5a6:	9301                	srli	a4,a4,0x20
 5a8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5ac:	fff94583          	lbu	a1,-1(s2)
 5b0:	8526                	mv	a0,s1
 5b2:	00000097          	auipc	ra,0x0
 5b6:	f58080e7          	jalr	-168(ra) # 50a <putc>
  while(--i >= 0)
 5ba:	197d                	addi	s2,s2,-1
 5bc:	ff3918e3          	bne	s2,s3,5ac <printint+0x80>
}
 5c0:	70e2                	ld	ra,56(sp)
 5c2:	7442                	ld	s0,48(sp)
 5c4:	74a2                	ld	s1,40(sp)
 5c6:	7902                	ld	s2,32(sp)
 5c8:	69e2                	ld	s3,24(sp)
 5ca:	6121                	addi	sp,sp,64
 5cc:	8082                	ret
    x = -xx;
 5ce:	40b005bb          	negw	a1,a1
    neg = 1;
 5d2:	4885                	li	a7,1
    x = -xx;
 5d4:	bf8d                	j	546 <printint+0x1a>

00000000000005d6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5d6:	7119                	addi	sp,sp,-128
 5d8:	fc86                	sd	ra,120(sp)
 5da:	f8a2                	sd	s0,112(sp)
 5dc:	f4a6                	sd	s1,104(sp)
 5de:	f0ca                	sd	s2,96(sp)
 5e0:	ecce                	sd	s3,88(sp)
 5e2:	e8d2                	sd	s4,80(sp)
 5e4:	e4d6                	sd	s5,72(sp)
 5e6:	e0da                	sd	s6,64(sp)
 5e8:	fc5e                	sd	s7,56(sp)
 5ea:	f862                	sd	s8,48(sp)
 5ec:	f466                	sd	s9,40(sp)
 5ee:	f06a                	sd	s10,32(sp)
 5f0:	ec6e                	sd	s11,24(sp)
 5f2:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5f4:	0005c903          	lbu	s2,0(a1)
 5f8:	18090f63          	beqz	s2,796 <vprintf+0x1c0>
 5fc:	8aaa                	mv	s5,a0
 5fe:	8b32                	mv	s6,a2
 600:	00158493          	addi	s1,a1,1
  state = 0;
 604:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 606:	02500a13          	li	s4,37
      if(c == 'd'){
 60a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 60e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 612:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 616:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 61a:	00000b97          	auipc	s7,0x0
 61e:	3eeb8b93          	addi	s7,s7,1006 # a08 <digits>
 622:	a839                	j	640 <vprintf+0x6a>
        putc(fd, c);
 624:	85ca                	mv	a1,s2
 626:	8556                	mv	a0,s5
 628:	00000097          	auipc	ra,0x0
 62c:	ee2080e7          	jalr	-286(ra) # 50a <putc>
 630:	a019                	j	636 <vprintf+0x60>
    } else if(state == '%'){
 632:	01498f63          	beq	s3,s4,650 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 636:	0485                	addi	s1,s1,1
 638:	fff4c903          	lbu	s2,-1(s1)
 63c:	14090d63          	beqz	s2,796 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 640:	0009079b          	sext.w	a5,s2
    if(state == 0){
 644:	fe0997e3          	bnez	s3,632 <vprintf+0x5c>
      if(c == '%'){
 648:	fd479ee3          	bne	a5,s4,624 <vprintf+0x4e>
        state = '%';
 64c:	89be                	mv	s3,a5
 64e:	b7e5                	j	636 <vprintf+0x60>
      if(c == 'd'){
 650:	05878063          	beq	a5,s8,690 <vprintf+0xba>
      } else if(c == 'l') {
 654:	05978c63          	beq	a5,s9,6ac <vprintf+0xd6>
      } else if(c == 'x') {
 658:	07a78863          	beq	a5,s10,6c8 <vprintf+0xf2>
      } else if(c == 'p') {
 65c:	09b78463          	beq	a5,s11,6e4 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 660:	07300713          	li	a4,115
 664:	0ce78663          	beq	a5,a4,730 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 668:	06300713          	li	a4,99
 66c:	0ee78e63          	beq	a5,a4,768 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 670:	11478863          	beq	a5,s4,780 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 674:	85d2                	mv	a1,s4
 676:	8556                	mv	a0,s5
 678:	00000097          	auipc	ra,0x0
 67c:	e92080e7          	jalr	-366(ra) # 50a <putc>
        putc(fd, c);
 680:	85ca                	mv	a1,s2
 682:	8556                	mv	a0,s5
 684:	00000097          	auipc	ra,0x0
 688:	e86080e7          	jalr	-378(ra) # 50a <putc>
      }
      state = 0;
 68c:	4981                	li	s3,0
 68e:	b765                	j	636 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 690:	008b0913          	addi	s2,s6,8
 694:	4685                	li	a3,1
 696:	4629                	li	a2,10
 698:	000b2583          	lw	a1,0(s6)
 69c:	8556                	mv	a0,s5
 69e:	00000097          	auipc	ra,0x0
 6a2:	e8e080e7          	jalr	-370(ra) # 52c <printint>
 6a6:	8b4a                	mv	s6,s2
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	b771                	j	636 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ac:	008b0913          	addi	s2,s6,8
 6b0:	4681                	li	a3,0
 6b2:	4629                	li	a2,10
 6b4:	000b2583          	lw	a1,0(s6)
 6b8:	8556                	mv	a0,s5
 6ba:	00000097          	auipc	ra,0x0
 6be:	e72080e7          	jalr	-398(ra) # 52c <printint>
 6c2:	8b4a                	mv	s6,s2
      state = 0;
 6c4:	4981                	li	s3,0
 6c6:	bf85                	j	636 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6c8:	008b0913          	addi	s2,s6,8
 6cc:	4681                	li	a3,0
 6ce:	4641                	li	a2,16
 6d0:	000b2583          	lw	a1,0(s6)
 6d4:	8556                	mv	a0,s5
 6d6:	00000097          	auipc	ra,0x0
 6da:	e56080e7          	jalr	-426(ra) # 52c <printint>
 6de:	8b4a                	mv	s6,s2
      state = 0;
 6e0:	4981                	li	s3,0
 6e2:	bf91                	j	636 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6e4:	008b0793          	addi	a5,s6,8
 6e8:	f8f43423          	sd	a5,-120(s0)
 6ec:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6f0:	03000593          	li	a1,48
 6f4:	8556                	mv	a0,s5
 6f6:	00000097          	auipc	ra,0x0
 6fa:	e14080e7          	jalr	-492(ra) # 50a <putc>
  putc(fd, 'x');
 6fe:	85ea                	mv	a1,s10
 700:	8556                	mv	a0,s5
 702:	00000097          	auipc	ra,0x0
 706:	e08080e7          	jalr	-504(ra) # 50a <putc>
 70a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 70c:	03c9d793          	srli	a5,s3,0x3c
 710:	97de                	add	a5,a5,s7
 712:	0007c583          	lbu	a1,0(a5)
 716:	8556                	mv	a0,s5
 718:	00000097          	auipc	ra,0x0
 71c:	df2080e7          	jalr	-526(ra) # 50a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 720:	0992                	slli	s3,s3,0x4
 722:	397d                	addiw	s2,s2,-1
 724:	fe0914e3          	bnez	s2,70c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 728:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 72c:	4981                	li	s3,0
 72e:	b721                	j	636 <vprintf+0x60>
        s = va_arg(ap, char*);
 730:	008b0993          	addi	s3,s6,8
 734:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 738:	02090163          	beqz	s2,75a <vprintf+0x184>
        while(*s != 0){
 73c:	00094583          	lbu	a1,0(s2)
 740:	c9a1                	beqz	a1,790 <vprintf+0x1ba>
          putc(fd, *s);
 742:	8556                	mv	a0,s5
 744:	00000097          	auipc	ra,0x0
 748:	dc6080e7          	jalr	-570(ra) # 50a <putc>
          s++;
 74c:	0905                	addi	s2,s2,1
        while(*s != 0){
 74e:	00094583          	lbu	a1,0(s2)
 752:	f9e5                	bnez	a1,742 <vprintf+0x16c>
        s = va_arg(ap, char*);
 754:	8b4e                	mv	s6,s3
      state = 0;
 756:	4981                	li	s3,0
 758:	bdf9                	j	636 <vprintf+0x60>
          s = "(null)";
 75a:	00000917          	auipc	s2,0x0
 75e:	2a690913          	addi	s2,s2,678 # a00 <longjmp_1+0xa>
        while(*s != 0){
 762:	02800593          	li	a1,40
 766:	bff1                	j	742 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 768:	008b0913          	addi	s2,s6,8
 76c:	000b4583          	lbu	a1,0(s6)
 770:	8556                	mv	a0,s5
 772:	00000097          	auipc	ra,0x0
 776:	d98080e7          	jalr	-616(ra) # 50a <putc>
 77a:	8b4a                	mv	s6,s2
      state = 0;
 77c:	4981                	li	s3,0
 77e:	bd65                	j	636 <vprintf+0x60>
        putc(fd, c);
 780:	85d2                	mv	a1,s4
 782:	8556                	mv	a0,s5
 784:	00000097          	auipc	ra,0x0
 788:	d86080e7          	jalr	-634(ra) # 50a <putc>
      state = 0;
 78c:	4981                	li	s3,0
 78e:	b565                	j	636 <vprintf+0x60>
        s = va_arg(ap, char*);
 790:	8b4e                	mv	s6,s3
      state = 0;
 792:	4981                	li	s3,0
 794:	b54d                	j	636 <vprintf+0x60>
    }
  }
}
 796:	70e6                	ld	ra,120(sp)
 798:	7446                	ld	s0,112(sp)
 79a:	74a6                	ld	s1,104(sp)
 79c:	7906                	ld	s2,96(sp)
 79e:	69e6                	ld	s3,88(sp)
 7a0:	6a46                	ld	s4,80(sp)
 7a2:	6aa6                	ld	s5,72(sp)
 7a4:	6b06                	ld	s6,64(sp)
 7a6:	7be2                	ld	s7,56(sp)
 7a8:	7c42                	ld	s8,48(sp)
 7aa:	7ca2                	ld	s9,40(sp)
 7ac:	7d02                	ld	s10,32(sp)
 7ae:	6de2                	ld	s11,24(sp)
 7b0:	6109                	addi	sp,sp,128
 7b2:	8082                	ret

00000000000007b4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7b4:	715d                	addi	sp,sp,-80
 7b6:	ec06                	sd	ra,24(sp)
 7b8:	e822                	sd	s0,16(sp)
 7ba:	1000                	addi	s0,sp,32
 7bc:	e010                	sd	a2,0(s0)
 7be:	e414                	sd	a3,8(s0)
 7c0:	e818                	sd	a4,16(s0)
 7c2:	ec1c                	sd	a5,24(s0)
 7c4:	03043023          	sd	a6,32(s0)
 7c8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7cc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7d0:	8622                	mv	a2,s0
 7d2:	00000097          	auipc	ra,0x0
 7d6:	e04080e7          	jalr	-508(ra) # 5d6 <vprintf>
}
 7da:	60e2                	ld	ra,24(sp)
 7dc:	6442                	ld	s0,16(sp)
 7de:	6161                	addi	sp,sp,80
 7e0:	8082                	ret

00000000000007e2 <printf>:

void
printf(const char *fmt, ...)
{
 7e2:	711d                	addi	sp,sp,-96
 7e4:	ec06                	sd	ra,24(sp)
 7e6:	e822                	sd	s0,16(sp)
 7e8:	1000                	addi	s0,sp,32
 7ea:	e40c                	sd	a1,8(s0)
 7ec:	e810                	sd	a2,16(s0)
 7ee:	ec14                	sd	a3,24(s0)
 7f0:	f018                	sd	a4,32(s0)
 7f2:	f41c                	sd	a5,40(s0)
 7f4:	03043823          	sd	a6,48(s0)
 7f8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7fc:	00840613          	addi	a2,s0,8
 800:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 804:	85aa                	mv	a1,a0
 806:	4505                	li	a0,1
 808:	00000097          	auipc	ra,0x0
 80c:	dce080e7          	jalr	-562(ra) # 5d6 <vprintf>
}
 810:	60e2                	ld	ra,24(sp)
 812:	6442                	ld	s0,16(sp)
 814:	6125                	addi	sp,sp,96
 816:	8082                	ret

0000000000000818 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 818:	1141                	addi	sp,sp,-16
 81a:	e422                	sd	s0,8(sp)
 81c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 81e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 822:	00000797          	auipc	a5,0x0
 826:	2067b783          	ld	a5,518(a5) # a28 <freep>
 82a:	a805                	j	85a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 82c:	4618                	lw	a4,8(a2)
 82e:	9db9                	addw	a1,a1,a4
 830:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 834:	6398                	ld	a4,0(a5)
 836:	6318                	ld	a4,0(a4)
 838:	fee53823          	sd	a4,-16(a0)
 83c:	a091                	j	880 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 83e:	ff852703          	lw	a4,-8(a0)
 842:	9e39                	addw	a2,a2,a4
 844:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 846:	ff053703          	ld	a4,-16(a0)
 84a:	e398                	sd	a4,0(a5)
 84c:	a099                	j	892 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84e:	6398                	ld	a4,0(a5)
 850:	00e7e463          	bltu	a5,a4,858 <free+0x40>
 854:	00e6ea63          	bltu	a3,a4,868 <free+0x50>
{
 858:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85a:	fed7fae3          	bgeu	a5,a3,84e <free+0x36>
 85e:	6398                	ld	a4,0(a5)
 860:	00e6e463          	bltu	a3,a4,868 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 864:	fee7eae3          	bltu	a5,a4,858 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 868:	ff852583          	lw	a1,-8(a0)
 86c:	6390                	ld	a2,0(a5)
 86e:	02059713          	slli	a4,a1,0x20
 872:	9301                	srli	a4,a4,0x20
 874:	0712                	slli	a4,a4,0x4
 876:	9736                	add	a4,a4,a3
 878:	fae60ae3          	beq	a2,a4,82c <free+0x14>
    bp->s.ptr = p->s.ptr;
 87c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 880:	4790                	lw	a2,8(a5)
 882:	02061713          	slli	a4,a2,0x20
 886:	9301                	srli	a4,a4,0x20
 888:	0712                	slli	a4,a4,0x4
 88a:	973e                	add	a4,a4,a5
 88c:	fae689e3          	beq	a3,a4,83e <free+0x26>
  } else
    p->s.ptr = bp;
 890:	e394                	sd	a3,0(a5)
  freep = p;
 892:	00000717          	auipc	a4,0x0
 896:	18f73b23          	sd	a5,406(a4) # a28 <freep>
}
 89a:	6422                	ld	s0,8(sp)
 89c:	0141                	addi	sp,sp,16
 89e:	8082                	ret

00000000000008a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8a0:	7139                	addi	sp,sp,-64
 8a2:	fc06                	sd	ra,56(sp)
 8a4:	f822                	sd	s0,48(sp)
 8a6:	f426                	sd	s1,40(sp)
 8a8:	f04a                	sd	s2,32(sp)
 8aa:	ec4e                	sd	s3,24(sp)
 8ac:	e852                	sd	s4,16(sp)
 8ae:	e456                	sd	s5,8(sp)
 8b0:	e05a                	sd	s6,0(sp)
 8b2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b4:	02051493          	slli	s1,a0,0x20
 8b8:	9081                	srli	s1,s1,0x20
 8ba:	04bd                	addi	s1,s1,15
 8bc:	8091                	srli	s1,s1,0x4
 8be:	0014899b          	addiw	s3,s1,1
 8c2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8c4:	00000517          	auipc	a0,0x0
 8c8:	16453503          	ld	a0,356(a0) # a28 <freep>
 8cc:	c515                	beqz	a0,8f8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d0:	4798                	lw	a4,8(a5)
 8d2:	02977f63          	bgeu	a4,s1,910 <malloc+0x70>
 8d6:	8a4e                	mv	s4,s3
 8d8:	0009871b          	sext.w	a4,s3
 8dc:	6685                	lui	a3,0x1
 8de:	00d77363          	bgeu	a4,a3,8e4 <malloc+0x44>
 8e2:	6a05                	lui	s4,0x1
 8e4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8e8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8ec:	00000917          	auipc	s2,0x0
 8f0:	13c90913          	addi	s2,s2,316 # a28 <freep>
  if(p == (char*)-1)
 8f4:	5afd                	li	s5,-1
 8f6:	a88d                	j	968 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 8f8:	00000797          	auipc	a5,0x0
 8fc:	1a878793          	addi	a5,a5,424 # aa0 <base>
 900:	00000717          	auipc	a4,0x0
 904:	12f73423          	sd	a5,296(a4) # a28 <freep>
 908:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 90a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 90e:	b7e1                	j	8d6 <malloc+0x36>
      if(p->s.size == nunits)
 910:	02e48b63          	beq	s1,a4,946 <malloc+0xa6>
        p->s.size -= nunits;
 914:	4137073b          	subw	a4,a4,s3
 918:	c798                	sw	a4,8(a5)
        p += p->s.size;
 91a:	1702                	slli	a4,a4,0x20
 91c:	9301                	srli	a4,a4,0x20
 91e:	0712                	slli	a4,a4,0x4
 920:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 922:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 926:	00000717          	auipc	a4,0x0
 92a:	10a73123          	sd	a0,258(a4) # a28 <freep>
      return (void*)(p + 1);
 92e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 932:	70e2                	ld	ra,56(sp)
 934:	7442                	ld	s0,48(sp)
 936:	74a2                	ld	s1,40(sp)
 938:	7902                	ld	s2,32(sp)
 93a:	69e2                	ld	s3,24(sp)
 93c:	6a42                	ld	s4,16(sp)
 93e:	6aa2                	ld	s5,8(sp)
 940:	6b02                	ld	s6,0(sp)
 942:	6121                	addi	sp,sp,64
 944:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 946:	6398                	ld	a4,0(a5)
 948:	e118                	sd	a4,0(a0)
 94a:	bff1                	j	926 <malloc+0x86>
  hp->s.size = nu;
 94c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 950:	0541                	addi	a0,a0,16
 952:	00000097          	auipc	ra,0x0
 956:	ec6080e7          	jalr	-314(ra) # 818 <free>
  return freep;
 95a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 95e:	d971                	beqz	a0,932 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 960:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 962:	4798                	lw	a4,8(a5)
 964:	fa9776e3          	bgeu	a4,s1,910 <malloc+0x70>
    if(p == freep)
 968:	00093703          	ld	a4,0(s2)
 96c:	853e                	mv	a0,a5
 96e:	fef719e3          	bne	a4,a5,960 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 972:	8552                	mv	a0,s4
 974:	00000097          	auipc	ra,0x0
 978:	b7e080e7          	jalr	-1154(ra) # 4f2 <sbrk>
  if(p == (char*)-1)
 97c:	fd5518e3          	bne	a0,s5,94c <malloc+0xac>
        return 0;
 980:	4501                	li	a0,0
 982:	bf45                	j	932 <malloc+0x92>

0000000000000984 <setjmp>:
 984:	e100                	sd	s0,0(a0)
 986:	e504                	sd	s1,8(a0)
 988:	01253823          	sd	s2,16(a0)
 98c:	01353c23          	sd	s3,24(a0)
 990:	03453023          	sd	s4,32(a0)
 994:	03553423          	sd	s5,40(a0)
 998:	03653823          	sd	s6,48(a0)
 99c:	03753c23          	sd	s7,56(a0)
 9a0:	05853023          	sd	s8,64(a0)
 9a4:	05953423          	sd	s9,72(a0)
 9a8:	05a53823          	sd	s10,80(a0)
 9ac:	05b53c23          	sd	s11,88(a0)
 9b0:	06153023          	sd	ra,96(a0)
 9b4:	06253423          	sd	sp,104(a0)
 9b8:	4501                	li	a0,0
 9ba:	8082                	ret

00000000000009bc <longjmp>:
 9bc:	6100                	ld	s0,0(a0)
 9be:	6504                	ld	s1,8(a0)
 9c0:	01053903          	ld	s2,16(a0)
 9c4:	01853983          	ld	s3,24(a0)
 9c8:	02053a03          	ld	s4,32(a0)
 9cc:	02853a83          	ld	s5,40(a0)
 9d0:	03053b03          	ld	s6,48(a0)
 9d4:	03853b83          	ld	s7,56(a0)
 9d8:	04053c03          	ld	s8,64(a0)
 9dc:	04853c83          	ld	s9,72(a0)
 9e0:	05053d03          	ld	s10,80(a0)
 9e4:	05853d83          	ld	s11,88(a0)
 9e8:	06053083          	ld	ra,96(a0)
 9ec:	06853103          	ld	sp,104(a0)
 9f0:	c199                	beqz	a1,9f6 <longjmp_1>
 9f2:	852e                	mv	a0,a1
 9f4:	8082                	ret

00000000000009f6 <longjmp_1>:
 9f6:	4505                	li	a0,1
 9f8:	8082                	ret
