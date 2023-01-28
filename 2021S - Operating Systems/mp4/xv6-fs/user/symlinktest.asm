
user/_symlinktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <stat_slink>:
}

// stat a symbolic link using O_NOFOLLOW
static int
stat_slink(char *pn, struct stat *st)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	892e                	mv	s2,a1

  int fd = open(pn, O_RDONLY | O_NOFOLLOW); // at most time return -1, why?
       e:	4591                	li	a1,4
      10:	00001097          	auipc	ra,0x1
      14:	dbc080e7          	jalr	-580(ra) # dcc <open>
  //printf("opened.\n");

  if(fd < 0)
      18:	02054663          	bltz	a0,44 <stat_slink+0x44>
      1c:	84aa                	mv	s1,a0
    return -1;
  if(fstat(fd, st) != 0)
      1e:	85ca                	mv	a1,s2
      20:	00001097          	auipc	ra,0x1
      24:	dc4080e7          	jalr	-572(ra) # de4 <fstat>
      28:	892a                	mv	s2,a0
      2a:	ed19                	bnez	a0,48 <stat_slink+0x48>
    return -1;
  close(fd);
      2c:	8526                	mv	a0,s1
      2e:	00001097          	auipc	ra,0x1
      32:	d86080e7          	jalr	-634(ra) # db4 <close>
  return 0;
}
      36:	854a                	mv	a0,s2
      38:	60e2                	ld	ra,24(sp)
      3a:	6442                	ld	s0,16(sp)
      3c:	64a2                	ld	s1,8(sp)
      3e:	6902                	ld	s2,0(sp)
      40:	6105                	addi	sp,sp,32
      42:	8082                	ret
    return -1;
      44:	597d                	li	s2,-1
      46:	bfc5                	j	36 <stat_slink+0x36>
    return -1;
      48:	597d                	li	s2,-1
      4a:	b7f5                	j	36 <stat_slink+0x36>

