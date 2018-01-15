#include <stdio.h>

#include "main.h"
#include "instruction-decoder.h"

int main(){
    while(true){
        Instruction instr = get_next_instruction();

        int i;
        for(i = 0; i < instr.length; i++){
            printf("%s\n", instr.words[i]);
        }

        printf("%d\n", get_instruction_type(instr));
    }
    return 0;
}
