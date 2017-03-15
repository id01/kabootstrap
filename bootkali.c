#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void cleanupxhost() { system("/usr/bin/xhost -local:"); }

// Do not compile this outside of the installkalichroot.sh script. It won't work.
// Nifty little binary that doesn't need changes to sudo :D
int main()
{
	// Verify that user either root or kali
	int myuid = getuid();
	if (myuid == kaliuid || myuid == 0) { setuid(0); } else { puts("Permission denied."); return 1; }
	puts("Entering Kali chroot...");
	// Allow xhost connection from anyone
	if (usesxhost == 1) { system("/usr/bin/xhost +local:"); atexit(cleanupxhost); }
	// Run chroot, wait for exit
	system(chrootcommand);
	puts("Exitted Kali chroot.");
	// Exit
	exit(EXIT_SUCCESS);
}
