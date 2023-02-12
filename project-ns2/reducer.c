#include "stdio.h"

int main(){
    size_t sz = 10000;
    char* buffer = (char *) malloc(sz);
    while(getline(buffer, sz, stdin) != -1){
        
    }
}