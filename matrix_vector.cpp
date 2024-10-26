#include <stdio.h>
#include <stdlib.h>

void matrix_vector_product(float *A, float *v1, float *v2, int matrix_size) {
  for (int i = 0; i < matrix_size; i++) {
    float sum = 0.0f;
    for(int j = 0; j < matrix_size; j++) {
      sum += A[i * matrix_size + j] * v1[j];
    }
    v2[i] = sum;
  }
}

int main() {
  float *A, *v1, *v2;
  int matrix_size = 40000;

  A = new float[matrix_size * matrix_size];
  v1 = new float[matrix_size];
  v2 = new float[matrix_size];
  
  // Initialize matrices and vectors
  for (int i = 0; i < matrix_size; i++) {
    for (int j = 0; j < matrix_size; j++) {
      A[i * matrix_size + j] = (float) i * matrix_size + j;
    }
    v1[i] = (float) i;
  }

  // Perform matrix-vector product
  matrix_vector_product(A, v1, v2, matrix_size);

  // Print the result
  for(int i = 0; i < matrix_size; i++) {
    printf("%.2f\n", v2[i]);
  }

  delete[] A;
  delete[] v1;
  delete[] v2;
  return 0;
}