#include <cuda_runtime.h>
#include <iostream>


inline void __checkCudaError(cudaError_t err, const char* file, int line) {
    if (err != cudaSuccess) {
        fprintf(stderr, "CUDA error at %s:%d: %s\n", file, line, cudaGetErrorString(err));
        exit(EXIT_FAILURE);
    }
}

#define checkCudaError(call) __checkCudaError((call), __FILE__, __LINE__)

__global__ void matrixMultiplyKernel(const double* A, const double* B, double* C, int N, int M, int P) {
    int i = blockIdx.y * blockDim.y + threadIdx.y;
    int k = blockIdx.x * blockDim.x + threadIdx.x;

    if (i < N && k < P) {
        double sum = 0.0f;
        for (int j = 0; j < M; ++j) {
            sum += A[i * M + j] * B[j * P + k];
        }
        C[i * P + k] = sum;
    }
}

int main() {
    // Matrix sizes
    int N = 2000, M = 3000, P = 4000;

    double *hostA, *hostB, *hostC;
    double *devA, *devB, *devC;

    // Allocate host memory
    hostA = (double*)malloc(N * M * sizeof(double));
    hostB = (double*)malloc(M * P * sizeof(double));
    hostC = (double*)malloc(N * P * sizeof(double));

    // Verify that allocations succeeded
    if (hostA == NULL || hostB == NULL || hostC == NULL) {
      fprintf(stderr, "Failed to allocate host vectors!\n");
      exit(EXIT_FAILURE);
    }

    // Data initialization omitted

    // Allocate device memory
    checkCudaError(cudaMalloc((void**)&devA, N * M * sizeof(double)));
    checkCudaError(cudaMalloc((void**)&devB, M * P * sizeof(double)));
    checkCudaError(cudaMalloc((void**)&devC, N * P * sizeof(double)));

    // Copy matrices from host to device
    checkCudaError(cudaMemcpy(devA, hostA, N * M * sizeof(double), cudaMemcpyHostToDevice));
    checkCudaError(cudaMemcpy(devB, hostB, M * P * sizeof(double), cudaMemcpyHostToDevice));

    // Define block and grid sizes
    dim3 blockDim(16, 16);
    dim3 gridDim((P + blockDim.x - 1) / blockDim.x, (N + blockDim.y - 1) / blockDim.y);

    // Launch the kernel
    matrixMultiplyKernel<<<gridDim, blockDim>>>(devA, devB, devC, N, M, P);
    checkCudaError(cudaPeekAtLastError());
    checkCudaError(cudaDeviceSynchronize());

    // Copy result matrix from device to host
    checkCudaError(cudaMemcpy(hostC, devC, N * P * sizeof(double), cudaMemcpyDeviceToHost));

    // Free device memory
    checkCudaError(cudaFree(devA));
    checkCudaError(cudaFree(devB));
    checkCudaError(cudaFree(devC));

    // Free host memory
    free(hostA);
    free(hostB);
    free(hostC);

    return 0;
}