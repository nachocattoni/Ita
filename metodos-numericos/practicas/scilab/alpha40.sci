clear; clc;
// Descomposición de Cholesky                                                //
//                                                                           //
// A: Matriz hermitiana y definida positiva                                  //
// L: Matriz triangular inferior tal que LL* = A (L* es la conjugada         //
// transpuesta).                                                             //

function L = Cholesky(A)
    n = size(A, 1)
    L = zeros(n, n)
    L(1,1) = sqrt(A(1,1))
    if( n > 1 )
        L(2:n,1) = A(2:n,1) / L(1,1)
        L(2:n,2:n) = Cholesky(A(2:n, 2:n) - L(2:n,1) * L(2:n,1)')
    end
endfunction

EJ_CholeskyA = [ 16 -12  8  -16; 
                -12  18 -6   9;
                 8  -6   5  -10;
                -16  9  -10 46];
EJ_CholeskyB = [ 4   12 -16;
                 12  37 -43;
                -16 -43  98];

// Descomposición QR                                                         //
//                                                                           //
// A: Matriz real cuadrada                                                   //
// Q: Matriz ortogonal                                                       //
// R: Matriz triangular superior                                             //
//                                                                           //
// No es numericamente estable.                                              //

function [Q, R] = QR(A)
    [n, m] = size(A)
    Q = zeros(n, n)
    Q(:,1) = A(:,1) / norm(A(:,1))
    for i = 2:n
        w = A(:,i)
        for j = 1:i-1
            w = w - (Q(:,j)'*A(:,i)) * Q(:,j)
        end
        Q(:,i) = w / norm(w)
    end
    R = Q'*A
endfunction

// Radio Espectral                                                           //
//                                                                           //
// A: Matriz cuadrada                                                        //
// r: Máximo valor absoluto de los autovalores de A (radio espectral)        //

function r = radioEspectral(A)
    r = max(abs(real(spec(A))))
endfunction

// Check Jacobi                                                              //
//                                                                           //
// Determina si la matriz de iteración del método de Jacobi tiene radio      //
// espectral menor que 1. Si lo tiene, la función devuelve true y es apta    //
// para utilizar Jacobi, si no, aún puede ser diagonal dominante y Jacobi    //
// aún puede funcionar.                                                      //

function b = checkJacobi(A)
    try
        D = diag(diag(A))
        R = A - D
        b = radioEspectral( diag(1 ./ diag(D)) * R ) < 1 
    catch
        b = %f
    end
    // Agregar el método general de la norma
endfunction

// Método de Jacobi                                                          //
//                                                                           //
// A, x, b: Describen el sistema de ecuaciones, x es aproximación inicial    //
// tol: Tolerancia requerida, por defecto 1e-4                               //
// iter: Cantidad de iteraciones a realizar, por defecto 15k                 //
// y: Aproximación de la solucion                                            //
// cnt: Cantidad de iteraciones realizadas realmente                         //
//                                                                           //
// Sea D = diag(A)                                                           //
// x_sig = (I - inv(D) * A) * x + inv(D) * b                                 //

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

EJ_JacobiA1 = [0  2  4;
               1 -1 -1;
               1 -1  2];
EJ_Jacobib1 = [0 0.375 0]';
EJ_Jacobix1 = [5 7 10]';

EJ_JacobiA2 = [ 1 -1  0; 
               -1  2 -1; 
                0 -1  1.1];
EJ_Jacobib2 = [0 1 0]';
EJ_Jacobix2 = [1 4 3]';

// Método de Gauss-Seidel                                                    //
//                                                                           //
//                                                                           //

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
        if(norm(x - y) < tol)
            break;
        end
        x = y;
    end
endfunction

// Minimos Cuadrados                                                  //

function [p, err] = MinimosCuadrados(x, y, k)
    n = length(x)
    X = ones(n, k+1)
    for i = 1:n
        for j = 1:k
            X(i,j+1) = x(i)**j
        end
    end
//    a = inv(X'*X)*X'*y 
    a1 = linsolve(X'*X,-X'*y)
    a2 = GaussSeidel(X'*X, -X'*y, y, 1e-1, 5)
    disp(norm(a1 - a2), "Ojo, la dif con linsolve es")
    a = a2
    p = poly(a, "x", "coeff")
    err = y - X * a
endfunction

X = [0 0.15 0.31 0.5 0.6 0.75]'
Y = [1 1.004 1.031 1.117 1.223 1.422 ]'
p = MinimosCuadrados(X, Y, 5)
X2 = 0:0.01:1
plot(X2,horner(p,X2))
plot2d(X, Y,-1)
