
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   c:	4785                	li	a5,1
   e:	02a7dd63          	bge	a5,a0,48 <main+0x48>
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	1902                	slli	s2,s2,0x20
  1c:	02095913          	srli	s2,s2,0x20
  20:	090e                	slli	s2,s2,0x3
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	1ae080e7          	jalr	430(ra) # 1d6 <atoi>
  30:	00000097          	auipc	ra,0x0
  34:	2d2080e7          	jalr	722(ra) # 302 <kill>
  for(i=1; i<argc; i++)
  38:	04a1                	addi	s1,s1,8
  3a:	ff2496e3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  3e:	4501                	li	a0,0
  40:	00000097          	auipc	ra,0x0
  44:	292080e7          	jalr	658(ra) # 2d2 <exit>
    fprintf(2, "usage: kill pid...\n");
  48:	00001597          	auipc	a1,0x1
  4c:	82058593          	addi	a1,a1,-2016 # 868 <longjmp_1+0xa>
  50:	4509                	li	a0,2
  52:	00000097          	auipc	ra,0x0
  56:	5ca080e7          	jalr	1482(ra) # 61c <fprintf>
    exit(1);
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	276080e7          	jalr	630(ra) # 2d2 <exit>

0000000000000064 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  64:	1141                	addi	sp,sp,-16
  66:	e422                	sd	s0,8(sp)
  68:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6a:	87aa                	mv	a5,a0
  6c:	0585                	addi	a1,a1,1
  6e:	0785                	addi	a5,a5,1
  70:	fff5c703          	lbu	a4,-1(a1)
  74:	fee78fa3          	sb	a4,-1(a5)
  78:	fb75                	bnez	a4,6c <strcpy+0x8>
    ;
  return os;
}
  7a:	6422                	ld	s0,8(sp)
  7c:	0141                	addi	sp,sp,16
  7e:	8082                	ret

0000000000000080 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80:	1141                	addi	sp,sp,-16
  82:	e422                	sd	s0,8(sp)
  84:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  86:	00054783          	lbu	a5,0(a0)
  8a:	cb91                	beqz	a5,9e <strcmp+0x1e>
  8c:	0005c703          	lbu	a4,0(a1)
  90:	00f71763          	bne	a4,a5,9e <strcmp+0x1e>
    p++, q++;
  94:	0505                	addi	a0,a0,1
  96:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  98:	00054783          	lbu	a5,0(a0)
  9c:	fbe5                	bnez	a5,8c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  9e:	0005c503          	lbu	a0,0(a1)
}
  a2:	40a7853b          	subw	a0,a5,a0
  a6:	6422                	ld	s0,8(sp)
  a8:	0141                	addi	sp,sp,16
  aa:	8082                	ret

00000000000000ac <strlen>:

uint
strlen(const char *s)
{
  ac:	1141                	addi	sp,sp,-16
  ae:	e422                	sd	s0,8(sp)
  b0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  b2:	00054783          	lbu	a5,0(a0)
  b6:	cf91                	beqz	a5,d2 <strlen+0x26>
  b8:	0505                	addi	a0,a0,1
  ba:	87aa                	mv	a5,a0
  bc:	4685                	li	a3,1
  be:	9e89                	subw	a3,a3,a0
  c0:	00f6853b          	addw	a0,a3,a5
  c4:	0785                	addi	a5,a5,1
  c6:	fff7c703          	lbu	a4,-1(a5)
  ca:	fb7d                	bnez	a4,c0 <strlen+0x14>
    ;
  return n;
}
  cc:	6422                	ld	s0,8(sp)
  ce:	0141                	addi	sp,sp,16
  d0:	8082                	ret
  for(n = 0; s[n]; n++)
  d2:	4501                	li	a0,0
  d4:	bfe5                	j	cc <strlen+0x20>

00000000000000d6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d6:	1141                	addi	sp,sp,-16
  d8:	e422                	sd	s0,8(sp)
  da:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  dc:	ca19                	beqz	a2,f2 <memset+0x1c>
  de:	87aa                	mv	a5,a0
  e0:	1602                	slli	a2,a2,0x20
  e2:	9201                	srli	a2,a2,0x20
  e4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  e8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ec:	0785                	addi	a5,a5,1
  ee:	fee79de3          	bne	a5,a4,e8 <memset+0x12>
  }
  return dst;
}
  f2:	6422                	ld	s0,8(sp)
  f4:	0141                	addi	sp,sp,16
  f6:	8082                	ret

00000000000000f8 <strchr>:

