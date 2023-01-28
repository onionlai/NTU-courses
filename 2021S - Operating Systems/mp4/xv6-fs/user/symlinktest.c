#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/riscv.h"
#include "kernel/fcntl.h"
#include "kernel/spinlock.h"
#include "kernel/sleeplock.h"
#include "kernel/fs.h"
#include "kernel/file.h"
#include "user/user.h"

#define fail(msg) do {printf("FAILURE: " msg "\n"); failed = 1; goto done;} while (0);
static int failed = 0;

static void testsymlink(void);
static void concur(void);
static void testsymlinkdir(void);
static void cleanup(void);

int
main(int argc, char *argv[])
{
  cleanup();
  testsymlink();
  testsymlinkdir();
  concur();
  exit(failed);
}

static void
cleanup(void)
{
  unlink("/testsymlink/a");
  unlink("/testsymlink/b");
  unlink("/testsymlink/c");
  unlink("/testsymlink/1");
  unlink("/testsymlink/2");
  unlink("/testsymlink/3");
  unlink("/testsymlink/4");
  unlink("/testsymlink/z");
  unlink("/testsymlink/y");
  unlink("/testsymlink2/p");
  unlink("/testsymlink3/q");
  unlink("/testsymlink2");
  unlink("/testsymlink3");
  unlink("/testsymlink");
}

// stat a symbolic link using O_NOFOLLOW
static int
stat_slink(char *pn, struct stat *st)
{

  int fd = open(pn, O_RDONLY | O_NOFOLLOW); // at most time return -1, why?
  //printf("opened.\n");

  if(fd < 0)
    return -1;
  if(fstat(fd, st) != 0)
    return -1;
  close(fd);
  return 0;
}

static void
testsymlink(void)
{
  int r, fd1 = -1, fd2 = -1;
  char buf[4] = {'a', 'b', 'c', 'd'};
  char c = 0, c2 = 0;
  struct stat st;

  printf("Start: test symlinks\n");

  mkdir("/testsymlink");


  fd1 = open("/testsymlink/a", O_CREATE | O_RDWR);
  if(fd1 < 0) fail("failed to open a");
  printf("-- opened a\n");

  r = symlink("/testsymlink/a", "/testsymlink/b");
  if(r < 0)
    fail("symlink b -> a failed");
  printf("-- symlink b -> a\n");

  if(write(fd1, buf, sizeof(buf)) != 4)
    fail("failed to write to a");
  printf("-- write \"abcd\" to a\n");

  if (stat_slink("/testsymlink/b", &st) != 0)
    fail("failed to stat b");
  printf("-- state b\n");

  if(st.type != T_SYMLINK)
    fail("b isn't a symlink");
  printf("-- b is a symlink\n");

  fd2 = open("/testsymlink/b", O_RDWR); //fd2 會是 "/testsymlink/a"
  if(fd2 < 0)
    fail("failed to open b");
  printf("-- opened b (which should be fd of a ?)\n");
  read(fd2, &c, 1);// read(fd2)會讀到 "/testsymlink/a" 裡面的 "abcd"
  if (c != 'a')
    fail("failed to read bytes from b");
  printf("-- yes it is~\n");

  unlink("/testsymlink/a");
  if(open("/testsymlink/b", O_RDWR) >= 0)
    fail("Should not be able to open b after deleting a");
  printf("-- after delete a, unavalible to open b now~\n");

  r = symlink("/testsymlink/b", "/testsymlink/a");
  if(r < 0)
    fail("symlink a -> b failed");
  printf("-- symlink a->b\n");

  r = open("/testsymlink/b", O_RDWR);
  if(r >= 0)
    fail("Should not be able to open b (cycle b->a->b->..)\n");
  printf("-- open b fail (because cycle b->a->b->..)\n");

  r = symlink("/testsymlink/nonexistent", "/testsymlink/c");
  if(r != 0)
    fail("Symlinking to nonexistent file should succeed\n");
  printf("-- symlink c->nonexistent fail (because not exist)~\n");

  r = symlink("/testsymlink/2", "/testsymlink/1");
  if(r) fail("Failed to link 1->2");
  printf("-- symlink 1->2\n");
  r = symlink("/testsymlink/3", "/testsymlink/2");
  if(r) fail("Failed to link 2->3");
  printf("-- symlink 2->3\n");
  r = symlink("/testsymlink/4", "/testsymlink/3");
  if(r) fail("Failed to link 3->4");
  printf("-- symlink 3->4\n");

  close(fd1);
  close(fd2);

  fd1 = open("/testsymlink/4", O_CREATE | O_RDWR);
  if(fd1<0) fail("Failed to create 4\n");
  printf("-- create 4\n");

  fd2 = open("/testsymlink/1", O_RDWR);
  if(fd2<0) fail("Failed to open 1\n");
  printf("-- open 1\n");

  c = '#';
  r = write(fd2, &c, 1);
  if(r!=1) fail("Failed to write to 1\n");
  printf("-- write \"#\" to 1\n");

  r = read(fd1, &c2, 1);
  if(r!=1) fail("Failed to read from 4\n");
  if(c!=c2)
    fail("Value read from 4 differed from value written to 1\n");
  printf("-- read \"#\" from 4, which is same from 1\n");

  printf("test symlinks: ok\n\n");
done:
  close(fd1);
  close(fd2);
}

