
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	00000097          	auipc	ra,0x0
  22:	030080e7          	jalr	48(ra) # 4e <matchhere>
  26:	e919                	bnez	a0,3c <matchstar+0x3c>
  }while(*text!='\0' && (*text++==c || c=='.'));
  28:	0004c783          	lbu	a5,0(s1)
  2c:	cb89                	beqz	a5,3e <matchstar+0x3e>
  2e:	0485                	addi	s1,s1,1
  30:	2781                	sext.w	a5,a5
  32:	ff2784e3          	beq	a5,s2,1a <matchstar+0x1a>
  36:	ff4902e3          	beq	s2,s4,1a <matchstar+0x1a>
  3a:	a011                	j	3e <matchstar+0x3e>
      return 1;
  3c:	4505                	li	a0,1
  return 0;
}
  3e:	70a2                	ld	ra,40(sp)
  40:	7402                	ld	s0,32(sp)
  42:	64e2                	ld	s1,24(sp)
  44:	6942                	ld	s2,16(sp)
  46:	69a2                	ld	s3,8(sp)
  48:	6a02                	ld	s4,0(sp)
  4a:	6145                	addi	sp,sp,48
  4c:	8082                	ret

000000000000004e <matchhere>:
  if(re[0] == '\0')
  4e:	00054703          	lbu	a4,0(a0)
  52:	cb3d                	beqz	a4,c8 <matchhere+0x7a>
{
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  5c:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5e:	00154683          	lbu	a3,1(a0)
  62:	02a00613          	li	a2,42
  66:	02c68563          	beq	a3,a2,90 <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  6a:	02400613          	li	a2,36
  6e:	02c70a63          	beq	a4,a2,a2 <matchhere+0x54>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  72:	0005c683          	lbu	a3,0(a1)
  return 0;
  76:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  78:	ca81                	beqz	a3,88 <matchhere+0x3a>
  7a:	02e00613          	li	a2,46
  7e:	02c70d63          	beq	a4,a2,b8 <matchhere+0x6a>
  return 0;
  82:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  84:	02d70a63          	beq	a4,a3,b8 <matchhere+0x6a>
}
  88:	60a2                	ld	ra,8(sp)
  8a:	6402                	ld	s0,0(sp)
  8c:	0141                	addi	sp,sp,16
  8e:	8082                	ret
    return matchstar(re[0], re+2, text);
  90:	862e                	mv	a2,a1
  92:	00250593          	addi	a1,a0,2
  96:	853a                	mv	a0,a4
  98:	00000097          	auipc	ra,0x0
  9c:	f68080e7          	jalr	-152(ra) # 0 <matchstar>
  a0:	b7e5                	j	88 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  a2:	c691                	beqz	a3,ae <matchhere+0x60>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  a4:	0005c683          	lbu	a3,0(a1)
  a8:	fee9                	bnez	a3,82 <matchhere+0x34>
  return 0;
  aa:	4501                	li	a0,0
  ac:	bff1                	j	88 <matchhere+0x3a>
    return *text == '\0';
  ae:	0005c503          	lbu	a0,0(a1)
  b2:	00153513          	seqz	a0,a0
  b6:	bfc9                	j	88 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b8:	0585                	addi	a1,a1,1
  ba:	00178513          	addi	a0,a5,1
  be:	00000097          	auipc	ra,0x0
  c2:	f90080e7          	jalr	-112(ra) # 4e <matchhere>
  c6:	b7c9                	j	88 <matchhere+0x3a>
    return 1;
  c8:	4505                	li	a0,1
}
  ca:	8082                	ret

00000000000000cc <match>:
{
  cc:	1101                	addi	sp,sp,-32
  ce:	ec06                	sd	ra,24(sp)
  d0:	e822                	sd	s0,16(sp)
  d2:	e426                	sd	s1,8(sp)
  d4:	e04a                	sd	s2,0(sp)
  d6:	1000                	addi	s0,sp,32
  d8:	892a                	mv	s2,a0
  da:	84ae                	mv	s1,a1
  if(re[0] == '^')
  dc:	00054703          	lbu	a4,0(a0)
  e0:	05e00793          	li	a5,94
  e4:	00f70e63          	beq	a4,a5,100 <match+0x34>
    if(matchhere(re, text))
  e8:	85a6                	mv	a1,s1
  ea:	854a                	mv	a0,s2
  ec:	00000097          	auipc	ra,0x0
  f0:	f62080e7          	jalr	-158(ra) # 4e <matchhere>
  f4:	ed01                	bnez	a0,10c <match+0x40>
  }while(*text++ != '\0');
  f6:	0485                	addi	s1,s1,1
  f8:	fff4c783          	lbu	a5,-1(s1)
  fc:	f7f5                	bnez	a5,e8 <match+0x1c>
  fe:	a801                	j	10e <match+0x42>
    return matchhere(re+1, text);
 100:	0505                	addi	a0,a0,1
 102:	00000097          	auipc	ra,0x0
 106:	f4c080e7          	jalr	-180(ra) # 4e <matchhere>
 10a:	a011                	j	10e <match+0x42>
      return 1;
 10c:	4505                	li	a0,1
}
 10e:	60e2                	ld	ra,24(sp)
 110:	6442                	ld	s0,16(sp)
 112:	64a2                	ld	s1,8(sp)
 114:	6902                	ld	s2,0(sp)
 116:	6105                	addi	sp,sp,32
 118:	8082                	ret

