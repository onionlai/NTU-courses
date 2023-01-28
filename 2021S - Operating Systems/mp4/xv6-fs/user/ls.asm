
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
  14:	31c080e7          	jalr	796(ra) # 32c <strlen>
  18:	1502                	slli	a0,a0,0x20
  1a:	9101                	srli	a0,a0,0x20
  1c:	9526                	add	a0,a0,s1
  1e:	02956163          	bltu	a0,s1,40 <fmtname+0x40>
  22:	00054703          	lbu	a4,0(a0)
  26:	02f00793          	li	a5,47
  2a:	00f70b63          	beq	a4,a5,40 <fmtname+0x40>
  2e:	02f00713          	li	a4,47
  32:	157d                	addi	a0,a0,-1
  34:	00956663          	bltu	a0,s1,40 <fmtname+0x40>
  38:	00054783          	lbu	a5,0(a0)
  3c:	fee79be3          	bne	a5,a4,32 <fmtname+0x32>
    ;
  p++;
  40:	00150493          	addi	s1,a0,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  44:	8526                	mv	a0,s1
  46:	00000097          	auipc	ra,0x0
  4a:	2e6080e7          	jalr	742(ra) # 32c <strlen>
  4e:	2501                	sext.w	a0,a0
  50:	47b5                	li	a5,13
  52:	00a7fa63          	bleu	a0,a5,66 <fmtname+0x66>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  56:	8526                	mv	a0,s1
  58:	70a2                	ld	ra,40(sp)
  5a:	7402                	ld	s0,32(sp)
  5c:	64e2                	ld	s1,24(sp)
  5e:	6942                	ld	s2,16(sp)
  60:	69a2                	ld	s3,8(sp)
  62:	6145                	addi	sp,sp,48
  64:	8082                	ret
  memmove(buf, p, strlen(p));
  66:	8526                	mv	a0,s1
  68:	00000097          	auipc	ra,0x0
  6c:	2c4080e7          	jalr	708(ra) # 32c <strlen>
  70:	00001917          	auipc	s2,0x1
  74:	ad890913          	addi	s2,s2,-1320 # b48 <buf.1130>
  78:	0005061b          	sext.w	a2,a0
  7c:	85a6                	mv	a1,s1
  7e:	854a                	mv	a0,s2
  80:	00000097          	auipc	ra,0x0
  84:	42a080e7          	jalr	1066(ra) # 4aa <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  88:	8526                	mv	a0,s1
  8a:	00000097          	auipc	ra,0x0
  8e:	2a2080e7          	jalr	674(ra) # 32c <strlen>
  92:	0005099b          	sext.w	s3,a0
  96:	8526                	mv	a0,s1
  98:	00000097          	auipc	ra,0x0
  9c:	294080e7          	jalr	660(ra) # 32c <strlen>
  a0:	1982                	slli	s3,s3,0x20
  a2:	0209d993          	srli	s3,s3,0x20
  a6:	4639                	li	a2,14
  a8:	9e09                	subw	a2,a2,a0
  aa:	02000593          	li	a1,32
  ae:	01390533          	add	a0,s2,s3
  b2:	00000097          	auipc	ra,0x0
  b6:	2a4080e7          	jalr	676(ra) # 356 <memset>
  return buf;
  ba:	84ca                	mv	s1,s2
  bc:	bf69                	j	56 <fmtname+0x56>

00000000000000be <ls>:

