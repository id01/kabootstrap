#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

// Do not compile this outside of the installkalichroot.sh script. It won't work.
// Nifty little binary that doesn't need changes to sudo :D
int main()
{
	int myuid = getuid();
	if (myuid == kaliuid || myuid == 0) { setuid(0); } else { puts("Permission denied."); return 1; }
	puts("Entering kali chroot...");
	int result = system(chrootcommand);
	puts("Kali chroot terminated.");
	return result;
}