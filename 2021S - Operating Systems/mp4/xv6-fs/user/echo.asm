
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  int i;

  for(i = 1; i < argc; i++){
  10:	4785                	li	a5,1
  12:	06a7d463          	ble	a0,a5,7a <main+0x7a>
  16:	00858493          	addi	s1,a1,8
  1a:	ffe5099b          	addiw	s3,a0,-2
  1e:	1982                	slli	s3,s3,0x20
  20:	0209d993          	srli	s3,s3,0x20
  24:	098e                	slli	s3,s3,0x3
  26:	05c1                	addi	a1,a1,16
  28:	99ae                	add	s3,s3,a1
    write(1, argv[i], strlen(argv[i]));
    if(i + 1 < argc){
      write(1, " ", 1);
  2a:	00001a17          	auipc	s4,0x1
  2e:	816a0a13          	addi	s4,s4,-2026 # 840 <malloc+0xec>
    write(1, argv[i], strlen(argv[i]));
  32:	0004b903          	ld	s2,0(s1)
  36:	854a                	mv	a0,s2
  38:	00000097          	auipc	ra,0x0
  3c:	09c080e7          	jalr	156(ra) # d4 <strlen>
  40:	0005061b          	sext.w	a2,a0
  44:	85ca                	mv	a1,s2
  46:	4505                	li	a0,1
  48:	00000097          	auipc	ra,0x0
  4c:	2ec080e7          	jalr	748(ra) # 334 <write>
    if(i + 1 < argc){
  50:	04a1                	addi	s1,s1,8
  52:	01348a63          	beq	s1,s3,66 <main+0x66>
      write(1, " ", 1);
  56:	4605                	li	a2,1
  58:	85d2                	mv	a1,s4
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	2d8080e7          	jalr	728(ra) # 334 <write>
  64:	b7f9                	j	32 <main+0x32>
    } else {
      write(1, "\n", 1);
  66:	4605                	li	a2,1
  68:	00000597          	auipc	a1,0x0
  6c:	7e058593          	addi	a1,a1,2016 # 848 <malloc+0xf4>
  70:	4505                	li	a0,1
  72:	00000097          	auipc	ra,0x0
  76:	2c2080e7          	jalr	706(ra) # 334 <write>
    }
  }
  exit(0);
  7a:	4501                	li	a0,0
  7c:	00000097          	auipc	ra,0x0
  80:	298080e7          	jalr	664(ra) # 314 <exit>

0000000000000084 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  84:	1141                	addi	sp,sp,-16
  86:	e422                	sd	s0,8(sp)
  88:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  8a:	87aa                	mv	a5,a0
  8c:	0585                	addi	a1,a1,1
  8e:	0785                	addi	a5,a5,1
  90:	fff5c703          	lbu	a4,-1(a1)
  94:	fee78fa3          	sb	a4,-1(a5)
  98:	fb75                	bnez	a4,8c <strcpy+0x8>
    ;
  return os;
}
  9a:	6422                	ld	s0,8(sp)
  9c:	0141                	addi	sp,sp,16
  9e:	8082                	ret

00000000000000a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a0:	1141                	addi	sp,sp,-16
  a2:	e422                	sd	s0,8(sp)
  a4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  a6:	00054783          	lbu	a5,0(a0)
  aa:	cf91                	beqz	a5,c6 <strcmp+0x26>
  ac:	0005c703          	lbu	a4,0(a1)
  b0:	00f71b63          	bne	a4,a5,c6 <strcmp+0x26>
    p++, q++;
  b4:	0505                	addi	a0,a0,1
  b6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  b8:	00054783          	lbu	a5,0(a0)
  bc:	c789                	beqz	a5,c6 <strcmp+0x26>
  be:	0005c703          	lbu	a4,0(a1)
  c2:	fef709e3          	beq	a4,a5,b4 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  c6:	0005c503          	lbu	a0,0(a1)
}
  ca:	40a7853b          	subw	a0,a5,a0
  ce:	6422                	ld	s0,8(sp)
  d0:	0141                	addi	sp,sp,16
  d2:	8082                	ret

00000000000000d4 <strlen>:

uint
strlen(const char *s)
{
  d4:	1141                	addi	sp,sp,-16
  d6:	e422                	sd	s0,8(sp)
  d8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  da:	00054783          	lbu	a5,0(a0)
  de:	cf91                	beqz	a5,fa <strlen+0x26>
  e0:	0505                	addi	a0,a0,1
  e2:	87aa                	mv	a5,a0
  e4:	4685                	li	a3,1
  e6:	9e89                	subw	a3,a3,a0
    ;
  e8:	00f6853b          	addw	a0,a3,a5
  ec:	0785                	addi	a5,a5,1
  for(n = 0; s[n]; n++)
  ee:	fff7c703          	lbu	a4,-1(a5)
  f2:	fb7d                	bnez	a4,e8 <strlen+0x14>
  return n;
}
  f4:	6422                	ld	s0,8(sp)
  f6:	0141                	addi	sp,sp,16
  f8:	8082                	ret
  for(n = 0; s[n]; n++)
  fa:	4501                	li	a0,0
  fc:	bfe5                	j	f4 <strlen+0x20>

