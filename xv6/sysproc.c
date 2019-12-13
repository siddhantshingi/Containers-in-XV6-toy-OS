#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
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

int
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

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int 
sys_halt(void)
{
  halt();
  cprintf("Command for shutdown\n");
  return 0;
}

int
sys_toggle(void)
{
  // cprintf("in sys_toggle\n");
  toggle();
  return 0;
}

int
sys_print_count(void)
{
  // cprintf("in sys_print_count\n");
  print_count();
  return 0;
}

int 
sys_ps(void)
{
  ps();
  return 0;
}

int 
sys_send(void)
{
  int a,b;
  char* msg;
  if(argint(0, &a) < 0)
    return -1;
  if(argint(1, &b) < 0)
    return -1;
  if(argptr(2, &msg, MSGSIZE) < 0)
    return -1;
  send(a,b,msg);
  return 0;
}

int 
sys_recv(void)
{
  char* msg;
  if(argptr(0, &msg, MSGSIZE) < 0)
    return -1;
  // int ret = recv(msg);
  // cprintf("msg in sysproc: %s\n",msg);
  // cprintf("ret value: %d\n",ret);

  return recv(msg);
  
}

int 
sys_send_multi(void)
{
  // cprintf("in sysproc");

  int a,len,b;
  char* msg;
  if(argint(0, &a) < 0)
    return -1;
  if(argint(3, &len) < 0)
    return -1;
  if(argptr(2, &msg, MSGSIZE) < 0)
    return -1;
  if(argint(1, &b) < 0)
    return -1;
  // cprintf("len in sysproc: %d\n",len);
  // cprintf("printing the array in sysproc: \n");
  int* d;
  d = (int*)b;
  int arr[len];
  for(int i=0;i<len;i++)
  {
    arr[i] = *d;
    // cprintf("%d\n",arr[i]);
    d++;
  }
  send_multi(a,arr,msg,len);
  return 0;
}

int 
sys_store(void)
{
  int a,b;
  if(argint(0, &a) < 0)
    return -1;
  if(argint(1, &b) < 0)
    return -1;
  store(a,b);
  return 0;
}

int 
sys_sleepcustom(void)
{
  int a;
  if(argint(0, &a) < 0)
    return -1;
  sleepcustom(a);
  return 0;
}

int 
sys_wakeupcustom(void)
{
  int a;
  if(argint(0, &a) < 0)
    return -1;
  wakeupcustom(a);
  return 0;
}


int 
sys_read_mean(void)
{
  char* msg;
  if(argptr(0, &msg, MSGSIZE) < 0)
    return -1;
  return read_mean(msg);
  
}

int 
sys_create_container(void)
{
  return create_container();
  
}

int 
sys_destroy_container(void)
{
  int a;
  if(argint(0, &a) < 0)
    return -1;
  return destroy_container(a);
  
}

int 
sys_join_container(void)
{
  int a;
  if(argint(0, &a) < 0)
    return -1;
  return join_container(a);
  
}

int 
sys_leave_container(void)
{
  return leave_container();
  
}

int
sys_container_malloc(void)
{
  int a;
  if(argint(0, &a) < 0)
    return -1;
  cprintf("malloc\n");
  return container_malloc(a);
  
}