000000000000004c <main>:
{
      4c:	7119                	addi	sp,sp,-128
      4e:	fc86                	sd	ra,120(sp)
      50:	f8a2                	sd	s0,112(sp)
      52:	f4a6                	sd	s1,104(sp)
      54:	f0ca                	sd	s2,96(sp)
      56:	ecce                	sd	s3,88(sp)
      58:	e8d2                	sd	s4,80(sp)
      5a:	e4d6                	sd	s5,72(sp)
      5c:	e0da                	sd	s6,64(sp)
      5e:	fc5e                	sd	s7,56(sp)
      60:	f862                	sd	s8,48(sp)
      62:	0100                	addi	s0,sp,128
  unlink("/testsymlink/a");
      64:	00001517          	auipc	a0,0x1
      68:	25450513          	addi	a0,a0,596 # 12b8 <malloc+0xec>
      6c:	00001097          	auipc	ra,0x1
      70:	d70080e7          	jalr	-656(ra) # ddc <unlink>
  unlink("/testsymlink/b");
      74:	00001517          	auipc	a0,0x1
      78:	25450513          	addi	a0,a0,596 # 12c8 <malloc+0xfc>
      7c:	00001097          	auipc	ra,0x1
      80:	d60080e7          	jalr	-672(ra) # ddc <unlink>
  unlink("/testsymlink/c");
      84:	00001517          	auipc	a0,0x1
      88:	25450513          	addi	a0,a0,596 # 12d8 <malloc+0x10c>
      8c:	00001097          	auipc	ra,0x1
      90:	d50080e7          	jalr	-688(ra) # ddc <unlink>
  unlink("/testsymlink/1");
      94:	00001517          	auipc	a0,0x1
      98:	25450513          	addi	a0,a0,596 # 12e8 <malloc+0x11c>
      9c:	00001097          	auipc	ra,0x1
      a0:	d40080e7          	jalr	-704(ra) # ddc <unlink>
  unlink("/testsymlink/2");
      a4:	00001517          	auipc	a0,0x1
      a8:	25450513          	addi	a0,a0,596 # 12f8 <malloc+0x12c>
      ac:	00001097          	auipc	ra,0x1
      b0:	d30080e7          	jalr	-720(ra) # ddc <unlink>
  unlink("/testsymlink/3");
      b4:	00001517          	auipc	a0,0x1
      b8:	25450513          	addi	a0,a0,596 # 1308 <malloc+0x13c>
      bc:	00001097          	auipc	ra,0x1
      c0:	d20080e7          	jalr	-736(ra) # ddc <unlink>
  unlink("/testsymlink/4");
      c4:	00001517          	auipc	a0,0x1
      c8:	25450513          	addi	a0,a0,596 # 1318 <malloc+0x14c>
      cc:	00001097          	auipc	ra,0x1
      d0:	d10080e7          	jalr	-752(ra) # ddc <unlink>
  unlink("/testsymlink/z");
      d4:	00001517          	auipc	a0,0x1
      d8:	25450513          	addi	a0,a0,596 # 1328 <malloc+0x15c>
      dc:	00001097          	auipc	ra,0x1
      e0:	d00080e7          	jalr	-768(ra) # ddc <unlink>
  unlink("/testsymlink/y");
      e4:	00001517          	auipc	a0,0x1
      e8:	25450513          	addi	a0,a0,596 # 1338 <malloc+0x16c>
      ec:	00001097          	auipc	ra,0x1
      f0:	cf0080e7          	jalr	-784(ra) # ddc <unlink>
  unlink("/testsymlink2/p");
      f4:	00001517          	auipc	a0,0x1
      f8:	25450513          	addi	a0,a0,596 # 1348 <malloc+0x17c>
      fc:	00001097          	auipc	ra,0x1
     100:	ce0080e7          	jalr	-800(ra) # ddc <unlink>
  unlink("/testsymlink3/q");
     104:	00001517          	auipc	a0,0x1
     108:	25450513          	addi	a0,a0,596 # 1358 <malloc+0x18c>
     10c:	00001097          	auipc	ra,0x1
     110:	cd0080e7          	jalr	-816(ra) # ddc <unlink>
  unlink("/testsymlink2");
     114:	00001517          	auipc	a0,0x1
     118:	25450513          	addi	a0,a0,596 # 1368 <malloc+0x19c>
     11c:	00001097          	auipc	ra,0x1
     120:	cc0080e7          	jalr	-832(ra) # ddc <unlink>
  unlink("/testsymlink3");
     124:	00001517          	auipc	a0,0x1
     128:	25450513          	addi	a0,a0,596 # 1378 <malloc+0x1ac>
     12c:	00001097          	auipc	ra,0x1
     130:	cb0080e7          	jalr	-848(ra) # ddc <unlink>
  unlink("/testsymlink");
     134:	00001517          	auipc	a0,0x1
     138:	25450513          	addi	a0,a0,596 # 1388 <malloc+0x1bc>
     13c:	00001097          	auipc	ra,0x1
     140:	ca0080e7          	jalr	-864(ra) # ddc <unlink>

static void
testsymlink(void)
{
  int r, fd1 = -1, fd2 = -1;
  char buf[4] = {'a', 'b', 'c', 'd'};
     144:	00002797          	auipc	a5,0x2
     148:	bf478793          	addi	a5,a5,-1036 # 1d38 <digits+0x20>
     14c:	439c                	lw	a5,0(a5)
     14e:	f8f42823          	sw	a5,-112(s0)
  char c = 0, c2 = 0;
     152:	f8040723          	sb	zero,-114(s0)
     156:	f80407a3          	sb	zero,-113(s0)
  struct stat st;

  printf("Start: test symlinks\n");
     15a:	00001517          	auipc	a0,0x1
     15e:	23e50513          	addi	a0,a0,574 # 1398 <malloc+0x1cc>
     162:	00001097          	auipc	ra,0x1
     166:	faa080e7          	jalr	-86(ra) # 110c <printf>

  mkdir("/testsymlink");
     16a:	00001517          	auipc	a0,0x1
     16e:	21e50513          	addi	a0,a0,542 # 1388 <malloc+0x1bc>
     172:	00001097          	auipc	ra,0x1
     176:	c82080e7          	jalr	-894(ra) # df4 <mkdir>


  fd1 = open("/testsymlink/a", O_CREATE | O_RDWR);
     17a:	20200593          	li	a1,514
     17e:	00001517          	auipc	a0,0x1
     182:	13a50513          	addi	a0,a0,314 # 12b8 <malloc+0xec>
     186:	00001097          	auipc	ra,0x1
     18a:	c46080e7          	jalr	-954(ra) # dcc <open>
     18e:	84aa                	mv	s1,a0
  if(fd1 < 0) fail("failed to open a");
     190:	18054363          	bltz	a0,316 <main+0x2ca>
  printf("-- opened a\n");
     194:	00001517          	auipc	a0,0x1
     198:	23c50513          	addi	a0,a0,572 # 13d0 <malloc+0x204>
     19c:	00001097          	auipc	ra,0x1
     1a0:	f70080e7          	jalr	-144(ra) # 110c <printf>

  r = symlink("/testsymlink/a", "/testsymlink/b");
     1a4:	00001597          	auipc	a1,0x1
     1a8:	12458593          	addi	a1,a1,292 # 12c8 <malloc+0xfc>
     1ac:	00001517          	auipc	a0,0x1
     1b0:	10c50513          	addi	a0,a0,268 # 12b8 <malloc+0xec>
     1b4:	00001097          	auipc	ra,0x1
     1b8:	c78080e7          	jalr	-904(ra) # e2c <symlink>
  if(r < 0)
     1bc:	16054c63          	bltz	a0,334 <main+0x2e8>
    fail("symlink b -> a failed");
  printf("-- symlink b -> a\n");
     1c0:	00001517          	auipc	a0,0x1
     1c4:	24050513          	addi	a0,a0,576 # 1400 <malloc+0x234>
     1c8:	00001097          	auipc	ra,0x1
     1cc:	f44080e7          	jalr	-188(ra) # 110c <printf>

  if(write(fd1, buf, sizeof(buf)) != 4)
     1d0:	4611                	li	a2,4
     1d2:	f9040593          	addi	a1,s0,-112
     1d6:	8526                	mv	a0,s1
     1d8:	00001097          	auipc	ra,0x1
     1dc:	bd4080e7          	jalr	-1068(ra) # dac <write>
     1e0:	4791                	li	a5,4
     1e2:	16f50863          	beq	a0,a5,352 <main+0x306>
    fail("failed to write to a");
     1e6:	00001517          	auipc	a0,0x1
     1ea:	23250513          	addi	a0,a0,562 # 1418 <malloc+0x24c>
     1ee:	00001097          	auipc	ra,0x1
     1f2:	f1e080e7          	jalr	-226(ra) # 110c <printf>
     1f6:	4785                	li	a5,1
     1f8:	00002717          	auipc	a4,0x2
     1fc:	b4f72423          	sw	a5,-1208(a4) # 1d40 <failed>
  int r, fd1 = -1, fd2 = -1;
     200:	597d                	li	s2,-1
    fail("Value read from 4 differed from value written to 1\n");
  printf("-- read \"#\" from 4, which is same from 1\n");

  printf("test symlinks: ok\n\n");
done:
  close(fd1);
     202:	8526                	mv	a0,s1
     204:	00001097          	auipc	ra,0x1
     208:	bb0080e7          	jalr	-1104(ra) # db4 <close>
  close(fd2);
     20c:	854a                	mv	a0,s2
     20e:	00001097          	auipc	ra,0x1
     212:	ba6080e7          	jalr	-1114(ra) # db4 <close>

static void
testsymlinkdir(void)
{
  int r, fd1 = -1, fd2 = -1;
  char c = 0, c2 = 0;
     216:	f8040823          	sb	zero,-112(s0)
     21a:	f8040c23          	sb	zero,-104(s0)

  printf("Start: test symlinks to directory\n");
     21e:	00001517          	auipc	a0,0x1
     222:	6ba50513          	addi	a0,a0,1722 # 18d8 <malloc+0x70c>
     226:	00001097          	auipc	ra,0x1
     22a:	ee6080e7          	jalr	-282(ra) # 110c <printf>

  mkdir("/testsymlink2");
     22e:	00001517          	auipc	a0,0x1
     232:	13a50513          	addi	a0,a0,314 # 1368 <malloc+0x19c>
     236:	00001097          	auipc	ra,0x1
     23a:	bbe080e7          	jalr	-1090(ra) # df4 <mkdir>
  mkdir("/testsymlink3");
     23e:	00001517          	auipc	a0,0x1
     242:	13a50513          	addi	a0,a0,314 # 1378 <malloc+0x1ac>
     246:	00001097          	auipc	ra,0x1
     24a:	bae080e7          	jalr	-1106(ra) # df4 <mkdir>
  printf("-- create dir /testsymlink2 & /testsymlink3\n");
     24e:	00001517          	auipc	a0,0x1
     252:	6b250513          	addi	a0,a0,1714 # 1900 <malloc+0x734>
     256:	00001097          	auipc	ra,0x1
     25a:	eb6080e7          	jalr	-330(ra) # 110c <printf>

  fd1 = open("/testsymlink2/p", O_CREATE | O_RDWR);
     25e:	20200593          	li	a1,514
     262:	00001517          	auipc	a0,0x1
     266:	0e650513          	addi	a0,a0,230 # 1348 <malloc+0x17c>
     26a:	00001097          	auipc	ra,0x1
     26e:	b62080e7          	jalr	-1182(ra) # dcc <open>
     272:	84aa                	mv	s1,a0
  if(fd1 < 0) fail("failed to open p");
     274:	54054b63          	bltz	a0,7ca <main+0x77e>
  printf("-- open /testsymlink2/p (fd1)\n");
     278:	00001517          	auipc	a0,0x1
     27c:	6d850513          	addi	a0,a0,1752 # 1950 <malloc+0x784>
     280:	00001097          	auipc	ra,0x1
     284:	e8c080e7          	jalr	-372(ra) # 110c <printf>

  r = symlink("/testsymlink2", "/testsymlink3/q");
     288:	00001597          	auipc	a1,0x1
     28c:	0d058593          	addi	a1,a1,208 # 1358 <malloc+0x18c>
     290:	00001517          	auipc	a0,0x1
     294:	0d850513          	addi	a0,a0,216 # 1368 <malloc+0x19c>
     298:	00001097          	auipc	ra,0x1
     29c:	b94080e7          	jalr	-1132(ra) # e2c <symlink>
  if(r < 0)
     2a0:	5e054a63          	bltz	a0,894 <main+0x848>
    fail("symlink q -> p failed");
  printf("-- symlink /testsymlink3/q -> /testsymlink2\n");
     2a4:	00001517          	auipc	a0,0x1
     2a8:	6ec50513          	addi	a0,a0,1772 # 1990 <malloc+0x7c4>
     2ac:	00001097          	auipc	ra,0x1
     2b0:	e60080e7          	jalr	-416(ra) # 110c <printf>

  fd2 = open("/testsymlink3/q/p", O_RDWR);
     2b4:	4589                	li	a1,2
     2b6:	00001517          	auipc	a0,0x1
     2ba:	70a50513          	addi	a0,a0,1802 # 19c0 <malloc+0x7f4>
     2be:	00001097          	auipc	ra,0x1
     2c2:	b0e080e7          	jalr	-1266(ra) # dcc <open>
     2c6:	892a                	mv	s2,a0
  if(fd2<0) fail("Failed to open /testsymlink3/q/p\n");
     2c8:	5e054563          	bltz	a0,8b2 <main+0x866>
  printf("-- open /testsymlink3/q/p (fd2)\n");
     2cc:	00001517          	auipc	a0,0x1
     2d0:	73c50513          	addi	a0,a0,1852 # 1a08 <malloc+0x83c>
     2d4:	00001097          	auipc	ra,0x1
     2d8:	e38080e7          	jalr	-456(ra) # 110c <printf>

  c = '#';
     2dc:	02300793          	li	a5,35
     2e0:	f8f40823          	sb	a5,-112(s0)
  r = write(fd1, &c, 1);
     2e4:	4605                	li	a2,1
     2e6:	f9040593          	addi	a1,s0,-112
     2ea:	8526                	mv	a0,s1
     2ec:	00001097          	auipc	ra,0x1
     2f0:	ac0080e7          	jalr	-1344(ra) # dac <write>
  if(r!=1) fail("Failed to write to /testsymlink2/p\n");
     2f4:	4785                	li	a5,1
     2f6:	5cf50c63          	beq	a0,a5,8ce <main+0x882>
     2fa:	00001517          	auipc	a0,0x1
     2fe:	73650513          	addi	a0,a0,1846 # 1a30 <malloc+0x864>
     302:	00001097          	auipc	ra,0x1
     306:	e0a080e7          	jalr	-502(ra) # 110c <printf>
     30a:	4785                	li	a5,1
     30c:	00002717          	auipc	a4,0x2
     310:	a2f72a23          	sw	a5,-1484(a4) # 1d40 <failed>
     314:	a9c9                	j	7e6 <main+0x79a>
  if(fd1 < 0) fail("failed to open a");
     316:	00001517          	auipc	a0,0x1
     31a:	09a50513          	addi	a0,a0,154 # 13b0 <malloc+0x1e4>
     31e:	00001097          	auipc	ra,0x1
     322:	dee080e7          	jalr	-530(ra) # 110c <printf>
     326:	4785                	li	a5,1
     328:	00002717          	auipc	a4,0x2
     32c:	a0f72c23          	sw	a5,-1512(a4) # 1d40 <failed>
  int r, fd1 = -1, fd2 = -1;
     330:	597d                	li	s2,-1
     332:	bdc1                	j	202 <main+0x1b6>
    fail("symlink b -> a failed");
     334:	00001517          	auipc	a0,0x1
     338:	0ac50513          	addi	a0,a0,172 # 13e0 <malloc+0x214>
     33c:	00001097          	auipc	ra,0x1
     340:	dd0080e7          	jalr	-560(ra) # 110c <printf>
     344:	4785                	li	a5,1
     346:	00002717          	auipc	a4,0x2
     34a:	9ef72d23          	sw	a5,-1542(a4) # 1d40 <failed>
  int r, fd1 = -1, fd2 = -1;
     34e:	597d                	li	s2,-1
     350:	bd4d                	j	202 <main+0x1b6>
  printf("-- write \"abcd\" to a\n");
     352:	00001517          	auipc	a0,0x1
     356:	0e650513          	addi	a0,a0,230 # 1438 <malloc+0x26c>
     35a:	00001097          	auipc	ra,0x1
     35e:	db2080e7          	jalr	-590(ra) # 110c <printf>
  if (stat_slink("/testsymlink/b", &st) != 0)
     362:	f9840593          	addi	a1,s0,-104
     366:	00001517          	auipc	a0,0x1
     36a:	f6250513          	addi	a0,a0,-158 # 12c8 <malloc+0xfc>
     36e:	00000097          	auipc	ra,0x0
     372:	c92080e7          	jalr	-878(ra) # 0 <stat_slink>
     376:	ed0d                	bnez	a0,3b0 <main+0x364>
  printf("-- state b\n");
     378:	00001517          	auipc	a0,0x1
     37c:	0f850513          	addi	a0,a0,248 # 1470 <malloc+0x2a4>
     380:	00001097          	auipc	ra,0x1
     384:	d8c080e7          	jalr	-628(ra) # 110c <printf>
  if(st.type != T_SYMLINK)
     388:	fa041703          	lh	a4,-96(s0)
     38c:	4791                	li	a5,4
     38e:	04f70063          	beq	a4,a5,3ce <main+0x382>
    fail("b isn't a symlink");
     392:	00001517          	auipc	a0,0x1
     396:	0ee50513          	addi	a0,a0,238 # 1480 <malloc+0x2b4>
     39a:	00001097          	auipc	ra,0x1
     39e:	d72080e7          	jalr	-654(ra) # 110c <printf>
     3a2:	4785                	li	a5,1
     3a4:	00002717          	auipc	a4,0x2
     3a8:	98f72e23          	sw	a5,-1636(a4) # 1d40 <failed>
  int r, fd1 = -1, fd2 = -1;
     3ac:	597d                	li	s2,-1
     3ae:	bd91                	j	202 <main+0x1b6>
    fail("failed to stat b");
     3b0:	00001517          	auipc	a0,0x1
     3b4:	0a050513          	addi	a0,a0,160 # 1450 <malloc+0x284>
     3b8:	00001097          	auipc	ra,0x1
     3bc:	d54080e7          	jalr	-684(ra) # 110c <printf>
     3c0:	4785                	li	a5,1
     3c2:	00002717          	auipc	a4,0x2
     3c6:	96f72f23          	sw	a5,-1666(a4) # 1d40 <failed>
  int r, fd1 = -1, fd2 = -1;
     3ca:	597d                	li	s2,-1
     3cc:	bd1d                	j	202 <main+0x1b6>
  printf("-- b is a symlink\n");
     3ce:	00001517          	auipc	a0,0x1
     3d2:	0d250513          	addi	a0,a0,210 # 14a0 <malloc+0x2d4>
     3d6:	00001097          	auipc	ra,0x1
     3da:	d36080e7          	jalr	-714(ra) # 110c <printf>
  fd2 = open("/testsymlink/b", O_RDWR); //fd2 會是 "/testsymlink/a"
     3de:	4589                	li	a1,2
     3e0:	00001517          	auipc	a0,0x1
     3e4:	ee850513          	addi	a0,a0,-280 # 12c8 <malloc+0xfc>
     3e8:	00001097          	auipc	ra,0x1
     3ec:	9e4080e7          	jalr	-1564(ra) # dcc <open>
     3f0:	892a                	mv	s2,a0
  if(fd2 < 0)
     3f2:	04054663          	bltz	a0,43e <main+0x3f2>
  printf("-- opened b (which should be fd of a ?)\n");
     3f6:	00001517          	auipc	a0,0x1
     3fa:	0e250513          	addi	a0,a0,226 # 14d8 <malloc+0x30c>
     3fe:	00001097          	auipc	ra,0x1
     402:	d0e080e7          	jalr	-754(ra) # 110c <printf>
  read(fd2, &c, 1);// read(fd2)會讀到 "/testsymlink/a" 裡面的 "abcd"
     406:	4605                	li	a2,1
     408:	f8e40593          	addi	a1,s0,-114
     40c:	854a                	mv	a0,s2
     40e:	00001097          	auipc	ra,0x1
     412:	996080e7          	jalr	-1642(ra) # da4 <read>
  if (c != 'a')
     416:	f8e44703          	lbu	a4,-114(s0)
     41a:	06100793          	li	a5,97
     41e:	02f70e63          	beq	a4,a5,45a <main+0x40e>
    fail("failed to read bytes from b");
     422:	00001517          	auipc	a0,0x1
     426:	0e650513          	addi	a0,a0,230 # 1508 <malloc+0x33c>
     42a:	00001097          	auipc	ra,0x1
     42e:	ce2080e7          	jalr	-798(ra) # 110c <printf>
     432:	4785                	li	a5,1
     434:	00002717          	auipc	a4,0x2
     438:	90f72623          	sw	a5,-1780(a4) # 1d40 <failed>
     43c:	b3d9                	j	202 <main+0x1b6>
    fail("failed to open b");
     43e:	00001517          	auipc	a0,0x1
     442:	07a50513          	addi	a0,a0,122 # 14b8 <malloc+0x2ec>
     446:	00001097          	auipc	ra,0x1
     44a:	cc6080e7          	jalr	-826(ra) # 110c <printf>
     44e:	4785                	li	a5,1
     450:	00002717          	auipc	a4,0x2
     454:	8ef72823          	sw	a5,-1808(a4) # 1d40 <failed>
     458:	b36d                	j	202 <main+0x1b6>
  printf("-- yes it is~\n");
     45a:	00001517          	auipc	a0,0x1
     45e:	0d650513          	addi	a0,a0,214 # 1530 <malloc+0x364>
     462:	00001097          	auipc	ra,0x1
     466:	caa080e7          	jalr	-854(ra) # 110c <printf>
  unlink("/testsymlink/a");
     46a:	00001517          	auipc	a0,0x1
     46e:	e4e50513          	addi	a0,a0,-434 # 12b8 <malloc+0xec>
     472:	00001097          	auipc	ra,0x1
     476:	96a080e7          	jalr	-1686(ra) # ddc <unlink>
  if(open("/testsymlink/b", O_RDWR) >= 0)
     47a:	4589                	li	a1,2
     47c:	00001517          	auipc	a0,0x1
     480:	e4c50513          	addi	a0,a0,-436 # 12c8 <malloc+0xfc>
     484:	00001097          	auipc	ra,0x1
     488:	948080e7          	jalr	-1720(ra) # dcc <open>
     48c:	1a055b63          	bgez	a0,642 <main+0x5f6>
  printf("-- after delete a, unavalible to open b now~\n");
     490:	00001517          	auipc	a0,0x1
     494:	0e850513          	addi	a0,a0,232 # 1578 <malloc+0x3ac>
     498:	00001097          	auipc	ra,0x1
     49c:	c74080e7          	jalr	-908(ra) # 110c <printf>
  r = symlink("/testsymlink/b", "/testsymlink/a");
     4a0:	00001597          	auipc	a1,0x1
     4a4:	e1858593          	addi	a1,a1,-488 # 12b8 <malloc+0xec>
     4a8:	00001517          	auipc	a0,0x1
     4ac:	e2050513          	addi	a0,a0,-480 # 12c8 <malloc+0xfc>
     4b0:	00001097          	auipc	ra,0x1
     4b4:	97c080e7          	jalr	-1668(ra) # e2c <symlink>
  if(r < 0)
     4b8:	1a054363          	bltz	a0,65e <main+0x612>
  printf("-- symlink a->b\n");
     4bc:	00001517          	auipc	a0,0x1
     4c0:	10c50513          	addi	a0,a0,268 # 15c8 <malloc+0x3fc>
     4c4:	00001097          	auipc	ra,0x1
     4c8:	c48080e7          	jalr	-952(ra) # 110c <printf>
  r = open("/testsymlink/b", O_RDWR);
     4cc:	4589                	li	a1,2
     4ce:	00001517          	auipc	a0,0x1
     4d2:	dfa50513          	addi	a0,a0,-518 # 12c8 <malloc+0xfc>
     4d6:	00001097          	auipc	ra,0x1
     4da:	8f6080e7          	jalr	-1802(ra) # dcc <open>
  if(r >= 0)
     4de:	18055e63          	bgez	a0,67a <main+0x62e>
  printf("-- open b fail (because cycle b->a->b->..)\n");
     4e2:	00001517          	auipc	a0,0x1
     4e6:	13e50513          	addi	a0,a0,318 # 1620 <malloc+0x454>
     4ea:	00001097          	auipc	ra,0x1
     4ee:	c22080e7          	jalr	-990(ra) # 110c <printf>
  r = symlink("/testsymlink/nonexistent", "/testsymlink/c");
     4f2:	00001597          	auipc	a1,0x1
     4f6:	de658593          	addi	a1,a1,-538 # 12d8 <malloc+0x10c>
     4fa:	00001517          	auipc	a0,0x1
     4fe:	15650513          	addi	a0,a0,342 # 1650 <malloc+0x484>
     502:	00001097          	auipc	ra,0x1
     506:	92a080e7          	jalr	-1750(ra) # e2c <symlink>
  if(r != 0)
     50a:	18051663          	bnez	a0,696 <main+0x64a>
  printf("-- symlink c->nonexistent fail (because not exist)~\n");
     50e:	00001517          	auipc	a0,0x1
     512:	1a250513          	addi	a0,a0,418 # 16b0 <malloc+0x4e4>
     516:	00001097          	auipc	ra,0x1
     51a:	bf6080e7          	jalr	-1034(ra) # 110c <printf>
  r = symlink("/testsymlink/2", "/testsymlink/1");
     51e:	00001597          	auipc	a1,0x1
     522:	dca58593          	addi	a1,a1,-566 # 12e8 <malloc+0x11c>
     526:	00001517          	auipc	a0,0x1
     52a:	dd250513          	addi	a0,a0,-558 # 12f8 <malloc+0x12c>
     52e:	00001097          	auipc	ra,0x1
     532:	8fe080e7          	jalr	-1794(ra) # e2c <symlink>
  if(r) fail("Failed to link 1->2");
     536:	16051e63          	bnez	a0,6b2 <main+0x666>
  printf("-- symlink 1->2\n");
     53a:	00001517          	auipc	a0,0x1
     53e:	1ce50513          	addi	a0,a0,462 # 1708 <malloc+0x53c>
     542:	00001097          	auipc	ra,0x1
     546:	bca080e7          	jalr	-1078(ra) # 110c <printf>
  r = symlink("/testsymlink/3", "/testsymlink/2");
     54a:	00001597          	auipc	a1,0x1
     54e:	dae58593          	addi	a1,a1,-594 # 12f8 <malloc+0x12c>
     552:	00001517          	auipc	a0,0x1
     556:	db650513          	addi	a0,a0,-586 # 1308 <malloc+0x13c>
     55a:	00001097          	auipc	ra,0x1
     55e:	8d2080e7          	jalr	-1838(ra) # e2c <symlink>
  if(r) fail("Failed to link 2->3");
     562:	16051663          	bnez	a0,6ce <main+0x682>
  printf("-- symlink 2->3\n");
     566:	00001517          	auipc	a0,0x1
     56a:	1da50513          	addi	a0,a0,474 # 1740 <malloc+0x574>
     56e:	00001097          	auipc	ra,0x1
     572:	b9e080e7          	jalr	-1122(ra) # 110c <printf>
  r = symlink("/testsymlink/4", "/testsymlink/3");
     576:	00001597          	auipc	a1,0x1
     57a:	d9258593          	addi	a1,a1,-622 # 1308 <malloc+0x13c>
     57e:	00001517          	auipc	a0,0x1
     582:	d9a50513          	addi	a0,a0,-614 # 1318 <malloc+0x14c>
     586:	00001097          	auipc	ra,0x1
     58a:	8a6080e7          	jalr	-1882(ra) # e2c <symlink>
  if(r) fail("Failed to link 3->4");
     58e:	14051e63          	bnez	a0,6ea <main+0x69e>
  printf("-- symlink 3->4\n");
     592:	00001517          	auipc	a0,0x1
     596:	1e650513          	addi	a0,a0,486 # 1778 <malloc+0x5ac>
     59a:	00001097          	auipc	ra,0x1
     59e:	b72080e7          	jalr	-1166(ra) # 110c <printf>
  close(fd1);
     5a2:	8526                	mv	a0,s1
     5a4:	00001097          	auipc	ra,0x1
     5a8:	810080e7          	jalr	-2032(ra) # db4 <close>
  close(fd2);
     5ac:	854a                	mv	a0,s2
     5ae:	00001097          	auipc	ra,0x1
     5b2:	806080e7          	jalr	-2042(ra) # db4 <close>
  fd1 = open("/testsymlink/4", O_CREATE | O_RDWR);
     5b6:	20200593          	li	a1,514
     5ba:	00001517          	auipc	a0,0x1
     5be:	d5e50513          	addi	a0,a0,-674 # 1318 <malloc+0x14c>
     5c2:	00001097          	auipc	ra,0x1
     5c6:	80a080e7          	jalr	-2038(ra) # dcc <open>
     5ca:	84aa                	mv	s1,a0
  if(fd1<0) fail("Failed to create 4\n");
     5cc:	12054d63          	bltz	a0,706 <main+0x6ba>
  printf("-- create 4\n");
     5d0:	00001517          	auipc	a0,0x1
     5d4:	1e050513          	addi	a0,a0,480 # 17b0 <malloc+0x5e4>
     5d8:	00001097          	auipc	ra,0x1
     5dc:	b34080e7          	jalr	-1228(ra) # 110c <printf>
  fd2 = open("/testsymlink/1", O_RDWR);
     5e0:	4589                	li	a1,2
     5e2:	00001517          	auipc	a0,0x1
     5e6:	d0650513          	addi	a0,a0,-762 # 12e8 <malloc+0x11c>
     5ea:	00000097          	auipc	ra,0x0
     5ee:	7e2080e7          	jalr	2018(ra) # dcc <open>
     5f2:	892a                	mv	s2,a0
  if(fd2<0) fail("Failed to open 1\n");
     5f4:	12054763          	bltz	a0,722 <main+0x6d6>
  printf("-- open 1\n");
     5f8:	00001517          	auipc	a0,0x1
     5fc:	1e850513          	addi	a0,a0,488 # 17e0 <malloc+0x614>
     600:	00001097          	auipc	ra,0x1
     604:	b0c080e7          	jalr	-1268(ra) # 110c <printf>
  c = '#';
     608:	02300793          	li	a5,35
     60c:	f8f40723          	sb	a5,-114(s0)
  r = write(fd2, &c, 1);
     610:	4605                	li	a2,1
     612:	f8e40593          	addi	a1,s0,-114
     616:	854a                	mv	a0,s2
     618:	00000097          	auipc	ra,0x0
     61c:	794080e7          	jalr	1940(ra) # dac <write>
  if(r!=1) fail("Failed to write to 1\n");
     620:	4785                	li	a5,1
     622:	10f50e63          	beq	a0,a5,73e <main+0x6f2>
     626:	00001517          	auipc	a0,0x1
     62a:	1ca50513          	addi	a0,a0,458 # 17f0 <malloc+0x624>
     62e:	00001097          	auipc	ra,0x1
     632:	ade080e7          	jalr	-1314(ra) # 110c <printf>
     636:	4785                	li	a5,1
     638:	00001717          	auipc	a4,0x1
     63c:	70f72423          	sw	a5,1800(a4) # 1d40 <failed>
     640:	b6c9                	j	202 <main+0x1b6>
    fail("Should not be able to open b after deleting a");
     642:	00001517          	auipc	a0,0x1
     646:	efe50513          	addi	a0,a0,-258 # 1540 <malloc+0x374>
     64a:	00001097          	auipc	ra,0x1
     64e:	ac2080e7          	jalr	-1342(ra) # 110c <printf>
     652:	4785                	li	a5,1
     654:	00001717          	auipc	a4,0x1
     658:	6ef72623          	sw	a5,1772(a4) # 1d40 <failed>
     65c:	b65d                	j	202 <main+0x1b6>
    fail("symlink a -> b failed");
     65e:	00001517          	auipc	a0,0x1
     662:	f4a50513          	addi	a0,a0,-182 # 15a8 <malloc+0x3dc>
     666:	00001097          	auipc	ra,0x1
     66a:	aa6080e7          	jalr	-1370(ra) # 110c <printf>
     66e:	4785                	li	a5,1
     670:	00001717          	auipc	a4,0x1
     674:	6cf72823          	sw	a5,1744(a4) # 1d40 <failed>
     678:	b669                	j	202 <main+0x1b6>
    fail("Should not be able to open b (cycle b->a->b->..)\n");
     67a:	00001517          	auipc	a0,0x1
     67e:	f6650513          	addi	a0,a0,-154 # 15e0 <malloc+0x414>
     682:	00001097          	auipc	ra,0x1
     686:	a8a080e7          	jalr	-1398(ra) # 110c <printf>
     68a:	4785                	li	a5,1
     68c:	00001717          	auipc	a4,0x1
     690:	6af72a23          	sw	a5,1716(a4) # 1d40 <failed>
     694:	b6bd                	j	202 <main+0x1b6>
    fail("Symlinking to nonexistent file should succeed\n");
     696:	00001517          	auipc	a0,0x1
     69a:	fda50513          	addi	a0,a0,-38 # 1670 <malloc+0x4a4>
     69e:	00001097          	auipc	ra,0x1
     6a2:	a6e080e7          	jalr	-1426(ra) # 110c <printf>
     6a6:	4785                	li	a5,1
     6a8:	00001717          	auipc	a4,0x1
     6ac:	68f72c23          	sw	a5,1688(a4) # 1d40 <failed>
     6b0:	be89                	j	202 <main+0x1b6>
  if(r) fail("Failed to link 1->2");
     6b2:	00001517          	auipc	a0,0x1
     6b6:	03650513          	addi	a0,a0,54 # 16e8 <malloc+0x51c>
     6ba:	00001097          	auipc	ra,0x1
     6be:	a52080e7          	jalr	-1454(ra) # 110c <printf>
     6c2:	4785                	li	a5,1
     6c4:	00001717          	auipc	a4,0x1
     6c8:	66f72e23          	sw	a5,1660(a4) # 1d40 <failed>
     6cc:	be1d                	j	202 <main+0x1b6>
  if(r) fail("Failed to link 2->3");
     6ce:	00001517          	auipc	a0,0x1
     6d2:	05250513          	addi	a0,a0,82 # 1720 <malloc+0x554>
     6d6:	00001097          	auipc	ra,0x1
     6da:	a36080e7          	jalr	-1482(ra) # 110c <printf>
     6de:	4785                	li	a5,1
     6e0:	00001717          	auipc	a4,0x1
     6e4:	66f72023          	sw	a5,1632(a4) # 1d40 <failed>
     6e8:	be29                	j	202 <main+0x1b6>
  if(r) fail("Failed to link 3->4");
     6ea:	00001517          	auipc	a0,0x1
     6ee:	06e50513          	addi	a0,a0,110 # 1758 <malloc+0x58c>
     6f2:	00001097          	auipc	ra,0x1
     6f6:	a1a080e7          	jalr	-1510(ra) # 110c <printf>
     6fa:	4785                	li	a5,1
     6fc:	00001717          	auipc	a4,0x1
     700:	64f72223          	sw	a5,1604(a4) # 1d40 <failed>
     704:	bcfd                	j	202 <main+0x1b6>
  if(fd1<0) fail("Failed to create 4\n");
     706:	00001517          	auipc	a0,0x1
     70a:	08a50513          	addi	a0,a0,138 # 1790 <malloc+0x5c4>
     70e:	00001097          	auipc	ra,0x1
     712:	9fe080e7          	jalr	-1538(ra) # 110c <printf>
     716:	4785                	li	a5,1
     718:	00001717          	auipc	a4,0x1
     71c:	62f72423          	sw	a5,1576(a4) # 1d40 <failed>
     720:	b4cd                	j	202 <main+0x1b6>
  if(fd2<0) fail("Failed to open 1\n");
     722:	00001517          	auipc	a0,0x1
     726:	09e50513          	addi	a0,a0,158 # 17c0 <malloc+0x5f4>
     72a:	00001097          	auipc	ra,0x1
     72e:	9e2080e7          	jalr	-1566(ra) # 110c <printf>
     732:	4785                	li	a5,1
     734:	00001717          	auipc	a4,0x1
     738:	60f72623          	sw	a5,1548(a4) # 1d40 <failed>
     73c:	b4d9                	j	202 <main+0x1b6>
  printf("-- write \"#\" to 1\n");
     73e:	00001517          	auipc	a0,0x1
     742:	0d250513          	addi	a0,a0,210 # 1810 <malloc+0x644>
     746:	00001097          	auipc	ra,0x1
     74a:	9c6080e7          	jalr	-1594(ra) # 110c <printf>
  r = read(fd1, &c2, 1);
     74e:	4605                	li	a2,1
     750:	f8f40593          	addi	a1,s0,-113
     754:	8526                	mv	a0,s1
     756:	00000097          	auipc	ra,0x0
     75a:	64e080e7          	jalr	1614(ra) # da4 <read>
  if(r!=1) fail("Failed to read from 4\n");
     75e:	4785                	li	a5,1
     760:	02f51663          	bne	a0,a5,78c <main+0x740>
  if(c!=c2)
     764:	f8e44703          	lbu	a4,-114(s0)
     768:	f8f44783          	lbu	a5,-113(s0)
     76c:	02f70e63          	beq	a4,a5,7a8 <main+0x75c>
    fail("Value read from 4 differed from value written to 1\n");
     770:	00001517          	auipc	a0,0x1
     774:	0e050513          	addi	a0,a0,224 # 1850 <malloc+0x684>
     778:	00001097          	auipc	ra,0x1
     77c:	994080e7          	jalr	-1644(ra) # 110c <printf>
     780:	4785                	li	a5,1
     782:	00001717          	auipc	a4,0x1
     786:	5af72f23          	sw	a5,1470(a4) # 1d40 <failed>
     78a:	bca5                	j	202 <main+0x1b6>
  if(r!=1) fail("Failed to read from 4\n");
     78c:	00001517          	auipc	a0,0x1
     790:	09c50513          	addi	a0,a0,156 # 1828 <malloc+0x65c>
     794:	00001097          	auipc	ra,0x1
     798:	978080e7          	jalr	-1672(ra) # 110c <printf>
     79c:	4785                	li	a5,1
     79e:	00001717          	auipc	a4,0x1
     7a2:	5af72123          	sw	a5,1442(a4) # 1d40 <failed>
     7a6:	bcb1                	j	202 <main+0x1b6>
  printf("-- read \"#\" from 4, which is same from 1\n");
     7a8:	00001517          	auipc	a0,0x1
     7ac:	0e850513          	addi	a0,a0,232 # 1890 <malloc+0x6c4>
     7b0:	00001097          	auipc	ra,0x1
     7b4:	95c080e7          	jalr	-1700(ra) # 110c <printf>
  printf("test symlinks: ok\n\n");
     7b8:	00001517          	auipc	a0,0x1
     7bc:	10850513          	addi	a0,a0,264 # 18c0 <malloc+0x6f4>
     7c0:	00001097          	auipc	ra,0x1
     7c4:	94c080e7          	jalr	-1716(ra) # 110c <printf>
     7c8:	bc2d                	j	202 <main+0x1b6>
  if(fd1 < 0) fail("failed to open p");
     7ca:	00001517          	auipc	a0,0x1
     7ce:	16650513          	addi	a0,a0,358 # 1930 <malloc+0x764>
     7d2:	00001097          	auipc	ra,0x1
     7d6:	93a080e7          	jalr	-1734(ra) # 110c <printf>
     7da:	4785                	li	a5,1
     7dc:	00001717          	auipc	a4,0x1
     7e0:	56f72223          	sw	a5,1380(a4) # 1d40 <failed>
  int r, fd1 = -1, fd2 = -1;
     7e4:	597d                	li	s2,-1
  printf("-- read \"#\" from p in /testsymlink3/q/\n");
  close(fd1);

  printf("test symlinks to directory: ok\n");
done:
  close(fd1);
     7e6:	8526                	mv	a0,s1
     7e8:	00000097          	auipc	ra,0x0
     7ec:	5cc080e7          	jalr	1484(ra) # db4 <close>
  close(fd2);//多的吧...
     7f0:	854a                	mv	a0,s2
     7f2:	00000097          	auipc	ra,0x0
     7f6:	5c2080e7          	jalr	1474(ra) # db4 <close>
  int pid, i;
  int fd;
  struct stat st;
  int nchild = 2;

  printf("Start: test concurrent symlinks\n");
     7fa:	00001517          	auipc	a0,0x1
     7fe:	45e50513          	addi	a0,a0,1118 # 1c58 <malloc+0xa8c>
     802:	00001097          	auipc	ra,0x1
     806:	90a080e7          	jalr	-1782(ra) # 110c <printf>

  fd = open("/testsymlink/z", O_CREATE | O_RDWR);
     80a:	20200593          	li	a1,514
     80e:	00001517          	auipc	a0,0x1
     812:	b1a50513          	addi	a0,a0,-1254 # 1328 <malloc+0x15c>
     816:	00000097          	auipc	ra,0x0
     81a:	5b6080e7          	jalr	1462(ra) # dcc <open>
  if(fd < 0) {
     81e:	1e054b63          	bltz	a0,a14 <main+0x9c8>
    printf("FAILED: open failed");
    exit(1);
  }
  close(fd);
     822:	00000097          	auipc	ra,0x0
     826:	592080e7          	jalr	1426(ra) # db4 <close>

  for(int j = 0; j < nchild; j++) {
    pid = fork();
     82a:	00000097          	auipc	ra,0x0
     82e:	55a080e7          	jalr	1370(ra) # d84 <fork>
    if(pid < 0){
     832:	1e054e63          	bltz	a0,a2e <main+0x9e2>
      printf("FAILED: fork failed\n");
      exit(1);
    }
    if(pid == 0) {
     836:	20050963          	beqz	a0,a48 <main+0x9fc>
    pid = fork();
     83a:	00000097          	auipc	ra,0x0
     83e:	54a080e7          	jalr	1354(ra) # d84 <fork>
    if(pid < 0){
     842:	1e054663          	bltz	a0,a2e <main+0x9e2>
    if(pid == 0) {
     846:	20050163          	beqz	a0,a48 <main+0x9fc>
    }
  }

  int r;
  for(int j = 0; j < nchild; j++) {
    wait(&r);
     84a:	f9840513          	addi	a0,s0,-104
     84e:	00000097          	auipc	ra,0x0
     852:	546080e7          	jalr	1350(ra) # d94 <wait>
    if(r != 0) {
     856:	f9842783          	lw	a5,-104(s0)
     85a:	28079463          	bnez	a5,ae2 <main+0xa96>
    wait(&r);
     85e:	f9840513          	addi	a0,s0,-104
     862:	00000097          	auipc	ra,0x0
     866:	532080e7          	jalr	1330(ra) # d94 <wait>
    if(r != 0) {
     86a:	f9842783          	lw	a5,-104(s0)
     86e:	26079a63          	bnez	a5,ae2 <main+0xa96>
      printf("test concurrent symlinks: failed\n");
      exit(1);
    }
  }
  printf("test concurrent symlinks: ok\n");
     872:	00001517          	auipc	a0,0x1
     876:	48650513          	addi	a0,a0,1158 # 1cf8 <malloc+0xb2c>
     87a:	00001097          	auipc	ra,0x1
     87e:	892080e7          	jalr	-1902(ra) # 110c <printf>
  exit(failed);
     882:	00001797          	auipc	a5,0x1
     886:	4be78793          	addi	a5,a5,1214 # 1d40 <failed>
     88a:	4388                	lw	a0,0(a5)
     88c:	00000097          	auipc	ra,0x0
     890:	500080e7          	jalr	1280(ra) # d8c <exit>
    fail("symlink q -> p failed");
     894:	00001517          	auipc	a0,0x1
     898:	0dc50513          	addi	a0,a0,220 # 1970 <malloc+0x7a4>
     89c:	00001097          	auipc	ra,0x1
     8a0:	870080e7          	jalr	-1936(ra) # 110c <printf>
     8a4:	4785                	li	a5,1
     8a6:	00001717          	auipc	a4,0x1
     8aa:	48f72d23          	sw	a5,1178(a4) # 1d40 <failed>
  int r, fd1 = -1, fd2 = -1;
     8ae:	597d                	li	s2,-1
     8b0:	bf1d                	j	7e6 <main+0x79a>
  if(fd2<0) fail("Failed to open /testsymlink3/q/p\n");
     8b2:	00001517          	auipc	a0,0x1
     8b6:	12650513          	addi	a0,a0,294 # 19d8 <malloc+0x80c>
     8ba:	00001097          	auipc	ra,0x1
     8be:	852080e7          	jalr	-1966(ra) # 110c <printf>
     8c2:	4785                	li	a5,1
     8c4:	00001717          	auipc	a4,0x1
     8c8:	46f72e23          	sw	a5,1148(a4) # 1d40 <failed>
     8cc:	bf29                	j	7e6 <main+0x79a>
  printf("-- write \"#\" to /testsymlink2/p (fd1)\n");
     8ce:	00001517          	auipc	a0,0x1
     8d2:	19250513          	addi	a0,a0,402 # 1a60 <malloc+0x894>
     8d6:	00001097          	auipc	ra,0x1
     8da:	836080e7          	jalr	-1994(ra) # 110c <printf>
  r = read(fd2, &c2, 1);
     8de:	4605                	li	a2,1
     8e0:	f9840593          	addi	a1,s0,-104
     8e4:	854a                	mv	a0,s2
     8e6:	00000097          	auipc	ra,0x0
     8ea:	4be080e7          	jalr	1214(ra) # da4 <read>
  if(r!=1) fail("Failed to read from /testsymlink3/q/p\n");
     8ee:	4785                	li	a5,1
     8f0:	02f51663          	bne	a0,a5,91c <main+0x8d0>
  if(c!=c2)
     8f4:	f9044703          	lbu	a4,-112(s0)
     8f8:	f9844783          	lbu	a5,-104(s0)
     8fc:	02f70e63          	beq	a4,a5,938 <main+0x8ec>
    fail("Value read from /testsymlink2/p differed from value written to /testsymlink3/q/p\n");
     900:	00001517          	auipc	a0,0x1
     904:	1c050513          	addi	a0,a0,448 # 1ac0 <malloc+0x8f4>
     908:	00001097          	auipc	ra,0x1
     90c:	804080e7          	jalr	-2044(ra) # 110c <printf>
     910:	4785                	li	a5,1
     912:	00001717          	auipc	a4,0x1
     916:	42f72723          	sw	a5,1070(a4) # 1d40 <failed>
     91a:	b5f1                	j	7e6 <main+0x79a>
  if(r!=1) fail("Failed to read from /testsymlink3/q/p\n");
     91c:	00001517          	auipc	a0,0x1
     920:	16c50513          	addi	a0,a0,364 # 1a88 <malloc+0x8bc>
     924:	00000097          	auipc	ra,0x0
     928:	7e8080e7          	jalr	2024(ra) # 110c <printf>
     92c:	4785                	li	a5,1
     92e:	00001717          	auipc	a4,0x1
     932:	40f72923          	sw	a5,1042(a4) # 1d40 <failed>
     936:	bd45                	j	7e6 <main+0x79a>
  printf("-- read \"#\" from /testsymlink3/q/p (fd2)\n");
     938:	00001517          	auipc	a0,0x1
     93c:	1e850513          	addi	a0,a0,488 # 1b20 <malloc+0x954>
     940:	00000097          	auipc	ra,0x0
     944:	7cc080e7          	jalr	1996(ra) # 110c <printf>
  close(fd1);
     948:	8526                	mv	a0,s1
     94a:	00000097          	auipc	ra,0x0
     94e:	46a080e7          	jalr	1130(ra) # db4 <close>
  close(fd2);
     952:	854a                	mv	a0,s2
     954:	00000097          	auipc	ra,0x0
     958:	460080e7          	jalr	1120(ra) # db4 <close>
  chdir("/testsymlink3/q");
     95c:	00001517          	auipc	a0,0x1
     960:	9fc50513          	addi	a0,a0,-1540 # 1358 <malloc+0x18c>
     964:	00000097          	auipc	ra,0x0
     968:	498080e7          	jalr	1176(ra) # dfc <chdir>
  printf("-- chdir to /testsymlink3/q\n");
     96c:	00001517          	auipc	a0,0x1
     970:	1e450513          	addi	a0,a0,484 # 1b50 <malloc+0x984>
     974:	00000097          	auipc	ra,0x0
     978:	798080e7          	jalr	1944(ra) # 110c <printf>
  fd1 = open("p", O_RDWR);
     97c:	4589                	li	a1,2
     97e:	00001517          	auipc	a0,0x1
     982:	05250513          	addi	a0,a0,82 # 19d0 <malloc+0x804>
     986:	00000097          	auipc	ra,0x0
     98a:	446080e7          	jalr	1094(ra) # dcc <open>
     98e:	84aa                	mv	s1,a0
  r = read(fd1, &c2, 1);
     990:	4605                	li	a2,1
     992:	f9840593          	addi	a1,s0,-104
     996:	00000097          	auipc	ra,0x0
     99a:	40e080e7          	jalr	1038(ra) # da4 <read>
  if(r!=1) fail("Failed to read from p in /testsymlink3/q\n");
     99e:	4785                	li	a5,1
     9a0:	02f51663          	bne	a0,a5,9cc <main+0x980>
  if(c!=c2)
     9a4:	f9044703          	lbu	a4,-112(s0)
     9a8:	f9844783          	lbu	a5,-104(s0)
     9ac:	02f70e63          	beq	a4,a5,9e8 <main+0x99c>
    fail("Value read from p in /testsymlink3/q differed from value written to /testsymlink3/q/p\n");
     9b0:	00001517          	auipc	a0,0x1
     9b4:	1f850513          	addi	a0,a0,504 # 1ba8 <malloc+0x9dc>
     9b8:	00000097          	auipc	ra,0x0
     9bc:	754080e7          	jalr	1876(ra) # 110c <printf>
     9c0:	4785                	li	a5,1
     9c2:	00001717          	auipc	a4,0x1
     9c6:	36f72f23          	sw	a5,894(a4) # 1d40 <failed>
     9ca:	bd31                	j	7e6 <main+0x79a>
  if(r!=1) fail("Failed to read from p in /testsymlink3/q\n");
     9cc:	00001517          	auipc	a0,0x1
     9d0:	1a450513          	addi	a0,a0,420 # 1b70 <malloc+0x9a4>
     9d4:	00000097          	auipc	ra,0x0
     9d8:	738080e7          	jalr	1848(ra) # 110c <printf>
     9dc:	4785                	li	a5,1
     9de:	00001717          	auipc	a4,0x1
     9e2:	36f72123          	sw	a5,866(a4) # 1d40 <failed>
     9e6:	b501                	j	7e6 <main+0x79a>
  printf("-- read \"#\" from p in /testsymlink3/q/\n");
     9e8:	00001517          	auipc	a0,0x1
     9ec:	22850513          	addi	a0,a0,552 # 1c10 <malloc+0xa44>
     9f0:	00000097          	auipc	ra,0x0
     9f4:	71c080e7          	jalr	1820(ra) # 110c <printf>
  close(fd1);
     9f8:	8526                	mv	a0,s1
     9fa:	00000097          	auipc	ra,0x0
     9fe:	3ba080e7          	jalr	954(ra) # db4 <close>
  printf("test symlinks to directory: ok\n");
     a02:	00001517          	auipc	a0,0x1
     a06:	23650513          	addi	a0,a0,566 # 1c38 <malloc+0xa6c>
     a0a:	00000097          	auipc	ra,0x0
     a0e:	702080e7          	jalr	1794(ra) # 110c <printf>
     a12:	bbd1                	j	7e6 <main+0x79a>
    printf("FAILED: open failed");
     a14:	00001517          	auipc	a0,0x1
     a18:	26c50513          	addi	a0,a0,620 # 1c80 <malloc+0xab4>
     a1c:	00000097          	auipc	ra,0x0
     a20:	6f0080e7          	jalr	1776(ra) # 110c <printf>
    exit(1);
     a24:	4505                	li	a0,1
     a26:	00000097          	auipc	ra,0x0
     a2a:	366080e7          	jalr	870(ra) # d8c <exit>
      printf("FAILED: fork failed\n");
     a2e:	00001517          	auipc	a0,0x1
     a32:	26a50513          	addi	a0,a0,618 # 1c98 <malloc+0xacc>
     a36:	00000097          	auipc	ra,0x0
     a3a:	6d6080e7          	jalr	1750(ra) # 110c <printf>
      exit(1);
     a3e:	4505                	li	a0,1
     a40:	00000097          	auipc	ra,0x0
     a44:	34c080e7          	jalr	844(ra) # d8c <exit>
  int r, fd1 = -1, fd2 = -1;
     a48:	06400913          	li	s2,100
      unsigned int x = (pid ? 1 : 97);
     a4c:	06100993          	li	s3,97
        x = x * 1103515245 + 12345;
     a50:	41c65ab7          	lui	s5,0x41c65
     a54:	e6da8a9b          	addiw	s5,s5,-403
     a58:	6a0d                	lui	s4,0x3
     a5a:	039a0a1b          	addiw	s4,s4,57
        if((x % 3) == 0) {
     a5e:	4c0d                	li	s8,3
          unlink("/testsymlink/y");
     a60:	00001497          	auipc	s1,0x1
     a64:	8d848493          	addi	s1,s1,-1832 # 1338 <malloc+0x16c>
          symlink("/testsymlink/z", "/testsymlink/y");
     a68:	00001b97          	auipc	s7,0x1
     a6c:	8c0b8b93          	addi	s7,s7,-1856 # 1328 <malloc+0x15c>
            if(st.type != T_SYMLINK) {
     a70:	4b11                	li	s6,4
     a72:	a809                	j	a84 <main+0xa38>
          unlink("/testsymlink/y");
     a74:	8526                	mv	a0,s1
     a76:	00000097          	auipc	ra,0x0
     a7a:	366080e7          	jalr	870(ra) # ddc <unlink>
     a7e:	397d                	addiw	s2,s2,-1
      for(i = 0; i < 100; i++){
     a80:	04090c63          	beqz	s2,ad8 <main+0xa8c>
        x = x * 1103515245 + 12345;
     a84:	035987bb          	mulw	a5,s3,s5
     a88:	014787bb          	addw	a5,a5,s4
     a8c:	0007899b          	sext.w	s3,a5
        if((x % 3) == 0) {
     a90:	0387f7bb          	remuw	a5,a5,s8
     a94:	f3e5                	bnez	a5,a74 <main+0xa28>
          symlink("/testsymlink/z", "/testsymlink/y");
     a96:	85a6                	mv	a1,s1
     a98:	855e                	mv	a0,s7
     a9a:	00000097          	auipc	ra,0x0
     a9e:	392080e7          	jalr	914(ra) # e2c <symlink>
          if (stat_slink("/testsymlink/y", &st) == 0) {
     aa2:	f9840593          	addi	a1,s0,-104
     aa6:	8526                	mv	a0,s1
     aa8:	fffff097          	auipc	ra,0xfffff
     aac:	558080e7          	jalr	1368(ra) # 0 <stat_slink>
     ab0:	f579                	bnez	a0,a7e <main+0xa32>
            if(st.type != T_SYMLINK) {
     ab2:	fa041583          	lh	a1,-96(s0)
     ab6:	0005879b          	sext.w	a5,a1
     aba:	fd6782e3          	beq	a5,s6,a7e <main+0xa32>
              printf("FAILED: not a symbolic link\n", st.type);
     abe:	00001517          	auipc	a0,0x1
     ac2:	1f250513          	addi	a0,a0,498 # 1cb0 <malloc+0xae4>
     ac6:	00000097          	auipc	ra,0x0
     aca:	646080e7          	jalr	1606(ra) # 110c <printf>
              exit(1);
     ace:	4505                	li	a0,1
     ad0:	00000097          	auipc	ra,0x0
     ad4:	2bc080e7          	jalr	700(ra) # d8c <exit>
      exit(0);
     ad8:	4501                	li	a0,0
     ada:	00000097          	auipc	ra,0x0
     ade:	2b2080e7          	jalr	690(ra) # d8c <exit>
      printf("test concurrent symlinks: failed\n");
     ae2:	00001517          	auipc	a0,0x1
     ae6:	1ee50513          	addi	a0,a0,494 # 1cd0 <malloc+0xb04>
     aea:	00000097          	auipc	ra,0x0
     aee:	622080e7          	jalr	1570(ra) # 110c <printf>
      exit(1);
     af2:	4505                	li	a0,1
     af4:	00000097          	auipc	ra,0x0
     af8:	298080e7          	jalr	664(ra) # d8c <exit>

0000000000000afc <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     afc:	1141                	addi	sp,sp,-16
     afe:	e422                	sd	s0,8(sp)
     b00:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b02:	87aa                	mv	a5,a0
     b04:	0585                	addi	a1,a1,1
     b06:	0785                	addi	a5,a5,1
     b08:	fff5c703          	lbu	a4,-1(a1)
     b0c:	fee78fa3          	sb	a4,-1(a5)
     b10:	fb75                	bnez	a4,b04 <strcpy+0x8>
    ;
  return os;
}
     b12:	6422                	ld	s0,8(sp)
     b14:	0141                	addi	sp,sp,16
     b16:	8082                	ret

0000000000000b18 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     b18:	1141                	addi	sp,sp,-16
     b1a:	e422                	sd	s0,8(sp)
     b1c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     b1e:	00054783          	lbu	a5,0(a0)
     b22:	cf91                	beqz	a5,b3e <strcmp+0x26>
     b24:	0005c703          	lbu	a4,0(a1)
     b28:	00f71b63          	bne	a4,a5,b3e <strcmp+0x26>
    p++, q++;
     b2c:	0505                	addi	a0,a0,1
     b2e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     b30:	00054783          	lbu	a5,0(a0)
     b34:	c789                	beqz	a5,b3e <strcmp+0x26>
     b36:	0005c703          	lbu	a4,0(a1)
     b3a:	fef709e3          	beq	a4,a5,b2c <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
     b3e:	0005c503          	lbu	a0,0(a1)
}
     b42:	40a7853b          	subw	a0,a5,a0
     b46:	6422                	ld	s0,8(sp)
     b48:	0141                	addi	sp,sp,16
     b4a:	8082                	ret

0000000000000b4c <strlen>:

uint
strlen(const char *s)
{
     b4c:	1141                	addi	sp,sp,-16
     b4e:	e422                	sd	s0,8(sp)
     b50:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     b52:	00054783          	lbu	a5,0(a0)
     b56:	cf91                	beqz	a5,b72 <strlen+0x26>
     b58:	0505                	addi	a0,a0,1
     b5a:	87aa                	mv	a5,a0
     b5c:	4685                	li	a3,1
     b5e:	9e89                	subw	a3,a3,a0
    ;
     b60:	00f6853b          	addw	a0,a3,a5
     b64:	0785                	addi	a5,a5,1
  for(n = 0; s[n]; n++)
     b66:	fff7c703          	lbu	a4,-1(a5)
     b6a:	fb7d                	bnez	a4,b60 <strlen+0x14>
  return n;
}
     b6c:	6422                	ld	s0,8(sp)
     b6e:	0141                	addi	sp,sp,16
     b70:	8082                	ret
  for(n = 0; s[n]; n++)
     b72:	4501                	li	a0,0
     b74:	bfe5                	j	b6c <strlen+0x20>

0000000000000b76 <memset>:

void*
memset(void *dst, int c, uint n)
{
     b76:	1141                	addi	sp,sp,-16
     b78:	e422                	sd	s0,8(sp)
     b7a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     b7c:	ce09                	beqz	a2,b96 <memset+0x20>
     b7e:	87aa                	mv	a5,a0
     b80:	fff6071b          	addiw	a4,a2,-1
     b84:	1702                	slli	a4,a4,0x20
     b86:	9301                	srli	a4,a4,0x20
     b88:	0705                	addi	a4,a4,1
     b8a:	972a                	add	a4,a4,a0
    cdst[i] = c;
     b8c:	00b78023          	sb	a1,0(a5)
     b90:	0785                	addi	a5,a5,1
  for(i = 0; i < n; i++){
     b92:	fee79de3          	bne	a5,a4,b8c <memset+0x16>
  }
  return dst;
}
     b96:	6422                	ld	s0,8(sp)
     b98:	0141                	addi	sp,sp,16
     b9a:	8082                	ret

0000000000000b9c <strchr>:

char*
strchr(const char *s, char c)
{
     b9c:	1141                	addi	sp,sp,-16
     b9e:	e422                	sd	s0,8(sp)
     ba0:	0800                	addi	s0,sp,16
  for(; *s; s++)
     ba2:	00054783          	lbu	a5,0(a0)
     ba6:	cf91                	beqz	a5,bc2 <strchr+0x26>
    if(*s == c)
     ba8:	00f58a63          	beq	a1,a5,bbc <strchr+0x20>
  for(; *s; s++)
     bac:	0505                	addi	a0,a0,1
     bae:	00054783          	lbu	a5,0(a0)
     bb2:	c781                	beqz	a5,bba <strchr+0x1e>
    if(*s == c)
     bb4:	feb79ce3          	bne	a5,a1,bac <strchr+0x10>
     bb8:	a011                	j	bbc <strchr+0x20>
      return (char*)s;
  return 0;
     bba:	4501                	li	a0,0
}
     bbc:	6422                	ld	s0,8(sp)
     bbe:	0141                	addi	sp,sp,16
     bc0:	8082                	ret
  return 0;
     bc2:	4501                	li	a0,0
     bc4:	bfe5                	j	bbc <strchr+0x20>

0000000000000bc6 <gets>:

char*
gets(char *buf, int max)
{
     bc6:	711d                	addi	sp,sp,-96
     bc8:	ec86                	sd	ra,88(sp)
     bca:	e8a2                	sd	s0,80(sp)
     bcc:	e4a6                	sd	s1,72(sp)
     bce:	e0ca                	sd	s2,64(sp)
     bd0:	fc4e                	sd	s3,56(sp)
     bd2:	f852                	sd	s4,48(sp)
     bd4:	f456                	sd	s5,40(sp)
     bd6:	f05a                	sd	s6,32(sp)
     bd8:	ec5e                	sd	s7,24(sp)
     bda:	1080                	addi	s0,sp,96
     bdc:	8baa                	mv	s7,a0
     bde:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     be0:	892a                	mv	s2,a0
     be2:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     be4:	4aa9                	li	s5,10
     be6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     be8:	0019849b          	addiw	s1,s3,1
     bec:	0344d863          	ble	s4,s1,c1c <gets+0x56>
    cc = read(0, &c, 1);
     bf0:	4605                	li	a2,1
     bf2:	faf40593          	addi	a1,s0,-81
     bf6:	4501                	li	a0,0
     bf8:	00000097          	auipc	ra,0x0
     bfc:	1ac080e7          	jalr	428(ra) # da4 <read>
    if(cc < 1)
     c00:	00a05e63          	blez	a0,c1c <gets+0x56>
    buf[i++] = c;
     c04:	faf44783          	lbu	a5,-81(s0)
     c08:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     c0c:	01578763          	beq	a5,s5,c1a <gets+0x54>
     c10:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
     c12:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
     c14:	fd679ae3          	bne	a5,s6,be8 <gets+0x22>
     c18:	a011                	j	c1c <gets+0x56>
  for(i=0; i+1 < max; ){
     c1a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     c1c:	99de                	add	s3,s3,s7
     c1e:	00098023          	sb	zero,0(s3)
  return buf;
}
     c22:	855e                	mv	a0,s7
     c24:	60e6                	ld	ra,88(sp)
     c26:	6446                	ld	s0,80(sp)
     c28:	64a6                	ld	s1,72(sp)
     c2a:	6906                	ld	s2,64(sp)
     c2c:	79e2                	ld	s3,56(sp)
     c2e:	7a42                	ld	s4,48(sp)
     c30:	7aa2                	ld	s5,40(sp)
     c32:	7b02                	ld	s6,32(sp)
     c34:	6be2                	ld	s7,24(sp)
     c36:	6125                	addi	sp,sp,96
     c38:	8082                	ret

0000000000000c3a <stat>:

int
stat(const char *n, struct stat *st)
{
     c3a:	1101                	addi	sp,sp,-32
     c3c:	ec06                	sd	ra,24(sp)
     c3e:	e822                	sd	s0,16(sp)
     c40:	e426                	sd	s1,8(sp)
     c42:	e04a                	sd	s2,0(sp)
     c44:	1000                	addi	s0,sp,32
     c46:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY|O_NOFOLLOW);
     c48:	4591                	li	a1,4
     c4a:	00000097          	auipc	ra,0x0
     c4e:	182080e7          	jalr	386(ra) # dcc <open>
  if(fd < 0)
     c52:	02054563          	bltz	a0,c7c <stat+0x42>
     c56:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     c58:	85ca                	mv	a1,s2
     c5a:	00000097          	auipc	ra,0x0
     c5e:	18a080e7          	jalr	394(ra) # de4 <fstat>
     c62:	892a                	mv	s2,a0
  close(fd);
     c64:	8526                	mv	a0,s1
     c66:	00000097          	auipc	ra,0x0
     c6a:	14e080e7          	jalr	334(ra) # db4 <close>
  return r;
}
     c6e:	854a                	mv	a0,s2
     c70:	60e2                	ld	ra,24(sp)
     c72:	6442                	ld	s0,16(sp)
     c74:	64a2                	ld	s1,8(sp)
     c76:	6902                	ld	s2,0(sp)
     c78:	6105                	addi	sp,sp,32
     c7a:	8082                	ret
    return -1;
     c7c:	597d                	li	s2,-1
     c7e:	bfc5                	j	c6e <stat+0x34>

0000000000000c80 <atoi>:

int
atoi(const char *s)
{
     c80:	1141                	addi	sp,sp,-16
     c82:	e422                	sd	s0,8(sp)
     c84:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     c86:	00054683          	lbu	a3,0(a0)
     c8a:	fd06879b          	addiw	a5,a3,-48
     c8e:	0ff7f793          	andi	a5,a5,255
     c92:	4725                	li	a4,9
     c94:	02f76963          	bltu	a4,a5,cc6 <atoi+0x46>
     c98:	862a                	mv	a2,a0
  n = 0;
     c9a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     c9c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     c9e:	0605                	addi	a2,a2,1
     ca0:	0025179b          	slliw	a5,a0,0x2
     ca4:	9fa9                	addw	a5,a5,a0
     ca6:	0017979b          	slliw	a5,a5,0x1
     caa:	9fb5                	addw	a5,a5,a3
     cac:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     cb0:	00064683          	lbu	a3,0(a2)
     cb4:	fd06871b          	addiw	a4,a3,-48
     cb8:	0ff77713          	andi	a4,a4,255
     cbc:	fee5f1e3          	bleu	a4,a1,c9e <atoi+0x1e>
  return n;
}
     cc0:	6422                	ld	s0,8(sp)
     cc2:	0141                	addi	sp,sp,16
     cc4:	8082                	ret
  n = 0;
     cc6:	4501                	li	a0,0
     cc8:	bfe5                	j	cc0 <atoi+0x40>

0000000000000cca <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     cca:	1141                	addi	sp,sp,-16
     ccc:	e422                	sd	s0,8(sp)
     cce:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     cd0:	02b57663          	bleu	a1,a0,cfc <memmove+0x32>
    while(n-- > 0)
     cd4:	02c05163          	blez	a2,cf6 <memmove+0x2c>
     cd8:	fff6079b          	addiw	a5,a2,-1
     cdc:	1782                	slli	a5,a5,0x20
     cde:	9381                	srli	a5,a5,0x20
     ce0:	0785                	addi	a5,a5,1
     ce2:	97aa                	add	a5,a5,a0
  dst = vdst;
     ce4:	872a                	mv	a4,a0
      *dst++ = *src++;
     ce6:	0585                	addi	a1,a1,1
     ce8:	0705                	addi	a4,a4,1
     cea:	fff5c683          	lbu	a3,-1(a1)
     cee:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     cf2:	fee79ae3          	bne	a5,a4,ce6 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     cf6:	6422                	ld	s0,8(sp)
     cf8:	0141                	addi	sp,sp,16
     cfa:	8082                	ret
    dst += n;
     cfc:	00c50733          	add	a4,a0,a2
    src += n;
     d00:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     d02:	fec05ae3          	blez	a2,cf6 <memmove+0x2c>
     d06:	fff6079b          	addiw	a5,a2,-1
     d0a:	1782                	slli	a5,a5,0x20
     d0c:	9381                	srli	a5,a5,0x20
     d0e:	fff7c793          	not	a5,a5
     d12:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     d14:	15fd                	addi	a1,a1,-1
     d16:	177d                	addi	a4,a4,-1
     d18:	0005c683          	lbu	a3,0(a1)
     d1c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     d20:	fef71ae3          	bne	a4,a5,d14 <memmove+0x4a>
     d24:	bfc9                	j	cf6 <memmove+0x2c>

0000000000000d26 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     d26:	1141                	addi	sp,sp,-16
     d28:	e422                	sd	s0,8(sp)
     d2a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     d2c:	ce15                	beqz	a2,d68 <memcmp+0x42>
     d2e:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
     d32:	00054783          	lbu	a5,0(a0)
     d36:	0005c703          	lbu	a4,0(a1)
     d3a:	02e79063          	bne	a5,a4,d5a <memcmp+0x34>
     d3e:	1682                	slli	a3,a3,0x20
     d40:	9281                	srli	a3,a3,0x20
     d42:	0685                	addi	a3,a3,1
     d44:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
     d46:	0505                	addi	a0,a0,1
    p2++;
     d48:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     d4a:	00d50d63          	beq	a0,a3,d64 <memcmp+0x3e>
    if (*p1 != *p2) {
     d4e:	00054783          	lbu	a5,0(a0)
     d52:	0005c703          	lbu	a4,0(a1)
     d56:	fee788e3          	beq	a5,a4,d46 <memcmp+0x20>
      return *p1 - *p2;
     d5a:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
     d5e:	6422                	ld	s0,8(sp)
     d60:	0141                	addi	sp,sp,16
     d62:	8082                	ret
  return 0;
     d64:	4501                	li	a0,0
     d66:	bfe5                	j	d5e <memcmp+0x38>
     d68:	4501                	li	a0,0
     d6a:	bfd5                	j	d5e <memcmp+0x38>

0000000000000d6c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     d6c:	1141                	addi	sp,sp,-16
     d6e:	e406                	sd	ra,8(sp)
     d70:	e022                	sd	s0,0(sp)
     d72:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     d74:	00000097          	auipc	ra,0x0
     d78:	f56080e7          	jalr	-170(ra) # cca <memmove>
}
     d7c:	60a2                	ld	ra,8(sp)
     d7e:	6402                	ld	s0,0(sp)
     d80:	0141                	addi	sp,sp,16
     d82:	8082                	ret

0000000000000d84 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     d84:	4885                	li	a7,1
 ecall
     d86:	00000073          	ecall
 ret
     d8a:	8082                	ret

0000000000000d8c <exit>:
.global exit
exit:
 li a7, SYS_exit
     d8c:	4889                	li	a7,2
 ecall
     d8e:	00000073          	ecall
 ret
     d92:	8082                	ret

0000000000000d94 <wait>:
.global wait
wait:
 li a7, SYS_wait
     d94:	488d                	li	a7,3
 ecall
     d96:	00000073          	ecall
 ret
     d9a:	8082                	ret

0000000000000d9c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     d9c:	4891                	li	a7,4
 ecall
     d9e:	00000073          	ecall
 ret
     da2:	8082                	ret

0000000000000da4 <read>:
.global read
read:
 li a7, SYS_read
     da4:	4895                	li	a7,5
 ecall
     da6:	00000073          	ecall
 ret
     daa:	8082                	ret

0000000000000dac <write>:
.global write
write:
 li a7, SYS_write
     dac:	48c1                	li	a7,16
 ecall
     dae:	00000073          	ecall
 ret
     db2:	8082                	ret

0000000000000db4 <close>:
.global close
close:
 li a7, SYS_close
     db4:	48d5                	li	a7,21
 ecall
     db6:	00000073          	ecall
 ret
     dba:	8082                	ret

0000000000000dbc <kill>:
.global kill
kill:
 li a7, SYS_kill
     dbc:	4899                	li	a7,6
 ecall
     dbe:	00000073          	ecall
 ret
     dc2:	8082                	ret

0000000000000dc4 <exec>:
.global exec
exec:
 li a7, SYS_exec
     dc4:	489d                	li	a7,7
 ecall
     dc6:	00000073          	ecall
 ret
     dca:	8082                	ret

0000000000000dcc <open>:
.global open
open:
 li a7, SYS_open
     dcc:	48bd                	li	a7,15
 ecall
     dce:	00000073          	ecall
 ret
     dd2:	8082                	ret

0000000000000dd4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     dd4:	48c5                	li	a7,17
 ecall
     dd6:	00000073          	ecall
 ret
     dda:	8082                	ret

0000000000000ddc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     ddc:	48c9                	li	a7,18
 ecall
     dde:	00000073          	ecall
 ret
     de2:	8082                	ret

0000000000000de4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     de4:	48a1                	li	a7,8
 ecall
     de6:	00000073          	ecall
 ret
     dea:	8082                	ret

0000000000000dec <link>:
.global link
link:
 li a7, SYS_link
     dec:	48cd                	li	a7,19
 ecall
     dee:	00000073          	ecall
 ret
     df2:	8082                	ret

0000000000000df4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     df4:	48d1                	li	a7,20
 ecall
     df6:	00000073          	ecall
 ret
     dfa:	8082                	ret

0000000000000dfc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     dfc:	48a5                	li	a7,9
 ecall
     dfe:	00000073          	ecall
 ret
     e02:	8082                	ret

0000000000000e04 <dup>:
.global dup
dup:
 li a7, SYS_dup
     e04:	48a9                	li	a7,10
 ecall
     e06:	00000073          	ecall
 ret
     e0a:	8082                	ret

0000000000000e0c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     e0c:	48ad                	li	a7,11
 ecall
     e0e:	00000073          	ecall
 ret
     e12:	8082                	ret

0000000000000e14 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     e14:	48b1                	li	a7,12
 ecall
     e16:	00000073          	ecall
 ret
     e1a:	8082                	ret

0000000000000e1c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     e1c:	48b5                	li	a7,13
 ecall
     e1e:	00000073          	ecall
 ret
     e22:	8082                	ret

0000000000000e24 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     e24:	48b9                	li	a7,14
 ecall
     e26:	00000073          	ecall
 ret
     e2a:	8082                	ret

0000000000000e2c <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
     e2c:	48d9                	li	a7,22
 ecall
     e2e:	00000073          	ecall
 ret
     e32:	8082                	ret

0000000000000e34 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     e34:	1101                	addi	sp,sp,-32
     e36:	ec06                	sd	ra,24(sp)
     e38:	e822                	sd	s0,16(sp)
     e3a:	1000                	addi	s0,sp,32
     e3c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     e40:	4605                	li	a2,1
     e42:	fef40593          	addi	a1,s0,-17
     e46:	00000097          	auipc	ra,0x0
     e4a:	f66080e7          	jalr	-154(ra) # dac <write>
}
     e4e:	60e2                	ld	ra,24(sp)
     e50:	6442                	ld	s0,16(sp)
     e52:	6105                	addi	sp,sp,32
     e54:	8082                	ret

0000000000000e56 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     e56:	7139                	addi	sp,sp,-64
     e58:	fc06                	sd	ra,56(sp)
     e5a:	f822                	sd	s0,48(sp)
     e5c:	f426                	sd	s1,40(sp)
     e5e:	f04a                	sd	s2,32(sp)
     e60:	ec4e                	sd	s3,24(sp)
     e62:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     e64:	c299                	beqz	a3,e6a <printint+0x14>
     e66:	0005cd63          	bltz	a1,e80 <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     e6a:	2581                	sext.w	a1,a1
  neg = 0;
     e6c:	4301                	li	t1,0
     e6e:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
     e72:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
     e74:	2601                	sext.w	a2,a2
     e76:	00001897          	auipc	a7,0x1
     e7a:	ea288893          	addi	a7,a7,-350 # 1d18 <digits>
     e7e:	a801                	j	e8e <printint+0x38>
    x = -xx;
     e80:	40b005bb          	negw	a1,a1
     e84:	2581                	sext.w	a1,a1
    neg = 1;
     e86:	4305                	li	t1,1
    x = -xx;
     e88:	b7dd                	j	e6e <printint+0x18>
  }while((x /= base) != 0);
     e8a:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
     e8c:	8836                	mv	a6,a3
     e8e:	0018069b          	addiw	a3,a6,1
     e92:	02c5f7bb          	remuw	a5,a1,a2
     e96:	1782                	slli	a5,a5,0x20
     e98:	9381                	srli	a5,a5,0x20
     e9a:	97c6                	add	a5,a5,a7
     e9c:	0007c783          	lbu	a5,0(a5)
     ea0:	00f70023          	sb	a5,0(a4)
     ea4:	0705                	addi	a4,a4,1
  }while((x /= base) != 0);
     ea6:	02c5d7bb          	divuw	a5,a1,a2
     eaa:	fec5f0e3          	bleu	a2,a1,e8a <printint+0x34>
  if(neg)
     eae:	00030b63          	beqz	t1,ec4 <printint+0x6e>
    buf[i++] = '-';
     eb2:	fd040793          	addi	a5,s0,-48
     eb6:	96be                	add	a3,a3,a5
     eb8:	02d00793          	li	a5,45
     ebc:	fef68823          	sb	a5,-16(a3)
     ec0:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
     ec4:	02d05963          	blez	a3,ef6 <printint+0xa0>
     ec8:	89aa                	mv	s3,a0
     eca:	fc040793          	addi	a5,s0,-64
     ece:	00d784b3          	add	s1,a5,a3
     ed2:	fff78913          	addi	s2,a5,-1
     ed6:	9936                	add	s2,s2,a3
     ed8:	36fd                	addiw	a3,a3,-1
     eda:	1682                	slli	a3,a3,0x20
     edc:	9281                	srli	a3,a3,0x20
     ede:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
     ee2:	fff4c583          	lbu	a1,-1(s1)
     ee6:	854e                	mv	a0,s3
     ee8:	00000097          	auipc	ra,0x0
     eec:	f4c080e7          	jalr	-180(ra) # e34 <putc>
     ef0:	14fd                	addi	s1,s1,-1
  while(--i >= 0)
     ef2:	ff2498e3          	bne	s1,s2,ee2 <printint+0x8c>
}
     ef6:	70e2                	ld	ra,56(sp)
     ef8:	7442                	ld	s0,48(sp)
     efa:	74a2                	ld	s1,40(sp)
     efc:	7902                	ld	s2,32(sp)
     efe:	69e2                	ld	s3,24(sp)
     f00:	6121                	addi	sp,sp,64
     f02:	8082                	ret

0000000000000f04 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     f04:	7119                	addi	sp,sp,-128
     f06:	fc86                	sd	ra,120(sp)
     f08:	f8a2                	sd	s0,112(sp)
     f0a:	f4a6                	sd	s1,104(sp)
     f0c:	f0ca                	sd	s2,96(sp)
     f0e:	ecce                	sd	s3,88(sp)
     f10:	e8d2                	sd	s4,80(sp)
     f12:	e4d6                	sd	s5,72(sp)
     f14:	e0da                	sd	s6,64(sp)
     f16:	fc5e                	sd	s7,56(sp)
     f18:	f862                	sd	s8,48(sp)
     f1a:	f466                	sd	s9,40(sp)
     f1c:	f06a                	sd	s10,32(sp)
     f1e:	ec6e                	sd	s11,24(sp)
     f20:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     f22:	0005c483          	lbu	s1,0(a1)
     f26:	18048d63          	beqz	s1,10c0 <vprintf+0x1bc>
     f2a:	8aaa                	mv	s5,a0
     f2c:	8b32                	mv	s6,a2
     f2e:	00158913          	addi	s2,a1,1
  state = 0;
     f32:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     f34:	02500a13          	li	s4,37
      if(c == 'd'){
     f38:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
     f3c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
     f40:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
     f44:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     f48:	00001b97          	auipc	s7,0x1
     f4c:	dd0b8b93          	addi	s7,s7,-560 # 1d18 <digits>
     f50:	a839                	j	f6e <vprintf+0x6a>
        putc(fd, c);
     f52:	85a6                	mv	a1,s1
     f54:	8556                	mv	a0,s5
     f56:	00000097          	auipc	ra,0x0
     f5a:	ede080e7          	jalr	-290(ra) # e34 <putc>
     f5e:	a019                	j	f64 <vprintf+0x60>
    } else if(state == '%'){
     f60:	01498f63          	beq	s3,s4,f7e <vprintf+0x7a>
     f64:	0905                	addi	s2,s2,1
  for(i = 0; fmt[i]; i++){
     f66:	fff94483          	lbu	s1,-1(s2)
     f6a:	14048b63          	beqz	s1,10c0 <vprintf+0x1bc>
    c = fmt[i] & 0xff;
     f6e:	0004879b          	sext.w	a5,s1
    if(state == 0){
     f72:	fe0997e3          	bnez	s3,f60 <vprintf+0x5c>
      if(c == '%'){
     f76:	fd479ee3          	bne	a5,s4,f52 <vprintf+0x4e>
        state = '%';
     f7a:	89be                	mv	s3,a5
     f7c:	b7e5                	j	f64 <vprintf+0x60>
      if(c == 'd'){
     f7e:	05878063          	beq	a5,s8,fbe <vprintf+0xba>
      } else if(c == 'l') {
     f82:	05978c63          	beq	a5,s9,fda <vprintf+0xd6>
      } else if(c == 'x') {
     f86:	07a78863          	beq	a5,s10,ff6 <vprintf+0xf2>
      } else if(c == 'p') {
     f8a:	09b78463          	beq	a5,s11,1012 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
     f8e:	07300713          	li	a4,115
     f92:	0ce78563          	beq	a5,a4,105c <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     f96:	06300713          	li	a4,99
     f9a:	0ee78c63          	beq	a5,a4,1092 <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
     f9e:	11478663          	beq	a5,s4,10aa <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     fa2:	85d2                	mv	a1,s4
     fa4:	8556                	mv	a0,s5
     fa6:	00000097          	auipc	ra,0x0
     faa:	e8e080e7          	jalr	-370(ra) # e34 <putc>
        putc(fd, c);
     fae:	85a6                	mv	a1,s1
     fb0:	8556                	mv	a0,s5
     fb2:	00000097          	auipc	ra,0x0
     fb6:	e82080e7          	jalr	-382(ra) # e34 <putc>
      }
      state = 0;
     fba:	4981                	li	s3,0
     fbc:	b765                	j	f64 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
     fbe:	008b0493          	addi	s1,s6,8
     fc2:	4685                	li	a3,1
     fc4:	4629                	li	a2,10
     fc6:	000b2583          	lw	a1,0(s6)
     fca:	8556                	mv	a0,s5
     fcc:	00000097          	auipc	ra,0x0
     fd0:	e8a080e7          	jalr	-374(ra) # e56 <printint>
     fd4:	8b26                	mv	s6,s1
      state = 0;
     fd6:	4981                	li	s3,0
     fd8:	b771                	j	f64 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
     fda:	008b0493          	addi	s1,s6,8
     fde:	4681                	li	a3,0
     fe0:	4629                	li	a2,10
     fe2:	000b2583          	lw	a1,0(s6)
     fe6:	8556                	mv	a0,s5
     fe8:	00000097          	auipc	ra,0x0
     fec:	e6e080e7          	jalr	-402(ra) # e56 <printint>
     ff0:	8b26                	mv	s6,s1
      state = 0;
     ff2:	4981                	li	s3,0
     ff4:	bf85                	j	f64 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
     ff6:	008b0493          	addi	s1,s6,8
     ffa:	4681                	li	a3,0
     ffc:	4641                	li	a2,16
     ffe:	000b2583          	lw	a1,0(s6)
    1002:	8556                	mv	a0,s5
    1004:	00000097          	auipc	ra,0x0
    1008:	e52080e7          	jalr	-430(ra) # e56 <printint>
    100c:	8b26                	mv	s6,s1
      state = 0;
    100e:	4981                	li	s3,0
    1010:	bf91                	j	f64 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    1012:	008b0793          	addi	a5,s6,8
    1016:	f8f43423          	sd	a5,-120(s0)
    101a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    101e:	03000593          	li	a1,48
    1022:	8556                	mv	a0,s5
    1024:	00000097          	auipc	ra,0x0
    1028:	e10080e7          	jalr	-496(ra) # e34 <putc>
  putc(fd, 'x');
    102c:	85ea                	mv	a1,s10
    102e:	8556                	mv	a0,s5
    1030:	00000097          	auipc	ra,0x0
    1034:	e04080e7          	jalr	-508(ra) # e34 <putc>
    1038:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    103a:	03c9d793          	srli	a5,s3,0x3c
    103e:	97de                	add	a5,a5,s7
    1040:	0007c583          	lbu	a1,0(a5)
    1044:	8556                	mv	a0,s5
    1046:	00000097          	auipc	ra,0x0
    104a:	dee080e7          	jalr	-530(ra) # e34 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    104e:	0992                	slli	s3,s3,0x4
    1050:	34fd                	addiw	s1,s1,-1
    1052:	f4e5                	bnez	s1,103a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    1054:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    1058:	4981                	li	s3,0
    105a:	b729                	j	f64 <vprintf+0x60>
        s = va_arg(ap, char*);
    105c:	008b0993          	addi	s3,s6,8
    1060:	000b3483          	ld	s1,0(s6)
        if(s == 0)
    1064:	c085                	beqz	s1,1084 <vprintf+0x180>
        while(*s != 0){
    1066:	0004c583          	lbu	a1,0(s1)
    106a:	c9a1                	beqz	a1,10ba <vprintf+0x1b6>
          putc(fd, *s);
    106c:	8556                	mv	a0,s5
    106e:	00000097          	auipc	ra,0x0
    1072:	dc6080e7          	jalr	-570(ra) # e34 <putc>
          s++;
    1076:	0485                	addi	s1,s1,1
        while(*s != 0){
    1078:	0004c583          	lbu	a1,0(s1)
    107c:	f9e5                	bnez	a1,106c <vprintf+0x168>
        s = va_arg(ap, char*);
    107e:	8b4e                	mv	s6,s3
      state = 0;
    1080:	4981                	li	s3,0
    1082:	b5cd                	j	f64 <vprintf+0x60>
          s = "(null)";
    1084:	00001497          	auipc	s1,0x1
    1088:	cac48493          	addi	s1,s1,-852 # 1d30 <digits+0x18>
        while(*s != 0){
    108c:	02800593          	li	a1,40
    1090:	bff1                	j	106c <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
    1092:	008b0493          	addi	s1,s6,8
    1096:	000b4583          	lbu	a1,0(s6)
    109a:	8556                	mv	a0,s5
    109c:	00000097          	auipc	ra,0x0
    10a0:	d98080e7          	jalr	-616(ra) # e34 <putc>
    10a4:	8b26                	mv	s6,s1
      state = 0;
    10a6:	4981                	li	s3,0
    10a8:	bd75                	j	f64 <vprintf+0x60>
        putc(fd, c);
    10aa:	85d2                	mv	a1,s4
    10ac:	8556                	mv	a0,s5
    10ae:	00000097          	auipc	ra,0x0
    10b2:	d86080e7          	jalr	-634(ra) # e34 <putc>
      state = 0;
    10b6:	4981                	li	s3,0
    10b8:	b575                	j	f64 <vprintf+0x60>
        s = va_arg(ap, char*);
    10ba:	8b4e                	mv	s6,s3
      state = 0;
    10bc:	4981                	li	s3,0
    10be:	b55d                	j	f64 <vprintf+0x60>
    }
  }
}
    10c0:	70e6                	ld	ra,120(sp)
    10c2:	7446                	ld	s0,112(sp)
    10c4:	74a6                	ld	s1,104(sp)
    10c6:	7906                	ld	s2,96(sp)
    10c8:	69e6                	ld	s3,88(sp)
    10ca:	6a46                	ld	s4,80(sp)
    10cc:	6aa6                	ld	s5,72(sp)
    10ce:	6b06                	ld	s6,64(sp)
    10d0:	7be2                	ld	s7,56(sp)
    10d2:	7c42                	ld	s8,48(sp)
    10d4:	7ca2                	ld	s9,40(sp)
    10d6:	7d02                	ld	s10,32(sp)
    10d8:	6de2                	ld	s11,24(sp)
    10da:	6109                	addi	sp,sp,128
    10dc:	8082                	ret

00000000000010de <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    10de:	715d                	addi	sp,sp,-80
    10e0:	ec06                	sd	ra,24(sp)
    10e2:	e822                	sd	s0,16(sp)
    10e4:	1000                	addi	s0,sp,32
    10e6:	e010                	sd	a2,0(s0)
    10e8:	e414                	sd	a3,8(s0)
    10ea:	e818                	sd	a4,16(s0)
    10ec:	ec1c                	sd	a5,24(s0)
    10ee:	03043023          	sd	a6,32(s0)
    10f2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    10f6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    10fa:	8622                	mv	a2,s0
    10fc:	00000097          	auipc	ra,0x0
    1100:	e08080e7          	jalr	-504(ra) # f04 <vprintf>
}
    1104:	60e2                	ld	ra,24(sp)
    1106:	6442                	ld	s0,16(sp)
    1108:	6161                	addi	sp,sp,80
    110a:	8082                	ret

000000000000110c <printf>:

void
printf(const char *fmt, ...)
{
    110c:	711d                	addi	sp,sp,-96
    110e:	ec06                	sd	ra,24(sp)
    1110:	e822                	sd	s0,16(sp)
    1112:	1000                	addi	s0,sp,32
    1114:	e40c                	sd	a1,8(s0)
    1116:	e810                	sd	a2,16(s0)
    1118:	ec14                	sd	a3,24(s0)
    111a:	f018                	sd	a4,32(s0)
    111c:	f41c                	sd	a5,40(s0)
    111e:	03043823          	sd	a6,48(s0)
    1122:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1126:	00840613          	addi	a2,s0,8
    112a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    112e:	85aa                	mv	a1,a0
    1130:	4505                	li	a0,1
    1132:	00000097          	auipc	ra,0x0
    1136:	dd2080e7          	jalr	-558(ra) # f04 <vprintf>
}
    113a:	60e2                	ld	ra,24(sp)
    113c:	6442                	ld	s0,16(sp)
    113e:	6125                	addi	sp,sp,96
    1140:	8082                	ret

0000000000001142 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1142:	1141                	addi	sp,sp,-16
    1144:	e422                	sd	s0,8(sp)
    1146:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1148:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    114c:	00001797          	auipc	a5,0x1
    1150:	bfc78793          	addi	a5,a5,-1028 # 1d48 <freep>
    1154:	639c                	ld	a5,0(a5)
    1156:	a805                	j	1186 <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1158:	4618                	lw	a4,8(a2)
    115a:	9db9                	addw	a1,a1,a4
    115c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1160:	6398                	ld	a4,0(a5)
    1162:	6318                	ld	a4,0(a4)
    1164:	fee53823          	sd	a4,-16(a0)
    1168:	a091                	j	11ac <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    116a:	ff852703          	lw	a4,-8(a0)
    116e:	9e39                	addw	a2,a2,a4
    1170:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    1172:	ff053703          	ld	a4,-16(a0)
    1176:	e398                	sd	a4,0(a5)
    1178:	a099                	j	11be <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    117a:	6398                	ld	a4,0(a5)
    117c:	00e7e463          	bltu	a5,a4,1184 <free+0x42>
    1180:	00e6ea63          	bltu	a3,a4,1194 <free+0x52>
{
    1184:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1186:	fed7fae3          	bleu	a3,a5,117a <free+0x38>
    118a:	6398                	ld	a4,0(a5)
    118c:	00e6e463          	bltu	a3,a4,1194 <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1190:	fee7eae3          	bltu	a5,a4,1184 <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
    1194:	ff852583          	lw	a1,-8(a0)
    1198:	6390                	ld	a2,0(a5)
    119a:	02059713          	slli	a4,a1,0x20
    119e:	9301                	srli	a4,a4,0x20
    11a0:	0712                	slli	a4,a4,0x4
    11a2:	9736                	add	a4,a4,a3
    11a4:	fae60ae3          	beq	a2,a4,1158 <free+0x16>
    bp->s.ptr = p->s.ptr;
    11a8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    11ac:	4790                	lw	a2,8(a5)
    11ae:	02061713          	slli	a4,a2,0x20
    11b2:	9301                	srli	a4,a4,0x20
    11b4:	0712                	slli	a4,a4,0x4
    11b6:	973e                	add	a4,a4,a5
    11b8:	fae689e3          	beq	a3,a4,116a <free+0x28>
  } else
    p->s.ptr = bp;
    11bc:	e394                	sd	a3,0(a5)
  freep = p;
    11be:	00001717          	auipc	a4,0x1
    11c2:	b8f73523          	sd	a5,-1142(a4) # 1d48 <freep>
}
    11c6:	6422                	ld	s0,8(sp)
    11c8:	0141                	addi	sp,sp,16
    11ca:	8082                	ret

00000000000011cc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    11cc:	7139                	addi	sp,sp,-64
    11ce:	fc06                	sd	ra,56(sp)
    11d0:	f822                	sd	s0,48(sp)
    11d2:	f426                	sd	s1,40(sp)
    11d4:	f04a                	sd	s2,32(sp)
    11d6:	ec4e                	sd	s3,24(sp)
    11d8:	e852                	sd	s4,16(sp)
    11da:	e456                	sd	s5,8(sp)
    11dc:	e05a                	sd	s6,0(sp)
    11de:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    11e0:	02051993          	slli	s3,a0,0x20
    11e4:	0209d993          	srli	s3,s3,0x20
    11e8:	09bd                	addi	s3,s3,15
    11ea:	0049d993          	srli	s3,s3,0x4
    11ee:	2985                	addiw	s3,s3,1
    11f0:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
    11f4:	00001797          	auipc	a5,0x1
    11f8:	b5478793          	addi	a5,a5,-1196 # 1d48 <freep>
    11fc:	6388                	ld	a0,0(a5)
    11fe:	c515                	beqz	a0,122a <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1200:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1202:	4798                	lw	a4,8(a5)
    1204:	03277f63          	bleu	s2,a4,1242 <malloc+0x76>
    1208:	8a4e                	mv	s4,s3
    120a:	0009871b          	sext.w	a4,s3
    120e:	6685                	lui	a3,0x1
    1210:	00d77363          	bleu	a3,a4,1216 <malloc+0x4a>
    1214:	6a05                	lui	s4,0x1
    1216:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
    121a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    121e:	00001497          	auipc	s1,0x1
    1222:	b2a48493          	addi	s1,s1,-1238 # 1d48 <freep>
  if(p == (char*)-1)
    1226:	5b7d                	li	s6,-1
    1228:	a885                	j	1298 <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
    122a:	00001797          	auipc	a5,0x1
    122e:	b2678793          	addi	a5,a5,-1242 # 1d50 <base>
    1232:	00001717          	auipc	a4,0x1
    1236:	b0f73b23          	sd	a5,-1258(a4) # 1d48 <freep>
    123a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    123c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1240:	b7e1                	j	1208 <malloc+0x3c>
      if(p->s.size == nunits)
    1242:	02e90b63          	beq	s2,a4,1278 <malloc+0xac>
        p->s.size -= nunits;
    1246:	4137073b          	subw	a4,a4,s3
    124a:	c798                	sw	a4,8(a5)
        p += p->s.size;
    124c:	1702                	slli	a4,a4,0x20
    124e:	9301                	srli	a4,a4,0x20
    1250:	0712                	slli	a4,a4,0x4
    1252:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1254:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1258:	00001717          	auipc	a4,0x1
    125c:	aea73823          	sd	a0,-1296(a4) # 1d48 <freep>
      return (void*)(p + 1);
    1260:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1264:	70e2                	ld	ra,56(sp)
    1266:	7442                	ld	s0,48(sp)
    1268:	74a2                	ld	s1,40(sp)
    126a:	7902                	ld	s2,32(sp)
    126c:	69e2                	ld	s3,24(sp)
    126e:	6a42                	ld	s4,16(sp)
    1270:	6aa2                	ld	s5,8(sp)
    1272:	6b02                	ld	s6,0(sp)
    1274:	6121                	addi	sp,sp,64
    1276:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    1278:	6398                	ld	a4,0(a5)
    127a:	e118                	sd	a4,0(a0)
    127c:	bff1                	j	1258 <malloc+0x8c>
  hp->s.size = nu;
    127e:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
    1282:	0541                	addi	a0,a0,16
    1284:	00000097          	auipc	ra,0x0
    1288:	ebe080e7          	jalr	-322(ra) # 1142 <free>
  return freep;
    128c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    128e:	d979                	beqz	a0,1264 <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1290:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1292:	4798                	lw	a4,8(a5)
    1294:	fb2777e3          	bleu	s2,a4,1242 <malloc+0x76>
    if(p == freep)
    1298:	6098                	ld	a4,0(s1)
    129a:	853e                	mv	a0,a5
    129c:	fef71ae3          	bne	a4,a5,1290 <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
    12a0:	8552                	mv	a0,s4
    12a2:	00000097          	auipc	ra,0x0
    12a6:	b72080e7          	jalr	-1166(ra) # e14 <sbrk>
  if(p == (char*)-1)
    12aa:	fd651ae3          	bne	a0,s6,127e <malloc+0xb2>
        return 0;
    12ae:	4501                	li	a0,0
    12b0:	bf55                	j	1264 <malloc+0x98>
