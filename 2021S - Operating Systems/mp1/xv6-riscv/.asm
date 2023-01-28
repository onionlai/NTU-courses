
user/_mp1:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <f3>:
#include "user/threads.h"

#define NULL 0

void f3(void *arg)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
    int i = 10000;
    while (1) {
        printf("thread 3: %d\n", i++);
   e:	6489                	lui	s1,0x2
  10:	71048593          	addi	a1,s1,1808 # 2710 <__global_pointer$+0x132f>
  14:	00001517          	auipc	a0,0x1
  18:	b7450513          	addi	a0,a0,-1164 # b88 <thread_start_threading+0x36>
  1c:	00000097          	auipc	ra,0x0
  20:	756080e7          	jalr	1878(ra) # 772 <printf>
  24:	71148493          	addi	s1,s1,1809
  28:	00001997          	auipc	s3,0x1
  2c:	b6098993          	addi	s3,s3,-1184 # b88 <thread_start_threading+0x36>
        if(i == 10005){
  30:	6909                	lui	s2,0x2
  32:	71590913          	addi	s2,s2,1813 # 2715 <__global_pointer$+0x1334>
            return;
            //thread_exit();
        }
        thread_yield();
  36:	00001097          	auipc	ra,0x1
  3a:	ae4080e7          	jalr	-1308(ra) # b1a <thread_yield>
        printf("thread 3: %d\n", i++);
  3e:	85a6                	mv	a1,s1
  40:	2485                	addiw	s1,s1,1
  42:	854e                	mv	a0,s3
  44:	00000097          	auipc	ra,0x0
  48:	72e080e7          	jalr	1838(ra) # 772 <printf>
        if(i == 10005){
  4c:	ff2495e3          	bne	s1,s2,36 <f3+0x36>
    }
}
  50:	70a2                	ld	ra,40(sp)
  52:	7402                	ld	s0,32(sp)
  54:	64e2                	ld	s1,24(sp)
  56:	6942                	ld	s2,16(sp)
  58:	69a2                	ld	s3,8(sp)
  5a:	6145                	addi	sp,sp,48
  5c:	8082                	ret

000000000000005e <f2>:

void f2(void *arg)
{
  5e:	7179                	addi	sp,sp,-48
  60:	f406                	sd	ra,40(sp)
  62:	f022                	sd	s0,32(sp)
  64:	ec26                	sd	s1,24(sp)
  66:	e84a                	sd	s2,16(sp)
  68:	e44e                	sd	s3,8(sp)
  6a:	e052                	sd	s4,0(sp)
  6c:	1800                	addi	s0,sp,48
    int i = 0;
    while(1) {
        printf("thread 2: %d\n",i++);
  6e:	4581                	li	a1,0
  70:	00001517          	auipc	a0,0x1
  74:	b2850513          	addi	a0,a0,-1240 # b98 <thread_start_threading+0x46>
  78:	00000097          	auipc	ra,0x0
  7c:	6fa080e7          	jalr	1786(ra) # 772 <printf>
  80:	4485                	li	s1,1
  82:	00001a17          	auipc	s4,0x1
  86:	b16a0a13          	addi	s4,s4,-1258 # b98 <thread_start_threading+0x46>
        if (i == 10) {
  8a:	49a9                	li	s3,10
  8c:	a011                	j	90 <f2+0x32>
        printf("thread 2: %d\n",i++);
  8e:	84ca                	mv	s1,s2
            thread_exit();
        }
        thread_yield();
  90:	00001097          	auipc	ra,0x1
  94:	a8a080e7          	jalr	-1398(ra) # b1a <thread_yield>
        printf("thread 2: %d\n",i++);
  98:	0014891b          	addiw	s2,s1,1
  9c:	85a6                	mv	a1,s1
  9e:	8552                	mv	a0,s4
  a0:	00000097          	auipc	ra,0x0
  a4:	6d2080e7          	jalr	1746(ra) # 772 <printf>
        if (i == 10) {
  a8:	ff3913e3          	bne	s2,s3,8e <f2+0x30>
            thread_exit();
  ac:	00001097          	auipc	ra,0x1
  b0:	98c080e7          	jalr	-1652(ra) # a38 <thread_exit>
  b4:	bfe9                	j	8e <f2+0x30>

00000000000000b6 <f1>:
    }
}

void f1(void *arg)
{
  b6:	7179                	addi	sp,sp,-48
  b8:	f406                	sd	ra,40(sp)
  ba:	f022                	sd	s0,32(sp)
  bc:	ec26                	sd	s1,24(sp)
  be:	e84a                	sd	s2,16(sp)
  c0:	e44e                	sd	s3,8(sp)
  c2:	e052                	sd	s4,0(sp)
  c4:	1800                	addi	s0,sp,48
    int i = 100;

    struct thread *t2 = thread_create(f2, NULL);
  c6:	4581                	li	a1,0
  c8:	00000517          	auipc	a0,0x0
  cc:	f9650513          	addi	a0,a0,-106 # 5e <f2>
  d0:	00001097          	auipc	ra,0x1
  d4:	8ba080e7          	jalr	-1862(ra) # 98a <thread_create>
    thread_add_runqueue(t2);
  d8:	00001097          	auipc	ra,0x1
  dc:	916080e7          	jalr	-1770(ra) # 9ee <thread_add_runqueue>
    struct thread *t3 = thread_create(f3, NULL);
  e0:	4581                	li	a1,0
  e2:	00000517          	auipc	a0,0x0
  e6:	f1e50513          	addi	a0,a0,-226 # 0 <f3>
  ea:	00001097          	auipc	ra,0x1
  ee:	8a0080e7          	jalr	-1888(ra) # 98a <thread_create>
    thread_add_runqueue(t3);
  f2:	00001097          	auipc	ra,0x1
  f6:	8fc080e7          	jalr	-1796(ra) # 9ee <thread_add_runqueue>
    while(1) {
        printf("thread 1: %d\n", i++);
  fa:	06400593          	li	a1,100
  fe:	00001517          	auipc	a0,0x1
 102:	aaa50513          	addi	a0,a0,-1366 # ba8 <thread_start_threading+0x56>
 106:	00000097          	auipc	ra,0x0
 10a:	66c080e7          	jalr	1644(ra) # 772 <printf>
 10e:	06500493          	li	s1,101
 112:	00001a17          	auipc	s4,0x1
 116:	a96a0a13          	addi	s4,s4,-1386 # ba8 <thread_start_threading+0x56>
        if (i == 110) {
 11a:	06e00993          	li	s3,110
 11e:	a011                	j	122 <f1+0x6c>
        printf("thread 1: %d\n", i++);
 120:	84ca                	mv	s1,s2
            thread_exit();
        }
        thread_yield();
 122:	00001097          	auipc	ra,0x1
 126:	9f8080e7          	jalr	-1544(ra) # b1a <thread_yield>
        printf("thread 1: %d\n", i++);
 12a:	0014891b          	addiw	s2,s1,1
 12e:	85a6                	mv	a1,s1
 130:	8552                	mv	a0,s4
 132:	00000097          	auipc	ra,0x0
 136:	640080e7          	jalr	1600(ra) # 772 <printf>
        if (i == 110) {
 13a:	ff3913e3          	bne	s2,s3,120 <f1+0x6a>
            thread_exit();
 13e:	00001097          	auipc	ra,0x1
 142:	8fa080e7          	jalr	-1798(ra) # a38 <thread_exit>
 146:	bfe9                	j	120 <f1+0x6a>

0000000000000148 <main>:
    }
}

int main(int argc, char **argv)
{
 148:	1141                	addi	sp,sp,-16
 14a:	e406                	sd	ra,8(sp)
 14c:	e022                	sd	s0,0(sp)
 14e:	0800                	addi	s0,sp,16
    struct thread *t1 = thread_create(f1, NULL);
 150:	4581                	li	a1,0
 152:	00000517          	auipc	a0,0x0
 156:	f6450513          	addi	a0,a0,-156 # b6 <f1>
 15a:	00001097          	auipc	ra,0x1
 15e:	830080e7          	jalr	-2000(ra) # 98a <thread_create>
    thread_add_runqueue(t1);
 162:	00001097          	auipc	ra,0x1
 166:	88c080e7          	jalr	-1908(ra) # 9ee <thread_add_runqueue>
    thread_start_threading();
 16a:	00001097          	auipc	ra,0x1
 16e:	9e8080e7          	jalr	-1560(ra) # b52 <thread_start_threading>
    printf("\nexited\n");
 172:	00001517          	auipc	a0,0x1
 176:	a4650513          	addi	a0,a0,-1466 # bb8 <thread_start_threading+0x66>
 17a:	00000097          	auipc	ra,0x0
 17e:	5f8080e7          	jalr	1528(ra) # 772 <printf>
    exit(0);
 182:	4501                	li	a0,0
 184:	00000097          	auipc	ra,0x0
 188:	276080e7          	jalr	630(ra) # 3fa <exit>

000000000000018c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 18c:	1141                	addi	sp,sp,-16
 18e:	e422                	sd	s0,8(sp)
 190:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 192:	87aa                	mv	a5,a0
 194:	0585                	addi	a1,a1,1
 196:	0785                	addi	a5,a5,1
 198:	fff5c703          	lbu	a4,-1(a1)
 19c:	fee78fa3          	sb	a4,-1(a5)
 1a0:	fb75                	bnez	a4,194 <strcpy+0x8>
    ;
  return os;
}
 1a2:	6422                	ld	s0,8(sp)
 1a4:	0141                	addi	sp,sp,16
 1a6:	8082                	ret

00000000000001a8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a8:	1141                	addi	sp,sp,-16
 1aa:	e422                	sd	s0,8(sp)
 1ac:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1ae:	00054783          	lbu	a5,0(a0)
 1b2:	cb91                	beqz	a5,1c6 <strcmp+0x1e>
 1b4:	0005c703          	lbu	a4,0(a1)
 1b8:	00f71763          	bne	a4,a5,1c6 <strcmp+0x1e>
    p++, q++;
 1bc:	0505                	addi	a0,a0,1
 1be:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1c0:	00054783          	lbu	a5,0(a0)
 1c4:	fbe5                	bnez	a5,1b4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1c6:	0005c503          	lbu	a0,0(a1)
}
 1ca:	40a7853b          	subw	a0,a5,a0
 1ce:	6422                	ld	s0,8(sp)
 1d0:	0141                	addi	sp,sp,16
 1d2:	8082                	ret

00000000000001d4 <strlen>:

uint
strlen(const char *s)
{
 1d4:	1141                	addi	sp,sp,-16
 1d6:	e422                	sd	s0,8(sp)
 1d8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1da:	00054783          	lbu	a5,0(a0)
 1de:	cf91                	beqz	a5,1fa <strlen+0x26>
 1e0:	0505                	addi	a0,a0,1
 1e2:	87aa                	mv	a5,a0
 1e4:	4685                	li	a3,1
 1e6:	9e89                	subw	a3,a3,a0
 1e8:	00f6853b          	addw	a0,a3,a5
 1ec:	0785                	addi	a5,a5,1
 1ee:	fff7c703          	lbu	a4,-1(a5)
 1f2:	fb7d                	bnez	a4,1e8 <strlen+0x14>
    ;
  return n;
}
 1f4:	6422                	ld	s0,8(sp)
 1f6:	0141                	addi	sp,sp,16
 1f8:	8082                	ret
  for(n = 0; s[n]; n++)
 1fa:	4501                	li	a0,0
 1fc:	bfe5                	j	1f4 <strlen+0x20>

00000000000001fe <memset>:

void*
memset(void *dst, int c, uint n)
{
 1fe:	1141                	addi	sp,sp,-16
 200:	e422                	sd	s0,8(sp)
 202:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 204:	ca19                	beqz	a2,21a <memset+0x1c>
 206:	87aa                	mv	a5,a0
 208:	1602                	slli	a2,a2,0x20
 20a:	9201                	srli	a2,a2,0x20
 20c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 210:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 214:	0785                	addi	a5,a5,1
 216:	fee79de3          	bne	a5,a4,210 <memset+0x12>
  }
  return dst;
}
 21a:	6422                	ld	s0,8(sp)
 21c:	0141                	addi	sp,sp,16
 21e:	8082                	ret