000000000000011a <grep>:
{
 11a:	711d                	addi	sp,sp,-96
 11c:	ec86                	sd	ra,88(sp)
 11e:	e8a2                	sd	s0,80(sp)
 120:	e4a6                	sd	s1,72(sp)
 122:	e0ca                	sd	s2,64(sp)
 124:	fc4e                	sd	s3,56(sp)
 126:	f852                	sd	s4,48(sp)
 128:	f456                	sd	s5,40(sp)
 12a:	f05a                	sd	s6,32(sp)
 12c:	ec5e                	sd	s7,24(sp)
 12e:	e862                	sd	s8,16(sp)
 130:	e466                	sd	s9,8(sp)
 132:	e06a                	sd	s10,0(sp)
 134:	1080                	addi	s0,sp,96
 136:	89aa                	mv	s3,a0
 138:	8c2e                	mv	s8,a1
  m = 0;
 13a:	4a01                	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 13c:	3ff00b93          	li	s7,1023
 140:	00001b17          	auipc	s6,0x1
 144:	980b0b13          	addi	s6,s6,-1664 # ac0 <buf>
    p = buf;
 148:	8d5a                	mv	s10,s6
        *q = '\n';
 14a:	4aa9                	li	s5,10
    p = buf;
 14c:	8cda                	mv	s9,s6
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 14e:	a099                	j	194 <grep+0x7a>
        *q = '\n';
 150:	01548023          	sb	s5,0(s1)
        write(1, p, q+1 - p);
 154:	00148613          	addi	a2,s1,1
 158:	4126063b          	subw	a2,a2,s2
 15c:	85ca                	mv	a1,s2
 15e:	4505                	li	a0,1
 160:	00000097          	auipc	ra,0x0
 164:	3fa080e7          	jalr	1018(ra) # 55a <write>
      p = q+1;
 168:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 16c:	45a9                	li	a1,10
 16e:	854a                	mv	a0,s2
 170:	00000097          	auipc	ra,0x0
 174:	1da080e7          	jalr	474(ra) # 34a <strchr>
 178:	84aa                	mv	s1,a0
 17a:	c919                	beqz	a0,190 <grep+0x76>
      *q = 0;
 17c:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 180:	85ca                	mv	a1,s2
 182:	854e                	mv	a0,s3
 184:	00000097          	auipc	ra,0x0
 188:	f48080e7          	jalr	-184(ra) # cc <match>
 18c:	dd71                	beqz	a0,168 <grep+0x4e>
 18e:	b7c9                	j	150 <grep+0x36>
    if(m > 0){
 190:	03404563          	bgtz	s4,1ba <grep+0xa0>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 194:	414b863b          	subw	a2,s7,s4
 198:	014b05b3          	add	a1,s6,s4
 19c:	8562                	mv	a0,s8
 19e:	00000097          	auipc	ra,0x0
 1a2:	3b4080e7          	jalr	948(ra) # 552 <read>
 1a6:	02a05663          	blez	a0,1d2 <grep+0xb8>
    m += n;
 1aa:	00aa0a3b          	addw	s4,s4,a0
    buf[m] = '\0';
 1ae:	014b07b3          	add	a5,s6,s4
 1b2:	00078023          	sb	zero,0(a5)
    p = buf;
 1b6:	8966                	mv	s2,s9
    while((q = strchr(p, '\n')) != 0){
 1b8:	bf55                	j	16c <grep+0x52>
      m -= p - buf;
 1ba:	416907b3          	sub	a5,s2,s6
 1be:	40fa0a3b          	subw	s4,s4,a5
      memmove(buf, p, m);
 1c2:	8652                	mv	a2,s4
 1c4:	85ca                	mv	a1,s2
 1c6:	856a                	mv	a0,s10
 1c8:	00000097          	auipc	ra,0x0
 1cc:	2b0080e7          	jalr	688(ra) # 478 <memmove>
 1d0:	b7d1                	j	194 <grep+0x7a>
}
 1d2:	60e6                	ld	ra,88(sp)
 1d4:	6446                	ld	s0,80(sp)
 1d6:	64a6                	ld	s1,72(sp)
 1d8:	6906                	ld	s2,64(sp)
 1da:	79e2                	ld	s3,56(sp)
 1dc:	7a42                	ld	s4,48(sp)
 1de:	7aa2                	ld	s5,40(sp)
 1e0:	7b02                	ld	s6,32(sp)
 1e2:	6be2                	ld	s7,24(sp)
 1e4:	6c42                	ld	s8,16(sp)
 1e6:	6ca2                	ld	s9,8(sp)
 1e8:	6d02                	ld	s10,0(sp)
 1ea:	6125                	addi	sp,sp,96
 1ec:	8082                	ret

00000000000001ee <main>:
{
 1ee:	7139                	addi	sp,sp,-64
 1f0:	fc06                	sd	ra,56(sp)
 1f2:	f822                	sd	s0,48(sp)
 1f4:	f426                	sd	s1,40(sp)
 1f6:	f04a                	sd	s2,32(sp)
 1f8:	ec4e                	sd	s3,24(sp)
 1fa:	e852                	sd	s4,16(sp)
 1fc:	e456                	sd	s5,8(sp)
 1fe:	0080                	addi	s0,sp,64
  if(argc <= 1){
 200:	4785                	li	a5,1
 202:	04a7dd63          	ble	a0,a5,25c <main+0x6e>
  pattern = argv[1];
 206:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 20a:	4789                	li	a5,2
 20c:	06a7d663          	ble	a0,a5,278 <main+0x8a>
 210:	01058493          	addi	s1,a1,16
 214:	ffd5099b          	addiw	s3,a0,-3
 218:	1982                	slli	s3,s3,0x20
 21a:	0209d993          	srli	s3,s3,0x20
 21e:	098e                	slli	s3,s3,0x3
 220:	05e1                	addi	a1,a1,24
 222:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], 0)) < 0){
 224:	4581                	li	a1,0
 226:	6088                	ld	a0,0(s1)
 228:	00000097          	auipc	ra,0x0
 22c:	352080e7          	jalr	850(ra) # 57a <open>
 230:	892a                	mv	s2,a0
 232:	04054e63          	bltz	a0,28e <main+0xa0>
    grep(pattern, fd);
 236:	85aa                	mv	a1,a0
 238:	8552                	mv	a0,s4
 23a:	00000097          	auipc	ra,0x0
 23e:	ee0080e7          	jalr	-288(ra) # 11a <grep>
    close(fd);
 242:	854a                	mv	a0,s2
 244:	00000097          	auipc	ra,0x0
 248:	31e080e7          	jalr	798(ra) # 562 <close>
 24c:	04a1                	addi	s1,s1,8
  for(i = 2; i < argc; i++){
 24e:	fd349be3          	bne	s1,s3,224 <main+0x36>
  exit(0);
 252:	4501                	li	a0,0
 254:	00000097          	auipc	ra,0x0
 258:	2e6080e7          	jalr	742(ra) # 53a <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 25c:	00001597          	auipc	a1,0x1
 260:	80458593          	addi	a1,a1,-2044 # a60 <malloc+0xe6>
 264:	4509                	li	a0,2
 266:	00000097          	auipc	ra,0x0
 26a:	626080e7          	jalr	1574(ra) # 88c <fprintf>
    exit(1);
 26e:	4505                	li	a0,1
 270:	00000097          	auipc	ra,0x0
 274:	2ca080e7          	jalr	714(ra) # 53a <exit>
    grep(pattern, 0);
 278:	4581                	li	a1,0
 27a:	8552                	mv	a0,s4
 27c:	00000097          	auipc	ra,0x0
 280:	e9e080e7          	jalr	-354(ra) # 11a <grep>
    exit(0);
 284:	4501                	li	a0,0
 286:	00000097          	auipc	ra,0x0
 28a:	2b4080e7          	jalr	692(ra) # 53a <exit>
      printf("grep: cannot open %s\n", argv[i]);
 28e:	608c                	ld	a1,0(s1)
 290:	00000517          	auipc	a0,0x0
 294:	7f050513          	addi	a0,a0,2032 # a80 <malloc+0x106>
 298:	00000097          	auipc	ra,0x0
 29c:	622080e7          	jalr	1570(ra) # 8ba <printf>
      exit(1);
 2a0:	4505                	li	a0,1
 2a2:	00000097          	auipc	ra,0x0
 2a6:	298080e7          	jalr	664(ra) # 53a <exit>

00000000000002aa <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e422                	sd	s0,8(sp)
 2ae:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2b0:	87aa                	mv	a5,a0
 2b2:	0585                	addi	a1,a1,1
 2b4:	0785                	addi	a5,a5,1
 2b6:	fff5c703          	lbu	a4,-1(a1)
 2ba:	fee78fa3          	sb	a4,-1(a5)
 2be:	fb75                	bnez	a4,2b2 <strcpy+0x8>
    ;
  return os;
}
 2c0:	6422                	ld	s0,8(sp)
 2c2:	0141                	addi	sp,sp,16
 2c4:	8082                	ret

00000000000002c6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2c6:	1141                	addi	sp,sp,-16
 2c8:	e422                	sd	s0,8(sp)
 2ca:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2cc:	00054783          	lbu	a5,0(a0)
 2d0:	cf91                	beqz	a5,2ec <strcmp+0x26>
 2d2:	0005c703          	lbu	a4,0(a1)
 2d6:	00f71b63          	bne	a4,a5,2ec <strcmp+0x26>
    p++, q++;
 2da:	0505                	addi	a0,a0,1
 2dc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2de:	00054783          	lbu	a5,0(a0)
 2e2:	c789                	beqz	a5,2ec <strcmp+0x26>
 2e4:	0005c703          	lbu	a4,0(a1)
 2e8:	fef709e3          	beq	a4,a5,2da <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 2ec:	0005c503          	lbu	a0,0(a1)
}
 2f0:	40a7853b          	subw	a0,a5,a0
 2f4:	6422                	ld	s0,8(sp)
 2f6:	0141                	addi	sp,sp,16
 2f8:	8082                	ret

