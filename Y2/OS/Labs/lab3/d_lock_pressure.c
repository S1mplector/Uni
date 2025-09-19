#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

typedef struct { long long iters; int tid; } arg_t;
static long long global_sum = 0;
static pthread_mutex_t m = PTHREAD_MUTEX_INITIALIZER;

void* worker(void* p){
    arg_t* a = (arg_t*)p;
    long long local = 0;
    for(long long i=0;i<a->iters;i++) local++;
    pthread_mutex_lock(&m);
    global_sum += local;
    pthread_mutex_unlock(&m);
    return NULL;
}

int main(int argc, char** argv){
    int T = (argc>1)?atoi(argv[1]):4;
    long long N = (argc>2)?atoll(argv[2]):1000000;
    pthread_t th[T]; arg_t args[T];
    for(int i=0;i<T;i++){
        args[i]=(arg_t){.iters=N,.tid=i};
        pthread_create(&th[i],NULL,worker,&args[i]); }
    for(int i=0;i<T;i++) pthread_join(th[i],NULL);
    printf("Expected %lld, got %lld\n", (long long)T*N, global_sum);
    return 0;
}
