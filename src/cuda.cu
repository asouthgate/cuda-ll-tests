#include <cuda_runtime_api.h>
#include <cuda.h>
#include <cuComplex.h>
#include <cstdlib>
#include <iostream>
#include <ctime>

#include "work.h"


__global__ void add(cxfloat *a, cxfloat *b, cxfloat *c) {
    int i = threadIdx.x + blockIdx.x * blockDim.x;
    c[i] = work(a[i], b[i]);
}

void run_app(int N, int THREADS_PER_BLOCK) {


    cxfloat *a, *b, *c; // host copies of a, b, c
    cxfloat *d_a, *d_b, *d_c; // device copies of a, b, c
    int size = N * sizeof(cxfloat);
    // Alloc space for device copies of a, b, c
    cudaMalloc((void **)&d_a, size);
    cudaMalloc((void **)&d_b, size);
    cudaMalloc((void **)&d_c, size);
    // Alloc space for host copies of a, b, c and setup input values
    a = (cxfloat *)malloc(size); init_arr(a, N);
    b = (cxfloat *)malloc(size); init_arr(b, N);
    c = (cxfloat *)malloc(size);

    // Copy inputs to device
    cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);

    // Launch add() kernel on GPU
    std::cerr << float(N)/THREADS_PER_BLOCK <<  std::endl;
    std::cerr << THREADS_PER_BLOCK << std::endl;
    int n_blocks = ceil( float(N)/THREADS_PER_BLOCK );
    add<<<n_blocks,THREADS_PER_BLOCK>>>(d_a, d_b, d_c);
//    cudaError_t cudaerr = cudaGetLastError();
//    if (cudaerr != cudaSuccess)
//        printf("kernel launch failed with error \"%s\".\n",
//               cudaGetErrorString(cudaerr));


    // Copy result back to host
    cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);

    std::cout << a[55] << " " << b[55] << " " << c[55] << std::endl;

    
    cxfloat s = 0;
    for (int i = 0; i < N; ++i) {
//        std::cout << "ci " << a[i] << std::endl;
        s += c[i];
    }
    std::cout << "final answer " << s << std::endl;


    // Cleanup
    free(a); free(b); free(c);
    cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);


}


int main(int argc, char* argv[]) {

    if (argc != 3) {

        fprintf(stderr,"%s: Error: 2 parameters expected. Found %d\n", argv[0], argc);

        return 1;

    }



    int N = atoi(argv[1]);
    int THREADS_PER_BLOCK = atoi(argv[2]);

    run_app(N, THREADS_PER_BLOCK);


    return 0;
}
