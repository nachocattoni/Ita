//// Ejercicio 1

// Parte a)
clear
clc

A1 = [1 0 0; -1 0 1; -1 -1 2];

function [cota_inf, cota_sup] = gerschgorinear(A)
    cota_inf = 0;
    cota_sup = 0;
    n = size(A, 1);
    for i=1:n
        centro(i) = A(i, i);
        radio(i) = sum(abs(A(i,:))) - A(i, i);
        cota_inf = min(cota_inf, centro(i) - radio(i));
        cota_sup = max(cota_sup, centro(i) + radio(i));
    end
    
    x = [cota_inf:1e-2:cota_sup];
    for i=1:n
        plot(x, sqrt( radio(i)^2 - (x - centro(i)).*(x - centro(i)) ));
        plot(x, -sqrt( radio(i)^2 - (x - centro(i)).*(x - centro(i)) ));
    end
endfunction

// gerschgorinear(A1);
// disp(spec(A1))

// Parte b)

A2 = [1 0 0; -0.1 0 0.1; -0.1 -0.1 2];
// gerschgorinear(A2);
// disp(spec(A2))

// Kip gowin

//// Ejercicio 2

// bueno, mejor no

//// Ejercicio 3

for k=0:1000
    A = [1 -1 0; -2 4 -2; 0, -1, 1 + 0.1*k];
    charp = poly(spec(A), "x", "r");
    eigenv = spec(A);
    disp(charp);
    disp(eigenv);
    gerschgorinear(A);
end
