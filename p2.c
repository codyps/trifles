#include <stdio.h> 
#include <string.h>
#include <math.h>

void Primes(int num) { 
  
  // square root ideal limit. floating point math unfortunate,
  // but likely fast as long as system has a fpu.
  int limit = sqrt(num);
  for (int factor = 2; factor < limit; factor += 1) {
    if ((num % factor) == 0) {
      printf("false");
    }
  }
  
  printf("true"); 
}

int main(void) { 
  
  // keep this function call here
  int v = 0;
  int r = scanf("%d", &v);
  if (r == 1) {
    Primes(v);
    return 0;
  }
  
  return -1;
} 


  
