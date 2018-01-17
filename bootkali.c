#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define NEWXAUTH "/root/.Xauthority"

// Do not compile this outside of the installkalichroot.sh script. It won't work.
// Note that NEWXAUTH and $XAUTHORITY must be on the same filesystem.
// Nifty little binary that doesn't need changes to sudo :D
int main()
{
	// Verify that user either root or kali
	int myuid = getuid();
	if (myuid == kaliuid || myuid == 0) { setuid(0); } else { puts("Permission denied."); return 1; }
#ifdef USESXAUTH
	// Hard link .Xauthority to chroot and set $XAUTHORITY in chroot
	link(getenv("XAUTHORITY"), CHROOTPATH NEWXAUTH);
	setenv("XAUTHORITY", NEWXAUTH, 1);
#endif
	// Run chroot
	if (chroot(CHROOTPATH) != 0) { puts("Chroot Failed."); return 1; }
	chdir("/");
	// Switch to bash in chroot
	execl("/bin/bash", "/bin/bash", NULL);
}
