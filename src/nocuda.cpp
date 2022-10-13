#include <iostream>
#include <math.h>
#include <cstdlib>

#include "work.h"

// function to add the elements of two arrays
void add(int n, cxfloat *x, cxfloat *y, cxfloat *z) {
  for (int i = 0; i < n; i++) {
    z[i] = work(x[i], y[i]);
  }
}

int main(int argc, char* argv[])
{
    int N = atoi(argv[1]);
    std::cout << N << std::endl;

  cxfloat *x = new cxfloat[N]; init_arr(x, N);
  cxfloat *y = new cxfloat[N]; init_arr(y, N);
  cxfloat *z = new cxfloat[N];

  // Run kernel on 1M elements on the CPU
  add(N, x, y, z);

  std::cout << x[55] << " " << y[55] << " " << z[55] << std::endl;

  cxfloat s = 0;
  for (int i = 0; i < N; ++i) {
    s += z[i];
  }
  std::cout << "final answer " << s << std::endl;


  // Free memory
  delete [] x;
  delete [] y;
  delete [] z;


  return 0;
}
