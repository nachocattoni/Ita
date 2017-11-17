
clear();

function D = difinitar(x, y)
    //D(i,j) = f[x_i ... x_j] DIFERENCIAS DIVIDIDAS
    n = length(y)
    D = diag(y)
    for j = 2:n
        for i = j-1:-1:1
            D(i,j) = (D(i+1, j) - D(i, j-1))/(x(j)-x(i))
        end
    end
endfunction

function p = internewtar(x, y)
    // para una interp de grado n, pasar n+1 puntos
    n = length(x)
    D = difinitar(x, y)
    p = poly([0], "x", "coeff")
    n_j = poly([1], "x", "coeff")
    for i = 0:n-1
        p = p + D(1,i+1) * n_j
        n_j = n_j * poly(x(i+1), "x", "roots")
    end
endfunction

function p = Lkar(j, x)
//     L_k(x) = Productorio{ desde i = 0, i != k hasta n}[ (x - x(i)) / (x(k) - x(i))]
    n = length(x)
    p = poly([1], "x", "coeff")
    for m = 1:n
        if m == j then continue; end
        p = p * poly(x(m),"x","roots") / (x(j)-x(m))
    end
endfunction

function p = interlagrangear(x, y)
    // para una interp de grado n-1, pasar n puntos
    p = poly([0], "x", "coeff")
    n = length(y)
    for i = 1:n
       p = p + Lkar(i, x) * y(i) 
    end
//    El polinomio P(x) = Sumatorio {desde k = 1 hasta n} [ L_k(x) * y(k)]
endfunction

function [p, err] = minicuadrar(x, y, k)
    n = length(x)
    X = ones(n, k+1)
    for i = 1:n
        for j = 1:k
            X(i,j+1) = x(i)**j
        end
    end
//    a = inv(X'*X)*X'*y 
    a = linsolve(X'*X,-X'*y)
    p = poly(a, "x", "coeff")
    err = y - X * a
endfunction

function p = chebyshevear(n)
    if n == 0 then
        p = poly([1], "x", "coeff")
    end
    if n == 1 then
        p = poly([0 1], "x", "coeff")                        
    end
    if n > 1 then
      for k = 1:n
           p = 2 * poly([0 1],"x","coeff") * chebyshevear(n-1) - chebyshevear(n-2)
        end
    end
endfunction

function r = getchebypointar(n, a, b)
    /// PARA APROXIMAR POLINOMIOS DE GRADOS N, PASAR N+1 ASI OBTENES N+1 PUNTOS
    /// DA LOS MEJORES PUNTOS EN LOS CUALES INTERPOLAR (ESCRITO POR MAXI, PUEDE ESTAR MAL :v)
    r = zeros(n,1)
    for k = 0:n-1
        r(k+1) = (b - a) / 2 * cos(%pi * (2 * k + 1) / (2 * n)) + (a + b) / 2
    end
endfunction

/// EJ 1
Y = [1.0 1.2214 1.4918 1.8221]
X = 0:0.2:0.6
/// a
p = interlagrangear(X, Y)
v = horner(p, 1/3)
/// b
p = poly(X, "x", "roots")
//plot(0:0.001:0.6,abs(horner(p,0:0.001:0.6)))
err = 0.0016 * exp(0.6) /24
disp(err)
disp(abs(v - 1.395612425))

/// EJ3

Y = [0.2239 0.16666 0.1104 0.0555 0.0025 -0.0484]
X = 2:0.1:2.5
p = internewtar(X, Y)
disp(horner(p, 2.15))
disp(horner(p, 2.35))

/// EJ4
p = internewtar(0:3, [1 3 3 3])
disp(horner(p, 2.5))

///Ej 5
p = poly([2], "x", "coeff") 
p = p + 1 * poly([-1], "x", "roots")
p = p + (-2) * poly([-1 1], "x", "roots")
p = p + (2) * poly([-1 1 2], "x", "roots")
//disp(p)
err = poly([-1 1 2 4], "x", "roots")
//plot(-1:0.1:4, abs(horner(p, -1:0.1:4)))
err = 37 * 33.6 / 24
disp(err)

clc();

/// Ej 6
//X = [0 0.15 0.31 0.5 0.6 0.75]'
//Y = [1 1.004 1.031 1.117 1.223 1.422 ]'
//p = minicuadrar(X, Y, 3)
//X2 = 0:0.01:1
//plot(X2,horner(p,X2))
//plot2d(X, Y,-1)


/// Ej 7
//X = [ 4, 4.2, 4.5, 4.7, 5.1, 5.5, 5.9, 6.3, 6.8, 7.1]'
//Y = [ 102.56 113.18 130.11 142.05 167.53 195.14 224.87 256.73 299.5 326.72]'
//
//[p3, err] = minicuadrar(X,Y,3)
//[p2, err] = minicuadrar(X,Y,2)
//
//X2 = 4:0.1:7.1
//
//plot2d(X, Y,-1)    
//for i = 0:100
//    p = minicuadrar(X, Y, i)
//    plot(X2,horner(p,X2),"r")
//    sleep(500)
//end
//
//
//disp(err' * err)

// Ej 8

//Al hacer crecer n, 
//Para valores cercanos a cero, el error converge a cero,
//mientras que para valores lejanos a éste, e.g., -5, diverge
//a infinito.

//function y = f(x)
//    y = 1 ./ (1 + x .* x) 
//endfunction
//
//disp("pepe")
//clf()
//
//for n = [2 4 6 10 14 ]
//    X = -5:(10/n):5
//    Pn = internewtar(X', f(X'))
//    X2 = -4:0.1:4
//    plot(X2', f(X2') - horner(Pn, X2'), "r")
//    sleep(1000)
//    
//end 


// Ej 9
//T4 = chebyshevear(4)
//X = roots(T4 / 8)
//Y = exp(X)
//p = internewtar(X, Y)
//
//// funcion
//X2 = -1:0.01:1
//plot(X2,horner(p,X2))
//
//plot2d(X, Y,-1)
//disp(T4/8)
//
//disp(X)
//disp(getchebypointar(4,-1,1))
//
//// error
//clf();
//plot(X2, abs(exp(X2) - horner(p, X2)),"r")


//Ej 10
clf()
X = getchebypointar(4,0,%pi/2)
X2 = 0:0.1:%pi/2
Y = cos(X)
p = internewtar(X, Y)
plot(X2', cos(X2'), "r")
plot(X2', horner(p, X2'), "b")
