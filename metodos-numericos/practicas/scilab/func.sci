clear
clc

// Para crear un arreglo de funciones

function y = f(x)
    y = x
endfunction

function y = g(x)
    y = x + 2
endfunction

function y = h(x)
    y = x + 3
endfunction

A = list(f, g, h);

p = A(1) // p ahora es f
q = A(2) // q ahora es g
r = A(3) // r ahora es h
