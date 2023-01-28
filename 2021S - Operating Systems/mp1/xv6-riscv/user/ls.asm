
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  10:	00000097          	auipc	ra,0x0
  14:	30c080e7          	jalr	780(ra) # 31c <strlen>
  18:	02051793          	slli	a5,a0,0x20
  1c:	9381                	srli	a5,a5,0x20
  1e:	97a6                	add	a5,a5,s1
  20:	02f00693          	li	a3,47
  24:	0097e963          	bltu	a5,s1,36 <fmtname+0x36>
  28:	0007c703          	lbu	a4,0(a5)
  2c:	00d70563          	beq	a4,a3,36 <fmtname+0x36>
  30:	17fd                	addi	a5,a5,-1
  32:	fe97fbe3          	bgeu	a5,s1,28 <fmtname+0x28>
    ;
  p++;
  36:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3a:	8526                	mv	a0,s1
  3c:	00000097          	auipc	ra,0x0
  40:	2e0080e7          	jalr	736(ra) # 31c <strlen>
  44:	2501                	sext.w	a0,a0
  46:	47b5                	li	a5,13
  48:	00a7fa63          	bgeu	a5,a0,5c <fmtname+0x5c>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  4c:	8526                	mv	a0,s1
  4e:	70a2                	ld	ra,40(sp)
  50:	7402                	ld	s0,32(sp)
  52:	64e2                	ld	s1,24(sp)
  54:	6942                	ld	s2,16(sp)
  56:	69a2                	ld	s3,8(sp)
  58:	6145                	addi	sp,sp,48
  5a:	8082                	ret
  memmove(buf, p, strlen(p));
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	2be080e7          	jalr	702(ra) # 31c <strlen>
  66:	00001997          	auipc	s3,0x1
  6a:	b0a98993          	addi	s3,s3,-1270 # b70 <buf.0>
  6e:	0005061b          	sext.w	a2,a0
  72:	85a6                	mv	a1,s1
  74:	854e                	mv	a0,s3
  76:	00000097          	auipc	ra,0x0
  7a:	41a080e7          	jalr	1050(ra) # 490 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  7e:	8526                	mv	a0,s1
  80:	00000097          	auipc	ra,0x0
  84:	29c080e7          	jalr	668(ra) # 31c <strlen>
  88:	0005091b          	sext.w	s2,a0
  8c:	8526                	mv	a0,s1
  8e:	00000097          	auipc	ra,0x0
  92:	28e080e7          	jalr	654(ra) # 31c <strlen>
  96:	1902                	slli	s2,s2,0x20
  98:	02095913          	srli	s2,s2,0x20
  9c:	4639                	li	a2,14
  9e:	9e09                	subw	a2,a2,a0
  a0:	02000593          	li	a1,32
  a4:	01298533          	add	a0,s3,s2
  a8:	00000097          	auipc	ra,0x0
  ac:	29e080e7          	jalr	670(ra) # 346 <memset>
  return buf;
  b0:	84ce                	mv	s1,s3
  b2:	bf69                	j	4c <fmtname+0x4c>

00000000000000b4 <ls>:

