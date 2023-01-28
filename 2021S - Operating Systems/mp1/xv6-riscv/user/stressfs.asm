
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dd010113          	addi	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	21213823          	sd	s2,528(sp)
  14:	1c00                	addi	s0,sp,560
  int fd, i;
  char path[] = "stressfs0";
  16:	00001797          	auipc	a5,0x1
  1a:	92a78793          	addi	a5,a5,-1750 # 940 <longjmp_1+0x3a>
  1e:	6398                	ld	a4,0(a5)
  20:	fce43823          	sd	a4,-48(s0)
  24:	0087d783          	lhu	a5,8(a5)
  28:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
  2c:	00001517          	auipc	a0,0x1
  30:	8e450513          	addi	a0,a0,-1820 # 910 <longjmp_1+0xa>
  34:	00000097          	auipc	ra,0x0
  38:	6be080e7          	jalr	1726(ra) # 6f2 <printf>
  memset(data, 'a', sizeof(data));
  3c:	20000613          	li	a2,512
  40:	06100593          	li	a1,97
  44:	dd040513          	addi	a0,s0,-560
  48:	00000097          	auipc	ra,0x0
  4c:	136080e7          	jalr	310(ra) # 17e <memset>

  for(i = 0; i < 4; i++)
  50:	4481                	li	s1,0
  52:	4911                	li	s2,4
    if(fork() > 0)
  54:	00000097          	auipc	ra,0x0
  58:	31e080e7          	jalr	798(ra) # 372 <fork>
  5c:	00a04563          	bgtz	a0,66 <main+0x66>
  for(i = 0; i < 4; i++)
  60:	2485                	addiw	s1,s1,1
  62:	ff2499e3          	bne	s1,s2,54 <main+0x54>
      break;

  printf("write %d\n", i);
  66:	85a6                	mv	a1,s1
  68:	00001517          	auipc	a0,0x1
  6c:	8c050513          	addi	a0,a0,-1856 # 928 <longjmp_1+0x22>
  70:	00000097          	auipc	ra,0x0
  74:	682080e7          	jalr	1666(ra) # 6f2 <printf>

  path[8] += i;
  78:	fd844783          	lbu	a5,-40(s0)
  7c:	9cbd                	addw	s1,s1,a5
  7e:	fc940c23          	sb	s1,-40(s0)
  fd = open(path, O_CREATE | O_RDWR);
  82:	20200593          	li	a1,514
  86:	fd040513          	addi	a0,s0,-48
  8a:	00000097          	auipc	ra,0x0
  8e:	330080e7          	jalr	816(ra) # 3ba <open>
  92:	892a                	mv	s2,a0
  94:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  96:	20000613          	li	a2,512
  9a:	dd040593          	addi	a1,s0,-560
  9e:	854a                	mv	a0,s2
  a0:	00000097          	auipc	ra,0x0
  a4:	2fa080e7          	jalr	762(ra) # 39a <write>
  for(i = 0; i < 20; i++)
  a8:	34fd                	addiw	s1,s1,-1
  aa:	f4f5                	bnez	s1,96 <main+0x96>
  close(fd);
  ac:	854a                	mv	a0,s2
  ae:	00000097          	auipc	ra,0x0
  b2:	2f4080e7          	jalr	756(ra) # 3a2 <close>

  printf("read\n");
  b6:	00001517          	auipc	a0,0x1
  ba:	88250513          	addi	a0,a0,-1918 # 938 <longjmp_1+0x32>
  be:	00000097          	auipc	ra,0x0
  c2:	634080e7          	jalr	1588(ra) # 6f2 <printf>

  fd = open(path, O_RDONLY);
  c6:	4581                	li	a1,0
  c8:	fd040513          	addi	a0,s0,-48
  cc:	00000097          	auipc	ra,0x0
  d0:	2ee080e7          	jalr	750(ra) # 3ba <open>
  d4:	892a                	mv	s2,a0
  d6:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  d8:	20000613          	li	a2,512
  dc:	dd040593          	addi	a1,s0,-560
  e0:	854a                	mv	a0,s2
  e2:	00000097          	auipc	ra,0x0
  e6:	2b0080e7          	jalr	688(ra) # 392 <read>
  for (i = 0; i < 20; i++)
  ea:	34fd                	addiw	s1,s1,-1
  ec:	f4f5                	bnez	s1,d8 <main+0xd8>
  close(fd);
  ee:	854a                	mv	a0,s2
  f0:	00000097          	auipc	ra,0x0
  f4:	2b2080e7          	jalr	690(ra) # 3a2 <close>

  wait(0);
  f8:	4501                	li	a0,0
  fa:	00000097          	auipc	ra,0x0
  fe:	288080e7          	jalr	648(ra) # 382 <wait>

  exit(0);
 102:	4501                	li	a0,0
 104:	00000097          	auipc	ra,0x0
 108:	276080e7          	jalr	630(ra) # 37a <exit>

000000000000010c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e422                	sd	s0,8(sp)
 110:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 112:	87aa                	mv	a5,a0
 114:	0585                	addi	a1,a1,1
 116:	0785                	addi	a5,a5,1
 118:	fff5c703          	lbu	a4,-1(a1)
 11c:	fee78fa3          	sb	a4,-1(a5)
 120:	fb75                	bnez	a4,114 <strcpy+0x8>
    ;
  return os;
}
 122:	6422                	ld	s0,8(sp)
 124:	0141                	addi	sp,sp,16
 126:	8082                	ret