static void
testsymlinkdir(void)
{
  int r, fd1 = -1, fd2 = -1;
  char c = 0, c2 = 0;

  printf("Start: test symlinks to directory\n");

  mkdir("/testsymlink2");
  mkdir("/testsymlink3");
  printf("-- create dir /testsymlink2 & /testsymlink3\n");

  fd1 = open("/testsymlink2/p", O_CREATE | O_RDWR);
  if(fd1 < 0) fail("failed to open p");
  printf("-- open /testsymlink2/p (fd1)\n");

  r = symlink("/testsymlink2", "/testsymlink3/q");
  if(r < 0)
    fail("symlink q -> p failed");
  printf("-- symlink /testsymlink3/q -> /testsymlink2\n");

  fd2 = open("/testsymlink3/q/p", O_RDWR);
  if(fd2<0) fail("Failed to open /testsymlink3/q/p\n");
  printf("-- open /testsymlink3/q/p (fd2)\n");

  c = '#';
  r = write(fd1, &c, 1);
  if(r!=1) fail("Failed to write to /testsymlink2/p\n");
  printf("-- write \"#\" to /testsymlink2/p (fd1)\n");
  r = read(fd2, &c2, 1);
  if(r!=1) fail("Failed to read from /testsymlink3/q/p\n");
  if(c!=c2)
    fail("Value read from /testsymlink2/p differed from value written to /testsymlink3/q/p\n");
  printf("-- read \"#\" from /testsymlink3/q/p (fd2)\n");


  close(fd1);
  close(fd2);

  chdir("/testsymlink3/q");
  printf("-- chdir to /testsymlink3/q\n");
  fd1 = open("p", O_RDWR);
  r = read(fd1, &c2, 1);
  if(r!=1) fail("Failed to read from p in /testsymlink3/q\n");
  if(c!=c2)
    fail("Value read from p in /testsymlink3/q differed from value written to /testsymlink3/q/p\n");

  printf("-- read \"#\" from p in /testsymlink3/q/\n");
  close(fd1);

  printf("test symlinks to directory: ok\n");
done:
  close(fd1);
  close(fd2);//多的吧...
}

static void
concur(void)
{
  int pid, i;
  int fd;
  struct stat st;
  int nchild = 2;

  printf("Start: test concurrent symlinks\n");

  fd = open("/testsymlink/z", O_CREATE | O_RDWR);
  if(fd < 0) {
    printf("FAILED: open failed");
    exit(1);
  }
  close(fd);

  for(int j = 0; j < nchild; j++) {
    pid = fork();
    if(pid < 0){
      printf("FAILED: fork failed\n");
      exit(1);
    }
    if(pid == 0) {
      int m = 0;// 這要幹麻 沒懂
      unsigned int x = (pid ? 1 : 97);
      for(i = 0; i < 100; i++){
        x = x * 1103515245 + 12345;
        // printf("Child: %d, number %d\n", j, i);

        if((x % 3) == 0) {
          symlink("/testsymlink/z", "/testsymlink/y");
          if (stat_slink("/testsymlink/y", &st) == 0) {
            m++;
            if(st.type != T_SYMLINK) {
              printf("FAILED: not a symbolic link\n", st.type);
              exit(1);
            }
          }
        } else {
          unlink("/testsymlink/y");
        }
      }
      exit(0);
    }
  }

  int r;
  for(int j = 0; j < nchild; j++) {
    wait(&r);
    if(r != 0) {
      printf("test concurrent symlinks: failed\n");
      exit(1);
    }
  }
  printf("test concurrent symlinks: ok\n");
}
