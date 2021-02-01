#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

  unsigned char c;
void
main ()
{
  int fd;

  fd = open ("/dev/ttyUSB2", O_RDWR);

  if (fd)
    {
      while (1)
	{
	  if(!read (fd, &c, 1))
	{
		printf("Read error\n");
	}
//	  printf ("%02x ", c);
	  write (fd, &c, 1);
	}
    }
}
