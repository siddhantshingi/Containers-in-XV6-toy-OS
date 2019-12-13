#include "types.h"
#include "user.h"

int main ( int argc , char * argv [])
{
  int length = 2;
  int rec_arr[length];
  rec_arr[0] = atoi(argv[2]);
  rec_arr[1] = atoi(argv[3]);
  char *msg_child = (char *)malloc(8);
  msg_child = "S";
  send_multi(atoi(argv[1]),rec_arr,msg_child,length);
  exit();
}