
clear();

function D = difinitar(x, y)
    //D(i,j) = f[x_i ... x_j]
    n = length(y)
    D = diag(y)
    for j = 2:n
        for i = j-1:-1:1
            D(i,j) = (D(i+1, j) - D(i, j-1))/(x(j)-x(i))
        end
    end
endfunction

function p = internewtar(x, y)
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
    n = length(x)
    p = poly([1], "x", "coeff")
    for m = 1:n
        if m == j then continue; end
        p = p * poly(x(m),"x","roots") / (x(j)-x(m))
    end
endfunction

function p = interlagrangear(x, y)
    p = poly([0], "x", "coeff")
    n = length(y)
    for i = 1:n
       p = p + Lkar(i, x) * y(i) 
    end
endfunction

function p = minicuadrar(x, y, k)
    n = length(x)
    X = ones(n, k+1)
    for i = 1:n
        for j = 1:k
            X(i,j+1) = x(i)**j
        end
    end
    a = inv(X'*X)*X'*y
    p = poly(a, "x", "coeff")
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
disp(p)
err = poly([-1 1 2 4], "x", "roots")
//plot(-1:0.1:4, abs(horner(p, -1:0.1:4)))
err = 37 * 33.6 / 24
disp(err)

clc();

/// Ej 6
X = [0 0.15 0.31 0.5 0.6 0.75]'
Y = [1 1.004 1.031 1.117 1.223 1.422 ]'
p = minicuadrar(X, Y, 3)
X2 = 0:0.01:1
plot(X2,horner(p,X2))
plot2d(X, Y,-1)
