#include <stdio.h>
#include <assert.h>

#include "main.h"
#include "instruction-decoder.h"
#include "expressions.h"
#include "debug.h"

int main(){
    while(true){
        Instruction instr = get_next_instruction();
        if(is_valid_integer(instr.words[0])){
			puts("OK");
		}
		else {
			puts("NO OK");
		}
		continue;

        instructionType instr_type = get_instruction_type(instr);
        
        switch(instr_type){
            case ASSIGN:
            {
                
                break;
			}
            case INPUT:
            {
                
                break;
			}
            case END:
            {
                
                break;
			}
            case JUMP:
            {
                
                break;
			}
            case LABEL:
            {
                
                break;
			}
            case CONDITIONAL_JUMP:
            {
                Expression e = get_next_expression(instr, 1);
                show_expression(e);
                break;
			}
            default:
            {
                printf("%s\n", INCORRECT_INSTRUCTION);
                return -1;
			}
        }
    }
    return 0;
}
