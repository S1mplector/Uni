// processes.c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main(void) {
    int x = 100;
    printf("parent start:  x=%d at %p\n", x, (void*)&x);

    pid_t pid = fork();
    if (pid < 0) {
        perror("fork");
        return 1;
    }

    if (pid == 0) {
        // Child process
        x = 200;
        printf("child:        x=%d at %p\n", x, (void*)&x);
        _exit(0);
    } else {
        // Parent process
        // Wait for child so prints are orderly
        wait(NULL);
        printf("parent end:   x=%d at %p\n", x, (void*)&x);
    }
    return 0;
}
