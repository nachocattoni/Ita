clear
clc
format(15)

function r = RadioEspectral(A)
    r = max(abs(real(spec(A))))
endfunction

function y = DiagonalDominante(A)
    n = size(A, 1);
    for i=1:n
        if(2 * abs(A(i, i)) < sum(abs(A(i,:))))
            y = %F
            return;
        end
    end
    y = %T
endfunction

function y = Simetrica(A)
    y = and(abs(A - A') < 1e-15);
endfunction

function y = DefinidaPositiva(A)
    y = and(real(spec(A)) > 1e-15);
endfunction

function b = CheckJacobi(A)
    D = diag(diag(A))
    R = A - D
    try
        b = RadioEspectral( diag(1 ./ diag(D)) * R ) < 1 
    catch
        b = DiagonalDominante(A)
        if ~b then
            try
                b = norm(diag(1 ./ diag(D)) * R) < 1
            end
        end
    end
endfunction

function [y, cnt] = Jacobi(A, x, b, tol, iter)
    if ~exists("iter", "local") then
        iter = 15000
    end
    if ~exists("tol", "local") then
        tol = 1e-9
    end
    
    n = size(A, 1);
    y = x;
    
    cnt = 0
    while cnt < iter
        cnt = cnt + 1
        for i=1:n
            guarda = A(i, i);
            A(i, i) = 0;
            y(i) = (b(i) - A(i,:)*x) / guarda;
            A(i, i) = guarda;
        end
        if(norm(x - y) < tol)
            break;
        end
        x = y;
    end
endfunction

function [y, cnt] = GaussSeidel(A, x, b, tol, iter)
    if ~exists("iter", "local") then
        iter = 15000
    end
    if ~exists("tol", "local") then
        tol = 1e-9
    end
   
    n = size(A, 1);
    y = x;
    
    cnt = 0
    while cnt < iter
        cnt = cnt + 1
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
        if(norm(x - y) <= tol)
            break;
        end
        x = y;
    end
endfunction

function [sol, iter]=SOR(A,b,x0,tol)
    iter = 0;
    n = size(A, 1);
    D = diag(diag(A));
    D = 1 ./ D;
    ant = x0;
    S = max(abs(real(spec(eye(n,n) - D*A))))
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
    if norm(sol - ant) < tol
        break;
     end
     ant = sol;
   end
endfunction

A = [ 3 -2  1  0  0  0;
     -2  4 -2  1  0  0;
      1 -2  4 -2  1  0;
      0  1 -2  4  -2 1;
      0  0  1 -2  4 -2;
      0  0  0  1  -2 3];

b = [10 -8 10 10 -8 10];


if(Simetrica(A) & DefinidaPositiva(A))
    // a) Si la matriz es simétrica y definida positiva, entonces podemos
    // utilizar el método de Gauss-Seidel, y este va a converger. Es una
    // de las condiciones suficientes.
    
    // b) Una vez que sabemos que converge, podemos utilizar el método de 
    // GaussSeidel que implementamos para obtener el resultado con el
    // criterio de terminación requerido.
    [v, cnt] = GaussSeidel(A, zeros(6, 1), b, 1e-6)
    disp("Utilizando el método de Gauss-Seidel")
    disp(cnt, "Cantidad de iteraciones")
    disp(v, "Valor resultado")
    disp(A*v, "Multiplicando por A") // #
    disp(b, "Valor teórico objetivo") // #
end

// c) Probando otros métodos iterativos.

// Aquí vemos que Jacobi no necesariamente converge, hasta donde sabemos
disp(CheckJacobi(A), "Estamos garantizados de la convergencia de Jacobi?")

// Aquí lo aplicamos de todos modos, porque aún así puede ser que converga.
// De hecho, converge, pero necesita de unas 45 iteraciones, como indica la
// salida de este programa, de manera que no acelera la velocidad de 
// convergencia obtenida con el método de Gauss-Seidel.
[v, cnt] = Jacobi(A, zeros(6, 1), b, 1e-6)
disp("Utilizando el método de Jacobi")
disp(cnt, "Cantidad de iteraciones")
disp(v, "Valor resultado")
disp(A*v, "Multiplicando por A") // #
disp(b, "Valor teórico objetivo") // #

// Por otro lado, quizás aplicar SOR funcione, pero no se de la teoría de 
// este método, y utilizarlo resulta en un bucle infinito (probar en el
// modo interactivo). Por lo tanto asumo que no funciona correctamente para
// este tipo de matrices (quizás un retoque funcione, no se como hacerlo).

// Comentar las lineas que terminan en "// #" para mayor legilibilidad de la
// salida de este programa.

// SALIDA
  
// Utilizando el método de Gauss-Seidel   
// 
// Cantidad de iteraciones   
// 
//    25.  
// 
// Valor resultado   
// 
//    2.000000236763  
//  - 0.000000080781  
//    3.999999672788  
//    3.999999852125  
//    0.000000106059  
//    2.000000119998  
// 
// Multiplicando por A   
// 
//    10.00000054464  
//  - 8.000000290101  
//    9.999999491285  
//    9.999999890023  
//  - 7.999999847222  
//    10.             
// 
// Valor teórico objetivo   
// 
//    10.  - 8.    10.    10.  - 8.    10.  
// 
// Estamos garantizados de la convergencia de Jacobi?   
// 
//  F  
// 
// Utilizando el método de Jacobi   
// 
// Cantidad de iteraciones   
// 
//    45.  
// 
// Valor resultado   
// 
//    2.00000018306   
//  - 0.000000154599  
//    4.000000067486  
//    4.000000067482  
//  - 0.000000154596  
//    2.000000183057  
// 
// Multiplicando por A   
// 
//    10.00000092586  
//  - 8.000001052006  
//    10.00000047264  
//    10.00000047261  
//  - 8.000001051975  
//    10.00000092584  
// 
// Valor teórico objetivo   
// 
//    10.  - 8.    10.    10.  - 8.    10.  
