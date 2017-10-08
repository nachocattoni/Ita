clear
clc

format(10);

function [P, L, U] = Gauss(A)
    m = size(A, 1);
    
    U = A;
    L = eye(m, m);
    P = eye(m, m);
    
    for k = 1:m-1
        mx = U(k, k);
        i = k;
        for j = k+1:m
            if(abs(U(j, k)) > mx)
                mx = U(j, k);
                i = j;
            end
        end
        U([k, i], k:m) = U([i, k], k:m);
        L([k, i], 1:k-1) = L([i, k], 1:k-1);
        P([k, i],:) = P([i, k],:);
        for j = k+1:m
            L(j, k) = U(j, k) / U(k, k);
            U(j, k:m) = U(j, k:m) - L(j, k)*U(k, k:m);
        end
    end
endfunction

A = [2 1 1 0; 4 3 3 1; 8 7 9 5; 6 7 9 8];

[P, L, U] = Gauss(A);

disp(P);
disp(L);
disp(U);

disp(abs(P*A - L*U) < 1e-18)

// SALIDA DEL PROGRAMA.
//    0.    0.    1.    0.  
//    0.    0.    0.    1.  
//    0.    1.    0.    0.  
//    1.    0.    0.    0.  
// 
//    1.      0.           0.           0.  
//    0.75    1.           0.           0.  
//    0.5   - 0.2857143    1.           0.  
//    0.25  - 0.4285714    0.3333333    1.  
// 
//    8.    7.      9.           5.         
//    0.    1.75    2.25         4.25       
//    0.    0.    - 0.8571429  - 0.2857143  
//    0.    0.      0.           0.6666667  
// 
//  T T T T  
//  T T T T  
//  T T T T  
//  T T T T  