00000000000000fe <memset>:

void*
memset(void *dst, int c, uint n)
{
  fe:	1141                	addi	sp,sp,-16
 100:	e422                	sd	s0,8(sp)
 102:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 104:	ce09                	beqz	a2,11e <memset+0x20>
 106:	87aa                	mv	a5,a0
 108:	fff6071b          	addiw	a4,a2,-1
 10c:	1702                	slli	a4,a4,0x20
 10e:	9301                	srli	a4,a4,0x20
 110:	0705                	addi	a4,a4,1
 112:	972a                	add	a4,a4,a0
    cdst[i] = c;
 114:	00b78023          	sb	a1,0(a5)
 118:	0785                	addi	a5,a5,1
  for(i = 0; i < n; i++){
 11a:	fee79de3          	bne	a5,a4,114 <memset+0x16>
  }
  return dst;
}
 11e:	6422                	ld	s0,8(sp)
 120:	0141                	addi	sp,sp,16
 122:	8082                	ret

0000000000000124 <strchr>:

char*
strchr(const char *s, char c)
{
 124:	1141                	addi	sp,sp,-16
 126:	e422                	sd	s0,8(sp)
 128:	0800                	addi	s0,sp,16
  for(; *s; s++)
 12a:	00054783          	lbu	a5,0(a0)
 12e:	cf91                	beqz	a5,14a <strchr+0x26>
    if(*s == c)
 130:	00f58a63          	beq	a1,a5,144 <strchr+0x20>
  for(; *s; s++)
 134:	0505                	addi	a0,a0,1
 136:	00054783          	lbu	a5,0(a0)
 13a:	c781                	beqz	a5,142 <strchr+0x1e>
    if(*s == c)
 13c:	feb79ce3          	bne	a5,a1,134 <strchr+0x10>
 140:	a011                	j	144 <strchr+0x20>
      return (char*)s;
  return 0;
 142:	4501                	li	a0,0
}
 144:	6422                	ld	s0,8(sp)
 146:	0141                	addi	sp,sp,16
 148:	8082                	ret
  return 0;
 14a:	4501                	li	a0,0
 14c:	bfe5                	j	144 <strchr+0x20>

000000000000014e <gets>:

char*
gets(char *buf, int max)
{
 14e:	711d                	addi	sp,sp,-96
 150:	ec86                	sd	ra,88(sp)
 152:	e8a2                	sd	s0,80(sp)
 154:	e4a6                	sd	s1,72(sp)
 156:	e0ca                	sd	s2,64(sp)
 158:	fc4e                	sd	s3,56(sp)
 15a:	f852                	sd	s4,48(sp)
 15c:	f456                	sd	s5,40(sp)
 15e:	f05a                	sd	s6,32(sp)
 160:	ec5e                	sd	s7,24(sp)
 162:	1080                	addi	s0,sp,96
 164:	8baa                	mv	s7,a0
 166:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 168:	892a                	mv	s2,a0
 16a:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 16c:	4aa9                	li	s5,10
 16e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 170:	0019849b          	addiw	s1,s3,1
 174:	0344d863          	ble	s4,s1,1a4 <gets+0x56>
    cc = read(0, &c, 1);
 178:	4605                	li	a2,1
 17a:	faf40593          	addi	a1,s0,-81
 17e:	4501                	li	a0,0
 180:	00000097          	auipc	ra,0x0
 184:	1ac080e7          	jalr	428(ra) # 32c <read>
    if(cc < 1)
 188:	00a05e63          	blez	a0,1a4 <gets+0x56>
    buf[i++] = c;
 18c:	faf44783          	lbu	a5,-81(s0)
 190:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 194:	01578763          	beq	a5,s5,1a2 <gets+0x54>
 198:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
 19a:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
 19c:	fd679ae3          	bne	a5,s6,170 <gets+0x22>
 1a0:	a011                	j	1a4 <gets+0x56>
  for(i=0; i+1 < max; ){
 1a2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1a4:	99de                	add	s3,s3,s7
 1a6:	00098023          	sb	zero,0(s3)
  return buf;
}
 1aa:	855e                	mv	a0,s7
 1ac:	60e6                	ld	ra,88(sp)
 1ae:	6446                	ld	s0,80(sp)
 1b0:	64a6                	ld	s1,72(sp)
 1b2:	6906                	ld	s2,64(sp)
 1b4:	79e2                	ld	s3,56(sp)
 1b6:	7a42                	ld	s4,48(sp)
 1b8:	7aa2                	ld	s5,40(sp)
 1ba:	7b02                	ld	s6,32(sp)
 1bc:	6be2                	ld	s7,24(sp)
 1be:	6125                	addi	sp,sp,96
 1c0:	8082                	ret

00000000000001c2 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c2:	1101                	addi	sp,sp,-32
 1c4:	ec06                	sd	ra,24(sp)
 1c6:	e822                	sd	s0,16(sp)
 1c8:	e426                	sd	s1,8(sp)
 1ca:	e04a                	sd	s2,0(sp)
 1cc:	1000                	addi	s0,sp,32
 1ce:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY|O_NOFOLLOW);
 1d0:	4591                	li	a1,4
 1d2:	00000097          	auipc	ra,0x0
 1d6:	182080e7          	jalr	386(ra) # 354 <open>
  if(fd < 0)
 1da:	02054563          	bltz	a0,204 <stat+0x42>
 1de:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1e0:	85ca                	mv	a1,s2
 1e2:	00000097          	auipc	ra,0x0
 1e6:	18a080e7          	jalr	394(ra) # 36c <fstat>
 1ea:	892a                	mv	s2,a0
  close(fd);
 1ec:	8526                	mv	a0,s1
 1ee:	00000097          	auipc	ra,0x0
 1f2:	14e080e7          	jalr	334(ra) # 33c <close>
  return r;
}
 1f6:	854a                	mv	a0,s2
 1f8:	60e2                	ld	ra,24(sp)
 1fa:	6442                	ld	s0,16(sp)
 1fc:	64a2                	ld	s1,8(sp)
 1fe:	6902                	ld	s2,0(sp)
 200:	6105                	addi	sp,sp,32
 202:	8082                	ret
    return -1;
 204:	597d                	li	s2,-1
 206:	bfc5                	j	1f6 <stat+0x34>

