clear
clc

function y = serie(n)
      y = (1.0 / (n * (n + 2.0))) - (-(1.0/3.0))^n
endfunction

function y = subSerie(n)
    y = (-(1.0/3.0))^n;
endfunction

ret1 = 0.0;
for n = 1:10^4
    ret1 = ret1 + serie(n);
end

ret2 = 0.0;
for n = 1:10^4
    ret2 = ret2 + subSerie(n);
end

mprintf("%.25f\n", ret1);
mprintf("%.25f\n", ret2);

//SALIDA DEL PROGRAMA:
// 0.9999000149975061368934348
//-0.2500000000000000555111512
// Devuelta, no es taaan relevante al ejercicio, pero son calculos que utilice
// para ayudarme y tener un mejor panorama del problema.
