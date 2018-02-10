#include <stdio.h>
			#include <assert.h>

#include "main.h"
#include "instruction-decoder.h"
#include "expressions.h"
#include "debug.h"
#include "storage.h"
#include "writer.h"

int main(){
    initialize();
    
    Bucket B = create_new_bucket();
    bool end = false;
    while(!end){
        Instruction instr = get_next_instruction();
        instructionType instr_type = get_instruction_type(instr);

        switch(instr_type){
            case ASSIGN:
            {
                insert_element(&B, instr.words[0]);
                Expression e = get_next_expression(instr, 1);
                evaluate_expression(e, &B);
                load_value(&B, instr.words[0]);
                break;
            }
            case OUTPUT:
            {
                Expression e = get_next_expression(instr, 1);
                evaluate_expression(e, &B);
                print_value();
                break;
            }
            case INPUT:
            {
                Component v = get_component(instr.words[1]);
                if(!v.var){
                    fprintf(stderr, "%s\n", INCORRECT_INSTRUCTION);
                    return -1;
                }
                scan_value(&B, v.value);
                //~ load_value(&B, v.value);
                break;
            }
            case END:
            {
                terminate(&B);
                end = true;
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
                evaluate_expression(e, &B);
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
