#include <stdio.h>
#include <assert.h>

#include "expressions.h"
#include "storage.h"

void evaluate_component(Component v, Bucket *B, int where){
    if(!v.valid) return;
    if(v.var){
        int pos = insert_element(B, v.value);
        printf("ldr r0, =universe\n");
        printf("ldr r%d, [r0, #%d]\n", where, pos * 4);
    }
    else {
        printf("ldr r%d, =#%s\n", where, v.value);
    }
}

void evaluate_expression(Expression e, Bucket *B){
    assert(e.valid);
    if(e.oper == NONE){
        Component v = e.v1;
        evaluate_component(v, B, 1);
    }
    else {
        int x, y;
        x = 2; y = 3; // registros auxiliares para los cómputos...
        evaluate_component(e.v1, B, x);
        evaluate_component(e.v2, B, y);
        printf("  ");
        switch(e.oper){
            case SUMA: {
                printf("add r1, r%d, r%d\n", x, y);
            }
            case RESTA: {
                printf("sub r1, r%d, r%d\n", x, y);
            }
            case MULTIPLICACION: {
                printf("mul r1, r%d, r%d\n", x, y);
            }
            case DIVISION: {
                printf("sdiv r1, r%d, r%d\n", x, y);
            }
            case AND: {
                printf("and r1, r%d, r%d\n", x, y);
            }
            case OR: {
                printf("orr r1, r%d, r%d\n", x, y);
            }
            case XOR: {
                printf("eor r1, r%d, r%d\n", x, y);
            }
            case MENOR: {
                printf("cmp r%d, r%d\n", x, y);
                printf("xor r1, r1\n");
                printf("movlt r1, #1\n", x, y);
            }
            case MENOR_O_IGUAL: {
                printf("cmp r%d, r%d\n", x, y);
                printf("xor r1, r1\n");
                printf("movls r1, #1\n", x, y);
            }
            case IGUAL: {
                printf("cmp r%d, r%d\n", x, y);
                printf("xor r1, r1\n");
                printf("moveq r1, #1\n", x, y);
            }
            case MAYOR: {
                printf("cmp r%d, r%d\n", x, y);
                printf("xor r1, r1\n");
                printf("movgt r1, #1\n", x, y);
            }
            case MAYOR_O_IGUAL: {
                printf("cmp r%d, r%d\n", x, y);
                printf("xor r1, r1\n");
                printf("movge r1, #1\n", x, y);
            }
            case NONE: {}
        }
    }
}

void print_value(){
    puts("  ldr r0, =output");
    puts("  bl printf");
}

void initialize(){
    puts(".global main");
    puts(".extern printf");
    puts(".extern scanf");
    puts("main:");
    puts("  push {ip, lr}");
}

void terminate(){
    puts("  pop {ip, pc}");
    puts("  bx lr");
    puts(".data");
    puts("input: .asciz \"%d\"");
    puts("output: .asciz \"%d\\n\"");
}
