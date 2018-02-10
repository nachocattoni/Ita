#include <stdio.h>

#include "main.h"
#include "instruction-decoder.h"
#include "expressions.h"
#include "debug.h"
#include "storage.h"
#include "writer.h"

int main(){
    initialize();
    
    Bucket B = create_new_bucket();
    while(true){
        Instruction instr = get_next_instruction();
        if(instr.length == 0) break;
        
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
                break;
            }
            case END:
            {
                terminate(&B);
                break;
            }
            case JUMP:
            {
                if(!is_label_number(instr.words[1])){
                    fprintf(stderr, "%s\n", INCORRECT_INSTRUCTION);
                    return -1;
                }
                jump_label(instr.words[1]);
                break;
            }
            case LABEL:
            {
                if(!is_label_number(instr.words[1])){
                    fprintf(stderr, "%s\n", INCORRECT_INSTRUCTION);
                    return -1;
                }
                mark_label(instr.words[1]);
                break;
            }
            case CONDITIONAL_JUMP:
            {
                Expression e = get_next_expression(instr, 1);
                evaluate_expression(e, &B);
                char *label = (e.oper == NONE) ? instr.words[2] : instr.words[4];
                conditional_jump(label);
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