void
ls(char *path)
{
  be:	d9010113          	addi	sp,sp,-624
  c2:	26113423          	sd	ra,616(sp)
  c6:	26813023          	sd	s0,608(sp)
  ca:	24913c23          	sd	s1,600(sp)
  ce:	25213823          	sd	s2,592(sp)
  d2:	25313423          	sd	s3,584(sp)
  d6:	25413023          	sd	s4,576(sp)
  da:	23513c23          	sd	s5,568(sp)
  de:	1c80                	addi	s0,sp,624
  e0:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  e2:	4581                	li	a1,0
  e4:	00000097          	auipc	ra,0x0
  e8:	4c8080e7          	jalr	1224(ra) # 5ac <open>
  ec:	06054f63          	bltz	a0,16a <ls+0xac>
  f0:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  f2:	d9840593          	addi	a1,s0,-616
  f6:	00000097          	auipc	ra,0x0
  fa:	4ce080e7          	jalr	1230(ra) # 5c4 <fstat>
  fe:	08054163          	bltz	a0,180 <ls+0xc2>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
 102:	da041783          	lh	a5,-608(s0)
 106:	0007869b          	sext.w	a3,a5
 10a:	4705                	li	a4,1
 10c:	08e68a63          	beq	a3,a4,1a0 <ls+0xe2>
 110:	4709                	li	a4,2
 112:	02e69663          	bne	a3,a4,13e <ls+0x80>
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
 116:	854a                	mv	a0,s2
 118:	00000097          	auipc	ra,0x0
 11c:	ee8080e7          	jalr	-280(ra) # 0 <fmtname>
 120:	da843703          	ld	a4,-600(s0)
 124:	d9c42683          	lw	a3,-612(s0)
 128:	da041603          	lh	a2,-608(s0)
 12c:	85aa                	mv	a1,a0
 12e:	00001517          	auipc	a0,0x1
 132:	99a50513          	addi	a0,a0,-1638 # ac8 <malloc+0x11c>
 136:	00000097          	auipc	ra,0x0
 13a:	7b6080e7          	jalr	1974(ra) # 8ec <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 13e:	8526                	mv	a0,s1
 140:	00000097          	auipc	ra,0x0
 144:	454080e7          	jalr	1108(ra) # 594 <close>
}
 148:	26813083          	ld	ra,616(sp)
 14c:	26013403          	ld	s0,608(sp)
 150:	25813483          	ld	s1,600(sp)
 154:	25013903          	ld	s2,592(sp)
 158:	24813983          	ld	s3,584(sp)
 15c:	24013a03          	ld	s4,576(sp)
 160:	23813a83          	ld	s5,568(sp)
 164:	27010113          	addi	sp,sp,624
 168:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 16a:	864a                	mv	a2,s2
 16c:	00001597          	auipc	a1,0x1
 170:	92c58593          	addi	a1,a1,-1748 # a98 <malloc+0xec>
 174:	4509                	li	a0,2
 176:	00000097          	auipc	ra,0x0
 17a:	748080e7          	jalr	1864(ra) # 8be <fprintf>
    return;
 17e:	b7e9                	j	148 <ls+0x8a>
    fprintf(2, "ls: cannot stat %s\n", path);
 180:	864a                	mv	a2,s2
 182:	00001597          	auipc	a1,0x1
 186:	92e58593          	addi	a1,a1,-1746 # ab0 <malloc+0x104>
 18a:	4509                	li	a0,2
 18c:	00000097          	auipc	ra,0x0
 190:	732080e7          	jalr	1842(ra) # 8be <fprintf>
    close(fd);
 194:	8526                	mv	a0,s1
 196:	00000097          	auipc	ra,0x0
 19a:	3fe080e7          	jalr	1022(ra) # 594 <close>
    return;
 19e:	b76d                	j	148 <ls+0x8a>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1a0:	854a                	mv	a0,s2
 1a2:	00000097          	auipc	ra,0x0
 1a6:	18a080e7          	jalr	394(ra) # 32c <strlen>
 1aa:	2541                	addiw	a0,a0,16
 1ac:	20000793          	li	a5,512
 1b0:	00a7fb63          	bleu	a0,a5,1c6 <ls+0x108>
      printf("ls: path too long\n");
 1b4:	00001517          	auipc	a0,0x1
 1b8:	92450513          	addi	a0,a0,-1756 # ad8 <malloc+0x12c>
 1bc:	00000097          	auipc	ra,0x0
 1c0:	730080e7          	jalr	1840(ra) # 8ec <printf>
      break;
 1c4:	bfad                	j	13e <ls+0x80>
    strcpy(buf, path);
 1c6:	85ca                	mv	a1,s2
 1c8:	dc040513          	addi	a0,s0,-576
 1cc:	00000097          	auipc	ra,0x0
 1d0:	110080e7          	jalr	272(ra) # 2dc <strcpy>
    p = buf+strlen(buf);
 1d4:	dc040513          	addi	a0,s0,-576
 1d8:	00000097          	auipc	ra,0x0
 1dc:	154080e7          	jalr	340(ra) # 32c <strlen>
 1e0:	1502                	slli	a0,a0,0x20
 1e2:	9101                	srli	a0,a0,0x20
 1e4:	dc040793          	addi	a5,s0,-576
 1e8:	00a78933          	add	s2,a5,a0
    *p++ = '/';
 1ec:	00190993          	addi	s3,s2,1
 1f0:	02f00793          	li	a5,47
 1f4:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 1f8:	00001a17          	auipc	s4,0x1
 1fc:	910a0a13          	addi	s4,s4,-1776 # b08 <malloc+0x15c>
        printf("ls: cannot stat- %s\n", buf);
 200:	00001a97          	auipc	s5,0x1
 204:	8f0a8a93          	addi	s5,s5,-1808 # af0 <malloc+0x144>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 208:	a01d                	j	22e <ls+0x170>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 20a:	dc040513          	addi	a0,s0,-576
 20e:	00000097          	auipc	ra,0x0
 212:	df2080e7          	jalr	-526(ra) # 0 <fmtname>
 216:	da843703          	ld	a4,-600(s0)
 21a:	d9c42683          	lw	a3,-612(s0)
 21e:	da041603          	lh	a2,-608(s0)
 222:	85aa                	mv	a1,a0
 224:	8552                	mv	a0,s4
 226:	00000097          	auipc	ra,0x0
 22a:	6c6080e7          	jalr	1734(ra) # 8ec <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 22e:	4641                	li	a2,16
 230:	db040593          	addi	a1,s0,-592
 234:	8526                	mv	a0,s1
 236:	00000097          	auipc	ra,0x0
 23a:	34e080e7          	jalr	846(ra) # 584 <read>
 23e:	47c1                	li	a5,16
 240:	eef51fe3          	bne	a0,a5,13e <ls+0x80>
      if(de.inum == 0)
 244:	db045783          	lhu	a5,-592(s0)
 248:	d3fd                	beqz	a5,22e <ls+0x170>
      memmove(p, de.name, DIRSIZ);
 24a:	4639                	li	a2,14
 24c:	db240593          	addi	a1,s0,-590
 250:	854e                	mv	a0,s3
 252:	00000097          	auipc	ra,0x0
 256:	258080e7          	jalr	600(ra) # 4aa <memmove>
      p[DIRSIZ] = 0;
 25a:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 25e:	d9840593          	addi	a1,s0,-616
 262:	dc040513          	addi	a0,s0,-576
 266:	00000097          	auipc	ra,0x0
 26a:	1b4080e7          	jalr	436(ra) # 41a <stat>
 26e:	f8055ee3          	bgez	a0,20a <ls+0x14c>
        printf("ls: cannot stat- %s\n", buf);
 272:	dc040593          	addi	a1,s0,-576
 276:	8556                	mv	a0,s5
 278:	00000097          	auipc	ra,0x0
 27c:	674080e7          	jalr	1652(ra) # 8ec <printf>
        continue;
 280:	b77d                	j	22e <ls+0x170>

0000000000000282 <main>:

int
main(int argc, char *argv[])
{
 282:	1101                	addi	sp,sp,-32
 284:	ec06                	sd	ra,24(sp)
 286:	e822                	sd	s0,16(sp)
 288:	e426                	sd	s1,8(sp)
 28a:	e04a                	sd	s2,0(sp)
 28c:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 28e:	4785                	li	a5,1
 290:	02a7d963          	ble	a0,a5,2c2 <main+0x40>
 294:	00858493          	addi	s1,a1,8
 298:	ffe5091b          	addiw	s2,a0,-2
 29c:	1902                	slli	s2,s2,0x20
 29e:	02095913          	srli	s2,s2,0x20
 2a2:	090e                	slli	s2,s2,0x3
 2a4:	05c1                	addi	a1,a1,16
 2a6:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 2a8:	6088                	ld	a0,0(s1)
 2aa:	00000097          	auipc	ra,0x0
 2ae:	e14080e7          	jalr	-492(ra) # be <ls>
 2b2:	04a1                	addi	s1,s1,8
  for(i=1; i<argc; i++)
 2b4:	ff249ae3          	bne	s1,s2,2a8 <main+0x26>
  exit(0);
 2b8:	4501                	li	a0,0
 2ba:	00000097          	auipc	ra,0x0
 2be:	2b2080e7          	jalr	690(ra) # 56c <exit>
    ls(".");
 2c2:	00001517          	auipc	a0,0x1
 2c6:	85650513          	addi	a0,a0,-1962 # b18 <malloc+0x16c>
 2ca:	00000097          	auipc	ra,0x0
 2ce:	df4080e7          	jalr	-524(ra) # be <ls>
    exit(0);
 2d2:	4501                	li	a0,0
 2d4:	00000097          	auipc	ra,0x0
 2d8:	298080e7          	jalr	664(ra) # 56c <exit>

00000000000002dc <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 2dc:	1141                	addi	sp,sp,-16
 2de:	e422                	sd	s0,8(sp)
 2e0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2e2:	87aa                	mv	a5,a0
 2e4:	0585                	addi	a1,a1,1
 2e6:	0785                	addi	a5,a5,1
 2e8:	fff5c703          	lbu	a4,-1(a1)
 2ec:	fee78fa3          	sb	a4,-1(a5)
 2f0:	fb75                	bnez	a4,2e4 <strcpy+0x8>
    ;
  return os;
}
 2f2:	6422                	ld	s0,8(sp)
 2f4:	0141                	addi	sp,sp,16
 2f6:	8082                	ret

