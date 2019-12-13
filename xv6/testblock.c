#include "types.h"
#include "stat.h"
#include "user.h"
#define MSGSIZE 8
int main(void)
{
	printf(1,"%s\n","IPC Test case");
	
	int cid = fork();

	if(cid==0){
		// This is parent
		// wait();
		// for(int i=0;i<100000;i++)
		// {

		// }
		char *msg_child = (char *)malloc(MSGSIZE);
		msg_child = "POLLAND";
		send(getpid(),getpid()-1,msg_child);	
		printf(1,"getpid()=%d\n",getpid());
		printf(1,"cid=%d\n",cid);
		printf(1,"1 CHILD: msg sent is: %s \n", msg_child );
		
		free(msg_child);
		exit();
	}else{
		// This is child
		char *msg = (char *)malloc(MSGSIZE);
		int stat=-1;
		printf(1,"here\n");
		while(stat==-1){
			printf(1,"here3\n");
			stat = recv(msg);
			printf(1,"here4\n");
		}
		printf(1,"2 parent: msg recv is: %s \n", msg );
		wait();
		// stat=-1;
		// printf(1,"here 2\n");
		// while(stat==-1){
		// 	printf(1,"here5\n");
		// 	stat = recv(msg);
		// 	printf(1,"here6\n");
		// }
		// printf(1,"2 parent: msg recv is: %s \n", msg );
	}

	exit();
}