0000000000000128 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 128:	1141                	addi	sp,sp,-16
 12a:	e422                	sd	s0,8(sp)
 12c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 12e:	00054783          	lbu	a5,0(a0)
 132:	cb91                	beqz	a5,146 <strcmp+0x1e>
 134:	0005c703          	lbu	a4,0(a1)
 138:	00f71763          	bne	a4,a5,146 <strcmp+0x1e>
    p++, q++;
 13c:	0505                	addi	a0,a0,1
 13e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 140:	00054783          	lbu	a5,0(a0)
 144:	fbe5                	bnez	a5,134 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 146:	0005c503          	lbu	a0,0(a1)
}
 14a:	40a7853b          	subw	a0,a5,a0
 14e:	6422                	ld	s0,8(sp)
 150:	0141                	addi	sp,sp,16
 152:	8082                	ret

0000000000000154 <strlen>:

uint
strlen(const char *s)
{
 154:	1141                	addi	sp,sp,-16
 156:	e422                	sd	s0,8(sp)
 158:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 15a:	00054783          	lbu	a5,0(a0)
 15e:	cf91                	beqz	a5,17a <strlen+0x26>
 160:	0505                	addi	a0,a0,1
 162:	87aa                	mv	a5,a0
 164:	4685                	li	a3,1
 166:	9e89                	subw	a3,a3,a0
 168:	00f6853b          	addw	a0,a3,a5
 16c:	0785                	addi	a5,a5,1
 16e:	fff7c703          	lbu	a4,-1(a5)
 172:	fb7d                	bnez	a4,168 <strlen+0x14>
    ;
  return n;
}
 174:	6422                	ld	s0,8(sp)
 176:	0141                	addi	sp,sp,16
 178:	8082                	ret
  for(n = 0; s[n]; n++)
 17a:	4501                	li	a0,0
 17c:	bfe5                	j	174 <strlen+0x20>

000000000000017e <memset>:

void*
memset(void *dst, int c, uint n)
{
 17e:	1141                	addi	sp,sp,-16
 180:	e422                	sd	s0,8(sp)
 182:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 184:	ca19                	beqz	a2,19a <memset+0x1c>
 186:	87aa                	mv	a5,a0
 188:	1602                	slli	a2,a2,0x20
 18a:	9201                	srli	a2,a2,0x20
 18c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 190:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 194:	0785                	addi	a5,a5,1
 196:	fee79de3          	bne	a5,a4,190 <memset+0x12>
  }
  return dst;
}
 19a:	6422                	ld	s0,8(sp)
 19c:	0141                	addi	sp,sp,16
 19e:	8082                	ret

00000000000001a0 <strchr>:

char*
strchr(const char *s, char c)
{
 1a0:	1141                	addi	sp,sp,-16
 1a2:	e422                	sd	s0,8(sp)
 1a4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1a6:	00054783          	lbu	a5,0(a0)
 1aa:	cb99                	beqz	a5,1c0 <strchr+0x20>
    if(*s == c)
 1ac:	00f58763          	beq	a1,a5,1ba <strchr+0x1a>
  for(; *s; s++)
 1b0:	0505                	addi	a0,a0,1
 1b2:	00054783          	lbu	a5,0(a0)
 1b6:	fbfd                	bnez	a5,1ac <strchr+0xc>
      return (char*)s;
  return 0;
 1b8:	4501                	li	a0,0
}
 1ba:	6422                	ld	s0,8(sp)
 1bc:	0141                	addi	sp,sp,16
 1be:	8082                	ret
  return 0;
 1c0:	4501                	li	a0,0
 1c2:	bfe5                	j	1ba <strchr+0x1a>

00000000000001c4 <gets>:

char*
gets(char *buf, int max)
{
 1c4:	711d                	addi	sp,sp,-96
 1c6:	ec86                	sd	ra,88(sp)
 1c8:	e8a2                	sd	s0,80(sp)
 1ca:	e4a6                	sd	s1,72(sp)
 1cc:	e0ca                	sd	s2,64(sp)
 1ce:	fc4e                	sd	s3,56(sp)
 1d0:	f852                	sd	s4,48(sp)
 1d2:	f456                	sd	s5,40(sp)
 1d4:	f05a                	sd	s6,32(sp)
 1d6:	ec5e                	sd	s7,24(sp)
 1d8:	1080                	addi	s0,sp,96
 1da:	8baa                	mv	s7,a0
 1dc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1de:	892a                	mv	s2,a0
 1e0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1e2:	4aa9                	li	s5,10
 1e4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1e6:	89a6                	mv	s3,s1
 1e8:	2485                	addiw	s1,s1,1
 1ea:	0344d863          	bge	s1,s4,21a <gets+0x56>
    cc = read(0, &c, 1);
 1ee:	4605                	li	a2,1
 1f0:	faf40593          	addi	a1,s0,-81
 1f4:	4501                	li	a0,0
 1f6:	00000097          	auipc	ra,0x0
 1fa:	19c080e7          	jalr	412(ra) # 392 <read>
    if(cc < 1)
 1fe:	00a05e63          	blez	a0,21a <gets+0x56>
    buf[i++] = c;
 202:	faf44783          	lbu	a5,-81(s0)
 206:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 20a:	01578763          	beq	a5,s5,218 <gets+0x54>
 20e:	0905                	addi	s2,s2,1
 210:	fd679be3          	bne	a5,s6,1e6 <gets+0x22>
  for(i=0; i+1 < max; ){
 214:	89a6                	mv	s3,s1
 216:	a011                	j	21a <gets+0x56>
 218:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 21a:	99de                	add	s3,s3,s7
 21c:	00098023          	sb	zero,0(s3)
  return buf;
}
 220:	855e                	mv	a0,s7
 222:	60e6                	ld	ra,88(sp)
 224:	6446                	ld	s0,80(sp)
 226:	64a6                	ld	s1,72(sp)
 228:	6906                	ld	s2,64(sp)
 22a:	79e2                	ld	s3,56(sp)
 22c:	7a42                	ld	s4,48(sp)
 22e:	7aa2                	ld	s5,40(sp)
 230:	7b02                	ld	s6,32(sp)
 232:	6be2                	ld	s7,24(sp)
 234:	6125                	addi	sp,sp,96
 236:	8082                	ret

0000000000000238 <stat>:

int
stat(const char *n, struct stat *st)
{
 238:	1101                	addi	sp,sp,-32
 23a:	ec06                	sd	ra,24(sp)
 23c:	e822                	sd	s0,16(sp)
 23e:	e426                	sd	s1,8(sp)
 240:	e04a                	sd	s2,0(sp)
 242:	1000                	addi	s0,sp,32
 244:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 246:	4581                	li	a1,0
 248:	00000097          	auipc	ra,0x0
 24c:	172080e7          	jalr	370(ra) # 3ba <open>
  if(fd < 0)
 250:	02054563          	bltz	a0,27a <stat+0x42>
 254:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 256:	85ca                	mv	a1,s2
 258:	00000097          	auipc	ra,0x0
 25c:	17a080e7          	jalr	378(ra) # 3d2 <fstat>
 260:	892a                	mv	s2,a0
  close(fd);
 262:	8526                	mv	a0,s1
 264:	00000097          	auipc	ra,0x0
 268:	13e080e7          	jalr	318(ra) # 3a2 <close>
  return r;
}
 26c:	854a                	mv	a0,s2
 26e:	60e2                	ld	ra,24(sp)
 270:	6442                	ld	s0,16(sp)
 272:	64a2                	ld	s1,8(sp)
 274:	6902                	ld	s2,0(sp)
 276:	6105                	addi	sp,sp,32
 278:	8082                	ret
    return -1;
 27a:	597d                	li	s2,-1
 27c:	bfc5                	j	26c <stat+0x34>

000000000000027e <atoi>:

int
atoi(const char *s)
{
 27e:	1141                	addi	sp,sp,-16
 280:	e422                	sd	s0,8(sp)
 282:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 284:	00054603          	lbu	a2,0(a0)
 288:	fd06079b          	addiw	a5,a2,-48
 28c:	0ff7f793          	andi	a5,a5,255
 290:	4725                	li	a4,9
 292:	02f76963          	bltu	a4,a5,2c4 <atoi+0x46>
 296:	86aa                	mv	a3,a0
  n = 0;
 298:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 29a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 29c:	0685                	addi	a3,a3,1
 29e:	0025179b          	slliw	a5,a0,0x2
 2a2:	9fa9                	addw	a5,a5,a0
 2a4:	0017979b          	slliw	a5,a5,0x1
 2a8:	9fb1                	addw	a5,a5,a2
 2aa:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2ae:	0006c603          	lbu	a2,0(a3)
 2b2:	fd06071b          	addiw	a4,a2,-48
 2b6:	0ff77713          	andi	a4,a4,255
 2ba:	fee5f1e3          	bgeu	a1,a4,29c <atoi+0x1e>
  return n;
}
 2be:	6422                	ld	s0,8(sp)
 2c0:	0141                	addi	sp,sp,16
 2c2:	8082                	ret
  n = 0;
 2c4:	4501                	li	a0,0
 2c6:	bfe5                	j	2be <atoi+0x40>

00000000000002c8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e422                	sd	s0,8(sp)
 2cc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2ce:	02b57463          	bgeu	a0,a1,2f6 <memmove+0x2e>
    while(n-- > 0)
 2d2:	00c05f63          	blez	a2,2f0 <memmove+0x28>
 2d6:	1602                	slli	a2,a2,0x20
 2d8:	9201                	srli	a2,a2,0x20
 2da:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2de:	872a                	mv	a4,a0
      *dst++ = *src++;
 2e0:	0585                	addi	a1,a1,1
 2e2:	0705                	addi	a4,a4,1
 2e4:	fff5c683          	lbu	a3,-1(a1)
 2e8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2ec:	fee79ae3          	bne	a5,a4,2e0 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2f0:	6422                	ld	s0,8(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret
    dst += n;
 2f6:	00c50733          	add	a4,a0,a2
    src += n;
 2fa:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2fc:	fec05ae3          	blez	a2,2f0 <memmove+0x28>
 300:	fff6079b          	addiw	a5,a2,-1
 304:	1782                	slli	a5,a5,0x20
 306:	9381                	srli	a5,a5,0x20
 308:	fff7c793          	not	a5,a5
 30c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 30e:	15fd                	addi	a1,a1,-1
 310:	177d                	addi	a4,a4,-1
 312:	0005c683          	lbu	a3,0(a1)
 316:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 31a:	fee79ae3          	bne	a5,a4,30e <memmove+0x46>
 31e:	bfc9                	j	2f0 <memmove+0x28>

0000000000000320 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 320:	1141                	addi	sp,sp,-16
 322:	e422                	sd	s0,8(sp)
 324:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 326:	ca05                	beqz	a2,356 <memcmp+0x36>
 328:	fff6069b          	addiw	a3,a2,-1
 32c:	1682                	slli	a3,a3,0x20
 32e:	9281                	srli	a3,a3,0x20
 330:	0685                	addi	a3,a3,1
 332:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 334:	00054783          	lbu	a5,0(a0)
 338:	0005c703          	lbu	a4,0(a1)
 33c:	00e79863          	bne	a5,a4,34c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 340:	0505                	addi	a0,a0,1
    p2++;
 342:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 344:	fed518e3          	bne	a0,a3,334 <memcmp+0x14>
  }
  return 0;
 348:	4501                	li	a0,0
 34a:	a019                	j	350 <memcmp+0x30>
      return *p1 - *p2;
 34c:	40e7853b          	subw	a0,a5,a4
}
 350:	6422                	ld	s0,8(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret
  return 0;
 356:	4501                	li	a0,0
 358:	bfe5                	j	350 <memcmp+0x30>

000000000000035a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 35a:	1141                	addi	sp,sp,-16
 35c:	e406                	sd	ra,8(sp)
 35e:	e022                	sd	s0,0(sp)
 360:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 362:	00000097          	auipc	ra,0x0
 366:	f66080e7          	jalr	-154(ra) # 2c8 <memmove>
}
 36a:	60a2                	ld	ra,8(sp)
 36c:	6402                	ld	s0,0(sp)
 36e:	0141                	addi	sp,sp,16
 370:	8082                	ret