0000000000000220 <strchr>:

char*
strchr(const char *s, char c)
{
 220:	1141                	addi	sp,sp,-16
 222:	e422                	sd	s0,8(sp)
 224:	0800                	addi	s0,sp,16
  for(; *s; s++)
 226:	00054783          	lbu	a5,0(a0)
 22a:	cb99                	beqz	a5,240 <strchr+0x20>
    if(*s == c)
 22c:	00f58763          	beq	a1,a5,23a <strchr+0x1a>
  for(; *s; s++)
 230:	0505                	addi	a0,a0,1
 232:	00054783          	lbu	a5,0(a0)
 236:	fbfd                	bnez	a5,22c <strchr+0xc>
      return (char*)s;
  return 0;
 238:	4501                	li	a0,0
}
 23a:	6422                	ld	s0,8(sp)
 23c:	0141                	addi	sp,sp,16
 23e:	8082                	ret
  return 0;
 240:	4501                	li	a0,0
 242:	bfe5                	j	23a <strchr+0x1a>

0000000000000244 <gets>:

char*
gets(char *buf, int max)
{
 244:	711d                	addi	sp,sp,-96
 246:	ec86                	sd	ra,88(sp)
 248:	e8a2                	sd	s0,80(sp)
 24a:	e4a6                	sd	s1,72(sp)
 24c:	e0ca                	sd	s2,64(sp)
 24e:	fc4e                	sd	s3,56(sp)
 250:	f852                	sd	s4,48(sp)
 252:	f456                	sd	s5,40(sp)
 254:	f05a                	sd	s6,32(sp)
 256:	ec5e                	sd	s7,24(sp)
 258:	1080                	addi	s0,sp,96
 25a:	8baa                	mv	s7,a0
 25c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25e:	892a                	mv	s2,a0
 260:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 262:	4aa9                	li	s5,10
 264:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 266:	89a6                	mv	s3,s1
 268:	2485                	addiw	s1,s1,1
 26a:	0344d863          	bge	s1,s4,29a <gets+0x56>
    cc = read(0, &c, 1);
 26e:	4605                	li	a2,1
 270:	faf40593          	addi	a1,s0,-81
 274:	4501                	li	a0,0
 276:	00000097          	auipc	ra,0x0
 27a:	19c080e7          	jalr	412(ra) # 412 <read>
    if(cc < 1)
 27e:	00a05e63          	blez	a0,29a <gets+0x56>
    buf[i++] = c;
 282:	faf44783          	lbu	a5,-81(s0)
 286:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 28a:	01578763          	beq	a5,s5,298 <gets+0x54>
 28e:	0905                	addi	s2,s2,1
 290:	fd679be3          	bne	a5,s6,266 <gets+0x22>
  for(i=0; i+1 < max; ){
 294:	89a6                	mv	s3,s1
 296:	a011                	j	29a <gets+0x56>
 298:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 29a:	99de                	add	s3,s3,s7
 29c:	00098023          	sb	zero,0(s3)
  return buf;
}
 2a0:	855e                	mv	a0,s7
 2a2:	60e6                	ld	ra,88(sp)
 2a4:	6446                	ld	s0,80(sp)
 2a6:	64a6                	ld	s1,72(sp)
 2a8:	6906                	ld	s2,64(sp)
 2aa:	79e2                	ld	s3,56(sp)
 2ac:	7a42                	ld	s4,48(sp)
 2ae:	7aa2                	ld	s5,40(sp)
 2b0:	7b02                	ld	s6,32(sp)
 2b2:	6be2                	ld	s7,24(sp)
 2b4:	6125                	addi	sp,sp,96
 2b6:	8082                	ret

00000000000002b8 <stat>:

int
stat(const char *n, struct stat *st)
{
 2b8:	1101                	addi	sp,sp,-32
 2ba:	ec06                	sd	ra,24(sp)
 2bc:	e822                	sd	s0,16(sp)
 2be:	e426                	sd	s1,8(sp)
 2c0:	e04a                	sd	s2,0(sp)
 2c2:	1000                	addi	s0,sp,32
 2c4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c6:	4581                	li	a1,0
 2c8:	00000097          	auipc	ra,0x0
 2cc:	172080e7          	jalr	370(ra) # 43a <open>
  if(fd < 0)
 2d0:	02054563          	bltz	a0,2fa <stat+0x42>
 2d4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2d6:	85ca                	mv	a1,s2
 2d8:	00000097          	auipc	ra,0x0
 2dc:	17a080e7          	jalr	378(ra) # 452 <fstat>
 2e0:	892a                	mv	s2,a0
  close(fd);
 2e2:	8526                	mv	a0,s1
 2e4:	00000097          	auipc	ra,0x0
 2e8:	13e080e7          	jalr	318(ra) # 422 <close>
  return r;
}
 2ec:	854a                	mv	a0,s2
 2ee:	60e2                	ld	ra,24(sp)
 2f0:	6442                	ld	s0,16(sp)
 2f2:	64a2                	ld	s1,8(sp)
 2f4:	6902                	ld	s2,0(sp)
 2f6:	6105                	addi	sp,sp,32
 2f8:	8082                	ret
    return -1;
 2fa:	597d                	li	s2,-1
 2fc:	bfc5                	j	2ec <stat+0x34>

00000000000002fe <atoi>:

int
atoi(const char *s)
{
 2fe:	1141                	addi	sp,sp,-16
 300:	e422                	sd	s0,8(sp)
 302:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 304:	00054603          	lbu	a2,0(a0)
 308:	fd06079b          	addiw	a5,a2,-48
 30c:	0ff7f793          	andi	a5,a5,255
 310:	4725                	li	a4,9
 312:	02f76963          	bltu	a4,a5,344 <atoi+0x46>
 316:	86aa                	mv	a3,a0
  n = 0;
 318:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 31a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 31c:	0685                	addi	a3,a3,1
 31e:	0025179b          	slliw	a5,a0,0x2
 322:	9fa9                	addw	a5,a5,a0
 324:	0017979b          	slliw	a5,a5,0x1
 328:	9fb1                	addw	a5,a5,a2
 32a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 32e:	0006c603          	lbu	a2,0(a3)
 332:	fd06071b          	addiw	a4,a2,-48
 336:	0ff77713          	andi	a4,a4,255
 33a:	fee5f1e3          	bgeu	a1,a4,31c <atoi+0x1e>
  return n;
}
 33e:	6422                	ld	s0,8(sp)
 340:	0141                	addi	sp,sp,16
 342:	8082                	ret
  n = 0;
 344:	4501                	li	a0,0
 346:	bfe5                	j	33e <atoi+0x40>

0000000000000348 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 348:	1141                	addi	sp,sp,-16
 34a:	e422                	sd	s0,8(sp)
 34c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 34e:	02b57463          	bgeu	a0,a1,376 <memmove+0x2e>
    while(n-- > 0)
 352:	00c05f63          	blez	a2,370 <memmove+0x28>
 356:	1602                	slli	a2,a2,0x20
 358:	9201                	srli	a2,a2,0x20
 35a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 35e:	872a                	mv	a4,a0
      *dst++ = *src++;
 360:	0585                	addi	a1,a1,1
 362:	0705                	addi	a4,a4,1
 364:	fff5c683          	lbu	a3,-1(a1)
 368:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 36c:	fee79ae3          	bne	a5,a4,360 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 370:	6422                	ld	s0,8(sp)
 372:	0141                	addi	sp,sp,16
 374:	8082                	ret
    dst += n;
 376:	00c50733          	add	a4,a0,a2
    src += n;
 37a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 37c:	fec05ae3          	blez	a2,370 <memmove+0x28>
 380:	fff6079b          	addiw	a5,a2,-1
 384:	1782                	slli	a5,a5,0x20
 386:	9381                	srli	a5,a5,0x20
 388:	fff7c793          	not	a5,a5
 38c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 38e:	15fd                	addi	a1,a1,-1
 390:	177d                	addi	a4,a4,-1
 392:	0005c683          	lbu	a3,0(a1)
 396:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 39a:	fee79ae3          	bne	a5,a4,38e <memmove+0x46>
 39e:	bfc9                	j	370 <memmove+0x28>

00000000000003a0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3a0:	1141                	addi	sp,sp,-16
 3a2:	e422                	sd	s0,8(sp)
 3a4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3a6:	ca05                	beqz	a2,3d6 <memcmp+0x36>
 3a8:	fff6069b          	addiw	a3,a2,-1
 3ac:	1682                	slli	a3,a3,0x20
 3ae:	9281                	srli	a3,a3,0x20
 3b0:	0685                	addi	a3,a3,1
 3b2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3b4:	00054783          	lbu	a5,0(a0)
 3b8:	0005c703          	lbu	a4,0(a1)
 3bc:	00e79863          	bne	a5,a4,3cc <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3c0:	0505                	addi	a0,a0,1
    p2++;
 3c2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3c4:	fed518e3          	bne	a0,a3,3b4 <memcmp+0x14>
  }
  return 0;
 3c8:	4501                	li	a0,0
 3ca:	a019                	j	3d0 <memcmp+0x30>
      return *p1 - *p2;
 3cc:	40e7853b          	subw	a0,a5,a4
}
 3d0:	6422                	ld	s0,8(sp)
 3d2:	0141                	addi	sp,sp,16
 3d4:	8082                	ret
  return 0;
 3d6:	4501                	li	a0,0
 3d8:	bfe5                	j	3d0 <memcmp+0x30>

