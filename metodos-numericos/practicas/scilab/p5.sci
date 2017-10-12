clear
clc
format(20)

// Checkear radio espectral:
// D = diag(diag(A))
// R = A - D
// max(abs(spec(inv(D)*R)))
// Si eso da menor que 1 converge desde cualquier punto

function res = jacobear(A, x, b)
    n = size(A, 1);
    rep = 5000;
    res = x;
    while(rep > 0)
        for i = 1:n
            guarda = A(i, i);
            A(i, i) = 0;
            res(i) = (b(i) - A(i,:)*x) / guarda;
            A(i, i) = guarda;
        end
        x = res;
        rep = rep - 1; 
    end
endfunction

A1 = [0 2 4; 1 -1 -1; 1 -1 2];
b1 = [0 0.375 0]';
x1 = [5 7 10]';

A2 = [1 -1 0; -1 2 -1; 0 -1 1.1];
b2 = [0 1 0]';
x2 = [1 4 3]';

res = jacobear(A2, x2, b2);
disp(res);
disp(A2*res);
disp(b2);
