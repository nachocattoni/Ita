clear
clc

// Matrices de Ejemplo
A = [1 -1 2 -1; 2 -2 3 -3; 1 1 1 0; 1 -1 4 3]
b = [-8 -20 -2 4]'
A_LU = [1.012, -2.132, 3.104; -2.132, 4.096, -7.013; 3.104, -7.013, 0.014]
A_paxb = [1 2 -2 1; 4 5 -7 6; 5 25 -15 -3; 6 -12 -6 22]
b_paxb = [1 2 0 1]'

function [x, A, b] = gaussear(A, b)
    n = size(A, 1)
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
        b([i, idmx]) = b([idmx, i])
        for j = i+1:n
            m = A(j,i) / A(i,i)
            A(j,:) = A(j,:) - m * A(i,:)
            b(j) = b(j) - m * b(i)
        end
    end
    x = remontar(A, b)
endfunction

function x = remontar(A, b)
    n = size(A, 1)
    x(n) = b(n) / A(n, n)
    for i = n-1:-1:1
        x(i) = (b(i) - A(i,i+1:n) * x(i+1:n)) / A(i,i)
    end
endfunction

// Calcula la factorizacion LU sin swaps
function [L, U] = doolittlear(A)
    n = size(A, 1)
    L = eye(n, n)
    if( det(A) == 0 )
        error("Argiroffo informs: ¡El determinante es cero, nene!")
    end
    for i = 1:n
        for j = i+1:n
            m = A(j,i) / A(i,i)
            L(j, i) = m
            A(j,:) = A(j,:) - m * A(i,:)
        end
    end
    U = A
endfunction

function [x, P, A, b] = paxbear(A, b)
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
    x = remontar(A, b)
endfunction

function [P, L, U] = paeleuear(A)
    [nada1, P, nada2, nada3] = paxbear(A, A(1))
    A = P*A
    [L, U] = eleuear(A)
endfunction

// calcula crout
function [L, U] = croutear(A)
    [U L]= doolittlear(A')
    L = L'
    U = U'
endfunction

function L = choleskear(A)
    n = size(A, 1)
    L = zeros(n, n)
    L(1,1) = sqrt(A(1,1))
    if( n > 1 )
        L(2:n,1) = A(2:n,1) / L(1,1)
        L(2:n,2:n) = choleskear(A(2:n, 2:n) - L(2:n,1) * L(2:n,1)')
    end
endfunction
