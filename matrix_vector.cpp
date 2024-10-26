#include <stdio.h>
#include <stdlib.h>

void matrix_vector_product(float *A, float *v1, float *v2, int matrix_size) {
  for (int i = 0; i < matrix_size; i++) {
    float sum = 0.0f;
    for(int j = 0; j < matrix_size; j++) {
      sum += A[i * matrix_size + j]
    }
  }
}