char*
strchr(const char *s, char c)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e422                	sd	s0,8(sp)
  fc:	0800                	addi	s0,sp,16
  for(; *s; s++)
  fe:	00054783          	lbu	a5,0(a0)
 102:	cb99                	beqz	a5,118 <strchr+0x20>
    if(*s == c)
 104:	00f58763          	beq	a1,a5,112 <strchr+0x1a>
  for(; *s; s++)
 108:	0505                	addi	a0,a0,1
 10a:	00054783          	lbu	a5,0(a0)
 10e:	fbfd                	bnez	a5,104 <strchr+0xc>
      return (char*)s;
  return 0;
 110:	4501                	li	a0,0
}
 112:	6422                	ld	s0,8(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret
  return 0;
 118:	4501                	li	a0,0
 11a:	bfe5                	j	112 <strchr+0x1a>

000000000000011c <gets>:

char*
gets(char *buf, int max)
{
 11c:	711d                	addi	sp,sp,-96
 11e:	ec86                	sd	ra,88(sp)
 120:	e8a2                	sd	s0,80(sp)
 122:	e4a6                	sd	s1,72(sp)
 124:	e0ca                	sd	s2,64(sp)
 126:	fc4e                	sd	s3,56(sp)
 128:	f852                	sd	s4,48(sp)
 12a:	f456                	sd	s5,40(sp)
 12c:	f05a                	sd	s6,32(sp)
 12e:	ec5e                	sd	s7,24(sp)
 130:	1080                	addi	s0,sp,96
 132:	8baa                	mv	s7,a0
 134:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 136:	892a                	mv	s2,a0
 138:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 13a:	4aa9                	li	s5,10
 13c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 13e:	89a6                	mv	s3,s1
 140:	2485                	addiw	s1,s1,1
 142:	0344d863          	bge	s1,s4,172 <gets+0x56>
    cc = read(0, &c, 1);
 146:	4605                	li	a2,1
 148:	faf40593          	addi	a1,s0,-81
 14c:	4501                	li	a0,0
 14e:	00000097          	auipc	ra,0x0
 152:	19c080e7          	jalr	412(ra) # 2ea <read>
    if(cc < 1)
 156:	00a05e63          	blez	a0,172 <gets+0x56>
    buf[i++] = c;
 15a:	faf44783          	lbu	a5,-81(s0)
 15e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 162:	01578763          	beq	a5,s5,170 <gets+0x54>
 166:	0905                	addi	s2,s2,1
 168:	fd679be3          	bne	a5,s6,13e <gets+0x22>
  for(i=0; i+1 < max; ){
 16c:	89a6                	mv	s3,s1
 16e:	a011                	j	172 <gets+0x56>
 170:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 172:	99de                	add	s3,s3,s7
 174:	00098023          	sb	zero,0(s3)
  return buf;
}
 178:	855e                	mv	a0,s7
 17a:	60e6                	ld	ra,88(sp)
 17c:	6446                	ld	s0,80(sp)
 17e:	64a6                	ld	s1,72(sp)
 180:	6906                	ld	s2,64(sp)
 182:	79e2                	ld	s3,56(sp)
 184:	7a42                	ld	s4,48(sp)
 186:	7aa2                	ld	s5,40(sp)
 188:	7b02                	ld	s6,32(sp)
 18a:	6be2                	ld	s7,24(sp)
 18c:	6125                	addi	sp,sp,96
 18e:	8082                	ret

0000000000000190 <stat>:

int
stat(const char *n, struct stat *st)
{
 190:	1101                	addi	sp,sp,-32
 192:	ec06                	sd	ra,24(sp)
 194:	e822                	sd	s0,16(sp)
 196:	e426                	sd	s1,8(sp)
 198:	e04a                	sd	s2,0(sp)
 19a:	1000                	addi	s0,sp,32
 19c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19e:	4581                	li	a1,0
 1a0:	00000097          	auipc	ra,0x0
 1a4:	172080e7          	jalr	370(ra) # 312 <open>
  if(fd < 0)
 1a8:	02054563          	bltz	a0,1d2 <stat+0x42>
 1ac:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ae:	85ca                	mv	a1,s2
 1b0:	00000097          	auipc	ra,0x0
 1b4:	17a080e7          	jalr	378(ra) # 32a <fstat>
 1b8:	892a                	mv	s2,a0
  close(fd);
 1ba:	8526                	mv	a0,s1
 1bc:	00000097          	auipc	ra,0x0
 1c0:	13e080e7          	jalr	318(ra) # 2fa <close>
  return r;
}
 1c4:	854a                	mv	a0,s2
 1c6:	60e2                	ld	ra,24(sp)
 1c8:	6442                	ld	s0,16(sp)
 1ca:	64a2                	ld	s1,8(sp)
 1cc:	6902                	ld	s2,0(sp)
 1ce:	6105                	addi	sp,sp,32
 1d0:	8082                	ret
    return -1;
 1d2:	597d                	li	s2,-1
 1d4:	bfc5                	j	1c4 <stat+0x34>

00000000000001d6 <atoi>:

int
atoi(const char *s)
{
 1d6:	1141                	addi	sp,sp,-16
 1d8:	e422                	sd	s0,8(sp)
 1da:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1dc:	00054603          	lbu	a2,0(a0)
 1e0:	fd06079b          	addiw	a5,a2,-48
 1e4:	0ff7f793          	andi	a5,a5,255
 1e8:	4725                	li	a4,9
 1ea:	02f76963          	bltu	a4,a5,21c <atoi+0x46>
 1ee:	86aa                	mv	a3,a0
  n = 0;
 1f0:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1f2:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1f4:	0685                	addi	a3,a3,1
 1f6:	0025179b          	slliw	a5,a0,0x2
 1fa:	9fa9                	addw	a5,a5,a0
 1fc:	0017979b          	slliw	a5,a5,0x1
 200:	9fb1                	addw	a5,a5,a2
 202:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 206:	0006c603          	lbu	a2,0(a3)
 20a:	fd06071b          	addiw	a4,a2,-48
 20e:	0ff77713          	andi	a4,a4,255
 212:	fee5f1e3          	bgeu	a1,a4,1f4 <atoi+0x1e>
  return n;
}
 216:	6422                	ld	s0,8(sp)
 218:	0141                	addi	sp,sp,16
 21a:	8082                	ret
  n = 0;
 21c:	4501                	li	a0,0
 21e:	bfe5                	j	216 <atoi+0x40>

0000000000000220 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 220:	1141                	addi	sp,sp,-16
 222:	e422                	sd	s0,8(sp)
 224:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 226:	02b57463          	bgeu	a0,a1,24e <memmove+0x2e>
    while(n-- > 0)
 22a:	00c05f63          	blez	a2,248 <memmove+0x28>
 22e:	1602                	slli	a2,a2,0x20
 230:	9201                	srli	a2,a2,0x20
 232:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 236:	872a                	mv	a4,a0
      *dst++ = *src++;
 238:	0585                	addi	a1,a1,1
 23a:	0705                	addi	a4,a4,1
 23c:	fff5c683          	lbu	a3,-1(a1)
 240:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 244:	fee79ae3          	bne	a5,a4,238 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 248:	6422                	ld	s0,8(sp)
 24a:	0141                	addi	sp,sp,16
 24c:	8082                	ret
    dst += n;
 24e:	00c50733          	add	a4,a0,a2
    src += n;
 252:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 254:	fec05ae3          	blez	a2,248 <memmove+0x28>
 258:	fff6079b          	addiw	a5,a2,-1
 25c:	1782                	slli	a5,a5,0x20
 25e:	9381                	srli	a5,a5,0x20
 260:	fff7c793          	not	a5,a5
 264:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 266:	15fd                	addi	a1,a1,-1
 268:	177d                	addi	a4,a4,-1
 26a:	0005c683          	lbu	a3,0(a1)
 26e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 272:	fee79ae3          	bne	a5,a4,266 <memmove+0x46>
 276:	bfc9                	j	248 <memmove+0x28>

0000000000000278 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 278:	1141                	addi	sp,sp,-16
 27a:	e422                	sd	s0,8(sp)
 27c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 27e:	ca05                	beqz	a2,2ae <memcmp+0x36>
 280:	fff6069b          	addiw	a3,a2,-1
 284:	1682                	slli	a3,a3,0x20
 286:	9281                	srli	a3,a3,0x20
 288:	0685                	addi	a3,a3,1
 28a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 28c:	00054783          	lbu	a5,0(a0)
 290:	0005c703          	lbu	a4,0(a1)
 294:	00e79863          	bne	a5,a4,2a4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 298:	0505                	addi	a0,a0,1
    p2++;
 29a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 29c:	fed518e3          	bne	a0,a3,28c <memcmp+0x14>
  }
  return 0;
 2a0:	4501                	li	a0,0
 2a2:	a019                	j	2a8 <memcmp+0x30>
      return *p1 - *p2;
 2a4:	40e7853b          	subw	a0,a5,a4
}
 2a8:	6422                	ld	s0,8(sp)
 2aa:	0141                	addi	sp,sp,16
 2ac:	8082                	ret
  return 0;
 2ae:	4501                	li	a0,0
 2b0:	bfe5                	j	2a8 <memcmp+0x30>

