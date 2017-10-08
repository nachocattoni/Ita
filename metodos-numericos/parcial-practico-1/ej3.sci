clear
clc

format(25)

//// Parte a), me ayude graficando la funcion
function y = f(x)
    y = atan(x);
endfunction

x = -5:1e-1:1.5;
plot(x, f(x));

//// Parte b), resuelvo usando el metodo
function y = df(x)
    y = 1 / (1 + x^2);
endfunction

function r = newtar(f, x1, err)
    x0 = x1 - err - 1;
    while( norm(x1 - x0) > err )
        ant = x1;
        x1 = x1 - inv(df(x1))*f(x1);
        x0 = ant;
    end
    r = x1;
endfunction

//// Vemos que para el punto inicial -4.2 el metodo no converge!
//// Lamentablemente, nuestro metodo de Newton funciona para obtener el valor
//// correcto cuando la sucesion de puntos converge, sin embargo, si no 
//// si no converge, obtenemos un mensaje de error. De todas formas, este
//// mensaje de error nos dice que el metodo no converge!
//// disp(newtar(f, -4.2, 1e-9));
//////////SALIDA DE ESTA PARTE:
//////////  !--error 19 
//////////Problem is singular.
//////////at line       5 of function newtar called by :  
//////////disp(newtar(f, -4.2, 1e-9));
//////////at line      34 of exec file called by :    
//////////exec('/home/alumno/Escritorio/ej3.sci', -1)

//// En cambio, si comenzamos en el punto x0 = 1, el metodo converge al valor 0.
disp("La raiz es:");
disp(newtar(f, 1, 1e-9));
//SALIDA DE ESTA PARTE:
//La raiz es:   
// 
//    0.  

//// Parte c):

//// Lo comienzo con una iteracion de biseccion para que tenga sentido con el
//// ejercicio, ya que hay que inicializarlo con un intervalo.
function y = safeNewton(f, a, b, err)
    x = (a + b) / 2.0;
    while %T
        
    end
endfunction

// No logro comprender como puedo usar el metodo de la biseccion si el punto se
// va de rango. Estamos garantizados de que uno de los puntos va a tener 
// imagen menor que cero y el otro mayor que cero? por que?.
// Eso es algo de lo que me falta ver para el ejercicio, ademas, el metodo de 
// Newton que conozco necesita de un solo valor inicial, mientras que el 
// descripto aca, necesita de dos (segun enunciado), no es tan importante igual,
// supongo que el "intervalo" que se usa es el de los dos puntos anteriores.
