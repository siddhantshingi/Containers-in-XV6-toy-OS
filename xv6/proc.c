#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
// #include "user.h"

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

int trace = 0;
int num_syscall = 33;
int counter[33] = {0};
char syscall_arr[33][30] = {
      "sys_fork",
      "sys_exit",
      "sys_wait",
      "sys_pipe",
      "sys_read",
      "sys_kill",
      "sys_exec",
      "sys_fstat",
      "sys_chdir",
      "sys_dup",
      "sys_getpid",
      "sys_sbrk",
      "sys_sleep",
      "sys_uptime",
      "sys_open",
      "sys_write",
      "sys_mknod",
      "sys_unlink",
      "sys_link",
      "sys_mkdir",
      "sys_close",
      "sys_halt",
      "sys_toggle",
      "sys_print_count",
      "sys_ps",
      "sys_send",
      "sys_recv",
      "sys_send_multi",
      "sys_create_container",
      "sys_destroy_container",
      "sys_join_container",
      "sys_leave_container",
      "sys_container_malloc"
      };

//changed
//{
//queue implemented
struct queue {
  struct spinlock lock;
  int front;                   //front of the queue
  int rear;                    //rear of the queue
  int size;                    //current size
  unsigned capacity;           //max size
  char array[MSGBUFFSIZE][8];                //array of data in queue
};

struct map_store{
  struct spinlock lock;
  int b;
  int s;
};


int isEmpty(struct queue* q) 
{  return (q->size == 0); } 

void print_queue(struct queue* q) 
{  
  for(int i=q->front+1;i<=q->rear;i++)
  {
    cprintf("   queue element: %d\n", *(int*)q->array[i] );
  } 
} 

int enqueue(struct queue* q, char* item) 
{ 
    if (q->size == MSGBUFFSIZE) 
      return -1; 
    // char* m = (char*)item;
    q->rear = (q->rear + 1)%MSGBUFFSIZE; 
    for(int i=0;i<8;i++)
    {
      q->array[q->rear][i] = *item; 
      item++;
    }
    q->size = q->size + 1; 
    return 0; 
} 

int dequeue(struct queue* q) 
{ 
    if (isEmpty(q)) 
        return -1; 
    q->front = (q->front + 1)%MSGBUFFSIZE; 
    q->size = q->size - 1; 
    return 0; 
} 

char* rear(struct queue* q) 
{ 
    // if (isEmpty(q)) 
    //     return -1; 
    return q->array[q->rear]; 
}

char* front(struct queue* q) 
{ 
    // if (isEmpty(q)) 
    //     return -1; 
    return q->array[q->front+1]; 
} 

typedef int msgbuffer[MSGSIZE];
msgbuffer msg_buf[MSGBUFFSIZE];
struct queue msg_queue[NPROC];
char* wait_array[NPROC];
// int wait_try;
struct map_store map[NPROC];
int map_len = 0;
char mean_buffer[8];

struct container container_table[NCONTAINER];
int c_active[NCONTAINER] = {0};
int c_pointer = 0;

//}

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  p->container_id = -1;
  
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    // cprintf("---------------\n");
    release(&ptable.lock);

  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

void
halt(void)
{
  cprintf("in halt functions: ");

}

int
toggle(void)
{
  if (trace == 0)
    trace = 1;
  else
  {
    trace = 0;
    for(int i=0;i<num_syscall;i++)
      counter[i] = 0;
  }
  // cprintf("trace = %d\n",trace);
  return 0;
}

int 
print_count(void)
{
  for(int i=0;i<num_syscall;i++)
  {
    if (counter[i]!=0)
      cprintf("%s %d\n", syscall_arr[i], counter[i]);
  }
  // cprintf("print_count completed\n");
  return 0;
}

