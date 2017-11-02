
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

function p = minicuadrar(x, y)
    
endfunction

Y = [1.0 1.2214 1.4918 1.8221]
X = 0:0.2:0.6

p = interlagrangear(X, Y)