0000000000000208 <atoi>:

int
atoi(const char *s)
{
 208:	1141                	addi	sp,sp,-16
 20a:	e422                	sd	s0,8(sp)
 20c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 20e:	00054683          	lbu	a3,0(a0)
 212:	fd06879b          	addiw	a5,a3,-48
 216:	0ff7f793          	andi	a5,a5,255
 21a:	4725                	li	a4,9
 21c:	02f76963          	bltu	a4,a5,24e <atoi+0x46>
 220:	862a                	mv	a2,a0
  n = 0;
 222:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 224:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 226:	0605                	addi	a2,a2,1
 228:	0025179b          	slliw	a5,a0,0x2
 22c:	9fa9                	addw	a5,a5,a0
 22e:	0017979b          	slliw	a5,a5,0x1
 232:	9fb5                	addw	a5,a5,a3
 234:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 238:	00064683          	lbu	a3,0(a2)
 23c:	fd06871b          	addiw	a4,a3,-48
 240:	0ff77713          	andi	a4,a4,255
 244:	fee5f1e3          	bleu	a4,a1,226 <atoi+0x1e>
  return n;
}
 248:	6422                	ld	s0,8(sp)
 24a:	0141                	addi	sp,sp,16
 24c:	8082                	ret
  n = 0;
 24e:	4501                	li	a0,0
 250:	bfe5                	j	248 <atoi+0x40>

0000000000000252 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 252:	1141                	addi	sp,sp,-16
 254:	e422                	sd	s0,8(sp)
 256:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 258:	02b57663          	bleu	a1,a0,284 <memmove+0x32>
    while(n-- > 0)
 25c:	02c05163          	blez	a2,27e <memmove+0x2c>
 260:	fff6079b          	addiw	a5,a2,-1
 264:	1782                	slli	a5,a5,0x20
 266:	9381                	srli	a5,a5,0x20
 268:	0785                	addi	a5,a5,1
 26a:	97aa                	add	a5,a5,a0
  dst = vdst;
 26c:	872a                	mv	a4,a0
      *dst++ = *src++;
 26e:	0585                	addi	a1,a1,1
 270:	0705                	addi	a4,a4,1
 272:	fff5c683          	lbu	a3,-1(a1)
 276:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 27a:	fee79ae3          	bne	a5,a4,26e <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 27e:	6422                	ld	s0,8(sp)
 280:	0141                	addi	sp,sp,16
 282:	8082                	ret
    dst += n;
 284:	00c50733          	add	a4,a0,a2
    src += n;
 288:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 28a:	fec05ae3          	blez	a2,27e <memmove+0x2c>
 28e:	fff6079b          	addiw	a5,a2,-1
 292:	1782                	slli	a5,a5,0x20
 294:	9381                	srli	a5,a5,0x20
 296:	fff7c793          	not	a5,a5
 29a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 29c:	15fd                	addi	a1,a1,-1
 29e:	177d                	addi	a4,a4,-1
 2a0:	0005c683          	lbu	a3,0(a1)
 2a4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2a8:	fef71ae3          	bne	a4,a5,29c <memmove+0x4a>
 2ac:	bfc9                	j	27e <memmove+0x2c>

