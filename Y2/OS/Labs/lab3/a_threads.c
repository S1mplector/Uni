#define _GNU_SOURCE
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#ifdef __linux__
#include <sched.h>
#endif

typedef struct { int tid; } arg_t;

void* worker(void* p) {
    arg_t* a = (arg_t*)p;
    int cpu = -1;
#ifdef __linux__
    cpu = sched_getcpu();
#endif
    printf("Hello from thread %d on CPU %d\n", a->tid, cpu);
    return NULL;
}

int main(int argc, char** argv){
    int T = (argc > 1) ? atoi(argv[1]) : 4;
    pthread_t th[T]; arg_t args[T];
    for (int i=0;i<T;i++){ args[i].tid=i; pthread_create(&th[i], NULL, worker, &args[i]); }
    for (int i=0;i<T;i++) pthread_join(th[i], NULL);
    return 0;
}