void
ls(char *path)
{
  b4:	d9010113          	addi	sp,sp,-624
  b8:	26113423          	sd	ra,616(sp)
  bc:	26813023          	sd	s0,608(sp)
  c0:	24913c23          	sd	s1,600(sp)
  c4:	25213823          	sd	s2,592(sp)
  c8:	25313423          	sd	s3,584(sp)
  cc:	25413023          	sd	s4,576(sp)
  d0:	23513c23          	sd	s5,568(sp)
  d4:	1c80                	addi	s0,sp,624
  d6:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  d8:	4581                	li	a1,0
  da:	00000097          	auipc	ra,0x0
  de:	4a8080e7          	jalr	1192(ra) # 582 <open>
  e2:	06054f63          	bltz	a0,160 <ls+0xac>
  e6:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  e8:	d9840593          	addi	a1,s0,-616
  ec:	00000097          	auipc	ra,0x0
  f0:	4ae080e7          	jalr	1198(ra) # 59a <fstat>
  f4:	08054163          	bltz	a0,176 <ls+0xc2>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  f8:	da041783          	lh	a5,-608(s0)
  fc:	0007869b          	sext.w	a3,a5
 100:	4705                	li	a4,1
 102:	08e68a63          	beq	a3,a4,196 <ls+0xe2>
 106:	4709                	li	a4,2
 108:	02e69663          	bne	a3,a4,134 <ls+0x80>
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
 10c:	854a                	mv	a0,s2
 10e:	00000097          	auipc	ra,0x0
 112:	ef2080e7          	jalr	-270(ra) # 0 <fmtname>
 116:	85aa                	mv	a1,a0
 118:	da843703          	ld	a4,-600(s0)
 11c:	d9c42683          	lw	a3,-612(s0)
 120:	da041603          	lh	a2,-608(s0)
 124:	00001517          	auipc	a0,0x1
 128:	9e450513          	addi	a0,a0,-1564 # b08 <longjmp_1+0x3a>
 12c:	00000097          	auipc	ra,0x0
 130:	78e080e7          	jalr	1934(ra) # 8ba <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 134:	8526                	mv	a0,s1
 136:	00000097          	auipc	ra,0x0
 13a:	434080e7          	jalr	1076(ra) # 56a <close>
}
 13e:	26813083          	ld	ra,616(sp)
 142:	26013403          	ld	s0,608(sp)
 146:	25813483          	ld	s1,600(sp)
 14a:	25013903          	ld	s2,592(sp)
 14e:	24813983          	ld	s3,584(sp)
 152:	24013a03          	ld	s4,576(sp)
 156:	23813a83          	ld	s5,568(sp)
 15a:	27010113          	addi	sp,sp,624
 15e:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 160:	864a                	mv	a2,s2
 162:	00001597          	auipc	a1,0x1
 166:	97658593          	addi	a1,a1,-1674 # ad8 <longjmp_1+0xa>
 16a:	4509                	li	a0,2
 16c:	00000097          	auipc	ra,0x0
 170:	720080e7          	jalr	1824(ra) # 88c <fprintf>
    return;
 174:	b7e9                	j	13e <ls+0x8a>
    fprintf(2, "ls: cannot stat %s\n", path);
 176:	864a                	mv	a2,s2
 178:	00001597          	auipc	a1,0x1
 17c:	97858593          	addi	a1,a1,-1672 # af0 <longjmp_1+0x22>
 180:	4509                	li	a0,2
 182:	00000097          	auipc	ra,0x0
 186:	70a080e7          	jalr	1802(ra) # 88c <fprintf>
    close(fd);
 18a:	8526                	mv	a0,s1
 18c:	00000097          	auipc	ra,0x0
 190:	3de080e7          	jalr	990(ra) # 56a <close>
    return;
 194:	b76d                	j	13e <ls+0x8a>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 196:	854a                	mv	a0,s2
 198:	00000097          	auipc	ra,0x0
 19c:	184080e7          	jalr	388(ra) # 31c <strlen>
 1a0:	2541                	addiw	a0,a0,16
 1a2:	20000793          	li	a5,512
 1a6:	00a7fb63          	bgeu	a5,a0,1bc <ls+0x108>
      printf("ls: path too long\n");
 1aa:	00001517          	auipc	a0,0x1
 1ae:	96e50513          	addi	a0,a0,-1682 # b18 <longjmp_1+0x4a>
 1b2:	00000097          	auipc	ra,0x0
 1b6:	708080e7          	jalr	1800(ra) # 8ba <printf>
      break;
 1ba:	bfad                	j	134 <ls+0x80>
    strcpy(buf, path);
 1bc:	85ca                	mv	a1,s2
 1be:	dc040513          	addi	a0,s0,-576
 1c2:	00000097          	auipc	ra,0x0
 1c6:	112080e7          	jalr	274(ra) # 2d4 <strcpy>
    p = buf+strlen(buf);
 1ca:	dc040513          	addi	a0,s0,-576
 1ce:	00000097          	auipc	ra,0x0
 1d2:	14e080e7          	jalr	334(ra) # 31c <strlen>
 1d6:	02051913          	slli	s2,a0,0x20
 1da:	02095913          	srli	s2,s2,0x20
 1de:	dc040793          	addi	a5,s0,-576
 1e2:	993e                	add	s2,s2,a5
    *p++ = '/';
 1e4:	00190993          	addi	s3,s2,1
 1e8:	02f00793          	li	a5,47
 1ec:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 1f0:	00001a17          	auipc	s4,0x1
 1f4:	940a0a13          	addi	s4,s4,-1728 # b30 <longjmp_1+0x62>
        printf("ls: cannot stat %s\n", buf);
 1f8:	00001a97          	auipc	s5,0x1
 1fc:	8f8a8a93          	addi	s5,s5,-1800 # af0 <longjmp_1+0x22>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 200:	a801                	j	210 <ls+0x15c>
        printf("ls: cannot stat %s\n", buf);
 202:	dc040593          	addi	a1,s0,-576
 206:	8556                	mv	a0,s5
 208:	00000097          	auipc	ra,0x0
 20c:	6b2080e7          	jalr	1714(ra) # 8ba <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 210:	4641                	li	a2,16
 212:	db040593          	addi	a1,s0,-592
 216:	8526                	mv	a0,s1
 218:	00000097          	auipc	ra,0x0
 21c:	342080e7          	jalr	834(ra) # 55a <read>
 220:	47c1                	li	a5,16
 222:	f0f519e3          	bne	a0,a5,134 <ls+0x80>
      if(de.inum == 0)
 226:	db045783          	lhu	a5,-592(s0)
 22a:	d3fd                	beqz	a5,210 <ls+0x15c>
      memmove(p, de.name, DIRSIZ);
 22c:	4639                	li	a2,14
 22e:	db240593          	addi	a1,s0,-590
 232:	854e                	mv	a0,s3
 234:	00000097          	auipc	ra,0x0
 238:	25c080e7          	jalr	604(ra) # 490 <memmove>
      p[DIRSIZ] = 0;
 23c:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 240:	d9840593          	addi	a1,s0,-616
 244:	dc040513          	addi	a0,s0,-576
 248:	00000097          	auipc	ra,0x0
 24c:	1b8080e7          	jalr	440(ra) # 400 <stat>
 250:	fa0549e3          	bltz	a0,202 <ls+0x14e>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 254:	dc040513          	addi	a0,s0,-576
 258:	00000097          	auipc	ra,0x0
 25c:	da8080e7          	jalr	-600(ra) # 0 <fmtname>
 260:	85aa                	mv	a1,a0
 262:	da843703          	ld	a4,-600(s0)
 266:	d9c42683          	lw	a3,-612(s0)
 26a:	da041603          	lh	a2,-608(s0)
 26e:	8552                	mv	a0,s4
 270:	00000097          	auipc	ra,0x0
 274:	64a080e7          	jalr	1610(ra) # 8ba <printf>
 278:	bf61                	j	210 <ls+0x15c>

000000000000027a <main>:

int
main(int argc, char *argv[])
{
 27a:	1101                	addi	sp,sp,-32
 27c:	ec06                	sd	ra,24(sp)
 27e:	e822                	sd	s0,16(sp)
 280:	e426                	sd	s1,8(sp)
 282:	e04a                	sd	s2,0(sp)
 284:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 286:	4785                	li	a5,1
 288:	02a7d963          	bge	a5,a0,2ba <main+0x40>
 28c:	00858493          	addi	s1,a1,8
 290:	ffe5091b          	addiw	s2,a0,-2
 294:	1902                	slli	s2,s2,0x20
 296:	02095913          	srli	s2,s2,0x20
 29a:	090e                	slli	s2,s2,0x3
 29c:	05c1                	addi	a1,a1,16
 29e:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 2a0:	6088                	ld	a0,0(s1)
 2a2:	00000097          	auipc	ra,0x0
 2a6:	e12080e7          	jalr	-494(ra) # b4 <ls>
  for(i=1; i<argc; i++)
 2aa:	04a1                	addi	s1,s1,8
 2ac:	ff249ae3          	bne	s1,s2,2a0 <main+0x26>
  exit(0);
 2b0:	4501                	li	a0,0
 2b2:	00000097          	auipc	ra,0x0
 2b6:	290080e7          	jalr	656(ra) # 542 <exit>
    ls(".");
 2ba:	00001517          	auipc	a0,0x1
 2be:	88650513          	addi	a0,a0,-1914 # b40 <longjmp_1+0x72>
 2c2:	00000097          	auipc	ra,0x0
 2c6:	df2080e7          	jalr	-526(ra) # b4 <ls>
    exit(0);
 2ca:	4501                	li	a0,0
 2cc:	00000097          	auipc	ra,0x0
 2d0:	276080e7          	jalr	630(ra) # 542 <exit>

00000000000002d4 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 2d4:	1141                	addi	sp,sp,-16
 2d6:	e422                	sd	s0,8(sp)
 2d8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2da:	87aa                	mv	a5,a0
 2dc:	0585                	addi	a1,a1,1
 2de:	0785                	addi	a5,a5,1
 2e0:	fff5c703          	lbu	a4,-1(a1)
 2e4:	fee78fa3          	sb	a4,-1(a5)
 2e8:	fb75                	bnez	a4,2dc <strcpy+0x8>
    ;
  return os;
}
 2ea:	6422                	ld	s0,8(sp)
 2ec:	0141                	addi	sp,sp,16
 2ee:	8082                	ret

