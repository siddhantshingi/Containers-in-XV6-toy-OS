#include "types.h"
#include "user.h"

int main ( int argc , char * argv [])
{
  char *msg_child = (char *)malloc(8);
  msg_child = "S";
  send(atoi(argv[1]),atoi(argv[2]),msg_child);
  exit();
}