#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

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


// for mp3
uint64
sys_thrdstop(void)
{
  int interval, thrdstop_context_id;
  uint64 handler;
  if (argint(0, &interval) < 0)
    return -1;
  if (argint(1, &thrdstop_context_id) < 0)
    return -1;
  if (argaddr(2, &handler) < 0)
    return -1;

  intr_off();
  myproc()->thrdstop_interval = interval;
  myproc()->thrdstop_handler_pointer = handler;
  myproc()->thrdstop_ticks = 0;

  if(thrdstop_context_id == -1){
    for(int i = 0; i < MAX_THRD_NUM; i++){
      if(myproc()->thrdstop_context_used[i] == 0){
        myproc()->thrdstop_context_id = i;
        myproc()->thrdstop_context_used[i] = 1;
        intr_on();
        return i;
      }
    }
  }else{
    myproc()->thrdstop_context_id = thrdstop_context_id;
    myproc()->thrdstop_context_used[thrdstop_context_id] = 1;
    intr_on();
    return thrdstop_context_id;
  }

  return -1;
}

// for mp3
uint64
sys_cancelthrdstop(void)
{
  int thrdstop_context_id;
  if (argint(0, &thrdstop_context_id) < 0)
    return -1;

  if(thrdstop_context_id >= MAX_THRD_NUM)
    return -1;

  myproc()->thrdstop_interval = -1;

  if(thrdstop_context_id != -1){
    store_trapframe(&(myproc()->thrdstop_context[thrdstop_context_id]));
  }else{
    myproc()->thrdstop_context_used[myproc()->thrdstop_context_id] = 0;
  }

  return myproc()->thrdstop_ticks;
}

// for mp3
uint64
sys_thrdresume(void)
{
  int  thrdstop_context_id, is_exit;
  if (argint(0, &thrdstop_context_id) < 0)
    return -1;
  if (argint(1, &is_exit) < 0)
    return -1;

  if(is_exit == 0){ // jump back
    restore_trapframe(&(myproc()->thrdstop_context[thrdstop_context_id]));
    myproc()->thrdstop_context_used[thrdstop_context_id] = 0;
  }else{ // for thread exit
    myproc()->thrdstop_interval = -1;
    myproc()->thrdstop_context_used[thrdstop_context_id] = 0;
  }
  return 0;
}