00000000000003da <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3da:	1141                	addi	sp,sp,-16
 3dc:	e406                	sd	ra,8(sp)
 3de:	e022                	sd	s0,0(sp)
 3e0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3e2:	00000097          	auipc	ra,0x0
 3e6:	f66080e7          	jalr	-154(ra) # 348 <memmove>
}
 3ea:	60a2                	ld	ra,8(sp)
 3ec:	6402                	ld	s0,0(sp)
 3ee:	0141                	addi	sp,sp,16
 3f0:	8082                	ret

00000000000003f2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3f2:	4885                	li	a7,1
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <exit>:
.global exit
exit:
 li a7, SYS_exit
 3fa:	4889                	li	a7,2
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <wait>:
.global wait
wait:
 li a7, SYS_wait
 402:	488d                	li	a7,3
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 40a:	4891                	li	a7,4
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <read>:
.global read
read:
 li a7, SYS_read
 412:	4895                	li	a7,5
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <write>:
.global write
write:
 li a7, SYS_write
 41a:	48c1                	li	a7,16
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <close>:
.global close
close:
 li a7, SYS_close
 422:	48d5                	li	a7,21
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <kill>:
.global kill
kill:
 li a7, SYS_kill
 42a:	4899                	li	a7,6
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <exec>:
.global exec
exec:
 li a7, SYS_exec
 432:	489d                	li	a7,7
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <open>:
.global open
open:
 li a7, SYS_open
 43a:	48bd                	li	a7,15
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 442:	48c5                	li	a7,17
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 44a:	48c9                	li	a7,18
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 452:	48a1                	li	a7,8
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <link>:
.global link
link:
 li a7, SYS_link
 45a:	48cd                	li	a7,19
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 462:	48d1                	li	a7,20
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 46a:	48a5                	li	a7,9
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <dup>:
.global dup
dup:
 li a7, SYS_dup
 472:	48a9                	li	a7,10
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 47a:	48ad                	li	a7,11
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 482:	48b1                	li	a7,12
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 48a:	48b5                	li	a7,13
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 492:	48b9                	li	a7,14
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 49a:	1101                	addi	sp,sp,-32
 49c:	ec06                	sd	ra,24(sp)
 49e:	e822                	sd	s0,16(sp)
 4a0:	1000                	addi	s0,sp,32
 4a2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4a6:	4605                	li	a2,1
 4a8:	fef40593          	addi	a1,s0,-17
 4ac:	00000097          	auipc	ra,0x0
 4b0:	f6e080e7          	jalr	-146(ra) # 41a <write>
}
 4b4:	60e2                	ld	ra,24(sp)
 4b6:	6442                	ld	s0,16(sp)
 4b8:	6105                	addi	sp,sp,32
 4ba:	8082                	ret

