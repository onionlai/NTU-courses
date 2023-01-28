
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	00000097          	auipc	ra,0x0
   c:	2aa080e7          	jalr	682(ra) # 2b2 <fork>
  10:	00a04763          	bgtz	a0,1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  exit(0);
  14:	4501                	li	a0,0
  16:	00000097          	auipc	ra,0x0
  1a:	2a4080e7          	jalr	676(ra) # 2ba <exit>
    sleep(5);  // Let child exit before parent.
  1e:	4515                	li	a0,5
  20:	00000097          	auipc	ra,0x0
  24:	32a080e7          	jalr	810(ra) # 34a <sleep>
  28:	b7f5                	j	14 <main+0x14>

000000000000002a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  2a:	1141                	addi	sp,sp,-16
  2c:	e422                	sd	s0,8(sp)
  2e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  30:	87aa                	mv	a5,a0
  32:	0585                	addi	a1,a1,1
  34:	0785                	addi	a5,a5,1
  36:	fff5c703          	lbu	a4,-1(a1)
  3a:	fee78fa3          	sb	a4,-1(a5)
  3e:	fb75                	bnez	a4,32 <strcpy+0x8>
    ;
  return os;
}
  40:	6422                	ld	s0,8(sp)
  42:	0141                	addi	sp,sp,16
  44:	8082                	ret

0000000000000046 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  46:	1141                	addi	sp,sp,-16
  48:	e422                	sd	s0,8(sp)
  4a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  4c:	00054783          	lbu	a5,0(a0)
  50:	cf91                	beqz	a5,6c <strcmp+0x26>
  52:	0005c703          	lbu	a4,0(a1)
  56:	00f71b63          	bne	a4,a5,6c <strcmp+0x26>
    p++, q++;
  5a:	0505                	addi	a0,a0,1
  5c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  5e:	00054783          	lbu	a5,0(a0)
  62:	c789                	beqz	a5,6c <strcmp+0x26>
  64:	0005c703          	lbu	a4,0(a1)
  68:	fef709e3          	beq	a4,a5,5a <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  6c:	0005c503          	lbu	a0,0(a1)
}
  70:	40a7853b          	subw	a0,a5,a0
  74:	6422                	ld	s0,8(sp)
  76:	0141                	addi	sp,sp,16
  78:	8082                	ret

000000000000007a <strlen>:

uint
strlen(const char *s)
{
  7a:	1141                	addi	sp,sp,-16
  7c:	e422                	sd	s0,8(sp)
  7e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  80:	00054783          	lbu	a5,0(a0)
  84:	cf91                	beqz	a5,a0 <strlen+0x26>
  86:	0505                	addi	a0,a0,1
  88:	87aa                	mv	a5,a0
  8a:	4685                	li	a3,1
  8c:	9e89                	subw	a3,a3,a0
    ;
  8e:	00f6853b          	addw	a0,a3,a5
  92:	0785                	addi	a5,a5,1
  for(n = 0; s[n]; n++)
  94:	fff7c703          	lbu	a4,-1(a5)
  98:	fb7d                	bnez	a4,8e <strlen+0x14>
  return n;
}
  9a:	6422                	ld	s0,8(sp)
  9c:	0141                	addi	sp,sp,16
  9e:	8082                	ret
  for(n = 0; s[n]; n++)
  a0:	4501                	li	a0,0
  a2:	bfe5                	j	9a <strlen+0x20>

00000000000000a4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a4:	1141                	addi	sp,sp,-16
  a6:	e422                	sd	s0,8(sp)
  a8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  aa:	ce09                	beqz	a2,c4 <memset+0x20>
  ac:	87aa                	mv	a5,a0
  ae:	fff6071b          	addiw	a4,a2,-1
  b2:	1702                	slli	a4,a4,0x20
  b4:	9301                	srli	a4,a4,0x20
  b6:	0705                	addi	a4,a4,1
  b8:	972a                	add	a4,a4,a0
    cdst[i] = c;
  ba:	00b78023          	sb	a1,0(a5)
  be:	0785                	addi	a5,a5,1
  for(i = 0; i < n; i++){
  c0:	fee79de3          	bne	a5,a4,ba <memset+0x16>
  }
  return dst;
}
  c4:	6422                	ld	s0,8(sp)
  c6:	0141                	addi	sp,sp,16
  c8:	8082                	ret

00000000000000ca <strchr>:

char*
strchr(const char *s, char c)
{
  ca:	1141                	addi	sp,sp,-16
  cc:	e422                	sd	s0,8(sp)
  ce:	0800                	addi	s0,sp,16
  for(; *s; s++)
  d0:	00054783          	lbu	a5,0(a0)
  d4:	cf91                	beqz	a5,f0 <strchr+0x26>
    if(*s == c)
  d6:	00f58a63          	beq	a1,a5,ea <strchr+0x20>
  for(; *s; s++)
  da:	0505                	addi	a0,a0,1
  dc:	00054783          	lbu	a5,0(a0)
  e0:	c781                	beqz	a5,e8 <strchr+0x1e>
    if(*s == c)
  e2:	feb79ce3          	bne	a5,a1,da <strchr+0x10>
  e6:	a011                	j	ea <strchr+0x20>
      return (char*)s;
  return 0;
  e8:	4501                	li	a0,0
}
  ea:	6422                	ld	s0,8(sp)
  ec:	0141                	addi	sp,sp,16
  ee:	8082                	ret
  return 0;
  f0:	4501                	li	a0,0
  f2:	bfe5                	j	ea <strchr+0x20>

