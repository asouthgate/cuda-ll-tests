#include "math.h"
#include <cuda.h>
#include <cuda_runtime_api.h>
#include <ctime>
#include <complex>
#include <thrust/complex.h>

#ifdef __CUDACC__
    #define HD __host__ __device__
    #define D __device__
    #define cxfloat thrust::complex<float>
#else
    #define HD
    #define D
    #define cxfloat std::complex<float>
#endif


D cxfloat work(cxfloat & a, cxfloat & b) {

    cxfloat c2 = cxfloat(2, 0);
    cxfloat cpi = cxfloat(M_PI, 0);


    cxfloat f = - pow( (a / b), c2) / c2;
    f -= log( c2 * cpi * pow(b, c2) ) / c2;


    return f;
}

int seed() {
    srand(0);
    return 0;
}

int TMP = seed();

void init_arr(cxfloat *arr, int SIZE) {
    for (int i = 0; i < SIZE; ++i) {
        arr[i] = cxfloat(1 + rand() % 10, 1 + rand() % 10);
    }
}