int
ps(void)
{
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state != UNUSED)
    {
      char m[16] = "0";
      if (p->state == RUNNING)
        safestrcpy(m, "RUNNING", sizeof(m));
      else if (p->state == RUNNABLE)
        safestrcpy(m, "RUNNABLE", sizeof(m));
      else if (p->state == SLEEPING)
        safestrcpy(m, "SLEEPING", sizeof(m));
      // cprintf("pid:%d name:%s state:%s\n",p->pid,p->name,m);
      cprintf("pid:%d name:%s \n",p->pid,p->name);
      // for(int i=0;i<NCONTAINER;i++)
      // {
      //   for(int j=0;j<NPROC_CONTAINER;j++)
      //   {
      //     if (container_table[i].process_active[j] == 1 && container_table[i].process_table[j].pid == p->pid)
      //       cprintf("belongs to a container\n");
      //   }
      // }
    }
  return 0;
}

int
send(int send_pid, int rec_pid, char* msg)
{
  struct proc *p = &ptable.proc[rec_pid-1];
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->pid == rec_pid)
      break;
  
  if (p->state == SLEEPING)
  {
    wakeup(p);

    acquire(&msg_queue[p->pid-1].lock);

    char in_msg[8];
    for(int i=0;i<8;i++)
    {
      in_msg[i] = *msg;
      msg++;
    }
    if (enqueue(&msg_queue[p->pid-1], in_msg) < 0)
      return -1;
    
    
    release(&msg_queue[p->pid-1].lock);
    
  }
  else 
  {
    acquire(&msg_queue[p->pid-1].lock);

    char in_msg[8];
    for(int i=0;i<8;i++)
    {
      in_msg[i] = *msg;
      msg++;
    }
    if (enqueue(&msg_queue[p->pid-1], in_msg) < 0)
    {
      return -1;
    }

    
    release(&msg_queue[p->pid-1].lock);

  }

  
  return 0;
}

int
recv(char* msg)
{
  struct proc *curproc = myproc();
  int rec_pid = curproc->pid;
  
  if (msg_queue[rec_pid-1].size == 0)
  {
    
    acquire(&ptable.lock);
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
    release(&ptable.lock);

  } 
  char* m = front(&msg_queue[rec_pid-1]);
  
  acquire(&msg_queue[rec_pid-1].lock);

  if (dequeue(&msg_queue[rec_pid-1]) < 0)
    return -1;
  
  strncpy(msg,m,8);
  
  release(&msg_queue[rec_pid-1].lock);

  
  return 0;
}

int
send_multi(int send_pid, int* rec_pid, char* msg, int len)
{
  // char* input_msg = (char*)msg;
  // void* in_msg = (void*)input_msg;
  // cprintf("in send_multi function\n");
  // cprintf("msg: %s\n",input_msg);
  // cprintf("send pid: %d\n",send_pid);
  // cprintf("len: %d\n",len);

  for(int i=0;i<8;i++)
  {
    mean_buffer[i] = *msg;
    msg++;
  }
  msg = msg - 8;
  // cprintf("mean_buffer: %s\n",mean_buffer);
  // cprintf("msg: %s\n",msg);

  // cprintf("rec_pid: \n");
  for(int i=0;i<len;i++)
  {
    // cprintf("%d   ",rec_pid[i]);
    for(int j=0;j<map_len;j++)
    {
      if (map[j].b == rec_pid[i])
      {
        // cprintf("wakeup %d\n",map[j].s);
        wakeupcustom(map[j].s);
        break;
      }
    }
  }
  // cprintf("ending send_multi\n");
  return 0;
}

int
store(int brother_pid, int sister_pid)
{
  // cprintf("in store function\n");
  // cprintf("brother pid: %d\n",brother_pid);
  // cprintf("sister pid: %d\n",sister_pid);
  map[map_len].b = brother_pid;
  map[map_len].s = sister_pid;
  map_len++;
  return 0;
}

int
sleepcustom(int p_pid)
{
  // cprintf("in sleepcustom function\n");
  // cprintf("pid: %d\n",p_pid);
  
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->pid == p_pid)
      break;

  acquire(&ptable.lock);
  sleep(p, &ptable.lock);  //DOC: wait-sleep
  release(&ptable.lock);
  return 0;
}

int
wakeupcustom(int p_pid)
{
  // cprintf("in wakeupcustom function\n");
  // cprintf("pid: %d\n",p_pid);
  
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->pid == p_pid)
      break;

  wakeup1(p);

  return 0;
}

