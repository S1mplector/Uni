#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <stdlib.h>

int main(void) {

    /*
    If the formatting of the file is messed up,
    https://drive.google.com/file/d/1z5aWEYeh4cMAk3A-sjINvHhBzk950yzB/view?usp=sharing
    please download and check the file from here. 
    */

    printf("[ROOT] PID=%d PPID=%d\n", (int)getpid(), (int)getppid());

    //create 3 children of the root: c0, c1, c2
    pid_t c0 = fork();
    if (c0 < 0) {
        perror("fork c0"); //error with creating a child process
        exit(1);
    }

    if (c0 == 0) {
        //child c0: this is the only child of root that creates 3 children of its own
        printf("[CHILD c0] PID=%d PPID=%d\n", (int)getpid(), (int)getppid());

        //a0, a1, a2 are children of c0 (siblings)
        pid_t a0 = fork();
        if (a0 < 0) { perror("fork a0"); _exit(1); } //if the number returned is less than 0, it means there was an error
        if (a0 == 0) {

            //a0 will have 2 children of it's own (grandchildren)

            //first grandchild of a0 (g0)
            printf("[CHILD a0] PID=%d PPID=%d\n", (int)getpid(), (int)getppid());
            pid_t g0 = fork();
            if (g0 < 0) { perror("fork g0"); _exit(1); } //if the number returned is less than 0, it means there was an error
            if (g0 == 0) {
                printf("[GRANDCHILD g0] PID=%d PPID=%d\n", (int)getpid(), (int)getppid());
                _exit(0);
            }

            //second grandchild of a0 (g1)
            pid_t g1 = fork();
            if (g1 < 0) { perror("fork g1"); _exit(1); }
            if (g1 == 0) {
                printf("[GRANDCHILD g1] PID=%d PPID=%d\n", (int)getpid(), (int)getppid());
                _exit(0);
            }
            //wait for the 2 children of a0
            wait(NULL);
            wait(NULL);
            _exit(0);
        }

        pid_t a1 = fork();
        if (a1 < 0) { perror("fork a1"); _exit(1); } //error creating fork
        if (a1 == 0) {
            //a1 will have 1 child of it's own (grandchild)

            //first grandchild of a1 (g2)
            printf("[CHILD a1] PID=%d PPID=%d\n", (int)getpid(), (int)getppid());
            pid_t g2 = fork();
            if (g2 < 0) { perror("fork g2"); _exit(1); }
            if (g2 == 0) {
                printf("[GRANDCHILD g2] PID=%d PPID=%d\n", (int)getpid(), (int)getppid());
                _exit(0);
            }
            //wait for the 1 child of a1
            wait(NULL);
            _exit(0);
        }

        pid_t a2 = fork();
        if (a2 < 0) { perror("fork a2"); _exit(1); }
        if (a2 == 0) {
            //a2 will have NO children
            printf("[CHILD a2] PID=%d PPID=%d\n", (int)getpid(), (int)getppid());
            _exit(0);
        }

        //c0 waits for its 3 children: a0, a1, a2
        wait(NULL);
        wait(NULL);
        wait(NULL);
        _exit(0);
    }

    //only the root reaches here to create c1 and c2
    pid_t c1 = fork();
    if (c1 < 0) {
        perror("fork c1");
        exit(1);
    }
    if (c1 == 0) {
        //c1: no further children
        printf("[CHILD c1] PID=%d PPID=%d\n", (int)getpid(), (int)getppid());
        _exit(0);
    }

    pid_t c2 = fork();
    if (c2 < 0) {
        perror("fork c2");
        exit(1);
    }
    if (c2 == 0) {
        //c2: no further children
        printf("[CHILD c2] PID=%d PPID=%d\n", (int)getpid(), (int)getppid());
        _exit(0);
    }

    //root waits for its 3 children: c0, c1, c2
    wait(NULL);
    wait(NULL);
    wait(NULL);

    return 0;
}
