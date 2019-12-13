#include "types.h"
#include "defs.h"
#include "param.h"
#include "fs.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "file.h"

void signal(int* arg, void (*handler)(int,int,int))
{
	int brother_pid = getpid();
	int cid = fork();
	if (cid == 0)
	{
		int pid = getpid();
		store(brother_pid,pid);
		while(true)
		{
			sleepcustom(pid);
			handler(arg[0],arg[1],arg[2]);
			wakeupcustom(brother_pid);
		}
	}
}

void raise(int num)
{
	int pid = getpid();
	int servent_pid = getserpid();
	wakeupcustom(servent_pid);
	sleepcustom(pid);
}