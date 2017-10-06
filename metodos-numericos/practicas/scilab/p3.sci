clc
clear

function y = f1(x)
    y = cos(x).*cosh(x)+1;
endfunction

function y = f2(x)
    y = x.*x - sin(x) .*2;
endfunction

function y = f3(x)
    y = exp(-x) - x.^4;
endfunction

function y = f4(x)
    y = x - log(x) - 1;
endfunction

function y = f5(x)
    y = x.*x/4 - sin(x);
endfunction

function y = f(x)
    y = x^3
endfunction

function y = g(x)
    y = (x^2 - 1) / 3;
endfunction

function y = f6(x)
    g = 9.8
    T = 5
    h = 4
    y = 4.* %pi.^2 / (g .* T.*T .* tanh(h.*x)) - x
endfunction


function y = f7(x)
    y1 = x(1).^2 + x(1).*x(2).^3 - 9
    y2 = 3*x(1).^2*x(2)  - 4 - x(2).^3
    y = [y1;y2]
endfunction

function y = f8(x)
    y(1) = 2  + exp(2*x(1)^2 + x(2)^2) * 4 * x(1)
    y(2) = 6 * x(2) + exp(2*x(1)^2 + x(2)^2) * 2 * x(2)
endfunction

function y = f8_campo(x)
    y = 2.*x(1) + 3.*x(2)^2 + exp(2.*x(1)^2 + x(2)^2)
endfunction

function r = bisecar(f, a, b, err)
    
    while( b-a > err )
        m = (a + b) / 2
        if( sign(f(a)) * sign(f(m)) < 1 )
            b = m;
        else
            a = m;
        end
    end
    r = m;
endfunction

//// Iteración de punto fijo, f función, p0 aproximación inicial,
//// err es la tolerancia dada, y n la cantidad máxima de repeticiones.
function p = fixear(f, p0, err, n)
    for i = 1:n
        p = f(p0);
        if norm(p - p0) < err then
            mprintf("El método de punto fijo fue exitoso! vamos los pibes!")
            return;
        end
        p0 = p
    end
    mprintf("El método de punto fijo no fue exitoso\n");
endfunction

//// Otro método de punto fijo, g es la función, x la estimación inicial
//// y err la tolerancia.
function x = puntofijar(g, x, err)
    ant = x
    x = g(x)
    while norm( x - ant ) > err
        ant = x
        x = g(x)
    end
endfunction

function r = secar(f, x0, x1, err)
    while(abs(x1 - x0) > err)
        ant = x1
        x1 = x1 - f(x1).*(x1 - x0)./(f(x1) - f(x0))
        x0 = ant;
    end
    r = x1;
endfunction


function r = newtar(f, x1, err)
    x0 = x1 - err - 1
    while( norm(x1 - x0) > err )
        ant = x1
        x1 = x1 - inv(numderivative(f, x1))*f(x1)
        x0 = ant;
    end
    r = x1;
endfunction

//// Implementación de Roman
function r = falsear(f, a, b, err)
    ant = a - err
    while( b-a > err )
        m = (a * f(b) - b * f(a)) / (f(b) - f(a))
        disp(m)
        if( norm(m-ant) < err ) break; end
        if( sign(f(a)) * sign(f(m)) < 1 )
            b = m;
        else
            a = m;
        end
        ant = m
    end
    r = m;
endfunction

//// Implementada desde el Burden y Faires
function r = falsiar(f, p0, p1, err, n)
    q0 = f(p0);
    q1 = f(p1);
    for i = 2:n
        p = p1 - q1*(p1 - p0)/(q1 - q0);
        if norm(p - p1) < err then
            r = p;
            mprintf("Regula falsi finalizó con éxito (increíble)\n");
            return;
        end
        q = f(p)
        if q*q1 < 0 then
            p0 = p1;
            q0 = q1;
        end
        p1 = p
        q1 = q
    end
    mprintf("Regula falsi falló horriblemente (huh, como siempre)\n");
endfunction

//// Recibe las dimensiones, un multiplicador, y una tolerancia, 
//// se fija si converge el método de Newton en puntos aleatorios de la
//// dimensión especificada con la tolerancia requerida.
//// Valores recomendados si no tenés idea: mul = 10, err = 1
function aleatoriar(dim, mul, err)
    while %T
        try
            r = newtar(f, mul * random(1, dim), err);
            if find(isnan(r)) then continue; else break; end
        catch
            continue
        end
    end
endfunction

x = (-0:0.0001:0.2);

//plot(x, f6(x))
//plot(x, x);

//r = secar(f6, 0.1, 1, 0.1)
//r2 = bisecar(f, 1.7, 1, 0.1)
r = newtar(f8, [1 ; 1], 1e-12)

//disp(r)
//disp(r2)
disp(r)
p = f8_campo(r)
disp(p)

[J, H] = numderivative(f8_campo, r, [], [],  "blockmat")

disp("pepe")
disp(spec(H))

x0 = 1
for(i = 1:30)
    x0 = f6(x0)
end



