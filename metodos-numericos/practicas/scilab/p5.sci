clear
clc
format(20)

////////// EJERCICIO 1 //////////

/// Matrices de ejemplo ///

A1 = [0 2 4; 1 -1 -1; 1 -1 2];
b1 = [0 0.375 0]';
x1 = [5 7 10]';

A2 = [1 -1 0; -1 2 -1; 0 -1 1.1];
b2 = [0 1 0]';
x2 = [1 4 3]';

/// Parte a) ///

// Si esto da true entonces converge Jacobi en cualquier punto.
function y = radioEspectralear(A)
    try 
        D = diag(diag(A));
        R = A - D;
        y = max(abs(spec(inv(D)*R))) < 1;
    catch
        y = %F;
    end
endfunction

// A matriz cuadrada, te devuelve la solucion si
// radioEspectralear da %T.
function y = jacobear(A, x, b)
    n = size(A, 1);
    y = x;
    for rep=1:15000
        for i=1:n
            guarda = A(i, i);
            A(i, i) = 0;
            y(i) = (b(i) - A(i,:)*x) / guarda;
            A(i, i) = guarda;
        end
        x = y;
    end
endfunction

disp( radioEspectralear(A1), "Funciona para la primera? " );
disp( radioEspectralear(A2), "Funciona para la segunda? " );
res = jacobear(A2, x2, b2);
disp(A2*res);
disp(b2);

// Para la primer matriz, no se puede asegurar la convergencia
// porque el radio espectral es >= 1 :(
// Para la segunda matriz anda todo bien porque si, tiene radio
// espectral menor que 1 (la matriz de iteracion).

/// Parte b) ///

// Arreglar esta cosa
function y = gaussSeidelear(A, x, b)
    n = size(A, 1);
    y = x;
    for rep=1:15000
        for i=1:n
            mat = A(i,:)*y;
            y(i) = (b(i) - sum(mat(1:i-1)) - sum(mat(i+1:n)))  
                   / a(i, i);
        end
        x = y;
    end
endfunction

res = gaussSeidelear(A2, x2, b2);