00000000000002f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2f0:	1141                	addi	sp,sp,-16
 2f2:	e422                	sd	s0,8(sp)
 2f4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2f6:	00054783          	lbu	a5,0(a0)
 2fa:	cb91                	beqz	a5,30e <strcmp+0x1e>
 2fc:	0005c703          	lbu	a4,0(a1)
 300:	00f71763          	bne	a4,a5,30e <strcmp+0x1e>
    p++, q++;
 304:	0505                	addi	a0,a0,1
 306:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 308:	00054783          	lbu	a5,0(a0)
 30c:	fbe5                	bnez	a5,2fc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 30e:	0005c503          	lbu	a0,0(a1)
}
 312:	40a7853b          	subw	a0,a5,a0
 316:	6422                	ld	s0,8(sp)
 318:	0141                	addi	sp,sp,16
 31a:	8082                	ret

000000000000031c <strlen>:

uint
strlen(const char *s)
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e422                	sd	s0,8(sp)
 320:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 322:	00054783          	lbu	a5,0(a0)
 326:	cf91                	beqz	a5,342 <strlen+0x26>
 328:	0505                	addi	a0,a0,1
 32a:	87aa                	mv	a5,a0
 32c:	4685                	li	a3,1
 32e:	9e89                	subw	a3,a3,a0
 330:	00f6853b          	addw	a0,a3,a5
 334:	0785                	addi	a5,a5,1
 336:	fff7c703          	lbu	a4,-1(a5)
 33a:	fb7d                	bnez	a4,330 <strlen+0x14>
    ;
  return n;
}
 33c:	6422                	ld	s0,8(sp)
 33e:	0141                	addi	sp,sp,16
 340:	8082                	ret
  for(n = 0; s[n]; n++)
 342:	4501                	li	a0,0
 344:	bfe5                	j	33c <strlen+0x20>

0000000000000346 <memset>:

void*
memset(void *dst, int c, uint n)
{
 346:	1141                	addi	sp,sp,-16
 348:	e422                	sd	s0,8(sp)
 34a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 34c:	ca19                	beqz	a2,362 <memset+0x1c>
 34e:	87aa                	mv	a5,a0
 350:	1602                	slli	a2,a2,0x20
 352:	9201                	srli	a2,a2,0x20
 354:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 358:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 35c:	0785                	addi	a5,a5,1
 35e:	fee79de3          	bne	a5,a4,358 <memset+0x12>
  }
  return dst;
}
 362:	6422                	ld	s0,8(sp)
 364:	0141                	addi	sp,sp,16
 366:	8082                	ret

0000000000000368 <strchr>:

char*
strchr(const char *s, char c)
{
 368:	1141                	addi	sp,sp,-16
 36a:	e422                	sd	s0,8(sp)
 36c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 36e:	00054783          	lbu	a5,0(a0)
 372:	cb99                	beqz	a5,388 <strchr+0x20>
    if(*s == c)
 374:	00f58763          	beq	a1,a5,382 <strchr+0x1a>
  for(; *s; s++)
 378:	0505                	addi	a0,a0,1
 37a:	00054783          	lbu	a5,0(a0)
 37e:	fbfd                	bnez	a5,374 <strchr+0xc>
      return (char*)s;
  return 0;
 380:	4501                	li	a0,0
}
 382:	6422                	ld	s0,8(sp)
 384:	0141                	addi	sp,sp,16
 386:	8082                	ret
  return 0;
 388:	4501                	li	a0,0
 38a:	bfe5                	j	382 <strchr+0x1a>

000000000000038c <gets>:

