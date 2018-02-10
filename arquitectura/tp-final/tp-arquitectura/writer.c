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
                break;
            }
            case RESTA: {
                printf("sub r1, r%d, r%d\n", x, y);
                break;
            }
            case MULTIPLICACION: {
                printf("mul r1, r%d, r%d\n", x, y);
                break;
            }
            case DIVISION: {
                printf("sdiv r1, r%d, r%d\n", x, y);
                break;
            }
            case AND: {
                printf("and r1, r%d, r%d\n", x, y);
                break;
            }
            case OR: {
                printf("orr r1, r%d, r%d\n", x, y);
                break;
            }
            case XOR: {
                printf("eor r1, r%d, r%d\n", x, y);
                break;
            }
            case MENOR: {
                printf("eor r1, r1\n");
                printf("  cmp r%d, r%d\n", x, y);
                printf("  movlt r1, #1\n");
                break;
            }
            case MENOR_O_IGUAL: {
                printf("eor r1, r1\n");
                printf("  cmp r%d, r%d\n", x, y);
                printf("  movls r1, #1\n");
                break;
            }
            case IGUAL: {
                printf("eor r1, r1\n");
                printf("  cmp r%d, r%d\n", x, y);
                printf("  moveq r1, #1\n");
                break;
            }
            case MAYOR: {
                printf("eor r1, r1\n");
                printf("  cmp r%d, r%d\n", x, y);
                printf("  movgt r1, #1\n");
                break;
            }
            case MAYOR_O_IGUAL: {
                printf("eor r1, r1\n");
                printf("  cmp r%d, r%d\n", x, y);
                printf("  movge r1, #1\n");
                break;
            }
            case NONE: {}
        }
    }
}

void print_value(){
    puts("  ldr r0, =output");
    puts("  bl printf");
}

void scan_value(Bucket *B, const char *s){
    int k = insert_element(B, s);
    puts("  ldr r0, =input");
    puts("  ldr r1, =universe");
    printf("  add r1, #%d\n", 4 * k);
    puts("  bl scanf");
}

void load_value(Bucket *B, const char *s){
    int k = insert_element(B, s);
    puts("  ldr r0, =universe");
    printf("  str r1, [r0, #%d]\n", 4 * k);
}

void mark_label(const char *l){
    printf("LABEL%s:\n", l);
}

void jump_label(const char *l){
    printf("  b LABEL%s\n", l);
}

void initialize(){
    puts(".global main");
    puts(".extern printf");
    puts(".extern scanf");
    puts("main:");
    puts("  push {ip, lr}");
}

void terminate(Bucket *B){
    puts("  pop {ip, pc}");
    puts("  bx lr");
    puts(".data");
    puts("input: .asciz \"%d\"");
    puts("output: .asciz \"%d\\n\"");
    printf("universe: .fill %d\n", 4 * B->nelems);
}