00000000000000f4 <gets>:

char*
gets(char *buf, int max)
{
  f4:	711d                	addi	sp,sp,-96
  f6:	ec86                	sd	ra,88(sp)
  f8:	e8a2                	sd	s0,80(sp)
  fa:	e4a6                	sd	s1,72(sp)
  fc:	e0ca                	sd	s2,64(sp)
  fe:	fc4e                	sd	s3,56(sp)
 100:	f852                	sd	s4,48(sp)
 102:	f456                	sd	s5,40(sp)
 104:	f05a                	sd	s6,32(sp)
 106:	ec5e                	sd	s7,24(sp)
 108:	1080                	addi	s0,sp,96
 10a:	8baa                	mv	s7,a0
 10c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 10e:	892a                	mv	s2,a0
 110:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 112:	4aa9                	li	s5,10
 114:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 116:	0019849b          	addiw	s1,s3,1
 11a:	0344d863          	ble	s4,s1,14a <gets+0x56>
    cc = read(0, &c, 1);
 11e:	4605                	li	a2,1
 120:	faf40593          	addi	a1,s0,-81
 124:	4501                	li	a0,0
 126:	00000097          	auipc	ra,0x0
 12a:	1ac080e7          	jalr	428(ra) # 2d2 <read>
    if(cc < 1)
 12e:	00a05e63          	blez	a0,14a <gets+0x56>
    buf[i++] = c;
 132:	faf44783          	lbu	a5,-81(s0)
 136:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 13a:	01578763          	beq	a5,s5,148 <gets+0x54>
 13e:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
 140:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
 142:	fd679ae3          	bne	a5,s6,116 <gets+0x22>
 146:	a011                	j	14a <gets+0x56>
  for(i=0; i+1 < max; ){
 148:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 14a:	99de                	add	s3,s3,s7
 14c:	00098023          	sb	zero,0(s3)
  return buf;
}
 150:	855e                	mv	a0,s7
 152:	60e6                	ld	ra,88(sp)
 154:	6446                	ld	s0,80(sp)
 156:	64a6                	ld	s1,72(sp)
 158:	6906                	ld	s2,64(sp)
 15a:	79e2                	ld	s3,56(sp)
 15c:	7a42                	ld	s4,48(sp)
 15e:	7aa2                	ld	s5,40(sp)
 160:	7b02                	ld	s6,32(sp)
 162:	6be2                	ld	s7,24(sp)
 164:	6125                	addi	sp,sp,96
 166:	8082                	ret

0000000000000168 <stat>:

int
stat(const char *n, struct stat *st)
{
 168:	1101                	addi	sp,sp,-32
 16a:	ec06                	sd	ra,24(sp)
 16c:	e822                	sd	s0,16(sp)
 16e:	e426                	sd	s1,8(sp)
 170:	e04a                	sd	s2,0(sp)
 172:	1000                	addi	s0,sp,32
 174:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY|O_NOFOLLOW);
 176:	4591                	li	a1,4
 178:	00000097          	auipc	ra,0x0
 17c:	182080e7          	jalr	386(ra) # 2fa <open>
  if(fd < 0)
 180:	02054563          	bltz	a0,1aa <stat+0x42>
 184:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 186:	85ca                	mv	a1,s2
 188:	00000097          	auipc	ra,0x0
 18c:	18a080e7          	jalr	394(ra) # 312 <fstat>
 190:	892a                	mv	s2,a0
  close(fd);
 192:	8526                	mv	a0,s1
 194:	00000097          	auipc	ra,0x0
 198:	14e080e7          	jalr	334(ra) # 2e2 <close>
  return r;
}
 19c:	854a                	mv	a0,s2
 19e:	60e2                	ld	ra,24(sp)
 1a0:	6442                	ld	s0,16(sp)
 1a2:	64a2                	ld	s1,8(sp)
 1a4:	6902                	ld	s2,0(sp)
 1a6:	6105                	addi	sp,sp,32
 1a8:	8082                	ret
    return -1;
 1aa:	597d                	li	s2,-1
 1ac:	bfc5                	j	19c <stat+0x34>

00000000000001ae <atoi>:

