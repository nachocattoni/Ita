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

function r = RadioEspectral(A)
    r = max(abs(real(spec(A))))
endfunction

// Diagonal Dominante                                                        //
//                                                                           //
// A: Matriz cuadrada                                                        //
// y: %T en caso de ser A una matriz diagonal dominante                      //

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

// Simétrica                                                                 //
//                                                                           //
// A: Matriz cuadrada                                                        //
// y: %T en caso de ser A una matriz simétrica (o hermitiana)                //

function y = Simetrica(A)
    y = and(abs(A - A') < 1e-15);
endfunction

// Definida Positiva                                                         //
//                                                                           //
// A: Matriz de la cual se quiere averiguar si es definida positiva          //
// y: %T si todos los autovalores son positivos, es decir, si es definida    //
// positiva.                                                                 //

function y = DefinidaPositiva(A)
    y = and(real(spec(A)) > 1e-15);
endfunction

// Check Jacobi                                                              //
//                                                                           //
// Determina si la matriz de iteración del método de Jacobi tiene radio      //
// espectral menor que 1. Si lo tiene, la función devuelve true y es apta    //
// para utilizar Jacobi, si no, aún puede ser diagonal dominante y Jacobi    //
// aún puede funcionar.                                                      //
// La matriz de iteración de Jacobi es inv(D)*R, si esa matriz tiene norma   //
// menor que uno, entonces converge y NO ESTA CHECKADO ACA.                  //

function b = CheckJacobi(A)
    D = diag(diag(A))
    R = A - D
    try
        b = RadioEspectral( diag(1 ./ diag(D)) * R ) < 1 
    catch
        b = DiagonalDominante(A)
        if ~b then
            try
                b = norm(diag(1 ./ diag(D)) * R) < 1 // puede usarse cualquier norm
            end
        end
    end
    // Agregar el método general de la norma
endfunction

// Check Gauss                                                               //
//                                                                           //
// Determina si la matriz es apta para aplicar el método de Gauss-Seidel     //
// Para serlo, debe ser diagonal dominante, o bien, simétrica y definida     //
// positiva.                                                                 //
// Descomponer A en L D U, donde D es diag(diag(A)), la matriz de iteración  //
// de Gauss Seidel es inv(D - L)*U, si eso tiene alguna norma que de menor   //
// que 1, entonces también converge.                                         //

function y = CheckGauss(A)
    y = DiagonalDominante(A) | (Simetrica(A) & DefinidaPositiva(A));
    if ~y then
        try 
            D = diag(diag(A))
            L = tril(A) - D
            U = (tril(A') - D)'
            disp(D, L, U);
            y = norm(inv(D - L)*U) < 1; // puede usarse cualquier norm
        catch
            y = %f
        end
    end
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
// Usar la conveniente "CheckGauss" en A, antes que querer usar esto         //
// A, x, b: Sistema de ecuaciones normal, con x siendo una aproximación      //
// inicial de la solución.                                                   //
// tol; Tolerancia, por defecto es 1e-9                                      //
// iter: Cantidad de iteraciones, por defecto, 15k                           //

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

// Sustitución Regresiva                                                     //
//                                                                           //
// Resuelve el sistema de ecuaciones Ax = b, con A triangular inferior.      //

function x = SustitucionRegresiva(A, b)
    n = size(A, 1)
    x(n) = b(n) / A(n, n)
    for i = n-1:-1:1
        x(i) = (b(i) - A(i,i+1:n) * x(i+1:n)) / A(i,i)
    end
endfunction

// Método de Gauss                                                           //
//                                                                           //
// Resuelve el sistema de ecuaciones Ax = b dando como resultado la matriz   //
// P de permutacion de filas, la solucion x, y deja a A como triangular      //
// inferior.                                                                 //

function [x, P, A, b] = Gauss(A, b)
    n = size(A, 1)
    P = eye(n, n)
    if( det(A) == 0 )
        error("Argiroffo informs: ¡El determinante es cero, nene!")
    end
    for i = 1:n
        mx = A(i, i)
        idmx = i
        for j = i+1:n
            if(abs(A(j, i)) > mx)
                mx = A(j, i)
                idmx = j
            end
        end
        A([i, idmx],:) = A([idmx, i],:)
        P([i, idmx],:) = P([idmx, i],:)
        b([i, idmx]) = b([idmx, i])
        for j = i+1:n
            m = A(j,i) / A(i,i)
            A(j,:) = A(j,:) - m * A(i,:)
            b(j) = b(j) - m * b(i)
        end
    end
    x = SustitucionRegresiva(A, b)
endfunction

// Minimos Cuadrados                                                         //
//                                                                           //
// x, y: descripción de los puntos, no necesariamente distintos en x         //
// k: grado del polinomio que querés                                         //
// p: polinomio que querés, que minimiza la suma de las diferencias al       //
// cuadrado con los puntos dados como dato, de grado k                       //
// err: error                                                                //

function [p, err] = MinimosCuadrados(x, y, k)
    n = length(x)
    X = ones(n, k+1)
    for i = 1:n
        for j = 1:k
            X(i,j+1) = x(i)**j
        end
    end
    a = Gauss(X'*X, X'*y)
    p = poly(a, "x", "coeff")
    err = y - X * a
endfunction

// Método de Sobrerelajación                                                 //
//                                                                           //

function [sol, iter]=SOR(A,b,x0,tol)
    iter = 0;
    n = size(A, 1);
    D = diag(diag(A));
    D = inv(D);
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
    disp(sol);
    disp(ant);
    if norm(sol - ant) < tol
        break;
     end
     ant = sol;
   end
endfunction

// Método de la Potencia                                                     //
//                                                                           //
// A: Matriz de la cual se quiere calcular el autovalor de mayor valor abs.  //
// zv: Estimación inicial del autovector, probar varias estimaciones, ya que //
// si zv comienza siendo un autovector asociado a algun otro autovalor, el   //
// método de va a quedar 'estancado' ahi.                                    //
// iter: Cantidad de iteraciones, por defecto son 500                        //

function [vector, lambda] = Potencia(A, zv, iter)
    // zv es un vector inicial, iter cantidad de iteraciones
    // metodo de la potencia, aproxima el autovalor de mayor
    // valor absoluto, y su autovector asociado
    if ~exists("iter", "local") then
        iter = 500
    end
    
    n = size(A, 1);
    for rep=1:iter
        wn = A*zv;
        zn = wn / norm(wn, 'inf');
        for k=1:n
            if(abs(zn(k)) > 1e-12)
                lambda = wn(k) / zv(k);
                break;
            end
        end
        zv = zn;
    end
    vector = zn;
endfunction

// Gershgorin                                                                //
//                                                                           //
// A: Matriz cuadrada                                                        //
// cota_inf, cota_sup: Dan cotas a los autovalores                           //
// Esta función también grafica los círculos de Gershgorin, y es fácilmente  //
// modificable para obtener el intervalo de la recta real que cubre cada     //
// círculo.                                                                  //

function [cota_inf, cota_sup] = Gershgorin(A)
    // Devuelve la cota inferior y la cota superior de los autovalores
    // Tambien hace un plot, que da mas informacion...
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

//,Diferencias Divididas                                                    //
//                                                                          //
// x, y: Descripción de la nube de puntos                                   //
// D: Matriz de diferencias divididas, D(i, j) = f[x_i ... x_j]             //

function D = DiferenciasDivididas(x, y)
    n = length(y)
    D = diag(y)
    for j = 2:n
        for i = j-1:-1:1
            D(i,j) = (D(i+1, j) - D(i, j-1))/(x(j)-x(i))
        end
    end
endfunction

// Interpolación Newton                                                     //
//                                                                          //
// x, y: Descripción de n + 1 puntos                                        //
// p: Polinomio de grado n, que pasa por los n + 1 puntos, es único.        //

function p = InterpolacionNewton(x, y)
    n = length(x)
    D = DiferenciasDivididas(x, y)
    p = poly([0], "x", "coeff")
    n_j = poly([1], "x", "coeff")
    for i = 0:n-1
        p = p + D(1,i+1) * n_j
        n_j = n_j * poly(x(i+1), "x", "roots")
    end
endfunction

// Productorio de Lagrange                                                  //
//                                                                          //
// j: Número de elemento a ignorar                                          //
// x: Descripción de los puntos                                             //
// p: Productorio desde i = 1 hasta i = n, con i != j, de                   //
// (x - x(i)) / (x(k) - x(i).                                               //

function p = ProdLagrange(j, x)
    n = length(x)
    p = poly([1], "x", "coeff")
    for m = 1:n
        if m == j then continue; end
        p = p * poly(x(m),"x","roots") / (x(j)-x(m))
    end
endfunction

// Interpolación Lagrange                                                   //
//                                                                          //
// x, y: Descripción de los n + 1 puntos                                    //
// p: Polinomio de grado n, que pasa por los n + 1 puntos, es único.        //

function p = InterpolacionLagrange(x, y)
    p = poly([0], "x", "coeff")
    n = length(y)
    for i = 1:n
       p = p + ProdLagrange(i, x) * y(i) 
    end
//    El polinomio P(x) = Sumatorio {desde k = 1 hasta n} [ L_k(x) * y(k)]
endfunction

// Puntos de Chebyshev                                                      //
//                                                                          //
// n: Cantidad de puntos a obtener, para aproximar polinomios con grado m,  //
// debe ser n = m + 1, de esa manera se pasan luego los m + 1 puntos para   //
// interpolar y se obtiene polinomio de grado m.                            //
// a, b: Intervalo en el cual obtener los puntos                            //
// r: Arreglo con los mejores puntos para hacer una interpolación           //

function r = PuntosChebyshev(n, a, b)
    r = zeros(n,1)
    for k = 0:n-1
        r(k+1) = (b - a) / 2 * cos(%pi * (2 * k + 1) / (2 * n)) + (a + b) / 2
    end
endfunction

// Método del Trapecio                                                      //
//                                                                          //
// f: Función a integrar                                                    //
// a, b: Intervalo de integración                                           //
// n: Cantidad de intervalos              .                                 //
// Devuelve una aproximación de la integral definida entre a y b usando n   //
// puntos, su error es: h^2 (b-a) / 12 * max(abs(f''(x))) para x entre      //
// a y b, siendo h = (b - a) / n.                                           //

function I = Trapecio(f, a, b, n)
    h = (b - a) / n
    I = 0.5 * (f(a) + f(b))
    for k = 1:n-1
        x = a + k * h
        I = I + f(x)
    end
    I = I * h
endfunction

// Método de Simpson                                                        //
//                                                                          //
// f: Función a integrar                                                    //
// a, b: Intervalo de integración                                           //
// n: Cantidad de intervalos, debe ser par.                                 //
// Devuelve una aproximación de la integral definida entre a y b usando n   //
// puntos, su error es: -h^4 * (b-a) / 180 * max(abs(f''''(x)))             //
// para x entre a y b, y siendo h = (b - a)/n                               //

function I = Simpson(f, a, b, n)
    h = (b - a) / n
    I = f(a) + f(b)
    for k = 1:n-1
        x = a + k * h
        if modulo(k,2) == 1 then
            I = I + 4 * f(x)
        else
            I = I + 2 * f(x)            
        end
    end
    I = I * h/3
endfunction

// Método del Trapecio, en dos dimensiones                                  //
//                                                                          //
// a < b, n: cantidad de divisiones sobre x                                 //
// c < d, m: cantidad de divisiones sobre y                                 //
// f: Función en dos variables a integrar en [a, b] y [c, d]                //
// I: Resultado de la aproximación de la integral, no vimos su error.       //
// En caso de querer integrar algo que no tiene dominio rectangular,        //
// la función como 0 fuera del dominio.                                     //

function [I]=DoubleIntegralTrap(a, b, n, c, d, m, f)
    Dx = (b - a)/n;
    Dy = (d - c)/m;
    x = zeros(1,n+1);
    y = zeros(1,m+1);
    F = zeros(n+1,m+1);
    for i = 1:n+1
        x(1,i) = a + (i-1)*Dx;
    end;
    for j = 1:m+1
        y(1,j) = c + (j-1)*Dy;
    end;
    for i = 1:n+1
        for j = 1:m+1
            F(i,j) = f(x(1,i),y(1,j));
        end;
    end;
    I = F(1,1) + F(1,m+1) + F(n+1,1) + F(n+1,m+1);
    for i = 2:n
        I = I + 2*(F(i,1) + F(i,m+1));
    end;
    for j = 2:m
        I = I + 2*(F(1,j) + F(n+1,j));
    end;
    for i = 2:n
        for j = 2:m
            I = I + 4*F(i,j);
        end;
    end;
    I = I*Dx*Dy/4;
endfunction

// Método de Simpson, en dos dimensiones                                  //
//                                                                          //
// a < b, n: cantidad de divisiones sobre x                                 //
// c < d, m: cantidad de divisiones sobre y                                 //
// f: Función en dos variables a integrar en [a, b] y [c, d]                //
// I: Resultado de la aproximación de la integral, no vimos su error.       //
// En caso de querer integrar algo que no tiene dominio rectangular,        //
// la función como 0 fuera del dominio.                                     //

function [I]=DoubleIntegralSimp(a, b, n, c, d, m, f)
    Dx = (b - a)/n;
    Dy = (d - c)/m;
    
    x = zeros(1,n+1);
    y = zeros(1,m+1);
    
    Rx = zeros(1, n+1);
    Ry = zeros(1, m+1);
    
    F = zeros(n+1,m+1);
    for i = 1:n+1
        x(1,i) = a + (i-1)*Dx;
    end;
    for j = 1:m+1
        y(1,j) = c + (j-1)*Dy;
    end;
    for i = 1:n+1
        for j = 1:m+1
            F(i,j) = f(x(1,i),y(1,j));
        end;
    end;
    
    resto = 2
    for i = 1:n+1
        Rx(i) = resto
        resto = 6 - resto
    end
    Rx(1) = 1
    Rx(n + 1) = 1
    
    resto = 2
    for i = 1:m+1
        Ry(i) = resto
        resto = 6 - resto
    end
    Ry(1) = 1
    Ry(m + 1) = 1    
    
    R = Rx' * Ry
    I = sum(F .* R)/9 * Dx * Dy 
endfunction