00000000000004bc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4bc:	7139                	addi	sp,sp,-64
 4be:	fc06                	sd	ra,56(sp)
 4c0:	f822                	sd	s0,48(sp)
 4c2:	f426                	sd	s1,40(sp)
 4c4:	f04a                	sd	s2,32(sp)
 4c6:	ec4e                	sd	s3,24(sp)
 4c8:	0080                	addi	s0,sp,64
 4ca:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4cc:	c299                	beqz	a3,4d2 <printint+0x16>
 4ce:	0805c863          	bltz	a1,55e <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4d2:	2581                	sext.w	a1,a1
  neg = 0;
 4d4:	4881                	li	a7,0
 4d6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4da:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4dc:	2601                	sext.w	a2,a2
 4de:	00000517          	auipc	a0,0x0
 4e2:	6f250513          	addi	a0,a0,1778 # bd0 <digits>
 4e6:	883a                	mv	a6,a4
 4e8:	2705                	addiw	a4,a4,1
 4ea:	02c5f7bb          	remuw	a5,a1,a2
 4ee:	1782                	slli	a5,a5,0x20
 4f0:	9381                	srli	a5,a5,0x20
 4f2:	97aa                	add	a5,a5,a0
 4f4:	0007c783          	lbu	a5,0(a5)
 4f8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4fc:	0005879b          	sext.w	a5,a1
 500:	02c5d5bb          	divuw	a1,a1,a2
 504:	0685                	addi	a3,a3,1
 506:	fec7f0e3          	bgeu	a5,a2,4e6 <printint+0x2a>
  if(neg)
 50a:	00088b63          	beqz	a7,520 <printint+0x64>
    buf[i++] = '-';
 50e:	fd040793          	addi	a5,s0,-48
 512:	973e                	add	a4,a4,a5
 514:	02d00793          	li	a5,45
 518:	fef70823          	sb	a5,-16(a4)
 51c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 520:	02e05863          	blez	a4,550 <printint+0x94>
 524:	fc040793          	addi	a5,s0,-64
 528:	00e78933          	add	s2,a5,a4
 52c:	fff78993          	addi	s3,a5,-1
 530:	99ba                	add	s3,s3,a4
 532:	377d                	addiw	a4,a4,-1
 534:	1702                	slli	a4,a4,0x20
 536:	9301                	srli	a4,a4,0x20
 538:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 53c:	fff94583          	lbu	a1,-1(s2)
 540:	8526                	mv	a0,s1
 542:	00000097          	auipc	ra,0x0
 546:	f58080e7          	jalr	-168(ra) # 49a <putc>
  while(--i >= 0)
 54a:	197d                	addi	s2,s2,-1
 54c:	ff3918e3          	bne	s2,s3,53c <printint+0x80>
}
 550:	70e2                	ld	ra,56(sp)
 552:	7442                	ld	s0,48(sp)
 554:	74a2                	ld	s1,40(sp)
 556:	7902                	ld	s2,32(sp)
 558:	69e2                	ld	s3,24(sp)
 55a:	6121                	addi	sp,sp,64
 55c:	8082                	ret
    x = -xx;
 55e:	40b005bb          	negw	a1,a1
    neg = 1;
 562:	4885                	li	a7,1
    x = -xx;
 564:	bf8d                	j	4d6 <printint+0x1a>