int
atoi(const char *s)
{
 1ae:	1141                	addi	sp,sp,-16
 1b0:	e422                	sd	s0,8(sp)
 1b2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1b4:	00054683          	lbu	a3,0(a0)
 1b8:	fd06879b          	addiw	a5,a3,-48
 1bc:	0ff7f793          	andi	a5,a5,255
 1c0:	4725                	li	a4,9
 1c2:	02f76963          	bltu	a4,a5,1f4 <atoi+0x46>
 1c6:	862a                	mv	a2,a0
  n = 0;
 1c8:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1ca:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1cc:	0605                	addi	a2,a2,1
 1ce:	0025179b          	slliw	a5,a0,0x2
 1d2:	9fa9                	addw	a5,a5,a0
 1d4:	0017979b          	slliw	a5,a5,0x1
 1d8:	9fb5                	addw	a5,a5,a3
 1da:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1de:	00064683          	lbu	a3,0(a2)
 1e2:	fd06871b          	addiw	a4,a3,-48
 1e6:	0ff77713          	andi	a4,a4,255
 1ea:	fee5f1e3          	bleu	a4,a1,1cc <atoi+0x1e>
  return n;
}
 1ee:	6422                	ld	s0,8(sp)
 1f0:	0141                	addi	sp,sp,16
 1f2:	8082                	ret
  n = 0;
 1f4:	4501                	li	a0,0
 1f6:	bfe5                	j	1ee <atoi+0x40>

00000000000001f8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1f8:	1141                	addi	sp,sp,-16
 1fa:	e422                	sd	s0,8(sp)
 1fc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1fe:	02b57663          	bleu	a1,a0,22a <memmove+0x32>
    while(n-- > 0)
 202:	02c05163          	blez	a2,224 <memmove+0x2c>
 206:	fff6079b          	addiw	a5,a2,-1
 20a:	1782                	slli	a5,a5,0x20
 20c:	9381                	srli	a5,a5,0x20
 20e:	0785                	addi	a5,a5,1
 210:	97aa                	add	a5,a5,a0
  dst = vdst;
 212:	872a                	mv	a4,a0
      *dst++ = *src++;
 214:	0585                	addi	a1,a1,1
 216:	0705                	addi	a4,a4,1
 218:	fff5c683          	lbu	a3,-1(a1)
 21c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 220:	fee79ae3          	bne	a5,a4,214 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 224:	6422                	ld	s0,8(sp)
 226:	0141                	addi	sp,sp,16
 228:	8082                	ret
    dst += n;
 22a:	00c50733          	add	a4,a0,a2
    src += n;
 22e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 230:	fec05ae3          	blez	a2,224 <memmove+0x2c>
 234:	fff6079b          	addiw	a5,a2,-1
 238:	1782                	slli	a5,a5,0x20
 23a:	9381                	srli	a5,a5,0x20
 23c:	fff7c793          	not	a5,a5
 240:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 242:	15fd                	addi	a1,a1,-1
 244:	177d                	addi	a4,a4,-1
 246:	0005c683          	lbu	a3,0(a1)
 24a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 24e:	fef71ae3          	bne	a4,a5,242 <memmove+0x4a>
 252:	bfc9                	j	224 <memmove+0x2c>

0000000000000254 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 254:	1141                	addi	sp,sp,-16
 256:	e422                	sd	s0,8(sp)
 258:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 25a:	ce15                	beqz	a2,296 <memcmp+0x42>
 25c:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
 260:	00054783          	lbu	a5,0(a0)
 264:	0005c703          	lbu	a4,0(a1)
 268:	02e79063          	bne	a5,a4,288 <memcmp+0x34>
 26c:	1682                	slli	a3,a3,0x20
 26e:	9281                	srli	a3,a3,0x20
 270:	0685                	addi	a3,a3,1
 272:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
 274:	0505                	addi	a0,a0,1
    p2++;
 276:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 278:	00d50d63          	beq	a0,a3,292 <memcmp+0x3e>
    if (*p1 != *p2) {
 27c:	00054783          	lbu	a5,0(a0)
 280:	0005c703          	lbu	a4,0(a1)
 284:	fee788e3          	beq	a5,a4,274 <memcmp+0x20>
      return *p1 - *p2;
 288:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
 28c:	6422                	ld	s0,8(sp)
 28e:	0141                	addi	sp,sp,16
 290:	8082                	ret
  return 0;
 292:	4501                	li	a0,0
 294:	bfe5                	j	28c <memcmp+0x38>
 296:	4501                	li	a0,0
 298:	bfd5                	j	28c <memcmp+0x38>

000000000000029a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 29a:	1141                	addi	sp,sp,-16
 29c:	e406                	sd	ra,8(sp)
 29e:	e022                	sd	s0,0(sp)
 2a0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2a2:	00000097          	auipc	ra,0x0
 2a6:	f56080e7          	jalr	-170(ra) # 1f8 <memmove>
}
 2aa:	60a2                	ld	ra,8(sp)
 2ac:	6402                	ld	s0,0(sp)
 2ae:	0141                	addi	sp,sp,16
 2b0:	8082                	ret

00000000000002b2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2b2:	4885                	li	a7,1
 ecall
 2b4:	00000073          	ecall
 ret
 2b8:	8082                	ret

