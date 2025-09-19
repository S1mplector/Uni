#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

static long long counter = 0;
pthread_mutex_t m = PTHREAD_MUTEX_INITIALIZER;

typedef struct { long long iters; } arg_t;

void* add(void* p){
    long long n = ((arg_t*)p)->iters;
    for(long long i=0;i<n;i++){
        pthread_mutex_lock(&m);
        counter++;
        pthread_mutex_unlock(&m);
    }
    return NULL;
}

int main(int argc, char** argv){
    int T = (argc>1)?atoi(argv[1]):4;
    long long N = (argc>2)?atoll(argv[2]):1000000;
    pthread_t th[T]; arg_t a = { .iters = N };
    for(int i=0;i<T;i++) pthread_create(&th[i],NULL,add,&a);
    for(int i=0;i<T;i++) pthread_join(th[i],NULL);
    printf("Expected %lld, got %lld\n", N*(long long)T, counter);
    return 0;
}