char*
gets(char *buf, int max)
{
 38c:	711d                	addi	sp,sp,-96
 38e:	ec86                	sd	ra,88(sp)
 390:	e8a2                	sd	s0,80(sp)
 392:	e4a6                	sd	s1,72(sp)
 394:	e0ca                	sd	s2,64(sp)
 396:	fc4e                	sd	s3,56(sp)
 398:	f852                	sd	s4,48(sp)
 39a:	f456                	sd	s5,40(sp)
 39c:	f05a                	sd	s6,32(sp)
 39e:	ec5e                	sd	s7,24(sp)
 3a0:	1080                	addi	s0,sp,96
 3a2:	8baa                	mv	s7,a0
 3a4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3a6:	892a                	mv	s2,a0
 3a8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3aa:	4aa9                	li	s5,10
 3ac:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3ae:	89a6                	mv	s3,s1
 3b0:	2485                	addiw	s1,s1,1
 3b2:	0344d863          	bge	s1,s4,3e2 <gets+0x56>
    cc = read(0, &c, 1);
 3b6:	4605                	li	a2,1
 3b8:	faf40593          	addi	a1,s0,-81
 3bc:	4501                	li	a0,0
 3be:	00000097          	auipc	ra,0x0
 3c2:	19c080e7          	jalr	412(ra) # 55a <read>
    if(cc < 1)
 3c6:	00a05e63          	blez	a0,3e2 <gets+0x56>
    buf[i++] = c;
 3ca:	faf44783          	lbu	a5,-81(s0)
 3ce:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3d2:	01578763          	beq	a5,s5,3e0 <gets+0x54>
 3d6:	0905                	addi	s2,s2,1
 3d8:	fd679be3          	bne	a5,s6,3ae <gets+0x22>
  for(i=0; i+1 < max; ){
 3dc:	89a6                	mv	s3,s1
 3de:	a011                	j	3e2 <gets+0x56>
 3e0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3e2:	99de                	add	s3,s3,s7
 3e4:	00098023          	sb	zero,0(s3)
  return buf;
}
 3e8:	855e                	mv	a0,s7
 3ea:	60e6                	ld	ra,88(sp)
 3ec:	6446                	ld	s0,80(sp)
 3ee:	64a6                	ld	s1,72(sp)
 3f0:	6906                	ld	s2,64(sp)
 3f2:	79e2                	ld	s3,56(sp)
 3f4:	7a42                	ld	s4,48(sp)
 3f6:	7aa2                	ld	s5,40(sp)
 3f8:	7b02                	ld	s6,32(sp)
 3fa:	6be2                	ld	s7,24(sp)
 3fc:	6125                	addi	sp,sp,96
 3fe:	8082                	ret

0000000000000400 <stat>:

int
stat(const char *n, struct stat *st)
{
 400:	1101                	addi	sp,sp,-32
 402:	ec06                	sd	ra,24(sp)
 404:	e822                	sd	s0,16(sp)
 406:	e426                	sd	s1,8(sp)
 408:	e04a                	sd	s2,0(sp)
 40a:	1000                	addi	s0,sp,32
 40c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 40e:	4581                	li	a1,0
 410:	00000097          	auipc	ra,0x0
 414:	172080e7          	jalr	370(ra) # 582 <open>
  if(fd < 0)
 418:	02054563          	bltz	a0,442 <stat+0x42>
 41c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 41e:	85ca                	mv	a1,s2
 420:	00000097          	auipc	ra,0x0
 424:	17a080e7          	jalr	378(ra) # 59a <fstat>
 428:	892a                	mv	s2,a0
  close(fd);
 42a:	8526                	mv	a0,s1
 42c:	00000097          	auipc	ra,0x0
 430:	13e080e7          	jalr	318(ra) # 56a <close>
  return r;
}
 434:	854a                	mv	a0,s2
 436:	60e2                	ld	ra,24(sp)
 438:	6442                	ld	s0,16(sp)
 43a:	64a2                	ld	s1,8(sp)
 43c:	6902                	ld	s2,0(sp)
 43e:	6105                	addi	sp,sp,32
 440:	8082                	ret
    return -1;
 442:	597d                	li	s2,-1
 444:	bfc5                	j	434 <stat+0x34>

0000000000000446 <atoi>:

int
atoi(const char *s)
{
 446:	1141                	addi	sp,sp,-16
 448:	e422                	sd	s0,8(sp)
 44a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 44c:	00054603          	lbu	a2,0(a0)
 450:	fd06079b          	addiw	a5,a2,-48
 454:	0ff7f793          	andi	a5,a5,255
 458:	4725                	li	a4,9
 45a:	02f76963          	bltu	a4,a5,48c <atoi+0x46>
 45e:	86aa                	mv	a3,a0
  n = 0;
 460:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 462:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 464:	0685                	addi	a3,a3,1
 466:	0025179b          	slliw	a5,a0,0x2
 46a:	9fa9                	addw	a5,a5,a0
 46c:	0017979b          	slliw	a5,a5,0x1
 470:	9fb1                	addw	a5,a5,a2
 472:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 476:	0006c603          	lbu	a2,0(a3)
 47a:	fd06071b          	addiw	a4,a2,-48
 47e:	0ff77713          	andi	a4,a4,255
 482:	fee5f1e3          	bgeu	a1,a4,464 <atoi+0x1e>
  return n;
}
 486:	6422                	ld	s0,8(sp)
 488:	0141                	addi	sp,sp,16
 48a:	8082                	ret
  n = 0;
 48c:	4501                	li	a0,0
 48e:	bfe5                	j	486 <atoi+0x40>

0000000000000490 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 490:	1141                	addi	sp,sp,-16
 492:	e422                	sd	s0,8(sp)
 494:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 496:	02b57463          	bgeu	a0,a1,4be <memmove+0x2e>
    while(n-- > 0)
 49a:	00c05f63          	blez	a2,4b8 <memmove+0x28>
 49e:	1602                	slli	a2,a2,0x20
 4a0:	9201                	srli	a2,a2,0x20
 4a2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4a6:	872a                	mv	a4,a0
      *dst++ = *src++;
 4a8:	0585                	addi	a1,a1,1
 4aa:	0705                	addi	a4,a4,1
 4ac:	fff5c683          	lbu	a3,-1(a1)
 4b0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4b4:	fee79ae3          	bne	a5,a4,4a8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4b8:	6422                	ld	s0,8(sp)
 4ba:	0141                	addi	sp,sp,16
 4bc:	8082                	ret
    dst += n;
 4be:	00c50733          	add	a4,a0,a2
    src += n;
 4c2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4c4:	fec05ae3          	blez	a2,4b8 <memmove+0x28>
 4c8:	fff6079b          	addiw	a5,a2,-1
 4cc:	1782                	slli	a5,a5,0x20
 4ce:	9381                	srli	a5,a5,0x20
 4d0:	fff7c793          	not	a5,a5
 4d4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4d6:	15fd                	addi	a1,a1,-1
 4d8:	177d                	addi	a4,a4,-1
 4da:	0005c683          	lbu	a3,0(a1)
 4de:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4e2:	fee79ae3          	bne	a5,a4,4d6 <memmove+0x46>
 4e6:	bfc9                	j	4b8 <memmove+0x28>

00000000000004e8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4e8:	1141                	addi	sp,sp,-16
 4ea:	e422                	sd	s0,8(sp)
 4ec:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4ee:	ca05                	beqz	a2,51e <memcmp+0x36>
 4f0:	fff6069b          	addiw	a3,a2,-1
 4f4:	1682                	slli	a3,a3,0x20
 4f6:	9281                	srli	a3,a3,0x20
 4f8:	0685                	addi	a3,a3,1
 4fa:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4fc:	00054783          	lbu	a5,0(a0)
 500:	0005c703          	lbu	a4,0(a1)
 504:	00e79863          	bne	a5,a4,514 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 508:	0505                	addi	a0,a0,1
    p2++;
 50a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 50c:	fed518e3          	bne	a0,a3,4fc <memcmp+0x14>
  }
  return 0;
 510:	4501                	li	a0,0
 512:	a019                	j	518 <memcmp+0x30>
      return *p1 - *p2;
 514:	40e7853b          	subw	a0,a5,a4
}
 518:	6422                	ld	s0,8(sp)
 51a:	0141                	addi	sp,sp,16
 51c:	8082                	ret
  return 0;
 51e:	4501                	li	a0,0
 520:	bfe5                	j	518 <memcmp+0x30>

0000000000000522 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 522:	1141                	addi	sp,sp,-16
 524:	e406                	sd	ra,8(sp)
 526:	e022                	sd	s0,0(sp)
 528:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 52a:	00000097          	auipc	ra,0x0
 52e:	f66080e7          	jalr	-154(ra) # 490 <memmove>
}
 532:	60a2                	ld	ra,8(sp)
 534:	6402                	ld	s0,0(sp)
 536:	0141                	addi	sp,sp,16
 538:	8082                	ret