0000000000000372 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 372:	4885                	li	a7,1
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <exit>:
.global exit
exit:
 li a7, SYS_exit
 37a:	4889                	li	a7,2
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <wait>:
.global wait
wait:
 li a7, SYS_wait
 382:	488d                	li	a7,3
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 38a:	4891                	li	a7,4
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <read>:
.global read
read:
 li a7, SYS_read
 392:	4895                	li	a7,5
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <write>:
.global write
write:
 li a7, SYS_write
 39a:	48c1                	li	a7,16
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <close>:
.global close
close:
 li a7, SYS_close
 3a2:	48d5                	li	a7,21
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <kill>:
.global kill
kill:
 li a7, SYS_kill
 3aa:	4899                	li	a7,6
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3b2:	489d                	li	a7,7
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <open>:
.global open
open:
 li a7, SYS_open
 3ba:	48bd                	li	a7,15
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3c2:	48c5                	li	a7,17
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3ca:	48c9                	li	a7,18
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3d2:	48a1                	li	a7,8
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <link>:
.global link
link:
 li a7, SYS_link
 3da:	48cd                	li	a7,19
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3e2:	48d1                	li	a7,20
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ea:	48a5                	li	a7,9
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3f2:	48a9                	li	a7,10
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3fa:	48ad                	li	a7,11
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 402:	48b1                	li	a7,12
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 40a:	48b5                	li	a7,13
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 412:	48b9                	li	a7,14
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 41a:	1101                	addi	sp,sp,-32
 41c:	ec06                	sd	ra,24(sp)
 41e:	e822                	sd	s0,16(sp)
 420:	1000                	addi	s0,sp,32
 422:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 426:	4605                	li	a2,1
 428:	fef40593          	addi	a1,s0,-17
 42c:	00000097          	auipc	ra,0x0
 430:	f6e080e7          	jalr	-146(ra) # 39a <write>
}
 434:	60e2                	ld	ra,24(sp)
 436:	6442                	ld	s0,16(sp)
 438:	6105                	addi	sp,sp,32
 43a:	8082                	ret

000000000000043c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 43c:	7139                	addi	sp,sp,-64
 43e:	fc06                	sd	ra,56(sp)
 440:	f822                	sd	s0,48(sp)
 442:	f426                	sd	s1,40(sp)
 444:	f04a                	sd	s2,32(sp)
 446:	ec4e                	sd	s3,24(sp)
 448:	0080                	addi	s0,sp,64
 44a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 44c:	c299                	beqz	a3,452 <printint+0x16>
 44e:	0805c863          	bltz	a1,4de <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 452:	2581                	sext.w	a1,a1
  neg = 0;
 454:	4881                	li	a7,0
 456:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 45a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 45c:	2601                	sext.w	a2,a2
 45e:	00000517          	auipc	a0,0x0
 462:	4fa50513          	addi	a0,a0,1274 # 958 <digits>
 466:	883a                	mv	a6,a4
 468:	2705                	addiw	a4,a4,1
 46a:	02c5f7bb          	remuw	a5,a1,a2
 46e:	1782                	slli	a5,a5,0x20
 470:	9381                	srli	a5,a5,0x20
 472:	97aa                	add	a5,a5,a0
 474:	0007c783          	lbu	a5,0(a5)
 478:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 47c:	0005879b          	sext.w	a5,a1
 480:	02c5d5bb          	divuw	a1,a1,a2
 484:	0685                	addi	a3,a3,1
 486:	fec7f0e3          	bgeu	a5,a2,466 <printint+0x2a>
  if(neg)
 48a:	00088b63          	beqz	a7,4a0 <printint+0x64>
    buf[i++] = '-';
 48e:	fd040793          	addi	a5,s0,-48
 492:	973e                	add	a4,a4,a5
 494:	02d00793          	li	a5,45
 498:	fef70823          	sb	a5,-16(a4)
 49c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4a0:	02e05863          	blez	a4,4d0 <printint+0x94>
 4a4:	fc040793          	addi	a5,s0,-64
 4a8:	00e78933          	add	s2,a5,a4
 4ac:	fff78993          	addi	s3,a5,-1
 4b0:	99ba                	add	s3,s3,a4
 4b2:	377d                	addiw	a4,a4,-1
 4b4:	1702                	slli	a4,a4,0x20
 4b6:	9301                	srli	a4,a4,0x20
 4b8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4bc:	fff94583          	lbu	a1,-1(s2)
 4c0:	8526                	mv	a0,s1
 4c2:	00000097          	auipc	ra,0x0
 4c6:	f58080e7          	jalr	-168(ra) # 41a <putc>
  while(--i >= 0)
 4ca:	197d                	addi	s2,s2,-1
 4cc:	ff3918e3          	bne	s2,s3,4bc <printint+0x80>
}
 4d0:	70e2                	ld	ra,56(sp)
 4d2:	7442                	ld	s0,48(sp)
 4d4:	74a2                	ld	s1,40(sp)
 4d6:	7902                	ld	s2,32(sp)
 4d8:	69e2                	ld	s3,24(sp)
 4da:	6121                	addi	sp,sp,64
 4dc:	8082                	ret
    x = -xx;
 4de:	40b005bb          	negw	a1,a1
    neg = 1;
 4e2:	4885                	li	a7,1
    x = -xx;
 4e4:	bf8d                	j	456 <printint+0x1a>