00000000000002fa <strlen>:

uint
strlen(const char *s)
{
 2fa:	1141                	addi	sp,sp,-16
 2fc:	e422                	sd	s0,8(sp)
 2fe:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 300:	00054783          	lbu	a5,0(a0)
 304:	cf91                	beqz	a5,320 <strlen+0x26>
 306:	0505                	addi	a0,a0,1
 308:	87aa                	mv	a5,a0
 30a:	4685                	li	a3,1
 30c:	9e89                	subw	a3,a3,a0
    ;
 30e:	00f6853b          	addw	a0,a3,a5
 312:	0785                	addi	a5,a5,1
  for(n = 0; s[n]; n++)
 314:	fff7c703          	lbu	a4,-1(a5)
 318:	fb7d                	bnez	a4,30e <strlen+0x14>
  return n;
}
 31a:	6422                	ld	s0,8(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret
  for(n = 0; s[n]; n++)
 320:	4501                	li	a0,0
 322:	bfe5                	j	31a <strlen+0x20>

0000000000000324 <memset>:

void*
memset(void *dst, int c, uint n)
{
 324:	1141                	addi	sp,sp,-16
 326:	e422                	sd	s0,8(sp)
 328:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 32a:	ce09                	beqz	a2,344 <memset+0x20>
 32c:	87aa                	mv	a5,a0
 32e:	fff6071b          	addiw	a4,a2,-1
 332:	1702                	slli	a4,a4,0x20
 334:	9301                	srli	a4,a4,0x20
 336:	0705                	addi	a4,a4,1
 338:	972a                	add	a4,a4,a0
    cdst[i] = c;
 33a:	00b78023          	sb	a1,0(a5)
 33e:	0785                	addi	a5,a5,1
  for(i = 0; i < n; i++){
 340:	fee79de3          	bne	a5,a4,33a <memset+0x16>
  }
  return dst;
}
 344:	6422                	ld	s0,8(sp)
 346:	0141                	addi	sp,sp,16
 348:	8082                	ret

000000000000034a <strchr>:

char*
strchr(const char *s, char c)
{
 34a:	1141                	addi	sp,sp,-16
 34c:	e422                	sd	s0,8(sp)
 34e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 350:	00054783          	lbu	a5,0(a0)
 354:	cf91                	beqz	a5,370 <strchr+0x26>
    if(*s == c)
 356:	00f58a63          	beq	a1,a5,36a <strchr+0x20>
  for(; *s; s++)
 35a:	0505                	addi	a0,a0,1
 35c:	00054783          	lbu	a5,0(a0)
 360:	c781                	beqz	a5,368 <strchr+0x1e>
    if(*s == c)
 362:	feb79ce3          	bne	a5,a1,35a <strchr+0x10>
 366:	a011                	j	36a <strchr+0x20>
      return (char*)s;
  return 0;
 368:	4501                	li	a0,0
}
 36a:	6422                	ld	s0,8(sp)
 36c:	0141                	addi	sp,sp,16
 36e:	8082                	ret
  return 0;
 370:	4501                	li	a0,0
 372:	bfe5                	j	36a <strchr+0x20>

0000000000000374 <gets>:

char*
gets(char *buf, int max)
{
 374:	711d                	addi	sp,sp,-96
 376:	ec86                	sd	ra,88(sp)
 378:	e8a2                	sd	s0,80(sp)
 37a:	e4a6                	sd	s1,72(sp)
 37c:	e0ca                	sd	s2,64(sp)
 37e:	fc4e                	sd	s3,56(sp)
 380:	f852                	sd	s4,48(sp)
 382:	f456                	sd	s5,40(sp)
 384:	f05a                	sd	s6,32(sp)
 386:	ec5e                	sd	s7,24(sp)
 388:	1080                	addi	s0,sp,96
 38a:	8baa                	mv	s7,a0
 38c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 38e:	892a                	mv	s2,a0
 390:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 392:	4aa9                	li	s5,10
 394:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 396:	0019849b          	addiw	s1,s3,1
 39a:	0344d863          	ble	s4,s1,3ca <gets+0x56>
    cc = read(0, &c, 1);
 39e:	4605                	li	a2,1
 3a0:	faf40593          	addi	a1,s0,-81
 3a4:	4501                	li	a0,0
 3a6:	00000097          	auipc	ra,0x0
 3aa:	1ac080e7          	jalr	428(ra) # 552 <read>
    if(cc < 1)
 3ae:	00a05e63          	blez	a0,3ca <gets+0x56>
    buf[i++] = c;
 3b2:	faf44783          	lbu	a5,-81(s0)
 3b6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3ba:	01578763          	beq	a5,s5,3c8 <gets+0x54>
 3be:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
 3c0:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
 3c2:	fd679ae3          	bne	a5,s6,396 <gets+0x22>
 3c6:	a011                	j	3ca <gets+0x56>
  for(i=0; i+1 < max; ){
 3c8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3ca:	99de                	add	s3,s3,s7
 3cc:	00098023          	sb	zero,0(s3)
  return buf;
}
 3d0:	855e                	mv	a0,s7
 3d2:	60e6                	ld	ra,88(sp)
 3d4:	6446                	ld	s0,80(sp)
 3d6:	64a6                	ld	s1,72(sp)
 3d8:	6906                	ld	s2,64(sp)
 3da:	79e2                	ld	s3,56(sp)
 3dc:	7a42                	ld	s4,48(sp)
 3de:	7aa2                	ld	s5,40(sp)
 3e0:	7b02                	ld	s6,32(sp)
 3e2:	6be2                	ld	s7,24(sp)
 3e4:	6125                	addi	sp,sp,96
 3e6:	8082                	ret

00000000000003e8 <stat>:

int
stat(const char *n, struct stat *st)
{
 3e8:	1101                	addi	sp,sp,-32
 3ea:	ec06                	sd	ra,24(sp)
 3ec:	e822                	sd	s0,16(sp)
 3ee:	e426                	sd	s1,8(sp)
 3f0:	e04a                	sd	s2,0(sp)
 3f2:	1000                	addi	s0,sp,32
 3f4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY|O_NOFOLLOW);
 3f6:	4591                	li	a1,4
 3f8:	00000097          	auipc	ra,0x0
 3fc:	182080e7          	jalr	386(ra) # 57a <open>
  if(fd < 0)
 400:	02054563          	bltz	a0,42a <stat+0x42>
 404:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 406:	85ca                	mv	a1,s2
 408:	00000097          	auipc	ra,0x0
 40c:	18a080e7          	jalr	394(ra) # 592 <fstat>
 410:	892a                	mv	s2,a0
  close(fd);
 412:	8526                	mv	a0,s1
 414:	00000097          	auipc	ra,0x0
 418:	14e080e7          	jalr	334(ra) # 562 <close>
  return r;
}
 41c:	854a                	mv	a0,s2
 41e:	60e2                	ld	ra,24(sp)
 420:	6442                	ld	s0,16(sp)
 422:	64a2                	ld	s1,8(sp)
 424:	6902                	ld	s2,0(sp)
 426:	6105                	addi	sp,sp,32
 428:	8082                	ret
    return -1;
 42a:	597d                	li	s2,-1
 42c:	bfc5                	j	41c <stat+0x34>

000000000000042e <atoi>:

int
atoi(const char *s)
{
 42e:	1141                	addi	sp,sp,-16
 430:	e422                	sd	s0,8(sp)
 432:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 434:	00054683          	lbu	a3,0(a0)
 438:	fd06879b          	addiw	a5,a3,-48
 43c:	0ff7f793          	andi	a5,a5,255
 440:	4725                	li	a4,9
 442:	02f76963          	bltu	a4,a5,474 <atoi+0x46>
 446:	862a                	mv	a2,a0
  n = 0;
 448:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 44a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 44c:	0605                	addi	a2,a2,1
 44e:	0025179b          	slliw	a5,a0,0x2
 452:	9fa9                	addw	a5,a5,a0
 454:	0017979b          	slliw	a5,a5,0x1
 458:	9fb5                	addw	a5,a5,a3
 45a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 45e:	00064683          	lbu	a3,0(a2)
 462:	fd06871b          	addiw	a4,a3,-48
 466:	0ff77713          	andi	a4,a4,255
 46a:	fee5f1e3          	bleu	a4,a1,44c <atoi+0x1e>
  return n;
}
 46e:	6422                	ld	s0,8(sp)
 470:	0141                	addi	sp,sp,16
 472:	8082                	ret
  n = 0;
 474:	4501                	li	a0,0
 476:	bfe5                	j	46e <atoi+0x40>

0000000000000478 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 478:	1141                	addi	sp,sp,-16
 47a:	e422                	sd	s0,8(sp)
 47c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 47e:	02b57663          	bleu	a1,a0,4aa <memmove+0x32>
    while(n-- > 0)
 482:	02c05163          	blez	a2,4a4 <memmove+0x2c>
 486:	fff6079b          	addiw	a5,a2,-1
 48a:	1782                	slli	a5,a5,0x20
 48c:	9381                	srli	a5,a5,0x20
 48e:	0785                	addi	a5,a5,1
 490:	97aa                	add	a5,a5,a0
  dst = vdst;
 492:	872a                	mv	a4,a0
      *dst++ = *src++;
 494:	0585                	addi	a1,a1,1
 496:	0705                	addi	a4,a4,1
 498:	fff5c683          	lbu	a3,-1(a1)
 49c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4a0:	fee79ae3          	bne	a5,a4,494 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4a4:	6422                	ld	s0,8(sp)
 4a6:	0141                	addi	sp,sp,16
 4a8:	8082                	ret
    dst += n;
 4aa:	00c50733          	add	a4,a0,a2
    src += n;
 4ae:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4b0:	fec05ae3          	blez	a2,4a4 <memmove+0x2c>
 4b4:	fff6079b          	addiw	a5,a2,-1
 4b8:	1782                	slli	a5,a5,0x20
 4ba:	9381                	srli	a5,a5,0x20
 4bc:	fff7c793          	not	a5,a5
 4c0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4c2:	15fd                	addi	a1,a1,-1
 4c4:	177d                	addi	a4,a4,-1
 4c6:	0005c683          	lbu	a3,0(a1)
 4ca:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4ce:	fef71ae3          	bne	a4,a5,4c2 <memmove+0x4a>
 4d2:	bfc9                	j	4a4 <memmove+0x2c>

00000000000004d4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4d4:	1141                	addi	sp,sp,-16
 4d6:	e422                	sd	s0,8(sp)
 4d8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4da:	ce15                	beqz	a2,516 <memcmp+0x42>
 4dc:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
 4e0:	00054783          	lbu	a5,0(a0)
 4e4:	0005c703          	lbu	a4,0(a1)
 4e8:	02e79063          	bne	a5,a4,508 <memcmp+0x34>
 4ec:	1682                	slli	a3,a3,0x20
 4ee:	9281                	srli	a3,a3,0x20
 4f0:	0685                	addi	a3,a3,1
 4f2:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
 4f4:	0505                	addi	a0,a0,1
    p2++;
 4f6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4f8:	00d50d63          	beq	a0,a3,512 <memcmp+0x3e>
    if (*p1 != *p2) {
 4fc:	00054783          	lbu	a5,0(a0)
 500:	0005c703          	lbu	a4,0(a1)
 504:	fee788e3          	beq	a5,a4,4f4 <memcmp+0x20>
      return *p1 - *p2;
 508:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
 50c:	6422                	ld	s0,8(sp)
 50e:	0141                	addi	sp,sp,16
 510:	8082                	ret
  return 0;
 512:	4501                	li	a0,0
 514:	bfe5                	j	50c <memcmp+0x38>
 516:	4501                	li	a0,0
 518:	bfd5                	j	50c <memcmp+0x38>

000000000000051a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 51a:	1141                	addi	sp,sp,-16
 51c:	e406                	sd	ra,8(sp)
 51e:	e022                	sd	s0,0(sp)
 520:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 522:	00000097          	auipc	ra,0x0
 526:	f56080e7          	jalr	-170(ra) # 478 <memmove>
}
 52a:	60a2                	ld	ra,8(sp)
 52c:	6402                	ld	s0,0(sp)
 52e:	0141                	addi	sp,sp,16
 530:	8082                	ret

0000000000000532 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 532:	4885                	li	a7,1
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <exit>:
.global exit
exit:
 li a7, SYS_exit
 53a:	4889                	li	a7,2
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <wait>:
.global wait
wait:
 li a7, SYS_wait
 542:	488d                	li	a7,3
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 54a:	4891                	li	a7,4
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <read>:
.global read
read:
 li a7, SYS_read
 552:	4895                	li	a7,5
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <write>:
.global write
write:
 li a7, SYS_write
 55a:	48c1                	li	a7,16
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <close>:
.global close
close:
 li a7, SYS_close
 562:	48d5                	li	a7,21
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <kill>:
.global kill
kill:
 li a7, SYS_kill
 56a:	4899                	li	a7,6
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <exec>:
.global exec
exec:
 li a7, SYS_exec
 572:	489d                	li	a7,7
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <open>:
.global open
open:
 li a7, SYS_open
 57a:	48bd                	li	a7,15
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 582:	48c5                	li	a7,17
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 58a:	48c9                	li	a7,18
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 592:	48a1                	li	a7,8
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <link>:
.global link
link:
 li a7, SYS_link
 59a:	48cd                	li	a7,19
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5a2:	48d1                	li	a7,20
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5aa:	48a5                	li	a7,9
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5b2:	48a9                	li	a7,10
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5ba:	48ad                	li	a7,11
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5c2:	48b1                	li	a7,12
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5ca:	48b5                	li	a7,13
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5d2:	48b9                	li	a7,14
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 5da:	48d9                	li	a7,22
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
 5f8:	f66080e7          	jalr	-154(ra) # 55a <write>
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
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 612:	c299                	beqz	a3,618 <printint+0x14>
 614:	0005cd63          	bltz	a1,62e <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 618:	2581                	sext.w	a1,a1
  neg = 0;
 61a:	4301                	li	t1,0
 61c:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
 620:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
 622:	2601                	sext.w	a2,a2
 624:	00000897          	auipc	a7,0x0
 628:	47488893          	addi	a7,a7,1140 # a98 <digits>
 62c:	a801                	j	63c <printint+0x38>
    x = -xx;
 62e:	40b005bb          	negw	a1,a1
 632:	2581                	sext.w	a1,a1
    neg = 1;
 634:	4305                	li	t1,1
    x = -xx;
 636:	b7dd                	j	61c <printint+0x18>
  }while((x /= base) != 0);
 638:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
 63a:	8836                	mv	a6,a3
 63c:	0018069b          	addiw	a3,a6,1
 640:	02c5f7bb          	remuw	a5,a1,a2
 644:	1782                	slli	a5,a5,0x20
 646:	9381                	srli	a5,a5,0x20
 648:	97c6                	add	a5,a5,a7
 64a:	0007c783          	lbu	a5,0(a5)
 64e:	00f70023          	sb	a5,0(a4)
 652:	0705                	addi	a4,a4,1
  }while((x /= base) != 0);
 654:	02c5d7bb          	divuw	a5,a1,a2
 658:	fec5f0e3          	bleu	a2,a1,638 <printint+0x34>
  if(neg)
 65c:	00030b63          	beqz	t1,672 <printint+0x6e>
    buf[i++] = '-';
 660:	fd040793          	addi	a5,s0,-48
 664:	96be                	add	a3,a3,a5
 666:	02d00793          	li	a5,45
 66a:	fef68823          	sb	a5,-16(a3)
 66e:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
 672:	02d05963          	blez	a3,6a4 <printint+0xa0>
 676:	89aa                	mv	s3,a0
 678:	fc040793          	addi	a5,s0,-64
 67c:	00d784b3          	add	s1,a5,a3
 680:	fff78913          	addi	s2,a5,-1
 684:	9936                	add	s2,s2,a3
 686:	36fd                	addiw	a3,a3,-1
 688:	1682                	slli	a3,a3,0x20
 68a:	9281                	srli	a3,a3,0x20
 68c:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
 690:	fff4c583          	lbu	a1,-1(s1)
 694:	854e                	mv	a0,s3
 696:	00000097          	auipc	ra,0x0
 69a:	f4c080e7          	jalr	-180(ra) # 5e2 <putc>
 69e:	14fd                	addi	s1,s1,-1
  while(--i >= 0)
 6a0:	ff2498e3          	bne	s1,s2,690 <printint+0x8c>
}
 6a4:	70e2                	ld	ra,56(sp)
 6a6:	7442                	ld	s0,48(sp)
 6a8:	74a2                	ld	s1,40(sp)
 6aa:	7902                	ld	s2,32(sp)
 6ac:	69e2                	ld	s3,24(sp)
 6ae:	6121                	addi	sp,sp,64
 6b0:	8082                	ret

