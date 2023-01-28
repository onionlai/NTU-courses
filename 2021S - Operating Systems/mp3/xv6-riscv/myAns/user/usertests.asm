
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00005097          	auipc	ra,0x5
      14:	63c080e7          	jalr	1596(ra) # 564c <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00005097          	auipc	ra,0x5
      26:	62a080e7          	jalr	1578(ra) # 564c <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	e9a50513          	addi	a0,a0,-358 # 5ed8 <longjmp_1+0x328>
      46:	00006097          	auipc	ra,0x6
      4a:	956080e7          	jalr	-1706(ra) # 599c <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00005097          	auipc	ra,0x5
      54:	5bc080e7          	jalr	1468(ra) # 560c <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	00009797          	auipc	a5,0x9
      5c:	3c078793          	addi	a5,a5,960 # 9418 <uninit>
      60:	0000c697          	auipc	a3,0xc
      64:	ac868693          	addi	a3,a3,-1336 # bb28 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	e7850513          	addi	a0,a0,-392 # 5ef8 <longjmp_1+0x348>
      88:	00006097          	auipc	ra,0x6
      8c:	914080e7          	jalr	-1772(ra) # 599c <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00005097          	auipc	ra,0x5
      96:	57a080e7          	jalr	1402(ra) # 560c <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	e6850513          	addi	a0,a0,-408 # 5f10 <longjmp_1+0x360>
      b0:	00005097          	auipc	ra,0x5
      b4:	59c080e7          	jalr	1436(ra) # 564c <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00005097          	auipc	ra,0x5
      c0:	578080e7          	jalr	1400(ra) # 5634 <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	e6a50513          	addi	a0,a0,-406 # 5f30 <longjmp_1+0x380>
      ce:	00005097          	auipc	ra,0x5
      d2:	57e080e7          	jalr	1406(ra) # 564c <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	e3250513          	addi	a0,a0,-462 # 5f18 <longjmp_1+0x368>
      ee:	00006097          	auipc	ra,0x6
      f2:	8ae080e7          	jalr	-1874(ra) # 599c <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00005097          	auipc	ra,0x5
      fc:	514080e7          	jalr	1300(ra) # 560c <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	e3e50513          	addi	a0,a0,-450 # 5f40 <longjmp_1+0x390>
     10a:	00006097          	auipc	ra,0x6
     10e:	892080e7          	jalr	-1902(ra) # 599c <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00005097          	auipc	ra,0x5
     118:	4f8080e7          	jalr	1272(ra) # 560c <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	e3c50513          	addi	a0,a0,-452 # 5f68 <longjmp_1+0x3b8>
     134:	00005097          	auipc	ra,0x5
     138:	528080e7          	jalr	1320(ra) # 565c <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	e2850513          	addi	a0,a0,-472 # 5f68 <longjmp_1+0x3b8>
     148:	00005097          	auipc	ra,0x5
     14c:	504080e7          	jalr	1284(ra) # 564c <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	e2458593          	addi	a1,a1,-476 # 5f78 <longjmp_1+0x3c8>
     15c:	00005097          	auipc	ra,0x5
     160:	4d0080e7          	jalr	1232(ra) # 562c <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	e0050513          	addi	a0,a0,-512 # 5f68 <longjmp_1+0x3b8>
     170:	00005097          	auipc	ra,0x5
     174:	4dc080e7          	jalr	1244(ra) # 564c <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	e0458593          	addi	a1,a1,-508 # 5f80 <longjmp_1+0x3d0>
     184:	8526                	mv	a0,s1
     186:	00005097          	auipc	ra,0x5
     18a:	4a6080e7          	jalr	1190(ra) # 562c <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	dd450513          	addi	a0,a0,-556 # 5f68 <longjmp_1+0x3b8>
     19c:	00005097          	auipc	ra,0x5
     1a0:	4c0080e7          	jalr	1216(ra) # 565c <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00005097          	auipc	ra,0x5
     1aa:	48e080e7          	jalr	1166(ra) # 5634 <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00005097          	auipc	ra,0x5
     1b4:	484080e7          	jalr	1156(ra) # 5634 <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	dbe50513          	addi	a0,a0,-578 # 5f88 <longjmp_1+0x3d8>
     1d2:	00005097          	auipc	ra,0x5
     1d6:	7ca080e7          	jalr	1994(ra) # 599c <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00005097          	auipc	ra,0x5
     1e0:	430080e7          	jalr	1072(ra) # 560c <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	addi	a0,s0,-40
     210:	00005097          	auipc	ra,0x5
     214:	43c080e7          	jalr	1084(ra) # 564c <open>
    close(fd);
     218:	00005097          	auipc	ra,0x5
     21c:	41c080e7          	jalr	1052(ra) # 5634 <close>
  for(i = 0; i < N; i++){
     220:	2485                	addiw	s1,s1,1
     222:	0ff4f493          	andi	s1,s1,255
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	addi	a0,s0,-40
     246:	00005097          	auipc	ra,0x5
     24a:	416080e7          	jalr	1046(ra) # 565c <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addiw	s1,s1,1
     250:	0ff4f493          	andi	s1,s1,255
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	addi	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	addi	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	addi	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	b0c50513          	addi	a0,a0,-1268 # 5d88 <longjmp_1+0x1d8>
     284:	00005097          	auipc	ra,0x5
     288:	3d8080e7          	jalr	984(ra) # 565c <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	af8a8a93          	addi	s5,s5,-1288 # 5d88 <longjmp_1+0x1d8>
      int cc = write(fd, buf, sz);
     298:	0000ca17          	auipc	s4,0xc
     29c:	890a0a13          	addi	s4,s4,-1904 # bb28 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <subdir+0x173>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00005097          	auipc	ra,0x5
     2b0:	3a0080e7          	jalr	928(ra) # 564c <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00005097          	auipc	ra,0x5
     2c2:	36e080e7          	jalr	878(ra) # 562c <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49463          	bne	s1,a0,330 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00005097          	auipc	ra,0x5
     2d6:	35a080e7          	jalr	858(ra) # 562c <write>
      if(cc != sz){
     2da:	04951963          	bne	a0,s1,32c <bigwrite+0xc8>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00005097          	auipc	ra,0x5
     2e4:	354080e7          	jalr	852(ra) # 5634 <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00005097          	auipc	ra,0x5
     2ee:	372080e7          	jalr	882(ra) # 565c <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addiw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	addi	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	c9e50513          	addi	a0,a0,-866 # 5fb0 <longjmp_1+0x400>
     31a:	00005097          	auipc	ra,0x5
     31e:	682080e7          	jalr	1666(ra) # 599c <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00005097          	auipc	ra,0x5
     328:	2e8080e7          	jalr	744(ra) # 560c <exit>
     32c:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     32e:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     330:	86ce                	mv	a3,s3
     332:	8626                	mv	a2,s1
     334:	85de                	mv	a1,s7
     336:	00006517          	auipc	a0,0x6
     33a:	c9a50513          	addi	a0,a0,-870 # 5fd0 <longjmp_1+0x420>
     33e:	00005097          	auipc	ra,0x5
     342:	65e080e7          	jalr	1630(ra) # 599c <printf>
        exit(1);
     346:	4505                	li	a0,1
     348:	00005097          	auipc	ra,0x5
     34c:	2c4080e7          	jalr	708(ra) # 560c <exit>

0000000000000350 <copyin>:
{
     350:	715d                	addi	sp,sp,-80
     352:	e486                	sd	ra,72(sp)
     354:	e0a2                	sd	s0,64(sp)
     356:	fc26                	sd	s1,56(sp)
     358:	f84a                	sd	s2,48(sp)
     35a:	f44e                	sd	s3,40(sp)
     35c:	f052                	sd	s4,32(sp)
     35e:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     360:	4785                	li	a5,1
     362:	07fe                	slli	a5,a5,0x1f
     364:	fcf43023          	sd	a5,-64(s0)
     368:	57fd                	li	a5,-1
     36a:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     36e:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     372:	00006a17          	auipc	s4,0x6
     376:	c76a0a13          	addi	s4,s4,-906 # 5fe8 <longjmp_1+0x438>
    uint64 addr = addrs[ai];
     37a:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     37e:	20100593          	li	a1,513
     382:	8552                	mv	a0,s4
     384:	00005097          	auipc	ra,0x5
     388:	2c8080e7          	jalr	712(ra) # 564c <open>
     38c:	84aa                	mv	s1,a0
    if(fd < 0){
     38e:	08054863          	bltz	a0,41e <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     392:	6609                	lui	a2,0x2
     394:	85ce                	mv	a1,s3
     396:	00005097          	auipc	ra,0x5
     39a:	296080e7          	jalr	662(ra) # 562c <write>
    if(n >= 0){
     39e:	08055d63          	bgez	a0,438 <copyin+0xe8>
    close(fd);
     3a2:	8526                	mv	a0,s1
     3a4:	00005097          	auipc	ra,0x5
     3a8:	290080e7          	jalr	656(ra) # 5634 <close>
    unlink("copyin1");
     3ac:	8552                	mv	a0,s4
     3ae:	00005097          	auipc	ra,0x5
     3b2:	2ae080e7          	jalr	686(ra) # 565c <unlink>
    n = write(1, (char*)addr, 8192);
     3b6:	6609                	lui	a2,0x2
     3b8:	85ce                	mv	a1,s3
     3ba:	4505                	li	a0,1
     3bc:	00005097          	auipc	ra,0x5
     3c0:	270080e7          	jalr	624(ra) # 562c <write>
    if(n > 0){
     3c4:	08a04963          	bgtz	a0,456 <copyin+0x106>
    if(pipe(fds) < 0){
     3c8:	fb840513          	addi	a0,s0,-72
     3cc:	00005097          	auipc	ra,0x5
     3d0:	250080e7          	jalr	592(ra) # 561c <pipe>
     3d4:	0a054063          	bltz	a0,474 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     3d8:	6609                	lui	a2,0x2
     3da:	85ce                	mv	a1,s3
     3dc:	fbc42503          	lw	a0,-68(s0)
     3e0:	00005097          	auipc	ra,0x5
     3e4:	24c080e7          	jalr	588(ra) # 562c <write>
    if(n > 0){
     3e8:	0aa04363          	bgtz	a0,48e <copyin+0x13e>
    close(fds[0]);
     3ec:	fb842503          	lw	a0,-72(s0)
     3f0:	00005097          	auipc	ra,0x5
     3f4:	244080e7          	jalr	580(ra) # 5634 <close>
    close(fds[1]);
     3f8:	fbc42503          	lw	a0,-68(s0)
     3fc:	00005097          	auipc	ra,0x5
     400:	238080e7          	jalr	568(ra) # 5634 <close>
  for(int ai = 0; ai < 2; ai++){
     404:	0921                	addi	s2,s2,8
     406:	fd040793          	addi	a5,s0,-48
     40a:	f6f918e3          	bne	s2,a5,37a <copyin+0x2a>
}
     40e:	60a6                	ld	ra,72(sp)
     410:	6406                	ld	s0,64(sp)
     412:	74e2                	ld	s1,56(sp)
     414:	7942                	ld	s2,48(sp)
     416:	79a2                	ld	s3,40(sp)
     418:	7a02                	ld	s4,32(sp)
     41a:	6161                	addi	sp,sp,80
     41c:	8082                	ret
      printf("open(copyin1) failed\n");
     41e:	00006517          	auipc	a0,0x6
     422:	bd250513          	addi	a0,a0,-1070 # 5ff0 <longjmp_1+0x440>
     426:	00005097          	auipc	ra,0x5
     42a:	576080e7          	jalr	1398(ra) # 599c <printf>
      exit(1);
     42e:	4505                	li	a0,1
     430:	00005097          	auipc	ra,0x5
     434:	1dc080e7          	jalr	476(ra) # 560c <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     438:	862a                	mv	a2,a0
     43a:	85ce                	mv	a1,s3
     43c:	00006517          	auipc	a0,0x6
     440:	bcc50513          	addi	a0,a0,-1076 # 6008 <longjmp_1+0x458>
     444:	00005097          	auipc	ra,0x5
     448:	558080e7          	jalr	1368(ra) # 599c <printf>
      exit(1);
     44c:	4505                	li	a0,1
     44e:	00005097          	auipc	ra,0x5
     452:	1be080e7          	jalr	446(ra) # 560c <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     456:	862a                	mv	a2,a0
     458:	85ce                	mv	a1,s3
     45a:	00006517          	auipc	a0,0x6
     45e:	bde50513          	addi	a0,a0,-1058 # 6038 <longjmp_1+0x488>
     462:	00005097          	auipc	ra,0x5
     466:	53a080e7          	jalr	1338(ra) # 599c <printf>
      exit(1);
     46a:	4505                	li	a0,1
     46c:	00005097          	auipc	ra,0x5
     470:	1a0080e7          	jalr	416(ra) # 560c <exit>
      printf("pipe() failed\n");
     474:	00006517          	auipc	a0,0x6
     478:	bf450513          	addi	a0,a0,-1036 # 6068 <longjmp_1+0x4b8>
     47c:	00005097          	auipc	ra,0x5
     480:	520080e7          	jalr	1312(ra) # 599c <printf>
      exit(1);
     484:	4505                	li	a0,1
     486:	00005097          	auipc	ra,0x5
     48a:	186080e7          	jalr	390(ra) # 560c <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     48e:	862a                	mv	a2,a0
     490:	85ce                	mv	a1,s3
     492:	00006517          	auipc	a0,0x6
     496:	be650513          	addi	a0,a0,-1050 # 6078 <longjmp_1+0x4c8>
     49a:	00005097          	auipc	ra,0x5
     49e:	502080e7          	jalr	1282(ra) # 599c <printf>
      exit(1);
     4a2:	4505                	li	a0,1
     4a4:	00005097          	auipc	ra,0x5
     4a8:	168080e7          	jalr	360(ra) # 560c <exit>

00000000000004ac <copyout>:
{
     4ac:	711d                	addi	sp,sp,-96
     4ae:	ec86                	sd	ra,88(sp)
     4b0:	e8a2                	sd	s0,80(sp)
     4b2:	e4a6                	sd	s1,72(sp)
     4b4:	e0ca                	sd	s2,64(sp)
     4b6:	fc4e                	sd	s3,56(sp)
     4b8:	f852                	sd	s4,48(sp)
     4ba:	f456                	sd	s5,40(sp)
     4bc:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     4be:	4785                	li	a5,1
     4c0:	07fe                	slli	a5,a5,0x1f
     4c2:	faf43823          	sd	a5,-80(s0)
     4c6:	57fd                	li	a5,-1
     4c8:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     4cc:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     4d0:	00006a17          	auipc	s4,0x6
     4d4:	bd8a0a13          	addi	s4,s4,-1064 # 60a8 <longjmp_1+0x4f8>
    n = write(fds[1], "x", 1);
     4d8:	00006a97          	auipc	s5,0x6
     4dc:	aa8a8a93          	addi	s5,s5,-1368 # 5f80 <longjmp_1+0x3d0>
    uint64 addr = addrs[ai];
     4e0:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     4e4:	4581                	li	a1,0
     4e6:	8552                	mv	a0,s4
     4e8:	00005097          	auipc	ra,0x5
     4ec:	164080e7          	jalr	356(ra) # 564c <open>
     4f0:	84aa                	mv	s1,a0
    if(fd < 0){
     4f2:	08054663          	bltz	a0,57e <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     4f6:	6609                	lui	a2,0x2
     4f8:	85ce                	mv	a1,s3
     4fa:	00005097          	auipc	ra,0x5
     4fe:	12a080e7          	jalr	298(ra) # 5624 <read>
    if(n > 0){
     502:	08a04b63          	bgtz	a0,598 <copyout+0xec>
    close(fd);
     506:	8526                	mv	a0,s1
     508:	00005097          	auipc	ra,0x5
     50c:	12c080e7          	jalr	300(ra) # 5634 <close>
    if(pipe(fds) < 0){
     510:	fa840513          	addi	a0,s0,-88
     514:	00005097          	auipc	ra,0x5
     518:	108080e7          	jalr	264(ra) # 561c <pipe>
     51c:	08054d63          	bltz	a0,5b6 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     520:	4605                	li	a2,1
     522:	85d6                	mv	a1,s5
     524:	fac42503          	lw	a0,-84(s0)
     528:	00005097          	auipc	ra,0x5
     52c:	104080e7          	jalr	260(ra) # 562c <write>
    if(n != 1){
     530:	4785                	li	a5,1
     532:	08f51f63          	bne	a0,a5,5d0 <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     536:	6609                	lui	a2,0x2
     538:	85ce                	mv	a1,s3
     53a:	fa842503          	lw	a0,-88(s0)
     53e:	00005097          	auipc	ra,0x5
     542:	0e6080e7          	jalr	230(ra) # 5624 <read>
    if(n > 0){
     546:	0aa04263          	bgtz	a0,5ea <copyout+0x13e>
    close(fds[0]);
     54a:	fa842503          	lw	a0,-88(s0)
     54e:	00005097          	auipc	ra,0x5
     552:	0e6080e7          	jalr	230(ra) # 5634 <close>
    close(fds[1]);
     556:	fac42503          	lw	a0,-84(s0)
     55a:	00005097          	auipc	ra,0x5
     55e:	0da080e7          	jalr	218(ra) # 5634 <close>
  for(int ai = 0; ai < 2; ai++){
     562:	0921                	addi	s2,s2,8
     564:	fc040793          	addi	a5,s0,-64
     568:	f6f91ce3          	bne	s2,a5,4e0 <copyout+0x34>
}
     56c:	60e6                	ld	ra,88(sp)
     56e:	6446                	ld	s0,80(sp)
     570:	64a6                	ld	s1,72(sp)
     572:	6906                	ld	s2,64(sp)
     574:	79e2                	ld	s3,56(sp)
     576:	7a42                	ld	s4,48(sp)
     578:	7aa2                	ld	s5,40(sp)
     57a:	6125                	addi	sp,sp,96
     57c:	8082                	ret
      printf("open(README) failed\n");
     57e:	00006517          	auipc	a0,0x6
     582:	b3250513          	addi	a0,a0,-1230 # 60b0 <longjmp_1+0x500>
     586:	00005097          	auipc	ra,0x5
     58a:	416080e7          	jalr	1046(ra) # 599c <printf>
      exit(1);
     58e:	4505                	li	a0,1
     590:	00005097          	auipc	ra,0x5
     594:	07c080e7          	jalr	124(ra) # 560c <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     598:	862a                	mv	a2,a0
     59a:	85ce                	mv	a1,s3
     59c:	00006517          	auipc	a0,0x6
     5a0:	b2c50513          	addi	a0,a0,-1236 # 60c8 <longjmp_1+0x518>
     5a4:	00005097          	auipc	ra,0x5
     5a8:	3f8080e7          	jalr	1016(ra) # 599c <printf>
      exit(1);
     5ac:	4505                	li	a0,1
     5ae:	00005097          	auipc	ra,0x5
     5b2:	05e080e7          	jalr	94(ra) # 560c <exit>
      printf("pipe() failed\n");
     5b6:	00006517          	auipc	a0,0x6
     5ba:	ab250513          	addi	a0,a0,-1358 # 6068 <longjmp_1+0x4b8>
     5be:	00005097          	auipc	ra,0x5
     5c2:	3de080e7          	jalr	990(ra) # 599c <printf>
      exit(1);
     5c6:	4505                	li	a0,1
     5c8:	00005097          	auipc	ra,0x5
     5cc:	044080e7          	jalr	68(ra) # 560c <exit>
      printf("pipe write failed\n");
     5d0:	00006517          	auipc	a0,0x6
     5d4:	b2850513          	addi	a0,a0,-1240 # 60f8 <longjmp_1+0x548>
     5d8:	00005097          	auipc	ra,0x5
     5dc:	3c4080e7          	jalr	964(ra) # 599c <printf>
      exit(1);
     5e0:	4505                	li	a0,1
     5e2:	00005097          	auipc	ra,0x5
     5e6:	02a080e7          	jalr	42(ra) # 560c <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5ea:	862a                	mv	a2,a0
     5ec:	85ce                	mv	a1,s3
     5ee:	00006517          	auipc	a0,0x6
     5f2:	b2250513          	addi	a0,a0,-1246 # 6110 <longjmp_1+0x560>
     5f6:	00005097          	auipc	ra,0x5
     5fa:	3a6080e7          	jalr	934(ra) # 599c <printf>
      exit(1);
     5fe:	4505                	li	a0,1
     600:	00005097          	auipc	ra,0x5
     604:	00c080e7          	jalr	12(ra) # 560c <exit>

0000000000000608 <truncate1>:
{
     608:	711d                	addi	sp,sp,-96
     60a:	ec86                	sd	ra,88(sp)
     60c:	e8a2                	sd	s0,80(sp)
     60e:	e4a6                	sd	s1,72(sp)
     610:	e0ca                	sd	s2,64(sp)
     612:	fc4e                	sd	s3,56(sp)
     614:	f852                	sd	s4,48(sp)
     616:	f456                	sd	s5,40(sp)
     618:	1080                	addi	s0,sp,96
     61a:	8aaa                	mv	s5,a0
  unlink("truncfile");
     61c:	00006517          	auipc	a0,0x6
     620:	94c50513          	addi	a0,a0,-1716 # 5f68 <longjmp_1+0x3b8>
     624:	00005097          	auipc	ra,0x5
     628:	038080e7          	jalr	56(ra) # 565c <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     62c:	60100593          	li	a1,1537
     630:	00006517          	auipc	a0,0x6
     634:	93850513          	addi	a0,a0,-1736 # 5f68 <longjmp_1+0x3b8>
     638:	00005097          	auipc	ra,0x5
     63c:	014080e7          	jalr	20(ra) # 564c <open>
     640:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     642:	4611                	li	a2,4
     644:	00006597          	auipc	a1,0x6
     648:	93458593          	addi	a1,a1,-1740 # 5f78 <longjmp_1+0x3c8>
     64c:	00005097          	auipc	ra,0x5
     650:	fe0080e7          	jalr	-32(ra) # 562c <write>
  close(fd1);
     654:	8526                	mv	a0,s1
     656:	00005097          	auipc	ra,0x5
     65a:	fde080e7          	jalr	-34(ra) # 5634 <close>
  int fd2 = open("truncfile", O_RDONLY);
     65e:	4581                	li	a1,0
     660:	00006517          	auipc	a0,0x6
     664:	90850513          	addi	a0,a0,-1784 # 5f68 <longjmp_1+0x3b8>
     668:	00005097          	auipc	ra,0x5
     66c:	fe4080e7          	jalr	-28(ra) # 564c <open>
     670:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     672:	02000613          	li	a2,32
     676:	fa040593          	addi	a1,s0,-96
     67a:	00005097          	auipc	ra,0x5
     67e:	faa080e7          	jalr	-86(ra) # 5624 <read>
  if(n != 4){
     682:	4791                	li	a5,4
     684:	0cf51e63          	bne	a0,a5,760 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     688:	40100593          	li	a1,1025
     68c:	00006517          	auipc	a0,0x6
     690:	8dc50513          	addi	a0,a0,-1828 # 5f68 <longjmp_1+0x3b8>
     694:	00005097          	auipc	ra,0x5
     698:	fb8080e7          	jalr	-72(ra) # 564c <open>
     69c:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     69e:	4581                	li	a1,0
     6a0:	00006517          	auipc	a0,0x6
     6a4:	8c850513          	addi	a0,a0,-1848 # 5f68 <longjmp_1+0x3b8>
     6a8:	00005097          	auipc	ra,0x5
     6ac:	fa4080e7          	jalr	-92(ra) # 564c <open>
     6b0:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6b2:	02000613          	li	a2,32
     6b6:	fa040593          	addi	a1,s0,-96
     6ba:	00005097          	auipc	ra,0x5
     6be:	f6a080e7          	jalr	-150(ra) # 5624 <read>
     6c2:	8a2a                	mv	s4,a0
  if(n != 0){
     6c4:	ed4d                	bnez	a0,77e <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     6c6:	02000613          	li	a2,32
     6ca:	fa040593          	addi	a1,s0,-96
     6ce:	8526                	mv	a0,s1
     6d0:	00005097          	auipc	ra,0x5
     6d4:	f54080e7          	jalr	-172(ra) # 5624 <read>
     6d8:	8a2a                	mv	s4,a0
  if(n != 0){
     6da:	e971                	bnez	a0,7ae <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     6dc:	4619                	li	a2,6
     6de:	00006597          	auipc	a1,0x6
     6e2:	ac258593          	addi	a1,a1,-1342 # 61a0 <longjmp_1+0x5f0>
     6e6:	854e                	mv	a0,s3
     6e8:	00005097          	auipc	ra,0x5
     6ec:	f44080e7          	jalr	-188(ra) # 562c <write>
  n = read(fd3, buf, sizeof(buf));
     6f0:	02000613          	li	a2,32
     6f4:	fa040593          	addi	a1,s0,-96
     6f8:	854a                	mv	a0,s2
     6fa:	00005097          	auipc	ra,0x5
     6fe:	f2a080e7          	jalr	-214(ra) # 5624 <read>
  if(n != 6){
     702:	4799                	li	a5,6
     704:	0cf51d63          	bne	a0,a5,7de <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     708:	02000613          	li	a2,32
     70c:	fa040593          	addi	a1,s0,-96
     710:	8526                	mv	a0,s1
     712:	00005097          	auipc	ra,0x5
     716:	f12080e7          	jalr	-238(ra) # 5624 <read>
  if(n != 2){
     71a:	4789                	li	a5,2
     71c:	0ef51063          	bne	a0,a5,7fc <truncate1+0x1f4>
  unlink("truncfile");
     720:	00006517          	auipc	a0,0x6
     724:	84850513          	addi	a0,a0,-1976 # 5f68 <longjmp_1+0x3b8>
     728:	00005097          	auipc	ra,0x5
     72c:	f34080e7          	jalr	-204(ra) # 565c <unlink>
  close(fd1);
     730:	854e                	mv	a0,s3
     732:	00005097          	auipc	ra,0x5
     736:	f02080e7          	jalr	-254(ra) # 5634 <close>
  close(fd2);
     73a:	8526                	mv	a0,s1
     73c:	00005097          	auipc	ra,0x5
     740:	ef8080e7          	jalr	-264(ra) # 5634 <close>
  close(fd3);
     744:	854a                	mv	a0,s2
     746:	00005097          	auipc	ra,0x5
     74a:	eee080e7          	jalr	-274(ra) # 5634 <close>
}
     74e:	60e6                	ld	ra,88(sp)
     750:	6446                	ld	s0,80(sp)
     752:	64a6                	ld	s1,72(sp)
     754:	6906                	ld	s2,64(sp)
     756:	79e2                	ld	s3,56(sp)
     758:	7a42                	ld	s4,48(sp)
     75a:	7aa2                	ld	s5,40(sp)
     75c:	6125                	addi	sp,sp,96
     75e:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     760:	862a                	mv	a2,a0
     762:	85d6                	mv	a1,s5
     764:	00006517          	auipc	a0,0x6
     768:	9dc50513          	addi	a0,a0,-1572 # 6140 <longjmp_1+0x590>
     76c:	00005097          	auipc	ra,0x5
     770:	230080e7          	jalr	560(ra) # 599c <printf>
    exit(1);
     774:	4505                	li	a0,1
     776:	00005097          	auipc	ra,0x5
     77a:	e96080e7          	jalr	-362(ra) # 560c <exit>
    printf("aaa fd3=%d\n", fd3);
     77e:	85ca                	mv	a1,s2
     780:	00006517          	auipc	a0,0x6
     784:	9e050513          	addi	a0,a0,-1568 # 6160 <longjmp_1+0x5b0>
     788:	00005097          	auipc	ra,0x5
     78c:	214080e7          	jalr	532(ra) # 599c <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     790:	8652                	mv	a2,s4
     792:	85d6                	mv	a1,s5
     794:	00006517          	auipc	a0,0x6
     798:	9dc50513          	addi	a0,a0,-1572 # 6170 <longjmp_1+0x5c0>
     79c:	00005097          	auipc	ra,0x5
     7a0:	200080e7          	jalr	512(ra) # 599c <printf>
    exit(1);
     7a4:	4505                	li	a0,1
     7a6:	00005097          	auipc	ra,0x5
     7aa:	e66080e7          	jalr	-410(ra) # 560c <exit>
    printf("bbb fd2=%d\n", fd2);
     7ae:	85a6                	mv	a1,s1
     7b0:	00006517          	auipc	a0,0x6
     7b4:	9e050513          	addi	a0,a0,-1568 # 6190 <longjmp_1+0x5e0>
     7b8:	00005097          	auipc	ra,0x5
     7bc:	1e4080e7          	jalr	484(ra) # 599c <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7c0:	8652                	mv	a2,s4
     7c2:	85d6                	mv	a1,s5
     7c4:	00006517          	auipc	a0,0x6
     7c8:	9ac50513          	addi	a0,a0,-1620 # 6170 <longjmp_1+0x5c0>
     7cc:	00005097          	auipc	ra,0x5
     7d0:	1d0080e7          	jalr	464(ra) # 599c <printf>
    exit(1);
     7d4:	4505                	li	a0,1
     7d6:	00005097          	auipc	ra,0x5
     7da:	e36080e7          	jalr	-458(ra) # 560c <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     7de:	862a                	mv	a2,a0
     7e0:	85d6                	mv	a1,s5
     7e2:	00006517          	auipc	a0,0x6
     7e6:	9c650513          	addi	a0,a0,-1594 # 61a8 <longjmp_1+0x5f8>
     7ea:	00005097          	auipc	ra,0x5
     7ee:	1b2080e7          	jalr	434(ra) # 599c <printf>
    exit(1);
     7f2:	4505                	li	a0,1
     7f4:	00005097          	auipc	ra,0x5
     7f8:	e18080e7          	jalr	-488(ra) # 560c <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     7fc:	862a                	mv	a2,a0
     7fe:	85d6                	mv	a1,s5
     800:	00006517          	auipc	a0,0x6
     804:	9c850513          	addi	a0,a0,-1592 # 61c8 <longjmp_1+0x618>
     808:	00005097          	auipc	ra,0x5
     80c:	194080e7          	jalr	404(ra) # 599c <printf>
    exit(1);
     810:	4505                	li	a0,1
     812:	00005097          	auipc	ra,0x5
     816:	dfa080e7          	jalr	-518(ra) # 560c <exit>

000000000000081a <writetest>:
{
     81a:	7139                	addi	sp,sp,-64
     81c:	fc06                	sd	ra,56(sp)
     81e:	f822                	sd	s0,48(sp)
     820:	f426                	sd	s1,40(sp)
     822:	f04a                	sd	s2,32(sp)
     824:	ec4e                	sd	s3,24(sp)
     826:	e852                	sd	s4,16(sp)
     828:	e456                	sd	s5,8(sp)
     82a:	e05a                	sd	s6,0(sp)
     82c:	0080                	addi	s0,sp,64
     82e:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     830:	20200593          	li	a1,514
     834:	00006517          	auipc	a0,0x6
     838:	9b450513          	addi	a0,a0,-1612 # 61e8 <longjmp_1+0x638>
     83c:	00005097          	auipc	ra,0x5
     840:	e10080e7          	jalr	-496(ra) # 564c <open>
  if(fd < 0){
     844:	0a054d63          	bltz	a0,8fe <writetest+0xe4>
     848:	892a                	mv	s2,a0
     84a:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     84c:	00006997          	auipc	s3,0x6
     850:	9c498993          	addi	s3,s3,-1596 # 6210 <longjmp_1+0x660>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     854:	00006a97          	auipc	s5,0x6
     858:	9f4a8a93          	addi	s5,s5,-1548 # 6248 <longjmp_1+0x698>
  for(i = 0; i < N; i++){
     85c:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     860:	4629                	li	a2,10
     862:	85ce                	mv	a1,s3
     864:	854a                	mv	a0,s2
     866:	00005097          	auipc	ra,0x5
     86a:	dc6080e7          	jalr	-570(ra) # 562c <write>
     86e:	47a9                	li	a5,10
     870:	0af51563          	bne	a0,a5,91a <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     874:	4629                	li	a2,10
     876:	85d6                	mv	a1,s5
     878:	854a                	mv	a0,s2
     87a:	00005097          	auipc	ra,0x5
     87e:	db2080e7          	jalr	-590(ra) # 562c <write>
     882:	47a9                	li	a5,10
     884:	0af51a63          	bne	a0,a5,938 <writetest+0x11e>
  for(i = 0; i < N; i++){
     888:	2485                	addiw	s1,s1,1
     88a:	fd449be3          	bne	s1,s4,860 <writetest+0x46>
  close(fd);
     88e:	854a                	mv	a0,s2
     890:	00005097          	auipc	ra,0x5
     894:	da4080e7          	jalr	-604(ra) # 5634 <close>
  fd = open("small", O_RDONLY);
     898:	4581                	li	a1,0
     89a:	00006517          	auipc	a0,0x6
     89e:	94e50513          	addi	a0,a0,-1714 # 61e8 <longjmp_1+0x638>
     8a2:	00005097          	auipc	ra,0x5
     8a6:	daa080e7          	jalr	-598(ra) # 564c <open>
     8aa:	84aa                	mv	s1,a0
  if(fd < 0){
     8ac:	0a054563          	bltz	a0,956 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     8b0:	7d000613          	li	a2,2000
     8b4:	0000b597          	auipc	a1,0xb
     8b8:	27458593          	addi	a1,a1,628 # bb28 <buf>
     8bc:	00005097          	auipc	ra,0x5
     8c0:	d68080e7          	jalr	-664(ra) # 5624 <read>
  if(i != N*SZ*2){
     8c4:	7d000793          	li	a5,2000
     8c8:	0af51563          	bne	a0,a5,972 <writetest+0x158>
  close(fd);
     8cc:	8526                	mv	a0,s1
     8ce:	00005097          	auipc	ra,0x5
     8d2:	d66080e7          	jalr	-666(ra) # 5634 <close>
  if(unlink("small") < 0){
     8d6:	00006517          	auipc	a0,0x6
     8da:	91250513          	addi	a0,a0,-1774 # 61e8 <longjmp_1+0x638>
     8de:	00005097          	auipc	ra,0x5
     8e2:	d7e080e7          	jalr	-642(ra) # 565c <unlink>
     8e6:	0a054463          	bltz	a0,98e <writetest+0x174>
}
     8ea:	70e2                	ld	ra,56(sp)
     8ec:	7442                	ld	s0,48(sp)
     8ee:	74a2                	ld	s1,40(sp)
     8f0:	7902                	ld	s2,32(sp)
     8f2:	69e2                	ld	s3,24(sp)
     8f4:	6a42                	ld	s4,16(sp)
     8f6:	6aa2                	ld	s5,8(sp)
     8f8:	6b02                	ld	s6,0(sp)
     8fa:	6121                	addi	sp,sp,64
     8fc:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     8fe:	85da                	mv	a1,s6
     900:	00006517          	auipc	a0,0x6
     904:	8f050513          	addi	a0,a0,-1808 # 61f0 <longjmp_1+0x640>
     908:	00005097          	auipc	ra,0x5
     90c:	094080e7          	jalr	148(ra) # 599c <printf>
    exit(1);
     910:	4505                	li	a0,1
     912:	00005097          	auipc	ra,0x5
     916:	cfa080e7          	jalr	-774(ra) # 560c <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     91a:	8626                	mv	a2,s1
     91c:	85da                	mv	a1,s6
     91e:	00006517          	auipc	a0,0x6
     922:	90250513          	addi	a0,a0,-1790 # 6220 <longjmp_1+0x670>
     926:	00005097          	auipc	ra,0x5
     92a:	076080e7          	jalr	118(ra) # 599c <printf>
      exit(1);
     92e:	4505                	li	a0,1
     930:	00005097          	auipc	ra,0x5
     934:	cdc080e7          	jalr	-804(ra) # 560c <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     938:	8626                	mv	a2,s1
     93a:	85da                	mv	a1,s6
     93c:	00006517          	auipc	a0,0x6
     940:	91c50513          	addi	a0,a0,-1764 # 6258 <longjmp_1+0x6a8>
     944:	00005097          	auipc	ra,0x5
     948:	058080e7          	jalr	88(ra) # 599c <printf>
      exit(1);
     94c:	4505                	li	a0,1
     94e:	00005097          	auipc	ra,0x5
     952:	cbe080e7          	jalr	-834(ra) # 560c <exit>
    printf("%s: error: open small failed!\n", s);
     956:	85da                	mv	a1,s6
     958:	00006517          	auipc	a0,0x6
     95c:	92850513          	addi	a0,a0,-1752 # 6280 <longjmp_1+0x6d0>
     960:	00005097          	auipc	ra,0x5
     964:	03c080e7          	jalr	60(ra) # 599c <printf>
    exit(1);
     968:	4505                	li	a0,1
     96a:	00005097          	auipc	ra,0x5
     96e:	ca2080e7          	jalr	-862(ra) # 560c <exit>
    printf("%s: read failed\n", s);
     972:	85da                	mv	a1,s6
     974:	00006517          	auipc	a0,0x6
     978:	92c50513          	addi	a0,a0,-1748 # 62a0 <longjmp_1+0x6f0>
     97c:	00005097          	auipc	ra,0x5
     980:	020080e7          	jalr	32(ra) # 599c <printf>
    exit(1);
     984:	4505                	li	a0,1
     986:	00005097          	auipc	ra,0x5
     98a:	c86080e7          	jalr	-890(ra) # 560c <exit>
    printf("%s: unlink small failed\n", s);
     98e:	85da                	mv	a1,s6
     990:	00006517          	auipc	a0,0x6
     994:	92850513          	addi	a0,a0,-1752 # 62b8 <longjmp_1+0x708>
     998:	00005097          	auipc	ra,0x5
     99c:	004080e7          	jalr	4(ra) # 599c <printf>
    exit(1);
     9a0:	4505                	li	a0,1
     9a2:	00005097          	auipc	ra,0x5
     9a6:	c6a080e7          	jalr	-918(ra) # 560c <exit>

00000000000009aa <writebig>:
{
     9aa:	7139                	addi	sp,sp,-64
     9ac:	fc06                	sd	ra,56(sp)
     9ae:	f822                	sd	s0,48(sp)
     9b0:	f426                	sd	s1,40(sp)
     9b2:	f04a                	sd	s2,32(sp)
     9b4:	ec4e                	sd	s3,24(sp)
     9b6:	e852                	sd	s4,16(sp)
     9b8:	e456                	sd	s5,8(sp)
     9ba:	0080                	addi	s0,sp,64
     9bc:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9be:	20200593          	li	a1,514
     9c2:	00006517          	auipc	a0,0x6
     9c6:	91650513          	addi	a0,a0,-1770 # 62d8 <longjmp_1+0x728>
     9ca:	00005097          	auipc	ra,0x5
     9ce:	c82080e7          	jalr	-894(ra) # 564c <open>
     9d2:	89aa                	mv	s3,a0
  for(i = 0; i < 100; i++){
     9d4:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9d6:	0000b917          	auipc	s2,0xb
     9da:	15290913          	addi	s2,s2,338 # bb28 <buf>
  for(i = 0; i < 100; i++){
     9de:	06400a13          	li	s4,100
  if(fd < 0){
     9e2:	06054c63          	bltz	a0,a5a <writebig+0xb0>
    ((int*)buf)[0] = i;
     9e6:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9ea:	40000613          	li	a2,1024
     9ee:	85ca                	mv	a1,s2
     9f0:	854e                	mv	a0,s3
     9f2:	00005097          	auipc	ra,0x5
     9f6:	c3a080e7          	jalr	-966(ra) # 562c <write>
     9fa:	40000793          	li	a5,1024
     9fe:	06f51c63          	bne	a0,a5,a76 <writebig+0xcc>
  for(i = 0; i < 100; i++){
     a02:	2485                	addiw	s1,s1,1
     a04:	ff4491e3          	bne	s1,s4,9e6 <writebig+0x3c>
  close(fd);
     a08:	854e                	mv	a0,s3
     a0a:	00005097          	auipc	ra,0x5
     a0e:	c2a080e7          	jalr	-982(ra) # 5634 <close>
  fd = open("big", O_RDONLY);
     a12:	4581                	li	a1,0
     a14:	00006517          	auipc	a0,0x6
     a18:	8c450513          	addi	a0,a0,-1852 # 62d8 <longjmp_1+0x728>
     a1c:	00005097          	auipc	ra,0x5
     a20:	c30080e7          	jalr	-976(ra) # 564c <open>
     a24:	89aa                	mv	s3,a0
  n = 0;
     a26:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a28:	0000b917          	auipc	s2,0xb
     a2c:	10090913          	addi	s2,s2,256 # bb28 <buf>
  if(fd < 0){
     a30:	06054263          	bltz	a0,a94 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     a34:	40000613          	li	a2,1024
     a38:	85ca                	mv	a1,s2
     a3a:	854e                	mv	a0,s3
     a3c:	00005097          	auipc	ra,0x5
     a40:	be8080e7          	jalr	-1048(ra) # 5624 <read>
    if(i == 0){
     a44:	c535                	beqz	a0,ab0 <writebig+0x106>
    } else if(i != BSIZE){
     a46:	40000793          	li	a5,1024
     a4a:	0af51f63          	bne	a0,a5,b08 <writebig+0x15e>
    if(((int*)buf)[0] != n){
     a4e:	00092683          	lw	a3,0(s2)
     a52:	0c969a63          	bne	a3,s1,b26 <writebig+0x17c>
    n++;
     a56:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a58:	bff1                	j	a34 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     a5a:	85d6                	mv	a1,s5
     a5c:	00006517          	auipc	a0,0x6
     a60:	88450513          	addi	a0,a0,-1916 # 62e0 <longjmp_1+0x730>
     a64:	00005097          	auipc	ra,0x5
     a68:	f38080e7          	jalr	-200(ra) # 599c <printf>
    exit(1);
     a6c:	4505                	li	a0,1
     a6e:	00005097          	auipc	ra,0x5
     a72:	b9e080e7          	jalr	-1122(ra) # 560c <exit>
      printf("%s: error: write big file failed\n", s, i);
     a76:	8626                	mv	a2,s1
     a78:	85d6                	mv	a1,s5
     a7a:	00006517          	auipc	a0,0x6
     a7e:	88650513          	addi	a0,a0,-1914 # 6300 <longjmp_1+0x750>
     a82:	00005097          	auipc	ra,0x5
     a86:	f1a080e7          	jalr	-230(ra) # 599c <printf>
      exit(1);
     a8a:	4505                	li	a0,1
     a8c:	00005097          	auipc	ra,0x5
     a90:	b80080e7          	jalr	-1152(ra) # 560c <exit>
    printf("%s: error: open big failed!\n", s);
     a94:	85d6                	mv	a1,s5
     a96:	00006517          	auipc	a0,0x6
     a9a:	89250513          	addi	a0,a0,-1902 # 6328 <longjmp_1+0x778>
     a9e:	00005097          	auipc	ra,0x5
     aa2:	efe080e7          	jalr	-258(ra) # 599c <printf>
    exit(1);
     aa6:	4505                	li	a0,1
     aa8:	00005097          	auipc	ra,0x5
     aac:	b64080e7          	jalr	-1180(ra) # 560c <exit>
      if(n == MAXFILE - 1){
     ab0:	10b00793          	li	a5,267
     ab4:	02f48a63          	beq	s1,a5,ae8 <writebig+0x13e>
  close(fd);
     ab8:	854e                	mv	a0,s3
     aba:	00005097          	auipc	ra,0x5
     abe:	b7a080e7          	jalr	-1158(ra) # 5634 <close>
  if(unlink("big") < 0){
     ac2:	00006517          	auipc	a0,0x6
     ac6:	81650513          	addi	a0,a0,-2026 # 62d8 <longjmp_1+0x728>
     aca:	00005097          	auipc	ra,0x5
     ace:	b92080e7          	jalr	-1134(ra) # 565c <unlink>
     ad2:	06054963          	bltz	a0,b44 <writebig+0x19a>
}
     ad6:	70e2                	ld	ra,56(sp)
     ad8:	7442                	ld	s0,48(sp)
     ada:	74a2                	ld	s1,40(sp)
     adc:	7902                	ld	s2,32(sp)
     ade:	69e2                	ld	s3,24(sp)
     ae0:	6a42                	ld	s4,16(sp)
     ae2:	6aa2                	ld	s5,8(sp)
     ae4:	6121                	addi	sp,sp,64
     ae6:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     ae8:	10b00613          	li	a2,267
     aec:	85d6                	mv	a1,s5
     aee:	00006517          	auipc	a0,0x6
     af2:	85a50513          	addi	a0,a0,-1958 # 6348 <longjmp_1+0x798>
     af6:	00005097          	auipc	ra,0x5
     afa:	ea6080e7          	jalr	-346(ra) # 599c <printf>
        exit(1);
     afe:	4505                	li	a0,1
     b00:	00005097          	auipc	ra,0x5
     b04:	b0c080e7          	jalr	-1268(ra) # 560c <exit>
      printf("%s: read failed %d\n", s, i);
     b08:	862a                	mv	a2,a0
     b0a:	85d6                	mv	a1,s5
     b0c:	00006517          	auipc	a0,0x6
     b10:	86450513          	addi	a0,a0,-1948 # 6370 <longjmp_1+0x7c0>
     b14:	00005097          	auipc	ra,0x5
     b18:	e88080e7          	jalr	-376(ra) # 599c <printf>
      exit(1);
     b1c:	4505                	li	a0,1
     b1e:	00005097          	auipc	ra,0x5
     b22:	aee080e7          	jalr	-1298(ra) # 560c <exit>
      printf("%s: read content of block %d is %d\n", s,
     b26:	8626                	mv	a2,s1
     b28:	85d6                	mv	a1,s5
     b2a:	00006517          	auipc	a0,0x6
     b2e:	85e50513          	addi	a0,a0,-1954 # 6388 <longjmp_1+0x7d8>
     b32:	00005097          	auipc	ra,0x5
     b36:	e6a080e7          	jalr	-406(ra) # 599c <printf>
      exit(1);
     b3a:	4505                	li	a0,1
     b3c:	00005097          	auipc	ra,0x5
     b40:	ad0080e7          	jalr	-1328(ra) # 560c <exit>
    printf("%s: unlink big failed\n", s);
     b44:	85d6                	mv	a1,s5
     b46:	00006517          	auipc	a0,0x6
     b4a:	86a50513          	addi	a0,a0,-1942 # 63b0 <longjmp_1+0x800>
     b4e:	00005097          	auipc	ra,0x5
     b52:	e4e080e7          	jalr	-434(ra) # 599c <printf>
    exit(1);
     b56:	4505                	li	a0,1
     b58:	00005097          	auipc	ra,0x5
     b5c:	ab4080e7          	jalr	-1356(ra) # 560c <exit>

0000000000000b60 <unlinkread>:
{
     b60:	7179                	addi	sp,sp,-48
     b62:	f406                	sd	ra,40(sp)
     b64:	f022                	sd	s0,32(sp)
     b66:	ec26                	sd	s1,24(sp)
     b68:	e84a                	sd	s2,16(sp)
     b6a:	e44e                	sd	s3,8(sp)
     b6c:	1800                	addi	s0,sp,48
     b6e:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b70:	20200593          	li	a1,514
     b74:	00005517          	auipc	a0,0x5
     b78:	1a450513          	addi	a0,a0,420 # 5d18 <longjmp_1+0x168>
     b7c:	00005097          	auipc	ra,0x5
     b80:	ad0080e7          	jalr	-1328(ra) # 564c <open>
  if(fd < 0){
     b84:	0e054563          	bltz	a0,c6e <unlinkread+0x10e>
     b88:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b8a:	4615                	li	a2,5
     b8c:	00006597          	auipc	a1,0x6
     b90:	85c58593          	addi	a1,a1,-1956 # 63e8 <longjmp_1+0x838>
     b94:	00005097          	auipc	ra,0x5
     b98:	a98080e7          	jalr	-1384(ra) # 562c <write>
  close(fd);
     b9c:	8526                	mv	a0,s1
     b9e:	00005097          	auipc	ra,0x5
     ba2:	a96080e7          	jalr	-1386(ra) # 5634 <close>
  fd = open("unlinkread", O_RDWR);
     ba6:	4589                	li	a1,2
     ba8:	00005517          	auipc	a0,0x5
     bac:	17050513          	addi	a0,a0,368 # 5d18 <longjmp_1+0x168>
     bb0:	00005097          	auipc	ra,0x5
     bb4:	a9c080e7          	jalr	-1380(ra) # 564c <open>
     bb8:	84aa                	mv	s1,a0
  if(fd < 0){
     bba:	0c054863          	bltz	a0,c8a <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     bbe:	00005517          	auipc	a0,0x5
     bc2:	15a50513          	addi	a0,a0,346 # 5d18 <longjmp_1+0x168>
     bc6:	00005097          	auipc	ra,0x5
     bca:	a96080e7          	jalr	-1386(ra) # 565c <unlink>
     bce:	ed61                	bnez	a0,ca6 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd0:	20200593          	li	a1,514
     bd4:	00005517          	auipc	a0,0x5
     bd8:	14450513          	addi	a0,a0,324 # 5d18 <longjmp_1+0x168>
     bdc:	00005097          	auipc	ra,0x5
     be0:	a70080e7          	jalr	-1424(ra) # 564c <open>
     be4:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be6:	460d                	li	a2,3
     be8:	00006597          	auipc	a1,0x6
     bec:	84858593          	addi	a1,a1,-1976 # 6430 <longjmp_1+0x880>
     bf0:	00005097          	auipc	ra,0x5
     bf4:	a3c080e7          	jalr	-1476(ra) # 562c <write>
  close(fd1);
     bf8:	854a                	mv	a0,s2
     bfa:	00005097          	auipc	ra,0x5
     bfe:	a3a080e7          	jalr	-1478(ra) # 5634 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c02:	660d                	lui	a2,0x3
     c04:	0000b597          	auipc	a1,0xb
     c08:	f2458593          	addi	a1,a1,-220 # bb28 <buf>
     c0c:	8526                	mv	a0,s1
     c0e:	00005097          	auipc	ra,0x5
     c12:	a16080e7          	jalr	-1514(ra) # 5624 <read>
     c16:	4795                	li	a5,5
     c18:	0af51563          	bne	a0,a5,cc2 <unlinkread+0x162>
  if(buf[0] != 'h'){
     c1c:	0000b717          	auipc	a4,0xb
     c20:	f0c74703          	lbu	a4,-244(a4) # bb28 <buf>
     c24:	06800793          	li	a5,104
     c28:	0af71b63          	bne	a4,a5,cde <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c2c:	4629                	li	a2,10
     c2e:	0000b597          	auipc	a1,0xb
     c32:	efa58593          	addi	a1,a1,-262 # bb28 <buf>
     c36:	8526                	mv	a0,s1
     c38:	00005097          	auipc	ra,0x5
     c3c:	9f4080e7          	jalr	-1548(ra) # 562c <write>
     c40:	47a9                	li	a5,10
     c42:	0af51c63          	bne	a0,a5,cfa <unlinkread+0x19a>
  close(fd);
     c46:	8526                	mv	a0,s1
     c48:	00005097          	auipc	ra,0x5
     c4c:	9ec080e7          	jalr	-1556(ra) # 5634 <close>
  unlink("unlinkread");
     c50:	00005517          	auipc	a0,0x5
     c54:	0c850513          	addi	a0,a0,200 # 5d18 <longjmp_1+0x168>
     c58:	00005097          	auipc	ra,0x5
     c5c:	a04080e7          	jalr	-1532(ra) # 565c <unlink>
}
     c60:	70a2                	ld	ra,40(sp)
     c62:	7402                	ld	s0,32(sp)
     c64:	64e2                	ld	s1,24(sp)
     c66:	6942                	ld	s2,16(sp)
     c68:	69a2                	ld	s3,8(sp)
     c6a:	6145                	addi	sp,sp,48
     c6c:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c6e:	85ce                	mv	a1,s3
     c70:	00005517          	auipc	a0,0x5
     c74:	75850513          	addi	a0,a0,1880 # 63c8 <longjmp_1+0x818>
     c78:	00005097          	auipc	ra,0x5
     c7c:	d24080e7          	jalr	-732(ra) # 599c <printf>
    exit(1);
     c80:	4505                	li	a0,1
     c82:	00005097          	auipc	ra,0x5
     c86:	98a080e7          	jalr	-1654(ra) # 560c <exit>
    printf("%s: open unlinkread failed\n", s);
     c8a:	85ce                	mv	a1,s3
     c8c:	00005517          	auipc	a0,0x5
     c90:	76450513          	addi	a0,a0,1892 # 63f0 <longjmp_1+0x840>
     c94:	00005097          	auipc	ra,0x5
     c98:	d08080e7          	jalr	-760(ra) # 599c <printf>
    exit(1);
     c9c:	4505                	li	a0,1
     c9e:	00005097          	auipc	ra,0x5
     ca2:	96e080e7          	jalr	-1682(ra) # 560c <exit>
    printf("%s: unlink unlinkread failed\n", s);
     ca6:	85ce                	mv	a1,s3
     ca8:	00005517          	auipc	a0,0x5
     cac:	76850513          	addi	a0,a0,1896 # 6410 <longjmp_1+0x860>
     cb0:	00005097          	auipc	ra,0x5
     cb4:	cec080e7          	jalr	-788(ra) # 599c <printf>
    exit(1);
     cb8:	4505                	li	a0,1
     cba:	00005097          	auipc	ra,0x5
     cbe:	952080e7          	jalr	-1710(ra) # 560c <exit>
    printf("%s: unlinkread read failed", s);
     cc2:	85ce                	mv	a1,s3
     cc4:	00005517          	auipc	a0,0x5
     cc8:	77450513          	addi	a0,a0,1908 # 6438 <longjmp_1+0x888>
     ccc:	00005097          	auipc	ra,0x5
     cd0:	cd0080e7          	jalr	-816(ra) # 599c <printf>
    exit(1);
     cd4:	4505                	li	a0,1
     cd6:	00005097          	auipc	ra,0x5
     cda:	936080e7          	jalr	-1738(ra) # 560c <exit>
    printf("%s: unlinkread wrong data\n", s);
     cde:	85ce                	mv	a1,s3
     ce0:	00005517          	auipc	a0,0x5
     ce4:	77850513          	addi	a0,a0,1912 # 6458 <longjmp_1+0x8a8>
     ce8:	00005097          	auipc	ra,0x5
     cec:	cb4080e7          	jalr	-844(ra) # 599c <printf>
    exit(1);
     cf0:	4505                	li	a0,1
     cf2:	00005097          	auipc	ra,0x5
     cf6:	91a080e7          	jalr	-1766(ra) # 560c <exit>
    printf("%s: unlinkread write failed\n", s);
     cfa:	85ce                	mv	a1,s3
     cfc:	00005517          	auipc	a0,0x5
     d00:	77c50513          	addi	a0,a0,1916 # 6478 <longjmp_1+0x8c8>
     d04:	00005097          	auipc	ra,0x5
     d08:	c98080e7          	jalr	-872(ra) # 599c <printf>
    exit(1);
     d0c:	4505                	li	a0,1
     d0e:	00005097          	auipc	ra,0x5
     d12:	8fe080e7          	jalr	-1794(ra) # 560c <exit>

0000000000000d16 <linktest>:
{
     d16:	1101                	addi	sp,sp,-32
     d18:	ec06                	sd	ra,24(sp)
     d1a:	e822                	sd	s0,16(sp)
     d1c:	e426                	sd	s1,8(sp)
     d1e:	e04a                	sd	s2,0(sp)
     d20:	1000                	addi	s0,sp,32
     d22:	892a                	mv	s2,a0
  unlink("lf1");
     d24:	00005517          	auipc	a0,0x5
     d28:	77450513          	addi	a0,a0,1908 # 6498 <longjmp_1+0x8e8>
     d2c:	00005097          	auipc	ra,0x5
     d30:	930080e7          	jalr	-1744(ra) # 565c <unlink>
  unlink("lf2");
     d34:	00005517          	auipc	a0,0x5
     d38:	76c50513          	addi	a0,a0,1900 # 64a0 <longjmp_1+0x8f0>
     d3c:	00005097          	auipc	ra,0x5
     d40:	920080e7          	jalr	-1760(ra) # 565c <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d44:	20200593          	li	a1,514
     d48:	00005517          	auipc	a0,0x5
     d4c:	75050513          	addi	a0,a0,1872 # 6498 <longjmp_1+0x8e8>
     d50:	00005097          	auipc	ra,0x5
     d54:	8fc080e7          	jalr	-1796(ra) # 564c <open>
  if(fd < 0){
     d58:	10054763          	bltz	a0,e66 <linktest+0x150>
     d5c:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d5e:	4615                	li	a2,5
     d60:	00005597          	auipc	a1,0x5
     d64:	68858593          	addi	a1,a1,1672 # 63e8 <longjmp_1+0x838>
     d68:	00005097          	auipc	ra,0x5
     d6c:	8c4080e7          	jalr	-1852(ra) # 562c <write>
     d70:	4795                	li	a5,5
     d72:	10f51863          	bne	a0,a5,e82 <linktest+0x16c>
  close(fd);
     d76:	8526                	mv	a0,s1
     d78:	00005097          	auipc	ra,0x5
     d7c:	8bc080e7          	jalr	-1860(ra) # 5634 <close>
  if(link("lf1", "lf2") < 0){
     d80:	00005597          	auipc	a1,0x5
     d84:	72058593          	addi	a1,a1,1824 # 64a0 <longjmp_1+0x8f0>
     d88:	00005517          	auipc	a0,0x5
     d8c:	71050513          	addi	a0,a0,1808 # 6498 <longjmp_1+0x8e8>
     d90:	00005097          	auipc	ra,0x5
     d94:	8dc080e7          	jalr	-1828(ra) # 566c <link>
     d98:	10054363          	bltz	a0,e9e <linktest+0x188>
  unlink("lf1");
     d9c:	00005517          	auipc	a0,0x5
     da0:	6fc50513          	addi	a0,a0,1788 # 6498 <longjmp_1+0x8e8>
     da4:	00005097          	auipc	ra,0x5
     da8:	8b8080e7          	jalr	-1864(ra) # 565c <unlink>
  if(open("lf1", 0) >= 0){
     dac:	4581                	li	a1,0
     dae:	00005517          	auipc	a0,0x5
     db2:	6ea50513          	addi	a0,a0,1770 # 6498 <longjmp_1+0x8e8>
     db6:	00005097          	auipc	ra,0x5
     dba:	896080e7          	jalr	-1898(ra) # 564c <open>
     dbe:	0e055e63          	bgez	a0,eba <linktest+0x1a4>
  fd = open("lf2", 0);
     dc2:	4581                	li	a1,0
     dc4:	00005517          	auipc	a0,0x5
     dc8:	6dc50513          	addi	a0,a0,1756 # 64a0 <longjmp_1+0x8f0>
     dcc:	00005097          	auipc	ra,0x5
     dd0:	880080e7          	jalr	-1920(ra) # 564c <open>
     dd4:	84aa                	mv	s1,a0
  if(fd < 0){
     dd6:	10054063          	bltz	a0,ed6 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     dda:	660d                	lui	a2,0x3
     ddc:	0000b597          	auipc	a1,0xb
     de0:	d4c58593          	addi	a1,a1,-692 # bb28 <buf>
     de4:	00005097          	auipc	ra,0x5
     de8:	840080e7          	jalr	-1984(ra) # 5624 <read>
     dec:	4795                	li	a5,5
     dee:	10f51263          	bne	a0,a5,ef2 <linktest+0x1dc>
  close(fd);
     df2:	8526                	mv	a0,s1
     df4:	00005097          	auipc	ra,0x5
     df8:	840080e7          	jalr	-1984(ra) # 5634 <close>
  if(link("lf2", "lf2") >= 0){
     dfc:	00005597          	auipc	a1,0x5
     e00:	6a458593          	addi	a1,a1,1700 # 64a0 <longjmp_1+0x8f0>
     e04:	852e                	mv	a0,a1
     e06:	00005097          	auipc	ra,0x5
     e0a:	866080e7          	jalr	-1946(ra) # 566c <link>
     e0e:	10055063          	bgez	a0,f0e <linktest+0x1f8>
  unlink("lf2");
     e12:	00005517          	auipc	a0,0x5
     e16:	68e50513          	addi	a0,a0,1678 # 64a0 <longjmp_1+0x8f0>
     e1a:	00005097          	auipc	ra,0x5
     e1e:	842080e7          	jalr	-1982(ra) # 565c <unlink>
  if(link("lf2", "lf1") >= 0){
     e22:	00005597          	auipc	a1,0x5
     e26:	67658593          	addi	a1,a1,1654 # 6498 <longjmp_1+0x8e8>
     e2a:	00005517          	auipc	a0,0x5
     e2e:	67650513          	addi	a0,a0,1654 # 64a0 <longjmp_1+0x8f0>
     e32:	00005097          	auipc	ra,0x5
     e36:	83a080e7          	jalr	-1990(ra) # 566c <link>
     e3a:	0e055863          	bgez	a0,f2a <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e3e:	00005597          	auipc	a1,0x5
     e42:	65a58593          	addi	a1,a1,1626 # 6498 <longjmp_1+0x8e8>
     e46:	00005517          	auipc	a0,0x5
     e4a:	76250513          	addi	a0,a0,1890 # 65a8 <longjmp_1+0x9f8>
     e4e:	00005097          	auipc	ra,0x5
     e52:	81e080e7          	jalr	-2018(ra) # 566c <link>
     e56:	0e055863          	bgez	a0,f46 <linktest+0x230>
}
     e5a:	60e2                	ld	ra,24(sp)
     e5c:	6442                	ld	s0,16(sp)
     e5e:	64a2                	ld	s1,8(sp)
     e60:	6902                	ld	s2,0(sp)
     e62:	6105                	addi	sp,sp,32
     e64:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     e66:	85ca                	mv	a1,s2
     e68:	00005517          	auipc	a0,0x5
     e6c:	64050513          	addi	a0,a0,1600 # 64a8 <longjmp_1+0x8f8>
     e70:	00005097          	auipc	ra,0x5
     e74:	b2c080e7          	jalr	-1236(ra) # 599c <printf>
    exit(1);
     e78:	4505                	li	a0,1
     e7a:	00004097          	auipc	ra,0x4
     e7e:	792080e7          	jalr	1938(ra) # 560c <exit>
    printf("%s: write lf1 failed\n", s);
     e82:	85ca                	mv	a1,s2
     e84:	00005517          	auipc	a0,0x5
     e88:	63c50513          	addi	a0,a0,1596 # 64c0 <longjmp_1+0x910>
     e8c:	00005097          	auipc	ra,0x5
     e90:	b10080e7          	jalr	-1264(ra) # 599c <printf>
    exit(1);
     e94:	4505                	li	a0,1
     e96:	00004097          	auipc	ra,0x4
     e9a:	776080e7          	jalr	1910(ra) # 560c <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     e9e:	85ca                	mv	a1,s2
     ea0:	00005517          	auipc	a0,0x5
     ea4:	63850513          	addi	a0,a0,1592 # 64d8 <longjmp_1+0x928>
     ea8:	00005097          	auipc	ra,0x5
     eac:	af4080e7          	jalr	-1292(ra) # 599c <printf>
    exit(1);
     eb0:	4505                	li	a0,1
     eb2:	00004097          	auipc	ra,0x4
     eb6:	75a080e7          	jalr	1882(ra) # 560c <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     eba:	85ca                	mv	a1,s2
     ebc:	00005517          	auipc	a0,0x5
     ec0:	63c50513          	addi	a0,a0,1596 # 64f8 <longjmp_1+0x948>
     ec4:	00005097          	auipc	ra,0x5
     ec8:	ad8080e7          	jalr	-1320(ra) # 599c <printf>
    exit(1);
     ecc:	4505                	li	a0,1
     ece:	00004097          	auipc	ra,0x4
     ed2:	73e080e7          	jalr	1854(ra) # 560c <exit>
    printf("%s: open lf2 failed\n", s);
     ed6:	85ca                	mv	a1,s2
     ed8:	00005517          	auipc	a0,0x5
     edc:	65050513          	addi	a0,a0,1616 # 6528 <longjmp_1+0x978>
     ee0:	00005097          	auipc	ra,0x5
     ee4:	abc080e7          	jalr	-1348(ra) # 599c <printf>
    exit(1);
     ee8:	4505                	li	a0,1
     eea:	00004097          	auipc	ra,0x4
     eee:	722080e7          	jalr	1826(ra) # 560c <exit>
    printf("%s: read lf2 failed\n", s);
     ef2:	85ca                	mv	a1,s2
     ef4:	00005517          	auipc	a0,0x5
     ef8:	64c50513          	addi	a0,a0,1612 # 6540 <longjmp_1+0x990>
     efc:	00005097          	auipc	ra,0x5
     f00:	aa0080e7          	jalr	-1376(ra) # 599c <printf>
    exit(1);
     f04:	4505                	li	a0,1
     f06:	00004097          	auipc	ra,0x4
     f0a:	706080e7          	jalr	1798(ra) # 560c <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f0e:	85ca                	mv	a1,s2
     f10:	00005517          	auipc	a0,0x5
     f14:	64850513          	addi	a0,a0,1608 # 6558 <longjmp_1+0x9a8>
     f18:	00005097          	auipc	ra,0x5
     f1c:	a84080e7          	jalr	-1404(ra) # 599c <printf>
    exit(1);
     f20:	4505                	li	a0,1
     f22:	00004097          	auipc	ra,0x4
     f26:	6ea080e7          	jalr	1770(ra) # 560c <exit>
    printf("%s: link non-existant succeeded! oops\n", s);
     f2a:	85ca                	mv	a1,s2
     f2c:	00005517          	auipc	a0,0x5
     f30:	65450513          	addi	a0,a0,1620 # 6580 <longjmp_1+0x9d0>
     f34:	00005097          	auipc	ra,0x5
     f38:	a68080e7          	jalr	-1432(ra) # 599c <printf>
    exit(1);
     f3c:	4505                	li	a0,1
     f3e:	00004097          	auipc	ra,0x4
     f42:	6ce080e7          	jalr	1742(ra) # 560c <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f46:	85ca                	mv	a1,s2
     f48:	00005517          	auipc	a0,0x5
     f4c:	66850513          	addi	a0,a0,1640 # 65b0 <longjmp_1+0xa00>
     f50:	00005097          	auipc	ra,0x5
     f54:	a4c080e7          	jalr	-1460(ra) # 599c <printf>
    exit(1);
     f58:	4505                	li	a0,1
     f5a:	00004097          	auipc	ra,0x4
     f5e:	6b2080e7          	jalr	1714(ra) # 560c <exit>

0000000000000f62 <bigdir>:
{
     f62:	715d                	addi	sp,sp,-80
     f64:	e486                	sd	ra,72(sp)
     f66:	e0a2                	sd	s0,64(sp)
     f68:	fc26                	sd	s1,56(sp)
     f6a:	f84a                	sd	s2,48(sp)
     f6c:	f44e                	sd	s3,40(sp)
     f6e:	f052                	sd	s4,32(sp)
     f70:	ec56                	sd	s5,24(sp)
     f72:	e85a                	sd	s6,16(sp)
     f74:	0880                	addi	s0,sp,80
     f76:	89aa                	mv	s3,a0
  unlink("bd");
     f78:	00005517          	auipc	a0,0x5
     f7c:	65850513          	addi	a0,a0,1624 # 65d0 <longjmp_1+0xa20>
     f80:	00004097          	auipc	ra,0x4
     f84:	6dc080e7          	jalr	1756(ra) # 565c <unlink>
  fd = open("bd", O_CREATE);
     f88:	20000593          	li	a1,512
     f8c:	00005517          	auipc	a0,0x5
     f90:	64450513          	addi	a0,a0,1604 # 65d0 <longjmp_1+0xa20>
     f94:	00004097          	auipc	ra,0x4
     f98:	6b8080e7          	jalr	1720(ra) # 564c <open>
  if(fd < 0){
     f9c:	0c054963          	bltz	a0,106e <bigdir+0x10c>
  close(fd);
     fa0:	00004097          	auipc	ra,0x4
     fa4:	694080e7          	jalr	1684(ra) # 5634 <close>
  for(i = 0; i < N; i++){
     fa8:	4901                	li	s2,0
    name[0] = 'x';
     faa:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     fae:	00005a17          	auipc	s4,0x5
     fb2:	622a0a13          	addi	s4,s4,1570 # 65d0 <longjmp_1+0xa20>
  for(i = 0; i < N; i++){
     fb6:	1f400b13          	li	s6,500
    name[0] = 'x';
     fba:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     fbe:	41f9579b          	sraiw	a5,s2,0x1f
     fc2:	01a7d71b          	srliw	a4,a5,0x1a
     fc6:	012707bb          	addw	a5,a4,s2
     fca:	4067d69b          	sraiw	a3,a5,0x6
     fce:	0306869b          	addiw	a3,a3,48
     fd2:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     fd6:	03f7f793          	andi	a5,a5,63
     fda:	9f99                	subw	a5,a5,a4
     fdc:	0307879b          	addiw	a5,a5,48
     fe0:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     fe4:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     fe8:	fb040593          	addi	a1,s0,-80
     fec:	8552                	mv	a0,s4
     fee:	00004097          	auipc	ra,0x4
     ff2:	67e080e7          	jalr	1662(ra) # 566c <link>
     ff6:	84aa                	mv	s1,a0
     ff8:	e949                	bnez	a0,108a <bigdir+0x128>
  for(i = 0; i < N; i++){
     ffa:	2905                	addiw	s2,s2,1
     ffc:	fb691fe3          	bne	s2,s6,fba <bigdir+0x58>
  unlink("bd");
    1000:	00005517          	auipc	a0,0x5
    1004:	5d050513          	addi	a0,a0,1488 # 65d0 <longjmp_1+0xa20>
    1008:	00004097          	auipc	ra,0x4
    100c:	654080e7          	jalr	1620(ra) # 565c <unlink>
    name[0] = 'x';
    1010:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1014:	1f400a13          	li	s4,500
    name[0] = 'x';
    1018:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    101c:	41f4d79b          	sraiw	a5,s1,0x1f
    1020:	01a7d71b          	srliw	a4,a5,0x1a
    1024:	009707bb          	addw	a5,a4,s1
    1028:	4067d69b          	sraiw	a3,a5,0x6
    102c:	0306869b          	addiw	a3,a3,48
    1030:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1034:	03f7f793          	andi	a5,a5,63
    1038:	9f99                	subw	a5,a5,a4
    103a:	0307879b          	addiw	a5,a5,48
    103e:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1042:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1046:	fb040513          	addi	a0,s0,-80
    104a:	00004097          	auipc	ra,0x4
    104e:	612080e7          	jalr	1554(ra) # 565c <unlink>
    1052:	ed21                	bnez	a0,10aa <bigdir+0x148>
  for(i = 0; i < N; i++){
    1054:	2485                	addiw	s1,s1,1
    1056:	fd4491e3          	bne	s1,s4,1018 <bigdir+0xb6>
}
    105a:	60a6                	ld	ra,72(sp)
    105c:	6406                	ld	s0,64(sp)
    105e:	74e2                	ld	s1,56(sp)
    1060:	7942                	ld	s2,48(sp)
    1062:	79a2                	ld	s3,40(sp)
    1064:	7a02                	ld	s4,32(sp)
    1066:	6ae2                	ld	s5,24(sp)
    1068:	6b42                	ld	s6,16(sp)
    106a:	6161                	addi	sp,sp,80
    106c:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    106e:	85ce                	mv	a1,s3
    1070:	00005517          	auipc	a0,0x5
    1074:	56850513          	addi	a0,a0,1384 # 65d8 <longjmp_1+0xa28>
    1078:	00005097          	auipc	ra,0x5
    107c:	924080e7          	jalr	-1756(ra) # 599c <printf>
    exit(1);
    1080:	4505                	li	a0,1
    1082:	00004097          	auipc	ra,0x4
    1086:	58a080e7          	jalr	1418(ra) # 560c <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    108a:	fb040613          	addi	a2,s0,-80
    108e:	85ce                	mv	a1,s3
    1090:	00005517          	auipc	a0,0x5
    1094:	56850513          	addi	a0,a0,1384 # 65f8 <longjmp_1+0xa48>
    1098:	00005097          	auipc	ra,0x5
    109c:	904080e7          	jalr	-1788(ra) # 599c <printf>
      exit(1);
    10a0:	4505                	li	a0,1
    10a2:	00004097          	auipc	ra,0x4
    10a6:	56a080e7          	jalr	1386(ra) # 560c <exit>
      printf("%s: bigdir unlink failed", s);
    10aa:	85ce                	mv	a1,s3
    10ac:	00005517          	auipc	a0,0x5
    10b0:	56c50513          	addi	a0,a0,1388 # 6618 <longjmp_1+0xa68>
    10b4:	00005097          	auipc	ra,0x5
    10b8:	8e8080e7          	jalr	-1816(ra) # 599c <printf>
      exit(1);
    10bc:	4505                	li	a0,1
    10be:	00004097          	auipc	ra,0x4
    10c2:	54e080e7          	jalr	1358(ra) # 560c <exit>

00000000000010c6 <validatetest>:
{
    10c6:	7139                	addi	sp,sp,-64
    10c8:	fc06                	sd	ra,56(sp)
    10ca:	f822                	sd	s0,48(sp)
    10cc:	f426                	sd	s1,40(sp)
    10ce:	f04a                	sd	s2,32(sp)
    10d0:	ec4e                	sd	s3,24(sp)
    10d2:	e852                	sd	s4,16(sp)
    10d4:	e456                	sd	s5,8(sp)
    10d6:	e05a                	sd	s6,0(sp)
    10d8:	0080                	addi	s0,sp,64
    10da:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10dc:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    10de:	00005997          	auipc	s3,0x5
    10e2:	55a98993          	addi	s3,s3,1370 # 6638 <longjmp_1+0xa88>
    10e6:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10e8:	6a85                	lui	s5,0x1
    10ea:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    10ee:	85a6                	mv	a1,s1
    10f0:	854e                	mv	a0,s3
    10f2:	00004097          	auipc	ra,0x4
    10f6:	57a080e7          	jalr	1402(ra) # 566c <link>
    10fa:	01251f63          	bne	a0,s2,1118 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10fe:	94d6                	add	s1,s1,s5
    1100:	ff4497e3          	bne	s1,s4,10ee <validatetest+0x28>
}
    1104:	70e2                	ld	ra,56(sp)
    1106:	7442                	ld	s0,48(sp)
    1108:	74a2                	ld	s1,40(sp)
    110a:	7902                	ld	s2,32(sp)
    110c:	69e2                	ld	s3,24(sp)
    110e:	6a42                	ld	s4,16(sp)
    1110:	6aa2                	ld	s5,8(sp)
    1112:	6b02                	ld	s6,0(sp)
    1114:	6121                	addi	sp,sp,64
    1116:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1118:	85da                	mv	a1,s6
    111a:	00005517          	auipc	a0,0x5
    111e:	52e50513          	addi	a0,a0,1326 # 6648 <longjmp_1+0xa98>
    1122:	00005097          	auipc	ra,0x5
    1126:	87a080e7          	jalr	-1926(ra) # 599c <printf>
      exit(1);
    112a:	4505                	li	a0,1
    112c:	00004097          	auipc	ra,0x4
    1130:	4e0080e7          	jalr	1248(ra) # 560c <exit>

0000000000001134 <pgbug>:
// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void
pgbug(char *s)
{
    1134:	7179                	addi	sp,sp,-48
    1136:	f406                	sd	ra,40(sp)
    1138:	f022                	sd	s0,32(sp)
    113a:	ec26                	sd	s1,24(sp)
    113c:	1800                	addi	s0,sp,48
  char *argv[1];
  argv[0] = 0;
    113e:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    1142:	00007497          	auipc	s1,0x7
    1146:	1b64b483          	ld	s1,438(s1) # 82f8 <__SDATA_BEGIN__>
    114a:	fd840593          	addi	a1,s0,-40
    114e:	8526                	mv	a0,s1
    1150:	00004097          	auipc	ra,0x4
    1154:	4f4080e7          	jalr	1268(ra) # 5644 <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    1158:	8526                	mv	a0,s1
    115a:	00004097          	auipc	ra,0x4
    115e:	4c2080e7          	jalr	1218(ra) # 561c <pipe>

  exit(0);
    1162:	4501                	li	a0,0
    1164:	00004097          	auipc	ra,0x4
    1168:	4a8080e7          	jalr	1192(ra) # 560c <exit>

000000000000116c <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    116c:	7139                	addi	sp,sp,-64
    116e:	fc06                	sd	ra,56(sp)
    1170:	f822                	sd	s0,48(sp)
    1172:	f426                	sd	s1,40(sp)
    1174:	f04a                	sd	s2,32(sp)
    1176:	ec4e                	sd	s3,24(sp)
    1178:	0080                	addi	s0,sp,64
    117a:	64b1                	lui	s1,0xc
    117c:	35048493          	addi	s1,s1,848 # c350 <buf+0x828>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    1180:	597d                	li	s2,-1
    1182:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    1186:	00005997          	auipc	s3,0x5
    118a:	d8a98993          	addi	s3,s3,-630 # 5f10 <longjmp_1+0x360>
    argv[0] = (char*)0xffffffff;
    118e:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1192:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1196:	fc040593          	addi	a1,s0,-64
    119a:	854e                	mv	a0,s3
    119c:	00004097          	auipc	ra,0x4
    11a0:	4a8080e7          	jalr	1192(ra) # 5644 <exec>
  for(int i = 0; i < 50000; i++){
    11a4:	34fd                	addiw	s1,s1,-1
    11a6:	f4e5                	bnez	s1,118e <badarg+0x22>
  }
  
  exit(0);
    11a8:	4501                	li	a0,0
    11aa:	00004097          	auipc	ra,0x4
    11ae:	462080e7          	jalr	1122(ra) # 560c <exit>

00000000000011b2 <copyinstr2>:
{
    11b2:	7155                	addi	sp,sp,-208
    11b4:	e586                	sd	ra,200(sp)
    11b6:	e1a2                	sd	s0,192(sp)
    11b8:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    11ba:	f6840793          	addi	a5,s0,-152
    11be:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    11c2:	07800713          	li	a4,120
    11c6:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    11ca:	0785                	addi	a5,a5,1
    11cc:	fed79de3          	bne	a5,a3,11c6 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    11d0:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    11d4:	f6840513          	addi	a0,s0,-152
    11d8:	00004097          	auipc	ra,0x4
    11dc:	484080e7          	jalr	1156(ra) # 565c <unlink>
  if(ret != -1){
    11e0:	57fd                	li	a5,-1
    11e2:	0ef51063          	bne	a0,a5,12c2 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    11e6:	20100593          	li	a1,513
    11ea:	f6840513          	addi	a0,s0,-152
    11ee:	00004097          	auipc	ra,0x4
    11f2:	45e080e7          	jalr	1118(ra) # 564c <open>
  if(fd != -1){
    11f6:	57fd                	li	a5,-1
    11f8:	0ef51563          	bne	a0,a5,12e2 <copyinstr2+0x130>
  ret = link(b, b);
    11fc:	f6840593          	addi	a1,s0,-152
    1200:	852e                	mv	a0,a1
    1202:	00004097          	auipc	ra,0x4
    1206:	46a080e7          	jalr	1130(ra) # 566c <link>
  if(ret != -1){
    120a:	57fd                	li	a5,-1
    120c:	0ef51b63          	bne	a0,a5,1302 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    1210:	00006797          	auipc	a5,0x6
    1214:	60878793          	addi	a5,a5,1544 # 7818 <longjmp_1+0x1c68>
    1218:	f4f43c23          	sd	a5,-168(s0)
    121c:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1220:	f5840593          	addi	a1,s0,-168
    1224:	f6840513          	addi	a0,s0,-152
    1228:	00004097          	auipc	ra,0x4
    122c:	41c080e7          	jalr	1052(ra) # 5644 <exec>
  if(ret != -1){
    1230:	57fd                	li	a5,-1
    1232:	0ef51963          	bne	a0,a5,1324 <copyinstr2+0x172>
  int pid = fork();
    1236:	00004097          	auipc	ra,0x4
    123a:	3ce080e7          	jalr	974(ra) # 5604 <fork>
  if(pid < 0){
    123e:	10054363          	bltz	a0,1344 <copyinstr2+0x192>
  if(pid == 0){
    1242:	12051463          	bnez	a0,136a <copyinstr2+0x1b8>
    1246:	00007797          	auipc	a5,0x7
    124a:	1ca78793          	addi	a5,a5,458 # 8410 <big.0>
    124e:	00008697          	auipc	a3,0x8
    1252:	1c268693          	addi	a3,a3,450 # 9410 <__global_pointer$+0x918>
      big[i] = 'x';
    1256:	07800713          	li	a4,120
    125a:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    125e:	0785                	addi	a5,a5,1
    1260:	fed79de3          	bne	a5,a3,125a <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1264:	00008797          	auipc	a5,0x8
    1268:	1a078623          	sb	zero,428(a5) # 9410 <__global_pointer$+0x918>
    char *args2[] = { big, big, big, 0 };
    126c:	00007797          	auipc	a5,0x7
    1270:	c9c78793          	addi	a5,a5,-868 # 7f08 <longjmp_1+0x2358>
    1274:	6390                	ld	a2,0(a5)
    1276:	6794                	ld	a3,8(a5)
    1278:	6b98                	ld	a4,16(a5)
    127a:	6f9c                	ld	a5,24(a5)
    127c:	f2c43823          	sd	a2,-208(s0)
    1280:	f2d43c23          	sd	a3,-200(s0)
    1284:	f4e43023          	sd	a4,-192(s0)
    1288:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    128c:	f3040593          	addi	a1,s0,-208
    1290:	00005517          	auipc	a0,0x5
    1294:	c8050513          	addi	a0,a0,-896 # 5f10 <longjmp_1+0x360>
    1298:	00004097          	auipc	ra,0x4
    129c:	3ac080e7          	jalr	940(ra) # 5644 <exec>
    if(ret != -1){
    12a0:	57fd                	li	a5,-1
    12a2:	0af50e63          	beq	a0,a5,135e <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    12a6:	55fd                	li	a1,-1
    12a8:	00005517          	auipc	a0,0x5
    12ac:	44850513          	addi	a0,a0,1096 # 66f0 <longjmp_1+0xb40>
    12b0:	00004097          	auipc	ra,0x4
    12b4:	6ec080e7          	jalr	1772(ra) # 599c <printf>
      exit(1);
    12b8:	4505                	li	a0,1
    12ba:	00004097          	auipc	ra,0x4
    12be:	352080e7          	jalr	850(ra) # 560c <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    12c2:	862a                	mv	a2,a0
    12c4:	f6840593          	addi	a1,s0,-152
    12c8:	00005517          	auipc	a0,0x5
    12cc:	3a050513          	addi	a0,a0,928 # 6668 <longjmp_1+0xab8>
    12d0:	00004097          	auipc	ra,0x4
    12d4:	6cc080e7          	jalr	1740(ra) # 599c <printf>
    exit(1);
    12d8:	4505                	li	a0,1
    12da:	00004097          	auipc	ra,0x4
    12de:	332080e7          	jalr	818(ra) # 560c <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    12e2:	862a                	mv	a2,a0
    12e4:	f6840593          	addi	a1,s0,-152
    12e8:	00005517          	auipc	a0,0x5
    12ec:	3a050513          	addi	a0,a0,928 # 6688 <longjmp_1+0xad8>
    12f0:	00004097          	auipc	ra,0x4
    12f4:	6ac080e7          	jalr	1708(ra) # 599c <printf>
    exit(1);
    12f8:	4505                	li	a0,1
    12fa:	00004097          	auipc	ra,0x4
    12fe:	312080e7          	jalr	786(ra) # 560c <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1302:	86aa                	mv	a3,a0
    1304:	f6840613          	addi	a2,s0,-152
    1308:	85b2                	mv	a1,a2
    130a:	00005517          	auipc	a0,0x5
    130e:	39e50513          	addi	a0,a0,926 # 66a8 <longjmp_1+0xaf8>
    1312:	00004097          	auipc	ra,0x4
    1316:	68a080e7          	jalr	1674(ra) # 599c <printf>
    exit(1);
    131a:	4505                	li	a0,1
    131c:	00004097          	auipc	ra,0x4
    1320:	2f0080e7          	jalr	752(ra) # 560c <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1324:	567d                	li	a2,-1
    1326:	f6840593          	addi	a1,s0,-152
    132a:	00005517          	auipc	a0,0x5
    132e:	3a650513          	addi	a0,a0,934 # 66d0 <longjmp_1+0xb20>
    1332:	00004097          	auipc	ra,0x4
    1336:	66a080e7          	jalr	1642(ra) # 599c <printf>
    exit(1);
    133a:	4505                	li	a0,1
    133c:	00004097          	auipc	ra,0x4
    1340:	2d0080e7          	jalr	720(ra) # 560c <exit>
    printf("fork failed\n");
    1344:	00006517          	auipc	a0,0x6
    1348:	80c50513          	addi	a0,a0,-2036 # 6b50 <longjmp_1+0xfa0>
    134c:	00004097          	auipc	ra,0x4
    1350:	650080e7          	jalr	1616(ra) # 599c <printf>
    exit(1);
    1354:	4505                	li	a0,1
    1356:	00004097          	auipc	ra,0x4
    135a:	2b6080e7          	jalr	694(ra) # 560c <exit>
    exit(747); // OK
    135e:	2eb00513          	li	a0,747
    1362:	00004097          	auipc	ra,0x4
    1366:	2aa080e7          	jalr	682(ra) # 560c <exit>
  int st = 0;
    136a:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    136e:	f5440513          	addi	a0,s0,-172
    1372:	00004097          	auipc	ra,0x4
    1376:	2a2080e7          	jalr	674(ra) # 5614 <wait>
  if(st != 747){
    137a:	f5442703          	lw	a4,-172(s0)
    137e:	2eb00793          	li	a5,747
    1382:	00f71663          	bne	a4,a5,138e <copyinstr2+0x1dc>
}
    1386:	60ae                	ld	ra,200(sp)
    1388:	640e                	ld	s0,192(sp)
    138a:	6169                	addi	sp,sp,208
    138c:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    138e:	00005517          	auipc	a0,0x5
    1392:	38a50513          	addi	a0,a0,906 # 6718 <longjmp_1+0xb68>
    1396:	00004097          	auipc	ra,0x4
    139a:	606080e7          	jalr	1542(ra) # 599c <printf>
    exit(1);
    139e:	4505                	li	a0,1
    13a0:	00004097          	auipc	ra,0x4
    13a4:	26c080e7          	jalr	620(ra) # 560c <exit>

00000000000013a8 <truncate3>:
{
    13a8:	7159                	addi	sp,sp,-112
    13aa:	f486                	sd	ra,104(sp)
    13ac:	f0a2                	sd	s0,96(sp)
    13ae:	eca6                	sd	s1,88(sp)
    13b0:	e8ca                	sd	s2,80(sp)
    13b2:	e4ce                	sd	s3,72(sp)
    13b4:	e0d2                	sd	s4,64(sp)
    13b6:	fc56                	sd	s5,56(sp)
    13b8:	1880                	addi	s0,sp,112
    13ba:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    13bc:	60100593          	li	a1,1537
    13c0:	00005517          	auipc	a0,0x5
    13c4:	ba850513          	addi	a0,a0,-1112 # 5f68 <longjmp_1+0x3b8>
    13c8:	00004097          	auipc	ra,0x4
    13cc:	284080e7          	jalr	644(ra) # 564c <open>
    13d0:	00004097          	auipc	ra,0x4
    13d4:	264080e7          	jalr	612(ra) # 5634 <close>
  pid = fork();
    13d8:	00004097          	auipc	ra,0x4
    13dc:	22c080e7          	jalr	556(ra) # 5604 <fork>
  if(pid < 0){
    13e0:	08054063          	bltz	a0,1460 <truncate3+0xb8>
  if(pid == 0){
    13e4:	e969                	bnez	a0,14b6 <truncate3+0x10e>
    13e6:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    13ea:	00005a17          	auipc	s4,0x5
    13ee:	b7ea0a13          	addi	s4,s4,-1154 # 5f68 <longjmp_1+0x3b8>
      int n = write(fd, "1234567890", 10);
    13f2:	00005a97          	auipc	s5,0x5
    13f6:	386a8a93          	addi	s5,s5,902 # 6778 <longjmp_1+0xbc8>
      int fd = open("truncfile", O_WRONLY);
    13fa:	4585                	li	a1,1
    13fc:	8552                	mv	a0,s4
    13fe:	00004097          	auipc	ra,0x4
    1402:	24e080e7          	jalr	590(ra) # 564c <open>
    1406:	84aa                	mv	s1,a0
      if(fd < 0){
    1408:	06054a63          	bltz	a0,147c <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    140c:	4629                	li	a2,10
    140e:	85d6                	mv	a1,s5
    1410:	00004097          	auipc	ra,0x4
    1414:	21c080e7          	jalr	540(ra) # 562c <write>
      if(n != 10){
    1418:	47a9                	li	a5,10
    141a:	06f51f63          	bne	a0,a5,1498 <truncate3+0xf0>
      close(fd);
    141e:	8526                	mv	a0,s1
    1420:	00004097          	auipc	ra,0x4
    1424:	214080e7          	jalr	532(ra) # 5634 <close>
      fd = open("truncfile", O_RDONLY);
    1428:	4581                	li	a1,0
    142a:	8552                	mv	a0,s4
    142c:	00004097          	auipc	ra,0x4
    1430:	220080e7          	jalr	544(ra) # 564c <open>
    1434:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1436:	02000613          	li	a2,32
    143a:	f9840593          	addi	a1,s0,-104
    143e:	00004097          	auipc	ra,0x4
    1442:	1e6080e7          	jalr	486(ra) # 5624 <read>
      close(fd);
    1446:	8526                	mv	a0,s1
    1448:	00004097          	auipc	ra,0x4
    144c:	1ec080e7          	jalr	492(ra) # 5634 <close>
    for(int i = 0; i < 100; i++){
    1450:	39fd                	addiw	s3,s3,-1
    1452:	fa0994e3          	bnez	s3,13fa <truncate3+0x52>
    exit(0);
    1456:	4501                	li	a0,0
    1458:	00004097          	auipc	ra,0x4
    145c:	1b4080e7          	jalr	436(ra) # 560c <exit>
    printf("%s: fork failed\n", s);
    1460:	85ca                	mv	a1,s2
    1462:	00005517          	auipc	a0,0x5
    1466:	2e650513          	addi	a0,a0,742 # 6748 <longjmp_1+0xb98>
    146a:	00004097          	auipc	ra,0x4
    146e:	532080e7          	jalr	1330(ra) # 599c <printf>
    exit(1);
    1472:	4505                	li	a0,1
    1474:	00004097          	auipc	ra,0x4
    1478:	198080e7          	jalr	408(ra) # 560c <exit>
        printf("%s: open failed\n", s);
    147c:	85ca                	mv	a1,s2
    147e:	00005517          	auipc	a0,0x5
    1482:	2e250513          	addi	a0,a0,738 # 6760 <longjmp_1+0xbb0>
    1486:	00004097          	auipc	ra,0x4
    148a:	516080e7          	jalr	1302(ra) # 599c <printf>
        exit(1);
    148e:	4505                	li	a0,1
    1490:	00004097          	auipc	ra,0x4
    1494:	17c080e7          	jalr	380(ra) # 560c <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1498:	862a                	mv	a2,a0
    149a:	85ca                	mv	a1,s2
    149c:	00005517          	auipc	a0,0x5
    14a0:	2ec50513          	addi	a0,a0,748 # 6788 <longjmp_1+0xbd8>
    14a4:	00004097          	auipc	ra,0x4
    14a8:	4f8080e7          	jalr	1272(ra) # 599c <printf>
        exit(1);
    14ac:	4505                	li	a0,1
    14ae:	00004097          	auipc	ra,0x4
    14b2:	15e080e7          	jalr	350(ra) # 560c <exit>
    14b6:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14ba:	00005a17          	auipc	s4,0x5
    14be:	aaea0a13          	addi	s4,s4,-1362 # 5f68 <longjmp_1+0x3b8>
    int n = write(fd, "xxx", 3);
    14c2:	00005a97          	auipc	s5,0x5
    14c6:	2e6a8a93          	addi	s5,s5,742 # 67a8 <longjmp_1+0xbf8>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14ca:	60100593          	li	a1,1537
    14ce:	8552                	mv	a0,s4
    14d0:	00004097          	auipc	ra,0x4
    14d4:	17c080e7          	jalr	380(ra) # 564c <open>
    14d8:	84aa                	mv	s1,a0
    if(fd < 0){
    14da:	04054763          	bltz	a0,1528 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    14de:	460d                	li	a2,3
    14e0:	85d6                	mv	a1,s5
    14e2:	00004097          	auipc	ra,0x4
    14e6:	14a080e7          	jalr	330(ra) # 562c <write>
    if(n != 3){
    14ea:	478d                	li	a5,3
    14ec:	04f51c63          	bne	a0,a5,1544 <truncate3+0x19c>
    close(fd);
    14f0:	8526                	mv	a0,s1
    14f2:	00004097          	auipc	ra,0x4
    14f6:	142080e7          	jalr	322(ra) # 5634 <close>
  for(int i = 0; i < 150; i++){
    14fa:	39fd                	addiw	s3,s3,-1
    14fc:	fc0997e3          	bnez	s3,14ca <truncate3+0x122>
  wait(&xstatus);
    1500:	fbc40513          	addi	a0,s0,-68
    1504:	00004097          	auipc	ra,0x4
    1508:	110080e7          	jalr	272(ra) # 5614 <wait>
  unlink("truncfile");
    150c:	00005517          	auipc	a0,0x5
    1510:	a5c50513          	addi	a0,a0,-1444 # 5f68 <longjmp_1+0x3b8>
    1514:	00004097          	auipc	ra,0x4
    1518:	148080e7          	jalr	328(ra) # 565c <unlink>
  exit(xstatus);
    151c:	fbc42503          	lw	a0,-68(s0)
    1520:	00004097          	auipc	ra,0x4
    1524:	0ec080e7          	jalr	236(ra) # 560c <exit>
      printf("%s: open failed\n", s);
    1528:	85ca                	mv	a1,s2
    152a:	00005517          	auipc	a0,0x5
    152e:	23650513          	addi	a0,a0,566 # 6760 <longjmp_1+0xbb0>
    1532:	00004097          	auipc	ra,0x4
    1536:	46a080e7          	jalr	1130(ra) # 599c <printf>
      exit(1);
    153a:	4505                	li	a0,1
    153c:	00004097          	auipc	ra,0x4
    1540:	0d0080e7          	jalr	208(ra) # 560c <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1544:	862a                	mv	a2,a0
    1546:	85ca                	mv	a1,s2
    1548:	00005517          	auipc	a0,0x5
    154c:	26850513          	addi	a0,a0,616 # 67b0 <longjmp_1+0xc00>
    1550:	00004097          	auipc	ra,0x4
    1554:	44c080e7          	jalr	1100(ra) # 599c <printf>
      exit(1);
    1558:	4505                	li	a0,1
    155a:	00004097          	auipc	ra,0x4
    155e:	0b2080e7          	jalr	178(ra) # 560c <exit>

0000000000001562 <exectest>:
{
    1562:	715d                	addi	sp,sp,-80
    1564:	e486                	sd	ra,72(sp)
    1566:	e0a2                	sd	s0,64(sp)
    1568:	fc26                	sd	s1,56(sp)
    156a:	f84a                	sd	s2,48(sp)
    156c:	0880                	addi	s0,sp,80
    156e:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1570:	00005797          	auipc	a5,0x5
    1574:	9a078793          	addi	a5,a5,-1632 # 5f10 <longjmp_1+0x360>
    1578:	fcf43023          	sd	a5,-64(s0)
    157c:	00005797          	auipc	a5,0x5
    1580:	25478793          	addi	a5,a5,596 # 67d0 <longjmp_1+0xc20>
    1584:	fcf43423          	sd	a5,-56(s0)
    1588:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    158c:	00005517          	auipc	a0,0x5
    1590:	24c50513          	addi	a0,a0,588 # 67d8 <longjmp_1+0xc28>
    1594:	00004097          	auipc	ra,0x4
    1598:	0c8080e7          	jalr	200(ra) # 565c <unlink>
  pid = fork();
    159c:	00004097          	auipc	ra,0x4
    15a0:	068080e7          	jalr	104(ra) # 5604 <fork>
  if(pid < 0) {
    15a4:	04054663          	bltz	a0,15f0 <exectest+0x8e>
    15a8:	84aa                	mv	s1,a0
  if(pid == 0) {
    15aa:	e959                	bnez	a0,1640 <exectest+0xde>
    close(1);
    15ac:	4505                	li	a0,1
    15ae:	00004097          	auipc	ra,0x4
    15b2:	086080e7          	jalr	134(ra) # 5634 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    15b6:	20100593          	li	a1,513
    15ba:	00005517          	auipc	a0,0x5
    15be:	21e50513          	addi	a0,a0,542 # 67d8 <longjmp_1+0xc28>
    15c2:	00004097          	auipc	ra,0x4
    15c6:	08a080e7          	jalr	138(ra) # 564c <open>
    if(fd < 0) {
    15ca:	04054163          	bltz	a0,160c <exectest+0xaa>
    if(fd != 1) {
    15ce:	4785                	li	a5,1
    15d0:	04f50c63          	beq	a0,a5,1628 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    15d4:	85ca                	mv	a1,s2
    15d6:	00005517          	auipc	a0,0x5
    15da:	22250513          	addi	a0,a0,546 # 67f8 <longjmp_1+0xc48>
    15de:	00004097          	auipc	ra,0x4
    15e2:	3be080e7          	jalr	958(ra) # 599c <printf>
      exit(1);
    15e6:	4505                	li	a0,1
    15e8:	00004097          	auipc	ra,0x4
    15ec:	024080e7          	jalr	36(ra) # 560c <exit>
     printf("%s: fork failed\n", s);
    15f0:	85ca                	mv	a1,s2
    15f2:	00005517          	auipc	a0,0x5
    15f6:	15650513          	addi	a0,a0,342 # 6748 <longjmp_1+0xb98>
    15fa:	00004097          	auipc	ra,0x4
    15fe:	3a2080e7          	jalr	930(ra) # 599c <printf>
     exit(1);
    1602:	4505                	li	a0,1
    1604:	00004097          	auipc	ra,0x4
    1608:	008080e7          	jalr	8(ra) # 560c <exit>
      printf("%s: create failed\n", s);
    160c:	85ca                	mv	a1,s2
    160e:	00005517          	auipc	a0,0x5
    1612:	1d250513          	addi	a0,a0,466 # 67e0 <longjmp_1+0xc30>
    1616:	00004097          	auipc	ra,0x4
    161a:	386080e7          	jalr	902(ra) # 599c <printf>
      exit(1);
    161e:	4505                	li	a0,1
    1620:	00004097          	auipc	ra,0x4
    1624:	fec080e7          	jalr	-20(ra) # 560c <exit>
    if(exec("echo", echoargv) < 0){
    1628:	fc040593          	addi	a1,s0,-64
    162c:	00005517          	auipc	a0,0x5
    1630:	8e450513          	addi	a0,a0,-1820 # 5f10 <longjmp_1+0x360>
    1634:	00004097          	auipc	ra,0x4
    1638:	010080e7          	jalr	16(ra) # 5644 <exec>
    163c:	02054163          	bltz	a0,165e <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1640:	fdc40513          	addi	a0,s0,-36
    1644:	00004097          	auipc	ra,0x4
    1648:	fd0080e7          	jalr	-48(ra) # 5614 <wait>
    164c:	02951763          	bne	a0,s1,167a <exectest+0x118>
  if(xstatus != 0)
    1650:	fdc42503          	lw	a0,-36(s0)
    1654:	cd0d                	beqz	a0,168e <exectest+0x12c>
    exit(xstatus);
    1656:	00004097          	auipc	ra,0x4
    165a:	fb6080e7          	jalr	-74(ra) # 560c <exit>
      printf("%s: exec echo failed\n", s);
    165e:	85ca                	mv	a1,s2
    1660:	00005517          	auipc	a0,0x5
    1664:	1a850513          	addi	a0,a0,424 # 6808 <longjmp_1+0xc58>
    1668:	00004097          	auipc	ra,0x4
    166c:	334080e7          	jalr	820(ra) # 599c <printf>
      exit(1);
    1670:	4505                	li	a0,1
    1672:	00004097          	auipc	ra,0x4
    1676:	f9a080e7          	jalr	-102(ra) # 560c <exit>
    printf("%s: wait failed!\n", s);
    167a:	85ca                	mv	a1,s2
    167c:	00005517          	auipc	a0,0x5
    1680:	1a450513          	addi	a0,a0,420 # 6820 <longjmp_1+0xc70>
    1684:	00004097          	auipc	ra,0x4
    1688:	318080e7          	jalr	792(ra) # 599c <printf>
    168c:	b7d1                	j	1650 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    168e:	4581                	li	a1,0
    1690:	00005517          	auipc	a0,0x5
    1694:	14850513          	addi	a0,a0,328 # 67d8 <longjmp_1+0xc28>
    1698:	00004097          	auipc	ra,0x4
    169c:	fb4080e7          	jalr	-76(ra) # 564c <open>
  if(fd < 0) {
    16a0:	02054a63          	bltz	a0,16d4 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    16a4:	4609                	li	a2,2
    16a6:	fb840593          	addi	a1,s0,-72
    16aa:	00004097          	auipc	ra,0x4
    16ae:	f7a080e7          	jalr	-134(ra) # 5624 <read>
    16b2:	4789                	li	a5,2
    16b4:	02f50e63          	beq	a0,a5,16f0 <exectest+0x18e>
    printf("%s: read failed\n", s);
    16b8:	85ca                	mv	a1,s2
    16ba:	00005517          	auipc	a0,0x5
    16be:	be650513          	addi	a0,a0,-1050 # 62a0 <longjmp_1+0x6f0>
    16c2:	00004097          	auipc	ra,0x4
    16c6:	2da080e7          	jalr	730(ra) # 599c <printf>
    exit(1);
    16ca:	4505                	li	a0,1
    16cc:	00004097          	auipc	ra,0x4
    16d0:	f40080e7          	jalr	-192(ra) # 560c <exit>
    printf("%s: open failed\n", s);
    16d4:	85ca                	mv	a1,s2
    16d6:	00005517          	auipc	a0,0x5
    16da:	08a50513          	addi	a0,a0,138 # 6760 <longjmp_1+0xbb0>
    16de:	00004097          	auipc	ra,0x4
    16e2:	2be080e7          	jalr	702(ra) # 599c <printf>
    exit(1);
    16e6:	4505                	li	a0,1
    16e8:	00004097          	auipc	ra,0x4
    16ec:	f24080e7          	jalr	-220(ra) # 560c <exit>
  unlink("echo-ok");
    16f0:	00005517          	auipc	a0,0x5
    16f4:	0e850513          	addi	a0,a0,232 # 67d8 <longjmp_1+0xc28>
    16f8:	00004097          	auipc	ra,0x4
    16fc:	f64080e7          	jalr	-156(ra) # 565c <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1700:	fb844703          	lbu	a4,-72(s0)
    1704:	04f00793          	li	a5,79
    1708:	00f71863          	bne	a4,a5,1718 <exectest+0x1b6>
    170c:	fb944703          	lbu	a4,-71(s0)
    1710:	04b00793          	li	a5,75
    1714:	02f70063          	beq	a4,a5,1734 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    1718:	85ca                	mv	a1,s2
    171a:	00005517          	auipc	a0,0x5
    171e:	11e50513          	addi	a0,a0,286 # 6838 <longjmp_1+0xc88>
    1722:	00004097          	auipc	ra,0x4
    1726:	27a080e7          	jalr	634(ra) # 599c <printf>
    exit(1);
    172a:	4505                	li	a0,1
    172c:	00004097          	auipc	ra,0x4
    1730:	ee0080e7          	jalr	-288(ra) # 560c <exit>
    exit(0);
    1734:	4501                	li	a0,0
    1736:	00004097          	auipc	ra,0x4
    173a:	ed6080e7          	jalr	-298(ra) # 560c <exit>

000000000000173e <pipe1>:
{
    173e:	711d                	addi	sp,sp,-96
    1740:	ec86                	sd	ra,88(sp)
    1742:	e8a2                	sd	s0,80(sp)
    1744:	e4a6                	sd	s1,72(sp)
    1746:	e0ca                	sd	s2,64(sp)
    1748:	fc4e                	sd	s3,56(sp)
    174a:	f852                	sd	s4,48(sp)
    174c:	f456                	sd	s5,40(sp)
    174e:	f05a                	sd	s6,32(sp)
    1750:	ec5e                	sd	s7,24(sp)
    1752:	1080                	addi	s0,sp,96
    1754:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1756:	fa840513          	addi	a0,s0,-88
    175a:	00004097          	auipc	ra,0x4
    175e:	ec2080e7          	jalr	-318(ra) # 561c <pipe>
    1762:	ed25                	bnez	a0,17da <pipe1+0x9c>
    1764:	84aa                	mv	s1,a0
  pid = fork();
    1766:	00004097          	auipc	ra,0x4
    176a:	e9e080e7          	jalr	-354(ra) # 5604 <fork>
    176e:	8a2a                	mv	s4,a0
  if(pid == 0){
    1770:	c159                	beqz	a0,17f6 <pipe1+0xb8>
  } else if(pid > 0){
    1772:	16a05e63          	blez	a0,18ee <pipe1+0x1b0>
    close(fds[1]);
    1776:	fac42503          	lw	a0,-84(s0)
    177a:	00004097          	auipc	ra,0x4
    177e:	eba080e7          	jalr	-326(ra) # 5634 <close>
    total = 0;
    1782:	8a26                	mv	s4,s1
    cc = 1;
    1784:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    1786:	0000aa97          	auipc	s5,0xa
    178a:	3a2a8a93          	addi	s5,s5,930 # bb28 <buf>
      if(cc > sizeof(buf))
    178e:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    1790:	864e                	mv	a2,s3
    1792:	85d6                	mv	a1,s5
    1794:	fa842503          	lw	a0,-88(s0)
    1798:	00004097          	auipc	ra,0x4
    179c:	e8c080e7          	jalr	-372(ra) # 5624 <read>
    17a0:	10a05263          	blez	a0,18a4 <pipe1+0x166>
      for(i = 0; i < n; i++){
    17a4:	0000a717          	auipc	a4,0xa
    17a8:	38470713          	addi	a4,a4,900 # bb28 <buf>
    17ac:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17b0:	00074683          	lbu	a3,0(a4)
    17b4:	0ff4f793          	andi	a5,s1,255
    17b8:	2485                	addiw	s1,s1,1
    17ba:	0cf69163          	bne	a3,a5,187c <pipe1+0x13e>
      for(i = 0; i < n; i++){
    17be:	0705                	addi	a4,a4,1
    17c0:	fec498e3          	bne	s1,a2,17b0 <pipe1+0x72>
      total += n;
    17c4:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    17c8:	0019979b          	slliw	a5,s3,0x1
    17cc:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    17d0:	013b7363          	bgeu	s6,s3,17d6 <pipe1+0x98>
        cc = sizeof(buf);
    17d4:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17d6:	84b2                	mv	s1,a2
    17d8:	bf65                	j	1790 <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    17da:	85ca                	mv	a1,s2
    17dc:	00005517          	auipc	a0,0x5
    17e0:	07450513          	addi	a0,a0,116 # 6850 <longjmp_1+0xca0>
    17e4:	00004097          	auipc	ra,0x4
    17e8:	1b8080e7          	jalr	440(ra) # 599c <printf>
    exit(1);
    17ec:	4505                	li	a0,1
    17ee:	00004097          	auipc	ra,0x4
    17f2:	e1e080e7          	jalr	-482(ra) # 560c <exit>
    close(fds[0]);
    17f6:	fa842503          	lw	a0,-88(s0)
    17fa:	00004097          	auipc	ra,0x4
    17fe:	e3a080e7          	jalr	-454(ra) # 5634 <close>
    for(n = 0; n < N; n++){
    1802:	0000ab17          	auipc	s6,0xa
    1806:	326b0b13          	addi	s6,s6,806 # bb28 <buf>
    180a:	416004bb          	negw	s1,s6
    180e:	0ff4f493          	andi	s1,s1,255
    1812:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1816:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1818:	6a85                	lui	s5,0x1
    181a:	42da8a93          	addi	s5,s5,1069 # 142d <truncate3+0x85>
{
    181e:	87da                	mv	a5,s6
        buf[i] = seq++;
    1820:	0097873b          	addw	a4,a5,s1
    1824:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1828:	0785                	addi	a5,a5,1
    182a:	fef99be3          	bne	s3,a5,1820 <pipe1+0xe2>
        buf[i] = seq++;
    182e:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1832:	40900613          	li	a2,1033
    1836:	85de                	mv	a1,s7
    1838:	fac42503          	lw	a0,-84(s0)
    183c:	00004097          	auipc	ra,0x4
    1840:	df0080e7          	jalr	-528(ra) # 562c <write>
    1844:	40900793          	li	a5,1033
    1848:	00f51c63          	bne	a0,a5,1860 <pipe1+0x122>
    for(n = 0; n < N; n++){
    184c:	24a5                	addiw	s1,s1,9
    184e:	0ff4f493          	andi	s1,s1,255
    1852:	fd5a16e3          	bne	s4,s5,181e <pipe1+0xe0>
    exit(0);
    1856:	4501                	li	a0,0
    1858:	00004097          	auipc	ra,0x4
    185c:	db4080e7          	jalr	-588(ra) # 560c <exit>
        printf("%s: pipe1 oops 1\n", s);
    1860:	85ca                	mv	a1,s2
    1862:	00005517          	auipc	a0,0x5
    1866:	00650513          	addi	a0,a0,6 # 6868 <longjmp_1+0xcb8>
    186a:	00004097          	auipc	ra,0x4
    186e:	132080e7          	jalr	306(ra) # 599c <printf>
        exit(1);
    1872:	4505                	li	a0,1
    1874:	00004097          	auipc	ra,0x4
    1878:	d98080e7          	jalr	-616(ra) # 560c <exit>
          printf("%s: pipe1 oops 2\n", s);
    187c:	85ca                	mv	a1,s2
    187e:	00005517          	auipc	a0,0x5
    1882:	00250513          	addi	a0,a0,2 # 6880 <longjmp_1+0xcd0>
    1886:	00004097          	auipc	ra,0x4
    188a:	116080e7          	jalr	278(ra) # 599c <printf>
}
    188e:	60e6                	ld	ra,88(sp)
    1890:	6446                	ld	s0,80(sp)
    1892:	64a6                	ld	s1,72(sp)
    1894:	6906                	ld	s2,64(sp)
    1896:	79e2                	ld	s3,56(sp)
    1898:	7a42                	ld	s4,48(sp)
    189a:	7aa2                	ld	s5,40(sp)
    189c:	7b02                	ld	s6,32(sp)
    189e:	6be2                	ld	s7,24(sp)
    18a0:	6125                	addi	sp,sp,96
    18a2:	8082                	ret
    if(total != N * SZ){
    18a4:	6785                	lui	a5,0x1
    18a6:	42d78793          	addi	a5,a5,1069 # 142d <truncate3+0x85>
    18aa:	02fa0063          	beq	s4,a5,18ca <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    18ae:	85d2                	mv	a1,s4
    18b0:	00005517          	auipc	a0,0x5
    18b4:	fe850513          	addi	a0,a0,-24 # 6898 <longjmp_1+0xce8>
    18b8:	00004097          	auipc	ra,0x4
    18bc:	0e4080e7          	jalr	228(ra) # 599c <printf>
      exit(1);
    18c0:	4505                	li	a0,1
    18c2:	00004097          	auipc	ra,0x4
    18c6:	d4a080e7          	jalr	-694(ra) # 560c <exit>
    close(fds[0]);
    18ca:	fa842503          	lw	a0,-88(s0)
    18ce:	00004097          	auipc	ra,0x4
    18d2:	d66080e7          	jalr	-666(ra) # 5634 <close>
    wait(&xstatus);
    18d6:	fa440513          	addi	a0,s0,-92
    18da:	00004097          	auipc	ra,0x4
    18de:	d3a080e7          	jalr	-710(ra) # 5614 <wait>
    exit(xstatus);
    18e2:	fa442503          	lw	a0,-92(s0)
    18e6:	00004097          	auipc	ra,0x4
    18ea:	d26080e7          	jalr	-730(ra) # 560c <exit>
    printf("%s: fork() failed\n", s);
    18ee:	85ca                	mv	a1,s2
    18f0:	00005517          	auipc	a0,0x5
    18f4:	fc850513          	addi	a0,a0,-56 # 68b8 <longjmp_1+0xd08>
    18f8:	00004097          	auipc	ra,0x4
    18fc:	0a4080e7          	jalr	164(ra) # 599c <printf>
    exit(1);
    1900:	4505                	li	a0,1
    1902:	00004097          	auipc	ra,0x4
    1906:	d0a080e7          	jalr	-758(ra) # 560c <exit>

000000000000190a <exitwait>:
{
    190a:	7139                	addi	sp,sp,-64
    190c:	fc06                	sd	ra,56(sp)
    190e:	f822                	sd	s0,48(sp)
    1910:	f426                	sd	s1,40(sp)
    1912:	f04a                	sd	s2,32(sp)
    1914:	ec4e                	sd	s3,24(sp)
    1916:	e852                	sd	s4,16(sp)
    1918:	0080                	addi	s0,sp,64
    191a:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    191c:	4901                	li	s2,0
    191e:	06400993          	li	s3,100
    pid = fork();
    1922:	00004097          	auipc	ra,0x4
    1926:	ce2080e7          	jalr	-798(ra) # 5604 <fork>
    192a:	84aa                	mv	s1,a0
    if(pid < 0){
    192c:	02054a63          	bltz	a0,1960 <exitwait+0x56>
    if(pid){
    1930:	c151                	beqz	a0,19b4 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1932:	fcc40513          	addi	a0,s0,-52
    1936:	00004097          	auipc	ra,0x4
    193a:	cde080e7          	jalr	-802(ra) # 5614 <wait>
    193e:	02951f63          	bne	a0,s1,197c <exitwait+0x72>
      if(i != xstate) {
    1942:	fcc42783          	lw	a5,-52(s0)
    1946:	05279963          	bne	a5,s2,1998 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    194a:	2905                	addiw	s2,s2,1
    194c:	fd391be3          	bne	s2,s3,1922 <exitwait+0x18>
}
    1950:	70e2                	ld	ra,56(sp)
    1952:	7442                	ld	s0,48(sp)
    1954:	74a2                	ld	s1,40(sp)
    1956:	7902                	ld	s2,32(sp)
    1958:	69e2                	ld	s3,24(sp)
    195a:	6a42                	ld	s4,16(sp)
    195c:	6121                	addi	sp,sp,64
    195e:	8082                	ret
      printf("%s: fork failed\n", s);
    1960:	85d2                	mv	a1,s4
    1962:	00005517          	auipc	a0,0x5
    1966:	de650513          	addi	a0,a0,-538 # 6748 <longjmp_1+0xb98>
    196a:	00004097          	auipc	ra,0x4
    196e:	032080e7          	jalr	50(ra) # 599c <printf>
      exit(1);
    1972:	4505                	li	a0,1
    1974:	00004097          	auipc	ra,0x4
    1978:	c98080e7          	jalr	-872(ra) # 560c <exit>
        printf("%s: wait wrong pid\n", s);
    197c:	85d2                	mv	a1,s4
    197e:	00005517          	auipc	a0,0x5
    1982:	f5250513          	addi	a0,a0,-174 # 68d0 <longjmp_1+0xd20>
    1986:	00004097          	auipc	ra,0x4
    198a:	016080e7          	jalr	22(ra) # 599c <printf>
        exit(1);
    198e:	4505                	li	a0,1
    1990:	00004097          	auipc	ra,0x4
    1994:	c7c080e7          	jalr	-900(ra) # 560c <exit>
        printf("%s: wait wrong exit status\n", s);
    1998:	85d2                	mv	a1,s4
    199a:	00005517          	auipc	a0,0x5
    199e:	f4e50513          	addi	a0,a0,-178 # 68e8 <longjmp_1+0xd38>
    19a2:	00004097          	auipc	ra,0x4
    19a6:	ffa080e7          	jalr	-6(ra) # 599c <printf>
        exit(1);
    19aa:	4505                	li	a0,1
    19ac:	00004097          	auipc	ra,0x4
    19b0:	c60080e7          	jalr	-928(ra) # 560c <exit>
      exit(i);
    19b4:	854a                	mv	a0,s2
    19b6:	00004097          	auipc	ra,0x4
    19ba:	c56080e7          	jalr	-938(ra) # 560c <exit>

00000000000019be <twochildren>:
{
    19be:	1101                	addi	sp,sp,-32
    19c0:	ec06                	sd	ra,24(sp)
    19c2:	e822                	sd	s0,16(sp)
    19c4:	e426                	sd	s1,8(sp)
    19c6:	e04a                	sd	s2,0(sp)
    19c8:	1000                	addi	s0,sp,32
    19ca:	892a                	mv	s2,a0
    19cc:	3e800493          	li	s1,1000
    int pid1 = fork();
    19d0:	00004097          	auipc	ra,0x4
    19d4:	c34080e7          	jalr	-972(ra) # 5604 <fork>
    if(pid1 < 0){
    19d8:	02054c63          	bltz	a0,1a10 <twochildren+0x52>
    if(pid1 == 0){
    19dc:	c921                	beqz	a0,1a2c <twochildren+0x6e>
      int pid2 = fork();
    19de:	00004097          	auipc	ra,0x4
    19e2:	c26080e7          	jalr	-986(ra) # 5604 <fork>
      if(pid2 < 0){
    19e6:	04054763          	bltz	a0,1a34 <twochildren+0x76>
      if(pid2 == 0){
    19ea:	c13d                	beqz	a0,1a50 <twochildren+0x92>
        wait(0);
    19ec:	4501                	li	a0,0
    19ee:	00004097          	auipc	ra,0x4
    19f2:	c26080e7          	jalr	-986(ra) # 5614 <wait>
        wait(0);
    19f6:	4501                	li	a0,0
    19f8:	00004097          	auipc	ra,0x4
    19fc:	c1c080e7          	jalr	-996(ra) # 5614 <wait>
  for(int i = 0; i < 1000; i++){
    1a00:	34fd                	addiw	s1,s1,-1
    1a02:	f4f9                	bnez	s1,19d0 <twochildren+0x12>
}
    1a04:	60e2                	ld	ra,24(sp)
    1a06:	6442                	ld	s0,16(sp)
    1a08:	64a2                	ld	s1,8(sp)
    1a0a:	6902                	ld	s2,0(sp)
    1a0c:	6105                	addi	sp,sp,32
    1a0e:	8082                	ret
      printf("%s: fork failed\n", s);
    1a10:	85ca                	mv	a1,s2
    1a12:	00005517          	auipc	a0,0x5
    1a16:	d3650513          	addi	a0,a0,-714 # 6748 <longjmp_1+0xb98>
    1a1a:	00004097          	auipc	ra,0x4
    1a1e:	f82080e7          	jalr	-126(ra) # 599c <printf>
      exit(1);
    1a22:	4505                	li	a0,1
    1a24:	00004097          	auipc	ra,0x4
    1a28:	be8080e7          	jalr	-1048(ra) # 560c <exit>
      exit(0);
    1a2c:	00004097          	auipc	ra,0x4
    1a30:	be0080e7          	jalr	-1056(ra) # 560c <exit>
        printf("%s: fork failed\n", s);
    1a34:	85ca                	mv	a1,s2
    1a36:	00005517          	auipc	a0,0x5
    1a3a:	d1250513          	addi	a0,a0,-750 # 6748 <longjmp_1+0xb98>
    1a3e:	00004097          	auipc	ra,0x4
    1a42:	f5e080e7          	jalr	-162(ra) # 599c <printf>
        exit(1);
    1a46:	4505                	li	a0,1
    1a48:	00004097          	auipc	ra,0x4
    1a4c:	bc4080e7          	jalr	-1084(ra) # 560c <exit>
        exit(0);
    1a50:	00004097          	auipc	ra,0x4
    1a54:	bbc080e7          	jalr	-1092(ra) # 560c <exit>

0000000000001a58 <forkfork>:
{
    1a58:	7179                	addi	sp,sp,-48
    1a5a:	f406                	sd	ra,40(sp)
    1a5c:	f022                	sd	s0,32(sp)
    1a5e:	ec26                	sd	s1,24(sp)
    1a60:	1800                	addi	s0,sp,48
    1a62:	84aa                	mv	s1,a0
    int pid = fork();
    1a64:	00004097          	auipc	ra,0x4
    1a68:	ba0080e7          	jalr	-1120(ra) # 5604 <fork>
    if(pid < 0){
    1a6c:	04054163          	bltz	a0,1aae <forkfork+0x56>
    if(pid == 0){
    1a70:	cd29                	beqz	a0,1aca <forkfork+0x72>
    int pid = fork();
    1a72:	00004097          	auipc	ra,0x4
    1a76:	b92080e7          	jalr	-1134(ra) # 5604 <fork>
    if(pid < 0){
    1a7a:	02054a63          	bltz	a0,1aae <forkfork+0x56>
    if(pid == 0){
    1a7e:	c531                	beqz	a0,1aca <forkfork+0x72>
    wait(&xstatus);
    1a80:	fdc40513          	addi	a0,s0,-36
    1a84:	00004097          	auipc	ra,0x4
    1a88:	b90080e7          	jalr	-1136(ra) # 5614 <wait>
    if(xstatus != 0) {
    1a8c:	fdc42783          	lw	a5,-36(s0)
    1a90:	ebbd                	bnez	a5,1b06 <forkfork+0xae>
    wait(&xstatus);
    1a92:	fdc40513          	addi	a0,s0,-36
    1a96:	00004097          	auipc	ra,0x4
    1a9a:	b7e080e7          	jalr	-1154(ra) # 5614 <wait>
    if(xstatus != 0) {
    1a9e:	fdc42783          	lw	a5,-36(s0)
    1aa2:	e3b5                	bnez	a5,1b06 <forkfork+0xae>
}
    1aa4:	70a2                	ld	ra,40(sp)
    1aa6:	7402                	ld	s0,32(sp)
    1aa8:	64e2                	ld	s1,24(sp)
    1aaa:	6145                	addi	sp,sp,48
    1aac:	8082                	ret
      printf("%s: fork failed", s);
    1aae:	85a6                	mv	a1,s1
    1ab0:	00005517          	auipc	a0,0x5
    1ab4:	e5850513          	addi	a0,a0,-424 # 6908 <longjmp_1+0xd58>
    1ab8:	00004097          	auipc	ra,0x4
    1abc:	ee4080e7          	jalr	-284(ra) # 599c <printf>
      exit(1);
    1ac0:	4505                	li	a0,1
    1ac2:	00004097          	auipc	ra,0x4
    1ac6:	b4a080e7          	jalr	-1206(ra) # 560c <exit>
{
    1aca:	0c800493          	li	s1,200
        int pid1 = fork();
    1ace:	00004097          	auipc	ra,0x4
    1ad2:	b36080e7          	jalr	-1226(ra) # 5604 <fork>
        if(pid1 < 0){
    1ad6:	00054f63          	bltz	a0,1af4 <forkfork+0x9c>
        if(pid1 == 0){
    1ada:	c115                	beqz	a0,1afe <forkfork+0xa6>
        wait(0);
    1adc:	4501                	li	a0,0
    1ade:	00004097          	auipc	ra,0x4
    1ae2:	b36080e7          	jalr	-1226(ra) # 5614 <wait>
      for(int j = 0; j < 200; j++){
    1ae6:	34fd                	addiw	s1,s1,-1
    1ae8:	f0fd                	bnez	s1,1ace <forkfork+0x76>
      exit(0);
    1aea:	4501                	li	a0,0
    1aec:	00004097          	auipc	ra,0x4
    1af0:	b20080e7          	jalr	-1248(ra) # 560c <exit>
          exit(1);
    1af4:	4505                	li	a0,1
    1af6:	00004097          	auipc	ra,0x4
    1afa:	b16080e7          	jalr	-1258(ra) # 560c <exit>
          exit(0);
    1afe:	00004097          	auipc	ra,0x4
    1b02:	b0e080e7          	jalr	-1266(ra) # 560c <exit>
      printf("%s: fork in child failed", s);
    1b06:	85a6                	mv	a1,s1
    1b08:	00005517          	auipc	a0,0x5
    1b0c:	e1050513          	addi	a0,a0,-496 # 6918 <longjmp_1+0xd68>
    1b10:	00004097          	auipc	ra,0x4
    1b14:	e8c080e7          	jalr	-372(ra) # 599c <printf>
      exit(1);
    1b18:	4505                	li	a0,1
    1b1a:	00004097          	auipc	ra,0x4
    1b1e:	af2080e7          	jalr	-1294(ra) # 560c <exit>

0000000000001b22 <reparent2>:
{
    1b22:	1101                	addi	sp,sp,-32
    1b24:	ec06                	sd	ra,24(sp)
    1b26:	e822                	sd	s0,16(sp)
    1b28:	e426                	sd	s1,8(sp)
    1b2a:	1000                	addi	s0,sp,32
    1b2c:	32000493          	li	s1,800
    int pid1 = fork();
    1b30:	00004097          	auipc	ra,0x4
    1b34:	ad4080e7          	jalr	-1324(ra) # 5604 <fork>
    if(pid1 < 0){
    1b38:	00054f63          	bltz	a0,1b56 <reparent2+0x34>
    if(pid1 == 0){
    1b3c:	c915                	beqz	a0,1b70 <reparent2+0x4e>
    wait(0);
    1b3e:	4501                	li	a0,0
    1b40:	00004097          	auipc	ra,0x4
    1b44:	ad4080e7          	jalr	-1324(ra) # 5614 <wait>
  for(int i = 0; i < 800; i++){
    1b48:	34fd                	addiw	s1,s1,-1
    1b4a:	f0fd                	bnez	s1,1b30 <reparent2+0xe>
  exit(0);
    1b4c:	4501                	li	a0,0
    1b4e:	00004097          	auipc	ra,0x4
    1b52:	abe080e7          	jalr	-1346(ra) # 560c <exit>
      printf("fork failed\n");
    1b56:	00005517          	auipc	a0,0x5
    1b5a:	ffa50513          	addi	a0,a0,-6 # 6b50 <longjmp_1+0xfa0>
    1b5e:	00004097          	auipc	ra,0x4
    1b62:	e3e080e7          	jalr	-450(ra) # 599c <printf>
      exit(1);
    1b66:	4505                	li	a0,1
    1b68:	00004097          	auipc	ra,0x4
    1b6c:	aa4080e7          	jalr	-1372(ra) # 560c <exit>
      fork();
    1b70:	00004097          	auipc	ra,0x4
    1b74:	a94080e7          	jalr	-1388(ra) # 5604 <fork>
      fork();
    1b78:	00004097          	auipc	ra,0x4
    1b7c:	a8c080e7          	jalr	-1396(ra) # 5604 <fork>
      exit(0);
    1b80:	4501                	li	a0,0
    1b82:	00004097          	auipc	ra,0x4
    1b86:	a8a080e7          	jalr	-1398(ra) # 560c <exit>

0000000000001b8a <createdelete>:
{
    1b8a:	7175                	addi	sp,sp,-144
    1b8c:	e506                	sd	ra,136(sp)
    1b8e:	e122                	sd	s0,128(sp)
    1b90:	fca6                	sd	s1,120(sp)
    1b92:	f8ca                	sd	s2,112(sp)
    1b94:	f4ce                	sd	s3,104(sp)
    1b96:	f0d2                	sd	s4,96(sp)
    1b98:	ecd6                	sd	s5,88(sp)
    1b9a:	e8da                	sd	s6,80(sp)
    1b9c:	e4de                	sd	s7,72(sp)
    1b9e:	e0e2                	sd	s8,64(sp)
    1ba0:	fc66                	sd	s9,56(sp)
    1ba2:	0900                	addi	s0,sp,144
    1ba4:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1ba6:	4901                	li	s2,0
    1ba8:	4991                	li	s3,4
    pid = fork();
    1baa:	00004097          	auipc	ra,0x4
    1bae:	a5a080e7          	jalr	-1446(ra) # 5604 <fork>
    1bb2:	84aa                	mv	s1,a0
    if(pid < 0){
    1bb4:	02054f63          	bltz	a0,1bf2 <createdelete+0x68>
    if(pid == 0){
    1bb8:	c939                	beqz	a0,1c0e <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1bba:	2905                	addiw	s2,s2,1
    1bbc:	ff3917e3          	bne	s2,s3,1baa <createdelete+0x20>
    1bc0:	4491                	li	s1,4
    wait(&xstatus);
    1bc2:	f7c40513          	addi	a0,s0,-132
    1bc6:	00004097          	auipc	ra,0x4
    1bca:	a4e080e7          	jalr	-1458(ra) # 5614 <wait>
    if(xstatus != 0)
    1bce:	f7c42903          	lw	s2,-132(s0)
    1bd2:	0e091263          	bnez	s2,1cb6 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1bd6:	34fd                	addiw	s1,s1,-1
    1bd8:	f4ed                	bnez	s1,1bc2 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1bda:	f8040123          	sb	zero,-126(s0)
    1bde:	03000993          	li	s3,48
    1be2:	5a7d                	li	s4,-1
    1be4:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1be8:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1bea:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1bec:	07400a93          	li	s5,116
    1bf0:	a29d                	j	1d56 <createdelete+0x1cc>
      printf("fork failed\n", s);
    1bf2:	85e6                	mv	a1,s9
    1bf4:	00005517          	auipc	a0,0x5
    1bf8:	f5c50513          	addi	a0,a0,-164 # 6b50 <longjmp_1+0xfa0>
    1bfc:	00004097          	auipc	ra,0x4
    1c00:	da0080e7          	jalr	-608(ra) # 599c <printf>
      exit(1);
    1c04:	4505                	li	a0,1
    1c06:	00004097          	auipc	ra,0x4
    1c0a:	a06080e7          	jalr	-1530(ra) # 560c <exit>
      name[0] = 'p' + pi;
    1c0e:	0709091b          	addiw	s2,s2,112
    1c12:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1c16:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1c1a:	4951                	li	s2,20
    1c1c:	a015                	j	1c40 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1c1e:	85e6                	mv	a1,s9
    1c20:	00005517          	auipc	a0,0x5
    1c24:	bc050513          	addi	a0,a0,-1088 # 67e0 <longjmp_1+0xc30>
    1c28:	00004097          	auipc	ra,0x4
    1c2c:	d74080e7          	jalr	-652(ra) # 599c <printf>
          exit(1);
    1c30:	4505                	li	a0,1
    1c32:	00004097          	auipc	ra,0x4
    1c36:	9da080e7          	jalr	-1574(ra) # 560c <exit>
      for(i = 0; i < N; i++){
    1c3a:	2485                	addiw	s1,s1,1
    1c3c:	07248863          	beq	s1,s2,1cac <createdelete+0x122>
        name[1] = '0' + i;
    1c40:	0304879b          	addiw	a5,s1,48
    1c44:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1c48:	20200593          	li	a1,514
    1c4c:	f8040513          	addi	a0,s0,-128
    1c50:	00004097          	auipc	ra,0x4
    1c54:	9fc080e7          	jalr	-1540(ra) # 564c <open>
        if(fd < 0){
    1c58:	fc0543e3          	bltz	a0,1c1e <createdelete+0x94>
        close(fd);
    1c5c:	00004097          	auipc	ra,0x4
    1c60:	9d8080e7          	jalr	-1576(ra) # 5634 <close>
        if(i > 0 && (i % 2 ) == 0){
    1c64:	fc905be3          	blez	s1,1c3a <createdelete+0xb0>
    1c68:	0014f793          	andi	a5,s1,1
    1c6c:	f7f9                	bnez	a5,1c3a <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1c6e:	01f4d79b          	srliw	a5,s1,0x1f
    1c72:	9fa5                	addw	a5,a5,s1
    1c74:	4017d79b          	sraiw	a5,a5,0x1
    1c78:	0307879b          	addiw	a5,a5,48
    1c7c:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1c80:	f8040513          	addi	a0,s0,-128
    1c84:	00004097          	auipc	ra,0x4
    1c88:	9d8080e7          	jalr	-1576(ra) # 565c <unlink>
    1c8c:	fa0557e3          	bgez	a0,1c3a <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1c90:	85e6                	mv	a1,s9
    1c92:	00005517          	auipc	a0,0x5
    1c96:	ca650513          	addi	a0,a0,-858 # 6938 <longjmp_1+0xd88>
    1c9a:	00004097          	auipc	ra,0x4
    1c9e:	d02080e7          	jalr	-766(ra) # 599c <printf>
            exit(1);
    1ca2:	4505                	li	a0,1
    1ca4:	00004097          	auipc	ra,0x4
    1ca8:	968080e7          	jalr	-1688(ra) # 560c <exit>
      exit(0);
    1cac:	4501                	li	a0,0
    1cae:	00004097          	auipc	ra,0x4
    1cb2:	95e080e7          	jalr	-1698(ra) # 560c <exit>
      exit(1);
    1cb6:	4505                	li	a0,1
    1cb8:	00004097          	auipc	ra,0x4
    1cbc:	954080e7          	jalr	-1708(ra) # 560c <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1cc0:	f8040613          	addi	a2,s0,-128
    1cc4:	85e6                	mv	a1,s9
    1cc6:	00005517          	auipc	a0,0x5
    1cca:	c8a50513          	addi	a0,a0,-886 # 6950 <longjmp_1+0xda0>
    1cce:	00004097          	auipc	ra,0x4
    1cd2:	cce080e7          	jalr	-818(ra) # 599c <printf>
        exit(1);
    1cd6:	4505                	li	a0,1
    1cd8:	00004097          	auipc	ra,0x4
    1cdc:	934080e7          	jalr	-1740(ra) # 560c <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ce0:	054b7163          	bgeu	s6,s4,1d22 <createdelete+0x198>
      if(fd >= 0)
    1ce4:	02055a63          	bgez	a0,1d18 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1ce8:	2485                	addiw	s1,s1,1
    1cea:	0ff4f493          	andi	s1,s1,255
    1cee:	05548c63          	beq	s1,s5,1d46 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1cf2:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1cf6:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1cfa:	4581                	li	a1,0
    1cfc:	f8040513          	addi	a0,s0,-128
    1d00:	00004097          	auipc	ra,0x4
    1d04:	94c080e7          	jalr	-1716(ra) # 564c <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1d08:	00090463          	beqz	s2,1d10 <createdelete+0x186>
    1d0c:	fd2bdae3          	bge	s7,s2,1ce0 <createdelete+0x156>
    1d10:	fa0548e3          	bltz	a0,1cc0 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d14:	014b7963          	bgeu	s6,s4,1d26 <createdelete+0x19c>
        close(fd);
    1d18:	00004097          	auipc	ra,0x4
    1d1c:	91c080e7          	jalr	-1764(ra) # 5634 <close>
    1d20:	b7e1                	j	1ce8 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d22:	fc0543e3          	bltz	a0,1ce8 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1d26:	f8040613          	addi	a2,s0,-128
    1d2a:	85e6                	mv	a1,s9
    1d2c:	00005517          	auipc	a0,0x5
    1d30:	c4c50513          	addi	a0,a0,-948 # 6978 <longjmp_1+0xdc8>
    1d34:	00004097          	auipc	ra,0x4
    1d38:	c68080e7          	jalr	-920(ra) # 599c <printf>
        exit(1);
    1d3c:	4505                	li	a0,1
    1d3e:	00004097          	auipc	ra,0x4
    1d42:	8ce080e7          	jalr	-1842(ra) # 560c <exit>
  for(i = 0; i < N; i++){
    1d46:	2905                	addiw	s2,s2,1
    1d48:	2a05                	addiw	s4,s4,1
    1d4a:	2985                	addiw	s3,s3,1
    1d4c:	0ff9f993          	andi	s3,s3,255
    1d50:	47d1                	li	a5,20
    1d52:	02f90a63          	beq	s2,a5,1d86 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1d56:	84e2                	mv	s1,s8
    1d58:	bf69                	j	1cf2 <createdelete+0x168>
  for(i = 0; i < N; i++){
    1d5a:	2905                	addiw	s2,s2,1
    1d5c:	0ff97913          	andi	s2,s2,255
    1d60:	2985                	addiw	s3,s3,1
    1d62:	0ff9f993          	andi	s3,s3,255
    1d66:	03490863          	beq	s2,s4,1d96 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1d6a:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1d6c:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1d70:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1d74:	f8040513          	addi	a0,s0,-128
    1d78:	00004097          	auipc	ra,0x4
    1d7c:	8e4080e7          	jalr	-1820(ra) # 565c <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1d80:	34fd                	addiw	s1,s1,-1
    1d82:	f4ed                	bnez	s1,1d6c <createdelete+0x1e2>
    1d84:	bfd9                	j	1d5a <createdelete+0x1d0>
    1d86:	03000993          	li	s3,48
    1d8a:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1d8e:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1d90:	08400a13          	li	s4,132
    1d94:	bfd9                	j	1d6a <createdelete+0x1e0>
}
    1d96:	60aa                	ld	ra,136(sp)
    1d98:	640a                	ld	s0,128(sp)
    1d9a:	74e6                	ld	s1,120(sp)
    1d9c:	7946                	ld	s2,112(sp)
    1d9e:	79a6                	ld	s3,104(sp)
    1da0:	7a06                	ld	s4,96(sp)
    1da2:	6ae6                	ld	s5,88(sp)
    1da4:	6b46                	ld	s6,80(sp)
    1da6:	6ba6                	ld	s7,72(sp)
    1da8:	6c06                	ld	s8,64(sp)
    1daa:	7ce2                	ld	s9,56(sp)
    1dac:	6149                	addi	sp,sp,144
    1dae:	8082                	ret

0000000000001db0 <linkunlink>:
{
    1db0:	711d                	addi	sp,sp,-96
    1db2:	ec86                	sd	ra,88(sp)
    1db4:	e8a2                	sd	s0,80(sp)
    1db6:	e4a6                	sd	s1,72(sp)
    1db8:	e0ca                	sd	s2,64(sp)
    1dba:	fc4e                	sd	s3,56(sp)
    1dbc:	f852                	sd	s4,48(sp)
    1dbe:	f456                	sd	s5,40(sp)
    1dc0:	f05a                	sd	s6,32(sp)
    1dc2:	ec5e                	sd	s7,24(sp)
    1dc4:	e862                	sd	s8,16(sp)
    1dc6:	e466                	sd	s9,8(sp)
    1dc8:	1080                	addi	s0,sp,96
    1dca:	84aa                	mv	s1,a0
  unlink("x");
    1dcc:	00004517          	auipc	a0,0x4
    1dd0:	1b450513          	addi	a0,a0,436 # 5f80 <longjmp_1+0x3d0>
    1dd4:	00004097          	auipc	ra,0x4
    1dd8:	888080e7          	jalr	-1912(ra) # 565c <unlink>
  pid = fork();
    1ddc:	00004097          	auipc	ra,0x4
    1de0:	828080e7          	jalr	-2008(ra) # 5604 <fork>
  if(pid < 0){
    1de4:	02054b63          	bltz	a0,1e1a <linkunlink+0x6a>
    1de8:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1dea:	4c85                	li	s9,1
    1dec:	e119                	bnez	a0,1df2 <linkunlink+0x42>
    1dee:	06100c93          	li	s9,97
    1df2:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1df6:	41c659b7          	lui	s3,0x41c65
    1dfa:	e6d9899b          	addiw	s3,s3,-403
    1dfe:	690d                	lui	s2,0x3
    1e00:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    1e04:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1e06:	4b05                	li	s6,1
      unlink("x");
    1e08:	00004a97          	auipc	s5,0x4
    1e0c:	178a8a93          	addi	s5,s5,376 # 5f80 <longjmp_1+0x3d0>
      link("cat", "x");
    1e10:	00005b97          	auipc	s7,0x5
    1e14:	b90b8b93          	addi	s7,s7,-1136 # 69a0 <longjmp_1+0xdf0>
    1e18:	a825                	j	1e50 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1e1a:	85a6                	mv	a1,s1
    1e1c:	00005517          	auipc	a0,0x5
    1e20:	92c50513          	addi	a0,a0,-1748 # 6748 <longjmp_1+0xb98>
    1e24:	00004097          	auipc	ra,0x4
    1e28:	b78080e7          	jalr	-1160(ra) # 599c <printf>
    exit(1);
    1e2c:	4505                	li	a0,1
    1e2e:	00003097          	auipc	ra,0x3
    1e32:	7de080e7          	jalr	2014(ra) # 560c <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e36:	20200593          	li	a1,514
    1e3a:	8556                	mv	a0,s5
    1e3c:	00004097          	auipc	ra,0x4
    1e40:	810080e7          	jalr	-2032(ra) # 564c <open>
    1e44:	00003097          	auipc	ra,0x3
    1e48:	7f0080e7          	jalr	2032(ra) # 5634 <close>
  for(i = 0; i < 100; i++){
    1e4c:	34fd                	addiw	s1,s1,-1
    1e4e:	c88d                	beqz	s1,1e80 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1e50:	033c87bb          	mulw	a5,s9,s3
    1e54:	012787bb          	addw	a5,a5,s2
    1e58:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1e5c:	0347f7bb          	remuw	a5,a5,s4
    1e60:	dbf9                	beqz	a5,1e36 <linkunlink+0x86>
    } else if((x % 3) == 1){
    1e62:	01678863          	beq	a5,s6,1e72 <linkunlink+0xc2>
      unlink("x");
    1e66:	8556                	mv	a0,s5
    1e68:	00003097          	auipc	ra,0x3
    1e6c:	7f4080e7          	jalr	2036(ra) # 565c <unlink>
    1e70:	bff1                	j	1e4c <linkunlink+0x9c>
      link("cat", "x");
    1e72:	85d6                	mv	a1,s5
    1e74:	855e                	mv	a0,s7
    1e76:	00003097          	auipc	ra,0x3
    1e7a:	7f6080e7          	jalr	2038(ra) # 566c <link>
    1e7e:	b7f9                	j	1e4c <linkunlink+0x9c>
  if(pid)
    1e80:	020c0463          	beqz	s8,1ea8 <linkunlink+0xf8>
    wait(0);
    1e84:	4501                	li	a0,0
    1e86:	00003097          	auipc	ra,0x3
    1e8a:	78e080e7          	jalr	1934(ra) # 5614 <wait>
}
    1e8e:	60e6                	ld	ra,88(sp)
    1e90:	6446                	ld	s0,80(sp)
    1e92:	64a6                	ld	s1,72(sp)
    1e94:	6906                	ld	s2,64(sp)
    1e96:	79e2                	ld	s3,56(sp)
    1e98:	7a42                	ld	s4,48(sp)
    1e9a:	7aa2                	ld	s5,40(sp)
    1e9c:	7b02                	ld	s6,32(sp)
    1e9e:	6be2                	ld	s7,24(sp)
    1ea0:	6c42                	ld	s8,16(sp)
    1ea2:	6ca2                	ld	s9,8(sp)
    1ea4:	6125                	addi	sp,sp,96
    1ea6:	8082                	ret
    exit(0);
    1ea8:	4501                	li	a0,0
    1eaa:	00003097          	auipc	ra,0x3
    1eae:	762080e7          	jalr	1890(ra) # 560c <exit>

0000000000001eb2 <manywrites>:
{
    1eb2:	711d                	addi	sp,sp,-96
    1eb4:	ec86                	sd	ra,88(sp)
    1eb6:	e8a2                	sd	s0,80(sp)
    1eb8:	e4a6                	sd	s1,72(sp)
    1eba:	e0ca                	sd	s2,64(sp)
    1ebc:	fc4e                	sd	s3,56(sp)
    1ebe:	f852                	sd	s4,48(sp)
    1ec0:	f456                	sd	s5,40(sp)
    1ec2:	f05a                	sd	s6,32(sp)
    1ec4:	ec5e                	sd	s7,24(sp)
    1ec6:	1080                	addi	s0,sp,96
    1ec8:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1eca:	4981                	li	s3,0
    1ecc:	4911                	li	s2,4
    int pid = fork();
    1ece:	00003097          	auipc	ra,0x3
    1ed2:	736080e7          	jalr	1846(ra) # 5604 <fork>
    1ed6:	84aa                	mv	s1,a0
    if(pid < 0){
    1ed8:	02054963          	bltz	a0,1f0a <manywrites+0x58>
    if(pid == 0){
    1edc:	c521                	beqz	a0,1f24 <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    1ede:	2985                	addiw	s3,s3,1
    1ee0:	ff2997e3          	bne	s3,s2,1ece <manywrites+0x1c>
    1ee4:	4491                	li	s1,4
    int st = 0;
    1ee6:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1eea:	fa840513          	addi	a0,s0,-88
    1eee:	00003097          	auipc	ra,0x3
    1ef2:	726080e7          	jalr	1830(ra) # 5614 <wait>
    if(st != 0)
    1ef6:	fa842503          	lw	a0,-88(s0)
    1efa:	ed6d                	bnez	a0,1ff4 <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    1efc:	34fd                	addiw	s1,s1,-1
    1efe:	f4e5                	bnez	s1,1ee6 <manywrites+0x34>
  exit(0);
    1f00:	4501                	li	a0,0
    1f02:	00003097          	auipc	ra,0x3
    1f06:	70a080e7          	jalr	1802(ra) # 560c <exit>
      printf("fork failed\n");
    1f0a:	00005517          	auipc	a0,0x5
    1f0e:	c4650513          	addi	a0,a0,-954 # 6b50 <longjmp_1+0xfa0>
    1f12:	00004097          	auipc	ra,0x4
    1f16:	a8a080e7          	jalr	-1398(ra) # 599c <printf>
      exit(1);
    1f1a:	4505                	li	a0,1
    1f1c:	00003097          	auipc	ra,0x3
    1f20:	6f0080e7          	jalr	1776(ra) # 560c <exit>
      name[0] = 'b';
    1f24:	06200793          	li	a5,98
    1f28:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1f2c:	0619879b          	addiw	a5,s3,97
    1f30:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1f34:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1f38:	fa840513          	addi	a0,s0,-88
    1f3c:	00003097          	auipc	ra,0x3
    1f40:	720080e7          	jalr	1824(ra) # 565c <unlink>
    1f44:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    1f46:	0000ab17          	auipc	s6,0xa
    1f4a:	be2b0b13          	addi	s6,s6,-1054 # bb28 <buf>
        for(int i = 0; i < ci+1; i++){
    1f4e:	8a26                	mv	s4,s1
    1f50:	0209ce63          	bltz	s3,1f8c <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    1f54:	20200593          	li	a1,514
    1f58:	fa840513          	addi	a0,s0,-88
    1f5c:	00003097          	auipc	ra,0x3
    1f60:	6f0080e7          	jalr	1776(ra) # 564c <open>
    1f64:	892a                	mv	s2,a0
          if(fd < 0){
    1f66:	04054763          	bltz	a0,1fb4 <manywrites+0x102>
          int cc = write(fd, buf, sz);
    1f6a:	660d                	lui	a2,0x3
    1f6c:	85da                	mv	a1,s6
    1f6e:	00003097          	auipc	ra,0x3
    1f72:	6be080e7          	jalr	1726(ra) # 562c <write>
          if(cc != sz){
    1f76:	678d                	lui	a5,0x3
    1f78:	04f51e63          	bne	a0,a5,1fd4 <manywrites+0x122>
          close(fd);
    1f7c:	854a                	mv	a0,s2
    1f7e:	00003097          	auipc	ra,0x3
    1f82:	6b6080e7          	jalr	1718(ra) # 5634 <close>
        for(int i = 0; i < ci+1; i++){
    1f86:	2a05                	addiw	s4,s4,1
    1f88:	fd49d6e3          	bge	s3,s4,1f54 <manywrites+0xa2>
        unlink(name);
    1f8c:	fa840513          	addi	a0,s0,-88
    1f90:	00003097          	auipc	ra,0x3
    1f94:	6cc080e7          	jalr	1740(ra) # 565c <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1f98:	3bfd                	addiw	s7,s7,-1
    1f9a:	fa0b9ae3          	bnez	s7,1f4e <manywrites+0x9c>
      unlink(name);
    1f9e:	fa840513          	addi	a0,s0,-88
    1fa2:	00003097          	auipc	ra,0x3
    1fa6:	6ba080e7          	jalr	1722(ra) # 565c <unlink>
      exit(0);
    1faa:	4501                	li	a0,0
    1fac:	00003097          	auipc	ra,0x3
    1fb0:	660080e7          	jalr	1632(ra) # 560c <exit>
            printf("%s: cannot create %s\n", s, name);
    1fb4:	fa840613          	addi	a2,s0,-88
    1fb8:	85d6                	mv	a1,s5
    1fba:	00005517          	auipc	a0,0x5
    1fbe:	9ee50513          	addi	a0,a0,-1554 # 69a8 <longjmp_1+0xdf8>
    1fc2:	00004097          	auipc	ra,0x4
    1fc6:	9da080e7          	jalr	-1574(ra) # 599c <printf>
            exit(1);
    1fca:	4505                	li	a0,1
    1fcc:	00003097          	auipc	ra,0x3
    1fd0:	640080e7          	jalr	1600(ra) # 560c <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1fd4:	86aa                	mv	a3,a0
    1fd6:	660d                	lui	a2,0x3
    1fd8:	85d6                	mv	a1,s5
    1fda:	00004517          	auipc	a0,0x4
    1fde:	ff650513          	addi	a0,a0,-10 # 5fd0 <longjmp_1+0x420>
    1fe2:	00004097          	auipc	ra,0x4
    1fe6:	9ba080e7          	jalr	-1606(ra) # 599c <printf>
            exit(1);
    1fea:	4505                	li	a0,1
    1fec:	00003097          	auipc	ra,0x3
    1ff0:	620080e7          	jalr	1568(ra) # 560c <exit>
      exit(st);
    1ff4:	00003097          	auipc	ra,0x3
    1ff8:	618080e7          	jalr	1560(ra) # 560c <exit>

0000000000001ffc <forktest>:
{
    1ffc:	7179                	addi	sp,sp,-48
    1ffe:	f406                	sd	ra,40(sp)
    2000:	f022                	sd	s0,32(sp)
    2002:	ec26                	sd	s1,24(sp)
    2004:	e84a                	sd	s2,16(sp)
    2006:	e44e                	sd	s3,8(sp)
    2008:	1800                	addi	s0,sp,48
    200a:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    200c:	4481                	li	s1,0
    200e:	3e800913          	li	s2,1000
    pid = fork();
    2012:	00003097          	auipc	ra,0x3
    2016:	5f2080e7          	jalr	1522(ra) # 5604 <fork>
    if(pid < 0)
    201a:	02054863          	bltz	a0,204a <forktest+0x4e>
    if(pid == 0)
    201e:	c115                	beqz	a0,2042 <forktest+0x46>
  for(n=0; n<N; n++){
    2020:	2485                	addiw	s1,s1,1
    2022:	ff2498e3          	bne	s1,s2,2012 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    2026:	85ce                	mv	a1,s3
    2028:	00005517          	auipc	a0,0x5
    202c:	9b050513          	addi	a0,a0,-1616 # 69d8 <longjmp_1+0xe28>
    2030:	00004097          	auipc	ra,0x4
    2034:	96c080e7          	jalr	-1684(ra) # 599c <printf>
    exit(1);
    2038:	4505                	li	a0,1
    203a:	00003097          	auipc	ra,0x3
    203e:	5d2080e7          	jalr	1490(ra) # 560c <exit>
      exit(0);
    2042:	00003097          	auipc	ra,0x3
    2046:	5ca080e7          	jalr	1482(ra) # 560c <exit>
  if (n == 0) {
    204a:	cc9d                	beqz	s1,2088 <forktest+0x8c>
  if(n == N){
    204c:	3e800793          	li	a5,1000
    2050:	fcf48be3          	beq	s1,a5,2026 <forktest+0x2a>
  for(; n > 0; n--){
    2054:	00905b63          	blez	s1,206a <forktest+0x6e>
    if(wait(0) < 0){
    2058:	4501                	li	a0,0
    205a:	00003097          	auipc	ra,0x3
    205e:	5ba080e7          	jalr	1466(ra) # 5614 <wait>
    2062:	04054163          	bltz	a0,20a4 <forktest+0xa8>
  for(; n > 0; n--){
    2066:	34fd                	addiw	s1,s1,-1
    2068:	f8e5                	bnez	s1,2058 <forktest+0x5c>
  if(wait(0) != -1){
    206a:	4501                	li	a0,0
    206c:	00003097          	auipc	ra,0x3
    2070:	5a8080e7          	jalr	1448(ra) # 5614 <wait>
    2074:	57fd                	li	a5,-1
    2076:	04f51563          	bne	a0,a5,20c0 <forktest+0xc4>
}
    207a:	70a2                	ld	ra,40(sp)
    207c:	7402                	ld	s0,32(sp)
    207e:	64e2                	ld	s1,24(sp)
    2080:	6942                	ld	s2,16(sp)
    2082:	69a2                	ld	s3,8(sp)
    2084:	6145                	addi	sp,sp,48
    2086:	8082                	ret
    printf("%s: no fork at all!\n", s);
    2088:	85ce                	mv	a1,s3
    208a:	00005517          	auipc	a0,0x5
    208e:	93650513          	addi	a0,a0,-1738 # 69c0 <longjmp_1+0xe10>
    2092:	00004097          	auipc	ra,0x4
    2096:	90a080e7          	jalr	-1782(ra) # 599c <printf>
    exit(1);
    209a:	4505                	li	a0,1
    209c:	00003097          	auipc	ra,0x3
    20a0:	570080e7          	jalr	1392(ra) # 560c <exit>
      printf("%s: wait stopped early\n", s);
    20a4:	85ce                	mv	a1,s3
    20a6:	00005517          	auipc	a0,0x5
    20aa:	95a50513          	addi	a0,a0,-1702 # 6a00 <longjmp_1+0xe50>
    20ae:	00004097          	auipc	ra,0x4
    20b2:	8ee080e7          	jalr	-1810(ra) # 599c <printf>
      exit(1);
    20b6:	4505                	li	a0,1
    20b8:	00003097          	auipc	ra,0x3
    20bc:	554080e7          	jalr	1364(ra) # 560c <exit>
    printf("%s: wait got too many\n", s);
    20c0:	85ce                	mv	a1,s3
    20c2:	00005517          	auipc	a0,0x5
    20c6:	95650513          	addi	a0,a0,-1706 # 6a18 <longjmp_1+0xe68>
    20ca:	00004097          	auipc	ra,0x4
    20ce:	8d2080e7          	jalr	-1838(ra) # 599c <printf>
    exit(1);
    20d2:	4505                	li	a0,1
    20d4:	00003097          	auipc	ra,0x3
    20d8:	538080e7          	jalr	1336(ra) # 560c <exit>

00000000000020dc <kernmem>:
{
    20dc:	715d                	addi	sp,sp,-80
    20de:	e486                	sd	ra,72(sp)
    20e0:	e0a2                	sd	s0,64(sp)
    20e2:	fc26                	sd	s1,56(sp)
    20e4:	f84a                	sd	s2,48(sp)
    20e6:	f44e                	sd	s3,40(sp)
    20e8:	f052                	sd	s4,32(sp)
    20ea:	ec56                	sd	s5,24(sp)
    20ec:	0880                	addi	s0,sp,80
    20ee:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    20f0:	4485                	li	s1,1
    20f2:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    20f4:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    20f6:	69b1                	lui	s3,0xc
    20f8:	35098993          	addi	s3,s3,848 # c350 <buf+0x828>
    20fc:	1003d937          	lui	s2,0x1003d
    2100:	090e                	slli	s2,s2,0x3
    2102:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002e948>
    pid = fork();
    2106:	00003097          	auipc	ra,0x3
    210a:	4fe080e7          	jalr	1278(ra) # 5604 <fork>
    if(pid < 0){
    210e:	02054963          	bltz	a0,2140 <kernmem+0x64>
    if(pid == 0){
    2112:	c529                	beqz	a0,215c <kernmem+0x80>
    wait(&xstatus);
    2114:	fbc40513          	addi	a0,s0,-68
    2118:	00003097          	auipc	ra,0x3
    211c:	4fc080e7          	jalr	1276(ra) # 5614 <wait>
    if(xstatus != -1)  // did kernel kill child?
    2120:	fbc42783          	lw	a5,-68(s0)
    2124:	05579d63          	bne	a5,s5,217e <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2128:	94ce                	add	s1,s1,s3
    212a:	fd249ee3          	bne	s1,s2,2106 <kernmem+0x2a>
}
    212e:	60a6                	ld	ra,72(sp)
    2130:	6406                	ld	s0,64(sp)
    2132:	74e2                	ld	s1,56(sp)
    2134:	7942                	ld	s2,48(sp)
    2136:	79a2                	ld	s3,40(sp)
    2138:	7a02                	ld	s4,32(sp)
    213a:	6ae2                	ld	s5,24(sp)
    213c:	6161                	addi	sp,sp,80
    213e:	8082                	ret
      printf("%s: fork failed\n", s);
    2140:	85d2                	mv	a1,s4
    2142:	00004517          	auipc	a0,0x4
    2146:	60650513          	addi	a0,a0,1542 # 6748 <longjmp_1+0xb98>
    214a:	00004097          	auipc	ra,0x4
    214e:	852080e7          	jalr	-1966(ra) # 599c <printf>
      exit(1);
    2152:	4505                	li	a0,1
    2154:	00003097          	auipc	ra,0x3
    2158:	4b8080e7          	jalr	1208(ra) # 560c <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    215c:	0004c683          	lbu	a3,0(s1)
    2160:	8626                	mv	a2,s1
    2162:	85d2                	mv	a1,s4
    2164:	00005517          	auipc	a0,0x5
    2168:	8cc50513          	addi	a0,a0,-1844 # 6a30 <longjmp_1+0xe80>
    216c:	00004097          	auipc	ra,0x4
    2170:	830080e7          	jalr	-2000(ra) # 599c <printf>
      exit(1);
    2174:	4505                	li	a0,1
    2176:	00003097          	auipc	ra,0x3
    217a:	496080e7          	jalr	1174(ra) # 560c <exit>
      exit(1);
    217e:	4505                	li	a0,1
    2180:	00003097          	auipc	ra,0x3
    2184:	48c080e7          	jalr	1164(ra) # 560c <exit>

0000000000002188 <bigargtest>:
{
    2188:	7179                	addi	sp,sp,-48
    218a:	f406                	sd	ra,40(sp)
    218c:	f022                	sd	s0,32(sp)
    218e:	ec26                	sd	s1,24(sp)
    2190:	1800                	addi	s0,sp,48
    2192:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    2194:	00005517          	auipc	a0,0x5
    2198:	8bc50513          	addi	a0,a0,-1860 # 6a50 <longjmp_1+0xea0>
    219c:	00003097          	auipc	ra,0x3
    21a0:	4c0080e7          	jalr	1216(ra) # 565c <unlink>
  pid = fork();
    21a4:	00003097          	auipc	ra,0x3
    21a8:	460080e7          	jalr	1120(ra) # 5604 <fork>
  if(pid == 0){
    21ac:	c121                	beqz	a0,21ec <bigargtest+0x64>
  } else if(pid < 0){
    21ae:	0a054063          	bltz	a0,224e <bigargtest+0xc6>
  wait(&xstatus);
    21b2:	fdc40513          	addi	a0,s0,-36
    21b6:	00003097          	auipc	ra,0x3
    21ba:	45e080e7          	jalr	1118(ra) # 5614 <wait>
  if(xstatus != 0)
    21be:	fdc42503          	lw	a0,-36(s0)
    21c2:	e545                	bnez	a0,226a <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    21c4:	4581                	li	a1,0
    21c6:	00005517          	auipc	a0,0x5
    21ca:	88a50513          	addi	a0,a0,-1910 # 6a50 <longjmp_1+0xea0>
    21ce:	00003097          	auipc	ra,0x3
    21d2:	47e080e7          	jalr	1150(ra) # 564c <open>
  if(fd < 0){
    21d6:	08054e63          	bltz	a0,2272 <bigargtest+0xea>
  close(fd);
    21da:	00003097          	auipc	ra,0x3
    21de:	45a080e7          	jalr	1114(ra) # 5634 <close>
}
    21e2:	70a2                	ld	ra,40(sp)
    21e4:	7402                	ld	s0,32(sp)
    21e6:	64e2                	ld	s1,24(sp)
    21e8:	6145                	addi	sp,sp,48
    21ea:	8082                	ret
    21ec:	00006797          	auipc	a5,0x6
    21f0:	12478793          	addi	a5,a5,292 # 8310 <args.1>
    21f4:	00006697          	auipc	a3,0x6
    21f8:	21468693          	addi	a3,a3,532 # 8408 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    21fc:	00005717          	auipc	a4,0x5
    2200:	86470713          	addi	a4,a4,-1948 # 6a60 <longjmp_1+0xeb0>
    2204:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    2206:	07a1                	addi	a5,a5,8
    2208:	fed79ee3          	bne	a5,a3,2204 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    220c:	00006597          	auipc	a1,0x6
    2210:	10458593          	addi	a1,a1,260 # 8310 <args.1>
    2214:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2218:	00004517          	auipc	a0,0x4
    221c:	cf850513          	addi	a0,a0,-776 # 5f10 <longjmp_1+0x360>
    2220:	00003097          	auipc	ra,0x3
    2224:	424080e7          	jalr	1060(ra) # 5644 <exec>
    fd = open("bigarg-ok", O_CREATE);
    2228:	20000593          	li	a1,512
    222c:	00005517          	auipc	a0,0x5
    2230:	82450513          	addi	a0,a0,-2012 # 6a50 <longjmp_1+0xea0>
    2234:	00003097          	auipc	ra,0x3
    2238:	418080e7          	jalr	1048(ra) # 564c <open>
    close(fd);
    223c:	00003097          	auipc	ra,0x3
    2240:	3f8080e7          	jalr	1016(ra) # 5634 <close>
    exit(0);
    2244:	4501                	li	a0,0
    2246:	00003097          	auipc	ra,0x3
    224a:	3c6080e7          	jalr	966(ra) # 560c <exit>
    printf("%s: bigargtest: fork failed\n", s);
    224e:	85a6                	mv	a1,s1
    2250:	00005517          	auipc	a0,0x5
    2254:	8f050513          	addi	a0,a0,-1808 # 6b40 <longjmp_1+0xf90>
    2258:	00003097          	auipc	ra,0x3
    225c:	744080e7          	jalr	1860(ra) # 599c <printf>
    exit(1);
    2260:	4505                	li	a0,1
    2262:	00003097          	auipc	ra,0x3
    2266:	3aa080e7          	jalr	938(ra) # 560c <exit>
    exit(xstatus);
    226a:	00003097          	auipc	ra,0x3
    226e:	3a2080e7          	jalr	930(ra) # 560c <exit>
    printf("%s: bigarg test failed!\n", s);
    2272:	85a6                	mv	a1,s1
    2274:	00005517          	auipc	a0,0x5
    2278:	8ec50513          	addi	a0,a0,-1812 # 6b60 <longjmp_1+0xfb0>
    227c:	00003097          	auipc	ra,0x3
    2280:	720080e7          	jalr	1824(ra) # 599c <printf>
    exit(1);
    2284:	4505                	li	a0,1
    2286:	00003097          	auipc	ra,0x3
    228a:	386080e7          	jalr	902(ra) # 560c <exit>

000000000000228e <stacktest>:
{
    228e:	7179                	addi	sp,sp,-48
    2290:	f406                	sd	ra,40(sp)
    2292:	f022                	sd	s0,32(sp)
    2294:	ec26                	sd	s1,24(sp)
    2296:	1800                	addi	s0,sp,48
    2298:	84aa                	mv	s1,a0
  pid = fork();
    229a:	00003097          	auipc	ra,0x3
    229e:	36a080e7          	jalr	874(ra) # 5604 <fork>
  if(pid == 0) {
    22a2:	c115                	beqz	a0,22c6 <stacktest+0x38>
  } else if(pid < 0){
    22a4:	04054463          	bltz	a0,22ec <stacktest+0x5e>
  wait(&xstatus);
    22a8:	fdc40513          	addi	a0,s0,-36
    22ac:	00003097          	auipc	ra,0x3
    22b0:	368080e7          	jalr	872(ra) # 5614 <wait>
  if(xstatus == -1)  // kernel killed child?
    22b4:	fdc42503          	lw	a0,-36(s0)
    22b8:	57fd                	li	a5,-1
    22ba:	04f50763          	beq	a0,a5,2308 <stacktest+0x7a>
    exit(xstatus);
    22be:	00003097          	auipc	ra,0x3
    22c2:	34e080e7          	jalr	846(ra) # 560c <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    22c6:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    22c8:	77fd                	lui	a5,0xfffff
    22ca:	97ba                	add	a5,a5,a4
    22cc:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff04c8>
    22d0:	85a6                	mv	a1,s1
    22d2:	00005517          	auipc	a0,0x5
    22d6:	8ae50513          	addi	a0,a0,-1874 # 6b80 <longjmp_1+0xfd0>
    22da:	00003097          	auipc	ra,0x3
    22de:	6c2080e7          	jalr	1730(ra) # 599c <printf>
    exit(1);
    22e2:	4505                	li	a0,1
    22e4:	00003097          	auipc	ra,0x3
    22e8:	328080e7          	jalr	808(ra) # 560c <exit>
    printf("%s: fork failed\n", s);
    22ec:	85a6                	mv	a1,s1
    22ee:	00004517          	auipc	a0,0x4
    22f2:	45a50513          	addi	a0,a0,1114 # 6748 <longjmp_1+0xb98>
    22f6:	00003097          	auipc	ra,0x3
    22fa:	6a6080e7          	jalr	1702(ra) # 599c <printf>
    exit(1);
    22fe:	4505                	li	a0,1
    2300:	00003097          	auipc	ra,0x3
    2304:	30c080e7          	jalr	780(ra) # 560c <exit>
    exit(0);
    2308:	4501                	li	a0,0
    230a:	00003097          	auipc	ra,0x3
    230e:	302080e7          	jalr	770(ra) # 560c <exit>

0000000000002312 <copyinstr3>:
{
    2312:	7179                	addi	sp,sp,-48
    2314:	f406                	sd	ra,40(sp)
    2316:	f022                	sd	s0,32(sp)
    2318:	ec26                	sd	s1,24(sp)
    231a:	1800                	addi	s0,sp,48
  sbrk(8192);
    231c:	6509                	lui	a0,0x2
    231e:	00003097          	auipc	ra,0x3
    2322:	376080e7          	jalr	886(ra) # 5694 <sbrk>
  uint64 top = (uint64) sbrk(0);
    2326:	4501                	li	a0,0
    2328:	00003097          	auipc	ra,0x3
    232c:	36c080e7          	jalr	876(ra) # 5694 <sbrk>
  if((top % PGSIZE) != 0){
    2330:	03451793          	slli	a5,a0,0x34
    2334:	e3c9                	bnez	a5,23b6 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    2336:	4501                	li	a0,0
    2338:	00003097          	auipc	ra,0x3
    233c:	35c080e7          	jalr	860(ra) # 5694 <sbrk>
  if(top % PGSIZE){
    2340:	03451793          	slli	a5,a0,0x34
    2344:	e3d9                	bnez	a5,23ca <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2346:	fff50493          	addi	s1,a0,-1 # 1fff <forktest+0x3>
  *b = 'x';
    234a:	07800793          	li	a5,120
    234e:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2352:	8526                	mv	a0,s1
    2354:	00003097          	auipc	ra,0x3
    2358:	308080e7          	jalr	776(ra) # 565c <unlink>
  if(ret != -1){
    235c:	57fd                	li	a5,-1
    235e:	08f51363          	bne	a0,a5,23e4 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2362:	20100593          	li	a1,513
    2366:	8526                	mv	a0,s1
    2368:	00003097          	auipc	ra,0x3
    236c:	2e4080e7          	jalr	740(ra) # 564c <open>
  if(fd != -1){
    2370:	57fd                	li	a5,-1
    2372:	08f51863          	bne	a0,a5,2402 <copyinstr3+0xf0>
  ret = link(b, b);
    2376:	85a6                	mv	a1,s1
    2378:	8526                	mv	a0,s1
    237a:	00003097          	auipc	ra,0x3
    237e:	2f2080e7          	jalr	754(ra) # 566c <link>
  if(ret != -1){
    2382:	57fd                	li	a5,-1
    2384:	08f51e63          	bne	a0,a5,2420 <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    2388:	00005797          	auipc	a5,0x5
    238c:	49078793          	addi	a5,a5,1168 # 7818 <longjmp_1+0x1c68>
    2390:	fcf43823          	sd	a5,-48(s0)
    2394:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2398:	fd040593          	addi	a1,s0,-48
    239c:	8526                	mv	a0,s1
    239e:	00003097          	auipc	ra,0x3
    23a2:	2a6080e7          	jalr	678(ra) # 5644 <exec>
  if(ret != -1){
    23a6:	57fd                	li	a5,-1
    23a8:	08f51c63          	bne	a0,a5,2440 <copyinstr3+0x12e>
}
    23ac:	70a2                	ld	ra,40(sp)
    23ae:	7402                	ld	s0,32(sp)
    23b0:	64e2                	ld	s1,24(sp)
    23b2:	6145                	addi	sp,sp,48
    23b4:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    23b6:	0347d513          	srli	a0,a5,0x34
    23ba:	6785                	lui	a5,0x1
    23bc:	40a7853b          	subw	a0,a5,a0
    23c0:	00003097          	auipc	ra,0x3
    23c4:	2d4080e7          	jalr	724(ra) # 5694 <sbrk>
    23c8:	b7bd                	j	2336 <copyinstr3+0x24>
    printf("oops\n");
    23ca:	00004517          	auipc	a0,0x4
    23ce:	7de50513          	addi	a0,a0,2014 # 6ba8 <longjmp_1+0xff8>
    23d2:	00003097          	auipc	ra,0x3
    23d6:	5ca080e7          	jalr	1482(ra) # 599c <printf>
    exit(1);
    23da:	4505                	li	a0,1
    23dc:	00003097          	auipc	ra,0x3
    23e0:	230080e7          	jalr	560(ra) # 560c <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    23e4:	862a                	mv	a2,a0
    23e6:	85a6                	mv	a1,s1
    23e8:	00004517          	auipc	a0,0x4
    23ec:	28050513          	addi	a0,a0,640 # 6668 <longjmp_1+0xab8>
    23f0:	00003097          	auipc	ra,0x3
    23f4:	5ac080e7          	jalr	1452(ra) # 599c <printf>
    exit(1);
    23f8:	4505                	li	a0,1
    23fa:	00003097          	auipc	ra,0x3
    23fe:	212080e7          	jalr	530(ra) # 560c <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2402:	862a                	mv	a2,a0
    2404:	85a6                	mv	a1,s1
    2406:	00004517          	auipc	a0,0x4
    240a:	28250513          	addi	a0,a0,642 # 6688 <longjmp_1+0xad8>
    240e:	00003097          	auipc	ra,0x3
    2412:	58e080e7          	jalr	1422(ra) # 599c <printf>
    exit(1);
    2416:	4505                	li	a0,1
    2418:	00003097          	auipc	ra,0x3
    241c:	1f4080e7          	jalr	500(ra) # 560c <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    2420:	86aa                	mv	a3,a0
    2422:	8626                	mv	a2,s1
    2424:	85a6                	mv	a1,s1
    2426:	00004517          	auipc	a0,0x4
    242a:	28250513          	addi	a0,a0,642 # 66a8 <longjmp_1+0xaf8>
    242e:	00003097          	auipc	ra,0x3
    2432:	56e080e7          	jalr	1390(ra) # 599c <printf>
    exit(1);
    2436:	4505                	li	a0,1
    2438:	00003097          	auipc	ra,0x3
    243c:	1d4080e7          	jalr	468(ra) # 560c <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2440:	567d                	li	a2,-1
    2442:	85a6                	mv	a1,s1
    2444:	00004517          	auipc	a0,0x4
    2448:	28c50513          	addi	a0,a0,652 # 66d0 <longjmp_1+0xb20>
    244c:	00003097          	auipc	ra,0x3
    2450:	550080e7          	jalr	1360(ra) # 599c <printf>
    exit(1);
    2454:	4505                	li	a0,1
    2456:	00003097          	auipc	ra,0x3
    245a:	1b6080e7          	jalr	438(ra) # 560c <exit>

000000000000245e <rwsbrk>:
{
    245e:	1101                	addi	sp,sp,-32
    2460:	ec06                	sd	ra,24(sp)
    2462:	e822                	sd	s0,16(sp)
    2464:	e426                	sd	s1,8(sp)
    2466:	e04a                	sd	s2,0(sp)
    2468:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    246a:	6509                	lui	a0,0x2
    246c:	00003097          	auipc	ra,0x3
    2470:	228080e7          	jalr	552(ra) # 5694 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    2474:	57fd                	li	a5,-1
    2476:	06f50363          	beq	a0,a5,24dc <rwsbrk+0x7e>
    247a:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    247c:	7579                	lui	a0,0xffffe
    247e:	00003097          	auipc	ra,0x3
    2482:	216080e7          	jalr	534(ra) # 5694 <sbrk>
    2486:	57fd                	li	a5,-1
    2488:	06f50763          	beq	a0,a5,24f6 <rwsbrk+0x98>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    248c:	20100593          	li	a1,513
    2490:	00003517          	auipc	a0,0x3
    2494:	7a050513          	addi	a0,a0,1952 # 5c30 <longjmp_1+0x80>
    2498:	00003097          	auipc	ra,0x3
    249c:	1b4080e7          	jalr	436(ra) # 564c <open>
    24a0:	892a                	mv	s2,a0
  if(fd < 0){
    24a2:	06054763          	bltz	a0,2510 <rwsbrk+0xb2>
  n = write(fd, (void*)(a+4096), 1024);
    24a6:	6505                	lui	a0,0x1
    24a8:	94aa                	add	s1,s1,a0
    24aa:	40000613          	li	a2,1024
    24ae:	85a6                	mv	a1,s1
    24b0:	854a                	mv	a0,s2
    24b2:	00003097          	auipc	ra,0x3
    24b6:	17a080e7          	jalr	378(ra) # 562c <write>
    24ba:	862a                	mv	a2,a0
  if(n >= 0){
    24bc:	06054763          	bltz	a0,252a <rwsbrk+0xcc>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    24c0:	85a6                	mv	a1,s1
    24c2:	00004517          	auipc	a0,0x4
    24c6:	73e50513          	addi	a0,a0,1854 # 6c00 <longjmp_1+0x1050>
    24ca:	00003097          	auipc	ra,0x3
    24ce:	4d2080e7          	jalr	1234(ra) # 599c <printf>
    exit(1);
    24d2:	4505                	li	a0,1
    24d4:	00003097          	auipc	ra,0x3
    24d8:	138080e7          	jalr	312(ra) # 560c <exit>
    printf("sbrk(rwsbrk) failed\n");
    24dc:	00004517          	auipc	a0,0x4
    24e0:	6d450513          	addi	a0,a0,1748 # 6bb0 <longjmp_1+0x1000>
    24e4:	00003097          	auipc	ra,0x3
    24e8:	4b8080e7          	jalr	1208(ra) # 599c <printf>
    exit(1);
    24ec:	4505                	li	a0,1
    24ee:	00003097          	auipc	ra,0x3
    24f2:	11e080e7          	jalr	286(ra) # 560c <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    24f6:	00004517          	auipc	a0,0x4
    24fa:	6d250513          	addi	a0,a0,1746 # 6bc8 <longjmp_1+0x1018>
    24fe:	00003097          	auipc	ra,0x3
    2502:	49e080e7          	jalr	1182(ra) # 599c <printf>
    exit(1);
    2506:	4505                	li	a0,1
    2508:	00003097          	auipc	ra,0x3
    250c:	104080e7          	jalr	260(ra) # 560c <exit>
    printf("open(rwsbrk) failed\n");
    2510:	00004517          	auipc	a0,0x4
    2514:	6d850513          	addi	a0,a0,1752 # 6be8 <longjmp_1+0x1038>
    2518:	00003097          	auipc	ra,0x3
    251c:	484080e7          	jalr	1156(ra) # 599c <printf>
    exit(1);
    2520:	4505                	li	a0,1
    2522:	00003097          	auipc	ra,0x3
    2526:	0ea080e7          	jalr	234(ra) # 560c <exit>
  close(fd);
    252a:	854a                	mv	a0,s2
    252c:	00003097          	auipc	ra,0x3
    2530:	108080e7          	jalr	264(ra) # 5634 <close>
  unlink("rwsbrk");
    2534:	00003517          	auipc	a0,0x3
    2538:	6fc50513          	addi	a0,a0,1788 # 5c30 <longjmp_1+0x80>
    253c:	00003097          	auipc	ra,0x3
    2540:	120080e7          	jalr	288(ra) # 565c <unlink>
  fd = open("README", O_RDONLY);
    2544:	4581                	li	a1,0
    2546:	00004517          	auipc	a0,0x4
    254a:	b6250513          	addi	a0,a0,-1182 # 60a8 <longjmp_1+0x4f8>
    254e:	00003097          	auipc	ra,0x3
    2552:	0fe080e7          	jalr	254(ra) # 564c <open>
    2556:	892a                	mv	s2,a0
  if(fd < 0){
    2558:	02054963          	bltz	a0,258a <rwsbrk+0x12c>
  n = read(fd, (void*)(a+4096), 10);
    255c:	4629                	li	a2,10
    255e:	85a6                	mv	a1,s1
    2560:	00003097          	auipc	ra,0x3
    2564:	0c4080e7          	jalr	196(ra) # 5624 <read>
    2568:	862a                	mv	a2,a0
  if(n >= 0){
    256a:	02054d63          	bltz	a0,25a4 <rwsbrk+0x146>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    256e:	85a6                	mv	a1,s1
    2570:	00004517          	auipc	a0,0x4
    2574:	6c050513          	addi	a0,a0,1728 # 6c30 <longjmp_1+0x1080>
    2578:	00003097          	auipc	ra,0x3
    257c:	424080e7          	jalr	1060(ra) # 599c <printf>
    exit(1);
    2580:	4505                	li	a0,1
    2582:	00003097          	auipc	ra,0x3
    2586:	08a080e7          	jalr	138(ra) # 560c <exit>
    printf("open(rwsbrk) failed\n");
    258a:	00004517          	auipc	a0,0x4
    258e:	65e50513          	addi	a0,a0,1630 # 6be8 <longjmp_1+0x1038>
    2592:	00003097          	auipc	ra,0x3
    2596:	40a080e7          	jalr	1034(ra) # 599c <printf>
    exit(1);
    259a:	4505                	li	a0,1
    259c:	00003097          	auipc	ra,0x3
    25a0:	070080e7          	jalr	112(ra) # 560c <exit>
  close(fd);
    25a4:	854a                	mv	a0,s2
    25a6:	00003097          	auipc	ra,0x3
    25aa:	08e080e7          	jalr	142(ra) # 5634 <close>
  exit(0);
    25ae:	4501                	li	a0,0
    25b0:	00003097          	auipc	ra,0x3
    25b4:	05c080e7          	jalr	92(ra) # 560c <exit>

00000000000025b8 <sbrkbasic>:
{
    25b8:	7139                	addi	sp,sp,-64
    25ba:	fc06                	sd	ra,56(sp)
    25bc:	f822                	sd	s0,48(sp)
    25be:	f426                	sd	s1,40(sp)
    25c0:	f04a                	sd	s2,32(sp)
    25c2:	ec4e                	sd	s3,24(sp)
    25c4:	e852                	sd	s4,16(sp)
    25c6:	0080                	addi	s0,sp,64
    25c8:	8a2a                	mv	s4,a0
  pid = fork();
    25ca:	00003097          	auipc	ra,0x3
    25ce:	03a080e7          	jalr	58(ra) # 5604 <fork>
  if(pid < 0){
    25d2:	02054c63          	bltz	a0,260a <sbrkbasic+0x52>
  if(pid == 0){
    25d6:	ed21                	bnez	a0,262e <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    25d8:	40000537          	lui	a0,0x40000
    25dc:	00003097          	auipc	ra,0x3
    25e0:	0b8080e7          	jalr	184(ra) # 5694 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    25e4:	57fd                	li	a5,-1
    25e6:	02f50f63          	beq	a0,a5,2624 <sbrkbasic+0x6c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    25ea:	400007b7          	lui	a5,0x40000
    25ee:	97aa                	add	a5,a5,a0
      *b = 99;
    25f0:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    25f4:	6705                	lui	a4,0x1
      *b = 99;
    25f6:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff14c8>
    for(b = a; b < a+TOOMUCH; b += 4096){
    25fa:	953a                	add	a0,a0,a4
    25fc:	fef51de3          	bne	a0,a5,25f6 <sbrkbasic+0x3e>
    exit(1);
    2600:	4505                	li	a0,1
    2602:	00003097          	auipc	ra,0x3
    2606:	00a080e7          	jalr	10(ra) # 560c <exit>
    printf("fork failed in sbrkbasic\n");
    260a:	00004517          	auipc	a0,0x4
    260e:	64e50513          	addi	a0,a0,1614 # 6c58 <longjmp_1+0x10a8>
    2612:	00003097          	auipc	ra,0x3
    2616:	38a080e7          	jalr	906(ra) # 599c <printf>
    exit(1);
    261a:	4505                	li	a0,1
    261c:	00003097          	auipc	ra,0x3
    2620:	ff0080e7          	jalr	-16(ra) # 560c <exit>
      exit(0);
    2624:	4501                	li	a0,0
    2626:	00003097          	auipc	ra,0x3
    262a:	fe6080e7          	jalr	-26(ra) # 560c <exit>
  wait(&xstatus);
    262e:	fcc40513          	addi	a0,s0,-52
    2632:	00003097          	auipc	ra,0x3
    2636:	fe2080e7          	jalr	-30(ra) # 5614 <wait>
  if(xstatus == 1){
    263a:	fcc42703          	lw	a4,-52(s0)
    263e:	4785                	li	a5,1
    2640:	00f70d63          	beq	a4,a5,265a <sbrkbasic+0xa2>
  a = sbrk(0);
    2644:	4501                	li	a0,0
    2646:	00003097          	auipc	ra,0x3
    264a:	04e080e7          	jalr	78(ra) # 5694 <sbrk>
    264e:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2650:	4901                	li	s2,0
    2652:	6985                	lui	s3,0x1
    2654:	38898993          	addi	s3,s3,904 # 1388 <copyinstr2+0x1d6>
    2658:	a005                	j	2678 <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    265a:	85d2                	mv	a1,s4
    265c:	00004517          	auipc	a0,0x4
    2660:	61c50513          	addi	a0,a0,1564 # 6c78 <longjmp_1+0x10c8>
    2664:	00003097          	auipc	ra,0x3
    2668:	338080e7          	jalr	824(ra) # 599c <printf>
    exit(1);
    266c:	4505                	li	a0,1
    266e:	00003097          	auipc	ra,0x3
    2672:	f9e080e7          	jalr	-98(ra) # 560c <exit>
    a = b + 1;
    2676:	84be                	mv	s1,a5
    b = sbrk(1);
    2678:	4505                	li	a0,1
    267a:	00003097          	auipc	ra,0x3
    267e:	01a080e7          	jalr	26(ra) # 5694 <sbrk>
    if(b != a){
    2682:	04951c63          	bne	a0,s1,26da <sbrkbasic+0x122>
    *b = 1;
    2686:	4785                	li	a5,1
    2688:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    268c:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2690:	2905                	addiw	s2,s2,1
    2692:	ff3912e3          	bne	s2,s3,2676 <sbrkbasic+0xbe>
  pid = fork();
    2696:	00003097          	auipc	ra,0x3
    269a:	f6e080e7          	jalr	-146(ra) # 5604 <fork>
    269e:	892a                	mv	s2,a0
  if(pid < 0){
    26a0:	04054d63          	bltz	a0,26fa <sbrkbasic+0x142>
  c = sbrk(1);
    26a4:	4505                	li	a0,1
    26a6:	00003097          	auipc	ra,0x3
    26aa:	fee080e7          	jalr	-18(ra) # 5694 <sbrk>
  c = sbrk(1);
    26ae:	4505                	li	a0,1
    26b0:	00003097          	auipc	ra,0x3
    26b4:	fe4080e7          	jalr	-28(ra) # 5694 <sbrk>
  if(c != a + 1){
    26b8:	0489                	addi	s1,s1,2
    26ba:	04a48e63          	beq	s1,a0,2716 <sbrkbasic+0x15e>
    printf("%s: sbrk test failed post-fork\n", s);
    26be:	85d2                	mv	a1,s4
    26c0:	00004517          	auipc	a0,0x4
    26c4:	61850513          	addi	a0,a0,1560 # 6cd8 <longjmp_1+0x1128>
    26c8:	00003097          	auipc	ra,0x3
    26cc:	2d4080e7          	jalr	724(ra) # 599c <printf>
    exit(1);
    26d0:	4505                	li	a0,1
    26d2:	00003097          	auipc	ra,0x3
    26d6:	f3a080e7          	jalr	-198(ra) # 560c <exit>
      printf("%s: sbrk test failed %d %x %x\n", i, a, b);
    26da:	86aa                	mv	a3,a0
    26dc:	8626                	mv	a2,s1
    26de:	85ca                	mv	a1,s2
    26e0:	00004517          	auipc	a0,0x4
    26e4:	5b850513          	addi	a0,a0,1464 # 6c98 <longjmp_1+0x10e8>
    26e8:	00003097          	auipc	ra,0x3
    26ec:	2b4080e7          	jalr	692(ra) # 599c <printf>
      exit(1);
    26f0:	4505                	li	a0,1
    26f2:	00003097          	auipc	ra,0x3
    26f6:	f1a080e7          	jalr	-230(ra) # 560c <exit>
    printf("%s: sbrk test fork failed\n", s);
    26fa:	85d2                	mv	a1,s4
    26fc:	00004517          	auipc	a0,0x4
    2700:	5bc50513          	addi	a0,a0,1468 # 6cb8 <longjmp_1+0x1108>
    2704:	00003097          	auipc	ra,0x3
    2708:	298080e7          	jalr	664(ra) # 599c <printf>
    exit(1);
    270c:	4505                	li	a0,1
    270e:	00003097          	auipc	ra,0x3
    2712:	efe080e7          	jalr	-258(ra) # 560c <exit>
  if(pid == 0)
    2716:	00091763          	bnez	s2,2724 <sbrkbasic+0x16c>
    exit(0);
    271a:	4501                	li	a0,0
    271c:	00003097          	auipc	ra,0x3
    2720:	ef0080e7          	jalr	-272(ra) # 560c <exit>
  wait(&xstatus);
    2724:	fcc40513          	addi	a0,s0,-52
    2728:	00003097          	auipc	ra,0x3
    272c:	eec080e7          	jalr	-276(ra) # 5614 <wait>
  exit(xstatus);
    2730:	fcc42503          	lw	a0,-52(s0)
    2734:	00003097          	auipc	ra,0x3
    2738:	ed8080e7          	jalr	-296(ra) # 560c <exit>

000000000000273c <sbrkmuch>:
{
    273c:	7179                	addi	sp,sp,-48
    273e:	f406                	sd	ra,40(sp)
    2740:	f022                	sd	s0,32(sp)
    2742:	ec26                	sd	s1,24(sp)
    2744:	e84a                	sd	s2,16(sp)
    2746:	e44e                	sd	s3,8(sp)
    2748:	e052                	sd	s4,0(sp)
    274a:	1800                	addi	s0,sp,48
    274c:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    274e:	4501                	li	a0,0
    2750:	00003097          	auipc	ra,0x3
    2754:	f44080e7          	jalr	-188(ra) # 5694 <sbrk>
    2758:	892a                	mv	s2,a0
  a = sbrk(0);
    275a:	4501                	li	a0,0
    275c:	00003097          	auipc	ra,0x3
    2760:	f38080e7          	jalr	-200(ra) # 5694 <sbrk>
    2764:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2766:	06400537          	lui	a0,0x6400
    276a:	9d05                	subw	a0,a0,s1
    276c:	00003097          	auipc	ra,0x3
    2770:	f28080e7          	jalr	-216(ra) # 5694 <sbrk>
  if (p != a) {
    2774:	0ca49863          	bne	s1,a0,2844 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2778:	4501                	li	a0,0
    277a:	00003097          	auipc	ra,0x3
    277e:	f1a080e7          	jalr	-230(ra) # 5694 <sbrk>
    2782:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2784:	00a4f963          	bgeu	s1,a0,2796 <sbrkmuch+0x5a>
    *pp = 1;
    2788:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    278a:	6705                	lui	a4,0x1
    *pp = 1;
    278c:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2790:	94ba                	add	s1,s1,a4
    2792:	fef4ede3          	bltu	s1,a5,278c <sbrkmuch+0x50>
  *lastaddr = 99;
    2796:	064007b7          	lui	a5,0x6400
    279a:	06300713          	li	a4,99
    279e:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f14c7>
  a = sbrk(0);
    27a2:	4501                	li	a0,0
    27a4:	00003097          	auipc	ra,0x3
    27a8:	ef0080e7          	jalr	-272(ra) # 5694 <sbrk>
    27ac:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    27ae:	757d                	lui	a0,0xfffff
    27b0:	00003097          	auipc	ra,0x3
    27b4:	ee4080e7          	jalr	-284(ra) # 5694 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    27b8:	57fd                	li	a5,-1
    27ba:	0af50363          	beq	a0,a5,2860 <sbrkmuch+0x124>
  c = sbrk(0);
    27be:	4501                	li	a0,0
    27c0:	00003097          	auipc	ra,0x3
    27c4:	ed4080e7          	jalr	-300(ra) # 5694 <sbrk>
  if(c != a - PGSIZE){
    27c8:	77fd                	lui	a5,0xfffff
    27ca:	97a6                	add	a5,a5,s1
    27cc:	0af51863          	bne	a0,a5,287c <sbrkmuch+0x140>
  a = sbrk(0);
    27d0:	4501                	li	a0,0
    27d2:	00003097          	auipc	ra,0x3
    27d6:	ec2080e7          	jalr	-318(ra) # 5694 <sbrk>
    27da:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    27dc:	6505                	lui	a0,0x1
    27de:	00003097          	auipc	ra,0x3
    27e2:	eb6080e7          	jalr	-330(ra) # 5694 <sbrk>
    27e6:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    27e8:	0aa49a63          	bne	s1,a0,289c <sbrkmuch+0x160>
    27ec:	4501                	li	a0,0
    27ee:	00003097          	auipc	ra,0x3
    27f2:	ea6080e7          	jalr	-346(ra) # 5694 <sbrk>
    27f6:	6785                	lui	a5,0x1
    27f8:	97a6                	add	a5,a5,s1
    27fa:	0af51163          	bne	a0,a5,289c <sbrkmuch+0x160>
  if(*lastaddr == 99){
    27fe:	064007b7          	lui	a5,0x6400
    2802:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f14c7>
    2806:	06300793          	li	a5,99
    280a:	0af70963          	beq	a4,a5,28bc <sbrkmuch+0x180>
  a = sbrk(0);
    280e:	4501                	li	a0,0
    2810:	00003097          	auipc	ra,0x3
    2814:	e84080e7          	jalr	-380(ra) # 5694 <sbrk>
    2818:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    281a:	4501                	li	a0,0
    281c:	00003097          	auipc	ra,0x3
    2820:	e78080e7          	jalr	-392(ra) # 5694 <sbrk>
    2824:	40a9053b          	subw	a0,s2,a0
    2828:	00003097          	auipc	ra,0x3
    282c:	e6c080e7          	jalr	-404(ra) # 5694 <sbrk>
  if(c != a){
    2830:	0aa49463          	bne	s1,a0,28d8 <sbrkmuch+0x19c>
}
    2834:	70a2                	ld	ra,40(sp)
    2836:	7402                	ld	s0,32(sp)
    2838:	64e2                	ld	s1,24(sp)
    283a:	6942                	ld	s2,16(sp)
    283c:	69a2                	ld	s3,8(sp)
    283e:	6a02                	ld	s4,0(sp)
    2840:	6145                	addi	sp,sp,48
    2842:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2844:	85ce                	mv	a1,s3
    2846:	00004517          	auipc	a0,0x4
    284a:	4b250513          	addi	a0,a0,1202 # 6cf8 <longjmp_1+0x1148>
    284e:	00003097          	auipc	ra,0x3
    2852:	14e080e7          	jalr	334(ra) # 599c <printf>
    exit(1);
    2856:	4505                	li	a0,1
    2858:	00003097          	auipc	ra,0x3
    285c:	db4080e7          	jalr	-588(ra) # 560c <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2860:	85ce                	mv	a1,s3
    2862:	00004517          	auipc	a0,0x4
    2866:	4de50513          	addi	a0,a0,1246 # 6d40 <longjmp_1+0x1190>
    286a:	00003097          	auipc	ra,0x3
    286e:	132080e7          	jalr	306(ra) # 599c <printf>
    exit(1);
    2872:	4505                	li	a0,1
    2874:	00003097          	auipc	ra,0x3
    2878:	d98080e7          	jalr	-616(ra) # 560c <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    287c:	86aa                	mv	a3,a0
    287e:	8626                	mv	a2,s1
    2880:	85ce                	mv	a1,s3
    2882:	00004517          	auipc	a0,0x4
    2886:	4de50513          	addi	a0,a0,1246 # 6d60 <longjmp_1+0x11b0>
    288a:	00003097          	auipc	ra,0x3
    288e:	112080e7          	jalr	274(ra) # 599c <printf>
    exit(1);
    2892:	4505                	li	a0,1
    2894:	00003097          	auipc	ra,0x3
    2898:	d78080e7          	jalr	-648(ra) # 560c <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    289c:	86d2                	mv	a3,s4
    289e:	8626                	mv	a2,s1
    28a0:	85ce                	mv	a1,s3
    28a2:	00004517          	auipc	a0,0x4
    28a6:	4fe50513          	addi	a0,a0,1278 # 6da0 <longjmp_1+0x11f0>
    28aa:	00003097          	auipc	ra,0x3
    28ae:	0f2080e7          	jalr	242(ra) # 599c <printf>
    exit(1);
    28b2:	4505                	li	a0,1
    28b4:	00003097          	auipc	ra,0x3
    28b8:	d58080e7          	jalr	-680(ra) # 560c <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    28bc:	85ce                	mv	a1,s3
    28be:	00004517          	auipc	a0,0x4
    28c2:	51250513          	addi	a0,a0,1298 # 6dd0 <longjmp_1+0x1220>
    28c6:	00003097          	auipc	ra,0x3
    28ca:	0d6080e7          	jalr	214(ra) # 599c <printf>
    exit(1);
    28ce:	4505                	li	a0,1
    28d0:	00003097          	auipc	ra,0x3
    28d4:	d3c080e7          	jalr	-708(ra) # 560c <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    28d8:	86aa                	mv	a3,a0
    28da:	8626                	mv	a2,s1
    28dc:	85ce                	mv	a1,s3
    28de:	00004517          	auipc	a0,0x4
    28e2:	52a50513          	addi	a0,a0,1322 # 6e08 <longjmp_1+0x1258>
    28e6:	00003097          	auipc	ra,0x3
    28ea:	0b6080e7          	jalr	182(ra) # 599c <printf>
    exit(1);
    28ee:	4505                	li	a0,1
    28f0:	00003097          	auipc	ra,0x3
    28f4:	d1c080e7          	jalr	-740(ra) # 560c <exit>

00000000000028f8 <sbrkarg>:
{
    28f8:	7179                	addi	sp,sp,-48
    28fa:	f406                	sd	ra,40(sp)
    28fc:	f022                	sd	s0,32(sp)
    28fe:	ec26                	sd	s1,24(sp)
    2900:	e84a                	sd	s2,16(sp)
    2902:	e44e                	sd	s3,8(sp)
    2904:	1800                	addi	s0,sp,48
    2906:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2908:	6505                	lui	a0,0x1
    290a:	00003097          	auipc	ra,0x3
    290e:	d8a080e7          	jalr	-630(ra) # 5694 <sbrk>
    2912:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2914:	20100593          	li	a1,513
    2918:	00004517          	auipc	a0,0x4
    291c:	51850513          	addi	a0,a0,1304 # 6e30 <longjmp_1+0x1280>
    2920:	00003097          	auipc	ra,0x3
    2924:	d2c080e7          	jalr	-724(ra) # 564c <open>
    2928:	84aa                	mv	s1,a0
  unlink("sbrk");
    292a:	00004517          	auipc	a0,0x4
    292e:	50650513          	addi	a0,a0,1286 # 6e30 <longjmp_1+0x1280>
    2932:	00003097          	auipc	ra,0x3
    2936:	d2a080e7          	jalr	-726(ra) # 565c <unlink>
  if(fd < 0)  {
    293a:	0404c163          	bltz	s1,297c <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    293e:	6605                	lui	a2,0x1
    2940:	85ca                	mv	a1,s2
    2942:	8526                	mv	a0,s1
    2944:	00003097          	auipc	ra,0x3
    2948:	ce8080e7          	jalr	-792(ra) # 562c <write>
    294c:	04054663          	bltz	a0,2998 <sbrkarg+0xa0>
  close(fd);
    2950:	8526                	mv	a0,s1
    2952:	00003097          	auipc	ra,0x3
    2956:	ce2080e7          	jalr	-798(ra) # 5634 <close>
  a = sbrk(PGSIZE);
    295a:	6505                	lui	a0,0x1
    295c:	00003097          	auipc	ra,0x3
    2960:	d38080e7          	jalr	-712(ra) # 5694 <sbrk>
  if(pipe((int *) a) != 0){
    2964:	00003097          	auipc	ra,0x3
    2968:	cb8080e7          	jalr	-840(ra) # 561c <pipe>
    296c:	e521                	bnez	a0,29b4 <sbrkarg+0xbc>
}
    296e:	70a2                	ld	ra,40(sp)
    2970:	7402                	ld	s0,32(sp)
    2972:	64e2                	ld	s1,24(sp)
    2974:	6942                	ld	s2,16(sp)
    2976:	69a2                	ld	s3,8(sp)
    2978:	6145                	addi	sp,sp,48
    297a:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    297c:	85ce                	mv	a1,s3
    297e:	00004517          	auipc	a0,0x4
    2982:	4ba50513          	addi	a0,a0,1210 # 6e38 <longjmp_1+0x1288>
    2986:	00003097          	auipc	ra,0x3
    298a:	016080e7          	jalr	22(ra) # 599c <printf>
    exit(1);
    298e:	4505                	li	a0,1
    2990:	00003097          	auipc	ra,0x3
    2994:	c7c080e7          	jalr	-900(ra) # 560c <exit>
    printf("%s: write sbrk failed\n", s);
    2998:	85ce                	mv	a1,s3
    299a:	00004517          	auipc	a0,0x4
    299e:	4b650513          	addi	a0,a0,1206 # 6e50 <longjmp_1+0x12a0>
    29a2:	00003097          	auipc	ra,0x3
    29a6:	ffa080e7          	jalr	-6(ra) # 599c <printf>
    exit(1);
    29aa:	4505                	li	a0,1
    29ac:	00003097          	auipc	ra,0x3
    29b0:	c60080e7          	jalr	-928(ra) # 560c <exit>
    printf("%s: pipe() failed\n", s);
    29b4:	85ce                	mv	a1,s3
    29b6:	00004517          	auipc	a0,0x4
    29ba:	e9a50513          	addi	a0,a0,-358 # 6850 <longjmp_1+0xca0>
    29be:	00003097          	auipc	ra,0x3
    29c2:	fde080e7          	jalr	-34(ra) # 599c <printf>
    exit(1);
    29c6:	4505                	li	a0,1
    29c8:	00003097          	auipc	ra,0x3
    29cc:	c44080e7          	jalr	-956(ra) # 560c <exit>

00000000000029d0 <argptest>:
{
    29d0:	1101                	addi	sp,sp,-32
    29d2:	ec06                	sd	ra,24(sp)
    29d4:	e822                	sd	s0,16(sp)
    29d6:	e426                	sd	s1,8(sp)
    29d8:	e04a                	sd	s2,0(sp)
    29da:	1000                	addi	s0,sp,32
    29dc:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    29de:	4581                	li	a1,0
    29e0:	00004517          	auipc	a0,0x4
    29e4:	48850513          	addi	a0,a0,1160 # 6e68 <longjmp_1+0x12b8>
    29e8:	00003097          	auipc	ra,0x3
    29ec:	c64080e7          	jalr	-924(ra) # 564c <open>
  if (fd < 0) {
    29f0:	02054b63          	bltz	a0,2a26 <argptest+0x56>
    29f4:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    29f6:	4501                	li	a0,0
    29f8:	00003097          	auipc	ra,0x3
    29fc:	c9c080e7          	jalr	-868(ra) # 5694 <sbrk>
    2a00:	567d                	li	a2,-1
    2a02:	fff50593          	addi	a1,a0,-1
    2a06:	8526                	mv	a0,s1
    2a08:	00003097          	auipc	ra,0x3
    2a0c:	c1c080e7          	jalr	-996(ra) # 5624 <read>
  close(fd);
    2a10:	8526                	mv	a0,s1
    2a12:	00003097          	auipc	ra,0x3
    2a16:	c22080e7          	jalr	-990(ra) # 5634 <close>
}
    2a1a:	60e2                	ld	ra,24(sp)
    2a1c:	6442                	ld	s0,16(sp)
    2a1e:	64a2                	ld	s1,8(sp)
    2a20:	6902                	ld	s2,0(sp)
    2a22:	6105                	addi	sp,sp,32
    2a24:	8082                	ret
    printf("%s: open failed\n", s);
    2a26:	85ca                	mv	a1,s2
    2a28:	00004517          	auipc	a0,0x4
    2a2c:	d3850513          	addi	a0,a0,-712 # 6760 <longjmp_1+0xbb0>
    2a30:	00003097          	auipc	ra,0x3
    2a34:	f6c080e7          	jalr	-148(ra) # 599c <printf>
    exit(1);
    2a38:	4505                	li	a0,1
    2a3a:	00003097          	auipc	ra,0x3
    2a3e:	bd2080e7          	jalr	-1070(ra) # 560c <exit>

0000000000002a42 <sbrkbugs>:
{
    2a42:	1141                	addi	sp,sp,-16
    2a44:	e406                	sd	ra,8(sp)
    2a46:	e022                	sd	s0,0(sp)
    2a48:	0800                	addi	s0,sp,16
  int pid = fork();
    2a4a:	00003097          	auipc	ra,0x3
    2a4e:	bba080e7          	jalr	-1094(ra) # 5604 <fork>
  if(pid < 0){
    2a52:	02054263          	bltz	a0,2a76 <sbrkbugs+0x34>
  if(pid == 0){
    2a56:	ed0d                	bnez	a0,2a90 <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2a58:	00003097          	auipc	ra,0x3
    2a5c:	c3c080e7          	jalr	-964(ra) # 5694 <sbrk>
    sbrk(-sz);
    2a60:	40a0053b          	negw	a0,a0
    2a64:	00003097          	auipc	ra,0x3
    2a68:	c30080e7          	jalr	-976(ra) # 5694 <sbrk>
    exit(0);
    2a6c:	4501                	li	a0,0
    2a6e:	00003097          	auipc	ra,0x3
    2a72:	b9e080e7          	jalr	-1122(ra) # 560c <exit>
    printf("fork failed\n");
    2a76:	00004517          	auipc	a0,0x4
    2a7a:	0da50513          	addi	a0,a0,218 # 6b50 <longjmp_1+0xfa0>
    2a7e:	00003097          	auipc	ra,0x3
    2a82:	f1e080e7          	jalr	-226(ra) # 599c <printf>
    exit(1);
    2a86:	4505                	li	a0,1
    2a88:	00003097          	auipc	ra,0x3
    2a8c:	b84080e7          	jalr	-1148(ra) # 560c <exit>
  wait(0);
    2a90:	4501                	li	a0,0
    2a92:	00003097          	auipc	ra,0x3
    2a96:	b82080e7          	jalr	-1150(ra) # 5614 <wait>
  pid = fork();
    2a9a:	00003097          	auipc	ra,0x3
    2a9e:	b6a080e7          	jalr	-1174(ra) # 5604 <fork>
  if(pid < 0){
    2aa2:	02054563          	bltz	a0,2acc <sbrkbugs+0x8a>
  if(pid == 0){
    2aa6:	e121                	bnez	a0,2ae6 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2aa8:	00003097          	auipc	ra,0x3
    2aac:	bec080e7          	jalr	-1044(ra) # 5694 <sbrk>
    sbrk(-(sz - 3500));
    2ab0:	6785                	lui	a5,0x1
    2ab2:	dac7879b          	addiw	a5,a5,-596
    2ab6:	40a7853b          	subw	a0,a5,a0
    2aba:	00003097          	auipc	ra,0x3
    2abe:	bda080e7          	jalr	-1062(ra) # 5694 <sbrk>
    exit(0);
    2ac2:	4501                	li	a0,0
    2ac4:	00003097          	auipc	ra,0x3
    2ac8:	b48080e7          	jalr	-1208(ra) # 560c <exit>
    printf("fork failed\n");
    2acc:	00004517          	auipc	a0,0x4
    2ad0:	08450513          	addi	a0,a0,132 # 6b50 <longjmp_1+0xfa0>
    2ad4:	00003097          	auipc	ra,0x3
    2ad8:	ec8080e7          	jalr	-312(ra) # 599c <printf>
    exit(1);
    2adc:	4505                	li	a0,1
    2ade:	00003097          	auipc	ra,0x3
    2ae2:	b2e080e7          	jalr	-1234(ra) # 560c <exit>
  wait(0);
    2ae6:	4501                	li	a0,0
    2ae8:	00003097          	auipc	ra,0x3
    2aec:	b2c080e7          	jalr	-1236(ra) # 5614 <wait>
  pid = fork();
    2af0:	00003097          	auipc	ra,0x3
    2af4:	b14080e7          	jalr	-1260(ra) # 5604 <fork>
  if(pid < 0){
    2af8:	02054a63          	bltz	a0,2b2c <sbrkbugs+0xea>
  if(pid == 0){
    2afc:	e529                	bnez	a0,2b46 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2afe:	00003097          	auipc	ra,0x3
    2b02:	b96080e7          	jalr	-1130(ra) # 5694 <sbrk>
    2b06:	67ad                	lui	a5,0xb
    2b08:	8007879b          	addiw	a5,a5,-2048
    2b0c:	40a7853b          	subw	a0,a5,a0
    2b10:	00003097          	auipc	ra,0x3
    2b14:	b84080e7          	jalr	-1148(ra) # 5694 <sbrk>
    sbrk(-10);
    2b18:	5559                	li	a0,-10
    2b1a:	00003097          	auipc	ra,0x3
    2b1e:	b7a080e7          	jalr	-1158(ra) # 5694 <sbrk>
    exit(0);
    2b22:	4501                	li	a0,0
    2b24:	00003097          	auipc	ra,0x3
    2b28:	ae8080e7          	jalr	-1304(ra) # 560c <exit>
    printf("fork failed\n");
    2b2c:	00004517          	auipc	a0,0x4
    2b30:	02450513          	addi	a0,a0,36 # 6b50 <longjmp_1+0xfa0>
    2b34:	00003097          	auipc	ra,0x3
    2b38:	e68080e7          	jalr	-408(ra) # 599c <printf>
    exit(1);
    2b3c:	4505                	li	a0,1
    2b3e:	00003097          	auipc	ra,0x3
    2b42:	ace080e7          	jalr	-1330(ra) # 560c <exit>
  wait(0);
    2b46:	4501                	li	a0,0
    2b48:	00003097          	auipc	ra,0x3
    2b4c:	acc080e7          	jalr	-1332(ra) # 5614 <wait>
  exit(0);
    2b50:	4501                	li	a0,0
    2b52:	00003097          	auipc	ra,0x3
    2b56:	aba080e7          	jalr	-1350(ra) # 560c <exit>

0000000000002b5a <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    2b5a:	715d                	addi	sp,sp,-80
    2b5c:	e486                	sd	ra,72(sp)
    2b5e:	e0a2                	sd	s0,64(sp)
    2b60:	fc26                	sd	s1,56(sp)
    2b62:	f84a                	sd	s2,48(sp)
    2b64:	f44e                	sd	s3,40(sp)
    2b66:	f052                	sd	s4,32(sp)
    2b68:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2b6a:	4901                	li	s2,0
    2b6c:	49bd                	li	s3,15
    int pid = fork();
    2b6e:	00003097          	auipc	ra,0x3
    2b72:	a96080e7          	jalr	-1386(ra) # 5604 <fork>
    2b76:	84aa                	mv	s1,a0
    if(pid < 0){
    2b78:	02054063          	bltz	a0,2b98 <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    2b7c:	c91d                	beqz	a0,2bb2 <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    2b7e:	4501                	li	a0,0
    2b80:	00003097          	auipc	ra,0x3
    2b84:	a94080e7          	jalr	-1388(ra) # 5614 <wait>
  for(int avail = 0; avail < 15; avail++){
    2b88:	2905                	addiw	s2,s2,1
    2b8a:	ff3912e3          	bne	s2,s3,2b6e <execout+0x14>
    }
  }

  exit(0);
    2b8e:	4501                	li	a0,0
    2b90:	00003097          	auipc	ra,0x3
    2b94:	a7c080e7          	jalr	-1412(ra) # 560c <exit>
      printf("fork failed\n");
    2b98:	00004517          	auipc	a0,0x4
    2b9c:	fb850513          	addi	a0,a0,-72 # 6b50 <longjmp_1+0xfa0>
    2ba0:	00003097          	auipc	ra,0x3
    2ba4:	dfc080e7          	jalr	-516(ra) # 599c <printf>
      exit(1);
    2ba8:	4505                	li	a0,1
    2baa:	00003097          	auipc	ra,0x3
    2bae:	a62080e7          	jalr	-1438(ra) # 560c <exit>
        if(a == 0xffffffffffffffffLL)
    2bb2:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2bb4:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2bb6:	6505                	lui	a0,0x1
    2bb8:	00003097          	auipc	ra,0x3
    2bbc:	adc080e7          	jalr	-1316(ra) # 5694 <sbrk>
        if(a == 0xffffffffffffffffLL)
    2bc0:	01350763          	beq	a0,s3,2bce <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2bc4:	6785                	lui	a5,0x1
    2bc6:	953e                	add	a0,a0,a5
    2bc8:	ff450fa3          	sb	s4,-1(a0) # fff <bigdir+0x9d>
      while(1){
    2bcc:	b7ed                	j	2bb6 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2bce:	01205a63          	blez	s2,2be2 <execout+0x88>
        sbrk(-4096);
    2bd2:	757d                	lui	a0,0xfffff
    2bd4:	00003097          	auipc	ra,0x3
    2bd8:	ac0080e7          	jalr	-1344(ra) # 5694 <sbrk>
      for(int i = 0; i < avail; i++)
    2bdc:	2485                	addiw	s1,s1,1
    2bde:	ff249ae3          	bne	s1,s2,2bd2 <execout+0x78>
      close(1);
    2be2:	4505                	li	a0,1
    2be4:	00003097          	auipc	ra,0x3
    2be8:	a50080e7          	jalr	-1456(ra) # 5634 <close>
      char *args[] = { "echo", "x", 0 };
    2bec:	00003517          	auipc	a0,0x3
    2bf0:	32450513          	addi	a0,a0,804 # 5f10 <longjmp_1+0x360>
    2bf4:	faa43c23          	sd	a0,-72(s0)
    2bf8:	00003797          	auipc	a5,0x3
    2bfc:	38878793          	addi	a5,a5,904 # 5f80 <longjmp_1+0x3d0>
    2c00:	fcf43023          	sd	a5,-64(s0)
    2c04:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2c08:	fb840593          	addi	a1,s0,-72
    2c0c:	00003097          	auipc	ra,0x3
    2c10:	a38080e7          	jalr	-1480(ra) # 5644 <exec>
      exit(0);
    2c14:	4501                	li	a0,0
    2c16:	00003097          	auipc	ra,0x3
    2c1a:	9f6080e7          	jalr	-1546(ra) # 560c <exit>

0000000000002c1e <fourteen>:
{
    2c1e:	1101                	addi	sp,sp,-32
    2c20:	ec06                	sd	ra,24(sp)
    2c22:	e822                	sd	s0,16(sp)
    2c24:	e426                	sd	s1,8(sp)
    2c26:	1000                	addi	s0,sp,32
    2c28:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2c2a:	00004517          	auipc	a0,0x4
    2c2e:	41650513          	addi	a0,a0,1046 # 7040 <longjmp_1+0x1490>
    2c32:	00003097          	auipc	ra,0x3
    2c36:	a42080e7          	jalr	-1470(ra) # 5674 <mkdir>
    2c3a:	e165                	bnez	a0,2d1a <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2c3c:	00004517          	auipc	a0,0x4
    2c40:	25c50513          	addi	a0,a0,604 # 6e98 <longjmp_1+0x12e8>
    2c44:	00003097          	auipc	ra,0x3
    2c48:	a30080e7          	jalr	-1488(ra) # 5674 <mkdir>
    2c4c:	e56d                	bnez	a0,2d36 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2c4e:	20000593          	li	a1,512
    2c52:	00004517          	auipc	a0,0x4
    2c56:	29e50513          	addi	a0,a0,670 # 6ef0 <longjmp_1+0x1340>
    2c5a:	00003097          	auipc	ra,0x3
    2c5e:	9f2080e7          	jalr	-1550(ra) # 564c <open>
  if(fd < 0){
    2c62:	0e054863          	bltz	a0,2d52 <fourteen+0x134>
  close(fd);
    2c66:	00003097          	auipc	ra,0x3
    2c6a:	9ce080e7          	jalr	-1586(ra) # 5634 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2c6e:	4581                	li	a1,0
    2c70:	00004517          	auipc	a0,0x4
    2c74:	2f850513          	addi	a0,a0,760 # 6f68 <longjmp_1+0x13b8>
    2c78:	00003097          	auipc	ra,0x3
    2c7c:	9d4080e7          	jalr	-1580(ra) # 564c <open>
  if(fd < 0){
    2c80:	0e054763          	bltz	a0,2d6e <fourteen+0x150>
  close(fd);
    2c84:	00003097          	auipc	ra,0x3
    2c88:	9b0080e7          	jalr	-1616(ra) # 5634 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2c8c:	00004517          	auipc	a0,0x4
    2c90:	34c50513          	addi	a0,a0,844 # 6fd8 <longjmp_1+0x1428>
    2c94:	00003097          	auipc	ra,0x3
    2c98:	9e0080e7          	jalr	-1568(ra) # 5674 <mkdir>
    2c9c:	c57d                	beqz	a0,2d8a <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2c9e:	00004517          	auipc	a0,0x4
    2ca2:	39250513          	addi	a0,a0,914 # 7030 <longjmp_1+0x1480>
    2ca6:	00003097          	auipc	ra,0x3
    2caa:	9ce080e7          	jalr	-1586(ra) # 5674 <mkdir>
    2cae:	cd65                	beqz	a0,2da6 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2cb0:	00004517          	auipc	a0,0x4
    2cb4:	38050513          	addi	a0,a0,896 # 7030 <longjmp_1+0x1480>
    2cb8:	00003097          	auipc	ra,0x3
    2cbc:	9a4080e7          	jalr	-1628(ra) # 565c <unlink>
  unlink("12345678901234/12345678901234");
    2cc0:	00004517          	auipc	a0,0x4
    2cc4:	31850513          	addi	a0,a0,792 # 6fd8 <longjmp_1+0x1428>
    2cc8:	00003097          	auipc	ra,0x3
    2ccc:	994080e7          	jalr	-1644(ra) # 565c <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2cd0:	00004517          	auipc	a0,0x4
    2cd4:	29850513          	addi	a0,a0,664 # 6f68 <longjmp_1+0x13b8>
    2cd8:	00003097          	auipc	ra,0x3
    2cdc:	984080e7          	jalr	-1660(ra) # 565c <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2ce0:	00004517          	auipc	a0,0x4
    2ce4:	21050513          	addi	a0,a0,528 # 6ef0 <longjmp_1+0x1340>
    2ce8:	00003097          	auipc	ra,0x3
    2cec:	974080e7          	jalr	-1676(ra) # 565c <unlink>
  unlink("12345678901234/123456789012345");
    2cf0:	00004517          	auipc	a0,0x4
    2cf4:	1a850513          	addi	a0,a0,424 # 6e98 <longjmp_1+0x12e8>
    2cf8:	00003097          	auipc	ra,0x3
    2cfc:	964080e7          	jalr	-1692(ra) # 565c <unlink>
  unlink("12345678901234");
    2d00:	00004517          	auipc	a0,0x4
    2d04:	34050513          	addi	a0,a0,832 # 7040 <longjmp_1+0x1490>
    2d08:	00003097          	auipc	ra,0x3
    2d0c:	954080e7          	jalr	-1708(ra) # 565c <unlink>
}
    2d10:	60e2                	ld	ra,24(sp)
    2d12:	6442                	ld	s0,16(sp)
    2d14:	64a2                	ld	s1,8(sp)
    2d16:	6105                	addi	sp,sp,32
    2d18:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2d1a:	85a6                	mv	a1,s1
    2d1c:	00004517          	auipc	a0,0x4
    2d20:	15450513          	addi	a0,a0,340 # 6e70 <longjmp_1+0x12c0>
    2d24:	00003097          	auipc	ra,0x3
    2d28:	c78080e7          	jalr	-904(ra) # 599c <printf>
    exit(1);
    2d2c:	4505                	li	a0,1
    2d2e:	00003097          	auipc	ra,0x3
    2d32:	8de080e7          	jalr	-1826(ra) # 560c <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2d36:	85a6                	mv	a1,s1
    2d38:	00004517          	auipc	a0,0x4
    2d3c:	18050513          	addi	a0,a0,384 # 6eb8 <longjmp_1+0x1308>
    2d40:	00003097          	auipc	ra,0x3
    2d44:	c5c080e7          	jalr	-932(ra) # 599c <printf>
    exit(1);
    2d48:	4505                	li	a0,1
    2d4a:	00003097          	auipc	ra,0x3
    2d4e:	8c2080e7          	jalr	-1854(ra) # 560c <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2d52:	85a6                	mv	a1,s1
    2d54:	00004517          	auipc	a0,0x4
    2d58:	1cc50513          	addi	a0,a0,460 # 6f20 <longjmp_1+0x1370>
    2d5c:	00003097          	auipc	ra,0x3
    2d60:	c40080e7          	jalr	-960(ra) # 599c <printf>
    exit(1);
    2d64:	4505                	li	a0,1
    2d66:	00003097          	auipc	ra,0x3
    2d6a:	8a6080e7          	jalr	-1882(ra) # 560c <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2d6e:	85a6                	mv	a1,s1
    2d70:	00004517          	auipc	a0,0x4
    2d74:	22850513          	addi	a0,a0,552 # 6f98 <longjmp_1+0x13e8>
    2d78:	00003097          	auipc	ra,0x3
    2d7c:	c24080e7          	jalr	-988(ra) # 599c <printf>
    exit(1);
    2d80:	4505                	li	a0,1
    2d82:	00003097          	auipc	ra,0x3
    2d86:	88a080e7          	jalr	-1910(ra) # 560c <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2d8a:	85a6                	mv	a1,s1
    2d8c:	00004517          	auipc	a0,0x4
    2d90:	26c50513          	addi	a0,a0,620 # 6ff8 <longjmp_1+0x1448>
    2d94:	00003097          	auipc	ra,0x3
    2d98:	c08080e7          	jalr	-1016(ra) # 599c <printf>
    exit(1);
    2d9c:	4505                	li	a0,1
    2d9e:	00003097          	auipc	ra,0x3
    2da2:	86e080e7          	jalr	-1938(ra) # 560c <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2da6:	85a6                	mv	a1,s1
    2da8:	00004517          	auipc	a0,0x4
    2dac:	2a850513          	addi	a0,a0,680 # 7050 <longjmp_1+0x14a0>
    2db0:	00003097          	auipc	ra,0x3
    2db4:	bec080e7          	jalr	-1044(ra) # 599c <printf>
    exit(1);
    2db8:	4505                	li	a0,1
    2dba:	00003097          	auipc	ra,0x3
    2dbe:	852080e7          	jalr	-1966(ra) # 560c <exit>

0000000000002dc2 <iputtest>:
{
    2dc2:	1101                	addi	sp,sp,-32
    2dc4:	ec06                	sd	ra,24(sp)
    2dc6:	e822                	sd	s0,16(sp)
    2dc8:	e426                	sd	s1,8(sp)
    2dca:	1000                	addi	s0,sp,32
    2dcc:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2dce:	00004517          	auipc	a0,0x4
    2dd2:	2ba50513          	addi	a0,a0,698 # 7088 <longjmp_1+0x14d8>
    2dd6:	00003097          	auipc	ra,0x3
    2dda:	89e080e7          	jalr	-1890(ra) # 5674 <mkdir>
    2dde:	04054563          	bltz	a0,2e28 <iputtest+0x66>
  if(chdir("iputdir") < 0){
    2de2:	00004517          	auipc	a0,0x4
    2de6:	2a650513          	addi	a0,a0,678 # 7088 <longjmp_1+0x14d8>
    2dea:	00003097          	auipc	ra,0x3
    2dee:	892080e7          	jalr	-1902(ra) # 567c <chdir>
    2df2:	04054963          	bltz	a0,2e44 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    2df6:	00004517          	auipc	a0,0x4
    2dfa:	2d250513          	addi	a0,a0,722 # 70c8 <longjmp_1+0x1518>
    2dfe:	00003097          	auipc	ra,0x3
    2e02:	85e080e7          	jalr	-1954(ra) # 565c <unlink>
    2e06:	04054d63          	bltz	a0,2e60 <iputtest+0x9e>
  if(chdir("/") < 0){
    2e0a:	00004517          	auipc	a0,0x4
    2e0e:	2ee50513          	addi	a0,a0,750 # 70f8 <longjmp_1+0x1548>
    2e12:	00003097          	auipc	ra,0x3
    2e16:	86a080e7          	jalr	-1942(ra) # 567c <chdir>
    2e1a:	06054163          	bltz	a0,2e7c <iputtest+0xba>
}
    2e1e:	60e2                	ld	ra,24(sp)
    2e20:	6442                	ld	s0,16(sp)
    2e22:	64a2                	ld	s1,8(sp)
    2e24:	6105                	addi	sp,sp,32
    2e26:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2e28:	85a6                	mv	a1,s1
    2e2a:	00004517          	auipc	a0,0x4
    2e2e:	26650513          	addi	a0,a0,614 # 7090 <longjmp_1+0x14e0>
    2e32:	00003097          	auipc	ra,0x3
    2e36:	b6a080e7          	jalr	-1174(ra) # 599c <printf>
    exit(1);
    2e3a:	4505                	li	a0,1
    2e3c:	00002097          	auipc	ra,0x2
    2e40:	7d0080e7          	jalr	2000(ra) # 560c <exit>
    printf("%s: chdir iputdir failed\n", s);
    2e44:	85a6                	mv	a1,s1
    2e46:	00004517          	auipc	a0,0x4
    2e4a:	26250513          	addi	a0,a0,610 # 70a8 <longjmp_1+0x14f8>
    2e4e:	00003097          	auipc	ra,0x3
    2e52:	b4e080e7          	jalr	-1202(ra) # 599c <printf>
    exit(1);
    2e56:	4505                	li	a0,1
    2e58:	00002097          	auipc	ra,0x2
    2e5c:	7b4080e7          	jalr	1972(ra) # 560c <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2e60:	85a6                	mv	a1,s1
    2e62:	00004517          	auipc	a0,0x4
    2e66:	27650513          	addi	a0,a0,630 # 70d8 <longjmp_1+0x1528>
    2e6a:	00003097          	auipc	ra,0x3
    2e6e:	b32080e7          	jalr	-1230(ra) # 599c <printf>
    exit(1);
    2e72:	4505                	li	a0,1
    2e74:	00002097          	auipc	ra,0x2
    2e78:	798080e7          	jalr	1944(ra) # 560c <exit>
    printf("%s: chdir / failed\n", s);
    2e7c:	85a6                	mv	a1,s1
    2e7e:	00004517          	auipc	a0,0x4
    2e82:	28250513          	addi	a0,a0,642 # 7100 <longjmp_1+0x1550>
    2e86:	00003097          	auipc	ra,0x3
    2e8a:	b16080e7          	jalr	-1258(ra) # 599c <printf>
    exit(1);
    2e8e:	4505                	li	a0,1
    2e90:	00002097          	auipc	ra,0x2
    2e94:	77c080e7          	jalr	1916(ra) # 560c <exit>

0000000000002e98 <exitiputtest>:
{
    2e98:	7179                	addi	sp,sp,-48
    2e9a:	f406                	sd	ra,40(sp)
    2e9c:	f022                	sd	s0,32(sp)
    2e9e:	ec26                	sd	s1,24(sp)
    2ea0:	1800                	addi	s0,sp,48
    2ea2:	84aa                	mv	s1,a0
  pid = fork();
    2ea4:	00002097          	auipc	ra,0x2
    2ea8:	760080e7          	jalr	1888(ra) # 5604 <fork>
  if(pid < 0){
    2eac:	04054663          	bltz	a0,2ef8 <exitiputtest+0x60>
  if(pid == 0){
    2eb0:	ed45                	bnez	a0,2f68 <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    2eb2:	00004517          	auipc	a0,0x4
    2eb6:	1d650513          	addi	a0,a0,470 # 7088 <longjmp_1+0x14d8>
    2eba:	00002097          	auipc	ra,0x2
    2ebe:	7ba080e7          	jalr	1978(ra) # 5674 <mkdir>
    2ec2:	04054963          	bltz	a0,2f14 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    2ec6:	00004517          	auipc	a0,0x4
    2eca:	1c250513          	addi	a0,a0,450 # 7088 <longjmp_1+0x14d8>
    2ece:	00002097          	auipc	ra,0x2
    2ed2:	7ae080e7          	jalr	1966(ra) # 567c <chdir>
    2ed6:	04054d63          	bltz	a0,2f30 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    2eda:	00004517          	auipc	a0,0x4
    2ede:	1ee50513          	addi	a0,a0,494 # 70c8 <longjmp_1+0x1518>
    2ee2:	00002097          	auipc	ra,0x2
    2ee6:	77a080e7          	jalr	1914(ra) # 565c <unlink>
    2eea:	06054163          	bltz	a0,2f4c <exitiputtest+0xb4>
    exit(0);
    2eee:	4501                	li	a0,0
    2ef0:	00002097          	auipc	ra,0x2
    2ef4:	71c080e7          	jalr	1820(ra) # 560c <exit>
    printf("%s: fork failed\n", s);
    2ef8:	85a6                	mv	a1,s1
    2efa:	00004517          	auipc	a0,0x4
    2efe:	84e50513          	addi	a0,a0,-1970 # 6748 <longjmp_1+0xb98>
    2f02:	00003097          	auipc	ra,0x3
    2f06:	a9a080e7          	jalr	-1382(ra) # 599c <printf>
    exit(1);
    2f0a:	4505                	li	a0,1
    2f0c:	00002097          	auipc	ra,0x2
    2f10:	700080e7          	jalr	1792(ra) # 560c <exit>
      printf("%s: mkdir failed\n", s);
    2f14:	85a6                	mv	a1,s1
    2f16:	00004517          	auipc	a0,0x4
    2f1a:	17a50513          	addi	a0,a0,378 # 7090 <longjmp_1+0x14e0>
    2f1e:	00003097          	auipc	ra,0x3
    2f22:	a7e080e7          	jalr	-1410(ra) # 599c <printf>
      exit(1);
    2f26:	4505                	li	a0,1
    2f28:	00002097          	auipc	ra,0x2
    2f2c:	6e4080e7          	jalr	1764(ra) # 560c <exit>
      printf("%s: child chdir failed\n", s);
    2f30:	85a6                	mv	a1,s1
    2f32:	00004517          	auipc	a0,0x4
    2f36:	1e650513          	addi	a0,a0,486 # 7118 <longjmp_1+0x1568>
    2f3a:	00003097          	auipc	ra,0x3
    2f3e:	a62080e7          	jalr	-1438(ra) # 599c <printf>
      exit(1);
    2f42:	4505                	li	a0,1
    2f44:	00002097          	auipc	ra,0x2
    2f48:	6c8080e7          	jalr	1736(ra) # 560c <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2f4c:	85a6                	mv	a1,s1
    2f4e:	00004517          	auipc	a0,0x4
    2f52:	18a50513          	addi	a0,a0,394 # 70d8 <longjmp_1+0x1528>
    2f56:	00003097          	auipc	ra,0x3
    2f5a:	a46080e7          	jalr	-1466(ra) # 599c <printf>
      exit(1);
    2f5e:	4505                	li	a0,1
    2f60:	00002097          	auipc	ra,0x2
    2f64:	6ac080e7          	jalr	1708(ra) # 560c <exit>
  wait(&xstatus);
    2f68:	fdc40513          	addi	a0,s0,-36
    2f6c:	00002097          	auipc	ra,0x2
    2f70:	6a8080e7          	jalr	1704(ra) # 5614 <wait>
  exit(xstatus);
    2f74:	fdc42503          	lw	a0,-36(s0)
    2f78:	00002097          	auipc	ra,0x2
    2f7c:	694080e7          	jalr	1684(ra) # 560c <exit>

0000000000002f80 <dirtest>:
{
    2f80:	1101                	addi	sp,sp,-32
    2f82:	ec06                	sd	ra,24(sp)
    2f84:	e822                	sd	s0,16(sp)
    2f86:	e426                	sd	s1,8(sp)
    2f88:	1000                	addi	s0,sp,32
    2f8a:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2f8c:	00004517          	auipc	a0,0x4
    2f90:	1a450513          	addi	a0,a0,420 # 7130 <longjmp_1+0x1580>
    2f94:	00002097          	auipc	ra,0x2
    2f98:	6e0080e7          	jalr	1760(ra) # 5674 <mkdir>
    2f9c:	04054563          	bltz	a0,2fe6 <dirtest+0x66>
  if(chdir("dir0") < 0){
    2fa0:	00004517          	auipc	a0,0x4
    2fa4:	19050513          	addi	a0,a0,400 # 7130 <longjmp_1+0x1580>
    2fa8:	00002097          	auipc	ra,0x2
    2fac:	6d4080e7          	jalr	1748(ra) # 567c <chdir>
    2fb0:	04054963          	bltz	a0,3002 <dirtest+0x82>
  if(chdir("..") < 0){
    2fb4:	00004517          	auipc	a0,0x4
    2fb8:	19c50513          	addi	a0,a0,412 # 7150 <longjmp_1+0x15a0>
    2fbc:	00002097          	auipc	ra,0x2
    2fc0:	6c0080e7          	jalr	1728(ra) # 567c <chdir>
    2fc4:	04054d63          	bltz	a0,301e <dirtest+0x9e>
  if(unlink("dir0") < 0){
    2fc8:	00004517          	auipc	a0,0x4
    2fcc:	16850513          	addi	a0,a0,360 # 7130 <longjmp_1+0x1580>
    2fd0:	00002097          	auipc	ra,0x2
    2fd4:	68c080e7          	jalr	1676(ra) # 565c <unlink>
    2fd8:	06054163          	bltz	a0,303a <dirtest+0xba>
}
    2fdc:	60e2                	ld	ra,24(sp)
    2fde:	6442                	ld	s0,16(sp)
    2fe0:	64a2                	ld	s1,8(sp)
    2fe2:	6105                	addi	sp,sp,32
    2fe4:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2fe6:	85a6                	mv	a1,s1
    2fe8:	00004517          	auipc	a0,0x4
    2fec:	0a850513          	addi	a0,a0,168 # 7090 <longjmp_1+0x14e0>
    2ff0:	00003097          	auipc	ra,0x3
    2ff4:	9ac080e7          	jalr	-1620(ra) # 599c <printf>
    exit(1);
    2ff8:	4505                	li	a0,1
    2ffa:	00002097          	auipc	ra,0x2
    2ffe:	612080e7          	jalr	1554(ra) # 560c <exit>
    printf("%s: chdir dir0 failed\n", s);
    3002:	85a6                	mv	a1,s1
    3004:	00004517          	auipc	a0,0x4
    3008:	13450513          	addi	a0,a0,308 # 7138 <longjmp_1+0x1588>
    300c:	00003097          	auipc	ra,0x3
    3010:	990080e7          	jalr	-1648(ra) # 599c <printf>
    exit(1);
    3014:	4505                	li	a0,1
    3016:	00002097          	auipc	ra,0x2
    301a:	5f6080e7          	jalr	1526(ra) # 560c <exit>
    printf("%s: chdir .. failed\n", s);
    301e:	85a6                	mv	a1,s1
    3020:	00004517          	auipc	a0,0x4
    3024:	13850513          	addi	a0,a0,312 # 7158 <longjmp_1+0x15a8>
    3028:	00003097          	auipc	ra,0x3
    302c:	974080e7          	jalr	-1676(ra) # 599c <printf>
    exit(1);
    3030:	4505                	li	a0,1
    3032:	00002097          	auipc	ra,0x2
    3036:	5da080e7          	jalr	1498(ra) # 560c <exit>
    printf("%s: unlink dir0 failed\n", s);
    303a:	85a6                	mv	a1,s1
    303c:	00004517          	auipc	a0,0x4
    3040:	13450513          	addi	a0,a0,308 # 7170 <longjmp_1+0x15c0>
    3044:	00003097          	auipc	ra,0x3
    3048:	958080e7          	jalr	-1704(ra) # 599c <printf>
    exit(1);
    304c:	4505                	li	a0,1
    304e:	00002097          	auipc	ra,0x2
    3052:	5be080e7          	jalr	1470(ra) # 560c <exit>

0000000000003056 <subdir>:
{
    3056:	1101                	addi	sp,sp,-32
    3058:	ec06                	sd	ra,24(sp)
    305a:	e822                	sd	s0,16(sp)
    305c:	e426                	sd	s1,8(sp)
    305e:	e04a                	sd	s2,0(sp)
    3060:	1000                	addi	s0,sp,32
    3062:	892a                	mv	s2,a0
  unlink("ff");
    3064:	00004517          	auipc	a0,0x4
    3068:	25450513          	addi	a0,a0,596 # 72b8 <longjmp_1+0x1708>
    306c:	00002097          	auipc	ra,0x2
    3070:	5f0080e7          	jalr	1520(ra) # 565c <unlink>
  if(mkdir("dd") != 0){
    3074:	00004517          	auipc	a0,0x4
    3078:	11450513          	addi	a0,a0,276 # 7188 <longjmp_1+0x15d8>
    307c:	00002097          	auipc	ra,0x2
    3080:	5f8080e7          	jalr	1528(ra) # 5674 <mkdir>
    3084:	38051663          	bnez	a0,3410 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    3088:	20200593          	li	a1,514
    308c:	00004517          	auipc	a0,0x4
    3090:	11c50513          	addi	a0,a0,284 # 71a8 <longjmp_1+0x15f8>
    3094:	00002097          	auipc	ra,0x2
    3098:	5b8080e7          	jalr	1464(ra) # 564c <open>
    309c:	84aa                	mv	s1,a0
  if(fd < 0){
    309e:	38054763          	bltz	a0,342c <subdir+0x3d6>
  write(fd, "ff", 2);
    30a2:	4609                	li	a2,2
    30a4:	00004597          	auipc	a1,0x4
    30a8:	21458593          	addi	a1,a1,532 # 72b8 <longjmp_1+0x1708>
    30ac:	00002097          	auipc	ra,0x2
    30b0:	580080e7          	jalr	1408(ra) # 562c <write>
  close(fd);
    30b4:	8526                	mv	a0,s1
    30b6:	00002097          	auipc	ra,0x2
    30ba:	57e080e7          	jalr	1406(ra) # 5634 <close>
  if(unlink("dd") >= 0){
    30be:	00004517          	auipc	a0,0x4
    30c2:	0ca50513          	addi	a0,a0,202 # 7188 <longjmp_1+0x15d8>
    30c6:	00002097          	auipc	ra,0x2
    30ca:	596080e7          	jalr	1430(ra) # 565c <unlink>
    30ce:	36055d63          	bgez	a0,3448 <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    30d2:	00004517          	auipc	a0,0x4
    30d6:	12e50513          	addi	a0,a0,302 # 7200 <longjmp_1+0x1650>
    30da:	00002097          	auipc	ra,0x2
    30de:	59a080e7          	jalr	1434(ra) # 5674 <mkdir>
    30e2:	38051163          	bnez	a0,3464 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    30e6:	20200593          	li	a1,514
    30ea:	00004517          	auipc	a0,0x4
    30ee:	13e50513          	addi	a0,a0,318 # 7228 <longjmp_1+0x1678>
    30f2:	00002097          	auipc	ra,0x2
    30f6:	55a080e7          	jalr	1370(ra) # 564c <open>
    30fa:	84aa                	mv	s1,a0
  if(fd < 0){
    30fc:	38054263          	bltz	a0,3480 <subdir+0x42a>
  write(fd, "FF", 2);
    3100:	4609                	li	a2,2
    3102:	00004597          	auipc	a1,0x4
    3106:	15658593          	addi	a1,a1,342 # 7258 <longjmp_1+0x16a8>
    310a:	00002097          	auipc	ra,0x2
    310e:	522080e7          	jalr	1314(ra) # 562c <write>
  close(fd);
    3112:	8526                	mv	a0,s1
    3114:	00002097          	auipc	ra,0x2
    3118:	520080e7          	jalr	1312(ra) # 5634 <close>
  fd = open("dd/dd/../ff", 0);
    311c:	4581                	li	a1,0
    311e:	00004517          	auipc	a0,0x4
    3122:	14250513          	addi	a0,a0,322 # 7260 <longjmp_1+0x16b0>
    3126:	00002097          	auipc	ra,0x2
    312a:	526080e7          	jalr	1318(ra) # 564c <open>
    312e:	84aa                	mv	s1,a0
  if(fd < 0){
    3130:	36054663          	bltz	a0,349c <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    3134:	660d                	lui	a2,0x3
    3136:	00009597          	auipc	a1,0x9
    313a:	9f258593          	addi	a1,a1,-1550 # bb28 <buf>
    313e:	00002097          	auipc	ra,0x2
    3142:	4e6080e7          	jalr	1254(ra) # 5624 <read>
  if(cc != 2 || buf[0] != 'f'){
    3146:	4789                	li	a5,2
    3148:	36f51863          	bne	a0,a5,34b8 <subdir+0x462>
    314c:	00009717          	auipc	a4,0x9
    3150:	9dc74703          	lbu	a4,-1572(a4) # bb28 <buf>
    3154:	06600793          	li	a5,102
    3158:	36f71063          	bne	a4,a5,34b8 <subdir+0x462>
  close(fd);
    315c:	8526                	mv	a0,s1
    315e:	00002097          	auipc	ra,0x2
    3162:	4d6080e7          	jalr	1238(ra) # 5634 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3166:	00004597          	auipc	a1,0x4
    316a:	14a58593          	addi	a1,a1,330 # 72b0 <longjmp_1+0x1700>
    316e:	00004517          	auipc	a0,0x4
    3172:	0ba50513          	addi	a0,a0,186 # 7228 <longjmp_1+0x1678>
    3176:	00002097          	auipc	ra,0x2
    317a:	4f6080e7          	jalr	1270(ra) # 566c <link>
    317e:	34051b63          	bnez	a0,34d4 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    3182:	00004517          	auipc	a0,0x4
    3186:	0a650513          	addi	a0,a0,166 # 7228 <longjmp_1+0x1678>
    318a:	00002097          	auipc	ra,0x2
    318e:	4d2080e7          	jalr	1234(ra) # 565c <unlink>
    3192:	34051f63          	bnez	a0,34f0 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3196:	4581                	li	a1,0
    3198:	00004517          	auipc	a0,0x4
    319c:	09050513          	addi	a0,a0,144 # 7228 <longjmp_1+0x1678>
    31a0:	00002097          	auipc	ra,0x2
    31a4:	4ac080e7          	jalr	1196(ra) # 564c <open>
    31a8:	36055263          	bgez	a0,350c <subdir+0x4b6>
  if(chdir("dd") != 0){
    31ac:	00004517          	auipc	a0,0x4
    31b0:	fdc50513          	addi	a0,a0,-36 # 7188 <longjmp_1+0x15d8>
    31b4:	00002097          	auipc	ra,0x2
    31b8:	4c8080e7          	jalr	1224(ra) # 567c <chdir>
    31bc:	36051663          	bnez	a0,3528 <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    31c0:	00004517          	auipc	a0,0x4
    31c4:	18850513          	addi	a0,a0,392 # 7348 <longjmp_1+0x1798>
    31c8:	00002097          	auipc	ra,0x2
    31cc:	4b4080e7          	jalr	1204(ra) # 567c <chdir>
    31d0:	36051a63          	bnez	a0,3544 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    31d4:	00004517          	auipc	a0,0x4
    31d8:	1a450513          	addi	a0,a0,420 # 7378 <longjmp_1+0x17c8>
    31dc:	00002097          	auipc	ra,0x2
    31e0:	4a0080e7          	jalr	1184(ra) # 567c <chdir>
    31e4:	36051e63          	bnez	a0,3560 <subdir+0x50a>
  if(chdir("./..") != 0){
    31e8:	00004517          	auipc	a0,0x4
    31ec:	1c050513          	addi	a0,a0,448 # 73a8 <longjmp_1+0x17f8>
    31f0:	00002097          	auipc	ra,0x2
    31f4:	48c080e7          	jalr	1164(ra) # 567c <chdir>
    31f8:	38051263          	bnez	a0,357c <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    31fc:	4581                	li	a1,0
    31fe:	00004517          	auipc	a0,0x4
    3202:	0b250513          	addi	a0,a0,178 # 72b0 <longjmp_1+0x1700>
    3206:	00002097          	auipc	ra,0x2
    320a:	446080e7          	jalr	1094(ra) # 564c <open>
    320e:	84aa                	mv	s1,a0
  if(fd < 0){
    3210:	38054463          	bltz	a0,3598 <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    3214:	660d                	lui	a2,0x3
    3216:	00009597          	auipc	a1,0x9
    321a:	91258593          	addi	a1,a1,-1774 # bb28 <buf>
    321e:	00002097          	auipc	ra,0x2
    3222:	406080e7          	jalr	1030(ra) # 5624 <read>
    3226:	4789                	li	a5,2
    3228:	38f51663          	bne	a0,a5,35b4 <subdir+0x55e>
  close(fd);
    322c:	8526                	mv	a0,s1
    322e:	00002097          	auipc	ra,0x2
    3232:	406080e7          	jalr	1030(ra) # 5634 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3236:	4581                	li	a1,0
    3238:	00004517          	auipc	a0,0x4
    323c:	ff050513          	addi	a0,a0,-16 # 7228 <longjmp_1+0x1678>
    3240:	00002097          	auipc	ra,0x2
    3244:	40c080e7          	jalr	1036(ra) # 564c <open>
    3248:	38055463          	bgez	a0,35d0 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    324c:	20200593          	li	a1,514
    3250:	00004517          	auipc	a0,0x4
    3254:	1e850513          	addi	a0,a0,488 # 7438 <longjmp_1+0x1888>
    3258:	00002097          	auipc	ra,0x2
    325c:	3f4080e7          	jalr	1012(ra) # 564c <open>
    3260:	38055663          	bgez	a0,35ec <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3264:	20200593          	li	a1,514
    3268:	00004517          	auipc	a0,0x4
    326c:	20050513          	addi	a0,a0,512 # 7468 <longjmp_1+0x18b8>
    3270:	00002097          	auipc	ra,0x2
    3274:	3dc080e7          	jalr	988(ra) # 564c <open>
    3278:	38055863          	bgez	a0,3608 <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    327c:	20000593          	li	a1,512
    3280:	00004517          	auipc	a0,0x4
    3284:	f0850513          	addi	a0,a0,-248 # 7188 <longjmp_1+0x15d8>
    3288:	00002097          	auipc	ra,0x2
    328c:	3c4080e7          	jalr	964(ra) # 564c <open>
    3290:	38055a63          	bgez	a0,3624 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    3294:	4589                	li	a1,2
    3296:	00004517          	auipc	a0,0x4
    329a:	ef250513          	addi	a0,a0,-270 # 7188 <longjmp_1+0x15d8>
    329e:	00002097          	auipc	ra,0x2
    32a2:	3ae080e7          	jalr	942(ra) # 564c <open>
    32a6:	38055d63          	bgez	a0,3640 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    32aa:	4585                	li	a1,1
    32ac:	00004517          	auipc	a0,0x4
    32b0:	edc50513          	addi	a0,a0,-292 # 7188 <longjmp_1+0x15d8>
    32b4:	00002097          	auipc	ra,0x2
    32b8:	398080e7          	jalr	920(ra) # 564c <open>
    32bc:	3a055063          	bgez	a0,365c <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    32c0:	00004597          	auipc	a1,0x4
    32c4:	23858593          	addi	a1,a1,568 # 74f8 <longjmp_1+0x1948>
    32c8:	00004517          	auipc	a0,0x4
    32cc:	17050513          	addi	a0,a0,368 # 7438 <longjmp_1+0x1888>
    32d0:	00002097          	auipc	ra,0x2
    32d4:	39c080e7          	jalr	924(ra) # 566c <link>
    32d8:	3a050063          	beqz	a0,3678 <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    32dc:	00004597          	auipc	a1,0x4
    32e0:	21c58593          	addi	a1,a1,540 # 74f8 <longjmp_1+0x1948>
    32e4:	00004517          	auipc	a0,0x4
    32e8:	18450513          	addi	a0,a0,388 # 7468 <longjmp_1+0x18b8>
    32ec:	00002097          	auipc	ra,0x2
    32f0:	380080e7          	jalr	896(ra) # 566c <link>
    32f4:	3a050063          	beqz	a0,3694 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    32f8:	00004597          	auipc	a1,0x4
    32fc:	fb858593          	addi	a1,a1,-72 # 72b0 <longjmp_1+0x1700>
    3300:	00004517          	auipc	a0,0x4
    3304:	ea850513          	addi	a0,a0,-344 # 71a8 <longjmp_1+0x15f8>
    3308:	00002097          	auipc	ra,0x2
    330c:	364080e7          	jalr	868(ra) # 566c <link>
    3310:	3a050063          	beqz	a0,36b0 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    3314:	00004517          	auipc	a0,0x4
    3318:	12450513          	addi	a0,a0,292 # 7438 <longjmp_1+0x1888>
    331c:	00002097          	auipc	ra,0x2
    3320:	358080e7          	jalr	856(ra) # 5674 <mkdir>
    3324:	3a050463          	beqz	a0,36cc <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    3328:	00004517          	auipc	a0,0x4
    332c:	14050513          	addi	a0,a0,320 # 7468 <longjmp_1+0x18b8>
    3330:	00002097          	auipc	ra,0x2
    3334:	344080e7          	jalr	836(ra) # 5674 <mkdir>
    3338:	3a050863          	beqz	a0,36e8 <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    333c:	00004517          	auipc	a0,0x4
    3340:	f7450513          	addi	a0,a0,-140 # 72b0 <longjmp_1+0x1700>
    3344:	00002097          	auipc	ra,0x2
    3348:	330080e7          	jalr	816(ra) # 5674 <mkdir>
    334c:	3a050c63          	beqz	a0,3704 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3350:	00004517          	auipc	a0,0x4
    3354:	11850513          	addi	a0,a0,280 # 7468 <longjmp_1+0x18b8>
    3358:	00002097          	auipc	ra,0x2
    335c:	304080e7          	jalr	772(ra) # 565c <unlink>
    3360:	3c050063          	beqz	a0,3720 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    3364:	00004517          	auipc	a0,0x4
    3368:	0d450513          	addi	a0,a0,212 # 7438 <longjmp_1+0x1888>
    336c:	00002097          	auipc	ra,0x2
    3370:	2f0080e7          	jalr	752(ra) # 565c <unlink>
    3374:	3c050463          	beqz	a0,373c <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    3378:	00004517          	auipc	a0,0x4
    337c:	e3050513          	addi	a0,a0,-464 # 71a8 <longjmp_1+0x15f8>
    3380:	00002097          	auipc	ra,0x2
    3384:	2fc080e7          	jalr	764(ra) # 567c <chdir>
    3388:	3c050863          	beqz	a0,3758 <subdir+0x702>
  if(chdir("dd/xx") == 0){
    338c:	00004517          	auipc	a0,0x4
    3390:	2bc50513          	addi	a0,a0,700 # 7648 <longjmp_1+0x1a98>
    3394:	00002097          	auipc	ra,0x2
    3398:	2e8080e7          	jalr	744(ra) # 567c <chdir>
    339c:	3c050c63          	beqz	a0,3774 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    33a0:	00004517          	auipc	a0,0x4
    33a4:	f1050513          	addi	a0,a0,-240 # 72b0 <longjmp_1+0x1700>
    33a8:	00002097          	auipc	ra,0x2
    33ac:	2b4080e7          	jalr	692(ra) # 565c <unlink>
    33b0:	3e051063          	bnez	a0,3790 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    33b4:	00004517          	auipc	a0,0x4
    33b8:	df450513          	addi	a0,a0,-524 # 71a8 <longjmp_1+0x15f8>
    33bc:	00002097          	auipc	ra,0x2
    33c0:	2a0080e7          	jalr	672(ra) # 565c <unlink>
    33c4:	3e051463          	bnez	a0,37ac <subdir+0x756>
  if(unlink("dd") == 0){
    33c8:	00004517          	auipc	a0,0x4
    33cc:	dc050513          	addi	a0,a0,-576 # 7188 <longjmp_1+0x15d8>
    33d0:	00002097          	auipc	ra,0x2
    33d4:	28c080e7          	jalr	652(ra) # 565c <unlink>
    33d8:	3e050863          	beqz	a0,37c8 <subdir+0x772>
  if(unlink("dd/dd") < 0){
    33dc:	00004517          	auipc	a0,0x4
    33e0:	2dc50513          	addi	a0,a0,732 # 76b8 <longjmp_1+0x1b08>
    33e4:	00002097          	auipc	ra,0x2
    33e8:	278080e7          	jalr	632(ra) # 565c <unlink>
    33ec:	3e054c63          	bltz	a0,37e4 <subdir+0x78e>
  if(unlink("dd") < 0){
    33f0:	00004517          	auipc	a0,0x4
    33f4:	d9850513          	addi	a0,a0,-616 # 7188 <longjmp_1+0x15d8>
    33f8:	00002097          	auipc	ra,0x2
    33fc:	264080e7          	jalr	612(ra) # 565c <unlink>
    3400:	40054063          	bltz	a0,3800 <subdir+0x7aa>
}
    3404:	60e2                	ld	ra,24(sp)
    3406:	6442                	ld	s0,16(sp)
    3408:	64a2                	ld	s1,8(sp)
    340a:	6902                	ld	s2,0(sp)
    340c:	6105                	addi	sp,sp,32
    340e:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3410:	85ca                	mv	a1,s2
    3412:	00004517          	auipc	a0,0x4
    3416:	d7e50513          	addi	a0,a0,-642 # 7190 <longjmp_1+0x15e0>
    341a:	00002097          	auipc	ra,0x2
    341e:	582080e7          	jalr	1410(ra) # 599c <printf>
    exit(1);
    3422:	4505                	li	a0,1
    3424:	00002097          	auipc	ra,0x2
    3428:	1e8080e7          	jalr	488(ra) # 560c <exit>
    printf("%s: create dd/ff failed\n", s);
    342c:	85ca                	mv	a1,s2
    342e:	00004517          	auipc	a0,0x4
    3432:	d8250513          	addi	a0,a0,-638 # 71b0 <longjmp_1+0x1600>
    3436:	00002097          	auipc	ra,0x2
    343a:	566080e7          	jalr	1382(ra) # 599c <printf>
    exit(1);
    343e:	4505                	li	a0,1
    3440:	00002097          	auipc	ra,0x2
    3444:	1cc080e7          	jalr	460(ra) # 560c <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3448:	85ca                	mv	a1,s2
    344a:	00004517          	auipc	a0,0x4
    344e:	d8650513          	addi	a0,a0,-634 # 71d0 <longjmp_1+0x1620>
    3452:	00002097          	auipc	ra,0x2
    3456:	54a080e7          	jalr	1354(ra) # 599c <printf>
    exit(1);
    345a:	4505                	li	a0,1
    345c:	00002097          	auipc	ra,0x2
    3460:	1b0080e7          	jalr	432(ra) # 560c <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3464:	85ca                	mv	a1,s2
    3466:	00004517          	auipc	a0,0x4
    346a:	da250513          	addi	a0,a0,-606 # 7208 <longjmp_1+0x1658>
    346e:	00002097          	auipc	ra,0x2
    3472:	52e080e7          	jalr	1326(ra) # 599c <printf>
    exit(1);
    3476:	4505                	li	a0,1
    3478:	00002097          	auipc	ra,0x2
    347c:	194080e7          	jalr	404(ra) # 560c <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3480:	85ca                	mv	a1,s2
    3482:	00004517          	auipc	a0,0x4
    3486:	db650513          	addi	a0,a0,-586 # 7238 <longjmp_1+0x1688>
    348a:	00002097          	auipc	ra,0x2
    348e:	512080e7          	jalr	1298(ra) # 599c <printf>
    exit(1);
    3492:	4505                	li	a0,1
    3494:	00002097          	auipc	ra,0x2
    3498:	178080e7          	jalr	376(ra) # 560c <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    349c:	85ca                	mv	a1,s2
    349e:	00004517          	auipc	a0,0x4
    34a2:	dd250513          	addi	a0,a0,-558 # 7270 <longjmp_1+0x16c0>
    34a6:	00002097          	auipc	ra,0x2
    34aa:	4f6080e7          	jalr	1270(ra) # 599c <printf>
    exit(1);
    34ae:	4505                	li	a0,1
    34b0:	00002097          	auipc	ra,0x2
    34b4:	15c080e7          	jalr	348(ra) # 560c <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    34b8:	85ca                	mv	a1,s2
    34ba:	00004517          	auipc	a0,0x4
    34be:	dd650513          	addi	a0,a0,-554 # 7290 <longjmp_1+0x16e0>
    34c2:	00002097          	auipc	ra,0x2
    34c6:	4da080e7          	jalr	1242(ra) # 599c <printf>
    exit(1);
    34ca:	4505                	li	a0,1
    34cc:	00002097          	auipc	ra,0x2
    34d0:	140080e7          	jalr	320(ra) # 560c <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    34d4:	85ca                	mv	a1,s2
    34d6:	00004517          	auipc	a0,0x4
    34da:	dea50513          	addi	a0,a0,-534 # 72c0 <longjmp_1+0x1710>
    34de:	00002097          	auipc	ra,0x2
    34e2:	4be080e7          	jalr	1214(ra) # 599c <printf>
    exit(1);
    34e6:	4505                	li	a0,1
    34e8:	00002097          	auipc	ra,0x2
    34ec:	124080e7          	jalr	292(ra) # 560c <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    34f0:	85ca                	mv	a1,s2
    34f2:	00004517          	auipc	a0,0x4
    34f6:	df650513          	addi	a0,a0,-522 # 72e8 <longjmp_1+0x1738>
    34fa:	00002097          	auipc	ra,0x2
    34fe:	4a2080e7          	jalr	1186(ra) # 599c <printf>
    exit(1);
    3502:	4505                	li	a0,1
    3504:	00002097          	auipc	ra,0x2
    3508:	108080e7          	jalr	264(ra) # 560c <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    350c:	85ca                	mv	a1,s2
    350e:	00004517          	auipc	a0,0x4
    3512:	dfa50513          	addi	a0,a0,-518 # 7308 <longjmp_1+0x1758>
    3516:	00002097          	auipc	ra,0x2
    351a:	486080e7          	jalr	1158(ra) # 599c <printf>
    exit(1);
    351e:	4505                	li	a0,1
    3520:	00002097          	auipc	ra,0x2
    3524:	0ec080e7          	jalr	236(ra) # 560c <exit>
    printf("%s: chdir dd failed\n", s);
    3528:	85ca                	mv	a1,s2
    352a:	00004517          	auipc	a0,0x4
    352e:	e0650513          	addi	a0,a0,-506 # 7330 <longjmp_1+0x1780>
    3532:	00002097          	auipc	ra,0x2
    3536:	46a080e7          	jalr	1130(ra) # 599c <printf>
    exit(1);
    353a:	4505                	li	a0,1
    353c:	00002097          	auipc	ra,0x2
    3540:	0d0080e7          	jalr	208(ra) # 560c <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3544:	85ca                	mv	a1,s2
    3546:	00004517          	auipc	a0,0x4
    354a:	e1250513          	addi	a0,a0,-494 # 7358 <longjmp_1+0x17a8>
    354e:	00002097          	auipc	ra,0x2
    3552:	44e080e7          	jalr	1102(ra) # 599c <printf>
    exit(1);
    3556:	4505                	li	a0,1
    3558:	00002097          	auipc	ra,0x2
    355c:	0b4080e7          	jalr	180(ra) # 560c <exit>
    printf("chdir dd/../../dd failed\n", s);
    3560:	85ca                	mv	a1,s2
    3562:	00004517          	auipc	a0,0x4
    3566:	e2650513          	addi	a0,a0,-474 # 7388 <longjmp_1+0x17d8>
    356a:	00002097          	auipc	ra,0x2
    356e:	432080e7          	jalr	1074(ra) # 599c <printf>
    exit(1);
    3572:	4505                	li	a0,1
    3574:	00002097          	auipc	ra,0x2
    3578:	098080e7          	jalr	152(ra) # 560c <exit>
    printf("%s: chdir ./.. failed\n", s);
    357c:	85ca                	mv	a1,s2
    357e:	00004517          	auipc	a0,0x4
    3582:	e3250513          	addi	a0,a0,-462 # 73b0 <longjmp_1+0x1800>
    3586:	00002097          	auipc	ra,0x2
    358a:	416080e7          	jalr	1046(ra) # 599c <printf>
    exit(1);
    358e:	4505                	li	a0,1
    3590:	00002097          	auipc	ra,0x2
    3594:	07c080e7          	jalr	124(ra) # 560c <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3598:	85ca                	mv	a1,s2
    359a:	00004517          	auipc	a0,0x4
    359e:	e2e50513          	addi	a0,a0,-466 # 73c8 <longjmp_1+0x1818>
    35a2:	00002097          	auipc	ra,0x2
    35a6:	3fa080e7          	jalr	1018(ra) # 599c <printf>
    exit(1);
    35aa:	4505                	li	a0,1
    35ac:	00002097          	auipc	ra,0x2
    35b0:	060080e7          	jalr	96(ra) # 560c <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    35b4:	85ca                	mv	a1,s2
    35b6:	00004517          	auipc	a0,0x4
    35ba:	e3250513          	addi	a0,a0,-462 # 73e8 <longjmp_1+0x1838>
    35be:	00002097          	auipc	ra,0x2
    35c2:	3de080e7          	jalr	990(ra) # 599c <printf>
    exit(1);
    35c6:	4505                	li	a0,1
    35c8:	00002097          	auipc	ra,0x2
    35cc:	044080e7          	jalr	68(ra) # 560c <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    35d0:	85ca                	mv	a1,s2
    35d2:	00004517          	auipc	a0,0x4
    35d6:	e3650513          	addi	a0,a0,-458 # 7408 <longjmp_1+0x1858>
    35da:	00002097          	auipc	ra,0x2
    35de:	3c2080e7          	jalr	962(ra) # 599c <printf>
    exit(1);
    35e2:	4505                	li	a0,1
    35e4:	00002097          	auipc	ra,0x2
    35e8:	028080e7          	jalr	40(ra) # 560c <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    35ec:	85ca                	mv	a1,s2
    35ee:	00004517          	auipc	a0,0x4
    35f2:	e5a50513          	addi	a0,a0,-422 # 7448 <longjmp_1+0x1898>
    35f6:	00002097          	auipc	ra,0x2
    35fa:	3a6080e7          	jalr	934(ra) # 599c <printf>
    exit(1);
    35fe:	4505                	li	a0,1
    3600:	00002097          	auipc	ra,0x2
    3604:	00c080e7          	jalr	12(ra) # 560c <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3608:	85ca                	mv	a1,s2
    360a:	00004517          	auipc	a0,0x4
    360e:	e6e50513          	addi	a0,a0,-402 # 7478 <longjmp_1+0x18c8>
    3612:	00002097          	auipc	ra,0x2
    3616:	38a080e7          	jalr	906(ra) # 599c <printf>
    exit(1);
    361a:	4505                	li	a0,1
    361c:	00002097          	auipc	ra,0x2
    3620:	ff0080e7          	jalr	-16(ra) # 560c <exit>
    printf("%s: create dd succeeded!\n", s);
    3624:	85ca                	mv	a1,s2
    3626:	00004517          	auipc	a0,0x4
    362a:	e7250513          	addi	a0,a0,-398 # 7498 <longjmp_1+0x18e8>
    362e:	00002097          	auipc	ra,0x2
    3632:	36e080e7          	jalr	878(ra) # 599c <printf>
    exit(1);
    3636:	4505                	li	a0,1
    3638:	00002097          	auipc	ra,0x2
    363c:	fd4080e7          	jalr	-44(ra) # 560c <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3640:	85ca                	mv	a1,s2
    3642:	00004517          	auipc	a0,0x4
    3646:	e7650513          	addi	a0,a0,-394 # 74b8 <longjmp_1+0x1908>
    364a:	00002097          	auipc	ra,0x2
    364e:	352080e7          	jalr	850(ra) # 599c <printf>
    exit(1);
    3652:	4505                	li	a0,1
    3654:	00002097          	auipc	ra,0x2
    3658:	fb8080e7          	jalr	-72(ra) # 560c <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    365c:	85ca                	mv	a1,s2
    365e:	00004517          	auipc	a0,0x4
    3662:	e7a50513          	addi	a0,a0,-390 # 74d8 <longjmp_1+0x1928>
    3666:	00002097          	auipc	ra,0x2
    366a:	336080e7          	jalr	822(ra) # 599c <printf>
    exit(1);
    366e:	4505                	li	a0,1
    3670:	00002097          	auipc	ra,0x2
    3674:	f9c080e7          	jalr	-100(ra) # 560c <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3678:	85ca                	mv	a1,s2
    367a:	00004517          	auipc	a0,0x4
    367e:	e8e50513          	addi	a0,a0,-370 # 7508 <longjmp_1+0x1958>
    3682:	00002097          	auipc	ra,0x2
    3686:	31a080e7          	jalr	794(ra) # 599c <printf>
    exit(1);
    368a:	4505                	li	a0,1
    368c:	00002097          	auipc	ra,0x2
    3690:	f80080e7          	jalr	-128(ra) # 560c <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3694:	85ca                	mv	a1,s2
    3696:	00004517          	auipc	a0,0x4
    369a:	e9a50513          	addi	a0,a0,-358 # 7530 <longjmp_1+0x1980>
    369e:	00002097          	auipc	ra,0x2
    36a2:	2fe080e7          	jalr	766(ra) # 599c <printf>
    exit(1);
    36a6:	4505                	li	a0,1
    36a8:	00002097          	auipc	ra,0x2
    36ac:	f64080e7          	jalr	-156(ra) # 560c <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    36b0:	85ca                	mv	a1,s2
    36b2:	00004517          	auipc	a0,0x4
    36b6:	ea650513          	addi	a0,a0,-346 # 7558 <longjmp_1+0x19a8>
    36ba:	00002097          	auipc	ra,0x2
    36be:	2e2080e7          	jalr	738(ra) # 599c <printf>
    exit(1);
    36c2:	4505                	li	a0,1
    36c4:	00002097          	auipc	ra,0x2
    36c8:	f48080e7          	jalr	-184(ra) # 560c <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    36cc:	85ca                	mv	a1,s2
    36ce:	00004517          	auipc	a0,0x4
    36d2:	eb250513          	addi	a0,a0,-334 # 7580 <longjmp_1+0x19d0>
    36d6:	00002097          	auipc	ra,0x2
    36da:	2c6080e7          	jalr	710(ra) # 599c <printf>
    exit(1);
    36de:	4505                	li	a0,1
    36e0:	00002097          	auipc	ra,0x2
    36e4:	f2c080e7          	jalr	-212(ra) # 560c <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    36e8:	85ca                	mv	a1,s2
    36ea:	00004517          	auipc	a0,0x4
    36ee:	eb650513          	addi	a0,a0,-330 # 75a0 <longjmp_1+0x19f0>
    36f2:	00002097          	auipc	ra,0x2
    36f6:	2aa080e7          	jalr	682(ra) # 599c <printf>
    exit(1);
    36fa:	4505                	li	a0,1
    36fc:	00002097          	auipc	ra,0x2
    3700:	f10080e7          	jalr	-240(ra) # 560c <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3704:	85ca                	mv	a1,s2
    3706:	00004517          	auipc	a0,0x4
    370a:	eba50513          	addi	a0,a0,-326 # 75c0 <longjmp_1+0x1a10>
    370e:	00002097          	auipc	ra,0x2
    3712:	28e080e7          	jalr	654(ra) # 599c <printf>
    exit(1);
    3716:	4505                	li	a0,1
    3718:	00002097          	auipc	ra,0x2
    371c:	ef4080e7          	jalr	-268(ra) # 560c <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3720:	85ca                	mv	a1,s2
    3722:	00004517          	auipc	a0,0x4
    3726:	ec650513          	addi	a0,a0,-314 # 75e8 <longjmp_1+0x1a38>
    372a:	00002097          	auipc	ra,0x2
    372e:	272080e7          	jalr	626(ra) # 599c <printf>
    exit(1);
    3732:	4505                	li	a0,1
    3734:	00002097          	auipc	ra,0x2
    3738:	ed8080e7          	jalr	-296(ra) # 560c <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    373c:	85ca                	mv	a1,s2
    373e:	00004517          	auipc	a0,0x4
    3742:	eca50513          	addi	a0,a0,-310 # 7608 <longjmp_1+0x1a58>
    3746:	00002097          	auipc	ra,0x2
    374a:	256080e7          	jalr	598(ra) # 599c <printf>
    exit(1);
    374e:	4505                	li	a0,1
    3750:	00002097          	auipc	ra,0x2
    3754:	ebc080e7          	jalr	-324(ra) # 560c <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3758:	85ca                	mv	a1,s2
    375a:	00004517          	auipc	a0,0x4
    375e:	ece50513          	addi	a0,a0,-306 # 7628 <longjmp_1+0x1a78>
    3762:	00002097          	auipc	ra,0x2
    3766:	23a080e7          	jalr	570(ra) # 599c <printf>
    exit(1);
    376a:	4505                	li	a0,1
    376c:	00002097          	auipc	ra,0x2
    3770:	ea0080e7          	jalr	-352(ra) # 560c <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3774:	85ca                	mv	a1,s2
    3776:	00004517          	auipc	a0,0x4
    377a:	eda50513          	addi	a0,a0,-294 # 7650 <longjmp_1+0x1aa0>
    377e:	00002097          	auipc	ra,0x2
    3782:	21e080e7          	jalr	542(ra) # 599c <printf>
    exit(1);
    3786:	4505                	li	a0,1
    3788:	00002097          	auipc	ra,0x2
    378c:	e84080e7          	jalr	-380(ra) # 560c <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3790:	85ca                	mv	a1,s2
    3792:	00004517          	auipc	a0,0x4
    3796:	b5650513          	addi	a0,a0,-1194 # 72e8 <longjmp_1+0x1738>
    379a:	00002097          	auipc	ra,0x2
    379e:	202080e7          	jalr	514(ra) # 599c <printf>
    exit(1);
    37a2:	4505                	li	a0,1
    37a4:	00002097          	auipc	ra,0x2
    37a8:	e68080e7          	jalr	-408(ra) # 560c <exit>
    printf("%s: unlink dd/ff failed\n", s);
    37ac:	85ca                	mv	a1,s2
    37ae:	00004517          	auipc	a0,0x4
    37b2:	ec250513          	addi	a0,a0,-318 # 7670 <longjmp_1+0x1ac0>
    37b6:	00002097          	auipc	ra,0x2
    37ba:	1e6080e7          	jalr	486(ra) # 599c <printf>
    exit(1);
    37be:	4505                	li	a0,1
    37c0:	00002097          	auipc	ra,0x2
    37c4:	e4c080e7          	jalr	-436(ra) # 560c <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    37c8:	85ca                	mv	a1,s2
    37ca:	00004517          	auipc	a0,0x4
    37ce:	ec650513          	addi	a0,a0,-314 # 7690 <longjmp_1+0x1ae0>
    37d2:	00002097          	auipc	ra,0x2
    37d6:	1ca080e7          	jalr	458(ra) # 599c <printf>
    exit(1);
    37da:	4505                	li	a0,1
    37dc:	00002097          	auipc	ra,0x2
    37e0:	e30080e7          	jalr	-464(ra) # 560c <exit>
    printf("%s: unlink dd/dd failed\n", s);
    37e4:	85ca                	mv	a1,s2
    37e6:	00004517          	auipc	a0,0x4
    37ea:	eda50513          	addi	a0,a0,-294 # 76c0 <longjmp_1+0x1b10>
    37ee:	00002097          	auipc	ra,0x2
    37f2:	1ae080e7          	jalr	430(ra) # 599c <printf>
    exit(1);
    37f6:	4505                	li	a0,1
    37f8:	00002097          	auipc	ra,0x2
    37fc:	e14080e7          	jalr	-492(ra) # 560c <exit>
    printf("%s: unlink dd failed\n", s);
    3800:	85ca                	mv	a1,s2
    3802:	00004517          	auipc	a0,0x4
    3806:	ede50513          	addi	a0,a0,-290 # 76e0 <longjmp_1+0x1b30>
    380a:	00002097          	auipc	ra,0x2
    380e:	192080e7          	jalr	402(ra) # 599c <printf>
    exit(1);
    3812:	4505                	li	a0,1
    3814:	00002097          	auipc	ra,0x2
    3818:	df8080e7          	jalr	-520(ra) # 560c <exit>

000000000000381c <rmdot>:
{
    381c:	1101                	addi	sp,sp,-32
    381e:	ec06                	sd	ra,24(sp)
    3820:	e822                	sd	s0,16(sp)
    3822:	e426                	sd	s1,8(sp)
    3824:	1000                	addi	s0,sp,32
    3826:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3828:	00004517          	auipc	a0,0x4
    382c:	ed050513          	addi	a0,a0,-304 # 76f8 <longjmp_1+0x1b48>
    3830:	00002097          	auipc	ra,0x2
    3834:	e44080e7          	jalr	-444(ra) # 5674 <mkdir>
    3838:	e549                	bnez	a0,38c2 <rmdot+0xa6>
  if(chdir("dots") != 0){
    383a:	00004517          	auipc	a0,0x4
    383e:	ebe50513          	addi	a0,a0,-322 # 76f8 <longjmp_1+0x1b48>
    3842:	00002097          	auipc	ra,0x2
    3846:	e3a080e7          	jalr	-454(ra) # 567c <chdir>
    384a:	e951                	bnez	a0,38de <rmdot+0xc2>
  if(unlink(".") == 0){
    384c:	00003517          	auipc	a0,0x3
    3850:	d5c50513          	addi	a0,a0,-676 # 65a8 <longjmp_1+0x9f8>
    3854:	00002097          	auipc	ra,0x2
    3858:	e08080e7          	jalr	-504(ra) # 565c <unlink>
    385c:	cd59                	beqz	a0,38fa <rmdot+0xde>
  if(unlink("..") == 0){
    385e:	00004517          	auipc	a0,0x4
    3862:	8f250513          	addi	a0,a0,-1806 # 7150 <longjmp_1+0x15a0>
    3866:	00002097          	auipc	ra,0x2
    386a:	df6080e7          	jalr	-522(ra) # 565c <unlink>
    386e:	c545                	beqz	a0,3916 <rmdot+0xfa>
  if(chdir("/") != 0){
    3870:	00004517          	auipc	a0,0x4
    3874:	88850513          	addi	a0,a0,-1912 # 70f8 <longjmp_1+0x1548>
    3878:	00002097          	auipc	ra,0x2
    387c:	e04080e7          	jalr	-508(ra) # 567c <chdir>
    3880:	e94d                	bnez	a0,3932 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3882:	00004517          	auipc	a0,0x4
    3886:	ede50513          	addi	a0,a0,-290 # 7760 <longjmp_1+0x1bb0>
    388a:	00002097          	auipc	ra,0x2
    388e:	dd2080e7          	jalr	-558(ra) # 565c <unlink>
    3892:	cd55                	beqz	a0,394e <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3894:	00004517          	auipc	a0,0x4
    3898:	ef450513          	addi	a0,a0,-268 # 7788 <longjmp_1+0x1bd8>
    389c:	00002097          	auipc	ra,0x2
    38a0:	dc0080e7          	jalr	-576(ra) # 565c <unlink>
    38a4:	c179                	beqz	a0,396a <rmdot+0x14e>
  if(unlink("dots") != 0){
    38a6:	00004517          	auipc	a0,0x4
    38aa:	e5250513          	addi	a0,a0,-430 # 76f8 <longjmp_1+0x1b48>
    38ae:	00002097          	auipc	ra,0x2
    38b2:	dae080e7          	jalr	-594(ra) # 565c <unlink>
    38b6:	e961                	bnez	a0,3986 <rmdot+0x16a>
}
    38b8:	60e2                	ld	ra,24(sp)
    38ba:	6442                	ld	s0,16(sp)
    38bc:	64a2                	ld	s1,8(sp)
    38be:	6105                	addi	sp,sp,32
    38c0:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    38c2:	85a6                	mv	a1,s1
    38c4:	00004517          	auipc	a0,0x4
    38c8:	e3c50513          	addi	a0,a0,-452 # 7700 <longjmp_1+0x1b50>
    38cc:	00002097          	auipc	ra,0x2
    38d0:	0d0080e7          	jalr	208(ra) # 599c <printf>
    exit(1);
    38d4:	4505                	li	a0,1
    38d6:	00002097          	auipc	ra,0x2
    38da:	d36080e7          	jalr	-714(ra) # 560c <exit>
    printf("%s: chdir dots failed\n", s);
    38de:	85a6                	mv	a1,s1
    38e0:	00004517          	auipc	a0,0x4
    38e4:	e3850513          	addi	a0,a0,-456 # 7718 <longjmp_1+0x1b68>
    38e8:	00002097          	auipc	ra,0x2
    38ec:	0b4080e7          	jalr	180(ra) # 599c <printf>
    exit(1);
    38f0:	4505                	li	a0,1
    38f2:	00002097          	auipc	ra,0x2
    38f6:	d1a080e7          	jalr	-742(ra) # 560c <exit>
    printf("%s: rm . worked!\n", s);
    38fa:	85a6                	mv	a1,s1
    38fc:	00004517          	auipc	a0,0x4
    3900:	e3450513          	addi	a0,a0,-460 # 7730 <longjmp_1+0x1b80>
    3904:	00002097          	auipc	ra,0x2
    3908:	098080e7          	jalr	152(ra) # 599c <printf>
    exit(1);
    390c:	4505                	li	a0,1
    390e:	00002097          	auipc	ra,0x2
    3912:	cfe080e7          	jalr	-770(ra) # 560c <exit>
    printf("%s: rm .. worked!\n", s);
    3916:	85a6                	mv	a1,s1
    3918:	00004517          	auipc	a0,0x4
    391c:	e3050513          	addi	a0,a0,-464 # 7748 <longjmp_1+0x1b98>
    3920:	00002097          	auipc	ra,0x2
    3924:	07c080e7          	jalr	124(ra) # 599c <printf>
    exit(1);
    3928:	4505                	li	a0,1
    392a:	00002097          	auipc	ra,0x2
    392e:	ce2080e7          	jalr	-798(ra) # 560c <exit>
    printf("%s: chdir / failed\n", s);
    3932:	85a6                	mv	a1,s1
    3934:	00003517          	auipc	a0,0x3
    3938:	7cc50513          	addi	a0,a0,1996 # 7100 <longjmp_1+0x1550>
    393c:	00002097          	auipc	ra,0x2
    3940:	060080e7          	jalr	96(ra) # 599c <printf>
    exit(1);
    3944:	4505                	li	a0,1
    3946:	00002097          	auipc	ra,0x2
    394a:	cc6080e7          	jalr	-826(ra) # 560c <exit>
    printf("%s: unlink dots/. worked!\n", s);
    394e:	85a6                	mv	a1,s1
    3950:	00004517          	auipc	a0,0x4
    3954:	e1850513          	addi	a0,a0,-488 # 7768 <longjmp_1+0x1bb8>
    3958:	00002097          	auipc	ra,0x2
    395c:	044080e7          	jalr	68(ra) # 599c <printf>
    exit(1);
    3960:	4505                	li	a0,1
    3962:	00002097          	auipc	ra,0x2
    3966:	caa080e7          	jalr	-854(ra) # 560c <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    396a:	85a6                	mv	a1,s1
    396c:	00004517          	auipc	a0,0x4
    3970:	e2450513          	addi	a0,a0,-476 # 7790 <longjmp_1+0x1be0>
    3974:	00002097          	auipc	ra,0x2
    3978:	028080e7          	jalr	40(ra) # 599c <printf>
    exit(1);
    397c:	4505                	li	a0,1
    397e:	00002097          	auipc	ra,0x2
    3982:	c8e080e7          	jalr	-882(ra) # 560c <exit>
    printf("%s: unlink dots failed!\n", s);
    3986:	85a6                	mv	a1,s1
    3988:	00004517          	auipc	a0,0x4
    398c:	e2850513          	addi	a0,a0,-472 # 77b0 <longjmp_1+0x1c00>
    3990:	00002097          	auipc	ra,0x2
    3994:	00c080e7          	jalr	12(ra) # 599c <printf>
    exit(1);
    3998:	4505                	li	a0,1
    399a:	00002097          	auipc	ra,0x2
    399e:	c72080e7          	jalr	-910(ra) # 560c <exit>

00000000000039a2 <dirfile>:
{
    39a2:	1101                	addi	sp,sp,-32
    39a4:	ec06                	sd	ra,24(sp)
    39a6:	e822                	sd	s0,16(sp)
    39a8:	e426                	sd	s1,8(sp)
    39aa:	e04a                	sd	s2,0(sp)
    39ac:	1000                	addi	s0,sp,32
    39ae:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    39b0:	20000593          	li	a1,512
    39b4:	00002517          	auipc	a0,0x2
    39b8:	4fc50513          	addi	a0,a0,1276 # 5eb0 <longjmp_1+0x300>
    39bc:	00002097          	auipc	ra,0x2
    39c0:	c90080e7          	jalr	-880(ra) # 564c <open>
  if(fd < 0){
    39c4:	0e054d63          	bltz	a0,3abe <dirfile+0x11c>
  close(fd);
    39c8:	00002097          	auipc	ra,0x2
    39cc:	c6c080e7          	jalr	-916(ra) # 5634 <close>
  if(chdir("dirfile") == 0){
    39d0:	00002517          	auipc	a0,0x2
    39d4:	4e050513          	addi	a0,a0,1248 # 5eb0 <longjmp_1+0x300>
    39d8:	00002097          	auipc	ra,0x2
    39dc:	ca4080e7          	jalr	-860(ra) # 567c <chdir>
    39e0:	cd6d                	beqz	a0,3ada <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    39e2:	4581                	li	a1,0
    39e4:	00004517          	auipc	a0,0x4
    39e8:	e2c50513          	addi	a0,a0,-468 # 7810 <longjmp_1+0x1c60>
    39ec:	00002097          	auipc	ra,0x2
    39f0:	c60080e7          	jalr	-928(ra) # 564c <open>
  if(fd >= 0){
    39f4:	10055163          	bgez	a0,3af6 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    39f8:	20000593          	li	a1,512
    39fc:	00004517          	auipc	a0,0x4
    3a00:	e1450513          	addi	a0,a0,-492 # 7810 <longjmp_1+0x1c60>
    3a04:	00002097          	auipc	ra,0x2
    3a08:	c48080e7          	jalr	-952(ra) # 564c <open>
  if(fd >= 0){
    3a0c:	10055363          	bgez	a0,3b12 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    3a10:	00004517          	auipc	a0,0x4
    3a14:	e0050513          	addi	a0,a0,-512 # 7810 <longjmp_1+0x1c60>
    3a18:	00002097          	auipc	ra,0x2
    3a1c:	c5c080e7          	jalr	-932(ra) # 5674 <mkdir>
    3a20:	10050763          	beqz	a0,3b2e <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3a24:	00004517          	auipc	a0,0x4
    3a28:	dec50513          	addi	a0,a0,-532 # 7810 <longjmp_1+0x1c60>
    3a2c:	00002097          	auipc	ra,0x2
    3a30:	c30080e7          	jalr	-976(ra) # 565c <unlink>
    3a34:	10050b63          	beqz	a0,3b4a <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3a38:	00004597          	auipc	a1,0x4
    3a3c:	dd858593          	addi	a1,a1,-552 # 7810 <longjmp_1+0x1c60>
    3a40:	00002517          	auipc	a0,0x2
    3a44:	66850513          	addi	a0,a0,1640 # 60a8 <longjmp_1+0x4f8>
    3a48:	00002097          	auipc	ra,0x2
    3a4c:	c24080e7          	jalr	-988(ra) # 566c <link>
    3a50:	10050b63          	beqz	a0,3b66 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3a54:	00002517          	auipc	a0,0x2
    3a58:	45c50513          	addi	a0,a0,1116 # 5eb0 <longjmp_1+0x300>
    3a5c:	00002097          	auipc	ra,0x2
    3a60:	c00080e7          	jalr	-1024(ra) # 565c <unlink>
    3a64:	10051f63          	bnez	a0,3b82 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3a68:	4589                	li	a1,2
    3a6a:	00003517          	auipc	a0,0x3
    3a6e:	b3e50513          	addi	a0,a0,-1218 # 65a8 <longjmp_1+0x9f8>
    3a72:	00002097          	auipc	ra,0x2
    3a76:	bda080e7          	jalr	-1062(ra) # 564c <open>
  if(fd >= 0){
    3a7a:	12055263          	bgez	a0,3b9e <dirfile+0x1fc>
  fd = open(".", 0);
    3a7e:	4581                	li	a1,0
    3a80:	00003517          	auipc	a0,0x3
    3a84:	b2850513          	addi	a0,a0,-1240 # 65a8 <longjmp_1+0x9f8>
    3a88:	00002097          	auipc	ra,0x2
    3a8c:	bc4080e7          	jalr	-1084(ra) # 564c <open>
    3a90:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3a92:	4605                	li	a2,1
    3a94:	00002597          	auipc	a1,0x2
    3a98:	4ec58593          	addi	a1,a1,1260 # 5f80 <longjmp_1+0x3d0>
    3a9c:	00002097          	auipc	ra,0x2
    3aa0:	b90080e7          	jalr	-1136(ra) # 562c <write>
    3aa4:	10a04b63          	bgtz	a0,3bba <dirfile+0x218>
  close(fd);
    3aa8:	8526                	mv	a0,s1
    3aaa:	00002097          	auipc	ra,0x2
    3aae:	b8a080e7          	jalr	-1142(ra) # 5634 <close>
}
    3ab2:	60e2                	ld	ra,24(sp)
    3ab4:	6442                	ld	s0,16(sp)
    3ab6:	64a2                	ld	s1,8(sp)
    3ab8:	6902                	ld	s2,0(sp)
    3aba:	6105                	addi	sp,sp,32
    3abc:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3abe:	85ca                	mv	a1,s2
    3ac0:	00004517          	auipc	a0,0x4
    3ac4:	d1050513          	addi	a0,a0,-752 # 77d0 <longjmp_1+0x1c20>
    3ac8:	00002097          	auipc	ra,0x2
    3acc:	ed4080e7          	jalr	-300(ra) # 599c <printf>
    exit(1);
    3ad0:	4505                	li	a0,1
    3ad2:	00002097          	auipc	ra,0x2
    3ad6:	b3a080e7          	jalr	-1222(ra) # 560c <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3ada:	85ca                	mv	a1,s2
    3adc:	00004517          	auipc	a0,0x4
    3ae0:	d1450513          	addi	a0,a0,-748 # 77f0 <longjmp_1+0x1c40>
    3ae4:	00002097          	auipc	ra,0x2
    3ae8:	eb8080e7          	jalr	-328(ra) # 599c <printf>
    exit(1);
    3aec:	4505                	li	a0,1
    3aee:	00002097          	auipc	ra,0x2
    3af2:	b1e080e7          	jalr	-1250(ra) # 560c <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3af6:	85ca                	mv	a1,s2
    3af8:	00004517          	auipc	a0,0x4
    3afc:	d2850513          	addi	a0,a0,-728 # 7820 <longjmp_1+0x1c70>
    3b00:	00002097          	auipc	ra,0x2
    3b04:	e9c080e7          	jalr	-356(ra) # 599c <printf>
    exit(1);
    3b08:	4505                	li	a0,1
    3b0a:	00002097          	auipc	ra,0x2
    3b0e:	b02080e7          	jalr	-1278(ra) # 560c <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3b12:	85ca                	mv	a1,s2
    3b14:	00004517          	auipc	a0,0x4
    3b18:	d0c50513          	addi	a0,a0,-756 # 7820 <longjmp_1+0x1c70>
    3b1c:	00002097          	auipc	ra,0x2
    3b20:	e80080e7          	jalr	-384(ra) # 599c <printf>
    exit(1);
    3b24:	4505                	li	a0,1
    3b26:	00002097          	auipc	ra,0x2
    3b2a:	ae6080e7          	jalr	-1306(ra) # 560c <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3b2e:	85ca                	mv	a1,s2
    3b30:	00004517          	auipc	a0,0x4
    3b34:	d1850513          	addi	a0,a0,-744 # 7848 <longjmp_1+0x1c98>
    3b38:	00002097          	auipc	ra,0x2
    3b3c:	e64080e7          	jalr	-412(ra) # 599c <printf>
    exit(1);
    3b40:	4505                	li	a0,1
    3b42:	00002097          	auipc	ra,0x2
    3b46:	aca080e7          	jalr	-1334(ra) # 560c <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3b4a:	85ca                	mv	a1,s2
    3b4c:	00004517          	auipc	a0,0x4
    3b50:	d2450513          	addi	a0,a0,-732 # 7870 <longjmp_1+0x1cc0>
    3b54:	00002097          	auipc	ra,0x2
    3b58:	e48080e7          	jalr	-440(ra) # 599c <printf>
    exit(1);
    3b5c:	4505                	li	a0,1
    3b5e:	00002097          	auipc	ra,0x2
    3b62:	aae080e7          	jalr	-1362(ra) # 560c <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3b66:	85ca                	mv	a1,s2
    3b68:	00004517          	auipc	a0,0x4
    3b6c:	d3050513          	addi	a0,a0,-720 # 7898 <longjmp_1+0x1ce8>
    3b70:	00002097          	auipc	ra,0x2
    3b74:	e2c080e7          	jalr	-468(ra) # 599c <printf>
    exit(1);
    3b78:	4505                	li	a0,1
    3b7a:	00002097          	auipc	ra,0x2
    3b7e:	a92080e7          	jalr	-1390(ra) # 560c <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3b82:	85ca                	mv	a1,s2
    3b84:	00004517          	auipc	a0,0x4
    3b88:	d3c50513          	addi	a0,a0,-708 # 78c0 <longjmp_1+0x1d10>
    3b8c:	00002097          	auipc	ra,0x2
    3b90:	e10080e7          	jalr	-496(ra) # 599c <printf>
    exit(1);
    3b94:	4505                	li	a0,1
    3b96:	00002097          	auipc	ra,0x2
    3b9a:	a76080e7          	jalr	-1418(ra) # 560c <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3b9e:	85ca                	mv	a1,s2
    3ba0:	00004517          	auipc	a0,0x4
    3ba4:	d4050513          	addi	a0,a0,-704 # 78e0 <longjmp_1+0x1d30>
    3ba8:	00002097          	auipc	ra,0x2
    3bac:	df4080e7          	jalr	-524(ra) # 599c <printf>
    exit(1);
    3bb0:	4505                	li	a0,1
    3bb2:	00002097          	auipc	ra,0x2
    3bb6:	a5a080e7          	jalr	-1446(ra) # 560c <exit>
    printf("%s: write . succeeded!\n", s);
    3bba:	85ca                	mv	a1,s2
    3bbc:	00004517          	auipc	a0,0x4
    3bc0:	d4c50513          	addi	a0,a0,-692 # 7908 <longjmp_1+0x1d58>
    3bc4:	00002097          	auipc	ra,0x2
    3bc8:	dd8080e7          	jalr	-552(ra) # 599c <printf>
    exit(1);
    3bcc:	4505                	li	a0,1
    3bce:	00002097          	auipc	ra,0x2
    3bd2:	a3e080e7          	jalr	-1474(ra) # 560c <exit>

0000000000003bd6 <iref>:
{
    3bd6:	7139                	addi	sp,sp,-64
    3bd8:	fc06                	sd	ra,56(sp)
    3bda:	f822                	sd	s0,48(sp)
    3bdc:	f426                	sd	s1,40(sp)
    3bde:	f04a                	sd	s2,32(sp)
    3be0:	ec4e                	sd	s3,24(sp)
    3be2:	e852                	sd	s4,16(sp)
    3be4:	e456                	sd	s5,8(sp)
    3be6:	e05a                	sd	s6,0(sp)
    3be8:	0080                	addi	s0,sp,64
    3bea:	8b2a                	mv	s6,a0
    3bec:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    3bf0:	00004a17          	auipc	s4,0x4
    3bf4:	d30a0a13          	addi	s4,s4,-720 # 7920 <longjmp_1+0x1d70>
    mkdir("");
    3bf8:	00004497          	auipc	s1,0x4
    3bfc:	83848493          	addi	s1,s1,-1992 # 7430 <longjmp_1+0x1880>
    link("README", "");
    3c00:	00002a97          	auipc	s5,0x2
    3c04:	4a8a8a93          	addi	s5,s5,1192 # 60a8 <longjmp_1+0x4f8>
    fd = open("xx", O_CREATE);
    3c08:	00004997          	auipc	s3,0x4
    3c0c:	c1098993          	addi	s3,s3,-1008 # 7818 <longjmp_1+0x1c68>
    3c10:	a891                	j	3c64 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    3c12:	85da                	mv	a1,s6
    3c14:	00004517          	auipc	a0,0x4
    3c18:	d1450513          	addi	a0,a0,-748 # 7928 <longjmp_1+0x1d78>
    3c1c:	00002097          	auipc	ra,0x2
    3c20:	d80080e7          	jalr	-640(ra) # 599c <printf>
      exit(1);
    3c24:	4505                	li	a0,1
    3c26:	00002097          	auipc	ra,0x2
    3c2a:	9e6080e7          	jalr	-1562(ra) # 560c <exit>
      printf("%s: chdir irefd failed\n", s);
    3c2e:	85da                	mv	a1,s6
    3c30:	00004517          	auipc	a0,0x4
    3c34:	d1050513          	addi	a0,a0,-752 # 7940 <longjmp_1+0x1d90>
    3c38:	00002097          	auipc	ra,0x2
    3c3c:	d64080e7          	jalr	-668(ra) # 599c <printf>
      exit(1);
    3c40:	4505                	li	a0,1
    3c42:	00002097          	auipc	ra,0x2
    3c46:	9ca080e7          	jalr	-1590(ra) # 560c <exit>
      close(fd);
    3c4a:	00002097          	auipc	ra,0x2
    3c4e:	9ea080e7          	jalr	-1558(ra) # 5634 <close>
    3c52:	a889                	j	3ca4 <iref+0xce>
    unlink("xx");
    3c54:	854e                	mv	a0,s3
    3c56:	00002097          	auipc	ra,0x2
    3c5a:	a06080e7          	jalr	-1530(ra) # 565c <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3c5e:	397d                	addiw	s2,s2,-1
    3c60:	06090063          	beqz	s2,3cc0 <iref+0xea>
    if(mkdir("irefd") != 0){
    3c64:	8552                	mv	a0,s4
    3c66:	00002097          	auipc	ra,0x2
    3c6a:	a0e080e7          	jalr	-1522(ra) # 5674 <mkdir>
    3c6e:	f155                	bnez	a0,3c12 <iref+0x3c>
    if(chdir("irefd") != 0){
    3c70:	8552                	mv	a0,s4
    3c72:	00002097          	auipc	ra,0x2
    3c76:	a0a080e7          	jalr	-1526(ra) # 567c <chdir>
    3c7a:	f955                	bnez	a0,3c2e <iref+0x58>
    mkdir("");
    3c7c:	8526                	mv	a0,s1
    3c7e:	00002097          	auipc	ra,0x2
    3c82:	9f6080e7          	jalr	-1546(ra) # 5674 <mkdir>
    link("README", "");
    3c86:	85a6                	mv	a1,s1
    3c88:	8556                	mv	a0,s5
    3c8a:	00002097          	auipc	ra,0x2
    3c8e:	9e2080e7          	jalr	-1566(ra) # 566c <link>
    fd = open("", O_CREATE);
    3c92:	20000593          	li	a1,512
    3c96:	8526                	mv	a0,s1
    3c98:	00002097          	auipc	ra,0x2
    3c9c:	9b4080e7          	jalr	-1612(ra) # 564c <open>
    if(fd >= 0)
    3ca0:	fa0555e3          	bgez	a0,3c4a <iref+0x74>
    fd = open("xx", O_CREATE);
    3ca4:	20000593          	li	a1,512
    3ca8:	854e                	mv	a0,s3
    3caa:	00002097          	auipc	ra,0x2
    3cae:	9a2080e7          	jalr	-1630(ra) # 564c <open>
    if(fd >= 0)
    3cb2:	fa0541e3          	bltz	a0,3c54 <iref+0x7e>
      close(fd);
    3cb6:	00002097          	auipc	ra,0x2
    3cba:	97e080e7          	jalr	-1666(ra) # 5634 <close>
    3cbe:	bf59                	j	3c54 <iref+0x7e>
    3cc0:	03300493          	li	s1,51
    chdir("..");
    3cc4:	00003997          	auipc	s3,0x3
    3cc8:	48c98993          	addi	s3,s3,1164 # 7150 <longjmp_1+0x15a0>
    unlink("irefd");
    3ccc:	00004917          	auipc	s2,0x4
    3cd0:	c5490913          	addi	s2,s2,-940 # 7920 <longjmp_1+0x1d70>
    chdir("..");
    3cd4:	854e                	mv	a0,s3
    3cd6:	00002097          	auipc	ra,0x2
    3cda:	9a6080e7          	jalr	-1626(ra) # 567c <chdir>
    unlink("irefd");
    3cde:	854a                	mv	a0,s2
    3ce0:	00002097          	auipc	ra,0x2
    3ce4:	97c080e7          	jalr	-1668(ra) # 565c <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3ce8:	34fd                	addiw	s1,s1,-1
    3cea:	f4ed                	bnez	s1,3cd4 <iref+0xfe>
  chdir("/");
    3cec:	00003517          	auipc	a0,0x3
    3cf0:	40c50513          	addi	a0,a0,1036 # 70f8 <longjmp_1+0x1548>
    3cf4:	00002097          	auipc	ra,0x2
    3cf8:	988080e7          	jalr	-1656(ra) # 567c <chdir>
}
    3cfc:	70e2                	ld	ra,56(sp)
    3cfe:	7442                	ld	s0,48(sp)
    3d00:	74a2                	ld	s1,40(sp)
    3d02:	7902                	ld	s2,32(sp)
    3d04:	69e2                	ld	s3,24(sp)
    3d06:	6a42                	ld	s4,16(sp)
    3d08:	6aa2                	ld	s5,8(sp)
    3d0a:	6b02                	ld	s6,0(sp)
    3d0c:	6121                	addi	sp,sp,64
    3d0e:	8082                	ret

0000000000003d10 <openiputtest>:
{
    3d10:	7179                	addi	sp,sp,-48
    3d12:	f406                	sd	ra,40(sp)
    3d14:	f022                	sd	s0,32(sp)
    3d16:	ec26                	sd	s1,24(sp)
    3d18:	1800                	addi	s0,sp,48
    3d1a:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3d1c:	00004517          	auipc	a0,0x4
    3d20:	c3c50513          	addi	a0,a0,-964 # 7958 <longjmp_1+0x1da8>
    3d24:	00002097          	auipc	ra,0x2
    3d28:	950080e7          	jalr	-1712(ra) # 5674 <mkdir>
    3d2c:	04054263          	bltz	a0,3d70 <openiputtest+0x60>
  pid = fork();
    3d30:	00002097          	auipc	ra,0x2
    3d34:	8d4080e7          	jalr	-1836(ra) # 5604 <fork>
  if(pid < 0){
    3d38:	04054a63          	bltz	a0,3d8c <openiputtest+0x7c>
  if(pid == 0){
    3d3c:	e93d                	bnez	a0,3db2 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    3d3e:	4589                	li	a1,2
    3d40:	00004517          	auipc	a0,0x4
    3d44:	c1850513          	addi	a0,a0,-1000 # 7958 <longjmp_1+0x1da8>
    3d48:	00002097          	auipc	ra,0x2
    3d4c:	904080e7          	jalr	-1788(ra) # 564c <open>
    if(fd >= 0){
    3d50:	04054c63          	bltz	a0,3da8 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    3d54:	85a6                	mv	a1,s1
    3d56:	00004517          	auipc	a0,0x4
    3d5a:	c2250513          	addi	a0,a0,-990 # 7978 <longjmp_1+0x1dc8>
    3d5e:	00002097          	auipc	ra,0x2
    3d62:	c3e080e7          	jalr	-962(ra) # 599c <printf>
      exit(1);
    3d66:	4505                	li	a0,1
    3d68:	00002097          	auipc	ra,0x2
    3d6c:	8a4080e7          	jalr	-1884(ra) # 560c <exit>
    printf("%s: mkdir oidir failed\n", s);
    3d70:	85a6                	mv	a1,s1
    3d72:	00004517          	auipc	a0,0x4
    3d76:	bee50513          	addi	a0,a0,-1042 # 7960 <longjmp_1+0x1db0>
    3d7a:	00002097          	auipc	ra,0x2
    3d7e:	c22080e7          	jalr	-990(ra) # 599c <printf>
    exit(1);
    3d82:	4505                	li	a0,1
    3d84:	00002097          	auipc	ra,0x2
    3d88:	888080e7          	jalr	-1912(ra) # 560c <exit>
    printf("%s: fork failed\n", s);
    3d8c:	85a6                	mv	a1,s1
    3d8e:	00003517          	auipc	a0,0x3
    3d92:	9ba50513          	addi	a0,a0,-1606 # 6748 <longjmp_1+0xb98>
    3d96:	00002097          	auipc	ra,0x2
    3d9a:	c06080e7          	jalr	-1018(ra) # 599c <printf>
    exit(1);
    3d9e:	4505                	li	a0,1
    3da0:	00002097          	auipc	ra,0x2
    3da4:	86c080e7          	jalr	-1940(ra) # 560c <exit>
    exit(0);
    3da8:	4501                	li	a0,0
    3daa:	00002097          	auipc	ra,0x2
    3dae:	862080e7          	jalr	-1950(ra) # 560c <exit>
  sleep(1);
    3db2:	4505                	li	a0,1
    3db4:	00002097          	auipc	ra,0x2
    3db8:	8e8080e7          	jalr	-1816(ra) # 569c <sleep>
  if(unlink("oidir") != 0){
    3dbc:	00004517          	auipc	a0,0x4
    3dc0:	b9c50513          	addi	a0,a0,-1124 # 7958 <longjmp_1+0x1da8>
    3dc4:	00002097          	auipc	ra,0x2
    3dc8:	898080e7          	jalr	-1896(ra) # 565c <unlink>
    3dcc:	cd19                	beqz	a0,3dea <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    3dce:	85a6                	mv	a1,s1
    3dd0:	00003517          	auipc	a0,0x3
    3dd4:	b6850513          	addi	a0,a0,-1176 # 6938 <longjmp_1+0xd88>
    3dd8:	00002097          	auipc	ra,0x2
    3ddc:	bc4080e7          	jalr	-1084(ra) # 599c <printf>
    exit(1);
    3de0:	4505                	li	a0,1
    3de2:	00002097          	auipc	ra,0x2
    3de6:	82a080e7          	jalr	-2006(ra) # 560c <exit>
  wait(&xstatus);
    3dea:	fdc40513          	addi	a0,s0,-36
    3dee:	00002097          	auipc	ra,0x2
    3df2:	826080e7          	jalr	-2010(ra) # 5614 <wait>
  exit(xstatus);
    3df6:	fdc42503          	lw	a0,-36(s0)
    3dfa:	00002097          	auipc	ra,0x2
    3dfe:	812080e7          	jalr	-2030(ra) # 560c <exit>

0000000000003e02 <forkforkfork>:
{
    3e02:	1101                	addi	sp,sp,-32
    3e04:	ec06                	sd	ra,24(sp)
    3e06:	e822                	sd	s0,16(sp)
    3e08:	e426                	sd	s1,8(sp)
    3e0a:	1000                	addi	s0,sp,32
    3e0c:	84aa                	mv	s1,a0
  unlink("stopforking");
    3e0e:	00004517          	auipc	a0,0x4
    3e12:	b9250513          	addi	a0,a0,-1134 # 79a0 <longjmp_1+0x1df0>
    3e16:	00002097          	auipc	ra,0x2
    3e1a:	846080e7          	jalr	-1978(ra) # 565c <unlink>
  int pid = fork();
    3e1e:	00001097          	auipc	ra,0x1
    3e22:	7e6080e7          	jalr	2022(ra) # 5604 <fork>
  if(pid < 0){
    3e26:	04054563          	bltz	a0,3e70 <forkforkfork+0x6e>
  if(pid == 0){
    3e2a:	c12d                	beqz	a0,3e8c <forkforkfork+0x8a>
  sleep(20); // two seconds
    3e2c:	4551                	li	a0,20
    3e2e:	00002097          	auipc	ra,0x2
    3e32:	86e080e7          	jalr	-1938(ra) # 569c <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    3e36:	20200593          	li	a1,514
    3e3a:	00004517          	auipc	a0,0x4
    3e3e:	b6650513          	addi	a0,a0,-1178 # 79a0 <longjmp_1+0x1df0>
    3e42:	00002097          	auipc	ra,0x2
    3e46:	80a080e7          	jalr	-2038(ra) # 564c <open>
    3e4a:	00001097          	auipc	ra,0x1
    3e4e:	7ea080e7          	jalr	2026(ra) # 5634 <close>
  wait(0);
    3e52:	4501                	li	a0,0
    3e54:	00001097          	auipc	ra,0x1
    3e58:	7c0080e7          	jalr	1984(ra) # 5614 <wait>
  sleep(10); // one second
    3e5c:	4529                	li	a0,10
    3e5e:	00002097          	auipc	ra,0x2
    3e62:	83e080e7          	jalr	-1986(ra) # 569c <sleep>
}
    3e66:	60e2                	ld	ra,24(sp)
    3e68:	6442                	ld	s0,16(sp)
    3e6a:	64a2                	ld	s1,8(sp)
    3e6c:	6105                	addi	sp,sp,32
    3e6e:	8082                	ret
    printf("%s: fork failed", s);
    3e70:	85a6                	mv	a1,s1
    3e72:	00003517          	auipc	a0,0x3
    3e76:	a9650513          	addi	a0,a0,-1386 # 6908 <longjmp_1+0xd58>
    3e7a:	00002097          	auipc	ra,0x2
    3e7e:	b22080e7          	jalr	-1246(ra) # 599c <printf>
    exit(1);
    3e82:	4505                	li	a0,1
    3e84:	00001097          	auipc	ra,0x1
    3e88:	788080e7          	jalr	1928(ra) # 560c <exit>
      int fd = open("stopforking", 0);
    3e8c:	00004497          	auipc	s1,0x4
    3e90:	b1448493          	addi	s1,s1,-1260 # 79a0 <longjmp_1+0x1df0>
    3e94:	4581                	li	a1,0
    3e96:	8526                	mv	a0,s1
    3e98:	00001097          	auipc	ra,0x1
    3e9c:	7b4080e7          	jalr	1972(ra) # 564c <open>
      if(fd >= 0){
    3ea0:	02055463          	bgez	a0,3ec8 <forkforkfork+0xc6>
      if(fork() < 0){
    3ea4:	00001097          	auipc	ra,0x1
    3ea8:	760080e7          	jalr	1888(ra) # 5604 <fork>
    3eac:	fe0554e3          	bgez	a0,3e94 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    3eb0:	20200593          	li	a1,514
    3eb4:	8526                	mv	a0,s1
    3eb6:	00001097          	auipc	ra,0x1
    3eba:	796080e7          	jalr	1942(ra) # 564c <open>
    3ebe:	00001097          	auipc	ra,0x1
    3ec2:	776080e7          	jalr	1910(ra) # 5634 <close>
    3ec6:	b7f9                	j	3e94 <forkforkfork+0x92>
        exit(0);
    3ec8:	4501                	li	a0,0
    3eca:	00001097          	auipc	ra,0x1
    3ece:	742080e7          	jalr	1858(ra) # 560c <exit>

0000000000003ed2 <preempt>:
{
    3ed2:	7139                	addi	sp,sp,-64
    3ed4:	fc06                	sd	ra,56(sp)
    3ed6:	f822                	sd	s0,48(sp)
    3ed8:	f426                	sd	s1,40(sp)
    3eda:	f04a                	sd	s2,32(sp)
    3edc:	ec4e                	sd	s3,24(sp)
    3ede:	e852                	sd	s4,16(sp)
    3ee0:	0080                	addi	s0,sp,64
    3ee2:	892a                	mv	s2,a0
  pid1 = fork();
    3ee4:	00001097          	auipc	ra,0x1
    3ee8:	720080e7          	jalr	1824(ra) # 5604 <fork>
  if(pid1 < 0) {
    3eec:	00054563          	bltz	a0,3ef6 <preempt+0x24>
    3ef0:	84aa                	mv	s1,a0
  if(pid1 == 0)
    3ef2:	e105                	bnez	a0,3f12 <preempt+0x40>
    for(;;)
    3ef4:	a001                	j	3ef4 <preempt+0x22>
    printf("%s: fork failed", s);
    3ef6:	85ca                	mv	a1,s2
    3ef8:	00003517          	auipc	a0,0x3
    3efc:	a1050513          	addi	a0,a0,-1520 # 6908 <longjmp_1+0xd58>
    3f00:	00002097          	auipc	ra,0x2
    3f04:	a9c080e7          	jalr	-1380(ra) # 599c <printf>
    exit(1);
    3f08:	4505                	li	a0,1
    3f0a:	00001097          	auipc	ra,0x1
    3f0e:	702080e7          	jalr	1794(ra) # 560c <exit>
  pid2 = fork();
    3f12:	00001097          	auipc	ra,0x1
    3f16:	6f2080e7          	jalr	1778(ra) # 5604 <fork>
    3f1a:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    3f1c:	00054463          	bltz	a0,3f24 <preempt+0x52>
  if(pid2 == 0)
    3f20:	e105                	bnez	a0,3f40 <preempt+0x6e>
    for(;;)
    3f22:	a001                	j	3f22 <preempt+0x50>
    printf("%s: fork failed\n", s);
    3f24:	85ca                	mv	a1,s2
    3f26:	00003517          	auipc	a0,0x3
    3f2a:	82250513          	addi	a0,a0,-2014 # 6748 <longjmp_1+0xb98>
    3f2e:	00002097          	auipc	ra,0x2
    3f32:	a6e080e7          	jalr	-1426(ra) # 599c <printf>
    exit(1);
    3f36:	4505                	li	a0,1
    3f38:	00001097          	auipc	ra,0x1
    3f3c:	6d4080e7          	jalr	1748(ra) # 560c <exit>
  pipe(pfds);
    3f40:	fc840513          	addi	a0,s0,-56
    3f44:	00001097          	auipc	ra,0x1
    3f48:	6d8080e7          	jalr	1752(ra) # 561c <pipe>
  pid3 = fork();
    3f4c:	00001097          	auipc	ra,0x1
    3f50:	6b8080e7          	jalr	1720(ra) # 5604 <fork>
    3f54:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    3f56:	02054e63          	bltz	a0,3f92 <preempt+0xc0>
  if(pid3 == 0){
    3f5a:	e525                	bnez	a0,3fc2 <preempt+0xf0>
    close(pfds[0]);
    3f5c:	fc842503          	lw	a0,-56(s0)
    3f60:	00001097          	auipc	ra,0x1
    3f64:	6d4080e7          	jalr	1748(ra) # 5634 <close>
    if(write(pfds[1], "x", 1) != 1)
    3f68:	4605                	li	a2,1
    3f6a:	00002597          	auipc	a1,0x2
    3f6e:	01658593          	addi	a1,a1,22 # 5f80 <longjmp_1+0x3d0>
    3f72:	fcc42503          	lw	a0,-52(s0)
    3f76:	00001097          	auipc	ra,0x1
    3f7a:	6b6080e7          	jalr	1718(ra) # 562c <write>
    3f7e:	4785                	li	a5,1
    3f80:	02f51763          	bne	a0,a5,3fae <preempt+0xdc>
    close(pfds[1]);
    3f84:	fcc42503          	lw	a0,-52(s0)
    3f88:	00001097          	auipc	ra,0x1
    3f8c:	6ac080e7          	jalr	1708(ra) # 5634 <close>
    for(;;)
    3f90:	a001                	j	3f90 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    3f92:	85ca                	mv	a1,s2
    3f94:	00002517          	auipc	a0,0x2
    3f98:	7b450513          	addi	a0,a0,1972 # 6748 <longjmp_1+0xb98>
    3f9c:	00002097          	auipc	ra,0x2
    3fa0:	a00080e7          	jalr	-1536(ra) # 599c <printf>
     exit(1);
    3fa4:	4505                	li	a0,1
    3fa6:	00001097          	auipc	ra,0x1
    3faa:	666080e7          	jalr	1638(ra) # 560c <exit>
      printf("%s: preempt write error", s);
    3fae:	85ca                	mv	a1,s2
    3fb0:	00004517          	auipc	a0,0x4
    3fb4:	a0050513          	addi	a0,a0,-1536 # 79b0 <longjmp_1+0x1e00>
    3fb8:	00002097          	auipc	ra,0x2
    3fbc:	9e4080e7          	jalr	-1564(ra) # 599c <printf>
    3fc0:	b7d1                	j	3f84 <preempt+0xb2>
  close(pfds[1]);
    3fc2:	fcc42503          	lw	a0,-52(s0)
    3fc6:	00001097          	auipc	ra,0x1
    3fca:	66e080e7          	jalr	1646(ra) # 5634 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    3fce:	660d                	lui	a2,0x3
    3fd0:	00008597          	auipc	a1,0x8
    3fd4:	b5858593          	addi	a1,a1,-1192 # bb28 <buf>
    3fd8:	fc842503          	lw	a0,-56(s0)
    3fdc:	00001097          	auipc	ra,0x1
    3fe0:	648080e7          	jalr	1608(ra) # 5624 <read>
    3fe4:	4785                	li	a5,1
    3fe6:	02f50363          	beq	a0,a5,400c <preempt+0x13a>
    printf("%s: preempt read error", s);
    3fea:	85ca                	mv	a1,s2
    3fec:	00004517          	auipc	a0,0x4
    3ff0:	9dc50513          	addi	a0,a0,-1572 # 79c8 <longjmp_1+0x1e18>
    3ff4:	00002097          	auipc	ra,0x2
    3ff8:	9a8080e7          	jalr	-1624(ra) # 599c <printf>
}
    3ffc:	70e2                	ld	ra,56(sp)
    3ffe:	7442                	ld	s0,48(sp)
    4000:	74a2                	ld	s1,40(sp)
    4002:	7902                	ld	s2,32(sp)
    4004:	69e2                	ld	s3,24(sp)
    4006:	6a42                	ld	s4,16(sp)
    4008:	6121                	addi	sp,sp,64
    400a:	8082                	ret
  close(pfds[0]);
    400c:	fc842503          	lw	a0,-56(s0)
    4010:	00001097          	auipc	ra,0x1
    4014:	624080e7          	jalr	1572(ra) # 5634 <close>
  printf("kill... ");
    4018:	00004517          	auipc	a0,0x4
    401c:	9c850513          	addi	a0,a0,-1592 # 79e0 <longjmp_1+0x1e30>
    4020:	00002097          	auipc	ra,0x2
    4024:	97c080e7          	jalr	-1668(ra) # 599c <printf>
  kill(pid1);
    4028:	8526                	mv	a0,s1
    402a:	00001097          	auipc	ra,0x1
    402e:	612080e7          	jalr	1554(ra) # 563c <kill>
  kill(pid2);
    4032:	854e                	mv	a0,s3
    4034:	00001097          	auipc	ra,0x1
    4038:	608080e7          	jalr	1544(ra) # 563c <kill>
  kill(pid3);
    403c:	8552                	mv	a0,s4
    403e:	00001097          	auipc	ra,0x1
    4042:	5fe080e7          	jalr	1534(ra) # 563c <kill>
  printf("wait... ");
    4046:	00004517          	auipc	a0,0x4
    404a:	9aa50513          	addi	a0,a0,-1622 # 79f0 <longjmp_1+0x1e40>
    404e:	00002097          	auipc	ra,0x2
    4052:	94e080e7          	jalr	-1714(ra) # 599c <printf>
  wait(0);
    4056:	4501                	li	a0,0
    4058:	00001097          	auipc	ra,0x1
    405c:	5bc080e7          	jalr	1468(ra) # 5614 <wait>
  wait(0);
    4060:	4501                	li	a0,0
    4062:	00001097          	auipc	ra,0x1
    4066:	5b2080e7          	jalr	1458(ra) # 5614 <wait>
  wait(0);
    406a:	4501                	li	a0,0
    406c:	00001097          	auipc	ra,0x1
    4070:	5a8080e7          	jalr	1448(ra) # 5614 <wait>
    4074:	b761                	j	3ffc <preempt+0x12a>

0000000000004076 <sbrkfail>:
{
    4076:	7119                	addi	sp,sp,-128
    4078:	fc86                	sd	ra,120(sp)
    407a:	f8a2                	sd	s0,112(sp)
    407c:	f4a6                	sd	s1,104(sp)
    407e:	f0ca                	sd	s2,96(sp)
    4080:	ecce                	sd	s3,88(sp)
    4082:	e8d2                	sd	s4,80(sp)
    4084:	e4d6                	sd	s5,72(sp)
    4086:	0100                	addi	s0,sp,128
    4088:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    408a:	fb040513          	addi	a0,s0,-80
    408e:	00001097          	auipc	ra,0x1
    4092:	58e080e7          	jalr	1422(ra) # 561c <pipe>
    4096:	e901                	bnez	a0,40a6 <sbrkfail+0x30>
    4098:	f8040493          	addi	s1,s0,-128
    409c:	fa840993          	addi	s3,s0,-88
    40a0:	8926                	mv	s2,s1
    if(pids[i] != -1)
    40a2:	5a7d                	li	s4,-1
    40a4:	a085                	j	4104 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    40a6:	85d6                	mv	a1,s5
    40a8:	00002517          	auipc	a0,0x2
    40ac:	7a850513          	addi	a0,a0,1960 # 6850 <longjmp_1+0xca0>
    40b0:	00002097          	auipc	ra,0x2
    40b4:	8ec080e7          	jalr	-1812(ra) # 599c <printf>
    exit(1);
    40b8:	4505                	li	a0,1
    40ba:	00001097          	auipc	ra,0x1
    40be:	552080e7          	jalr	1362(ra) # 560c <exit>
      sbrk(BIG - (uint64)sbrk(0));
    40c2:	00001097          	auipc	ra,0x1
    40c6:	5d2080e7          	jalr	1490(ra) # 5694 <sbrk>
    40ca:	064007b7          	lui	a5,0x6400
    40ce:	40a7853b          	subw	a0,a5,a0
    40d2:	00001097          	auipc	ra,0x1
    40d6:	5c2080e7          	jalr	1474(ra) # 5694 <sbrk>
      write(fds[1], "x", 1);
    40da:	4605                	li	a2,1
    40dc:	00002597          	auipc	a1,0x2
    40e0:	ea458593          	addi	a1,a1,-348 # 5f80 <longjmp_1+0x3d0>
    40e4:	fb442503          	lw	a0,-76(s0)
    40e8:	00001097          	auipc	ra,0x1
    40ec:	544080e7          	jalr	1348(ra) # 562c <write>
      for(;;) sleep(1000);
    40f0:	3e800513          	li	a0,1000
    40f4:	00001097          	auipc	ra,0x1
    40f8:	5a8080e7          	jalr	1448(ra) # 569c <sleep>
    40fc:	bfd5                	j	40f0 <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    40fe:	0911                	addi	s2,s2,4
    4100:	03390563          	beq	s2,s3,412a <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    4104:	00001097          	auipc	ra,0x1
    4108:	500080e7          	jalr	1280(ra) # 5604 <fork>
    410c:	00a92023          	sw	a0,0(s2)
    4110:	d94d                	beqz	a0,40c2 <sbrkfail+0x4c>
    if(pids[i] != -1)
    4112:	ff4506e3          	beq	a0,s4,40fe <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    4116:	4605                	li	a2,1
    4118:	faf40593          	addi	a1,s0,-81
    411c:	fb042503          	lw	a0,-80(s0)
    4120:	00001097          	auipc	ra,0x1
    4124:	504080e7          	jalr	1284(ra) # 5624 <read>
    4128:	bfd9                	j	40fe <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    412a:	6505                	lui	a0,0x1
    412c:	00001097          	auipc	ra,0x1
    4130:	568080e7          	jalr	1384(ra) # 5694 <sbrk>
    4134:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    4136:	597d                	li	s2,-1
    4138:	a021                	j	4140 <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    413a:	0491                	addi	s1,s1,4
    413c:	01348f63          	beq	s1,s3,415a <sbrkfail+0xe4>
    if(pids[i] == -1)
    4140:	4088                	lw	a0,0(s1)
    4142:	ff250ce3          	beq	a0,s2,413a <sbrkfail+0xc4>
    kill(pids[i]);
    4146:	00001097          	auipc	ra,0x1
    414a:	4f6080e7          	jalr	1270(ra) # 563c <kill>
    wait(0);
    414e:	4501                	li	a0,0
    4150:	00001097          	auipc	ra,0x1
    4154:	4c4080e7          	jalr	1220(ra) # 5614 <wait>
    4158:	b7cd                	j	413a <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    415a:	57fd                	li	a5,-1
    415c:	04fa0163          	beq	s4,a5,419e <sbrkfail+0x128>
  pid = fork();
    4160:	00001097          	auipc	ra,0x1
    4164:	4a4080e7          	jalr	1188(ra) # 5604 <fork>
    4168:	84aa                	mv	s1,a0
  if(pid < 0){
    416a:	04054863          	bltz	a0,41ba <sbrkfail+0x144>
  if(pid == 0){
    416e:	c525                	beqz	a0,41d6 <sbrkfail+0x160>
  wait(&xstatus);
    4170:	fbc40513          	addi	a0,s0,-68
    4174:	00001097          	auipc	ra,0x1
    4178:	4a0080e7          	jalr	1184(ra) # 5614 <wait>
  if(xstatus != -1 && xstatus != 2)
    417c:	fbc42783          	lw	a5,-68(s0)
    4180:	577d                	li	a4,-1
    4182:	00e78563          	beq	a5,a4,418c <sbrkfail+0x116>
    4186:	4709                	li	a4,2
    4188:	08e79d63          	bne	a5,a4,4222 <sbrkfail+0x1ac>
}
    418c:	70e6                	ld	ra,120(sp)
    418e:	7446                	ld	s0,112(sp)
    4190:	74a6                	ld	s1,104(sp)
    4192:	7906                	ld	s2,96(sp)
    4194:	69e6                	ld	s3,88(sp)
    4196:	6a46                	ld	s4,80(sp)
    4198:	6aa6                	ld	s5,72(sp)
    419a:	6109                	addi	sp,sp,128
    419c:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    419e:	85d6                	mv	a1,s5
    41a0:	00004517          	auipc	a0,0x4
    41a4:	86050513          	addi	a0,a0,-1952 # 7a00 <longjmp_1+0x1e50>
    41a8:	00001097          	auipc	ra,0x1
    41ac:	7f4080e7          	jalr	2036(ra) # 599c <printf>
    exit(1);
    41b0:	4505                	li	a0,1
    41b2:	00001097          	auipc	ra,0x1
    41b6:	45a080e7          	jalr	1114(ra) # 560c <exit>
    printf("%s: fork failed\n", s);
    41ba:	85d6                	mv	a1,s5
    41bc:	00002517          	auipc	a0,0x2
    41c0:	58c50513          	addi	a0,a0,1420 # 6748 <longjmp_1+0xb98>
    41c4:	00001097          	auipc	ra,0x1
    41c8:	7d8080e7          	jalr	2008(ra) # 599c <printf>
    exit(1);
    41cc:	4505                	li	a0,1
    41ce:	00001097          	auipc	ra,0x1
    41d2:	43e080e7          	jalr	1086(ra) # 560c <exit>
    a = sbrk(0);
    41d6:	4501                	li	a0,0
    41d8:	00001097          	auipc	ra,0x1
    41dc:	4bc080e7          	jalr	1212(ra) # 5694 <sbrk>
    41e0:	892a                	mv	s2,a0
    sbrk(10*BIG);
    41e2:	3e800537          	lui	a0,0x3e800
    41e6:	00001097          	auipc	ra,0x1
    41ea:	4ae080e7          	jalr	1198(ra) # 5694 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    41ee:	87ca                	mv	a5,s2
    41f0:	3e800737          	lui	a4,0x3e800
    41f4:	993a                	add	s2,s2,a4
    41f6:	6705                	lui	a4,0x1
      n += *(a+i);
    41f8:	0007c683          	lbu	a3,0(a5) # 6400000 <__BSS_END__+0x63f14c8>
    41fc:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    41fe:	97ba                	add	a5,a5,a4
    4200:	ff279ce3          	bne	a5,s2,41f8 <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    4204:	8626                	mv	a2,s1
    4206:	85d6                	mv	a1,s5
    4208:	00004517          	auipc	a0,0x4
    420c:	81850513          	addi	a0,a0,-2024 # 7a20 <longjmp_1+0x1e70>
    4210:	00001097          	auipc	ra,0x1
    4214:	78c080e7          	jalr	1932(ra) # 599c <printf>
    exit(1);
    4218:	4505                	li	a0,1
    421a:	00001097          	auipc	ra,0x1
    421e:	3f2080e7          	jalr	1010(ra) # 560c <exit>
    exit(1);
    4222:	4505                	li	a0,1
    4224:	00001097          	auipc	ra,0x1
    4228:	3e8080e7          	jalr	1000(ra) # 560c <exit>

000000000000422c <reparent>:
{
    422c:	7179                	addi	sp,sp,-48
    422e:	f406                	sd	ra,40(sp)
    4230:	f022                	sd	s0,32(sp)
    4232:	ec26                	sd	s1,24(sp)
    4234:	e84a                	sd	s2,16(sp)
    4236:	e44e                	sd	s3,8(sp)
    4238:	e052                	sd	s4,0(sp)
    423a:	1800                	addi	s0,sp,48
    423c:	89aa                	mv	s3,a0
  int master_pid = getpid();
    423e:	00001097          	auipc	ra,0x1
    4242:	44e080e7          	jalr	1102(ra) # 568c <getpid>
    4246:	8a2a                	mv	s4,a0
    4248:	0c800913          	li	s2,200
    int pid = fork();
    424c:	00001097          	auipc	ra,0x1
    4250:	3b8080e7          	jalr	952(ra) # 5604 <fork>
    4254:	84aa                	mv	s1,a0
    if(pid < 0){
    4256:	02054263          	bltz	a0,427a <reparent+0x4e>
    if(pid){
    425a:	cd21                	beqz	a0,42b2 <reparent+0x86>
      if(wait(0) != pid){
    425c:	4501                	li	a0,0
    425e:	00001097          	auipc	ra,0x1
    4262:	3b6080e7          	jalr	950(ra) # 5614 <wait>
    4266:	02951863          	bne	a0,s1,4296 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    426a:	397d                	addiw	s2,s2,-1
    426c:	fe0910e3          	bnez	s2,424c <reparent+0x20>
  exit(0);
    4270:	4501                	li	a0,0
    4272:	00001097          	auipc	ra,0x1
    4276:	39a080e7          	jalr	922(ra) # 560c <exit>
      printf("%s: fork failed\n", s);
    427a:	85ce                	mv	a1,s3
    427c:	00002517          	auipc	a0,0x2
    4280:	4cc50513          	addi	a0,a0,1228 # 6748 <longjmp_1+0xb98>
    4284:	00001097          	auipc	ra,0x1
    4288:	718080e7          	jalr	1816(ra) # 599c <printf>
      exit(1);
    428c:	4505                	li	a0,1
    428e:	00001097          	auipc	ra,0x1
    4292:	37e080e7          	jalr	894(ra) # 560c <exit>
        printf("%s: wait wrong pid\n", s);
    4296:	85ce                	mv	a1,s3
    4298:	00002517          	auipc	a0,0x2
    429c:	63850513          	addi	a0,a0,1592 # 68d0 <longjmp_1+0xd20>
    42a0:	00001097          	auipc	ra,0x1
    42a4:	6fc080e7          	jalr	1788(ra) # 599c <printf>
        exit(1);
    42a8:	4505                	li	a0,1
    42aa:	00001097          	auipc	ra,0x1
    42ae:	362080e7          	jalr	866(ra) # 560c <exit>
      int pid2 = fork();
    42b2:	00001097          	auipc	ra,0x1
    42b6:	352080e7          	jalr	850(ra) # 5604 <fork>
      if(pid2 < 0){
    42ba:	00054763          	bltz	a0,42c8 <reparent+0x9c>
      exit(0);
    42be:	4501                	li	a0,0
    42c0:	00001097          	auipc	ra,0x1
    42c4:	34c080e7          	jalr	844(ra) # 560c <exit>
        kill(master_pid);
    42c8:	8552                	mv	a0,s4
    42ca:	00001097          	auipc	ra,0x1
    42ce:	372080e7          	jalr	882(ra) # 563c <kill>
        exit(1);
    42d2:	4505                	li	a0,1
    42d4:	00001097          	auipc	ra,0x1
    42d8:	338080e7          	jalr	824(ra) # 560c <exit>

00000000000042dc <mem>:
{
    42dc:	7139                	addi	sp,sp,-64
    42de:	fc06                	sd	ra,56(sp)
    42e0:	f822                	sd	s0,48(sp)
    42e2:	f426                	sd	s1,40(sp)
    42e4:	f04a                	sd	s2,32(sp)
    42e6:	ec4e                	sd	s3,24(sp)
    42e8:	0080                	addi	s0,sp,64
    42ea:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    42ec:	00001097          	auipc	ra,0x1
    42f0:	318080e7          	jalr	792(ra) # 5604 <fork>
    m1 = 0;
    42f4:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    42f6:	6909                	lui	s2,0x2
    42f8:	71190913          	addi	s2,s2,1809 # 2711 <sbrkbasic+0x159>
  if((pid = fork()) == 0){
    42fc:	c115                	beqz	a0,4320 <mem+0x44>
    wait(&xstatus);
    42fe:	fcc40513          	addi	a0,s0,-52
    4302:	00001097          	auipc	ra,0x1
    4306:	312080e7          	jalr	786(ra) # 5614 <wait>
    if(xstatus == -1){
    430a:	fcc42503          	lw	a0,-52(s0)
    430e:	57fd                	li	a5,-1
    4310:	06f50363          	beq	a0,a5,4376 <mem+0x9a>
    exit(xstatus);
    4314:	00001097          	auipc	ra,0x1
    4318:	2f8080e7          	jalr	760(ra) # 560c <exit>
      *(char**)m2 = m1;
    431c:	e104                	sd	s1,0(a0)
      m1 = m2;
    431e:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    4320:	854a                	mv	a0,s2
    4322:	00001097          	auipc	ra,0x1
    4326:	738080e7          	jalr	1848(ra) # 5a5a <malloc>
    432a:	f96d                	bnez	a0,431c <mem+0x40>
    while(m1){
    432c:	c881                	beqz	s1,433c <mem+0x60>
      m2 = *(char**)m1;
    432e:	8526                	mv	a0,s1
    4330:	6084                	ld	s1,0(s1)
      free(m1);
    4332:	00001097          	auipc	ra,0x1
    4336:	6a0080e7          	jalr	1696(ra) # 59d2 <free>
    while(m1){
    433a:	f8f5                	bnez	s1,432e <mem+0x52>
    m1 = malloc(1024*20);
    433c:	6515                	lui	a0,0x5
    433e:	00001097          	auipc	ra,0x1
    4342:	71c080e7          	jalr	1820(ra) # 5a5a <malloc>
    if(m1 == 0){
    4346:	c911                	beqz	a0,435a <mem+0x7e>
    free(m1);
    4348:	00001097          	auipc	ra,0x1
    434c:	68a080e7          	jalr	1674(ra) # 59d2 <free>
    exit(0);
    4350:	4501                	li	a0,0
    4352:	00001097          	auipc	ra,0x1
    4356:	2ba080e7          	jalr	698(ra) # 560c <exit>
      printf("couldn't allocate mem?!!\n", s);
    435a:	85ce                	mv	a1,s3
    435c:	00003517          	auipc	a0,0x3
    4360:	6f450513          	addi	a0,a0,1780 # 7a50 <longjmp_1+0x1ea0>
    4364:	00001097          	auipc	ra,0x1
    4368:	638080e7          	jalr	1592(ra) # 599c <printf>
      exit(1);
    436c:	4505                	li	a0,1
    436e:	00001097          	auipc	ra,0x1
    4372:	29e080e7          	jalr	670(ra) # 560c <exit>
      exit(0);
    4376:	4501                	li	a0,0
    4378:	00001097          	auipc	ra,0x1
    437c:	294080e7          	jalr	660(ra) # 560c <exit>

0000000000004380 <sharedfd>:
{
    4380:	7159                	addi	sp,sp,-112
    4382:	f486                	sd	ra,104(sp)
    4384:	f0a2                	sd	s0,96(sp)
    4386:	eca6                	sd	s1,88(sp)
    4388:	e8ca                	sd	s2,80(sp)
    438a:	e4ce                	sd	s3,72(sp)
    438c:	e0d2                	sd	s4,64(sp)
    438e:	fc56                	sd	s5,56(sp)
    4390:	f85a                	sd	s6,48(sp)
    4392:	f45e                	sd	s7,40(sp)
    4394:	1880                	addi	s0,sp,112
    4396:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4398:	00002517          	auipc	a0,0x2
    439c:	9b850513          	addi	a0,a0,-1608 # 5d50 <longjmp_1+0x1a0>
    43a0:	00001097          	auipc	ra,0x1
    43a4:	2bc080e7          	jalr	700(ra) # 565c <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    43a8:	20200593          	li	a1,514
    43ac:	00002517          	auipc	a0,0x2
    43b0:	9a450513          	addi	a0,a0,-1628 # 5d50 <longjmp_1+0x1a0>
    43b4:	00001097          	auipc	ra,0x1
    43b8:	298080e7          	jalr	664(ra) # 564c <open>
  if(fd < 0){
    43bc:	04054a63          	bltz	a0,4410 <sharedfd+0x90>
    43c0:	892a                	mv	s2,a0
  pid = fork();
    43c2:	00001097          	auipc	ra,0x1
    43c6:	242080e7          	jalr	578(ra) # 5604 <fork>
    43ca:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    43cc:	06300593          	li	a1,99
    43d0:	c119                	beqz	a0,43d6 <sharedfd+0x56>
    43d2:	07000593          	li	a1,112
    43d6:	4629                	li	a2,10
    43d8:	fa040513          	addi	a0,s0,-96
    43dc:	00001097          	auipc	ra,0x1
    43e0:	034080e7          	jalr	52(ra) # 5410 <memset>
    43e4:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    43e8:	4629                	li	a2,10
    43ea:	fa040593          	addi	a1,s0,-96
    43ee:	854a                	mv	a0,s2
    43f0:	00001097          	auipc	ra,0x1
    43f4:	23c080e7          	jalr	572(ra) # 562c <write>
    43f8:	47a9                	li	a5,10
    43fa:	02f51963          	bne	a0,a5,442c <sharedfd+0xac>
  for(i = 0; i < N; i++){
    43fe:	34fd                	addiw	s1,s1,-1
    4400:	f4e5                	bnez	s1,43e8 <sharedfd+0x68>
  if(pid == 0) {
    4402:	04099363          	bnez	s3,4448 <sharedfd+0xc8>
    exit(0);
    4406:	4501                	li	a0,0
    4408:	00001097          	auipc	ra,0x1
    440c:	204080e7          	jalr	516(ra) # 560c <exit>
    printf("%s: cannot open sharedfd for writing", s);
    4410:	85d2                	mv	a1,s4
    4412:	00003517          	auipc	a0,0x3
    4416:	65e50513          	addi	a0,a0,1630 # 7a70 <longjmp_1+0x1ec0>
    441a:	00001097          	auipc	ra,0x1
    441e:	582080e7          	jalr	1410(ra) # 599c <printf>
    exit(1);
    4422:	4505                	li	a0,1
    4424:	00001097          	auipc	ra,0x1
    4428:	1e8080e7          	jalr	488(ra) # 560c <exit>
      printf("%s: write sharedfd failed\n", s);
    442c:	85d2                	mv	a1,s4
    442e:	00003517          	auipc	a0,0x3
    4432:	66a50513          	addi	a0,a0,1642 # 7a98 <longjmp_1+0x1ee8>
    4436:	00001097          	auipc	ra,0x1
    443a:	566080e7          	jalr	1382(ra) # 599c <printf>
      exit(1);
    443e:	4505                	li	a0,1
    4440:	00001097          	auipc	ra,0x1
    4444:	1cc080e7          	jalr	460(ra) # 560c <exit>
    wait(&xstatus);
    4448:	f9c40513          	addi	a0,s0,-100
    444c:	00001097          	auipc	ra,0x1
    4450:	1c8080e7          	jalr	456(ra) # 5614 <wait>
    if(xstatus != 0)
    4454:	f9c42983          	lw	s3,-100(s0)
    4458:	00098763          	beqz	s3,4466 <sharedfd+0xe6>
      exit(xstatus);
    445c:	854e                	mv	a0,s3
    445e:	00001097          	auipc	ra,0x1
    4462:	1ae080e7          	jalr	430(ra) # 560c <exit>
  close(fd);
    4466:	854a                	mv	a0,s2
    4468:	00001097          	auipc	ra,0x1
    446c:	1cc080e7          	jalr	460(ra) # 5634 <close>
  fd = open("sharedfd", 0);
    4470:	4581                	li	a1,0
    4472:	00002517          	auipc	a0,0x2
    4476:	8de50513          	addi	a0,a0,-1826 # 5d50 <longjmp_1+0x1a0>
    447a:	00001097          	auipc	ra,0x1
    447e:	1d2080e7          	jalr	466(ra) # 564c <open>
    4482:	8baa                	mv	s7,a0
  nc = np = 0;
    4484:	8ace                	mv	s5,s3
  if(fd < 0){
    4486:	02054563          	bltz	a0,44b0 <sharedfd+0x130>
    448a:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    448e:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4492:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4496:	4629                	li	a2,10
    4498:	fa040593          	addi	a1,s0,-96
    449c:	855e                	mv	a0,s7
    449e:	00001097          	auipc	ra,0x1
    44a2:	186080e7          	jalr	390(ra) # 5624 <read>
    44a6:	02a05f63          	blez	a0,44e4 <sharedfd+0x164>
    44aa:	fa040793          	addi	a5,s0,-96
    44ae:	a01d                	j	44d4 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    44b0:	85d2                	mv	a1,s4
    44b2:	00003517          	auipc	a0,0x3
    44b6:	60650513          	addi	a0,a0,1542 # 7ab8 <longjmp_1+0x1f08>
    44ba:	00001097          	auipc	ra,0x1
    44be:	4e2080e7          	jalr	1250(ra) # 599c <printf>
    exit(1);
    44c2:	4505                	li	a0,1
    44c4:	00001097          	auipc	ra,0x1
    44c8:	148080e7          	jalr	328(ra) # 560c <exit>
        nc++;
    44cc:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    44ce:	0785                	addi	a5,a5,1
    44d0:	fd2783e3          	beq	a5,s2,4496 <sharedfd+0x116>
      if(buf[i] == 'c')
    44d4:	0007c703          	lbu	a4,0(a5)
    44d8:	fe970ae3          	beq	a4,s1,44cc <sharedfd+0x14c>
      if(buf[i] == 'p')
    44dc:	ff6719e3          	bne	a4,s6,44ce <sharedfd+0x14e>
        np++;
    44e0:	2a85                	addiw	s5,s5,1
    44e2:	b7f5                	j	44ce <sharedfd+0x14e>
  close(fd);
    44e4:	855e                	mv	a0,s7
    44e6:	00001097          	auipc	ra,0x1
    44ea:	14e080e7          	jalr	334(ra) # 5634 <close>
  unlink("sharedfd");
    44ee:	00002517          	auipc	a0,0x2
    44f2:	86250513          	addi	a0,a0,-1950 # 5d50 <longjmp_1+0x1a0>
    44f6:	00001097          	auipc	ra,0x1
    44fa:	166080e7          	jalr	358(ra) # 565c <unlink>
  if(nc == N*SZ && np == N*SZ){
    44fe:	6789                	lui	a5,0x2
    4500:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0x158>
    4504:	00f99763          	bne	s3,a5,4512 <sharedfd+0x192>
    4508:	6789                	lui	a5,0x2
    450a:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0x158>
    450e:	02fa8063          	beq	s5,a5,452e <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    4512:	85d2                	mv	a1,s4
    4514:	00003517          	auipc	a0,0x3
    4518:	5cc50513          	addi	a0,a0,1484 # 7ae0 <longjmp_1+0x1f30>
    451c:	00001097          	auipc	ra,0x1
    4520:	480080e7          	jalr	1152(ra) # 599c <printf>
    exit(1);
    4524:	4505                	li	a0,1
    4526:	00001097          	auipc	ra,0x1
    452a:	0e6080e7          	jalr	230(ra) # 560c <exit>
    exit(0);
    452e:	4501                	li	a0,0
    4530:	00001097          	auipc	ra,0x1
    4534:	0dc080e7          	jalr	220(ra) # 560c <exit>

0000000000004538 <fourfiles>:
{
    4538:	7171                	addi	sp,sp,-176
    453a:	f506                	sd	ra,168(sp)
    453c:	f122                	sd	s0,160(sp)
    453e:	ed26                	sd	s1,152(sp)
    4540:	e94a                	sd	s2,144(sp)
    4542:	e54e                	sd	s3,136(sp)
    4544:	e152                	sd	s4,128(sp)
    4546:	fcd6                	sd	s5,120(sp)
    4548:	f8da                	sd	s6,112(sp)
    454a:	f4de                	sd	s7,104(sp)
    454c:	f0e2                	sd	s8,96(sp)
    454e:	ece6                	sd	s9,88(sp)
    4550:	e8ea                	sd	s10,80(sp)
    4552:	e4ee                	sd	s11,72(sp)
    4554:	1900                	addi	s0,sp,176
    4556:	f4a43c23          	sd	a0,-168(s0)
  char *names[] = { "f0", "f1", "f2", "f3" };
    455a:	00001797          	auipc	a5,0x1
    455e:	65e78793          	addi	a5,a5,1630 # 5bb8 <longjmp_1+0x8>
    4562:	f6f43823          	sd	a5,-144(s0)
    4566:	00001797          	auipc	a5,0x1
    456a:	65a78793          	addi	a5,a5,1626 # 5bc0 <longjmp_1+0x10>
    456e:	f6f43c23          	sd	a5,-136(s0)
    4572:	00001797          	auipc	a5,0x1
    4576:	65678793          	addi	a5,a5,1622 # 5bc8 <longjmp_1+0x18>
    457a:	f8f43023          	sd	a5,-128(s0)
    457e:	00001797          	auipc	a5,0x1
    4582:	65278793          	addi	a5,a5,1618 # 5bd0 <longjmp_1+0x20>
    4586:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    458a:	f7040c13          	addi	s8,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    458e:	8962                	mv	s2,s8
  for(pi = 0; pi < NCHILD; pi++){
    4590:	4481                	li	s1,0
    4592:	4a11                	li	s4,4
    fname = names[pi];
    4594:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4598:	854e                	mv	a0,s3
    459a:	00001097          	auipc	ra,0x1
    459e:	0c2080e7          	jalr	194(ra) # 565c <unlink>
    pid = fork();
    45a2:	00001097          	auipc	ra,0x1
    45a6:	062080e7          	jalr	98(ra) # 5604 <fork>
    if(pid < 0){
    45aa:	04054463          	bltz	a0,45f2 <fourfiles+0xba>
    if(pid == 0){
    45ae:	c12d                	beqz	a0,4610 <fourfiles+0xd8>
  for(pi = 0; pi < NCHILD; pi++){
    45b0:	2485                	addiw	s1,s1,1
    45b2:	0921                	addi	s2,s2,8
    45b4:	ff4490e3          	bne	s1,s4,4594 <fourfiles+0x5c>
    45b8:	4491                	li	s1,4
    wait(&xstatus);
    45ba:	f6c40513          	addi	a0,s0,-148
    45be:	00001097          	auipc	ra,0x1
    45c2:	056080e7          	jalr	86(ra) # 5614 <wait>
    if(xstatus != 0)
    45c6:	f6c42b03          	lw	s6,-148(s0)
    45ca:	0c0b1e63          	bnez	s6,46a6 <fourfiles+0x16e>
  for(pi = 0; pi < NCHILD; pi++){
    45ce:	34fd                	addiw	s1,s1,-1
    45d0:	f4ed                	bnez	s1,45ba <fourfiles+0x82>
    45d2:	03000b93          	li	s7,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    45d6:	00007a17          	auipc	s4,0x7
    45da:	552a0a13          	addi	s4,s4,1362 # bb28 <buf>
    45de:	00007a97          	auipc	s5,0x7
    45e2:	54ba8a93          	addi	s5,s5,1355 # bb29 <buf+0x1>
    if(total != N*SZ){
    45e6:	6d85                	lui	s11,0x1
    45e8:	770d8d93          	addi	s11,s11,1904 # 1770 <pipe1+0x32>
  for(i = 0; i < NCHILD; i++){
    45ec:	03400d13          	li	s10,52
    45f0:	aa1d                	j	4726 <fourfiles+0x1ee>
      printf("fork failed\n", s);
    45f2:	f5843583          	ld	a1,-168(s0)
    45f6:	00002517          	auipc	a0,0x2
    45fa:	55a50513          	addi	a0,a0,1370 # 6b50 <longjmp_1+0xfa0>
    45fe:	00001097          	auipc	ra,0x1
    4602:	39e080e7          	jalr	926(ra) # 599c <printf>
      exit(1);
    4606:	4505                	li	a0,1
    4608:	00001097          	auipc	ra,0x1
    460c:	004080e7          	jalr	4(ra) # 560c <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4610:	20200593          	li	a1,514
    4614:	854e                	mv	a0,s3
    4616:	00001097          	auipc	ra,0x1
    461a:	036080e7          	jalr	54(ra) # 564c <open>
    461e:	892a                	mv	s2,a0
      if(fd < 0){
    4620:	04054763          	bltz	a0,466e <fourfiles+0x136>
      memset(buf, '0'+pi, SZ);
    4624:	1f400613          	li	a2,500
    4628:	0304859b          	addiw	a1,s1,48
    462c:	00007517          	auipc	a0,0x7
    4630:	4fc50513          	addi	a0,a0,1276 # bb28 <buf>
    4634:	00001097          	auipc	ra,0x1
    4638:	ddc080e7          	jalr	-548(ra) # 5410 <memset>
    463c:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    463e:	00007997          	auipc	s3,0x7
    4642:	4ea98993          	addi	s3,s3,1258 # bb28 <buf>
    4646:	1f400613          	li	a2,500
    464a:	85ce                	mv	a1,s3
    464c:	854a                	mv	a0,s2
    464e:	00001097          	auipc	ra,0x1
    4652:	fde080e7          	jalr	-34(ra) # 562c <write>
    4656:	85aa                	mv	a1,a0
    4658:	1f400793          	li	a5,500
    465c:	02f51863          	bne	a0,a5,468c <fourfiles+0x154>
      for(i = 0; i < N; i++){
    4660:	34fd                	addiw	s1,s1,-1
    4662:	f0f5                	bnez	s1,4646 <fourfiles+0x10e>
      exit(0);
    4664:	4501                	li	a0,0
    4666:	00001097          	auipc	ra,0x1
    466a:	fa6080e7          	jalr	-90(ra) # 560c <exit>
        printf("create failed\n", s);
    466e:	f5843583          	ld	a1,-168(s0)
    4672:	00003517          	auipc	a0,0x3
    4676:	48650513          	addi	a0,a0,1158 # 7af8 <longjmp_1+0x1f48>
    467a:	00001097          	auipc	ra,0x1
    467e:	322080e7          	jalr	802(ra) # 599c <printf>
        exit(1);
    4682:	4505                	li	a0,1
    4684:	00001097          	auipc	ra,0x1
    4688:	f88080e7          	jalr	-120(ra) # 560c <exit>
          printf("write failed %d\n", n);
    468c:	00003517          	auipc	a0,0x3
    4690:	47c50513          	addi	a0,a0,1148 # 7b08 <longjmp_1+0x1f58>
    4694:	00001097          	auipc	ra,0x1
    4698:	308080e7          	jalr	776(ra) # 599c <printf>
          exit(1);
    469c:	4505                	li	a0,1
    469e:	00001097          	auipc	ra,0x1
    46a2:	f6e080e7          	jalr	-146(ra) # 560c <exit>
      exit(xstatus);
    46a6:	855a                	mv	a0,s6
    46a8:	00001097          	auipc	ra,0x1
    46ac:	f64080e7          	jalr	-156(ra) # 560c <exit>
          printf("wrong char\n", s);
    46b0:	f5843583          	ld	a1,-168(s0)
    46b4:	00003517          	auipc	a0,0x3
    46b8:	46c50513          	addi	a0,a0,1132 # 7b20 <longjmp_1+0x1f70>
    46bc:	00001097          	auipc	ra,0x1
    46c0:	2e0080e7          	jalr	736(ra) # 599c <printf>
          exit(1);
    46c4:	4505                	li	a0,1
    46c6:	00001097          	auipc	ra,0x1
    46ca:	f46080e7          	jalr	-186(ra) # 560c <exit>
      total += n;
    46ce:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    46d2:	660d                	lui	a2,0x3
    46d4:	85d2                	mv	a1,s4
    46d6:	854e                	mv	a0,s3
    46d8:	00001097          	auipc	ra,0x1
    46dc:	f4c080e7          	jalr	-180(ra) # 5624 <read>
    46e0:	02a05363          	blez	a0,4706 <fourfiles+0x1ce>
    46e4:	00007797          	auipc	a5,0x7
    46e8:	44478793          	addi	a5,a5,1092 # bb28 <buf>
    46ec:	fff5069b          	addiw	a3,a0,-1
    46f0:	1682                	slli	a3,a3,0x20
    46f2:	9281                	srli	a3,a3,0x20
    46f4:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    46f6:	0007c703          	lbu	a4,0(a5)
    46fa:	fa971be3          	bne	a4,s1,46b0 <fourfiles+0x178>
      for(j = 0; j < n; j++){
    46fe:	0785                	addi	a5,a5,1
    4700:	fed79be3          	bne	a5,a3,46f6 <fourfiles+0x1be>
    4704:	b7e9                	j	46ce <fourfiles+0x196>
    close(fd);
    4706:	854e                	mv	a0,s3
    4708:	00001097          	auipc	ra,0x1
    470c:	f2c080e7          	jalr	-212(ra) # 5634 <close>
    if(total != N*SZ){
    4710:	03b91863          	bne	s2,s11,4740 <fourfiles+0x208>
    unlink(fname);
    4714:	8566                	mv	a0,s9
    4716:	00001097          	auipc	ra,0x1
    471a:	f46080e7          	jalr	-186(ra) # 565c <unlink>
  for(i = 0; i < NCHILD; i++){
    471e:	0c21                	addi	s8,s8,8
    4720:	2b85                	addiw	s7,s7,1
    4722:	03ab8d63          	beq	s7,s10,475c <fourfiles+0x224>
    fname = names[i];
    4726:	000c3c83          	ld	s9,0(s8)
    fd = open(fname, 0);
    472a:	4581                	li	a1,0
    472c:	8566                	mv	a0,s9
    472e:	00001097          	auipc	ra,0x1
    4732:	f1e080e7          	jalr	-226(ra) # 564c <open>
    4736:	89aa                	mv	s3,a0
    total = 0;
    4738:	895a                	mv	s2,s6
        if(buf[j] != '0'+i){
    473a:	000b849b          	sext.w	s1,s7
    while((n = read(fd, buf, sizeof(buf))) > 0){
    473e:	bf51                	j	46d2 <fourfiles+0x19a>
      printf("wrong length %d\n", total);
    4740:	85ca                	mv	a1,s2
    4742:	00003517          	auipc	a0,0x3
    4746:	3ee50513          	addi	a0,a0,1006 # 7b30 <longjmp_1+0x1f80>
    474a:	00001097          	auipc	ra,0x1
    474e:	252080e7          	jalr	594(ra) # 599c <printf>
      exit(1);
    4752:	4505                	li	a0,1
    4754:	00001097          	auipc	ra,0x1
    4758:	eb8080e7          	jalr	-328(ra) # 560c <exit>
}
    475c:	70aa                	ld	ra,168(sp)
    475e:	740a                	ld	s0,160(sp)
    4760:	64ea                	ld	s1,152(sp)
    4762:	694a                	ld	s2,144(sp)
    4764:	69aa                	ld	s3,136(sp)
    4766:	6a0a                	ld	s4,128(sp)
    4768:	7ae6                	ld	s5,120(sp)
    476a:	7b46                	ld	s6,112(sp)
    476c:	7ba6                	ld	s7,104(sp)
    476e:	7c06                	ld	s8,96(sp)
    4770:	6ce6                	ld	s9,88(sp)
    4772:	6d46                	ld	s10,80(sp)
    4774:	6da6                	ld	s11,72(sp)
    4776:	614d                	addi	sp,sp,176
    4778:	8082                	ret

000000000000477a <concreate>:
{
    477a:	7135                	addi	sp,sp,-160
    477c:	ed06                	sd	ra,152(sp)
    477e:	e922                	sd	s0,144(sp)
    4780:	e526                	sd	s1,136(sp)
    4782:	e14a                	sd	s2,128(sp)
    4784:	fcce                	sd	s3,120(sp)
    4786:	f8d2                	sd	s4,112(sp)
    4788:	f4d6                	sd	s5,104(sp)
    478a:	f0da                	sd	s6,96(sp)
    478c:	ecde                	sd	s7,88(sp)
    478e:	1100                	addi	s0,sp,160
    4790:	89aa                	mv	s3,a0
  file[0] = 'C';
    4792:	04300793          	li	a5,67
    4796:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    479a:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    479e:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    47a0:	4b0d                	li	s6,3
    47a2:	4a85                	li	s5,1
      link("C0", file);
    47a4:	00003b97          	auipc	s7,0x3
    47a8:	3a4b8b93          	addi	s7,s7,932 # 7b48 <longjmp_1+0x1f98>
  for(i = 0; i < N; i++){
    47ac:	02800a13          	li	s4,40
    47b0:	acc1                	j	4a80 <concreate+0x306>
      link("C0", file);
    47b2:	fa840593          	addi	a1,s0,-88
    47b6:	855e                	mv	a0,s7
    47b8:	00001097          	auipc	ra,0x1
    47bc:	eb4080e7          	jalr	-332(ra) # 566c <link>
    if(pid == 0) {
    47c0:	a45d                	j	4a66 <concreate+0x2ec>
    } else if(pid == 0 && (i % 5) == 1){
    47c2:	4795                	li	a5,5
    47c4:	02f9693b          	remw	s2,s2,a5
    47c8:	4785                	li	a5,1
    47ca:	02f90b63          	beq	s2,a5,4800 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    47ce:	20200593          	li	a1,514
    47d2:	fa840513          	addi	a0,s0,-88
    47d6:	00001097          	auipc	ra,0x1
    47da:	e76080e7          	jalr	-394(ra) # 564c <open>
      if(fd < 0){
    47de:	26055b63          	bgez	a0,4a54 <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    47e2:	fa840593          	addi	a1,s0,-88
    47e6:	00003517          	auipc	a0,0x3
    47ea:	36a50513          	addi	a0,a0,874 # 7b50 <longjmp_1+0x1fa0>
    47ee:	00001097          	auipc	ra,0x1
    47f2:	1ae080e7          	jalr	430(ra) # 599c <printf>
        exit(1);
    47f6:	4505                	li	a0,1
    47f8:	00001097          	auipc	ra,0x1
    47fc:	e14080e7          	jalr	-492(ra) # 560c <exit>
      link("C0", file);
    4800:	fa840593          	addi	a1,s0,-88
    4804:	00003517          	auipc	a0,0x3
    4808:	34450513          	addi	a0,a0,836 # 7b48 <longjmp_1+0x1f98>
    480c:	00001097          	auipc	ra,0x1
    4810:	e60080e7          	jalr	-416(ra) # 566c <link>
      exit(0);
    4814:	4501                	li	a0,0
    4816:	00001097          	auipc	ra,0x1
    481a:	df6080e7          	jalr	-522(ra) # 560c <exit>
        exit(1);
    481e:	4505                	li	a0,1
    4820:	00001097          	auipc	ra,0x1
    4824:	dec080e7          	jalr	-532(ra) # 560c <exit>
  memset(fa, 0, sizeof(fa));
    4828:	02800613          	li	a2,40
    482c:	4581                	li	a1,0
    482e:	f8040513          	addi	a0,s0,-128
    4832:	00001097          	auipc	ra,0x1
    4836:	bde080e7          	jalr	-1058(ra) # 5410 <memset>
  fd = open(".", 0);
    483a:	4581                	li	a1,0
    483c:	00002517          	auipc	a0,0x2
    4840:	d6c50513          	addi	a0,a0,-660 # 65a8 <longjmp_1+0x9f8>
    4844:	00001097          	auipc	ra,0x1
    4848:	e08080e7          	jalr	-504(ra) # 564c <open>
    484c:	892a                	mv	s2,a0
  n = 0;
    484e:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4850:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4854:	02700b13          	li	s6,39
      fa[i] = 1;
    4858:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    485a:	4641                	li	a2,16
    485c:	f7040593          	addi	a1,s0,-144
    4860:	854a                	mv	a0,s2
    4862:	00001097          	auipc	ra,0x1
    4866:	dc2080e7          	jalr	-574(ra) # 5624 <read>
    486a:	08a05163          	blez	a0,48ec <concreate+0x172>
    if(de.inum == 0)
    486e:	f7045783          	lhu	a5,-144(s0)
    4872:	d7e5                	beqz	a5,485a <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4874:	f7244783          	lbu	a5,-142(s0)
    4878:	ff4791e3          	bne	a5,s4,485a <concreate+0xe0>
    487c:	f7444783          	lbu	a5,-140(s0)
    4880:	ffe9                	bnez	a5,485a <concreate+0xe0>
      i = de.name[1] - '0';
    4882:	f7344783          	lbu	a5,-141(s0)
    4886:	fd07879b          	addiw	a5,a5,-48
    488a:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    488e:	00eb6f63          	bltu	s6,a4,48ac <concreate+0x132>
      if(fa[i]){
    4892:	fb040793          	addi	a5,s0,-80
    4896:	97ba                	add	a5,a5,a4
    4898:	fd07c783          	lbu	a5,-48(a5)
    489c:	eb85                	bnez	a5,48cc <concreate+0x152>
      fa[i] = 1;
    489e:	fb040793          	addi	a5,s0,-80
    48a2:	973e                	add	a4,a4,a5
    48a4:	fd770823          	sb	s7,-48(a4) # fd0 <bigdir+0x6e>
      n++;
    48a8:	2a85                	addiw	s5,s5,1
    48aa:	bf45                	j	485a <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    48ac:	f7240613          	addi	a2,s0,-142
    48b0:	85ce                	mv	a1,s3
    48b2:	00003517          	auipc	a0,0x3
    48b6:	2be50513          	addi	a0,a0,702 # 7b70 <longjmp_1+0x1fc0>
    48ba:	00001097          	auipc	ra,0x1
    48be:	0e2080e7          	jalr	226(ra) # 599c <printf>
        exit(1);
    48c2:	4505                	li	a0,1
    48c4:	00001097          	auipc	ra,0x1
    48c8:	d48080e7          	jalr	-696(ra) # 560c <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    48cc:	f7240613          	addi	a2,s0,-142
    48d0:	85ce                	mv	a1,s3
    48d2:	00003517          	auipc	a0,0x3
    48d6:	2be50513          	addi	a0,a0,702 # 7b90 <longjmp_1+0x1fe0>
    48da:	00001097          	auipc	ra,0x1
    48de:	0c2080e7          	jalr	194(ra) # 599c <printf>
        exit(1);
    48e2:	4505                	li	a0,1
    48e4:	00001097          	auipc	ra,0x1
    48e8:	d28080e7          	jalr	-728(ra) # 560c <exit>
  close(fd);
    48ec:	854a                	mv	a0,s2
    48ee:	00001097          	auipc	ra,0x1
    48f2:	d46080e7          	jalr	-698(ra) # 5634 <close>
  if(n != N){
    48f6:	02800793          	li	a5,40
    48fa:	00fa9763          	bne	s5,a5,4908 <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    48fe:	4a8d                	li	s5,3
    4900:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4902:	02800a13          	li	s4,40
    4906:	a8c9                	j	49d8 <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    4908:	85ce                	mv	a1,s3
    490a:	00003517          	auipc	a0,0x3
    490e:	2ae50513          	addi	a0,a0,686 # 7bb8 <longjmp_1+0x2008>
    4912:	00001097          	auipc	ra,0x1
    4916:	08a080e7          	jalr	138(ra) # 599c <printf>
    exit(1);
    491a:	4505                	li	a0,1
    491c:	00001097          	auipc	ra,0x1
    4920:	cf0080e7          	jalr	-784(ra) # 560c <exit>
      printf("%s: fork failed\n", s);
    4924:	85ce                	mv	a1,s3
    4926:	00002517          	auipc	a0,0x2
    492a:	e2250513          	addi	a0,a0,-478 # 6748 <longjmp_1+0xb98>
    492e:	00001097          	auipc	ra,0x1
    4932:	06e080e7          	jalr	110(ra) # 599c <printf>
      exit(1);
    4936:	4505                	li	a0,1
    4938:	00001097          	auipc	ra,0x1
    493c:	cd4080e7          	jalr	-812(ra) # 560c <exit>
      close(open(file, 0));
    4940:	4581                	li	a1,0
    4942:	fa840513          	addi	a0,s0,-88
    4946:	00001097          	auipc	ra,0x1
    494a:	d06080e7          	jalr	-762(ra) # 564c <open>
    494e:	00001097          	auipc	ra,0x1
    4952:	ce6080e7          	jalr	-794(ra) # 5634 <close>
      close(open(file, 0));
    4956:	4581                	li	a1,0
    4958:	fa840513          	addi	a0,s0,-88
    495c:	00001097          	auipc	ra,0x1
    4960:	cf0080e7          	jalr	-784(ra) # 564c <open>
    4964:	00001097          	auipc	ra,0x1
    4968:	cd0080e7          	jalr	-816(ra) # 5634 <close>
      close(open(file, 0));
    496c:	4581                	li	a1,0
    496e:	fa840513          	addi	a0,s0,-88
    4972:	00001097          	auipc	ra,0x1
    4976:	cda080e7          	jalr	-806(ra) # 564c <open>
    497a:	00001097          	auipc	ra,0x1
    497e:	cba080e7          	jalr	-838(ra) # 5634 <close>
      close(open(file, 0));
    4982:	4581                	li	a1,0
    4984:	fa840513          	addi	a0,s0,-88
    4988:	00001097          	auipc	ra,0x1
    498c:	cc4080e7          	jalr	-828(ra) # 564c <open>
    4990:	00001097          	auipc	ra,0x1
    4994:	ca4080e7          	jalr	-860(ra) # 5634 <close>
      close(open(file, 0));
    4998:	4581                	li	a1,0
    499a:	fa840513          	addi	a0,s0,-88
    499e:	00001097          	auipc	ra,0x1
    49a2:	cae080e7          	jalr	-850(ra) # 564c <open>
    49a6:	00001097          	auipc	ra,0x1
    49aa:	c8e080e7          	jalr	-882(ra) # 5634 <close>
      close(open(file, 0));
    49ae:	4581                	li	a1,0
    49b0:	fa840513          	addi	a0,s0,-88
    49b4:	00001097          	auipc	ra,0x1
    49b8:	c98080e7          	jalr	-872(ra) # 564c <open>
    49bc:	00001097          	auipc	ra,0x1
    49c0:	c78080e7          	jalr	-904(ra) # 5634 <close>
    if(pid == 0)
    49c4:	08090363          	beqz	s2,4a4a <concreate+0x2d0>
      wait(0);
    49c8:	4501                	li	a0,0
    49ca:	00001097          	auipc	ra,0x1
    49ce:	c4a080e7          	jalr	-950(ra) # 5614 <wait>
  for(i = 0; i < N; i++){
    49d2:	2485                	addiw	s1,s1,1
    49d4:	0f448563          	beq	s1,s4,4abe <concreate+0x344>
    file[1] = '0' + i;
    49d8:	0304879b          	addiw	a5,s1,48
    49dc:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    49e0:	00001097          	auipc	ra,0x1
    49e4:	c24080e7          	jalr	-988(ra) # 5604 <fork>
    49e8:	892a                	mv	s2,a0
    if(pid < 0){
    49ea:	f2054de3          	bltz	a0,4924 <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    49ee:	0354e73b          	remw	a4,s1,s5
    49f2:	00a767b3          	or	a5,a4,a0
    49f6:	2781                	sext.w	a5,a5
    49f8:	d7a1                	beqz	a5,4940 <concreate+0x1c6>
    49fa:	01671363          	bne	a4,s6,4a00 <concreate+0x286>
       ((i % 3) == 1 && pid != 0)){
    49fe:	f129                	bnez	a0,4940 <concreate+0x1c6>
      unlink(file);
    4a00:	fa840513          	addi	a0,s0,-88
    4a04:	00001097          	auipc	ra,0x1
    4a08:	c58080e7          	jalr	-936(ra) # 565c <unlink>
      unlink(file);
    4a0c:	fa840513          	addi	a0,s0,-88
    4a10:	00001097          	auipc	ra,0x1
    4a14:	c4c080e7          	jalr	-948(ra) # 565c <unlink>
      unlink(file);
    4a18:	fa840513          	addi	a0,s0,-88
    4a1c:	00001097          	auipc	ra,0x1
    4a20:	c40080e7          	jalr	-960(ra) # 565c <unlink>
      unlink(file);
    4a24:	fa840513          	addi	a0,s0,-88
    4a28:	00001097          	auipc	ra,0x1
    4a2c:	c34080e7          	jalr	-972(ra) # 565c <unlink>
      unlink(file);
    4a30:	fa840513          	addi	a0,s0,-88
    4a34:	00001097          	auipc	ra,0x1
    4a38:	c28080e7          	jalr	-984(ra) # 565c <unlink>
      unlink(file);
    4a3c:	fa840513          	addi	a0,s0,-88
    4a40:	00001097          	auipc	ra,0x1
    4a44:	c1c080e7          	jalr	-996(ra) # 565c <unlink>
    4a48:	bfb5                	j	49c4 <concreate+0x24a>
      exit(0);
    4a4a:	4501                	li	a0,0
    4a4c:	00001097          	auipc	ra,0x1
    4a50:	bc0080e7          	jalr	-1088(ra) # 560c <exit>
      close(fd);
    4a54:	00001097          	auipc	ra,0x1
    4a58:	be0080e7          	jalr	-1056(ra) # 5634 <close>
    if(pid == 0) {
    4a5c:	bb65                	j	4814 <concreate+0x9a>
      close(fd);
    4a5e:	00001097          	auipc	ra,0x1
    4a62:	bd6080e7          	jalr	-1066(ra) # 5634 <close>
      wait(&xstatus);
    4a66:	f6c40513          	addi	a0,s0,-148
    4a6a:	00001097          	auipc	ra,0x1
    4a6e:	baa080e7          	jalr	-1110(ra) # 5614 <wait>
      if(xstatus != 0)
    4a72:	f6c42483          	lw	s1,-148(s0)
    4a76:	da0494e3          	bnez	s1,481e <concreate+0xa4>
  for(i = 0; i < N; i++){
    4a7a:	2905                	addiw	s2,s2,1
    4a7c:	db4906e3          	beq	s2,s4,4828 <concreate+0xae>
    file[1] = '0' + i;
    4a80:	0309079b          	addiw	a5,s2,48
    4a84:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4a88:	fa840513          	addi	a0,s0,-88
    4a8c:	00001097          	auipc	ra,0x1
    4a90:	bd0080e7          	jalr	-1072(ra) # 565c <unlink>
    pid = fork();
    4a94:	00001097          	auipc	ra,0x1
    4a98:	b70080e7          	jalr	-1168(ra) # 5604 <fork>
    if(pid && (i % 3) == 1){
    4a9c:	d20503e3          	beqz	a0,47c2 <concreate+0x48>
    4aa0:	036967bb          	remw	a5,s2,s6
    4aa4:	d15787e3          	beq	a5,s5,47b2 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4aa8:	20200593          	li	a1,514
    4aac:	fa840513          	addi	a0,s0,-88
    4ab0:	00001097          	auipc	ra,0x1
    4ab4:	b9c080e7          	jalr	-1124(ra) # 564c <open>
      if(fd < 0){
    4ab8:	fa0553e3          	bgez	a0,4a5e <concreate+0x2e4>
    4abc:	b31d                	j	47e2 <concreate+0x68>
}
    4abe:	60ea                	ld	ra,152(sp)
    4ac0:	644a                	ld	s0,144(sp)
    4ac2:	64aa                	ld	s1,136(sp)
    4ac4:	690a                	ld	s2,128(sp)
    4ac6:	79e6                	ld	s3,120(sp)
    4ac8:	7a46                	ld	s4,112(sp)
    4aca:	7aa6                	ld	s5,104(sp)
    4acc:	7b06                	ld	s6,96(sp)
    4ace:	6be6                	ld	s7,88(sp)
    4ad0:	610d                	addi	sp,sp,160
    4ad2:	8082                	ret

0000000000004ad4 <bigfile>:
{
    4ad4:	7139                	addi	sp,sp,-64
    4ad6:	fc06                	sd	ra,56(sp)
    4ad8:	f822                	sd	s0,48(sp)
    4ada:	f426                	sd	s1,40(sp)
    4adc:	f04a                	sd	s2,32(sp)
    4ade:	ec4e                	sd	s3,24(sp)
    4ae0:	e852                	sd	s4,16(sp)
    4ae2:	e456                	sd	s5,8(sp)
    4ae4:	0080                	addi	s0,sp,64
    4ae6:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4ae8:	00003517          	auipc	a0,0x3
    4aec:	10850513          	addi	a0,a0,264 # 7bf0 <longjmp_1+0x2040>
    4af0:	00001097          	auipc	ra,0x1
    4af4:	b6c080e7          	jalr	-1172(ra) # 565c <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4af8:	20200593          	li	a1,514
    4afc:	00003517          	auipc	a0,0x3
    4b00:	0f450513          	addi	a0,a0,244 # 7bf0 <longjmp_1+0x2040>
    4b04:	00001097          	auipc	ra,0x1
    4b08:	b48080e7          	jalr	-1208(ra) # 564c <open>
    4b0c:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    4b0e:	4481                	li	s1,0
    memset(buf, i, SZ);
    4b10:	00007917          	auipc	s2,0x7
    4b14:	01890913          	addi	s2,s2,24 # bb28 <buf>
  for(i = 0; i < N; i++){
    4b18:	4a51                	li	s4,20
  if(fd < 0){
    4b1a:	0a054063          	bltz	a0,4bba <bigfile+0xe6>
    memset(buf, i, SZ);
    4b1e:	25800613          	li	a2,600
    4b22:	85a6                	mv	a1,s1
    4b24:	854a                	mv	a0,s2
    4b26:	00001097          	auipc	ra,0x1
    4b2a:	8ea080e7          	jalr	-1814(ra) # 5410 <memset>
    if(write(fd, buf, SZ) != SZ){
    4b2e:	25800613          	li	a2,600
    4b32:	85ca                	mv	a1,s2
    4b34:	854e                	mv	a0,s3
    4b36:	00001097          	auipc	ra,0x1
    4b3a:	af6080e7          	jalr	-1290(ra) # 562c <write>
    4b3e:	25800793          	li	a5,600
    4b42:	08f51a63          	bne	a0,a5,4bd6 <bigfile+0x102>
  for(i = 0; i < N; i++){
    4b46:	2485                	addiw	s1,s1,1
    4b48:	fd449be3          	bne	s1,s4,4b1e <bigfile+0x4a>
  close(fd);
    4b4c:	854e                	mv	a0,s3
    4b4e:	00001097          	auipc	ra,0x1
    4b52:	ae6080e7          	jalr	-1306(ra) # 5634 <close>
  fd = open("bigfile.dat", 0);
    4b56:	4581                	li	a1,0
    4b58:	00003517          	auipc	a0,0x3
    4b5c:	09850513          	addi	a0,a0,152 # 7bf0 <longjmp_1+0x2040>
    4b60:	00001097          	auipc	ra,0x1
    4b64:	aec080e7          	jalr	-1300(ra) # 564c <open>
    4b68:	8a2a                	mv	s4,a0
  total = 0;
    4b6a:	4981                	li	s3,0
  for(i = 0; ; i++){
    4b6c:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4b6e:	00007917          	auipc	s2,0x7
    4b72:	fba90913          	addi	s2,s2,-70 # bb28 <buf>
  if(fd < 0){
    4b76:	06054e63          	bltz	a0,4bf2 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    4b7a:	12c00613          	li	a2,300
    4b7e:	85ca                	mv	a1,s2
    4b80:	8552                	mv	a0,s4
    4b82:	00001097          	auipc	ra,0x1
    4b86:	aa2080e7          	jalr	-1374(ra) # 5624 <read>
    if(cc < 0){
    4b8a:	08054263          	bltz	a0,4c0e <bigfile+0x13a>
    if(cc == 0)
    4b8e:	c971                	beqz	a0,4c62 <bigfile+0x18e>
    if(cc != SZ/2){
    4b90:	12c00793          	li	a5,300
    4b94:	08f51b63          	bne	a0,a5,4c2a <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4b98:	01f4d79b          	srliw	a5,s1,0x1f
    4b9c:	9fa5                	addw	a5,a5,s1
    4b9e:	4017d79b          	sraiw	a5,a5,0x1
    4ba2:	00094703          	lbu	a4,0(s2)
    4ba6:	0af71063          	bne	a4,a5,4c46 <bigfile+0x172>
    4baa:	12b94703          	lbu	a4,299(s2)
    4bae:	08f71c63          	bne	a4,a5,4c46 <bigfile+0x172>
    total += cc;
    4bb2:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    4bb6:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4bb8:	b7c9                	j	4b7a <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4bba:	85d6                	mv	a1,s5
    4bbc:	00003517          	auipc	a0,0x3
    4bc0:	04450513          	addi	a0,a0,68 # 7c00 <longjmp_1+0x2050>
    4bc4:	00001097          	auipc	ra,0x1
    4bc8:	dd8080e7          	jalr	-552(ra) # 599c <printf>
    exit(1);
    4bcc:	4505                	li	a0,1
    4bce:	00001097          	auipc	ra,0x1
    4bd2:	a3e080e7          	jalr	-1474(ra) # 560c <exit>
      printf("%s: write bigfile failed\n", s);
    4bd6:	85d6                	mv	a1,s5
    4bd8:	00003517          	auipc	a0,0x3
    4bdc:	04850513          	addi	a0,a0,72 # 7c20 <longjmp_1+0x2070>
    4be0:	00001097          	auipc	ra,0x1
    4be4:	dbc080e7          	jalr	-580(ra) # 599c <printf>
      exit(1);
    4be8:	4505                	li	a0,1
    4bea:	00001097          	auipc	ra,0x1
    4bee:	a22080e7          	jalr	-1502(ra) # 560c <exit>
    printf("%s: cannot open bigfile\n", s);
    4bf2:	85d6                	mv	a1,s5
    4bf4:	00003517          	auipc	a0,0x3
    4bf8:	04c50513          	addi	a0,a0,76 # 7c40 <longjmp_1+0x2090>
    4bfc:	00001097          	auipc	ra,0x1
    4c00:	da0080e7          	jalr	-608(ra) # 599c <printf>
    exit(1);
    4c04:	4505                	li	a0,1
    4c06:	00001097          	auipc	ra,0x1
    4c0a:	a06080e7          	jalr	-1530(ra) # 560c <exit>
      printf("%s: read bigfile failed\n", s);
    4c0e:	85d6                	mv	a1,s5
    4c10:	00003517          	auipc	a0,0x3
    4c14:	05050513          	addi	a0,a0,80 # 7c60 <longjmp_1+0x20b0>
    4c18:	00001097          	auipc	ra,0x1
    4c1c:	d84080e7          	jalr	-636(ra) # 599c <printf>
      exit(1);
    4c20:	4505                	li	a0,1
    4c22:	00001097          	auipc	ra,0x1
    4c26:	9ea080e7          	jalr	-1558(ra) # 560c <exit>
      printf("%s: short read bigfile\n", s);
    4c2a:	85d6                	mv	a1,s5
    4c2c:	00003517          	auipc	a0,0x3
    4c30:	05450513          	addi	a0,a0,84 # 7c80 <longjmp_1+0x20d0>
    4c34:	00001097          	auipc	ra,0x1
    4c38:	d68080e7          	jalr	-664(ra) # 599c <printf>
      exit(1);
    4c3c:	4505                	li	a0,1
    4c3e:	00001097          	auipc	ra,0x1
    4c42:	9ce080e7          	jalr	-1586(ra) # 560c <exit>
      printf("%s: read bigfile wrong data\n", s);
    4c46:	85d6                	mv	a1,s5
    4c48:	00003517          	auipc	a0,0x3
    4c4c:	05050513          	addi	a0,a0,80 # 7c98 <longjmp_1+0x20e8>
    4c50:	00001097          	auipc	ra,0x1
    4c54:	d4c080e7          	jalr	-692(ra) # 599c <printf>
      exit(1);
    4c58:	4505                	li	a0,1
    4c5a:	00001097          	auipc	ra,0x1
    4c5e:	9b2080e7          	jalr	-1614(ra) # 560c <exit>
  close(fd);
    4c62:	8552                	mv	a0,s4
    4c64:	00001097          	auipc	ra,0x1
    4c68:	9d0080e7          	jalr	-1584(ra) # 5634 <close>
  if(total != N*SZ){
    4c6c:	678d                	lui	a5,0x3
    4c6e:	ee078793          	addi	a5,a5,-288 # 2ee0 <exitiputtest+0x48>
    4c72:	02f99363          	bne	s3,a5,4c98 <bigfile+0x1c4>
  unlink("bigfile.dat");
    4c76:	00003517          	auipc	a0,0x3
    4c7a:	f7a50513          	addi	a0,a0,-134 # 7bf0 <longjmp_1+0x2040>
    4c7e:	00001097          	auipc	ra,0x1
    4c82:	9de080e7          	jalr	-1570(ra) # 565c <unlink>
}
    4c86:	70e2                	ld	ra,56(sp)
    4c88:	7442                	ld	s0,48(sp)
    4c8a:	74a2                	ld	s1,40(sp)
    4c8c:	7902                	ld	s2,32(sp)
    4c8e:	69e2                	ld	s3,24(sp)
    4c90:	6a42                	ld	s4,16(sp)
    4c92:	6aa2                	ld	s5,8(sp)
    4c94:	6121                	addi	sp,sp,64
    4c96:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4c98:	85d6                	mv	a1,s5
    4c9a:	00003517          	auipc	a0,0x3
    4c9e:	01e50513          	addi	a0,a0,30 # 7cb8 <longjmp_1+0x2108>
    4ca2:	00001097          	auipc	ra,0x1
    4ca6:	cfa080e7          	jalr	-774(ra) # 599c <printf>
    exit(1);
    4caa:	4505                	li	a0,1
    4cac:	00001097          	auipc	ra,0x1
    4cb0:	960080e7          	jalr	-1696(ra) # 560c <exit>

0000000000004cb4 <fsfull>:
{
    4cb4:	7171                	addi	sp,sp,-176
    4cb6:	f506                	sd	ra,168(sp)
    4cb8:	f122                	sd	s0,160(sp)
    4cba:	ed26                	sd	s1,152(sp)
    4cbc:	e94a                	sd	s2,144(sp)
    4cbe:	e54e                	sd	s3,136(sp)
    4cc0:	e152                	sd	s4,128(sp)
    4cc2:	fcd6                	sd	s5,120(sp)
    4cc4:	f8da                	sd	s6,112(sp)
    4cc6:	f4de                	sd	s7,104(sp)
    4cc8:	f0e2                	sd	s8,96(sp)
    4cca:	ece6                	sd	s9,88(sp)
    4ccc:	e8ea                	sd	s10,80(sp)
    4cce:	e4ee                	sd	s11,72(sp)
    4cd0:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4cd2:	00003517          	auipc	a0,0x3
    4cd6:	00650513          	addi	a0,a0,6 # 7cd8 <longjmp_1+0x2128>
    4cda:	00001097          	auipc	ra,0x1
    4cde:	cc2080e7          	jalr	-830(ra) # 599c <printf>
  for(nfiles = 0; ; nfiles++){
    4ce2:	4481                	li	s1,0
    name[0] = 'f';
    4ce4:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4ce8:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4cec:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4cf0:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4cf2:	00003c97          	auipc	s9,0x3
    4cf6:	ff6c8c93          	addi	s9,s9,-10 # 7ce8 <longjmp_1+0x2138>
    int total = 0;
    4cfa:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    4cfc:	00007a17          	auipc	s4,0x7
    4d00:	e2ca0a13          	addi	s4,s4,-468 # bb28 <buf>
    name[0] = 'f';
    4d04:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4d08:	0384c7bb          	divw	a5,s1,s8
    4d0c:	0307879b          	addiw	a5,a5,48
    4d10:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4d14:	0384e7bb          	remw	a5,s1,s8
    4d18:	0377c7bb          	divw	a5,a5,s7
    4d1c:	0307879b          	addiw	a5,a5,48
    4d20:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4d24:	0374e7bb          	remw	a5,s1,s7
    4d28:	0367c7bb          	divw	a5,a5,s6
    4d2c:	0307879b          	addiw	a5,a5,48
    4d30:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4d34:	0364e7bb          	remw	a5,s1,s6
    4d38:	0307879b          	addiw	a5,a5,48
    4d3c:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4d40:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4d44:	f5040593          	addi	a1,s0,-176
    4d48:	8566                	mv	a0,s9
    4d4a:	00001097          	auipc	ra,0x1
    4d4e:	c52080e7          	jalr	-942(ra) # 599c <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4d52:	20200593          	li	a1,514
    4d56:	f5040513          	addi	a0,s0,-176
    4d5a:	00001097          	auipc	ra,0x1
    4d5e:	8f2080e7          	jalr	-1806(ra) # 564c <open>
    4d62:	892a                	mv	s2,a0
    if(fd < 0){
    4d64:	0a055663          	bgez	a0,4e10 <fsfull+0x15c>
      printf("open %s failed\n", name);
    4d68:	f5040593          	addi	a1,s0,-176
    4d6c:	00003517          	auipc	a0,0x3
    4d70:	f8c50513          	addi	a0,a0,-116 # 7cf8 <longjmp_1+0x2148>
    4d74:	00001097          	auipc	ra,0x1
    4d78:	c28080e7          	jalr	-984(ra) # 599c <printf>
  while(nfiles >= 0){
    4d7c:	0604c363          	bltz	s1,4de2 <fsfull+0x12e>
    name[0] = 'f';
    4d80:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4d84:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4d88:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4d8c:	4929                	li	s2,10
  while(nfiles >= 0){
    4d8e:	5afd                	li	s5,-1
    name[0] = 'f';
    4d90:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4d94:	0344c7bb          	divw	a5,s1,s4
    4d98:	0307879b          	addiw	a5,a5,48
    4d9c:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4da0:	0344e7bb          	remw	a5,s1,s4
    4da4:	0337c7bb          	divw	a5,a5,s3
    4da8:	0307879b          	addiw	a5,a5,48
    4dac:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4db0:	0334e7bb          	remw	a5,s1,s3
    4db4:	0327c7bb          	divw	a5,a5,s2
    4db8:	0307879b          	addiw	a5,a5,48
    4dbc:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4dc0:	0324e7bb          	remw	a5,s1,s2
    4dc4:	0307879b          	addiw	a5,a5,48
    4dc8:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4dcc:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4dd0:	f5040513          	addi	a0,s0,-176
    4dd4:	00001097          	auipc	ra,0x1
    4dd8:	888080e7          	jalr	-1912(ra) # 565c <unlink>
    nfiles--;
    4ddc:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    4dde:	fb5499e3          	bne	s1,s5,4d90 <fsfull+0xdc>
  printf("fsfull test finished\n");
    4de2:	00003517          	auipc	a0,0x3
    4de6:	f3650513          	addi	a0,a0,-202 # 7d18 <longjmp_1+0x2168>
    4dea:	00001097          	auipc	ra,0x1
    4dee:	bb2080e7          	jalr	-1102(ra) # 599c <printf>
}
    4df2:	70aa                	ld	ra,168(sp)
    4df4:	740a                	ld	s0,160(sp)
    4df6:	64ea                	ld	s1,152(sp)
    4df8:	694a                	ld	s2,144(sp)
    4dfa:	69aa                	ld	s3,136(sp)
    4dfc:	6a0a                	ld	s4,128(sp)
    4dfe:	7ae6                	ld	s5,120(sp)
    4e00:	7b46                	ld	s6,112(sp)
    4e02:	7ba6                	ld	s7,104(sp)
    4e04:	7c06                	ld	s8,96(sp)
    4e06:	6ce6                	ld	s9,88(sp)
    4e08:	6d46                	ld	s10,80(sp)
    4e0a:	6da6                	ld	s11,72(sp)
    4e0c:	614d                	addi	sp,sp,176
    4e0e:	8082                	ret
    int total = 0;
    4e10:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    4e12:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    4e16:	40000613          	li	a2,1024
    4e1a:	85d2                	mv	a1,s4
    4e1c:	854a                	mv	a0,s2
    4e1e:	00001097          	auipc	ra,0x1
    4e22:	80e080e7          	jalr	-2034(ra) # 562c <write>
      if(cc < BSIZE)
    4e26:	00aad563          	bge	s5,a0,4e30 <fsfull+0x17c>
      total += cc;
    4e2a:	00a989bb          	addw	s3,s3,a0
    while(1){
    4e2e:	b7e5                	j	4e16 <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    4e30:	85ce                	mv	a1,s3
    4e32:	00003517          	auipc	a0,0x3
    4e36:	ed650513          	addi	a0,a0,-298 # 7d08 <longjmp_1+0x2158>
    4e3a:	00001097          	auipc	ra,0x1
    4e3e:	b62080e7          	jalr	-1182(ra) # 599c <printf>
    close(fd);
    4e42:	854a                	mv	a0,s2
    4e44:	00000097          	auipc	ra,0x0
    4e48:	7f0080e7          	jalr	2032(ra) # 5634 <close>
    if(total == 0)
    4e4c:	f20988e3          	beqz	s3,4d7c <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    4e50:	2485                	addiw	s1,s1,1
    4e52:	bd4d                	j	4d04 <fsfull+0x50>

0000000000004e54 <rand>:
{
    4e54:	1141                	addi	sp,sp,-16
    4e56:	e422                	sd	s0,8(sp)
    4e58:	0800                	addi	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    4e5a:	00003717          	auipc	a4,0x3
    4e5e:	4a670713          	addi	a4,a4,1190 # 8300 <randstate>
    4e62:	6308                	ld	a0,0(a4)
    4e64:	001967b7          	lui	a5,0x196
    4e68:	60d78793          	addi	a5,a5,1549 # 19660d <__BSS_END__+0x187ad5>
    4e6c:	02f50533          	mul	a0,a0,a5
    4e70:	3c6ef7b7          	lui	a5,0x3c6ef
    4e74:	35f78793          	addi	a5,a5,863 # 3c6ef35f <__BSS_END__+0x3c6e0827>
    4e78:	953e                	add	a0,a0,a5
    4e7a:	e308                	sd	a0,0(a4)
}
    4e7c:	2501                	sext.w	a0,a0
    4e7e:	6422                	ld	s0,8(sp)
    4e80:	0141                	addi	sp,sp,16
    4e82:	8082                	ret

0000000000004e84 <badwrite>:
{
    4e84:	7179                	addi	sp,sp,-48
    4e86:	f406                	sd	ra,40(sp)
    4e88:	f022                	sd	s0,32(sp)
    4e8a:	ec26                	sd	s1,24(sp)
    4e8c:	e84a                	sd	s2,16(sp)
    4e8e:	e44e                	sd	s3,8(sp)
    4e90:	e052                	sd	s4,0(sp)
    4e92:	1800                	addi	s0,sp,48
  unlink("junk");
    4e94:	00003517          	auipc	a0,0x3
    4e98:	e9c50513          	addi	a0,a0,-356 # 7d30 <longjmp_1+0x2180>
    4e9c:	00000097          	auipc	ra,0x0
    4ea0:	7c0080e7          	jalr	1984(ra) # 565c <unlink>
    4ea4:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    4ea8:	00003997          	auipc	s3,0x3
    4eac:	e8898993          	addi	s3,s3,-376 # 7d30 <longjmp_1+0x2180>
    write(fd, (char*)0xffffffffffL, 1);
    4eb0:	5a7d                	li	s4,-1
    4eb2:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    4eb6:	20100593          	li	a1,513
    4eba:	854e                	mv	a0,s3
    4ebc:	00000097          	auipc	ra,0x0
    4ec0:	790080e7          	jalr	1936(ra) # 564c <open>
    4ec4:	84aa                	mv	s1,a0
    if(fd < 0){
    4ec6:	06054b63          	bltz	a0,4f3c <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    4eca:	4605                	li	a2,1
    4ecc:	85d2                	mv	a1,s4
    4ece:	00000097          	auipc	ra,0x0
    4ed2:	75e080e7          	jalr	1886(ra) # 562c <write>
    close(fd);
    4ed6:	8526                	mv	a0,s1
    4ed8:	00000097          	auipc	ra,0x0
    4edc:	75c080e7          	jalr	1884(ra) # 5634 <close>
    unlink("junk");
    4ee0:	854e                	mv	a0,s3
    4ee2:	00000097          	auipc	ra,0x0
    4ee6:	77a080e7          	jalr	1914(ra) # 565c <unlink>
  for(int i = 0; i < assumed_free; i++){
    4eea:	397d                	addiw	s2,s2,-1
    4eec:	fc0915e3          	bnez	s2,4eb6 <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    4ef0:	20100593          	li	a1,513
    4ef4:	00003517          	auipc	a0,0x3
    4ef8:	e3c50513          	addi	a0,a0,-452 # 7d30 <longjmp_1+0x2180>
    4efc:	00000097          	auipc	ra,0x0
    4f00:	750080e7          	jalr	1872(ra) # 564c <open>
    4f04:	84aa                	mv	s1,a0
  if(fd < 0){
    4f06:	04054863          	bltz	a0,4f56 <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    4f0a:	4605                	li	a2,1
    4f0c:	00001597          	auipc	a1,0x1
    4f10:	07458593          	addi	a1,a1,116 # 5f80 <longjmp_1+0x3d0>
    4f14:	00000097          	auipc	ra,0x0
    4f18:	718080e7          	jalr	1816(ra) # 562c <write>
    4f1c:	4785                	li	a5,1
    4f1e:	04f50963          	beq	a0,a5,4f70 <badwrite+0xec>
    printf("write failed\n");
    4f22:	00003517          	auipc	a0,0x3
    4f26:	e2e50513          	addi	a0,a0,-466 # 7d50 <longjmp_1+0x21a0>
    4f2a:	00001097          	auipc	ra,0x1
    4f2e:	a72080e7          	jalr	-1422(ra) # 599c <printf>
    exit(1);
    4f32:	4505                	li	a0,1
    4f34:	00000097          	auipc	ra,0x0
    4f38:	6d8080e7          	jalr	1752(ra) # 560c <exit>
      printf("open junk failed\n");
    4f3c:	00003517          	auipc	a0,0x3
    4f40:	dfc50513          	addi	a0,a0,-516 # 7d38 <longjmp_1+0x2188>
    4f44:	00001097          	auipc	ra,0x1
    4f48:	a58080e7          	jalr	-1448(ra) # 599c <printf>
      exit(1);
    4f4c:	4505                	li	a0,1
    4f4e:	00000097          	auipc	ra,0x0
    4f52:	6be080e7          	jalr	1726(ra) # 560c <exit>
    printf("open junk failed\n");
    4f56:	00003517          	auipc	a0,0x3
    4f5a:	de250513          	addi	a0,a0,-542 # 7d38 <longjmp_1+0x2188>
    4f5e:	00001097          	auipc	ra,0x1
    4f62:	a3e080e7          	jalr	-1474(ra) # 599c <printf>
    exit(1);
    4f66:	4505                	li	a0,1
    4f68:	00000097          	auipc	ra,0x0
    4f6c:	6a4080e7          	jalr	1700(ra) # 560c <exit>
  close(fd);
    4f70:	8526                	mv	a0,s1
    4f72:	00000097          	auipc	ra,0x0
    4f76:	6c2080e7          	jalr	1730(ra) # 5634 <close>
  unlink("junk");
    4f7a:	00003517          	auipc	a0,0x3
    4f7e:	db650513          	addi	a0,a0,-586 # 7d30 <longjmp_1+0x2180>
    4f82:	00000097          	auipc	ra,0x0
    4f86:	6da080e7          	jalr	1754(ra) # 565c <unlink>
  exit(0);
    4f8a:	4501                	li	a0,0
    4f8c:	00000097          	auipc	ra,0x0
    4f90:	680080e7          	jalr	1664(ra) # 560c <exit>

0000000000004f94 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    4f94:	7139                	addi	sp,sp,-64
    4f96:	fc06                	sd	ra,56(sp)
    4f98:	f822                	sd	s0,48(sp)
    4f9a:	f426                	sd	s1,40(sp)
    4f9c:	f04a                	sd	s2,32(sp)
    4f9e:	ec4e                	sd	s3,24(sp)
    4fa0:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    4fa2:	fc840513          	addi	a0,s0,-56
    4fa6:	00000097          	auipc	ra,0x0
    4faa:	676080e7          	jalr	1654(ra) # 561c <pipe>
    4fae:	06054763          	bltz	a0,501c <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    4fb2:	00000097          	auipc	ra,0x0
    4fb6:	652080e7          	jalr	1618(ra) # 5604 <fork>

  if(pid < 0){
    4fba:	06054e63          	bltz	a0,5036 <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    4fbe:	ed51                	bnez	a0,505a <countfree+0xc6>
    close(fds[0]);
    4fc0:	fc842503          	lw	a0,-56(s0)
    4fc4:	00000097          	auipc	ra,0x0
    4fc8:	670080e7          	jalr	1648(ra) # 5634 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    4fcc:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    4fce:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    4fd0:	00001997          	auipc	s3,0x1
    4fd4:	fb098993          	addi	s3,s3,-80 # 5f80 <longjmp_1+0x3d0>
      uint64 a = (uint64) sbrk(4096);
    4fd8:	6505                	lui	a0,0x1
    4fda:	00000097          	auipc	ra,0x0
    4fde:	6ba080e7          	jalr	1722(ra) # 5694 <sbrk>
      if(a == 0xffffffffffffffff){
    4fe2:	07250763          	beq	a0,s2,5050 <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    4fe6:	6785                	lui	a5,0x1
    4fe8:	953e                	add	a0,a0,a5
    4fea:	fe950fa3          	sb	s1,-1(a0) # fff <bigdir+0x9d>
      if(write(fds[1], "x", 1) != 1){
    4fee:	8626                	mv	a2,s1
    4ff0:	85ce                	mv	a1,s3
    4ff2:	fcc42503          	lw	a0,-52(s0)
    4ff6:	00000097          	auipc	ra,0x0
    4ffa:	636080e7          	jalr	1590(ra) # 562c <write>
    4ffe:	fc950de3          	beq	a0,s1,4fd8 <countfree+0x44>
        printf("write() failed in countfree()\n");
    5002:	00003517          	auipc	a0,0x3
    5006:	d9e50513          	addi	a0,a0,-610 # 7da0 <longjmp_1+0x21f0>
    500a:	00001097          	auipc	ra,0x1
    500e:	992080e7          	jalr	-1646(ra) # 599c <printf>
        exit(1);
    5012:	4505                	li	a0,1
    5014:	00000097          	auipc	ra,0x0
    5018:	5f8080e7          	jalr	1528(ra) # 560c <exit>
    printf("pipe() failed in countfree()\n");
    501c:	00003517          	auipc	a0,0x3
    5020:	d4450513          	addi	a0,a0,-700 # 7d60 <longjmp_1+0x21b0>
    5024:	00001097          	auipc	ra,0x1
    5028:	978080e7          	jalr	-1672(ra) # 599c <printf>
    exit(1);
    502c:	4505                	li	a0,1
    502e:	00000097          	auipc	ra,0x0
    5032:	5de080e7          	jalr	1502(ra) # 560c <exit>
    printf("fork failed in countfree()\n");
    5036:	00003517          	auipc	a0,0x3
    503a:	d4a50513          	addi	a0,a0,-694 # 7d80 <longjmp_1+0x21d0>
    503e:	00001097          	auipc	ra,0x1
    5042:	95e080e7          	jalr	-1698(ra) # 599c <printf>
    exit(1);
    5046:	4505                	li	a0,1
    5048:	00000097          	auipc	ra,0x0
    504c:	5c4080e7          	jalr	1476(ra) # 560c <exit>
      }
    }

    exit(0);
    5050:	4501                	li	a0,0
    5052:	00000097          	auipc	ra,0x0
    5056:	5ba080e7          	jalr	1466(ra) # 560c <exit>
  }

  close(fds[1]);
    505a:	fcc42503          	lw	a0,-52(s0)
    505e:	00000097          	auipc	ra,0x0
    5062:	5d6080e7          	jalr	1494(ra) # 5634 <close>

  int n = 0;
    5066:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    5068:	4605                	li	a2,1
    506a:	fc740593          	addi	a1,s0,-57
    506e:	fc842503          	lw	a0,-56(s0)
    5072:	00000097          	auipc	ra,0x0
    5076:	5b2080e7          	jalr	1458(ra) # 5624 <read>
    if(cc < 0){
    507a:	00054563          	bltz	a0,5084 <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    507e:	c105                	beqz	a0,509e <countfree+0x10a>
      break;
    n += 1;
    5080:	2485                	addiw	s1,s1,1
  while(1){
    5082:	b7dd                	j	5068 <countfree+0xd4>
      printf("read() failed in countfree()\n");
    5084:	00003517          	auipc	a0,0x3
    5088:	d3c50513          	addi	a0,a0,-708 # 7dc0 <longjmp_1+0x2210>
    508c:	00001097          	auipc	ra,0x1
    5090:	910080e7          	jalr	-1776(ra) # 599c <printf>
      exit(1);
    5094:	4505                	li	a0,1
    5096:	00000097          	auipc	ra,0x0
    509a:	576080e7          	jalr	1398(ra) # 560c <exit>
  }

  close(fds[0]);
    509e:	fc842503          	lw	a0,-56(s0)
    50a2:	00000097          	auipc	ra,0x0
    50a6:	592080e7          	jalr	1426(ra) # 5634 <close>
  wait((int*)0);
    50aa:	4501                	li	a0,0
    50ac:	00000097          	auipc	ra,0x0
    50b0:	568080e7          	jalr	1384(ra) # 5614 <wait>
  
  return n;
}
    50b4:	8526                	mv	a0,s1
    50b6:	70e2                	ld	ra,56(sp)
    50b8:	7442                	ld	s0,48(sp)
    50ba:	74a2                	ld	s1,40(sp)
    50bc:	7902                	ld	s2,32(sp)
    50be:	69e2                	ld	s3,24(sp)
    50c0:	6121                	addi	sp,sp,64
    50c2:	8082                	ret

00000000000050c4 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    50c4:	7179                	addi	sp,sp,-48
    50c6:	f406                	sd	ra,40(sp)
    50c8:	f022                	sd	s0,32(sp)
    50ca:	ec26                	sd	s1,24(sp)
    50cc:	e84a                	sd	s2,16(sp)
    50ce:	1800                	addi	s0,sp,48
    50d0:	84aa                	mv	s1,a0
    50d2:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    50d4:	00003517          	auipc	a0,0x3
    50d8:	d0c50513          	addi	a0,a0,-756 # 7de0 <longjmp_1+0x2230>
    50dc:	00001097          	auipc	ra,0x1
    50e0:	8c0080e7          	jalr	-1856(ra) # 599c <printf>
  if((pid = fork()) < 0) {
    50e4:	00000097          	auipc	ra,0x0
    50e8:	520080e7          	jalr	1312(ra) # 5604 <fork>
    50ec:	02054e63          	bltz	a0,5128 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    50f0:	c929                	beqz	a0,5142 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    50f2:	fdc40513          	addi	a0,s0,-36
    50f6:	00000097          	auipc	ra,0x0
    50fa:	51e080e7          	jalr	1310(ra) # 5614 <wait>
    if(xstatus != 0) 
    50fe:	fdc42783          	lw	a5,-36(s0)
    5102:	c7b9                	beqz	a5,5150 <run+0x8c>
      printf("FAILED\n");
    5104:	00003517          	auipc	a0,0x3
    5108:	d0450513          	addi	a0,a0,-764 # 7e08 <longjmp_1+0x2258>
    510c:	00001097          	auipc	ra,0x1
    5110:	890080e7          	jalr	-1904(ra) # 599c <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    5114:	fdc42503          	lw	a0,-36(s0)
  }
}
    5118:	00153513          	seqz	a0,a0
    511c:	70a2                	ld	ra,40(sp)
    511e:	7402                	ld	s0,32(sp)
    5120:	64e2                	ld	s1,24(sp)
    5122:	6942                	ld	s2,16(sp)
    5124:	6145                	addi	sp,sp,48
    5126:	8082                	ret
    printf("runtest: fork error\n");
    5128:	00003517          	auipc	a0,0x3
    512c:	cc850513          	addi	a0,a0,-824 # 7df0 <longjmp_1+0x2240>
    5130:	00001097          	auipc	ra,0x1
    5134:	86c080e7          	jalr	-1940(ra) # 599c <printf>
    exit(1);
    5138:	4505                	li	a0,1
    513a:	00000097          	auipc	ra,0x0
    513e:	4d2080e7          	jalr	1234(ra) # 560c <exit>
    f(s);
    5142:	854a                	mv	a0,s2
    5144:	9482                	jalr	s1
    exit(0);
    5146:	4501                	li	a0,0
    5148:	00000097          	auipc	ra,0x0
    514c:	4c4080e7          	jalr	1220(ra) # 560c <exit>
      printf("OK\n");
    5150:	00003517          	auipc	a0,0x3
    5154:	cc050513          	addi	a0,a0,-832 # 7e10 <longjmp_1+0x2260>
    5158:	00001097          	auipc	ra,0x1
    515c:	844080e7          	jalr	-1980(ra) # 599c <printf>
    5160:	bf55                	j	5114 <run+0x50>

0000000000005162 <main>:

int
main(int argc, char *argv[])
{
    5162:	c1010113          	addi	sp,sp,-1008
    5166:	3e113423          	sd	ra,1000(sp)
    516a:	3e813023          	sd	s0,992(sp)
    516e:	3c913c23          	sd	s1,984(sp)
    5172:	3d213823          	sd	s2,976(sp)
    5176:	3d313423          	sd	s3,968(sp)
    517a:	3d413023          	sd	s4,960(sp)
    517e:	3b513c23          	sd	s5,952(sp)
    5182:	3b613823          	sd	s6,944(sp)
    5186:	1f80                	addi	s0,sp,1008
    5188:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    518a:	4789                	li	a5,2
    518c:	08f50b63          	beq	a0,a5,5222 <main+0xc0>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    5190:	4785                	li	a5,1
  char *justone = 0;
    5192:	4901                	li	s2,0
  } else if(argc > 1){
    5194:	0ca7c563          	blt	a5,a0,525e <main+0xfc>
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    5198:	00003797          	auipc	a5,0x3
    519c:	d9078793          	addi	a5,a5,-624 # 7f28 <longjmp_1+0x2378>
    51a0:	c1040713          	addi	a4,s0,-1008
    51a4:	00003817          	auipc	a6,0x3
    51a8:	12480813          	addi	a6,a6,292 # 82c8 <longjmp_1+0x2718>
    51ac:	6388                	ld	a0,0(a5)
    51ae:	678c                	ld	a1,8(a5)
    51b0:	6b90                	ld	a2,16(a5)
    51b2:	6f94                	ld	a3,24(a5)
    51b4:	e308                	sd	a0,0(a4)
    51b6:	e70c                	sd	a1,8(a4)
    51b8:	eb10                	sd	a2,16(a4)
    51ba:	ef14                	sd	a3,24(a4)
    51bc:	02078793          	addi	a5,a5,32
    51c0:	02070713          	addi	a4,a4,32
    51c4:	ff0794e3          	bne	a5,a6,51ac <main+0x4a>
    51c8:	6394                	ld	a3,0(a5)
    51ca:	679c                	ld	a5,8(a5)
    51cc:	e314                	sd	a3,0(a4)
    51ce:	e71c                	sd	a5,8(a4)
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    51d0:	00003517          	auipc	a0,0x3
    51d4:	cf850513          	addi	a0,a0,-776 # 7ec8 <longjmp_1+0x2318>
    51d8:	00000097          	auipc	ra,0x0
    51dc:	7c4080e7          	jalr	1988(ra) # 599c <printf>
  int free0 = countfree();
    51e0:	00000097          	auipc	ra,0x0
    51e4:	db4080e7          	jalr	-588(ra) # 4f94 <countfree>
    51e8:	8a2a                	mv	s4,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    51ea:	c1843503          	ld	a0,-1000(s0)
    51ee:	c1040493          	addi	s1,s0,-1008
  int fail = 0;
    51f2:	4981                	li	s3,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    51f4:	4a85                	li	s5,1
  for (struct test *t = tests; t->s != 0; t++) {
    51f6:	e55d                	bnez	a0,52a4 <main+0x142>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    51f8:	00000097          	auipc	ra,0x0
    51fc:	d9c080e7          	jalr	-612(ra) # 4f94 <countfree>
    5200:	85aa                	mv	a1,a0
    5202:	0f455163          	bge	a0,s4,52e4 <main+0x182>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5206:	8652                	mv	a2,s4
    5208:	00003517          	auipc	a0,0x3
    520c:	c7850513          	addi	a0,a0,-904 # 7e80 <longjmp_1+0x22d0>
    5210:	00000097          	auipc	ra,0x0
    5214:	78c080e7          	jalr	1932(ra) # 599c <printf>
    exit(1);
    5218:	4505                	li	a0,1
    521a:	00000097          	auipc	ra,0x0
    521e:	3f2080e7          	jalr	1010(ra) # 560c <exit>
    5222:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    5224:	00003597          	auipc	a1,0x3
    5228:	bf458593          	addi	a1,a1,-1036 # 7e18 <longjmp_1+0x2268>
    522c:	6488                	ld	a0,8(s1)
    522e:	00000097          	auipc	ra,0x0
    5232:	18c080e7          	jalr	396(ra) # 53ba <strcmp>
    5236:	10050563          	beqz	a0,5340 <main+0x1de>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    523a:	00003597          	auipc	a1,0x3
    523e:	cc658593          	addi	a1,a1,-826 # 7f00 <longjmp_1+0x2350>
    5242:	6488                	ld	a0,8(s1)
    5244:	00000097          	auipc	ra,0x0
    5248:	176080e7          	jalr	374(ra) # 53ba <strcmp>
    524c:	c97d                	beqz	a0,5342 <main+0x1e0>
  } else if(argc == 2 && argv[1][0] != '-'){
    524e:	0084b903          	ld	s2,8(s1)
    5252:	00094703          	lbu	a4,0(s2)
    5256:	02d00793          	li	a5,45
    525a:	f2f71fe3          	bne	a4,a5,5198 <main+0x36>
    printf("Usage: usertests [-c] [testname]\n");
    525e:	00003517          	auipc	a0,0x3
    5262:	bc250513          	addi	a0,a0,-1086 # 7e20 <longjmp_1+0x2270>
    5266:	00000097          	auipc	ra,0x0
    526a:	736080e7          	jalr	1846(ra) # 599c <printf>
    exit(1);
    526e:	4505                	li	a0,1
    5270:	00000097          	auipc	ra,0x0
    5274:	39c080e7          	jalr	924(ra) # 560c <exit>
          exit(1);
    5278:	4505                	li	a0,1
    527a:	00000097          	auipc	ra,0x0
    527e:	392080e7          	jalr	914(ra) # 560c <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    5282:	40a905bb          	subw	a1,s2,a0
    5286:	855a                	mv	a0,s6
    5288:	00000097          	auipc	ra,0x0
    528c:	714080e7          	jalr	1812(ra) # 599c <printf>
        if(continuous != 2)
    5290:	09498463          	beq	s3,s4,5318 <main+0x1b6>
          exit(1);
    5294:	4505                	li	a0,1
    5296:	00000097          	auipc	ra,0x0
    529a:	376080e7          	jalr	886(ra) # 560c <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    529e:	04c1                	addi	s1,s1,16
    52a0:	6488                	ld	a0,8(s1)
    52a2:	c115                	beqz	a0,52c6 <main+0x164>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    52a4:	00090863          	beqz	s2,52b4 <main+0x152>
    52a8:	85ca                	mv	a1,s2
    52aa:	00000097          	auipc	ra,0x0
    52ae:	110080e7          	jalr	272(ra) # 53ba <strcmp>
    52b2:	f575                	bnez	a0,529e <main+0x13c>
      if(!run(t->f, t->s))
    52b4:	648c                	ld	a1,8(s1)
    52b6:	6088                	ld	a0,0(s1)
    52b8:	00000097          	auipc	ra,0x0
    52bc:	e0c080e7          	jalr	-500(ra) # 50c4 <run>
    52c0:	fd79                	bnez	a0,529e <main+0x13c>
        fail = 1;
    52c2:	89d6                	mv	s3,s5
    52c4:	bfe9                	j	529e <main+0x13c>
  if(fail){
    52c6:	f20989e3          	beqz	s3,51f8 <main+0x96>
    printf("SOME TESTS FAILED\n");
    52ca:	00003517          	auipc	a0,0x3
    52ce:	b9e50513          	addi	a0,a0,-1122 # 7e68 <longjmp_1+0x22b8>
    52d2:	00000097          	auipc	ra,0x0
    52d6:	6ca080e7          	jalr	1738(ra) # 599c <printf>
    exit(1);
    52da:	4505                	li	a0,1
    52dc:	00000097          	auipc	ra,0x0
    52e0:	330080e7          	jalr	816(ra) # 560c <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    52e4:	00003517          	auipc	a0,0x3
    52e8:	bcc50513          	addi	a0,a0,-1076 # 7eb0 <longjmp_1+0x2300>
    52ec:	00000097          	auipc	ra,0x0
    52f0:	6b0080e7          	jalr	1712(ra) # 599c <printf>
    exit(0);
    52f4:	4501                	li	a0,0
    52f6:	00000097          	auipc	ra,0x0
    52fa:	316080e7          	jalr	790(ra) # 560c <exit>
        printf("SOME TESTS FAILED\n");
    52fe:	8556                	mv	a0,s5
    5300:	00000097          	auipc	ra,0x0
    5304:	69c080e7          	jalr	1692(ra) # 599c <printf>
        if(continuous != 2)
    5308:	f74998e3          	bne	s3,s4,5278 <main+0x116>
      int free1 = countfree();
    530c:	00000097          	auipc	ra,0x0
    5310:	c88080e7          	jalr	-888(ra) # 4f94 <countfree>
      if(free1 < free0){
    5314:	f72547e3          	blt	a0,s2,5282 <main+0x120>
      int free0 = countfree();
    5318:	00000097          	auipc	ra,0x0
    531c:	c7c080e7          	jalr	-900(ra) # 4f94 <countfree>
    5320:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    5322:	c1843583          	ld	a1,-1000(s0)
    5326:	d1fd                	beqz	a1,530c <main+0x1aa>
    5328:	c1040493          	addi	s1,s0,-1008
        if(!run(t->f, t->s)){
    532c:	6088                	ld	a0,0(s1)
    532e:	00000097          	auipc	ra,0x0
    5332:	d96080e7          	jalr	-618(ra) # 50c4 <run>
    5336:	d561                	beqz	a0,52fe <main+0x19c>
      for (struct test *t = tests; t->s != 0; t++) {
    5338:	04c1                	addi	s1,s1,16
    533a:	648c                	ld	a1,8(s1)
    533c:	f9e5                	bnez	a1,532c <main+0x1ca>
    533e:	b7f9                	j	530c <main+0x1aa>
    continuous = 1;
    5340:	4985                	li	s3,1
  } tests[] = {
    5342:	00003797          	auipc	a5,0x3
    5346:	be678793          	addi	a5,a5,-1050 # 7f28 <longjmp_1+0x2378>
    534a:	c1040713          	addi	a4,s0,-1008
    534e:	00003817          	auipc	a6,0x3
    5352:	f7a80813          	addi	a6,a6,-134 # 82c8 <longjmp_1+0x2718>
    5356:	6388                	ld	a0,0(a5)
    5358:	678c                	ld	a1,8(a5)
    535a:	6b90                	ld	a2,16(a5)
    535c:	6f94                	ld	a3,24(a5)
    535e:	e308                	sd	a0,0(a4)
    5360:	e70c                	sd	a1,8(a4)
    5362:	eb10                	sd	a2,16(a4)
    5364:	ef14                	sd	a3,24(a4)
    5366:	02078793          	addi	a5,a5,32
    536a:	02070713          	addi	a4,a4,32
    536e:	ff0794e3          	bne	a5,a6,5356 <main+0x1f4>
    5372:	6394                	ld	a3,0(a5)
    5374:	679c                	ld	a5,8(a5)
    5376:	e314                	sd	a3,0(a4)
    5378:	e71c                	sd	a5,8(a4)
    printf("continuous usertests starting\n");
    537a:	00003517          	auipc	a0,0x3
    537e:	b6650513          	addi	a0,a0,-1178 # 7ee0 <longjmp_1+0x2330>
    5382:	00000097          	auipc	ra,0x0
    5386:	61a080e7          	jalr	1562(ra) # 599c <printf>
        printf("SOME TESTS FAILED\n");
    538a:	00003a97          	auipc	s5,0x3
    538e:	adea8a93          	addi	s5,s5,-1314 # 7e68 <longjmp_1+0x22b8>
        if(continuous != 2)
    5392:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    5394:	00003b17          	auipc	s6,0x3
    5398:	ab4b0b13          	addi	s6,s6,-1356 # 7e48 <longjmp_1+0x2298>
    539c:	bfb5                	j	5318 <main+0x1b6>

000000000000539e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    539e:	1141                	addi	sp,sp,-16
    53a0:	e422                	sd	s0,8(sp)
    53a2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    53a4:	87aa                	mv	a5,a0
    53a6:	0585                	addi	a1,a1,1
    53a8:	0785                	addi	a5,a5,1
    53aa:	fff5c703          	lbu	a4,-1(a1)
    53ae:	fee78fa3          	sb	a4,-1(a5)
    53b2:	fb75                	bnez	a4,53a6 <strcpy+0x8>
    ;
  return os;
}
    53b4:	6422                	ld	s0,8(sp)
    53b6:	0141                	addi	sp,sp,16
    53b8:	8082                	ret

00000000000053ba <strcmp>:

int
strcmp(const char *p, const char *q)
{
    53ba:	1141                	addi	sp,sp,-16
    53bc:	e422                	sd	s0,8(sp)
    53be:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    53c0:	00054783          	lbu	a5,0(a0)
    53c4:	cb91                	beqz	a5,53d8 <strcmp+0x1e>
    53c6:	0005c703          	lbu	a4,0(a1)
    53ca:	00f71763          	bne	a4,a5,53d8 <strcmp+0x1e>
    p++, q++;
    53ce:	0505                	addi	a0,a0,1
    53d0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    53d2:	00054783          	lbu	a5,0(a0)
    53d6:	fbe5                	bnez	a5,53c6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    53d8:	0005c503          	lbu	a0,0(a1)
}
    53dc:	40a7853b          	subw	a0,a5,a0
    53e0:	6422                	ld	s0,8(sp)
    53e2:	0141                	addi	sp,sp,16
    53e4:	8082                	ret

00000000000053e6 <strlen>:

uint
strlen(const char *s)
{
    53e6:	1141                	addi	sp,sp,-16
    53e8:	e422                	sd	s0,8(sp)
    53ea:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    53ec:	00054783          	lbu	a5,0(a0)
    53f0:	cf91                	beqz	a5,540c <strlen+0x26>
    53f2:	0505                	addi	a0,a0,1
    53f4:	87aa                	mv	a5,a0
    53f6:	4685                	li	a3,1
    53f8:	9e89                	subw	a3,a3,a0
    53fa:	00f6853b          	addw	a0,a3,a5
    53fe:	0785                	addi	a5,a5,1
    5400:	fff7c703          	lbu	a4,-1(a5)
    5404:	fb7d                	bnez	a4,53fa <strlen+0x14>
    ;
  return n;
}
    5406:	6422                	ld	s0,8(sp)
    5408:	0141                	addi	sp,sp,16
    540a:	8082                	ret
  for(n = 0; s[n]; n++)
    540c:	4501                	li	a0,0
    540e:	bfe5                	j	5406 <strlen+0x20>

0000000000005410 <memset>:

void*
memset(void *dst, int c, uint n)
{
    5410:	1141                	addi	sp,sp,-16
    5412:	e422                	sd	s0,8(sp)
    5414:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    5416:	ca19                	beqz	a2,542c <memset+0x1c>
    5418:	87aa                	mv	a5,a0
    541a:	1602                	slli	a2,a2,0x20
    541c:	9201                	srli	a2,a2,0x20
    541e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    5422:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    5426:	0785                	addi	a5,a5,1
    5428:	fee79de3          	bne	a5,a4,5422 <memset+0x12>
  }
  return dst;
}
    542c:	6422                	ld	s0,8(sp)
    542e:	0141                	addi	sp,sp,16
    5430:	8082                	ret

0000000000005432 <strchr>:

char*
strchr(const char *s, char c)
{
    5432:	1141                	addi	sp,sp,-16
    5434:	e422                	sd	s0,8(sp)
    5436:	0800                	addi	s0,sp,16
  for(; *s; s++)
    5438:	00054783          	lbu	a5,0(a0)
    543c:	cb99                	beqz	a5,5452 <strchr+0x20>
    if(*s == c)
    543e:	00f58763          	beq	a1,a5,544c <strchr+0x1a>
  for(; *s; s++)
    5442:	0505                	addi	a0,a0,1
    5444:	00054783          	lbu	a5,0(a0)
    5448:	fbfd                	bnez	a5,543e <strchr+0xc>
      return (char*)s;
  return 0;
    544a:	4501                	li	a0,0
}
    544c:	6422                	ld	s0,8(sp)
    544e:	0141                	addi	sp,sp,16
    5450:	8082                	ret
  return 0;
    5452:	4501                	li	a0,0
    5454:	bfe5                	j	544c <strchr+0x1a>

0000000000005456 <gets>:

char*
gets(char *buf, int max)
{
    5456:	711d                	addi	sp,sp,-96
    5458:	ec86                	sd	ra,88(sp)
    545a:	e8a2                	sd	s0,80(sp)
    545c:	e4a6                	sd	s1,72(sp)
    545e:	e0ca                	sd	s2,64(sp)
    5460:	fc4e                	sd	s3,56(sp)
    5462:	f852                	sd	s4,48(sp)
    5464:	f456                	sd	s5,40(sp)
    5466:	f05a                	sd	s6,32(sp)
    5468:	ec5e                	sd	s7,24(sp)
    546a:	1080                	addi	s0,sp,96
    546c:	8baa                	mv	s7,a0
    546e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5470:	892a                	mv	s2,a0
    5472:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5474:	4aa9                	li	s5,10
    5476:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5478:	89a6                	mv	s3,s1
    547a:	2485                	addiw	s1,s1,1
    547c:	0344d863          	bge	s1,s4,54ac <gets+0x56>
    cc = read(0, &c, 1);
    5480:	4605                	li	a2,1
    5482:	faf40593          	addi	a1,s0,-81
    5486:	4501                	li	a0,0
    5488:	00000097          	auipc	ra,0x0
    548c:	19c080e7          	jalr	412(ra) # 5624 <read>
    if(cc < 1)
    5490:	00a05e63          	blez	a0,54ac <gets+0x56>
    buf[i++] = c;
    5494:	faf44783          	lbu	a5,-81(s0)
    5498:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    549c:	01578763          	beq	a5,s5,54aa <gets+0x54>
    54a0:	0905                	addi	s2,s2,1
    54a2:	fd679be3          	bne	a5,s6,5478 <gets+0x22>
  for(i=0; i+1 < max; ){
    54a6:	89a6                	mv	s3,s1
    54a8:	a011                	j	54ac <gets+0x56>
    54aa:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    54ac:	99de                	add	s3,s3,s7
    54ae:	00098023          	sb	zero,0(s3)
  return buf;
}
    54b2:	855e                	mv	a0,s7
    54b4:	60e6                	ld	ra,88(sp)
    54b6:	6446                	ld	s0,80(sp)
    54b8:	64a6                	ld	s1,72(sp)
    54ba:	6906                	ld	s2,64(sp)
    54bc:	79e2                	ld	s3,56(sp)
    54be:	7a42                	ld	s4,48(sp)
    54c0:	7aa2                	ld	s5,40(sp)
    54c2:	7b02                	ld	s6,32(sp)
    54c4:	6be2                	ld	s7,24(sp)
    54c6:	6125                	addi	sp,sp,96
    54c8:	8082                	ret

00000000000054ca <stat>:

int
stat(const char *n, struct stat *st)
{
    54ca:	1101                	addi	sp,sp,-32
    54cc:	ec06                	sd	ra,24(sp)
    54ce:	e822                	sd	s0,16(sp)
    54d0:	e426                	sd	s1,8(sp)
    54d2:	e04a                	sd	s2,0(sp)
    54d4:	1000                	addi	s0,sp,32
    54d6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    54d8:	4581                	li	a1,0
    54da:	00000097          	auipc	ra,0x0
    54de:	172080e7          	jalr	370(ra) # 564c <open>
  if(fd < 0)
    54e2:	02054563          	bltz	a0,550c <stat+0x42>
    54e6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    54e8:	85ca                	mv	a1,s2
    54ea:	00000097          	auipc	ra,0x0
    54ee:	17a080e7          	jalr	378(ra) # 5664 <fstat>
    54f2:	892a                	mv	s2,a0
  close(fd);
    54f4:	8526                	mv	a0,s1
    54f6:	00000097          	auipc	ra,0x0
    54fa:	13e080e7          	jalr	318(ra) # 5634 <close>
  return r;
}
    54fe:	854a                	mv	a0,s2
    5500:	60e2                	ld	ra,24(sp)
    5502:	6442                	ld	s0,16(sp)
    5504:	64a2                	ld	s1,8(sp)
    5506:	6902                	ld	s2,0(sp)
    5508:	6105                	addi	sp,sp,32
    550a:	8082                	ret
    return -1;
    550c:	597d                	li	s2,-1
    550e:	bfc5                	j	54fe <stat+0x34>

0000000000005510 <atoi>:

int
atoi(const char *s)
{
    5510:	1141                	addi	sp,sp,-16
    5512:	e422                	sd	s0,8(sp)
    5514:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5516:	00054603          	lbu	a2,0(a0)
    551a:	fd06079b          	addiw	a5,a2,-48
    551e:	0ff7f793          	andi	a5,a5,255
    5522:	4725                	li	a4,9
    5524:	02f76963          	bltu	a4,a5,5556 <atoi+0x46>
    5528:	86aa                	mv	a3,a0
  n = 0;
    552a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    552c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    552e:	0685                	addi	a3,a3,1
    5530:	0025179b          	slliw	a5,a0,0x2
    5534:	9fa9                	addw	a5,a5,a0
    5536:	0017979b          	slliw	a5,a5,0x1
    553a:	9fb1                	addw	a5,a5,a2
    553c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5540:	0006c603          	lbu	a2,0(a3)
    5544:	fd06071b          	addiw	a4,a2,-48
    5548:	0ff77713          	andi	a4,a4,255
    554c:	fee5f1e3          	bgeu	a1,a4,552e <atoi+0x1e>
  return n;
}
    5550:	6422                	ld	s0,8(sp)
    5552:	0141                	addi	sp,sp,16
    5554:	8082                	ret
  n = 0;
    5556:	4501                	li	a0,0
    5558:	bfe5                	j	5550 <atoi+0x40>

000000000000555a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    555a:	1141                	addi	sp,sp,-16
    555c:	e422                	sd	s0,8(sp)
    555e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5560:	02b57463          	bgeu	a0,a1,5588 <memmove+0x2e>
    while(n-- > 0)
    5564:	00c05f63          	blez	a2,5582 <memmove+0x28>
    5568:	1602                	slli	a2,a2,0x20
    556a:	9201                	srli	a2,a2,0x20
    556c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5570:	872a                	mv	a4,a0
      *dst++ = *src++;
    5572:	0585                	addi	a1,a1,1
    5574:	0705                	addi	a4,a4,1
    5576:	fff5c683          	lbu	a3,-1(a1)
    557a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    557e:	fee79ae3          	bne	a5,a4,5572 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5582:	6422                	ld	s0,8(sp)
    5584:	0141                	addi	sp,sp,16
    5586:	8082                	ret
    dst += n;
    5588:	00c50733          	add	a4,a0,a2
    src += n;
    558c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    558e:	fec05ae3          	blez	a2,5582 <memmove+0x28>
    5592:	fff6079b          	addiw	a5,a2,-1
    5596:	1782                	slli	a5,a5,0x20
    5598:	9381                	srli	a5,a5,0x20
    559a:	fff7c793          	not	a5,a5
    559e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    55a0:	15fd                	addi	a1,a1,-1
    55a2:	177d                	addi	a4,a4,-1
    55a4:	0005c683          	lbu	a3,0(a1)
    55a8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    55ac:	fee79ae3          	bne	a5,a4,55a0 <memmove+0x46>
    55b0:	bfc9                	j	5582 <memmove+0x28>

00000000000055b2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    55b2:	1141                	addi	sp,sp,-16
    55b4:	e422                	sd	s0,8(sp)
    55b6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    55b8:	ca05                	beqz	a2,55e8 <memcmp+0x36>
    55ba:	fff6069b          	addiw	a3,a2,-1
    55be:	1682                	slli	a3,a3,0x20
    55c0:	9281                	srli	a3,a3,0x20
    55c2:	0685                	addi	a3,a3,1
    55c4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    55c6:	00054783          	lbu	a5,0(a0)
    55ca:	0005c703          	lbu	a4,0(a1)
    55ce:	00e79863          	bne	a5,a4,55de <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    55d2:	0505                	addi	a0,a0,1
    p2++;
    55d4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    55d6:	fed518e3          	bne	a0,a3,55c6 <memcmp+0x14>
  }
  return 0;
    55da:	4501                	li	a0,0
    55dc:	a019                	j	55e2 <memcmp+0x30>
      return *p1 - *p2;
    55de:	40e7853b          	subw	a0,a5,a4
}
    55e2:	6422                	ld	s0,8(sp)
    55e4:	0141                	addi	sp,sp,16
    55e6:	8082                	ret
  return 0;
    55e8:	4501                	li	a0,0
    55ea:	bfe5                	j	55e2 <memcmp+0x30>

00000000000055ec <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    55ec:	1141                	addi	sp,sp,-16
    55ee:	e406                	sd	ra,8(sp)
    55f0:	e022                	sd	s0,0(sp)
    55f2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    55f4:	00000097          	auipc	ra,0x0
    55f8:	f66080e7          	jalr	-154(ra) # 555a <memmove>
}
    55fc:	60a2                	ld	ra,8(sp)
    55fe:	6402                	ld	s0,0(sp)
    5600:	0141                	addi	sp,sp,16
    5602:	8082                	ret

0000000000005604 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5604:	4885                	li	a7,1
 ecall
    5606:	00000073          	ecall
 ret
    560a:	8082                	ret

000000000000560c <exit>:
.global exit
exit:
 li a7, SYS_exit
    560c:	4889                	li	a7,2
 ecall
    560e:	00000073          	ecall
 ret
    5612:	8082                	ret

0000000000005614 <wait>:
.global wait
wait:
 li a7, SYS_wait
    5614:	488d                	li	a7,3
 ecall
    5616:	00000073          	ecall
 ret
    561a:	8082                	ret

000000000000561c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    561c:	4891                	li	a7,4
 ecall
    561e:	00000073          	ecall
 ret
    5622:	8082                	ret

0000000000005624 <read>:
.global read
read:
 li a7, SYS_read
    5624:	4895                	li	a7,5
 ecall
    5626:	00000073          	ecall
 ret
    562a:	8082                	ret

000000000000562c <write>:
.global write
write:
 li a7, SYS_write
    562c:	48c1                	li	a7,16
 ecall
    562e:	00000073          	ecall
 ret
    5632:	8082                	ret

0000000000005634 <close>:
.global close
close:
 li a7, SYS_close
    5634:	48d5                	li	a7,21
 ecall
    5636:	00000073          	ecall
 ret
    563a:	8082                	ret

000000000000563c <kill>:
.global kill
kill:
 li a7, SYS_kill
    563c:	4899                	li	a7,6
 ecall
    563e:	00000073          	ecall
 ret
    5642:	8082                	ret

0000000000005644 <exec>:
.global exec
exec:
 li a7, SYS_exec
    5644:	489d                	li	a7,7
 ecall
    5646:	00000073          	ecall
 ret
    564a:	8082                	ret

000000000000564c <open>:
.global open
open:
 li a7, SYS_open
    564c:	48bd                	li	a7,15
 ecall
    564e:	00000073          	ecall
 ret
    5652:	8082                	ret

0000000000005654 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5654:	48c5                	li	a7,17
 ecall
    5656:	00000073          	ecall
 ret
    565a:	8082                	ret

000000000000565c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    565c:	48c9                	li	a7,18
 ecall
    565e:	00000073          	ecall
 ret
    5662:	8082                	ret

0000000000005664 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5664:	48a1                	li	a7,8
 ecall
    5666:	00000073          	ecall
 ret
    566a:	8082                	ret

000000000000566c <link>:
.global link
link:
 li a7, SYS_link
    566c:	48cd                	li	a7,19
 ecall
    566e:	00000073          	ecall
 ret
    5672:	8082                	ret

0000000000005674 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5674:	48d1                	li	a7,20
 ecall
    5676:	00000073          	ecall
 ret
    567a:	8082                	ret

000000000000567c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    567c:	48a5                	li	a7,9
 ecall
    567e:	00000073          	ecall
 ret
    5682:	8082                	ret

0000000000005684 <dup>:
.global dup
dup:
 li a7, SYS_dup
    5684:	48a9                	li	a7,10
 ecall
    5686:	00000073          	ecall
 ret
    568a:	8082                	ret

000000000000568c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    568c:	48ad                	li	a7,11
 ecall
    568e:	00000073          	ecall
 ret
    5692:	8082                	ret

0000000000005694 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5694:	48b1                	li	a7,12
 ecall
    5696:	00000073          	ecall
 ret
    569a:	8082                	ret

000000000000569c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    569c:	48b5                	li	a7,13
 ecall
    569e:	00000073          	ecall
 ret
    56a2:	8082                	ret

00000000000056a4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    56a4:	48b9                	li	a7,14
 ecall
    56a6:	00000073          	ecall
 ret
    56aa:	8082                	ret

00000000000056ac <thrdstop>:
.global thrdstop
thrdstop:
 li a7, SYS_thrdstop
    56ac:	48d9                	li	a7,22
 ecall
    56ae:	00000073          	ecall
 ret
    56b2:	8082                	ret

00000000000056b4 <thrdresume>:
.global thrdresume
thrdresume:
 li a7, SYS_thrdresume
    56b4:	48dd                	li	a7,23
 ecall
    56b6:	00000073          	ecall
 ret
    56ba:	8082                	ret

00000000000056bc <cancelthrdstop>:
.global cancelthrdstop
cancelthrdstop:
 li a7, SYS_cancelthrdstop
    56bc:	48e1                	li	a7,24
 ecall
    56be:	00000073          	ecall
 ret
    56c2:	8082                	ret

00000000000056c4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    56c4:	1101                	addi	sp,sp,-32
    56c6:	ec06                	sd	ra,24(sp)
    56c8:	e822                	sd	s0,16(sp)
    56ca:	1000                	addi	s0,sp,32
    56cc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    56d0:	4605                	li	a2,1
    56d2:	fef40593          	addi	a1,s0,-17
    56d6:	00000097          	auipc	ra,0x0
    56da:	f56080e7          	jalr	-170(ra) # 562c <write>
}
    56de:	60e2                	ld	ra,24(sp)
    56e0:	6442                	ld	s0,16(sp)
    56e2:	6105                	addi	sp,sp,32
    56e4:	8082                	ret

00000000000056e6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    56e6:	7139                	addi	sp,sp,-64
    56e8:	fc06                	sd	ra,56(sp)
    56ea:	f822                	sd	s0,48(sp)
    56ec:	f426                	sd	s1,40(sp)
    56ee:	f04a                	sd	s2,32(sp)
    56f0:	ec4e                	sd	s3,24(sp)
    56f2:	0080                	addi	s0,sp,64
    56f4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    56f6:	c299                	beqz	a3,56fc <printint+0x16>
    56f8:	0805c863          	bltz	a1,5788 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    56fc:	2581                	sext.w	a1,a1
  neg = 0;
    56fe:	4881                	li	a7,0
    5700:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5704:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5706:	2601                	sext.w	a2,a2
    5708:	00003517          	auipc	a0,0x3
    570c:	bd850513          	addi	a0,a0,-1064 # 82e0 <digits>
    5710:	883a                	mv	a6,a4
    5712:	2705                	addiw	a4,a4,1
    5714:	02c5f7bb          	remuw	a5,a1,a2
    5718:	1782                	slli	a5,a5,0x20
    571a:	9381                	srli	a5,a5,0x20
    571c:	97aa                	add	a5,a5,a0
    571e:	0007c783          	lbu	a5,0(a5)
    5722:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5726:	0005879b          	sext.w	a5,a1
    572a:	02c5d5bb          	divuw	a1,a1,a2
    572e:	0685                	addi	a3,a3,1
    5730:	fec7f0e3          	bgeu	a5,a2,5710 <printint+0x2a>
  if(neg)
    5734:	00088b63          	beqz	a7,574a <printint+0x64>
    buf[i++] = '-';
    5738:	fd040793          	addi	a5,s0,-48
    573c:	973e                	add	a4,a4,a5
    573e:	02d00793          	li	a5,45
    5742:	fef70823          	sb	a5,-16(a4)
    5746:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    574a:	02e05863          	blez	a4,577a <printint+0x94>
    574e:	fc040793          	addi	a5,s0,-64
    5752:	00e78933          	add	s2,a5,a4
    5756:	fff78993          	addi	s3,a5,-1
    575a:	99ba                	add	s3,s3,a4
    575c:	377d                	addiw	a4,a4,-1
    575e:	1702                	slli	a4,a4,0x20
    5760:	9301                	srli	a4,a4,0x20
    5762:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5766:	fff94583          	lbu	a1,-1(s2)
    576a:	8526                	mv	a0,s1
    576c:	00000097          	auipc	ra,0x0
    5770:	f58080e7          	jalr	-168(ra) # 56c4 <putc>
  while(--i >= 0)
    5774:	197d                	addi	s2,s2,-1
    5776:	ff3918e3          	bne	s2,s3,5766 <printint+0x80>
}
    577a:	70e2                	ld	ra,56(sp)
    577c:	7442                	ld	s0,48(sp)
    577e:	74a2                	ld	s1,40(sp)
    5780:	7902                	ld	s2,32(sp)
    5782:	69e2                	ld	s3,24(sp)
    5784:	6121                	addi	sp,sp,64
    5786:	8082                	ret
    x = -xx;
    5788:	40b005bb          	negw	a1,a1
    neg = 1;
    578c:	4885                	li	a7,1
    x = -xx;
    578e:	bf8d                	j	5700 <printint+0x1a>

0000000000005790 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5790:	7119                	addi	sp,sp,-128
    5792:	fc86                	sd	ra,120(sp)
    5794:	f8a2                	sd	s0,112(sp)
    5796:	f4a6                	sd	s1,104(sp)
    5798:	f0ca                	sd	s2,96(sp)
    579a:	ecce                	sd	s3,88(sp)
    579c:	e8d2                	sd	s4,80(sp)
    579e:	e4d6                	sd	s5,72(sp)
    57a0:	e0da                	sd	s6,64(sp)
    57a2:	fc5e                	sd	s7,56(sp)
    57a4:	f862                	sd	s8,48(sp)
    57a6:	f466                	sd	s9,40(sp)
    57a8:	f06a                	sd	s10,32(sp)
    57aa:	ec6e                	sd	s11,24(sp)
    57ac:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    57ae:	0005c903          	lbu	s2,0(a1)
    57b2:	18090f63          	beqz	s2,5950 <vprintf+0x1c0>
    57b6:	8aaa                	mv	s5,a0
    57b8:	8b32                	mv	s6,a2
    57ba:	00158493          	addi	s1,a1,1
  state = 0;
    57be:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    57c0:	02500a13          	li	s4,37
      if(c == 'd'){
    57c4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    57c8:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    57cc:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    57d0:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    57d4:	00003b97          	auipc	s7,0x3
    57d8:	b0cb8b93          	addi	s7,s7,-1268 # 82e0 <digits>
    57dc:	a839                	j	57fa <vprintf+0x6a>
        putc(fd, c);
    57de:	85ca                	mv	a1,s2
    57e0:	8556                	mv	a0,s5
    57e2:	00000097          	auipc	ra,0x0
    57e6:	ee2080e7          	jalr	-286(ra) # 56c4 <putc>
    57ea:	a019                	j	57f0 <vprintf+0x60>
    } else if(state == '%'){
    57ec:	01498f63          	beq	s3,s4,580a <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    57f0:	0485                	addi	s1,s1,1
    57f2:	fff4c903          	lbu	s2,-1(s1)
    57f6:	14090d63          	beqz	s2,5950 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    57fa:	0009079b          	sext.w	a5,s2
    if(state == 0){
    57fe:	fe0997e3          	bnez	s3,57ec <vprintf+0x5c>
      if(c == '%'){
    5802:	fd479ee3          	bne	a5,s4,57de <vprintf+0x4e>
        state = '%';
    5806:	89be                	mv	s3,a5
    5808:	b7e5                	j	57f0 <vprintf+0x60>
      if(c == 'd'){
    580a:	05878063          	beq	a5,s8,584a <vprintf+0xba>
      } else if(c == 'l') {
    580e:	05978c63          	beq	a5,s9,5866 <vprintf+0xd6>
      } else if(c == 'x') {
    5812:	07a78863          	beq	a5,s10,5882 <vprintf+0xf2>
      } else if(c == 'p') {
    5816:	09b78463          	beq	a5,s11,589e <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    581a:	07300713          	li	a4,115
    581e:	0ce78663          	beq	a5,a4,58ea <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    5822:	06300713          	li	a4,99
    5826:	0ee78e63          	beq	a5,a4,5922 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    582a:	11478863          	beq	a5,s4,593a <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    582e:	85d2                	mv	a1,s4
    5830:	8556                	mv	a0,s5
    5832:	00000097          	auipc	ra,0x0
    5836:	e92080e7          	jalr	-366(ra) # 56c4 <putc>
        putc(fd, c);
    583a:	85ca                	mv	a1,s2
    583c:	8556                	mv	a0,s5
    583e:	00000097          	auipc	ra,0x0
    5842:	e86080e7          	jalr	-378(ra) # 56c4 <putc>
      }
      state = 0;
    5846:	4981                	li	s3,0
    5848:	b765                	j	57f0 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    584a:	008b0913          	addi	s2,s6,8
    584e:	4685                	li	a3,1
    5850:	4629                	li	a2,10
    5852:	000b2583          	lw	a1,0(s6)
    5856:	8556                	mv	a0,s5
    5858:	00000097          	auipc	ra,0x0
    585c:	e8e080e7          	jalr	-370(ra) # 56e6 <printint>
    5860:	8b4a                	mv	s6,s2
      state = 0;
    5862:	4981                	li	s3,0
    5864:	b771                	j	57f0 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5866:	008b0913          	addi	s2,s6,8
    586a:	4681                	li	a3,0
    586c:	4629                	li	a2,10
    586e:	000b2583          	lw	a1,0(s6)
    5872:	8556                	mv	a0,s5
    5874:	00000097          	auipc	ra,0x0
    5878:	e72080e7          	jalr	-398(ra) # 56e6 <printint>
    587c:	8b4a                	mv	s6,s2
      state = 0;
    587e:	4981                	li	s3,0
    5880:	bf85                	j	57f0 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5882:	008b0913          	addi	s2,s6,8
    5886:	4681                	li	a3,0
    5888:	4641                	li	a2,16
    588a:	000b2583          	lw	a1,0(s6)
    588e:	8556                	mv	a0,s5
    5890:	00000097          	auipc	ra,0x0
    5894:	e56080e7          	jalr	-426(ra) # 56e6 <printint>
    5898:	8b4a                	mv	s6,s2
      state = 0;
    589a:	4981                	li	s3,0
    589c:	bf91                	j	57f0 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    589e:	008b0793          	addi	a5,s6,8
    58a2:	f8f43423          	sd	a5,-120(s0)
    58a6:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    58aa:	03000593          	li	a1,48
    58ae:	8556                	mv	a0,s5
    58b0:	00000097          	auipc	ra,0x0
    58b4:	e14080e7          	jalr	-492(ra) # 56c4 <putc>
  putc(fd, 'x');
    58b8:	85ea                	mv	a1,s10
    58ba:	8556                	mv	a0,s5
    58bc:	00000097          	auipc	ra,0x0
    58c0:	e08080e7          	jalr	-504(ra) # 56c4 <putc>
    58c4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    58c6:	03c9d793          	srli	a5,s3,0x3c
    58ca:	97de                	add	a5,a5,s7
    58cc:	0007c583          	lbu	a1,0(a5)
    58d0:	8556                	mv	a0,s5
    58d2:	00000097          	auipc	ra,0x0
    58d6:	df2080e7          	jalr	-526(ra) # 56c4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    58da:	0992                	slli	s3,s3,0x4
    58dc:	397d                	addiw	s2,s2,-1
    58de:	fe0914e3          	bnez	s2,58c6 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    58e2:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    58e6:	4981                	li	s3,0
    58e8:	b721                	j	57f0 <vprintf+0x60>
        s = va_arg(ap, char*);
    58ea:	008b0993          	addi	s3,s6,8
    58ee:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    58f2:	02090163          	beqz	s2,5914 <vprintf+0x184>
        while(*s != 0){
    58f6:	00094583          	lbu	a1,0(s2)
    58fa:	c9a1                	beqz	a1,594a <vprintf+0x1ba>
          putc(fd, *s);
    58fc:	8556                	mv	a0,s5
    58fe:	00000097          	auipc	ra,0x0
    5902:	dc6080e7          	jalr	-570(ra) # 56c4 <putc>
          s++;
    5906:	0905                	addi	s2,s2,1
        while(*s != 0){
    5908:	00094583          	lbu	a1,0(s2)
    590c:	f9e5                	bnez	a1,58fc <vprintf+0x16c>
        s = va_arg(ap, char*);
    590e:	8b4e                	mv	s6,s3
      state = 0;
    5910:	4981                	li	s3,0
    5912:	bdf9                	j	57f0 <vprintf+0x60>
          s = "(null)";
    5914:	00003917          	auipc	s2,0x3
    5918:	9c490913          	addi	s2,s2,-1596 # 82d8 <longjmp_1+0x2728>
        while(*s != 0){
    591c:	02800593          	li	a1,40
    5920:	bff1                	j	58fc <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    5922:	008b0913          	addi	s2,s6,8
    5926:	000b4583          	lbu	a1,0(s6)
    592a:	8556                	mv	a0,s5
    592c:	00000097          	auipc	ra,0x0
    5930:	d98080e7          	jalr	-616(ra) # 56c4 <putc>
    5934:	8b4a                	mv	s6,s2
      state = 0;
    5936:	4981                	li	s3,0
    5938:	bd65                	j	57f0 <vprintf+0x60>
        putc(fd, c);
    593a:	85d2                	mv	a1,s4
    593c:	8556                	mv	a0,s5
    593e:	00000097          	auipc	ra,0x0
    5942:	d86080e7          	jalr	-634(ra) # 56c4 <putc>
      state = 0;
    5946:	4981                	li	s3,0
    5948:	b565                	j	57f0 <vprintf+0x60>
        s = va_arg(ap, char*);
    594a:	8b4e                	mv	s6,s3
      state = 0;
    594c:	4981                	li	s3,0
    594e:	b54d                	j	57f0 <vprintf+0x60>
    }
  }
}
    5950:	70e6                	ld	ra,120(sp)
    5952:	7446                	ld	s0,112(sp)
    5954:	74a6                	ld	s1,104(sp)
    5956:	7906                	ld	s2,96(sp)
    5958:	69e6                	ld	s3,88(sp)
    595a:	6a46                	ld	s4,80(sp)
    595c:	6aa6                	ld	s5,72(sp)
    595e:	6b06                	ld	s6,64(sp)
    5960:	7be2                	ld	s7,56(sp)
    5962:	7c42                	ld	s8,48(sp)
    5964:	7ca2                	ld	s9,40(sp)
    5966:	7d02                	ld	s10,32(sp)
    5968:	6de2                	ld	s11,24(sp)
    596a:	6109                	addi	sp,sp,128
    596c:	8082                	ret

000000000000596e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    596e:	715d                	addi	sp,sp,-80
    5970:	ec06                	sd	ra,24(sp)
    5972:	e822                	sd	s0,16(sp)
    5974:	1000                	addi	s0,sp,32
    5976:	e010                	sd	a2,0(s0)
    5978:	e414                	sd	a3,8(s0)
    597a:	e818                	sd	a4,16(s0)
    597c:	ec1c                	sd	a5,24(s0)
    597e:	03043023          	sd	a6,32(s0)
    5982:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5986:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    598a:	8622                	mv	a2,s0
    598c:	00000097          	auipc	ra,0x0
    5990:	e04080e7          	jalr	-508(ra) # 5790 <vprintf>
}
    5994:	60e2                	ld	ra,24(sp)
    5996:	6442                	ld	s0,16(sp)
    5998:	6161                	addi	sp,sp,80
    599a:	8082                	ret

000000000000599c <printf>:

void
printf(const char *fmt, ...)
{
    599c:	711d                	addi	sp,sp,-96
    599e:	ec06                	sd	ra,24(sp)
    59a0:	e822                	sd	s0,16(sp)
    59a2:	1000                	addi	s0,sp,32
    59a4:	e40c                	sd	a1,8(s0)
    59a6:	e810                	sd	a2,16(s0)
    59a8:	ec14                	sd	a3,24(s0)
    59aa:	f018                	sd	a4,32(s0)
    59ac:	f41c                	sd	a5,40(s0)
    59ae:	03043823          	sd	a6,48(s0)
    59b2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    59b6:	00840613          	addi	a2,s0,8
    59ba:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    59be:	85aa                	mv	a1,a0
    59c0:	4505                	li	a0,1
    59c2:	00000097          	auipc	ra,0x0
    59c6:	dce080e7          	jalr	-562(ra) # 5790 <vprintf>
}
    59ca:	60e2                	ld	ra,24(sp)
    59cc:	6442                	ld	s0,16(sp)
    59ce:	6125                	addi	sp,sp,96
    59d0:	8082                	ret

00000000000059d2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    59d2:	1141                	addi	sp,sp,-16
    59d4:	e422                	sd	s0,8(sp)
    59d6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    59d8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    59dc:	00003797          	auipc	a5,0x3
    59e0:	92c7b783          	ld	a5,-1748(a5) # 8308 <freep>
    59e4:	a805                	j	5a14 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    59e6:	4618                	lw	a4,8(a2)
    59e8:	9db9                	addw	a1,a1,a4
    59ea:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    59ee:	6398                	ld	a4,0(a5)
    59f0:	6318                	ld	a4,0(a4)
    59f2:	fee53823          	sd	a4,-16(a0)
    59f6:	a091                	j	5a3a <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    59f8:	ff852703          	lw	a4,-8(a0)
    59fc:	9e39                	addw	a2,a2,a4
    59fe:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    5a00:	ff053703          	ld	a4,-16(a0)
    5a04:	e398                	sd	a4,0(a5)
    5a06:	a099                	j	5a4c <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5a08:	6398                	ld	a4,0(a5)
    5a0a:	00e7e463          	bltu	a5,a4,5a12 <free+0x40>
    5a0e:	00e6ea63          	bltu	a3,a4,5a22 <free+0x50>
{
    5a12:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5a14:	fed7fae3          	bgeu	a5,a3,5a08 <free+0x36>
    5a18:	6398                	ld	a4,0(a5)
    5a1a:	00e6e463          	bltu	a3,a4,5a22 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5a1e:	fee7eae3          	bltu	a5,a4,5a12 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    5a22:	ff852583          	lw	a1,-8(a0)
    5a26:	6390                	ld	a2,0(a5)
    5a28:	02059713          	slli	a4,a1,0x20
    5a2c:	9301                	srli	a4,a4,0x20
    5a2e:	0712                	slli	a4,a4,0x4
    5a30:	9736                	add	a4,a4,a3
    5a32:	fae60ae3          	beq	a2,a4,59e6 <free+0x14>
    bp->s.ptr = p->s.ptr;
    5a36:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5a3a:	4790                	lw	a2,8(a5)
    5a3c:	02061713          	slli	a4,a2,0x20
    5a40:	9301                	srli	a4,a4,0x20
    5a42:	0712                	slli	a4,a4,0x4
    5a44:	973e                	add	a4,a4,a5
    5a46:	fae689e3          	beq	a3,a4,59f8 <free+0x26>
  } else
    p->s.ptr = bp;
    5a4a:	e394                	sd	a3,0(a5)
  freep = p;
    5a4c:	00003717          	auipc	a4,0x3
    5a50:	8af73e23          	sd	a5,-1860(a4) # 8308 <freep>
}
    5a54:	6422                	ld	s0,8(sp)
    5a56:	0141                	addi	sp,sp,16
    5a58:	8082                	ret

0000000000005a5a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5a5a:	7139                	addi	sp,sp,-64
    5a5c:	fc06                	sd	ra,56(sp)
    5a5e:	f822                	sd	s0,48(sp)
    5a60:	f426                	sd	s1,40(sp)
    5a62:	f04a                	sd	s2,32(sp)
    5a64:	ec4e                	sd	s3,24(sp)
    5a66:	e852                	sd	s4,16(sp)
    5a68:	e456                	sd	s5,8(sp)
    5a6a:	e05a                	sd	s6,0(sp)
    5a6c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5a6e:	02051493          	slli	s1,a0,0x20
    5a72:	9081                	srli	s1,s1,0x20
    5a74:	04bd                	addi	s1,s1,15
    5a76:	8091                	srli	s1,s1,0x4
    5a78:	0014899b          	addiw	s3,s1,1
    5a7c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    5a7e:	00003517          	auipc	a0,0x3
    5a82:	88a53503          	ld	a0,-1910(a0) # 8308 <freep>
    5a86:	c515                	beqz	a0,5ab2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5a88:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5a8a:	4798                	lw	a4,8(a5)
    5a8c:	02977f63          	bgeu	a4,s1,5aca <malloc+0x70>
    5a90:	8a4e                	mv	s4,s3
    5a92:	0009871b          	sext.w	a4,s3
    5a96:	6685                	lui	a3,0x1
    5a98:	00d77363          	bgeu	a4,a3,5a9e <malloc+0x44>
    5a9c:	6a05                	lui	s4,0x1
    5a9e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5aa2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5aa6:	00003917          	auipc	s2,0x3
    5aaa:	86290913          	addi	s2,s2,-1950 # 8308 <freep>
  if(p == (char*)-1)
    5aae:	5afd                	li	s5,-1
    5ab0:	a88d                	j	5b22 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    5ab2:	00009797          	auipc	a5,0x9
    5ab6:	07678793          	addi	a5,a5,118 # eb28 <base>
    5aba:	00003717          	auipc	a4,0x3
    5abe:	84f73723          	sd	a5,-1970(a4) # 8308 <freep>
    5ac2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5ac4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5ac8:	b7e1                	j	5a90 <malloc+0x36>
      if(p->s.size == nunits)
    5aca:	02e48b63          	beq	s1,a4,5b00 <malloc+0xa6>
        p->s.size -= nunits;
    5ace:	4137073b          	subw	a4,a4,s3
    5ad2:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5ad4:	1702                	slli	a4,a4,0x20
    5ad6:	9301                	srli	a4,a4,0x20
    5ad8:	0712                	slli	a4,a4,0x4
    5ada:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5adc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5ae0:	00003717          	auipc	a4,0x3
    5ae4:	82a73423          	sd	a0,-2008(a4) # 8308 <freep>
      return (void*)(p + 1);
    5ae8:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5aec:	70e2                	ld	ra,56(sp)
    5aee:	7442                	ld	s0,48(sp)
    5af0:	74a2                	ld	s1,40(sp)
    5af2:	7902                	ld	s2,32(sp)
    5af4:	69e2                	ld	s3,24(sp)
    5af6:	6a42                	ld	s4,16(sp)
    5af8:	6aa2                	ld	s5,8(sp)
    5afa:	6b02                	ld	s6,0(sp)
    5afc:	6121                	addi	sp,sp,64
    5afe:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    5b00:	6398                	ld	a4,0(a5)
    5b02:	e118                	sd	a4,0(a0)
    5b04:	bff1                	j	5ae0 <malloc+0x86>
  hp->s.size = nu;
    5b06:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5b0a:	0541                	addi	a0,a0,16
    5b0c:	00000097          	auipc	ra,0x0
    5b10:	ec6080e7          	jalr	-314(ra) # 59d2 <free>
  return freep;
    5b14:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    5b18:	d971                	beqz	a0,5aec <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5b1a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5b1c:	4798                	lw	a4,8(a5)
    5b1e:	fa9776e3          	bgeu	a4,s1,5aca <malloc+0x70>
    if(p == freep)
    5b22:	00093703          	ld	a4,0(s2)
    5b26:	853e                	mv	a0,a5
    5b28:	fef719e3          	bne	a4,a5,5b1a <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    5b2c:	8552                	mv	a0,s4
    5b2e:	00000097          	auipc	ra,0x0
    5b32:	b66080e7          	jalr	-1178(ra) # 5694 <sbrk>
  if(p == (char*)-1)
    5b36:	fd5518e3          	bne	a0,s5,5b06 <malloc+0xac>
        return 0;
    5b3a:	4501                	li	a0,0
    5b3c:	bf45                	j	5aec <malloc+0x92>

0000000000005b3e <setjmp>:
    5b3e:	e100                	sd	s0,0(a0)
    5b40:	e504                	sd	s1,8(a0)
    5b42:	01253823          	sd	s2,16(a0)
    5b46:	01353c23          	sd	s3,24(a0)
    5b4a:	03453023          	sd	s4,32(a0)
    5b4e:	03553423          	sd	s5,40(a0)
    5b52:	03653823          	sd	s6,48(a0)
    5b56:	03753c23          	sd	s7,56(a0)
    5b5a:	05853023          	sd	s8,64(a0)
    5b5e:	05953423          	sd	s9,72(a0)
    5b62:	05a53823          	sd	s10,80(a0)
    5b66:	05b53c23          	sd	s11,88(a0)
    5b6a:	06153023          	sd	ra,96(a0)
    5b6e:	06253423          	sd	sp,104(a0)
    5b72:	4501                	li	a0,0
    5b74:	8082                	ret

0000000000005b76 <longjmp>:
    5b76:	6100                	ld	s0,0(a0)
    5b78:	6504                	ld	s1,8(a0)
    5b7a:	01053903          	ld	s2,16(a0)
    5b7e:	01853983          	ld	s3,24(a0)
    5b82:	02053a03          	ld	s4,32(a0)
    5b86:	02853a83          	ld	s5,40(a0)
    5b8a:	03053b03          	ld	s6,48(a0)
    5b8e:	03853b83          	ld	s7,56(a0)
    5b92:	04053c03          	ld	s8,64(a0)
    5b96:	04853c83          	ld	s9,72(a0)
    5b9a:	05053d03          	ld	s10,80(a0)
    5b9e:	05853d83          	ld	s11,88(a0)
    5ba2:	06053083          	ld	ra,96(a0)
    5ba6:	06853103          	ld	sp,104(a0)
    5baa:	c199                	beqz	a1,5bb0 <longjmp_1>
    5bac:	852e                	mv	a0,a1
    5bae:	8082                	ret

0000000000005bb0 <longjmp_1>:
    5bb0:	4505                	li	a0,1
    5bb2:	8082                	ret
