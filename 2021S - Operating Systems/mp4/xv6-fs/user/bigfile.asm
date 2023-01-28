
user/_bigfile:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#define TARGET_BLOCK_NUM 66666

int
main()
{
   0:	bc010113          	addi	sp,sp,-1088
   4:	42113c23          	sd	ra,1080(sp)
   8:	42813823          	sd	s0,1072(sp)
   c:	42913423          	sd	s1,1064(sp)
  10:	43213023          	sd	s2,1056(sp)
  14:	41313c23          	sd	s3,1048(sp)
  18:	41413823          	sd	s4,1040(sp)
  1c:	41513423          	sd	s5,1032(sp)
  20:	44010413          	addi	s0,sp,1088
  char buf[BSIZE];
  int fd, i, blocks;


  fd = open("big.file", O_CREATE | O_WRONLY);
  24:	20100593          	li	a1,513
  28:	00001517          	auipc	a0,0x1
  2c:	a2050513          	addi	a0,a0,-1504 # a48 <malloc+0xe8>
  30:	00000097          	auipc	ra,0x0
  34:	530080e7          	jalr	1328(ra) # 560 <open>
  if(fd < 0){
  38:	00054e63          	bltz	a0,54 <main+0x54>
  3c:	892a                	mv	s2,a0
  3e:	4481                	li	s1,0
    *(int*)buf = blocks;
    int cc = write(fd, buf, sizeof(buf));
    if(cc <= 0)
      break;
    blocks++;
    if (blocks % 100 == 0)
  40:	06400a13          	li	s4,100
      printf(".");
  44:	00001a97          	auipc	s5,0x1
  48:	a44a8a93          	addi	s5,s5,-1468 # a88 <malloc+0x128>
    if(blocks == TARGET_BLOCK_NUM)
  4c:	69c1                	lui	s3,0x10
  4e:	46a98993          	addi	s3,s3,1130 # 1046a <__global_pointer$+0xf082>
  52:	a02d                	j	7c <main+0x7c>
    printf("bigfile: cannot open big.file for writing\n");
  54:	00001517          	auipc	a0,0x1
  58:	a0450513          	addi	a0,a0,-1532 # a58 <malloc+0xf8>
  5c:	00001097          	auipc	ra,0x1
  60:	844080e7          	jalr	-1980(ra) # 8a0 <printf>
    exit(-1);
  64:	557d                	li	a0,-1
  66:	00000097          	auipc	ra,0x0
  6a:	4ba080e7          	jalr	1210(ra) # 520 <exit>
      printf(".");
  6e:	8556                	mv	a0,s5
  70:	00001097          	auipc	ra,0x1
  74:	830080e7          	jalr	-2000(ra) # 8a0 <printf>
    if(blocks == TARGET_BLOCK_NUM)
  78:	11348d63          	beq	s1,s3,192 <main+0x192>
    *(int*)buf = blocks;
  7c:	bc942023          	sw	s1,-1088(s0)
    int cc = write(fd, buf, sizeof(buf));
  80:	40000613          	li	a2,1024
  84:	bc040593          	addi	a1,s0,-1088
  88:	854a                	mv	a0,s2
  8a:	00000097          	auipc	ra,0x0
  8e:	4b6080e7          	jalr	1206(ra) # 540 <write>
    if(cc <= 0)
  92:	00a05a63          	blez	a0,a6 <main+0xa6>
    blocks++;
  96:	0014879b          	addiw	a5,s1,1
  9a:	0007849b          	sext.w	s1,a5
    if (blocks % 100 == 0)
  9e:	0347e7bb          	remw	a5,a5,s4
  a2:	fbf9                	bnez	a5,78 <main+0x78>
  a4:	b7e9                	j	6e <main+0x6e>
      break;
  }

  printf("\nwrote %d blocks\n", blocks);
  a6:	85a6                	mv	a1,s1
  a8:	00001517          	auipc	a0,0x1
  ac:	9e850513          	addi	a0,a0,-1560 # a90 <malloc+0x130>
  b0:	00000097          	auipc	ra,0x0
  b4:	7f0080e7          	jalr	2032(ra) # 8a0 <printf>
  if(blocks != TARGET_BLOCK_NUM) {
  b8:	67c1                	lui	a5,0x10
  ba:	46a78793          	addi	a5,a5,1130 # 1046a <__global_pointer$+0xf082>
  be:	0ef48563          	beq	s1,a5,1a8 <main+0x1a8>
    printf("bigfile: file is too small\n");
  c2:	00001517          	auipc	a0,0x1
  c6:	9e650513          	addi	a0,a0,-1562 # aa8 <malloc+0x148>
  ca:	00000097          	auipc	ra,0x0
  ce:	7d6080e7          	jalr	2006(ra) # 8a0 <printf>
    exit(-1);
  d2:	557d                	li	a0,-1
  d4:	00000097          	auipc	ra,0x0
  d8:	44c080e7          	jalr	1100(ra) # 520 <exit>
  }

  close(fd);
  fd = open("big.file", O_RDONLY);
  if(fd < 0){
    printf("bigfile: cannot re-open big.file for reading\n");
  dc:	00001517          	auipc	a0,0x1
  e0:	9ec50513          	addi	a0,a0,-1556 # ac8 <malloc+0x168>
  e4:	00000097          	auipc	ra,0x0
  e8:	7bc080e7          	jalr	1980(ra) # 8a0 <printf>
    exit(-1);
  ec:	557d                	li	a0,-1
  ee:	00000097          	auipc	ra,0x0
  f2:	432080e7          	jalr	1074(ra) # 520 <exit>
  }
  for(i = 0; i < blocks; i++){
    int cc = read(fd, buf, sizeof(buf));
    if(cc <= 0){
      printf("bigfile: read error at block %d\n", i);
  f6:	85a6                	mv	a1,s1
  f8:	00001517          	auipc	a0,0x1
  fc:	a0050513          	addi	a0,a0,-1536 # af8 <malloc+0x198>
 100:	00000097          	auipc	ra,0x0
 104:	7a0080e7          	jalr	1952(ra) # 8a0 <printf>
      exit(-1);
 108:	557d                	li	a0,-1
 10a:	00000097          	auipc	ra,0x0
 10e:	416080e7          	jalr	1046(ra) # 520 <exit>
    }
    if(*(int*)buf != i){
      printf("bigfile: read the wrong data (%d) for block %d\n",
 112:	8626                	mv	a2,s1
 114:	00001517          	auipc	a0,0x1
 118:	a0c50513          	addi	a0,a0,-1524 # b20 <malloc+0x1c0>
 11c:	00000097          	auipc	ra,0x0
 120:	784080e7          	jalr	1924(ra) # 8a0 <printf>
             *(int*)buf, i);
      exit(-1);
 124:	557d                	li	a0,-1
 126:	00000097          	auipc	ra,0x0
 12a:	3fa080e7          	jalr	1018(ra) # 520 <exit>
  }

  close(fd);
  fd = open("big.file", O_TRUNC);
  if(fd < 0){
    printf("truncate fail\n");
 12e:	00001517          	auipc	a0,0x1
 132:	a2250513          	addi	a0,a0,-1502 # b50 <malloc+0x1f0>
 136:	00000097          	auipc	ra,0x0
 13a:	76a080e7          	jalr	1898(ra) # 8a0 <printf>
 13e:	a8f1                	j	21a <main+0x21a>


  printf("now read at truncate file\n");
  fd = open("big.file", O_RDONLY);
  if(fd < 0){
    printf("bigfile: cannot re-open big.file for reading\n");
 140:	00001517          	auipc	a0,0x1
 144:	98850513          	addi	a0,a0,-1656 # ac8 <malloc+0x168>
 148:	00000097          	auipc	ra,0x0
 14c:	758080e7          	jalr	1880(ra) # 8a0 <printf>
    exit(-1);
 150:	557d                	li	a0,-1
 152:	00000097          	auipc	ra,0x0
 156:	3ce080e7          	jalr	974(ra) # 520 <exit>
  }
  for(i = 0; i < blocks; i++){
    int cc = read(fd, buf, sizeof(buf));
    if(cc <= 0){
      printf("bigfile: read error at block %d\n", i);
 15a:	85a6                	mv	a1,s1
 15c:	00001517          	auipc	a0,0x1
 160:	99c50513          	addi	a0,a0,-1636 # af8 <malloc+0x198>
 164:	00000097          	auipc	ra,0x0
 168:	73c080e7          	jalr	1852(ra) # 8a0 <printf>
      exit(-1);
 16c:	557d                	li	a0,-1
 16e:	00000097          	auipc	ra,0x0
 172:	3b2080e7          	jalr	946(ra) # 520 <exit>
    }
    if(*buf != '\0'){
      printf("bigfile: read the wrong data (%c) for block %d\n",
 176:	8626                	mv	a2,s1
 178:	00001517          	auipc	a0,0x1
 17c:	a0850513          	addi	a0,a0,-1528 # b80 <malloc+0x220>
 180:	00000097          	auipc	ra,0x0
 184:	720080e7          	jalr	1824(ra) # 8a0 <printf>
             *buf, i);
      exit(-1);
 188:	557d                	li	a0,-1
 18a:	00000097          	auipc	ra,0x0
 18e:	396080e7          	jalr	918(ra) # 520 <exit>
  printf("\nwrote %d blocks\n", blocks);
 192:	65c1                	lui	a1,0x10
 194:	46a58593          	addi	a1,a1,1130 # 1046a <__global_pointer$+0xf082>
 198:	00001517          	auipc	a0,0x1
 19c:	8f850513          	addi	a0,a0,-1800 # a90 <malloc+0x130>
 1a0:	00000097          	auipc	ra,0x0
 1a4:	700080e7          	jalr	1792(ra) # 8a0 <printf>
  close(fd);
 1a8:	854a                	mv	a0,s2
 1aa:	00000097          	auipc	ra,0x0
 1ae:	39e080e7          	jalr	926(ra) # 548 <close>
  fd = open("big.file", O_RDONLY);
 1b2:	4581                	li	a1,0
 1b4:	00001517          	auipc	a0,0x1
 1b8:	89450513          	addi	a0,a0,-1900 # a48 <malloc+0xe8>
 1bc:	00000097          	auipc	ra,0x0
 1c0:	3a4080e7          	jalr	932(ra) # 560 <open>
 1c4:	892a                	mv	s2,a0
  for(i = 0; i < blocks; i++){
 1c6:	4481                	li	s1,0
  if(fd < 0){
 1c8:	f0054ae3          	bltz	a0,dc <main+0xdc>
  for(i = 0; i < blocks; i++){
 1cc:	69c1                	lui	s3,0x10
 1ce:	46a98993          	addi	s3,s3,1130 # 1046a <__global_pointer$+0xf082>
    int cc = read(fd, buf, sizeof(buf));
 1d2:	40000613          	li	a2,1024
 1d6:	bc040593          	addi	a1,s0,-1088
 1da:	854a                	mv	a0,s2
 1dc:	00000097          	auipc	ra,0x0
 1e0:	35c080e7          	jalr	860(ra) # 538 <read>
    if(cc <= 0){
 1e4:	f0a059e3          	blez	a0,f6 <main+0xf6>
    if(*(int*)buf != i){
 1e8:	bc042583          	lw	a1,-1088(s0)
 1ec:	f29593e3          	bne	a1,s1,112 <main+0x112>
  for(i = 0; i < blocks; i++){
 1f0:	2485                	addiw	s1,s1,1
 1f2:	ff3490e3          	bne	s1,s3,1d2 <main+0x1d2>
  close(fd);
 1f6:	854a                	mv	a0,s2
 1f8:	00000097          	auipc	ra,0x0
 1fc:	350080e7          	jalr	848(ra) # 548 <close>
  fd = open("big.file", O_TRUNC);
 200:	40000593          	li	a1,1024
 204:	00001517          	auipc	a0,0x1
 208:	84450513          	addi	a0,a0,-1980 # a48 <malloc+0xe8>
 20c:	00000097          	auipc	ra,0x0
 210:	354080e7          	jalr	852(ra) # 560 <open>
 214:	84aa                	mv	s1,a0
  if(fd < 0){
 216:	f0054ce3          	bltz	a0,12e <main+0x12e>
  close(fd);
 21a:	8526                	mv	a0,s1
 21c:	00000097          	auipc	ra,0x0
 220:	32c080e7          	jalr	812(ra) # 548 <close>
  printf("now read at truncate file\n");
 224:	00001517          	auipc	a0,0x1
 228:	93c50513          	addi	a0,a0,-1732 # b60 <malloc+0x200>
 22c:	00000097          	auipc	ra,0x0
 230:	674080e7          	jalr	1652(ra) # 8a0 <printf>
  fd = open("big.file", O_RDONLY);
 234:	4581                	li	a1,0
 236:	00001517          	auipc	a0,0x1
 23a:	81250513          	addi	a0,a0,-2030 # a48 <malloc+0xe8>
 23e:	00000097          	auipc	ra,0x0
 242:	322080e7          	jalr	802(ra) # 560 <open>
 246:	892a                	mv	s2,a0
  for(i = 0; i < blocks; i++){
 248:	4481                	li	s1,0
  if(fd < 0){
 24a:	ee054be3          	bltz	a0,140 <main+0x140>
  for(i = 0; i < blocks; i++){
 24e:	69c1                	lui	s3,0x10
 250:	46a98993          	addi	s3,s3,1130 # 1046a <__global_pointer$+0xf082>
    int cc = read(fd, buf, sizeof(buf));
 254:	40000613          	li	a2,1024
 258:	bc040593          	addi	a1,s0,-1088
 25c:	854a                	mv	a0,s2
 25e:	00000097          	auipc	ra,0x0
 262:	2da080e7          	jalr	730(ra) # 538 <read>
    if(cc <= 0){
 266:	eea05ae3          	blez	a0,15a <main+0x15a>
    if(*buf != '\0'){
 26a:	bc044583          	lbu	a1,-1088(s0)
 26e:	f581                	bnez	a1,176 <main+0x176>
  for(i = 0; i < blocks; i++){
 270:	2485                	addiw	s1,s1,1
 272:	ff3491e3          	bne	s1,s3,254 <main+0x254>
    }
  }

  printf("bigfile done; ok\n");
 276:	00001517          	auipc	a0,0x1
 27a:	93a50513          	addi	a0,a0,-1734 # bb0 <malloc+0x250>
 27e:	00000097          	auipc	ra,0x0
 282:	622080e7          	jalr	1570(ra) # 8a0 <printf>

  exit(0);
 286:	4501                	li	a0,0
 288:	00000097          	auipc	ra,0x0
 28c:	298080e7          	jalr	664(ra) # 520 <exit>

0000000000000290 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 290:	1141                	addi	sp,sp,-16
 292:	e422                	sd	s0,8(sp)
 294:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 296:	87aa                	mv	a5,a0
 298:	0585                	addi	a1,a1,1
 29a:	0785                	addi	a5,a5,1
 29c:	fff5c703          	lbu	a4,-1(a1)
 2a0:	fee78fa3          	sb	a4,-1(a5)
 2a4:	fb75                	bnez	a4,298 <strcpy+0x8>
    ;
  return os;
}
 2a6:	6422                	ld	s0,8(sp)
 2a8:	0141                	addi	sp,sp,16
 2aa:	8082                	ret

00000000000002ac <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2ac:	1141                	addi	sp,sp,-16
 2ae:	e422                	sd	s0,8(sp)
 2b0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2b2:	00054783          	lbu	a5,0(a0)
 2b6:	cf91                	beqz	a5,2d2 <strcmp+0x26>
 2b8:	0005c703          	lbu	a4,0(a1)
 2bc:	00f71b63          	bne	a4,a5,2d2 <strcmp+0x26>
    p++, q++;
 2c0:	0505                	addi	a0,a0,1
 2c2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2c4:	00054783          	lbu	a5,0(a0)
 2c8:	c789                	beqz	a5,2d2 <strcmp+0x26>
 2ca:	0005c703          	lbu	a4,0(a1)
 2ce:	fef709e3          	beq	a4,a5,2c0 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 2d2:	0005c503          	lbu	a0,0(a1)
}
 2d6:	40a7853b          	subw	a0,a5,a0
 2da:	6422                	ld	s0,8(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret

00000000000002e0 <strlen>:

uint
strlen(const char *s)
{
 2e0:	1141                	addi	sp,sp,-16
 2e2:	e422                	sd	s0,8(sp)
 2e4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2e6:	00054783          	lbu	a5,0(a0)
 2ea:	cf91                	beqz	a5,306 <strlen+0x26>
 2ec:	0505                	addi	a0,a0,1
 2ee:	87aa                	mv	a5,a0
 2f0:	4685                	li	a3,1
 2f2:	9e89                	subw	a3,a3,a0
    ;
 2f4:	00f6853b          	addw	a0,a3,a5
 2f8:	0785                	addi	a5,a5,1
  for(n = 0; s[n]; n++)
 2fa:	fff7c703          	lbu	a4,-1(a5)
 2fe:	fb7d                	bnez	a4,2f4 <strlen+0x14>
  return n;
}
 300:	6422                	ld	s0,8(sp)
 302:	0141                	addi	sp,sp,16
 304:	8082                	ret
  for(n = 0; s[n]; n++)
 306:	4501                	li	a0,0
 308:	bfe5                	j	300 <strlen+0x20>

000000000000030a <memset>:

void*
memset(void *dst, int c, uint n)
{
 30a:	1141                	addi	sp,sp,-16
 30c:	e422                	sd	s0,8(sp)
 30e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 310:	ce09                	beqz	a2,32a <memset+0x20>
 312:	87aa                	mv	a5,a0
 314:	fff6071b          	addiw	a4,a2,-1
 318:	1702                	slli	a4,a4,0x20
 31a:	9301                	srli	a4,a4,0x20
 31c:	0705                	addi	a4,a4,1
 31e:	972a                	add	a4,a4,a0
    cdst[i] = c;
 320:	00b78023          	sb	a1,0(a5)
 324:	0785                	addi	a5,a5,1
  for(i = 0; i < n; i++){
 326:	fee79de3          	bne	a5,a4,320 <memset+0x16>
  }
  return dst;
}
 32a:	6422                	ld	s0,8(sp)
 32c:	0141                	addi	sp,sp,16
 32e:	8082                	ret

0000000000000330 <strchr>:

char*
strchr(const char *s, char c)
{
 330:	1141                	addi	sp,sp,-16
 332:	e422                	sd	s0,8(sp)
 334:	0800                	addi	s0,sp,16
  for(; *s; s++)
 336:	00054783          	lbu	a5,0(a0)
 33a:	cf91                	beqz	a5,356 <strchr+0x26>
    if(*s == c)
 33c:	00f58a63          	beq	a1,a5,350 <strchr+0x20>
  for(; *s; s++)
 340:	0505                	addi	a0,a0,1
 342:	00054783          	lbu	a5,0(a0)
 346:	c781                	beqz	a5,34e <strchr+0x1e>
    if(*s == c)
 348:	feb79ce3          	bne	a5,a1,340 <strchr+0x10>
 34c:	a011                	j	350 <strchr+0x20>
      return (char*)s;
  return 0;
 34e:	4501                	li	a0,0
}
 350:	6422                	ld	s0,8(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret
  return 0;
 356:	4501                	li	a0,0
 358:	bfe5                	j	350 <strchr+0x20>

000000000000035a <gets>:

char*
gets(char *buf, int max)
{
 35a:	711d                	addi	sp,sp,-96
 35c:	ec86                	sd	ra,88(sp)
 35e:	e8a2                	sd	s0,80(sp)
 360:	e4a6                	sd	s1,72(sp)
 362:	e0ca                	sd	s2,64(sp)
 364:	fc4e                	sd	s3,56(sp)
 366:	f852                	sd	s4,48(sp)
 368:	f456                	sd	s5,40(sp)
 36a:	f05a                	sd	s6,32(sp)
 36c:	ec5e                	sd	s7,24(sp)
 36e:	1080                	addi	s0,sp,96
 370:	8baa                	mv	s7,a0
 372:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 374:	892a                	mv	s2,a0
 376:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 378:	4aa9                	li	s5,10
 37a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 37c:	0019849b          	addiw	s1,s3,1
 380:	0344d863          	ble	s4,s1,3b0 <gets+0x56>
    cc = read(0, &c, 1);
 384:	4605                	li	a2,1
 386:	faf40593          	addi	a1,s0,-81
 38a:	4501                	li	a0,0
 38c:	00000097          	auipc	ra,0x0
 390:	1ac080e7          	jalr	428(ra) # 538 <read>
    if(cc < 1)
 394:	00a05e63          	blez	a0,3b0 <gets+0x56>
    buf[i++] = c;
 398:	faf44783          	lbu	a5,-81(s0)
 39c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3a0:	01578763          	beq	a5,s5,3ae <gets+0x54>
 3a4:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
 3a6:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
 3a8:	fd679ae3          	bne	a5,s6,37c <gets+0x22>
 3ac:	a011                	j	3b0 <gets+0x56>
  for(i=0; i+1 < max; ){
 3ae:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3b0:	99de                	add	s3,s3,s7
 3b2:	00098023          	sb	zero,0(s3)
  return buf;
}
 3b6:	855e                	mv	a0,s7
 3b8:	60e6                	ld	ra,88(sp)
 3ba:	6446                	ld	s0,80(sp)
 3bc:	64a6                	ld	s1,72(sp)
 3be:	6906                	ld	s2,64(sp)
 3c0:	79e2                	ld	s3,56(sp)
 3c2:	7a42                	ld	s4,48(sp)
 3c4:	7aa2                	ld	s5,40(sp)
 3c6:	7b02                	ld	s6,32(sp)
 3c8:	6be2                	ld	s7,24(sp)
 3ca:	6125                	addi	sp,sp,96
 3cc:	8082                	ret

00000000000003ce <stat>:

int
stat(const char *n, struct stat *st)
{
 3ce:	1101                	addi	sp,sp,-32
 3d0:	ec06                	sd	ra,24(sp)
 3d2:	e822                	sd	s0,16(sp)
 3d4:	e426                	sd	s1,8(sp)
 3d6:	e04a                	sd	s2,0(sp)
 3d8:	1000                	addi	s0,sp,32
 3da:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY|O_NOFOLLOW);
 3dc:	4591                	li	a1,4
 3de:	00000097          	auipc	ra,0x0
 3e2:	182080e7          	jalr	386(ra) # 560 <open>
  if(fd < 0)
 3e6:	02054563          	bltz	a0,410 <stat+0x42>
 3ea:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3ec:	85ca                	mv	a1,s2
 3ee:	00000097          	auipc	ra,0x0
 3f2:	18a080e7          	jalr	394(ra) # 578 <fstat>
 3f6:	892a                	mv	s2,a0
  close(fd);
 3f8:	8526                	mv	a0,s1
 3fa:	00000097          	auipc	ra,0x0
 3fe:	14e080e7          	jalr	334(ra) # 548 <close>
  return r;
}
 402:	854a                	mv	a0,s2
 404:	60e2                	ld	ra,24(sp)
 406:	6442                	ld	s0,16(sp)
 408:	64a2                	ld	s1,8(sp)
 40a:	6902                	ld	s2,0(sp)
 40c:	6105                	addi	sp,sp,32
 40e:	8082                	ret
    return -1;
 410:	597d                	li	s2,-1
 412:	bfc5                	j	402 <stat+0x34>

0000000000000414 <atoi>:

int
atoi(const char *s)
{
 414:	1141                	addi	sp,sp,-16
 416:	e422                	sd	s0,8(sp)
 418:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 41a:	00054683          	lbu	a3,0(a0)
 41e:	fd06879b          	addiw	a5,a3,-48
 422:	0ff7f793          	andi	a5,a5,255
 426:	4725                	li	a4,9
 428:	02f76963          	bltu	a4,a5,45a <atoi+0x46>
 42c:	862a                	mv	a2,a0
  n = 0;
 42e:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 430:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 432:	0605                	addi	a2,a2,1
 434:	0025179b          	slliw	a5,a0,0x2
 438:	9fa9                	addw	a5,a5,a0
 43a:	0017979b          	slliw	a5,a5,0x1
 43e:	9fb5                	addw	a5,a5,a3
 440:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 444:	00064683          	lbu	a3,0(a2)
 448:	fd06871b          	addiw	a4,a3,-48
 44c:	0ff77713          	andi	a4,a4,255
 450:	fee5f1e3          	bleu	a4,a1,432 <atoi+0x1e>
  return n;
}
 454:	6422                	ld	s0,8(sp)
 456:	0141                	addi	sp,sp,16
 458:	8082                	ret
  n = 0;
 45a:	4501                	li	a0,0
 45c:	bfe5                	j	454 <atoi+0x40>

000000000000045e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 45e:	1141                	addi	sp,sp,-16
 460:	e422                	sd	s0,8(sp)
 462:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 464:	02b57663          	bleu	a1,a0,490 <memmove+0x32>
    while(n-- > 0)
 468:	02c05163          	blez	a2,48a <memmove+0x2c>
 46c:	fff6079b          	addiw	a5,a2,-1
 470:	1782                	slli	a5,a5,0x20
 472:	9381                	srli	a5,a5,0x20
 474:	0785                	addi	a5,a5,1
 476:	97aa                	add	a5,a5,a0
  dst = vdst;
 478:	872a                	mv	a4,a0
      *dst++ = *src++;
 47a:	0585                	addi	a1,a1,1
 47c:	0705                	addi	a4,a4,1
 47e:	fff5c683          	lbu	a3,-1(a1)
 482:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 486:	fee79ae3          	bne	a5,a4,47a <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 48a:	6422                	ld	s0,8(sp)
 48c:	0141                	addi	sp,sp,16
 48e:	8082                	ret
    dst += n;
 490:	00c50733          	add	a4,a0,a2
    src += n;
 494:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 496:	fec05ae3          	blez	a2,48a <memmove+0x2c>
 49a:	fff6079b          	addiw	a5,a2,-1
 49e:	1782                	slli	a5,a5,0x20
 4a0:	9381                	srli	a5,a5,0x20
 4a2:	fff7c793          	not	a5,a5
 4a6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4a8:	15fd                	addi	a1,a1,-1
 4aa:	177d                	addi	a4,a4,-1
 4ac:	0005c683          	lbu	a3,0(a1)
 4b0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4b4:	fef71ae3          	bne	a4,a5,4a8 <memmove+0x4a>
 4b8:	bfc9                	j	48a <memmove+0x2c>

00000000000004ba <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4ba:	1141                	addi	sp,sp,-16
 4bc:	e422                	sd	s0,8(sp)
 4be:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4c0:	ce15                	beqz	a2,4fc <memcmp+0x42>
 4c2:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
 4c6:	00054783          	lbu	a5,0(a0)
 4ca:	0005c703          	lbu	a4,0(a1)
 4ce:	02e79063          	bne	a5,a4,4ee <memcmp+0x34>
 4d2:	1682                	slli	a3,a3,0x20
 4d4:	9281                	srli	a3,a3,0x20
 4d6:	0685                	addi	a3,a3,1
 4d8:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
 4da:	0505                	addi	a0,a0,1
    p2++;
 4dc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4de:	00d50d63          	beq	a0,a3,4f8 <memcmp+0x3e>
    if (*p1 != *p2) {
 4e2:	00054783          	lbu	a5,0(a0)
 4e6:	0005c703          	lbu	a4,0(a1)
 4ea:	fee788e3          	beq	a5,a4,4da <memcmp+0x20>
      return *p1 - *p2;
 4ee:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
 4f2:	6422                	ld	s0,8(sp)
 4f4:	0141                	addi	sp,sp,16
 4f6:	8082                	ret
  return 0;
 4f8:	4501                	li	a0,0
 4fa:	bfe5                	j	4f2 <memcmp+0x38>
 4fc:	4501                	li	a0,0
 4fe:	bfd5                	j	4f2 <memcmp+0x38>

0000000000000500 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 500:	1141                	addi	sp,sp,-16
 502:	e406                	sd	ra,8(sp)
 504:	e022                	sd	s0,0(sp)
 506:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 508:	00000097          	auipc	ra,0x0
 50c:	f56080e7          	jalr	-170(ra) # 45e <memmove>
}
 510:	60a2                	ld	ra,8(sp)
 512:	6402                	ld	s0,0(sp)
 514:	0141                	addi	sp,sp,16
 516:	8082                	ret

0000000000000518 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 518:	4885                	li	a7,1
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <exit>:
.global exit
exit:
 li a7, SYS_exit
 520:	4889                	li	a7,2
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <wait>:
.global wait
wait:
 li a7, SYS_wait
 528:	488d                	li	a7,3
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 530:	4891                	li	a7,4
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <read>:
.global read
read:
 li a7, SYS_read
 538:	4895                	li	a7,5
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <write>:
.global write
write:
 li a7, SYS_write
 540:	48c1                	li	a7,16
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <close>:
.global close
close:
 li a7, SYS_close
 548:	48d5                	li	a7,21
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <kill>:
.global kill
kill:
 li a7, SYS_kill
 550:	4899                	li	a7,6
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <exec>:
.global exec
exec:
 li a7, SYS_exec
 558:	489d                	li	a7,7
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <open>:
.global open
open:
 li a7, SYS_open
 560:	48bd                	li	a7,15
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 568:	48c5                	li	a7,17
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 570:	48c9                	li	a7,18
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 578:	48a1                	li	a7,8
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <link>:
.global link
link:
 li a7, SYS_link
 580:	48cd                	li	a7,19
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 588:	48d1                	li	a7,20
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 590:	48a5                	li	a7,9
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <dup>:
.global dup
dup:
 li a7, SYS_dup
 598:	48a9                	li	a7,10
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5a0:	48ad                	li	a7,11
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5a8:	48b1                	li	a7,12
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5b0:	48b5                	li	a7,13
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5b8:	48b9                	li	a7,14
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 5c0:	48d9                	li	a7,22
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5c8:	1101                	addi	sp,sp,-32
 5ca:	ec06                	sd	ra,24(sp)
 5cc:	e822                	sd	s0,16(sp)
 5ce:	1000                	addi	s0,sp,32
 5d0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5d4:	4605                	li	a2,1
 5d6:	fef40593          	addi	a1,s0,-17
 5da:	00000097          	auipc	ra,0x0
 5de:	f66080e7          	jalr	-154(ra) # 540 <write>
}
 5e2:	60e2                	ld	ra,24(sp)
 5e4:	6442                	ld	s0,16(sp)
 5e6:	6105                	addi	sp,sp,32
 5e8:	8082                	ret

00000000000005ea <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5ea:	7139                	addi	sp,sp,-64
 5ec:	fc06                	sd	ra,56(sp)
 5ee:	f822                	sd	s0,48(sp)
 5f0:	f426                	sd	s1,40(sp)
 5f2:	f04a                	sd	s2,32(sp)
 5f4:	ec4e                	sd	s3,24(sp)
 5f6:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5f8:	c299                	beqz	a3,5fe <printint+0x14>
 5fa:	0005cd63          	bltz	a1,614 <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5fe:	2581                	sext.w	a1,a1
  neg = 0;
 600:	4301                	li	t1,0
 602:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
 606:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
 608:	2601                	sext.w	a2,a2
 60a:	00000897          	auipc	a7,0x0
 60e:	5be88893          	addi	a7,a7,1470 # bc8 <digits>
 612:	a801                	j	622 <printint+0x38>
    x = -xx;
 614:	40b005bb          	negw	a1,a1
 618:	2581                	sext.w	a1,a1
    neg = 1;
 61a:	4305                	li	t1,1
    x = -xx;
 61c:	b7dd                	j	602 <printint+0x18>
  }while((x /= base) != 0);
 61e:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
 620:	8836                	mv	a6,a3
 622:	0018069b          	addiw	a3,a6,1
 626:	02c5f7bb          	remuw	a5,a1,a2
 62a:	1782                	slli	a5,a5,0x20
 62c:	9381                	srli	a5,a5,0x20
 62e:	97c6                	add	a5,a5,a7
 630:	0007c783          	lbu	a5,0(a5)
 634:	00f70023          	sb	a5,0(a4)
 638:	0705                	addi	a4,a4,1
  }while((x /= base) != 0);
 63a:	02c5d7bb          	divuw	a5,a1,a2
 63e:	fec5f0e3          	bleu	a2,a1,61e <printint+0x34>
  if(neg)
 642:	00030b63          	beqz	t1,658 <printint+0x6e>
    buf[i++] = '-';
 646:	fd040793          	addi	a5,s0,-48
 64a:	96be                	add	a3,a3,a5
 64c:	02d00793          	li	a5,45
 650:	fef68823          	sb	a5,-16(a3)
 654:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
 658:	02d05963          	blez	a3,68a <printint+0xa0>
 65c:	89aa                	mv	s3,a0
 65e:	fc040793          	addi	a5,s0,-64
 662:	00d784b3          	add	s1,a5,a3
 666:	fff78913          	addi	s2,a5,-1
 66a:	9936                	add	s2,s2,a3
 66c:	36fd                	addiw	a3,a3,-1
 66e:	1682                	slli	a3,a3,0x20
 670:	9281                	srli	a3,a3,0x20
 672:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
 676:	fff4c583          	lbu	a1,-1(s1)
 67a:	854e                	mv	a0,s3
 67c:	00000097          	auipc	ra,0x0
 680:	f4c080e7          	jalr	-180(ra) # 5c8 <putc>
 684:	14fd                	addi	s1,s1,-1
  while(--i >= 0)
 686:	ff2498e3          	bne	s1,s2,676 <printint+0x8c>
}
 68a:	70e2                	ld	ra,56(sp)
 68c:	7442                	ld	s0,48(sp)
 68e:	74a2                	ld	s1,40(sp)
 690:	7902                	ld	s2,32(sp)
 692:	69e2                	ld	s3,24(sp)
 694:	6121                	addi	sp,sp,64
 696:	8082                	ret

0000000000000698 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 698:	7119                	addi	sp,sp,-128
 69a:	fc86                	sd	ra,120(sp)
 69c:	f8a2                	sd	s0,112(sp)
 69e:	f4a6                	sd	s1,104(sp)
 6a0:	f0ca                	sd	s2,96(sp)
 6a2:	ecce                	sd	s3,88(sp)
 6a4:	e8d2                	sd	s4,80(sp)
 6a6:	e4d6                	sd	s5,72(sp)
 6a8:	e0da                	sd	s6,64(sp)
 6aa:	fc5e                	sd	s7,56(sp)
 6ac:	f862                	sd	s8,48(sp)
 6ae:	f466                	sd	s9,40(sp)
 6b0:	f06a                	sd	s10,32(sp)
 6b2:	ec6e                	sd	s11,24(sp)
 6b4:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6b6:	0005c483          	lbu	s1,0(a1)
 6ba:	18048d63          	beqz	s1,854 <vprintf+0x1bc>
 6be:	8aaa                	mv	s5,a0
 6c0:	8b32                	mv	s6,a2
 6c2:	00158913          	addi	s2,a1,1
  state = 0;
 6c6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6c8:	02500a13          	li	s4,37
      if(c == 'd'){
 6cc:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 6d0:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 6d4:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 6d8:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6dc:	00000b97          	auipc	s7,0x0
 6e0:	4ecb8b93          	addi	s7,s7,1260 # bc8 <digits>
 6e4:	a839                	j	702 <vprintf+0x6a>
        putc(fd, c);
 6e6:	85a6                	mv	a1,s1
 6e8:	8556                	mv	a0,s5
 6ea:	00000097          	auipc	ra,0x0
 6ee:	ede080e7          	jalr	-290(ra) # 5c8 <putc>
 6f2:	a019                	j	6f8 <vprintf+0x60>
    } else if(state == '%'){
 6f4:	01498f63          	beq	s3,s4,712 <vprintf+0x7a>
 6f8:	0905                	addi	s2,s2,1
  for(i = 0; fmt[i]; i++){
 6fa:	fff94483          	lbu	s1,-1(s2)
 6fe:	14048b63          	beqz	s1,854 <vprintf+0x1bc>
    c = fmt[i] & 0xff;
 702:	0004879b          	sext.w	a5,s1
    if(state == 0){
 706:	fe0997e3          	bnez	s3,6f4 <vprintf+0x5c>
      if(c == '%'){
 70a:	fd479ee3          	bne	a5,s4,6e6 <vprintf+0x4e>
        state = '%';
 70e:	89be                	mv	s3,a5
 710:	b7e5                	j	6f8 <vprintf+0x60>
      if(c == 'd'){
 712:	05878063          	beq	a5,s8,752 <vprintf+0xba>
      } else if(c == 'l') {
 716:	05978c63          	beq	a5,s9,76e <vprintf+0xd6>
      } else if(c == 'x') {
 71a:	07a78863          	beq	a5,s10,78a <vprintf+0xf2>
      } else if(c == 'p') {
 71e:	09b78463          	beq	a5,s11,7a6 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 722:	07300713          	li	a4,115
 726:	0ce78563          	beq	a5,a4,7f0 <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 72a:	06300713          	li	a4,99
 72e:	0ee78c63          	beq	a5,a4,826 <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 732:	11478663          	beq	a5,s4,83e <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 736:	85d2                	mv	a1,s4
 738:	8556                	mv	a0,s5
 73a:	00000097          	auipc	ra,0x0
 73e:	e8e080e7          	jalr	-370(ra) # 5c8 <putc>
        putc(fd, c);
 742:	85a6                	mv	a1,s1
 744:	8556                	mv	a0,s5
 746:	00000097          	auipc	ra,0x0
 74a:	e82080e7          	jalr	-382(ra) # 5c8 <putc>
      }
      state = 0;
 74e:	4981                	li	s3,0
 750:	b765                	j	6f8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 752:	008b0493          	addi	s1,s6,8
 756:	4685                	li	a3,1
 758:	4629                	li	a2,10
 75a:	000b2583          	lw	a1,0(s6)
 75e:	8556                	mv	a0,s5
 760:	00000097          	auipc	ra,0x0
 764:	e8a080e7          	jalr	-374(ra) # 5ea <printint>
 768:	8b26                	mv	s6,s1
      state = 0;
 76a:	4981                	li	s3,0
 76c:	b771                	j	6f8 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 76e:	008b0493          	addi	s1,s6,8
 772:	4681                	li	a3,0
 774:	4629                	li	a2,10
 776:	000b2583          	lw	a1,0(s6)
 77a:	8556                	mv	a0,s5
 77c:	00000097          	auipc	ra,0x0
 780:	e6e080e7          	jalr	-402(ra) # 5ea <printint>
 784:	8b26                	mv	s6,s1
      state = 0;
 786:	4981                	li	s3,0
 788:	bf85                	j	6f8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 78a:	008b0493          	addi	s1,s6,8
 78e:	4681                	li	a3,0
 790:	4641                	li	a2,16
 792:	000b2583          	lw	a1,0(s6)
 796:	8556                	mv	a0,s5
 798:	00000097          	auipc	ra,0x0
 79c:	e52080e7          	jalr	-430(ra) # 5ea <printint>
 7a0:	8b26                	mv	s6,s1
      state = 0;
 7a2:	4981                	li	s3,0
 7a4:	bf91                	j	6f8 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7a6:	008b0793          	addi	a5,s6,8
 7aa:	f8f43423          	sd	a5,-120(s0)
 7ae:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7b2:	03000593          	li	a1,48
 7b6:	8556                	mv	a0,s5
 7b8:	00000097          	auipc	ra,0x0
 7bc:	e10080e7          	jalr	-496(ra) # 5c8 <putc>
  putc(fd, 'x');
 7c0:	85ea                	mv	a1,s10
 7c2:	8556                	mv	a0,s5
 7c4:	00000097          	auipc	ra,0x0
 7c8:	e04080e7          	jalr	-508(ra) # 5c8 <putc>
 7cc:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7ce:	03c9d793          	srli	a5,s3,0x3c
 7d2:	97de                	add	a5,a5,s7
 7d4:	0007c583          	lbu	a1,0(a5)
 7d8:	8556                	mv	a0,s5
 7da:	00000097          	auipc	ra,0x0
 7de:	dee080e7          	jalr	-530(ra) # 5c8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7e2:	0992                	slli	s3,s3,0x4
 7e4:	34fd                	addiw	s1,s1,-1
 7e6:	f4e5                	bnez	s1,7ce <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 7e8:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7ec:	4981                	li	s3,0
 7ee:	b729                	j	6f8 <vprintf+0x60>
        s = va_arg(ap, char*);
 7f0:	008b0993          	addi	s3,s6,8
 7f4:	000b3483          	ld	s1,0(s6)
        if(s == 0)
 7f8:	c085                	beqz	s1,818 <vprintf+0x180>
        while(*s != 0){
 7fa:	0004c583          	lbu	a1,0(s1)
 7fe:	c9a1                	beqz	a1,84e <vprintf+0x1b6>
          putc(fd, *s);
 800:	8556                	mv	a0,s5
 802:	00000097          	auipc	ra,0x0
 806:	dc6080e7          	jalr	-570(ra) # 5c8 <putc>
          s++;
 80a:	0485                	addi	s1,s1,1
        while(*s != 0){
 80c:	0004c583          	lbu	a1,0(s1)
 810:	f9e5                	bnez	a1,800 <vprintf+0x168>
        s = va_arg(ap, char*);
 812:	8b4e                	mv	s6,s3
      state = 0;
 814:	4981                	li	s3,0
 816:	b5cd                	j	6f8 <vprintf+0x60>
          s = "(null)";
 818:	00000497          	auipc	s1,0x0
 81c:	3c848493          	addi	s1,s1,968 # be0 <digits+0x18>
        while(*s != 0){
 820:	02800593          	li	a1,40
 824:	bff1                	j	800 <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
 826:	008b0493          	addi	s1,s6,8
 82a:	000b4583          	lbu	a1,0(s6)
 82e:	8556                	mv	a0,s5
 830:	00000097          	auipc	ra,0x0
 834:	d98080e7          	jalr	-616(ra) # 5c8 <putc>
 838:	8b26                	mv	s6,s1
      state = 0;
 83a:	4981                	li	s3,0
 83c:	bd75                	j	6f8 <vprintf+0x60>
        putc(fd, c);
 83e:	85d2                	mv	a1,s4
 840:	8556                	mv	a0,s5
 842:	00000097          	auipc	ra,0x0
 846:	d86080e7          	jalr	-634(ra) # 5c8 <putc>
      state = 0;
 84a:	4981                	li	s3,0
 84c:	b575                	j	6f8 <vprintf+0x60>
        s = va_arg(ap, char*);
 84e:	8b4e                	mv	s6,s3
      state = 0;
 850:	4981                	li	s3,0
 852:	b55d                	j	6f8 <vprintf+0x60>
    }
  }
}
 854:	70e6                	ld	ra,120(sp)
 856:	7446                	ld	s0,112(sp)
 858:	74a6                	ld	s1,104(sp)
 85a:	7906                	ld	s2,96(sp)
 85c:	69e6                	ld	s3,88(sp)
 85e:	6a46                	ld	s4,80(sp)
 860:	6aa6                	ld	s5,72(sp)
 862:	6b06                	ld	s6,64(sp)
 864:	7be2                	ld	s7,56(sp)
 866:	7c42                	ld	s8,48(sp)
 868:	7ca2                	ld	s9,40(sp)
 86a:	7d02                	ld	s10,32(sp)
 86c:	6de2                	ld	s11,24(sp)
 86e:	6109                	addi	sp,sp,128
 870:	8082                	ret

0000000000000872 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 872:	715d                	addi	sp,sp,-80
 874:	ec06                	sd	ra,24(sp)
 876:	e822                	sd	s0,16(sp)
 878:	1000                	addi	s0,sp,32
 87a:	e010                	sd	a2,0(s0)
 87c:	e414                	sd	a3,8(s0)
 87e:	e818                	sd	a4,16(s0)
 880:	ec1c                	sd	a5,24(s0)
 882:	03043023          	sd	a6,32(s0)
 886:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 88a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 88e:	8622                	mv	a2,s0
 890:	00000097          	auipc	ra,0x0
 894:	e08080e7          	jalr	-504(ra) # 698 <vprintf>
}
 898:	60e2                	ld	ra,24(sp)
 89a:	6442                	ld	s0,16(sp)
 89c:	6161                	addi	sp,sp,80
 89e:	8082                	ret

00000000000008a0 <printf>:

void
printf(const char *fmt, ...)
{
 8a0:	711d                	addi	sp,sp,-96
 8a2:	ec06                	sd	ra,24(sp)
 8a4:	e822                	sd	s0,16(sp)
 8a6:	1000                	addi	s0,sp,32
 8a8:	e40c                	sd	a1,8(s0)
 8aa:	e810                	sd	a2,16(s0)
 8ac:	ec14                	sd	a3,24(s0)
 8ae:	f018                	sd	a4,32(s0)
 8b0:	f41c                	sd	a5,40(s0)
 8b2:	03043823          	sd	a6,48(s0)
 8b6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8ba:	00840613          	addi	a2,s0,8
 8be:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8c2:	85aa                	mv	a1,a0
 8c4:	4505                	li	a0,1
 8c6:	00000097          	auipc	ra,0x0
 8ca:	dd2080e7          	jalr	-558(ra) # 698 <vprintf>
}
 8ce:	60e2                	ld	ra,24(sp)
 8d0:	6442                	ld	s0,16(sp)
 8d2:	6125                	addi	sp,sp,96
 8d4:	8082                	ret

00000000000008d6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8d6:	1141                	addi	sp,sp,-16
 8d8:	e422                	sd	s0,8(sp)
 8da:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8dc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e0:	00000797          	auipc	a5,0x0
 8e4:	30878793          	addi	a5,a5,776 # be8 <__bss_start>
 8e8:	639c                	ld	a5,0(a5)
 8ea:	a805                	j	91a <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8ec:	4618                	lw	a4,8(a2)
 8ee:	9db9                	addw	a1,a1,a4
 8f0:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8f4:	6398                	ld	a4,0(a5)
 8f6:	6318                	ld	a4,0(a4)
 8f8:	fee53823          	sd	a4,-16(a0)
 8fc:	a091                	j	940 <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8fe:	ff852703          	lw	a4,-8(a0)
 902:	9e39                	addw	a2,a2,a4
 904:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 906:	ff053703          	ld	a4,-16(a0)
 90a:	e398                	sd	a4,0(a5)
 90c:	a099                	j	952 <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 90e:	6398                	ld	a4,0(a5)
 910:	00e7e463          	bltu	a5,a4,918 <free+0x42>
 914:	00e6ea63          	bltu	a3,a4,928 <free+0x52>
{
 918:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 91a:	fed7fae3          	bleu	a3,a5,90e <free+0x38>
 91e:	6398                	ld	a4,0(a5)
 920:	00e6e463          	bltu	a3,a4,928 <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 924:	fee7eae3          	bltu	a5,a4,918 <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
 928:	ff852583          	lw	a1,-8(a0)
 92c:	6390                	ld	a2,0(a5)
 92e:	02059713          	slli	a4,a1,0x20
 932:	9301                	srli	a4,a4,0x20
 934:	0712                	slli	a4,a4,0x4
 936:	9736                	add	a4,a4,a3
 938:	fae60ae3          	beq	a2,a4,8ec <free+0x16>
    bp->s.ptr = p->s.ptr;
 93c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 940:	4790                	lw	a2,8(a5)
 942:	02061713          	slli	a4,a2,0x20
 946:	9301                	srli	a4,a4,0x20
 948:	0712                	slli	a4,a4,0x4
 94a:	973e                	add	a4,a4,a5
 94c:	fae689e3          	beq	a3,a4,8fe <free+0x28>
  } else
    p->s.ptr = bp;
 950:	e394                	sd	a3,0(a5)
  freep = p;
 952:	00000717          	auipc	a4,0x0
 956:	28f73b23          	sd	a5,662(a4) # be8 <__bss_start>
}
 95a:	6422                	ld	s0,8(sp)
 95c:	0141                	addi	sp,sp,16
 95e:	8082                	ret

0000000000000960 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 960:	7139                	addi	sp,sp,-64
 962:	fc06                	sd	ra,56(sp)
 964:	f822                	sd	s0,48(sp)
 966:	f426                	sd	s1,40(sp)
 968:	f04a                	sd	s2,32(sp)
 96a:	ec4e                	sd	s3,24(sp)
 96c:	e852                	sd	s4,16(sp)
 96e:	e456                	sd	s5,8(sp)
 970:	e05a                	sd	s6,0(sp)
 972:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 974:	02051993          	slli	s3,a0,0x20
 978:	0209d993          	srli	s3,s3,0x20
 97c:	09bd                	addi	s3,s3,15
 97e:	0049d993          	srli	s3,s3,0x4
 982:	2985                	addiw	s3,s3,1
 984:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
 988:	00000797          	auipc	a5,0x0
 98c:	26078793          	addi	a5,a5,608 # be8 <__bss_start>
 990:	6388                	ld	a0,0(a5)
 992:	c515                	beqz	a0,9be <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 994:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 996:	4798                	lw	a4,8(a5)
 998:	03277f63          	bleu	s2,a4,9d6 <malloc+0x76>
 99c:	8a4e                	mv	s4,s3
 99e:	0009871b          	sext.w	a4,s3
 9a2:	6685                	lui	a3,0x1
 9a4:	00d77363          	bleu	a3,a4,9aa <malloc+0x4a>
 9a8:	6a05                	lui	s4,0x1
 9aa:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
 9ae:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9b2:	00000497          	auipc	s1,0x0
 9b6:	23648493          	addi	s1,s1,566 # be8 <__bss_start>
  if(p == (char*)-1)
 9ba:	5b7d                	li	s6,-1
 9bc:	a885                	j	a2c <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
 9be:	00000797          	auipc	a5,0x0
 9c2:	23278793          	addi	a5,a5,562 # bf0 <base>
 9c6:	00000717          	auipc	a4,0x0
 9ca:	22f73123          	sd	a5,546(a4) # be8 <__bss_start>
 9ce:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9d0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9d4:	b7e1                	j	99c <malloc+0x3c>
      if(p->s.size == nunits)
 9d6:	02e90b63          	beq	s2,a4,a0c <malloc+0xac>
        p->s.size -= nunits;
 9da:	4137073b          	subw	a4,a4,s3
 9de:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9e0:	1702                	slli	a4,a4,0x20
 9e2:	9301                	srli	a4,a4,0x20
 9e4:	0712                	slli	a4,a4,0x4
 9e6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9e8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ec:	00000717          	auipc	a4,0x0
 9f0:	1ea73e23          	sd	a0,508(a4) # be8 <__bss_start>
      return (void*)(p + 1);
 9f4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9f8:	70e2                	ld	ra,56(sp)
 9fa:	7442                	ld	s0,48(sp)
 9fc:	74a2                	ld	s1,40(sp)
 9fe:	7902                	ld	s2,32(sp)
 a00:	69e2                	ld	s3,24(sp)
 a02:	6a42                	ld	s4,16(sp)
 a04:	6aa2                	ld	s5,8(sp)
 a06:	6b02                	ld	s6,0(sp)
 a08:	6121                	addi	sp,sp,64
 a0a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a0c:	6398                	ld	a4,0(a5)
 a0e:	e118                	sd	a4,0(a0)
 a10:	bff1                	j	9ec <malloc+0x8c>
  hp->s.size = nu;
 a12:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
 a16:	0541                	addi	a0,a0,16
 a18:	00000097          	auipc	ra,0x0
 a1c:	ebe080e7          	jalr	-322(ra) # 8d6 <free>
  return freep;
 a20:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a22:	d979                	beqz	a0,9f8 <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a24:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a26:	4798                	lw	a4,8(a5)
 a28:	fb2777e3          	bleu	s2,a4,9d6 <malloc+0x76>
    if(p == freep)
 a2c:	6098                	ld	a4,0(s1)
 a2e:	853e                	mv	a0,a5
 a30:	fef71ae3          	bne	a4,a5,a24 <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
 a34:	8552                	mv	a0,s4
 a36:	00000097          	auipc	ra,0x0
 a3a:	b72080e7          	jalr	-1166(ra) # 5a8 <sbrk>
  if(p == (char*)-1)
 a3e:	fd651ae3          	bne	a0,s6,a12 <malloc+0xb2>
        return 0;
 a42:	4501                	li	a0,0
 a44:	bf55                	j	9f8 <malloc+0x98>
