#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>

int main(void) {
    pid_t rc = fork();
    if (rc < 0) { perror("fork"); return 1; }
    printf("[pid=%d ppid=%d] fork() returned %d\n",
           (int)getpid(), (int)getppid(), (int)rc);
    return 0;
}
