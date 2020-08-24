#include <iostream>
#include <string>
#include <map>
using namespace std;

string NonrepeatingCharacter(string str) { 
  // NOTE: we're assuming single-byte characters, but utf-8 exists.
  map<char, size_t> counts;
  for (char c: str) {
    counts[c] += 1;
  }
  
  // second iteration is unfortunate. can avoid if we had an insertion
  // order map, like python's OrderedDict (or used some other data structure as our key)
  for (char c: str) {
    if (counts[c] == 1) {
      string r;
      r += c;
      return r;
    }
  }
  
  // unreachable
  abort();
}

int main() { 
  
  // keep this function call here
  cout << NonrepeatingCharacter(gets(stdin));
  return 0;
    
} 


  
