clear
clc

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

function [p, err] = MinimosCuadrados(x, y, k)
    n = length(x)
    X = ones(n, k+1)
    for i = 1:n
        for j = 2:k
            if j == 2 then
                X(i,j) = cos(x(i))
            else
                X(i,j) = sin(x(i))
            end
        end
    end
    disp(X);
    p = Gauss(X'*X, X'*y)
endfunction

X = [-%pi/2, 0, %pi/2]'
Y = [1, 0, 1/2]'

MinimosCuadrados(X, Y, 3)

// Acá perdí :( no llegué con el tiempo para dejar los otros ejercicios mejor,
// porque no estaba muy afilado con mínimos cuadrados si no era para obtener
// un polinomio. Al hacer esto, obtengo que el determinante es cero, lo adjunto
// para que vean que lo intenté jaja.

// SALIDA, por si la querés

//    1.    6.12323400D-17  - 1.    1.  
//    1.    1.                0.    1.  
//    1.    6.12323400D-17    1.    1.  
// !--error 10000 
//Argiroffo informs: ¡El determinante es cero, nene!
//at line       5 of function Gauss called by :  
//at line      14 of function MinimosCuadrados called by :  
//MinimosCuadrados(X, Y, 3)
//at line      50 of exec file called by :    
//exec('/home/alumno/Escritorio/scilab/ej3.sci', -1)