00000000000002ba <exit>:
.global exit
exit:
 li a7, SYS_exit
 2ba:	4889                	li	a7,2
 ecall
 2bc:	00000073          	ecall
 ret
 2c0:	8082                	ret

00000000000002c2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2c2:	488d                	li	a7,3
 ecall
 2c4:	00000073          	ecall
 ret
 2c8:	8082                	ret

00000000000002ca <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2ca:	4891                	li	a7,4
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <read>:
.global read
read:
 li a7, SYS_read
 2d2:	4895                	li	a7,5
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <write>:
.global write
write:
 li a7, SYS_write
 2da:	48c1                	li	a7,16
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <close>:
.global close
close:
 li a7, SYS_close
 2e2:	48d5                	li	a7,21
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <kill>:
.global kill
kill:
 li a7, SYS_kill
 2ea:	4899                	li	a7,6
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2f2:	489d                	li	a7,7
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <open>:
.global open
open:
 li a7, SYS_open
 2fa:	48bd                	li	a7,15
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 302:	48c5                	li	a7,17
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 30a:	48c9                	li	a7,18
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 312:	48a1                	li	a7,8
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <link>:
.global link
link:
 li a7, SYS_link
 31a:	48cd                	li	a7,19
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 322:	48d1                	li	a7,20
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 32a:	48a5                	li	a7,9
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <dup>:
.global dup
dup:
 li a7, SYS_dup
 332:	48a9                	li	a7,10
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 33a:	48ad                	li	a7,11
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 342:	48b1                	li	a7,12
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 34a:	48b5                	li	a7,13
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 352:	48b9                	li	a7,14
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 35a:	48d9                	li	a7,22
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 362:	1101                	addi	sp,sp,-32
 364:	ec06                	sd	ra,24(sp)
 366:	e822                	sd	s0,16(sp)
 368:	1000                	addi	s0,sp,32
 36a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 36e:	4605                	li	a2,1
 370:	fef40593          	addi	a1,s0,-17
 374:	00000097          	auipc	ra,0x0
 378:	f66080e7          	jalr	-154(ra) # 2da <write>
}
 37c:	60e2                	ld	ra,24(sp)
 37e:	6442                	ld	s0,16(sp)
 380:	6105                	addi	sp,sp,32
 382:	8082                	ret

0000000000000384 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 384:	7139                	addi	sp,sp,-64
 386:	fc06                	sd	ra,56(sp)
 388:	f822                	sd	s0,48(sp)
 38a:	f426                	sd	s1,40(sp)
 38c:	f04a                	sd	s2,32(sp)
 38e:	ec4e                	sd	s3,24(sp)
 390:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 392:	c299                	beqz	a3,398 <printint+0x14>
 394:	0005cd63          	bltz	a1,3ae <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 398:	2581                	sext.w	a1,a1
  neg = 0;
 39a:	4301                	li	t1,0
 39c:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
 3a0:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
 3a2:	2601                	sext.w	a2,a2
 3a4:	00000897          	auipc	a7,0x0
 3a8:	43c88893          	addi	a7,a7,1084 # 7e0 <digits>
 3ac:	a801                	j	3bc <printint+0x38>
    x = -xx;
 3ae:	40b005bb          	negw	a1,a1
 3b2:	2581                	sext.w	a1,a1
    neg = 1;
 3b4:	4305                	li	t1,1
    x = -xx;
 3b6:	b7dd                	j	39c <printint+0x18>
  }while((x /= base) != 0);
 3b8:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
 3ba:	8836                	mv	a6,a3
 3bc:	0018069b          	addiw	a3,a6,1
 3c0:	02c5f7bb          	remuw	a5,a1,a2
 3c4:	1782                	slli	a5,a5,0x20
 3c6:	9381                	srli	a5,a5,0x20
 3c8:	97c6                	add	a5,a5,a7
 3ca:	0007c783          	lbu	a5,0(a5)
 3ce:	00f70023          	sb	a5,0(a4)
 3d2:	0705                	addi	a4,a4,1
  }while((x /= base) != 0);
 3d4:	02c5d7bb          	divuw	a5,a1,a2
 3d8:	fec5f0e3          	bleu	a2,a1,3b8 <printint+0x34>
  if(neg)
 3dc:	00030b63          	beqz	t1,3f2 <printint+0x6e>
    buf[i++] = '-';
 3e0:	fd040793          	addi	a5,s0,-48
 3e4:	96be                	add	a3,a3,a5
 3e6:	02d00793          	li	a5,45
 3ea:	fef68823          	sb	a5,-16(a3)
 3ee:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
 3f2:	02d05963          	blez	a3,424 <printint+0xa0>
 3f6:	89aa                	mv	s3,a0
 3f8:	fc040793          	addi	a5,s0,-64
 3fc:	00d784b3          	add	s1,a5,a3
 400:	fff78913          	addi	s2,a5,-1
 404:	9936                	add	s2,s2,a3
 406:	36fd                	addiw	a3,a3,-1
 408:	1682                	slli	a3,a3,0x20
 40a:	9281                	srli	a3,a3,0x20
 40c:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
 410:	fff4c583          	lbu	a1,-1(s1)
 414:	854e                	mv	a0,s3
 416:	00000097          	auipc	ra,0x0
 41a:	f4c080e7          	jalr	-180(ra) # 362 <putc>
 41e:	14fd                	addi	s1,s1,-1
  while(--i >= 0)
 420:	ff2498e3          	bne	s1,s2,410 <printint+0x8c>
}
 424:	70e2                	ld	ra,56(sp)
 426:	7442                	ld	s0,48(sp)
 428:	74a2                	ld	s1,40(sp)
 42a:	7902                	ld	s2,32(sp)
 42c:	69e2                	ld	s3,24(sp)
 42e:	6121                	addi	sp,sp,64
 430:	8082                	ret

