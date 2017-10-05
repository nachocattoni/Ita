clear
clc

//// Retorna la representación binaria de un número en Scilab, como 
//// dos listas (parte entera y decimal) de tamaño fijo.
function [E, D] = my_dec2bin (x)
    ent = floor(x);
    dec = x - ent;
    
    step = 30;
    while(step >= 1)
        E(step) = modulo(ent, 2);
        ent = floor(ent / 2);
        step = step - 1;
    end
    
    step = 30;
    while(step >= 1)
        dec = dec * 2;
        D(step) = floor(dec);
        dec = dec - floor(dec);
        step = step - 1;
    end
    
    E = E'
    D = D'
endfunction

//// Inversa de my_dec2bin
function x = my_bin2dec(E, D)
    x = 0;
    for i = 1:30
        x = x + E(i) * 2^(30 - i)
    end
    for i = 1:30
        x = x + D(i) * 2^(i - 31)
    end
endfunction

