#include <stdio.h>
#include <stdlib.h>

void
SetUp ()
{
}

unsigned char x;
unsigned char c;
int i, j;

void
TestWrite (char *buf)
{
  while (1)
    {
      if (bdos (CPM_ICON, 0))
	exit (0);
      if ((inp (0xab) & 1) == 0)
	{
	  outp (0xaa, *buf++);
	  if (*buf == 0)
	    return;
	}
    }
}

unsigned char c;
void
RunLoop ()
{
  while (1)
    {
      if (bdos (CPM_ICON, 0))
	exit (0);
      if ((inp (0XAB) & 1) == 0)
	TestWrite
	  ("Now is the time for all good mem to come to the aid of there country. 1 2 3 4 5 6 7 8 9 0\n");
      if ((inp (0xab) & 2) != 2)
	{
	  while ((inp (0xab) & 2) != 2)
	    {
	      printf ("%c", inp(0xaa));
	    }
	}
    }
}

void
main ()
{
  SetUp ();
  RunLoop ();
}
