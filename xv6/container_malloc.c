#include "types.h"
#include "user.h"

int main ( int argc , char * argv [])
{
  
  //int->1,char->2,flaot->3 etc
  int err = 0;
  int b = container_malloc(1);
  printf(1,"pointer is: %d and error: %d\n",b,err);
  exit();
}