00000000000002ae <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ae:	1141                	addi	sp,sp,-16
 2b0:	e422                	sd	s0,8(sp)
 2b2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2b4:	ce15                	beqz	a2,2f0 <memcmp+0x42>
 2b6:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
 2ba:	00054783          	lbu	a5,0(a0)
 2be:	0005c703          	lbu	a4,0(a1)
 2c2:	02e79063          	bne	a5,a4,2e2 <memcmp+0x34>
 2c6:	1682                	slli	a3,a3,0x20
 2c8:	9281                	srli	a3,a3,0x20
 2ca:	0685                	addi	a3,a3,1
 2cc:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
 2ce:	0505                	addi	a0,a0,1
    p2++;
 2d0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2d2:	00d50d63          	beq	a0,a3,2ec <memcmp+0x3e>
    if (*p1 != *p2) {
 2d6:	00054783          	lbu	a5,0(a0)
 2da:	0005c703          	lbu	a4,0(a1)
 2de:	fee788e3          	beq	a5,a4,2ce <memcmp+0x20>
      return *p1 - *p2;
 2e2:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
 2e6:	6422                	ld	s0,8(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret
  return 0;
 2ec:	4501                	li	a0,0
 2ee:	bfe5                	j	2e6 <memcmp+0x38>
 2f0:	4501                	li	a0,0
 2f2:	bfd5                	j	2e6 <memcmp+0x38>

00000000000002f4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2f4:	1141                	addi	sp,sp,-16
 2f6:	e406                	sd	ra,8(sp)
 2f8:	e022                	sd	s0,0(sp)
 2fa:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2fc:	00000097          	auipc	ra,0x0
 300:	f56080e7          	jalr	-170(ra) # 252 <memmove>
}
 304:	60a2                	ld	ra,8(sp)
 306:	6402                	ld	s0,0(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret

000000000000030c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 30c:	4885                	li	a7,1
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <exit>:
.global exit
exit:
 li a7, SYS_exit
 314:	4889                	li	a7,2
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <wait>:
.global wait
wait:
 li a7, SYS_wait
 31c:	488d                	li	a7,3
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 324:	4891                	li	a7,4
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <read>:
.global read
read:
 li a7, SYS_read
 32c:	4895                	li	a7,5
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <write>:
.global write
write:
 li a7, SYS_write
 334:	48c1                	li	a7,16
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <close>:
.global close
close:
 li a7, SYS_close
 33c:	48d5                	li	a7,21
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <kill>:
.global kill
kill:
 li a7, SYS_kill
 344:	4899                	li	a7,6
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <exec>:
.global exec
exec:
 li a7, SYS_exec
 34c:	489d                	li	a7,7
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <open>:
.global open
open:
 li a7, SYS_open
 354:	48bd                	li	a7,15
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 35c:	48c5                	li	a7,17
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 364:	48c9                	li	a7,18
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 36c:	48a1                	li	a7,8
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <link>:
.global link
link:
 li a7, SYS_link
 374:	48cd                	li	a7,19
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 37c:	48d1                	li	a7,20
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 384:	48a5                	li	a7,9
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <dup>:
.global dup
dup:
 li a7, SYS_dup
 38c:	48a9                	li	a7,10
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 394:	48ad                	li	a7,11
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 39c:	48b1                	li	a7,12
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3a4:	48b5                	li	a7,13
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ac:	48b9                	li	a7,14
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 3b4:	48d9                	li	a7,22
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3bc:	1101                	addi	sp,sp,-32
 3be:	ec06                	sd	ra,24(sp)
 3c0:	e822                	sd	s0,16(sp)
 3c2:	1000                	addi	s0,sp,32
 3c4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3c8:	4605                	li	a2,1
 3ca:	fef40593          	addi	a1,s0,-17
 3ce:	00000097          	auipc	ra,0x0
 3d2:	f66080e7          	jalr	-154(ra) # 334 <write>
}
 3d6:	60e2                	ld	ra,24(sp)
 3d8:	6442                	ld	s0,16(sp)
 3da:	6105                	addi	sp,sp,32
 3dc:	8082                	ret

00000000000003de <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3de:	7139                	addi	sp,sp,-64
 3e0:	fc06                	sd	ra,56(sp)
 3e2:	f822                	sd	s0,48(sp)
 3e4:	f426                	sd	s1,40(sp)
 3e6:	f04a                	sd	s2,32(sp)
 3e8:	ec4e                	sd	s3,24(sp)
 3ea:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ec:	c299                	beqz	a3,3f2 <printint+0x14>
 3ee:	0005cd63          	bltz	a1,408 <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3f2:	2581                	sext.w	a1,a1
  neg = 0;
 3f4:	4301                	li	t1,0
 3f6:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
 3fa:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
 3fc:	2601                	sext.w	a2,a2
 3fe:	00000897          	auipc	a7,0x0
 402:	45288893          	addi	a7,a7,1106 # 850 <digits>
 406:	a801                	j	416 <printint+0x38>
    x = -xx;
 408:	40b005bb          	negw	a1,a1
 40c:	2581                	sext.w	a1,a1
    neg = 1;
 40e:	4305                	li	t1,1
    x = -xx;
 410:	b7dd                	j	3f6 <printint+0x18>
  }while((x /= base) != 0);
 412:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
 414:	8836                	mv	a6,a3
 416:	0018069b          	addiw	a3,a6,1
 41a:	02c5f7bb          	remuw	a5,a1,a2
 41e:	1782                	slli	a5,a5,0x20
 420:	9381                	srli	a5,a5,0x20
 422:	97c6                	add	a5,a5,a7
 424:	0007c783          	lbu	a5,0(a5)
 428:	00f70023          	sb	a5,0(a4)
 42c:	0705                	addi	a4,a4,1
  }while((x /= base) != 0);
 42e:	02c5d7bb          	divuw	a5,a1,a2
 432:	fec5f0e3          	bleu	a2,a1,412 <printint+0x34>
  if(neg)
 436:	00030b63          	beqz	t1,44c <printint+0x6e>
    buf[i++] = '-';
 43a:	fd040793          	addi	a5,s0,-48
 43e:	96be                	add	a3,a3,a5
 440:	02d00793          	li	a5,45
 444:	fef68823          	sb	a5,-16(a3)
 448:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
 44c:	02d05963          	blez	a3,47e <printint+0xa0>
 450:	89aa                	mv	s3,a0
 452:	fc040793          	addi	a5,s0,-64
 456:	00d784b3          	add	s1,a5,a3
 45a:	fff78913          	addi	s2,a5,-1
 45e:	9936                	add	s2,s2,a3
 460:	36fd                	addiw	a3,a3,-1
 462:	1682                	slli	a3,a3,0x20
 464:	9281                	srli	a3,a3,0x20
 466:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
 46a:	fff4c583          	lbu	a1,-1(s1)
 46e:	854e                	mv	a0,s3
 470:	00000097          	auipc	ra,0x0
 474:	f4c080e7          	jalr	-180(ra) # 3bc <putc>
 478:	14fd                	addi	s1,s1,-1
  while(--i >= 0)
 47a:	ff2498e3          	bne	s1,s2,46a <printint+0x8c>
}
 47e:	70e2                	ld	ra,56(sp)
 480:	7442                	ld	s0,48(sp)
 482:	74a2                	ld	s1,40(sp)
 484:	7902                	ld	s2,32(sp)
 486:	69e2                	ld	s3,24(sp)
 488:	6121                	addi	sp,sp,64
 48a:	8082                	ret

