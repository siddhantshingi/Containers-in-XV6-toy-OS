#include "types.h"
#include "user.h"

int main ( int argc , char * argv [])
{
  char *msg_child = (char *)malloc(8);
  msg_child = "R";
  recv(msg_child);
   
  // recv(argv[1]);
  exit();
}