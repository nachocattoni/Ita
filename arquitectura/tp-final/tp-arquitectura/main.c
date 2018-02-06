#include <stdio.h>
#include <assert.h>

#include "main.h"
#include "instruction-decoder.h"
#include "expressions.h"
#include "debug.h"
#include "storage.h"

int main(){
    Bucket B = create_new_bucket();
    while(true){
        Instruction instr = get_next_instruction();
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
                fprintf(stderr, "%s\n", INCORRECT_INSTRUCTION);
                return -1;
            }
        }
    }
    return 0;
}
