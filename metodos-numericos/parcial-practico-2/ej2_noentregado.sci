clear
clc
format(15)

function [cota_inf, cota_sup] = Gershgorin(A)
    // Devuelve la cota inferior y la cota superior de los autovalores
    // Tambien hace un plot, que da mas informacion...
    cota_inf = 0;
    cota_sup = 0;
    n = size(A, 1);
    for i=1:n
        centro(i) = A(i, i);
        radio(i) = sum(abs(A(i,:))) - A(i, i);
        cota_inf = min(cota_inf, centro(i) - radio(i));
        cota_sup = max(cota_sup, centro(i) + radio(i));
    end
    
    x = [cota_inf:1e-2:cota_sup];
    for i=1:n
        plot(x, sqrt( radio(i)^2 - (x - centro(i)).*(x - centro(i)) ));
        plot(x, -sqrt( radio(i)^2 - (x - centro(i)).*(x - centro(i)) ));
    end
endfunction+

function r = RadioEspectral(A)
    r = max(abs(real(spec(A))))
endfunction

a = 1/2 // algún valor en [0, 1/2]
A = [0 1/4 1/6; 5/9 0 a; 1/3 1/5 0]
B = A; B(2, 3) = 0

x0 = [1531353155 2135000 313513500]'
while %T
    x1 = B*x0
    if norm(x0 - x1) < 1e-10 then
        break
    end
    x0 = x1
end

mprintf("Papi, papi, converjo!")
Gershgorin(A)