00000000000002f8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2f8:	1141                	addi	sp,sp,-16
 2fa:	e422                	sd	s0,8(sp)
 2fc:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2fe:	00054783          	lbu	a5,0(a0)
 302:	cf91                	beqz	a5,31e <strcmp+0x26>
 304:	0005c703          	lbu	a4,0(a1)
 308:	00f71b63          	bne	a4,a5,31e <strcmp+0x26>
    p++, q++;
 30c:	0505                	addi	a0,a0,1
 30e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 310:	00054783          	lbu	a5,0(a0)
 314:	c789                	beqz	a5,31e <strcmp+0x26>
 316:	0005c703          	lbu	a4,0(a1)
 31a:	fef709e3          	beq	a4,a5,30c <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 31e:	0005c503          	lbu	a0,0(a1)
}
 322:	40a7853b          	subw	a0,a5,a0
 326:	6422                	ld	s0,8(sp)
 328:	0141                	addi	sp,sp,16
 32a:	8082                	ret

000000000000032c <strlen>:

uint
strlen(const char *s)
{
 32c:	1141                	addi	sp,sp,-16
 32e:	e422                	sd	s0,8(sp)
 330:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 332:	00054783          	lbu	a5,0(a0)
 336:	cf91                	beqz	a5,352 <strlen+0x26>
 338:	0505                	addi	a0,a0,1
 33a:	87aa                	mv	a5,a0
 33c:	4685                	li	a3,1
 33e:	9e89                	subw	a3,a3,a0
    ;
 340:	00f6853b          	addw	a0,a3,a5
 344:	0785                	addi	a5,a5,1
  for(n = 0; s[n]; n++)
 346:	fff7c703          	lbu	a4,-1(a5)
 34a:	fb7d                	bnez	a4,340 <strlen+0x14>
  return n;
}
 34c:	6422                	ld	s0,8(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret
  for(n = 0; s[n]; n++)
 352:	4501                	li	a0,0
 354:	bfe5                	j	34c <strlen+0x20>

0000000000000356 <memset>:

void*
memset(void *dst, int c, uint n)
{
 356:	1141                	addi	sp,sp,-16
 358:	e422                	sd	s0,8(sp)
 35a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 35c:	ce09                	beqz	a2,376 <memset+0x20>
 35e:	87aa                	mv	a5,a0
 360:	fff6071b          	addiw	a4,a2,-1
 364:	1702                	slli	a4,a4,0x20
 366:	9301                	srli	a4,a4,0x20
 368:	0705                	addi	a4,a4,1
 36a:	972a                	add	a4,a4,a0
    cdst[i] = c;
 36c:	00b78023          	sb	a1,0(a5)
 370:	0785                	addi	a5,a5,1
  for(i = 0; i < n; i++){
 372:	fee79de3          	bne	a5,a4,36c <memset+0x16>
  }
  return dst;
}
 376:	6422                	ld	s0,8(sp)
 378:	0141                	addi	sp,sp,16
 37a:	8082                	ret

000000000000037c <strchr>:

char*
strchr(const char *s, char c)
{
 37c:	1141                	addi	sp,sp,-16
 37e:	e422                	sd	s0,8(sp)
 380:	0800                	addi	s0,sp,16
  for(; *s; s++)
 382:	00054783          	lbu	a5,0(a0)
 386:	cf91                	beqz	a5,3a2 <strchr+0x26>
    if(*s == c)
 388:	00f58a63          	beq	a1,a5,39c <strchr+0x20>
  for(; *s; s++)
 38c:	0505                	addi	a0,a0,1
 38e:	00054783          	lbu	a5,0(a0)
 392:	c781                	beqz	a5,39a <strchr+0x1e>
    if(*s == c)
 394:	feb79ce3          	bne	a5,a1,38c <strchr+0x10>
 398:	a011                	j	39c <strchr+0x20>
      return (char*)s;
  return 0;
 39a:	4501                	li	a0,0
}
 39c:	6422                	ld	s0,8(sp)
 39e:	0141                	addi	sp,sp,16
 3a0:	8082                	ret
  return 0;
 3a2:	4501                	li	a0,0
 3a4:	bfe5                	j	39c <strchr+0x20>

00000000000003a6 <gets>:

char*
gets(char *buf, int max)
{
 3a6:	711d                	addi	sp,sp,-96
 3a8:	ec86                	sd	ra,88(sp)
 3aa:	e8a2                	sd	s0,80(sp)
 3ac:	e4a6                	sd	s1,72(sp)
 3ae:	e0ca                	sd	s2,64(sp)
 3b0:	fc4e                	sd	s3,56(sp)
 3b2:	f852                	sd	s4,48(sp)
 3b4:	f456                	sd	s5,40(sp)
 3b6:	f05a                	sd	s6,32(sp)
 3b8:	ec5e                	sd	s7,24(sp)
 3ba:	1080                	addi	s0,sp,96
 3bc:	8baa                	mv	s7,a0
 3be:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3c0:	892a                	mv	s2,a0
 3c2:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3c4:	4aa9                	li	s5,10
 3c6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3c8:	0019849b          	addiw	s1,s3,1
 3cc:	0344d863          	ble	s4,s1,3fc <gets+0x56>
    cc = read(0, &c, 1);
 3d0:	4605                	li	a2,1
 3d2:	faf40593          	addi	a1,s0,-81
 3d6:	4501                	li	a0,0
 3d8:	00000097          	auipc	ra,0x0
 3dc:	1ac080e7          	jalr	428(ra) # 584 <read>
    if(cc < 1)
 3e0:	00a05e63          	blez	a0,3fc <gets+0x56>
    buf[i++] = c;
 3e4:	faf44783          	lbu	a5,-81(s0)
 3e8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3ec:	01578763          	beq	a5,s5,3fa <gets+0x54>
 3f0:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
 3f2:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
 3f4:	fd679ae3          	bne	a5,s6,3c8 <gets+0x22>
 3f8:	a011                	j	3fc <gets+0x56>
  for(i=0; i+1 < max; ){
 3fa:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3fc:	99de                	add	s3,s3,s7
 3fe:	00098023          	sb	zero,0(s3)
  return buf;
}
 402:	855e                	mv	a0,s7
 404:	60e6                	ld	ra,88(sp)
 406:	6446                	ld	s0,80(sp)
 408:	64a6                	ld	s1,72(sp)
 40a:	6906                	ld	s2,64(sp)
 40c:	79e2                	ld	s3,56(sp)
 40e:	7a42                	ld	s4,48(sp)
 410:	7aa2                	ld	s5,40(sp)
 412:	7b02                	ld	s6,32(sp)
 414:	6be2                	ld	s7,24(sp)
 416:	6125                	addi	sp,sp,96
 418:	8082                	ret

000000000000041a <stat>:

int
stat(const char *n, struct stat *st)
{
 41a:	1101                	addi	sp,sp,-32
 41c:	ec06                	sd	ra,24(sp)
 41e:	e822                	sd	s0,16(sp)
 420:	e426                	sd	s1,8(sp)
 422:	e04a                	sd	s2,0(sp)
 424:	1000                	addi	s0,sp,32
 426:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY|O_NOFOLLOW);
 428:	4591                	li	a1,4
 42a:	00000097          	auipc	ra,0x0
 42e:	182080e7          	jalr	386(ra) # 5ac <open>
  if(fd < 0)
 432:	02054563          	bltz	a0,45c <stat+0x42>
 436:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 438:	85ca                	mv	a1,s2
 43a:	00000097          	auipc	ra,0x0
 43e:	18a080e7          	jalr	394(ra) # 5c4 <fstat>
 442:	892a                	mv	s2,a0
  close(fd);
 444:	8526                	mv	a0,s1
 446:	00000097          	auipc	ra,0x0
 44a:	14e080e7          	jalr	334(ra) # 594 <close>
  return r;
}
 44e:	854a                	mv	a0,s2
 450:	60e2                	ld	ra,24(sp)
 452:	6442                	ld	s0,16(sp)
 454:	64a2                	ld	s1,8(sp)
 456:	6902                	ld	s2,0(sp)
 458:	6105                	addi	sp,sp,32
 45a:	8082                	ret
    return -1;
 45c:	597d                	li	s2,-1
 45e:	bfc5                	j	44e <stat+0x34>

0000000000000460 <atoi>:

int
atoi(const char *s)
{
 460:	1141                	addi	sp,sp,-16
 462:	e422                	sd	s0,8(sp)
 464:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 466:	00054683          	lbu	a3,0(a0)
 46a:	fd06879b          	addiw	a5,a3,-48
 46e:	0ff7f793          	andi	a5,a5,255
 472:	4725                	li	a4,9
 474:	02f76963          	bltu	a4,a5,4a6 <atoi+0x46>
 478:	862a                	mv	a2,a0
  n = 0;
 47a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 47c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 47e:	0605                	addi	a2,a2,1
 480:	0025179b          	slliw	a5,a0,0x2
 484:	9fa9                	addw	a5,a5,a0
 486:	0017979b          	slliw	a5,a5,0x1
 48a:	9fb5                	addw	a5,a5,a3
 48c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 490:	00064683          	lbu	a3,0(a2)
 494:	fd06871b          	addiw	a4,a3,-48
 498:	0ff77713          	andi	a4,a4,255
 49c:	fee5f1e3          	bleu	a4,a1,47e <atoi+0x1e>
  return n;
}
 4a0:	6422                	ld	s0,8(sp)
 4a2:	0141                	addi	sp,sp,16
 4a4:	8082                	ret
  n = 0;
 4a6:	4501                	li	a0,0
 4a8:	bfe5                	j	4a0 <atoi+0x40>

00000000000004aa <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4aa:	1141                	addi	sp,sp,-16
 4ac:	e422                	sd	s0,8(sp)
 4ae:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4b0:	02b57663          	bleu	a1,a0,4dc <memmove+0x32>
    while(n-- > 0)
 4b4:	02c05163          	blez	a2,4d6 <memmove+0x2c>
 4b8:	fff6079b          	addiw	a5,a2,-1
 4bc:	1782                	slli	a5,a5,0x20
 4be:	9381                	srli	a5,a5,0x20
 4c0:	0785                	addi	a5,a5,1
 4c2:	97aa                	add	a5,a5,a0
  dst = vdst;
 4c4:	872a                	mv	a4,a0
      *dst++ = *src++;
 4c6:	0585                	addi	a1,a1,1
 4c8:	0705                	addi	a4,a4,1
 4ca:	fff5c683          	lbu	a3,-1(a1)
 4ce:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4d2:	fee79ae3          	bne	a5,a4,4c6 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4d6:	6422                	ld	s0,8(sp)
 4d8:	0141                	addi	sp,sp,16
 4da:	8082                	ret
    dst += n;
 4dc:	00c50733          	add	a4,a0,a2
    src += n;
 4e0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4e2:	fec05ae3          	blez	a2,4d6 <memmove+0x2c>
 4e6:	fff6079b          	addiw	a5,a2,-1
 4ea:	1782                	slli	a5,a5,0x20
 4ec:	9381                	srli	a5,a5,0x20
 4ee:	fff7c793          	not	a5,a5
 4f2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4f4:	15fd                	addi	a1,a1,-1
 4f6:	177d                	addi	a4,a4,-1
 4f8:	0005c683          	lbu	a3,0(a1)
 4fc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 500:	fef71ae3          	bne	a4,a5,4f4 <memmove+0x4a>
 504:	bfc9                	j	4d6 <memmove+0x2c>

0000000000000506 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 506:	1141                	addi	sp,sp,-16
 508:	e422                	sd	s0,8(sp)
 50a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 50c:	ce15                	beqz	a2,548 <memcmp+0x42>
 50e:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
 512:	00054783          	lbu	a5,0(a0)
 516:	0005c703          	lbu	a4,0(a1)
 51a:	02e79063          	bne	a5,a4,53a <memcmp+0x34>
 51e:	1682                	slli	a3,a3,0x20
 520:	9281                	srli	a3,a3,0x20
 522:	0685                	addi	a3,a3,1
 524:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
 526:	0505                	addi	a0,a0,1
    p2++;
 528:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 52a:	00d50d63          	beq	a0,a3,544 <memcmp+0x3e>
    if (*p1 != *p2) {
 52e:	00054783          	lbu	a5,0(a0)
 532:	0005c703          	lbu	a4,0(a1)
 536:	fee788e3          	beq	a5,a4,526 <memcmp+0x20>
      return *p1 - *p2;
 53a:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
 53e:	6422                	ld	s0,8(sp)
 540:	0141                	addi	sp,sp,16
 542:	8082                	ret
  return 0;
 544:	4501                	li	a0,0
 546:	bfe5                	j	53e <memcmp+0x38>
 548:	4501                	li	a0,0
 54a:	bfd5                	j	53e <memcmp+0x38>

000000000000054c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 54c:	1141                	addi	sp,sp,-16
 54e:	e406                	sd	ra,8(sp)
 550:	e022                	sd	s0,0(sp)
 552:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 554:	00000097          	auipc	ra,0x0
 558:	f56080e7          	jalr	-170(ra) # 4aa <memmove>
}
 55c:	60a2                	ld	ra,8(sp)
 55e:	6402                	ld	s0,0(sp)
 560:	0141                	addi	sp,sp,16
 562:	8082                	ret

0000000000000564 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 564:	4885                	li	a7,1
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <exit>:
.global exit
exit:
 li a7, SYS_exit
 56c:	4889                	li	a7,2
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <wait>:
.global wait
wait:
 li a7, SYS_wait
 574:	488d                	li	a7,3
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 57c:	4891                	li	a7,4
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <read>:
.global read
read:
 li a7, SYS_read
 584:	4895                	li	a7,5
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <write>:
.global write
write:
 li a7, SYS_write
 58c:	48c1                	li	a7,16
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <close>:
.global close
close:
 li a7, SYS_close
 594:	48d5                	li	a7,21
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <kill>:
.global kill
kill:
 li a7, SYS_kill
 59c:	4899                	li	a7,6
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5a4:	489d                	li	a7,7
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <open>:
.global open
open:
 li a7, SYS_open
 5ac:	48bd                	li	a7,15
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5b4:	48c5                	li	a7,17
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5bc:	48c9                	li	a7,18
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5c4:	48a1                	li	a7,8
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <link>:
.global link
link:
 li a7, SYS_link
 5cc:	48cd                	li	a7,19
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5d4:	48d1                	li	a7,20
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5dc:	48a5                	li	a7,9
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5e4:	48a9                	li	a7,10
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5ec:	48ad                	li	a7,11
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5f4:	48b1                	li	a7,12
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5fc:	48b5                	li	a7,13
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 604:	48b9                	li	a7,14
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 60c:	48d9                	li	a7,22
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 614:	1101                	addi	sp,sp,-32
 616:	ec06                	sd	ra,24(sp)
 618:	e822                	sd	s0,16(sp)
 61a:	1000                	addi	s0,sp,32
 61c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 620:	4605                	li	a2,1
 622:	fef40593          	addi	a1,s0,-17
 626:	00000097          	auipc	ra,0x0
 62a:	f66080e7          	jalr	-154(ra) # 58c <write>
}
 62e:	60e2                	ld	ra,24(sp)
 630:	6442                	ld	s0,16(sp)
 632:	6105                	addi	sp,sp,32
 634:	8082                	ret