000000000000048c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 48c:	7119                	addi	sp,sp,-128
 48e:	fc86                	sd	ra,120(sp)
 490:	f8a2                	sd	s0,112(sp)
 492:	f4a6                	sd	s1,104(sp)
 494:	f0ca                	sd	s2,96(sp)
 496:	ecce                	sd	s3,88(sp)
 498:	e8d2                	sd	s4,80(sp)
 49a:	e4d6                	sd	s5,72(sp)
 49c:	e0da                	sd	s6,64(sp)
 49e:	fc5e                	sd	s7,56(sp)
 4a0:	f862                	sd	s8,48(sp)
 4a2:	f466                	sd	s9,40(sp)
 4a4:	f06a                	sd	s10,32(sp)
 4a6:	ec6e                	sd	s11,24(sp)
 4a8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4aa:	0005c483          	lbu	s1,0(a1)
 4ae:	18048d63          	beqz	s1,648 <vprintf+0x1bc>
 4b2:	8aaa                	mv	s5,a0
 4b4:	8b32                	mv	s6,a2
 4b6:	00158913          	addi	s2,a1,1
  state = 0;
 4ba:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4bc:	02500a13          	li	s4,37
      if(c == 'd'){
 4c0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4c4:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4c8:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4cc:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4d0:	00000b97          	auipc	s7,0x0
 4d4:	380b8b93          	addi	s7,s7,896 # 850 <digits>
 4d8:	a839                	j	4f6 <vprintf+0x6a>
        putc(fd, c);
 4da:	85a6                	mv	a1,s1
 4dc:	8556                	mv	a0,s5
 4de:	00000097          	auipc	ra,0x0
 4e2:	ede080e7          	jalr	-290(ra) # 3bc <putc>
 4e6:	a019                	j	4ec <vprintf+0x60>
    } else if(state == '%'){
 4e8:	01498f63          	beq	s3,s4,506 <vprintf+0x7a>
 4ec:	0905                	addi	s2,s2,1
  for(i = 0; fmt[i]; i++){
 4ee:	fff94483          	lbu	s1,-1(s2)
 4f2:	14048b63          	beqz	s1,648 <vprintf+0x1bc>
    c = fmt[i] & 0xff;
 4f6:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4fa:	fe0997e3          	bnez	s3,4e8 <vprintf+0x5c>
      if(c == '%'){
 4fe:	fd479ee3          	bne	a5,s4,4da <vprintf+0x4e>
        state = '%';
 502:	89be                	mv	s3,a5
 504:	b7e5                	j	4ec <vprintf+0x60>
      if(c == 'd'){
 506:	05878063          	beq	a5,s8,546 <vprintf+0xba>
      } else if(c == 'l') {
 50a:	05978c63          	beq	a5,s9,562 <vprintf+0xd6>
      } else if(c == 'x') {
 50e:	07a78863          	beq	a5,s10,57e <vprintf+0xf2>
      } else if(c == 'p') {
 512:	09b78463          	beq	a5,s11,59a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 516:	07300713          	li	a4,115
 51a:	0ce78563          	beq	a5,a4,5e4 <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 51e:	06300713          	li	a4,99
 522:	0ee78c63          	beq	a5,a4,61a <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 526:	11478663          	beq	a5,s4,632 <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 52a:	85d2                	mv	a1,s4
 52c:	8556                	mv	a0,s5
 52e:	00000097          	auipc	ra,0x0
 532:	e8e080e7          	jalr	-370(ra) # 3bc <putc>
        putc(fd, c);
 536:	85a6                	mv	a1,s1
 538:	8556                	mv	a0,s5
 53a:	00000097          	auipc	ra,0x0
 53e:	e82080e7          	jalr	-382(ra) # 3bc <putc>
      }
      state = 0;
 542:	4981                	li	s3,0
 544:	b765                	j	4ec <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 546:	008b0493          	addi	s1,s6,8
 54a:	4685                	li	a3,1
 54c:	4629                	li	a2,10
 54e:	000b2583          	lw	a1,0(s6)
 552:	8556                	mv	a0,s5
 554:	00000097          	auipc	ra,0x0
 558:	e8a080e7          	jalr	-374(ra) # 3de <printint>
 55c:	8b26                	mv	s6,s1
      state = 0;
 55e:	4981                	li	s3,0
 560:	b771                	j	4ec <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 562:	008b0493          	addi	s1,s6,8
 566:	4681                	li	a3,0
 568:	4629                	li	a2,10
 56a:	000b2583          	lw	a1,0(s6)
 56e:	8556                	mv	a0,s5
 570:	00000097          	auipc	ra,0x0
 574:	e6e080e7          	jalr	-402(ra) # 3de <printint>
 578:	8b26                	mv	s6,s1
      state = 0;
 57a:	4981                	li	s3,0
 57c:	bf85                	j	4ec <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 57e:	008b0493          	addi	s1,s6,8
 582:	4681                	li	a3,0
 584:	4641                	li	a2,16
 586:	000b2583          	lw	a1,0(s6)
 58a:	8556                	mv	a0,s5
 58c:	00000097          	auipc	ra,0x0
 590:	e52080e7          	jalr	-430(ra) # 3de <printint>
 594:	8b26                	mv	s6,s1
      state = 0;
 596:	4981                	li	s3,0
 598:	bf91                	j	4ec <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 59a:	008b0793          	addi	a5,s6,8
 59e:	f8f43423          	sd	a5,-120(s0)
 5a2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5a6:	03000593          	li	a1,48
 5aa:	8556                	mv	a0,s5
 5ac:	00000097          	auipc	ra,0x0
 5b0:	e10080e7          	jalr	-496(ra) # 3bc <putc>
  putc(fd, 'x');
 5b4:	85ea                	mv	a1,s10
 5b6:	8556                	mv	a0,s5
 5b8:	00000097          	auipc	ra,0x0
 5bc:	e04080e7          	jalr	-508(ra) # 3bc <putc>
 5c0:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5c2:	03c9d793          	srli	a5,s3,0x3c
 5c6:	97de                	add	a5,a5,s7
 5c8:	0007c583          	lbu	a1,0(a5)
 5cc:	8556                	mv	a0,s5
 5ce:	00000097          	auipc	ra,0x0
 5d2:	dee080e7          	jalr	-530(ra) # 3bc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5d6:	0992                	slli	s3,s3,0x4
 5d8:	34fd                	addiw	s1,s1,-1
 5da:	f4e5                	bnez	s1,5c2 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 5dc:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5e0:	4981                	li	s3,0
 5e2:	b729                	j	4ec <vprintf+0x60>
        s = va_arg(ap, char*);
 5e4:	008b0993          	addi	s3,s6,8
 5e8:	000b3483          	ld	s1,0(s6)
        if(s == 0)
 5ec:	c085                	beqz	s1,60c <vprintf+0x180>
        while(*s != 0){
 5ee:	0004c583          	lbu	a1,0(s1)
 5f2:	c9a1                	beqz	a1,642 <vprintf+0x1b6>
          putc(fd, *s);
 5f4:	8556                	mv	a0,s5
 5f6:	00000097          	auipc	ra,0x0
 5fa:	dc6080e7          	jalr	-570(ra) # 3bc <putc>
          s++;
 5fe:	0485                	addi	s1,s1,1
        while(*s != 0){
 600:	0004c583          	lbu	a1,0(s1)
 604:	f9e5                	bnez	a1,5f4 <vprintf+0x168>
        s = va_arg(ap, char*);
 606:	8b4e                	mv	s6,s3
      state = 0;
 608:	4981                	li	s3,0
 60a:	b5cd                	j	4ec <vprintf+0x60>
          s = "(null)";
 60c:	00000497          	auipc	s1,0x0
 610:	25c48493          	addi	s1,s1,604 # 868 <digits+0x18>
        while(*s != 0){
 614:	02800593          	li	a1,40
 618:	bff1                	j	5f4 <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
 61a:	008b0493          	addi	s1,s6,8
 61e:	000b4583          	lbu	a1,0(s6)
 622:	8556                	mv	a0,s5
 624:	00000097          	auipc	ra,0x0
 628:	d98080e7          	jalr	-616(ra) # 3bc <putc>
 62c:	8b26                	mv	s6,s1
      state = 0;
 62e:	4981                	li	s3,0
 630:	bd75                	j	4ec <vprintf+0x60>
        putc(fd, c);
 632:	85d2                	mv	a1,s4
 634:	8556                	mv	a0,s5
 636:	00000097          	auipc	ra,0x0
 63a:	d86080e7          	jalr	-634(ra) # 3bc <putc>
      state = 0;
 63e:	4981                	li	s3,0
 640:	b575                	j	4ec <vprintf+0x60>
        s = va_arg(ap, char*);
 642:	8b4e                	mv	s6,s3
      state = 0;
 644:	4981                	li	s3,0
 646:	b55d                	j	4ec <vprintf+0x60>
    }
  }
}
 648:	70e6                	ld	ra,120(sp)
 64a:	7446                	ld	s0,112(sp)
 64c:	74a6                	ld	s1,104(sp)
 64e:	7906                	ld	s2,96(sp)
 650:	69e6                	ld	s3,88(sp)
 652:	6a46                	ld	s4,80(sp)
 654:	6aa6                	ld	s5,72(sp)
 656:	6b06                	ld	s6,64(sp)
 658:	7be2                	ld	s7,56(sp)
 65a:	7c42                	ld	s8,48(sp)
 65c:	7ca2                	ld	s9,40(sp)
 65e:	7d02                	ld	s10,32(sp)
 660:	6de2                	ld	s11,24(sp)
 662:	6109                	addi	sp,sp,128
 664:	8082                	ret

0000000000000666 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 666:	715d                	addi	sp,sp,-80
 668:	ec06                	sd	ra,24(sp)
 66a:	e822                	sd	s0,16(sp)
 66c:	1000                	addi	s0,sp,32
 66e:	e010                	sd	a2,0(s0)
 670:	e414                	sd	a3,8(s0)
 672:	e818                	sd	a4,16(s0)
 674:	ec1c                	sd	a5,24(s0)
 676:	03043023          	sd	a6,32(s0)
 67a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 67e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 682:	8622                	mv	a2,s0
 684:	00000097          	auipc	ra,0x0
 688:	e08080e7          	jalr	-504(ra) # 48c <vprintf>
}
 68c:	60e2                	ld	ra,24(sp)
 68e:	6442                	ld	s0,16(sp)
 690:	6161                	addi	sp,sp,80
 692:	8082                	ret

0000000000000694 <printf>:

void
printf(const char *fmt, ...)
{
 694:	711d                	addi	sp,sp,-96
 696:	ec06                	sd	ra,24(sp)
 698:	e822                	sd	s0,16(sp)
 69a:	1000                	addi	s0,sp,32
 69c:	e40c                	sd	a1,8(s0)
 69e:	e810                	sd	a2,16(s0)
 6a0:	ec14                	sd	a3,24(s0)
 6a2:	f018                	sd	a4,32(s0)
 6a4:	f41c                	sd	a5,40(s0)
 6a6:	03043823          	sd	a6,48(s0)
 6aa:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6ae:	00840613          	addi	a2,s0,8
 6b2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6b6:	85aa                	mv	a1,a0
 6b8:	4505                	li	a0,1
 6ba:	00000097          	auipc	ra,0x0
 6be:	dd2080e7          	jalr	-558(ra) # 48c <vprintf>
}
 6c2:	60e2                	ld	ra,24(sp)
 6c4:	6442                	ld	s0,16(sp)
 6c6:	6125                	addi	sp,sp,96
 6c8:	8082                	ret

00000000000006ca <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ca:	1141                	addi	sp,sp,-16
 6cc:	e422                	sd	s0,8(sp)
 6ce:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6d0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d4:	00000797          	auipc	a5,0x0
 6d8:	19c78793          	addi	a5,a5,412 # 870 <__bss_start>
 6dc:	639c                	ld	a5,0(a5)
 6de:	a805                	j	70e <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6e0:	4618                	lw	a4,8(a2)
 6e2:	9db9                	addw	a1,a1,a4
 6e4:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6e8:	6398                	ld	a4,0(a5)
 6ea:	6318                	ld	a4,0(a4)
 6ec:	fee53823          	sd	a4,-16(a0)
 6f0:	a091                	j	734 <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6f2:	ff852703          	lw	a4,-8(a0)
 6f6:	9e39                	addw	a2,a2,a4
 6f8:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 6fa:	ff053703          	ld	a4,-16(a0)
 6fe:	e398                	sd	a4,0(a5)
 700:	a099                	j	746 <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 702:	6398                	ld	a4,0(a5)
 704:	00e7e463          	bltu	a5,a4,70c <free+0x42>
 708:	00e6ea63          	bltu	a3,a4,71c <free+0x52>
{
 70c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 70e:	fed7fae3          	bleu	a3,a5,702 <free+0x38>
 712:	6398                	ld	a4,0(a5)
 714:	00e6e463          	bltu	a3,a4,71c <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 718:	fee7eae3          	bltu	a5,a4,70c <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
 71c:	ff852583          	lw	a1,-8(a0)
 720:	6390                	ld	a2,0(a5)
 722:	02059713          	slli	a4,a1,0x20
 726:	9301                	srli	a4,a4,0x20
 728:	0712                	slli	a4,a4,0x4
 72a:	9736                	add	a4,a4,a3
 72c:	fae60ae3          	beq	a2,a4,6e0 <free+0x16>
    bp->s.ptr = p->s.ptr;
 730:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 734:	4790                	lw	a2,8(a5)
 736:	02061713          	slli	a4,a2,0x20
 73a:	9301                	srli	a4,a4,0x20
 73c:	0712                	slli	a4,a4,0x4
 73e:	973e                	add	a4,a4,a5
 740:	fae689e3          	beq	a3,a4,6f2 <free+0x28>
  } else
    p->s.ptr = bp;
 744:	e394                	sd	a3,0(a5)
  freep = p;
 746:	00000717          	auipc	a4,0x0
 74a:	12f73523          	sd	a5,298(a4) # 870 <__bss_start>
}
 74e:	6422                	ld	s0,8(sp)
 750:	0141                	addi	sp,sp,16
 752:	8082                	ret

0000000000000754 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 754:	7139                	addi	sp,sp,-64
 756:	fc06                	sd	ra,56(sp)
 758:	f822                	sd	s0,48(sp)
 75a:	f426                	sd	s1,40(sp)
 75c:	f04a                	sd	s2,32(sp)
 75e:	ec4e                	sd	s3,24(sp)
 760:	e852                	sd	s4,16(sp)
 762:	e456                	sd	s5,8(sp)
 764:	e05a                	sd	s6,0(sp)
 766:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 768:	02051993          	slli	s3,a0,0x20
 76c:	0209d993          	srli	s3,s3,0x20
 770:	09bd                	addi	s3,s3,15
 772:	0049d993          	srli	s3,s3,0x4
 776:	2985                	addiw	s3,s3,1
 778:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
 77c:	00000797          	auipc	a5,0x0
 780:	0f478793          	addi	a5,a5,244 # 870 <__bss_start>
 784:	6388                	ld	a0,0(a5)
 786:	c515                	beqz	a0,7b2 <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 788:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 78a:	4798                	lw	a4,8(a5)
 78c:	03277f63          	bleu	s2,a4,7ca <malloc+0x76>
 790:	8a4e                	mv	s4,s3
 792:	0009871b          	sext.w	a4,s3
 796:	6685                	lui	a3,0x1
 798:	00d77363          	bleu	a3,a4,79e <malloc+0x4a>
 79c:	6a05                	lui	s4,0x1
 79e:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
 7a2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7a6:	00000497          	auipc	s1,0x0
 7aa:	0ca48493          	addi	s1,s1,202 # 870 <__bss_start>
  if(p == (char*)-1)
 7ae:	5b7d                	li	s6,-1
 7b0:	a885                	j	820 <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
 7b2:	00000797          	auipc	a5,0x0
 7b6:	0c678793          	addi	a5,a5,198 # 878 <base>
 7ba:	00000717          	auipc	a4,0x0
 7be:	0af73b23          	sd	a5,182(a4) # 870 <__bss_start>
 7c2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7c4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7c8:	b7e1                	j	790 <malloc+0x3c>
      if(p->s.size == nunits)
 7ca:	02e90b63          	beq	s2,a4,800 <malloc+0xac>
        p->s.size -= nunits;
 7ce:	4137073b          	subw	a4,a4,s3
 7d2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7d4:	1702                	slli	a4,a4,0x20
 7d6:	9301                	srli	a4,a4,0x20
 7d8:	0712                	slli	a4,a4,0x4
 7da:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7dc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7e0:	00000717          	auipc	a4,0x0
 7e4:	08a73823          	sd	a0,144(a4) # 870 <__bss_start>
      return (void*)(p + 1);
 7e8:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7ec:	70e2                	ld	ra,56(sp)
 7ee:	7442                	ld	s0,48(sp)
 7f0:	74a2                	ld	s1,40(sp)
 7f2:	7902                	ld	s2,32(sp)
 7f4:	69e2                	ld	s3,24(sp)
 7f6:	6a42                	ld	s4,16(sp)
 7f8:	6aa2                	ld	s5,8(sp)
 7fa:	6b02                	ld	s6,0(sp)
 7fc:	6121                	addi	sp,sp,64
 7fe:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 800:	6398                	ld	a4,0(a5)
 802:	e118                	sd	a4,0(a0)
 804:	bff1                	j	7e0 <malloc+0x8c>
  hp->s.size = nu;
 806:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
 80a:	0541                	addi	a0,a0,16
 80c:	00000097          	auipc	ra,0x0
 810:	ebe080e7          	jalr	-322(ra) # 6ca <free>
  return freep;
 814:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 816:	d979                	beqz	a0,7ec <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 818:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 81a:	4798                	lw	a4,8(a5)
 81c:	fb2777e3          	bleu	s2,a4,7ca <malloc+0x76>
    if(p == freep)
 820:	6098                	ld	a4,0(s1)
 822:	853e                	mv	a0,a5
 824:	fef71ae3          	bne	a4,a5,818 <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
 828:	8552                	mv	a0,s4
 82a:	00000097          	auipc	ra,0x0
 82e:	b72080e7          	jalr	-1166(ra) # 39c <sbrk>
  if(p == (char*)-1)
 832:	fd651ae3          	bne	a0,s6,806 <malloc+0xb2>
        return 0;
 836:	4501                	li	a0,0
 838:	bf55                	j	7ec <malloc+0x98>
