/* Monte Carlo estimation of pi — multithreaded version (pthreads).
 *
 * How it works:
 *  - Randomly pick points (x, y) in [0,1] x [0,1].
 *  - Count how many satisfy x^2 + y^2 <= 1.
 *  - pi ≈ 4 * (hits / total_samples).
 */

 #include <stdio.h>
 #include <stdlib.h>
 #include <stdint.h>
 #include <time.h>
 #include <pthread.h>
 
 /* -------- Shared data (global) -------- */
 static pthread_mutex_t g_mutex = PTHREAD_MUTEX_INITIALIZER;
 static long long g_global_hits = 0;
 
 /* ---- Per-thread arguments ---- */
 struct thread_args {
     long long samples;   /* number of samples this thread should simulate */
     int       tid;       /* 0..T-1 */
     unsigned  seed;      /* thread-local RNG seed for rand_r */
 };
 
 /* A tiny helper to get "now" in seconds (as a double). */
 static double now_seconds(void) {
     struct timespec ts;
     clock_gettime(CLOCK_MONOTONIC, &ts);
     return (double)ts.tv_sec + (double)ts.tv_nsec / 1e9;
 }
 
 /* Worker logic used by both single-thread and thread function. */
 static long long simulate_hits(long long samples, unsigned int seed) {
     long long local_hits = 0;
 
     for (long long i = 0; i < samples; i++) {
         /* Random numbers in [0,1]. rand_r() is reentrant and fine here. */
         float x = (float)rand_r(&seed) / (float)RAND_MAX;
         float y = (float)rand_r(&seed) / (float)RAND_MAX;
 
         if (x * x + y * y <= 1.0f) {
             local_hits++;
         }
     }
     return local_hits;
 }
 
 /* Thread entry: compute local hits, then add to global under a mutex. */
 static void* worker(void* arg_ptr) {
     struct thread_args* a = (struct thread_args*)arg_ptr;
 
     /* Each thread needs its own random number seed.
        Deterministic per-thread seed: base + multiplier * tid. */
     unsigned int seed = (unsigned int)(1234u + 10007u * (unsigned int)a->tid);
 
     long long local = simulate_hits(a->samples, seed);
 
     pthread_mutex_lock(&g_mutex);
     g_global_hits += local;
     pthread_mutex_unlock(&g_mutex);
 
     return NULL; /* no per-thread return value */
 }
 
 int main(int argc, char** argv) {
     /* Usage: ./mcpi [T] [N]
      *   T = number of threads (default 4)
      *   N = total number of samples (default 50,000,000)
      */
     int T = (argc > 1) ? atoi(argv[1]) : 4;
     long long N = (argc > 2) ? atoll(argv[2]) : 50000000LL;
 
     if (T <= 0) {
         fprintf(stderr, "Number of threads T must be >= 1\n");
         return 1;
     }
     if (N <= 0) {
         fprintf(stderr, "Total samples N must be >= 1\n");
         return 1;
     }
 
     double t0 = now_seconds();
 
     /* -------- MULTITHREADED EXECUTION --------
        Split N fairly across T threads (first 'rem' get +1). */
     pthread_t* threads = (pthread_t*)malloc(sizeof(pthread_t) * (size_t)T);
     struct thread_args* args = (struct thread_args*)malloc(sizeof(struct thread_args) * (size_t)T);
     if (!threads || !args) {
         fprintf(stderr, "Allocation failed\n");
         free(threads); free(args);
         return 1;
     }
 
     long long base = N / T;
     long long rem  = N % T;
 
     for (int i = 0; i < T; i++) {
         args[i].tid     = i;
         args[i].samples = base + (i < rem ? 1 : 0);
         args[i].seed    = 0; /* seed set inside worker for clarity */
         int rc = pthread_create(&threads[i], NULL, worker, &args[i]);
         if (rc != 0) {
             fprintf(stderr, "pthread_create failed at i=%d (rc=%d)\n", i, rc);
             /* Best-effort join already created threads then exit */
             for (int j = 0; j < i; j++) pthread_join(threads[j], NULL);
             free(threads); free(args);
             return 2;
         }
     }
 
     for (int i = 0; i < T; i++) {
         pthread_join(threads[i], NULL);
     }
 
     long long hits = g_global_hits;
 
     free(threads);
     free(args);
 
     double t1 = now_seconds();
 
     /* Compute pi from the multithreaded result. */
     double pi_estimate = 4.0 * (double)hits / (double)N;
     const double PI_REF = 3.14159265358979323846;
     double err = (pi_estimate >= PI_REF) ? (pi_estimate - PI_REF) : (PI_REF - pi_estimate);
 
     printf("pi ≈ %.6f   error = %.6f   time = %.3fs   T = %d   N = %lld\n",
            pi_estimate, err, (t1 - t0), T, N);
 
     return 0;
 }
 