000000000000053a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 53a:	4885                	li	a7,1
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <exit>:
.global exit
exit:
 li a7, SYS_exit
 542:	4889                	li	a7,2
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <wait>:
.global wait
wait:
 li a7, SYS_wait
 54a:	488d                	li	a7,3
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 552:	4891                	li	a7,4
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <read>:
.global read
read:
 li a7, SYS_read
 55a:	4895                	li	a7,5
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <write>:
.global write
write:
 li a7, SYS_write
 562:	48c1                	li	a7,16
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <close>:
.global close
close:
 li a7, SYS_close
 56a:	48d5                	li	a7,21
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <kill>:
.global kill
kill:
 li a7, SYS_kill
 572:	4899                	li	a7,6
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <exec>:
.global exec
exec:
 li a7, SYS_exec
 57a:	489d                	li	a7,7
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <open>:
.global open
open:
 li a7, SYS_open
 582:	48bd                	li	a7,15
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 58a:	48c5                	li	a7,17
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 592:	48c9                	li	a7,18
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 59a:	48a1                	li	a7,8
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <link>:
.global link
link:
 li a7, SYS_link
 5a2:	48cd                	li	a7,19
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5aa:	48d1                	li	a7,20
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5b2:	48a5                	li	a7,9
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <dup>:
.global dup
dup:
 li a7, SYS_dup
 5ba:	48a9                	li	a7,10
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5c2:	48ad                	li	a7,11
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5ca:	48b1                	li	a7,12
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5d2:	48b5                	li	a7,13
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5da:	48b9                	li	a7,14
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5e2:	1101                	addi	sp,sp,-32
 5e4:	ec06                	sd	ra,24(sp)
 5e6:	e822                	sd	s0,16(sp)
 5e8:	1000                	addi	s0,sp,32
 5ea:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5ee:	4605                	li	a2,1
 5f0:	fef40593          	addi	a1,s0,-17
 5f4:	00000097          	auipc	ra,0x0
 5f8:	f6e080e7          	jalr	-146(ra) # 562 <write>
}
 5fc:	60e2                	ld	ra,24(sp)
 5fe:	6442                	ld	s0,16(sp)
 600:	6105                	addi	sp,sp,32
 602:	8082                	ret

0000000000000604 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 604:	7139                	addi	sp,sp,-64
 606:	fc06                	sd	ra,56(sp)
 608:	f822                	sd	s0,48(sp)
 60a:	f426                	sd	s1,40(sp)
 60c:	f04a                	sd	s2,32(sp)
 60e:	ec4e                	sd	s3,24(sp)
 610:	0080                	addi	s0,sp,64
 612:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 614:	c299                	beqz	a3,61a <printint+0x16>
 616:	0805c863          	bltz	a1,6a6 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 61a:	2581                	sext.w	a1,a1
  neg = 0;
 61c:	4881                	li	a7,0
 61e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 622:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 624:	2601                	sext.w	a2,a2
 626:	00000517          	auipc	a0,0x0
 62a:	52a50513          	addi	a0,a0,1322 # b50 <digits>
 62e:	883a                	mv	a6,a4
 630:	2705                	addiw	a4,a4,1
 632:	02c5f7bb          	remuw	a5,a1,a2
 636:	1782                	slli	a5,a5,0x20
 638:	9381                	srli	a5,a5,0x20
 63a:	97aa                	add	a5,a5,a0
 63c:	0007c783          	lbu	a5,0(a5)
 640:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 644:	0005879b          	sext.w	a5,a1
 648:	02c5d5bb          	divuw	a1,a1,a2
 64c:	0685                	addi	a3,a3,1
 64e:	fec7f0e3          	bgeu	a5,a2,62e <printint+0x2a>
  if(neg)
 652:	00088b63          	beqz	a7,668 <printint+0x64>
    buf[i++] = '-';
 656:	fd040793          	addi	a5,s0,-48
 65a:	973e                	add	a4,a4,a5
 65c:	02d00793          	li	a5,45
 660:	fef70823          	sb	a5,-16(a4)
 664:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 668:	02e05863          	blez	a4,698 <printint+0x94>
 66c:	fc040793          	addi	a5,s0,-64
 670:	00e78933          	add	s2,a5,a4
 674:	fff78993          	addi	s3,a5,-1
 678:	99ba                	add	s3,s3,a4
 67a:	377d                	addiw	a4,a4,-1
 67c:	1702                	slli	a4,a4,0x20
 67e:	9301                	srli	a4,a4,0x20
 680:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 684:	fff94583          	lbu	a1,-1(s2)
 688:	8526                	mv	a0,s1
 68a:	00000097          	auipc	ra,0x0
 68e:	f58080e7          	jalr	-168(ra) # 5e2 <putc>
  while(--i >= 0)
 692:	197d                	addi	s2,s2,-1
 694:	ff3918e3          	bne	s2,s3,684 <printint+0x80>
}
 698:	70e2                	ld	ra,56(sp)
 69a:	7442                	ld	s0,48(sp)
 69c:	74a2                	ld	s1,40(sp)
 69e:	7902                	ld	s2,32(sp)
 6a0:	69e2                	ld	s3,24(sp)
 6a2:	6121                	addi	sp,sp,64
 6a4:	8082                	ret
    x = -xx;
 6a6:	40b005bb          	negw	a1,a1
    neg = 1;
 6aa:	4885                	li	a7,1
    x = -xx;
 6ac:	bf8d                	j	61e <printint+0x1a>