0000000000000636 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 636:	7139                	addi	sp,sp,-64
 638:	fc06                	sd	ra,56(sp)
 63a:	f822                	sd	s0,48(sp)
 63c:	f426                	sd	s1,40(sp)
 63e:	f04a                	sd	s2,32(sp)
 640:	ec4e                	sd	s3,24(sp)
 642:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 644:	c299                	beqz	a3,64a <printint+0x14>
 646:	0005cd63          	bltz	a1,660 <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 64a:	2581                	sext.w	a1,a1
  neg = 0;
 64c:	4301                	li	t1,0
 64e:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
 652:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
 654:	2601                	sext.w	a2,a2
 656:	00000897          	auipc	a7,0x0
 65a:	4ca88893          	addi	a7,a7,1226 # b20 <digits>
 65e:	a801                	j	66e <printint+0x38>
    x = -xx;
 660:	40b005bb          	negw	a1,a1
 664:	2581                	sext.w	a1,a1
    neg = 1;
 666:	4305                	li	t1,1
    x = -xx;
 668:	b7dd                	j	64e <printint+0x18>
  }while((x /= base) != 0);
 66a:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
 66c:	8836                	mv	a6,a3
 66e:	0018069b          	addiw	a3,a6,1
 672:	02c5f7bb          	remuw	a5,a1,a2
 676:	1782                	slli	a5,a5,0x20
 678:	9381                	srli	a5,a5,0x20
 67a:	97c6                	add	a5,a5,a7
 67c:	0007c783          	lbu	a5,0(a5)
 680:	00f70023          	sb	a5,0(a4)
 684:	0705                	addi	a4,a4,1
  }while((x /= base) != 0);
 686:	02c5d7bb          	divuw	a5,a1,a2
 68a:	fec5f0e3          	bleu	a2,a1,66a <printint+0x34>
  if(neg)
 68e:	00030b63          	beqz	t1,6a4 <printint+0x6e>
    buf[i++] = '-';
 692:	fd040793          	addi	a5,s0,-48
 696:	96be                	add	a3,a3,a5
 698:	02d00793          	li	a5,45
 69c:	fef68823          	sb	a5,-16(a3)
 6a0:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
 6a4:	02d05963          	blez	a3,6d6 <printint+0xa0>
 6a8:	89aa                	mv	s3,a0
 6aa:	fc040793          	addi	a5,s0,-64
 6ae:	00d784b3          	add	s1,a5,a3
 6b2:	fff78913          	addi	s2,a5,-1
 6b6:	9936                	add	s2,s2,a3
 6b8:	36fd                	addiw	a3,a3,-1
 6ba:	1682                	slli	a3,a3,0x20
 6bc:	9281                	srli	a3,a3,0x20
 6be:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
 6c2:	fff4c583          	lbu	a1,-1(s1)
 6c6:	854e                	mv	a0,s3
 6c8:	00000097          	auipc	ra,0x0
 6cc:	f4c080e7          	jalr	-180(ra) # 614 <putc>
 6d0:	14fd                	addi	s1,s1,-1
  while(--i >= 0)
 6d2:	ff2498e3          	bne	s1,s2,6c2 <printint+0x8c>
}
 6d6:	70e2                	ld	ra,56(sp)
 6d8:	7442                	ld	s0,48(sp)
 6da:	74a2                	ld	s1,40(sp)
 6dc:	7902                	ld	s2,32(sp)
 6de:	69e2                	ld	s3,24(sp)
 6e0:	6121                	addi	sp,sp,64
 6e2:	8082                	ret

