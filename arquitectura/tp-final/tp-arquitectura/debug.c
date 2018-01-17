#include <stdio.h>

#include "expressions.h"
#include "debug.h"

void show_component(Component c){
	if(c.code == '?'){
		printf("La componente consiste del literal: %d\n", c.value);
	}
	else {
		printf("La componente corresponde a la variable %c%d\n", c.code,
			c.value);
	}
}

void show_expression(Expression e){
	if(!e.valid){
		printf("No es una expresion valida\n");
	}
	else {
		if(e.oper != NONE){
			const char *operators[] = OPERATOR_LIST;
			printf("La expresion consiste de dos componentes, siendo operadas por: %s\n", operators[e.oper]);
			printf("Componente 1: "); show_component(e.v1);
			printf("Componente 2: "); show_component(e.v2);
		}
		else {
			printf("La expresion consiste de una sola componente\n");
			show_component(e.v1);
		}
	}
}

