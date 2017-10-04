//// EJERCICIO 1 ////
//// Resolvente robusta

clc
clear

function r = raices(p)
  // p is a polynomial
  c = coeff(p, 0)
  b = coeff(p, 1)
  a = coeff(p, 2)
  if (b < 0)
      r(1) = 2*c/(-b + sqrt(b^2 - 4*a*c))
      r(2) = (-b + sqrt(b^2 - 4*a*c))/2/a;
  else
      r(1) = (-b - sqrt(b^2 - 4*a*c))/2/a;
      r(2) = 2*c/(-b - sqrt(b^2 - 4*a*c))
  end
endfunction

p = poly([-1e-7 1e7 1e-7], "x", "c")
roots1 = roots(p)
roots2 = raices(p)

e1 = 1e-8
r1 = roots1(2)
r2 = roots2(2)
disp(r1, r2)

error1 = abs(r1 - e1) / e1
error2 = abs(r2 - e1) / e1

printf("Esperado:\t%e\n", e1)
printf("raices:\t\t%e\t%e\n", r2, error2);
printf("roots:\t\t%e\t%e\n", r1, error1)

//// EJERCICIO 3 b ////
//// Algoritmo de Horner

clc
clear

function y = myHorner(p, x0)
    c = coeff(p);
    n = degree(p) + 1;
    y = c(n);
    for i = n-1:-1:1
        y = y*x0 + c(i);
    end
endfunction

p = poly([1 4 -2 3], "x", "coeff");

mprintf("The answer is %d\n", myHorner(p, -1));
mprintf("The answer is %d\n", myHorner(p, 3));
mprintf("The answer is %d\n", myHorner(p, 0));

//// EJERCICIO 3 d ////
//// Algoritmo de Horner (generalización, calcula derivada)

clc
clear

function y = mySuperHorner(p, x0)
    c = coeff(p);
    n = degree(p) + 1;
    y(1) = c(n);
    y(2) = y(1)
    for i = n-1:-1:1
        y(1) = y(1)*x0 + c(i);
        y(2) = y(2)*x0 + y(1);
    end
    y(2) = y(2) - y(1)
endfunction

p = poly([1 4 -2 3], "x", "coeff");

mprintf("The answer is %d\n", mySuperHorner(p, 1))

//// EJERCICIO 4 ////
//// Derivada n-ésima

clc
clear

function y = derivar(f, v, n, h)
    if n == 0 then
        y = f(v)
    else
        y = (derivar(f, v + h, n - 1, h) - derivar(f, v, n - 1, h)) / h
    end
endfunction

function y = nth_derivar(f, x, n)
    if(n == 0)
        y = f(x) 
    else
        old = 'f';
        for i=1:n
            new = 'd'+string(i)+'f';
            deff('y='+new+'(x)','y=numderivative('+old+',x)');
            old=new;
        end
        deff('y=ff(x)', 'y=d'+string(n)+'f(x)')
        y = ff(x)
    end
endfunction

//// EJERCICIO 5 ////
//// Polinomio de Taylor

clc
clear
xdel(winsid())
format(25)

function y = f(x)
    y = x.^4
endfunction

function y = g(x)
    y = exp(x)
endfunction

// Calcula el valor de la n-ésima derivada de f en
// el punto x.
function y = nth_derivar(f, x, n)
    if(n == 0)
        y = f(x) 
    else
        old = 'f';
        for i=1:n
            new = 'd'+string(i)+'f';
            deff('y='+new+'(x)','y=numderivative('+old+',x)');
            old=new;
        end
        deff('y=ff(x)', 'y=d'+string(n)+'f(x)')
        y = ff(x)
    end
endfunction

// Calcula el polinomio de Taylor de la función f
// de grado n, alrededor del punto a y lo evalua
// en x.
function y = taylorear(f, a, n, x)
    y = 0;
    for k=0:n
        y = y + nth_derivar(f, a, k) * (x - a)^k / factorial(k)
    end
endfunction

disp(taylorear(g, -1.5, 2, -2))