0000000000000432 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 432:	7119                	addi	sp,sp,-128
 434:	fc86                	sd	ra,120(sp)
 436:	f8a2                	sd	s0,112(sp)
 438:	f4a6                	sd	s1,104(sp)
 43a:	f0ca                	sd	s2,96(sp)
 43c:	ecce                	sd	s3,88(sp)
 43e:	e8d2                	sd	s4,80(sp)
 440:	e4d6                	sd	s5,72(sp)
 442:	e0da                	sd	s6,64(sp)
 444:	fc5e                	sd	s7,56(sp)
 446:	f862                	sd	s8,48(sp)
 448:	f466                	sd	s9,40(sp)
 44a:	f06a                	sd	s10,32(sp)
 44c:	ec6e                	sd	s11,24(sp)
 44e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 450:	0005c483          	lbu	s1,0(a1)
 454:	18048d63          	beqz	s1,5ee <vprintf+0x1bc>
 458:	8aaa                	mv	s5,a0
 45a:	8b32                	mv	s6,a2
 45c:	00158913          	addi	s2,a1,1
  state = 0;
 460:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 462:	02500a13          	li	s4,37
      if(c == 'd'){
 466:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 46a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 46e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 472:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 476:	00000b97          	auipc	s7,0x0
 47a:	36ab8b93          	addi	s7,s7,874 # 7e0 <digits>
 47e:	a839                	j	49c <vprintf+0x6a>
        putc(fd, c);
 480:	85a6                	mv	a1,s1
 482:	8556                	mv	a0,s5
 484:	00000097          	auipc	ra,0x0
 488:	ede080e7          	jalr	-290(ra) # 362 <putc>
 48c:	a019                	j	492 <vprintf+0x60>
    } else if(state == '%'){
 48e:	01498f63          	beq	s3,s4,4ac <vprintf+0x7a>
 492:	0905                	addi	s2,s2,1
  for(i = 0; fmt[i]; i++){
 494:	fff94483          	lbu	s1,-1(s2)
 498:	14048b63          	beqz	s1,5ee <vprintf+0x1bc>
    c = fmt[i] & 0xff;
 49c:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4a0:	fe0997e3          	bnez	s3,48e <vprintf+0x5c>
      if(c == '%'){
 4a4:	fd479ee3          	bne	a5,s4,480 <vprintf+0x4e>
        state = '%';
 4a8:	89be                	mv	s3,a5
 4aa:	b7e5                	j	492 <vprintf+0x60>
      if(c == 'd'){
 4ac:	05878063          	beq	a5,s8,4ec <vprintf+0xba>
      } else if(c == 'l') {
 4b0:	05978c63          	beq	a5,s9,508 <vprintf+0xd6>
      } else if(c == 'x') {
 4b4:	07a78863          	beq	a5,s10,524 <vprintf+0xf2>
      } else if(c == 'p') {
 4b8:	09b78463          	beq	a5,s11,540 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 4bc:	07300713          	li	a4,115
 4c0:	0ce78563          	beq	a5,a4,58a <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4c4:	06300713          	li	a4,99
 4c8:	0ee78c63          	beq	a5,a4,5c0 <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 4cc:	11478663          	beq	a5,s4,5d8 <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4d0:	85d2                	mv	a1,s4
 4d2:	8556                	mv	a0,s5
 4d4:	00000097          	auipc	ra,0x0
 4d8:	e8e080e7          	jalr	-370(ra) # 362 <putc>
        putc(fd, c);
 4dc:	85a6                	mv	a1,s1
 4de:	8556                	mv	a0,s5
 4e0:	00000097          	auipc	ra,0x0
 4e4:	e82080e7          	jalr	-382(ra) # 362 <putc>
      }
      state = 0;
 4e8:	4981                	li	s3,0
 4ea:	b765                	j	492 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 4ec:	008b0493          	addi	s1,s6,8
 4f0:	4685                	li	a3,1
 4f2:	4629                	li	a2,10
 4f4:	000b2583          	lw	a1,0(s6)
 4f8:	8556                	mv	a0,s5
 4fa:	00000097          	auipc	ra,0x0
 4fe:	e8a080e7          	jalr	-374(ra) # 384 <printint>
 502:	8b26                	mv	s6,s1
      state = 0;
 504:	4981                	li	s3,0
 506:	b771                	j	492 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 508:	008b0493          	addi	s1,s6,8
 50c:	4681                	li	a3,0
 50e:	4629                	li	a2,10
 510:	000b2583          	lw	a1,0(s6)
 514:	8556                	mv	a0,s5
 516:	00000097          	auipc	ra,0x0
 51a:	e6e080e7          	jalr	-402(ra) # 384 <printint>
 51e:	8b26                	mv	s6,s1
      state = 0;
 520:	4981                	li	s3,0
 522:	bf85                	j	492 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 524:	008b0493          	addi	s1,s6,8
 528:	4681                	li	a3,0
 52a:	4641                	li	a2,16
 52c:	000b2583          	lw	a1,0(s6)
 530:	8556                	mv	a0,s5
 532:	00000097          	auipc	ra,0x0
 536:	e52080e7          	jalr	-430(ra) # 384 <printint>
 53a:	8b26                	mv	s6,s1
      state = 0;
 53c:	4981                	li	s3,0
 53e:	bf91                	j	492 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 540:	008b0793          	addi	a5,s6,8
 544:	f8f43423          	sd	a5,-120(s0)
 548:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 54c:	03000593          	li	a1,48
 550:	8556                	mv	a0,s5
 552:	00000097          	auipc	ra,0x0
 556:	e10080e7          	jalr	-496(ra) # 362 <putc>
  putc(fd, 'x');
 55a:	85ea                	mv	a1,s10
 55c:	8556                	mv	a0,s5
 55e:	00000097          	auipc	ra,0x0
 562:	e04080e7          	jalr	-508(ra) # 362 <putc>
 566:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 568:	03c9d793          	srli	a5,s3,0x3c
 56c:	97de                	add	a5,a5,s7
 56e:	0007c583          	lbu	a1,0(a5)
 572:	8556                	mv	a0,s5
 574:	00000097          	auipc	ra,0x0
 578:	dee080e7          	jalr	-530(ra) # 362 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 57c:	0992                	slli	s3,s3,0x4
 57e:	34fd                	addiw	s1,s1,-1
 580:	f4e5                	bnez	s1,568 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 582:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 586:	4981                	li	s3,0
 588:	b729                	j	492 <vprintf+0x60>
        s = va_arg(ap, char*);
 58a:	008b0993          	addi	s3,s6,8
 58e:	000b3483          	ld	s1,0(s6)
        if(s == 0)
 592:	c085                	beqz	s1,5b2 <vprintf+0x180>
        while(*s != 0){
 594:	0004c583          	lbu	a1,0(s1)
 598:	c9a1                	beqz	a1,5e8 <vprintf+0x1b6>
          putc(fd, *s);
 59a:	8556                	mv	a0,s5
 59c:	00000097          	auipc	ra,0x0
 5a0:	dc6080e7          	jalr	-570(ra) # 362 <putc>
          s++;
 5a4:	0485                	addi	s1,s1,1
        while(*s != 0){
 5a6:	0004c583          	lbu	a1,0(s1)
 5aa:	f9e5                	bnez	a1,59a <vprintf+0x168>
        s = va_arg(ap, char*);
 5ac:	8b4e                	mv	s6,s3
      state = 0;
 5ae:	4981                	li	s3,0
 5b0:	b5cd                	j	492 <vprintf+0x60>
          s = "(null)";
 5b2:	00000497          	auipc	s1,0x0
 5b6:	24648493          	addi	s1,s1,582 # 7f8 <digits+0x18>
        while(*s != 0){
 5ba:	02800593          	li	a1,40
 5be:	bff1                	j	59a <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
 5c0:	008b0493          	addi	s1,s6,8
 5c4:	000b4583          	lbu	a1,0(s6)
 5c8:	8556                	mv	a0,s5
 5ca:	00000097          	auipc	ra,0x0
 5ce:	d98080e7          	jalr	-616(ra) # 362 <putc>
 5d2:	8b26                	mv	s6,s1
      state = 0;
 5d4:	4981                	li	s3,0
 5d6:	bd75                	j	492 <vprintf+0x60>
        putc(fd, c);
 5d8:	85d2                	mv	a1,s4
 5da:	8556                	mv	a0,s5
 5dc:	00000097          	auipc	ra,0x0
 5e0:	d86080e7          	jalr	-634(ra) # 362 <putc>
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	b575                	j	492 <vprintf+0x60>
        s = va_arg(ap, char*);
 5e8:	8b4e                	mv	s6,s3
      state = 0;
 5ea:	4981                	li	s3,0
 5ec:	b55d                	j	492 <vprintf+0x60>
    }
  }
}
 5ee:	70e6                	ld	ra,120(sp)
 5f0:	7446                	ld	s0,112(sp)
 5f2:	74a6                	ld	s1,104(sp)
 5f4:	7906                	ld	s2,96(sp)
 5f6:	69e6                	ld	s3,88(sp)
 5f8:	6a46                	ld	s4,80(sp)
 5fa:	6aa6                	ld	s5,72(sp)
 5fc:	6b06                	ld	s6,64(sp)
 5fe:	7be2                	ld	s7,56(sp)
 600:	7c42                	ld	s8,48(sp)
 602:	7ca2                	ld	s9,40(sp)
 604:	7d02                	ld	s10,32(sp)
 606:	6de2                	ld	s11,24(sp)
 608:	6109                	addi	sp,sp,128
 60a:	8082                	ret

000000000000060c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 60c:	715d                	addi	sp,sp,-80
 60e:	ec06                	sd	ra,24(sp)
 610:	e822                	sd	s0,16(sp)
 612:	1000                	addi	s0,sp,32
 614:	e010                	sd	a2,0(s0)
 616:	e414                	sd	a3,8(s0)
 618:	e818                	sd	a4,16(s0)
 61a:	ec1c                	sd	a5,24(s0)
 61c:	03043023          	sd	a6,32(s0)
 620:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 624:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 628:	8622                	mv	a2,s0
 62a:	00000097          	auipc	ra,0x0
 62e:	e08080e7          	jalr	-504(ra) # 432 <vprintf>
}
 632:	60e2                	ld	ra,24(sp)
 634:	6442                	ld	s0,16(sp)
 636:	6161                	addi	sp,sp,80
 638:	8082                	ret

000000000000063a <printf>:

void
printf(const char *fmt, ...)
{
 63a:	711d                	addi	sp,sp,-96
 63c:	ec06                	sd	ra,24(sp)
 63e:	e822                	sd	s0,16(sp)
 640:	1000                	addi	s0,sp,32
 642:	e40c                	sd	a1,8(s0)
 644:	e810                	sd	a2,16(s0)
 646:	ec14                	sd	a3,24(s0)
 648:	f018                	sd	a4,32(s0)
 64a:	f41c                	sd	a5,40(s0)
 64c:	03043823          	sd	a6,48(s0)
 650:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 654:	00840613          	addi	a2,s0,8
 658:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 65c:	85aa                	mv	a1,a0
 65e:	4505                	li	a0,1
 660:	00000097          	auipc	ra,0x0
 664:	dd2080e7          	jalr	-558(ra) # 432 <vprintf>
}
 668:	60e2                	ld	ra,24(sp)
 66a:	6442                	ld	s0,16(sp)
 66c:	6125                	addi	sp,sp,96
 66e:	8082                	ret

0000000000000670 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 670:	1141                	addi	sp,sp,-16
 672:	e422                	sd	s0,8(sp)
 674:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 676:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 67a:	00000797          	auipc	a5,0x0
 67e:	18678793          	addi	a5,a5,390 # 800 <__bss_start>
 682:	639c                	ld	a5,0(a5)
 684:	a805                	j	6b4 <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 686:	4618                	lw	a4,8(a2)
 688:	9db9                	addw	a1,a1,a4
 68a:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 68e:	6398                	ld	a4,0(a5)
 690:	6318                	ld	a4,0(a4)
 692:	fee53823          	sd	a4,-16(a0)
 696:	a091                	j	6da <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 698:	ff852703          	lw	a4,-8(a0)
 69c:	9e39                	addw	a2,a2,a4
 69e:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 6a0:	ff053703          	ld	a4,-16(a0)
 6a4:	e398                	sd	a4,0(a5)
 6a6:	a099                	j	6ec <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a8:	6398                	ld	a4,0(a5)
 6aa:	00e7e463          	bltu	a5,a4,6b2 <free+0x42>
 6ae:	00e6ea63          	bltu	a3,a4,6c2 <free+0x52>
{
 6b2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b4:	fed7fae3          	bleu	a3,a5,6a8 <free+0x38>
 6b8:	6398                	ld	a4,0(a5)
 6ba:	00e6e463          	bltu	a3,a4,6c2 <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6be:	fee7eae3          	bltu	a5,a4,6b2 <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
 6c2:	ff852583          	lw	a1,-8(a0)
 6c6:	6390                	ld	a2,0(a5)
 6c8:	02059713          	slli	a4,a1,0x20
 6cc:	9301                	srli	a4,a4,0x20
 6ce:	0712                	slli	a4,a4,0x4
 6d0:	9736                	add	a4,a4,a3
 6d2:	fae60ae3          	beq	a2,a4,686 <free+0x16>
    bp->s.ptr = p->s.ptr;
 6d6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6da:	4790                	lw	a2,8(a5)
 6dc:	02061713          	slli	a4,a2,0x20
 6e0:	9301                	srli	a4,a4,0x20
 6e2:	0712                	slli	a4,a4,0x4
 6e4:	973e                	add	a4,a4,a5
 6e6:	fae689e3          	beq	a3,a4,698 <free+0x28>
  } else
    p->s.ptr = bp;
 6ea:	e394                	sd	a3,0(a5)
  freep = p;
 6ec:	00000717          	auipc	a4,0x0
 6f0:	10f73a23          	sd	a5,276(a4) # 800 <__bss_start>
}
 6f4:	6422                	ld	s0,8(sp)
 6f6:	0141                	addi	sp,sp,16
 6f8:	8082                	ret

00000000000006fa <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6fa:	7139                	addi	sp,sp,-64
 6fc:	fc06                	sd	ra,56(sp)
 6fe:	f822                	sd	s0,48(sp)
 700:	f426                	sd	s1,40(sp)
 702:	f04a                	sd	s2,32(sp)
 704:	ec4e                	sd	s3,24(sp)
 706:	e852                	sd	s4,16(sp)
 708:	e456                	sd	s5,8(sp)
 70a:	e05a                	sd	s6,0(sp)
 70c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 70e:	02051993          	slli	s3,a0,0x20
 712:	0209d993          	srli	s3,s3,0x20
 716:	09bd                	addi	s3,s3,15
 718:	0049d993          	srli	s3,s3,0x4
 71c:	2985                	addiw	s3,s3,1
 71e:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
 722:	00000797          	auipc	a5,0x0
 726:	0de78793          	addi	a5,a5,222 # 800 <__bss_start>
 72a:	6388                	ld	a0,0(a5)
 72c:	c515                	beqz	a0,758 <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 72e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 730:	4798                	lw	a4,8(a5)
 732:	03277f63          	bleu	s2,a4,770 <malloc+0x76>
 736:	8a4e                	mv	s4,s3
 738:	0009871b          	sext.w	a4,s3
 73c:	6685                	lui	a3,0x1
 73e:	00d77363          	bleu	a3,a4,744 <malloc+0x4a>
 742:	6a05                	lui	s4,0x1
 744:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
 748:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 74c:	00000497          	auipc	s1,0x0
 750:	0b448493          	addi	s1,s1,180 # 800 <__bss_start>
  if(p == (char*)-1)
 754:	5b7d                	li	s6,-1
 756:	a885                	j	7c6 <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
 758:	00000797          	auipc	a5,0x0
 75c:	0b078793          	addi	a5,a5,176 # 808 <base>
 760:	00000717          	auipc	a4,0x0
 764:	0af73023          	sd	a5,160(a4) # 800 <__bss_start>
 768:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 76a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 76e:	b7e1                	j	736 <malloc+0x3c>
      if(p->s.size == nunits)
 770:	02e90b63          	beq	s2,a4,7a6 <malloc+0xac>
        p->s.size -= nunits;
 774:	4137073b          	subw	a4,a4,s3
 778:	c798                	sw	a4,8(a5)
        p += p->s.size;
 77a:	1702                	slli	a4,a4,0x20
 77c:	9301                	srli	a4,a4,0x20
 77e:	0712                	slli	a4,a4,0x4
 780:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 782:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 786:	00000717          	auipc	a4,0x0
 78a:	06a73d23          	sd	a0,122(a4) # 800 <__bss_start>
      return (void*)(p + 1);
 78e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 792:	70e2                	ld	ra,56(sp)
 794:	7442                	ld	s0,48(sp)
 796:	74a2                	ld	s1,40(sp)
 798:	7902                	ld	s2,32(sp)
 79a:	69e2                	ld	s3,24(sp)
 79c:	6a42                	ld	s4,16(sp)
 79e:	6aa2                	ld	s5,8(sp)
 7a0:	6b02                	ld	s6,0(sp)
 7a2:	6121                	addi	sp,sp,64
 7a4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7a6:	6398                	ld	a4,0(a5)
 7a8:	e118                	sd	a4,0(a0)
 7aa:	bff1                	j	786 <malloc+0x8c>
  hp->s.size = nu;
 7ac:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
 7b0:	0541                	addi	a0,a0,16
 7b2:	00000097          	auipc	ra,0x0
 7b6:	ebe080e7          	jalr	-322(ra) # 670 <free>
  return freep;
 7ba:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 7bc:	d979                	beqz	a0,792 <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7be:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7c0:	4798                	lw	a4,8(a5)
 7c2:	fb2777e3          	bleu	s2,a4,770 <malloc+0x76>
    if(p == freep)
 7c6:	6098                	ld	a4,0(s1)
 7c8:	853e                	mv	a0,a5
 7ca:	fef71ae3          	bne	a4,a5,7be <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
 7ce:	8552                	mv	a0,s4
 7d0:	00000097          	auipc	ra,0x0
 7d4:	b72080e7          	jalr	-1166(ra) # 342 <sbrk>
  if(p == (char*)-1)
 7d8:	fd651ae3          	bne	a0,s6,7ac <malloc+0xb2>
        return 0;
 7dc:	4501                	li	a0,0
 7de:	bf55                	j	792 <malloc+0x98>