00000000000006e4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6e4:	7119                	addi	sp,sp,-128
 6e6:	fc86                	sd	ra,120(sp)
 6e8:	f8a2                	sd	s0,112(sp)
 6ea:	f4a6                	sd	s1,104(sp)
 6ec:	f0ca                	sd	s2,96(sp)
 6ee:	ecce                	sd	s3,88(sp)
 6f0:	e8d2                	sd	s4,80(sp)
 6f2:	e4d6                	sd	s5,72(sp)
 6f4:	e0da                	sd	s6,64(sp)
 6f6:	fc5e                	sd	s7,56(sp)
 6f8:	f862                	sd	s8,48(sp)
 6fa:	f466                	sd	s9,40(sp)
 6fc:	f06a                	sd	s10,32(sp)
 6fe:	ec6e                	sd	s11,24(sp)
 700:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 702:	0005c483          	lbu	s1,0(a1)
 706:	18048d63          	beqz	s1,8a0 <vprintf+0x1bc>
 70a:	8aaa                	mv	s5,a0
 70c:	8b32                	mv	s6,a2
 70e:	00158913          	addi	s2,a1,1
  state = 0;
 712:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 714:	02500a13          	li	s4,37
      if(c == 'd'){
 718:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 71c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 720:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 724:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 728:	00000b97          	auipc	s7,0x0
 72c:	3f8b8b93          	addi	s7,s7,1016 # b20 <digits>
 730:	a839                	j	74e <vprintf+0x6a>
        putc(fd, c);
 732:	85a6                	mv	a1,s1
 734:	8556                	mv	a0,s5
 736:	00000097          	auipc	ra,0x0
 73a:	ede080e7          	jalr	-290(ra) # 614 <putc>
 73e:	a019                	j	744 <vprintf+0x60>
    } else if(state == '%'){
 740:	01498f63          	beq	s3,s4,75e <vprintf+0x7a>
 744:	0905                	addi	s2,s2,1
  for(i = 0; fmt[i]; i++){
 746:	fff94483          	lbu	s1,-1(s2)
 74a:	14048b63          	beqz	s1,8a0 <vprintf+0x1bc>
    c = fmt[i] & 0xff;
 74e:	0004879b          	sext.w	a5,s1
    if(state == 0){
 752:	fe0997e3          	bnez	s3,740 <vprintf+0x5c>
      if(c == '%'){
 756:	fd479ee3          	bne	a5,s4,732 <vprintf+0x4e>
        state = '%';
 75a:	89be                	mv	s3,a5
 75c:	b7e5                	j	744 <vprintf+0x60>
      if(c == 'd'){
 75e:	05878063          	beq	a5,s8,79e <vprintf+0xba>
      } else if(c == 'l') {
 762:	05978c63          	beq	a5,s9,7ba <vprintf+0xd6>
      } else if(c == 'x') {
 766:	07a78863          	beq	a5,s10,7d6 <vprintf+0xf2>
      } else if(c == 'p') {
 76a:	09b78463          	beq	a5,s11,7f2 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 76e:	07300713          	li	a4,115
 772:	0ce78563          	beq	a5,a4,83c <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 776:	06300713          	li	a4,99
 77a:	0ee78c63          	beq	a5,a4,872 <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 77e:	11478663          	beq	a5,s4,88a <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 782:	85d2                	mv	a1,s4
 784:	8556                	mv	a0,s5
 786:	00000097          	auipc	ra,0x0
 78a:	e8e080e7          	jalr	-370(ra) # 614 <putc>
        putc(fd, c);
 78e:	85a6                	mv	a1,s1
 790:	8556                	mv	a0,s5
 792:	00000097          	auipc	ra,0x0
 796:	e82080e7          	jalr	-382(ra) # 614 <putc>
      }
      state = 0;
 79a:	4981                	li	s3,0
 79c:	b765                	j	744 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 79e:	008b0493          	addi	s1,s6,8
 7a2:	4685                	li	a3,1
 7a4:	4629                	li	a2,10
 7a6:	000b2583          	lw	a1,0(s6)
 7aa:	8556                	mv	a0,s5
 7ac:	00000097          	auipc	ra,0x0
 7b0:	e8a080e7          	jalr	-374(ra) # 636 <printint>
 7b4:	8b26                	mv	s6,s1
      state = 0;
 7b6:	4981                	li	s3,0
 7b8:	b771                	j	744 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ba:	008b0493          	addi	s1,s6,8
 7be:	4681                	li	a3,0
 7c0:	4629                	li	a2,10
 7c2:	000b2583          	lw	a1,0(s6)
 7c6:	8556                	mv	a0,s5
 7c8:	00000097          	auipc	ra,0x0
 7cc:	e6e080e7          	jalr	-402(ra) # 636 <printint>
 7d0:	8b26                	mv	s6,s1
      state = 0;
 7d2:	4981                	li	s3,0
 7d4:	bf85                	j	744 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7d6:	008b0493          	addi	s1,s6,8
 7da:	4681                	li	a3,0
 7dc:	4641                	li	a2,16
 7de:	000b2583          	lw	a1,0(s6)
 7e2:	8556                	mv	a0,s5
 7e4:	00000097          	auipc	ra,0x0
 7e8:	e52080e7          	jalr	-430(ra) # 636 <printint>
 7ec:	8b26                	mv	s6,s1
      state = 0;
 7ee:	4981                	li	s3,0
 7f0:	bf91                	j	744 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7f2:	008b0793          	addi	a5,s6,8
 7f6:	f8f43423          	sd	a5,-120(s0)
 7fa:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7fe:	03000593          	li	a1,48
 802:	8556                	mv	a0,s5
 804:	00000097          	auipc	ra,0x0
 808:	e10080e7          	jalr	-496(ra) # 614 <putc>
  putc(fd, 'x');
 80c:	85ea                	mv	a1,s10
 80e:	8556                	mv	a0,s5
 810:	00000097          	auipc	ra,0x0
 814:	e04080e7          	jalr	-508(ra) # 614 <putc>
 818:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 81a:	03c9d793          	srli	a5,s3,0x3c
 81e:	97de                	add	a5,a5,s7
 820:	0007c583          	lbu	a1,0(a5)
 824:	8556                	mv	a0,s5
 826:	00000097          	auipc	ra,0x0
 82a:	dee080e7          	jalr	-530(ra) # 614 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 82e:	0992                	slli	s3,s3,0x4
 830:	34fd                	addiw	s1,s1,-1
 832:	f4e5                	bnez	s1,81a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 834:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 838:	4981                	li	s3,0
 83a:	b729                	j	744 <vprintf+0x60>
        s = va_arg(ap, char*);
 83c:	008b0993          	addi	s3,s6,8
 840:	000b3483          	ld	s1,0(s6)
        if(s == 0)
 844:	c085                	beqz	s1,864 <vprintf+0x180>
        while(*s != 0){
 846:	0004c583          	lbu	a1,0(s1)
 84a:	c9a1                	beqz	a1,89a <vprintf+0x1b6>
          putc(fd, *s);
 84c:	8556                	mv	a0,s5
 84e:	00000097          	auipc	ra,0x0
 852:	dc6080e7          	jalr	-570(ra) # 614 <putc>
          s++;
 856:	0485                	addi	s1,s1,1
        while(*s != 0){
 858:	0004c583          	lbu	a1,0(s1)
 85c:	f9e5                	bnez	a1,84c <vprintf+0x168>
        s = va_arg(ap, char*);
 85e:	8b4e                	mv	s6,s3
      state = 0;
 860:	4981                	li	s3,0
 862:	b5cd                	j	744 <vprintf+0x60>
          s = "(null)";
 864:	00000497          	auipc	s1,0x0
 868:	2d448493          	addi	s1,s1,724 # b38 <digits+0x18>
        while(*s != 0){
 86c:	02800593          	li	a1,40
 870:	bff1                	j	84c <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
 872:	008b0493          	addi	s1,s6,8
 876:	000b4583          	lbu	a1,0(s6)
 87a:	8556                	mv	a0,s5
 87c:	00000097          	auipc	ra,0x0
 880:	d98080e7          	jalr	-616(ra) # 614 <putc>
 884:	8b26                	mv	s6,s1
      state = 0;
 886:	4981                	li	s3,0
 888:	bd75                	j	744 <vprintf+0x60>
        putc(fd, c);
 88a:	85d2                	mv	a1,s4
 88c:	8556                	mv	a0,s5
 88e:	00000097          	auipc	ra,0x0
 892:	d86080e7          	jalr	-634(ra) # 614 <putc>
      state = 0;
 896:	4981                	li	s3,0
 898:	b575                	j	744 <vprintf+0x60>
        s = va_arg(ap, char*);
 89a:	8b4e                	mv	s6,s3
      state = 0;
 89c:	4981                	li	s3,0
 89e:	b55d                	j	744 <vprintf+0x60>
    }
  }
}
 8a0:	70e6                	ld	ra,120(sp)
 8a2:	7446                	ld	s0,112(sp)
 8a4:	74a6                	ld	s1,104(sp)
 8a6:	7906                	ld	s2,96(sp)
 8a8:	69e6                	ld	s3,88(sp)
 8aa:	6a46                	ld	s4,80(sp)
 8ac:	6aa6                	ld	s5,72(sp)
 8ae:	6b06                	ld	s6,64(sp)
 8b0:	7be2                	ld	s7,56(sp)
 8b2:	7c42                	ld	s8,48(sp)
 8b4:	7ca2                	ld	s9,40(sp)
 8b6:	7d02                	ld	s10,32(sp)
 8b8:	6de2                	ld	s11,24(sp)
 8ba:	6109                	addi	sp,sp,128
 8bc:	8082                	ret

00000000000008be <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8be:	715d                	addi	sp,sp,-80
 8c0:	ec06                	sd	ra,24(sp)
 8c2:	e822                	sd	s0,16(sp)
 8c4:	1000                	addi	s0,sp,32
 8c6:	e010                	sd	a2,0(s0)
 8c8:	e414                	sd	a3,8(s0)
 8ca:	e818                	sd	a4,16(s0)
 8cc:	ec1c                	sd	a5,24(s0)
 8ce:	03043023          	sd	a6,32(s0)
 8d2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8d6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8da:	8622                	mv	a2,s0
 8dc:	00000097          	auipc	ra,0x0
 8e0:	e08080e7          	jalr	-504(ra) # 6e4 <vprintf>
}
 8e4:	60e2                	ld	ra,24(sp)
 8e6:	6442                	ld	s0,16(sp)
 8e8:	6161                	addi	sp,sp,80
 8ea:	8082                	ret

00000000000008ec <printf>:

void
printf(const char *fmt, ...)
{
 8ec:	711d                	addi	sp,sp,-96
 8ee:	ec06                	sd	ra,24(sp)
 8f0:	e822                	sd	s0,16(sp)
 8f2:	1000                	addi	s0,sp,32
 8f4:	e40c                	sd	a1,8(s0)
 8f6:	e810                	sd	a2,16(s0)
 8f8:	ec14                	sd	a3,24(s0)
 8fa:	f018                	sd	a4,32(s0)
 8fc:	f41c                	sd	a5,40(s0)
 8fe:	03043823          	sd	a6,48(s0)
 902:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 906:	00840613          	addi	a2,s0,8
 90a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 90e:	85aa                	mv	a1,a0
 910:	4505                	li	a0,1
 912:	00000097          	auipc	ra,0x0
 916:	dd2080e7          	jalr	-558(ra) # 6e4 <vprintf>
}
 91a:	60e2                	ld	ra,24(sp)
 91c:	6442                	ld	s0,16(sp)
 91e:	6125                	addi	sp,sp,96
 920:	8082                	ret

0000000000000922 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 922:	1141                	addi	sp,sp,-16
 924:	e422                	sd	s0,8(sp)
 926:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 928:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 92c:	00000797          	auipc	a5,0x0
 930:	21478793          	addi	a5,a5,532 # b40 <__bss_start>
 934:	639c                	ld	a5,0(a5)
 936:	a805                	j	966 <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 938:	4618                	lw	a4,8(a2)
 93a:	9db9                	addw	a1,a1,a4
 93c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 940:	6398                	ld	a4,0(a5)
 942:	6318                	ld	a4,0(a4)
 944:	fee53823          	sd	a4,-16(a0)
 948:	a091                	j	98c <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 94a:	ff852703          	lw	a4,-8(a0)
 94e:	9e39                	addw	a2,a2,a4
 950:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 952:	ff053703          	ld	a4,-16(a0)
 956:	e398                	sd	a4,0(a5)
 958:	a099                	j	99e <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 95a:	6398                	ld	a4,0(a5)
 95c:	00e7e463          	bltu	a5,a4,964 <free+0x42>
 960:	00e6ea63          	bltu	a3,a4,974 <free+0x52>
{
 964:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 966:	fed7fae3          	bleu	a3,a5,95a <free+0x38>
 96a:	6398                	ld	a4,0(a5)
 96c:	00e6e463          	bltu	a3,a4,974 <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 970:	fee7eae3          	bltu	a5,a4,964 <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
 974:	ff852583          	lw	a1,-8(a0)
 978:	6390                	ld	a2,0(a5)
 97a:	02059713          	slli	a4,a1,0x20
 97e:	9301                	srli	a4,a4,0x20
 980:	0712                	slli	a4,a4,0x4
 982:	9736                	add	a4,a4,a3
 984:	fae60ae3          	beq	a2,a4,938 <free+0x16>
    bp->s.ptr = p->s.ptr;
 988:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 98c:	4790                	lw	a2,8(a5)
 98e:	02061713          	slli	a4,a2,0x20
 992:	9301                	srli	a4,a4,0x20
 994:	0712                	slli	a4,a4,0x4
 996:	973e                	add	a4,a4,a5
 998:	fae689e3          	beq	a3,a4,94a <free+0x28>
  } else
    p->s.ptr = bp;
 99c:	e394                	sd	a3,0(a5)
  freep = p;
 99e:	00000717          	auipc	a4,0x0
 9a2:	1af73123          	sd	a5,418(a4) # b40 <__bss_start>
}
 9a6:	6422                	ld	s0,8(sp)
 9a8:	0141                	addi	sp,sp,16
 9aa:	8082                	ret

00000000000009ac <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9ac:	7139                	addi	sp,sp,-64
 9ae:	fc06                	sd	ra,56(sp)
 9b0:	f822                	sd	s0,48(sp)
 9b2:	f426                	sd	s1,40(sp)
 9b4:	f04a                	sd	s2,32(sp)
 9b6:	ec4e                	sd	s3,24(sp)
 9b8:	e852                	sd	s4,16(sp)
 9ba:	e456                	sd	s5,8(sp)
 9bc:	e05a                	sd	s6,0(sp)
 9be:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9c0:	02051993          	slli	s3,a0,0x20
 9c4:	0209d993          	srli	s3,s3,0x20
 9c8:	09bd                	addi	s3,s3,15
 9ca:	0049d993          	srli	s3,s3,0x4
 9ce:	2985                	addiw	s3,s3,1
 9d0:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
 9d4:	00000797          	auipc	a5,0x0
 9d8:	16c78793          	addi	a5,a5,364 # b40 <__bss_start>
 9dc:	6388                	ld	a0,0(a5)
 9de:	c515                	beqz	a0,a0a <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9e2:	4798                	lw	a4,8(a5)
 9e4:	03277f63          	bleu	s2,a4,a22 <malloc+0x76>
 9e8:	8a4e                	mv	s4,s3
 9ea:	0009871b          	sext.w	a4,s3
 9ee:	6685                	lui	a3,0x1
 9f0:	00d77363          	bleu	a3,a4,9f6 <malloc+0x4a>
 9f4:	6a05                	lui	s4,0x1
 9f6:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
 9fa:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9fe:	00000497          	auipc	s1,0x0
 a02:	14248493          	addi	s1,s1,322 # b40 <__bss_start>
  if(p == (char*)-1)
 a06:	5b7d                	li	s6,-1
 a08:	a885                	j	a78 <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
 a0a:	00000797          	auipc	a5,0x0
 a0e:	14e78793          	addi	a5,a5,334 # b58 <base>
 a12:	00000717          	auipc	a4,0x0
 a16:	12f73723          	sd	a5,302(a4) # b40 <__bss_start>
 a1a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a1c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a20:	b7e1                	j	9e8 <malloc+0x3c>
      if(p->s.size == nunits)
 a22:	02e90b63          	beq	s2,a4,a58 <malloc+0xac>
        p->s.size -= nunits;
 a26:	4137073b          	subw	a4,a4,s3
 a2a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a2c:	1702                	slli	a4,a4,0x20
 a2e:	9301                	srli	a4,a4,0x20
 a30:	0712                	slli	a4,a4,0x4
 a32:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a34:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a38:	00000717          	auipc	a4,0x0
 a3c:	10a73423          	sd	a0,264(a4) # b40 <__bss_start>
      return (void*)(p + 1);
 a40:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a44:	70e2                	ld	ra,56(sp)
 a46:	7442                	ld	s0,48(sp)
 a48:	74a2                	ld	s1,40(sp)
 a4a:	7902                	ld	s2,32(sp)
 a4c:	69e2                	ld	s3,24(sp)
 a4e:	6a42                	ld	s4,16(sp)
 a50:	6aa2                	ld	s5,8(sp)
 a52:	6b02                	ld	s6,0(sp)
 a54:	6121                	addi	sp,sp,64
 a56:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a58:	6398                	ld	a4,0(a5)
 a5a:	e118                	sd	a4,0(a0)
 a5c:	bff1                	j	a38 <malloc+0x8c>
  hp->s.size = nu;
 a5e:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
 a62:	0541                	addi	a0,a0,16
 a64:	00000097          	auipc	ra,0x0
 a68:	ebe080e7          	jalr	-322(ra) # 922 <free>
  return freep;
 a6c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a6e:	d979                	beqz	a0,a44 <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a70:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a72:	4798                	lw	a4,8(a5)
 a74:	fb2777e3          	bleu	s2,a4,a22 <malloc+0x76>
    if(p == freep)
 a78:	6098                	ld	a4,0(s1)
 a7a:	853e                	mv	a0,a5
 a7c:	fef71ae3          	bne	a4,a5,a70 <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
 a80:	8552                	mv	a0,s4
 a82:	00000097          	auipc	ra,0x0
 a86:	b72080e7          	jalr	-1166(ra) # 5f4 <sbrk>
  if(p == (char*)-1)
 a8a:	fd651ae3          	bne	a0,s6,a5e <malloc+0xb2>
        return 0;
 a8e:	4501                	li	a0,0
 a90:	bf55                	j	a44 <malloc+0x98>
