#include <stdio.h> 
#include <string.h>
#include <math.h>

void Primes(int num) { 
  // square root ideal limit. floating point math unfortunate,
  // but likely fast as long as system has a fpu.
  printf("n:%d\n", num);
  int limit = ceil(sqrt(num));
  printf("l:%d\n", limit);
  for (int factor = 2; factor < limit; factor += 1) {
    printf("f: %d\n", factor);
    if ((num % factor) == 0) {
      printf("false\n");
    }
  }
  
  printf("true\n"); 
}

int main(void) { 
  
  // keep this function call here
  int v = 0;
  int r = scanf("%d\n", &v);
  if (r != 1) {
	  printf("r: %d", r);
  } else {
	  Primes(v);
  }
  
  return 0;
} 


  