0000000000000566 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 566:	7119                	addi	sp,sp,-128
 568:	fc86                	sd	ra,120(sp)
 56a:	f8a2                	sd	s0,112(sp)
 56c:	f4a6                	sd	s1,104(sp)
 56e:	f0ca                	sd	s2,96(sp)
 570:	ecce                	sd	s3,88(sp)
 572:	e8d2                	sd	s4,80(sp)
 574:	e4d6                	sd	s5,72(sp)
 576:	e0da                	sd	s6,64(sp)
 578:	fc5e                	sd	s7,56(sp)
 57a:	f862                	sd	s8,48(sp)
 57c:	f466                	sd	s9,40(sp)
 57e:	f06a                	sd	s10,32(sp)
 580:	ec6e                	sd	s11,24(sp)
 582:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 584:	0005c903          	lbu	s2,0(a1)
 588:	18090f63          	beqz	s2,726 <vprintf+0x1c0>
 58c:	8aaa                	mv	s5,a0
 58e:	8b32                	mv	s6,a2
 590:	00158493          	addi	s1,a1,1
  state = 0;
 594:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 596:	02500a13          	li	s4,37
      if(c == 'd'){
 59a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 59e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 5a2:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 5a6:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5aa:	00000b97          	auipc	s7,0x0
 5ae:	626b8b93          	addi	s7,s7,1574 # bd0 <digits>
 5b2:	a839                	j	5d0 <vprintf+0x6a>
        putc(fd, c);
 5b4:	85ca                	mv	a1,s2
 5b6:	8556                	mv	a0,s5
 5b8:	00000097          	auipc	ra,0x0
 5bc:	ee2080e7          	jalr	-286(ra) # 49a <putc>
 5c0:	a019                	j	5c6 <vprintf+0x60>
    } else if(state == '%'){
 5c2:	01498f63          	beq	s3,s4,5e0 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5c6:	0485                	addi	s1,s1,1
 5c8:	fff4c903          	lbu	s2,-1(s1)
 5cc:	14090d63          	beqz	s2,726 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5d0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5d4:	fe0997e3          	bnez	s3,5c2 <vprintf+0x5c>
      if(c == '%'){
 5d8:	fd479ee3          	bne	a5,s4,5b4 <vprintf+0x4e>
        state = '%';
 5dc:	89be                	mv	s3,a5
 5de:	b7e5                	j	5c6 <vprintf+0x60>
      if(c == 'd'){
 5e0:	05878063          	beq	a5,s8,620 <vprintf+0xba>
      } else if(c == 'l') {
 5e4:	05978c63          	beq	a5,s9,63c <vprintf+0xd6>
      } else if(c == 'x') {
 5e8:	07a78863          	beq	a5,s10,658 <vprintf+0xf2>
      } else if(c == 'p') {
 5ec:	09b78463          	beq	a5,s11,674 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5f0:	07300713          	li	a4,115
 5f4:	0ce78663          	beq	a5,a4,6c0 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5f8:	06300713          	li	a4,99
 5fc:	0ee78e63          	beq	a5,a4,6f8 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 600:	11478863          	beq	a5,s4,710 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 604:	85d2                	mv	a1,s4
 606:	8556                	mv	a0,s5
 608:	00000097          	auipc	ra,0x0
 60c:	e92080e7          	jalr	-366(ra) # 49a <putc>
        putc(fd, c);
 610:	85ca                	mv	a1,s2
 612:	8556                	mv	a0,s5
 614:	00000097          	auipc	ra,0x0
 618:	e86080e7          	jalr	-378(ra) # 49a <putc>
      }
      state = 0;
 61c:	4981                	li	s3,0
 61e:	b765                	j	5c6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 620:	008b0913          	addi	s2,s6,8
 624:	4685                	li	a3,1
 626:	4629                	li	a2,10
 628:	000b2583          	lw	a1,0(s6)
 62c:	8556                	mv	a0,s5
 62e:	00000097          	auipc	ra,0x0
 632:	e8e080e7          	jalr	-370(ra) # 4bc <printint>
 636:	8b4a                	mv	s6,s2
      state = 0;
 638:	4981                	li	s3,0
 63a:	b771                	j	5c6 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 63c:	008b0913          	addi	s2,s6,8
 640:	4681                	li	a3,0
 642:	4629                	li	a2,10
 644:	000b2583          	lw	a1,0(s6)
 648:	8556                	mv	a0,s5
 64a:	00000097          	auipc	ra,0x0
 64e:	e72080e7          	jalr	-398(ra) # 4bc <printint>
 652:	8b4a                	mv	s6,s2
      state = 0;
 654:	4981                	li	s3,0
 656:	bf85                	j	5c6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 658:	008b0913          	addi	s2,s6,8
 65c:	4681                	li	a3,0
 65e:	4641                	li	a2,16
 660:	000b2583          	lw	a1,0(s6)
 664:	8556                	mv	a0,s5
 666:	00000097          	auipc	ra,0x0
 66a:	e56080e7          	jalr	-426(ra) # 4bc <printint>
 66e:	8b4a                	mv	s6,s2
      state = 0;
 670:	4981                	li	s3,0
 672:	bf91                	j	5c6 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 674:	008b0793          	addi	a5,s6,8
 678:	f8f43423          	sd	a5,-120(s0)
 67c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 680:	03000593          	li	a1,48
 684:	8556                	mv	a0,s5
 686:	00000097          	auipc	ra,0x0
 68a:	e14080e7          	jalr	-492(ra) # 49a <putc>
  putc(fd, 'x');
 68e:	85ea                	mv	a1,s10
 690:	8556                	mv	a0,s5
 692:	00000097          	auipc	ra,0x0
 696:	e08080e7          	jalr	-504(ra) # 49a <putc>
 69a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 69c:	03c9d793          	srli	a5,s3,0x3c
 6a0:	97de                	add	a5,a5,s7
 6a2:	0007c583          	lbu	a1,0(a5)
 6a6:	8556                	mv	a0,s5
 6a8:	00000097          	auipc	ra,0x0
 6ac:	df2080e7          	jalr	-526(ra) # 49a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6b0:	0992                	slli	s3,s3,0x4
 6b2:	397d                	addiw	s2,s2,-1
 6b4:	fe0914e3          	bnez	s2,69c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6b8:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6bc:	4981                	li	s3,0
 6be:	b721                	j	5c6 <vprintf+0x60>
        s = va_arg(ap, char*);
 6c0:	008b0993          	addi	s3,s6,8
 6c4:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6c8:	02090163          	beqz	s2,6ea <vprintf+0x184>
        while(*s != 0){
 6cc:	00094583          	lbu	a1,0(s2)
 6d0:	c9a1                	beqz	a1,720 <vprintf+0x1ba>
          putc(fd, *s);
 6d2:	8556                	mv	a0,s5
 6d4:	00000097          	auipc	ra,0x0
 6d8:	dc6080e7          	jalr	-570(ra) # 49a <putc>
          s++;
 6dc:	0905                	addi	s2,s2,1
        while(*s != 0){
 6de:	00094583          	lbu	a1,0(s2)
 6e2:	f9e5                	bnez	a1,6d2 <vprintf+0x16c>
        s = va_arg(ap, char*);
 6e4:	8b4e                	mv	s6,s3
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	bdf9                	j	5c6 <vprintf+0x60>
          s = "(null)";
 6ea:	00000917          	auipc	s2,0x0
 6ee:	4de90913          	addi	s2,s2,1246 # bc8 <thread_start_threading+0x76>
        while(*s != 0){
 6f2:	02800593          	li	a1,40
 6f6:	bff1                	j	6d2 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6f8:	008b0913          	addi	s2,s6,8
 6fc:	000b4583          	lbu	a1,0(s6)
 700:	8556                	mv	a0,s5
 702:	00000097          	auipc	ra,0x0
 706:	d98080e7          	jalr	-616(ra) # 49a <putc>
 70a:	8b4a                	mv	s6,s2
      state = 0;
 70c:	4981                	li	s3,0
 70e:	bd65                	j	5c6 <vprintf+0x60>
        putc(fd, c);
 710:	85d2                	mv	a1,s4
 712:	8556                	mv	a0,s5
 714:	00000097          	auipc	ra,0x0
 718:	d86080e7          	jalr	-634(ra) # 49a <putc>
      state = 0;
 71c:	4981                	li	s3,0
 71e:	b565                	j	5c6 <vprintf+0x60>
        s = va_arg(ap, char*);
 720:	8b4e                	mv	s6,s3
      state = 0;
 722:	4981                	li	s3,0
 724:	b54d                	j	5c6 <vprintf+0x60>
    }
  }
}
 726:	70e6                	ld	ra,120(sp)
 728:	7446                	ld	s0,112(sp)
 72a:	74a6                	ld	s1,104(sp)
 72c:	7906                	ld	s2,96(sp)
 72e:	69e6                	ld	s3,88(sp)
 730:	6a46                	ld	s4,80(sp)
 732:	6aa6                	ld	s5,72(sp)
 734:	6b06                	ld	s6,64(sp)
 736:	7be2                	ld	s7,56(sp)
 738:	7c42                	ld	s8,48(sp)
 73a:	7ca2                	ld	s9,40(sp)
 73c:	7d02                	ld	s10,32(sp)
 73e:	6de2                	ld	s11,24(sp)
 740:	6109                	addi	sp,sp,128
 742:	8082                	ret

0000000000000744 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 744:	715d                	addi	sp,sp,-80
 746:	ec06                	sd	ra,24(sp)
 748:	e822                	sd	s0,16(sp)
 74a:	1000                	addi	s0,sp,32
 74c:	e010                	sd	a2,0(s0)
 74e:	e414                	sd	a3,8(s0)
 750:	e818                	sd	a4,16(s0)
 752:	ec1c                	sd	a5,24(s0)
 754:	03043023          	sd	a6,32(s0)
 758:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 75c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 760:	8622                	mv	a2,s0
 762:	00000097          	auipc	ra,0x0
 766:	e04080e7          	jalr	-508(ra) # 566 <vprintf>
}
 76a:	60e2                	ld	ra,24(sp)
 76c:	6442                	ld	s0,16(sp)
 76e:	6161                	addi	sp,sp,80
 770:	8082                	ret

0000000000000772 <printf>:

void
printf(const char *fmt, ...)
{
 772:	711d                	addi	sp,sp,-96
 774:	ec06                	sd	ra,24(sp)
 776:	e822                	sd	s0,16(sp)
 778:	1000                	addi	s0,sp,32
 77a:	e40c                	sd	a1,8(s0)
 77c:	e810                	sd	a2,16(s0)
 77e:	ec14                	sd	a3,24(s0)
 780:	f018                	sd	a4,32(s0)
 782:	f41c                	sd	a5,40(s0)
 784:	03043823          	sd	a6,48(s0)
 788:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 78c:	00840613          	addi	a2,s0,8
 790:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 794:	85aa                	mv	a1,a0
 796:	4505                	li	a0,1
 798:	00000097          	auipc	ra,0x0
 79c:	dce080e7          	jalr	-562(ra) # 566 <vprintf>
}
 7a0:	60e2                	ld	ra,24(sp)
 7a2:	6442                	ld	s0,16(sp)
 7a4:	6125                	addi	sp,sp,96
 7a6:	8082                	ret

00000000000007a8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7a8:	1141                	addi	sp,sp,-16
 7aa:	e422                	sd	s0,8(sp)
 7ac:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ae:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b2:	00000797          	auipc	a5,0x0
 7b6:	4367b783          	ld	a5,1078(a5) # be8 <freep>
 7ba:	a805                	j	7ea <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7bc:	4618                	lw	a4,8(a2)
 7be:	9db9                	addw	a1,a1,a4
 7c0:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7c4:	6398                	ld	a4,0(a5)
 7c6:	6318                	ld	a4,0(a4)
 7c8:	fee53823          	sd	a4,-16(a0)
 7cc:	a091                	j	810 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7ce:	ff852703          	lw	a4,-8(a0)
 7d2:	9e39                	addw	a2,a2,a4
 7d4:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7d6:	ff053703          	ld	a4,-16(a0)
 7da:	e398                	sd	a4,0(a5)
 7dc:	a099                	j	822 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7de:	6398                	ld	a4,0(a5)
 7e0:	00e7e463          	bltu	a5,a4,7e8 <free+0x40>
 7e4:	00e6ea63          	bltu	a3,a4,7f8 <free+0x50>
{
 7e8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ea:	fed7fae3          	bgeu	a5,a3,7de <free+0x36>
 7ee:	6398                	ld	a4,0(a5)
 7f0:	00e6e463          	bltu	a3,a4,7f8 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f4:	fee7eae3          	bltu	a5,a4,7e8 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7f8:	ff852583          	lw	a1,-8(a0)
 7fc:	6390                	ld	a2,0(a5)
 7fe:	02059713          	slli	a4,a1,0x20
 802:	9301                	srli	a4,a4,0x20
 804:	0712                	slli	a4,a4,0x4
 806:	9736                	add	a4,a4,a3
 808:	fae60ae3          	beq	a2,a4,7bc <free+0x14>
    bp->s.ptr = p->s.ptr;
 80c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 810:	4790                	lw	a2,8(a5)
 812:	02061713          	slli	a4,a2,0x20
 816:	9301                	srli	a4,a4,0x20
 818:	0712                	slli	a4,a4,0x4
 81a:	973e                	add	a4,a4,a5
 81c:	fae689e3          	beq	a3,a4,7ce <free+0x26>
  } else
    p->s.ptr = bp;
 820:	e394                	sd	a3,0(a5)
  freep = p;
 822:	00000717          	auipc	a4,0x0
 826:	3cf73323          	sd	a5,966(a4) # be8 <freep>
}
 82a:	6422                	ld	s0,8(sp)
 82c:	0141                	addi	sp,sp,16
 82e:	8082                	ret

