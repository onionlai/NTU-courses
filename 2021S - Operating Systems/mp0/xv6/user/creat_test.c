#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
  mkdir("hello");
  open("onion", O_CREATE | O_RDWR);

  chdir("./hello");
  open("book", O_CREATE | O_RDWR);
  open("onion", O_CREATE | O_RDWR);
  mkdir("hi");
  mkdir("test");

  chdir("hi");
  open("book", O_CREATE | O_RDWR);
  open("hello", O_CREATE | O_RDWR);
  mkdir("test");
  mkdir("tree");

  chdir("../test");
  open("apple", O_CREATE | O_RDWR);
  mkdir("hello");
  chdir("hello");
  open("apple", O_CREATE | O_RDWR);
  mkdir("hello");
  chdir("hello");
  open("apple", O_CREATE | O_RDWR);
  mkdir("hello");
  chdir("hello");


  exit(0);
}
