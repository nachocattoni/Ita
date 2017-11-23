clc()
clear()
/// PRACTICA 8

function I = Simpsonar(f, a, b, n)
    /// LA CANTIDAD DE INTERVALOS n DEBE SER PAR
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
//    El error es
//    -h^4 * (b-a) / 180 * max(abs(f''''(x))) para x entre a y b
endfunction

function I = trapeciar(f, a, b, n)
    h = (b - a) / n
    I = 0.5 * (f(a) + f(b))
    for k = 1:n-1
        x = a + k * h
        I = I + f(x)
    end
    I = I * h
//    El error es 
//    h^2 (b-a) / 12 * max(abs(f''(x))) para x entre a y b
endfunction

// SE BANCA PASAR FUNCIONES COMO ARGUMENTOS EN Y
function I = Trapeciar2D(f, a, b, cc, dd, n)
    /// CANT INTERVALOS N DEBE SER PAR
    hx = (b - a) / n
    for kx = 0:n
        x = a + kx*hx
        
        // asumo que ambas son funciones
        if(typeof(cc) == "function")
            c = cc(x)
            d = dd(x)
        else
            c = cc
            d = dd
        end

        subI = 0
        hy = (d - c) / n
        for ky = 0:n
            y = c + ky*hy
            
            w = 1
            
            if(kx == 0 | kx == n)
                w = w / 2 
            end
            
            if(ky == 0 | ky == n)
                w = w / 2
            end
            
            subI = subI + w*f(x, y)
        end
        subI = subI * hy
        
        I = I + subI
    end
    I = I * hx
endfunction

/// Ej 1

//I = Simpsonar(log, 1, 2, 20)
//Ireal = 2 * log(2) - 1
//disp(I)
//disp(Ireal)
//disp( -0.05^4 / 180 * 6)
//
//I = trapeciar(log, 1, 2, 20)
//Ireal = 2 * log(2) - 1
//disp(I)
//disp(Ireal)
//disp( 0.05^2 / 12 )


function [I]=DoubleIntegralTrap(a, b, n, c, d, m, f)
//    TRAPECIO 2D
//    a < b, n: cantidad de divisiones sobre x
//    c < d, m: cantidad de divisiones sobre y

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
    //end of DoubleIntegral function
endfunction

function [I]=DoubleIntegralSimp(a, b, n, c, d, m, f)
//    SIMPSON 2D
//    a < b, n: cantidad de divisiones sobre x
//    c < d, m: cantidad de divisiones sobre y

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
    //disp(F)
    I = sum(F .* R)/9 * Dx * Dy 
    //end of DoubleIntegral function
endfunction

// Ej 2

//deff('y = f(x)', 'y = 1/x')
//I = trapeciar(f, 1, 3, 4)
//disp(I)
//disp(intg(1,3,f))

function z = f(x, y)
//    z = 1 / (%pi * sqrt(x * (1-x)))
    z = sin(x + y)
endfunction

z1 = DoubleIntegralSimp(0, 1, 2, 0, 2, 2, f)
disp(z1)