00000000000002b2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e406                	sd	ra,8(sp)
 2b6:	e022                	sd	s0,0(sp)
 2b8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2ba:	00000097          	auipc	ra,0x0
 2be:	f66080e7          	jalr	-154(ra) # 220 <memmove>
}
 2c2:	60a2                	ld	ra,8(sp)
 2c4:	6402                	ld	s0,0(sp)
 2c6:	0141                	addi	sp,sp,16
 2c8:	8082                	ret

00000000000002ca <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2ca:	4885                	li	a7,1
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2d2:	4889                	li	a7,2
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <wait>:
.global wait
wait:
 li a7, SYS_wait
 2da:	488d                	li	a7,3
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2e2:	4891                	li	a7,4
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <read>:
.global read
read:
 li a7, SYS_read
 2ea:	4895                	li	a7,5
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <write>:
.global write
write:
 li a7, SYS_write
 2f2:	48c1                	li	a7,16
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <close>:
.global close
close:
 li a7, SYS_close
 2fa:	48d5                	li	a7,21
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <kill>:
.global kill
kill:
 li a7, SYS_kill
 302:	4899                	li	a7,6
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <exec>:
.global exec
exec:
 li a7, SYS_exec
 30a:	489d                	li	a7,7
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <open>:
.global open
open:
 li a7, SYS_open
 312:	48bd                	li	a7,15
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 31a:	48c5                	li	a7,17
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 322:	48c9                	li	a7,18
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 32a:	48a1                	li	a7,8
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <link>:
.global link
link:
 li a7, SYS_link
 332:	48cd                	li	a7,19
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 33a:	48d1                	li	a7,20
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 342:	48a5                	li	a7,9
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <dup>:
.global dup
dup:
 li a7, SYS_dup
 34a:	48a9                	li	a7,10
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 352:	48ad                	li	a7,11
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 35a:	48b1                	li	a7,12
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 362:	48b5                	li	a7,13
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 36a:	48b9                	li	a7,14
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 372:	1101                	addi	sp,sp,-32
 374:	ec06                	sd	ra,24(sp)
 376:	e822                	sd	s0,16(sp)
 378:	1000                	addi	s0,sp,32
 37a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 37e:	4605                	li	a2,1
 380:	fef40593          	addi	a1,s0,-17
 384:	00000097          	auipc	ra,0x0
 388:	f6e080e7          	jalr	-146(ra) # 2f2 <write>
}
 38c:	60e2                	ld	ra,24(sp)
 38e:	6442                	ld	s0,16(sp)
 390:	6105                	addi	sp,sp,32
 392:	8082                	ret

