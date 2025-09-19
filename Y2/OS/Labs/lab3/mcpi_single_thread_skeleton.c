/* Monte Carlo estimation of pi — single-thread baseline.
 *
 * Assignment: This file is fully working in one thread.
 * Fill in the marked TODO blocks to turn it into
 * the multithreaded version (using pthreads).
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

/* -------------- TODO (Multithreading) -----------------
 * When you make it multithreaded, you will:
 *  - #include <pthread.h>
 *  - Add a global mutex and a global_hits counter
 *  - Define a struct thread_args for per-thread arguments;
 *  - Write a worker(void*) that computes local_hits and adds to global_hits with the mutex.
 *  - Split the work across T threads with pthread_create/pthread_join.
 * BE CAREFUL TO THE SEED VALUES OF YOUR RANDOM GENERATOR: IT NEEDS TO BE DIFFERENT IN EACH THREAD
 * ------------------------------------------------------ */
 
 /* -------- TODO: Create your shared data variables here -------- */


/* ---- TODO: Create your per-thread arguments structure here ---- */


/* A tiny helper to get "now" in seconds (as a double). */
static double now_seconds(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (double)ts.tv_sec + (double)ts.tv_nsec / 1e9;
}

/* Single-thread worker: returns how many samples landed inside the circle.
 * (The multithreaded version’s thread function should mirror this logic.) */
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

/* TODO: Create your worker function run by each thread. */
void* worker(void* arg_ptr) {

    /* Each thread needs its own random number seed.
     * We use a simple per-thread seed based on thread id.
     * rand_r() is a thread-safe random function available on Linux.
	 * Uncomment the line and replace the TODO by your thread ID, it should be part of your
	 * per-thread arguments
     */
    //unsigned int seed = (unsigned int)(1234 + 10007 * TODO);

    return NULL; /* no result to return */
}

int main(int argc, char** argv) {
    /* Usage: ./mcpi_single [T] [N]
     *   T = number of threads (ignored in the single-thread baseline; default 4)
     *   N = total number of samples (default 50,000,000)
     */
    int T = (argc > 1) ? atoi(argv[1]) : 1;            /* currently unused */
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

    /* -------- SINGLE-THREAD EXECUTION --------
     * TODO (Multithreading):
     *   - Split N across T threads.
     *   - Create arrays for your threads and arguments
     *   - For i in [0..T): run the Monte Carlo simulation for each thread with the worker
     *   - Join all threads and sum up global_hits.
     */


    //TODO: Write multithreaded execution here

    
    


    //TODO: Comment out the next 2 lines when running your multithreaded version
    /* In the single-thread baseline we just do all N samples here. */
    unsigned int seed = 1234u;                /* deterministic seed; you can vary it */
    long long hits = simulate_hits(N, seed);  /* all work done in the main thread */


    //Computing the end time
    double t1 = now_seconds();

    /* Compute pi from the single-thread result. */
    double pi_estimate = 4.0 * (double)hits / (double)N;

    const double PI_REF = 3.14159265358979323846;
    double err = (pi_estimate >= PI_REF) ? (pi_estimate - PI_REF) : (PI_REF - pi_estimate);

    /* Keep the print format similar to the multithreaded version.
     * Note: T printed here is the CLI value but execution was single-threaded.
     */
    printf("pi ≈ %.6f   error = %.6f   time = %.3fs   T = %d   N = %lld\n",
           pi_estimate, err, (t1 - t0), T, N);

    return 0;
}