00000000000006b2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6b2:	7119                	addi	sp,sp,-128
 6b4:	fc86                	sd	ra,120(sp)
 6b6:	f8a2                	sd	s0,112(sp)
 6b8:	f4a6                	sd	s1,104(sp)
 6ba:	f0ca                	sd	s2,96(sp)
 6bc:	ecce                	sd	s3,88(sp)
 6be:	e8d2                	sd	s4,80(sp)
 6c0:	e4d6                	sd	s5,72(sp)
 6c2:	e0da                	sd	s6,64(sp)
 6c4:	fc5e                	sd	s7,56(sp)
 6c6:	f862                	sd	s8,48(sp)
 6c8:	f466                	sd	s9,40(sp)
 6ca:	f06a                	sd	s10,32(sp)
 6cc:	ec6e                	sd	s11,24(sp)
 6ce:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6d0:	0005c483          	lbu	s1,0(a1)
 6d4:	18048d63          	beqz	s1,86e <vprintf+0x1bc>
 6d8:	8aaa                	mv	s5,a0
 6da:	8b32                	mv	s6,a2
 6dc:	00158913          	addi	s2,a1,1
  state = 0;
 6e0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6e2:	02500a13          	li	s4,37
      if(c == 'd'){
 6e6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 6ea:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 6ee:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 6f2:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6f6:	00000b97          	auipc	s7,0x0
 6fa:	3a2b8b93          	addi	s7,s7,930 # a98 <digits>
 6fe:	a839                	j	71c <vprintf+0x6a>
        putc(fd, c);
 700:	85a6                	mv	a1,s1
 702:	8556                	mv	a0,s5
 704:	00000097          	auipc	ra,0x0
 708:	ede080e7          	jalr	-290(ra) # 5e2 <putc>
 70c:	a019                	j	712 <vprintf+0x60>
    } else if(state == '%'){
 70e:	01498f63          	beq	s3,s4,72c <vprintf+0x7a>
 712:	0905                	addi	s2,s2,1
  for(i = 0; fmt[i]; i++){
 714:	fff94483          	lbu	s1,-1(s2)
 718:	14048b63          	beqz	s1,86e <vprintf+0x1bc>
    c = fmt[i] & 0xff;
 71c:	0004879b          	sext.w	a5,s1
    if(state == 0){
 720:	fe0997e3          	bnez	s3,70e <vprintf+0x5c>
      if(c == '%'){
 724:	fd479ee3          	bne	a5,s4,700 <vprintf+0x4e>
        state = '%';
 728:	89be                	mv	s3,a5
 72a:	b7e5                	j	712 <vprintf+0x60>
      if(c == 'd'){
 72c:	05878063          	beq	a5,s8,76c <vprintf+0xba>
      } else if(c == 'l') {
 730:	05978c63          	beq	a5,s9,788 <vprintf+0xd6>
      } else if(c == 'x') {
 734:	07a78863          	beq	a5,s10,7a4 <vprintf+0xf2>
      } else if(c == 'p') {
 738:	09b78463          	beq	a5,s11,7c0 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 73c:	07300713          	li	a4,115
 740:	0ce78563          	beq	a5,a4,80a <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 744:	06300713          	li	a4,99
 748:	0ee78c63          	beq	a5,a4,840 <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 74c:	11478663          	beq	a5,s4,858 <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 750:	85d2                	mv	a1,s4
 752:	8556                	mv	a0,s5
 754:	00000097          	auipc	ra,0x0
 758:	e8e080e7          	jalr	-370(ra) # 5e2 <putc>
        putc(fd, c);
 75c:	85a6                	mv	a1,s1
 75e:	8556                	mv	a0,s5
 760:	00000097          	auipc	ra,0x0
 764:	e82080e7          	jalr	-382(ra) # 5e2 <putc>
      }
      state = 0;
 768:	4981                	li	s3,0
 76a:	b765                	j	712 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 76c:	008b0493          	addi	s1,s6,8
 770:	4685                	li	a3,1
 772:	4629                	li	a2,10
 774:	000b2583          	lw	a1,0(s6)
 778:	8556                	mv	a0,s5
 77a:	00000097          	auipc	ra,0x0
 77e:	e8a080e7          	jalr	-374(ra) # 604 <printint>
 782:	8b26                	mv	s6,s1
      state = 0;
 784:	4981                	li	s3,0
 786:	b771                	j	712 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 788:	008b0493          	addi	s1,s6,8
 78c:	4681                	li	a3,0
 78e:	4629                	li	a2,10
 790:	000b2583          	lw	a1,0(s6)
 794:	8556                	mv	a0,s5
 796:	00000097          	auipc	ra,0x0
 79a:	e6e080e7          	jalr	-402(ra) # 604 <printint>
 79e:	8b26                	mv	s6,s1
      state = 0;
 7a0:	4981                	li	s3,0
 7a2:	bf85                	j	712 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7a4:	008b0493          	addi	s1,s6,8
 7a8:	4681                	li	a3,0
 7aa:	4641                	li	a2,16
 7ac:	000b2583          	lw	a1,0(s6)
 7b0:	8556                	mv	a0,s5
 7b2:	00000097          	auipc	ra,0x0
 7b6:	e52080e7          	jalr	-430(ra) # 604 <printint>
 7ba:	8b26                	mv	s6,s1
      state = 0;
 7bc:	4981                	li	s3,0
 7be:	bf91                	j	712 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7c0:	008b0793          	addi	a5,s6,8
 7c4:	f8f43423          	sd	a5,-120(s0)
 7c8:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7cc:	03000593          	li	a1,48
 7d0:	8556                	mv	a0,s5
 7d2:	00000097          	auipc	ra,0x0
 7d6:	e10080e7          	jalr	-496(ra) # 5e2 <putc>
  putc(fd, 'x');
 7da:	85ea                	mv	a1,s10
 7dc:	8556                	mv	a0,s5
 7de:	00000097          	auipc	ra,0x0
 7e2:	e04080e7          	jalr	-508(ra) # 5e2 <putc>
 7e6:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7e8:	03c9d793          	srli	a5,s3,0x3c
 7ec:	97de                	add	a5,a5,s7
 7ee:	0007c583          	lbu	a1,0(a5)
 7f2:	8556                	mv	a0,s5
 7f4:	00000097          	auipc	ra,0x0
 7f8:	dee080e7          	jalr	-530(ra) # 5e2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7fc:	0992                	slli	s3,s3,0x4
 7fe:	34fd                	addiw	s1,s1,-1
 800:	f4e5                	bnez	s1,7e8 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 802:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 806:	4981                	li	s3,0
 808:	b729                	j	712 <vprintf+0x60>
        s = va_arg(ap, char*);
 80a:	008b0993          	addi	s3,s6,8
 80e:	000b3483          	ld	s1,0(s6)
        if(s == 0)
 812:	c085                	beqz	s1,832 <vprintf+0x180>
        while(*s != 0){
 814:	0004c583          	lbu	a1,0(s1)
 818:	c9a1                	beqz	a1,868 <vprintf+0x1b6>
          putc(fd, *s);
 81a:	8556                	mv	a0,s5
 81c:	00000097          	auipc	ra,0x0
 820:	dc6080e7          	jalr	-570(ra) # 5e2 <putc>
          s++;
 824:	0485                	addi	s1,s1,1
        while(*s != 0){
 826:	0004c583          	lbu	a1,0(s1)
 82a:	f9e5                	bnez	a1,81a <vprintf+0x168>
        s = va_arg(ap, char*);
 82c:	8b4e                	mv	s6,s3
      state = 0;
 82e:	4981                	li	s3,0
 830:	b5cd                	j	712 <vprintf+0x60>
          s = "(null)";
 832:	00000497          	auipc	s1,0x0
 836:	27e48493          	addi	s1,s1,638 # ab0 <digits+0x18>
        while(*s != 0){
 83a:	02800593          	li	a1,40
 83e:	bff1                	j	81a <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
 840:	008b0493          	addi	s1,s6,8
 844:	000b4583          	lbu	a1,0(s6)
 848:	8556                	mv	a0,s5
 84a:	00000097          	auipc	ra,0x0
 84e:	d98080e7          	jalr	-616(ra) # 5e2 <putc>
 852:	8b26                	mv	s6,s1
      state = 0;
 854:	4981                	li	s3,0
 856:	bd75                	j	712 <vprintf+0x60>
        putc(fd, c);
 858:	85d2                	mv	a1,s4
 85a:	8556                	mv	a0,s5
 85c:	00000097          	auipc	ra,0x0
 860:	d86080e7          	jalr	-634(ra) # 5e2 <putc>
      state = 0;
 864:	4981                	li	s3,0
 866:	b575                	j	712 <vprintf+0x60>
        s = va_arg(ap, char*);
 868:	8b4e                	mv	s6,s3
      state = 0;
 86a:	4981                	li	s3,0
 86c:	b55d                	j	712 <vprintf+0x60>
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
 8ae:	e08080e7          	jalr	-504(ra) # 6b2 <vprintf>
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
 8e4:	dd2080e7          	jalr	-558(ra) # 6b2 <vprintf>
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
 8fe:	1be78793          	addi	a5,a5,446 # ab8 <__bss_start>
 902:	639c                	ld	a5,0(a5)
 904:	a805                	j	934 <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 906:	4618                	lw	a4,8(a2)
 908:	9db9                	addw	a1,a1,a4
 90a:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 90e:	6398                	ld	a4,0(a5)
 910:	6318                	ld	a4,0(a4)
 912:	fee53823          	sd	a4,-16(a0)
 916:	a091                	j	95a <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 918:	ff852703          	lw	a4,-8(a0)
 91c:	9e39                	addw	a2,a2,a4
 91e:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 920:	ff053703          	ld	a4,-16(a0)
 924:	e398                	sd	a4,0(a5)
 926:	a099                	j	96c <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 928:	6398                	ld	a4,0(a5)
 92a:	00e7e463          	bltu	a5,a4,932 <free+0x42>
 92e:	00e6ea63          	bltu	a3,a4,942 <free+0x52>
{
 932:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 934:	fed7fae3          	bleu	a3,a5,928 <free+0x38>
 938:	6398                	ld	a4,0(a5)
 93a:	00e6e463          	bltu	a3,a4,942 <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 93e:	fee7eae3          	bltu	a5,a4,932 <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
 942:	ff852583          	lw	a1,-8(a0)
 946:	6390                	ld	a2,0(a5)
 948:	02059713          	slli	a4,a1,0x20
 94c:	9301                	srli	a4,a4,0x20
 94e:	0712                	slli	a4,a4,0x4
 950:	9736                	add	a4,a4,a3
 952:	fae60ae3          	beq	a2,a4,906 <free+0x16>
    bp->s.ptr = p->s.ptr;
 956:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 95a:	4790                	lw	a2,8(a5)
 95c:	02061713          	slli	a4,a2,0x20
 960:	9301                	srli	a4,a4,0x20
 962:	0712                	slli	a4,a4,0x4
 964:	973e                	add	a4,a4,a5
 966:	fae689e3          	beq	a3,a4,918 <free+0x28>
  } else
    p->s.ptr = bp;
 96a:	e394                	sd	a3,0(a5)
  freep = p;
 96c:	00000717          	auipc	a4,0x0
 970:	14f73623          	sd	a5,332(a4) # ab8 <__bss_start>
}
 974:	6422                	ld	s0,8(sp)
 976:	0141                	addi	sp,sp,16
 978:	8082                	ret

000000000000097a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 97a:	7139                	addi	sp,sp,-64
 97c:	fc06                	sd	ra,56(sp)
 97e:	f822                	sd	s0,48(sp)
 980:	f426                	sd	s1,40(sp)
 982:	f04a                	sd	s2,32(sp)
 984:	ec4e                	sd	s3,24(sp)
 986:	e852                	sd	s4,16(sp)
 988:	e456                	sd	s5,8(sp)
 98a:	e05a                	sd	s6,0(sp)
 98c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 98e:	02051993          	slli	s3,a0,0x20
 992:	0209d993          	srli	s3,s3,0x20
 996:	09bd                	addi	s3,s3,15
 998:	0049d993          	srli	s3,s3,0x4
 99c:	2985                	addiw	s3,s3,1
 99e:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
 9a2:	00000797          	auipc	a5,0x0
 9a6:	11678793          	addi	a5,a5,278 # ab8 <__bss_start>
 9aa:	6388                	ld	a0,0(a5)
 9ac:	c515                	beqz	a0,9d8 <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ae:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9b0:	4798                	lw	a4,8(a5)
 9b2:	03277f63          	bleu	s2,a4,9f0 <malloc+0x76>
 9b6:	8a4e                	mv	s4,s3
 9b8:	0009871b          	sext.w	a4,s3
 9bc:	6685                	lui	a3,0x1
 9be:	00d77363          	bleu	a3,a4,9c4 <malloc+0x4a>
 9c2:	6a05                	lui	s4,0x1
 9c4:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
 9c8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9cc:	00000497          	auipc	s1,0x0
 9d0:	0ec48493          	addi	s1,s1,236 # ab8 <__bss_start>
  if(p == (char*)-1)
 9d4:	5b7d                	li	s6,-1
 9d6:	a885                	j	a46 <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
 9d8:	00000797          	auipc	a5,0x0
 9dc:	4e878793          	addi	a5,a5,1256 # ec0 <base>
 9e0:	00000717          	auipc	a4,0x0
 9e4:	0cf73c23          	sd	a5,216(a4) # ab8 <__bss_start>
 9e8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9ea:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9ee:	b7e1                	j	9b6 <malloc+0x3c>
      if(p->s.size == nunits)
 9f0:	02e90b63          	beq	s2,a4,a26 <malloc+0xac>
        p->s.size -= nunits;
 9f4:	4137073b          	subw	a4,a4,s3
 9f8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9fa:	1702                	slli	a4,a4,0x20
 9fc:	9301                	srli	a4,a4,0x20
 9fe:	0712                	slli	a4,a4,0x4
 a00:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a02:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a06:	00000717          	auipc	a4,0x0
 a0a:	0aa73923          	sd	a0,178(a4) # ab8 <__bss_start>
      return (void*)(p + 1);
 a0e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a12:	70e2                	ld	ra,56(sp)
 a14:	7442                	ld	s0,48(sp)
 a16:	74a2                	ld	s1,40(sp)
 a18:	7902                	ld	s2,32(sp)
 a1a:	69e2                	ld	s3,24(sp)
 a1c:	6a42                	ld	s4,16(sp)
 a1e:	6aa2                	ld	s5,8(sp)
 a20:	6b02                	ld	s6,0(sp)
 a22:	6121                	addi	sp,sp,64
 a24:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a26:	6398                	ld	a4,0(a5)
 a28:	e118                	sd	a4,0(a0)
 a2a:	bff1                	j	a06 <malloc+0x8c>
  hp->s.size = nu;
 a2c:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
 a30:	0541                	addi	a0,a0,16
 a32:	00000097          	auipc	ra,0x0
 a36:	ebe080e7          	jalr	-322(ra) # 8f0 <free>
  return freep;
 a3a:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a3c:	d979                	beqz	a0,a12 <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a3e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a40:	4798                	lw	a4,8(a5)
 a42:	fb2777e3          	bleu	s2,a4,9f0 <malloc+0x76>
    if(p == freep)
 a46:	6098                	ld	a4,0(s1)
 a48:	853e                	mv	a0,a5
 a4a:	fef71ae3          	bne	a4,a5,a3e <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
 a4e:	8552                	mv	a0,s4
 a50:	00000097          	auipc	ra,0x0
 a54:	b72080e7          	jalr	-1166(ra) # 5c2 <sbrk>
  if(p == (char*)-1)
 a58:	fd651ae3          	bne	a0,s6,a2c <malloc+0xb2>
        return 0;
 a5c:	4501                	li	a0,0
 a5e:	bf55                	j	a12 <malloc+0x98>
