
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
      14:	726080e7          	jalr	1830(ra) # 5736 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00005097          	auipc	ra,0x5
      26:	714080e7          	jalr	1812(ra) # 5736 <open>
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
      42:	fc250513          	addi	a0,a0,-62 # 6000 <malloc+0x4ca>
      46:	00006097          	auipc	ra,0x6
      4a:	a30080e7          	jalr	-1488(ra) # 5a76 <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00005097          	auipc	ra,0x5
      54:	6a6080e7          	jalr	1702(ra) # 56f6 <exit>

0000000000000058 <bsstest>:
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
    if(uninit[i] != '\0'){
      58:	00009797          	auipc	a5,0x9
      5c:	4687c783          	lbu	a5,1128(a5) # 94c0 <uninit>
      60:	e385                	bnez	a5,80 <bsstest+0x28>
      62:	00009797          	auipc	a5,0x9
      66:	45f78793          	addi	a5,a5,1119 # 94c1 <uninit+0x1>
      6a:	0000c697          	auipc	a3,0xc
      6e:	b6668693          	addi	a3,a3,-1178 # bbd0 <buf>
      72:	0007c703          	lbu	a4,0(a5)
      76:	e709                	bnez	a4,80 <bsstest+0x28>
      78:	0785                	addi	a5,a5,1
  for(i = 0; i < sizeof(uninit); i++){
      7a:	fed79ce3          	bne	a5,a3,72 <bsstest+0x1a>
      7e:	8082                	ret
{
      80:	1141                	addi	sp,sp,-16
      82:	e406                	sd	ra,8(sp)
      84:	e022                	sd	s0,0(sp)
      86:	0800                	addi	s0,sp,16
      88:	85aa                	mv	a1,a0
      printf("%s: bss test failed\n", s);
      8a:	00006517          	auipc	a0,0x6
      8e:	f9650513          	addi	a0,a0,-106 # 6020 <malloc+0x4ea>
      92:	00006097          	auipc	ra,0x6
      96:	9e4080e7          	jalr	-1564(ra) # 5a76 <printf>
      exit(1);
      9a:	4505                	li	a0,1
      9c:	00005097          	auipc	ra,0x5
      a0:	65a080e7          	jalr	1626(ra) # 56f6 <exit>

00000000000000a4 <opentest>:
{
      a4:	1101                	addi	sp,sp,-32
      a6:	ec06                	sd	ra,24(sp)
      a8:	e822                	sd	s0,16(sp)
      aa:	e426                	sd	s1,8(sp)
      ac:	1000                	addi	s0,sp,32
      ae:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      b0:	4581                	li	a1,0
      b2:	00006517          	auipc	a0,0x6
      b6:	f8650513          	addi	a0,a0,-122 # 6038 <malloc+0x502>
      ba:	00005097          	auipc	ra,0x5
      be:	67c080e7          	jalr	1660(ra) # 5736 <open>
  if(fd < 0){
      c2:	02054663          	bltz	a0,ee <opentest+0x4a>
  close(fd);
      c6:	00005097          	auipc	ra,0x5
      ca:	658080e7          	jalr	1624(ra) # 571e <close>
  fd = open("doesnotexist", 0);
      ce:	4581                	li	a1,0
      d0:	00006517          	auipc	a0,0x6
      d4:	f8850513          	addi	a0,a0,-120 # 6058 <malloc+0x522>
      d8:	00005097          	auipc	ra,0x5
      dc:	65e080e7          	jalr	1630(ra) # 5736 <open>
  if(fd >= 0){
      e0:	02055563          	bgez	a0,10a <opentest+0x66>
}
      e4:	60e2                	ld	ra,24(sp)
      e6:	6442                	ld	s0,16(sp)
      e8:	64a2                	ld	s1,8(sp)
      ea:	6105                	addi	sp,sp,32
      ec:	8082                	ret
    printf("%s: open echo failed!\n", s);
      ee:	85a6                	mv	a1,s1
      f0:	00006517          	auipc	a0,0x6
      f4:	f5050513          	addi	a0,a0,-176 # 6040 <malloc+0x50a>
      f8:	00006097          	auipc	ra,0x6
      fc:	97e080e7          	jalr	-1666(ra) # 5a76 <printf>
    exit(1);
     100:	4505                	li	a0,1
     102:	00005097          	auipc	ra,0x5
     106:	5f4080e7          	jalr	1524(ra) # 56f6 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     10a:	85a6                	mv	a1,s1
     10c:	00006517          	auipc	a0,0x6
     110:	f5c50513          	addi	a0,a0,-164 # 6068 <malloc+0x532>
     114:	00006097          	auipc	ra,0x6
     118:	962080e7          	jalr	-1694(ra) # 5a76 <printf>
    exit(1);
     11c:	4505                	li	a0,1
     11e:	00005097          	auipc	ra,0x5
     122:	5d8080e7          	jalr	1496(ra) # 56f6 <exit>

0000000000000126 <truncate2>:
{
     126:	7179                	addi	sp,sp,-48
     128:	f406                	sd	ra,40(sp)
     12a:	f022                	sd	s0,32(sp)
     12c:	ec26                	sd	s1,24(sp)
     12e:	e84a                	sd	s2,16(sp)
     130:	e44e                	sd	s3,8(sp)
     132:	1800                	addi	s0,sp,48
     134:	89aa                	mv	s3,a0
  unlink("truncfile");
     136:	00006517          	auipc	a0,0x6
     13a:	f5a50513          	addi	a0,a0,-166 # 6090 <malloc+0x55a>
     13e:	00005097          	auipc	ra,0x5
     142:	608080e7          	jalr	1544(ra) # 5746 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     146:	60100593          	li	a1,1537
     14a:	00006517          	auipc	a0,0x6
     14e:	f4650513          	addi	a0,a0,-186 # 6090 <malloc+0x55a>
     152:	00005097          	auipc	ra,0x5
     156:	5e4080e7          	jalr	1508(ra) # 5736 <open>
     15a:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     15c:	4611                	li	a2,4
     15e:	00006597          	auipc	a1,0x6
     162:	f4258593          	addi	a1,a1,-190 # 60a0 <malloc+0x56a>
     166:	00005097          	auipc	ra,0x5
     16a:	5b0080e7          	jalr	1456(ra) # 5716 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     16e:	40100593          	li	a1,1025
     172:	00006517          	auipc	a0,0x6
     176:	f1e50513          	addi	a0,a0,-226 # 6090 <malloc+0x55a>
     17a:	00005097          	auipc	ra,0x5
     17e:	5bc080e7          	jalr	1468(ra) # 5736 <open>
     182:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     184:	4605                	li	a2,1
     186:	00006597          	auipc	a1,0x6
     18a:	f2258593          	addi	a1,a1,-222 # 60a8 <malloc+0x572>
     18e:	8526                	mv	a0,s1
     190:	00005097          	auipc	ra,0x5
     194:	586080e7          	jalr	1414(ra) # 5716 <write>
  if(n != -1){
     198:	57fd                	li	a5,-1
     19a:	02f51b63          	bne	a0,a5,1d0 <truncate2+0xaa>
  unlink("truncfile");
     19e:	00006517          	auipc	a0,0x6
     1a2:	ef250513          	addi	a0,a0,-270 # 6090 <malloc+0x55a>
     1a6:	00005097          	auipc	ra,0x5
     1aa:	5a0080e7          	jalr	1440(ra) # 5746 <unlink>
  close(fd1);
     1ae:	8526                	mv	a0,s1
     1b0:	00005097          	auipc	ra,0x5
     1b4:	56e080e7          	jalr	1390(ra) # 571e <close>
  close(fd2);
     1b8:	854a                	mv	a0,s2
     1ba:	00005097          	auipc	ra,0x5
     1be:	564080e7          	jalr	1380(ra) # 571e <close>
}
     1c2:	70a2                	ld	ra,40(sp)
     1c4:	7402                	ld	s0,32(sp)
     1c6:	64e2                	ld	s1,24(sp)
     1c8:	6942                	ld	s2,16(sp)
     1ca:	69a2                	ld	s3,8(sp)
     1cc:	6145                	addi	sp,sp,48
     1ce:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1d0:	862a                	mv	a2,a0
     1d2:	85ce                	mv	a1,s3
     1d4:	00006517          	auipc	a0,0x6
     1d8:	edc50513          	addi	a0,a0,-292 # 60b0 <malloc+0x57a>
     1dc:	00006097          	auipc	ra,0x6
     1e0:	89a080e7          	jalr	-1894(ra) # 5a76 <printf>
    exit(1);
     1e4:	4505                	li	a0,1
     1e6:	00005097          	auipc	ra,0x5
     1ea:	510080e7          	jalr	1296(ra) # 56f6 <exit>

00000000000001ee <createtest>:
{
     1ee:	7179                	addi	sp,sp,-48
     1f0:	f406                	sd	ra,40(sp)
     1f2:	f022                	sd	s0,32(sp)
     1f4:	ec26                	sd	s1,24(sp)
     1f6:	e84a                	sd	s2,16(sp)
     1f8:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1fa:	06100793          	li	a5,97
     1fe:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     202:	fc040d23          	sb	zero,-38(s0)
     206:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     20a:	06400913          	li	s2,100
    name[1] = '0' + i;
     20e:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     212:	20200593          	li	a1,514
     216:	fd840513          	addi	a0,s0,-40
     21a:	00005097          	auipc	ra,0x5
     21e:	51c080e7          	jalr	1308(ra) # 5736 <open>
    close(fd);
     222:	00005097          	auipc	ra,0x5
     226:	4fc080e7          	jalr	1276(ra) # 571e <close>
     22a:	2485                	addiw	s1,s1,1
     22c:	0ff4f493          	andi	s1,s1,255
  for(i = 0; i < N; i++){
     230:	fd249fe3          	bne	s1,s2,20e <createtest+0x20>
  name[0] = 'a';
     234:	06100793          	li	a5,97
     238:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     23c:	fc040d23          	sb	zero,-38(s0)
     240:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     244:	06400913          	li	s2,100
    name[1] = '0' + i;
     248:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     24c:	fd840513          	addi	a0,s0,-40
     250:	00005097          	auipc	ra,0x5
     254:	4f6080e7          	jalr	1270(ra) # 5746 <unlink>
     258:	2485                	addiw	s1,s1,1
     25a:	0ff4f493          	andi	s1,s1,255
  for(i = 0; i < N; i++){
     25e:	ff2495e3          	bne	s1,s2,248 <createtest+0x5a>
}
     262:	70a2                	ld	ra,40(sp)
     264:	7402                	ld	s0,32(sp)
     266:	64e2                	ld	s1,24(sp)
     268:	6942                	ld	s2,16(sp)
     26a:	6145                	addi	sp,sp,48
     26c:	8082                	ret

000000000000026e <bigwrite>:
{
     26e:	715d                	addi	sp,sp,-80
     270:	e486                	sd	ra,72(sp)
     272:	e0a2                	sd	s0,64(sp)
     274:	fc26                	sd	s1,56(sp)
     276:	f84a                	sd	s2,48(sp)
     278:	f44e                	sd	s3,40(sp)
     27a:	f052                	sd	s4,32(sp)
     27c:	ec56                	sd	s5,24(sp)
     27e:	e85a                	sd	s6,16(sp)
     280:	e45e                	sd	s7,8(sp)
     282:	0880                	addi	s0,sp,80
     284:	8baa                	mv	s7,a0
  unlink("bigwrite");
     286:	00006517          	auipc	a0,0x6
     28a:	e5250513          	addi	a0,a0,-430 # 60d8 <malloc+0x5a2>
     28e:	00005097          	auipc	ra,0x5
     292:	4b8080e7          	jalr	1208(ra) # 5746 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     296:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     29a:	00006a17          	auipc	s4,0x6
     29e:	e3ea0a13          	addi	s4,s4,-450 # 60d8 <malloc+0x5a2>
      int cc = write(fd, buf, sz);
     2a2:	0000c997          	auipc	s3,0xc
     2a6:	92e98993          	addi	s3,s3,-1746 # bbd0 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2aa:	6b0d                	lui	s6,0x3
     2ac:	1c9b0b13          	addi	s6,s6,457 # 31c9 <subdir+0x145>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2b0:	20200593          	li	a1,514
     2b4:	8552                	mv	a0,s4
     2b6:	00005097          	auipc	ra,0x5
     2ba:	480080e7          	jalr	1152(ra) # 5736 <open>
     2be:	892a                	mv	s2,a0
    if(fd < 0){
     2c0:	04054d63          	bltz	a0,31a <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2c4:	8626                	mv	a2,s1
     2c6:	85ce                	mv	a1,s3
     2c8:	00005097          	auipc	ra,0x5
     2cc:	44e080e7          	jalr	1102(ra) # 5716 <write>
     2d0:	8aaa                	mv	s5,a0
      if(cc != sz){
     2d2:	06a49463          	bne	s1,a0,33a <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     2d6:	8626                	mv	a2,s1
     2d8:	85ce                	mv	a1,s3
     2da:	854a                	mv	a0,s2
     2dc:	00005097          	auipc	ra,0x5
     2e0:	43a080e7          	jalr	1082(ra) # 5716 <write>
      if(cc != sz){
     2e4:	04951963          	bne	a0,s1,336 <bigwrite+0xc8>
    close(fd);
     2e8:	854a                	mv	a0,s2
     2ea:	00005097          	auipc	ra,0x5
     2ee:	434080e7          	jalr	1076(ra) # 571e <close>
    unlink("bigwrite");
     2f2:	8552                	mv	a0,s4
     2f4:	00005097          	auipc	ra,0x5
     2f8:	452080e7          	jalr	1106(ra) # 5746 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2fc:	1d74849b          	addiw	s1,s1,471
     300:	fb6498e3          	bne	s1,s6,2b0 <bigwrite+0x42>
}
     304:	60a6                	ld	ra,72(sp)
     306:	6406                	ld	s0,64(sp)
     308:	74e2                	ld	s1,56(sp)
     30a:	7942                	ld	s2,48(sp)
     30c:	79a2                	ld	s3,40(sp)
     30e:	7a02                	ld	s4,32(sp)
     310:	6ae2                	ld	s5,24(sp)
     312:	6b42                	ld	s6,16(sp)
     314:	6ba2                	ld	s7,8(sp)
     316:	6161                	addi	sp,sp,80
     318:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     31a:	85de                	mv	a1,s7
     31c:	00006517          	auipc	a0,0x6
     320:	dcc50513          	addi	a0,a0,-564 # 60e8 <malloc+0x5b2>
     324:	00005097          	auipc	ra,0x5
     328:	752080e7          	jalr	1874(ra) # 5a76 <printf>
      exit(1);
     32c:	4505                	li	a0,1
     32e:	00005097          	auipc	ra,0x5
     332:	3c8080e7          	jalr	968(ra) # 56f6 <exit>
     336:	84d6                	mv	s1,s5
      int cc = write(fd, buf, sz);
     338:	8aaa                	mv	s5,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     33a:	86d6                	mv	a3,s5
     33c:	8626                	mv	a2,s1
     33e:	85de                	mv	a1,s7
     340:	00006517          	auipc	a0,0x6
     344:	dc850513          	addi	a0,a0,-568 # 6108 <malloc+0x5d2>
     348:	00005097          	auipc	ra,0x5
     34c:	72e080e7          	jalr	1838(ra) # 5a76 <printf>
        exit(1);
     350:	4505                	li	a0,1
     352:	00005097          	auipc	ra,0x5
     356:	3a4080e7          	jalr	932(ra) # 56f6 <exit>

000000000000035a <copyin>:
{
     35a:	711d                	addi	sp,sp,-96
     35c:	ec86                	sd	ra,88(sp)
     35e:	e8a2                	sd	s0,80(sp)
     360:	e4a6                	sd	s1,72(sp)
     362:	e0ca                	sd	s2,64(sp)
     364:	fc4e                	sd	s3,56(sp)
     366:	f852                	sd	s4,48(sp)
     368:	f456                	sd	s5,40(sp)
     36a:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     36c:	4785                	li	a5,1
     36e:	07fe                	slli	a5,a5,0x1f
     370:	faf43823          	sd	a5,-80(s0)
     374:	57fd                	li	a5,-1
     376:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     37a:	fb040493          	addi	s1,s0,-80
     37e:	fc040a93          	addi	s5,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     382:	00006a17          	auipc	s4,0x6
     386:	d9ea0a13          	addi	s4,s4,-610 # 6120 <malloc+0x5ea>
    uint64 addr = addrs[ai];
     38a:	0004b903          	ld	s2,0(s1)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     38e:	20100593          	li	a1,513
     392:	8552                	mv	a0,s4
     394:	00005097          	auipc	ra,0x5
     398:	3a2080e7          	jalr	930(ra) # 5736 <open>
     39c:	89aa                	mv	s3,a0
    if(fd < 0){
     39e:	08054763          	bltz	a0,42c <copyin+0xd2>
    int n = write(fd, (void*)addr, 8192);
     3a2:	6609                	lui	a2,0x2
     3a4:	85ca                	mv	a1,s2
     3a6:	00005097          	auipc	ra,0x5
     3aa:	370080e7          	jalr	880(ra) # 5716 <write>
    if(n >= 0){
     3ae:	08055c63          	bgez	a0,446 <copyin+0xec>
    close(fd);
     3b2:	854e                	mv	a0,s3
     3b4:	00005097          	auipc	ra,0x5
     3b8:	36a080e7          	jalr	874(ra) # 571e <close>
    unlink("copyin1");
     3bc:	8552                	mv	a0,s4
     3be:	00005097          	auipc	ra,0x5
     3c2:	388080e7          	jalr	904(ra) # 5746 <unlink>
    n = write(1, (char*)addr, 8192);
     3c6:	6609                	lui	a2,0x2
     3c8:	85ca                	mv	a1,s2
     3ca:	4505                	li	a0,1
     3cc:	00005097          	auipc	ra,0x5
     3d0:	34a080e7          	jalr	842(ra) # 5716 <write>
    if(n > 0){
     3d4:	08a04863          	bgtz	a0,464 <copyin+0x10a>
    if(pipe(fds) < 0){
     3d8:	fa840513          	addi	a0,s0,-88
     3dc:	00005097          	auipc	ra,0x5
     3e0:	32a080e7          	jalr	810(ra) # 5706 <pipe>
     3e4:	08054f63          	bltz	a0,482 <copyin+0x128>
    n = write(fds[1], (char*)addr, 8192);
     3e8:	6609                	lui	a2,0x2
     3ea:	85ca                	mv	a1,s2
     3ec:	fac42503          	lw	a0,-84(s0)
     3f0:	00005097          	auipc	ra,0x5
     3f4:	326080e7          	jalr	806(ra) # 5716 <write>
    if(n > 0){
     3f8:	0aa04263          	bgtz	a0,49c <copyin+0x142>
    close(fds[0]);
     3fc:	fa842503          	lw	a0,-88(s0)
     400:	00005097          	auipc	ra,0x5
     404:	31e080e7          	jalr	798(ra) # 571e <close>
    close(fds[1]);
     408:	fac42503          	lw	a0,-84(s0)
     40c:	00005097          	auipc	ra,0x5
     410:	312080e7          	jalr	786(ra) # 571e <close>
     414:	04a1                	addi	s1,s1,8
  for(int ai = 0; ai < 2; ai++){
     416:	f7549ae3          	bne	s1,s5,38a <copyin+0x30>
}
     41a:	60e6                	ld	ra,88(sp)
     41c:	6446                	ld	s0,80(sp)
     41e:	64a6                	ld	s1,72(sp)
     420:	6906                	ld	s2,64(sp)
     422:	79e2                	ld	s3,56(sp)
     424:	7a42                	ld	s4,48(sp)
     426:	7aa2                	ld	s5,40(sp)
     428:	6125                	addi	sp,sp,96
     42a:	8082                	ret
      printf("open(copyin1) failed\n");
     42c:	00006517          	auipc	a0,0x6
     430:	cfc50513          	addi	a0,a0,-772 # 6128 <malloc+0x5f2>
     434:	00005097          	auipc	ra,0x5
     438:	642080e7          	jalr	1602(ra) # 5a76 <printf>
      exit(1);
     43c:	4505                	li	a0,1
     43e:	00005097          	auipc	ra,0x5
     442:	2b8080e7          	jalr	696(ra) # 56f6 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     446:	862a                	mv	a2,a0
     448:	85ca                	mv	a1,s2
     44a:	00006517          	auipc	a0,0x6
     44e:	cf650513          	addi	a0,a0,-778 # 6140 <malloc+0x60a>
     452:	00005097          	auipc	ra,0x5
     456:	624080e7          	jalr	1572(ra) # 5a76 <printf>
      exit(1);
     45a:	4505                	li	a0,1
     45c:	00005097          	auipc	ra,0x5
     460:	29a080e7          	jalr	666(ra) # 56f6 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     464:	862a                	mv	a2,a0
     466:	85ca                	mv	a1,s2
     468:	00006517          	auipc	a0,0x6
     46c:	d0850513          	addi	a0,a0,-760 # 6170 <malloc+0x63a>
     470:	00005097          	auipc	ra,0x5
     474:	606080e7          	jalr	1542(ra) # 5a76 <printf>
      exit(1);
     478:	4505                	li	a0,1
     47a:	00005097          	auipc	ra,0x5
     47e:	27c080e7          	jalr	636(ra) # 56f6 <exit>
      printf("pipe() failed\n");
     482:	00006517          	auipc	a0,0x6
     486:	d1e50513          	addi	a0,a0,-738 # 61a0 <malloc+0x66a>
     48a:	00005097          	auipc	ra,0x5
     48e:	5ec080e7          	jalr	1516(ra) # 5a76 <printf>
      exit(1);
     492:	4505                	li	a0,1
     494:	00005097          	auipc	ra,0x5
     498:	262080e7          	jalr	610(ra) # 56f6 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     49c:	862a                	mv	a2,a0
     49e:	85ca                	mv	a1,s2
     4a0:	00006517          	auipc	a0,0x6
     4a4:	d1050513          	addi	a0,a0,-752 # 61b0 <malloc+0x67a>
     4a8:	00005097          	auipc	ra,0x5
     4ac:	5ce080e7          	jalr	1486(ra) # 5a76 <printf>
      exit(1);
     4b0:	4505                	li	a0,1
     4b2:	00005097          	auipc	ra,0x5
     4b6:	244080e7          	jalr	580(ra) # 56f6 <exit>

00000000000004ba <copyout>:
{
     4ba:	711d                	addi	sp,sp,-96
     4bc:	ec86                	sd	ra,88(sp)
     4be:	e8a2                	sd	s0,80(sp)
     4c0:	e4a6                	sd	s1,72(sp)
     4c2:	e0ca                	sd	s2,64(sp)
     4c4:	fc4e                	sd	s3,56(sp)
     4c6:	f852                	sd	s4,48(sp)
     4c8:	f456                	sd	s5,40(sp)
     4ca:	f05a                	sd	s6,32(sp)
     4cc:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     4ce:	4785                	li	a5,1
     4d0:	07fe                	slli	a5,a5,0x1f
     4d2:	faf43823          	sd	a5,-80(s0)
     4d6:	57fd                	li	a5,-1
     4d8:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     4dc:	fb040493          	addi	s1,s0,-80
     4e0:	fc040b13          	addi	s6,s0,-64
    int fd = open("README", 0);
     4e4:	00006a17          	auipc	s4,0x6
     4e8:	cfca0a13          	addi	s4,s4,-772 # 61e0 <malloc+0x6aa>
    n = write(fds[1], "x", 1);
     4ec:	00006a97          	auipc	s5,0x6
     4f0:	bbca8a93          	addi	s5,s5,-1092 # 60a8 <malloc+0x572>
    uint64 addr = addrs[ai];
     4f4:	0004b983          	ld	s3,0(s1)
    int fd = open("README", 0);
     4f8:	4581                	li	a1,0
     4fa:	8552                	mv	a0,s4
     4fc:	00005097          	auipc	ra,0x5
     500:	23a080e7          	jalr	570(ra) # 5736 <open>
     504:	892a                	mv	s2,a0
    if(fd < 0){
     506:	08054563          	bltz	a0,590 <copyout+0xd6>
    int n = read(fd, (void*)addr, 8192);
     50a:	6609                	lui	a2,0x2
     50c:	85ce                	mv	a1,s3
     50e:	00005097          	auipc	ra,0x5
     512:	200080e7          	jalr	512(ra) # 570e <read>
    if(n > 0){
     516:	08a04a63          	bgtz	a0,5aa <copyout+0xf0>
    close(fd);
     51a:	854a                	mv	a0,s2
     51c:	00005097          	auipc	ra,0x5
     520:	202080e7          	jalr	514(ra) # 571e <close>
    if(pipe(fds) < 0){
     524:	fa840513          	addi	a0,s0,-88
     528:	00005097          	auipc	ra,0x5
     52c:	1de080e7          	jalr	478(ra) # 5706 <pipe>
     530:	08054c63          	bltz	a0,5c8 <copyout+0x10e>
    n = write(fds[1], "x", 1);
     534:	4605                	li	a2,1
     536:	85d6                	mv	a1,s5
     538:	fac42503          	lw	a0,-84(s0)
     53c:	00005097          	auipc	ra,0x5
     540:	1da080e7          	jalr	474(ra) # 5716 <write>
    if(n != 1){
     544:	4785                	li	a5,1
     546:	08f51e63          	bne	a0,a5,5e2 <copyout+0x128>
    n = read(fds[0], (void*)addr, 8192);
     54a:	6609                	lui	a2,0x2
     54c:	85ce                	mv	a1,s3
     54e:	fa842503          	lw	a0,-88(s0)
     552:	00005097          	auipc	ra,0x5
     556:	1bc080e7          	jalr	444(ra) # 570e <read>
    if(n > 0){
     55a:	0aa04163          	bgtz	a0,5fc <copyout+0x142>
    close(fds[0]);
     55e:	fa842503          	lw	a0,-88(s0)
     562:	00005097          	auipc	ra,0x5
     566:	1bc080e7          	jalr	444(ra) # 571e <close>
    close(fds[1]);
     56a:	fac42503          	lw	a0,-84(s0)
     56e:	00005097          	auipc	ra,0x5
     572:	1b0080e7          	jalr	432(ra) # 571e <close>
     576:	04a1                	addi	s1,s1,8
  for(int ai = 0; ai < 2; ai++){
     578:	f7649ee3          	bne	s1,s6,4f4 <copyout+0x3a>
}
     57c:	60e6                	ld	ra,88(sp)
     57e:	6446                	ld	s0,80(sp)
     580:	64a6                	ld	s1,72(sp)
     582:	6906                	ld	s2,64(sp)
     584:	79e2                	ld	s3,56(sp)
     586:	7a42                	ld	s4,48(sp)
     588:	7aa2                	ld	s5,40(sp)
     58a:	7b02                	ld	s6,32(sp)
     58c:	6125                	addi	sp,sp,96
     58e:	8082                	ret
      printf("open(README) failed\n");
     590:	00006517          	auipc	a0,0x6
     594:	c5850513          	addi	a0,a0,-936 # 61e8 <malloc+0x6b2>
     598:	00005097          	auipc	ra,0x5
     59c:	4de080e7          	jalr	1246(ra) # 5a76 <printf>
      exit(1);
     5a0:	4505                	li	a0,1
     5a2:	00005097          	auipc	ra,0x5
     5a6:	154080e7          	jalr	340(ra) # 56f6 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5aa:	862a                	mv	a2,a0
     5ac:	85ce                	mv	a1,s3
     5ae:	00006517          	auipc	a0,0x6
     5b2:	c5250513          	addi	a0,a0,-942 # 6200 <malloc+0x6ca>
     5b6:	00005097          	auipc	ra,0x5
     5ba:	4c0080e7          	jalr	1216(ra) # 5a76 <printf>
      exit(1);
     5be:	4505                	li	a0,1
     5c0:	00005097          	auipc	ra,0x5
     5c4:	136080e7          	jalr	310(ra) # 56f6 <exit>
      printf("pipe() failed\n");
     5c8:	00006517          	auipc	a0,0x6
     5cc:	bd850513          	addi	a0,a0,-1064 # 61a0 <malloc+0x66a>
     5d0:	00005097          	auipc	ra,0x5
     5d4:	4a6080e7          	jalr	1190(ra) # 5a76 <printf>
      exit(1);
     5d8:	4505                	li	a0,1
     5da:	00005097          	auipc	ra,0x5
     5de:	11c080e7          	jalr	284(ra) # 56f6 <exit>
      printf("pipe write failed\n");
     5e2:	00006517          	auipc	a0,0x6
     5e6:	c4e50513          	addi	a0,a0,-946 # 6230 <malloc+0x6fa>
     5ea:	00005097          	auipc	ra,0x5
     5ee:	48c080e7          	jalr	1164(ra) # 5a76 <printf>
      exit(1);
     5f2:	4505                	li	a0,1
     5f4:	00005097          	auipc	ra,0x5
     5f8:	102080e7          	jalr	258(ra) # 56f6 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5fc:	862a                	mv	a2,a0
     5fe:	85ce                	mv	a1,s3
     600:	00006517          	auipc	a0,0x6
     604:	c4850513          	addi	a0,a0,-952 # 6248 <malloc+0x712>
     608:	00005097          	auipc	ra,0x5
     60c:	46e080e7          	jalr	1134(ra) # 5a76 <printf>
      exit(1);
     610:	4505                	li	a0,1
     612:	00005097          	auipc	ra,0x5
     616:	0e4080e7          	jalr	228(ra) # 56f6 <exit>

000000000000061a <truncate1>:
{
     61a:	711d                	addi	sp,sp,-96
     61c:	ec86                	sd	ra,88(sp)
     61e:	e8a2                	sd	s0,80(sp)
     620:	e4a6                	sd	s1,72(sp)
     622:	e0ca                	sd	s2,64(sp)
     624:	fc4e                	sd	s3,56(sp)
     626:	f852                	sd	s4,48(sp)
     628:	f456                	sd	s5,40(sp)
     62a:	1080                	addi	s0,sp,96
     62c:	8aaa                	mv	s5,a0
  unlink("truncfile");
     62e:	00006517          	auipc	a0,0x6
     632:	a6250513          	addi	a0,a0,-1438 # 6090 <malloc+0x55a>
     636:	00005097          	auipc	ra,0x5
     63a:	110080e7          	jalr	272(ra) # 5746 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     63e:	60100593          	li	a1,1537
     642:	00006517          	auipc	a0,0x6
     646:	a4e50513          	addi	a0,a0,-1458 # 6090 <malloc+0x55a>
     64a:	00005097          	auipc	ra,0x5
     64e:	0ec080e7          	jalr	236(ra) # 5736 <open>
     652:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     654:	4611                	li	a2,4
     656:	00006597          	auipc	a1,0x6
     65a:	a4a58593          	addi	a1,a1,-1462 # 60a0 <malloc+0x56a>
     65e:	00005097          	auipc	ra,0x5
     662:	0b8080e7          	jalr	184(ra) # 5716 <write>
  close(fd1);
     666:	8526                	mv	a0,s1
     668:	00005097          	auipc	ra,0x5
     66c:	0b6080e7          	jalr	182(ra) # 571e <close>
  int fd2 = open("truncfile", O_RDONLY);
     670:	4581                	li	a1,0
     672:	00006517          	auipc	a0,0x6
     676:	a1e50513          	addi	a0,a0,-1506 # 6090 <malloc+0x55a>
     67a:	00005097          	auipc	ra,0x5
     67e:	0bc080e7          	jalr	188(ra) # 5736 <open>
     682:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     684:	02000613          	li	a2,32
     688:	fa040593          	addi	a1,s0,-96
     68c:	00005097          	auipc	ra,0x5
     690:	082080e7          	jalr	130(ra) # 570e <read>
  if(n != 4){
     694:	4791                	li	a5,4
     696:	0cf51e63          	bne	a0,a5,772 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     69a:	40100593          	li	a1,1025
     69e:	00006517          	auipc	a0,0x6
     6a2:	9f250513          	addi	a0,a0,-1550 # 6090 <malloc+0x55a>
     6a6:	00005097          	auipc	ra,0x5
     6aa:	090080e7          	jalr	144(ra) # 5736 <open>
     6ae:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     6b0:	4581                	li	a1,0
     6b2:	00006517          	auipc	a0,0x6
     6b6:	9de50513          	addi	a0,a0,-1570 # 6090 <malloc+0x55a>
     6ba:	00005097          	auipc	ra,0x5
     6be:	07c080e7          	jalr	124(ra) # 5736 <open>
     6c2:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6c4:	02000613          	li	a2,32
     6c8:	fa040593          	addi	a1,s0,-96
     6cc:	00005097          	auipc	ra,0x5
     6d0:	042080e7          	jalr	66(ra) # 570e <read>
     6d4:	8a2a                	mv	s4,a0
  if(n != 0){
     6d6:	ed4d                	bnez	a0,790 <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     6d8:	02000613          	li	a2,32
     6dc:	fa040593          	addi	a1,s0,-96
     6e0:	8526                	mv	a0,s1
     6e2:	00005097          	auipc	ra,0x5
     6e6:	02c080e7          	jalr	44(ra) # 570e <read>
     6ea:	8a2a                	mv	s4,a0
  if(n != 0){
     6ec:	e971                	bnez	a0,7c0 <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     6ee:	4619                	li	a2,6
     6f0:	00006597          	auipc	a1,0x6
     6f4:	be858593          	addi	a1,a1,-1048 # 62d8 <malloc+0x7a2>
     6f8:	854e                	mv	a0,s3
     6fa:	00005097          	auipc	ra,0x5
     6fe:	01c080e7          	jalr	28(ra) # 5716 <write>
  n = read(fd3, buf, sizeof(buf));
     702:	02000613          	li	a2,32
     706:	fa040593          	addi	a1,s0,-96
     70a:	854a                	mv	a0,s2
     70c:	00005097          	auipc	ra,0x5
     710:	002080e7          	jalr	2(ra) # 570e <read>
  if(n != 6){
     714:	4799                	li	a5,6
     716:	0cf51d63          	bne	a0,a5,7f0 <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     71a:	02000613          	li	a2,32
     71e:	fa040593          	addi	a1,s0,-96
     722:	8526                	mv	a0,s1
     724:	00005097          	auipc	ra,0x5
     728:	fea080e7          	jalr	-22(ra) # 570e <read>
  if(n != 2){
     72c:	4789                	li	a5,2
     72e:	0ef51063          	bne	a0,a5,80e <truncate1+0x1f4>
  unlink("truncfile");
     732:	00006517          	auipc	a0,0x6
     736:	95e50513          	addi	a0,a0,-1698 # 6090 <malloc+0x55a>
     73a:	00005097          	auipc	ra,0x5
     73e:	00c080e7          	jalr	12(ra) # 5746 <unlink>
  close(fd1);
     742:	854e                	mv	a0,s3
     744:	00005097          	auipc	ra,0x5
     748:	fda080e7          	jalr	-38(ra) # 571e <close>
  close(fd2);
     74c:	8526                	mv	a0,s1
     74e:	00005097          	auipc	ra,0x5
     752:	fd0080e7          	jalr	-48(ra) # 571e <close>
  close(fd3);
     756:	854a                	mv	a0,s2
     758:	00005097          	auipc	ra,0x5
     75c:	fc6080e7          	jalr	-58(ra) # 571e <close>
}
     760:	60e6                	ld	ra,88(sp)
     762:	6446                	ld	s0,80(sp)
     764:	64a6                	ld	s1,72(sp)
     766:	6906                	ld	s2,64(sp)
     768:	79e2                	ld	s3,56(sp)
     76a:	7a42                	ld	s4,48(sp)
     76c:	7aa2                	ld	s5,40(sp)
     76e:	6125                	addi	sp,sp,96
     770:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     772:	862a                	mv	a2,a0
     774:	85d6                	mv	a1,s5
     776:	00006517          	auipc	a0,0x6
     77a:	b0250513          	addi	a0,a0,-1278 # 6278 <malloc+0x742>
     77e:	00005097          	auipc	ra,0x5
     782:	2f8080e7          	jalr	760(ra) # 5a76 <printf>
    exit(1);
     786:	4505                	li	a0,1
     788:	00005097          	auipc	ra,0x5
     78c:	f6e080e7          	jalr	-146(ra) # 56f6 <exit>
    printf("aaa fd3=%d\n", fd3);
     790:	85ca                	mv	a1,s2
     792:	00006517          	auipc	a0,0x6
     796:	b0650513          	addi	a0,a0,-1274 # 6298 <malloc+0x762>
     79a:	00005097          	auipc	ra,0x5
     79e:	2dc080e7          	jalr	732(ra) # 5a76 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7a2:	8652                	mv	a2,s4
     7a4:	85d6                	mv	a1,s5
     7a6:	00006517          	auipc	a0,0x6
     7aa:	b0250513          	addi	a0,a0,-1278 # 62a8 <malloc+0x772>
     7ae:	00005097          	auipc	ra,0x5
     7b2:	2c8080e7          	jalr	712(ra) # 5a76 <printf>
    exit(1);
     7b6:	4505                	li	a0,1
     7b8:	00005097          	auipc	ra,0x5
     7bc:	f3e080e7          	jalr	-194(ra) # 56f6 <exit>
    printf("bbb fd2=%d\n", fd2);
     7c0:	85a6                	mv	a1,s1
     7c2:	00006517          	auipc	a0,0x6
     7c6:	b0650513          	addi	a0,a0,-1274 # 62c8 <malloc+0x792>
     7ca:	00005097          	auipc	ra,0x5
     7ce:	2ac080e7          	jalr	684(ra) # 5a76 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7d2:	8652                	mv	a2,s4
     7d4:	85d6                	mv	a1,s5
     7d6:	00006517          	auipc	a0,0x6
     7da:	ad250513          	addi	a0,a0,-1326 # 62a8 <malloc+0x772>
     7de:	00005097          	auipc	ra,0x5
     7e2:	298080e7          	jalr	664(ra) # 5a76 <printf>
    exit(1);
     7e6:	4505                	li	a0,1
     7e8:	00005097          	auipc	ra,0x5
     7ec:	f0e080e7          	jalr	-242(ra) # 56f6 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     7f0:	862a                	mv	a2,a0
     7f2:	85d6                	mv	a1,s5
     7f4:	00006517          	auipc	a0,0x6
     7f8:	aec50513          	addi	a0,a0,-1300 # 62e0 <malloc+0x7aa>
     7fc:	00005097          	auipc	ra,0x5
     800:	27a080e7          	jalr	634(ra) # 5a76 <printf>
    exit(1);
     804:	4505                	li	a0,1
     806:	00005097          	auipc	ra,0x5
     80a:	ef0080e7          	jalr	-272(ra) # 56f6 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     80e:	862a                	mv	a2,a0
     810:	85d6                	mv	a1,s5
     812:	00006517          	auipc	a0,0x6
     816:	aee50513          	addi	a0,a0,-1298 # 6300 <malloc+0x7ca>
     81a:	00005097          	auipc	ra,0x5
     81e:	25c080e7          	jalr	604(ra) # 5a76 <printf>
    exit(1);
     822:	4505                	li	a0,1
     824:	00005097          	auipc	ra,0x5
     828:	ed2080e7          	jalr	-302(ra) # 56f6 <exit>

000000000000082c <writetest>:
{
     82c:	7139                	addi	sp,sp,-64
     82e:	fc06                	sd	ra,56(sp)
     830:	f822                	sd	s0,48(sp)
     832:	f426                	sd	s1,40(sp)
     834:	f04a                	sd	s2,32(sp)
     836:	ec4e                	sd	s3,24(sp)
     838:	e852                	sd	s4,16(sp)
     83a:	e456                	sd	s5,8(sp)
     83c:	e05a                	sd	s6,0(sp)
     83e:	0080                	addi	s0,sp,64
     840:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     842:	20200593          	li	a1,514
     846:	00006517          	auipc	a0,0x6
     84a:	ada50513          	addi	a0,a0,-1318 # 6320 <malloc+0x7ea>
     84e:	00005097          	auipc	ra,0x5
     852:	ee8080e7          	jalr	-280(ra) # 5736 <open>
  if(fd < 0){
     856:	0a054d63          	bltz	a0,910 <writetest+0xe4>
     85a:	892a                	mv	s2,a0
     85c:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     85e:	00006997          	auipc	s3,0x6
     862:	aea98993          	addi	s3,s3,-1302 # 6348 <malloc+0x812>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     866:	00006a97          	auipc	s5,0x6
     86a:	b1aa8a93          	addi	s5,s5,-1254 # 6380 <malloc+0x84a>
  for(i = 0; i < N; i++){
     86e:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     872:	4629                	li	a2,10
     874:	85ce                	mv	a1,s3
     876:	854a                	mv	a0,s2
     878:	00005097          	auipc	ra,0x5
     87c:	e9e080e7          	jalr	-354(ra) # 5716 <write>
     880:	47a9                	li	a5,10
     882:	0af51563          	bne	a0,a5,92c <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     886:	4629                	li	a2,10
     888:	85d6                	mv	a1,s5
     88a:	854a                	mv	a0,s2
     88c:	00005097          	auipc	ra,0x5
     890:	e8a080e7          	jalr	-374(ra) # 5716 <write>
     894:	47a9                	li	a5,10
     896:	0af51a63          	bne	a0,a5,94a <writetest+0x11e>
  for(i = 0; i < N; i++){
     89a:	2485                	addiw	s1,s1,1
     89c:	fd449be3          	bne	s1,s4,872 <writetest+0x46>
  close(fd);
     8a0:	854a                	mv	a0,s2
     8a2:	00005097          	auipc	ra,0x5
     8a6:	e7c080e7          	jalr	-388(ra) # 571e <close>
  fd = open("small", O_RDONLY);
     8aa:	4581                	li	a1,0
     8ac:	00006517          	auipc	a0,0x6
     8b0:	a7450513          	addi	a0,a0,-1420 # 6320 <malloc+0x7ea>
     8b4:	00005097          	auipc	ra,0x5
     8b8:	e82080e7          	jalr	-382(ra) # 5736 <open>
     8bc:	84aa                	mv	s1,a0
  if(fd < 0){
     8be:	0a054563          	bltz	a0,968 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     8c2:	7d000613          	li	a2,2000
     8c6:	0000b597          	auipc	a1,0xb
     8ca:	30a58593          	addi	a1,a1,778 # bbd0 <buf>
     8ce:	00005097          	auipc	ra,0x5
     8d2:	e40080e7          	jalr	-448(ra) # 570e <read>
  if(i != N*SZ*2){
     8d6:	7d000793          	li	a5,2000
     8da:	0af51563          	bne	a0,a5,984 <writetest+0x158>
  close(fd);
     8de:	8526                	mv	a0,s1
     8e0:	00005097          	auipc	ra,0x5
     8e4:	e3e080e7          	jalr	-450(ra) # 571e <close>
  if(unlink("small") < 0){
     8e8:	00006517          	auipc	a0,0x6
     8ec:	a3850513          	addi	a0,a0,-1480 # 6320 <malloc+0x7ea>
     8f0:	00005097          	auipc	ra,0x5
     8f4:	e56080e7          	jalr	-426(ra) # 5746 <unlink>
     8f8:	0a054463          	bltz	a0,9a0 <writetest+0x174>
}
     8fc:	70e2                	ld	ra,56(sp)
     8fe:	7442                	ld	s0,48(sp)
     900:	74a2                	ld	s1,40(sp)
     902:	7902                	ld	s2,32(sp)
     904:	69e2                	ld	s3,24(sp)
     906:	6a42                	ld	s4,16(sp)
     908:	6aa2                	ld	s5,8(sp)
     90a:	6b02                	ld	s6,0(sp)
     90c:	6121                	addi	sp,sp,64
     90e:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     910:	85da                	mv	a1,s6
     912:	00006517          	auipc	a0,0x6
     916:	a1650513          	addi	a0,a0,-1514 # 6328 <malloc+0x7f2>
     91a:	00005097          	auipc	ra,0x5
     91e:	15c080e7          	jalr	348(ra) # 5a76 <printf>
    exit(1);
     922:	4505                	li	a0,1
     924:	00005097          	auipc	ra,0x5
     928:	dd2080e7          	jalr	-558(ra) # 56f6 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     92c:	8626                	mv	a2,s1
     92e:	85da                	mv	a1,s6
     930:	00006517          	auipc	a0,0x6
     934:	a2850513          	addi	a0,a0,-1496 # 6358 <malloc+0x822>
     938:	00005097          	auipc	ra,0x5
     93c:	13e080e7          	jalr	318(ra) # 5a76 <printf>
      exit(1);
     940:	4505                	li	a0,1
     942:	00005097          	auipc	ra,0x5
     946:	db4080e7          	jalr	-588(ra) # 56f6 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     94a:	8626                	mv	a2,s1
     94c:	85da                	mv	a1,s6
     94e:	00006517          	auipc	a0,0x6
     952:	a4250513          	addi	a0,a0,-1470 # 6390 <malloc+0x85a>
     956:	00005097          	auipc	ra,0x5
     95a:	120080e7          	jalr	288(ra) # 5a76 <printf>
      exit(1);
     95e:	4505                	li	a0,1
     960:	00005097          	auipc	ra,0x5
     964:	d96080e7          	jalr	-618(ra) # 56f6 <exit>
    printf("%s: error: open small failed!\n", s);
     968:	85da                	mv	a1,s6
     96a:	00006517          	auipc	a0,0x6
     96e:	a4e50513          	addi	a0,a0,-1458 # 63b8 <malloc+0x882>
     972:	00005097          	auipc	ra,0x5
     976:	104080e7          	jalr	260(ra) # 5a76 <printf>
    exit(1);
     97a:	4505                	li	a0,1
     97c:	00005097          	auipc	ra,0x5
     980:	d7a080e7          	jalr	-646(ra) # 56f6 <exit>
    printf("%s: read failed\n", s);
     984:	85da                	mv	a1,s6
     986:	00006517          	auipc	a0,0x6
     98a:	a5250513          	addi	a0,a0,-1454 # 63d8 <malloc+0x8a2>
     98e:	00005097          	auipc	ra,0x5
     992:	0e8080e7          	jalr	232(ra) # 5a76 <printf>
    exit(1);
     996:	4505                	li	a0,1
     998:	00005097          	auipc	ra,0x5
     99c:	d5e080e7          	jalr	-674(ra) # 56f6 <exit>
    printf("%s: unlink small failed\n", s);
     9a0:	85da                	mv	a1,s6
     9a2:	00006517          	auipc	a0,0x6
     9a6:	a4e50513          	addi	a0,a0,-1458 # 63f0 <malloc+0x8ba>
     9aa:	00005097          	auipc	ra,0x5
     9ae:	0cc080e7          	jalr	204(ra) # 5a76 <printf>
    exit(1);
     9b2:	4505                	li	a0,1
     9b4:	00005097          	auipc	ra,0x5
     9b8:	d42080e7          	jalr	-702(ra) # 56f6 <exit>

00000000000009bc <writebig>:
{
     9bc:	7139                	addi	sp,sp,-64
     9be:	fc06                	sd	ra,56(sp)
     9c0:	f822                	sd	s0,48(sp)
     9c2:	f426                	sd	s1,40(sp)
     9c4:	f04a                	sd	s2,32(sp)
     9c6:	ec4e                	sd	s3,24(sp)
     9c8:	e852                	sd	s4,16(sp)
     9ca:	e456                	sd	s5,8(sp)
     9cc:	0080                	addi	s0,sp,64
     9ce:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9d0:	20200593          	li	a1,514
     9d4:	00006517          	auipc	a0,0x6
     9d8:	a3c50513          	addi	a0,a0,-1476 # 6410 <malloc+0x8da>
     9dc:	00005097          	auipc	ra,0x5
     9e0:	d5a080e7          	jalr	-678(ra) # 5736 <open>
  if(fd < 0){
     9e4:	08054563          	bltz	a0,a6e <writebig+0xb2>
     9e8:	89aa                	mv	s3,a0
     9ea:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9ec:	0000b917          	auipc	s2,0xb
     9f0:	1e490913          	addi	s2,s2,484 # bbd0 <buf>
  for(i = 0; i < MAXFILE; i++){
     9f4:	6a41                	lui	s4,0x10
     9f6:	507a0a13          	addi	s4,s4,1287 # 10507 <_end+0x1927>
    ((int*)buf)[0] = i;
     9fa:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9fe:	40000613          	li	a2,1024
     a02:	85ca                	mv	a1,s2
     a04:	854e                	mv	a0,s3
     a06:	00005097          	auipc	ra,0x5
     a0a:	d10080e7          	jalr	-752(ra) # 5716 <write>
     a0e:	40000793          	li	a5,1024
     a12:	06f51c63          	bne	a0,a5,a8a <writebig+0xce>
  for(i = 0; i < MAXFILE; i++){
     a16:	2485                	addiw	s1,s1,1
     a18:	ff4491e3          	bne	s1,s4,9fa <writebig+0x3e>
  close(fd);
     a1c:	854e                	mv	a0,s3
     a1e:	00005097          	auipc	ra,0x5
     a22:	d00080e7          	jalr	-768(ra) # 571e <close>
  fd = open("big", O_RDONLY);
     a26:	4581                	li	a1,0
     a28:	00006517          	auipc	a0,0x6
     a2c:	9e850513          	addi	a0,a0,-1560 # 6410 <malloc+0x8da>
     a30:	00005097          	auipc	ra,0x5
     a34:	d06080e7          	jalr	-762(ra) # 5736 <open>
     a38:	89aa                	mv	s3,a0
  n = 0;
     a3a:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a3c:	0000b917          	auipc	s2,0xb
     a40:	19490913          	addi	s2,s2,404 # bbd0 <buf>
  if(fd < 0){
     a44:	06054263          	bltz	a0,aa8 <writebig+0xec>
    i = read(fd, buf, BSIZE);
     a48:	40000613          	li	a2,1024
     a4c:	85ca                	mv	a1,s2
     a4e:	854e                	mv	a0,s3
     a50:	00005097          	auipc	ra,0x5
     a54:	cbe080e7          	jalr	-834(ra) # 570e <read>
    if(i == 0){
     a58:	c535                	beqz	a0,ac4 <writebig+0x108>
    } else if(i != BSIZE){
     a5a:	40000793          	li	a5,1024
     a5e:	0af51f63          	bne	a0,a5,b1c <writebig+0x160>
    if(((int*)buf)[0] != n){
     a62:	00092683          	lw	a3,0(s2)
     a66:	0c969a63          	bne	a3,s1,b3a <writebig+0x17e>
    n++;
     a6a:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a6c:	bff1                	j	a48 <writebig+0x8c>
    printf("%s: error: creat big failed!\n", s);
     a6e:	85d6                	mv	a1,s5
     a70:	00006517          	auipc	a0,0x6
     a74:	9a850513          	addi	a0,a0,-1624 # 6418 <malloc+0x8e2>
     a78:	00005097          	auipc	ra,0x5
     a7c:	ffe080e7          	jalr	-2(ra) # 5a76 <printf>
    exit(1);
     a80:	4505                	li	a0,1
     a82:	00005097          	auipc	ra,0x5
     a86:	c74080e7          	jalr	-908(ra) # 56f6 <exit>
      printf("%s: error: write big file failed\n", s, i);
     a8a:	8626                	mv	a2,s1
     a8c:	85d6                	mv	a1,s5
     a8e:	00006517          	auipc	a0,0x6
     a92:	9aa50513          	addi	a0,a0,-1622 # 6438 <malloc+0x902>
     a96:	00005097          	auipc	ra,0x5
     a9a:	fe0080e7          	jalr	-32(ra) # 5a76 <printf>
      exit(1);
     a9e:	4505                	li	a0,1
     aa0:	00005097          	auipc	ra,0x5
     aa4:	c56080e7          	jalr	-938(ra) # 56f6 <exit>
    printf("%s: error: open big failed!\n", s);
     aa8:	85d6                	mv	a1,s5
     aaa:	00006517          	auipc	a0,0x6
     aae:	9b650513          	addi	a0,a0,-1610 # 6460 <malloc+0x92a>
     ab2:	00005097          	auipc	ra,0x5
     ab6:	fc4080e7          	jalr	-60(ra) # 5a76 <printf>
    exit(1);
     aba:	4505                	li	a0,1
     abc:	00005097          	auipc	ra,0x5
     ac0:	c3a080e7          	jalr	-966(ra) # 56f6 <exit>
      if(n == MAXFILE - 1){
     ac4:	67c1                	lui	a5,0x10
     ac6:	50678793          	addi	a5,a5,1286 # 10506 <_end+0x1926>
     aca:	02f48a63          	beq	s1,a5,afe <writebig+0x142>
  close(fd);
     ace:	854e                	mv	a0,s3
     ad0:	00005097          	auipc	ra,0x5
     ad4:	c4e080e7          	jalr	-946(ra) # 571e <close>
  if(unlink("big") < 0){
     ad8:	00006517          	auipc	a0,0x6
     adc:	93850513          	addi	a0,a0,-1736 # 6410 <malloc+0x8da>
     ae0:	00005097          	auipc	ra,0x5
     ae4:	c66080e7          	jalr	-922(ra) # 5746 <unlink>
     ae8:	06054863          	bltz	a0,b58 <writebig+0x19c>
}
     aec:	70e2                	ld	ra,56(sp)
     aee:	7442                	ld	s0,48(sp)
     af0:	74a2                	ld	s1,40(sp)
     af2:	7902                	ld	s2,32(sp)
     af4:	69e2                	ld	s3,24(sp)
     af6:	6a42                	ld	s4,16(sp)
     af8:	6aa2                	ld	s5,8(sp)
     afa:	6121                	addi	sp,sp,64
     afc:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     afe:	863e                	mv	a2,a5
     b00:	85d6                	mv	a1,s5
     b02:	00006517          	auipc	a0,0x6
     b06:	97e50513          	addi	a0,a0,-1666 # 6480 <malloc+0x94a>
     b0a:	00005097          	auipc	ra,0x5
     b0e:	f6c080e7          	jalr	-148(ra) # 5a76 <printf>
        exit(1);
     b12:	4505                	li	a0,1
     b14:	00005097          	auipc	ra,0x5
     b18:	be2080e7          	jalr	-1054(ra) # 56f6 <exit>
      printf("%s: read failed %d\n", s, i);
     b1c:	862a                	mv	a2,a0
     b1e:	85d6                	mv	a1,s5
     b20:	00006517          	auipc	a0,0x6
     b24:	98850513          	addi	a0,a0,-1656 # 64a8 <malloc+0x972>
     b28:	00005097          	auipc	ra,0x5
     b2c:	f4e080e7          	jalr	-178(ra) # 5a76 <printf>
      exit(1);
     b30:	4505                	li	a0,1
     b32:	00005097          	auipc	ra,0x5
     b36:	bc4080e7          	jalr	-1084(ra) # 56f6 <exit>
      printf("%s: read content of block %d is %d\n", s,
     b3a:	8626                	mv	a2,s1
     b3c:	85d6                	mv	a1,s5
     b3e:	00006517          	auipc	a0,0x6
     b42:	98250513          	addi	a0,a0,-1662 # 64c0 <malloc+0x98a>
     b46:	00005097          	auipc	ra,0x5
     b4a:	f30080e7          	jalr	-208(ra) # 5a76 <printf>
      exit(1);
     b4e:	4505                	li	a0,1
     b50:	00005097          	auipc	ra,0x5
     b54:	ba6080e7          	jalr	-1114(ra) # 56f6 <exit>
    printf("%s: unlink big failed\n", s);
     b58:	85d6                	mv	a1,s5
     b5a:	00006517          	auipc	a0,0x6
     b5e:	98e50513          	addi	a0,a0,-1650 # 64e8 <malloc+0x9b2>
     b62:	00005097          	auipc	ra,0x5
     b66:	f14080e7          	jalr	-236(ra) # 5a76 <printf>
    exit(1);
     b6a:	4505                	li	a0,1
     b6c:	00005097          	auipc	ra,0x5
     b70:	b8a080e7          	jalr	-1142(ra) # 56f6 <exit>

0000000000000b74 <unlinkread>:
{
     b74:	7179                	addi	sp,sp,-48
     b76:	f406                	sd	ra,40(sp)
     b78:	f022                	sd	s0,32(sp)
     b7a:	ec26                	sd	s1,24(sp)
     b7c:	e84a                	sd	s2,16(sp)
     b7e:	e44e                	sd	s3,8(sp)
     b80:	1800                	addi	s0,sp,48
     b82:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b84:	20200593          	li	a1,514
     b88:	00006517          	auipc	a0,0x6
     b8c:	97850513          	addi	a0,a0,-1672 # 6500 <malloc+0x9ca>
     b90:	00005097          	auipc	ra,0x5
     b94:	ba6080e7          	jalr	-1114(ra) # 5736 <open>
  if(fd < 0){
     b98:	0e054563          	bltz	a0,c82 <unlinkread+0x10e>
     b9c:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b9e:	4615                	li	a2,5
     ba0:	00006597          	auipc	a1,0x6
     ba4:	99058593          	addi	a1,a1,-1648 # 6530 <malloc+0x9fa>
     ba8:	00005097          	auipc	ra,0x5
     bac:	b6e080e7          	jalr	-1170(ra) # 5716 <write>
  close(fd);
     bb0:	8526                	mv	a0,s1
     bb2:	00005097          	auipc	ra,0x5
     bb6:	b6c080e7          	jalr	-1172(ra) # 571e <close>
  fd = open("unlinkread", O_RDWR);
     bba:	4589                	li	a1,2
     bbc:	00006517          	auipc	a0,0x6
     bc0:	94450513          	addi	a0,a0,-1724 # 6500 <malloc+0x9ca>
     bc4:	00005097          	auipc	ra,0x5
     bc8:	b72080e7          	jalr	-1166(ra) # 5736 <open>
     bcc:	84aa                	mv	s1,a0
  if(fd < 0){
     bce:	0c054863          	bltz	a0,c9e <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     bd2:	00006517          	auipc	a0,0x6
     bd6:	92e50513          	addi	a0,a0,-1746 # 6500 <malloc+0x9ca>
     bda:	00005097          	auipc	ra,0x5
     bde:	b6c080e7          	jalr	-1172(ra) # 5746 <unlink>
     be2:	ed61                	bnez	a0,cba <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     be4:	20200593          	li	a1,514
     be8:	00006517          	auipc	a0,0x6
     bec:	91850513          	addi	a0,a0,-1768 # 6500 <malloc+0x9ca>
     bf0:	00005097          	auipc	ra,0x5
     bf4:	b46080e7          	jalr	-1210(ra) # 5736 <open>
     bf8:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     bfa:	460d                	li	a2,3
     bfc:	00006597          	auipc	a1,0x6
     c00:	97c58593          	addi	a1,a1,-1668 # 6578 <malloc+0xa42>
     c04:	00005097          	auipc	ra,0x5
     c08:	b12080e7          	jalr	-1262(ra) # 5716 <write>
  close(fd1);
     c0c:	854a                	mv	a0,s2
     c0e:	00005097          	auipc	ra,0x5
     c12:	b10080e7          	jalr	-1264(ra) # 571e <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c16:	660d                	lui	a2,0x3
     c18:	0000b597          	auipc	a1,0xb
     c1c:	fb858593          	addi	a1,a1,-72 # bbd0 <buf>
     c20:	8526                	mv	a0,s1
     c22:	00005097          	auipc	ra,0x5
     c26:	aec080e7          	jalr	-1300(ra) # 570e <read>
     c2a:	4795                	li	a5,5
     c2c:	0af51563          	bne	a0,a5,cd6 <unlinkread+0x162>
  if(buf[0] != 'h'){
     c30:	0000b717          	auipc	a4,0xb
     c34:	fa074703          	lbu	a4,-96(a4) # bbd0 <buf>
     c38:	06800793          	li	a5,104
     c3c:	0af71b63          	bne	a4,a5,cf2 <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c40:	4629                	li	a2,10
     c42:	0000b597          	auipc	a1,0xb
     c46:	f8e58593          	addi	a1,a1,-114 # bbd0 <buf>
     c4a:	8526                	mv	a0,s1
     c4c:	00005097          	auipc	ra,0x5
     c50:	aca080e7          	jalr	-1334(ra) # 5716 <write>
     c54:	47a9                	li	a5,10
     c56:	0af51c63          	bne	a0,a5,d0e <unlinkread+0x19a>
  close(fd);
     c5a:	8526                	mv	a0,s1
     c5c:	00005097          	auipc	ra,0x5
     c60:	ac2080e7          	jalr	-1342(ra) # 571e <close>
  unlink("unlinkread");
     c64:	00006517          	auipc	a0,0x6
     c68:	89c50513          	addi	a0,a0,-1892 # 6500 <malloc+0x9ca>
     c6c:	00005097          	auipc	ra,0x5
     c70:	ada080e7          	jalr	-1318(ra) # 5746 <unlink>
}
     c74:	70a2                	ld	ra,40(sp)
     c76:	7402                	ld	s0,32(sp)
     c78:	64e2                	ld	s1,24(sp)
     c7a:	6942                	ld	s2,16(sp)
     c7c:	69a2                	ld	s3,8(sp)
     c7e:	6145                	addi	sp,sp,48
     c80:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c82:	85ce                	mv	a1,s3
     c84:	00006517          	auipc	a0,0x6
     c88:	88c50513          	addi	a0,a0,-1908 # 6510 <malloc+0x9da>
     c8c:	00005097          	auipc	ra,0x5
     c90:	dea080e7          	jalr	-534(ra) # 5a76 <printf>
    exit(1);
     c94:	4505                	li	a0,1
     c96:	00005097          	auipc	ra,0x5
     c9a:	a60080e7          	jalr	-1440(ra) # 56f6 <exit>
    printf("%s: open unlinkread failed\n", s);
     c9e:	85ce                	mv	a1,s3
     ca0:	00006517          	auipc	a0,0x6
     ca4:	89850513          	addi	a0,a0,-1896 # 6538 <malloc+0xa02>
     ca8:	00005097          	auipc	ra,0x5
     cac:	dce080e7          	jalr	-562(ra) # 5a76 <printf>
    exit(1);
     cb0:	4505                	li	a0,1
     cb2:	00005097          	auipc	ra,0x5
     cb6:	a44080e7          	jalr	-1468(ra) # 56f6 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     cba:	85ce                	mv	a1,s3
     cbc:	00006517          	auipc	a0,0x6
     cc0:	89c50513          	addi	a0,a0,-1892 # 6558 <malloc+0xa22>
     cc4:	00005097          	auipc	ra,0x5
     cc8:	db2080e7          	jalr	-590(ra) # 5a76 <printf>
    exit(1);
     ccc:	4505                	li	a0,1
     cce:	00005097          	auipc	ra,0x5
     cd2:	a28080e7          	jalr	-1496(ra) # 56f6 <exit>
    printf("%s: unlinkread read failed", s);
     cd6:	85ce                	mv	a1,s3
     cd8:	00006517          	auipc	a0,0x6
     cdc:	8a850513          	addi	a0,a0,-1880 # 6580 <malloc+0xa4a>
     ce0:	00005097          	auipc	ra,0x5
     ce4:	d96080e7          	jalr	-618(ra) # 5a76 <printf>
    exit(1);
     ce8:	4505                	li	a0,1
     cea:	00005097          	auipc	ra,0x5
     cee:	a0c080e7          	jalr	-1524(ra) # 56f6 <exit>
    printf("%s: unlinkread wrong data\n", s);
     cf2:	85ce                	mv	a1,s3
     cf4:	00006517          	auipc	a0,0x6
     cf8:	8ac50513          	addi	a0,a0,-1876 # 65a0 <malloc+0xa6a>
     cfc:	00005097          	auipc	ra,0x5
     d00:	d7a080e7          	jalr	-646(ra) # 5a76 <printf>
    exit(1);
     d04:	4505                	li	a0,1
     d06:	00005097          	auipc	ra,0x5
     d0a:	9f0080e7          	jalr	-1552(ra) # 56f6 <exit>
    printf("%s: unlinkread write failed\n", s);
     d0e:	85ce                	mv	a1,s3
     d10:	00006517          	auipc	a0,0x6
     d14:	8b050513          	addi	a0,a0,-1872 # 65c0 <malloc+0xa8a>
     d18:	00005097          	auipc	ra,0x5
     d1c:	d5e080e7          	jalr	-674(ra) # 5a76 <printf>
    exit(1);
     d20:	4505                	li	a0,1
     d22:	00005097          	auipc	ra,0x5
     d26:	9d4080e7          	jalr	-1580(ra) # 56f6 <exit>

0000000000000d2a <linktest>:
{
     d2a:	1101                	addi	sp,sp,-32
     d2c:	ec06                	sd	ra,24(sp)
     d2e:	e822                	sd	s0,16(sp)
     d30:	e426                	sd	s1,8(sp)
     d32:	e04a                	sd	s2,0(sp)
     d34:	1000                	addi	s0,sp,32
     d36:	892a                	mv	s2,a0
  unlink("lf1");
     d38:	00006517          	auipc	a0,0x6
     d3c:	8a850513          	addi	a0,a0,-1880 # 65e0 <malloc+0xaaa>
     d40:	00005097          	auipc	ra,0x5
     d44:	a06080e7          	jalr	-1530(ra) # 5746 <unlink>
  unlink("lf2");
     d48:	00006517          	auipc	a0,0x6
     d4c:	8a050513          	addi	a0,a0,-1888 # 65e8 <malloc+0xab2>
     d50:	00005097          	auipc	ra,0x5
     d54:	9f6080e7          	jalr	-1546(ra) # 5746 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d58:	20200593          	li	a1,514
     d5c:	00006517          	auipc	a0,0x6
     d60:	88450513          	addi	a0,a0,-1916 # 65e0 <malloc+0xaaa>
     d64:	00005097          	auipc	ra,0x5
     d68:	9d2080e7          	jalr	-1582(ra) # 5736 <open>
  if(fd < 0){
     d6c:	10054763          	bltz	a0,e7a <linktest+0x150>
     d70:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d72:	4615                	li	a2,5
     d74:	00005597          	auipc	a1,0x5
     d78:	7bc58593          	addi	a1,a1,1980 # 6530 <malloc+0x9fa>
     d7c:	00005097          	auipc	ra,0x5
     d80:	99a080e7          	jalr	-1638(ra) # 5716 <write>
     d84:	4795                	li	a5,5
     d86:	10f51863          	bne	a0,a5,e96 <linktest+0x16c>
  close(fd);
     d8a:	8526                	mv	a0,s1
     d8c:	00005097          	auipc	ra,0x5
     d90:	992080e7          	jalr	-1646(ra) # 571e <close>
  if(link("lf1", "lf2") < 0){
     d94:	00006597          	auipc	a1,0x6
     d98:	85458593          	addi	a1,a1,-1964 # 65e8 <malloc+0xab2>
     d9c:	00006517          	auipc	a0,0x6
     da0:	84450513          	addi	a0,a0,-1980 # 65e0 <malloc+0xaaa>
     da4:	00005097          	auipc	ra,0x5
     da8:	9b2080e7          	jalr	-1614(ra) # 5756 <link>
     dac:	10054363          	bltz	a0,eb2 <linktest+0x188>
  unlink("lf1");
     db0:	00006517          	auipc	a0,0x6
     db4:	83050513          	addi	a0,a0,-2000 # 65e0 <malloc+0xaaa>
     db8:	00005097          	auipc	ra,0x5
     dbc:	98e080e7          	jalr	-1650(ra) # 5746 <unlink>
  if(open("lf1", 0) >= 0){
     dc0:	4581                	li	a1,0
     dc2:	00006517          	auipc	a0,0x6
     dc6:	81e50513          	addi	a0,a0,-2018 # 65e0 <malloc+0xaaa>
     dca:	00005097          	auipc	ra,0x5
     dce:	96c080e7          	jalr	-1684(ra) # 5736 <open>
     dd2:	0e055e63          	bgez	a0,ece <linktest+0x1a4>
  fd = open("lf2", 0);
     dd6:	4581                	li	a1,0
     dd8:	00006517          	auipc	a0,0x6
     ddc:	81050513          	addi	a0,a0,-2032 # 65e8 <malloc+0xab2>
     de0:	00005097          	auipc	ra,0x5
     de4:	956080e7          	jalr	-1706(ra) # 5736 <open>
     de8:	84aa                	mv	s1,a0
  if(fd < 0){
     dea:	10054063          	bltz	a0,eea <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     dee:	660d                	lui	a2,0x3
     df0:	0000b597          	auipc	a1,0xb
     df4:	de058593          	addi	a1,a1,-544 # bbd0 <buf>
     df8:	00005097          	auipc	ra,0x5
     dfc:	916080e7          	jalr	-1770(ra) # 570e <read>
     e00:	4795                	li	a5,5
     e02:	10f51263          	bne	a0,a5,f06 <linktest+0x1dc>
  close(fd);
     e06:	8526                	mv	a0,s1
     e08:	00005097          	auipc	ra,0x5
     e0c:	916080e7          	jalr	-1770(ra) # 571e <close>
  if(link("lf2", "lf2") >= 0){
     e10:	00005597          	auipc	a1,0x5
     e14:	7d858593          	addi	a1,a1,2008 # 65e8 <malloc+0xab2>
     e18:	852e                	mv	a0,a1
     e1a:	00005097          	auipc	ra,0x5
     e1e:	93c080e7          	jalr	-1732(ra) # 5756 <link>
     e22:	10055063          	bgez	a0,f22 <linktest+0x1f8>
  unlink("lf2");
     e26:	00005517          	auipc	a0,0x5
     e2a:	7c250513          	addi	a0,a0,1986 # 65e8 <malloc+0xab2>
     e2e:	00005097          	auipc	ra,0x5
     e32:	918080e7          	jalr	-1768(ra) # 5746 <unlink>
  if(link("lf2", "lf1") >= 0){
     e36:	00005597          	auipc	a1,0x5
     e3a:	7aa58593          	addi	a1,a1,1962 # 65e0 <malloc+0xaaa>
     e3e:	00005517          	auipc	a0,0x5
     e42:	7aa50513          	addi	a0,a0,1962 # 65e8 <malloc+0xab2>
     e46:	00005097          	auipc	ra,0x5
     e4a:	910080e7          	jalr	-1776(ra) # 5756 <link>
     e4e:	0e055863          	bgez	a0,f3e <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e52:	00005597          	auipc	a1,0x5
     e56:	78e58593          	addi	a1,a1,1934 # 65e0 <malloc+0xaaa>
     e5a:	00006517          	auipc	a0,0x6
     e5e:	89650513          	addi	a0,a0,-1898 # 66f0 <malloc+0xbba>
     e62:	00005097          	auipc	ra,0x5
     e66:	8f4080e7          	jalr	-1804(ra) # 5756 <link>
     e6a:	0e055863          	bgez	a0,f5a <linktest+0x230>
}
     e6e:	60e2                	ld	ra,24(sp)
     e70:	6442                	ld	s0,16(sp)
     e72:	64a2                	ld	s1,8(sp)
     e74:	6902                	ld	s2,0(sp)
     e76:	6105                	addi	sp,sp,32
     e78:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     e7a:	85ca                	mv	a1,s2
     e7c:	00005517          	auipc	a0,0x5
     e80:	77450513          	addi	a0,a0,1908 # 65f0 <malloc+0xaba>
     e84:	00005097          	auipc	ra,0x5
     e88:	bf2080e7          	jalr	-1038(ra) # 5a76 <printf>
    exit(1);
     e8c:	4505                	li	a0,1
     e8e:	00005097          	auipc	ra,0x5
     e92:	868080e7          	jalr	-1944(ra) # 56f6 <exit>
    printf("%s: write lf1 failed\n", s);
     e96:	85ca                	mv	a1,s2
     e98:	00005517          	auipc	a0,0x5
     e9c:	77050513          	addi	a0,a0,1904 # 6608 <malloc+0xad2>
     ea0:	00005097          	auipc	ra,0x5
     ea4:	bd6080e7          	jalr	-1066(ra) # 5a76 <printf>
    exit(1);
     ea8:	4505                	li	a0,1
     eaa:	00005097          	auipc	ra,0x5
     eae:	84c080e7          	jalr	-1972(ra) # 56f6 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     eb2:	85ca                	mv	a1,s2
     eb4:	00005517          	auipc	a0,0x5
     eb8:	76c50513          	addi	a0,a0,1900 # 6620 <malloc+0xaea>
     ebc:	00005097          	auipc	ra,0x5
     ec0:	bba080e7          	jalr	-1094(ra) # 5a76 <printf>
    exit(1);
     ec4:	4505                	li	a0,1
     ec6:	00005097          	auipc	ra,0x5
     eca:	830080e7          	jalr	-2000(ra) # 56f6 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     ece:	85ca                	mv	a1,s2
     ed0:	00005517          	auipc	a0,0x5
     ed4:	77050513          	addi	a0,a0,1904 # 6640 <malloc+0xb0a>
     ed8:	00005097          	auipc	ra,0x5
     edc:	b9e080e7          	jalr	-1122(ra) # 5a76 <printf>
    exit(1);
     ee0:	4505                	li	a0,1
     ee2:	00005097          	auipc	ra,0x5
     ee6:	814080e7          	jalr	-2028(ra) # 56f6 <exit>
    printf("%s: open lf2 failed\n", s);
     eea:	85ca                	mv	a1,s2
     eec:	00005517          	auipc	a0,0x5
     ef0:	78450513          	addi	a0,a0,1924 # 6670 <malloc+0xb3a>
     ef4:	00005097          	auipc	ra,0x5
     ef8:	b82080e7          	jalr	-1150(ra) # 5a76 <printf>
    exit(1);
     efc:	4505                	li	a0,1
     efe:	00004097          	auipc	ra,0x4
     f02:	7f8080e7          	jalr	2040(ra) # 56f6 <exit>
    printf("%s: read lf2 failed\n", s);
     f06:	85ca                	mv	a1,s2
     f08:	00005517          	auipc	a0,0x5
     f0c:	78050513          	addi	a0,a0,1920 # 6688 <malloc+0xb52>
     f10:	00005097          	auipc	ra,0x5
     f14:	b66080e7          	jalr	-1178(ra) # 5a76 <printf>
    exit(1);
     f18:	4505                	li	a0,1
     f1a:	00004097          	auipc	ra,0x4
     f1e:	7dc080e7          	jalr	2012(ra) # 56f6 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f22:	85ca                	mv	a1,s2
     f24:	00005517          	auipc	a0,0x5
     f28:	77c50513          	addi	a0,a0,1916 # 66a0 <malloc+0xb6a>
     f2c:	00005097          	auipc	ra,0x5
     f30:	b4a080e7          	jalr	-1206(ra) # 5a76 <printf>
    exit(1);
     f34:	4505                	li	a0,1
     f36:	00004097          	auipc	ra,0x4
     f3a:	7c0080e7          	jalr	1984(ra) # 56f6 <exit>
    printf("%s: link non-existant succeeded! oops\n", s);
     f3e:	85ca                	mv	a1,s2
     f40:	00005517          	auipc	a0,0x5
     f44:	78850513          	addi	a0,a0,1928 # 66c8 <malloc+0xb92>
     f48:	00005097          	auipc	ra,0x5
     f4c:	b2e080e7          	jalr	-1234(ra) # 5a76 <printf>
    exit(1);
     f50:	4505                	li	a0,1
     f52:	00004097          	auipc	ra,0x4
     f56:	7a4080e7          	jalr	1956(ra) # 56f6 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f5a:	85ca                	mv	a1,s2
     f5c:	00005517          	auipc	a0,0x5
     f60:	79c50513          	addi	a0,a0,1948 # 66f8 <malloc+0xbc2>
     f64:	00005097          	auipc	ra,0x5
     f68:	b12080e7          	jalr	-1262(ra) # 5a76 <printf>
    exit(1);
     f6c:	4505                	li	a0,1
     f6e:	00004097          	auipc	ra,0x4
     f72:	788080e7          	jalr	1928(ra) # 56f6 <exit>

0000000000000f76 <bigdir>:
{
     f76:	715d                	addi	sp,sp,-80
     f78:	e486                	sd	ra,72(sp)
     f7a:	e0a2                	sd	s0,64(sp)
     f7c:	fc26                	sd	s1,56(sp)
     f7e:	f84a                	sd	s2,48(sp)
     f80:	f44e                	sd	s3,40(sp)
     f82:	f052                	sd	s4,32(sp)
     f84:	ec56                	sd	s5,24(sp)
     f86:	e85a                	sd	s6,16(sp)
     f88:	0880                	addi	s0,sp,80
     f8a:	89aa                	mv	s3,a0
  unlink("bd");
     f8c:	00005517          	auipc	a0,0x5
     f90:	78c50513          	addi	a0,a0,1932 # 6718 <malloc+0xbe2>
     f94:	00004097          	auipc	ra,0x4
     f98:	7b2080e7          	jalr	1970(ra) # 5746 <unlink>
  fd = open("bd", O_CREATE);
     f9c:	20000593          	li	a1,512
     fa0:	00005517          	auipc	a0,0x5
     fa4:	77850513          	addi	a0,a0,1912 # 6718 <malloc+0xbe2>
     fa8:	00004097          	auipc	ra,0x4
     fac:	78e080e7          	jalr	1934(ra) # 5736 <open>
  if(fd < 0){
     fb0:	0c054963          	bltz	a0,1082 <bigdir+0x10c>
  close(fd);
     fb4:	00004097          	auipc	ra,0x4
     fb8:	76a080e7          	jalr	1898(ra) # 571e <close>
  for(i = 0; i < N; i++){
     fbc:	4901                	li	s2,0
    name[0] = 'x';
     fbe:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     fc2:	00005a17          	auipc	s4,0x5
     fc6:	756a0a13          	addi	s4,s4,1878 # 6718 <malloc+0xbe2>
  for(i = 0; i < N; i++){
     fca:	1f400b13          	li	s6,500
    name[0] = 'x';
     fce:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     fd2:	41f9579b          	sraiw	a5,s2,0x1f
     fd6:	01a7d71b          	srliw	a4,a5,0x1a
     fda:	012707bb          	addw	a5,a4,s2
     fde:	4067d69b          	sraiw	a3,a5,0x6
     fe2:	0306869b          	addiw	a3,a3,48
     fe6:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     fea:	03f7f793          	andi	a5,a5,63
     fee:	9f99                	subw	a5,a5,a4
     ff0:	0307879b          	addiw	a5,a5,48
     ff4:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     ff8:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     ffc:	fb040593          	addi	a1,s0,-80
    1000:	8552                	mv	a0,s4
    1002:	00004097          	auipc	ra,0x4
    1006:	754080e7          	jalr	1876(ra) # 5756 <link>
    100a:	84aa                	mv	s1,a0
    100c:	e949                	bnez	a0,109e <bigdir+0x128>
  for(i = 0; i < N; i++){
    100e:	2905                	addiw	s2,s2,1
    1010:	fb691fe3          	bne	s2,s6,fce <bigdir+0x58>
  unlink("bd");
    1014:	00005517          	auipc	a0,0x5
    1018:	70450513          	addi	a0,a0,1796 # 6718 <malloc+0xbe2>
    101c:	00004097          	auipc	ra,0x4
    1020:	72a080e7          	jalr	1834(ra) # 5746 <unlink>
    name[0] = 'x';
    1024:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1028:	1f400a13          	li	s4,500
    name[0] = 'x';
    102c:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    1030:	41f4d79b          	sraiw	a5,s1,0x1f
    1034:	01a7d71b          	srliw	a4,a5,0x1a
    1038:	009707bb          	addw	a5,a4,s1
    103c:	4067d69b          	sraiw	a3,a5,0x6
    1040:	0306869b          	addiw	a3,a3,48
    1044:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1048:	03f7f793          	andi	a5,a5,63
    104c:	9f99                	subw	a5,a5,a4
    104e:	0307879b          	addiw	a5,a5,48
    1052:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1056:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    105a:	fb040513          	addi	a0,s0,-80
    105e:	00004097          	auipc	ra,0x4
    1062:	6e8080e7          	jalr	1768(ra) # 5746 <unlink>
    1066:	ed21                	bnez	a0,10be <bigdir+0x148>
  for(i = 0; i < N; i++){
    1068:	2485                	addiw	s1,s1,1
    106a:	fd4491e3          	bne	s1,s4,102c <bigdir+0xb6>
}
    106e:	60a6                	ld	ra,72(sp)
    1070:	6406                	ld	s0,64(sp)
    1072:	74e2                	ld	s1,56(sp)
    1074:	7942                	ld	s2,48(sp)
    1076:	79a2                	ld	s3,40(sp)
    1078:	7a02                	ld	s4,32(sp)
    107a:	6ae2                	ld	s5,24(sp)
    107c:	6b42                	ld	s6,16(sp)
    107e:	6161                	addi	sp,sp,80
    1080:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    1082:	85ce                	mv	a1,s3
    1084:	00005517          	auipc	a0,0x5
    1088:	69c50513          	addi	a0,a0,1692 # 6720 <malloc+0xbea>
    108c:	00005097          	auipc	ra,0x5
    1090:	9ea080e7          	jalr	-1558(ra) # 5a76 <printf>
    exit(1);
    1094:	4505                	li	a0,1
    1096:	00004097          	auipc	ra,0x4
    109a:	660080e7          	jalr	1632(ra) # 56f6 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    109e:	fb040613          	addi	a2,s0,-80
    10a2:	85ce                	mv	a1,s3
    10a4:	00005517          	auipc	a0,0x5
    10a8:	69c50513          	addi	a0,a0,1692 # 6740 <malloc+0xc0a>
    10ac:	00005097          	auipc	ra,0x5
    10b0:	9ca080e7          	jalr	-1590(ra) # 5a76 <printf>
      exit(1);
    10b4:	4505                	li	a0,1
    10b6:	00004097          	auipc	ra,0x4
    10ba:	640080e7          	jalr	1600(ra) # 56f6 <exit>
      printf("%s: bigdir unlink failed", s);
    10be:	85ce                	mv	a1,s3
    10c0:	00005517          	auipc	a0,0x5
    10c4:	6a050513          	addi	a0,a0,1696 # 6760 <malloc+0xc2a>
    10c8:	00005097          	auipc	ra,0x5
    10cc:	9ae080e7          	jalr	-1618(ra) # 5a76 <printf>
      exit(1);
    10d0:	4505                	li	a0,1
    10d2:	00004097          	auipc	ra,0x4
    10d6:	624080e7          	jalr	1572(ra) # 56f6 <exit>

00000000000010da <validatetest>:
{
    10da:	7139                	addi	sp,sp,-64
    10dc:	fc06                	sd	ra,56(sp)
    10de:	f822                	sd	s0,48(sp)
    10e0:	f426                	sd	s1,40(sp)
    10e2:	f04a                	sd	s2,32(sp)
    10e4:	ec4e                	sd	s3,24(sp)
    10e6:	e852                	sd	s4,16(sp)
    10e8:	e456                	sd	s5,8(sp)
    10ea:	e05a                	sd	s6,0(sp)
    10ec:	0080                	addi	s0,sp,64
    10ee:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10f0:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    10f2:	00005997          	auipc	s3,0x5
    10f6:	68e98993          	addi	s3,s3,1678 # 6780 <malloc+0xc4a>
    10fa:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10fc:	6a85                	lui	s5,0x1
    10fe:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    1102:	85a6                	mv	a1,s1
    1104:	854e                	mv	a0,s3
    1106:	00004097          	auipc	ra,0x4
    110a:	650080e7          	jalr	1616(ra) # 5756 <link>
    110e:	01251f63          	bne	a0,s2,112c <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1112:	94d6                	add	s1,s1,s5
    1114:	ff4497e3          	bne	s1,s4,1102 <validatetest+0x28>
}
    1118:	70e2                	ld	ra,56(sp)
    111a:	7442                	ld	s0,48(sp)
    111c:	74a2                	ld	s1,40(sp)
    111e:	7902                	ld	s2,32(sp)
    1120:	69e2                	ld	s3,24(sp)
    1122:	6a42                	ld	s4,16(sp)
    1124:	6aa2                	ld	s5,8(sp)
    1126:	6b02                	ld	s6,0(sp)
    1128:	6121                	addi	sp,sp,64
    112a:	8082                	ret
      printf("%s: link should not succeed\n", s);
    112c:	85da                	mv	a1,s6
    112e:	00005517          	auipc	a0,0x5
    1132:	66250513          	addi	a0,a0,1634 # 6790 <malloc+0xc5a>
    1136:	00005097          	auipc	ra,0x5
    113a:	940080e7          	jalr	-1728(ra) # 5a76 <printf>
      exit(1);
    113e:	4505                	li	a0,1
    1140:	00004097          	auipc	ra,0x4
    1144:	5b6080e7          	jalr	1462(ra) # 56f6 <exit>

0000000000001148 <pgbug>:
// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void
pgbug(char *s)
{
    1148:	7179                	addi	sp,sp,-48
    114a:	f406                	sd	ra,40(sp)
    114c:	f022                	sd	s0,32(sp)
    114e:	ec26                	sd	s1,24(sp)
    1150:	1800                	addi	s0,sp,48
  char *argv[1];
  argv[0] = 0;
    1152:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    1156:	00007797          	auipc	a5,0x7
    115a:	24a78793          	addi	a5,a5,586 # 83a0 <digits+0x20>
    115e:	6384                	ld	s1,0(a5)
    1160:	fd840593          	addi	a1,s0,-40
    1164:	8526                	mv	a0,s1
    1166:	00004097          	auipc	ra,0x4
    116a:	5c8080e7          	jalr	1480(ra) # 572e <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    116e:	8526                	mv	a0,s1
    1170:	00004097          	auipc	ra,0x4
    1174:	596080e7          	jalr	1430(ra) # 5706 <pipe>

  exit(0);
    1178:	4501                	li	a0,0
    117a:	00004097          	auipc	ra,0x4
    117e:	57c080e7          	jalr	1404(ra) # 56f6 <exit>

0000000000001182 <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    1182:	7139                	addi	sp,sp,-64
    1184:	fc06                	sd	ra,56(sp)
    1186:	f822                	sd	s0,48(sp)
    1188:	f426                	sd	s1,40(sp)
    118a:	f04a                	sd	s2,32(sp)
    118c:	ec4e                	sd	s3,24(sp)
    118e:	0080                	addi	s0,sp,64
    1190:	64b1                	lui	s1,0xc
    1192:	35048493          	addi	s1,s1,848 # c350 <buf+0x780>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    1196:	597d                	li	s2,-1
    1198:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    119c:	00005997          	auipc	s3,0x5
    11a0:	e9c98993          	addi	s3,s3,-356 # 6038 <malloc+0x502>
    argv[0] = (char*)0xffffffff;
    11a4:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    11a8:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    11ac:	fc040593          	addi	a1,s0,-64
    11b0:	854e                	mv	a0,s3
    11b2:	00004097          	auipc	ra,0x4
    11b6:	57c080e7          	jalr	1404(ra) # 572e <exec>
    11ba:	34fd                	addiw	s1,s1,-1
  for(int i = 0; i < 50000; i++){
    11bc:	f4e5                	bnez	s1,11a4 <badarg+0x22>
  }
  
  exit(0);
    11be:	4501                	li	a0,0
    11c0:	00004097          	auipc	ra,0x4
    11c4:	536080e7          	jalr	1334(ra) # 56f6 <exit>

00000000000011c8 <copyinstr2>:
{
    11c8:	7155                	addi	sp,sp,-208
    11ca:	e586                	sd	ra,200(sp)
    11cc:	e1a2                	sd	s0,192(sp)
    11ce:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    11d0:	f6840793          	addi	a5,s0,-152
    11d4:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    11d8:	07800713          	li	a4,120
    11dc:	00e78023          	sb	a4,0(a5)
    11e0:	0785                	addi	a5,a5,1
  for(int i = 0; i < MAXPATH; i++)
    11e2:	fed79de3          	bne	a5,a3,11dc <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    11e6:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    11ea:	f6840513          	addi	a0,s0,-152
    11ee:	00004097          	auipc	ra,0x4
    11f2:	558080e7          	jalr	1368(ra) # 5746 <unlink>
  if(ret != -1){
    11f6:	57fd                	li	a5,-1
    11f8:	0ef51063          	bne	a0,a5,12d8 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    11fc:	20100593          	li	a1,513
    1200:	f6840513          	addi	a0,s0,-152
    1204:	00004097          	auipc	ra,0x4
    1208:	532080e7          	jalr	1330(ra) # 5736 <open>
  if(fd != -1){
    120c:	57fd                	li	a5,-1
    120e:	0ef51563          	bne	a0,a5,12f8 <copyinstr2+0x130>
  ret = link(b, b);
    1212:	f6840593          	addi	a1,s0,-152
    1216:	852e                	mv	a0,a1
    1218:	00004097          	auipc	ra,0x4
    121c:	53e080e7          	jalr	1342(ra) # 5756 <link>
  if(ret != -1){
    1220:	57fd                	li	a5,-1
    1222:	0ef51b63          	bne	a0,a5,1318 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    1226:	00006797          	auipc	a5,0x6
    122a:	74a78793          	addi	a5,a5,1866 # 7970 <malloc+0x1e3a>
    122e:	f4f43c23          	sd	a5,-168(s0)
    1232:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1236:	f5840593          	addi	a1,s0,-168
    123a:	f6840513          	addi	a0,s0,-152
    123e:	00004097          	auipc	ra,0x4
    1242:	4f0080e7          	jalr	1264(ra) # 572e <exec>
  if(ret != -1){
    1246:	57fd                	li	a5,-1
    1248:	0ef51963          	bne	a0,a5,133a <copyinstr2+0x172>
  int pid = fork();
    124c:	00004097          	auipc	ra,0x4
    1250:	4a2080e7          	jalr	1186(ra) # 56ee <fork>
  if(pid < 0){
    1254:	10054363          	bltz	a0,135a <copyinstr2+0x192>
  if(pid == 0){
    1258:	12051463          	bnez	a0,1380 <copyinstr2+0x1b8>
    125c:	00007797          	auipc	a5,0x7
    1260:	25c78793          	addi	a5,a5,604 # 84b8 <big.1287>
    1264:	00008697          	auipc	a3,0x8
    1268:	25468693          	addi	a3,a3,596 # 94b8 <__global_pointer$+0x918>
      big[i] = 'x';
    126c:	07800713          	li	a4,120
    1270:	00e78023          	sb	a4,0(a5)
    1274:	0785                	addi	a5,a5,1
    for(int i = 0; i < PGSIZE; i++)
    1276:	fed79de3          	bne	a5,a3,1270 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    127a:	00008797          	auipc	a5,0x8
    127e:	22078f23          	sb	zero,574(a5) # 94b8 <__global_pointer$+0x918>
    char *args2[] = { big, big, big, 0 };
    1282:	00005797          	auipc	a5,0x5
    1286:	99e78793          	addi	a5,a5,-1634 # 5c20 <malloc+0xea>
    128a:	6390                	ld	a2,0(a5)
    128c:	6794                	ld	a3,8(a5)
    128e:	6b98                	ld	a4,16(a5)
    1290:	6f9c                	ld	a5,24(a5)
    1292:	f2c43823          	sd	a2,-208(s0)
    1296:	f2d43c23          	sd	a3,-200(s0)
    129a:	f4e43023          	sd	a4,-192(s0)
    129e:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    12a2:	f3040593          	addi	a1,s0,-208
    12a6:	00005517          	auipc	a0,0x5
    12aa:	d9250513          	addi	a0,a0,-622 # 6038 <malloc+0x502>
    12ae:	00004097          	auipc	ra,0x4
    12b2:	480080e7          	jalr	1152(ra) # 572e <exec>
    if(ret != -1){
    12b6:	57fd                	li	a5,-1
    12b8:	0af50e63          	beq	a0,a5,1374 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    12bc:	55fd                	li	a1,-1
    12be:	00005517          	auipc	a0,0x5
    12c2:	57a50513          	addi	a0,a0,1402 # 6838 <malloc+0xd02>
    12c6:	00004097          	auipc	ra,0x4
    12ca:	7b0080e7          	jalr	1968(ra) # 5a76 <printf>
      exit(1);
    12ce:	4505                	li	a0,1
    12d0:	00004097          	auipc	ra,0x4
    12d4:	426080e7          	jalr	1062(ra) # 56f6 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    12d8:	862a                	mv	a2,a0
    12da:	f6840593          	addi	a1,s0,-152
    12de:	00005517          	auipc	a0,0x5
    12e2:	4d250513          	addi	a0,a0,1234 # 67b0 <malloc+0xc7a>
    12e6:	00004097          	auipc	ra,0x4
    12ea:	790080e7          	jalr	1936(ra) # 5a76 <printf>
    exit(1);
    12ee:	4505                	li	a0,1
    12f0:	00004097          	auipc	ra,0x4
    12f4:	406080e7          	jalr	1030(ra) # 56f6 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    12f8:	862a                	mv	a2,a0
    12fa:	f6840593          	addi	a1,s0,-152
    12fe:	00005517          	auipc	a0,0x5
    1302:	4d250513          	addi	a0,a0,1234 # 67d0 <malloc+0xc9a>
    1306:	00004097          	auipc	ra,0x4
    130a:	770080e7          	jalr	1904(ra) # 5a76 <printf>
    exit(1);
    130e:	4505                	li	a0,1
    1310:	00004097          	auipc	ra,0x4
    1314:	3e6080e7          	jalr	998(ra) # 56f6 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1318:	86aa                	mv	a3,a0
    131a:	f6840613          	addi	a2,s0,-152
    131e:	85b2                	mv	a1,a2
    1320:	00005517          	auipc	a0,0x5
    1324:	4d050513          	addi	a0,a0,1232 # 67f0 <malloc+0xcba>
    1328:	00004097          	auipc	ra,0x4
    132c:	74e080e7          	jalr	1870(ra) # 5a76 <printf>
    exit(1);
    1330:	4505                	li	a0,1
    1332:	00004097          	auipc	ra,0x4
    1336:	3c4080e7          	jalr	964(ra) # 56f6 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    133a:	567d                	li	a2,-1
    133c:	f6840593          	addi	a1,s0,-152
    1340:	00005517          	auipc	a0,0x5
    1344:	4d850513          	addi	a0,a0,1240 # 6818 <malloc+0xce2>
    1348:	00004097          	auipc	ra,0x4
    134c:	72e080e7          	jalr	1838(ra) # 5a76 <printf>
    exit(1);
    1350:	4505                	li	a0,1
    1352:	00004097          	auipc	ra,0x4
    1356:	3a4080e7          	jalr	932(ra) # 56f6 <exit>
    printf("fork failed\n");
    135a:	00006517          	auipc	a0,0x6
    135e:	93e50513          	addi	a0,a0,-1730 # 6c98 <malloc+0x1162>
    1362:	00004097          	auipc	ra,0x4
    1366:	714080e7          	jalr	1812(ra) # 5a76 <printf>
    exit(1);
    136a:	4505                	li	a0,1
    136c:	00004097          	auipc	ra,0x4
    1370:	38a080e7          	jalr	906(ra) # 56f6 <exit>
    exit(747); // OK
    1374:	2eb00513          	li	a0,747
    1378:	00004097          	auipc	ra,0x4
    137c:	37e080e7          	jalr	894(ra) # 56f6 <exit>
  int st = 0;
    1380:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1384:	f5440513          	addi	a0,s0,-172
    1388:	00004097          	auipc	ra,0x4
    138c:	376080e7          	jalr	886(ra) # 56fe <wait>
  if(st != 747){
    1390:	f5442703          	lw	a4,-172(s0)
    1394:	2eb00793          	li	a5,747
    1398:	00f71663          	bne	a4,a5,13a4 <copyinstr2+0x1dc>
}
    139c:	60ae                	ld	ra,200(sp)
    139e:	640e                	ld	s0,192(sp)
    13a0:	6169                	addi	sp,sp,208
    13a2:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    13a4:	00005517          	auipc	a0,0x5
    13a8:	4bc50513          	addi	a0,a0,1212 # 6860 <malloc+0xd2a>
    13ac:	00004097          	auipc	ra,0x4
    13b0:	6ca080e7          	jalr	1738(ra) # 5a76 <printf>
    exit(1);
    13b4:	4505                	li	a0,1
    13b6:	00004097          	auipc	ra,0x4
    13ba:	340080e7          	jalr	832(ra) # 56f6 <exit>

00000000000013be <truncate3>:
{
    13be:	7159                	addi	sp,sp,-112
    13c0:	f486                	sd	ra,104(sp)
    13c2:	f0a2                	sd	s0,96(sp)
    13c4:	eca6                	sd	s1,88(sp)
    13c6:	e8ca                	sd	s2,80(sp)
    13c8:	e4ce                	sd	s3,72(sp)
    13ca:	e0d2                	sd	s4,64(sp)
    13cc:	fc56                	sd	s5,56(sp)
    13ce:	1880                	addi	s0,sp,112
    13d0:	8a2a                	mv	s4,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    13d2:	60100593          	li	a1,1537
    13d6:	00005517          	auipc	a0,0x5
    13da:	cba50513          	addi	a0,a0,-838 # 6090 <malloc+0x55a>
    13de:	00004097          	auipc	ra,0x4
    13e2:	358080e7          	jalr	856(ra) # 5736 <open>
    13e6:	00004097          	auipc	ra,0x4
    13ea:	338080e7          	jalr	824(ra) # 571e <close>
  pid = fork();
    13ee:	00004097          	auipc	ra,0x4
    13f2:	300080e7          	jalr	768(ra) # 56ee <fork>
  if(pid < 0){
    13f6:	08054063          	bltz	a0,1476 <truncate3+0xb8>
  if(pid == 0){
    13fa:	e969                	bnez	a0,14cc <truncate3+0x10e>
    13fc:	06400913          	li	s2,100
      int fd = open("truncfile", O_WRONLY);
    1400:	00005997          	auipc	s3,0x5
    1404:	c9098993          	addi	s3,s3,-880 # 6090 <malloc+0x55a>
      int n = write(fd, "1234567890", 10);
    1408:	00005a97          	auipc	s5,0x5
    140c:	4b8a8a93          	addi	s5,s5,1208 # 68c0 <malloc+0xd8a>
      int fd = open("truncfile", O_WRONLY);
    1410:	4585                	li	a1,1
    1412:	854e                	mv	a0,s3
    1414:	00004097          	auipc	ra,0x4
    1418:	322080e7          	jalr	802(ra) # 5736 <open>
    141c:	84aa                	mv	s1,a0
      if(fd < 0){
    141e:	06054a63          	bltz	a0,1492 <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    1422:	4629                	li	a2,10
    1424:	85d6                	mv	a1,s5
    1426:	00004097          	auipc	ra,0x4
    142a:	2f0080e7          	jalr	752(ra) # 5716 <write>
      if(n != 10){
    142e:	47a9                	li	a5,10
    1430:	06f51f63          	bne	a0,a5,14ae <truncate3+0xf0>
      close(fd);
    1434:	8526                	mv	a0,s1
    1436:	00004097          	auipc	ra,0x4
    143a:	2e8080e7          	jalr	744(ra) # 571e <close>
      fd = open("truncfile", O_RDONLY);
    143e:	4581                	li	a1,0
    1440:	854e                	mv	a0,s3
    1442:	00004097          	auipc	ra,0x4
    1446:	2f4080e7          	jalr	756(ra) # 5736 <open>
    144a:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    144c:	02000613          	li	a2,32
    1450:	f9840593          	addi	a1,s0,-104
    1454:	00004097          	auipc	ra,0x4
    1458:	2ba080e7          	jalr	698(ra) # 570e <read>
      close(fd);
    145c:	8526                	mv	a0,s1
    145e:	00004097          	auipc	ra,0x4
    1462:	2c0080e7          	jalr	704(ra) # 571e <close>
    1466:	397d                	addiw	s2,s2,-1
    for(int i = 0; i < 100; i++){
    1468:	fa0914e3          	bnez	s2,1410 <truncate3+0x52>
    exit(0);
    146c:	4501                	li	a0,0
    146e:	00004097          	auipc	ra,0x4
    1472:	288080e7          	jalr	648(ra) # 56f6 <exit>
    printf("%s: fork failed\n", s);
    1476:	85d2                	mv	a1,s4
    1478:	00005517          	auipc	a0,0x5
    147c:	41850513          	addi	a0,a0,1048 # 6890 <malloc+0xd5a>
    1480:	00004097          	auipc	ra,0x4
    1484:	5f6080e7          	jalr	1526(ra) # 5a76 <printf>
    exit(1);
    1488:	4505                	li	a0,1
    148a:	00004097          	auipc	ra,0x4
    148e:	26c080e7          	jalr	620(ra) # 56f6 <exit>
        printf("%s: open failed\n", s);
    1492:	85d2                	mv	a1,s4
    1494:	00005517          	auipc	a0,0x5
    1498:	41450513          	addi	a0,a0,1044 # 68a8 <malloc+0xd72>
    149c:	00004097          	auipc	ra,0x4
    14a0:	5da080e7          	jalr	1498(ra) # 5a76 <printf>
        exit(1);
    14a4:	4505                	li	a0,1
    14a6:	00004097          	auipc	ra,0x4
    14aa:	250080e7          	jalr	592(ra) # 56f6 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    14ae:	862a                	mv	a2,a0
    14b0:	85d2                	mv	a1,s4
    14b2:	00005517          	auipc	a0,0x5
    14b6:	41e50513          	addi	a0,a0,1054 # 68d0 <malloc+0xd9a>
    14ba:	00004097          	auipc	ra,0x4
    14be:	5bc080e7          	jalr	1468(ra) # 5a76 <printf>
        exit(1);
    14c2:	4505                	li	a0,1
    14c4:	00004097          	auipc	ra,0x4
    14c8:	232080e7          	jalr	562(ra) # 56f6 <exit>
    14cc:	09600913          	li	s2,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14d0:	00005997          	auipc	s3,0x5
    14d4:	bc098993          	addi	s3,s3,-1088 # 6090 <malloc+0x55a>
    int n = write(fd, "xxx", 3);
    14d8:	00005a97          	auipc	s5,0x5
    14dc:	418a8a93          	addi	s5,s5,1048 # 68f0 <malloc+0xdba>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14e0:	60100593          	li	a1,1537
    14e4:	854e                	mv	a0,s3
    14e6:	00004097          	auipc	ra,0x4
    14ea:	250080e7          	jalr	592(ra) # 5736 <open>
    14ee:	84aa                	mv	s1,a0
    if(fd < 0){
    14f0:	04054763          	bltz	a0,153e <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    14f4:	460d                	li	a2,3
    14f6:	85d6                	mv	a1,s5
    14f8:	00004097          	auipc	ra,0x4
    14fc:	21e080e7          	jalr	542(ra) # 5716 <write>
    if(n != 3){
    1500:	478d                	li	a5,3
    1502:	04f51c63          	bne	a0,a5,155a <truncate3+0x19c>
    close(fd);
    1506:	8526                	mv	a0,s1
    1508:	00004097          	auipc	ra,0x4
    150c:	216080e7          	jalr	534(ra) # 571e <close>
    1510:	397d                	addiw	s2,s2,-1
  for(int i = 0; i < 150; i++){
    1512:	fc0917e3          	bnez	s2,14e0 <truncate3+0x122>
  wait(&xstatus);
    1516:	fbc40513          	addi	a0,s0,-68
    151a:	00004097          	auipc	ra,0x4
    151e:	1e4080e7          	jalr	484(ra) # 56fe <wait>
  unlink("truncfile");
    1522:	00005517          	auipc	a0,0x5
    1526:	b6e50513          	addi	a0,a0,-1170 # 6090 <malloc+0x55a>
    152a:	00004097          	auipc	ra,0x4
    152e:	21c080e7          	jalr	540(ra) # 5746 <unlink>
  exit(xstatus);
    1532:	fbc42503          	lw	a0,-68(s0)
    1536:	00004097          	auipc	ra,0x4
    153a:	1c0080e7          	jalr	448(ra) # 56f6 <exit>
      printf("%s: open failed\n", s);
    153e:	85d2                	mv	a1,s4
    1540:	00005517          	auipc	a0,0x5
    1544:	36850513          	addi	a0,a0,872 # 68a8 <malloc+0xd72>
    1548:	00004097          	auipc	ra,0x4
    154c:	52e080e7          	jalr	1326(ra) # 5a76 <printf>
      exit(1);
    1550:	4505                	li	a0,1
    1552:	00004097          	auipc	ra,0x4
    1556:	1a4080e7          	jalr	420(ra) # 56f6 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    155a:	862a                	mv	a2,a0
    155c:	85d2                	mv	a1,s4
    155e:	00005517          	auipc	a0,0x5
    1562:	39a50513          	addi	a0,a0,922 # 68f8 <malloc+0xdc2>
    1566:	00004097          	auipc	ra,0x4
    156a:	510080e7          	jalr	1296(ra) # 5a76 <printf>
      exit(1);
    156e:	4505                	li	a0,1
    1570:	00004097          	auipc	ra,0x4
    1574:	186080e7          	jalr	390(ra) # 56f6 <exit>

0000000000001578 <exectest>:
{
    1578:	715d                	addi	sp,sp,-80
    157a:	e486                	sd	ra,72(sp)
    157c:	e0a2                	sd	s0,64(sp)
    157e:	fc26                	sd	s1,56(sp)
    1580:	f84a                	sd	s2,48(sp)
    1582:	0880                	addi	s0,sp,80
    1584:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1586:	00005797          	auipc	a5,0x5
    158a:	ab278793          	addi	a5,a5,-1358 # 6038 <malloc+0x502>
    158e:	fcf43023          	sd	a5,-64(s0)
    1592:	00005797          	auipc	a5,0x5
    1596:	38678793          	addi	a5,a5,902 # 6918 <malloc+0xde2>
    159a:	fcf43423          	sd	a5,-56(s0)
    159e:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    15a2:	00005517          	auipc	a0,0x5
    15a6:	37e50513          	addi	a0,a0,894 # 6920 <malloc+0xdea>
    15aa:	00004097          	auipc	ra,0x4
    15ae:	19c080e7          	jalr	412(ra) # 5746 <unlink>
  pid = fork();
    15b2:	00004097          	auipc	ra,0x4
    15b6:	13c080e7          	jalr	316(ra) # 56ee <fork>
  if(pid < 0) {
    15ba:	04054663          	bltz	a0,1606 <exectest+0x8e>
    15be:	84aa                	mv	s1,a0
  if(pid == 0) {
    15c0:	e959                	bnez	a0,1656 <exectest+0xde>
    close(1);
    15c2:	4505                	li	a0,1
    15c4:	00004097          	auipc	ra,0x4
    15c8:	15a080e7          	jalr	346(ra) # 571e <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    15cc:	20100593          	li	a1,513
    15d0:	00005517          	auipc	a0,0x5
    15d4:	35050513          	addi	a0,a0,848 # 6920 <malloc+0xdea>
    15d8:	00004097          	auipc	ra,0x4
    15dc:	15e080e7          	jalr	350(ra) # 5736 <open>
    if(fd < 0) {
    15e0:	04054163          	bltz	a0,1622 <exectest+0xaa>
    if(fd != 1) {
    15e4:	4785                	li	a5,1
    15e6:	04f50c63          	beq	a0,a5,163e <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    15ea:	85ca                	mv	a1,s2
    15ec:	00005517          	auipc	a0,0x5
    15f0:	35450513          	addi	a0,a0,852 # 6940 <malloc+0xe0a>
    15f4:	00004097          	auipc	ra,0x4
    15f8:	482080e7          	jalr	1154(ra) # 5a76 <printf>
      exit(1);
    15fc:	4505                	li	a0,1
    15fe:	00004097          	auipc	ra,0x4
    1602:	0f8080e7          	jalr	248(ra) # 56f6 <exit>
     printf("%s: fork failed\n", s);
    1606:	85ca                	mv	a1,s2
    1608:	00005517          	auipc	a0,0x5
    160c:	28850513          	addi	a0,a0,648 # 6890 <malloc+0xd5a>
    1610:	00004097          	auipc	ra,0x4
    1614:	466080e7          	jalr	1126(ra) # 5a76 <printf>
     exit(1);
    1618:	4505                	li	a0,1
    161a:	00004097          	auipc	ra,0x4
    161e:	0dc080e7          	jalr	220(ra) # 56f6 <exit>
      printf("%s: create failed\n", s);
    1622:	85ca                	mv	a1,s2
    1624:	00005517          	auipc	a0,0x5
    1628:	30450513          	addi	a0,a0,772 # 6928 <malloc+0xdf2>
    162c:	00004097          	auipc	ra,0x4
    1630:	44a080e7          	jalr	1098(ra) # 5a76 <printf>
      exit(1);
    1634:	4505                	li	a0,1
    1636:	00004097          	auipc	ra,0x4
    163a:	0c0080e7          	jalr	192(ra) # 56f6 <exit>
    if(exec("echo", echoargv) < 0){
    163e:	fc040593          	addi	a1,s0,-64
    1642:	00005517          	auipc	a0,0x5
    1646:	9f650513          	addi	a0,a0,-1546 # 6038 <malloc+0x502>
    164a:	00004097          	auipc	ra,0x4
    164e:	0e4080e7          	jalr	228(ra) # 572e <exec>
    1652:	02054163          	bltz	a0,1674 <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1656:	fdc40513          	addi	a0,s0,-36
    165a:	00004097          	auipc	ra,0x4
    165e:	0a4080e7          	jalr	164(ra) # 56fe <wait>
    1662:	02951763          	bne	a0,s1,1690 <exectest+0x118>
  if(xstatus != 0)
    1666:	fdc42503          	lw	a0,-36(s0)
    166a:	cd0d                	beqz	a0,16a4 <exectest+0x12c>
    exit(xstatus);
    166c:	00004097          	auipc	ra,0x4
    1670:	08a080e7          	jalr	138(ra) # 56f6 <exit>
      printf("%s: exec echo failed\n", s);
    1674:	85ca                	mv	a1,s2
    1676:	00005517          	auipc	a0,0x5
    167a:	2da50513          	addi	a0,a0,730 # 6950 <malloc+0xe1a>
    167e:	00004097          	auipc	ra,0x4
    1682:	3f8080e7          	jalr	1016(ra) # 5a76 <printf>
      exit(1);
    1686:	4505                	li	a0,1
    1688:	00004097          	auipc	ra,0x4
    168c:	06e080e7          	jalr	110(ra) # 56f6 <exit>
    printf("%s: wait failed!\n", s);
    1690:	85ca                	mv	a1,s2
    1692:	00005517          	auipc	a0,0x5
    1696:	2d650513          	addi	a0,a0,726 # 6968 <malloc+0xe32>
    169a:	00004097          	auipc	ra,0x4
    169e:	3dc080e7          	jalr	988(ra) # 5a76 <printf>
    16a2:	b7d1                	j	1666 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    16a4:	4581                	li	a1,0
    16a6:	00005517          	auipc	a0,0x5
    16aa:	27a50513          	addi	a0,a0,634 # 6920 <malloc+0xdea>
    16ae:	00004097          	auipc	ra,0x4
    16b2:	088080e7          	jalr	136(ra) # 5736 <open>
  if(fd < 0) {
    16b6:	02054a63          	bltz	a0,16ea <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    16ba:	4609                	li	a2,2
    16bc:	fb840593          	addi	a1,s0,-72
    16c0:	00004097          	auipc	ra,0x4
    16c4:	04e080e7          	jalr	78(ra) # 570e <read>
    16c8:	4789                	li	a5,2
    16ca:	02f50e63          	beq	a0,a5,1706 <exectest+0x18e>
    printf("%s: read failed\n", s);
    16ce:	85ca                	mv	a1,s2
    16d0:	00005517          	auipc	a0,0x5
    16d4:	d0850513          	addi	a0,a0,-760 # 63d8 <malloc+0x8a2>
    16d8:	00004097          	auipc	ra,0x4
    16dc:	39e080e7          	jalr	926(ra) # 5a76 <printf>
    exit(1);
    16e0:	4505                	li	a0,1
    16e2:	00004097          	auipc	ra,0x4
    16e6:	014080e7          	jalr	20(ra) # 56f6 <exit>
    printf("%s: open failed\n", s);
    16ea:	85ca                	mv	a1,s2
    16ec:	00005517          	auipc	a0,0x5
    16f0:	1bc50513          	addi	a0,a0,444 # 68a8 <malloc+0xd72>
    16f4:	00004097          	auipc	ra,0x4
    16f8:	382080e7          	jalr	898(ra) # 5a76 <printf>
    exit(1);
    16fc:	4505                	li	a0,1
    16fe:	00004097          	auipc	ra,0x4
    1702:	ff8080e7          	jalr	-8(ra) # 56f6 <exit>
  unlink("echo-ok");
    1706:	00005517          	auipc	a0,0x5
    170a:	21a50513          	addi	a0,a0,538 # 6920 <malloc+0xdea>
    170e:	00004097          	auipc	ra,0x4
    1712:	038080e7          	jalr	56(ra) # 5746 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1716:	fb844703          	lbu	a4,-72(s0)
    171a:	04f00793          	li	a5,79
    171e:	00f71863          	bne	a4,a5,172e <exectest+0x1b6>
    1722:	fb944703          	lbu	a4,-71(s0)
    1726:	04b00793          	li	a5,75
    172a:	02f70063          	beq	a4,a5,174a <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    172e:	85ca                	mv	a1,s2
    1730:	00005517          	auipc	a0,0x5
    1734:	25050513          	addi	a0,a0,592 # 6980 <malloc+0xe4a>
    1738:	00004097          	auipc	ra,0x4
    173c:	33e080e7          	jalr	830(ra) # 5a76 <printf>
    exit(1);
    1740:	4505                	li	a0,1
    1742:	00004097          	auipc	ra,0x4
    1746:	fb4080e7          	jalr	-76(ra) # 56f6 <exit>
    exit(0);
    174a:	4501                	li	a0,0
    174c:	00004097          	auipc	ra,0x4
    1750:	faa080e7          	jalr	-86(ra) # 56f6 <exit>

0000000000001754 <pipe1>:
{
    1754:	715d                	addi	sp,sp,-80
    1756:	e486                	sd	ra,72(sp)
    1758:	e0a2                	sd	s0,64(sp)
    175a:	fc26                	sd	s1,56(sp)
    175c:	f84a                	sd	s2,48(sp)
    175e:	f44e                	sd	s3,40(sp)
    1760:	f052                	sd	s4,32(sp)
    1762:	ec56                	sd	s5,24(sp)
    1764:	e85a                	sd	s6,16(sp)
    1766:	0880                	addi	s0,sp,80
    1768:	89aa                	mv	s3,a0
  if(pipe(fds) != 0){
    176a:	fb840513          	addi	a0,s0,-72
    176e:	00004097          	auipc	ra,0x4
    1772:	f98080e7          	jalr	-104(ra) # 5706 <pipe>
    1776:	e935                	bnez	a0,17ea <pipe1+0x96>
    1778:	84aa                	mv	s1,a0
  pid = fork();
    177a:	00004097          	auipc	ra,0x4
    177e:	f74080e7          	jalr	-140(ra) # 56ee <fork>
  if(pid == 0){
    1782:	c151                	beqz	a0,1806 <pipe1+0xb2>
  } else if(pid > 0){
    1784:	18a05963          	blez	a0,1916 <pipe1+0x1c2>
    close(fds[1]);
    1788:	fbc42503          	lw	a0,-68(s0)
    178c:	00004097          	auipc	ra,0x4
    1790:	f92080e7          	jalr	-110(ra) # 571e <close>
    total = 0;
    1794:	8aa6                	mv	s5,s1
    cc = 1;
    1796:	4a05                	li	s4,1
    while((n = read(fds[0], buf, cc)) > 0){
    1798:	0000a917          	auipc	s2,0xa
    179c:	43890913          	addi	s2,s2,1080 # bbd0 <buf>
      if(cc > sizeof(buf))
    17a0:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    17a2:	8652                	mv	a2,s4
    17a4:	85ca                	mv	a1,s2
    17a6:	fb842503          	lw	a0,-72(s0)
    17aa:	00004097          	auipc	ra,0x4
    17ae:	f64080e7          	jalr	-156(ra) # 570e <read>
    17b2:	10a05d63          	blez	a0,18cc <pipe1+0x178>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17b6:	0014879b          	addiw	a5,s1,1
    17ba:	00094683          	lbu	a3,0(s2)
    17be:	0ff4f713          	andi	a4,s1,255
    17c2:	0ce69863          	bne	a3,a4,1892 <pipe1+0x13e>
    17c6:	0000a717          	auipc	a4,0xa
    17ca:	40b70713          	addi	a4,a4,1035 # bbd1 <buf+0x1>
    17ce:	9ca9                	addw	s1,s1,a0
      for(i = 0; i < n; i++){
    17d0:	0e978463          	beq	a5,s1,18b8 <pipe1+0x164>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17d4:	00074683          	lbu	a3,0(a4)
    17d8:	0017861b          	addiw	a2,a5,1
    17dc:	0705                	addi	a4,a4,1
    17de:	0ff7f793          	andi	a5,a5,255
    17e2:	0af69863          	bne	a3,a5,1892 <pipe1+0x13e>
    17e6:	87b2                	mv	a5,a2
    17e8:	b7e5                	j	17d0 <pipe1+0x7c>
    printf("%s: pipe() failed\n", s);
    17ea:	85ce                	mv	a1,s3
    17ec:	00005517          	auipc	a0,0x5
    17f0:	1ac50513          	addi	a0,a0,428 # 6998 <malloc+0xe62>
    17f4:	00004097          	auipc	ra,0x4
    17f8:	282080e7          	jalr	642(ra) # 5a76 <printf>
    exit(1);
    17fc:	4505                	li	a0,1
    17fe:	00004097          	auipc	ra,0x4
    1802:	ef8080e7          	jalr	-264(ra) # 56f6 <exit>
    close(fds[0]);
    1806:	fb842503          	lw	a0,-72(s0)
    180a:	00004097          	auipc	ra,0x4
    180e:	f14080e7          	jalr	-236(ra) # 571e <close>
    for(n = 0; n < N; n++){
    1812:	0000aa97          	auipc	s5,0xa
    1816:	3bea8a93          	addi	s5,s5,958 # bbd0 <buf>
    181a:	0ffaf793          	andi	a5,s5,255
    181e:	40f004b3          	neg	s1,a5
    1822:	0ff4f493          	andi	s1,s1,255
    1826:	02d00a13          	li	s4,45
    182a:	40fa0a3b          	subw	s4,s4,a5
    182e:	0ffa7a13          	andi	s4,s4,255
    1832:	409a8913          	addi	s2,s5,1033
      if(write(fds[1], buf, SZ) != SZ){
    1836:	8b56                	mv	s6,s5
{
    1838:	87d6                	mv	a5,s5
        buf[i] = seq++;
    183a:	0097873b          	addw	a4,a5,s1
    183e:	00e78023          	sb	a4,0(a5)
    1842:	0785                	addi	a5,a5,1
      for(i = 0; i < SZ; i++)
    1844:	fef91be3          	bne	s2,a5,183a <pipe1+0xe6>
      if(write(fds[1], buf, SZ) != SZ){
    1848:	40900613          	li	a2,1033
    184c:	85da                	mv	a1,s6
    184e:	fbc42503          	lw	a0,-68(s0)
    1852:	00004097          	auipc	ra,0x4
    1856:	ec4080e7          	jalr	-316(ra) # 5716 <write>
    185a:	40900793          	li	a5,1033
    185e:	00f51c63          	bne	a0,a5,1876 <pipe1+0x122>
    1862:	24a5                	addiw	s1,s1,9
    1864:	0ff4f493          	andi	s1,s1,255
    for(n = 0; n < N; n++){
    1868:	fd4498e3          	bne	s1,s4,1838 <pipe1+0xe4>
    exit(0);
    186c:	4501                	li	a0,0
    186e:	00004097          	auipc	ra,0x4
    1872:	e88080e7          	jalr	-376(ra) # 56f6 <exit>
        printf("%s: pipe1 oops 1\n", s);
    1876:	85ce                	mv	a1,s3
    1878:	00005517          	auipc	a0,0x5
    187c:	13850513          	addi	a0,a0,312 # 69b0 <malloc+0xe7a>
    1880:	00004097          	auipc	ra,0x4
    1884:	1f6080e7          	jalr	502(ra) # 5a76 <printf>
        exit(1);
    1888:	4505                	li	a0,1
    188a:	00004097          	auipc	ra,0x4
    188e:	e6c080e7          	jalr	-404(ra) # 56f6 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1892:	85ce                	mv	a1,s3
    1894:	00005517          	auipc	a0,0x5
    1898:	13450513          	addi	a0,a0,308 # 69c8 <malloc+0xe92>
    189c:	00004097          	auipc	ra,0x4
    18a0:	1da080e7          	jalr	474(ra) # 5a76 <printf>
}
    18a4:	60a6                	ld	ra,72(sp)
    18a6:	6406                	ld	s0,64(sp)
    18a8:	74e2                	ld	s1,56(sp)
    18aa:	7942                	ld	s2,48(sp)
    18ac:	79a2                	ld	s3,40(sp)
    18ae:	7a02                	ld	s4,32(sp)
    18b0:	6ae2                	ld	s5,24(sp)
    18b2:	6b42                	ld	s6,16(sp)
    18b4:	6161                	addi	sp,sp,80
    18b6:	8082                	ret
      total += n;
    18b8:	00aa8abb          	addw	s5,s5,a0
      cc = cc * 2;
    18bc:	001a179b          	slliw	a5,s4,0x1
    18c0:	00078a1b          	sext.w	s4,a5
      if(cc > sizeof(buf))
    18c4:	ed4b7fe3          	bleu	s4,s6,17a2 <pipe1+0x4e>
        cc = sizeof(buf);
    18c8:	8a5a                	mv	s4,s6
    18ca:	bde1                	j	17a2 <pipe1+0x4e>
    if(total != N * SZ){
    18cc:	6785                	lui	a5,0x1
    18ce:	42d78793          	addi	a5,a5,1069 # 142d <truncate3+0x6f>
    18d2:	02fa8063          	beq	s5,a5,18f2 <pipe1+0x19e>
      printf("%s: pipe1 oops 3 total %d\n", total);
    18d6:	85d6                	mv	a1,s5
    18d8:	00005517          	auipc	a0,0x5
    18dc:	10850513          	addi	a0,a0,264 # 69e0 <malloc+0xeaa>
    18e0:	00004097          	auipc	ra,0x4
    18e4:	196080e7          	jalr	406(ra) # 5a76 <printf>
      exit(1);
    18e8:	4505                	li	a0,1
    18ea:	00004097          	auipc	ra,0x4
    18ee:	e0c080e7          	jalr	-500(ra) # 56f6 <exit>
    close(fds[0]);
    18f2:	fb842503          	lw	a0,-72(s0)
    18f6:	00004097          	auipc	ra,0x4
    18fa:	e28080e7          	jalr	-472(ra) # 571e <close>
    wait(&xstatus);
    18fe:	fb440513          	addi	a0,s0,-76
    1902:	00004097          	auipc	ra,0x4
    1906:	dfc080e7          	jalr	-516(ra) # 56fe <wait>
    exit(xstatus);
    190a:	fb442503          	lw	a0,-76(s0)
    190e:	00004097          	auipc	ra,0x4
    1912:	de8080e7          	jalr	-536(ra) # 56f6 <exit>
    printf("%s: fork() failed\n", s);
    1916:	85ce                	mv	a1,s3
    1918:	00005517          	auipc	a0,0x5
    191c:	0e850513          	addi	a0,a0,232 # 6a00 <malloc+0xeca>
    1920:	00004097          	auipc	ra,0x4
    1924:	156080e7          	jalr	342(ra) # 5a76 <printf>
    exit(1);
    1928:	4505                	li	a0,1
    192a:	00004097          	auipc	ra,0x4
    192e:	dcc080e7          	jalr	-564(ra) # 56f6 <exit>

0000000000001932 <exitwait>:
{
    1932:	7139                	addi	sp,sp,-64
    1934:	fc06                	sd	ra,56(sp)
    1936:	f822                	sd	s0,48(sp)
    1938:	f426                	sd	s1,40(sp)
    193a:	f04a                	sd	s2,32(sp)
    193c:	ec4e                	sd	s3,24(sp)
    193e:	e852                	sd	s4,16(sp)
    1940:	0080                	addi	s0,sp,64
    1942:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1944:	4481                	li	s1,0
    1946:	06400993          	li	s3,100
    pid = fork();
    194a:	00004097          	auipc	ra,0x4
    194e:	da4080e7          	jalr	-604(ra) # 56ee <fork>
    1952:	892a                	mv	s2,a0
    if(pid < 0){
    1954:	02054a63          	bltz	a0,1988 <exitwait+0x56>
    if(pid){
    1958:	c151                	beqz	a0,19dc <exitwait+0xaa>
      if(wait(&xstate) != pid){
    195a:	fcc40513          	addi	a0,s0,-52
    195e:	00004097          	auipc	ra,0x4
    1962:	da0080e7          	jalr	-608(ra) # 56fe <wait>
    1966:	03251f63          	bne	a0,s2,19a4 <exitwait+0x72>
      if(i != xstate) {
    196a:	fcc42783          	lw	a5,-52(s0)
    196e:	04979963          	bne	a5,s1,19c0 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1972:	2485                	addiw	s1,s1,1
    1974:	fd349be3          	bne	s1,s3,194a <exitwait+0x18>
}
    1978:	70e2                	ld	ra,56(sp)
    197a:	7442                	ld	s0,48(sp)
    197c:	74a2                	ld	s1,40(sp)
    197e:	7902                	ld	s2,32(sp)
    1980:	69e2                	ld	s3,24(sp)
    1982:	6a42                	ld	s4,16(sp)
    1984:	6121                	addi	sp,sp,64
    1986:	8082                	ret
      printf("%s: fork failed\n", s);
    1988:	85d2                	mv	a1,s4
    198a:	00005517          	auipc	a0,0x5
    198e:	f0650513          	addi	a0,a0,-250 # 6890 <malloc+0xd5a>
    1992:	00004097          	auipc	ra,0x4
    1996:	0e4080e7          	jalr	228(ra) # 5a76 <printf>
      exit(1);
    199a:	4505                	li	a0,1
    199c:	00004097          	auipc	ra,0x4
    19a0:	d5a080e7          	jalr	-678(ra) # 56f6 <exit>
        printf("%s: wait wrong pid\n", s);
    19a4:	85d2                	mv	a1,s4
    19a6:	00005517          	auipc	a0,0x5
    19aa:	07250513          	addi	a0,a0,114 # 6a18 <malloc+0xee2>
    19ae:	00004097          	auipc	ra,0x4
    19b2:	0c8080e7          	jalr	200(ra) # 5a76 <printf>
        exit(1);
    19b6:	4505                	li	a0,1
    19b8:	00004097          	auipc	ra,0x4
    19bc:	d3e080e7          	jalr	-706(ra) # 56f6 <exit>
        printf("%s: wait wrong exit status\n", s);
    19c0:	85d2                	mv	a1,s4
    19c2:	00005517          	auipc	a0,0x5
    19c6:	06e50513          	addi	a0,a0,110 # 6a30 <malloc+0xefa>
    19ca:	00004097          	auipc	ra,0x4
    19ce:	0ac080e7          	jalr	172(ra) # 5a76 <printf>
        exit(1);
    19d2:	4505                	li	a0,1
    19d4:	00004097          	auipc	ra,0x4
    19d8:	d22080e7          	jalr	-734(ra) # 56f6 <exit>
      exit(i);
    19dc:	8526                	mv	a0,s1
    19de:	00004097          	auipc	ra,0x4
    19e2:	d18080e7          	jalr	-744(ra) # 56f6 <exit>

00000000000019e6 <twochildren>:
{
    19e6:	1101                	addi	sp,sp,-32
    19e8:	ec06                	sd	ra,24(sp)
    19ea:	e822                	sd	s0,16(sp)
    19ec:	e426                	sd	s1,8(sp)
    19ee:	e04a                	sd	s2,0(sp)
    19f0:	1000                	addi	s0,sp,32
    19f2:	892a                	mv	s2,a0
    19f4:	3e800493          	li	s1,1000
    int pid1 = fork();
    19f8:	00004097          	auipc	ra,0x4
    19fc:	cf6080e7          	jalr	-778(ra) # 56ee <fork>
    if(pid1 < 0){
    1a00:	02054c63          	bltz	a0,1a38 <twochildren+0x52>
    if(pid1 == 0){
    1a04:	c921                	beqz	a0,1a54 <twochildren+0x6e>
      int pid2 = fork();
    1a06:	00004097          	auipc	ra,0x4
    1a0a:	ce8080e7          	jalr	-792(ra) # 56ee <fork>
      if(pid2 < 0){
    1a0e:	04054763          	bltz	a0,1a5c <twochildren+0x76>
      if(pid2 == 0){
    1a12:	c13d                	beqz	a0,1a78 <twochildren+0x92>
        wait(0);
    1a14:	4501                	li	a0,0
    1a16:	00004097          	auipc	ra,0x4
    1a1a:	ce8080e7          	jalr	-792(ra) # 56fe <wait>
        wait(0);
    1a1e:	4501                	li	a0,0
    1a20:	00004097          	auipc	ra,0x4
    1a24:	cde080e7          	jalr	-802(ra) # 56fe <wait>
    1a28:	34fd                	addiw	s1,s1,-1
  for(int i = 0; i < 1000; i++){
    1a2a:	f4f9                	bnez	s1,19f8 <twochildren+0x12>
}
    1a2c:	60e2                	ld	ra,24(sp)
    1a2e:	6442                	ld	s0,16(sp)
    1a30:	64a2                	ld	s1,8(sp)
    1a32:	6902                	ld	s2,0(sp)
    1a34:	6105                	addi	sp,sp,32
    1a36:	8082                	ret
      printf("%s: fork failed\n", s);
    1a38:	85ca                	mv	a1,s2
    1a3a:	00005517          	auipc	a0,0x5
    1a3e:	e5650513          	addi	a0,a0,-426 # 6890 <malloc+0xd5a>
    1a42:	00004097          	auipc	ra,0x4
    1a46:	034080e7          	jalr	52(ra) # 5a76 <printf>
      exit(1);
    1a4a:	4505                	li	a0,1
    1a4c:	00004097          	auipc	ra,0x4
    1a50:	caa080e7          	jalr	-854(ra) # 56f6 <exit>
      exit(0);
    1a54:	00004097          	auipc	ra,0x4
    1a58:	ca2080e7          	jalr	-862(ra) # 56f6 <exit>
        printf("%s: fork failed\n", s);
    1a5c:	85ca                	mv	a1,s2
    1a5e:	00005517          	auipc	a0,0x5
    1a62:	e3250513          	addi	a0,a0,-462 # 6890 <malloc+0xd5a>
    1a66:	00004097          	auipc	ra,0x4
    1a6a:	010080e7          	jalr	16(ra) # 5a76 <printf>
        exit(1);
    1a6e:	4505                	li	a0,1
    1a70:	00004097          	auipc	ra,0x4
    1a74:	c86080e7          	jalr	-890(ra) # 56f6 <exit>
        exit(0);
    1a78:	00004097          	auipc	ra,0x4
    1a7c:	c7e080e7          	jalr	-898(ra) # 56f6 <exit>

0000000000001a80 <forkfork>:
{
    1a80:	7179                	addi	sp,sp,-48
    1a82:	f406                	sd	ra,40(sp)
    1a84:	f022                	sd	s0,32(sp)
    1a86:	ec26                	sd	s1,24(sp)
    1a88:	1800                	addi	s0,sp,48
    1a8a:	84aa                	mv	s1,a0
    int pid = fork();
    1a8c:	00004097          	auipc	ra,0x4
    1a90:	c62080e7          	jalr	-926(ra) # 56ee <fork>
    if(pid < 0){
    1a94:	04054163          	bltz	a0,1ad6 <forkfork+0x56>
    if(pid == 0){
    1a98:	cd29                	beqz	a0,1af2 <forkfork+0x72>
    int pid = fork();
    1a9a:	00004097          	auipc	ra,0x4
    1a9e:	c54080e7          	jalr	-940(ra) # 56ee <fork>
    if(pid < 0){
    1aa2:	02054a63          	bltz	a0,1ad6 <forkfork+0x56>
    if(pid == 0){
    1aa6:	c531                	beqz	a0,1af2 <forkfork+0x72>
    wait(&xstatus);
    1aa8:	fdc40513          	addi	a0,s0,-36
    1aac:	00004097          	auipc	ra,0x4
    1ab0:	c52080e7          	jalr	-942(ra) # 56fe <wait>
    if(xstatus != 0) {
    1ab4:	fdc42783          	lw	a5,-36(s0)
    1ab8:	ebbd                	bnez	a5,1b2e <forkfork+0xae>
    wait(&xstatus);
    1aba:	fdc40513          	addi	a0,s0,-36
    1abe:	00004097          	auipc	ra,0x4
    1ac2:	c40080e7          	jalr	-960(ra) # 56fe <wait>
    if(xstatus != 0) {
    1ac6:	fdc42783          	lw	a5,-36(s0)
    1aca:	e3b5                	bnez	a5,1b2e <forkfork+0xae>
}
    1acc:	70a2                	ld	ra,40(sp)
    1ace:	7402                	ld	s0,32(sp)
    1ad0:	64e2                	ld	s1,24(sp)
    1ad2:	6145                	addi	sp,sp,48
    1ad4:	8082                	ret
      printf("%s: fork failed", s);
    1ad6:	85a6                	mv	a1,s1
    1ad8:	00005517          	auipc	a0,0x5
    1adc:	f7850513          	addi	a0,a0,-136 # 6a50 <malloc+0xf1a>
    1ae0:	00004097          	auipc	ra,0x4
    1ae4:	f96080e7          	jalr	-106(ra) # 5a76 <printf>
      exit(1);
    1ae8:	4505                	li	a0,1
    1aea:	00004097          	auipc	ra,0x4
    1aee:	c0c080e7          	jalr	-1012(ra) # 56f6 <exit>
{
    1af2:	0c800493          	li	s1,200
        int pid1 = fork();
    1af6:	00004097          	auipc	ra,0x4
    1afa:	bf8080e7          	jalr	-1032(ra) # 56ee <fork>
        if(pid1 < 0){
    1afe:	00054f63          	bltz	a0,1b1c <forkfork+0x9c>
        if(pid1 == 0){
    1b02:	c115                	beqz	a0,1b26 <forkfork+0xa6>
        wait(0);
    1b04:	4501                	li	a0,0
    1b06:	00004097          	auipc	ra,0x4
    1b0a:	bf8080e7          	jalr	-1032(ra) # 56fe <wait>
    1b0e:	34fd                	addiw	s1,s1,-1
      for(int j = 0; j < 200; j++){
    1b10:	f0fd                	bnez	s1,1af6 <forkfork+0x76>
      exit(0);
    1b12:	4501                	li	a0,0
    1b14:	00004097          	auipc	ra,0x4
    1b18:	be2080e7          	jalr	-1054(ra) # 56f6 <exit>
          exit(1);
    1b1c:	4505                	li	a0,1
    1b1e:	00004097          	auipc	ra,0x4
    1b22:	bd8080e7          	jalr	-1064(ra) # 56f6 <exit>
          exit(0);
    1b26:	00004097          	auipc	ra,0x4
    1b2a:	bd0080e7          	jalr	-1072(ra) # 56f6 <exit>
      printf("%s: fork in child failed", s);
    1b2e:	85a6                	mv	a1,s1
    1b30:	00005517          	auipc	a0,0x5
    1b34:	f3050513          	addi	a0,a0,-208 # 6a60 <malloc+0xf2a>
    1b38:	00004097          	auipc	ra,0x4
    1b3c:	f3e080e7          	jalr	-194(ra) # 5a76 <printf>
      exit(1);
    1b40:	4505                	li	a0,1
    1b42:	00004097          	auipc	ra,0x4
    1b46:	bb4080e7          	jalr	-1100(ra) # 56f6 <exit>

0000000000001b4a <reparent2>:
{
    1b4a:	1101                	addi	sp,sp,-32
    1b4c:	ec06                	sd	ra,24(sp)
    1b4e:	e822                	sd	s0,16(sp)
    1b50:	e426                	sd	s1,8(sp)
    1b52:	1000                	addi	s0,sp,32
    1b54:	32000493          	li	s1,800
    int pid1 = fork();
    1b58:	00004097          	auipc	ra,0x4
    1b5c:	b96080e7          	jalr	-1130(ra) # 56ee <fork>
    if(pid1 < 0){
    1b60:	00054f63          	bltz	a0,1b7e <reparent2+0x34>
    if(pid1 == 0){
    1b64:	c915                	beqz	a0,1b98 <reparent2+0x4e>
    wait(0);
    1b66:	4501                	li	a0,0
    1b68:	00004097          	auipc	ra,0x4
    1b6c:	b96080e7          	jalr	-1130(ra) # 56fe <wait>
    1b70:	34fd                	addiw	s1,s1,-1
  for(int i = 0; i < 800; i++){
    1b72:	f0fd                	bnez	s1,1b58 <reparent2+0xe>
  exit(0);
    1b74:	4501                	li	a0,0
    1b76:	00004097          	auipc	ra,0x4
    1b7a:	b80080e7          	jalr	-1152(ra) # 56f6 <exit>
      printf("fork failed\n");
    1b7e:	00005517          	auipc	a0,0x5
    1b82:	11a50513          	addi	a0,a0,282 # 6c98 <malloc+0x1162>
    1b86:	00004097          	auipc	ra,0x4
    1b8a:	ef0080e7          	jalr	-272(ra) # 5a76 <printf>
      exit(1);
    1b8e:	4505                	li	a0,1
    1b90:	00004097          	auipc	ra,0x4
    1b94:	b66080e7          	jalr	-1178(ra) # 56f6 <exit>
      fork();
    1b98:	00004097          	auipc	ra,0x4
    1b9c:	b56080e7          	jalr	-1194(ra) # 56ee <fork>
      fork();
    1ba0:	00004097          	auipc	ra,0x4
    1ba4:	b4e080e7          	jalr	-1202(ra) # 56ee <fork>
      exit(0);
    1ba8:	4501                	li	a0,0
    1baa:	00004097          	auipc	ra,0x4
    1bae:	b4c080e7          	jalr	-1204(ra) # 56f6 <exit>

0000000000001bb2 <createdelete>:
{
    1bb2:	7175                	addi	sp,sp,-144
    1bb4:	e506                	sd	ra,136(sp)
    1bb6:	e122                	sd	s0,128(sp)
    1bb8:	fca6                	sd	s1,120(sp)
    1bba:	f8ca                	sd	s2,112(sp)
    1bbc:	f4ce                	sd	s3,104(sp)
    1bbe:	f0d2                	sd	s4,96(sp)
    1bc0:	ecd6                	sd	s5,88(sp)
    1bc2:	e8da                	sd	s6,80(sp)
    1bc4:	e4de                	sd	s7,72(sp)
    1bc6:	e0e2                	sd	s8,64(sp)
    1bc8:	fc66                	sd	s9,56(sp)
    1bca:	0900                	addi	s0,sp,144
    1bcc:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1bce:	4901                	li	s2,0
    1bd0:	4991                	li	s3,4
    pid = fork();
    1bd2:	00004097          	auipc	ra,0x4
    1bd6:	b1c080e7          	jalr	-1252(ra) # 56ee <fork>
    1bda:	84aa                	mv	s1,a0
    if(pid < 0){
    1bdc:	02054f63          	bltz	a0,1c1a <createdelete+0x68>
    if(pid == 0){
    1be0:	c939                	beqz	a0,1c36 <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1be2:	2905                	addiw	s2,s2,1
    1be4:	ff3917e3          	bne	s2,s3,1bd2 <createdelete+0x20>
    1be8:	4491                	li	s1,4
    wait(&xstatus);
    1bea:	f7c40513          	addi	a0,s0,-132
    1bee:	00004097          	auipc	ra,0x4
    1bf2:	b10080e7          	jalr	-1264(ra) # 56fe <wait>
    if(xstatus != 0)
    1bf6:	f7c42903          	lw	s2,-132(s0)
    1bfa:	0e091263          	bnez	s2,1cde <createdelete+0x12c>
    1bfe:	34fd                	addiw	s1,s1,-1
  for(pi = 0; pi < NCHILD; pi++){
    1c00:	f4ed                	bnez	s1,1bea <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1c02:	f8040123          	sb	zero,-126(s0)
    1c06:	03000993          	li	s3,48
    1c0a:	5a7d                	li	s4,-1
    1c0c:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1c10:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1c12:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1c14:	07400a93          	li	s5,116
    1c18:	a29d                	j	1d7e <createdelete+0x1cc>
      printf("fork failed\n", s);
    1c1a:	85e6                	mv	a1,s9
    1c1c:	00005517          	auipc	a0,0x5
    1c20:	07c50513          	addi	a0,a0,124 # 6c98 <malloc+0x1162>
    1c24:	00004097          	auipc	ra,0x4
    1c28:	e52080e7          	jalr	-430(ra) # 5a76 <printf>
      exit(1);
    1c2c:	4505                	li	a0,1
    1c2e:	00004097          	auipc	ra,0x4
    1c32:	ac8080e7          	jalr	-1336(ra) # 56f6 <exit>
      name[0] = 'p' + pi;
    1c36:	0709091b          	addiw	s2,s2,112
    1c3a:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1c3e:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1c42:	4951                	li	s2,20
    1c44:	a015                	j	1c68 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1c46:	85e6                	mv	a1,s9
    1c48:	00005517          	auipc	a0,0x5
    1c4c:	ce050513          	addi	a0,a0,-800 # 6928 <malloc+0xdf2>
    1c50:	00004097          	auipc	ra,0x4
    1c54:	e26080e7          	jalr	-474(ra) # 5a76 <printf>
          exit(1);
    1c58:	4505                	li	a0,1
    1c5a:	00004097          	auipc	ra,0x4
    1c5e:	a9c080e7          	jalr	-1380(ra) # 56f6 <exit>
      for(i = 0; i < N; i++){
    1c62:	2485                	addiw	s1,s1,1
    1c64:	07248863          	beq	s1,s2,1cd4 <createdelete+0x122>
        name[1] = '0' + i;
    1c68:	0304879b          	addiw	a5,s1,48
    1c6c:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1c70:	20200593          	li	a1,514
    1c74:	f8040513          	addi	a0,s0,-128
    1c78:	00004097          	auipc	ra,0x4
    1c7c:	abe080e7          	jalr	-1346(ra) # 5736 <open>
        if(fd < 0){
    1c80:	fc0543e3          	bltz	a0,1c46 <createdelete+0x94>
        close(fd);
    1c84:	00004097          	auipc	ra,0x4
    1c88:	a9a080e7          	jalr	-1382(ra) # 571e <close>
        if(i > 0 && (i % 2 ) == 0){
    1c8c:	fc905be3          	blez	s1,1c62 <createdelete+0xb0>
    1c90:	0014f793          	andi	a5,s1,1
    1c94:	f7f9                	bnez	a5,1c62 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1c96:	01f4d79b          	srliw	a5,s1,0x1f
    1c9a:	9fa5                	addw	a5,a5,s1
    1c9c:	4017d79b          	sraiw	a5,a5,0x1
    1ca0:	0307879b          	addiw	a5,a5,48
    1ca4:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1ca8:	f8040513          	addi	a0,s0,-128
    1cac:	00004097          	auipc	ra,0x4
    1cb0:	a9a080e7          	jalr	-1382(ra) # 5746 <unlink>
    1cb4:	fa0557e3          	bgez	a0,1c62 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1cb8:	85e6                	mv	a1,s9
    1cba:	00005517          	auipc	a0,0x5
    1cbe:	dc650513          	addi	a0,a0,-570 # 6a80 <malloc+0xf4a>
    1cc2:	00004097          	auipc	ra,0x4
    1cc6:	db4080e7          	jalr	-588(ra) # 5a76 <printf>
            exit(1);
    1cca:	4505                	li	a0,1
    1ccc:	00004097          	auipc	ra,0x4
    1cd0:	a2a080e7          	jalr	-1494(ra) # 56f6 <exit>
      exit(0);
    1cd4:	4501                	li	a0,0
    1cd6:	00004097          	auipc	ra,0x4
    1cda:	a20080e7          	jalr	-1504(ra) # 56f6 <exit>
      exit(1);
    1cde:	4505                	li	a0,1
    1ce0:	00004097          	auipc	ra,0x4
    1ce4:	a16080e7          	jalr	-1514(ra) # 56f6 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1ce8:	f8040613          	addi	a2,s0,-128
    1cec:	85e6                	mv	a1,s9
    1cee:	00005517          	auipc	a0,0x5
    1cf2:	daa50513          	addi	a0,a0,-598 # 6a98 <malloc+0xf62>
    1cf6:	00004097          	auipc	ra,0x4
    1cfa:	d80080e7          	jalr	-640(ra) # 5a76 <printf>
        exit(1);
    1cfe:	4505                	li	a0,1
    1d00:	00004097          	auipc	ra,0x4
    1d04:	9f6080e7          	jalr	-1546(ra) # 56f6 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d08:	054b7163          	bleu	s4,s6,1d4a <createdelete+0x198>
      if(fd >= 0)
    1d0c:	02055a63          	bgez	a0,1d40 <createdelete+0x18e>
    1d10:	2485                	addiw	s1,s1,1
    1d12:	0ff4f493          	andi	s1,s1,255
    for(pi = 0; pi < NCHILD; pi++){
    1d16:	05548c63          	beq	s1,s5,1d6e <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1d1a:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1d1e:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1d22:	4581                	li	a1,0
    1d24:	f8040513          	addi	a0,s0,-128
    1d28:	00004097          	auipc	ra,0x4
    1d2c:	a0e080e7          	jalr	-1522(ra) # 5736 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1d30:	00090463          	beqz	s2,1d38 <createdelete+0x186>
    1d34:	fd2bdae3          	ble	s2,s7,1d08 <createdelete+0x156>
    1d38:	fa0548e3          	bltz	a0,1ce8 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d3c:	014b7963          	bleu	s4,s6,1d4e <createdelete+0x19c>
        close(fd);
    1d40:	00004097          	auipc	ra,0x4
    1d44:	9de080e7          	jalr	-1570(ra) # 571e <close>
    1d48:	b7e1                	j	1d10 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d4a:	fc0543e3          	bltz	a0,1d10 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1d4e:	f8040613          	addi	a2,s0,-128
    1d52:	85e6                	mv	a1,s9
    1d54:	00005517          	auipc	a0,0x5
    1d58:	d6c50513          	addi	a0,a0,-660 # 6ac0 <malloc+0xf8a>
    1d5c:	00004097          	auipc	ra,0x4
    1d60:	d1a080e7          	jalr	-742(ra) # 5a76 <printf>
        exit(1);
    1d64:	4505                	li	a0,1
    1d66:	00004097          	auipc	ra,0x4
    1d6a:	990080e7          	jalr	-1648(ra) # 56f6 <exit>
  for(i = 0; i < N; i++){
    1d6e:	2905                	addiw	s2,s2,1
    1d70:	2a05                	addiw	s4,s4,1
    1d72:	2985                	addiw	s3,s3,1
    1d74:	0ff9f993          	andi	s3,s3,255
    1d78:	47d1                	li	a5,20
    1d7a:	02f90a63          	beq	s2,a5,1dae <createdelete+0x1fc>
    1d7e:	84e2                	mv	s1,s8
    1d80:	bf69                	j	1d1a <createdelete+0x168>
    1d82:	2905                	addiw	s2,s2,1
    1d84:	0ff97913          	andi	s2,s2,255
    1d88:	2985                	addiw	s3,s3,1
    1d8a:	0ff9f993          	andi	s3,s3,255
  for(i = 0; i < N; i++){
    1d8e:	03490863          	beq	s2,s4,1dbe <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1d92:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1d94:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1d98:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1d9c:	f8040513          	addi	a0,s0,-128
    1da0:	00004097          	auipc	ra,0x4
    1da4:	9a6080e7          	jalr	-1626(ra) # 5746 <unlink>
    1da8:	34fd                	addiw	s1,s1,-1
    for(pi = 0; pi < NCHILD; pi++){
    1daa:	f4ed                	bnez	s1,1d94 <createdelete+0x1e2>
    1dac:	bfd9                	j	1d82 <createdelete+0x1d0>
    1dae:	03000993          	li	s3,48
    1db2:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1db6:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1db8:	08400a13          	li	s4,132
    1dbc:	bfd9                	j	1d92 <createdelete+0x1e0>
}
    1dbe:	60aa                	ld	ra,136(sp)
    1dc0:	640a                	ld	s0,128(sp)
    1dc2:	74e6                	ld	s1,120(sp)
    1dc4:	7946                	ld	s2,112(sp)
    1dc6:	79a6                	ld	s3,104(sp)
    1dc8:	7a06                	ld	s4,96(sp)
    1dca:	6ae6                	ld	s5,88(sp)
    1dcc:	6b46                	ld	s6,80(sp)
    1dce:	6ba6                	ld	s7,72(sp)
    1dd0:	6c06                	ld	s8,64(sp)
    1dd2:	7ce2                	ld	s9,56(sp)
    1dd4:	6149                	addi	sp,sp,144
    1dd6:	8082                	ret

0000000000001dd8 <linkunlink>:
{
    1dd8:	711d                	addi	sp,sp,-96
    1dda:	ec86                	sd	ra,88(sp)
    1ddc:	e8a2                	sd	s0,80(sp)
    1dde:	e4a6                	sd	s1,72(sp)
    1de0:	e0ca                	sd	s2,64(sp)
    1de2:	fc4e                	sd	s3,56(sp)
    1de4:	f852                	sd	s4,48(sp)
    1de6:	f456                	sd	s5,40(sp)
    1de8:	f05a                	sd	s6,32(sp)
    1dea:	ec5e                	sd	s7,24(sp)
    1dec:	e862                	sd	s8,16(sp)
    1dee:	e466                	sd	s9,8(sp)
    1df0:	1080                	addi	s0,sp,96
    1df2:	84aa                	mv	s1,a0
  unlink("x");
    1df4:	00004517          	auipc	a0,0x4
    1df8:	2b450513          	addi	a0,a0,692 # 60a8 <malloc+0x572>
    1dfc:	00004097          	auipc	ra,0x4
    1e00:	94a080e7          	jalr	-1718(ra) # 5746 <unlink>
  pid = fork();
    1e04:	00004097          	auipc	ra,0x4
    1e08:	8ea080e7          	jalr	-1814(ra) # 56ee <fork>
  if(pid < 0){
    1e0c:	02054b63          	bltz	a0,1e42 <linkunlink+0x6a>
    1e10:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1e12:	4c85                	li	s9,1
    1e14:	e119                	bnez	a0,1e1a <linkunlink+0x42>
    1e16:	06100c93          	li	s9,97
    1e1a:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1e1e:	41c659b7          	lui	s3,0x41c65
    1e22:	e6d9899b          	addiw	s3,s3,-403
    1e26:	690d                	lui	s2,0x3
    1e28:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    1e2c:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1e2e:	4b05                	li	s6,1
      unlink("x");
    1e30:	00004a97          	auipc	s5,0x4
    1e34:	278a8a93          	addi	s5,s5,632 # 60a8 <malloc+0x572>
      link("cat", "x");
    1e38:	00005b97          	auipc	s7,0x5
    1e3c:	cb0b8b93          	addi	s7,s7,-848 # 6ae8 <malloc+0xfb2>
    1e40:	a091                	j	1e84 <linkunlink+0xac>
    printf("%s: fork failed\n", s);
    1e42:	85a6                	mv	a1,s1
    1e44:	00005517          	auipc	a0,0x5
    1e48:	a4c50513          	addi	a0,a0,-1460 # 6890 <malloc+0xd5a>
    1e4c:	00004097          	auipc	ra,0x4
    1e50:	c2a080e7          	jalr	-982(ra) # 5a76 <printf>
    exit(1);
    1e54:	4505                	li	a0,1
    1e56:	00004097          	auipc	ra,0x4
    1e5a:	8a0080e7          	jalr	-1888(ra) # 56f6 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e5e:	20200593          	li	a1,514
    1e62:	8556                	mv	a0,s5
    1e64:	00004097          	auipc	ra,0x4
    1e68:	8d2080e7          	jalr	-1838(ra) # 5736 <open>
    1e6c:	00004097          	auipc	ra,0x4
    1e70:	8b2080e7          	jalr	-1870(ra) # 571e <close>
    1e74:	a031                	j	1e80 <linkunlink+0xa8>
      unlink("x");
    1e76:	8556                	mv	a0,s5
    1e78:	00004097          	auipc	ra,0x4
    1e7c:	8ce080e7          	jalr	-1842(ra) # 5746 <unlink>
    1e80:	34fd                	addiw	s1,s1,-1
  for(i = 0; i < 100; i++){
    1e82:	c09d                	beqz	s1,1ea8 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1e84:	033c87bb          	mulw	a5,s9,s3
    1e88:	012787bb          	addw	a5,a5,s2
    1e8c:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1e90:	0347f7bb          	remuw	a5,a5,s4
    1e94:	d7e9                	beqz	a5,1e5e <linkunlink+0x86>
    } else if((x % 3) == 1){
    1e96:	ff6790e3          	bne	a5,s6,1e76 <linkunlink+0x9e>
      link("cat", "x");
    1e9a:	85d6                	mv	a1,s5
    1e9c:	855e                	mv	a0,s7
    1e9e:	00004097          	auipc	ra,0x4
    1ea2:	8b8080e7          	jalr	-1864(ra) # 5756 <link>
    1ea6:	bfe9                	j	1e80 <linkunlink+0xa8>
  if(pid)
    1ea8:	020c0463          	beqz	s8,1ed0 <linkunlink+0xf8>
    wait(0);
    1eac:	4501                	li	a0,0
    1eae:	00004097          	auipc	ra,0x4
    1eb2:	850080e7          	jalr	-1968(ra) # 56fe <wait>
}
    1eb6:	60e6                	ld	ra,88(sp)
    1eb8:	6446                	ld	s0,80(sp)
    1eba:	64a6                	ld	s1,72(sp)
    1ebc:	6906                	ld	s2,64(sp)
    1ebe:	79e2                	ld	s3,56(sp)
    1ec0:	7a42                	ld	s4,48(sp)
    1ec2:	7aa2                	ld	s5,40(sp)
    1ec4:	7b02                	ld	s6,32(sp)
    1ec6:	6be2                	ld	s7,24(sp)
    1ec8:	6c42                	ld	s8,16(sp)
    1eca:	6ca2                	ld	s9,8(sp)
    1ecc:	6125                	addi	sp,sp,96
    1ece:	8082                	ret
    exit(0);
    1ed0:	4501                	li	a0,0
    1ed2:	00004097          	auipc	ra,0x4
    1ed6:	824080e7          	jalr	-2012(ra) # 56f6 <exit>

0000000000001eda <manywrites>:
{
    1eda:	711d                	addi	sp,sp,-96
    1edc:	ec86                	sd	ra,88(sp)
    1ede:	e8a2                	sd	s0,80(sp)
    1ee0:	e4a6                	sd	s1,72(sp)
    1ee2:	e0ca                	sd	s2,64(sp)
    1ee4:	fc4e                	sd	s3,56(sp)
    1ee6:	f852                	sd	s4,48(sp)
    1ee8:	f456                	sd	s5,40(sp)
    1eea:	f05a                	sd	s6,32(sp)
    1eec:	ec5e                	sd	s7,24(sp)
    1eee:	1080                	addi	s0,sp,96
    1ef0:	8b2a                	mv	s6,a0
  for(int ci = 0; ci < nchildren; ci++){
    1ef2:	4481                	li	s1,0
    1ef4:	4991                	li	s3,4
    int pid = fork();
    1ef6:	00003097          	auipc	ra,0x3
    1efa:	7f8080e7          	jalr	2040(ra) # 56ee <fork>
    1efe:	892a                	mv	s2,a0
    if(pid < 0){
    1f00:	02054963          	bltz	a0,1f32 <manywrites+0x58>
    if(pid == 0){
    1f04:	c521                	beqz	a0,1f4c <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    1f06:	2485                	addiw	s1,s1,1
    1f08:	ff3497e3          	bne	s1,s3,1ef6 <manywrites+0x1c>
    1f0c:	4491                	li	s1,4
    int st = 0;
    1f0e:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1f12:	fa840513          	addi	a0,s0,-88
    1f16:	00003097          	auipc	ra,0x3
    1f1a:	7e8080e7          	jalr	2024(ra) # 56fe <wait>
    if(st != 0)
    1f1e:	fa842503          	lw	a0,-88(s0)
    1f22:	ed6d                	bnez	a0,201c <manywrites+0x142>
    1f24:	34fd                	addiw	s1,s1,-1
  for(int ci = 0; ci < nchildren; ci++){
    1f26:	f4e5                	bnez	s1,1f0e <manywrites+0x34>
  exit(0);
    1f28:	4501                	li	a0,0
    1f2a:	00003097          	auipc	ra,0x3
    1f2e:	7cc080e7          	jalr	1996(ra) # 56f6 <exit>
      printf("fork failed\n");
    1f32:	00005517          	auipc	a0,0x5
    1f36:	d6650513          	addi	a0,a0,-666 # 6c98 <malloc+0x1162>
    1f3a:	00004097          	auipc	ra,0x4
    1f3e:	b3c080e7          	jalr	-1220(ra) # 5a76 <printf>
      exit(1);
    1f42:	4505                	li	a0,1
    1f44:	00003097          	auipc	ra,0x3
    1f48:	7b2080e7          	jalr	1970(ra) # 56f6 <exit>
      name[0] = 'b';
    1f4c:	06200793          	li	a5,98
    1f50:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1f54:	0614879b          	addiw	a5,s1,97
    1f58:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1f5c:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1f60:	fa840513          	addi	a0,s0,-88
    1f64:	00003097          	auipc	ra,0x3
    1f68:	7e2080e7          	jalr	2018(ra) # 5746 <unlink>
    1f6c:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    1f6e:	0000aa97          	auipc	s5,0xa
    1f72:	c62a8a93          	addi	s5,s5,-926 # bbd0 <buf>
        for(int i = 0; i < ci+1; i++){
    1f76:	8a4a                	mv	s4,s2
    1f78:	0204ce63          	bltz	s1,1fb4 <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    1f7c:	20200593          	li	a1,514
    1f80:	fa840513          	addi	a0,s0,-88
    1f84:	00003097          	auipc	ra,0x3
    1f88:	7b2080e7          	jalr	1970(ra) # 5736 <open>
    1f8c:	89aa                	mv	s3,a0
          if(fd < 0){
    1f8e:	04054763          	bltz	a0,1fdc <manywrites+0x102>
          int cc = write(fd, buf, sz);
    1f92:	660d                	lui	a2,0x3
    1f94:	85d6                	mv	a1,s5
    1f96:	00003097          	auipc	ra,0x3
    1f9a:	780080e7          	jalr	1920(ra) # 5716 <write>
          if(cc != sz){
    1f9e:	678d                	lui	a5,0x3
    1fa0:	04f51e63          	bne	a0,a5,1ffc <manywrites+0x122>
          close(fd);
    1fa4:	854e                	mv	a0,s3
    1fa6:	00003097          	auipc	ra,0x3
    1faa:	778080e7          	jalr	1912(ra) # 571e <close>
        for(int i = 0; i < ci+1; i++){
    1fae:	2a05                	addiw	s4,s4,1
    1fb0:	fd44d6e3          	ble	s4,s1,1f7c <manywrites+0xa2>
        unlink(name);
    1fb4:	fa840513          	addi	a0,s0,-88
    1fb8:	00003097          	auipc	ra,0x3
    1fbc:	78e080e7          	jalr	1934(ra) # 5746 <unlink>
    1fc0:	3bfd                	addiw	s7,s7,-1
      for(int iters = 0; iters < howmany; iters++){
    1fc2:	fa0b9ae3          	bnez	s7,1f76 <manywrites+0x9c>
      unlink(name);
    1fc6:	fa840513          	addi	a0,s0,-88
    1fca:	00003097          	auipc	ra,0x3
    1fce:	77c080e7          	jalr	1916(ra) # 5746 <unlink>
      exit(0);
    1fd2:	4501                	li	a0,0
    1fd4:	00003097          	auipc	ra,0x3
    1fd8:	722080e7          	jalr	1826(ra) # 56f6 <exit>
            printf("%s: cannot create %s\n", s, name);
    1fdc:	fa840613          	addi	a2,s0,-88
    1fe0:	85da                	mv	a1,s6
    1fe2:	00005517          	auipc	a0,0x5
    1fe6:	b0e50513          	addi	a0,a0,-1266 # 6af0 <malloc+0xfba>
    1fea:	00004097          	auipc	ra,0x4
    1fee:	a8c080e7          	jalr	-1396(ra) # 5a76 <printf>
            exit(1);
    1ff2:	4505                	li	a0,1
    1ff4:	00003097          	auipc	ra,0x3
    1ff8:	702080e7          	jalr	1794(ra) # 56f6 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1ffc:	86aa                	mv	a3,a0
    1ffe:	660d                	lui	a2,0x3
    2000:	85da                	mv	a1,s6
    2002:	00004517          	auipc	a0,0x4
    2006:	10650513          	addi	a0,a0,262 # 6108 <malloc+0x5d2>
    200a:	00004097          	auipc	ra,0x4
    200e:	a6c080e7          	jalr	-1428(ra) # 5a76 <printf>
            exit(1);
    2012:	4505                	li	a0,1
    2014:	00003097          	auipc	ra,0x3
    2018:	6e2080e7          	jalr	1762(ra) # 56f6 <exit>
      exit(st);
    201c:	00003097          	auipc	ra,0x3
    2020:	6da080e7          	jalr	1754(ra) # 56f6 <exit>

0000000000002024 <forktest>:
{
    2024:	7179                	addi	sp,sp,-48
    2026:	f406                	sd	ra,40(sp)
    2028:	f022                	sd	s0,32(sp)
    202a:	ec26                	sd	s1,24(sp)
    202c:	e84a                	sd	s2,16(sp)
    202e:	e44e                	sd	s3,8(sp)
    2030:	1800                	addi	s0,sp,48
    2032:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    2034:	4481                	li	s1,0
    2036:	3e800913          	li	s2,1000
    pid = fork();
    203a:	00003097          	auipc	ra,0x3
    203e:	6b4080e7          	jalr	1716(ra) # 56ee <fork>
    if(pid < 0)
    2042:	02054863          	bltz	a0,2072 <forktest+0x4e>
    if(pid == 0)
    2046:	c115                	beqz	a0,206a <forktest+0x46>
  for(n=0; n<N; n++){
    2048:	2485                	addiw	s1,s1,1
    204a:	ff2498e3          	bne	s1,s2,203a <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    204e:	85ce                	mv	a1,s3
    2050:	00005517          	auipc	a0,0x5
    2054:	ad050513          	addi	a0,a0,-1328 # 6b20 <malloc+0xfea>
    2058:	00004097          	auipc	ra,0x4
    205c:	a1e080e7          	jalr	-1506(ra) # 5a76 <printf>
    exit(1);
    2060:	4505                	li	a0,1
    2062:	00003097          	auipc	ra,0x3
    2066:	694080e7          	jalr	1684(ra) # 56f6 <exit>
      exit(0);
    206a:	00003097          	auipc	ra,0x3
    206e:	68c080e7          	jalr	1676(ra) # 56f6 <exit>
  if (n == 0) {
    2072:	cc9d                	beqz	s1,20b0 <forktest+0x8c>
  if(n == N){
    2074:	3e800793          	li	a5,1000
    2078:	fcf48be3          	beq	s1,a5,204e <forktest+0x2a>
  for(; n > 0; n--){
    207c:	00905b63          	blez	s1,2092 <forktest+0x6e>
    if(wait(0) < 0){
    2080:	4501                	li	a0,0
    2082:	00003097          	auipc	ra,0x3
    2086:	67c080e7          	jalr	1660(ra) # 56fe <wait>
    208a:	04054163          	bltz	a0,20cc <forktest+0xa8>
  for(; n > 0; n--){
    208e:	34fd                	addiw	s1,s1,-1
    2090:	f8e5                	bnez	s1,2080 <forktest+0x5c>
  if(wait(0) != -1){
    2092:	4501                	li	a0,0
    2094:	00003097          	auipc	ra,0x3
    2098:	66a080e7          	jalr	1642(ra) # 56fe <wait>
    209c:	57fd                	li	a5,-1
    209e:	04f51563          	bne	a0,a5,20e8 <forktest+0xc4>
}
    20a2:	70a2                	ld	ra,40(sp)
    20a4:	7402                	ld	s0,32(sp)
    20a6:	64e2                	ld	s1,24(sp)
    20a8:	6942                	ld	s2,16(sp)
    20aa:	69a2                	ld	s3,8(sp)
    20ac:	6145                	addi	sp,sp,48
    20ae:	8082                	ret
    printf("%s: no fork at all!\n", s);
    20b0:	85ce                	mv	a1,s3
    20b2:	00005517          	auipc	a0,0x5
    20b6:	a5650513          	addi	a0,a0,-1450 # 6b08 <malloc+0xfd2>
    20ba:	00004097          	auipc	ra,0x4
    20be:	9bc080e7          	jalr	-1604(ra) # 5a76 <printf>
    exit(1);
    20c2:	4505                	li	a0,1
    20c4:	00003097          	auipc	ra,0x3
    20c8:	632080e7          	jalr	1586(ra) # 56f6 <exit>
      printf("%s: wait stopped early\n", s);
    20cc:	85ce                	mv	a1,s3
    20ce:	00005517          	auipc	a0,0x5
    20d2:	a7a50513          	addi	a0,a0,-1414 # 6b48 <malloc+0x1012>
    20d6:	00004097          	auipc	ra,0x4
    20da:	9a0080e7          	jalr	-1632(ra) # 5a76 <printf>
      exit(1);
    20de:	4505                	li	a0,1
    20e0:	00003097          	auipc	ra,0x3
    20e4:	616080e7          	jalr	1558(ra) # 56f6 <exit>
    printf("%s: wait got too many\n", s);
    20e8:	85ce                	mv	a1,s3
    20ea:	00005517          	auipc	a0,0x5
    20ee:	a7650513          	addi	a0,a0,-1418 # 6b60 <malloc+0x102a>
    20f2:	00004097          	auipc	ra,0x4
    20f6:	984080e7          	jalr	-1660(ra) # 5a76 <printf>
    exit(1);
    20fa:	4505                	li	a0,1
    20fc:	00003097          	auipc	ra,0x3
    2100:	5fa080e7          	jalr	1530(ra) # 56f6 <exit>

0000000000002104 <kernmem>:
{
    2104:	715d                	addi	sp,sp,-80
    2106:	e486                	sd	ra,72(sp)
    2108:	e0a2                	sd	s0,64(sp)
    210a:	fc26                	sd	s1,56(sp)
    210c:	f84a                	sd	s2,48(sp)
    210e:	f44e                	sd	s3,40(sp)
    2110:	f052                	sd	s4,32(sp)
    2112:	ec56                	sd	s5,24(sp)
    2114:	0880                	addi	s0,sp,80
    2116:	8aaa                	mv	s5,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2118:	4485                	li	s1,1
    211a:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    211c:	5a7d                	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    211e:	69b1                	lui	s3,0xc
    2120:	35098993          	addi	s3,s3,848 # c350 <buf+0x780>
    2124:	1003d937          	lui	s2,0x1003d
    2128:	090e                	slli	s2,s2,0x3
    212a:	48090913          	addi	s2,s2,1152 # 1003d480 <_end+0x1002e8a0>
    pid = fork();
    212e:	00003097          	auipc	ra,0x3
    2132:	5c0080e7          	jalr	1472(ra) # 56ee <fork>
    if(pid < 0){
    2136:	02054963          	bltz	a0,2168 <kernmem+0x64>
    if(pid == 0){
    213a:	c529                	beqz	a0,2184 <kernmem+0x80>
    wait(&xstatus);
    213c:	fbc40513          	addi	a0,s0,-68
    2140:	00003097          	auipc	ra,0x3
    2144:	5be080e7          	jalr	1470(ra) # 56fe <wait>
    if(xstatus != -1)  // did kernel kill child?
    2148:	fbc42783          	lw	a5,-68(s0)
    214c:	05479d63          	bne	a5,s4,21a6 <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2150:	94ce                	add	s1,s1,s3
    2152:	fd249ee3          	bne	s1,s2,212e <kernmem+0x2a>
}
    2156:	60a6                	ld	ra,72(sp)
    2158:	6406                	ld	s0,64(sp)
    215a:	74e2                	ld	s1,56(sp)
    215c:	7942                	ld	s2,48(sp)
    215e:	79a2                	ld	s3,40(sp)
    2160:	7a02                	ld	s4,32(sp)
    2162:	6ae2                	ld	s5,24(sp)
    2164:	6161                	addi	sp,sp,80
    2166:	8082                	ret
      printf("%s: fork failed\n", s);
    2168:	85d6                	mv	a1,s5
    216a:	00004517          	auipc	a0,0x4
    216e:	72650513          	addi	a0,a0,1830 # 6890 <malloc+0xd5a>
    2172:	00004097          	auipc	ra,0x4
    2176:	904080e7          	jalr	-1788(ra) # 5a76 <printf>
      exit(1);
    217a:	4505                	li	a0,1
    217c:	00003097          	auipc	ra,0x3
    2180:	57a080e7          	jalr	1402(ra) # 56f6 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    2184:	0004c683          	lbu	a3,0(s1)
    2188:	8626                	mv	a2,s1
    218a:	85d6                	mv	a1,s5
    218c:	00005517          	auipc	a0,0x5
    2190:	9ec50513          	addi	a0,a0,-1556 # 6b78 <malloc+0x1042>
    2194:	00004097          	auipc	ra,0x4
    2198:	8e2080e7          	jalr	-1822(ra) # 5a76 <printf>
      exit(1);
    219c:	4505                	li	a0,1
    219e:	00003097          	auipc	ra,0x3
    21a2:	558080e7          	jalr	1368(ra) # 56f6 <exit>
      exit(1);
    21a6:	4505                	li	a0,1
    21a8:	00003097          	auipc	ra,0x3
    21ac:	54e080e7          	jalr	1358(ra) # 56f6 <exit>

00000000000021b0 <bigargtest>:
{
    21b0:	7179                	addi	sp,sp,-48
    21b2:	f406                	sd	ra,40(sp)
    21b4:	f022                	sd	s0,32(sp)
    21b6:	ec26                	sd	s1,24(sp)
    21b8:	1800                	addi	s0,sp,48
    21ba:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    21bc:	00005517          	auipc	a0,0x5
    21c0:	9dc50513          	addi	a0,a0,-1572 # 6b98 <malloc+0x1062>
    21c4:	00003097          	auipc	ra,0x3
    21c8:	582080e7          	jalr	1410(ra) # 5746 <unlink>
  pid = fork();
    21cc:	00003097          	auipc	ra,0x3
    21d0:	522080e7          	jalr	1314(ra) # 56ee <fork>
  if(pid == 0){
    21d4:	c121                	beqz	a0,2214 <bigargtest+0x64>
  } else if(pid < 0){
    21d6:	0a054063          	bltz	a0,2276 <bigargtest+0xc6>
  wait(&xstatus);
    21da:	fdc40513          	addi	a0,s0,-36
    21de:	00003097          	auipc	ra,0x3
    21e2:	520080e7          	jalr	1312(ra) # 56fe <wait>
  if(xstatus != 0)
    21e6:	fdc42503          	lw	a0,-36(s0)
    21ea:	e545                	bnez	a0,2292 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    21ec:	4581                	li	a1,0
    21ee:	00005517          	auipc	a0,0x5
    21f2:	9aa50513          	addi	a0,a0,-1622 # 6b98 <malloc+0x1062>
    21f6:	00003097          	auipc	ra,0x3
    21fa:	540080e7          	jalr	1344(ra) # 5736 <open>
  if(fd < 0){
    21fe:	08054e63          	bltz	a0,229a <bigargtest+0xea>
  close(fd);
    2202:	00003097          	auipc	ra,0x3
    2206:	51c080e7          	jalr	1308(ra) # 571e <close>
}
    220a:	70a2                	ld	ra,40(sp)
    220c:	7402                	ld	s0,32(sp)
    220e:	64e2                	ld	s1,24(sp)
    2210:	6145                	addi	sp,sp,48
    2212:	8082                	ret
    2214:	00006797          	auipc	a5,0x6
    2218:	1a478793          	addi	a5,a5,420 # 83b8 <args.1867>
    221c:	00006697          	auipc	a3,0x6
    2220:	29468693          	addi	a3,a3,660 # 84b0 <args.1867+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    2224:	00005717          	auipc	a4,0x5
    2228:	98470713          	addi	a4,a4,-1660 # 6ba8 <malloc+0x1072>
    222c:	e398                	sd	a4,0(a5)
    222e:	07a1                	addi	a5,a5,8
    for(i = 0; i < MAXARG-1; i++)
    2230:	fed79ee3          	bne	a5,a3,222c <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    2234:	00006597          	auipc	a1,0x6
    2238:	18458593          	addi	a1,a1,388 # 83b8 <args.1867>
    223c:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2240:	00004517          	auipc	a0,0x4
    2244:	df850513          	addi	a0,a0,-520 # 6038 <malloc+0x502>
    2248:	00003097          	auipc	ra,0x3
    224c:	4e6080e7          	jalr	1254(ra) # 572e <exec>
    fd = open("bigarg-ok", O_CREATE);
    2250:	20000593          	li	a1,512
    2254:	00005517          	auipc	a0,0x5
    2258:	94450513          	addi	a0,a0,-1724 # 6b98 <malloc+0x1062>
    225c:	00003097          	auipc	ra,0x3
    2260:	4da080e7          	jalr	1242(ra) # 5736 <open>
    close(fd);
    2264:	00003097          	auipc	ra,0x3
    2268:	4ba080e7          	jalr	1210(ra) # 571e <close>
    exit(0);
    226c:	4501                	li	a0,0
    226e:	00003097          	auipc	ra,0x3
    2272:	488080e7          	jalr	1160(ra) # 56f6 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    2276:	85a6                	mv	a1,s1
    2278:	00005517          	auipc	a0,0x5
    227c:	a1050513          	addi	a0,a0,-1520 # 6c88 <malloc+0x1152>
    2280:	00003097          	auipc	ra,0x3
    2284:	7f6080e7          	jalr	2038(ra) # 5a76 <printf>
    exit(1);
    2288:	4505                	li	a0,1
    228a:	00003097          	auipc	ra,0x3
    228e:	46c080e7          	jalr	1132(ra) # 56f6 <exit>
    exit(xstatus);
    2292:	00003097          	auipc	ra,0x3
    2296:	464080e7          	jalr	1124(ra) # 56f6 <exit>
    printf("%s: bigarg test failed!\n", s);
    229a:	85a6                	mv	a1,s1
    229c:	00005517          	auipc	a0,0x5
    22a0:	a0c50513          	addi	a0,a0,-1524 # 6ca8 <malloc+0x1172>
    22a4:	00003097          	auipc	ra,0x3
    22a8:	7d2080e7          	jalr	2002(ra) # 5a76 <printf>
    exit(1);
    22ac:	4505                	li	a0,1
    22ae:	00003097          	auipc	ra,0x3
    22b2:	448080e7          	jalr	1096(ra) # 56f6 <exit>

00000000000022b6 <stacktest>:
{
    22b6:	7179                	addi	sp,sp,-48
    22b8:	f406                	sd	ra,40(sp)
    22ba:	f022                	sd	s0,32(sp)
    22bc:	ec26                	sd	s1,24(sp)
    22be:	1800                	addi	s0,sp,48
    22c0:	84aa                	mv	s1,a0
  pid = fork();
    22c2:	00003097          	auipc	ra,0x3
    22c6:	42c080e7          	jalr	1068(ra) # 56ee <fork>
  if(pid == 0) {
    22ca:	c115                	beqz	a0,22ee <stacktest+0x38>
  } else if(pid < 0){
    22cc:	04054463          	bltz	a0,2314 <stacktest+0x5e>
  wait(&xstatus);
    22d0:	fdc40513          	addi	a0,s0,-36
    22d4:	00003097          	auipc	ra,0x3
    22d8:	42a080e7          	jalr	1066(ra) # 56fe <wait>
  if(xstatus == -1)  // kernel killed child?
    22dc:	fdc42503          	lw	a0,-36(s0)
    22e0:	57fd                	li	a5,-1
    22e2:	04f50763          	beq	a0,a5,2330 <stacktest+0x7a>
    exit(xstatus);
    22e6:	00003097          	auipc	ra,0x3
    22ea:	410080e7          	jalr	1040(ra) # 56f6 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    22ee:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    22f0:	77fd                	lui	a5,0xfffff
    22f2:	97ba                	add	a5,a5,a4
    22f4:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <_end+0xffffffffffff0420>
    22f8:	85a6                	mv	a1,s1
    22fa:	00005517          	auipc	a0,0x5
    22fe:	9ce50513          	addi	a0,a0,-1586 # 6cc8 <malloc+0x1192>
    2302:	00003097          	auipc	ra,0x3
    2306:	774080e7          	jalr	1908(ra) # 5a76 <printf>
    exit(1);
    230a:	4505                	li	a0,1
    230c:	00003097          	auipc	ra,0x3
    2310:	3ea080e7          	jalr	1002(ra) # 56f6 <exit>
    printf("%s: fork failed\n", s);
    2314:	85a6                	mv	a1,s1
    2316:	00004517          	auipc	a0,0x4
    231a:	57a50513          	addi	a0,a0,1402 # 6890 <malloc+0xd5a>
    231e:	00003097          	auipc	ra,0x3
    2322:	758080e7          	jalr	1880(ra) # 5a76 <printf>
    exit(1);
    2326:	4505                	li	a0,1
    2328:	00003097          	auipc	ra,0x3
    232c:	3ce080e7          	jalr	974(ra) # 56f6 <exit>
    exit(0);
    2330:	4501                	li	a0,0
    2332:	00003097          	auipc	ra,0x3
    2336:	3c4080e7          	jalr	964(ra) # 56f6 <exit>

000000000000233a <copyinstr3>:
{
    233a:	7179                	addi	sp,sp,-48
    233c:	f406                	sd	ra,40(sp)
    233e:	f022                	sd	s0,32(sp)
    2340:	ec26                	sd	s1,24(sp)
    2342:	1800                	addi	s0,sp,48
  sbrk(8192);
    2344:	6509                	lui	a0,0x2
    2346:	00003097          	auipc	ra,0x3
    234a:	438080e7          	jalr	1080(ra) # 577e <sbrk>
  uint64 top = (uint64) sbrk(0);
    234e:	4501                	li	a0,0
    2350:	00003097          	auipc	ra,0x3
    2354:	42e080e7          	jalr	1070(ra) # 577e <sbrk>
  if((top % PGSIZE) != 0){
    2358:	6785                	lui	a5,0x1
    235a:	17fd                	addi	a5,a5,-1
    235c:	8fe9                	and	a5,a5,a0
    235e:	e3d1                	bnez	a5,23e2 <copyinstr3+0xa8>
  top = (uint64) sbrk(0);
    2360:	4501                	li	a0,0
    2362:	00003097          	auipc	ra,0x3
    2366:	41c080e7          	jalr	1052(ra) # 577e <sbrk>
  if(top % PGSIZE){
    236a:	6785                	lui	a5,0x1
    236c:	17fd                	addi	a5,a5,-1
    236e:	8fe9                	and	a5,a5,a0
    2370:	e7c1                	bnez	a5,23f8 <copyinstr3+0xbe>
  char *b = (char *) (top - 1);
    2372:	fff50493          	addi	s1,a0,-1 # 1fff <manywrites+0x125>
  *b = 'x';
    2376:	07800793          	li	a5,120
    237a:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    237e:	8526                	mv	a0,s1
    2380:	00003097          	auipc	ra,0x3
    2384:	3c6080e7          	jalr	966(ra) # 5746 <unlink>
  if(ret != -1){
    2388:	57fd                	li	a5,-1
    238a:	08f51463          	bne	a0,a5,2412 <copyinstr3+0xd8>
  int fd = open(b, O_CREATE | O_WRONLY);
    238e:	20100593          	li	a1,513
    2392:	8526                	mv	a0,s1
    2394:	00003097          	auipc	ra,0x3
    2398:	3a2080e7          	jalr	930(ra) # 5736 <open>
  if(fd != -1){
    239c:	57fd                	li	a5,-1
    239e:	08f51963          	bne	a0,a5,2430 <copyinstr3+0xf6>
  ret = link(b, b);
    23a2:	85a6                	mv	a1,s1
    23a4:	8526                	mv	a0,s1
    23a6:	00003097          	auipc	ra,0x3
    23aa:	3b0080e7          	jalr	944(ra) # 5756 <link>
  if(ret != -1){
    23ae:	57fd                	li	a5,-1
    23b0:	08f51f63          	bne	a0,a5,244e <copyinstr3+0x114>
  char *args[] = { "xx", 0 };
    23b4:	00005797          	auipc	a5,0x5
    23b8:	5bc78793          	addi	a5,a5,1468 # 7970 <malloc+0x1e3a>
    23bc:	fcf43823          	sd	a5,-48(s0)
    23c0:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    23c4:	fd040593          	addi	a1,s0,-48
    23c8:	8526                	mv	a0,s1
    23ca:	00003097          	auipc	ra,0x3
    23ce:	364080e7          	jalr	868(ra) # 572e <exec>
  if(ret != -1){
    23d2:	57fd                	li	a5,-1
    23d4:	08f51d63          	bne	a0,a5,246e <copyinstr3+0x134>
}
    23d8:	70a2                	ld	ra,40(sp)
    23da:	7402                	ld	s0,32(sp)
    23dc:	64e2                	ld	s1,24(sp)
    23de:	6145                	addi	sp,sp,48
    23e0:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    23e2:	6785                	lui	a5,0x1
    23e4:	17fd                	addi	a5,a5,-1
    23e6:	8d7d                	and	a0,a0,a5
    23e8:	6785                	lui	a5,0x1
    23ea:	40a7853b          	subw	a0,a5,a0
    23ee:	00003097          	auipc	ra,0x3
    23f2:	390080e7          	jalr	912(ra) # 577e <sbrk>
    23f6:	b7ad                	j	2360 <copyinstr3+0x26>
    printf("oops\n");
    23f8:	00005517          	auipc	a0,0x5
    23fc:	8f850513          	addi	a0,a0,-1800 # 6cf0 <malloc+0x11ba>
    2400:	00003097          	auipc	ra,0x3
    2404:	676080e7          	jalr	1654(ra) # 5a76 <printf>
    exit(1);
    2408:	4505                	li	a0,1
    240a:	00003097          	auipc	ra,0x3
    240e:	2ec080e7          	jalr	748(ra) # 56f6 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    2412:	862a                	mv	a2,a0
    2414:	85a6                	mv	a1,s1
    2416:	00004517          	auipc	a0,0x4
    241a:	39a50513          	addi	a0,a0,922 # 67b0 <malloc+0xc7a>
    241e:	00003097          	auipc	ra,0x3
    2422:	658080e7          	jalr	1624(ra) # 5a76 <printf>
    exit(1);
    2426:	4505                	li	a0,1
    2428:	00003097          	auipc	ra,0x3
    242c:	2ce080e7          	jalr	718(ra) # 56f6 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2430:	862a                	mv	a2,a0
    2432:	85a6                	mv	a1,s1
    2434:	00004517          	auipc	a0,0x4
    2438:	39c50513          	addi	a0,a0,924 # 67d0 <malloc+0xc9a>
    243c:	00003097          	auipc	ra,0x3
    2440:	63a080e7          	jalr	1594(ra) # 5a76 <printf>
    exit(1);
    2444:	4505                	li	a0,1
    2446:	00003097          	auipc	ra,0x3
    244a:	2b0080e7          	jalr	688(ra) # 56f6 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    244e:	86aa                	mv	a3,a0
    2450:	8626                	mv	a2,s1
    2452:	85a6                	mv	a1,s1
    2454:	00004517          	auipc	a0,0x4
    2458:	39c50513          	addi	a0,a0,924 # 67f0 <malloc+0xcba>
    245c:	00003097          	auipc	ra,0x3
    2460:	61a080e7          	jalr	1562(ra) # 5a76 <printf>
    exit(1);
    2464:	4505                	li	a0,1
    2466:	00003097          	auipc	ra,0x3
    246a:	290080e7          	jalr	656(ra) # 56f6 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    246e:	567d                	li	a2,-1
    2470:	85a6                	mv	a1,s1
    2472:	00004517          	auipc	a0,0x4
    2476:	3a650513          	addi	a0,a0,934 # 6818 <malloc+0xce2>
    247a:	00003097          	auipc	ra,0x3
    247e:	5fc080e7          	jalr	1532(ra) # 5a76 <printf>
    exit(1);
    2482:	4505                	li	a0,1
    2484:	00003097          	auipc	ra,0x3
    2488:	272080e7          	jalr	626(ra) # 56f6 <exit>

000000000000248c <rwsbrk>:
{
    248c:	1101                	addi	sp,sp,-32
    248e:	ec06                	sd	ra,24(sp)
    2490:	e822                	sd	s0,16(sp)
    2492:	e426                	sd	s1,8(sp)
    2494:	e04a                	sd	s2,0(sp)
    2496:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2498:	6509                	lui	a0,0x2
    249a:	00003097          	auipc	ra,0x3
    249e:	2e4080e7          	jalr	740(ra) # 577e <sbrk>
  if(a == 0xffffffffffffffffLL) {
    24a2:	57fd                	li	a5,-1
    24a4:	06f50263          	beq	a0,a5,2508 <rwsbrk+0x7c>
    24a8:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    24aa:	7579                	lui	a0,0xffffe
    24ac:	00003097          	auipc	ra,0x3
    24b0:	2d2080e7          	jalr	722(ra) # 577e <sbrk>
    24b4:	57fd                	li	a5,-1
    24b6:	06f50663          	beq	a0,a5,2522 <rwsbrk+0x96>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    24ba:	20100593          	li	a1,513
    24be:	00005517          	auipc	a0,0x5
    24c2:	87250513          	addi	a0,a0,-1934 # 6d30 <malloc+0x11fa>
    24c6:	00003097          	auipc	ra,0x3
    24ca:	270080e7          	jalr	624(ra) # 5736 <open>
    24ce:	892a                	mv	s2,a0
  if(fd < 0){
    24d0:	06054663          	bltz	a0,253c <rwsbrk+0xb0>
  n = write(fd, (void*)(a+4096), 1024);
    24d4:	6785                	lui	a5,0x1
    24d6:	94be                	add	s1,s1,a5
    24d8:	40000613          	li	a2,1024
    24dc:	85a6                	mv	a1,s1
    24de:	00003097          	auipc	ra,0x3
    24e2:	238080e7          	jalr	568(ra) # 5716 <write>
  if(n >= 0){
    24e6:	06054863          	bltz	a0,2556 <rwsbrk+0xca>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    24ea:	862a                	mv	a2,a0
    24ec:	85a6                	mv	a1,s1
    24ee:	00005517          	auipc	a0,0x5
    24f2:	86250513          	addi	a0,a0,-1950 # 6d50 <malloc+0x121a>
    24f6:	00003097          	auipc	ra,0x3
    24fa:	580080e7          	jalr	1408(ra) # 5a76 <printf>
    exit(1);
    24fe:	4505                	li	a0,1
    2500:	00003097          	auipc	ra,0x3
    2504:	1f6080e7          	jalr	502(ra) # 56f6 <exit>
    printf("sbrk(rwsbrk) failed\n");
    2508:	00004517          	auipc	a0,0x4
    250c:	7f050513          	addi	a0,a0,2032 # 6cf8 <malloc+0x11c2>
    2510:	00003097          	auipc	ra,0x3
    2514:	566080e7          	jalr	1382(ra) # 5a76 <printf>
    exit(1);
    2518:	4505                	li	a0,1
    251a:	00003097          	auipc	ra,0x3
    251e:	1dc080e7          	jalr	476(ra) # 56f6 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    2522:	00004517          	auipc	a0,0x4
    2526:	7ee50513          	addi	a0,a0,2030 # 6d10 <malloc+0x11da>
    252a:	00003097          	auipc	ra,0x3
    252e:	54c080e7          	jalr	1356(ra) # 5a76 <printf>
    exit(1);
    2532:	4505                	li	a0,1
    2534:	00003097          	auipc	ra,0x3
    2538:	1c2080e7          	jalr	450(ra) # 56f6 <exit>
    printf("open(rwsbrk) failed\n");
    253c:	00004517          	auipc	a0,0x4
    2540:	7fc50513          	addi	a0,a0,2044 # 6d38 <malloc+0x1202>
    2544:	00003097          	auipc	ra,0x3
    2548:	532080e7          	jalr	1330(ra) # 5a76 <printf>
    exit(1);
    254c:	4505                	li	a0,1
    254e:	00003097          	auipc	ra,0x3
    2552:	1a8080e7          	jalr	424(ra) # 56f6 <exit>
  close(fd);
    2556:	854a                	mv	a0,s2
    2558:	00003097          	auipc	ra,0x3
    255c:	1c6080e7          	jalr	454(ra) # 571e <close>
  unlink("rwsbrk");
    2560:	00004517          	auipc	a0,0x4
    2564:	7d050513          	addi	a0,a0,2000 # 6d30 <malloc+0x11fa>
    2568:	00003097          	auipc	ra,0x3
    256c:	1de080e7          	jalr	478(ra) # 5746 <unlink>
  fd = open("README", O_RDONLY);
    2570:	4581                	li	a1,0
    2572:	00004517          	auipc	a0,0x4
    2576:	c6e50513          	addi	a0,a0,-914 # 61e0 <malloc+0x6aa>
    257a:	00003097          	auipc	ra,0x3
    257e:	1bc080e7          	jalr	444(ra) # 5736 <open>
    2582:	892a                	mv	s2,a0
  if(fd < 0){
    2584:	02054963          	bltz	a0,25b6 <rwsbrk+0x12a>
  n = read(fd, (void*)(a+4096), 10);
    2588:	4629                	li	a2,10
    258a:	85a6                	mv	a1,s1
    258c:	00003097          	auipc	ra,0x3
    2590:	182080e7          	jalr	386(ra) # 570e <read>
  if(n >= 0){
    2594:	02054e63          	bltz	a0,25d0 <rwsbrk+0x144>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    2598:	862a                	mv	a2,a0
    259a:	85a6                	mv	a1,s1
    259c:	00004517          	auipc	a0,0x4
    25a0:	7e450513          	addi	a0,a0,2020 # 6d80 <malloc+0x124a>
    25a4:	00003097          	auipc	ra,0x3
    25a8:	4d2080e7          	jalr	1234(ra) # 5a76 <printf>
    exit(1);
    25ac:	4505                	li	a0,1
    25ae:	00003097          	auipc	ra,0x3
    25b2:	148080e7          	jalr	328(ra) # 56f6 <exit>
    printf("open(rwsbrk) failed\n");
    25b6:	00004517          	auipc	a0,0x4
    25ba:	78250513          	addi	a0,a0,1922 # 6d38 <malloc+0x1202>
    25be:	00003097          	auipc	ra,0x3
    25c2:	4b8080e7          	jalr	1208(ra) # 5a76 <printf>
    exit(1);
    25c6:	4505                	li	a0,1
    25c8:	00003097          	auipc	ra,0x3
    25cc:	12e080e7          	jalr	302(ra) # 56f6 <exit>
  close(fd);
    25d0:	854a                	mv	a0,s2
    25d2:	00003097          	auipc	ra,0x3
    25d6:	14c080e7          	jalr	332(ra) # 571e <close>
  exit(0);
    25da:	4501                	li	a0,0
    25dc:	00003097          	auipc	ra,0x3
    25e0:	11a080e7          	jalr	282(ra) # 56f6 <exit>

00000000000025e4 <sbrkbasic>:
{
    25e4:	715d                	addi	sp,sp,-80
    25e6:	e486                	sd	ra,72(sp)
    25e8:	e0a2                	sd	s0,64(sp)
    25ea:	fc26                	sd	s1,56(sp)
    25ec:	f84a                	sd	s2,48(sp)
    25ee:	f44e                	sd	s3,40(sp)
    25f0:	f052                	sd	s4,32(sp)
    25f2:	ec56                	sd	s5,24(sp)
    25f4:	0880                	addi	s0,sp,80
    25f6:	8aaa                	mv	s5,a0
  pid = fork();
    25f8:	00003097          	auipc	ra,0x3
    25fc:	0f6080e7          	jalr	246(ra) # 56ee <fork>
  if(pid < 0){
    2600:	02054c63          	bltz	a0,2638 <sbrkbasic+0x54>
  if(pid == 0){
    2604:	ed21                	bnez	a0,265c <sbrkbasic+0x78>
    a = sbrk(TOOMUCH);
    2606:	40000537          	lui	a0,0x40000
    260a:	00003097          	auipc	ra,0x3
    260e:	174080e7          	jalr	372(ra) # 577e <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    2612:	57fd                	li	a5,-1
    2614:	02f50f63          	beq	a0,a5,2652 <sbrkbasic+0x6e>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2618:	400007b7          	lui	a5,0x40000
    261c:	97aa                	add	a5,a5,a0
      *b = 99;
    261e:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    2622:	6705                	lui	a4,0x1
      *b = 99;
    2624:	00d50023          	sb	a3,0(a0) # 40000000 <_end+0x3fff1420>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2628:	953a                	add	a0,a0,a4
    262a:	fef51de3          	bne	a0,a5,2624 <sbrkbasic+0x40>
    exit(1);
    262e:	4505                	li	a0,1
    2630:	00003097          	auipc	ra,0x3
    2634:	0c6080e7          	jalr	198(ra) # 56f6 <exit>
    printf("fork failed in sbrkbasic\n");
    2638:	00004517          	auipc	a0,0x4
    263c:	77050513          	addi	a0,a0,1904 # 6da8 <malloc+0x1272>
    2640:	00003097          	auipc	ra,0x3
    2644:	436080e7          	jalr	1078(ra) # 5a76 <printf>
    exit(1);
    2648:	4505                	li	a0,1
    264a:	00003097          	auipc	ra,0x3
    264e:	0ac080e7          	jalr	172(ra) # 56f6 <exit>
      exit(0);
    2652:	4501                	li	a0,0
    2654:	00003097          	auipc	ra,0x3
    2658:	0a2080e7          	jalr	162(ra) # 56f6 <exit>
  wait(&xstatus);
    265c:	fbc40513          	addi	a0,s0,-68
    2660:	00003097          	auipc	ra,0x3
    2664:	09e080e7          	jalr	158(ra) # 56fe <wait>
  if(xstatus == 1){
    2668:	fbc42703          	lw	a4,-68(s0)
    266c:	4785                	li	a5,1
    266e:	00f70e63          	beq	a4,a5,268a <sbrkbasic+0xa6>
  a = sbrk(0);
    2672:	4501                	li	a0,0
    2674:	00003097          	auipc	ra,0x3
    2678:	10a080e7          	jalr	266(ra) # 577e <sbrk>
    267c:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    267e:	4901                	li	s2,0
    *b = 1;
    2680:	4a05                	li	s4,1
  for(i = 0; i < 5000; i++){
    2682:	6985                	lui	s3,0x1
    2684:	38898993          	addi	s3,s3,904 # 1388 <copyinstr2+0x1c0>
    2688:	a005                	j	26a8 <sbrkbasic+0xc4>
    printf("%s: too much memory allocated!\n", s);
    268a:	85d6                	mv	a1,s5
    268c:	00004517          	auipc	a0,0x4
    2690:	73c50513          	addi	a0,a0,1852 # 6dc8 <malloc+0x1292>
    2694:	00003097          	auipc	ra,0x3
    2698:	3e2080e7          	jalr	994(ra) # 5a76 <printf>
    exit(1);
    269c:	4505                	li	a0,1
    269e:	00003097          	auipc	ra,0x3
    26a2:	058080e7          	jalr	88(ra) # 56f6 <exit>
    a = b + 1;
    26a6:	84be                	mv	s1,a5
    b = sbrk(1);
    26a8:	4505                	li	a0,1
    26aa:	00003097          	auipc	ra,0x3
    26ae:	0d4080e7          	jalr	212(ra) # 577e <sbrk>
    if(b != a){
    26b2:	04951b63          	bne	a0,s1,2708 <sbrkbasic+0x124>
    *b = 1;
    26b6:	01448023          	sb	s4,0(s1)
    a = b + 1;
    26ba:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    26be:	2905                	addiw	s2,s2,1
    26c0:	ff3913e3          	bne	s2,s3,26a6 <sbrkbasic+0xc2>
  pid = fork();
    26c4:	00003097          	auipc	ra,0x3
    26c8:	02a080e7          	jalr	42(ra) # 56ee <fork>
    26cc:	892a                	mv	s2,a0
  if(pid < 0){
    26ce:	04054d63          	bltz	a0,2728 <sbrkbasic+0x144>
  c = sbrk(1);
    26d2:	4505                	li	a0,1
    26d4:	00003097          	auipc	ra,0x3
    26d8:	0aa080e7          	jalr	170(ra) # 577e <sbrk>
  c = sbrk(1);
    26dc:	4505                	li	a0,1
    26de:	00003097          	auipc	ra,0x3
    26e2:	0a0080e7          	jalr	160(ra) # 577e <sbrk>
  if(c != a + 1){
    26e6:	0489                	addi	s1,s1,2
    26e8:	04a48e63          	beq	s1,a0,2744 <sbrkbasic+0x160>
    printf("%s: sbrk test failed post-fork\n", s);
    26ec:	85d6                	mv	a1,s5
    26ee:	00004517          	auipc	a0,0x4
    26f2:	73a50513          	addi	a0,a0,1850 # 6e28 <malloc+0x12f2>
    26f6:	00003097          	auipc	ra,0x3
    26fa:	380080e7          	jalr	896(ra) # 5a76 <printf>
    exit(1);
    26fe:	4505                	li	a0,1
    2700:	00003097          	auipc	ra,0x3
    2704:	ff6080e7          	jalr	-10(ra) # 56f6 <exit>
      printf("%s: sbrk test failed %d %x %x\n", i, a, b);
    2708:	86aa                	mv	a3,a0
    270a:	8626                	mv	a2,s1
    270c:	85ca                	mv	a1,s2
    270e:	00004517          	auipc	a0,0x4
    2712:	6da50513          	addi	a0,a0,1754 # 6de8 <malloc+0x12b2>
    2716:	00003097          	auipc	ra,0x3
    271a:	360080e7          	jalr	864(ra) # 5a76 <printf>
      exit(1);
    271e:	4505                	li	a0,1
    2720:	00003097          	auipc	ra,0x3
    2724:	fd6080e7          	jalr	-42(ra) # 56f6 <exit>
    printf("%s: sbrk test fork failed\n", s);
    2728:	85d6                	mv	a1,s5
    272a:	00004517          	auipc	a0,0x4
    272e:	6de50513          	addi	a0,a0,1758 # 6e08 <malloc+0x12d2>
    2732:	00003097          	auipc	ra,0x3
    2736:	344080e7          	jalr	836(ra) # 5a76 <printf>
    exit(1);
    273a:	4505                	li	a0,1
    273c:	00003097          	auipc	ra,0x3
    2740:	fba080e7          	jalr	-70(ra) # 56f6 <exit>
  if(pid == 0)
    2744:	00091763          	bnez	s2,2752 <sbrkbasic+0x16e>
    exit(0);
    2748:	4501                	li	a0,0
    274a:	00003097          	auipc	ra,0x3
    274e:	fac080e7          	jalr	-84(ra) # 56f6 <exit>
  wait(&xstatus);
    2752:	fbc40513          	addi	a0,s0,-68
    2756:	00003097          	auipc	ra,0x3
    275a:	fa8080e7          	jalr	-88(ra) # 56fe <wait>
  exit(xstatus);
    275e:	fbc42503          	lw	a0,-68(s0)
    2762:	00003097          	auipc	ra,0x3
    2766:	f94080e7          	jalr	-108(ra) # 56f6 <exit>

000000000000276a <sbrkmuch>:
{
    276a:	7179                	addi	sp,sp,-48
    276c:	f406                	sd	ra,40(sp)
    276e:	f022                	sd	s0,32(sp)
    2770:	ec26                	sd	s1,24(sp)
    2772:	e84a                	sd	s2,16(sp)
    2774:	e44e                	sd	s3,8(sp)
    2776:	e052                	sd	s4,0(sp)
    2778:	1800                	addi	s0,sp,48
    277a:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    277c:	4501                	li	a0,0
    277e:	00003097          	auipc	ra,0x3
    2782:	000080e7          	jalr	ra # 577e <sbrk>
    2786:	892a                	mv	s2,a0
  a = sbrk(0);
    2788:	4501                	li	a0,0
    278a:	00003097          	auipc	ra,0x3
    278e:	ff4080e7          	jalr	-12(ra) # 577e <sbrk>
    2792:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2794:	06400537          	lui	a0,0x6400
    2798:	9d05                	subw	a0,a0,s1
    279a:	00003097          	auipc	ra,0x3
    279e:	fe4080e7          	jalr	-28(ra) # 577e <sbrk>
  if (p != a) {
    27a2:	0ca49763          	bne	s1,a0,2870 <sbrkmuch+0x106>
  char *eee = sbrk(0);
    27a6:	4501                	li	a0,0
    27a8:	00003097          	auipc	ra,0x3
    27ac:	fd6080e7          	jalr	-42(ra) # 577e <sbrk>
  for(char *pp = a; pp < eee; pp += 4096)
    27b0:	00a4f963          	bleu	a0,s1,27c2 <sbrkmuch+0x58>
    *pp = 1;
    27b4:	4705                	li	a4,1
  for(char *pp = a; pp < eee; pp += 4096)
    27b6:	6785                	lui	a5,0x1
    *pp = 1;
    27b8:	00e48023          	sb	a4,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    27bc:	94be                	add	s1,s1,a5
    27be:	fea4ede3          	bltu	s1,a0,27b8 <sbrkmuch+0x4e>
  *lastaddr = 99;
    27c2:	064007b7          	lui	a5,0x6400
    27c6:	06300713          	li	a4,99
    27ca:	fee78fa3          	sb	a4,-1(a5) # 63fffff <_end+0x63f141f>
  a = sbrk(0);
    27ce:	4501                	li	a0,0
    27d0:	00003097          	auipc	ra,0x3
    27d4:	fae080e7          	jalr	-82(ra) # 577e <sbrk>
    27d8:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    27da:	757d                	lui	a0,0xfffff
    27dc:	00003097          	auipc	ra,0x3
    27e0:	fa2080e7          	jalr	-94(ra) # 577e <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    27e4:	57fd                	li	a5,-1
    27e6:	0af50363          	beq	a0,a5,288c <sbrkmuch+0x122>
  c = sbrk(0);
    27ea:	4501                	li	a0,0
    27ec:	00003097          	auipc	ra,0x3
    27f0:	f92080e7          	jalr	-110(ra) # 577e <sbrk>
  if(c != a - PGSIZE){
    27f4:	77fd                	lui	a5,0xfffff
    27f6:	97a6                	add	a5,a5,s1
    27f8:	0af51863          	bne	a0,a5,28a8 <sbrkmuch+0x13e>
  a = sbrk(0);
    27fc:	4501                	li	a0,0
    27fe:	00003097          	auipc	ra,0x3
    2802:	f80080e7          	jalr	-128(ra) # 577e <sbrk>
    2806:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2808:	6505                	lui	a0,0x1
    280a:	00003097          	auipc	ra,0x3
    280e:	f74080e7          	jalr	-140(ra) # 577e <sbrk>
    2812:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2814:	0aa49a63          	bne	s1,a0,28c8 <sbrkmuch+0x15e>
    2818:	4501                	li	a0,0
    281a:	00003097          	auipc	ra,0x3
    281e:	f64080e7          	jalr	-156(ra) # 577e <sbrk>
    2822:	6785                	lui	a5,0x1
    2824:	97a6                	add	a5,a5,s1
    2826:	0af51163          	bne	a0,a5,28c8 <sbrkmuch+0x15e>
  if(*lastaddr == 99){
    282a:	064007b7          	lui	a5,0x6400
    282e:	fff7c703          	lbu	a4,-1(a5) # 63fffff <_end+0x63f141f>
    2832:	06300793          	li	a5,99
    2836:	0af70963          	beq	a4,a5,28e8 <sbrkmuch+0x17e>
  a = sbrk(0);
    283a:	4501                	li	a0,0
    283c:	00003097          	auipc	ra,0x3
    2840:	f42080e7          	jalr	-190(ra) # 577e <sbrk>
    2844:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2846:	4501                	li	a0,0
    2848:	00003097          	auipc	ra,0x3
    284c:	f36080e7          	jalr	-202(ra) # 577e <sbrk>
    2850:	40a9053b          	subw	a0,s2,a0
    2854:	00003097          	auipc	ra,0x3
    2858:	f2a080e7          	jalr	-214(ra) # 577e <sbrk>
  if(c != a){
    285c:	0aa49463          	bne	s1,a0,2904 <sbrkmuch+0x19a>
}
    2860:	70a2                	ld	ra,40(sp)
    2862:	7402                	ld	s0,32(sp)
    2864:	64e2                	ld	s1,24(sp)
    2866:	6942                	ld	s2,16(sp)
    2868:	69a2                	ld	s3,8(sp)
    286a:	6a02                	ld	s4,0(sp)
    286c:	6145                	addi	sp,sp,48
    286e:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2870:	85ce                	mv	a1,s3
    2872:	00004517          	auipc	a0,0x4
    2876:	5d650513          	addi	a0,a0,1494 # 6e48 <malloc+0x1312>
    287a:	00003097          	auipc	ra,0x3
    287e:	1fc080e7          	jalr	508(ra) # 5a76 <printf>
    exit(1);
    2882:	4505                	li	a0,1
    2884:	00003097          	auipc	ra,0x3
    2888:	e72080e7          	jalr	-398(ra) # 56f6 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    288c:	85ce                	mv	a1,s3
    288e:	00004517          	auipc	a0,0x4
    2892:	60250513          	addi	a0,a0,1538 # 6e90 <malloc+0x135a>
    2896:	00003097          	auipc	ra,0x3
    289a:	1e0080e7          	jalr	480(ra) # 5a76 <printf>
    exit(1);
    289e:	4505                	li	a0,1
    28a0:	00003097          	auipc	ra,0x3
    28a4:	e56080e7          	jalr	-426(ra) # 56f6 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    28a8:	86aa                	mv	a3,a0
    28aa:	8626                	mv	a2,s1
    28ac:	85ce                	mv	a1,s3
    28ae:	00004517          	auipc	a0,0x4
    28b2:	60250513          	addi	a0,a0,1538 # 6eb0 <malloc+0x137a>
    28b6:	00003097          	auipc	ra,0x3
    28ba:	1c0080e7          	jalr	448(ra) # 5a76 <printf>
    exit(1);
    28be:	4505                	li	a0,1
    28c0:	00003097          	auipc	ra,0x3
    28c4:	e36080e7          	jalr	-458(ra) # 56f6 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    28c8:	86d2                	mv	a3,s4
    28ca:	8626                	mv	a2,s1
    28cc:	85ce                	mv	a1,s3
    28ce:	00004517          	auipc	a0,0x4
    28d2:	62250513          	addi	a0,a0,1570 # 6ef0 <malloc+0x13ba>
    28d6:	00003097          	auipc	ra,0x3
    28da:	1a0080e7          	jalr	416(ra) # 5a76 <printf>
    exit(1);
    28de:	4505                	li	a0,1
    28e0:	00003097          	auipc	ra,0x3
    28e4:	e16080e7          	jalr	-490(ra) # 56f6 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    28e8:	85ce                	mv	a1,s3
    28ea:	00004517          	auipc	a0,0x4
    28ee:	63650513          	addi	a0,a0,1590 # 6f20 <malloc+0x13ea>
    28f2:	00003097          	auipc	ra,0x3
    28f6:	184080e7          	jalr	388(ra) # 5a76 <printf>
    exit(1);
    28fa:	4505                	li	a0,1
    28fc:	00003097          	auipc	ra,0x3
    2900:	dfa080e7          	jalr	-518(ra) # 56f6 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2904:	86aa                	mv	a3,a0
    2906:	8626                	mv	a2,s1
    2908:	85ce                	mv	a1,s3
    290a:	00004517          	auipc	a0,0x4
    290e:	64e50513          	addi	a0,a0,1614 # 6f58 <malloc+0x1422>
    2912:	00003097          	auipc	ra,0x3
    2916:	164080e7          	jalr	356(ra) # 5a76 <printf>
    exit(1);
    291a:	4505                	li	a0,1
    291c:	00003097          	auipc	ra,0x3
    2920:	dda080e7          	jalr	-550(ra) # 56f6 <exit>

0000000000002924 <sbrkarg>:
{
    2924:	7179                	addi	sp,sp,-48
    2926:	f406                	sd	ra,40(sp)
    2928:	f022                	sd	s0,32(sp)
    292a:	ec26                	sd	s1,24(sp)
    292c:	e84a                	sd	s2,16(sp)
    292e:	e44e                	sd	s3,8(sp)
    2930:	1800                	addi	s0,sp,48
    2932:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2934:	6505                	lui	a0,0x1
    2936:	00003097          	auipc	ra,0x3
    293a:	e48080e7          	jalr	-440(ra) # 577e <sbrk>
    293e:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2940:	20100593          	li	a1,513
    2944:	00004517          	auipc	a0,0x4
    2948:	63c50513          	addi	a0,a0,1596 # 6f80 <malloc+0x144a>
    294c:	00003097          	auipc	ra,0x3
    2950:	dea080e7          	jalr	-534(ra) # 5736 <open>
    2954:	84aa                	mv	s1,a0
  unlink("sbrk");
    2956:	00004517          	auipc	a0,0x4
    295a:	62a50513          	addi	a0,a0,1578 # 6f80 <malloc+0x144a>
    295e:	00003097          	auipc	ra,0x3
    2962:	de8080e7          	jalr	-536(ra) # 5746 <unlink>
  if(fd < 0)  {
    2966:	0404c163          	bltz	s1,29a8 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    296a:	6605                	lui	a2,0x1
    296c:	85ca                	mv	a1,s2
    296e:	8526                	mv	a0,s1
    2970:	00003097          	auipc	ra,0x3
    2974:	da6080e7          	jalr	-602(ra) # 5716 <write>
    2978:	04054663          	bltz	a0,29c4 <sbrkarg+0xa0>
  close(fd);
    297c:	8526                	mv	a0,s1
    297e:	00003097          	auipc	ra,0x3
    2982:	da0080e7          	jalr	-608(ra) # 571e <close>
  a = sbrk(PGSIZE);
    2986:	6505                	lui	a0,0x1
    2988:	00003097          	auipc	ra,0x3
    298c:	df6080e7          	jalr	-522(ra) # 577e <sbrk>
  if(pipe((int *) a) != 0){
    2990:	00003097          	auipc	ra,0x3
    2994:	d76080e7          	jalr	-650(ra) # 5706 <pipe>
    2998:	e521                	bnez	a0,29e0 <sbrkarg+0xbc>
}
    299a:	70a2                	ld	ra,40(sp)
    299c:	7402                	ld	s0,32(sp)
    299e:	64e2                	ld	s1,24(sp)
    29a0:	6942                	ld	s2,16(sp)
    29a2:	69a2                	ld	s3,8(sp)
    29a4:	6145                	addi	sp,sp,48
    29a6:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    29a8:	85ce                	mv	a1,s3
    29aa:	00004517          	auipc	a0,0x4
    29ae:	5de50513          	addi	a0,a0,1502 # 6f88 <malloc+0x1452>
    29b2:	00003097          	auipc	ra,0x3
    29b6:	0c4080e7          	jalr	196(ra) # 5a76 <printf>
    exit(1);
    29ba:	4505                	li	a0,1
    29bc:	00003097          	auipc	ra,0x3
    29c0:	d3a080e7          	jalr	-710(ra) # 56f6 <exit>
    printf("%s: write sbrk failed\n", s);
    29c4:	85ce                	mv	a1,s3
    29c6:	00004517          	auipc	a0,0x4
    29ca:	5da50513          	addi	a0,a0,1498 # 6fa0 <malloc+0x146a>
    29ce:	00003097          	auipc	ra,0x3
    29d2:	0a8080e7          	jalr	168(ra) # 5a76 <printf>
    exit(1);
    29d6:	4505                	li	a0,1
    29d8:	00003097          	auipc	ra,0x3
    29dc:	d1e080e7          	jalr	-738(ra) # 56f6 <exit>
    printf("%s: pipe() failed\n", s);
    29e0:	85ce                	mv	a1,s3
    29e2:	00004517          	auipc	a0,0x4
    29e6:	fb650513          	addi	a0,a0,-74 # 6998 <malloc+0xe62>
    29ea:	00003097          	auipc	ra,0x3
    29ee:	08c080e7          	jalr	140(ra) # 5a76 <printf>
    exit(1);
    29f2:	4505                	li	a0,1
    29f4:	00003097          	auipc	ra,0x3
    29f8:	d02080e7          	jalr	-766(ra) # 56f6 <exit>

00000000000029fc <argptest>:
{
    29fc:	1101                	addi	sp,sp,-32
    29fe:	ec06                	sd	ra,24(sp)
    2a00:	e822                	sd	s0,16(sp)
    2a02:	e426                	sd	s1,8(sp)
    2a04:	e04a                	sd	s2,0(sp)
    2a06:	1000                	addi	s0,sp,32
    2a08:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2a0a:	4581                	li	a1,0
    2a0c:	00004517          	auipc	a0,0x4
    2a10:	5ac50513          	addi	a0,a0,1452 # 6fb8 <malloc+0x1482>
    2a14:	00003097          	auipc	ra,0x3
    2a18:	d22080e7          	jalr	-734(ra) # 5736 <open>
  if (fd < 0) {
    2a1c:	02054b63          	bltz	a0,2a52 <argptest+0x56>
    2a20:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2a22:	4501                	li	a0,0
    2a24:	00003097          	auipc	ra,0x3
    2a28:	d5a080e7          	jalr	-678(ra) # 577e <sbrk>
    2a2c:	567d                	li	a2,-1
    2a2e:	fff50593          	addi	a1,a0,-1
    2a32:	8526                	mv	a0,s1
    2a34:	00003097          	auipc	ra,0x3
    2a38:	cda080e7          	jalr	-806(ra) # 570e <read>
  close(fd);
    2a3c:	8526                	mv	a0,s1
    2a3e:	00003097          	auipc	ra,0x3
    2a42:	ce0080e7          	jalr	-800(ra) # 571e <close>
}
    2a46:	60e2                	ld	ra,24(sp)
    2a48:	6442                	ld	s0,16(sp)
    2a4a:	64a2                	ld	s1,8(sp)
    2a4c:	6902                	ld	s2,0(sp)
    2a4e:	6105                	addi	sp,sp,32
    2a50:	8082                	ret
    printf("%s: open failed\n", s);
    2a52:	85ca                	mv	a1,s2
    2a54:	00004517          	auipc	a0,0x4
    2a58:	e5450513          	addi	a0,a0,-428 # 68a8 <malloc+0xd72>
    2a5c:	00003097          	auipc	ra,0x3
    2a60:	01a080e7          	jalr	26(ra) # 5a76 <printf>
    exit(1);
    2a64:	4505                	li	a0,1
    2a66:	00003097          	auipc	ra,0x3
    2a6a:	c90080e7          	jalr	-880(ra) # 56f6 <exit>

0000000000002a6e <sbrkbugs>:
{
    2a6e:	1141                	addi	sp,sp,-16
    2a70:	e406                	sd	ra,8(sp)
    2a72:	e022                	sd	s0,0(sp)
    2a74:	0800                	addi	s0,sp,16
  int pid = fork();
    2a76:	00003097          	auipc	ra,0x3
    2a7a:	c78080e7          	jalr	-904(ra) # 56ee <fork>
  if(pid < 0){
    2a7e:	02054363          	bltz	a0,2aa4 <sbrkbugs+0x36>
  if(pid == 0){
    2a82:	ed15                	bnez	a0,2abe <sbrkbugs+0x50>
    int sz = (uint64) sbrk(0);
    2a84:	00003097          	auipc	ra,0x3
    2a88:	cfa080e7          	jalr	-774(ra) # 577e <sbrk>
    sbrk(-sz);
    2a8c:	40a0053b          	negw	a0,a0
    2a90:	2501                	sext.w	a0,a0
    2a92:	00003097          	auipc	ra,0x3
    2a96:	cec080e7          	jalr	-788(ra) # 577e <sbrk>
    exit(0);
    2a9a:	4501                	li	a0,0
    2a9c:	00003097          	auipc	ra,0x3
    2aa0:	c5a080e7          	jalr	-934(ra) # 56f6 <exit>
    printf("fork failed\n");
    2aa4:	00004517          	auipc	a0,0x4
    2aa8:	1f450513          	addi	a0,a0,500 # 6c98 <malloc+0x1162>
    2aac:	00003097          	auipc	ra,0x3
    2ab0:	fca080e7          	jalr	-54(ra) # 5a76 <printf>
    exit(1);
    2ab4:	4505                	li	a0,1
    2ab6:	00003097          	auipc	ra,0x3
    2aba:	c40080e7          	jalr	-960(ra) # 56f6 <exit>
  wait(0);
    2abe:	4501                	li	a0,0
    2ac0:	00003097          	auipc	ra,0x3
    2ac4:	c3e080e7          	jalr	-962(ra) # 56fe <wait>
  pid = fork();
    2ac8:	00003097          	auipc	ra,0x3
    2acc:	c26080e7          	jalr	-986(ra) # 56ee <fork>
  if(pid < 0){
    2ad0:	02054563          	bltz	a0,2afa <sbrkbugs+0x8c>
  if(pid == 0){
    2ad4:	e121                	bnez	a0,2b14 <sbrkbugs+0xa6>
    int sz = (uint64) sbrk(0);
    2ad6:	00003097          	auipc	ra,0x3
    2ada:	ca8080e7          	jalr	-856(ra) # 577e <sbrk>
    sbrk(-(sz - 3500));
    2ade:	6785                	lui	a5,0x1
    2ae0:	dac7879b          	addiw	a5,a5,-596
    2ae4:	40a7853b          	subw	a0,a5,a0
    2ae8:	00003097          	auipc	ra,0x3
    2aec:	c96080e7          	jalr	-874(ra) # 577e <sbrk>
    exit(0);
    2af0:	4501                	li	a0,0
    2af2:	00003097          	auipc	ra,0x3
    2af6:	c04080e7          	jalr	-1020(ra) # 56f6 <exit>
    printf("fork failed\n");
    2afa:	00004517          	auipc	a0,0x4
    2afe:	19e50513          	addi	a0,a0,414 # 6c98 <malloc+0x1162>
    2b02:	00003097          	auipc	ra,0x3
    2b06:	f74080e7          	jalr	-140(ra) # 5a76 <printf>
    exit(1);
    2b0a:	4505                	li	a0,1
    2b0c:	00003097          	auipc	ra,0x3
    2b10:	bea080e7          	jalr	-1046(ra) # 56f6 <exit>
  wait(0);
    2b14:	4501                	li	a0,0
    2b16:	00003097          	auipc	ra,0x3
    2b1a:	be8080e7          	jalr	-1048(ra) # 56fe <wait>
  pid = fork();
    2b1e:	00003097          	auipc	ra,0x3
    2b22:	bd0080e7          	jalr	-1072(ra) # 56ee <fork>
  if(pid < 0){
    2b26:	02054a63          	bltz	a0,2b5a <sbrkbugs+0xec>
  if(pid == 0){
    2b2a:	e529                	bnez	a0,2b74 <sbrkbugs+0x106>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2b2c:	00003097          	auipc	ra,0x3
    2b30:	c52080e7          	jalr	-942(ra) # 577e <sbrk>
    2b34:	67ad                	lui	a5,0xb
    2b36:	8007879b          	addiw	a5,a5,-2048
    2b3a:	40a7853b          	subw	a0,a5,a0
    2b3e:	00003097          	auipc	ra,0x3
    2b42:	c40080e7          	jalr	-960(ra) # 577e <sbrk>
    sbrk(-10);
    2b46:	5559                	li	a0,-10
    2b48:	00003097          	auipc	ra,0x3
    2b4c:	c36080e7          	jalr	-970(ra) # 577e <sbrk>
    exit(0);
    2b50:	4501                	li	a0,0
    2b52:	00003097          	auipc	ra,0x3
    2b56:	ba4080e7          	jalr	-1116(ra) # 56f6 <exit>
    printf("fork failed\n");
    2b5a:	00004517          	auipc	a0,0x4
    2b5e:	13e50513          	addi	a0,a0,318 # 6c98 <malloc+0x1162>
    2b62:	00003097          	auipc	ra,0x3
    2b66:	f14080e7          	jalr	-236(ra) # 5a76 <printf>
    exit(1);
    2b6a:	4505                	li	a0,1
    2b6c:	00003097          	auipc	ra,0x3
    2b70:	b8a080e7          	jalr	-1142(ra) # 56f6 <exit>
  wait(0);
    2b74:	4501                	li	a0,0
    2b76:	00003097          	auipc	ra,0x3
    2b7a:	b88080e7          	jalr	-1144(ra) # 56fe <wait>
  exit(0);
    2b7e:	4501                	li	a0,0
    2b80:	00003097          	auipc	ra,0x3
    2b84:	b76080e7          	jalr	-1162(ra) # 56f6 <exit>

0000000000002b88 <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    2b88:	715d                	addi	sp,sp,-80
    2b8a:	e486                	sd	ra,72(sp)
    2b8c:	e0a2                	sd	s0,64(sp)
    2b8e:	fc26                	sd	s1,56(sp)
    2b90:	f84a                	sd	s2,48(sp)
    2b92:	f44e                	sd	s3,40(sp)
    2b94:	f052                	sd	s4,32(sp)
    2b96:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2b98:	4901                	li	s2,0
    2b9a:	49bd                	li	s3,15
    int pid = fork();
    2b9c:	00003097          	auipc	ra,0x3
    2ba0:	b52080e7          	jalr	-1198(ra) # 56ee <fork>
    2ba4:	84aa                	mv	s1,a0
    if(pid < 0){
    2ba6:	02054063          	bltz	a0,2bc6 <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    2baa:	c91d                	beqz	a0,2be0 <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    2bac:	4501                	li	a0,0
    2bae:	00003097          	auipc	ra,0x3
    2bb2:	b50080e7          	jalr	-1200(ra) # 56fe <wait>
  for(int avail = 0; avail < 15; avail++){
    2bb6:	2905                	addiw	s2,s2,1
    2bb8:	ff3912e3          	bne	s2,s3,2b9c <execout+0x14>
    }
  }

  exit(0);
    2bbc:	4501                	li	a0,0
    2bbe:	00003097          	auipc	ra,0x3
    2bc2:	b38080e7          	jalr	-1224(ra) # 56f6 <exit>
      printf("fork failed\n");
    2bc6:	00004517          	auipc	a0,0x4
    2bca:	0d250513          	addi	a0,a0,210 # 6c98 <malloc+0x1162>
    2bce:	00003097          	auipc	ra,0x3
    2bd2:	ea8080e7          	jalr	-344(ra) # 5a76 <printf>
      exit(1);
    2bd6:	4505                	li	a0,1
    2bd8:	00003097          	auipc	ra,0x3
    2bdc:	b1e080e7          	jalr	-1250(ra) # 56f6 <exit>
        if(a == 0xffffffffffffffffLL)
    2be0:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2be2:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2be4:	6505                	lui	a0,0x1
    2be6:	00003097          	auipc	ra,0x3
    2bea:	b98080e7          	jalr	-1128(ra) # 577e <sbrk>
        if(a == 0xffffffffffffffffLL)
    2bee:	01350763          	beq	a0,s3,2bfc <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2bf2:	6785                	lui	a5,0x1
    2bf4:	97aa                	add	a5,a5,a0
    2bf6:	ff478fa3          	sb	s4,-1(a5) # fff <bigdir+0x89>
      while(1){
    2bfa:	b7ed                	j	2be4 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2bfc:	01205a63          	blez	s2,2c10 <execout+0x88>
        sbrk(-4096);
    2c00:	757d                	lui	a0,0xfffff
    2c02:	00003097          	auipc	ra,0x3
    2c06:	b7c080e7          	jalr	-1156(ra) # 577e <sbrk>
      for(int i = 0; i < avail; i++)
    2c0a:	2485                	addiw	s1,s1,1
    2c0c:	ff249ae3          	bne	s1,s2,2c00 <execout+0x78>
      close(1);
    2c10:	4505                	li	a0,1
    2c12:	00003097          	auipc	ra,0x3
    2c16:	b0c080e7          	jalr	-1268(ra) # 571e <close>
      char *args[] = { "echo", "x", 0 };
    2c1a:	00003517          	auipc	a0,0x3
    2c1e:	41e50513          	addi	a0,a0,1054 # 6038 <malloc+0x502>
    2c22:	faa43c23          	sd	a0,-72(s0)
    2c26:	00003797          	auipc	a5,0x3
    2c2a:	48278793          	addi	a5,a5,1154 # 60a8 <malloc+0x572>
    2c2e:	fcf43023          	sd	a5,-64(s0)
    2c32:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2c36:	fb840593          	addi	a1,s0,-72
    2c3a:	00003097          	auipc	ra,0x3
    2c3e:	af4080e7          	jalr	-1292(ra) # 572e <exec>
      exit(0);
    2c42:	4501                	li	a0,0
    2c44:	00003097          	auipc	ra,0x3
    2c48:	ab2080e7          	jalr	-1358(ra) # 56f6 <exit>

0000000000002c4c <fourteen>:
{
    2c4c:	1101                	addi	sp,sp,-32
    2c4e:	ec06                	sd	ra,24(sp)
    2c50:	e822                	sd	s0,16(sp)
    2c52:	e426                	sd	s1,8(sp)
    2c54:	1000                	addi	s0,sp,32
    2c56:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2c58:	00004517          	auipc	a0,0x4
    2c5c:	53850513          	addi	a0,a0,1336 # 7190 <malloc+0x165a>
    2c60:	00003097          	auipc	ra,0x3
    2c64:	afe080e7          	jalr	-1282(ra) # 575e <mkdir>
    2c68:	e165                	bnez	a0,2d48 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2c6a:	00004517          	auipc	a0,0x4
    2c6e:	37e50513          	addi	a0,a0,894 # 6fe8 <malloc+0x14b2>
    2c72:	00003097          	auipc	ra,0x3
    2c76:	aec080e7          	jalr	-1300(ra) # 575e <mkdir>
    2c7a:	e56d                	bnez	a0,2d64 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2c7c:	20000593          	li	a1,512
    2c80:	00004517          	auipc	a0,0x4
    2c84:	3c050513          	addi	a0,a0,960 # 7040 <malloc+0x150a>
    2c88:	00003097          	auipc	ra,0x3
    2c8c:	aae080e7          	jalr	-1362(ra) # 5736 <open>
  if(fd < 0){
    2c90:	0e054863          	bltz	a0,2d80 <fourteen+0x134>
  close(fd);
    2c94:	00003097          	auipc	ra,0x3
    2c98:	a8a080e7          	jalr	-1398(ra) # 571e <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2c9c:	4581                	li	a1,0
    2c9e:	00004517          	auipc	a0,0x4
    2ca2:	41a50513          	addi	a0,a0,1050 # 70b8 <malloc+0x1582>
    2ca6:	00003097          	auipc	ra,0x3
    2caa:	a90080e7          	jalr	-1392(ra) # 5736 <open>
  if(fd < 0){
    2cae:	0e054763          	bltz	a0,2d9c <fourteen+0x150>
  close(fd);
    2cb2:	00003097          	auipc	ra,0x3
    2cb6:	a6c080e7          	jalr	-1428(ra) # 571e <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2cba:	00004517          	auipc	a0,0x4
    2cbe:	46e50513          	addi	a0,a0,1134 # 7128 <malloc+0x15f2>
    2cc2:	00003097          	auipc	ra,0x3
    2cc6:	a9c080e7          	jalr	-1380(ra) # 575e <mkdir>
    2cca:	c57d                	beqz	a0,2db8 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2ccc:	00004517          	auipc	a0,0x4
    2cd0:	4b450513          	addi	a0,a0,1204 # 7180 <malloc+0x164a>
    2cd4:	00003097          	auipc	ra,0x3
    2cd8:	a8a080e7          	jalr	-1398(ra) # 575e <mkdir>
    2cdc:	cd65                	beqz	a0,2dd4 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2cde:	00004517          	auipc	a0,0x4
    2ce2:	4a250513          	addi	a0,a0,1186 # 7180 <malloc+0x164a>
    2ce6:	00003097          	auipc	ra,0x3
    2cea:	a60080e7          	jalr	-1440(ra) # 5746 <unlink>
  unlink("12345678901234/12345678901234");
    2cee:	00004517          	auipc	a0,0x4
    2cf2:	43a50513          	addi	a0,a0,1082 # 7128 <malloc+0x15f2>
    2cf6:	00003097          	auipc	ra,0x3
    2cfa:	a50080e7          	jalr	-1456(ra) # 5746 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2cfe:	00004517          	auipc	a0,0x4
    2d02:	3ba50513          	addi	a0,a0,954 # 70b8 <malloc+0x1582>
    2d06:	00003097          	auipc	ra,0x3
    2d0a:	a40080e7          	jalr	-1472(ra) # 5746 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2d0e:	00004517          	auipc	a0,0x4
    2d12:	33250513          	addi	a0,a0,818 # 7040 <malloc+0x150a>
    2d16:	00003097          	auipc	ra,0x3
    2d1a:	a30080e7          	jalr	-1488(ra) # 5746 <unlink>
  unlink("12345678901234/123456789012345");
    2d1e:	00004517          	auipc	a0,0x4
    2d22:	2ca50513          	addi	a0,a0,714 # 6fe8 <malloc+0x14b2>
    2d26:	00003097          	auipc	ra,0x3
    2d2a:	a20080e7          	jalr	-1504(ra) # 5746 <unlink>
  unlink("12345678901234");
    2d2e:	00004517          	auipc	a0,0x4
    2d32:	46250513          	addi	a0,a0,1122 # 7190 <malloc+0x165a>
    2d36:	00003097          	auipc	ra,0x3
    2d3a:	a10080e7          	jalr	-1520(ra) # 5746 <unlink>
}
    2d3e:	60e2                	ld	ra,24(sp)
    2d40:	6442                	ld	s0,16(sp)
    2d42:	64a2                	ld	s1,8(sp)
    2d44:	6105                	addi	sp,sp,32
    2d46:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2d48:	85a6                	mv	a1,s1
    2d4a:	00004517          	auipc	a0,0x4
    2d4e:	27650513          	addi	a0,a0,630 # 6fc0 <malloc+0x148a>
    2d52:	00003097          	auipc	ra,0x3
    2d56:	d24080e7          	jalr	-732(ra) # 5a76 <printf>
    exit(1);
    2d5a:	4505                	li	a0,1
    2d5c:	00003097          	auipc	ra,0x3
    2d60:	99a080e7          	jalr	-1638(ra) # 56f6 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2d64:	85a6                	mv	a1,s1
    2d66:	00004517          	auipc	a0,0x4
    2d6a:	2a250513          	addi	a0,a0,674 # 7008 <malloc+0x14d2>
    2d6e:	00003097          	auipc	ra,0x3
    2d72:	d08080e7          	jalr	-760(ra) # 5a76 <printf>
    exit(1);
    2d76:	4505                	li	a0,1
    2d78:	00003097          	auipc	ra,0x3
    2d7c:	97e080e7          	jalr	-1666(ra) # 56f6 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2d80:	85a6                	mv	a1,s1
    2d82:	00004517          	auipc	a0,0x4
    2d86:	2ee50513          	addi	a0,a0,750 # 7070 <malloc+0x153a>
    2d8a:	00003097          	auipc	ra,0x3
    2d8e:	cec080e7          	jalr	-788(ra) # 5a76 <printf>
    exit(1);
    2d92:	4505                	li	a0,1
    2d94:	00003097          	auipc	ra,0x3
    2d98:	962080e7          	jalr	-1694(ra) # 56f6 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2d9c:	85a6                	mv	a1,s1
    2d9e:	00004517          	auipc	a0,0x4
    2da2:	34a50513          	addi	a0,a0,842 # 70e8 <malloc+0x15b2>
    2da6:	00003097          	auipc	ra,0x3
    2daa:	cd0080e7          	jalr	-816(ra) # 5a76 <printf>
    exit(1);
    2dae:	4505                	li	a0,1
    2db0:	00003097          	auipc	ra,0x3
    2db4:	946080e7          	jalr	-1722(ra) # 56f6 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2db8:	85a6                	mv	a1,s1
    2dba:	00004517          	auipc	a0,0x4
    2dbe:	38e50513          	addi	a0,a0,910 # 7148 <malloc+0x1612>
    2dc2:	00003097          	auipc	ra,0x3
    2dc6:	cb4080e7          	jalr	-844(ra) # 5a76 <printf>
    exit(1);
    2dca:	4505                	li	a0,1
    2dcc:	00003097          	auipc	ra,0x3
    2dd0:	92a080e7          	jalr	-1750(ra) # 56f6 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2dd4:	85a6                	mv	a1,s1
    2dd6:	00004517          	auipc	a0,0x4
    2dda:	3ca50513          	addi	a0,a0,970 # 71a0 <malloc+0x166a>
    2dde:	00003097          	auipc	ra,0x3
    2de2:	c98080e7          	jalr	-872(ra) # 5a76 <printf>
    exit(1);
    2de6:	4505                	li	a0,1
    2de8:	00003097          	auipc	ra,0x3
    2dec:	90e080e7          	jalr	-1778(ra) # 56f6 <exit>

0000000000002df0 <iputtest>:
{
    2df0:	1101                	addi	sp,sp,-32
    2df2:	ec06                	sd	ra,24(sp)
    2df4:	e822                	sd	s0,16(sp)
    2df6:	e426                	sd	s1,8(sp)
    2df8:	1000                	addi	s0,sp,32
    2dfa:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2dfc:	00004517          	auipc	a0,0x4
    2e00:	3dc50513          	addi	a0,a0,988 # 71d8 <malloc+0x16a2>
    2e04:	00003097          	auipc	ra,0x3
    2e08:	95a080e7          	jalr	-1702(ra) # 575e <mkdir>
    2e0c:	04054563          	bltz	a0,2e56 <iputtest+0x66>
  if(chdir("iputdir") < 0){
    2e10:	00004517          	auipc	a0,0x4
    2e14:	3c850513          	addi	a0,a0,968 # 71d8 <malloc+0x16a2>
    2e18:	00003097          	auipc	ra,0x3
    2e1c:	94e080e7          	jalr	-1714(ra) # 5766 <chdir>
    2e20:	04054963          	bltz	a0,2e72 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    2e24:	00004517          	auipc	a0,0x4
    2e28:	3f450513          	addi	a0,a0,1012 # 7218 <malloc+0x16e2>
    2e2c:	00003097          	auipc	ra,0x3
    2e30:	91a080e7          	jalr	-1766(ra) # 5746 <unlink>
    2e34:	04054d63          	bltz	a0,2e8e <iputtest+0x9e>
  if(chdir("/") < 0){
    2e38:	00004517          	auipc	a0,0x4
    2e3c:	41050513          	addi	a0,a0,1040 # 7248 <malloc+0x1712>
    2e40:	00003097          	auipc	ra,0x3
    2e44:	926080e7          	jalr	-1754(ra) # 5766 <chdir>
    2e48:	06054163          	bltz	a0,2eaa <iputtest+0xba>
}
    2e4c:	60e2                	ld	ra,24(sp)
    2e4e:	6442                	ld	s0,16(sp)
    2e50:	64a2                	ld	s1,8(sp)
    2e52:	6105                	addi	sp,sp,32
    2e54:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2e56:	85a6                	mv	a1,s1
    2e58:	00004517          	auipc	a0,0x4
    2e5c:	38850513          	addi	a0,a0,904 # 71e0 <malloc+0x16aa>
    2e60:	00003097          	auipc	ra,0x3
    2e64:	c16080e7          	jalr	-1002(ra) # 5a76 <printf>
    exit(1);
    2e68:	4505                	li	a0,1
    2e6a:	00003097          	auipc	ra,0x3
    2e6e:	88c080e7          	jalr	-1908(ra) # 56f6 <exit>
    printf("%s: chdir iputdir failed\n", s);
    2e72:	85a6                	mv	a1,s1
    2e74:	00004517          	auipc	a0,0x4
    2e78:	38450513          	addi	a0,a0,900 # 71f8 <malloc+0x16c2>
    2e7c:	00003097          	auipc	ra,0x3
    2e80:	bfa080e7          	jalr	-1030(ra) # 5a76 <printf>
    exit(1);
    2e84:	4505                	li	a0,1
    2e86:	00003097          	auipc	ra,0x3
    2e8a:	870080e7          	jalr	-1936(ra) # 56f6 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2e8e:	85a6                	mv	a1,s1
    2e90:	00004517          	auipc	a0,0x4
    2e94:	39850513          	addi	a0,a0,920 # 7228 <malloc+0x16f2>
    2e98:	00003097          	auipc	ra,0x3
    2e9c:	bde080e7          	jalr	-1058(ra) # 5a76 <printf>
    exit(1);
    2ea0:	4505                	li	a0,1
    2ea2:	00003097          	auipc	ra,0x3
    2ea6:	854080e7          	jalr	-1964(ra) # 56f6 <exit>
    printf("%s: chdir / failed\n", s);
    2eaa:	85a6                	mv	a1,s1
    2eac:	00004517          	auipc	a0,0x4
    2eb0:	3a450513          	addi	a0,a0,932 # 7250 <malloc+0x171a>
    2eb4:	00003097          	auipc	ra,0x3
    2eb8:	bc2080e7          	jalr	-1086(ra) # 5a76 <printf>
    exit(1);
    2ebc:	4505                	li	a0,1
    2ebe:	00003097          	auipc	ra,0x3
    2ec2:	838080e7          	jalr	-1992(ra) # 56f6 <exit>

0000000000002ec6 <exitiputtest>:
{
    2ec6:	7179                	addi	sp,sp,-48
    2ec8:	f406                	sd	ra,40(sp)
    2eca:	f022                	sd	s0,32(sp)
    2ecc:	ec26                	sd	s1,24(sp)
    2ece:	1800                	addi	s0,sp,48
    2ed0:	84aa                	mv	s1,a0
  pid = fork();
    2ed2:	00003097          	auipc	ra,0x3
    2ed6:	81c080e7          	jalr	-2020(ra) # 56ee <fork>
  if(pid < 0){
    2eda:	04054663          	bltz	a0,2f26 <exitiputtest+0x60>
  if(pid == 0){
    2ede:	ed45                	bnez	a0,2f96 <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    2ee0:	00004517          	auipc	a0,0x4
    2ee4:	2f850513          	addi	a0,a0,760 # 71d8 <malloc+0x16a2>
    2ee8:	00003097          	auipc	ra,0x3
    2eec:	876080e7          	jalr	-1930(ra) # 575e <mkdir>
    2ef0:	04054963          	bltz	a0,2f42 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    2ef4:	00004517          	auipc	a0,0x4
    2ef8:	2e450513          	addi	a0,a0,740 # 71d8 <malloc+0x16a2>
    2efc:	00003097          	auipc	ra,0x3
    2f00:	86a080e7          	jalr	-1942(ra) # 5766 <chdir>
    2f04:	04054d63          	bltz	a0,2f5e <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    2f08:	00004517          	auipc	a0,0x4
    2f0c:	31050513          	addi	a0,a0,784 # 7218 <malloc+0x16e2>
    2f10:	00003097          	auipc	ra,0x3
    2f14:	836080e7          	jalr	-1994(ra) # 5746 <unlink>
    2f18:	06054163          	bltz	a0,2f7a <exitiputtest+0xb4>
    exit(0);
    2f1c:	4501                	li	a0,0
    2f1e:	00002097          	auipc	ra,0x2
    2f22:	7d8080e7          	jalr	2008(ra) # 56f6 <exit>
    printf("%s: fork failed\n", s);
    2f26:	85a6                	mv	a1,s1
    2f28:	00004517          	auipc	a0,0x4
    2f2c:	96850513          	addi	a0,a0,-1688 # 6890 <malloc+0xd5a>
    2f30:	00003097          	auipc	ra,0x3
    2f34:	b46080e7          	jalr	-1210(ra) # 5a76 <printf>
    exit(1);
    2f38:	4505                	li	a0,1
    2f3a:	00002097          	auipc	ra,0x2
    2f3e:	7bc080e7          	jalr	1980(ra) # 56f6 <exit>
      printf("%s: mkdir failed\n", s);
    2f42:	85a6                	mv	a1,s1
    2f44:	00004517          	auipc	a0,0x4
    2f48:	29c50513          	addi	a0,a0,668 # 71e0 <malloc+0x16aa>
    2f4c:	00003097          	auipc	ra,0x3
    2f50:	b2a080e7          	jalr	-1238(ra) # 5a76 <printf>
      exit(1);
    2f54:	4505                	li	a0,1
    2f56:	00002097          	auipc	ra,0x2
    2f5a:	7a0080e7          	jalr	1952(ra) # 56f6 <exit>
      printf("%s: child chdir failed\n", s);
    2f5e:	85a6                	mv	a1,s1
    2f60:	00004517          	auipc	a0,0x4
    2f64:	30850513          	addi	a0,a0,776 # 7268 <malloc+0x1732>
    2f68:	00003097          	auipc	ra,0x3
    2f6c:	b0e080e7          	jalr	-1266(ra) # 5a76 <printf>
      exit(1);
    2f70:	4505                	li	a0,1
    2f72:	00002097          	auipc	ra,0x2
    2f76:	784080e7          	jalr	1924(ra) # 56f6 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2f7a:	85a6                	mv	a1,s1
    2f7c:	00004517          	auipc	a0,0x4
    2f80:	2ac50513          	addi	a0,a0,684 # 7228 <malloc+0x16f2>
    2f84:	00003097          	auipc	ra,0x3
    2f88:	af2080e7          	jalr	-1294(ra) # 5a76 <printf>
      exit(1);
    2f8c:	4505                	li	a0,1
    2f8e:	00002097          	auipc	ra,0x2
    2f92:	768080e7          	jalr	1896(ra) # 56f6 <exit>
  wait(&xstatus);
    2f96:	fdc40513          	addi	a0,s0,-36
    2f9a:	00002097          	auipc	ra,0x2
    2f9e:	764080e7          	jalr	1892(ra) # 56fe <wait>
  exit(xstatus);
    2fa2:	fdc42503          	lw	a0,-36(s0)
    2fa6:	00002097          	auipc	ra,0x2
    2faa:	750080e7          	jalr	1872(ra) # 56f6 <exit>

0000000000002fae <dirtest>:
{
    2fae:	1101                	addi	sp,sp,-32
    2fb0:	ec06                	sd	ra,24(sp)
    2fb2:	e822                	sd	s0,16(sp)
    2fb4:	e426                	sd	s1,8(sp)
    2fb6:	1000                	addi	s0,sp,32
    2fb8:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2fba:	00004517          	auipc	a0,0x4
    2fbe:	2c650513          	addi	a0,a0,710 # 7280 <malloc+0x174a>
    2fc2:	00002097          	auipc	ra,0x2
    2fc6:	79c080e7          	jalr	1948(ra) # 575e <mkdir>
    2fca:	04054563          	bltz	a0,3014 <dirtest+0x66>
  if(chdir("dir0") < 0){
    2fce:	00004517          	auipc	a0,0x4
    2fd2:	2b250513          	addi	a0,a0,690 # 7280 <malloc+0x174a>
    2fd6:	00002097          	auipc	ra,0x2
    2fda:	790080e7          	jalr	1936(ra) # 5766 <chdir>
    2fde:	04054963          	bltz	a0,3030 <dirtest+0x82>
  if(chdir("..") < 0){
    2fe2:	00004517          	auipc	a0,0x4
    2fe6:	2be50513          	addi	a0,a0,702 # 72a0 <malloc+0x176a>
    2fea:	00002097          	auipc	ra,0x2
    2fee:	77c080e7          	jalr	1916(ra) # 5766 <chdir>
    2ff2:	04054d63          	bltz	a0,304c <dirtest+0x9e>
  if(unlink("dir0") < 0){
    2ff6:	00004517          	auipc	a0,0x4
    2ffa:	28a50513          	addi	a0,a0,650 # 7280 <malloc+0x174a>
    2ffe:	00002097          	auipc	ra,0x2
    3002:	748080e7          	jalr	1864(ra) # 5746 <unlink>
    3006:	06054163          	bltz	a0,3068 <dirtest+0xba>
}
    300a:	60e2                	ld	ra,24(sp)
    300c:	6442                	ld	s0,16(sp)
    300e:	64a2                	ld	s1,8(sp)
    3010:	6105                	addi	sp,sp,32
    3012:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3014:	85a6                	mv	a1,s1
    3016:	00004517          	auipc	a0,0x4
    301a:	1ca50513          	addi	a0,a0,458 # 71e0 <malloc+0x16aa>
    301e:	00003097          	auipc	ra,0x3
    3022:	a58080e7          	jalr	-1448(ra) # 5a76 <printf>
    exit(1);
    3026:	4505                	li	a0,1
    3028:	00002097          	auipc	ra,0x2
    302c:	6ce080e7          	jalr	1742(ra) # 56f6 <exit>
    printf("%s: chdir dir0 failed\n", s);
    3030:	85a6                	mv	a1,s1
    3032:	00004517          	auipc	a0,0x4
    3036:	25650513          	addi	a0,a0,598 # 7288 <malloc+0x1752>
    303a:	00003097          	auipc	ra,0x3
    303e:	a3c080e7          	jalr	-1476(ra) # 5a76 <printf>
    exit(1);
    3042:	4505                	li	a0,1
    3044:	00002097          	auipc	ra,0x2
    3048:	6b2080e7          	jalr	1714(ra) # 56f6 <exit>
    printf("%s: chdir .. failed\n", s);
    304c:	85a6                	mv	a1,s1
    304e:	00004517          	auipc	a0,0x4
    3052:	25a50513          	addi	a0,a0,602 # 72a8 <malloc+0x1772>
    3056:	00003097          	auipc	ra,0x3
    305a:	a20080e7          	jalr	-1504(ra) # 5a76 <printf>
    exit(1);
    305e:	4505                	li	a0,1
    3060:	00002097          	auipc	ra,0x2
    3064:	696080e7          	jalr	1686(ra) # 56f6 <exit>
    printf("%s: unlink dir0 failed\n", s);
    3068:	85a6                	mv	a1,s1
    306a:	00004517          	auipc	a0,0x4
    306e:	25650513          	addi	a0,a0,598 # 72c0 <malloc+0x178a>
    3072:	00003097          	auipc	ra,0x3
    3076:	a04080e7          	jalr	-1532(ra) # 5a76 <printf>
    exit(1);
    307a:	4505                	li	a0,1
    307c:	00002097          	auipc	ra,0x2
    3080:	67a080e7          	jalr	1658(ra) # 56f6 <exit>

0000000000003084 <subdir>:
{
    3084:	1101                	addi	sp,sp,-32
    3086:	ec06                	sd	ra,24(sp)
    3088:	e822                	sd	s0,16(sp)
    308a:	e426                	sd	s1,8(sp)
    308c:	e04a                	sd	s2,0(sp)
    308e:	1000                	addi	s0,sp,32
    3090:	892a                	mv	s2,a0
  unlink("ff");
    3092:	00004517          	auipc	a0,0x4
    3096:	37650513          	addi	a0,a0,886 # 7408 <malloc+0x18d2>
    309a:	00002097          	auipc	ra,0x2
    309e:	6ac080e7          	jalr	1708(ra) # 5746 <unlink>
  if(mkdir("dd") != 0){
    30a2:	00004517          	auipc	a0,0x4
    30a6:	23650513          	addi	a0,a0,566 # 72d8 <malloc+0x17a2>
    30aa:	00002097          	auipc	ra,0x2
    30ae:	6b4080e7          	jalr	1716(ra) # 575e <mkdir>
    30b2:	38051663          	bnez	a0,343e <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    30b6:	20200593          	li	a1,514
    30ba:	00004517          	auipc	a0,0x4
    30be:	23e50513          	addi	a0,a0,574 # 72f8 <malloc+0x17c2>
    30c2:	00002097          	auipc	ra,0x2
    30c6:	674080e7          	jalr	1652(ra) # 5736 <open>
    30ca:	84aa                	mv	s1,a0
  if(fd < 0){
    30cc:	38054763          	bltz	a0,345a <subdir+0x3d6>
  write(fd, "ff", 2);
    30d0:	4609                	li	a2,2
    30d2:	00004597          	auipc	a1,0x4
    30d6:	33658593          	addi	a1,a1,822 # 7408 <malloc+0x18d2>
    30da:	00002097          	auipc	ra,0x2
    30de:	63c080e7          	jalr	1596(ra) # 5716 <write>
  close(fd);
    30e2:	8526                	mv	a0,s1
    30e4:	00002097          	auipc	ra,0x2
    30e8:	63a080e7          	jalr	1594(ra) # 571e <close>
  if(unlink("dd") >= 0){
    30ec:	00004517          	auipc	a0,0x4
    30f0:	1ec50513          	addi	a0,a0,492 # 72d8 <malloc+0x17a2>
    30f4:	00002097          	auipc	ra,0x2
    30f8:	652080e7          	jalr	1618(ra) # 5746 <unlink>
    30fc:	36055d63          	bgez	a0,3476 <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    3100:	00004517          	auipc	a0,0x4
    3104:	25050513          	addi	a0,a0,592 # 7350 <malloc+0x181a>
    3108:	00002097          	auipc	ra,0x2
    310c:	656080e7          	jalr	1622(ra) # 575e <mkdir>
    3110:	38051163          	bnez	a0,3492 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    3114:	20200593          	li	a1,514
    3118:	00004517          	auipc	a0,0x4
    311c:	26050513          	addi	a0,a0,608 # 7378 <malloc+0x1842>
    3120:	00002097          	auipc	ra,0x2
    3124:	616080e7          	jalr	1558(ra) # 5736 <open>
    3128:	84aa                	mv	s1,a0
  if(fd < 0){
    312a:	38054263          	bltz	a0,34ae <subdir+0x42a>
  write(fd, "FF", 2);
    312e:	4609                	li	a2,2
    3130:	00004597          	auipc	a1,0x4
    3134:	27858593          	addi	a1,a1,632 # 73a8 <malloc+0x1872>
    3138:	00002097          	auipc	ra,0x2
    313c:	5de080e7          	jalr	1502(ra) # 5716 <write>
  close(fd);
    3140:	8526                	mv	a0,s1
    3142:	00002097          	auipc	ra,0x2
    3146:	5dc080e7          	jalr	1500(ra) # 571e <close>
  fd = open("dd/dd/../ff", 0);
    314a:	4581                	li	a1,0
    314c:	00004517          	auipc	a0,0x4
    3150:	26450513          	addi	a0,a0,612 # 73b0 <malloc+0x187a>
    3154:	00002097          	auipc	ra,0x2
    3158:	5e2080e7          	jalr	1506(ra) # 5736 <open>
    315c:	84aa                	mv	s1,a0
  if(fd < 0){
    315e:	36054663          	bltz	a0,34ca <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    3162:	660d                	lui	a2,0x3
    3164:	00009597          	auipc	a1,0x9
    3168:	a6c58593          	addi	a1,a1,-1428 # bbd0 <buf>
    316c:	00002097          	auipc	ra,0x2
    3170:	5a2080e7          	jalr	1442(ra) # 570e <read>
  if(cc != 2 || buf[0] != 'f'){
    3174:	4789                	li	a5,2
    3176:	36f51863          	bne	a0,a5,34e6 <subdir+0x462>
    317a:	00009717          	auipc	a4,0x9
    317e:	a5674703          	lbu	a4,-1450(a4) # bbd0 <buf>
    3182:	06600793          	li	a5,102
    3186:	36f71063          	bne	a4,a5,34e6 <subdir+0x462>
  close(fd);
    318a:	8526                	mv	a0,s1
    318c:	00002097          	auipc	ra,0x2
    3190:	592080e7          	jalr	1426(ra) # 571e <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3194:	00004597          	auipc	a1,0x4
    3198:	26c58593          	addi	a1,a1,620 # 7400 <malloc+0x18ca>
    319c:	00004517          	auipc	a0,0x4
    31a0:	1dc50513          	addi	a0,a0,476 # 7378 <malloc+0x1842>
    31a4:	00002097          	auipc	ra,0x2
    31a8:	5b2080e7          	jalr	1458(ra) # 5756 <link>
    31ac:	34051b63          	bnez	a0,3502 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    31b0:	00004517          	auipc	a0,0x4
    31b4:	1c850513          	addi	a0,a0,456 # 7378 <malloc+0x1842>
    31b8:	00002097          	auipc	ra,0x2
    31bc:	58e080e7          	jalr	1422(ra) # 5746 <unlink>
    31c0:	34051f63          	bnez	a0,351e <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    31c4:	4581                	li	a1,0
    31c6:	00004517          	auipc	a0,0x4
    31ca:	1b250513          	addi	a0,a0,434 # 7378 <malloc+0x1842>
    31ce:	00002097          	auipc	ra,0x2
    31d2:	568080e7          	jalr	1384(ra) # 5736 <open>
    31d6:	36055263          	bgez	a0,353a <subdir+0x4b6>
  if(chdir("dd") != 0){
    31da:	00004517          	auipc	a0,0x4
    31de:	0fe50513          	addi	a0,a0,254 # 72d8 <malloc+0x17a2>
    31e2:	00002097          	auipc	ra,0x2
    31e6:	584080e7          	jalr	1412(ra) # 5766 <chdir>
    31ea:	36051663          	bnez	a0,3556 <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    31ee:	00004517          	auipc	a0,0x4
    31f2:	2aa50513          	addi	a0,a0,682 # 7498 <malloc+0x1962>
    31f6:	00002097          	auipc	ra,0x2
    31fa:	570080e7          	jalr	1392(ra) # 5766 <chdir>
    31fe:	36051a63          	bnez	a0,3572 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    3202:	00004517          	auipc	a0,0x4
    3206:	2c650513          	addi	a0,a0,710 # 74c8 <malloc+0x1992>
    320a:	00002097          	auipc	ra,0x2
    320e:	55c080e7          	jalr	1372(ra) # 5766 <chdir>
    3212:	36051e63          	bnez	a0,358e <subdir+0x50a>
  if(chdir("./..") != 0){
    3216:	00004517          	auipc	a0,0x4
    321a:	2e250513          	addi	a0,a0,738 # 74f8 <malloc+0x19c2>
    321e:	00002097          	auipc	ra,0x2
    3222:	548080e7          	jalr	1352(ra) # 5766 <chdir>
    3226:	38051263          	bnez	a0,35aa <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    322a:	4581                	li	a1,0
    322c:	00004517          	auipc	a0,0x4
    3230:	1d450513          	addi	a0,a0,468 # 7400 <malloc+0x18ca>
    3234:	00002097          	auipc	ra,0x2
    3238:	502080e7          	jalr	1282(ra) # 5736 <open>
    323c:	84aa                	mv	s1,a0
  if(fd < 0){
    323e:	38054463          	bltz	a0,35c6 <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    3242:	660d                	lui	a2,0x3
    3244:	00009597          	auipc	a1,0x9
    3248:	98c58593          	addi	a1,a1,-1652 # bbd0 <buf>
    324c:	00002097          	auipc	ra,0x2
    3250:	4c2080e7          	jalr	1218(ra) # 570e <read>
    3254:	4789                	li	a5,2
    3256:	38f51663          	bne	a0,a5,35e2 <subdir+0x55e>
  close(fd);
    325a:	8526                	mv	a0,s1
    325c:	00002097          	auipc	ra,0x2
    3260:	4c2080e7          	jalr	1218(ra) # 571e <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3264:	4581                	li	a1,0
    3266:	00004517          	auipc	a0,0x4
    326a:	11250513          	addi	a0,a0,274 # 7378 <malloc+0x1842>
    326e:	00002097          	auipc	ra,0x2
    3272:	4c8080e7          	jalr	1224(ra) # 5736 <open>
    3276:	38055463          	bgez	a0,35fe <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    327a:	20200593          	li	a1,514
    327e:	00004517          	auipc	a0,0x4
    3282:	30a50513          	addi	a0,a0,778 # 7588 <malloc+0x1a52>
    3286:	00002097          	auipc	ra,0x2
    328a:	4b0080e7          	jalr	1200(ra) # 5736 <open>
    328e:	38055663          	bgez	a0,361a <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3292:	20200593          	li	a1,514
    3296:	00004517          	auipc	a0,0x4
    329a:	32250513          	addi	a0,a0,802 # 75b8 <malloc+0x1a82>
    329e:	00002097          	auipc	ra,0x2
    32a2:	498080e7          	jalr	1176(ra) # 5736 <open>
    32a6:	38055863          	bgez	a0,3636 <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    32aa:	20000593          	li	a1,512
    32ae:	00004517          	auipc	a0,0x4
    32b2:	02a50513          	addi	a0,a0,42 # 72d8 <malloc+0x17a2>
    32b6:	00002097          	auipc	ra,0x2
    32ba:	480080e7          	jalr	1152(ra) # 5736 <open>
    32be:	38055a63          	bgez	a0,3652 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    32c2:	4589                	li	a1,2
    32c4:	00004517          	auipc	a0,0x4
    32c8:	01450513          	addi	a0,a0,20 # 72d8 <malloc+0x17a2>
    32cc:	00002097          	auipc	ra,0x2
    32d0:	46a080e7          	jalr	1130(ra) # 5736 <open>
    32d4:	38055d63          	bgez	a0,366e <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    32d8:	4585                	li	a1,1
    32da:	00004517          	auipc	a0,0x4
    32de:	ffe50513          	addi	a0,a0,-2 # 72d8 <malloc+0x17a2>
    32e2:	00002097          	auipc	ra,0x2
    32e6:	454080e7          	jalr	1108(ra) # 5736 <open>
    32ea:	3a055063          	bgez	a0,368a <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    32ee:	00004597          	auipc	a1,0x4
    32f2:	35a58593          	addi	a1,a1,858 # 7648 <malloc+0x1b12>
    32f6:	00004517          	auipc	a0,0x4
    32fa:	29250513          	addi	a0,a0,658 # 7588 <malloc+0x1a52>
    32fe:	00002097          	auipc	ra,0x2
    3302:	458080e7          	jalr	1112(ra) # 5756 <link>
    3306:	3a050063          	beqz	a0,36a6 <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    330a:	00004597          	auipc	a1,0x4
    330e:	33e58593          	addi	a1,a1,830 # 7648 <malloc+0x1b12>
    3312:	00004517          	auipc	a0,0x4
    3316:	2a650513          	addi	a0,a0,678 # 75b8 <malloc+0x1a82>
    331a:	00002097          	auipc	ra,0x2
    331e:	43c080e7          	jalr	1084(ra) # 5756 <link>
    3322:	3a050063          	beqz	a0,36c2 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    3326:	00004597          	auipc	a1,0x4
    332a:	0da58593          	addi	a1,a1,218 # 7400 <malloc+0x18ca>
    332e:	00004517          	auipc	a0,0x4
    3332:	fca50513          	addi	a0,a0,-54 # 72f8 <malloc+0x17c2>
    3336:	00002097          	auipc	ra,0x2
    333a:	420080e7          	jalr	1056(ra) # 5756 <link>
    333e:	3a050063          	beqz	a0,36de <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    3342:	00004517          	auipc	a0,0x4
    3346:	24650513          	addi	a0,a0,582 # 7588 <malloc+0x1a52>
    334a:	00002097          	auipc	ra,0x2
    334e:	414080e7          	jalr	1044(ra) # 575e <mkdir>
    3352:	3a050463          	beqz	a0,36fa <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    3356:	00004517          	auipc	a0,0x4
    335a:	26250513          	addi	a0,a0,610 # 75b8 <malloc+0x1a82>
    335e:	00002097          	auipc	ra,0x2
    3362:	400080e7          	jalr	1024(ra) # 575e <mkdir>
    3366:	3a050863          	beqz	a0,3716 <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    336a:	00004517          	auipc	a0,0x4
    336e:	09650513          	addi	a0,a0,150 # 7400 <malloc+0x18ca>
    3372:	00002097          	auipc	ra,0x2
    3376:	3ec080e7          	jalr	1004(ra) # 575e <mkdir>
    337a:	3a050c63          	beqz	a0,3732 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    337e:	00004517          	auipc	a0,0x4
    3382:	23a50513          	addi	a0,a0,570 # 75b8 <malloc+0x1a82>
    3386:	00002097          	auipc	ra,0x2
    338a:	3c0080e7          	jalr	960(ra) # 5746 <unlink>
    338e:	3c050063          	beqz	a0,374e <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    3392:	00004517          	auipc	a0,0x4
    3396:	1f650513          	addi	a0,a0,502 # 7588 <malloc+0x1a52>
    339a:	00002097          	auipc	ra,0x2
    339e:	3ac080e7          	jalr	940(ra) # 5746 <unlink>
    33a2:	3c050463          	beqz	a0,376a <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    33a6:	00004517          	auipc	a0,0x4
    33aa:	f5250513          	addi	a0,a0,-174 # 72f8 <malloc+0x17c2>
    33ae:	00002097          	auipc	ra,0x2
    33b2:	3b8080e7          	jalr	952(ra) # 5766 <chdir>
    33b6:	3c050863          	beqz	a0,3786 <subdir+0x702>
  if(chdir("dd/xx") == 0){
    33ba:	00004517          	auipc	a0,0x4
    33be:	3de50513          	addi	a0,a0,990 # 7798 <malloc+0x1c62>
    33c2:	00002097          	auipc	ra,0x2
    33c6:	3a4080e7          	jalr	932(ra) # 5766 <chdir>
    33ca:	3c050c63          	beqz	a0,37a2 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    33ce:	00004517          	auipc	a0,0x4
    33d2:	03250513          	addi	a0,a0,50 # 7400 <malloc+0x18ca>
    33d6:	00002097          	auipc	ra,0x2
    33da:	370080e7          	jalr	880(ra) # 5746 <unlink>
    33de:	3e051063          	bnez	a0,37be <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    33e2:	00004517          	auipc	a0,0x4
    33e6:	f1650513          	addi	a0,a0,-234 # 72f8 <malloc+0x17c2>
    33ea:	00002097          	auipc	ra,0x2
    33ee:	35c080e7          	jalr	860(ra) # 5746 <unlink>
    33f2:	3e051463          	bnez	a0,37da <subdir+0x756>
  if(unlink("dd") == 0){
    33f6:	00004517          	auipc	a0,0x4
    33fa:	ee250513          	addi	a0,a0,-286 # 72d8 <malloc+0x17a2>
    33fe:	00002097          	auipc	ra,0x2
    3402:	348080e7          	jalr	840(ra) # 5746 <unlink>
    3406:	3e050863          	beqz	a0,37f6 <subdir+0x772>
  if(unlink("dd/dd") < 0){
    340a:	00004517          	auipc	a0,0x4
    340e:	3fe50513          	addi	a0,a0,1022 # 7808 <malloc+0x1cd2>
    3412:	00002097          	auipc	ra,0x2
    3416:	334080e7          	jalr	820(ra) # 5746 <unlink>
    341a:	3e054c63          	bltz	a0,3812 <subdir+0x78e>
  if(unlink("dd") < 0){
    341e:	00004517          	auipc	a0,0x4
    3422:	eba50513          	addi	a0,a0,-326 # 72d8 <malloc+0x17a2>
    3426:	00002097          	auipc	ra,0x2
    342a:	320080e7          	jalr	800(ra) # 5746 <unlink>
    342e:	40054063          	bltz	a0,382e <subdir+0x7aa>
}
    3432:	60e2                	ld	ra,24(sp)
    3434:	6442                	ld	s0,16(sp)
    3436:	64a2                	ld	s1,8(sp)
    3438:	6902                	ld	s2,0(sp)
    343a:	6105                	addi	sp,sp,32
    343c:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    343e:	85ca                	mv	a1,s2
    3440:	00004517          	auipc	a0,0x4
    3444:	ea050513          	addi	a0,a0,-352 # 72e0 <malloc+0x17aa>
    3448:	00002097          	auipc	ra,0x2
    344c:	62e080e7          	jalr	1582(ra) # 5a76 <printf>
    exit(1);
    3450:	4505                	li	a0,1
    3452:	00002097          	auipc	ra,0x2
    3456:	2a4080e7          	jalr	676(ra) # 56f6 <exit>
    printf("%s: create dd/ff failed\n", s);
    345a:	85ca                	mv	a1,s2
    345c:	00004517          	auipc	a0,0x4
    3460:	ea450513          	addi	a0,a0,-348 # 7300 <malloc+0x17ca>
    3464:	00002097          	auipc	ra,0x2
    3468:	612080e7          	jalr	1554(ra) # 5a76 <printf>
    exit(1);
    346c:	4505                	li	a0,1
    346e:	00002097          	auipc	ra,0x2
    3472:	288080e7          	jalr	648(ra) # 56f6 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3476:	85ca                	mv	a1,s2
    3478:	00004517          	auipc	a0,0x4
    347c:	ea850513          	addi	a0,a0,-344 # 7320 <malloc+0x17ea>
    3480:	00002097          	auipc	ra,0x2
    3484:	5f6080e7          	jalr	1526(ra) # 5a76 <printf>
    exit(1);
    3488:	4505                	li	a0,1
    348a:	00002097          	auipc	ra,0x2
    348e:	26c080e7          	jalr	620(ra) # 56f6 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3492:	85ca                	mv	a1,s2
    3494:	00004517          	auipc	a0,0x4
    3498:	ec450513          	addi	a0,a0,-316 # 7358 <malloc+0x1822>
    349c:	00002097          	auipc	ra,0x2
    34a0:	5da080e7          	jalr	1498(ra) # 5a76 <printf>
    exit(1);
    34a4:	4505                	li	a0,1
    34a6:	00002097          	auipc	ra,0x2
    34aa:	250080e7          	jalr	592(ra) # 56f6 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    34ae:	85ca                	mv	a1,s2
    34b0:	00004517          	auipc	a0,0x4
    34b4:	ed850513          	addi	a0,a0,-296 # 7388 <malloc+0x1852>
    34b8:	00002097          	auipc	ra,0x2
    34bc:	5be080e7          	jalr	1470(ra) # 5a76 <printf>
    exit(1);
    34c0:	4505                	li	a0,1
    34c2:	00002097          	auipc	ra,0x2
    34c6:	234080e7          	jalr	564(ra) # 56f6 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    34ca:	85ca                	mv	a1,s2
    34cc:	00004517          	auipc	a0,0x4
    34d0:	ef450513          	addi	a0,a0,-268 # 73c0 <malloc+0x188a>
    34d4:	00002097          	auipc	ra,0x2
    34d8:	5a2080e7          	jalr	1442(ra) # 5a76 <printf>
    exit(1);
    34dc:	4505                	li	a0,1
    34de:	00002097          	auipc	ra,0x2
    34e2:	218080e7          	jalr	536(ra) # 56f6 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    34e6:	85ca                	mv	a1,s2
    34e8:	00004517          	auipc	a0,0x4
    34ec:	ef850513          	addi	a0,a0,-264 # 73e0 <malloc+0x18aa>
    34f0:	00002097          	auipc	ra,0x2
    34f4:	586080e7          	jalr	1414(ra) # 5a76 <printf>
    exit(1);
    34f8:	4505                	li	a0,1
    34fa:	00002097          	auipc	ra,0x2
    34fe:	1fc080e7          	jalr	508(ra) # 56f6 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3502:	85ca                	mv	a1,s2
    3504:	00004517          	auipc	a0,0x4
    3508:	f0c50513          	addi	a0,a0,-244 # 7410 <malloc+0x18da>
    350c:	00002097          	auipc	ra,0x2
    3510:	56a080e7          	jalr	1386(ra) # 5a76 <printf>
    exit(1);
    3514:	4505                	li	a0,1
    3516:	00002097          	auipc	ra,0x2
    351a:	1e0080e7          	jalr	480(ra) # 56f6 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    351e:	85ca                	mv	a1,s2
    3520:	00004517          	auipc	a0,0x4
    3524:	f1850513          	addi	a0,a0,-232 # 7438 <malloc+0x1902>
    3528:	00002097          	auipc	ra,0x2
    352c:	54e080e7          	jalr	1358(ra) # 5a76 <printf>
    exit(1);
    3530:	4505                	li	a0,1
    3532:	00002097          	auipc	ra,0x2
    3536:	1c4080e7          	jalr	452(ra) # 56f6 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    353a:	85ca                	mv	a1,s2
    353c:	00004517          	auipc	a0,0x4
    3540:	f1c50513          	addi	a0,a0,-228 # 7458 <malloc+0x1922>
    3544:	00002097          	auipc	ra,0x2
    3548:	532080e7          	jalr	1330(ra) # 5a76 <printf>
    exit(1);
    354c:	4505                	li	a0,1
    354e:	00002097          	auipc	ra,0x2
    3552:	1a8080e7          	jalr	424(ra) # 56f6 <exit>
    printf("%s: chdir dd failed\n", s);
    3556:	85ca                	mv	a1,s2
    3558:	00004517          	auipc	a0,0x4
    355c:	f2850513          	addi	a0,a0,-216 # 7480 <malloc+0x194a>
    3560:	00002097          	auipc	ra,0x2
    3564:	516080e7          	jalr	1302(ra) # 5a76 <printf>
    exit(1);
    3568:	4505                	li	a0,1
    356a:	00002097          	auipc	ra,0x2
    356e:	18c080e7          	jalr	396(ra) # 56f6 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3572:	85ca                	mv	a1,s2
    3574:	00004517          	auipc	a0,0x4
    3578:	f3450513          	addi	a0,a0,-204 # 74a8 <malloc+0x1972>
    357c:	00002097          	auipc	ra,0x2
    3580:	4fa080e7          	jalr	1274(ra) # 5a76 <printf>
    exit(1);
    3584:	4505                	li	a0,1
    3586:	00002097          	auipc	ra,0x2
    358a:	170080e7          	jalr	368(ra) # 56f6 <exit>
    printf("chdir dd/../../dd failed\n", s);
    358e:	85ca                	mv	a1,s2
    3590:	00004517          	auipc	a0,0x4
    3594:	f4850513          	addi	a0,a0,-184 # 74d8 <malloc+0x19a2>
    3598:	00002097          	auipc	ra,0x2
    359c:	4de080e7          	jalr	1246(ra) # 5a76 <printf>
    exit(1);
    35a0:	4505                	li	a0,1
    35a2:	00002097          	auipc	ra,0x2
    35a6:	154080e7          	jalr	340(ra) # 56f6 <exit>
    printf("%s: chdir ./.. failed\n", s);
    35aa:	85ca                	mv	a1,s2
    35ac:	00004517          	auipc	a0,0x4
    35b0:	f5450513          	addi	a0,a0,-172 # 7500 <malloc+0x19ca>
    35b4:	00002097          	auipc	ra,0x2
    35b8:	4c2080e7          	jalr	1218(ra) # 5a76 <printf>
    exit(1);
    35bc:	4505                	li	a0,1
    35be:	00002097          	auipc	ra,0x2
    35c2:	138080e7          	jalr	312(ra) # 56f6 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    35c6:	85ca                	mv	a1,s2
    35c8:	00004517          	auipc	a0,0x4
    35cc:	f5050513          	addi	a0,a0,-176 # 7518 <malloc+0x19e2>
    35d0:	00002097          	auipc	ra,0x2
    35d4:	4a6080e7          	jalr	1190(ra) # 5a76 <printf>
    exit(1);
    35d8:	4505                	li	a0,1
    35da:	00002097          	auipc	ra,0x2
    35de:	11c080e7          	jalr	284(ra) # 56f6 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    35e2:	85ca                	mv	a1,s2
    35e4:	00004517          	auipc	a0,0x4
    35e8:	f5450513          	addi	a0,a0,-172 # 7538 <malloc+0x1a02>
    35ec:	00002097          	auipc	ra,0x2
    35f0:	48a080e7          	jalr	1162(ra) # 5a76 <printf>
    exit(1);
    35f4:	4505                	li	a0,1
    35f6:	00002097          	auipc	ra,0x2
    35fa:	100080e7          	jalr	256(ra) # 56f6 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    35fe:	85ca                	mv	a1,s2
    3600:	00004517          	auipc	a0,0x4
    3604:	f5850513          	addi	a0,a0,-168 # 7558 <malloc+0x1a22>
    3608:	00002097          	auipc	ra,0x2
    360c:	46e080e7          	jalr	1134(ra) # 5a76 <printf>
    exit(1);
    3610:	4505                	li	a0,1
    3612:	00002097          	auipc	ra,0x2
    3616:	0e4080e7          	jalr	228(ra) # 56f6 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    361a:	85ca                	mv	a1,s2
    361c:	00004517          	auipc	a0,0x4
    3620:	f7c50513          	addi	a0,a0,-132 # 7598 <malloc+0x1a62>
    3624:	00002097          	auipc	ra,0x2
    3628:	452080e7          	jalr	1106(ra) # 5a76 <printf>
    exit(1);
    362c:	4505                	li	a0,1
    362e:	00002097          	auipc	ra,0x2
    3632:	0c8080e7          	jalr	200(ra) # 56f6 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3636:	85ca                	mv	a1,s2
    3638:	00004517          	auipc	a0,0x4
    363c:	f9050513          	addi	a0,a0,-112 # 75c8 <malloc+0x1a92>
    3640:	00002097          	auipc	ra,0x2
    3644:	436080e7          	jalr	1078(ra) # 5a76 <printf>
    exit(1);
    3648:	4505                	li	a0,1
    364a:	00002097          	auipc	ra,0x2
    364e:	0ac080e7          	jalr	172(ra) # 56f6 <exit>
    printf("%s: create dd succeeded!\n", s);
    3652:	85ca                	mv	a1,s2
    3654:	00004517          	auipc	a0,0x4
    3658:	f9450513          	addi	a0,a0,-108 # 75e8 <malloc+0x1ab2>
    365c:	00002097          	auipc	ra,0x2
    3660:	41a080e7          	jalr	1050(ra) # 5a76 <printf>
    exit(1);
    3664:	4505                	li	a0,1
    3666:	00002097          	auipc	ra,0x2
    366a:	090080e7          	jalr	144(ra) # 56f6 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    366e:	85ca                	mv	a1,s2
    3670:	00004517          	auipc	a0,0x4
    3674:	f9850513          	addi	a0,a0,-104 # 7608 <malloc+0x1ad2>
    3678:	00002097          	auipc	ra,0x2
    367c:	3fe080e7          	jalr	1022(ra) # 5a76 <printf>
    exit(1);
    3680:	4505                	li	a0,1
    3682:	00002097          	auipc	ra,0x2
    3686:	074080e7          	jalr	116(ra) # 56f6 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    368a:	85ca                	mv	a1,s2
    368c:	00004517          	auipc	a0,0x4
    3690:	f9c50513          	addi	a0,a0,-100 # 7628 <malloc+0x1af2>
    3694:	00002097          	auipc	ra,0x2
    3698:	3e2080e7          	jalr	994(ra) # 5a76 <printf>
    exit(1);
    369c:	4505                	li	a0,1
    369e:	00002097          	auipc	ra,0x2
    36a2:	058080e7          	jalr	88(ra) # 56f6 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    36a6:	85ca                	mv	a1,s2
    36a8:	00004517          	auipc	a0,0x4
    36ac:	fb050513          	addi	a0,a0,-80 # 7658 <malloc+0x1b22>
    36b0:	00002097          	auipc	ra,0x2
    36b4:	3c6080e7          	jalr	966(ra) # 5a76 <printf>
    exit(1);
    36b8:	4505                	li	a0,1
    36ba:	00002097          	auipc	ra,0x2
    36be:	03c080e7          	jalr	60(ra) # 56f6 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    36c2:	85ca                	mv	a1,s2
    36c4:	00004517          	auipc	a0,0x4
    36c8:	fbc50513          	addi	a0,a0,-68 # 7680 <malloc+0x1b4a>
    36cc:	00002097          	auipc	ra,0x2
    36d0:	3aa080e7          	jalr	938(ra) # 5a76 <printf>
    exit(1);
    36d4:	4505                	li	a0,1
    36d6:	00002097          	auipc	ra,0x2
    36da:	020080e7          	jalr	32(ra) # 56f6 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    36de:	85ca                	mv	a1,s2
    36e0:	00004517          	auipc	a0,0x4
    36e4:	fc850513          	addi	a0,a0,-56 # 76a8 <malloc+0x1b72>
    36e8:	00002097          	auipc	ra,0x2
    36ec:	38e080e7          	jalr	910(ra) # 5a76 <printf>
    exit(1);
    36f0:	4505                	li	a0,1
    36f2:	00002097          	auipc	ra,0x2
    36f6:	004080e7          	jalr	4(ra) # 56f6 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    36fa:	85ca                	mv	a1,s2
    36fc:	00004517          	auipc	a0,0x4
    3700:	fd450513          	addi	a0,a0,-44 # 76d0 <malloc+0x1b9a>
    3704:	00002097          	auipc	ra,0x2
    3708:	372080e7          	jalr	882(ra) # 5a76 <printf>
    exit(1);
    370c:	4505                	li	a0,1
    370e:	00002097          	auipc	ra,0x2
    3712:	fe8080e7          	jalr	-24(ra) # 56f6 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3716:	85ca                	mv	a1,s2
    3718:	00004517          	auipc	a0,0x4
    371c:	fd850513          	addi	a0,a0,-40 # 76f0 <malloc+0x1bba>
    3720:	00002097          	auipc	ra,0x2
    3724:	356080e7          	jalr	854(ra) # 5a76 <printf>
    exit(1);
    3728:	4505                	li	a0,1
    372a:	00002097          	auipc	ra,0x2
    372e:	fcc080e7          	jalr	-52(ra) # 56f6 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3732:	85ca                	mv	a1,s2
    3734:	00004517          	auipc	a0,0x4
    3738:	fdc50513          	addi	a0,a0,-36 # 7710 <malloc+0x1bda>
    373c:	00002097          	auipc	ra,0x2
    3740:	33a080e7          	jalr	826(ra) # 5a76 <printf>
    exit(1);
    3744:	4505                	li	a0,1
    3746:	00002097          	auipc	ra,0x2
    374a:	fb0080e7          	jalr	-80(ra) # 56f6 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    374e:	85ca                	mv	a1,s2
    3750:	00004517          	auipc	a0,0x4
    3754:	fe850513          	addi	a0,a0,-24 # 7738 <malloc+0x1c02>
    3758:	00002097          	auipc	ra,0x2
    375c:	31e080e7          	jalr	798(ra) # 5a76 <printf>
    exit(1);
    3760:	4505                	li	a0,1
    3762:	00002097          	auipc	ra,0x2
    3766:	f94080e7          	jalr	-108(ra) # 56f6 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    376a:	85ca                	mv	a1,s2
    376c:	00004517          	auipc	a0,0x4
    3770:	fec50513          	addi	a0,a0,-20 # 7758 <malloc+0x1c22>
    3774:	00002097          	auipc	ra,0x2
    3778:	302080e7          	jalr	770(ra) # 5a76 <printf>
    exit(1);
    377c:	4505                	li	a0,1
    377e:	00002097          	auipc	ra,0x2
    3782:	f78080e7          	jalr	-136(ra) # 56f6 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3786:	85ca                	mv	a1,s2
    3788:	00004517          	auipc	a0,0x4
    378c:	ff050513          	addi	a0,a0,-16 # 7778 <malloc+0x1c42>
    3790:	00002097          	auipc	ra,0x2
    3794:	2e6080e7          	jalr	742(ra) # 5a76 <printf>
    exit(1);
    3798:	4505                	li	a0,1
    379a:	00002097          	auipc	ra,0x2
    379e:	f5c080e7          	jalr	-164(ra) # 56f6 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    37a2:	85ca                	mv	a1,s2
    37a4:	00004517          	auipc	a0,0x4
    37a8:	ffc50513          	addi	a0,a0,-4 # 77a0 <malloc+0x1c6a>
    37ac:	00002097          	auipc	ra,0x2
    37b0:	2ca080e7          	jalr	714(ra) # 5a76 <printf>
    exit(1);
    37b4:	4505                	li	a0,1
    37b6:	00002097          	auipc	ra,0x2
    37ba:	f40080e7          	jalr	-192(ra) # 56f6 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    37be:	85ca                	mv	a1,s2
    37c0:	00004517          	auipc	a0,0x4
    37c4:	c7850513          	addi	a0,a0,-904 # 7438 <malloc+0x1902>
    37c8:	00002097          	auipc	ra,0x2
    37cc:	2ae080e7          	jalr	686(ra) # 5a76 <printf>
    exit(1);
    37d0:	4505                	li	a0,1
    37d2:	00002097          	auipc	ra,0x2
    37d6:	f24080e7          	jalr	-220(ra) # 56f6 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    37da:	85ca                	mv	a1,s2
    37dc:	00004517          	auipc	a0,0x4
    37e0:	fe450513          	addi	a0,a0,-28 # 77c0 <malloc+0x1c8a>
    37e4:	00002097          	auipc	ra,0x2
    37e8:	292080e7          	jalr	658(ra) # 5a76 <printf>
    exit(1);
    37ec:	4505                	li	a0,1
    37ee:	00002097          	auipc	ra,0x2
    37f2:	f08080e7          	jalr	-248(ra) # 56f6 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    37f6:	85ca                	mv	a1,s2
    37f8:	00004517          	auipc	a0,0x4
    37fc:	fe850513          	addi	a0,a0,-24 # 77e0 <malloc+0x1caa>
    3800:	00002097          	auipc	ra,0x2
    3804:	276080e7          	jalr	630(ra) # 5a76 <printf>
    exit(1);
    3808:	4505                	li	a0,1
    380a:	00002097          	auipc	ra,0x2
    380e:	eec080e7          	jalr	-276(ra) # 56f6 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3812:	85ca                	mv	a1,s2
    3814:	00004517          	auipc	a0,0x4
    3818:	ffc50513          	addi	a0,a0,-4 # 7810 <malloc+0x1cda>
    381c:	00002097          	auipc	ra,0x2
    3820:	25a080e7          	jalr	602(ra) # 5a76 <printf>
    exit(1);
    3824:	4505                	li	a0,1
    3826:	00002097          	auipc	ra,0x2
    382a:	ed0080e7          	jalr	-304(ra) # 56f6 <exit>
    printf("%s: unlink dd failed\n", s);
    382e:	85ca                	mv	a1,s2
    3830:	00004517          	auipc	a0,0x4
    3834:	00050513          	mv	a0,a0
    3838:	00002097          	auipc	ra,0x2
    383c:	23e080e7          	jalr	574(ra) # 5a76 <printf>
    exit(1);
    3840:	4505                	li	a0,1
    3842:	00002097          	auipc	ra,0x2
    3846:	eb4080e7          	jalr	-332(ra) # 56f6 <exit>

000000000000384a <rmdot>:
{
    384a:	1101                	addi	sp,sp,-32
    384c:	ec06                	sd	ra,24(sp)
    384e:	e822                	sd	s0,16(sp)
    3850:	e426                	sd	s1,8(sp)
    3852:	1000                	addi	s0,sp,32
    3854:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3856:	00004517          	auipc	a0,0x4
    385a:	ff250513          	addi	a0,a0,-14 # 7848 <malloc+0x1d12>
    385e:	00002097          	auipc	ra,0x2
    3862:	f00080e7          	jalr	-256(ra) # 575e <mkdir>
    3866:	e549                	bnez	a0,38f0 <rmdot+0xa6>
  if(chdir("dots") != 0){
    3868:	00004517          	auipc	a0,0x4
    386c:	fe050513          	addi	a0,a0,-32 # 7848 <malloc+0x1d12>
    3870:	00002097          	auipc	ra,0x2
    3874:	ef6080e7          	jalr	-266(ra) # 5766 <chdir>
    3878:	e951                	bnez	a0,390c <rmdot+0xc2>
  if(unlink(".") == 0){
    387a:	00003517          	auipc	a0,0x3
    387e:	e7650513          	addi	a0,a0,-394 # 66f0 <malloc+0xbba>
    3882:	00002097          	auipc	ra,0x2
    3886:	ec4080e7          	jalr	-316(ra) # 5746 <unlink>
    388a:	cd59                	beqz	a0,3928 <rmdot+0xde>
  if(unlink("..") == 0){
    388c:	00004517          	auipc	a0,0x4
    3890:	a1450513          	addi	a0,a0,-1516 # 72a0 <malloc+0x176a>
    3894:	00002097          	auipc	ra,0x2
    3898:	eb2080e7          	jalr	-334(ra) # 5746 <unlink>
    389c:	c545                	beqz	a0,3944 <rmdot+0xfa>
  if(chdir("/") != 0){
    389e:	00004517          	auipc	a0,0x4
    38a2:	9aa50513          	addi	a0,a0,-1622 # 7248 <malloc+0x1712>
    38a6:	00002097          	auipc	ra,0x2
    38aa:	ec0080e7          	jalr	-320(ra) # 5766 <chdir>
    38ae:	e94d                	bnez	a0,3960 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    38b0:	00004517          	auipc	a0,0x4
    38b4:	00050513          	mv	a0,a0
    38b8:	00002097          	auipc	ra,0x2
    38bc:	e8e080e7          	jalr	-370(ra) # 5746 <unlink>
    38c0:	cd55                	beqz	a0,397c <rmdot+0x132>
  if(unlink("dots/..") == 0){
    38c2:	00004517          	auipc	a0,0x4
    38c6:	01650513          	addi	a0,a0,22 # 78d8 <malloc+0x1da2>
    38ca:	00002097          	auipc	ra,0x2
    38ce:	e7c080e7          	jalr	-388(ra) # 5746 <unlink>
    38d2:	c179                	beqz	a0,3998 <rmdot+0x14e>
  if(unlink("dots") != 0){
    38d4:	00004517          	auipc	a0,0x4
    38d8:	f7450513          	addi	a0,a0,-140 # 7848 <malloc+0x1d12>
    38dc:	00002097          	auipc	ra,0x2
    38e0:	e6a080e7          	jalr	-406(ra) # 5746 <unlink>
    38e4:	e961                	bnez	a0,39b4 <rmdot+0x16a>
}
    38e6:	60e2                	ld	ra,24(sp)
    38e8:	6442                	ld	s0,16(sp)
    38ea:	64a2                	ld	s1,8(sp)
    38ec:	6105                	addi	sp,sp,32
    38ee:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    38f0:	85a6                	mv	a1,s1
    38f2:	00004517          	auipc	a0,0x4
    38f6:	f5e50513          	addi	a0,a0,-162 # 7850 <malloc+0x1d1a>
    38fa:	00002097          	auipc	ra,0x2
    38fe:	17c080e7          	jalr	380(ra) # 5a76 <printf>
    exit(1);
    3902:	4505                	li	a0,1
    3904:	00002097          	auipc	ra,0x2
    3908:	df2080e7          	jalr	-526(ra) # 56f6 <exit>
    printf("%s: chdir dots failed\n", s);
    390c:	85a6                	mv	a1,s1
    390e:	00004517          	auipc	a0,0x4
    3912:	f5a50513          	addi	a0,a0,-166 # 7868 <malloc+0x1d32>
    3916:	00002097          	auipc	ra,0x2
    391a:	160080e7          	jalr	352(ra) # 5a76 <printf>
    exit(1);
    391e:	4505                	li	a0,1
    3920:	00002097          	auipc	ra,0x2
    3924:	dd6080e7          	jalr	-554(ra) # 56f6 <exit>
    printf("%s: rm . worked!\n", s);
    3928:	85a6                	mv	a1,s1
    392a:	00004517          	auipc	a0,0x4
    392e:	f5650513          	addi	a0,a0,-170 # 7880 <malloc+0x1d4a>
    3932:	00002097          	auipc	ra,0x2
    3936:	144080e7          	jalr	324(ra) # 5a76 <printf>
    exit(1);
    393a:	4505                	li	a0,1
    393c:	00002097          	auipc	ra,0x2
    3940:	dba080e7          	jalr	-582(ra) # 56f6 <exit>
    printf("%s: rm .. worked!\n", s);
    3944:	85a6                	mv	a1,s1
    3946:	00004517          	auipc	a0,0x4
    394a:	f5250513          	addi	a0,a0,-174 # 7898 <malloc+0x1d62>
    394e:	00002097          	auipc	ra,0x2
    3952:	128080e7          	jalr	296(ra) # 5a76 <printf>
    exit(1);
    3956:	4505                	li	a0,1
    3958:	00002097          	auipc	ra,0x2
    395c:	d9e080e7          	jalr	-610(ra) # 56f6 <exit>
    printf("%s: chdir / failed\n", s);
    3960:	85a6                	mv	a1,s1
    3962:	00004517          	auipc	a0,0x4
    3966:	8ee50513          	addi	a0,a0,-1810 # 7250 <malloc+0x171a>
    396a:	00002097          	auipc	ra,0x2
    396e:	10c080e7          	jalr	268(ra) # 5a76 <printf>
    exit(1);
    3972:	4505                	li	a0,1
    3974:	00002097          	auipc	ra,0x2
    3978:	d82080e7          	jalr	-638(ra) # 56f6 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    397c:	85a6                	mv	a1,s1
    397e:	00004517          	auipc	a0,0x4
    3982:	f3a50513          	addi	a0,a0,-198 # 78b8 <malloc+0x1d82>
    3986:	00002097          	auipc	ra,0x2
    398a:	0f0080e7          	jalr	240(ra) # 5a76 <printf>
    exit(1);
    398e:	4505                	li	a0,1
    3990:	00002097          	auipc	ra,0x2
    3994:	d66080e7          	jalr	-666(ra) # 56f6 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3998:	85a6                	mv	a1,s1
    399a:	00004517          	auipc	a0,0x4
    399e:	f4650513          	addi	a0,a0,-186 # 78e0 <malloc+0x1daa>
    39a2:	00002097          	auipc	ra,0x2
    39a6:	0d4080e7          	jalr	212(ra) # 5a76 <printf>
    exit(1);
    39aa:	4505                	li	a0,1
    39ac:	00002097          	auipc	ra,0x2
    39b0:	d4a080e7          	jalr	-694(ra) # 56f6 <exit>
    printf("%s: unlink dots failed!\n", s);
    39b4:	85a6                	mv	a1,s1
    39b6:	00004517          	auipc	a0,0x4
    39ba:	f4a50513          	addi	a0,a0,-182 # 7900 <malloc+0x1dca>
    39be:	00002097          	auipc	ra,0x2
    39c2:	0b8080e7          	jalr	184(ra) # 5a76 <printf>
    exit(1);
    39c6:	4505                	li	a0,1
    39c8:	00002097          	auipc	ra,0x2
    39cc:	d2e080e7          	jalr	-722(ra) # 56f6 <exit>

00000000000039d0 <dirfile>:
{
    39d0:	1101                	addi	sp,sp,-32
    39d2:	ec06                	sd	ra,24(sp)
    39d4:	e822                	sd	s0,16(sp)
    39d6:	e426                	sd	s1,8(sp)
    39d8:	e04a                	sd	s2,0(sp)
    39da:	1000                	addi	s0,sp,32
    39dc:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    39de:	20000593          	li	a1,512
    39e2:	00004517          	auipc	a0,0x4
    39e6:	f3e50513          	addi	a0,a0,-194 # 7920 <malloc+0x1dea>
    39ea:	00002097          	auipc	ra,0x2
    39ee:	d4c080e7          	jalr	-692(ra) # 5736 <open>
  if(fd < 0){
    39f2:	0e054d63          	bltz	a0,3aec <dirfile+0x11c>
  close(fd);
    39f6:	00002097          	auipc	ra,0x2
    39fa:	d28080e7          	jalr	-728(ra) # 571e <close>
  if(chdir("dirfile") == 0){
    39fe:	00004517          	auipc	a0,0x4
    3a02:	f2250513          	addi	a0,a0,-222 # 7920 <malloc+0x1dea>
    3a06:	00002097          	auipc	ra,0x2
    3a0a:	d60080e7          	jalr	-672(ra) # 5766 <chdir>
    3a0e:	cd6d                	beqz	a0,3b08 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    3a10:	4581                	li	a1,0
    3a12:	00004517          	auipc	a0,0x4
    3a16:	f5650513          	addi	a0,a0,-170 # 7968 <malloc+0x1e32>
    3a1a:	00002097          	auipc	ra,0x2
    3a1e:	d1c080e7          	jalr	-740(ra) # 5736 <open>
  if(fd >= 0){
    3a22:	10055163          	bgez	a0,3b24 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    3a26:	20000593          	li	a1,512
    3a2a:	00004517          	auipc	a0,0x4
    3a2e:	f3e50513          	addi	a0,a0,-194 # 7968 <malloc+0x1e32>
    3a32:	00002097          	auipc	ra,0x2
    3a36:	d04080e7          	jalr	-764(ra) # 5736 <open>
  if(fd >= 0){
    3a3a:	10055363          	bgez	a0,3b40 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    3a3e:	00004517          	auipc	a0,0x4
    3a42:	f2a50513          	addi	a0,a0,-214 # 7968 <malloc+0x1e32>
    3a46:	00002097          	auipc	ra,0x2
    3a4a:	d18080e7          	jalr	-744(ra) # 575e <mkdir>
    3a4e:	10050763          	beqz	a0,3b5c <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3a52:	00004517          	auipc	a0,0x4
    3a56:	f1650513          	addi	a0,a0,-234 # 7968 <malloc+0x1e32>
    3a5a:	00002097          	auipc	ra,0x2
    3a5e:	cec080e7          	jalr	-788(ra) # 5746 <unlink>
    3a62:	10050b63          	beqz	a0,3b78 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3a66:	00004597          	auipc	a1,0x4
    3a6a:	f0258593          	addi	a1,a1,-254 # 7968 <malloc+0x1e32>
    3a6e:	00002517          	auipc	a0,0x2
    3a72:	77250513          	addi	a0,a0,1906 # 61e0 <malloc+0x6aa>
    3a76:	00002097          	auipc	ra,0x2
    3a7a:	ce0080e7          	jalr	-800(ra) # 5756 <link>
    3a7e:	10050b63          	beqz	a0,3b94 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3a82:	00004517          	auipc	a0,0x4
    3a86:	e9e50513          	addi	a0,a0,-354 # 7920 <malloc+0x1dea>
    3a8a:	00002097          	auipc	ra,0x2
    3a8e:	cbc080e7          	jalr	-836(ra) # 5746 <unlink>
    3a92:	10051f63          	bnez	a0,3bb0 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3a96:	4589                	li	a1,2
    3a98:	00003517          	auipc	a0,0x3
    3a9c:	c5850513          	addi	a0,a0,-936 # 66f0 <malloc+0xbba>
    3aa0:	00002097          	auipc	ra,0x2
    3aa4:	c96080e7          	jalr	-874(ra) # 5736 <open>
  if(fd >= 0){
    3aa8:	12055263          	bgez	a0,3bcc <dirfile+0x1fc>
  fd = open(".", 0);
    3aac:	4581                	li	a1,0
    3aae:	00003517          	auipc	a0,0x3
    3ab2:	c4250513          	addi	a0,a0,-958 # 66f0 <malloc+0xbba>
    3ab6:	00002097          	auipc	ra,0x2
    3aba:	c80080e7          	jalr	-896(ra) # 5736 <open>
    3abe:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3ac0:	4605                	li	a2,1
    3ac2:	00002597          	auipc	a1,0x2
    3ac6:	5e658593          	addi	a1,a1,1510 # 60a8 <malloc+0x572>
    3aca:	00002097          	auipc	ra,0x2
    3ace:	c4c080e7          	jalr	-948(ra) # 5716 <write>
    3ad2:	10a04b63          	bgtz	a0,3be8 <dirfile+0x218>
  close(fd);
    3ad6:	8526                	mv	a0,s1
    3ad8:	00002097          	auipc	ra,0x2
    3adc:	c46080e7          	jalr	-954(ra) # 571e <close>
}
    3ae0:	60e2                	ld	ra,24(sp)
    3ae2:	6442                	ld	s0,16(sp)
    3ae4:	64a2                	ld	s1,8(sp)
    3ae6:	6902                	ld	s2,0(sp)
    3ae8:	6105                	addi	sp,sp,32
    3aea:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3aec:	85ca                	mv	a1,s2
    3aee:	00004517          	auipc	a0,0x4
    3af2:	e3a50513          	addi	a0,a0,-454 # 7928 <malloc+0x1df2>
    3af6:	00002097          	auipc	ra,0x2
    3afa:	f80080e7          	jalr	-128(ra) # 5a76 <printf>
    exit(1);
    3afe:	4505                	li	a0,1
    3b00:	00002097          	auipc	ra,0x2
    3b04:	bf6080e7          	jalr	-1034(ra) # 56f6 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3b08:	85ca                	mv	a1,s2
    3b0a:	00004517          	auipc	a0,0x4
    3b0e:	e3e50513          	addi	a0,a0,-450 # 7948 <malloc+0x1e12>
    3b12:	00002097          	auipc	ra,0x2
    3b16:	f64080e7          	jalr	-156(ra) # 5a76 <printf>
    exit(1);
    3b1a:	4505                	li	a0,1
    3b1c:	00002097          	auipc	ra,0x2
    3b20:	bda080e7          	jalr	-1062(ra) # 56f6 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3b24:	85ca                	mv	a1,s2
    3b26:	00004517          	auipc	a0,0x4
    3b2a:	e5250513          	addi	a0,a0,-430 # 7978 <malloc+0x1e42>
    3b2e:	00002097          	auipc	ra,0x2
    3b32:	f48080e7          	jalr	-184(ra) # 5a76 <printf>
    exit(1);
    3b36:	4505                	li	a0,1
    3b38:	00002097          	auipc	ra,0x2
    3b3c:	bbe080e7          	jalr	-1090(ra) # 56f6 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3b40:	85ca                	mv	a1,s2
    3b42:	00004517          	auipc	a0,0x4
    3b46:	e3650513          	addi	a0,a0,-458 # 7978 <malloc+0x1e42>
    3b4a:	00002097          	auipc	ra,0x2
    3b4e:	f2c080e7          	jalr	-212(ra) # 5a76 <printf>
    exit(1);
    3b52:	4505                	li	a0,1
    3b54:	00002097          	auipc	ra,0x2
    3b58:	ba2080e7          	jalr	-1118(ra) # 56f6 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3b5c:	85ca                	mv	a1,s2
    3b5e:	00004517          	auipc	a0,0x4
    3b62:	e4250513          	addi	a0,a0,-446 # 79a0 <malloc+0x1e6a>
    3b66:	00002097          	auipc	ra,0x2
    3b6a:	f10080e7          	jalr	-240(ra) # 5a76 <printf>
    exit(1);
    3b6e:	4505                	li	a0,1
    3b70:	00002097          	auipc	ra,0x2
    3b74:	b86080e7          	jalr	-1146(ra) # 56f6 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3b78:	85ca                	mv	a1,s2
    3b7a:	00004517          	auipc	a0,0x4
    3b7e:	e4e50513          	addi	a0,a0,-434 # 79c8 <malloc+0x1e92>
    3b82:	00002097          	auipc	ra,0x2
    3b86:	ef4080e7          	jalr	-268(ra) # 5a76 <printf>
    exit(1);
    3b8a:	4505                	li	a0,1
    3b8c:	00002097          	auipc	ra,0x2
    3b90:	b6a080e7          	jalr	-1174(ra) # 56f6 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3b94:	85ca                	mv	a1,s2
    3b96:	00004517          	auipc	a0,0x4
    3b9a:	e5a50513          	addi	a0,a0,-422 # 79f0 <malloc+0x1eba>
    3b9e:	00002097          	auipc	ra,0x2
    3ba2:	ed8080e7          	jalr	-296(ra) # 5a76 <printf>
    exit(1);
    3ba6:	4505                	li	a0,1
    3ba8:	00002097          	auipc	ra,0x2
    3bac:	b4e080e7          	jalr	-1202(ra) # 56f6 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3bb0:	85ca                	mv	a1,s2
    3bb2:	00004517          	auipc	a0,0x4
    3bb6:	e6650513          	addi	a0,a0,-410 # 7a18 <malloc+0x1ee2>
    3bba:	00002097          	auipc	ra,0x2
    3bbe:	ebc080e7          	jalr	-324(ra) # 5a76 <printf>
    exit(1);
    3bc2:	4505                	li	a0,1
    3bc4:	00002097          	auipc	ra,0x2
    3bc8:	b32080e7          	jalr	-1230(ra) # 56f6 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3bcc:	85ca                	mv	a1,s2
    3bce:	00004517          	auipc	a0,0x4
    3bd2:	e6a50513          	addi	a0,a0,-406 # 7a38 <malloc+0x1f02>
    3bd6:	00002097          	auipc	ra,0x2
    3bda:	ea0080e7          	jalr	-352(ra) # 5a76 <printf>
    exit(1);
    3bde:	4505                	li	a0,1
    3be0:	00002097          	auipc	ra,0x2
    3be4:	b16080e7          	jalr	-1258(ra) # 56f6 <exit>
    printf("%s: write . succeeded!\n", s);
    3be8:	85ca                	mv	a1,s2
    3bea:	00004517          	auipc	a0,0x4
    3bee:	e7650513          	addi	a0,a0,-394 # 7a60 <malloc+0x1f2a>
    3bf2:	00002097          	auipc	ra,0x2
    3bf6:	e84080e7          	jalr	-380(ra) # 5a76 <printf>
    exit(1);
    3bfa:	4505                	li	a0,1
    3bfc:	00002097          	auipc	ra,0x2
    3c00:	afa080e7          	jalr	-1286(ra) # 56f6 <exit>

0000000000003c04 <iref>:
{
    3c04:	7139                	addi	sp,sp,-64
    3c06:	fc06                	sd	ra,56(sp)
    3c08:	f822                	sd	s0,48(sp)
    3c0a:	f426                	sd	s1,40(sp)
    3c0c:	f04a                	sd	s2,32(sp)
    3c0e:	ec4e                	sd	s3,24(sp)
    3c10:	e852                	sd	s4,16(sp)
    3c12:	e456                	sd	s5,8(sp)
    3c14:	e05a                	sd	s6,0(sp)
    3c16:	0080                	addi	s0,sp,64
    3c18:	8b2a                	mv	s6,a0
    3c1a:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    3c1e:	00004a17          	auipc	s4,0x4
    3c22:	e5aa0a13          	addi	s4,s4,-422 # 7a78 <malloc+0x1f42>
    mkdir("");
    3c26:	00004497          	auipc	s1,0x4
    3c2a:	95a48493          	addi	s1,s1,-1702 # 7580 <malloc+0x1a4a>
    link("README", "");
    3c2e:	00002a97          	auipc	s5,0x2
    3c32:	5b2a8a93          	addi	s5,s5,1458 # 61e0 <malloc+0x6aa>
    fd = open("xx", O_CREATE);
    3c36:	00004997          	auipc	s3,0x4
    3c3a:	d3a98993          	addi	s3,s3,-710 # 7970 <malloc+0x1e3a>
    3c3e:	a891                	j	3c92 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    3c40:	85da                	mv	a1,s6
    3c42:	00004517          	auipc	a0,0x4
    3c46:	e3e50513          	addi	a0,a0,-450 # 7a80 <malloc+0x1f4a>
    3c4a:	00002097          	auipc	ra,0x2
    3c4e:	e2c080e7          	jalr	-468(ra) # 5a76 <printf>
      exit(1);
    3c52:	4505                	li	a0,1
    3c54:	00002097          	auipc	ra,0x2
    3c58:	aa2080e7          	jalr	-1374(ra) # 56f6 <exit>
      printf("%s: chdir irefd failed\n", s);
    3c5c:	85da                	mv	a1,s6
    3c5e:	00004517          	auipc	a0,0x4
    3c62:	e3a50513          	addi	a0,a0,-454 # 7a98 <malloc+0x1f62>
    3c66:	00002097          	auipc	ra,0x2
    3c6a:	e10080e7          	jalr	-496(ra) # 5a76 <printf>
      exit(1);
    3c6e:	4505                	li	a0,1
    3c70:	00002097          	auipc	ra,0x2
    3c74:	a86080e7          	jalr	-1402(ra) # 56f6 <exit>
      close(fd);
    3c78:	00002097          	auipc	ra,0x2
    3c7c:	aa6080e7          	jalr	-1370(ra) # 571e <close>
    3c80:	a889                	j	3cd2 <iref+0xce>
    unlink("xx");
    3c82:	854e                	mv	a0,s3
    3c84:	00002097          	auipc	ra,0x2
    3c88:	ac2080e7          	jalr	-1342(ra) # 5746 <unlink>
    3c8c:	397d                	addiw	s2,s2,-1
  for(i = 0; i < NINODE + 1; i++){
    3c8e:	06090063          	beqz	s2,3cee <iref+0xea>
    if(mkdir("irefd") != 0){
    3c92:	8552                	mv	a0,s4
    3c94:	00002097          	auipc	ra,0x2
    3c98:	aca080e7          	jalr	-1334(ra) # 575e <mkdir>
    3c9c:	f155                	bnez	a0,3c40 <iref+0x3c>
    if(chdir("irefd") != 0){
    3c9e:	8552                	mv	a0,s4
    3ca0:	00002097          	auipc	ra,0x2
    3ca4:	ac6080e7          	jalr	-1338(ra) # 5766 <chdir>
    3ca8:	f955                	bnez	a0,3c5c <iref+0x58>
    mkdir("");
    3caa:	8526                	mv	a0,s1
    3cac:	00002097          	auipc	ra,0x2
    3cb0:	ab2080e7          	jalr	-1358(ra) # 575e <mkdir>
    link("README", "");
    3cb4:	85a6                	mv	a1,s1
    3cb6:	8556                	mv	a0,s5
    3cb8:	00002097          	auipc	ra,0x2
    3cbc:	a9e080e7          	jalr	-1378(ra) # 5756 <link>
    fd = open("", O_CREATE);
    3cc0:	20000593          	li	a1,512
    3cc4:	8526                	mv	a0,s1
    3cc6:	00002097          	auipc	ra,0x2
    3cca:	a70080e7          	jalr	-1424(ra) # 5736 <open>
    if(fd >= 0)
    3cce:	fa0555e3          	bgez	a0,3c78 <iref+0x74>
    fd = open("xx", O_CREATE);
    3cd2:	20000593          	li	a1,512
    3cd6:	854e                	mv	a0,s3
    3cd8:	00002097          	auipc	ra,0x2
    3cdc:	a5e080e7          	jalr	-1442(ra) # 5736 <open>
    if(fd >= 0)
    3ce0:	fa0541e3          	bltz	a0,3c82 <iref+0x7e>
      close(fd);
    3ce4:	00002097          	auipc	ra,0x2
    3ce8:	a3a080e7          	jalr	-1478(ra) # 571e <close>
    3cec:	bf59                	j	3c82 <iref+0x7e>
    3cee:	03300493          	li	s1,51
    chdir("..");
    3cf2:	00003997          	auipc	s3,0x3
    3cf6:	5ae98993          	addi	s3,s3,1454 # 72a0 <malloc+0x176a>
    unlink("irefd");
    3cfa:	00004917          	auipc	s2,0x4
    3cfe:	d7e90913          	addi	s2,s2,-642 # 7a78 <malloc+0x1f42>
    chdir("..");
    3d02:	854e                	mv	a0,s3
    3d04:	00002097          	auipc	ra,0x2
    3d08:	a62080e7          	jalr	-1438(ra) # 5766 <chdir>
    unlink("irefd");
    3d0c:	854a                	mv	a0,s2
    3d0e:	00002097          	auipc	ra,0x2
    3d12:	a38080e7          	jalr	-1480(ra) # 5746 <unlink>
    3d16:	34fd                	addiw	s1,s1,-1
  for(i = 0; i < NINODE + 1; i++){
    3d18:	f4ed                	bnez	s1,3d02 <iref+0xfe>
  chdir("/");
    3d1a:	00003517          	auipc	a0,0x3
    3d1e:	52e50513          	addi	a0,a0,1326 # 7248 <malloc+0x1712>
    3d22:	00002097          	auipc	ra,0x2
    3d26:	a44080e7          	jalr	-1468(ra) # 5766 <chdir>
}
    3d2a:	70e2                	ld	ra,56(sp)
    3d2c:	7442                	ld	s0,48(sp)
    3d2e:	74a2                	ld	s1,40(sp)
    3d30:	7902                	ld	s2,32(sp)
    3d32:	69e2                	ld	s3,24(sp)
    3d34:	6a42                	ld	s4,16(sp)
    3d36:	6aa2                	ld	s5,8(sp)
    3d38:	6b02                	ld	s6,0(sp)
    3d3a:	6121                	addi	sp,sp,64
    3d3c:	8082                	ret

0000000000003d3e <openiputtest>:
{
    3d3e:	7179                	addi	sp,sp,-48
    3d40:	f406                	sd	ra,40(sp)
    3d42:	f022                	sd	s0,32(sp)
    3d44:	ec26                	sd	s1,24(sp)
    3d46:	1800                	addi	s0,sp,48
    3d48:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3d4a:	00004517          	auipc	a0,0x4
    3d4e:	d6650513          	addi	a0,a0,-666 # 7ab0 <malloc+0x1f7a>
    3d52:	00002097          	auipc	ra,0x2
    3d56:	a0c080e7          	jalr	-1524(ra) # 575e <mkdir>
    3d5a:	04054263          	bltz	a0,3d9e <openiputtest+0x60>
  pid = fork();
    3d5e:	00002097          	auipc	ra,0x2
    3d62:	990080e7          	jalr	-1648(ra) # 56ee <fork>
  if(pid < 0){
    3d66:	04054a63          	bltz	a0,3dba <openiputtest+0x7c>
  if(pid == 0){
    3d6a:	e93d                	bnez	a0,3de0 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    3d6c:	4589                	li	a1,2
    3d6e:	00004517          	auipc	a0,0x4
    3d72:	d4250513          	addi	a0,a0,-702 # 7ab0 <malloc+0x1f7a>
    3d76:	00002097          	auipc	ra,0x2
    3d7a:	9c0080e7          	jalr	-1600(ra) # 5736 <open>
    if(fd >= 0){
    3d7e:	04054c63          	bltz	a0,3dd6 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    3d82:	85a6                	mv	a1,s1
    3d84:	00004517          	auipc	a0,0x4
    3d88:	d4c50513          	addi	a0,a0,-692 # 7ad0 <malloc+0x1f9a>
    3d8c:	00002097          	auipc	ra,0x2
    3d90:	cea080e7          	jalr	-790(ra) # 5a76 <printf>
      exit(1);
    3d94:	4505                	li	a0,1
    3d96:	00002097          	auipc	ra,0x2
    3d9a:	960080e7          	jalr	-1696(ra) # 56f6 <exit>
    printf("%s: mkdir oidir failed\n", s);
    3d9e:	85a6                	mv	a1,s1
    3da0:	00004517          	auipc	a0,0x4
    3da4:	d1850513          	addi	a0,a0,-744 # 7ab8 <malloc+0x1f82>
    3da8:	00002097          	auipc	ra,0x2
    3dac:	cce080e7          	jalr	-818(ra) # 5a76 <printf>
    exit(1);
    3db0:	4505                	li	a0,1
    3db2:	00002097          	auipc	ra,0x2
    3db6:	944080e7          	jalr	-1724(ra) # 56f6 <exit>
    printf("%s: fork failed\n", s);
    3dba:	85a6                	mv	a1,s1
    3dbc:	00003517          	auipc	a0,0x3
    3dc0:	ad450513          	addi	a0,a0,-1324 # 6890 <malloc+0xd5a>
    3dc4:	00002097          	auipc	ra,0x2
    3dc8:	cb2080e7          	jalr	-846(ra) # 5a76 <printf>
    exit(1);
    3dcc:	4505                	li	a0,1
    3dce:	00002097          	auipc	ra,0x2
    3dd2:	928080e7          	jalr	-1752(ra) # 56f6 <exit>
    exit(0);
    3dd6:	4501                	li	a0,0
    3dd8:	00002097          	auipc	ra,0x2
    3ddc:	91e080e7          	jalr	-1762(ra) # 56f6 <exit>
  sleep(1);
    3de0:	4505                	li	a0,1
    3de2:	00002097          	auipc	ra,0x2
    3de6:	9a4080e7          	jalr	-1628(ra) # 5786 <sleep>
  if(unlink("oidir") != 0){
    3dea:	00004517          	auipc	a0,0x4
    3dee:	cc650513          	addi	a0,a0,-826 # 7ab0 <malloc+0x1f7a>
    3df2:	00002097          	auipc	ra,0x2
    3df6:	954080e7          	jalr	-1708(ra) # 5746 <unlink>
    3dfa:	cd19                	beqz	a0,3e18 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    3dfc:	85a6                	mv	a1,s1
    3dfe:	00003517          	auipc	a0,0x3
    3e02:	c8250513          	addi	a0,a0,-894 # 6a80 <malloc+0xf4a>
    3e06:	00002097          	auipc	ra,0x2
    3e0a:	c70080e7          	jalr	-912(ra) # 5a76 <printf>
    exit(1);
    3e0e:	4505                	li	a0,1
    3e10:	00002097          	auipc	ra,0x2
    3e14:	8e6080e7          	jalr	-1818(ra) # 56f6 <exit>
  wait(&xstatus);
    3e18:	fdc40513          	addi	a0,s0,-36
    3e1c:	00002097          	auipc	ra,0x2
    3e20:	8e2080e7          	jalr	-1822(ra) # 56fe <wait>
  exit(xstatus);
    3e24:	fdc42503          	lw	a0,-36(s0)
    3e28:	00002097          	auipc	ra,0x2
    3e2c:	8ce080e7          	jalr	-1842(ra) # 56f6 <exit>

0000000000003e30 <forkforkfork>:
{
    3e30:	1101                	addi	sp,sp,-32
    3e32:	ec06                	sd	ra,24(sp)
    3e34:	e822                	sd	s0,16(sp)
    3e36:	e426                	sd	s1,8(sp)
    3e38:	1000                	addi	s0,sp,32
    3e3a:	84aa                	mv	s1,a0
  unlink("stopforking");
    3e3c:	00004517          	auipc	a0,0x4
    3e40:	cbc50513          	addi	a0,a0,-836 # 7af8 <malloc+0x1fc2>
    3e44:	00002097          	auipc	ra,0x2
    3e48:	902080e7          	jalr	-1790(ra) # 5746 <unlink>
  int pid = fork();
    3e4c:	00002097          	auipc	ra,0x2
    3e50:	8a2080e7          	jalr	-1886(ra) # 56ee <fork>
  if(pid < 0){
    3e54:	04054563          	bltz	a0,3e9e <forkforkfork+0x6e>
  if(pid == 0){
    3e58:	c12d                	beqz	a0,3eba <forkforkfork+0x8a>
  sleep(20); // two seconds
    3e5a:	4551                	li	a0,20
    3e5c:	00002097          	auipc	ra,0x2
    3e60:	92a080e7          	jalr	-1750(ra) # 5786 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    3e64:	20200593          	li	a1,514
    3e68:	00004517          	auipc	a0,0x4
    3e6c:	c9050513          	addi	a0,a0,-880 # 7af8 <malloc+0x1fc2>
    3e70:	00002097          	auipc	ra,0x2
    3e74:	8c6080e7          	jalr	-1850(ra) # 5736 <open>
    3e78:	00002097          	auipc	ra,0x2
    3e7c:	8a6080e7          	jalr	-1882(ra) # 571e <close>
  wait(0);
    3e80:	4501                	li	a0,0
    3e82:	00002097          	auipc	ra,0x2
    3e86:	87c080e7          	jalr	-1924(ra) # 56fe <wait>
  sleep(10); // one second
    3e8a:	4529                	li	a0,10
    3e8c:	00002097          	auipc	ra,0x2
    3e90:	8fa080e7          	jalr	-1798(ra) # 5786 <sleep>
}
    3e94:	60e2                	ld	ra,24(sp)
    3e96:	6442                	ld	s0,16(sp)
    3e98:	64a2                	ld	s1,8(sp)
    3e9a:	6105                	addi	sp,sp,32
    3e9c:	8082                	ret
    printf("%s: fork failed", s);
    3e9e:	85a6                	mv	a1,s1
    3ea0:	00003517          	auipc	a0,0x3
    3ea4:	bb050513          	addi	a0,a0,-1104 # 6a50 <malloc+0xf1a>
    3ea8:	00002097          	auipc	ra,0x2
    3eac:	bce080e7          	jalr	-1074(ra) # 5a76 <printf>
    exit(1);
    3eb0:	4505                	li	a0,1
    3eb2:	00002097          	auipc	ra,0x2
    3eb6:	844080e7          	jalr	-1980(ra) # 56f6 <exit>
      int fd = open("stopforking", 0);
    3eba:	00004497          	auipc	s1,0x4
    3ebe:	c3e48493          	addi	s1,s1,-962 # 7af8 <malloc+0x1fc2>
    3ec2:	4581                	li	a1,0
    3ec4:	8526                	mv	a0,s1
    3ec6:	00002097          	auipc	ra,0x2
    3eca:	870080e7          	jalr	-1936(ra) # 5736 <open>
      if(fd >= 0){
    3ece:	02055463          	bgez	a0,3ef6 <forkforkfork+0xc6>
      if(fork() < 0){
    3ed2:	00002097          	auipc	ra,0x2
    3ed6:	81c080e7          	jalr	-2020(ra) # 56ee <fork>
    3eda:	fe0554e3          	bgez	a0,3ec2 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    3ede:	20200593          	li	a1,514
    3ee2:	8526                	mv	a0,s1
    3ee4:	00002097          	auipc	ra,0x2
    3ee8:	852080e7          	jalr	-1966(ra) # 5736 <open>
    3eec:	00002097          	auipc	ra,0x2
    3ef0:	832080e7          	jalr	-1998(ra) # 571e <close>
    3ef4:	b7f9                	j	3ec2 <forkforkfork+0x92>
        exit(0);
    3ef6:	4501                	li	a0,0
    3ef8:	00001097          	auipc	ra,0x1
    3efc:	7fe080e7          	jalr	2046(ra) # 56f6 <exit>

0000000000003f00 <killstatus>:
{
    3f00:	7139                	addi	sp,sp,-64
    3f02:	fc06                	sd	ra,56(sp)
    3f04:	f822                	sd	s0,48(sp)
    3f06:	f426                	sd	s1,40(sp)
    3f08:	f04a                	sd	s2,32(sp)
    3f0a:	ec4e                	sd	s3,24(sp)
    3f0c:	e852                	sd	s4,16(sp)
    3f0e:	0080                	addi	s0,sp,64
    3f10:	8a2a                	mv	s4,a0
    3f12:	06400913          	li	s2,100
    if(xst != -1) {
    3f16:	59fd                	li	s3,-1
    int pid1 = fork();
    3f18:	00001097          	auipc	ra,0x1
    3f1c:	7d6080e7          	jalr	2006(ra) # 56ee <fork>
    3f20:	84aa                	mv	s1,a0
    if(pid1 < 0){
    3f22:	02054f63          	bltz	a0,3f60 <killstatus+0x60>
    if(pid1 == 0){
    3f26:	c939                	beqz	a0,3f7c <killstatus+0x7c>
    sleep(1);
    3f28:	4505                	li	a0,1
    3f2a:	00002097          	auipc	ra,0x2
    3f2e:	85c080e7          	jalr	-1956(ra) # 5786 <sleep>
    kill(pid1);
    3f32:	8526                	mv	a0,s1
    3f34:	00001097          	auipc	ra,0x1
    3f38:	7f2080e7          	jalr	2034(ra) # 5726 <kill>
    wait(&xst);
    3f3c:	fcc40513          	addi	a0,s0,-52
    3f40:	00001097          	auipc	ra,0x1
    3f44:	7be080e7          	jalr	1982(ra) # 56fe <wait>
    if(xst != -1) {
    3f48:	fcc42783          	lw	a5,-52(s0)
    3f4c:	03379d63          	bne	a5,s3,3f86 <killstatus+0x86>
    3f50:	397d                	addiw	s2,s2,-1
  for(int i = 0; i < 100; i++){
    3f52:	fc0913e3          	bnez	s2,3f18 <killstatus+0x18>
  exit(0);
    3f56:	4501                	li	a0,0
    3f58:	00001097          	auipc	ra,0x1
    3f5c:	79e080e7          	jalr	1950(ra) # 56f6 <exit>
      printf("%s: fork failed\n", s);
    3f60:	85d2                	mv	a1,s4
    3f62:	00003517          	auipc	a0,0x3
    3f66:	92e50513          	addi	a0,a0,-1746 # 6890 <malloc+0xd5a>
    3f6a:	00002097          	auipc	ra,0x2
    3f6e:	b0c080e7          	jalr	-1268(ra) # 5a76 <printf>
      exit(1);
    3f72:	4505                	li	a0,1
    3f74:	00001097          	auipc	ra,0x1
    3f78:	782080e7          	jalr	1922(ra) # 56f6 <exit>
        getpid();
    3f7c:	00001097          	auipc	ra,0x1
    3f80:	7fa080e7          	jalr	2042(ra) # 5776 <getpid>
    3f84:	bfe5                	j	3f7c <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    3f86:	85d2                	mv	a1,s4
    3f88:	00004517          	auipc	a0,0x4
    3f8c:	b8050513          	addi	a0,a0,-1152 # 7b08 <malloc+0x1fd2>
    3f90:	00002097          	auipc	ra,0x2
    3f94:	ae6080e7          	jalr	-1306(ra) # 5a76 <printf>
       exit(1);
    3f98:	4505                	li	a0,1
    3f9a:	00001097          	auipc	ra,0x1
    3f9e:	75c080e7          	jalr	1884(ra) # 56f6 <exit>

0000000000003fa2 <preempt>:
{
    3fa2:	7139                	addi	sp,sp,-64
    3fa4:	fc06                	sd	ra,56(sp)
    3fa6:	f822                	sd	s0,48(sp)
    3fa8:	f426                	sd	s1,40(sp)
    3faa:	f04a                	sd	s2,32(sp)
    3fac:	ec4e                	sd	s3,24(sp)
    3fae:	e852                	sd	s4,16(sp)
    3fb0:	0080                	addi	s0,sp,64
    3fb2:	8a2a                	mv	s4,a0
  pid1 = fork();
    3fb4:	00001097          	auipc	ra,0x1
    3fb8:	73a080e7          	jalr	1850(ra) # 56ee <fork>
  if(pid1 < 0) {
    3fbc:	00054563          	bltz	a0,3fc6 <preempt+0x24>
    3fc0:	89aa                	mv	s3,a0
  if(pid1 == 0)
    3fc2:	e105                	bnez	a0,3fe2 <preempt+0x40>
      ;
    3fc4:	a001                	j	3fc4 <preempt+0x22>
    printf("%s: fork failed", s);
    3fc6:	85d2                	mv	a1,s4
    3fc8:	00003517          	auipc	a0,0x3
    3fcc:	a8850513          	addi	a0,a0,-1400 # 6a50 <malloc+0xf1a>
    3fd0:	00002097          	auipc	ra,0x2
    3fd4:	aa6080e7          	jalr	-1370(ra) # 5a76 <printf>
    exit(1);
    3fd8:	4505                	li	a0,1
    3fda:	00001097          	auipc	ra,0x1
    3fde:	71c080e7          	jalr	1820(ra) # 56f6 <exit>
  pid2 = fork();
    3fe2:	00001097          	auipc	ra,0x1
    3fe6:	70c080e7          	jalr	1804(ra) # 56ee <fork>
    3fea:	892a                	mv	s2,a0
  if(pid2 < 0) {
    3fec:	00054463          	bltz	a0,3ff4 <preempt+0x52>
  if(pid2 == 0)
    3ff0:	e105                	bnez	a0,4010 <preempt+0x6e>
      ;
    3ff2:	a001                	j	3ff2 <preempt+0x50>
    printf("%s: fork failed\n", s);
    3ff4:	85d2                	mv	a1,s4
    3ff6:	00003517          	auipc	a0,0x3
    3ffa:	89a50513          	addi	a0,a0,-1894 # 6890 <malloc+0xd5a>
    3ffe:	00002097          	auipc	ra,0x2
    4002:	a78080e7          	jalr	-1416(ra) # 5a76 <printf>
    exit(1);
    4006:	4505                	li	a0,1
    4008:	00001097          	auipc	ra,0x1
    400c:	6ee080e7          	jalr	1774(ra) # 56f6 <exit>
  pipe(pfds);
    4010:	fc840513          	addi	a0,s0,-56
    4014:	00001097          	auipc	ra,0x1
    4018:	6f2080e7          	jalr	1778(ra) # 5706 <pipe>
  pid3 = fork();
    401c:	00001097          	auipc	ra,0x1
    4020:	6d2080e7          	jalr	1746(ra) # 56ee <fork>
    4024:	84aa                	mv	s1,a0
  if(pid3 < 0) {
    4026:	02054e63          	bltz	a0,4062 <preempt+0xc0>
  if(pid3 == 0){
    402a:	e525                	bnez	a0,4092 <preempt+0xf0>
    close(pfds[0]);
    402c:	fc842503          	lw	a0,-56(s0)
    4030:	00001097          	auipc	ra,0x1
    4034:	6ee080e7          	jalr	1774(ra) # 571e <close>
    if(write(pfds[1], "x", 1) != 1)
    4038:	4605                	li	a2,1
    403a:	00002597          	auipc	a1,0x2
    403e:	06e58593          	addi	a1,a1,110 # 60a8 <malloc+0x572>
    4042:	fcc42503          	lw	a0,-52(s0)
    4046:	00001097          	auipc	ra,0x1
    404a:	6d0080e7          	jalr	1744(ra) # 5716 <write>
    404e:	4785                	li	a5,1
    4050:	02f51763          	bne	a0,a5,407e <preempt+0xdc>
    close(pfds[1]);
    4054:	fcc42503          	lw	a0,-52(s0)
    4058:	00001097          	auipc	ra,0x1
    405c:	6c6080e7          	jalr	1734(ra) # 571e <close>
      ;
    4060:	a001                	j	4060 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    4062:	85d2                	mv	a1,s4
    4064:	00003517          	auipc	a0,0x3
    4068:	82c50513          	addi	a0,a0,-2004 # 6890 <malloc+0xd5a>
    406c:	00002097          	auipc	ra,0x2
    4070:	a0a080e7          	jalr	-1526(ra) # 5a76 <printf>
     exit(1);
    4074:	4505                	li	a0,1
    4076:	00001097          	auipc	ra,0x1
    407a:	680080e7          	jalr	1664(ra) # 56f6 <exit>
      printf("%s: preempt write error", s);
    407e:	85d2                	mv	a1,s4
    4080:	00004517          	auipc	a0,0x4
    4084:	aa850513          	addi	a0,a0,-1368 # 7b28 <malloc+0x1ff2>
    4088:	00002097          	auipc	ra,0x2
    408c:	9ee080e7          	jalr	-1554(ra) # 5a76 <printf>
    4090:	b7d1                	j	4054 <preempt+0xb2>
  close(pfds[1]);
    4092:	fcc42503          	lw	a0,-52(s0)
    4096:	00001097          	auipc	ra,0x1
    409a:	688080e7          	jalr	1672(ra) # 571e <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    409e:	660d                	lui	a2,0x3
    40a0:	00008597          	auipc	a1,0x8
    40a4:	b3058593          	addi	a1,a1,-1232 # bbd0 <buf>
    40a8:	fc842503          	lw	a0,-56(s0)
    40ac:	00001097          	auipc	ra,0x1
    40b0:	662080e7          	jalr	1634(ra) # 570e <read>
    40b4:	4785                	li	a5,1
    40b6:	02f50363          	beq	a0,a5,40dc <preempt+0x13a>
    printf("%s: preempt read error", s);
    40ba:	85d2                	mv	a1,s4
    40bc:	00004517          	auipc	a0,0x4
    40c0:	a8450513          	addi	a0,a0,-1404 # 7b40 <malloc+0x200a>
    40c4:	00002097          	auipc	ra,0x2
    40c8:	9b2080e7          	jalr	-1614(ra) # 5a76 <printf>
}
    40cc:	70e2                	ld	ra,56(sp)
    40ce:	7442                	ld	s0,48(sp)
    40d0:	74a2                	ld	s1,40(sp)
    40d2:	7902                	ld	s2,32(sp)
    40d4:	69e2                	ld	s3,24(sp)
    40d6:	6a42                	ld	s4,16(sp)
    40d8:	6121                	addi	sp,sp,64
    40da:	8082                	ret
  close(pfds[0]);
    40dc:	fc842503          	lw	a0,-56(s0)
    40e0:	00001097          	auipc	ra,0x1
    40e4:	63e080e7          	jalr	1598(ra) # 571e <close>
  printf("kill... ");
    40e8:	00004517          	auipc	a0,0x4
    40ec:	a7050513          	addi	a0,a0,-1424 # 7b58 <malloc+0x2022>
    40f0:	00002097          	auipc	ra,0x2
    40f4:	986080e7          	jalr	-1658(ra) # 5a76 <printf>
  kill(pid1);
    40f8:	854e                	mv	a0,s3
    40fa:	00001097          	auipc	ra,0x1
    40fe:	62c080e7          	jalr	1580(ra) # 5726 <kill>
  kill(pid2);
    4102:	854a                	mv	a0,s2
    4104:	00001097          	auipc	ra,0x1
    4108:	622080e7          	jalr	1570(ra) # 5726 <kill>
  kill(pid3);
    410c:	8526                	mv	a0,s1
    410e:	00001097          	auipc	ra,0x1
    4112:	618080e7          	jalr	1560(ra) # 5726 <kill>
  printf("wait... ");
    4116:	00004517          	auipc	a0,0x4
    411a:	a5250513          	addi	a0,a0,-1454 # 7b68 <malloc+0x2032>
    411e:	00002097          	auipc	ra,0x2
    4122:	958080e7          	jalr	-1704(ra) # 5a76 <printf>
  wait(0);
    4126:	4501                	li	a0,0
    4128:	00001097          	auipc	ra,0x1
    412c:	5d6080e7          	jalr	1494(ra) # 56fe <wait>
  wait(0);
    4130:	4501                	li	a0,0
    4132:	00001097          	auipc	ra,0x1
    4136:	5cc080e7          	jalr	1484(ra) # 56fe <wait>
  wait(0);
    413a:	4501                	li	a0,0
    413c:	00001097          	auipc	ra,0x1
    4140:	5c2080e7          	jalr	1474(ra) # 56fe <wait>
    4144:	b761                	j	40cc <preempt+0x12a>

0000000000004146 <reparent>:
{
    4146:	7179                	addi	sp,sp,-48
    4148:	f406                	sd	ra,40(sp)
    414a:	f022                	sd	s0,32(sp)
    414c:	ec26                	sd	s1,24(sp)
    414e:	e84a                	sd	s2,16(sp)
    4150:	e44e                	sd	s3,8(sp)
    4152:	e052                	sd	s4,0(sp)
    4154:	1800                	addi	s0,sp,48
    4156:	89aa                	mv	s3,a0
  int master_pid = getpid();
    4158:	00001097          	auipc	ra,0x1
    415c:	61e080e7          	jalr	1566(ra) # 5776 <getpid>
    4160:	8a2a                	mv	s4,a0
    4162:	0c800913          	li	s2,200
    int pid = fork();
    4166:	00001097          	auipc	ra,0x1
    416a:	588080e7          	jalr	1416(ra) # 56ee <fork>
    416e:	84aa                	mv	s1,a0
    if(pid < 0){
    4170:	02054263          	bltz	a0,4194 <reparent+0x4e>
    if(pid){
    4174:	cd21                	beqz	a0,41cc <reparent+0x86>
      if(wait(0) != pid){
    4176:	4501                	li	a0,0
    4178:	00001097          	auipc	ra,0x1
    417c:	586080e7          	jalr	1414(ra) # 56fe <wait>
    4180:	02951863          	bne	a0,s1,41b0 <reparent+0x6a>
    4184:	397d                	addiw	s2,s2,-1
  for(int i = 0; i < 200; i++){
    4186:	fe0910e3          	bnez	s2,4166 <reparent+0x20>
  exit(0);
    418a:	4501                	li	a0,0
    418c:	00001097          	auipc	ra,0x1
    4190:	56a080e7          	jalr	1386(ra) # 56f6 <exit>
      printf("%s: fork failed\n", s);
    4194:	85ce                	mv	a1,s3
    4196:	00002517          	auipc	a0,0x2
    419a:	6fa50513          	addi	a0,a0,1786 # 6890 <malloc+0xd5a>
    419e:	00002097          	auipc	ra,0x2
    41a2:	8d8080e7          	jalr	-1832(ra) # 5a76 <printf>
      exit(1);
    41a6:	4505                	li	a0,1
    41a8:	00001097          	auipc	ra,0x1
    41ac:	54e080e7          	jalr	1358(ra) # 56f6 <exit>
        printf("%s: wait wrong pid\n", s);
    41b0:	85ce                	mv	a1,s3
    41b2:	00003517          	auipc	a0,0x3
    41b6:	86650513          	addi	a0,a0,-1946 # 6a18 <malloc+0xee2>
    41ba:	00002097          	auipc	ra,0x2
    41be:	8bc080e7          	jalr	-1860(ra) # 5a76 <printf>
        exit(1);
    41c2:	4505                	li	a0,1
    41c4:	00001097          	auipc	ra,0x1
    41c8:	532080e7          	jalr	1330(ra) # 56f6 <exit>
      int pid2 = fork();
    41cc:	00001097          	auipc	ra,0x1
    41d0:	522080e7          	jalr	1314(ra) # 56ee <fork>
      if(pid2 < 0){
    41d4:	00054763          	bltz	a0,41e2 <reparent+0x9c>
      exit(0);
    41d8:	4501                	li	a0,0
    41da:	00001097          	auipc	ra,0x1
    41de:	51c080e7          	jalr	1308(ra) # 56f6 <exit>
        kill(master_pid);
    41e2:	8552                	mv	a0,s4
    41e4:	00001097          	auipc	ra,0x1
    41e8:	542080e7          	jalr	1346(ra) # 5726 <kill>
        exit(1);
    41ec:	4505                	li	a0,1
    41ee:	00001097          	auipc	ra,0x1
    41f2:	508080e7          	jalr	1288(ra) # 56f6 <exit>

00000000000041f6 <sbrkfail>:
{
    41f6:	7119                	addi	sp,sp,-128
    41f8:	fc86                	sd	ra,120(sp)
    41fa:	f8a2                	sd	s0,112(sp)
    41fc:	f4a6                	sd	s1,104(sp)
    41fe:	f0ca                	sd	s2,96(sp)
    4200:	ecce                	sd	s3,88(sp)
    4202:	e8d2                	sd	s4,80(sp)
    4204:	e4d6                	sd	s5,72(sp)
    4206:	0100                	addi	s0,sp,128
    4208:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    420a:	fb040513          	addi	a0,s0,-80
    420e:	00001097          	auipc	ra,0x1
    4212:	4f8080e7          	jalr	1272(ra) # 5706 <pipe>
    4216:	e901                	bnez	a0,4226 <sbrkfail+0x30>
    4218:	f8040493          	addi	s1,s0,-128
    421c:	fa840993          	addi	s3,s0,-88
    4220:	8926                	mv	s2,s1
    if(pids[i] != -1)
    4222:	5a7d                	li	s4,-1
    4224:	a085                	j	4284 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    4226:	85d6                	mv	a1,s5
    4228:	00002517          	auipc	a0,0x2
    422c:	77050513          	addi	a0,a0,1904 # 6998 <malloc+0xe62>
    4230:	00002097          	auipc	ra,0x2
    4234:	846080e7          	jalr	-1978(ra) # 5a76 <printf>
    exit(1);
    4238:	4505                	li	a0,1
    423a:	00001097          	auipc	ra,0x1
    423e:	4bc080e7          	jalr	1212(ra) # 56f6 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    4242:	00001097          	auipc	ra,0x1
    4246:	53c080e7          	jalr	1340(ra) # 577e <sbrk>
    424a:	064007b7          	lui	a5,0x6400
    424e:	40a7853b          	subw	a0,a5,a0
    4252:	00001097          	auipc	ra,0x1
    4256:	52c080e7          	jalr	1324(ra) # 577e <sbrk>
      write(fds[1], "x", 1);
    425a:	4605                	li	a2,1
    425c:	00002597          	auipc	a1,0x2
    4260:	e4c58593          	addi	a1,a1,-436 # 60a8 <malloc+0x572>
    4264:	fb442503          	lw	a0,-76(s0)
    4268:	00001097          	auipc	ra,0x1
    426c:	4ae080e7          	jalr	1198(ra) # 5716 <write>
      for(;;) sleep(1000);
    4270:	3e800513          	li	a0,1000
    4274:	00001097          	auipc	ra,0x1
    4278:	512080e7          	jalr	1298(ra) # 5786 <sleep>
    427c:	bfd5                	j	4270 <sbrkfail+0x7a>
    427e:	0911                	addi	s2,s2,4
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4280:	03390563          	beq	s2,s3,42aa <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    4284:	00001097          	auipc	ra,0x1
    4288:	46a080e7          	jalr	1130(ra) # 56ee <fork>
    428c:	00a92023          	sw	a0,0(s2)
    4290:	d94d                	beqz	a0,4242 <sbrkfail+0x4c>
    if(pids[i] != -1)
    4292:	ff4506e3          	beq	a0,s4,427e <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    4296:	4605                	li	a2,1
    4298:	faf40593          	addi	a1,s0,-81
    429c:	fb042503          	lw	a0,-80(s0)
    42a0:	00001097          	auipc	ra,0x1
    42a4:	46e080e7          	jalr	1134(ra) # 570e <read>
    42a8:	bfd9                	j	427e <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    42aa:	6505                	lui	a0,0x1
    42ac:	00001097          	auipc	ra,0x1
    42b0:	4d2080e7          	jalr	1234(ra) # 577e <sbrk>
    42b4:	892a                	mv	s2,a0
    if(pids[i] == -1)
    42b6:	5a7d                	li	s4,-1
    42b8:	a021                	j	42c0 <sbrkfail+0xca>
    42ba:	0491                	addi	s1,s1,4
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    42bc:	01348f63          	beq	s1,s3,42da <sbrkfail+0xe4>
    if(pids[i] == -1)
    42c0:	4088                	lw	a0,0(s1)
    42c2:	ff450ce3          	beq	a0,s4,42ba <sbrkfail+0xc4>
    kill(pids[i]);
    42c6:	00001097          	auipc	ra,0x1
    42ca:	460080e7          	jalr	1120(ra) # 5726 <kill>
    wait(0);
    42ce:	4501                	li	a0,0
    42d0:	00001097          	auipc	ra,0x1
    42d4:	42e080e7          	jalr	1070(ra) # 56fe <wait>
    42d8:	b7cd                	j	42ba <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    42da:	57fd                	li	a5,-1
    42dc:	04f90163          	beq	s2,a5,431e <sbrkfail+0x128>
  pid = fork();
    42e0:	00001097          	auipc	ra,0x1
    42e4:	40e080e7          	jalr	1038(ra) # 56ee <fork>
    42e8:	84aa                	mv	s1,a0
  if(pid < 0){
    42ea:	04054863          	bltz	a0,433a <sbrkfail+0x144>
  if(pid == 0){
    42ee:	c525                	beqz	a0,4356 <sbrkfail+0x160>
  wait(&xstatus);
    42f0:	fbc40513          	addi	a0,s0,-68
    42f4:	00001097          	auipc	ra,0x1
    42f8:	40a080e7          	jalr	1034(ra) # 56fe <wait>
  if(xstatus != -1 && xstatus != 2)
    42fc:	fbc42783          	lw	a5,-68(s0)
    4300:	577d                	li	a4,-1
    4302:	00e78563          	beq	a5,a4,430c <sbrkfail+0x116>
    4306:	4709                	li	a4,2
    4308:	08e79d63          	bne	a5,a4,43a2 <sbrkfail+0x1ac>
}
    430c:	70e6                	ld	ra,120(sp)
    430e:	7446                	ld	s0,112(sp)
    4310:	74a6                	ld	s1,104(sp)
    4312:	7906                	ld	s2,96(sp)
    4314:	69e6                	ld	s3,88(sp)
    4316:	6a46                	ld	s4,80(sp)
    4318:	6aa6                	ld	s5,72(sp)
    431a:	6109                	addi	sp,sp,128
    431c:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    431e:	85d6                	mv	a1,s5
    4320:	00004517          	auipc	a0,0x4
    4324:	85850513          	addi	a0,a0,-1960 # 7b78 <malloc+0x2042>
    4328:	00001097          	auipc	ra,0x1
    432c:	74e080e7          	jalr	1870(ra) # 5a76 <printf>
    exit(1);
    4330:	4505                	li	a0,1
    4332:	00001097          	auipc	ra,0x1
    4336:	3c4080e7          	jalr	964(ra) # 56f6 <exit>
    printf("%s: fork failed\n", s);
    433a:	85d6                	mv	a1,s5
    433c:	00002517          	auipc	a0,0x2
    4340:	55450513          	addi	a0,a0,1364 # 6890 <malloc+0xd5a>
    4344:	00001097          	auipc	ra,0x1
    4348:	732080e7          	jalr	1842(ra) # 5a76 <printf>
    exit(1);
    434c:	4505                	li	a0,1
    434e:	00001097          	auipc	ra,0x1
    4352:	3a8080e7          	jalr	936(ra) # 56f6 <exit>
    a = sbrk(0);
    4356:	4501                	li	a0,0
    4358:	00001097          	auipc	ra,0x1
    435c:	426080e7          	jalr	1062(ra) # 577e <sbrk>
    4360:	892a                	mv	s2,a0
    sbrk(10*BIG);
    4362:	3e800537          	lui	a0,0x3e800
    4366:	00001097          	auipc	ra,0x1
    436a:	418080e7          	jalr	1048(ra) # 577e <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    436e:	874a                	mv	a4,s2
    4370:	3e8007b7          	lui	a5,0x3e800
    4374:	97ca                	add	a5,a5,s2
    4376:	6685                	lui	a3,0x1
      n += *(a+i);
    4378:	00074603          	lbu	a2,0(a4)
    437c:	9cb1                	addw	s1,s1,a2
    437e:	9736                	add	a4,a4,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4380:	fee79ce3          	bne	a5,a4,4378 <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    4384:	8626                	mv	a2,s1
    4386:	85d6                	mv	a1,s5
    4388:	00004517          	auipc	a0,0x4
    438c:	81050513          	addi	a0,a0,-2032 # 7b98 <malloc+0x2062>
    4390:	00001097          	auipc	ra,0x1
    4394:	6e6080e7          	jalr	1766(ra) # 5a76 <printf>
    exit(1);
    4398:	4505                	li	a0,1
    439a:	00001097          	auipc	ra,0x1
    439e:	35c080e7          	jalr	860(ra) # 56f6 <exit>
    exit(1);
    43a2:	4505                	li	a0,1
    43a4:	00001097          	auipc	ra,0x1
    43a8:	352080e7          	jalr	850(ra) # 56f6 <exit>

00000000000043ac <mem>:
{
    43ac:	7139                	addi	sp,sp,-64
    43ae:	fc06                	sd	ra,56(sp)
    43b0:	f822                	sd	s0,48(sp)
    43b2:	f426                	sd	s1,40(sp)
    43b4:	f04a                	sd	s2,32(sp)
    43b6:	ec4e                	sd	s3,24(sp)
    43b8:	0080                	addi	s0,sp,64
    43ba:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    43bc:	00001097          	auipc	ra,0x1
    43c0:	332080e7          	jalr	818(ra) # 56ee <fork>
    m1 = 0;
    43c4:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    43c6:	6909                	lui	s2,0x2
    43c8:	71190913          	addi	s2,s2,1809 # 2711 <sbrkbasic+0x12d>
  if((pid = fork()) == 0){
    43cc:	e135                	bnez	a0,4430 <mem+0x84>
    while((m2 = malloc(10001)) != 0){
    43ce:	854a                	mv	a0,s2
    43d0:	00001097          	auipc	ra,0x1
    43d4:	766080e7          	jalr	1894(ra) # 5b36 <malloc>
    43d8:	c501                	beqz	a0,43e0 <mem+0x34>
      *(char**)m2 = m1;
    43da:	e104                	sd	s1,0(a0)
      m1 = m2;
    43dc:	84aa                	mv	s1,a0
    43de:	bfc5                	j	43ce <mem+0x22>
    while(m1){
    43e0:	c899                	beqz	s1,43f6 <mem+0x4a>
      m2 = *(char**)m1;
    43e2:	0004b903          	ld	s2,0(s1)
      free(m1);
    43e6:	8526                	mv	a0,s1
    43e8:	00001097          	auipc	ra,0x1
    43ec:	6c4080e7          	jalr	1732(ra) # 5aac <free>
      m1 = m2;
    43f0:	84ca                	mv	s1,s2
    while(m1){
    43f2:	fe0918e3          	bnez	s2,43e2 <mem+0x36>
    m1 = malloc(1024*20);
    43f6:	6515                	lui	a0,0x5
    43f8:	00001097          	auipc	ra,0x1
    43fc:	73e080e7          	jalr	1854(ra) # 5b36 <malloc>
    if(m1 == 0){
    4400:	c911                	beqz	a0,4414 <mem+0x68>
    free(m1);
    4402:	00001097          	auipc	ra,0x1
    4406:	6aa080e7          	jalr	1706(ra) # 5aac <free>
    exit(0);
    440a:	4501                	li	a0,0
    440c:	00001097          	auipc	ra,0x1
    4410:	2ea080e7          	jalr	746(ra) # 56f6 <exit>
      printf("couldn't allocate mem?!!\n", s);
    4414:	85ce                	mv	a1,s3
    4416:	00003517          	auipc	a0,0x3
    441a:	7b250513          	addi	a0,a0,1970 # 7bc8 <malloc+0x2092>
    441e:	00001097          	auipc	ra,0x1
    4422:	658080e7          	jalr	1624(ra) # 5a76 <printf>
      exit(1);
    4426:	4505                	li	a0,1
    4428:	00001097          	auipc	ra,0x1
    442c:	2ce080e7          	jalr	718(ra) # 56f6 <exit>
    wait(&xstatus);
    4430:	fcc40513          	addi	a0,s0,-52
    4434:	00001097          	auipc	ra,0x1
    4438:	2ca080e7          	jalr	714(ra) # 56fe <wait>
    if(xstatus == -1){
    443c:	fcc42503          	lw	a0,-52(s0)
    4440:	57fd                	li	a5,-1
    4442:	00f50663          	beq	a0,a5,444e <mem+0xa2>
    exit(xstatus);
    4446:	00001097          	auipc	ra,0x1
    444a:	2b0080e7          	jalr	688(ra) # 56f6 <exit>
      exit(0);
    444e:	4501                	li	a0,0
    4450:	00001097          	auipc	ra,0x1
    4454:	2a6080e7          	jalr	678(ra) # 56f6 <exit>

0000000000004458 <sharedfd>:
{
    4458:	7159                	addi	sp,sp,-112
    445a:	f486                	sd	ra,104(sp)
    445c:	f0a2                	sd	s0,96(sp)
    445e:	eca6                	sd	s1,88(sp)
    4460:	e8ca                	sd	s2,80(sp)
    4462:	e4ce                	sd	s3,72(sp)
    4464:	e0d2                	sd	s4,64(sp)
    4466:	fc56                	sd	s5,56(sp)
    4468:	f85a                	sd	s6,48(sp)
    446a:	f45e                	sd	s7,40(sp)
    446c:	1880                	addi	s0,sp,112
    446e:	89aa                	mv	s3,a0
  unlink("sharedfd");
    4470:	00003517          	auipc	a0,0x3
    4474:	77850513          	addi	a0,a0,1912 # 7be8 <malloc+0x20b2>
    4478:	00001097          	auipc	ra,0x1
    447c:	2ce080e7          	jalr	718(ra) # 5746 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4480:	20200593          	li	a1,514
    4484:	00003517          	auipc	a0,0x3
    4488:	76450513          	addi	a0,a0,1892 # 7be8 <malloc+0x20b2>
    448c:	00001097          	auipc	ra,0x1
    4490:	2aa080e7          	jalr	682(ra) # 5736 <open>
  if(fd < 0){
    4494:	04054a63          	bltz	a0,44e8 <sharedfd+0x90>
    4498:	892a                	mv	s2,a0
  pid = fork();
    449a:	00001097          	auipc	ra,0x1
    449e:	254080e7          	jalr	596(ra) # 56ee <fork>
    44a2:	8a2a                	mv	s4,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    44a4:	06300593          	li	a1,99
    44a8:	c119                	beqz	a0,44ae <sharedfd+0x56>
    44aa:	07000593          	li	a1,112
    44ae:	4629                	li	a2,10
    44b0:	fa040513          	addi	a0,s0,-96
    44b4:	00001097          	auipc	ra,0x1
    44b8:	02c080e7          	jalr	44(ra) # 54e0 <memset>
    44bc:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    44c0:	4629                	li	a2,10
    44c2:	fa040593          	addi	a1,s0,-96
    44c6:	854a                	mv	a0,s2
    44c8:	00001097          	auipc	ra,0x1
    44cc:	24e080e7          	jalr	590(ra) # 5716 <write>
    44d0:	47a9                	li	a5,10
    44d2:	02f51963          	bne	a0,a5,4504 <sharedfd+0xac>
    44d6:	34fd                	addiw	s1,s1,-1
  for(i = 0; i < N; i++){
    44d8:	f4e5                	bnez	s1,44c0 <sharedfd+0x68>
  if(pid == 0) {
    44da:	040a1363          	bnez	s4,4520 <sharedfd+0xc8>
    exit(0);
    44de:	4501                	li	a0,0
    44e0:	00001097          	auipc	ra,0x1
    44e4:	216080e7          	jalr	534(ra) # 56f6 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    44e8:	85ce                	mv	a1,s3
    44ea:	00003517          	auipc	a0,0x3
    44ee:	70e50513          	addi	a0,a0,1806 # 7bf8 <malloc+0x20c2>
    44f2:	00001097          	auipc	ra,0x1
    44f6:	584080e7          	jalr	1412(ra) # 5a76 <printf>
    exit(1);
    44fa:	4505                	li	a0,1
    44fc:	00001097          	auipc	ra,0x1
    4500:	1fa080e7          	jalr	506(ra) # 56f6 <exit>
      printf("%s: write sharedfd failed\n", s);
    4504:	85ce                	mv	a1,s3
    4506:	00003517          	auipc	a0,0x3
    450a:	71a50513          	addi	a0,a0,1818 # 7c20 <malloc+0x20ea>
    450e:	00001097          	auipc	ra,0x1
    4512:	568080e7          	jalr	1384(ra) # 5a76 <printf>
      exit(1);
    4516:	4505                	li	a0,1
    4518:	00001097          	auipc	ra,0x1
    451c:	1de080e7          	jalr	478(ra) # 56f6 <exit>
    wait(&xstatus);
    4520:	f9c40513          	addi	a0,s0,-100
    4524:	00001097          	auipc	ra,0x1
    4528:	1da080e7          	jalr	474(ra) # 56fe <wait>
    if(xstatus != 0)
    452c:	f9c42a03          	lw	s4,-100(s0)
    4530:	000a0763          	beqz	s4,453e <sharedfd+0xe6>
      exit(xstatus);
    4534:	8552                	mv	a0,s4
    4536:	00001097          	auipc	ra,0x1
    453a:	1c0080e7          	jalr	448(ra) # 56f6 <exit>
  close(fd);
    453e:	854a                	mv	a0,s2
    4540:	00001097          	auipc	ra,0x1
    4544:	1de080e7          	jalr	478(ra) # 571e <close>
  fd = open("sharedfd", 0);
    4548:	4581                	li	a1,0
    454a:	00003517          	auipc	a0,0x3
    454e:	69e50513          	addi	a0,a0,1694 # 7be8 <malloc+0x20b2>
    4552:	00001097          	auipc	ra,0x1
    4556:	1e4080e7          	jalr	484(ra) # 5736 <open>
    455a:	8baa                	mv	s7,a0
  nc = np = 0;
    455c:	8ad2                	mv	s5,s4
  if(fd < 0){
    455e:	02054563          	bltz	a0,4588 <sharedfd+0x130>
    4562:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4566:	06300493          	li	s1,99
      if(buf[i] == 'p')
    456a:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    456e:	4629                	li	a2,10
    4570:	fa040593          	addi	a1,s0,-96
    4574:	855e                	mv	a0,s7
    4576:	00001097          	auipc	ra,0x1
    457a:	198080e7          	jalr	408(ra) # 570e <read>
    457e:	02a05f63          	blez	a0,45bc <sharedfd+0x164>
    4582:	fa040793          	addi	a5,s0,-96
    4586:	a01d                	j	45ac <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4588:	85ce                	mv	a1,s3
    458a:	00003517          	auipc	a0,0x3
    458e:	6b650513          	addi	a0,a0,1718 # 7c40 <malloc+0x210a>
    4592:	00001097          	auipc	ra,0x1
    4596:	4e4080e7          	jalr	1252(ra) # 5a76 <printf>
    exit(1);
    459a:	4505                	li	a0,1
    459c:	00001097          	auipc	ra,0x1
    45a0:	15a080e7          	jalr	346(ra) # 56f6 <exit>
        nc++;
    45a4:	2a05                	addiw	s4,s4,1
      if(buf[i] == 'p')
    45a6:	0785                	addi	a5,a5,1
    for(i = 0; i < sizeof(buf); i++){
    45a8:	fd2783e3          	beq	a5,s2,456e <sharedfd+0x116>
      if(buf[i] == 'c')
    45ac:	0007c703          	lbu	a4,0(a5) # 3e800000 <_end+0x3e7f1420>
    45b0:	fe970ae3          	beq	a4,s1,45a4 <sharedfd+0x14c>
      if(buf[i] == 'p')
    45b4:	ff6719e3          	bne	a4,s6,45a6 <sharedfd+0x14e>
        np++;
    45b8:	2a85                	addiw	s5,s5,1
    45ba:	b7f5                	j	45a6 <sharedfd+0x14e>
  close(fd);
    45bc:	855e                	mv	a0,s7
    45be:	00001097          	auipc	ra,0x1
    45c2:	160080e7          	jalr	352(ra) # 571e <close>
  unlink("sharedfd");
    45c6:	00003517          	auipc	a0,0x3
    45ca:	62250513          	addi	a0,a0,1570 # 7be8 <malloc+0x20b2>
    45ce:	00001097          	auipc	ra,0x1
    45d2:	178080e7          	jalr	376(ra) # 5746 <unlink>
  if(nc == N*SZ && np == N*SZ){
    45d6:	6789                	lui	a5,0x2
    45d8:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0x12c>
    45dc:	00fa1763          	bne	s4,a5,45ea <sharedfd+0x192>
    45e0:	6789                	lui	a5,0x2
    45e2:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0x12c>
    45e6:	02fa8063          	beq	s5,a5,4606 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    45ea:	85ce                	mv	a1,s3
    45ec:	00003517          	auipc	a0,0x3
    45f0:	67c50513          	addi	a0,a0,1660 # 7c68 <malloc+0x2132>
    45f4:	00001097          	auipc	ra,0x1
    45f8:	482080e7          	jalr	1154(ra) # 5a76 <printf>
    exit(1);
    45fc:	4505                	li	a0,1
    45fe:	00001097          	auipc	ra,0x1
    4602:	0f8080e7          	jalr	248(ra) # 56f6 <exit>
    exit(0);
    4606:	4501                	li	a0,0
    4608:	00001097          	auipc	ra,0x1
    460c:	0ee080e7          	jalr	238(ra) # 56f6 <exit>

0000000000004610 <fourfiles>:
{
    4610:	7135                	addi	sp,sp,-160
    4612:	ed06                	sd	ra,152(sp)
    4614:	e922                	sd	s0,144(sp)
    4616:	e526                	sd	s1,136(sp)
    4618:	e14a                	sd	s2,128(sp)
    461a:	fcce                	sd	s3,120(sp)
    461c:	f8d2                	sd	s4,112(sp)
    461e:	f4d6                	sd	s5,104(sp)
    4620:	f0da                	sd	s6,96(sp)
    4622:	ecde                	sd	s7,88(sp)
    4624:	e8e2                	sd	s8,80(sp)
    4626:	e4e6                	sd	s9,72(sp)
    4628:	e0ea                	sd	s10,64(sp)
    462a:	fc6e                	sd	s11,56(sp)
    462c:	1100                	addi	s0,sp,160
    462e:	8d2a                	mv	s10,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    4630:	00003797          	auipc	a5,0x3
    4634:	65078793          	addi	a5,a5,1616 # 7c80 <malloc+0x214a>
    4638:	f6f43823          	sd	a5,-144(s0)
    463c:	00003797          	auipc	a5,0x3
    4640:	64c78793          	addi	a5,a5,1612 # 7c88 <malloc+0x2152>
    4644:	f6f43c23          	sd	a5,-136(s0)
    4648:	00003797          	auipc	a5,0x3
    464c:	64878793          	addi	a5,a5,1608 # 7c90 <malloc+0x215a>
    4650:	f8f43023          	sd	a5,-128(s0)
    4654:	00003797          	auipc	a5,0x3
    4658:	64478793          	addi	a5,a5,1604 # 7c98 <malloc+0x2162>
    465c:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4660:	f7040b13          	addi	s6,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4664:	895a                	mv	s2,s6
  for(pi = 0; pi < NCHILD; pi++){
    4666:	4481                	li	s1,0
    4668:	4a11                	li	s4,4
    fname = names[pi];
    466a:	00093983          	ld	s3,0(s2)
    unlink(fname);
    466e:	854e                	mv	a0,s3
    4670:	00001097          	auipc	ra,0x1
    4674:	0d6080e7          	jalr	214(ra) # 5746 <unlink>
    pid = fork();
    4678:	00001097          	auipc	ra,0x1
    467c:	076080e7          	jalr	118(ra) # 56ee <fork>
    if(pid < 0){
    4680:	04054063          	bltz	a0,46c0 <fourfiles+0xb0>
    if(pid == 0){
    4684:	cd21                	beqz	a0,46dc <fourfiles+0xcc>
  for(pi = 0; pi < NCHILD; pi++){
    4686:	2485                	addiw	s1,s1,1
    4688:	0921                	addi	s2,s2,8
    468a:	ff4490e3          	bne	s1,s4,466a <fourfiles+0x5a>
    468e:	4491                	li	s1,4
    wait(&xstatus);
    4690:	f6c40513          	addi	a0,s0,-148
    4694:	00001097          	auipc	ra,0x1
    4698:	06a080e7          	jalr	106(ra) # 56fe <wait>
    if(xstatus != 0)
    469c:	f6c42503          	lw	a0,-148(s0)
    46a0:	e961                	bnez	a0,4770 <fourfiles+0x160>
    46a2:	34fd                	addiw	s1,s1,-1
  for(pi = 0; pi < NCHILD; pi++){
    46a4:	f4f5                	bnez	s1,4690 <fourfiles+0x80>
    46a6:	03000a93          	li	s5,48
    total = 0;
    46aa:	8daa                	mv	s11,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    46ac:	00007997          	auipc	s3,0x7
    46b0:	52498993          	addi	s3,s3,1316 # bbd0 <buf>
    if(total != N*SZ){
    46b4:	6c05                	lui	s8,0x1
    46b6:	770c0c13          	addi	s8,s8,1904 # 1770 <pipe1+0x1c>
  for(i = 0; i < NCHILD; i++){
    46ba:	03400c93          	li	s9,52
    46be:	aa15                	j	47f2 <fourfiles+0x1e2>
      printf("fork failed\n", s);
    46c0:	85ea                	mv	a1,s10
    46c2:	00002517          	auipc	a0,0x2
    46c6:	5d650513          	addi	a0,a0,1494 # 6c98 <malloc+0x1162>
    46ca:	00001097          	auipc	ra,0x1
    46ce:	3ac080e7          	jalr	940(ra) # 5a76 <printf>
      exit(1);
    46d2:	4505                	li	a0,1
    46d4:	00001097          	auipc	ra,0x1
    46d8:	022080e7          	jalr	34(ra) # 56f6 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    46dc:	20200593          	li	a1,514
    46e0:	854e                	mv	a0,s3
    46e2:	00001097          	auipc	ra,0x1
    46e6:	054080e7          	jalr	84(ra) # 5736 <open>
    46ea:	892a                	mv	s2,a0
      if(fd < 0){
    46ec:	04054663          	bltz	a0,4738 <fourfiles+0x128>
      memset(buf, '0'+pi, SZ);
    46f0:	1f400613          	li	a2,500
    46f4:	0304859b          	addiw	a1,s1,48
    46f8:	00007517          	auipc	a0,0x7
    46fc:	4d850513          	addi	a0,a0,1240 # bbd0 <buf>
    4700:	00001097          	auipc	ra,0x1
    4704:	de0080e7          	jalr	-544(ra) # 54e0 <memset>
    4708:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    470a:	00007997          	auipc	s3,0x7
    470e:	4c698993          	addi	s3,s3,1222 # bbd0 <buf>
    4712:	1f400613          	li	a2,500
    4716:	85ce                	mv	a1,s3
    4718:	854a                	mv	a0,s2
    471a:	00001097          	auipc	ra,0x1
    471e:	ffc080e7          	jalr	-4(ra) # 5716 <write>
    4722:	1f400793          	li	a5,500
    4726:	02f51763          	bne	a0,a5,4754 <fourfiles+0x144>
    472a:	34fd                	addiw	s1,s1,-1
      for(i = 0; i < N; i++){
    472c:	f0fd                	bnez	s1,4712 <fourfiles+0x102>
      exit(0);
    472e:	4501                	li	a0,0
    4730:	00001097          	auipc	ra,0x1
    4734:	fc6080e7          	jalr	-58(ra) # 56f6 <exit>
        printf("create failed\n", s);
    4738:	85ea                	mv	a1,s10
    473a:	00003517          	auipc	a0,0x3
    473e:	56650513          	addi	a0,a0,1382 # 7ca0 <malloc+0x216a>
    4742:	00001097          	auipc	ra,0x1
    4746:	334080e7          	jalr	820(ra) # 5a76 <printf>
        exit(1);
    474a:	4505                	li	a0,1
    474c:	00001097          	auipc	ra,0x1
    4750:	faa080e7          	jalr	-86(ra) # 56f6 <exit>
          printf("write failed %d\n", n);
    4754:	85aa                	mv	a1,a0
    4756:	00003517          	auipc	a0,0x3
    475a:	55a50513          	addi	a0,a0,1370 # 7cb0 <malloc+0x217a>
    475e:	00001097          	auipc	ra,0x1
    4762:	318080e7          	jalr	792(ra) # 5a76 <printf>
          exit(1);
    4766:	4505                	li	a0,1
    4768:	00001097          	auipc	ra,0x1
    476c:	f8e080e7          	jalr	-114(ra) # 56f6 <exit>
      exit(xstatus);
    4770:	00001097          	auipc	ra,0x1
    4774:	f86080e7          	jalr	-122(ra) # 56f6 <exit>
      total += n;
    4778:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    477c:	660d                	lui	a2,0x3
    477e:	85ce                	mv	a1,s3
    4780:	8552                	mv	a0,s4
    4782:	00001097          	auipc	ra,0x1
    4786:	f8c080e7          	jalr	-116(ra) # 570e <read>
    478a:	04a05463          	blez	a0,47d2 <fourfiles+0x1c2>
        if(buf[j] != '0'+i){
    478e:	0009c783          	lbu	a5,0(s3)
    4792:	02979263          	bne	a5,s1,47b6 <fourfiles+0x1a6>
    4796:	00007797          	auipc	a5,0x7
    479a:	43b78793          	addi	a5,a5,1083 # bbd1 <buf+0x1>
    479e:	fff5069b          	addiw	a3,a0,-1
    47a2:	1682                	slli	a3,a3,0x20
    47a4:	9281                	srli	a3,a3,0x20
    47a6:	96be                	add	a3,a3,a5
      for(j = 0; j < n; j++){
    47a8:	fcd788e3          	beq	a5,a3,4778 <fourfiles+0x168>
        if(buf[j] != '0'+i){
    47ac:	0007c703          	lbu	a4,0(a5)
    47b0:	0785                	addi	a5,a5,1
    47b2:	fe970be3          	beq	a4,s1,47a8 <fourfiles+0x198>
          printf("wrong char\n", s);
    47b6:	85ea                	mv	a1,s10
    47b8:	00003517          	auipc	a0,0x3
    47bc:	51050513          	addi	a0,a0,1296 # 7cc8 <malloc+0x2192>
    47c0:	00001097          	auipc	ra,0x1
    47c4:	2b6080e7          	jalr	694(ra) # 5a76 <printf>
          exit(1);
    47c8:	4505                	li	a0,1
    47ca:	00001097          	auipc	ra,0x1
    47ce:	f2c080e7          	jalr	-212(ra) # 56f6 <exit>
    close(fd);
    47d2:	8552                	mv	a0,s4
    47d4:	00001097          	auipc	ra,0x1
    47d8:	f4a080e7          	jalr	-182(ra) # 571e <close>
    if(total != N*SZ){
    47dc:	03891863          	bne	s2,s8,480c <fourfiles+0x1fc>
    unlink(fname);
    47e0:	855e                	mv	a0,s7
    47e2:	00001097          	auipc	ra,0x1
    47e6:	f64080e7          	jalr	-156(ra) # 5746 <unlink>
    47ea:	0b21                	addi	s6,s6,8
    47ec:	2a85                	addiw	s5,s5,1
  for(i = 0; i < NCHILD; i++){
    47ee:	039a8d63          	beq	s5,s9,4828 <fourfiles+0x218>
    fname = names[i];
    47f2:	000b3b83          	ld	s7,0(s6) # 3000 <dirtest+0x52>
    fd = open(fname, 0);
    47f6:	4581                	li	a1,0
    47f8:	855e                	mv	a0,s7
    47fa:	00001097          	auipc	ra,0x1
    47fe:	f3c080e7          	jalr	-196(ra) # 5736 <open>
    4802:	8a2a                	mv	s4,a0
    total = 0;
    4804:	896e                	mv	s2,s11
    4806:	000a849b          	sext.w	s1,s5
    while((n = read(fd, buf, sizeof(buf))) > 0){
    480a:	bf8d                	j	477c <fourfiles+0x16c>
      printf("wrong length %d\n", total);
    480c:	85ca                	mv	a1,s2
    480e:	00003517          	auipc	a0,0x3
    4812:	4ca50513          	addi	a0,a0,1226 # 7cd8 <malloc+0x21a2>
    4816:	00001097          	auipc	ra,0x1
    481a:	260080e7          	jalr	608(ra) # 5a76 <printf>
      exit(1);
    481e:	4505                	li	a0,1
    4820:	00001097          	auipc	ra,0x1
    4824:	ed6080e7          	jalr	-298(ra) # 56f6 <exit>
}
    4828:	60ea                	ld	ra,152(sp)
    482a:	644a                	ld	s0,144(sp)
    482c:	64aa                	ld	s1,136(sp)
    482e:	690a                	ld	s2,128(sp)
    4830:	79e6                	ld	s3,120(sp)
    4832:	7a46                	ld	s4,112(sp)
    4834:	7aa6                	ld	s5,104(sp)
    4836:	7b06                	ld	s6,96(sp)
    4838:	6be6                	ld	s7,88(sp)
    483a:	6c46                	ld	s8,80(sp)
    483c:	6ca6                	ld	s9,72(sp)
    483e:	6d06                	ld	s10,64(sp)
    4840:	7de2                	ld	s11,56(sp)
    4842:	610d                	addi	sp,sp,160
    4844:	8082                	ret

0000000000004846 <concreate>:
{
    4846:	7135                	addi	sp,sp,-160
    4848:	ed06                	sd	ra,152(sp)
    484a:	e922                	sd	s0,144(sp)
    484c:	e526                	sd	s1,136(sp)
    484e:	e14a                	sd	s2,128(sp)
    4850:	fcce                	sd	s3,120(sp)
    4852:	f8d2                	sd	s4,112(sp)
    4854:	f4d6                	sd	s5,104(sp)
    4856:	f0da                	sd	s6,96(sp)
    4858:	ecde                	sd	s7,88(sp)
    485a:	1100                	addi	s0,sp,160
    485c:	89aa                	mv	s3,a0
  file[0] = 'C';
    485e:	04300793          	li	a5,67
    4862:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4866:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    486a:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    486c:	4b0d                	li	s6,3
    486e:	4a85                	li	s5,1
      link("C0", file);
    4870:	00003b97          	auipc	s7,0x3
    4874:	480b8b93          	addi	s7,s7,1152 # 7cf0 <malloc+0x21ba>
  for(i = 0; i < N; i++){
    4878:	02800a13          	li	s4,40
    487c:	acc1                	j	4b4c <concreate+0x306>
      link("C0", file);
    487e:	fa840593          	addi	a1,s0,-88
    4882:	855e                	mv	a0,s7
    4884:	00001097          	auipc	ra,0x1
    4888:	ed2080e7          	jalr	-302(ra) # 5756 <link>
    if(pid == 0) {
    488c:	a45d                	j	4b32 <concreate+0x2ec>
    } else if(pid == 0 && (i % 5) == 1){
    488e:	4795                	li	a5,5
    4890:	02f9693b          	remw	s2,s2,a5
    4894:	4785                	li	a5,1
    4896:	02f90b63          	beq	s2,a5,48cc <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    489a:	20200593          	li	a1,514
    489e:	fa840513          	addi	a0,s0,-88
    48a2:	00001097          	auipc	ra,0x1
    48a6:	e94080e7          	jalr	-364(ra) # 5736 <open>
      if(fd < 0){
    48aa:	26055b63          	bgez	a0,4b20 <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    48ae:	fa840593          	addi	a1,s0,-88
    48b2:	00003517          	auipc	a0,0x3
    48b6:	44650513          	addi	a0,a0,1094 # 7cf8 <malloc+0x21c2>
    48ba:	00001097          	auipc	ra,0x1
    48be:	1bc080e7          	jalr	444(ra) # 5a76 <printf>
        exit(1);
    48c2:	4505                	li	a0,1
    48c4:	00001097          	auipc	ra,0x1
    48c8:	e32080e7          	jalr	-462(ra) # 56f6 <exit>
      link("C0", file);
    48cc:	fa840593          	addi	a1,s0,-88
    48d0:	00003517          	auipc	a0,0x3
    48d4:	42050513          	addi	a0,a0,1056 # 7cf0 <malloc+0x21ba>
    48d8:	00001097          	auipc	ra,0x1
    48dc:	e7e080e7          	jalr	-386(ra) # 5756 <link>
      exit(0);
    48e0:	4501                	li	a0,0
    48e2:	00001097          	auipc	ra,0x1
    48e6:	e14080e7          	jalr	-492(ra) # 56f6 <exit>
        exit(1);
    48ea:	4505                	li	a0,1
    48ec:	00001097          	auipc	ra,0x1
    48f0:	e0a080e7          	jalr	-502(ra) # 56f6 <exit>
  memset(fa, 0, sizeof(fa));
    48f4:	02800613          	li	a2,40
    48f8:	4581                	li	a1,0
    48fa:	f8040513          	addi	a0,s0,-128
    48fe:	00001097          	auipc	ra,0x1
    4902:	be2080e7          	jalr	-1054(ra) # 54e0 <memset>
  fd = open(".", 0);
    4906:	4581                	li	a1,0
    4908:	00002517          	auipc	a0,0x2
    490c:	de850513          	addi	a0,a0,-536 # 66f0 <malloc+0xbba>
    4910:	00001097          	auipc	ra,0x1
    4914:	e26080e7          	jalr	-474(ra) # 5736 <open>
    4918:	892a                	mv	s2,a0
  n = 0;
    491a:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    491c:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4920:	02700b13          	li	s6,39
      fa[i] = 1;
    4924:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4926:	4641                	li	a2,16
    4928:	f7040593          	addi	a1,s0,-144
    492c:	854a                	mv	a0,s2
    492e:	00001097          	auipc	ra,0x1
    4932:	de0080e7          	jalr	-544(ra) # 570e <read>
    4936:	08a05163          	blez	a0,49b8 <concreate+0x172>
    if(de.inum == 0)
    493a:	f7045783          	lhu	a5,-144(s0)
    493e:	d7e5                	beqz	a5,4926 <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4940:	f7244783          	lbu	a5,-142(s0)
    4944:	ff4791e3          	bne	a5,s4,4926 <concreate+0xe0>
    4948:	f7444783          	lbu	a5,-140(s0)
    494c:	ffe9                	bnez	a5,4926 <concreate+0xe0>
      i = de.name[1] - '0';
    494e:	f7344783          	lbu	a5,-141(s0)
    4952:	fd07879b          	addiw	a5,a5,-48
    4956:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    495a:	00eb6f63          	bltu	s6,a4,4978 <concreate+0x132>
      if(fa[i]){
    495e:	fb040793          	addi	a5,s0,-80
    4962:	97ba                	add	a5,a5,a4
    4964:	fd07c783          	lbu	a5,-48(a5)
    4968:	eb85                	bnez	a5,4998 <concreate+0x152>
      fa[i] = 1;
    496a:	fb040793          	addi	a5,s0,-80
    496e:	973e                	add	a4,a4,a5
    4970:	fd770823          	sb	s7,-48(a4)
      n++;
    4974:	2a85                	addiw	s5,s5,1
    4976:	bf45                	j	4926 <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4978:	f7240613          	addi	a2,s0,-142
    497c:	85ce                	mv	a1,s3
    497e:	00003517          	auipc	a0,0x3
    4982:	39a50513          	addi	a0,a0,922 # 7d18 <malloc+0x21e2>
    4986:	00001097          	auipc	ra,0x1
    498a:	0f0080e7          	jalr	240(ra) # 5a76 <printf>
        exit(1);
    498e:	4505                	li	a0,1
    4990:	00001097          	auipc	ra,0x1
    4994:	d66080e7          	jalr	-666(ra) # 56f6 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4998:	f7240613          	addi	a2,s0,-142
    499c:	85ce                	mv	a1,s3
    499e:	00003517          	auipc	a0,0x3
    49a2:	39a50513          	addi	a0,a0,922 # 7d38 <malloc+0x2202>
    49a6:	00001097          	auipc	ra,0x1
    49aa:	0d0080e7          	jalr	208(ra) # 5a76 <printf>
        exit(1);
    49ae:	4505                	li	a0,1
    49b0:	00001097          	auipc	ra,0x1
    49b4:	d46080e7          	jalr	-698(ra) # 56f6 <exit>
  close(fd);
    49b8:	854a                	mv	a0,s2
    49ba:	00001097          	auipc	ra,0x1
    49be:	d64080e7          	jalr	-668(ra) # 571e <close>
  if(n != N){
    49c2:	02800793          	li	a5,40
    49c6:	00fa9763          	bne	s5,a5,49d4 <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    49ca:	4a8d                	li	s5,3
    49cc:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    49ce:	02800a13          	li	s4,40
    49d2:	a8c9                	j	4aa4 <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    49d4:	85ce                	mv	a1,s3
    49d6:	00003517          	auipc	a0,0x3
    49da:	38a50513          	addi	a0,a0,906 # 7d60 <malloc+0x222a>
    49de:	00001097          	auipc	ra,0x1
    49e2:	098080e7          	jalr	152(ra) # 5a76 <printf>
    exit(1);
    49e6:	4505                	li	a0,1
    49e8:	00001097          	auipc	ra,0x1
    49ec:	d0e080e7          	jalr	-754(ra) # 56f6 <exit>
      printf("%s: fork failed\n", s);
    49f0:	85ce                	mv	a1,s3
    49f2:	00002517          	auipc	a0,0x2
    49f6:	e9e50513          	addi	a0,a0,-354 # 6890 <malloc+0xd5a>
    49fa:	00001097          	auipc	ra,0x1
    49fe:	07c080e7          	jalr	124(ra) # 5a76 <printf>
      exit(1);
    4a02:	4505                	li	a0,1
    4a04:	00001097          	auipc	ra,0x1
    4a08:	cf2080e7          	jalr	-782(ra) # 56f6 <exit>
      close(open(file, 0));
    4a0c:	4581                	li	a1,0
    4a0e:	fa840513          	addi	a0,s0,-88
    4a12:	00001097          	auipc	ra,0x1
    4a16:	d24080e7          	jalr	-732(ra) # 5736 <open>
    4a1a:	00001097          	auipc	ra,0x1
    4a1e:	d04080e7          	jalr	-764(ra) # 571e <close>
      close(open(file, 0));
    4a22:	4581                	li	a1,0
    4a24:	fa840513          	addi	a0,s0,-88
    4a28:	00001097          	auipc	ra,0x1
    4a2c:	d0e080e7          	jalr	-754(ra) # 5736 <open>
    4a30:	00001097          	auipc	ra,0x1
    4a34:	cee080e7          	jalr	-786(ra) # 571e <close>
      close(open(file, 0));
    4a38:	4581                	li	a1,0
    4a3a:	fa840513          	addi	a0,s0,-88
    4a3e:	00001097          	auipc	ra,0x1
    4a42:	cf8080e7          	jalr	-776(ra) # 5736 <open>
    4a46:	00001097          	auipc	ra,0x1
    4a4a:	cd8080e7          	jalr	-808(ra) # 571e <close>
      close(open(file, 0));
    4a4e:	4581                	li	a1,0
    4a50:	fa840513          	addi	a0,s0,-88
    4a54:	00001097          	auipc	ra,0x1
    4a58:	ce2080e7          	jalr	-798(ra) # 5736 <open>
    4a5c:	00001097          	auipc	ra,0x1
    4a60:	cc2080e7          	jalr	-830(ra) # 571e <close>
      close(open(file, 0));
    4a64:	4581                	li	a1,0
    4a66:	fa840513          	addi	a0,s0,-88
    4a6a:	00001097          	auipc	ra,0x1
    4a6e:	ccc080e7          	jalr	-820(ra) # 5736 <open>
    4a72:	00001097          	auipc	ra,0x1
    4a76:	cac080e7          	jalr	-852(ra) # 571e <close>
      close(open(file, 0));
    4a7a:	4581                	li	a1,0
    4a7c:	fa840513          	addi	a0,s0,-88
    4a80:	00001097          	auipc	ra,0x1
    4a84:	cb6080e7          	jalr	-842(ra) # 5736 <open>
    4a88:	00001097          	auipc	ra,0x1
    4a8c:	c96080e7          	jalr	-874(ra) # 571e <close>
    if(pid == 0)
    4a90:	08090363          	beqz	s2,4b16 <concreate+0x2d0>
      wait(0);
    4a94:	4501                	li	a0,0
    4a96:	00001097          	auipc	ra,0x1
    4a9a:	c68080e7          	jalr	-920(ra) # 56fe <wait>
  for(i = 0; i < N; i++){
    4a9e:	2485                	addiw	s1,s1,1
    4aa0:	0f448563          	beq	s1,s4,4b8a <concreate+0x344>
    file[1] = '0' + i;
    4aa4:	0304879b          	addiw	a5,s1,48
    4aa8:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    4aac:	00001097          	auipc	ra,0x1
    4ab0:	c42080e7          	jalr	-958(ra) # 56ee <fork>
    4ab4:	892a                	mv	s2,a0
    if(pid < 0){
    4ab6:	f2054de3          	bltz	a0,49f0 <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    4aba:	0354e73b          	remw	a4,s1,s5
    4abe:	00a767b3          	or	a5,a4,a0
    4ac2:	2781                	sext.w	a5,a5
    4ac4:	d7a1                	beqz	a5,4a0c <concreate+0x1c6>
    4ac6:	01671363          	bne	a4,s6,4acc <concreate+0x286>
       ((i % 3) == 1 && pid != 0)){
    4aca:	f129                	bnez	a0,4a0c <concreate+0x1c6>
      unlink(file);
    4acc:	fa840513          	addi	a0,s0,-88
    4ad0:	00001097          	auipc	ra,0x1
    4ad4:	c76080e7          	jalr	-906(ra) # 5746 <unlink>
      unlink(file);
    4ad8:	fa840513          	addi	a0,s0,-88
    4adc:	00001097          	auipc	ra,0x1
    4ae0:	c6a080e7          	jalr	-918(ra) # 5746 <unlink>
      unlink(file);
    4ae4:	fa840513          	addi	a0,s0,-88
    4ae8:	00001097          	auipc	ra,0x1
    4aec:	c5e080e7          	jalr	-930(ra) # 5746 <unlink>
      unlink(file);
    4af0:	fa840513          	addi	a0,s0,-88
    4af4:	00001097          	auipc	ra,0x1
    4af8:	c52080e7          	jalr	-942(ra) # 5746 <unlink>
      unlink(file);
    4afc:	fa840513          	addi	a0,s0,-88
    4b00:	00001097          	auipc	ra,0x1
    4b04:	c46080e7          	jalr	-954(ra) # 5746 <unlink>
      unlink(file);
    4b08:	fa840513          	addi	a0,s0,-88
    4b0c:	00001097          	auipc	ra,0x1
    4b10:	c3a080e7          	jalr	-966(ra) # 5746 <unlink>
    4b14:	bfb5                	j	4a90 <concreate+0x24a>
      exit(0);
    4b16:	4501                	li	a0,0
    4b18:	00001097          	auipc	ra,0x1
    4b1c:	bde080e7          	jalr	-1058(ra) # 56f6 <exit>
      close(fd);
    4b20:	00001097          	auipc	ra,0x1
    4b24:	bfe080e7          	jalr	-1026(ra) # 571e <close>
    if(pid == 0) {
    4b28:	bb65                	j	48e0 <concreate+0x9a>
      close(fd);
    4b2a:	00001097          	auipc	ra,0x1
    4b2e:	bf4080e7          	jalr	-1036(ra) # 571e <close>
      wait(&xstatus);
    4b32:	f6c40513          	addi	a0,s0,-148
    4b36:	00001097          	auipc	ra,0x1
    4b3a:	bc8080e7          	jalr	-1080(ra) # 56fe <wait>
      if(xstatus != 0)
    4b3e:	f6c42483          	lw	s1,-148(s0)
    4b42:	da0494e3          	bnez	s1,48ea <concreate+0xa4>
  for(i = 0; i < N; i++){
    4b46:	2905                	addiw	s2,s2,1
    4b48:	db4906e3          	beq	s2,s4,48f4 <concreate+0xae>
    file[1] = '0' + i;
    4b4c:	0309079b          	addiw	a5,s2,48
    4b50:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4b54:	fa840513          	addi	a0,s0,-88
    4b58:	00001097          	auipc	ra,0x1
    4b5c:	bee080e7          	jalr	-1042(ra) # 5746 <unlink>
    pid = fork();
    4b60:	00001097          	auipc	ra,0x1
    4b64:	b8e080e7          	jalr	-1138(ra) # 56ee <fork>
    if(pid && (i % 3) == 1){
    4b68:	d20503e3          	beqz	a0,488e <concreate+0x48>
    4b6c:	036967bb          	remw	a5,s2,s6
    4b70:	d15787e3          	beq	a5,s5,487e <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4b74:	20200593          	li	a1,514
    4b78:	fa840513          	addi	a0,s0,-88
    4b7c:	00001097          	auipc	ra,0x1
    4b80:	bba080e7          	jalr	-1094(ra) # 5736 <open>
      if(fd < 0){
    4b84:	fa0553e3          	bgez	a0,4b2a <concreate+0x2e4>
    4b88:	b31d                	j	48ae <concreate+0x68>
}
    4b8a:	60ea                	ld	ra,152(sp)
    4b8c:	644a                	ld	s0,144(sp)
    4b8e:	64aa                	ld	s1,136(sp)
    4b90:	690a                	ld	s2,128(sp)
    4b92:	79e6                	ld	s3,120(sp)
    4b94:	7a46                	ld	s4,112(sp)
    4b96:	7aa6                	ld	s5,104(sp)
    4b98:	7b06                	ld	s6,96(sp)
    4b9a:	6be6                	ld	s7,88(sp)
    4b9c:	610d                	addi	sp,sp,160
    4b9e:	8082                	ret

0000000000004ba0 <bigfile>:
{
    4ba0:	7139                	addi	sp,sp,-64
    4ba2:	fc06                	sd	ra,56(sp)
    4ba4:	f822                	sd	s0,48(sp)
    4ba6:	f426                	sd	s1,40(sp)
    4ba8:	f04a                	sd	s2,32(sp)
    4baa:	ec4e                	sd	s3,24(sp)
    4bac:	e852                	sd	s4,16(sp)
    4bae:	e456                	sd	s5,8(sp)
    4bb0:	0080                	addi	s0,sp,64
    4bb2:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4bb4:	00003517          	auipc	a0,0x3
    4bb8:	1e450513          	addi	a0,a0,484 # 7d98 <malloc+0x2262>
    4bbc:	00001097          	auipc	ra,0x1
    4bc0:	b8a080e7          	jalr	-1142(ra) # 5746 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4bc4:	20200593          	li	a1,514
    4bc8:	00003517          	auipc	a0,0x3
    4bcc:	1d050513          	addi	a0,a0,464 # 7d98 <malloc+0x2262>
    4bd0:	00001097          	auipc	ra,0x1
    4bd4:	b66080e7          	jalr	-1178(ra) # 5736 <open>
    4bd8:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    4bda:	4481                	li	s1,0
    memset(buf, i, SZ);
    4bdc:	00007917          	auipc	s2,0x7
    4be0:	ff490913          	addi	s2,s2,-12 # bbd0 <buf>
  for(i = 0; i < N; i++){
    4be4:	4a51                	li	s4,20
  if(fd < 0){
    4be6:	0a054063          	bltz	a0,4c86 <bigfile+0xe6>
    memset(buf, i, SZ);
    4bea:	25800613          	li	a2,600
    4bee:	85a6                	mv	a1,s1
    4bf0:	854a                	mv	a0,s2
    4bf2:	00001097          	auipc	ra,0x1
    4bf6:	8ee080e7          	jalr	-1810(ra) # 54e0 <memset>
    if(write(fd, buf, SZ) != SZ){
    4bfa:	25800613          	li	a2,600
    4bfe:	85ca                	mv	a1,s2
    4c00:	854e                	mv	a0,s3
    4c02:	00001097          	auipc	ra,0x1
    4c06:	b14080e7          	jalr	-1260(ra) # 5716 <write>
    4c0a:	25800793          	li	a5,600
    4c0e:	08f51a63          	bne	a0,a5,4ca2 <bigfile+0x102>
  for(i = 0; i < N; i++){
    4c12:	2485                	addiw	s1,s1,1
    4c14:	fd449be3          	bne	s1,s4,4bea <bigfile+0x4a>
  close(fd);
    4c18:	854e                	mv	a0,s3
    4c1a:	00001097          	auipc	ra,0x1
    4c1e:	b04080e7          	jalr	-1276(ra) # 571e <close>
  fd = open("bigfile.dat", 0);
    4c22:	4581                	li	a1,0
    4c24:	00003517          	auipc	a0,0x3
    4c28:	17450513          	addi	a0,a0,372 # 7d98 <malloc+0x2262>
    4c2c:	00001097          	auipc	ra,0x1
    4c30:	b0a080e7          	jalr	-1270(ra) # 5736 <open>
    4c34:	8a2a                	mv	s4,a0
  total = 0;
    4c36:	4981                	li	s3,0
  for(i = 0; ; i++){
    4c38:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4c3a:	00007917          	auipc	s2,0x7
    4c3e:	f9690913          	addi	s2,s2,-106 # bbd0 <buf>
  if(fd < 0){
    4c42:	06054e63          	bltz	a0,4cbe <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    4c46:	12c00613          	li	a2,300
    4c4a:	85ca                	mv	a1,s2
    4c4c:	8552                	mv	a0,s4
    4c4e:	00001097          	auipc	ra,0x1
    4c52:	ac0080e7          	jalr	-1344(ra) # 570e <read>
    if(cc < 0){
    4c56:	08054263          	bltz	a0,4cda <bigfile+0x13a>
    if(cc == 0)
    4c5a:	c971                	beqz	a0,4d2e <bigfile+0x18e>
    if(cc != SZ/2){
    4c5c:	12c00793          	li	a5,300
    4c60:	08f51b63          	bne	a0,a5,4cf6 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4c64:	01f4d79b          	srliw	a5,s1,0x1f
    4c68:	9fa5                	addw	a5,a5,s1
    4c6a:	4017d79b          	sraiw	a5,a5,0x1
    4c6e:	00094703          	lbu	a4,0(s2)
    4c72:	0af71063          	bne	a4,a5,4d12 <bigfile+0x172>
    4c76:	12b94703          	lbu	a4,299(s2)
    4c7a:	08f71c63          	bne	a4,a5,4d12 <bigfile+0x172>
    total += cc;
    4c7e:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    4c82:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4c84:	b7c9                	j	4c46 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4c86:	85d6                	mv	a1,s5
    4c88:	00003517          	auipc	a0,0x3
    4c8c:	12050513          	addi	a0,a0,288 # 7da8 <malloc+0x2272>
    4c90:	00001097          	auipc	ra,0x1
    4c94:	de6080e7          	jalr	-538(ra) # 5a76 <printf>
    exit(1);
    4c98:	4505                	li	a0,1
    4c9a:	00001097          	auipc	ra,0x1
    4c9e:	a5c080e7          	jalr	-1444(ra) # 56f6 <exit>
      printf("%s: write bigfile failed\n", s);
    4ca2:	85d6                	mv	a1,s5
    4ca4:	00003517          	auipc	a0,0x3
    4ca8:	12450513          	addi	a0,a0,292 # 7dc8 <malloc+0x2292>
    4cac:	00001097          	auipc	ra,0x1
    4cb0:	dca080e7          	jalr	-566(ra) # 5a76 <printf>
      exit(1);
    4cb4:	4505                	li	a0,1
    4cb6:	00001097          	auipc	ra,0x1
    4cba:	a40080e7          	jalr	-1472(ra) # 56f6 <exit>
    printf("%s: cannot open bigfile\n", s);
    4cbe:	85d6                	mv	a1,s5
    4cc0:	00003517          	auipc	a0,0x3
    4cc4:	12850513          	addi	a0,a0,296 # 7de8 <malloc+0x22b2>
    4cc8:	00001097          	auipc	ra,0x1
    4ccc:	dae080e7          	jalr	-594(ra) # 5a76 <printf>
    exit(1);
    4cd0:	4505                	li	a0,1
    4cd2:	00001097          	auipc	ra,0x1
    4cd6:	a24080e7          	jalr	-1500(ra) # 56f6 <exit>
      printf("%s: read bigfile failed\n", s);
    4cda:	85d6                	mv	a1,s5
    4cdc:	00003517          	auipc	a0,0x3
    4ce0:	12c50513          	addi	a0,a0,300 # 7e08 <malloc+0x22d2>
    4ce4:	00001097          	auipc	ra,0x1
    4ce8:	d92080e7          	jalr	-622(ra) # 5a76 <printf>
      exit(1);
    4cec:	4505                	li	a0,1
    4cee:	00001097          	auipc	ra,0x1
    4cf2:	a08080e7          	jalr	-1528(ra) # 56f6 <exit>
      printf("%s: short read bigfile\n", s);
    4cf6:	85d6                	mv	a1,s5
    4cf8:	00003517          	auipc	a0,0x3
    4cfc:	13050513          	addi	a0,a0,304 # 7e28 <malloc+0x22f2>
    4d00:	00001097          	auipc	ra,0x1
    4d04:	d76080e7          	jalr	-650(ra) # 5a76 <printf>
      exit(1);
    4d08:	4505                	li	a0,1
    4d0a:	00001097          	auipc	ra,0x1
    4d0e:	9ec080e7          	jalr	-1556(ra) # 56f6 <exit>
      printf("%s: read bigfile wrong data\n", s);
    4d12:	85d6                	mv	a1,s5
    4d14:	00003517          	auipc	a0,0x3
    4d18:	12c50513          	addi	a0,a0,300 # 7e40 <malloc+0x230a>
    4d1c:	00001097          	auipc	ra,0x1
    4d20:	d5a080e7          	jalr	-678(ra) # 5a76 <printf>
      exit(1);
    4d24:	4505                	li	a0,1
    4d26:	00001097          	auipc	ra,0x1
    4d2a:	9d0080e7          	jalr	-1584(ra) # 56f6 <exit>
  close(fd);
    4d2e:	8552                	mv	a0,s4
    4d30:	00001097          	auipc	ra,0x1
    4d34:	9ee080e7          	jalr	-1554(ra) # 571e <close>
  if(total != N*SZ){
    4d38:	678d                	lui	a5,0x3
    4d3a:	ee078793          	addi	a5,a5,-288 # 2ee0 <exitiputtest+0x1a>
    4d3e:	02f99363          	bne	s3,a5,4d64 <bigfile+0x1c4>
  unlink("bigfile.dat");
    4d42:	00003517          	auipc	a0,0x3
    4d46:	05650513          	addi	a0,a0,86 # 7d98 <malloc+0x2262>
    4d4a:	00001097          	auipc	ra,0x1
    4d4e:	9fc080e7          	jalr	-1540(ra) # 5746 <unlink>
}
    4d52:	70e2                	ld	ra,56(sp)
    4d54:	7442                	ld	s0,48(sp)
    4d56:	74a2                	ld	s1,40(sp)
    4d58:	7902                	ld	s2,32(sp)
    4d5a:	69e2                	ld	s3,24(sp)
    4d5c:	6a42                	ld	s4,16(sp)
    4d5e:	6aa2                	ld	s5,8(sp)
    4d60:	6121                	addi	sp,sp,64
    4d62:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4d64:	85d6                	mv	a1,s5
    4d66:	00003517          	auipc	a0,0x3
    4d6a:	0fa50513          	addi	a0,a0,250 # 7e60 <malloc+0x232a>
    4d6e:	00001097          	auipc	ra,0x1
    4d72:	d08080e7          	jalr	-760(ra) # 5a76 <printf>
    exit(1);
    4d76:	4505                	li	a0,1
    4d78:	00001097          	auipc	ra,0x1
    4d7c:	97e080e7          	jalr	-1666(ra) # 56f6 <exit>

0000000000004d80 <fsfull>:
{
    4d80:	7171                	addi	sp,sp,-176
    4d82:	f506                	sd	ra,168(sp)
    4d84:	f122                	sd	s0,160(sp)
    4d86:	ed26                	sd	s1,152(sp)
    4d88:	e94a                	sd	s2,144(sp)
    4d8a:	e54e                	sd	s3,136(sp)
    4d8c:	e152                	sd	s4,128(sp)
    4d8e:	fcd6                	sd	s5,120(sp)
    4d90:	f8da                	sd	s6,112(sp)
    4d92:	f4de                	sd	s7,104(sp)
    4d94:	f0e2                	sd	s8,96(sp)
    4d96:	ece6                	sd	s9,88(sp)
    4d98:	e8ea                	sd	s10,80(sp)
    4d9a:	e4ee                	sd	s11,72(sp)
    4d9c:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4d9e:	00003517          	auipc	a0,0x3
    4da2:	0e250513          	addi	a0,a0,226 # 7e80 <malloc+0x234a>
    4da6:	00001097          	auipc	ra,0x1
    4daa:	cd0080e7          	jalr	-816(ra) # 5a76 <printf>
  for(nfiles = 0; ; nfiles++){
    4dae:	4481                	li	s1,0
    name[0] = 'f';
    4db0:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4db4:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4db8:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4dbc:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4dbe:	00003c97          	auipc	s9,0x3
    4dc2:	0d2c8c93          	addi	s9,s9,210 # 7e90 <malloc+0x235a>
    int total = 0;
    4dc6:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    4dc8:	00007a17          	auipc	s4,0x7
    4dcc:	e08a0a13          	addi	s4,s4,-504 # bbd0 <buf>
    name[0] = 'f';
    4dd0:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4dd4:	0384c7bb          	divw	a5,s1,s8
    4dd8:	0307879b          	addiw	a5,a5,48
    4ddc:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4de0:	0384e7bb          	remw	a5,s1,s8
    4de4:	0377c7bb          	divw	a5,a5,s7
    4de8:	0307879b          	addiw	a5,a5,48
    4dec:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4df0:	0374e7bb          	remw	a5,s1,s7
    4df4:	0367c7bb          	divw	a5,a5,s6
    4df8:	0307879b          	addiw	a5,a5,48
    4dfc:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4e00:	0364e7bb          	remw	a5,s1,s6
    4e04:	0307879b          	addiw	a5,a5,48
    4e08:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4e0c:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4e10:	f5040593          	addi	a1,s0,-176
    4e14:	8566                	mv	a0,s9
    4e16:	00001097          	auipc	ra,0x1
    4e1a:	c60080e7          	jalr	-928(ra) # 5a76 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4e1e:	20200593          	li	a1,514
    4e22:	f5040513          	addi	a0,s0,-176
    4e26:	00001097          	auipc	ra,0x1
    4e2a:	910080e7          	jalr	-1776(ra) # 5736 <open>
    4e2e:	89aa                	mv	s3,a0
    if(fd < 0){
    4e30:	0a055663          	bgez	a0,4edc <fsfull+0x15c>
      printf("open %s failed\n", name);
    4e34:	f5040593          	addi	a1,s0,-176
    4e38:	00003517          	auipc	a0,0x3
    4e3c:	06850513          	addi	a0,a0,104 # 7ea0 <malloc+0x236a>
    4e40:	00001097          	auipc	ra,0x1
    4e44:	c36080e7          	jalr	-970(ra) # 5a76 <printf>
  while(nfiles >= 0){
    4e48:	0604c363          	bltz	s1,4eae <fsfull+0x12e>
    name[0] = 'f';
    4e4c:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4e50:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4e54:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4e58:	4929                	li	s2,10
  while(nfiles >= 0){
    4e5a:	5afd                	li	s5,-1
    name[0] = 'f';
    4e5c:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4e60:	0344c7bb          	divw	a5,s1,s4
    4e64:	0307879b          	addiw	a5,a5,48
    4e68:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4e6c:	0344e7bb          	remw	a5,s1,s4
    4e70:	0337c7bb          	divw	a5,a5,s3
    4e74:	0307879b          	addiw	a5,a5,48
    4e78:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4e7c:	0334e7bb          	remw	a5,s1,s3
    4e80:	0327c7bb          	divw	a5,a5,s2
    4e84:	0307879b          	addiw	a5,a5,48
    4e88:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4e8c:	0324e7bb          	remw	a5,s1,s2
    4e90:	0307879b          	addiw	a5,a5,48
    4e94:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4e98:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4e9c:	f5040513          	addi	a0,s0,-176
    4ea0:	00001097          	auipc	ra,0x1
    4ea4:	8a6080e7          	jalr	-1882(ra) # 5746 <unlink>
    nfiles--;
    4ea8:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    4eaa:	fb5499e3          	bne	s1,s5,4e5c <fsfull+0xdc>
  printf("fsfull test finished\n");
    4eae:	00003517          	auipc	a0,0x3
    4eb2:	01250513          	addi	a0,a0,18 # 7ec0 <malloc+0x238a>
    4eb6:	00001097          	auipc	ra,0x1
    4eba:	bc0080e7          	jalr	-1088(ra) # 5a76 <printf>
}
    4ebe:	70aa                	ld	ra,168(sp)
    4ec0:	740a                	ld	s0,160(sp)
    4ec2:	64ea                	ld	s1,152(sp)
    4ec4:	694a                	ld	s2,144(sp)
    4ec6:	69aa                	ld	s3,136(sp)
    4ec8:	6a0a                	ld	s4,128(sp)
    4eca:	7ae6                	ld	s5,120(sp)
    4ecc:	7b46                	ld	s6,112(sp)
    4ece:	7ba6                	ld	s7,104(sp)
    4ed0:	7c06                	ld	s8,96(sp)
    4ed2:	6ce6                	ld	s9,88(sp)
    4ed4:	6d46                	ld	s10,80(sp)
    4ed6:	6da6                	ld	s11,72(sp)
    4ed8:	614d                	addi	sp,sp,176
    4eda:	8082                	ret
    int total = 0;
    4edc:	896e                	mv	s2,s11
      if(cc < BSIZE)
    4ede:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    4ee2:	40000613          	li	a2,1024
    4ee6:	85d2                	mv	a1,s4
    4ee8:	854e                	mv	a0,s3
    4eea:	00001097          	auipc	ra,0x1
    4eee:	82c080e7          	jalr	-2004(ra) # 5716 <write>
      if(cc < BSIZE)
    4ef2:	00aad563          	ble	a0,s5,4efc <fsfull+0x17c>
      total += cc;
    4ef6:	00a9093b          	addw	s2,s2,a0
    while(1){
    4efa:	b7e5                	j	4ee2 <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    4efc:	85ca                	mv	a1,s2
    4efe:	00003517          	auipc	a0,0x3
    4f02:	fb250513          	addi	a0,a0,-78 # 7eb0 <malloc+0x237a>
    4f06:	00001097          	auipc	ra,0x1
    4f0a:	b70080e7          	jalr	-1168(ra) # 5a76 <printf>
    close(fd);
    4f0e:	854e                	mv	a0,s3
    4f10:	00001097          	auipc	ra,0x1
    4f14:	80e080e7          	jalr	-2034(ra) # 571e <close>
    if(total == 0)
    4f18:	f20908e3          	beqz	s2,4e48 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    4f1c:	2485                	addiw	s1,s1,1
    4f1e:	bd4d                	j	4dd0 <fsfull+0x50>

0000000000004f20 <rand>:
{
    4f20:	1141                	addi	sp,sp,-16
    4f22:	e422                	sd	s0,8(sp)
    4f24:	0800                	addi	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    4f26:	00003717          	auipc	a4,0x3
    4f2a:	48270713          	addi	a4,a4,1154 # 83a8 <randstate>
    4f2e:	6308                	ld	a0,0(a4)
    4f30:	001967b7          	lui	a5,0x196
    4f34:	60d78793          	addi	a5,a5,1549 # 19660d <_end+0x187a2d>
    4f38:	02f50533          	mul	a0,a0,a5
    4f3c:	3c6ef7b7          	lui	a5,0x3c6ef
    4f40:	35f78793          	addi	a5,a5,863 # 3c6ef35f <_end+0x3c6e077f>
    4f44:	953e                	add	a0,a0,a5
    4f46:	e308                	sd	a0,0(a4)
}
    4f48:	2501                	sext.w	a0,a0
    4f4a:	6422                	ld	s0,8(sp)
    4f4c:	0141                	addi	sp,sp,16
    4f4e:	8082                	ret

0000000000004f50 <badwrite>:
{
    4f50:	7179                	addi	sp,sp,-48
    4f52:	f406                	sd	ra,40(sp)
    4f54:	f022                	sd	s0,32(sp)
    4f56:	ec26                	sd	s1,24(sp)
    4f58:	e84a                	sd	s2,16(sp)
    4f5a:	e44e                	sd	s3,8(sp)
    4f5c:	e052                	sd	s4,0(sp)
    4f5e:	1800                	addi	s0,sp,48
  unlink("junk");
    4f60:	00003517          	auipc	a0,0x3
    4f64:	f7850513          	addi	a0,a0,-136 # 7ed8 <malloc+0x23a2>
    4f68:	00000097          	auipc	ra,0x0
    4f6c:	7de080e7          	jalr	2014(ra) # 5746 <unlink>
    4f70:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    4f74:	00003997          	auipc	s3,0x3
    4f78:	f6498993          	addi	s3,s3,-156 # 7ed8 <malloc+0x23a2>
    write(fd, (char*)0xffffffffffL, 1);
    4f7c:	5a7d                	li	s4,-1
    4f7e:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    4f82:	20100593          	li	a1,513
    4f86:	854e                	mv	a0,s3
    4f88:	00000097          	auipc	ra,0x0
    4f8c:	7ae080e7          	jalr	1966(ra) # 5736 <open>
    4f90:	84aa                	mv	s1,a0
    if(fd < 0){
    4f92:	06054b63          	bltz	a0,5008 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    4f96:	4605                	li	a2,1
    4f98:	85d2                	mv	a1,s4
    4f9a:	00000097          	auipc	ra,0x0
    4f9e:	77c080e7          	jalr	1916(ra) # 5716 <write>
    close(fd);
    4fa2:	8526                	mv	a0,s1
    4fa4:	00000097          	auipc	ra,0x0
    4fa8:	77a080e7          	jalr	1914(ra) # 571e <close>
    unlink("junk");
    4fac:	854e                	mv	a0,s3
    4fae:	00000097          	auipc	ra,0x0
    4fb2:	798080e7          	jalr	1944(ra) # 5746 <unlink>
    4fb6:	397d                	addiw	s2,s2,-1
  for(int i = 0; i < assumed_free; i++){
    4fb8:	fc0915e3          	bnez	s2,4f82 <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    4fbc:	20100593          	li	a1,513
    4fc0:	00003517          	auipc	a0,0x3
    4fc4:	f1850513          	addi	a0,a0,-232 # 7ed8 <malloc+0x23a2>
    4fc8:	00000097          	auipc	ra,0x0
    4fcc:	76e080e7          	jalr	1902(ra) # 5736 <open>
    4fd0:	84aa                	mv	s1,a0
  if(fd < 0){
    4fd2:	04054863          	bltz	a0,5022 <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    4fd6:	4605                	li	a2,1
    4fd8:	00001597          	auipc	a1,0x1
    4fdc:	0d058593          	addi	a1,a1,208 # 60a8 <malloc+0x572>
    4fe0:	00000097          	auipc	ra,0x0
    4fe4:	736080e7          	jalr	1846(ra) # 5716 <write>
    4fe8:	4785                	li	a5,1
    4fea:	04f50963          	beq	a0,a5,503c <badwrite+0xec>
    printf("write failed\n");
    4fee:	00003517          	auipc	a0,0x3
    4ff2:	f0a50513          	addi	a0,a0,-246 # 7ef8 <malloc+0x23c2>
    4ff6:	00001097          	auipc	ra,0x1
    4ffa:	a80080e7          	jalr	-1408(ra) # 5a76 <printf>
    exit(1);
    4ffe:	4505                	li	a0,1
    5000:	00000097          	auipc	ra,0x0
    5004:	6f6080e7          	jalr	1782(ra) # 56f6 <exit>
      printf("open junk failed\n");
    5008:	00003517          	auipc	a0,0x3
    500c:	ed850513          	addi	a0,a0,-296 # 7ee0 <malloc+0x23aa>
    5010:	00001097          	auipc	ra,0x1
    5014:	a66080e7          	jalr	-1434(ra) # 5a76 <printf>
      exit(1);
    5018:	4505                	li	a0,1
    501a:	00000097          	auipc	ra,0x0
    501e:	6dc080e7          	jalr	1756(ra) # 56f6 <exit>
    printf("open junk failed\n");
    5022:	00003517          	auipc	a0,0x3
    5026:	ebe50513          	addi	a0,a0,-322 # 7ee0 <malloc+0x23aa>
    502a:	00001097          	auipc	ra,0x1
    502e:	a4c080e7          	jalr	-1460(ra) # 5a76 <printf>
    exit(1);
    5032:	4505                	li	a0,1
    5034:	00000097          	auipc	ra,0x0
    5038:	6c2080e7          	jalr	1730(ra) # 56f6 <exit>
  close(fd);
    503c:	8526                	mv	a0,s1
    503e:	00000097          	auipc	ra,0x0
    5042:	6e0080e7          	jalr	1760(ra) # 571e <close>
  unlink("junk");
    5046:	00003517          	auipc	a0,0x3
    504a:	e9250513          	addi	a0,a0,-366 # 7ed8 <malloc+0x23a2>
    504e:	00000097          	auipc	ra,0x0
    5052:	6f8080e7          	jalr	1784(ra) # 5746 <unlink>
  exit(0);
    5056:	4501                	li	a0,0
    5058:	00000097          	auipc	ra,0x0
    505c:	69e080e7          	jalr	1694(ra) # 56f6 <exit>

0000000000005060 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    5060:	7139                	addi	sp,sp,-64
    5062:	fc06                	sd	ra,56(sp)
    5064:	f822                	sd	s0,48(sp)
    5066:	f426                	sd	s1,40(sp)
    5068:	f04a                	sd	s2,32(sp)
    506a:	ec4e                	sd	s3,24(sp)
    506c:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    506e:	fc840513          	addi	a0,s0,-56
    5072:	00000097          	auipc	ra,0x0
    5076:	694080e7          	jalr	1684(ra) # 5706 <pipe>
    507a:	06054863          	bltz	a0,50ea <countfree+0x8a>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    507e:	00000097          	auipc	ra,0x0
    5082:	670080e7          	jalr	1648(ra) # 56ee <fork>

  if(pid < 0){
    5086:	06054f63          	bltz	a0,5104 <countfree+0xa4>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    508a:	ed59                	bnez	a0,5128 <countfree+0xc8>
    close(fds[0]);
    508c:	fc842503          	lw	a0,-56(s0)
    5090:	00000097          	auipc	ra,0x0
    5094:	68e080e7          	jalr	1678(ra) # 571e <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    5098:	54fd                	li	s1,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    509a:	4985                	li	s3,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    509c:	00001917          	auipc	s2,0x1
    50a0:	00c90913          	addi	s2,s2,12 # 60a8 <malloc+0x572>
      uint64 a = (uint64) sbrk(4096);
    50a4:	6505                	lui	a0,0x1
    50a6:	00000097          	auipc	ra,0x0
    50aa:	6d8080e7          	jalr	1752(ra) # 577e <sbrk>
      if(a == 0xffffffffffffffff){
    50ae:	06950863          	beq	a0,s1,511e <countfree+0xbe>
      *(char *)(a + 4096 - 1) = 1;
    50b2:	6785                	lui	a5,0x1
    50b4:	97aa                	add	a5,a5,a0
    50b6:	ff378fa3          	sb	s3,-1(a5) # fff <bigdir+0x89>
      if(write(fds[1], "x", 1) != 1){
    50ba:	4605                	li	a2,1
    50bc:	85ca                	mv	a1,s2
    50be:	fcc42503          	lw	a0,-52(s0)
    50c2:	00000097          	auipc	ra,0x0
    50c6:	654080e7          	jalr	1620(ra) # 5716 <write>
    50ca:	4785                	li	a5,1
    50cc:	fcf50ce3          	beq	a0,a5,50a4 <countfree+0x44>
        printf("write() failed in countfree()\n");
    50d0:	00003517          	auipc	a0,0x3
    50d4:	e7850513          	addi	a0,a0,-392 # 7f48 <malloc+0x2412>
    50d8:	00001097          	auipc	ra,0x1
    50dc:	99e080e7          	jalr	-1634(ra) # 5a76 <printf>
        exit(1);
    50e0:	4505                	li	a0,1
    50e2:	00000097          	auipc	ra,0x0
    50e6:	614080e7          	jalr	1556(ra) # 56f6 <exit>
    printf("pipe() failed in countfree()\n");
    50ea:	00003517          	auipc	a0,0x3
    50ee:	e1e50513          	addi	a0,a0,-482 # 7f08 <malloc+0x23d2>
    50f2:	00001097          	auipc	ra,0x1
    50f6:	984080e7          	jalr	-1660(ra) # 5a76 <printf>
    exit(1);
    50fa:	4505                	li	a0,1
    50fc:	00000097          	auipc	ra,0x0
    5100:	5fa080e7          	jalr	1530(ra) # 56f6 <exit>
    printf("fork failed in countfree()\n");
    5104:	00003517          	auipc	a0,0x3
    5108:	e2450513          	addi	a0,a0,-476 # 7f28 <malloc+0x23f2>
    510c:	00001097          	auipc	ra,0x1
    5110:	96a080e7          	jalr	-1686(ra) # 5a76 <printf>
    exit(1);
    5114:	4505                	li	a0,1
    5116:	00000097          	auipc	ra,0x0
    511a:	5e0080e7          	jalr	1504(ra) # 56f6 <exit>
      }
    }

    exit(0);
    511e:	4501                	li	a0,0
    5120:	00000097          	auipc	ra,0x0
    5124:	5d6080e7          	jalr	1494(ra) # 56f6 <exit>
  }

  close(fds[1]);
    5128:	fcc42503          	lw	a0,-52(s0)
    512c:	00000097          	auipc	ra,0x0
    5130:	5f2080e7          	jalr	1522(ra) # 571e <close>

  int n = 0;
    5134:	4481                	li	s1,0
    5136:	a839                	j	5154 <countfree+0xf4>
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    if(cc < 0){
      printf("read() failed in countfree()\n");
    5138:	00003517          	auipc	a0,0x3
    513c:	e3050513          	addi	a0,a0,-464 # 7f68 <malloc+0x2432>
    5140:	00001097          	auipc	ra,0x1
    5144:	936080e7          	jalr	-1738(ra) # 5a76 <printf>
      exit(1);
    5148:	4505                	li	a0,1
    514a:	00000097          	auipc	ra,0x0
    514e:	5ac080e7          	jalr	1452(ra) # 56f6 <exit>
    }
    if(cc == 0)
      break;
    n += 1;
    5152:	2485                	addiw	s1,s1,1
    int cc = read(fds[0], &c, 1);
    5154:	4605                	li	a2,1
    5156:	fc740593          	addi	a1,s0,-57
    515a:	fc842503          	lw	a0,-56(s0)
    515e:	00000097          	auipc	ra,0x0
    5162:	5b0080e7          	jalr	1456(ra) # 570e <read>
    if(cc < 0){
    5166:	fc0549e3          	bltz	a0,5138 <countfree+0xd8>
    if(cc == 0)
    516a:	f565                	bnez	a0,5152 <countfree+0xf2>
  }

  close(fds[0]);
    516c:	fc842503          	lw	a0,-56(s0)
    5170:	00000097          	auipc	ra,0x0
    5174:	5ae080e7          	jalr	1454(ra) # 571e <close>
  wait((int*)0);
    5178:	4501                	li	a0,0
    517a:	00000097          	auipc	ra,0x0
    517e:	584080e7          	jalr	1412(ra) # 56fe <wait>
  
  return n;
}
    5182:	8526                	mv	a0,s1
    5184:	70e2                	ld	ra,56(sp)
    5186:	7442                	ld	s0,48(sp)
    5188:	74a2                	ld	s1,40(sp)
    518a:	7902                	ld	s2,32(sp)
    518c:	69e2                	ld	s3,24(sp)
    518e:	6121                	addi	sp,sp,64
    5190:	8082                	ret

0000000000005192 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    5192:	7179                	addi	sp,sp,-48
    5194:	f406                	sd	ra,40(sp)
    5196:	f022                	sd	s0,32(sp)
    5198:	ec26                	sd	s1,24(sp)
    519a:	e84a                	sd	s2,16(sp)
    519c:	1800                	addi	s0,sp,48
    519e:	84aa                	mv	s1,a0
    51a0:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    51a2:	00003517          	auipc	a0,0x3
    51a6:	de650513          	addi	a0,a0,-538 # 7f88 <malloc+0x2452>
    51aa:	00001097          	auipc	ra,0x1
    51ae:	8cc080e7          	jalr	-1844(ra) # 5a76 <printf>
  if((pid = fork()) < 0) {
    51b2:	00000097          	auipc	ra,0x0
    51b6:	53c080e7          	jalr	1340(ra) # 56ee <fork>
    51ba:	02054e63          	bltz	a0,51f6 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    51be:	c929                	beqz	a0,5210 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    51c0:	fdc40513          	addi	a0,s0,-36
    51c4:	00000097          	auipc	ra,0x0
    51c8:	53a080e7          	jalr	1338(ra) # 56fe <wait>
    if(xstatus != 0) 
    51cc:	fdc42783          	lw	a5,-36(s0)
    51d0:	c7b9                	beqz	a5,521e <run+0x8c>
      printf("FAILED\n");
    51d2:	00003517          	auipc	a0,0x3
    51d6:	dde50513          	addi	a0,a0,-546 # 7fb0 <malloc+0x247a>
    51da:	00001097          	auipc	ra,0x1
    51de:	89c080e7          	jalr	-1892(ra) # 5a76 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    51e2:	fdc42503          	lw	a0,-36(s0)
  }
}
    51e6:	00153513          	seqz	a0,a0
    51ea:	70a2                	ld	ra,40(sp)
    51ec:	7402                	ld	s0,32(sp)
    51ee:	64e2                	ld	s1,24(sp)
    51f0:	6942                	ld	s2,16(sp)
    51f2:	6145                	addi	sp,sp,48
    51f4:	8082                	ret
    printf("runtest: fork error\n");
    51f6:	00003517          	auipc	a0,0x3
    51fa:	da250513          	addi	a0,a0,-606 # 7f98 <malloc+0x2462>
    51fe:	00001097          	auipc	ra,0x1
    5202:	878080e7          	jalr	-1928(ra) # 5a76 <printf>
    exit(1);
    5206:	4505                	li	a0,1
    5208:	00000097          	auipc	ra,0x0
    520c:	4ee080e7          	jalr	1262(ra) # 56f6 <exit>
    f(s);
    5210:	854a                	mv	a0,s2
    5212:	9482                	jalr	s1
    exit(0);
    5214:	4501                	li	a0,0
    5216:	00000097          	auipc	ra,0x0
    521a:	4e0080e7          	jalr	1248(ra) # 56f6 <exit>
      printf("OK\n");
    521e:	00003517          	auipc	a0,0x3
    5222:	d9a50513          	addi	a0,a0,-614 # 7fb8 <malloc+0x2482>
    5226:	00001097          	auipc	ra,0x1
    522a:	850080e7          	jalr	-1968(ra) # 5a76 <printf>
    522e:	bf55                	j	51e2 <run+0x50>

0000000000005230 <main>:

int
main(int argc, char *argv[])
{
    5230:	c0010113          	addi	sp,sp,-1024
    5234:	3e113c23          	sd	ra,1016(sp)
    5238:	3e813823          	sd	s0,1008(sp)
    523c:	3e913423          	sd	s1,1000(sp)
    5240:	3f213023          	sd	s2,992(sp)
    5244:	3d313c23          	sd	s3,984(sp)
    5248:	3d413823          	sd	s4,976(sp)
    524c:	3d513423          	sd	s5,968(sp)
    5250:	3d613023          	sd	s6,960(sp)
    5254:	40010413          	addi	s0,sp,1024
    5258:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    525a:	4789                	li	a5,2
    525c:	08f50863          	beq	a0,a5,52ec <main+0xbc>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    5260:	4785                	li	a5,1
    5262:	0ca7c363          	blt	a5,a0,5328 <main+0xf8>
  char *justone = 0;
    5266:	4981                	li	s3,0
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    5268:	00001797          	auipc	a5,0x1
    526c:	9d878793          	addi	a5,a5,-1576 # 5c40 <malloc+0x10a>
    5270:	c0040713          	addi	a4,s0,-1024
    5274:	00001817          	auipc	a6,0x1
    5278:	d8c80813          	addi	a6,a6,-628 # 6000 <malloc+0x4ca>
    527c:	6388                	ld	a0,0(a5)
    527e:	678c                	ld	a1,8(a5)
    5280:	6b90                	ld	a2,16(a5)
    5282:	6f94                	ld	a3,24(a5)
    5284:	e308                	sd	a0,0(a4)
    5286:	e70c                	sd	a1,8(a4)
    5288:	eb10                	sd	a2,16(a4)
    528a:	ef14                	sd	a3,24(a4)
    528c:	02078793          	addi	a5,a5,32
    5290:	02070713          	addi	a4,a4,32
    5294:	ff0794e3          	bne	a5,a6,527c <main+0x4c>
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    5298:	00003517          	auipc	a0,0x3
    529c:	dd850513          	addi	a0,a0,-552 # 8070 <malloc+0x253a>
    52a0:	00000097          	auipc	ra,0x0
    52a4:	7d6080e7          	jalr	2006(ra) # 5a76 <printf>
  int free0 = countfree();
    52a8:	00000097          	auipc	ra,0x0
    52ac:	db8080e7          	jalr	-584(ra) # 5060 <countfree>
    52b0:	8b2a                	mv	s6,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    52b2:	c0843903          	ld	s2,-1016(s0)
    52b6:	c0040493          	addi	s1,s0,-1024
  int fail = 0;
    52ba:	4a01                	li	s4,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    52bc:	4a85                	li	s5,1
  for (struct test *t = tests; t->s != 0; t++) {
    52be:	0a091a63          	bnez	s2,5372 <main+0x142>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    52c2:	00000097          	auipc	ra,0x0
    52c6:	d9e080e7          	jalr	-610(ra) # 5060 <countfree>
    52ca:	85aa                	mv	a1,a0
    52cc:	0f655463          	ble	s6,a0,53b4 <main+0x184>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    52d0:	865a                	mv	a2,s6
    52d2:	00003517          	auipc	a0,0x3
    52d6:	d5650513          	addi	a0,a0,-682 # 8028 <malloc+0x24f2>
    52da:	00000097          	auipc	ra,0x0
    52de:	79c080e7          	jalr	1948(ra) # 5a76 <printf>
    exit(1);
    52e2:	4505                	li	a0,1
    52e4:	00000097          	auipc	ra,0x0
    52e8:	412080e7          	jalr	1042(ra) # 56f6 <exit>
    52ec:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    52ee:	00003597          	auipc	a1,0x3
    52f2:	cd258593          	addi	a1,a1,-814 # 7fc0 <malloc+0x248a>
    52f6:	6488                	ld	a0,8(s1)
    52f8:	00000097          	auipc	ra,0x0
    52fc:	18a080e7          	jalr	394(ra) # 5482 <strcmp>
    5300:	10050863          	beqz	a0,5410 <main+0x1e0>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    5304:	00003597          	auipc	a1,0x3
    5308:	da458593          	addi	a1,a1,-604 # 80a8 <malloc+0x2572>
    530c:	6488                	ld	a0,8(s1)
    530e:	00000097          	auipc	ra,0x0
    5312:	174080e7          	jalr	372(ra) # 5482 <strcmp>
    5316:	cd75                	beqz	a0,5412 <main+0x1e2>
  } else if(argc == 2 && argv[1][0] != '-'){
    5318:	0084b983          	ld	s3,8(s1)
    531c:	0009c703          	lbu	a4,0(s3)
    5320:	02d00793          	li	a5,45
    5324:	f4f712e3          	bne	a4,a5,5268 <main+0x38>
    printf("Usage: usertests [-c] [testname]\n");
    5328:	00003517          	auipc	a0,0x3
    532c:	ca050513          	addi	a0,a0,-864 # 7fc8 <malloc+0x2492>
    5330:	00000097          	auipc	ra,0x0
    5334:	746080e7          	jalr	1862(ra) # 5a76 <printf>
    exit(1);
    5338:	4505                	li	a0,1
    533a:	00000097          	auipc	ra,0x0
    533e:	3bc080e7          	jalr	956(ra) # 56f6 <exit>
          exit(1);
    5342:	4505                	li	a0,1
    5344:	00000097          	auipc	ra,0x0
    5348:	3b2080e7          	jalr	946(ra) # 56f6 <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    534c:	40a905bb          	subw	a1,s2,a0
    5350:	855a                	mv	a0,s6
    5352:	00000097          	auipc	ra,0x0
    5356:	724080e7          	jalr	1828(ra) # 5a76 <printf>
        if(continuous != 2)
    535a:	09498763          	beq	s3,s4,53e8 <main+0x1b8>
          exit(1);
    535e:	4505                	li	a0,1
    5360:	00000097          	auipc	ra,0x0
    5364:	396080e7          	jalr	918(ra) # 56f6 <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    5368:	04c1                	addi	s1,s1,16
    536a:	0084b903          	ld	s2,8(s1)
    536e:	02090463          	beqz	s2,5396 <main+0x166>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    5372:	00098963          	beqz	s3,5384 <main+0x154>
    5376:	85ce                	mv	a1,s3
    5378:	854a                	mv	a0,s2
    537a:	00000097          	auipc	ra,0x0
    537e:	108080e7          	jalr	264(ra) # 5482 <strcmp>
    5382:	f17d                	bnez	a0,5368 <main+0x138>
      if(!run(t->f, t->s))
    5384:	85ca                	mv	a1,s2
    5386:	6088                	ld	a0,0(s1)
    5388:	00000097          	auipc	ra,0x0
    538c:	e0a080e7          	jalr	-502(ra) # 5192 <run>
    5390:	fd61                	bnez	a0,5368 <main+0x138>
        fail = 1;
    5392:	8a56                	mv	s4,s5
    5394:	bfd1                	j	5368 <main+0x138>
  if(fail){
    5396:	f20a06e3          	beqz	s4,52c2 <main+0x92>
    printf("SOME TESTS FAILED\n");
    539a:	00003517          	auipc	a0,0x3
    539e:	c7650513          	addi	a0,a0,-906 # 8010 <malloc+0x24da>
    53a2:	00000097          	auipc	ra,0x0
    53a6:	6d4080e7          	jalr	1748(ra) # 5a76 <printf>
    exit(1);
    53aa:	4505                	li	a0,1
    53ac:	00000097          	auipc	ra,0x0
    53b0:	34a080e7          	jalr	842(ra) # 56f6 <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    53b4:	00003517          	auipc	a0,0x3
    53b8:	ca450513          	addi	a0,a0,-860 # 8058 <malloc+0x2522>
    53bc:	00000097          	auipc	ra,0x0
    53c0:	6ba080e7          	jalr	1722(ra) # 5a76 <printf>
    exit(0);
    53c4:	4501                	li	a0,0
    53c6:	00000097          	auipc	ra,0x0
    53ca:	330080e7          	jalr	816(ra) # 56f6 <exit>
        printf("SOME TESTS FAILED\n");
    53ce:	8556                	mv	a0,s5
    53d0:	00000097          	auipc	ra,0x0
    53d4:	6a6080e7          	jalr	1702(ra) # 5a76 <printf>
        if(continuous != 2)
    53d8:	f74995e3          	bne	s3,s4,5342 <main+0x112>
      int free1 = countfree();
    53dc:	00000097          	auipc	ra,0x0
    53e0:	c84080e7          	jalr	-892(ra) # 5060 <countfree>
      if(free1 < free0){
    53e4:	f72544e3          	blt	a0,s2,534c <main+0x11c>
      int free0 = countfree();
    53e8:	00000097          	auipc	ra,0x0
    53ec:	c78080e7          	jalr	-904(ra) # 5060 <countfree>
    53f0:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    53f2:	c0843583          	ld	a1,-1016(s0)
    53f6:	d1fd                	beqz	a1,53dc <main+0x1ac>
    53f8:	c0040493          	addi	s1,s0,-1024
        if(!run(t->f, t->s)){
    53fc:	6088                	ld	a0,0(s1)
    53fe:	00000097          	auipc	ra,0x0
    5402:	d94080e7          	jalr	-620(ra) # 5192 <run>
    5406:	d561                	beqz	a0,53ce <main+0x19e>
      for (struct test *t = tests; t->s != 0; t++) {
    5408:	04c1                	addi	s1,s1,16
    540a:	648c                	ld	a1,8(s1)
    540c:	f9e5                	bnez	a1,53fc <main+0x1cc>
    540e:	b7f9                	j	53dc <main+0x1ac>
    continuous = 1;
    5410:	4985                	li	s3,1
  } tests[] = {
    5412:	00001797          	auipc	a5,0x1
    5416:	82e78793          	addi	a5,a5,-2002 # 5c40 <malloc+0x10a>
    541a:	c0040713          	addi	a4,s0,-1024
    541e:	00001817          	auipc	a6,0x1
    5422:	be280813          	addi	a6,a6,-1054 # 6000 <malloc+0x4ca>
    5426:	6388                	ld	a0,0(a5)
    5428:	678c                	ld	a1,8(a5)
    542a:	6b90                	ld	a2,16(a5)
    542c:	6f94                	ld	a3,24(a5)
    542e:	e308                	sd	a0,0(a4)
    5430:	e70c                	sd	a1,8(a4)
    5432:	eb10                	sd	a2,16(a4)
    5434:	ef14                	sd	a3,24(a4)
    5436:	02078793          	addi	a5,a5,32
    543a:	02070713          	addi	a4,a4,32
    543e:	ff0794e3          	bne	a5,a6,5426 <main+0x1f6>
    printf("continuous usertests starting\n");
    5442:	00003517          	auipc	a0,0x3
    5446:	c4650513          	addi	a0,a0,-954 # 8088 <malloc+0x2552>
    544a:	00000097          	auipc	ra,0x0
    544e:	62c080e7          	jalr	1580(ra) # 5a76 <printf>
        printf("SOME TESTS FAILED\n");
    5452:	00003a97          	auipc	s5,0x3
    5456:	bbea8a93          	addi	s5,s5,-1090 # 8010 <malloc+0x24da>
        if(continuous != 2)
    545a:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    545c:	00003b17          	auipc	s6,0x3
    5460:	b94b0b13          	addi	s6,s6,-1132 # 7ff0 <malloc+0x24ba>
    5464:	b751                	j	53e8 <main+0x1b8>

0000000000005466 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    5466:	1141                	addi	sp,sp,-16
    5468:	e422                	sd	s0,8(sp)
    546a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    546c:	87aa                	mv	a5,a0
    546e:	0585                	addi	a1,a1,1
    5470:	0785                	addi	a5,a5,1
    5472:	fff5c703          	lbu	a4,-1(a1)
    5476:	fee78fa3          	sb	a4,-1(a5)
    547a:	fb75                	bnez	a4,546e <strcpy+0x8>
    ;
  return os;
}
    547c:	6422                	ld	s0,8(sp)
    547e:	0141                	addi	sp,sp,16
    5480:	8082                	ret

0000000000005482 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5482:	1141                	addi	sp,sp,-16
    5484:	e422                	sd	s0,8(sp)
    5486:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    5488:	00054783          	lbu	a5,0(a0)
    548c:	cf91                	beqz	a5,54a8 <strcmp+0x26>
    548e:	0005c703          	lbu	a4,0(a1)
    5492:	00f71b63          	bne	a4,a5,54a8 <strcmp+0x26>
    p++, q++;
    5496:	0505                	addi	a0,a0,1
    5498:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    549a:	00054783          	lbu	a5,0(a0)
    549e:	c789                	beqz	a5,54a8 <strcmp+0x26>
    54a0:	0005c703          	lbu	a4,0(a1)
    54a4:	fef709e3          	beq	a4,a5,5496 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
    54a8:	0005c503          	lbu	a0,0(a1)
}
    54ac:	40a7853b          	subw	a0,a5,a0
    54b0:	6422                	ld	s0,8(sp)
    54b2:	0141                	addi	sp,sp,16
    54b4:	8082                	ret

00000000000054b6 <strlen>:

uint
strlen(const char *s)
{
    54b6:	1141                	addi	sp,sp,-16
    54b8:	e422                	sd	s0,8(sp)
    54ba:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    54bc:	00054783          	lbu	a5,0(a0)
    54c0:	cf91                	beqz	a5,54dc <strlen+0x26>
    54c2:	0505                	addi	a0,a0,1
    54c4:	87aa                	mv	a5,a0
    54c6:	4685                	li	a3,1
    54c8:	9e89                	subw	a3,a3,a0
    ;
    54ca:	00f6853b          	addw	a0,a3,a5
    54ce:	0785                	addi	a5,a5,1
  for(n = 0; s[n]; n++)
    54d0:	fff7c703          	lbu	a4,-1(a5)
    54d4:	fb7d                	bnez	a4,54ca <strlen+0x14>
  return n;
}
    54d6:	6422                	ld	s0,8(sp)
    54d8:	0141                	addi	sp,sp,16
    54da:	8082                	ret
  for(n = 0; s[n]; n++)
    54dc:	4501                	li	a0,0
    54de:	bfe5                	j	54d6 <strlen+0x20>

00000000000054e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    54e0:	1141                	addi	sp,sp,-16
    54e2:	e422                	sd	s0,8(sp)
    54e4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    54e6:	ce09                	beqz	a2,5500 <memset+0x20>
    54e8:	87aa                	mv	a5,a0
    54ea:	fff6071b          	addiw	a4,a2,-1
    54ee:	1702                	slli	a4,a4,0x20
    54f0:	9301                	srli	a4,a4,0x20
    54f2:	0705                	addi	a4,a4,1
    54f4:	972a                	add	a4,a4,a0
    cdst[i] = c;
    54f6:	00b78023          	sb	a1,0(a5)
    54fa:	0785                	addi	a5,a5,1
  for(i = 0; i < n; i++){
    54fc:	fee79de3          	bne	a5,a4,54f6 <memset+0x16>
  }
  return dst;
}
    5500:	6422                	ld	s0,8(sp)
    5502:	0141                	addi	sp,sp,16
    5504:	8082                	ret

0000000000005506 <strchr>:

char*
strchr(const char *s, char c)
{
    5506:	1141                	addi	sp,sp,-16
    5508:	e422                	sd	s0,8(sp)
    550a:	0800                	addi	s0,sp,16
  for(; *s; s++)
    550c:	00054783          	lbu	a5,0(a0)
    5510:	cf91                	beqz	a5,552c <strchr+0x26>
    if(*s == c)
    5512:	00f58a63          	beq	a1,a5,5526 <strchr+0x20>
  for(; *s; s++)
    5516:	0505                	addi	a0,a0,1
    5518:	00054783          	lbu	a5,0(a0)
    551c:	c781                	beqz	a5,5524 <strchr+0x1e>
    if(*s == c)
    551e:	feb79ce3          	bne	a5,a1,5516 <strchr+0x10>
    5522:	a011                	j	5526 <strchr+0x20>
      return (char*)s;
  return 0;
    5524:	4501                	li	a0,0
}
    5526:	6422                	ld	s0,8(sp)
    5528:	0141                	addi	sp,sp,16
    552a:	8082                	ret
  return 0;
    552c:	4501                	li	a0,0
    552e:	bfe5                	j	5526 <strchr+0x20>

0000000000005530 <gets>:

char*
gets(char *buf, int max)
{
    5530:	711d                	addi	sp,sp,-96
    5532:	ec86                	sd	ra,88(sp)
    5534:	e8a2                	sd	s0,80(sp)
    5536:	e4a6                	sd	s1,72(sp)
    5538:	e0ca                	sd	s2,64(sp)
    553a:	fc4e                	sd	s3,56(sp)
    553c:	f852                	sd	s4,48(sp)
    553e:	f456                	sd	s5,40(sp)
    5540:	f05a                	sd	s6,32(sp)
    5542:	ec5e                	sd	s7,24(sp)
    5544:	1080                	addi	s0,sp,96
    5546:	8baa                	mv	s7,a0
    5548:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    554a:	892a                	mv	s2,a0
    554c:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    554e:	4aa9                	li	s5,10
    5550:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5552:	0019849b          	addiw	s1,s3,1
    5556:	0344d863          	ble	s4,s1,5586 <gets+0x56>
    cc = read(0, &c, 1);
    555a:	4605                	li	a2,1
    555c:	faf40593          	addi	a1,s0,-81
    5560:	4501                	li	a0,0
    5562:	00000097          	auipc	ra,0x0
    5566:	1ac080e7          	jalr	428(ra) # 570e <read>
    if(cc < 1)
    556a:	00a05e63          	blez	a0,5586 <gets+0x56>
    buf[i++] = c;
    556e:	faf44783          	lbu	a5,-81(s0)
    5572:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5576:	01578763          	beq	a5,s5,5584 <gets+0x54>
    557a:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
    557c:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
    557e:	fd679ae3          	bne	a5,s6,5552 <gets+0x22>
    5582:	a011                	j	5586 <gets+0x56>
  for(i=0; i+1 < max; ){
    5584:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5586:	99de                	add	s3,s3,s7
    5588:	00098023          	sb	zero,0(s3)
  return buf;
}
    558c:	855e                	mv	a0,s7
    558e:	60e6                	ld	ra,88(sp)
    5590:	6446                	ld	s0,80(sp)
    5592:	64a6                	ld	s1,72(sp)
    5594:	6906                	ld	s2,64(sp)
    5596:	79e2                	ld	s3,56(sp)
    5598:	7a42                	ld	s4,48(sp)
    559a:	7aa2                	ld	s5,40(sp)
    559c:	7b02                	ld	s6,32(sp)
    559e:	6be2                	ld	s7,24(sp)
    55a0:	6125                	addi	sp,sp,96
    55a2:	8082                	ret

00000000000055a4 <stat>:

int
stat(const char *n, struct stat *st)
{
    55a4:	1101                	addi	sp,sp,-32
    55a6:	ec06                	sd	ra,24(sp)
    55a8:	e822                	sd	s0,16(sp)
    55aa:	e426                	sd	s1,8(sp)
    55ac:	e04a                	sd	s2,0(sp)
    55ae:	1000                	addi	s0,sp,32
    55b0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY|O_NOFOLLOW);
    55b2:	4591                	li	a1,4
    55b4:	00000097          	auipc	ra,0x0
    55b8:	182080e7          	jalr	386(ra) # 5736 <open>
  if(fd < 0)
    55bc:	02054563          	bltz	a0,55e6 <stat+0x42>
    55c0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    55c2:	85ca                	mv	a1,s2
    55c4:	00000097          	auipc	ra,0x0
    55c8:	18a080e7          	jalr	394(ra) # 574e <fstat>
    55cc:	892a                	mv	s2,a0
  close(fd);
    55ce:	8526                	mv	a0,s1
    55d0:	00000097          	auipc	ra,0x0
    55d4:	14e080e7          	jalr	334(ra) # 571e <close>
  return r;
}
    55d8:	854a                	mv	a0,s2
    55da:	60e2                	ld	ra,24(sp)
    55dc:	6442                	ld	s0,16(sp)
    55de:	64a2                	ld	s1,8(sp)
    55e0:	6902                	ld	s2,0(sp)
    55e2:	6105                	addi	sp,sp,32
    55e4:	8082                	ret
    return -1;
    55e6:	597d                	li	s2,-1
    55e8:	bfc5                	j	55d8 <stat+0x34>

00000000000055ea <atoi>:

int
atoi(const char *s)
{
    55ea:	1141                	addi	sp,sp,-16
    55ec:	e422                	sd	s0,8(sp)
    55ee:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    55f0:	00054683          	lbu	a3,0(a0)
    55f4:	fd06879b          	addiw	a5,a3,-48
    55f8:	0ff7f793          	andi	a5,a5,255
    55fc:	4725                	li	a4,9
    55fe:	02f76963          	bltu	a4,a5,5630 <atoi+0x46>
    5602:	862a                	mv	a2,a0
  n = 0;
    5604:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    5606:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    5608:	0605                	addi	a2,a2,1
    560a:	0025179b          	slliw	a5,a0,0x2
    560e:	9fa9                	addw	a5,a5,a0
    5610:	0017979b          	slliw	a5,a5,0x1
    5614:	9fb5                	addw	a5,a5,a3
    5616:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    561a:	00064683          	lbu	a3,0(a2) # 3000 <dirtest+0x52>
    561e:	fd06871b          	addiw	a4,a3,-48
    5622:	0ff77713          	andi	a4,a4,255
    5626:	fee5f1e3          	bleu	a4,a1,5608 <atoi+0x1e>
  return n;
}
    562a:	6422                	ld	s0,8(sp)
    562c:	0141                	addi	sp,sp,16
    562e:	8082                	ret
  n = 0;
    5630:	4501                	li	a0,0
    5632:	bfe5                	j	562a <atoi+0x40>

0000000000005634 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5634:	1141                	addi	sp,sp,-16
    5636:	e422                	sd	s0,8(sp)
    5638:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    563a:	02b57663          	bleu	a1,a0,5666 <memmove+0x32>
    while(n-- > 0)
    563e:	02c05163          	blez	a2,5660 <memmove+0x2c>
    5642:	fff6079b          	addiw	a5,a2,-1
    5646:	1782                	slli	a5,a5,0x20
    5648:	9381                	srli	a5,a5,0x20
    564a:	0785                	addi	a5,a5,1
    564c:	97aa                	add	a5,a5,a0
  dst = vdst;
    564e:	872a                	mv	a4,a0
      *dst++ = *src++;
    5650:	0585                	addi	a1,a1,1
    5652:	0705                	addi	a4,a4,1
    5654:	fff5c683          	lbu	a3,-1(a1)
    5658:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    565c:	fee79ae3          	bne	a5,a4,5650 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5660:	6422                	ld	s0,8(sp)
    5662:	0141                	addi	sp,sp,16
    5664:	8082                	ret
    dst += n;
    5666:	00c50733          	add	a4,a0,a2
    src += n;
    566a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    566c:	fec05ae3          	blez	a2,5660 <memmove+0x2c>
    5670:	fff6079b          	addiw	a5,a2,-1
    5674:	1782                	slli	a5,a5,0x20
    5676:	9381                	srli	a5,a5,0x20
    5678:	fff7c793          	not	a5,a5
    567c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    567e:	15fd                	addi	a1,a1,-1
    5680:	177d                	addi	a4,a4,-1
    5682:	0005c683          	lbu	a3,0(a1)
    5686:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    568a:	fef71ae3          	bne	a4,a5,567e <memmove+0x4a>
    568e:	bfc9                	j	5660 <memmove+0x2c>

0000000000005690 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5690:	1141                	addi	sp,sp,-16
    5692:	e422                	sd	s0,8(sp)
    5694:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5696:	ce15                	beqz	a2,56d2 <memcmp+0x42>
    5698:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
    569c:	00054783          	lbu	a5,0(a0)
    56a0:	0005c703          	lbu	a4,0(a1)
    56a4:	02e79063          	bne	a5,a4,56c4 <memcmp+0x34>
    56a8:	1682                	slli	a3,a3,0x20
    56aa:	9281                	srli	a3,a3,0x20
    56ac:	0685                	addi	a3,a3,1
    56ae:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
    56b0:	0505                	addi	a0,a0,1
    p2++;
    56b2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    56b4:	00d50d63          	beq	a0,a3,56ce <memcmp+0x3e>
    if (*p1 != *p2) {
    56b8:	00054783          	lbu	a5,0(a0)
    56bc:	0005c703          	lbu	a4,0(a1)
    56c0:	fee788e3          	beq	a5,a4,56b0 <memcmp+0x20>
      return *p1 - *p2;
    56c4:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
    56c8:	6422                	ld	s0,8(sp)
    56ca:	0141                	addi	sp,sp,16
    56cc:	8082                	ret
  return 0;
    56ce:	4501                	li	a0,0
    56d0:	bfe5                	j	56c8 <memcmp+0x38>
    56d2:	4501                	li	a0,0
    56d4:	bfd5                	j	56c8 <memcmp+0x38>

00000000000056d6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    56d6:	1141                	addi	sp,sp,-16
    56d8:	e406                	sd	ra,8(sp)
    56da:	e022                	sd	s0,0(sp)
    56dc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    56de:	00000097          	auipc	ra,0x0
    56e2:	f56080e7          	jalr	-170(ra) # 5634 <memmove>
}
    56e6:	60a2                	ld	ra,8(sp)
    56e8:	6402                	ld	s0,0(sp)
    56ea:	0141                	addi	sp,sp,16
    56ec:	8082                	ret

00000000000056ee <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    56ee:	4885                	li	a7,1
 ecall
    56f0:	00000073          	ecall
 ret
    56f4:	8082                	ret

00000000000056f6 <exit>:
.global exit
exit:
 li a7, SYS_exit
    56f6:	4889                	li	a7,2
 ecall
    56f8:	00000073          	ecall
 ret
    56fc:	8082                	ret

00000000000056fe <wait>:
.global wait
wait:
 li a7, SYS_wait
    56fe:	488d                	li	a7,3
 ecall
    5700:	00000073          	ecall
 ret
    5704:	8082                	ret

0000000000005706 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5706:	4891                	li	a7,4
 ecall
    5708:	00000073          	ecall
 ret
    570c:	8082                	ret

000000000000570e <read>:
.global read
read:
 li a7, SYS_read
    570e:	4895                	li	a7,5
 ecall
    5710:	00000073          	ecall
 ret
    5714:	8082                	ret

0000000000005716 <write>:
.global write
write:
 li a7, SYS_write
    5716:	48c1                	li	a7,16
 ecall
    5718:	00000073          	ecall
 ret
    571c:	8082                	ret

000000000000571e <close>:
.global close
close:
 li a7, SYS_close
    571e:	48d5                	li	a7,21
 ecall
    5720:	00000073          	ecall
 ret
    5724:	8082                	ret

0000000000005726 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5726:	4899                	li	a7,6
 ecall
    5728:	00000073          	ecall
 ret
    572c:	8082                	ret

000000000000572e <exec>:
.global exec
exec:
 li a7, SYS_exec
    572e:	489d                	li	a7,7
 ecall
    5730:	00000073          	ecall
 ret
    5734:	8082                	ret

0000000000005736 <open>:
.global open
open:
 li a7, SYS_open
    5736:	48bd                	li	a7,15
 ecall
    5738:	00000073          	ecall
 ret
    573c:	8082                	ret

000000000000573e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    573e:	48c5                	li	a7,17
 ecall
    5740:	00000073          	ecall
 ret
    5744:	8082                	ret

0000000000005746 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5746:	48c9                	li	a7,18
 ecall
    5748:	00000073          	ecall
 ret
    574c:	8082                	ret

000000000000574e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    574e:	48a1                	li	a7,8
 ecall
    5750:	00000073          	ecall
 ret
    5754:	8082                	ret

0000000000005756 <link>:
.global link
link:
 li a7, SYS_link
    5756:	48cd                	li	a7,19
 ecall
    5758:	00000073          	ecall
 ret
    575c:	8082                	ret

000000000000575e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    575e:	48d1                	li	a7,20
 ecall
    5760:	00000073          	ecall
 ret
    5764:	8082                	ret

0000000000005766 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5766:	48a5                	li	a7,9
 ecall
    5768:	00000073          	ecall
 ret
    576c:	8082                	ret

000000000000576e <dup>:
.global dup
dup:
 li a7, SYS_dup
    576e:	48a9                	li	a7,10
 ecall
    5770:	00000073          	ecall
 ret
    5774:	8082                	ret

0000000000005776 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5776:	48ad                	li	a7,11
 ecall
    5778:	00000073          	ecall
 ret
    577c:	8082                	ret

000000000000577e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    577e:	48b1                	li	a7,12
 ecall
    5780:	00000073          	ecall
 ret
    5784:	8082                	ret

0000000000005786 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5786:	48b5                	li	a7,13
 ecall
    5788:	00000073          	ecall
 ret
    578c:	8082                	ret

000000000000578e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    578e:	48b9                	li	a7,14
 ecall
    5790:	00000073          	ecall
 ret
    5794:	8082                	ret

0000000000005796 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
    5796:	48d9                	li	a7,22
 ecall
    5798:	00000073          	ecall
 ret
    579c:	8082                	ret

000000000000579e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    579e:	1101                	addi	sp,sp,-32
    57a0:	ec06                	sd	ra,24(sp)
    57a2:	e822                	sd	s0,16(sp)
    57a4:	1000                	addi	s0,sp,32
    57a6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    57aa:	4605                	li	a2,1
    57ac:	fef40593          	addi	a1,s0,-17
    57b0:	00000097          	auipc	ra,0x0
    57b4:	f66080e7          	jalr	-154(ra) # 5716 <write>
}
    57b8:	60e2                	ld	ra,24(sp)
    57ba:	6442                	ld	s0,16(sp)
    57bc:	6105                	addi	sp,sp,32
    57be:	8082                	ret

00000000000057c0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    57c0:	7139                	addi	sp,sp,-64
    57c2:	fc06                	sd	ra,56(sp)
    57c4:	f822                	sd	s0,48(sp)
    57c6:	f426                	sd	s1,40(sp)
    57c8:	f04a                	sd	s2,32(sp)
    57ca:	ec4e                	sd	s3,24(sp)
    57cc:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    57ce:	c299                	beqz	a3,57d4 <printint+0x14>
    57d0:	0005cd63          	bltz	a1,57ea <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    57d4:	2581                	sext.w	a1,a1
  neg = 0;
    57d6:	4301                	li	t1,0
    57d8:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
    57dc:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
    57de:	2601                	sext.w	a2,a2
    57e0:	00003897          	auipc	a7,0x3
    57e4:	ba088893          	addi	a7,a7,-1120 # 8380 <digits>
    57e8:	a801                	j	57f8 <printint+0x38>
    x = -xx;
    57ea:	40b005bb          	negw	a1,a1
    57ee:	2581                	sext.w	a1,a1
    neg = 1;
    57f0:	4305                	li	t1,1
    x = -xx;
    57f2:	b7dd                	j	57d8 <printint+0x18>
  }while((x /= base) != 0);
    57f4:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
    57f6:	8836                	mv	a6,a3
    57f8:	0018069b          	addiw	a3,a6,1
    57fc:	02c5f7bb          	remuw	a5,a1,a2
    5800:	1782                	slli	a5,a5,0x20
    5802:	9381                	srli	a5,a5,0x20
    5804:	97c6                	add	a5,a5,a7
    5806:	0007c783          	lbu	a5,0(a5)
    580a:	00f70023          	sb	a5,0(a4)
    580e:	0705                	addi	a4,a4,1
  }while((x /= base) != 0);
    5810:	02c5d7bb          	divuw	a5,a1,a2
    5814:	fec5f0e3          	bleu	a2,a1,57f4 <printint+0x34>
  if(neg)
    5818:	00030b63          	beqz	t1,582e <printint+0x6e>
    buf[i++] = '-';
    581c:	fd040793          	addi	a5,s0,-48
    5820:	96be                	add	a3,a3,a5
    5822:	02d00793          	li	a5,45
    5826:	fef68823          	sb	a5,-16(a3) # ff0 <bigdir+0x7a>
    582a:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
    582e:	02d05963          	blez	a3,5860 <printint+0xa0>
    5832:	89aa                	mv	s3,a0
    5834:	fc040793          	addi	a5,s0,-64
    5838:	00d784b3          	add	s1,a5,a3
    583c:	fff78913          	addi	s2,a5,-1
    5840:	9936                	add	s2,s2,a3
    5842:	36fd                	addiw	a3,a3,-1
    5844:	1682                	slli	a3,a3,0x20
    5846:	9281                	srli	a3,a3,0x20
    5848:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
    584c:	fff4c583          	lbu	a1,-1(s1)
    5850:	854e                	mv	a0,s3
    5852:	00000097          	auipc	ra,0x0
    5856:	f4c080e7          	jalr	-180(ra) # 579e <putc>
    585a:	14fd                	addi	s1,s1,-1
  while(--i >= 0)
    585c:	ff2498e3          	bne	s1,s2,584c <printint+0x8c>
}
    5860:	70e2                	ld	ra,56(sp)
    5862:	7442                	ld	s0,48(sp)
    5864:	74a2                	ld	s1,40(sp)
    5866:	7902                	ld	s2,32(sp)
    5868:	69e2                	ld	s3,24(sp)
    586a:	6121                	addi	sp,sp,64
    586c:	8082                	ret

000000000000586e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    586e:	7119                	addi	sp,sp,-128
    5870:	fc86                	sd	ra,120(sp)
    5872:	f8a2                	sd	s0,112(sp)
    5874:	f4a6                	sd	s1,104(sp)
    5876:	f0ca                	sd	s2,96(sp)
    5878:	ecce                	sd	s3,88(sp)
    587a:	e8d2                	sd	s4,80(sp)
    587c:	e4d6                	sd	s5,72(sp)
    587e:	e0da                	sd	s6,64(sp)
    5880:	fc5e                	sd	s7,56(sp)
    5882:	f862                	sd	s8,48(sp)
    5884:	f466                	sd	s9,40(sp)
    5886:	f06a                	sd	s10,32(sp)
    5888:	ec6e                	sd	s11,24(sp)
    588a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    588c:	0005c483          	lbu	s1,0(a1)
    5890:	18048d63          	beqz	s1,5a2a <vprintf+0x1bc>
    5894:	8aaa                	mv	s5,a0
    5896:	8b32                	mv	s6,a2
    5898:	00158913          	addi	s2,a1,1
  state = 0;
    589c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    589e:	02500a13          	li	s4,37
      if(c == 'd'){
    58a2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    58a6:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    58aa:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    58ae:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    58b2:	00003b97          	auipc	s7,0x3
    58b6:	aceb8b93          	addi	s7,s7,-1330 # 8380 <digits>
    58ba:	a839                	j	58d8 <vprintf+0x6a>
        putc(fd, c);
    58bc:	85a6                	mv	a1,s1
    58be:	8556                	mv	a0,s5
    58c0:	00000097          	auipc	ra,0x0
    58c4:	ede080e7          	jalr	-290(ra) # 579e <putc>
    58c8:	a019                	j	58ce <vprintf+0x60>
    } else if(state == '%'){
    58ca:	01498f63          	beq	s3,s4,58e8 <vprintf+0x7a>
    58ce:	0905                	addi	s2,s2,1
  for(i = 0; fmt[i]; i++){
    58d0:	fff94483          	lbu	s1,-1(s2)
    58d4:	14048b63          	beqz	s1,5a2a <vprintf+0x1bc>
    c = fmt[i] & 0xff;
    58d8:	0004879b          	sext.w	a5,s1
    if(state == 0){
    58dc:	fe0997e3          	bnez	s3,58ca <vprintf+0x5c>
      if(c == '%'){
    58e0:	fd479ee3          	bne	a5,s4,58bc <vprintf+0x4e>
        state = '%';
    58e4:	89be                	mv	s3,a5
    58e6:	b7e5                	j	58ce <vprintf+0x60>
      if(c == 'd'){
    58e8:	05878063          	beq	a5,s8,5928 <vprintf+0xba>
      } else if(c == 'l') {
    58ec:	05978c63          	beq	a5,s9,5944 <vprintf+0xd6>
      } else if(c == 'x') {
    58f0:	07a78863          	beq	a5,s10,5960 <vprintf+0xf2>
      } else if(c == 'p') {
    58f4:	09b78463          	beq	a5,s11,597c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    58f8:	07300713          	li	a4,115
    58fc:	0ce78563          	beq	a5,a4,59c6 <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    5900:	06300713          	li	a4,99
    5904:	0ee78c63          	beq	a5,a4,59fc <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    5908:	11478663          	beq	a5,s4,5a14 <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    590c:	85d2                	mv	a1,s4
    590e:	8556                	mv	a0,s5
    5910:	00000097          	auipc	ra,0x0
    5914:	e8e080e7          	jalr	-370(ra) # 579e <putc>
        putc(fd, c);
    5918:	85a6                	mv	a1,s1
    591a:	8556                	mv	a0,s5
    591c:	00000097          	auipc	ra,0x0
    5920:	e82080e7          	jalr	-382(ra) # 579e <putc>
      }
      state = 0;
    5924:	4981                	li	s3,0
    5926:	b765                	j	58ce <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    5928:	008b0493          	addi	s1,s6,8
    592c:	4685                	li	a3,1
    592e:	4629                	li	a2,10
    5930:	000b2583          	lw	a1,0(s6)
    5934:	8556                	mv	a0,s5
    5936:	00000097          	auipc	ra,0x0
    593a:	e8a080e7          	jalr	-374(ra) # 57c0 <printint>
    593e:	8b26                	mv	s6,s1
      state = 0;
    5940:	4981                	li	s3,0
    5942:	b771                	j	58ce <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5944:	008b0493          	addi	s1,s6,8
    5948:	4681                	li	a3,0
    594a:	4629                	li	a2,10
    594c:	000b2583          	lw	a1,0(s6)
    5950:	8556                	mv	a0,s5
    5952:	00000097          	auipc	ra,0x0
    5956:	e6e080e7          	jalr	-402(ra) # 57c0 <printint>
    595a:	8b26                	mv	s6,s1
      state = 0;
    595c:	4981                	li	s3,0
    595e:	bf85                	j	58ce <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5960:	008b0493          	addi	s1,s6,8
    5964:	4681                	li	a3,0
    5966:	4641                	li	a2,16
    5968:	000b2583          	lw	a1,0(s6)
    596c:	8556                	mv	a0,s5
    596e:	00000097          	auipc	ra,0x0
    5972:	e52080e7          	jalr	-430(ra) # 57c0 <printint>
    5976:	8b26                	mv	s6,s1
      state = 0;
    5978:	4981                	li	s3,0
    597a:	bf91                	j	58ce <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    597c:	008b0793          	addi	a5,s6,8
    5980:	f8f43423          	sd	a5,-120(s0)
    5984:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5988:	03000593          	li	a1,48
    598c:	8556                	mv	a0,s5
    598e:	00000097          	auipc	ra,0x0
    5992:	e10080e7          	jalr	-496(ra) # 579e <putc>
  putc(fd, 'x');
    5996:	85ea                	mv	a1,s10
    5998:	8556                	mv	a0,s5
    599a:	00000097          	auipc	ra,0x0
    599e:	e04080e7          	jalr	-508(ra) # 579e <putc>
    59a2:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    59a4:	03c9d793          	srli	a5,s3,0x3c
    59a8:	97de                	add	a5,a5,s7
    59aa:	0007c583          	lbu	a1,0(a5)
    59ae:	8556                	mv	a0,s5
    59b0:	00000097          	auipc	ra,0x0
    59b4:	dee080e7          	jalr	-530(ra) # 579e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    59b8:	0992                	slli	s3,s3,0x4
    59ba:	34fd                	addiw	s1,s1,-1
    59bc:	f4e5                	bnez	s1,59a4 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    59be:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    59c2:	4981                	li	s3,0
    59c4:	b729                	j	58ce <vprintf+0x60>
        s = va_arg(ap, char*);
    59c6:	008b0993          	addi	s3,s6,8
    59ca:	000b3483          	ld	s1,0(s6)
        if(s == 0)
    59ce:	c085                	beqz	s1,59ee <vprintf+0x180>
        while(*s != 0){
    59d0:	0004c583          	lbu	a1,0(s1)
    59d4:	c9a1                	beqz	a1,5a24 <vprintf+0x1b6>
          putc(fd, *s);
    59d6:	8556                	mv	a0,s5
    59d8:	00000097          	auipc	ra,0x0
    59dc:	dc6080e7          	jalr	-570(ra) # 579e <putc>
          s++;
    59e0:	0485                	addi	s1,s1,1
        while(*s != 0){
    59e2:	0004c583          	lbu	a1,0(s1)
    59e6:	f9e5                	bnez	a1,59d6 <vprintf+0x168>
        s = va_arg(ap, char*);
    59e8:	8b4e                	mv	s6,s3
      state = 0;
    59ea:	4981                	li	s3,0
    59ec:	b5cd                	j	58ce <vprintf+0x60>
          s = "(null)";
    59ee:	00003497          	auipc	s1,0x3
    59f2:	9aa48493          	addi	s1,s1,-1622 # 8398 <digits+0x18>
        while(*s != 0){
    59f6:	02800593          	li	a1,40
    59fa:	bff1                	j	59d6 <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
    59fc:	008b0493          	addi	s1,s6,8
    5a00:	000b4583          	lbu	a1,0(s6)
    5a04:	8556                	mv	a0,s5
    5a06:	00000097          	auipc	ra,0x0
    5a0a:	d98080e7          	jalr	-616(ra) # 579e <putc>
    5a0e:	8b26                	mv	s6,s1
      state = 0;
    5a10:	4981                	li	s3,0
    5a12:	bd75                	j	58ce <vprintf+0x60>
        putc(fd, c);
    5a14:	85d2                	mv	a1,s4
    5a16:	8556                	mv	a0,s5
    5a18:	00000097          	auipc	ra,0x0
    5a1c:	d86080e7          	jalr	-634(ra) # 579e <putc>
      state = 0;
    5a20:	4981                	li	s3,0
    5a22:	b575                	j	58ce <vprintf+0x60>
        s = va_arg(ap, char*);
    5a24:	8b4e                	mv	s6,s3
      state = 0;
    5a26:	4981                	li	s3,0
    5a28:	b55d                	j	58ce <vprintf+0x60>
    }
  }
}
    5a2a:	70e6                	ld	ra,120(sp)
    5a2c:	7446                	ld	s0,112(sp)
    5a2e:	74a6                	ld	s1,104(sp)
    5a30:	7906                	ld	s2,96(sp)
    5a32:	69e6                	ld	s3,88(sp)
    5a34:	6a46                	ld	s4,80(sp)
    5a36:	6aa6                	ld	s5,72(sp)
    5a38:	6b06                	ld	s6,64(sp)
    5a3a:	7be2                	ld	s7,56(sp)
    5a3c:	7c42                	ld	s8,48(sp)
    5a3e:	7ca2                	ld	s9,40(sp)
    5a40:	7d02                	ld	s10,32(sp)
    5a42:	6de2                	ld	s11,24(sp)
    5a44:	6109                	addi	sp,sp,128
    5a46:	8082                	ret

0000000000005a48 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5a48:	715d                	addi	sp,sp,-80
    5a4a:	ec06                	sd	ra,24(sp)
    5a4c:	e822                	sd	s0,16(sp)
    5a4e:	1000                	addi	s0,sp,32
    5a50:	e010                	sd	a2,0(s0)
    5a52:	e414                	sd	a3,8(s0)
    5a54:	e818                	sd	a4,16(s0)
    5a56:	ec1c                	sd	a5,24(s0)
    5a58:	03043023          	sd	a6,32(s0)
    5a5c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5a60:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5a64:	8622                	mv	a2,s0
    5a66:	00000097          	auipc	ra,0x0
    5a6a:	e08080e7          	jalr	-504(ra) # 586e <vprintf>
}
    5a6e:	60e2                	ld	ra,24(sp)
    5a70:	6442                	ld	s0,16(sp)
    5a72:	6161                	addi	sp,sp,80
    5a74:	8082                	ret

0000000000005a76 <printf>:

void
printf(const char *fmt, ...)
{
    5a76:	711d                	addi	sp,sp,-96
    5a78:	ec06                	sd	ra,24(sp)
    5a7a:	e822                	sd	s0,16(sp)
    5a7c:	1000                	addi	s0,sp,32
    5a7e:	e40c                	sd	a1,8(s0)
    5a80:	e810                	sd	a2,16(s0)
    5a82:	ec14                	sd	a3,24(s0)
    5a84:	f018                	sd	a4,32(s0)
    5a86:	f41c                	sd	a5,40(s0)
    5a88:	03043823          	sd	a6,48(s0)
    5a8c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5a90:	00840613          	addi	a2,s0,8
    5a94:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5a98:	85aa                	mv	a1,a0
    5a9a:	4505                	li	a0,1
    5a9c:	00000097          	auipc	ra,0x0
    5aa0:	dd2080e7          	jalr	-558(ra) # 586e <vprintf>
}
    5aa4:	60e2                	ld	ra,24(sp)
    5aa6:	6442                	ld	s0,16(sp)
    5aa8:	6125                	addi	sp,sp,96
    5aaa:	8082                	ret

0000000000005aac <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5aac:	1141                	addi	sp,sp,-16
    5aae:	e422                	sd	s0,8(sp)
    5ab0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5ab2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5ab6:	00003797          	auipc	a5,0x3
    5aba:	8fa78793          	addi	a5,a5,-1798 # 83b0 <_edata>
    5abe:	639c                	ld	a5,0(a5)
    5ac0:	a805                	j	5af0 <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5ac2:	4618                	lw	a4,8(a2)
    5ac4:	9db9                	addw	a1,a1,a4
    5ac6:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5aca:	6398                	ld	a4,0(a5)
    5acc:	6318                	ld	a4,0(a4)
    5ace:	fee53823          	sd	a4,-16(a0)
    5ad2:	a091                	j	5b16 <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5ad4:	ff852703          	lw	a4,-8(a0)
    5ad8:	9e39                	addw	a2,a2,a4
    5ada:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    5adc:	ff053703          	ld	a4,-16(a0)
    5ae0:	e398                	sd	a4,0(a5)
    5ae2:	a099                	j	5b28 <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5ae4:	6398                	ld	a4,0(a5)
    5ae6:	00e7e463          	bltu	a5,a4,5aee <free+0x42>
    5aea:	00e6ea63          	bltu	a3,a4,5afe <free+0x52>
{
    5aee:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5af0:	fed7fae3          	bleu	a3,a5,5ae4 <free+0x38>
    5af4:	6398                	ld	a4,0(a5)
    5af6:	00e6e463          	bltu	a3,a4,5afe <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5afa:	fee7eae3          	bltu	a5,a4,5aee <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
    5afe:	ff852583          	lw	a1,-8(a0)
    5b02:	6390                	ld	a2,0(a5)
    5b04:	02059713          	slli	a4,a1,0x20
    5b08:	9301                	srli	a4,a4,0x20
    5b0a:	0712                	slli	a4,a4,0x4
    5b0c:	9736                	add	a4,a4,a3
    5b0e:	fae60ae3          	beq	a2,a4,5ac2 <free+0x16>
    bp->s.ptr = p->s.ptr;
    5b12:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5b16:	4790                	lw	a2,8(a5)
    5b18:	02061713          	slli	a4,a2,0x20
    5b1c:	9301                	srli	a4,a4,0x20
    5b1e:	0712                	slli	a4,a4,0x4
    5b20:	973e                	add	a4,a4,a5
    5b22:	fae689e3          	beq	a3,a4,5ad4 <free+0x28>
  } else
    p->s.ptr = bp;
    5b26:	e394                	sd	a3,0(a5)
  freep = p;
    5b28:	00003717          	auipc	a4,0x3
    5b2c:	88f73423          	sd	a5,-1912(a4) # 83b0 <_edata>
}
    5b30:	6422                	ld	s0,8(sp)
    5b32:	0141                	addi	sp,sp,16
    5b34:	8082                	ret

0000000000005b36 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5b36:	7139                	addi	sp,sp,-64
    5b38:	fc06                	sd	ra,56(sp)
    5b3a:	f822                	sd	s0,48(sp)
    5b3c:	f426                	sd	s1,40(sp)
    5b3e:	f04a                	sd	s2,32(sp)
    5b40:	ec4e                	sd	s3,24(sp)
    5b42:	e852                	sd	s4,16(sp)
    5b44:	e456                	sd	s5,8(sp)
    5b46:	e05a                	sd	s6,0(sp)
    5b48:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5b4a:	02051993          	slli	s3,a0,0x20
    5b4e:	0209d993          	srli	s3,s3,0x20
    5b52:	09bd                	addi	s3,s3,15
    5b54:	0049d993          	srli	s3,s3,0x4
    5b58:	2985                	addiw	s3,s3,1
    5b5a:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
    5b5e:	00003797          	auipc	a5,0x3
    5b62:	85278793          	addi	a5,a5,-1966 # 83b0 <_edata>
    5b66:	6388                	ld	a0,0(a5)
    5b68:	c515                	beqz	a0,5b94 <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5b6a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5b6c:	4798                	lw	a4,8(a5)
    5b6e:	03277f63          	bleu	s2,a4,5bac <malloc+0x76>
    5b72:	8a4e                	mv	s4,s3
    5b74:	0009871b          	sext.w	a4,s3
    5b78:	6685                	lui	a3,0x1
    5b7a:	00d77363          	bleu	a3,a4,5b80 <malloc+0x4a>
    5b7e:	6a05                	lui	s4,0x1
    5b80:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
    5b84:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5b88:	00003497          	auipc	s1,0x3
    5b8c:	82848493          	addi	s1,s1,-2008 # 83b0 <_edata>
  if(p == (char*)-1)
    5b90:	5b7d                	li	s6,-1
    5b92:	a885                	j	5c02 <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
    5b94:	00009797          	auipc	a5,0x9
    5b98:	03c78793          	addi	a5,a5,60 # ebd0 <base>
    5b9c:	00003717          	auipc	a4,0x3
    5ba0:	80f73a23          	sd	a5,-2028(a4) # 83b0 <_edata>
    5ba4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5ba6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5baa:	b7e1                	j	5b72 <malloc+0x3c>
      if(p->s.size == nunits)
    5bac:	02e90b63          	beq	s2,a4,5be2 <malloc+0xac>
        p->s.size -= nunits;
    5bb0:	4137073b          	subw	a4,a4,s3
    5bb4:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5bb6:	1702                	slli	a4,a4,0x20
    5bb8:	9301                	srli	a4,a4,0x20
    5bba:	0712                	slli	a4,a4,0x4
    5bbc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5bbe:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5bc2:	00002717          	auipc	a4,0x2
    5bc6:	7ea73723          	sd	a0,2030(a4) # 83b0 <_edata>
      return (void*)(p + 1);
    5bca:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5bce:	70e2                	ld	ra,56(sp)
    5bd0:	7442                	ld	s0,48(sp)
    5bd2:	74a2                	ld	s1,40(sp)
    5bd4:	7902                	ld	s2,32(sp)
    5bd6:	69e2                	ld	s3,24(sp)
    5bd8:	6a42                	ld	s4,16(sp)
    5bda:	6aa2                	ld	s5,8(sp)
    5bdc:	6b02                	ld	s6,0(sp)
    5bde:	6121                	addi	sp,sp,64
    5be0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    5be2:	6398                	ld	a4,0(a5)
    5be4:	e118                	sd	a4,0(a0)
    5be6:	bff1                	j	5bc2 <malloc+0x8c>
  hp->s.size = nu;
    5be8:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
    5bec:	0541                	addi	a0,a0,16
    5bee:	00000097          	auipc	ra,0x0
    5bf2:	ebe080e7          	jalr	-322(ra) # 5aac <free>
  return freep;
    5bf6:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    5bf8:	d979                	beqz	a0,5bce <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5bfa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5bfc:	4798                	lw	a4,8(a5)
    5bfe:	fb2777e3          	bleu	s2,a4,5bac <malloc+0x76>
    if(p == freep)
    5c02:	6098                	ld	a4,0(s1)
    5c04:	853e                	mv	a0,a5
    5c06:	fef71ae3          	bne	a4,a5,5bfa <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
    5c0a:	8552                	mv	a0,s4
    5c0c:	00000097          	auipc	ra,0x0
    5c10:	b72080e7          	jalr	-1166(ra) # 577e <sbrk>
  if(p == (char*)-1)
    5c14:	fd651ae3          	bne	a0,s6,5be8 <malloc+0xb2>
        return 0;
    5c18:	4501                	li	a0,0
    5c1a:	bf55                	j	5bce <malloc+0x98>
