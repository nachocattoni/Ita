clear
clc

function x = f(x0, y0, x1, y1)
    x = (x0*y1 - x1*y0) / (y1 - y0)
endfunction

function x = g(x0, y0, x1, y1)
    x = x0 - y0 * (x1 - x0) / (y1 - y0)
endfunction

x0 = 1.31
y0 = 3.24

x1 = 1.93
y1 = 4.76

format(25)
disp(f(x0, y0, x1, y1));
disp(g(x0, y0, x1, y1));

//// Ademas de esto, me ayude con los calculos con
//// el interprete, lo use como calculadora.

//SALIDA DEL PROGRAMA:
//  
//  - 0.0115789473684215337562  
// 
//  - 0.0115789473684213550797  
// Esta salida no es relevante en si al ejercicio, son solo cuentas que me
// ayudaron a tomar decisiones.