0000000000000830 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 830:	7139                	addi	sp,sp,-64
 832:	fc06                	sd	ra,56(sp)
 834:	f822                	sd	s0,48(sp)
 836:	f426                	sd	s1,40(sp)
 838:	f04a                	sd	s2,32(sp)
 83a:	ec4e                	sd	s3,24(sp)
 83c:	e852                	sd	s4,16(sp)
 83e:	e456                	sd	s5,8(sp)
 840:	e05a                	sd	s6,0(sp)
 842:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 844:	02051493          	slli	s1,a0,0x20
 848:	9081                	srli	s1,s1,0x20
 84a:	04bd                	addi	s1,s1,15
 84c:	8091                	srli	s1,s1,0x4
 84e:	0014899b          	addiw	s3,s1,1
 852:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 854:	00000517          	auipc	a0,0x0
 858:	39453503          	ld	a0,916(a0) # be8 <freep>
 85c:	c515                	beqz	a0,888 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 860:	4798                	lw	a4,8(a5)
 862:	02977f63          	bgeu	a4,s1,8a0 <malloc+0x70>
 866:	8a4e                	mv	s4,s3
 868:	0009871b          	sext.w	a4,s3
 86c:	6685                	lui	a3,0x1
 86e:	00d77363          	bgeu	a4,a3,874 <malloc+0x44>
 872:	6a05                	lui	s4,0x1
 874:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 878:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 87c:	00000917          	auipc	s2,0x0
 880:	36c90913          	addi	s2,s2,876 # be8 <freep>
  if(p == (char*)-1)
 884:	5afd                	li	s5,-1
 886:	a88d                	j	8f8 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 888:	00000797          	auipc	a5,0x0
 88c:	37078793          	addi	a5,a5,880 # bf8 <base>
 890:	00000717          	auipc	a4,0x0
 894:	34f73c23          	sd	a5,856(a4) # be8 <freep>
 898:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 89a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 89e:	b7e1                	j	866 <malloc+0x36>
      if(p->s.size == nunits)
 8a0:	02e48b63          	beq	s1,a4,8d6 <malloc+0xa6>
        p->s.size -= nunits;
 8a4:	4137073b          	subw	a4,a4,s3
 8a8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8aa:	1702                	slli	a4,a4,0x20
 8ac:	9301                	srli	a4,a4,0x20
 8ae:	0712                	slli	a4,a4,0x4
 8b0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8b2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8b6:	00000717          	auipc	a4,0x0
 8ba:	32a73923          	sd	a0,818(a4) # be8 <freep>
      return (void*)(p + 1);
 8be:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8c2:	70e2                	ld	ra,56(sp)
 8c4:	7442                	ld	s0,48(sp)
 8c6:	74a2                	ld	s1,40(sp)
 8c8:	7902                	ld	s2,32(sp)
 8ca:	69e2                	ld	s3,24(sp)
 8cc:	6a42                	ld	s4,16(sp)
 8ce:	6aa2                	ld	s5,8(sp)
 8d0:	6b02                	ld	s6,0(sp)
 8d2:	6121                	addi	sp,sp,64
 8d4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8d6:	6398                	ld	a4,0(a5)
 8d8:	e118                	sd	a4,0(a0)
 8da:	bff1                	j	8b6 <malloc+0x86>
  hp->s.size = nu;
 8dc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8e0:	0541                	addi	a0,a0,16
 8e2:	00000097          	auipc	ra,0x0
 8e6:	ec6080e7          	jalr	-314(ra) # 7a8 <free>
  return freep;
 8ea:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8ee:	d971                	beqz	a0,8c2 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f2:	4798                	lw	a4,8(a5)
 8f4:	fa9776e3          	bgeu	a4,s1,8a0 <malloc+0x70>
    if(p == freep)
 8f8:	00093703          	ld	a4,0(s2)
 8fc:	853e                	mv	a0,a5
 8fe:	fef719e3          	bne	a4,a5,8f0 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 902:	8552                	mv	a0,s4
 904:	00000097          	auipc	ra,0x0
 908:	b7e080e7          	jalr	-1154(ra) # 482 <sbrk>
  if(p == (char*)-1)
 90c:	fd5518e3          	bne	a0,s5,8dc <malloc+0xac>
        return 0;
 910:	4501                	li	a0,0
 912:	bf45                	j	8c2 <malloc+0x92>

