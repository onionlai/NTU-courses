#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "stat.h"
#include "sleeplock.h"
#include "fs.h"
#include "fcntl.h"
#include "file.h"

uint64
sys_exit(void)
{
  int n;
  if(argint(0, &n) < 0)
    return -1;
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  if(argaddr(0, &p) < 0)
    return -1;
  return wait(p);
}

uint64
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

// struct vma* allocvma1(){
//   struct proc *p = myproc();
//   vmprint(p->pagetable);
//   for(int i = 0; i < 16; i++){
//     printf("vmal[] is at %p\n", &p->vmal[i]);

//     if(p->vmal[i].used == 0){ // can take this
//       return &p->vmal[i];
//     }
//   }
//   printf("Wrong\n\n");
//   return 0;
// }

uint64
sys_mmap(void)
{
  uint64 addr;
  int length, prot, flags, fd, offset;
  /////////////// check arguments /////////////////
  if(argaddr(0, &addr) < 0 || argint(1, &length) < 0 || argint(2, &prot) < 0 || argint(3, &flags) < 0 || argint(4, &fd) < 0 || argint(5, &offset) < 0){
    return -1;
  }
  // printf("system call mmap(%p, %d, %d, %d, %d, %d)\n", addr, length, prot, flags, fd, offset);

  if(addr != 0 || offset != 0){
    return -1;
  } // due to mp2 requirement

  struct proc *p = myproc();
  struct file *f = p->ofile[fd];

  if((prot & PROT_READ) && !(f->readable)){
    return -1;
  }
  if(((prot & PROT_WRITE) && (flags == MAP_SHARED))  && !(f->writable)){
    return -1;
  }
  ////////////////// create vma ////////////////////
  struct vma* new_vma = allocvma();
  new_vma->length = length;
  new_vma->offset = offset;
  new_vma->flags = flags;
  new_vma->prot = prot;
  new_vma->file = filedup(f);
  new_vma->alloc_start = 0;
  new_vma->alloc_end = 0;
  new_vma->alloc_length = 0;
  new_vma->used = 1;

  struct vma* p_vma = p->vma;
  if (p_vma == 0){ // the first vma in the process
    new_vma->start = (MAXVA/2);
    new_vma->end = new_vma->start + length;
    new_vma->next = 0;
    p->vma = new_vma;
  }
  else{
    while(p_vma->next){ // find end-node in vma linked list
      p_vma = p_vma->next;
    }
    new_vma->start = PGROUNDUP(p_vma->end);
    new_vma->end = new_vma->start + length;
    new_vma->next = 0;
    p_vma->next = new_vma;
  }
  addr = new_vma->start;
  return addr;
}

uint64
sys_munmap(void)
{
  uint64 addr;
  int length;
  ////////////// check arguments////////////////
  if(argaddr(0, &addr) < 0 || argint(1, &length) < 0){
    return -1;
  }
  // printf("syscall sys_munmap(%p, %d)\n", addr, length);

  struct proc *p = myproc();
  struct vma *p_vma = p->vma;
  struct vma *pre_vma = 0;
  while(p_vma){
    if( p_vma->start <= addr && addr < p_vma->end){
      break;
    }
    pre_vma = p_vma;
    p_vma = p_vma->next;
  }
  if(p_vma == 0){
    return -1;
  }

  // assumption: munmap()不會發生在vma中間。要麻vma前段 要麻vma後段
  if(!(addr == p_vma->start) && !((addr + length) == p_vma->end)){
    return -1;
  }

  ///////////// write if MAP_SHARED and allocated ///////////////
  ////////// uvmunmap() physical memory if allocated ///////////
  if(p_vma->alloc_length != 0){

    uint64 free_start = p_vma->alloc_start;
    uint64 free_end = p_vma->alloc_end;
    if(addr > free_start){
      free_start = addr;
      p_vma->alloc_end = addr;
    }
    if((addr + length) < free_end){
      free_end = addr + length;
      p_vma->alloc_start = addr + length;
    }

    // write to the disk if flags == MAP_SHARED
    if(p_vma->flags & MAP_SHARED){
      struct file *f = p_vma->file;
      filewrite(f, free_start, free_end-free_start);
    }

    // uvmunmap
    //printf("now uvmunmap from %p to %p\n\n", free_start, free_end);
    uvmunmap(p->pagetable, free_start, (free_end-free_start)/PGSIZE, 1);
    p_vma->alloc_length -= (free_end-free_start);
  }

  ///////////////// update vma or clean it ///////////////////
  if(addr == p_vma->start){
    if(length == p_vma->length){ // unmap the whole length of vma -> freevma(), update list
      if(pre_vma == 0){
        p->vma = p_vma->next;
      }
      else{
        pre_vma->next = p_vma->next;
      }
      freevma(p_vma);
    }
    else{ // unmap the section of the front
      p_vma->start += length;
      p_vma->length -= length;
    }

  }
  else{ // unmap the section of the back
    p_vma->end -= length;
    p_vma->length -= length;
  }

  return 0;
}