0000000000000394 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 394:	7139                	addi	sp,sp,-64
 396:	fc06                	sd	ra,56(sp)
 398:	f822                	sd	s0,48(sp)
 39a:	f426                	sd	s1,40(sp)
 39c:	f04a                	sd	s2,32(sp)
 39e:	ec4e                	sd	s3,24(sp)
 3a0:	0080                	addi	s0,sp,64
 3a2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3a4:	c299                	beqz	a3,3aa <printint+0x16>
 3a6:	0805c863          	bltz	a1,436 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3aa:	2581                	sext.w	a1,a1
  neg = 0;
 3ac:	4881                	li	a7,0
 3ae:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3b2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3b4:	2601                	sext.w	a2,a2
 3b6:	00000517          	auipc	a0,0x0
 3ba:	4d250513          	addi	a0,a0,1234 # 888 <digits>
 3be:	883a                	mv	a6,a4
 3c0:	2705                	addiw	a4,a4,1
 3c2:	02c5f7bb          	remuw	a5,a1,a2
 3c6:	1782                	slli	a5,a5,0x20
 3c8:	9381                	srli	a5,a5,0x20
 3ca:	97aa                	add	a5,a5,a0
 3cc:	0007c783          	lbu	a5,0(a5)
 3d0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3d4:	0005879b          	sext.w	a5,a1
 3d8:	02c5d5bb          	divuw	a1,a1,a2
 3dc:	0685                	addi	a3,a3,1
 3de:	fec7f0e3          	bgeu	a5,a2,3be <printint+0x2a>
  if(neg)
 3e2:	00088b63          	beqz	a7,3f8 <printint+0x64>
    buf[i++] = '-';
 3e6:	fd040793          	addi	a5,s0,-48
 3ea:	973e                	add	a4,a4,a5
 3ec:	02d00793          	li	a5,45
 3f0:	fef70823          	sb	a5,-16(a4)
 3f4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3f8:	02e05863          	blez	a4,428 <printint+0x94>
 3fc:	fc040793          	addi	a5,s0,-64
 400:	00e78933          	add	s2,a5,a4
 404:	fff78993          	addi	s3,a5,-1
 408:	99ba                	add	s3,s3,a4
 40a:	377d                	addiw	a4,a4,-1
 40c:	1702                	slli	a4,a4,0x20
 40e:	9301                	srli	a4,a4,0x20
 410:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 414:	fff94583          	lbu	a1,-1(s2)
 418:	8526                	mv	a0,s1
 41a:	00000097          	auipc	ra,0x0
 41e:	f58080e7          	jalr	-168(ra) # 372 <putc>
  while(--i >= 0)
 422:	197d                	addi	s2,s2,-1
 424:	ff3918e3          	bne	s2,s3,414 <printint+0x80>
}
 428:	70e2                	ld	ra,56(sp)
 42a:	7442                	ld	s0,48(sp)
 42c:	74a2                	ld	s1,40(sp)
 42e:	7902                	ld	s2,32(sp)
 430:	69e2                	ld	s3,24(sp)
 432:	6121                	addi	sp,sp,64
 434:	8082                	ret
    x = -xx;
 436:	40b005bb          	negw	a1,a1
    neg = 1;
 43a:	4885                	li	a7,1
    x = -xx;
 43c:	bf8d                	j	3ae <printint+0x1a>

