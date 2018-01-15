#include <stdio.h>

#include "main.h"
#include "instruction-decoder.h"

int main(){
    while(true){
        Instruction instr = get_next_instruction();

        int i;
        for(i = 0; i < instr.length; i++){
            printf("%s\n", instr.word[i]);
        }
    }
    return 0;
}
