#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>

int main() {
	pid_t pid = fork();
	if (pid > 0) {
		sleep(30); // parent does not wait
	} else if (pid == 0) {
		exit(0); // child exits immediately
	}
	return 0;
}