000000000000043e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 43e:	7119                	addi	sp,sp,-128
 440:	fc86                	sd	ra,120(sp)
 442:	f8a2                	sd	s0,112(sp)
 444:	f4a6                	sd	s1,104(sp)
 446:	f0ca                	sd	s2,96(sp)
 448:	ecce                	sd	s3,88(sp)
 44a:	e8d2                	sd	s4,80(sp)
 44c:	e4d6                	sd	s5,72(sp)
 44e:	e0da                	sd	s6,64(sp)
 450:	fc5e                	sd	s7,56(sp)
 452:	f862                	sd	s8,48(sp)
 454:	f466                	sd	s9,40(sp)
 456:	f06a                	sd	s10,32(sp)
 458:	ec6e                	sd	s11,24(sp)
 45a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 45c:	0005c903          	lbu	s2,0(a1)
 460:	18090f63          	beqz	s2,5fe <vprintf+0x1c0>
 464:	8aaa                	mv	s5,a0
 466:	8b32                	mv	s6,a2
 468:	00158493          	addi	s1,a1,1
  state = 0;
 46c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 46e:	02500a13          	li	s4,37
      if(c == 'd'){
 472:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 476:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 47a:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 47e:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 482:	00000b97          	auipc	s7,0x0
 486:	406b8b93          	addi	s7,s7,1030 # 888 <digits>
 48a:	a839                	j	4a8 <vprintf+0x6a>
        putc(fd, c);
 48c:	85ca                	mv	a1,s2
 48e:	8556                	mv	a0,s5
 490:	00000097          	auipc	ra,0x0
 494:	ee2080e7          	jalr	-286(ra) # 372 <putc>
 498:	a019                	j	49e <vprintf+0x60>
    } else if(state == '%'){
 49a:	01498f63          	beq	s3,s4,4b8 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 49e:	0485                	addi	s1,s1,1
 4a0:	fff4c903          	lbu	s2,-1(s1)
 4a4:	14090d63          	beqz	s2,5fe <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 4a8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4ac:	fe0997e3          	bnez	s3,49a <vprintf+0x5c>
      if(c == '%'){
 4b0:	fd479ee3          	bne	a5,s4,48c <vprintf+0x4e>
        state = '%';
 4b4:	89be                	mv	s3,a5
 4b6:	b7e5                	j	49e <vprintf+0x60>
      if(c == 'd'){
 4b8:	05878063          	beq	a5,s8,4f8 <vprintf+0xba>
      } else if(c == 'l') {
 4bc:	05978c63          	beq	a5,s9,514 <vprintf+0xd6>
      } else if(c == 'x') {
 4c0:	07a78863          	beq	a5,s10,530 <vprintf+0xf2>
      } else if(c == 'p') {
 4c4:	09b78463          	beq	a5,s11,54c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 4c8:	07300713          	li	a4,115
 4cc:	0ce78663          	beq	a5,a4,598 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4d0:	06300713          	li	a4,99
 4d4:	0ee78e63          	beq	a5,a4,5d0 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 4d8:	11478863          	beq	a5,s4,5e8 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4dc:	85d2                	mv	a1,s4
 4de:	8556                	mv	a0,s5
 4e0:	00000097          	auipc	ra,0x0
 4e4:	e92080e7          	jalr	-366(ra) # 372 <putc>
        putc(fd, c);
 4e8:	85ca                	mv	a1,s2
 4ea:	8556                	mv	a0,s5
 4ec:	00000097          	auipc	ra,0x0
 4f0:	e86080e7          	jalr	-378(ra) # 372 <putc>
      }
      state = 0;
 4f4:	4981                	li	s3,0
 4f6:	b765                	j	49e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 4f8:	008b0913          	addi	s2,s6,8
 4fc:	4685                	li	a3,1
 4fe:	4629                	li	a2,10
 500:	000b2583          	lw	a1,0(s6)
 504:	8556                	mv	a0,s5
 506:	00000097          	auipc	ra,0x0
 50a:	e8e080e7          	jalr	-370(ra) # 394 <printint>
 50e:	8b4a                	mv	s6,s2
      state = 0;
 510:	4981                	li	s3,0
 512:	b771                	j	49e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 514:	008b0913          	addi	s2,s6,8
 518:	4681                	li	a3,0
 51a:	4629                	li	a2,10
 51c:	000b2583          	lw	a1,0(s6)
 520:	8556                	mv	a0,s5
 522:	00000097          	auipc	ra,0x0
 526:	e72080e7          	jalr	-398(ra) # 394 <printint>
 52a:	8b4a                	mv	s6,s2
      state = 0;
 52c:	4981                	li	s3,0
 52e:	bf85                	j	49e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 530:	008b0913          	addi	s2,s6,8
 534:	4681                	li	a3,0
 536:	4641                	li	a2,16
 538:	000b2583          	lw	a1,0(s6)
 53c:	8556                	mv	a0,s5
 53e:	00000097          	auipc	ra,0x0
 542:	e56080e7          	jalr	-426(ra) # 394 <printint>
 546:	8b4a                	mv	s6,s2
      state = 0;
 548:	4981                	li	s3,0
 54a:	bf91                	j	49e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 54c:	008b0793          	addi	a5,s6,8
 550:	f8f43423          	sd	a5,-120(s0)
 554:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 558:	03000593          	li	a1,48
 55c:	8556                	mv	a0,s5
 55e:	00000097          	auipc	ra,0x0
 562:	e14080e7          	jalr	-492(ra) # 372 <putc>
  putc(fd, 'x');
 566:	85ea                	mv	a1,s10
 568:	8556                	mv	a0,s5
 56a:	00000097          	auipc	ra,0x0
 56e:	e08080e7          	jalr	-504(ra) # 372 <putc>
 572:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 574:	03c9d793          	srli	a5,s3,0x3c
 578:	97de                	add	a5,a5,s7
 57a:	0007c583          	lbu	a1,0(a5)
 57e:	8556                	mv	a0,s5
 580:	00000097          	auipc	ra,0x0
 584:	df2080e7          	jalr	-526(ra) # 372 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 588:	0992                	slli	s3,s3,0x4
 58a:	397d                	addiw	s2,s2,-1
 58c:	fe0914e3          	bnez	s2,574 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 590:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 594:	4981                	li	s3,0
 596:	b721                	j	49e <vprintf+0x60>
        s = va_arg(ap, char*);
 598:	008b0993          	addi	s3,s6,8
 59c:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 5a0:	02090163          	beqz	s2,5c2 <vprintf+0x184>
        while(*s != 0){
 5a4:	00094583          	lbu	a1,0(s2)
 5a8:	c9a1                	beqz	a1,5f8 <vprintf+0x1ba>
          putc(fd, *s);
 5aa:	8556                	mv	a0,s5
 5ac:	00000097          	auipc	ra,0x0
 5b0:	dc6080e7          	jalr	-570(ra) # 372 <putc>
          s++;
 5b4:	0905                	addi	s2,s2,1
        while(*s != 0){
 5b6:	00094583          	lbu	a1,0(s2)
 5ba:	f9e5                	bnez	a1,5aa <vprintf+0x16c>
        s = va_arg(ap, char*);
 5bc:	8b4e                	mv	s6,s3
      state = 0;
 5be:	4981                	li	s3,0
 5c0:	bdf9                	j	49e <vprintf+0x60>
          s = "(null)";
 5c2:	00000917          	auipc	s2,0x0
 5c6:	2be90913          	addi	s2,s2,702 # 880 <longjmp_1+0x22>
        while(*s != 0){
 5ca:	02800593          	li	a1,40
 5ce:	bff1                	j	5aa <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 5d0:	008b0913          	addi	s2,s6,8
 5d4:	000b4583          	lbu	a1,0(s6)
 5d8:	8556                	mv	a0,s5
 5da:	00000097          	auipc	ra,0x0
 5de:	d98080e7          	jalr	-616(ra) # 372 <putc>
 5e2:	8b4a                	mv	s6,s2
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	bd65                	j	49e <vprintf+0x60>
        putc(fd, c);
 5e8:	85d2                	mv	a1,s4
 5ea:	8556                	mv	a0,s5
 5ec:	00000097          	auipc	ra,0x0
 5f0:	d86080e7          	jalr	-634(ra) # 372 <putc>
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	b565                	j	49e <vprintf+0x60>
        s = va_arg(ap, char*);
 5f8:	8b4e                	mv	s6,s3
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	b54d                	j	49e <vprintf+0x60>
    }
  }
}
 5fe:	70e6                	ld	ra,120(sp)
 600:	7446                	ld	s0,112(sp)
 602:	74a6                	ld	s1,104(sp)
 604:	7906                	ld	s2,96(sp)
 606:	69e6                	ld	s3,88(sp)
 608:	6a46                	ld	s4,80(sp)
 60a:	6aa6                	ld	s5,72(sp)
 60c:	6b06                	ld	s6,64(sp)
 60e:	7be2                	ld	s7,56(sp)
 610:	7c42                	ld	s8,48(sp)
 612:	7ca2                	ld	s9,40(sp)
 614:	7d02                	ld	s10,32(sp)
 616:	6de2                	ld	s11,24(sp)
 618:	6109                	addi	sp,sp,128
 61a:	8082                	ret

000000000000061c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 61c:	715d                	addi	sp,sp,-80
 61e:	ec06                	sd	ra,24(sp)
 620:	e822                	sd	s0,16(sp)
 622:	1000                	addi	s0,sp,32
 624:	e010                	sd	a2,0(s0)
 626:	e414                	sd	a3,8(s0)
 628:	e818                	sd	a4,16(s0)
 62a:	ec1c                	sd	a5,24(s0)
 62c:	03043023          	sd	a6,32(s0)
 630:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 634:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 638:	8622                	mv	a2,s0
 63a:	00000097          	auipc	ra,0x0
 63e:	e04080e7          	jalr	-508(ra) # 43e <vprintf>
}
 642:	60e2                	ld	ra,24(sp)
 644:	6442                	ld	s0,16(sp)
 646:	6161                	addi	sp,sp,80
 648:	8082                	ret

000000000000064a <printf>:

void
printf(const char *fmt, ...)
{
 64a:	711d                	addi	sp,sp,-96
 64c:	ec06                	sd	ra,24(sp)
 64e:	e822                	sd	s0,16(sp)
 650:	1000                	addi	s0,sp,32
 652:	e40c                	sd	a1,8(s0)
 654:	e810                	sd	a2,16(s0)
 656:	ec14                	sd	a3,24(s0)
 658:	f018                	sd	a4,32(s0)
 65a:	f41c                	sd	a5,40(s0)
 65c:	03043823          	sd	a6,48(s0)
 660:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 664:	00840613          	addi	a2,s0,8
 668:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 66c:	85aa                	mv	a1,a0
 66e:	4505                	li	a0,1
 670:	00000097          	auipc	ra,0x0
 674:	dce080e7          	jalr	-562(ra) # 43e <vprintf>
}
 678:	60e2                	ld	ra,24(sp)
 67a:	6442                	ld	s0,16(sp)
 67c:	6125                	addi	sp,sp,96
 67e:	8082                	ret

0000000000000680 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 680:	1141                	addi	sp,sp,-16
 682:	e422                	sd	s0,8(sp)
 684:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 686:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 68a:	00000797          	auipc	a5,0x0
 68e:	2167b783          	ld	a5,534(a5) # 8a0 <freep>
 692:	a805                	j	6c2 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 694:	4618                	lw	a4,8(a2)
 696:	9db9                	addw	a1,a1,a4
 698:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 69c:	6398                	ld	a4,0(a5)
 69e:	6318                	ld	a4,0(a4)
 6a0:	fee53823          	sd	a4,-16(a0)
 6a4:	a091                	j	6e8 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6a6:	ff852703          	lw	a4,-8(a0)
 6aa:	9e39                	addw	a2,a2,a4
 6ac:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 6ae:	ff053703          	ld	a4,-16(a0)
 6b2:	e398                	sd	a4,0(a5)
 6b4:	a099                	j	6fa <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b6:	6398                	ld	a4,0(a5)
 6b8:	00e7e463          	bltu	a5,a4,6c0 <free+0x40>
 6bc:	00e6ea63          	bltu	a3,a4,6d0 <free+0x50>
{
 6c0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c2:	fed7fae3          	bgeu	a5,a3,6b6 <free+0x36>
 6c6:	6398                	ld	a4,0(a5)
 6c8:	00e6e463          	bltu	a3,a4,6d0 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6cc:	fee7eae3          	bltu	a5,a4,6c0 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 6d0:	ff852583          	lw	a1,-8(a0)
 6d4:	6390                	ld	a2,0(a5)
 6d6:	02059713          	slli	a4,a1,0x20
 6da:	9301                	srli	a4,a4,0x20
 6dc:	0712                	slli	a4,a4,0x4
 6de:	9736                	add	a4,a4,a3
 6e0:	fae60ae3          	beq	a2,a4,694 <free+0x14>
    bp->s.ptr = p->s.ptr;
 6e4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6e8:	4790                	lw	a2,8(a5)
 6ea:	02061713          	slli	a4,a2,0x20
 6ee:	9301                	srli	a4,a4,0x20
 6f0:	0712                	slli	a4,a4,0x4
 6f2:	973e                	add	a4,a4,a5
 6f4:	fae689e3          	beq	a3,a4,6a6 <free+0x26>
  } else
    p->s.ptr = bp;
 6f8:	e394                	sd	a3,0(a5)
  freep = p;
 6fa:	00000717          	auipc	a4,0x0
 6fe:	1af73323          	sd	a5,422(a4) # 8a0 <freep>
}
 702:	6422                	ld	s0,8(sp)
 704:	0141                	addi	sp,sp,16
 706:	8082                	ret