0000000000000914 <setjmp>:
 914:	e100                	sd	s0,0(a0)
 916:	e504                	sd	s1,8(a0)
 918:	01253823          	sd	s2,16(a0)
 91c:	01353c23          	sd	s3,24(a0)
 920:	03453023          	sd	s4,32(a0)
 924:	03553423          	sd	s5,40(a0)
 928:	03653823          	sd	s6,48(a0)
 92c:	03753c23          	sd	s7,56(a0)
 930:	05853023          	sd	s8,64(a0)
 934:	05953423          	sd	s9,72(a0)
 938:	05a53823          	sd	s10,80(a0)
 93c:	05b53c23          	sd	s11,88(a0)
 940:	06153023          	sd	ra,96(a0)
 944:	06253423          	sd	sp,104(a0)
 948:	4501                	li	a0,0
 94a:	8082                	ret

000000000000094c <longjmp>:
 94c:	6100                	ld	s0,0(a0)
 94e:	6504                	ld	s1,8(a0)
 950:	01053903          	ld	s2,16(a0)
 954:	01853983          	ld	s3,24(a0)
 958:	02053a03          	ld	s4,32(a0)
 95c:	02853a83          	ld	s5,40(a0)
 960:	03053b03          	ld	s6,48(a0)
 964:	03853b83          	ld	s7,56(a0)
 968:	04053c03          	ld	s8,64(a0)
 96c:	04853c83          	ld	s9,72(a0)
 970:	05053d03          	ld	s10,80(a0)
 974:	05853d83          	ld	s11,88(a0)
 978:	06053083          	ld	ra,96(a0)
 97c:	06853103          	ld	sp,104(a0)
 980:	c199                	beqz	a1,986 <longjmp_1>
 982:	852e                	mv	a0,a1
 984:	8082                	ret

0000000000000986 <longjmp_1>:
 986:	4505                	li	a0,1
 988:	8082                	ret

000000000000098a <thread_create>:
static struct thread* current_thread = NULL;
static int id = 1;
static jmp_buf env_st;
//static jmp_buf env_tmp;

struct thread *thread_create(void (*f)(void *), void *arg){
 98a:	7179                	addi	sp,sp,-48
 98c:	f406                	sd	ra,40(sp)
 98e:	f022                	sd	s0,32(sp)
 990:	ec26                	sd	s1,24(sp)
 992:	e84a                	sd	s2,16(sp)
 994:	e44e                	sd	s3,8(sp)
 996:	1800                	addi	s0,sp,48
 998:	89aa                	mv	s3,a0
 99a:	892e                	mv	s2,a1
    struct thread *t = (struct thread*) malloc(sizeof(struct thread));
 99c:	0a800513          	li	a0,168
 9a0:	00000097          	auipc	ra,0x0
 9a4:	e90080e7          	jalr	-368(ra) # 830 <malloc>
 9a8:	84aa                	mv	s1,a0
    //unsigned long stack_p = 0;
    unsigned long new_stack_p;
    unsigned long new_stack;
    new_stack = (unsigned long) malloc(sizeof(unsigned long)*0x100);
 9aa:	6505                	lui	a0,0x1
 9ac:	80050513          	addi	a0,a0,-2048 # 800 <free+0x58>
 9b0:	00000097          	auipc	ra,0x0
 9b4:	e80080e7          	jalr	-384(ra) # 830 <malloc>
    new_stack_p = new_stack +0x100*8-0x2*8;
    t->fp = f;
 9b8:	0134b023          	sd	s3,0(s1)
    t->arg = arg;
 9bc:	0124b423          	sd	s2,8(s1)
    t->ID  = id;
 9c0:	00000717          	auipc	a4,0x0
 9c4:	22470713          	addi	a4,a4,548 # be4 <id>
 9c8:	431c                	lw	a5,0(a4)
 9ca:	08f4a823          	sw	a5,144(s1)
    t->buf_set = 0;
 9ce:	0804aa23          	sw	zero,148(s1)
    t->stack = (void*) new_stack;
 9d2:	e888                	sd	a0,16(s1)
    new_stack_p = new_stack +0x100*8-0x2*8;
 9d4:	7f050513          	addi	a0,a0,2032
    t->stack_p = (void*) new_stack_p;
 9d8:	ec88                	sd	a0,24(s1)
    id++;
 9da:	2785                	addiw	a5,a5,1
 9dc:	c31c                	sw	a5,0(a4)
    return t;
}
 9de:	8526                	mv	a0,s1
 9e0:	70a2                	ld	ra,40(sp)
 9e2:	7402                	ld	s0,32(sp)
 9e4:	64e2                	ld	s1,24(sp)
 9e6:	6942                	ld	s2,16(sp)
 9e8:	69a2                	ld	s3,8(sp)
 9ea:	6145                	addi	sp,sp,48
 9ec:	8082                	ret

00000000000009ee <thread_add_runqueue>:
void thread_add_runqueue(struct thread *t){
 9ee:	1141                	addi	sp,sp,-16
 9f0:	e422                	sd	s0,8(sp)
 9f2:	0800                	addi	s0,sp,16
    if(current_thread == NULL){
 9f4:	00000797          	auipc	a5,0x0
 9f8:	1fc7b783          	ld	a5,508(a5) # bf0 <current_thread>
 9fc:	cb91                	beqz	a5,a10 <thread_add_runqueue+0x22>
        current_thread = t;
        current_thread->previous = t;
        current_thread->next = t;
    }
    else{
        current_thread->previous->next = t;
 9fe:	6fd8                	ld	a4,152(a5)
 a00:	f348                	sd	a0,160(a4)
        t->previous = current_thread->previous;
 a02:	6fd8                	ld	a4,152(a5)
 a04:	ed58                	sd	a4,152(a0)
        t->next = current_thread;
 a06:	f15c                	sd	a5,160(a0)
        current_thread->previous = t;
 a08:	efc8                	sd	a0,152(a5)
    }
}
 a0a:	6422                	ld	s0,8(sp)
 a0c:	0141                	addi	sp,sp,16
 a0e:	8082                	ret
        current_thread = t;
 a10:	00000797          	auipc	a5,0x0
 a14:	1ea7b023          	sd	a0,480(a5) # bf0 <current_thread>
        current_thread->previous = t;
 a18:	ed48                	sd	a0,152(a0)
        current_thread->next = t;
 a1a:	f148                	sd	a0,160(a0)
 a1c:	b7fd                	j	a0a <thread_add_runqueue+0x1c>

0000000000000a1e <schedule>:
    }
    else{
        longjmp(current_thread->env, 1);
    }
}
void schedule(void){
 a1e:	1141                	addi	sp,sp,-16
 a20:	e422                	sd	s0,8(sp)
 a22:	0800                	addi	s0,sp,16
    current_thread = current_thread->next;
 a24:	00000797          	auipc	a5,0x0
 a28:	1cc78793          	addi	a5,a5,460 # bf0 <current_thread>
 a2c:	6398                	ld	a4,0(a5)
 a2e:	7358                	ld	a4,160(a4)
 a30:	e398                	sd	a4,0(a5)
}
 a32:	6422                	ld	s0,8(sp)
 a34:	0141                	addi	sp,sp,16
 a36:	8082                	ret