00000000000006ae <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6ae:	7119                	addi	sp,sp,-128
 6b0:	fc86                	sd	ra,120(sp)
 6b2:	f8a2                	sd	s0,112(sp)
 6b4:	f4a6                	sd	s1,104(sp)
 6b6:	f0ca                	sd	s2,96(sp)
 6b8:	ecce                	sd	s3,88(sp)
 6ba:	e8d2                	sd	s4,80(sp)
 6bc:	e4d6                	sd	s5,72(sp)
 6be:	e0da                	sd	s6,64(sp)
 6c0:	fc5e                	sd	s7,56(sp)
 6c2:	f862                	sd	s8,48(sp)
 6c4:	f466                	sd	s9,40(sp)
 6c6:	f06a                	sd	s10,32(sp)
 6c8:	ec6e                	sd	s11,24(sp)
 6ca:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6cc:	0005c903          	lbu	s2,0(a1)
 6d0:	18090f63          	beqz	s2,86e <vprintf+0x1c0>
 6d4:	8aaa                	mv	s5,a0
 6d6:	8b32                	mv	s6,a2
 6d8:	00158493          	addi	s1,a1,1
  state = 0;
 6dc:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6de:	02500a13          	li	s4,37
      if(c == 'd'){
 6e2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 6e6:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 6ea:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 6ee:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6f2:	00000b97          	auipc	s7,0x0
 6f6:	45eb8b93          	addi	s7,s7,1118 # b50 <digits>
 6fa:	a839                	j	718 <vprintf+0x6a>
        putc(fd, c);
 6fc:	85ca                	mv	a1,s2
 6fe:	8556                	mv	a0,s5
 700:	00000097          	auipc	ra,0x0
 704:	ee2080e7          	jalr	-286(ra) # 5e2 <putc>
 708:	a019                	j	70e <vprintf+0x60>
    } else if(state == '%'){
 70a:	01498f63          	beq	s3,s4,728 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 70e:	0485                	addi	s1,s1,1
 710:	fff4c903          	lbu	s2,-1(s1)
 714:	14090d63          	beqz	s2,86e <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 718:	0009079b          	sext.w	a5,s2
    if(state == 0){
 71c:	fe0997e3          	bnez	s3,70a <vprintf+0x5c>
      if(c == '%'){
 720:	fd479ee3          	bne	a5,s4,6fc <vprintf+0x4e>
        state = '%';
 724:	89be                	mv	s3,a5
 726:	b7e5                	j	70e <vprintf+0x60>
      if(c == 'd'){
 728:	05878063          	beq	a5,s8,768 <vprintf+0xba>
      } else if(c == 'l') {
 72c:	05978c63          	beq	a5,s9,784 <vprintf+0xd6>
      } else if(c == 'x') {
 730:	07a78863          	beq	a5,s10,7a0 <vprintf+0xf2>
      } else if(c == 'p') {
 734:	09b78463          	beq	a5,s11,7bc <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 738:	07300713          	li	a4,115
 73c:	0ce78663          	beq	a5,a4,808 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 740:	06300713          	li	a4,99
 744:	0ee78e63          	beq	a5,a4,840 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 748:	11478863          	beq	a5,s4,858 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 74c:	85d2                	mv	a1,s4
 74e:	8556                	mv	a0,s5
 750:	00000097          	auipc	ra,0x0
 754:	e92080e7          	jalr	-366(ra) # 5e2 <putc>
        putc(fd, c);
 758:	85ca                	mv	a1,s2
 75a:	8556                	mv	a0,s5
 75c:	00000097          	auipc	ra,0x0
 760:	e86080e7          	jalr	-378(ra) # 5e2 <putc>
      }
      state = 0;
 764:	4981                	li	s3,0
 766:	b765                	j	70e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 768:	008b0913          	addi	s2,s6,8
 76c:	4685                	li	a3,1
 76e:	4629                	li	a2,10
 770:	000b2583          	lw	a1,0(s6)
 774:	8556                	mv	a0,s5
 776:	00000097          	auipc	ra,0x0
 77a:	e8e080e7          	jalr	-370(ra) # 604 <printint>
 77e:	8b4a                	mv	s6,s2
      state = 0;
 780:	4981                	li	s3,0
 782:	b771                	j	70e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 784:	008b0913          	addi	s2,s6,8
 788:	4681                	li	a3,0
 78a:	4629                	li	a2,10
 78c:	000b2583          	lw	a1,0(s6)
 790:	8556                	mv	a0,s5
 792:	00000097          	auipc	ra,0x0
 796:	e72080e7          	jalr	-398(ra) # 604 <printint>
 79a:	8b4a                	mv	s6,s2
      state = 0;
 79c:	4981                	li	s3,0
 79e:	bf85                	j	70e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7a0:	008b0913          	addi	s2,s6,8
 7a4:	4681                	li	a3,0
 7a6:	4641                	li	a2,16
 7a8:	000b2583          	lw	a1,0(s6)
 7ac:	8556                	mv	a0,s5
 7ae:	00000097          	auipc	ra,0x0
 7b2:	e56080e7          	jalr	-426(ra) # 604 <printint>
 7b6:	8b4a                	mv	s6,s2
      state = 0;
 7b8:	4981                	li	s3,0
 7ba:	bf91                	j	70e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7bc:	008b0793          	addi	a5,s6,8
 7c0:	f8f43423          	sd	a5,-120(s0)
 7c4:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7c8:	03000593          	li	a1,48
 7cc:	8556                	mv	a0,s5
 7ce:	00000097          	auipc	ra,0x0
 7d2:	e14080e7          	jalr	-492(ra) # 5e2 <putc>
  putc(fd, 'x');
 7d6:	85ea                	mv	a1,s10
 7d8:	8556                	mv	a0,s5
 7da:	00000097          	auipc	ra,0x0
 7de:	e08080e7          	jalr	-504(ra) # 5e2 <putc>
 7e2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7e4:	03c9d793          	srli	a5,s3,0x3c
 7e8:	97de                	add	a5,a5,s7
 7ea:	0007c583          	lbu	a1,0(a5)
 7ee:	8556                	mv	a0,s5
 7f0:	00000097          	auipc	ra,0x0
 7f4:	df2080e7          	jalr	-526(ra) # 5e2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7f8:	0992                	slli	s3,s3,0x4
 7fa:	397d                	addiw	s2,s2,-1
 7fc:	fe0914e3          	bnez	s2,7e4 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 800:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 804:	4981                	li	s3,0
 806:	b721                	j	70e <vprintf+0x60>
        s = va_arg(ap, char*);
 808:	008b0993          	addi	s3,s6,8
 80c:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 810:	02090163          	beqz	s2,832 <vprintf+0x184>
        while(*s != 0){
 814:	00094583          	lbu	a1,0(s2)
 818:	c9a1                	beqz	a1,868 <vprintf+0x1ba>
          putc(fd, *s);
 81a:	8556                	mv	a0,s5
 81c:	00000097          	auipc	ra,0x0
 820:	dc6080e7          	jalr	-570(ra) # 5e2 <putc>
          s++;
 824:	0905                	addi	s2,s2,1
        while(*s != 0){
 826:	00094583          	lbu	a1,0(s2)
 82a:	f9e5                	bnez	a1,81a <vprintf+0x16c>
        s = va_arg(ap, char*);
 82c:	8b4e                	mv	s6,s3
      state = 0;
 82e:	4981                	li	s3,0
 830:	bdf9                	j	70e <vprintf+0x60>
          s = "(null)";
 832:	00000917          	auipc	s2,0x0
 836:	31690913          	addi	s2,s2,790 # b48 <longjmp_1+0x7a>
        while(*s != 0){
 83a:	02800593          	li	a1,40
 83e:	bff1                	j	81a <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 840:	008b0913          	addi	s2,s6,8
 844:	000b4583          	lbu	a1,0(s6)
 848:	8556                	mv	a0,s5
 84a:	00000097          	auipc	ra,0x0
 84e:	d98080e7          	jalr	-616(ra) # 5e2 <putc>
 852:	8b4a                	mv	s6,s2
      state = 0;
 854:	4981                	li	s3,0
 856:	bd65                	j	70e <vprintf+0x60>
        putc(fd, c);
 858:	85d2                	mv	a1,s4
 85a:	8556                	mv	a0,s5
 85c:	00000097          	auipc	ra,0x0
 860:	d86080e7          	jalr	-634(ra) # 5e2 <putc>
      state = 0;
 864:	4981                	li	s3,0
 866:	b565                	j	70e <vprintf+0x60>
        s = va_arg(ap, char*);
 868:	8b4e                	mv	s6,s3
      state = 0;
 86a:	4981                	li	s3,0
 86c:	b54d                	j	70e <vprintf+0x60>
    }
  }
}
 86e:	70e6                	ld	ra,120(sp)
 870:	7446                	ld	s0,112(sp)
 872:	74a6                	ld	s1,104(sp)
 874:	7906                	ld	s2,96(sp)
 876:	69e6                	ld	s3,88(sp)
 878:	6a46                	ld	s4,80(sp)
 87a:	6aa6                	ld	s5,72(sp)
 87c:	6b06                	ld	s6,64(sp)
 87e:	7be2                	ld	s7,56(sp)
 880:	7c42                	ld	s8,48(sp)
 882:	7ca2                	ld	s9,40(sp)
 884:	7d02                	ld	s10,32(sp)
 886:	6de2                	ld	s11,24(sp)
 888:	6109                	addi	sp,sp,128
 88a:	8082                	ret

000000000000088c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 88c:	715d                	addi	sp,sp,-80
 88e:	ec06                	sd	ra,24(sp)
 890:	e822                	sd	s0,16(sp)
 892:	1000                	addi	s0,sp,32
 894:	e010                	sd	a2,0(s0)
 896:	e414                	sd	a3,8(s0)
 898:	e818                	sd	a4,16(s0)
 89a:	ec1c                	sd	a5,24(s0)
 89c:	03043023          	sd	a6,32(s0)
 8a0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8a4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8a8:	8622                	mv	a2,s0
 8aa:	00000097          	auipc	ra,0x0
 8ae:	e04080e7          	jalr	-508(ra) # 6ae <vprintf>
}
 8b2:	60e2                	ld	ra,24(sp)
 8b4:	6442                	ld	s0,16(sp)
 8b6:	6161                	addi	sp,sp,80
 8b8:	8082                	ret

00000000000008ba <printf>:

void
printf(const char *fmt, ...)
{
 8ba:	711d                	addi	sp,sp,-96
 8bc:	ec06                	sd	ra,24(sp)
 8be:	e822                	sd	s0,16(sp)
 8c0:	1000                	addi	s0,sp,32
 8c2:	e40c                	sd	a1,8(s0)
 8c4:	e810                	sd	a2,16(s0)
 8c6:	ec14                	sd	a3,24(s0)
 8c8:	f018                	sd	a4,32(s0)
 8ca:	f41c                	sd	a5,40(s0)
 8cc:	03043823          	sd	a6,48(s0)
 8d0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8d4:	00840613          	addi	a2,s0,8
 8d8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8dc:	85aa                	mv	a1,a0
 8de:	4505                	li	a0,1
 8e0:	00000097          	auipc	ra,0x0
 8e4:	dce080e7          	jalr	-562(ra) # 6ae <vprintf>
}
 8e8:	60e2                	ld	ra,24(sp)
 8ea:	6442                	ld	s0,16(sp)
 8ec:	6125                	addi	sp,sp,96
 8ee:	8082                	ret

00000000000008f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8f0:	1141                	addi	sp,sp,-16
 8f2:	e422                	sd	s0,8(sp)
 8f4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8f6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8fa:	00000797          	auipc	a5,0x0
 8fe:	26e7b783          	ld	a5,622(a5) # b68 <freep>
 902:	a805                	j	932 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 904:	4618                	lw	a4,8(a2)
 906:	9db9                	addw	a1,a1,a4
 908:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 90c:	6398                	ld	a4,0(a5)
 90e:	6318                	ld	a4,0(a4)
 910:	fee53823          	sd	a4,-16(a0)
 914:	a091                	j	958 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 916:	ff852703          	lw	a4,-8(a0)
 91a:	9e39                	addw	a2,a2,a4
 91c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 91e:	ff053703          	ld	a4,-16(a0)
 922:	e398                	sd	a4,0(a5)
 924:	a099                	j	96a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 926:	6398                	ld	a4,0(a5)
 928:	00e7e463          	bltu	a5,a4,930 <free+0x40>
 92c:	00e6ea63          	bltu	a3,a4,940 <free+0x50>
{
 930:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 932:	fed7fae3          	bgeu	a5,a3,926 <free+0x36>
 936:	6398                	ld	a4,0(a5)
 938:	00e6e463          	bltu	a3,a4,940 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 93c:	fee7eae3          	bltu	a5,a4,930 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 940:	ff852583          	lw	a1,-8(a0)
 944:	6390                	ld	a2,0(a5)
 946:	02059713          	slli	a4,a1,0x20
 94a:	9301                	srli	a4,a4,0x20
 94c:	0712                	slli	a4,a4,0x4
 94e:	9736                	add	a4,a4,a3
 950:	fae60ae3          	beq	a2,a4,904 <free+0x14>
    bp->s.ptr = p->s.ptr;
 954:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 958:	4790                	lw	a2,8(a5)
 95a:	02061713          	slli	a4,a2,0x20
 95e:	9301                	srli	a4,a4,0x20
 960:	0712                	slli	a4,a4,0x4
 962:	973e                	add	a4,a4,a5
 964:	fae689e3          	beq	a3,a4,916 <free+0x26>
  } else
    p->s.ptr = bp;
 968:	e394                	sd	a3,0(a5)
  freep = p;
 96a:	00000717          	auipc	a4,0x0
 96e:	1ef73f23          	sd	a5,510(a4) # b68 <freep>
}
 972:	6422                	ld	s0,8(sp)
 974:	0141                	addi	sp,sp,16
 976:	8082                	ret

0000000000000978 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 978:	7139                	addi	sp,sp,-64
 97a:	fc06                	sd	ra,56(sp)
 97c:	f822                	sd	s0,48(sp)
 97e:	f426                	sd	s1,40(sp)
 980:	f04a                	sd	s2,32(sp)
 982:	ec4e                	sd	s3,24(sp)
 984:	e852                	sd	s4,16(sp)
 986:	e456                	sd	s5,8(sp)
 988:	e05a                	sd	s6,0(sp)
 98a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 98c:	02051493          	slli	s1,a0,0x20
 990:	9081                	srli	s1,s1,0x20
 992:	04bd                	addi	s1,s1,15
 994:	8091                	srli	s1,s1,0x4
 996:	0014899b          	addiw	s3,s1,1
 99a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 99c:	00000517          	auipc	a0,0x0
 9a0:	1cc53503          	ld	a0,460(a0) # b68 <freep>
 9a4:	c515                	beqz	a0,9d0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9a8:	4798                	lw	a4,8(a5)
 9aa:	02977f63          	bgeu	a4,s1,9e8 <malloc+0x70>
 9ae:	8a4e                	mv	s4,s3
 9b0:	0009871b          	sext.w	a4,s3
 9b4:	6685                	lui	a3,0x1
 9b6:	00d77363          	bgeu	a4,a3,9bc <malloc+0x44>
 9ba:	6a05                	lui	s4,0x1
 9bc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9c0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9c4:	00000917          	auipc	s2,0x0
 9c8:	1a490913          	addi	s2,s2,420 # b68 <freep>
  if(p == (char*)-1)
 9cc:	5afd                	li	s5,-1
 9ce:	a88d                	j	a40 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 9d0:	00000797          	auipc	a5,0x0
 9d4:	1b078793          	addi	a5,a5,432 # b80 <base>
 9d8:	00000717          	auipc	a4,0x0
 9dc:	18f73823          	sd	a5,400(a4) # b68 <freep>
 9e0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9e2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9e6:	b7e1                	j	9ae <malloc+0x36>
      if(p->s.size == nunits)
 9e8:	02e48b63          	beq	s1,a4,a1e <malloc+0xa6>
        p->s.size -= nunits;
 9ec:	4137073b          	subw	a4,a4,s3
 9f0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9f2:	1702                	slli	a4,a4,0x20
 9f4:	9301                	srli	a4,a4,0x20
 9f6:	0712                	slli	a4,a4,0x4
 9f8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9fa:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9fe:	00000717          	auipc	a4,0x0
 a02:	16a73523          	sd	a0,362(a4) # b68 <freep>
      return (void*)(p + 1);
 a06:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a0a:	70e2                	ld	ra,56(sp)
 a0c:	7442                	ld	s0,48(sp)
 a0e:	74a2                	ld	s1,40(sp)
 a10:	7902                	ld	s2,32(sp)
 a12:	69e2                	ld	s3,24(sp)
 a14:	6a42                	ld	s4,16(sp)
 a16:	6aa2                	ld	s5,8(sp)
 a18:	6b02                	ld	s6,0(sp)
 a1a:	6121                	addi	sp,sp,64
 a1c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a1e:	6398                	ld	a4,0(a5)
 a20:	e118                	sd	a4,0(a0)
 a22:	bff1                	j	9fe <malloc+0x86>
  hp->s.size = nu;
 a24:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a28:	0541                	addi	a0,a0,16
 a2a:	00000097          	auipc	ra,0x0
 a2e:	ec6080e7          	jalr	-314(ra) # 8f0 <free>
  return freep;
 a32:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a36:	d971                	beqz	a0,a0a <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a38:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a3a:	4798                	lw	a4,8(a5)
 a3c:	fa9776e3          	bgeu	a4,s1,9e8 <malloc+0x70>
    if(p == freep)
 a40:	00093703          	ld	a4,0(s2)
 a44:	853e                	mv	a0,a5
 a46:	fef719e3          	bne	a4,a5,a38 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 a4a:	8552                	mv	a0,s4
 a4c:	00000097          	auipc	ra,0x0
 a50:	b7e080e7          	jalr	-1154(ra) # 5ca <sbrk>
  if(p == (char*)-1)
 a54:	fd5518e3          	bne	a0,s5,a24 <malloc+0xac>
        return 0;
 a58:	4501                	li	a0,0
 a5a:	bf45                	j	a0a <malloc+0x92>

0000000000000a5c <setjmp>:
 a5c:	e100                	sd	s0,0(a0)
 a5e:	e504                	sd	s1,8(a0)
 a60:	01253823          	sd	s2,16(a0)
 a64:	01353c23          	sd	s3,24(a0)
 a68:	03453023          	sd	s4,32(a0)
 a6c:	03553423          	sd	s5,40(a0)
 a70:	03653823          	sd	s6,48(a0)
 a74:	03753c23          	sd	s7,56(a0)
 a78:	05853023          	sd	s8,64(a0)
 a7c:	05953423          	sd	s9,72(a0)
 a80:	05a53823          	sd	s10,80(a0)
 a84:	05b53c23          	sd	s11,88(a0)
 a88:	06153023          	sd	ra,96(a0)
 a8c:	06253423          	sd	sp,104(a0)
 a90:	4501                	li	a0,0
 a92:	8082                	ret

0000000000000a94 <longjmp>:
 a94:	6100                	ld	s0,0(a0)
 a96:	6504                	ld	s1,8(a0)
 a98:	01053903          	ld	s2,16(a0)
 a9c:	01853983          	ld	s3,24(a0)
 aa0:	02053a03          	ld	s4,32(a0)
 aa4:	02853a83          	ld	s5,40(a0)
 aa8:	03053b03          	ld	s6,48(a0)
 aac:	03853b83          	ld	s7,56(a0)
 ab0:	04053c03          	ld	s8,64(a0)
 ab4:	04853c83          	ld	s9,72(a0)
 ab8:	05053d03          	ld	s10,80(a0)
 abc:	05853d83          	ld	s11,88(a0)
 ac0:	06053083          	ld	ra,96(a0)
 ac4:	06853103          	ld	sp,104(a0)
 ac8:	c199                	beqz	a1,ace <longjmp_1>
 aca:	852e                	mv	a0,a1
 acc:	8082                	ret

0000000000000ace <longjmp_1>:
 ace:	4505                	li	a0,1
 ad0:	8082                	ret
