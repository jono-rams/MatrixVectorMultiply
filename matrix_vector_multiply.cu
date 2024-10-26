
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <algorithm>
#include <cmath>
#include <stdio.h>

__global__ void matrix_vector_product(float* A, float* v1, float* v2, int matrix_size) {
    int row = blockIdx.x * blockDim.x + threadIdx.x;
    int col = blockIdx.y * blockDim.y + threadIdx.y;

    if (col == 0 && row < matrix_size) {
        float sum = 0;
        for (int i = 0; i < matrix_size; i++) {
            sum += A[row * matrix_size + i] * v1[i];
        }
        v2[row] = sum;
    }
}

int main() {
    float* A, * A_gpu;
    float* v1, * v1_gpu;
    float* v2, * v2_gpu;

    int matrix_size = 40000;

    dim3 block_shape = dim3(32, 32);
    dim3 grid_shape = dim3(std::max(1.0f, std::ceil((float)matrix_size / (float)block_shape.x)),
        std::max(1.0f, std::ceil((float)matrix_size / (float)block_shape.y)));

    // Allocate memory for CPU arrays
    A = new float[matrix_size * matrix_size];
    v1 = new float[matrix_size];
    v2 = new float[matrix_size];

    // Initialize matrices and vectors
    for (int i = 0; i < matrix_size; i++) {
        for (int j = 0; j < matrix_size; j++) {
            A[i * matrix_size + j] = (float)i * matrix_size + j;
        }
        v1[i] = (float)i;
    }

    cudaMalloc((void**)&A_gpu, matrix_size * matrix_size * sizeof(float));
    cudaMalloc((void**)&v1_gpu, matrix_size * sizeof(float));
    cudaMalloc((void**)&v2_gpu, matrix_size * sizeof(float));

    // Copy matrices and vectors to GPU
    cudaMemcpy(A_gpu, A, matrix_size * matrix_size * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(v1_gpu, v1, matrix_size * sizeof(float), cudaMemcpyHostToDevice);

    // Launch kernel
    matrix_vector_product << <grid_shape, block_shape >> > (A_gpu, v1_gpu, v2_gpu, matrix_size);

    // Copy result from GPU to CPU
    cudaMemcpy(v2, v2_gpu, matrix_size * sizeof(float), cudaMemcpyDeviceToHost);

    // Print the result
    for (int i = 0; i < matrix_size; i++) {
        printf("%.2f\n", v2[i]);
    }

    cudaFree(A_gpu);
    cudaFree(v1_gpu);
    cudaFree(v2_gpu);

    delete[] A;
    delete[] v1;
    delete[] v2;

    return 0;
}