int
read_mean(char* mean)
{
  // cprintf("in read_mean function\n");
  for(int i=0;i<8;i++)
  {
    *mean = mean_buffer[i];
    mean++;
  }
  mean = mean - 8;
  // cprintf("mean in proc: %s\n",mean);
  return 0;
}

struct proc 
get_proc(int pid)
{
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->pid == pid)
      break;
  return (*p);
}

void init_container(struct container* c, int t_id)
{
  (*c).id = t_id;
  (*c).active = 1;
  for(int i=0;i<NPROC_CONTAINER;i++)
    (*c).process_active[i] = 0;
  for(int i=0;i<MAX_PAGES;i++)
    (*c).page_active[i] = 0;
  for(int i=0;i<MAX_FILES;i++)
    (*c).file_active[i] = 0;
  (*c).process_pointer = 0;  
  (*c).page_pointer = 0;  
  (*c).file_pointer = 0;  
}

void print_c_table()
{
  cprintf("conatiner_table:\n");
  for (int i=0;i<NCONTAINER;i++)
  {
    cprintf("id: %d active: %d\n",container_table[i].id,c_active[i]);
    for (int j=0;j<NPROC_CONTAINER;j++)
      cprintf("\t process_id: %d active bit: %d state: %d c_id: %d\n",container_table[i].process_table[j].pid,
          container_table[i].process_active[j],container_table[i].process_table[j].state,
          container_table[i].process_table[j].container_id);
  }
}

int
create_container()
{
  cprintf("in create_container\n");
  //when the container table is full
  if (c_pointer == -1)
  {
    cprintf("container_table full\n");
    return -1;
  }
  c_active[c_pointer] = 1;
  struct container c;
  init_container(&c,c_pointer);
  container_table[c_pointer] = c;
  int output = c_pointer;
  
  print_c_table();
   
  //update the c_pointer
  for (int i=c_pointer+1;i<NCONTAINER;i++)
    if (c_active[i] == 0)
    {
      c_pointer = i;
      return output;
    }
  for (int i=0;i<c_pointer;i++)
    if (c_active[i] == 0)
    {
      c_pointer = i;
      return output;
    }
  c_pointer = -1;
  return output;
}

int
destroy_container(int id)
{
  cprintf("in destroy_container\n");
  if (id < 0 || id >= NCONTAINER)
    return -1;
  if (c_active[id] == 0)
    return -1;
  c_active[id] = 0;
  if (c_pointer == -1)
    c_pointer = id;
  
  print_c_table();

  return 0;
}

int
join_container(int id)
{
  cprintf("in join_container\n");
  if (id < 0 || id >= NCONTAINER || c_active[id] == 0)
    return -1;
  int pointer = container_table[id].process_pointer;
  if (pointer == -1)
    return -1;
  
  struct proc p = *myproc();
  //**imp**(not implemented):check if the process is already in a container 
  p.container_id = c_pointer;
  p.cont = &container_table[id];
  // if (sleepcustom(p.pid) == -1)
    // return -1;
  container_table[id].process_table[pointer] = p;
  container_table[id].process_active[pointer] = 1;

  print_c_table();

  
  //update the c_pointer
  for (int i=c_pointer+1;i<NPROC_CONTAINER;i++)
    if (container_table[id].process_active[i] == 0)
    {
      container_table[id].process_pointer = i;
      return 0;
    }
  for (int i=0;i<c_pointer;i++)
    if (container_table[id].process_active[i] == 0)
    {
      container_table[id].process_pointer = i;
      return 0;
    }
  container_table[id].process_pointer = -1;
  return 0;
}

int
leave_container()
{
  cprintf("in leave_container\n");
  struct proc p = *myproc();
  int id = p.container_id;
  p.container_id = -1;
  if (id < 0 || id >= NCONTAINER || c_active[id] == 0)
    return -1;
  for (int i=0;i<NPROC_CONTAINER;i++)
    if (container_table[id].process_table[i].pid == p.pid && container_table[id].process_active[i] == 1)
    {
      container_table[id].process_active[i] = 0;
      break;
    }
  print_c_table();
  
  return 0;  
}


int
container_malloc(int s)
{
  cprintf("in container_malloc\n");
  int* t = (int*)kvmalloc(sizeof(int));
  cprintf("pri %u\n",t);
  return 0;
}