0000000000000708 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 708:	7139                	addi	sp,sp,-64
 70a:	fc06                	sd	ra,56(sp)
 70c:	f822                	sd	s0,48(sp)
 70e:	f426                	sd	s1,40(sp)
 710:	f04a                	sd	s2,32(sp)
 712:	ec4e                	sd	s3,24(sp)
 714:	e852                	sd	s4,16(sp)
 716:	e456                	sd	s5,8(sp)
 718:	e05a                	sd	s6,0(sp)
 71a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 71c:	02051493          	slli	s1,a0,0x20
 720:	9081                	srli	s1,s1,0x20
 722:	04bd                	addi	s1,s1,15
 724:	8091                	srli	s1,s1,0x4
 726:	0014899b          	addiw	s3,s1,1
 72a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 72c:	00000517          	auipc	a0,0x0
 730:	17453503          	ld	a0,372(a0) # 8a0 <freep>
 734:	c515                	beqz	a0,760 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 736:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 738:	4798                	lw	a4,8(a5)
 73a:	02977f63          	bgeu	a4,s1,778 <malloc+0x70>
 73e:	8a4e                	mv	s4,s3
 740:	0009871b          	sext.w	a4,s3
 744:	6685                	lui	a3,0x1
 746:	00d77363          	bgeu	a4,a3,74c <malloc+0x44>
 74a:	6a05                	lui	s4,0x1
 74c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 750:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 754:	00000917          	auipc	s2,0x0
 758:	14c90913          	addi	s2,s2,332 # 8a0 <freep>
  if(p == (char*)-1)
 75c:	5afd                	li	s5,-1
 75e:	a88d                	j	7d0 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 760:	00000797          	auipc	a5,0x0
 764:	14878793          	addi	a5,a5,328 # 8a8 <base>
 768:	00000717          	auipc	a4,0x0
 76c:	12f73c23          	sd	a5,312(a4) # 8a0 <freep>
 770:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 772:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 776:	b7e1                	j	73e <malloc+0x36>
      if(p->s.size == nunits)
 778:	02e48b63          	beq	s1,a4,7ae <malloc+0xa6>
        p->s.size -= nunits;
 77c:	4137073b          	subw	a4,a4,s3
 780:	c798                	sw	a4,8(a5)
        p += p->s.size;
 782:	1702                	slli	a4,a4,0x20
 784:	9301                	srli	a4,a4,0x20
 786:	0712                	slli	a4,a4,0x4
 788:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 78a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 78e:	00000717          	auipc	a4,0x0
 792:	10a73923          	sd	a0,274(a4) # 8a0 <freep>
      return (void*)(p + 1);
 796:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 79a:	70e2                	ld	ra,56(sp)
 79c:	7442                	ld	s0,48(sp)
 79e:	74a2                	ld	s1,40(sp)
 7a0:	7902                	ld	s2,32(sp)
 7a2:	69e2                	ld	s3,24(sp)
 7a4:	6a42                	ld	s4,16(sp)
 7a6:	6aa2                	ld	s5,8(sp)
 7a8:	6b02                	ld	s6,0(sp)
 7aa:	6121                	addi	sp,sp,64
 7ac:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7ae:	6398                	ld	a4,0(a5)
 7b0:	e118                	sd	a4,0(a0)
 7b2:	bff1                	j	78e <malloc+0x86>
  hp->s.size = nu;
 7b4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7b8:	0541                	addi	a0,a0,16
 7ba:	00000097          	auipc	ra,0x0
 7be:	ec6080e7          	jalr	-314(ra) # 680 <free>
  return freep;
 7c2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7c6:	d971                	beqz	a0,79a <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ca:	4798                	lw	a4,8(a5)
 7cc:	fa9776e3          	bgeu	a4,s1,778 <malloc+0x70>
    if(p == freep)
 7d0:	00093703          	ld	a4,0(s2)
 7d4:	853e                	mv	a0,a5
 7d6:	fef719e3          	bne	a4,a5,7c8 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 7da:	8552                	mv	a0,s4
 7dc:	00000097          	auipc	ra,0x0
 7e0:	b7e080e7          	jalr	-1154(ra) # 35a <sbrk>
  if(p == (char*)-1)
 7e4:	fd5518e3          	bne	a0,s5,7b4 <malloc+0xac>
        return 0;
 7e8:	4501                	li	a0,0
 7ea:	bf45                	j	79a <malloc+0x92>

