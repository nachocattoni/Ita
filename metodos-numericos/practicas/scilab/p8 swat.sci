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

function r = suma(x, y)
    r = x + y
endfunction

function g = fijarx(f, x)
    deff('r = g(y)', 'r = f(' + string(x) + ',y)')
endfunction

function I = Simpsonar2D(f, a, b, cc, dd, n)
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
            
            I = I + w*f(x, y)
        end
    end
    I = I * hx * hy
endfunction

//function I = Simpsonar2D(f, xa, xb, ya, yb, xn, yn)
//    /// LA CANTIDAD DE INTERVALOS n DEBE SER PAR
//    h = (xb - xa) / xn
//    
//    I = f(xa, ) + f(b)
//    for k = 1:n-1
//        x = a + k * h
//        if modulo(k,2) == 1 then
//            I = I + 4 * f(x)
//        else
//            I = I + 2 * f(x)            
//        end
//    end
//    I = I * h/3
////    El error es
////    -h^4 * (b-a) / 180 * max(abs(f''''(x))) para x entre a y b
//endfunction

//function I = Simponar2D(f, xa, xb, ya, yb, xn, yn)
//    I = Simpsonar( )
//endfunction

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

// Ej 2

deff('y = f(x)', 'y = 1/x')
I = trapeciar(f, 1, 3, 4)
disp(I)
disp(intg(1,3,f))

