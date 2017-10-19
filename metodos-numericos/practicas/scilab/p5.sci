clear
clc
format(20)

////////// EJERCICIO 1 //////////
mprintf("<<< Ejercicio 1) >>>\n");
/// Matrices de ejemplo ///

A1 = [0 2 4; 1 -1 -1; 1 -1 2];
b1 = [0 0.375 0]';
x1 = [5 7 10]';

A2 = [1 -1 0; -1 2 -1; 0 -1 1.1];
b2 = [0 1 0]';
x2 = [1 4 3]';

/// Parte a) ///
for i = 1:72
    mprintf("*");
end
mprintf("\nParte a)\n");

// Si esto da true entonces converge Jacobi en cualquier punto.
function y = radioEspectralear(A)
    try 
        D = diag(diag(A));
        R = A - D;
        y = max(abs(spec(inv(D)*R))) < 1;
        disp(max(abs(spec(inv(D)*R))), "Radio Espectral da: ");
    catch
        mprintf("El radio espectral no se pudo calcular :(");
        y = %F;
    end
endfunction

// A: matriz cuadrada, te devuelve la solucion si
// radioEspectralear da %T (o una aproximación,
// ya que puede converger muuuuuy lento).
function y = jacobear(A, x, b, tol)
    n = size(A, 1);
    y = x;
    for rep=1:15000
        for i=1:n
            guarda = A(i, i);
            A(i, i) = 0;
            y(i) = (b(i) - A(i,:)*x) / guarda;
            A(i, i) = guarda;
        end
        if(norm(x - y) < tol)
            mprintf("JACOBI TERMINA LUEGO DE %d ITERACIONES", rep);
            break;
        end
        x = y;
    end
endfunction

disp( radioEspectralear(A1), "Funciona para la primera? " );
disp( radioEspectralear(A2), "Funciona para la segunda? " );
res = jacobear(A2, x2, b2, 1e-9);
disp(res, "La solucion encontrada es: ");
disp(A2*res, "Para checkear, la multiplicamos por A2: ");
disp(b2, "Esto era lo que debía dar: ");

// Para la primer matriz, no se puede asegurar la convergencia
// porque el radio espectral es >= 1 :(
// Para la segunda matriz anda todo bien porque si, tiene radio
// espectral menor que 1 (la matriz de iteracion).

/// Parte b) ///
for i = 1:72
    mprintf("*");
end
mprintf("\nParte b)\n");

//// Da true si la matriz es diagonal dominante
function y = diagonalDominante(A)
    n = size(A, 1);
    for i=1:n
        if( 2 * abs(A(i, i)) < sum(abs(A(i,:))) )
            y = %F
            return;
        end
    end
    y = %T
endfunction

//// Da true si la matriz es simétrica
function y = simetrica(A)
    y = and(abs(A - A') < 1e-15);
endfunction

//// Da true si la matriz es definida positiva
//// NO FUNCIONA, TESTEAR A MANO... :(
function y = dp(A)
    y = and(spec(A) > 1e-15);
endfunction

//// Te dice si tu matriz esta apta para darle con Gauss-Seidel
function y = aptaParaGaussear(A)
    p1 = diagonalDominante(A);
    p2 = simetrica(A) & dp(A);
    y = p1 | p2;
endfunction

//// Te da la solucion si la matriz es diagonal dominante,
//// o simétrica y definida positiva.
function y = gaussSeidelear(A, x, b, tol)
    n = size(A, 1);
    y = x;
    for rep=1:15000
        for i=1:n
            mat = A(i,:).*y';
            v1 = 0;
            v2 = 0;
            if(i > 1)
                v1 = sum(mat(1:i-1));
            end
            if(i < n)
                v2 = sum(mat(i+1:n));
            end
            y(i) = (b(i) - v1 - v2) / A(i, i);
        end
        if(norm(x - y) < tol)
            break;
        end
        x = y;
    end
endfunction

// La primera no es apta para gaussear, pero no me anda el test :(
//if(aptaParaGaussear(A1))
//    disp("La matriz 1 es apta para Gaussear!");
//    res = gaussSeidelear(A1, x1, b1);
//    disp(res, "Gauss-Seidel para la segunda matriz: ");
//    disp(A1*res, "Para checkear, la multiplicamos por A1: ");
//    disp(b2, "Esto es lo que debía dar: ");
//end
mprintf("La matriz 1 no es apta para Gaussear :(\n");

//if(aptaParaGaussear(A2))
    disp("La matriz 2 es apta para Gaussear!");
    res = gaussSeidelear(A2, x2, b2, 1e-9);
    disp(res, "Gauss-Seidel para la segunda matriz: ");
    disp(A2*res, "Para checkear, la multiplicamos por A2: ");
    disp(b2, "Esto es lo que debía dar: ");
//end

/// Parte c) ///
for i = 1:72
    mprintf("*");
end
mprintf("\nParte c)\n");
mprintf("Como resolver la primer matriz si ninguno de los dos métodos funciona?");
disp(jacobear(A2, x2, b2, 1e-2), "Con 1e-2 de tolerancia la matriz 2 da: ");
for i = 1:72
    mprintf("*");
end

//// Ejercicio 2

mprintf("\n<<< Ejercicio 2) >>>\n");
for i = 1:72
    mprintf("*");
end

//// Ejercicio 5, robado a Gonza :3

function [sol, iter]=SOR(A,b,x0,tol)
    iter = 0;
    n = size(A, 1);
    D = diag(diag(A));
    D = inv(D);
    ant = x0;
    S = max(abs(spec(eye(n,n) - D*A)))
    w = 2/(1+sqrt(1-S^2));
   while ( %T )
    for i=1:n
     aux1 = 0; 
     for j=1:i-1
        aux1 = aux1 + A(i,j)*sol(j)
     end
     aux2 = 0;
     for j=i+1:n
        aux2 = aux2 + A(i,j)*ant(j)
     end
     
     sol(i) = w/A(i,i) * (b(i) - aux1 - aux2) + (1 - w)*ant(i)
     iter = iter + 1;
    end
    disp(sol);
    disp(ant);
    if norm(sol - ant) < tol
        break;
     end
     ant = sol;
   end
endfunction