00000000000007ec <setjmp>:
 7ec:	e100                	sd	s0,0(a0)
 7ee:	e504                	sd	s1,8(a0)
 7f0:	01253823          	sd	s2,16(a0)
 7f4:	01353c23          	sd	s3,24(a0)
 7f8:	03453023          	sd	s4,32(a0)
 7fc:	03553423          	sd	s5,40(a0)
 800:	03653823          	sd	s6,48(a0)
 804:	03753c23          	sd	s7,56(a0)
 808:	05853023          	sd	s8,64(a0)
 80c:	05953423          	sd	s9,72(a0)
 810:	05a53823          	sd	s10,80(a0)
 814:	05b53c23          	sd	s11,88(a0)
 818:	06153023          	sd	ra,96(a0)
 81c:	06253423          	sd	sp,104(a0)
 820:	4501                	li	a0,0
 822:	8082                	ret

0000000000000824 <longjmp>:
 824:	6100                	ld	s0,0(a0)
 826:	6504                	ld	s1,8(a0)
 828:	01053903          	ld	s2,16(a0)
 82c:	01853983          	ld	s3,24(a0)
 830:	02053a03          	ld	s4,32(a0)
 834:	02853a83          	ld	s5,40(a0)
 838:	03053b03          	ld	s6,48(a0)
 83c:	03853b83          	ld	s7,56(a0)
 840:	04053c03          	ld	s8,64(a0)
 844:	04853c83          	ld	s9,72(a0)
 848:	05053d03          	ld	s10,80(a0)
 84c:	05853d83          	ld	s11,88(a0)
 850:	06053083          	ld	ra,96(a0)
 854:	06853103          	ld	sp,104(a0)
 858:	c199                	beqz	a1,85e <longjmp_1>
 85a:	852e                	mv	a0,a1
 85c:	8082                	ret

000000000000085e <longjmp_1>:
 85e:	4505                	li	a0,1
 860:	8082                	ret