0000000000000a38 <thread_exit>:
void thread_exit(void){
 a38:	1101                	addi	sp,sp,-32
 a3a:	ec06                	sd	ra,24(sp)
 a3c:	e822                	sd	s0,16(sp)
 a3e:	e426                	sd	s1,8(sp)
 a40:	e04a                	sd	s2,0(sp)
 a42:	1000                	addi	s0,sp,32
    if(current_thread->next != current_thread){
 a44:	00000797          	auipc	a5,0x0
 a48:	1ac7b783          	ld	a5,428(a5) # bf0 <current_thread>
 a4c:	73d8                	ld	a4,160(a5)
 a4e:	04e78263          	beq	a5,a4,a92 <thread_exit+0x5a>
        // TODO
        current_thread->previous->next = current_thread->next;
 a52:	6fd4                	ld	a3,152(a5)
 a54:	f2d8                	sd	a4,160(a3)
        current_thread->next->previous = current_thread->previous;
 a56:	6fd4                	ld	a3,152(a5)
 a58:	ef54                	sd	a3,152(a4)
        struct thread *next = current_thread->next;
 a5a:	0a07b903          	ld	s2,160(a5)
        // free the thread
        free(current_thread->stack);
 a5e:	6b88                	ld	a0,16(a5)
 a60:	00000097          	auipc	ra,0x0
 a64:	d48080e7          	jalr	-696(ra) # 7a8 <free>
        free(current_thread);
 a68:	00000497          	auipc	s1,0x0
 a6c:	18848493          	addi	s1,s1,392 # bf0 <current_thread>
 a70:	6088                	ld	a0,0(s1)
 a72:	00000097          	auipc	ra,0x0
 a76:	d36080e7          	jalr	-714(ra) # 7a8 <free>
        current_thread = next;
 a7a:	0124b023          	sd	s2,0(s1)
        // schedule();
        dispatch();
 a7e:	00000097          	auipc	ra,0x0
 a82:	028080e7          	jalr	40(ra) # aa6 <dispatch>
        // TODO
        // Hint: No more thread to execute
        longjmp(env_st, 1);
        return;
    }
}
 a86:	60e2                	ld	ra,24(sp)
 a88:	6442                	ld	s0,16(sp)
 a8a:	64a2                	ld	s1,8(sp)
 a8c:	6902                	ld	s2,0(sp)
 a8e:	6105                	addi	sp,sp,32
 a90:	8082                	ret
        longjmp(env_st, 1);
 a92:	4585                	li	a1,1
 a94:	00000517          	auipc	a0,0x0
 a98:	17450513          	addi	a0,a0,372 # c08 <env_st>
 a9c:	00000097          	auipc	ra,0x0
 aa0:	eb0080e7          	jalr	-336(ra) # 94c <longjmp>
        return;
 aa4:	b7cd                	j	a86 <thread_exit+0x4e>

0000000000000aa6 <dispatch>:
void dispatch(void){
 aa6:	1141                	addi	sp,sp,-16
 aa8:	e406                	sd	ra,8(sp)
 aaa:	e022                	sd	s0,0(sp)
 aac:	0800                	addi	s0,sp,16
    if(current_thread->buf_set == 0){ //not yet initialized
 aae:	00000517          	auipc	a0,0x0
 ab2:	14253503          	ld	a0,322(a0) # bf0 <current_thread>
 ab6:	09452783          	lw	a5,148(a0)
 aba:	eba1                	bnez	a5,b0a <dispatch+0x64>
        current_thread->buf_set = 1;
 abc:	4785                	li	a5,1
 abe:	08f52a23          	sw	a5,148(a0)
        if(setjmp(current_thread->env) == 0){
 ac2:	02050513          	addi	a0,a0,32
 ac6:	00000097          	auipc	ra,0x0
 aca:	e4e080e7          	jalr	-434(ra) # 914 <setjmp>
 ace:	c105                	beqz	a0,aee <dispatch+0x48>
            current_thread->fp(current_thread->arg);
 ad0:	00000797          	auipc	a5,0x0
 ad4:	1207b783          	ld	a5,288(a5) # bf0 <current_thread>
 ad8:	6398                	ld	a4,0(a5)
 ada:	6788                	ld	a0,8(a5)
 adc:	9702                	jalr	a4
            thread_exit();
 ade:	00000097          	auipc	ra,0x0
 ae2:	f5a080e7          	jalr	-166(ra) # a38 <thread_exit>
}
 ae6:	60a2                	ld	ra,8(sp)
 ae8:	6402                	ld	s0,0(sp)
 aea:	0141                	addi	sp,sp,16
 aec:	8082                	ret
            current_thread->env->sp = (unsigned long)current_thread->stack_p;
 aee:	00000517          	auipc	a0,0x0
 af2:	10253503          	ld	a0,258(a0) # bf0 <current_thread>
 af6:	6d1c                	ld	a5,24(a0)
 af8:	e55c                	sd	a5,136(a0)
            longjmp(current_thread->env, 1);
 afa:	4585                	li	a1,1
 afc:	02050513          	addi	a0,a0,32
 b00:	00000097          	auipc	ra,0x0
 b04:	e4c080e7          	jalr	-436(ra) # 94c <longjmp>
 b08:	bff9                	j	ae6 <dispatch+0x40>
        longjmp(current_thread->env, 1);
 b0a:	4585                	li	a1,1
 b0c:	02050513          	addi	a0,a0,32
 b10:	00000097          	auipc	ra,0x0
 b14:	e3c080e7          	jalr	-452(ra) # 94c <longjmp>
}
 b18:	b7f9                	j	ae6 <dispatch+0x40>

0000000000000b1a <thread_yield>:
void thread_yield(void){
 b1a:	1141                	addi	sp,sp,-16
 b1c:	e406                	sd	ra,8(sp)
 b1e:	e022                	sd	s0,0(sp)
 b20:	0800                	addi	s0,sp,16
    if(setjmp(current_thread->env) == 0){ //從function裡叫thread_yield
 b22:	00000517          	auipc	a0,0x0
 b26:	0ce53503          	ld	a0,206(a0) # bf0 <current_thread>
 b2a:	02050513          	addi	a0,a0,32
 b2e:	00000097          	auipc	ra,0x0
 b32:	de6080e7          	jalr	-538(ra) # 914 <setjmp>
 b36:	c509                	beqz	a0,b40 <thread_yield+0x26>
}
 b38:	60a2                	ld	ra,8(sp)
 b3a:	6402                	ld	s0,0(sp)
 b3c:	0141                	addi	sp,sp,16
 b3e:	8082                	ret
        schedule();
 b40:	00000097          	auipc	ra,0x0
 b44:	ede080e7          	jalr	-290(ra) # a1e <schedule>
        dispatch();
 b48:	00000097          	auipc	ra,0x0
 b4c:	f5e080e7          	jalr	-162(ra) # aa6 <dispatch>
 b50:	b7e5                	j	b38 <thread_yield+0x1e>

0000000000000b52 <thread_start_threading>:
void thread_start_threading(void){
 b52:	1141                	addi	sp,sp,-16
 b54:	e406                	sd	ra,8(sp)
 b56:	e022                	sd	s0,0(sp)
 b58:	0800                	addi	s0,sp,16
    // TODO
    if(setjmp(env_st) == 0){ // main thread
 b5a:	00000517          	auipc	a0,0x0
 b5e:	0ae50513          	addi	a0,a0,174 # c08 <env_st>
 b62:	00000097          	auipc	ra,0x0
 b66:	db2080e7          	jalr	-590(ra) # 914 <setjmp>
 b6a:	c509                	beqz	a0,b74 <thread_start_threading+0x22>
        dispatch();
    }
    else{
        return;
    }
}
 b6c:	60a2                	ld	ra,8(sp)
 b6e:	6402                	ld	s0,0(sp)
 b70:	0141                	addi	sp,sp,16
 b72:	8082                	ret
        schedule();
 b74:	00000097          	auipc	ra,0x0
 b78:	eaa080e7          	jalr	-342(ra) # a1e <schedule>
        dispatch();
 b7c:	00000097          	auipc	ra,0x0
 b80:	f2a080e7          	jalr	-214(ra) # aa6 <dispatch>
 b84:	b7e5                	j	b6c <thread_start_threading+0x1a>
