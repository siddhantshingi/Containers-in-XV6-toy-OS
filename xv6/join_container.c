#include "types.h"
#include "user.h"

int main ( int argc , char * argv [])
{
  join_container(atoi(argv[1]));
  ps();
  printf(1,"done\n");
  exit();
}
