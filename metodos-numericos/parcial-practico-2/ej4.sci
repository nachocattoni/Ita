clear
clc
format(15)

function I = Trapecio(f, a, b, n)
    h = (b - a) / n
    I = 0.5 * (f(a) + f(b))
    for k = 1:n-1
        x = a + k * h
        I = I + f(x)
    end
    I = I * h
endfunction

function I = Simpson(f, a, b, n)
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
endfunction

function y = f(x)
    y = (x .^ 3) .* (log(x))
endfunction

I = intg(1, 2, f) // Por defecto, este valor tiene un error absoluto menor
                  // que 1e-14, por lo tanto, como solo requerimos una
                  // aproximación con error menor que 1e-5, podemos comparar
                  // nuestro valor con el de I como si I fuera el verdadero.

// TRAPECIO
n = 1 // Este será el primer valor para el cual el error es menor que 1e-5
while %T
    v = Trapecio(f, 1, 2, n)
    if norm(I - v) < 1e-5 then
        break
    end
    n = n + 1
end

val_correcto = Trapecio(f, 1, 2, n)
val_incorrecto = Trapecio(f, 1, 2, n - 1)
mprintf("Trapecio: Utilizando %d intervalos:\n -> obtenemos %.10f\n -> error de %.10f\n", n, val_correcto, norm(I - val_correcto));
mprintf("Trapecio: Utilizando %d intervalos:\n -> obtenemos %.10f\n -> error de %.10f\n\n", n-1, val_incorrecto, norm(I - val_incorrecto))

// SIMPSON
n = 1 // Este será el primer valor para el cual el error es menor que 1e-5
while %T
    v = Simpson(f, 1, 2, n)
    if norm(I - v) < 1e-5 then
        break
    end
    n = n + 1
end

val_correcto = Simpson(f, 1, 2, n)
val_incorrecto = Simpson(f, 1, 2, n - 1)
mprintf("Simpson: Utilizando %d intervalos:\n -> obtenemos %.10f\n -> error de %.10f\n", n, val_correcto, norm(I - val_correcto));
mprintf("Simpson: Utilizando %d intervalos:\n -> obtenemos %.10f\n -> error de %.10f\n\n", n-1, val_incorrecto, norm(I - val_incorrecto))

// SALIDA

// Trapecio: Utilizando 308 intervalos:
// -> obtenemos 1.8350986643
// -> error de 0.0000099421
//Trapecio: Utilizando 307 intervalos:
// -> obtenemos 1.8350987292
// -> error de 0.0000100070
//
//Simpson: Utilizando 8 intervalos:
// -> obtenemos 1.8350943519
// -> error de 0.0000056296
//Simpson: Utilizando 7 intervalos:
// -> obtenemos 1.6128517093
// -> error de 0.2222370130