00000000000004e6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4e6:	7119                	addi	sp,sp,-128
 4e8:	fc86                	sd	ra,120(sp)
 4ea:	f8a2                	sd	s0,112(sp)
 4ec:	f4a6                	sd	s1,104(sp)
 4ee:	f0ca                	sd	s2,96(sp)
 4f0:	ecce                	sd	s3,88(sp)
 4f2:	e8d2                	sd	s4,80(sp)
 4f4:	e4d6                	sd	s5,72(sp)
 4f6:	e0da                	sd	s6,64(sp)
 4f8:	fc5e                	sd	s7,56(sp)
 4fa:	f862                	sd	s8,48(sp)
 4fc:	f466                	sd	s9,40(sp)
 4fe:	f06a                	sd	s10,32(sp)
 500:	ec6e                	sd	s11,24(sp)
 502:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 504:	0005c903          	lbu	s2,0(a1)
 508:	18090f63          	beqz	s2,6a6 <vprintf+0x1c0>
 50c:	8aaa                	mv	s5,a0
 50e:	8b32                	mv	s6,a2
 510:	00158493          	addi	s1,a1,1
  state = 0;
 514:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 516:	02500a13          	li	s4,37
      if(c == 'd'){
 51a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 51e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 522:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 526:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 52a:	00000b97          	auipc	s7,0x0
 52e:	42eb8b93          	addi	s7,s7,1070 # 958 <digits>
 532:	a839                	j	550 <vprintf+0x6a>
        putc(fd, c);
 534:	85ca                	mv	a1,s2
 536:	8556                	mv	a0,s5
 538:	00000097          	auipc	ra,0x0
 53c:	ee2080e7          	jalr	-286(ra) # 41a <putc>
 540:	a019                	j	546 <vprintf+0x60>
    } else if(state == '%'){
 542:	01498f63          	beq	s3,s4,560 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 546:	0485                	addi	s1,s1,1
 548:	fff4c903          	lbu	s2,-1(s1)
 54c:	14090d63          	beqz	s2,6a6 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 550:	0009079b          	sext.w	a5,s2
    if(state == 0){
 554:	fe0997e3          	bnez	s3,542 <vprintf+0x5c>
      if(c == '%'){
 558:	fd479ee3          	bne	a5,s4,534 <vprintf+0x4e>
        state = '%';
 55c:	89be                	mv	s3,a5
 55e:	b7e5                	j	546 <vprintf+0x60>
      if(c == 'd'){
 560:	05878063          	beq	a5,s8,5a0 <vprintf+0xba>
      } else if(c == 'l') {
 564:	05978c63          	beq	a5,s9,5bc <vprintf+0xd6>
      } else if(c == 'x') {
 568:	07a78863          	beq	a5,s10,5d8 <vprintf+0xf2>
      } else if(c == 'p') {
 56c:	09b78463          	beq	a5,s11,5f4 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 570:	07300713          	li	a4,115
 574:	0ce78663          	beq	a5,a4,640 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 578:	06300713          	li	a4,99
 57c:	0ee78e63          	beq	a5,a4,678 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 580:	11478863          	beq	a5,s4,690 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 584:	85d2                	mv	a1,s4
 586:	8556                	mv	a0,s5
 588:	00000097          	auipc	ra,0x0
 58c:	e92080e7          	jalr	-366(ra) # 41a <putc>
        putc(fd, c);
 590:	85ca                	mv	a1,s2
 592:	8556                	mv	a0,s5
 594:	00000097          	auipc	ra,0x0
 598:	e86080e7          	jalr	-378(ra) # 41a <putc>
      }
      state = 0;
 59c:	4981                	li	s3,0
 59e:	b765                	j	546 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 5a0:	008b0913          	addi	s2,s6,8
 5a4:	4685                	li	a3,1
 5a6:	4629                	li	a2,10
 5a8:	000b2583          	lw	a1,0(s6)
 5ac:	8556                	mv	a0,s5
 5ae:	00000097          	auipc	ra,0x0
 5b2:	e8e080e7          	jalr	-370(ra) # 43c <printint>
 5b6:	8b4a                	mv	s6,s2
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	b771                	j	546 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5bc:	008b0913          	addi	s2,s6,8
 5c0:	4681                	li	a3,0
 5c2:	4629                	li	a2,10
 5c4:	000b2583          	lw	a1,0(s6)
 5c8:	8556                	mv	a0,s5
 5ca:	00000097          	auipc	ra,0x0
 5ce:	e72080e7          	jalr	-398(ra) # 43c <printint>
 5d2:	8b4a                	mv	s6,s2
      state = 0;
 5d4:	4981                	li	s3,0
 5d6:	bf85                	j	546 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5d8:	008b0913          	addi	s2,s6,8
 5dc:	4681                	li	a3,0
 5de:	4641                	li	a2,16
 5e0:	000b2583          	lw	a1,0(s6)
 5e4:	8556                	mv	a0,s5
 5e6:	00000097          	auipc	ra,0x0
 5ea:	e56080e7          	jalr	-426(ra) # 43c <printint>
 5ee:	8b4a                	mv	s6,s2
      state = 0;
 5f0:	4981                	li	s3,0
 5f2:	bf91                	j	546 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5f4:	008b0793          	addi	a5,s6,8
 5f8:	f8f43423          	sd	a5,-120(s0)
 5fc:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 600:	03000593          	li	a1,48
 604:	8556                	mv	a0,s5
 606:	00000097          	auipc	ra,0x0
 60a:	e14080e7          	jalr	-492(ra) # 41a <putc>
  putc(fd, 'x');
 60e:	85ea                	mv	a1,s10
 610:	8556                	mv	a0,s5
 612:	00000097          	auipc	ra,0x0
 616:	e08080e7          	jalr	-504(ra) # 41a <putc>
 61a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 61c:	03c9d793          	srli	a5,s3,0x3c
 620:	97de                	add	a5,a5,s7
 622:	0007c583          	lbu	a1,0(a5)
 626:	8556                	mv	a0,s5
 628:	00000097          	auipc	ra,0x0
 62c:	df2080e7          	jalr	-526(ra) # 41a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 630:	0992                	slli	s3,s3,0x4
 632:	397d                	addiw	s2,s2,-1
 634:	fe0914e3          	bnez	s2,61c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 638:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 63c:	4981                	li	s3,0
 63e:	b721                	j	546 <vprintf+0x60>
        s = va_arg(ap, char*);
 640:	008b0993          	addi	s3,s6,8
 644:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 648:	02090163          	beqz	s2,66a <vprintf+0x184>
        while(*s != 0){
 64c:	00094583          	lbu	a1,0(s2)
 650:	c9a1                	beqz	a1,6a0 <vprintf+0x1ba>
          putc(fd, *s);
 652:	8556                	mv	a0,s5
 654:	00000097          	auipc	ra,0x0
 658:	dc6080e7          	jalr	-570(ra) # 41a <putc>
          s++;
 65c:	0905                	addi	s2,s2,1
        while(*s != 0){
 65e:	00094583          	lbu	a1,0(s2)
 662:	f9e5                	bnez	a1,652 <vprintf+0x16c>
        s = va_arg(ap, char*);
 664:	8b4e                	mv	s6,s3
      state = 0;
 666:	4981                	li	s3,0
 668:	bdf9                	j	546 <vprintf+0x60>
          s = "(null)";
 66a:	00000917          	auipc	s2,0x0
 66e:	2e690913          	addi	s2,s2,742 # 950 <longjmp_1+0x4a>
        while(*s != 0){
 672:	02800593          	li	a1,40
 676:	bff1                	j	652 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 678:	008b0913          	addi	s2,s6,8
 67c:	000b4583          	lbu	a1,0(s6)
 680:	8556                	mv	a0,s5
 682:	00000097          	auipc	ra,0x0
 686:	d98080e7          	jalr	-616(ra) # 41a <putc>
 68a:	8b4a                	mv	s6,s2
      state = 0;
 68c:	4981                	li	s3,0
 68e:	bd65                	j	546 <vprintf+0x60>
        putc(fd, c);
 690:	85d2                	mv	a1,s4
 692:	8556                	mv	a0,s5
 694:	00000097          	auipc	ra,0x0
 698:	d86080e7          	jalr	-634(ra) # 41a <putc>
      state = 0;
 69c:	4981                	li	s3,0
 69e:	b565                	j	546 <vprintf+0x60>
        s = va_arg(ap, char*);
 6a0:	8b4e                	mv	s6,s3
      state = 0;
 6a2:	4981                	li	s3,0
 6a4:	b54d                	j	546 <vprintf+0x60>
    }
  }
}
 6a6:	70e6                	ld	ra,120(sp)
 6a8:	7446                	ld	s0,112(sp)
 6aa:	74a6                	ld	s1,104(sp)
 6ac:	7906                	ld	s2,96(sp)
 6ae:	69e6                	ld	s3,88(sp)
 6b0:	6a46                	ld	s4,80(sp)
 6b2:	6aa6                	ld	s5,72(sp)
 6b4:	6b06                	ld	s6,64(sp)
 6b6:	7be2                	ld	s7,56(sp)
 6b8:	7c42                	ld	s8,48(sp)
 6ba:	7ca2                	ld	s9,40(sp)
 6bc:	7d02                	ld	s10,32(sp)
 6be:	6de2                	ld	s11,24(sp)
 6c0:	6109                	addi	sp,sp,128
 6c2:	8082                	ret

00000000000006c4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6c4:	715d                	addi	sp,sp,-80
 6c6:	ec06                	sd	ra,24(sp)
 6c8:	e822                	sd	s0,16(sp)
 6ca:	1000                	addi	s0,sp,32
 6cc:	e010                	sd	a2,0(s0)
 6ce:	e414                	sd	a3,8(s0)
 6d0:	e818                	sd	a4,16(s0)
 6d2:	ec1c                	sd	a5,24(s0)
 6d4:	03043023          	sd	a6,32(s0)
 6d8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6dc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6e0:	8622                	mv	a2,s0
 6e2:	00000097          	auipc	ra,0x0
 6e6:	e04080e7          	jalr	-508(ra) # 4e6 <vprintf>
}
 6ea:	60e2                	ld	ra,24(sp)
 6ec:	6442                	ld	s0,16(sp)
 6ee:	6161                	addi	sp,sp,80
 6f0:	8082                	ret

00000000000006f2 <printf>:

void
printf(const char *fmt, ...)
{
 6f2:	711d                	addi	sp,sp,-96
 6f4:	ec06                	sd	ra,24(sp)
 6f6:	e822                	sd	s0,16(sp)
 6f8:	1000                	addi	s0,sp,32
 6fa:	e40c                	sd	a1,8(s0)
 6fc:	e810                	sd	a2,16(s0)
 6fe:	ec14                	sd	a3,24(s0)
 700:	f018                	sd	a4,32(s0)
 702:	f41c                	sd	a5,40(s0)
 704:	03043823          	sd	a6,48(s0)
 708:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 70c:	00840613          	addi	a2,s0,8
 710:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 714:	85aa                	mv	a1,a0
 716:	4505                	li	a0,1
 718:	00000097          	auipc	ra,0x0
 71c:	dce080e7          	jalr	-562(ra) # 4e6 <vprintf>
}
 720:	60e2                	ld	ra,24(sp)
 722:	6442                	ld	s0,16(sp)
 724:	6125                	addi	sp,sp,96
 726:	8082                	ret

0000000000000728 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 728:	1141                	addi	sp,sp,-16
 72a:	e422                	sd	s0,8(sp)
 72c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 72e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 732:	00000797          	auipc	a5,0x0
 736:	23e7b783          	ld	a5,574(a5) # 970 <freep>
 73a:	a805                	j	76a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 73c:	4618                	lw	a4,8(a2)
 73e:	9db9                	addw	a1,a1,a4
 740:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 744:	6398                	ld	a4,0(a5)
 746:	6318                	ld	a4,0(a4)
 748:	fee53823          	sd	a4,-16(a0)
 74c:	a091                	j	790 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 74e:	ff852703          	lw	a4,-8(a0)
 752:	9e39                	addw	a2,a2,a4
 754:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 756:	ff053703          	ld	a4,-16(a0)
 75a:	e398                	sd	a4,0(a5)
 75c:	a099                	j	7a2 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 75e:	6398                	ld	a4,0(a5)
 760:	00e7e463          	bltu	a5,a4,768 <free+0x40>
 764:	00e6ea63          	bltu	a3,a4,778 <free+0x50>
{
 768:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76a:	fed7fae3          	bgeu	a5,a3,75e <free+0x36>
 76e:	6398                	ld	a4,0(a5)
 770:	00e6e463          	bltu	a3,a4,778 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 774:	fee7eae3          	bltu	a5,a4,768 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 778:	ff852583          	lw	a1,-8(a0)
 77c:	6390                	ld	a2,0(a5)
 77e:	02059713          	slli	a4,a1,0x20
 782:	9301                	srli	a4,a4,0x20
 784:	0712                	slli	a4,a4,0x4
 786:	9736                	add	a4,a4,a3
 788:	fae60ae3          	beq	a2,a4,73c <free+0x14>
    bp->s.ptr = p->s.ptr;
 78c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 790:	4790                	lw	a2,8(a5)
 792:	02061713          	slli	a4,a2,0x20
 796:	9301                	srli	a4,a4,0x20
 798:	0712                	slli	a4,a4,0x4
 79a:	973e                	add	a4,a4,a5
 79c:	fae689e3          	beq	a3,a4,74e <free+0x26>
  } else
    p->s.ptr = bp;
 7a0:	e394                	sd	a3,0(a5)
  freep = p;
 7a2:	00000717          	auipc	a4,0x0
 7a6:	1cf73723          	sd	a5,462(a4) # 970 <freep>
}
 7aa:	6422                	ld	s0,8(sp)
 7ac:	0141                	addi	sp,sp,16
 7ae:	8082                	ret

00000000000007b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7b0:	7139                	addi	sp,sp,-64
 7b2:	fc06                	sd	ra,56(sp)
 7b4:	f822                	sd	s0,48(sp)
 7b6:	f426                	sd	s1,40(sp)
 7b8:	f04a                	sd	s2,32(sp)
 7ba:	ec4e                	sd	s3,24(sp)
 7bc:	e852                	sd	s4,16(sp)
 7be:	e456                	sd	s5,8(sp)
 7c0:	e05a                	sd	s6,0(sp)
 7c2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c4:	02051493          	slli	s1,a0,0x20
 7c8:	9081                	srli	s1,s1,0x20
 7ca:	04bd                	addi	s1,s1,15
 7cc:	8091                	srli	s1,s1,0x4
 7ce:	0014899b          	addiw	s3,s1,1
 7d2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7d4:	00000517          	auipc	a0,0x0
 7d8:	19c53503          	ld	a0,412(a0) # 970 <freep>
 7dc:	c515                	beqz	a0,808 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7de:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7e0:	4798                	lw	a4,8(a5)
 7e2:	02977f63          	bgeu	a4,s1,820 <malloc+0x70>
 7e6:	8a4e                	mv	s4,s3
 7e8:	0009871b          	sext.w	a4,s3
 7ec:	6685                	lui	a3,0x1
 7ee:	00d77363          	bgeu	a4,a3,7f4 <malloc+0x44>
 7f2:	6a05                	lui	s4,0x1
 7f4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7f8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7fc:	00000917          	auipc	s2,0x0
 800:	17490913          	addi	s2,s2,372 # 970 <freep>
  if(p == (char*)-1)
 804:	5afd                	li	s5,-1
 806:	a88d                	j	878 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 808:	00000797          	auipc	a5,0x0
 80c:	17078793          	addi	a5,a5,368 # 978 <base>
 810:	00000717          	auipc	a4,0x0
 814:	16f73023          	sd	a5,352(a4) # 970 <freep>
 818:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 81a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 81e:	b7e1                	j	7e6 <malloc+0x36>
      if(p->s.size == nunits)
 820:	02e48b63          	beq	s1,a4,856 <malloc+0xa6>
        p->s.size -= nunits;
 824:	4137073b          	subw	a4,a4,s3
 828:	c798                	sw	a4,8(a5)
        p += p->s.size;
 82a:	1702                	slli	a4,a4,0x20
 82c:	9301                	srli	a4,a4,0x20
 82e:	0712                	slli	a4,a4,0x4
 830:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 832:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 836:	00000717          	auipc	a4,0x0
 83a:	12a73d23          	sd	a0,314(a4) # 970 <freep>
      return (void*)(p + 1);
 83e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 842:	70e2                	ld	ra,56(sp)
 844:	7442                	ld	s0,48(sp)
 846:	74a2                	ld	s1,40(sp)
 848:	7902                	ld	s2,32(sp)
 84a:	69e2                	ld	s3,24(sp)
 84c:	6a42                	ld	s4,16(sp)
 84e:	6aa2                	ld	s5,8(sp)
 850:	6b02                	ld	s6,0(sp)
 852:	6121                	addi	sp,sp,64
 854:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 856:	6398                	ld	a4,0(a5)
 858:	e118                	sd	a4,0(a0)
 85a:	bff1                	j	836 <malloc+0x86>
  hp->s.size = nu;
 85c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 860:	0541                	addi	a0,a0,16
 862:	00000097          	auipc	ra,0x0
 866:	ec6080e7          	jalr	-314(ra) # 728 <free>
  return freep;
 86a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 86e:	d971                	beqz	a0,842 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 870:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 872:	4798                	lw	a4,8(a5)
 874:	fa9776e3          	bgeu	a4,s1,820 <malloc+0x70>
    if(p == freep)
 878:	00093703          	ld	a4,0(s2)
 87c:	853e                	mv	a0,a5
 87e:	fef719e3          	bne	a4,a5,870 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 882:	8552                	mv	a0,s4
 884:	00000097          	auipc	ra,0x0
 888:	b7e080e7          	jalr	-1154(ra) # 402 <sbrk>
  if(p == (char*)-1)
 88c:	fd5518e3          	bne	a0,s5,85c <malloc+0xac>
        return 0;
 890:	4501                	li	a0,0
 892:	bf45                	j	842 <malloc+0x92>

0000000000000894 <setjmp>:
 894:	e100                	sd	s0,0(a0)
 896:	e504                	sd	s1,8(a0)
 898:	01253823          	sd	s2,16(a0)
 89c:	01353c23          	sd	s3,24(a0)
 8a0:	03453023          	sd	s4,32(a0)
 8a4:	03553423          	sd	s5,40(a0)
 8a8:	03653823          	sd	s6,48(a0)
 8ac:	03753c23          	sd	s7,56(a0)
 8b0:	05853023          	sd	s8,64(a0)
 8b4:	05953423          	sd	s9,72(a0)
 8b8:	05a53823          	sd	s10,80(a0)
 8bc:	05b53c23          	sd	s11,88(a0)
 8c0:	06153023          	sd	ra,96(a0)
 8c4:	06253423          	sd	sp,104(a0)
 8c8:	4501                	li	a0,0
 8ca:	8082                	ret

00000000000008cc <longjmp>:
 8cc:	6100                	ld	s0,0(a0)
 8ce:	6504                	ld	s1,8(a0)
 8d0:	01053903          	ld	s2,16(a0)
 8d4:	01853983          	ld	s3,24(a0)
 8d8:	02053a03          	ld	s4,32(a0)
 8dc:	02853a83          	ld	s5,40(a0)
 8e0:	03053b03          	ld	s6,48(a0)
 8e4:	03853b83          	ld	s7,56(a0)
 8e8:	04053c03          	ld	s8,64(a0)
 8ec:	04853c83          	ld	s9,72(a0)
 8f0:	05053d03          	ld	s10,80(a0)
 8f4:	05853d83          	ld	s11,88(a0)
 8f8:	06053083          	ld	ra,96(a0)
 8fc:	06853103          	ld	sp,104(a0)
 900:	c199                	beqz	a1,906 <longjmp_1>
 902:	852e                	mv	a0,a1
 904:	8082                	ret

0000000000000906 <longjmp_1>:
 906:	4505                	li	a0,1
 908:	8082                	ret
