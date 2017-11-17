// Usar esto para ir chequeando los valores en cada iteración
// mprintf("X: %f | ",x); mprintf("Y: %f | ",y); mprintf("C: %f | ",c); mprintf("i: %d | ",i); mprintf("f(c): %f\n",f(c));

// ##################################################################
// ##################### Método de la bisección #####################
// ##################################################################
function [res,count] = biseccion(f,a,b,err)
  if sign(f(a)) == sign(f(b)) then
    disp("Los puntos a y b deben tener imágenes con signo opuesto");
  elseif f(a) == 0 then
    res = a; count = 0;
  elseif f(b) == 0 then
    res = b; count = 0;
  else        
    x = a; y = b; c = (x+y)/2; count = 1;
    
    if sign(f(x)) <> sign(f(c)) then
      y = c
    else
      x = c
    end
        
    if abs(y - x) <= err | relative_error(y,x,err) <= err | f(c) == 0 then
      res = c;
    else
      while abs(y - x) > err & relative_error(y,x,err) > err & f(c) <> 0
        c = (x+y)/2;
        count = count + 1;
        
        if sign(f(x)) <> sign(f(c)) then
          y = c
        else
          x = c
        end
      end
      
      res = c;
    end
  end
endfunction



// ################################################################
// ####################### Método de Newton #######################
// ################################################################
function [res,count] = newton(f,a,err)
  x = a;
  derf = numderivative(f,x,0.0001,4);
  
  if derf == 0 then
    mprintf("La derivada de f en uno de los pasos es 0\n Dentengo el algoritmo.\n");
    res = 0; count = 0;
    break;
  else
    y = x - (f(x)/derf);
    count = 1;
    
    if abs(y - x) <= err | relative_error(y,x,err) <= err | f(y) == 0 then
      res = y;
    else
      while abs(y - x) > err & relative_error(y,x,err) > err & f(y) <> 0
        x = y;
        derf = numderivative(f,x,0.0001,4);        
        
        if derf == 0 then
          mprintf("La derivada de f en uno de los pasos es 0\n Dentengo el algoritmo.\n");
          res = 0; count = 0;
          break;
        else
          y = x - (f(x)/derf);
          count = count + 1;
          mprintf("X: %f | ",x); mprintf("Y: %f | ",y); mprintf("count: %d\n",count);
        end
      end
      
      res = y;
    end
  end
endfunction



// ##########################################################################
// ##################### Método de Newton multivariable #####################
// ##########################################################################
function [res,count] = newton_multivar(f,a,err,p)
  x = a;
  jacob = numderivative(f,x,0.0001,4);
    
  if det(jacob) == 0 then
    mprintf("El jacobiano de f en uno de los pasos es 0\n Dentengo el algoritmo.\n");
    res = 0; count = 0;
  else
      
    y = x - inv(jacob) * f(x);
    count = 1;
    mprintf("X1: %f | ",x(1)); mprintf("X2: %f | ",x(2)); mprintf("Y1: %f | ",y(1)); mprintf("Y2: %f | ",y(2)); mprintf("count: %d\n",count);
    if norm(y - x) <= err | relative_error(y,x,err) <= err | f(y) == 0 | count == p then
      res = y;
    else
      while norm(y - x) > err & relative_error(y,x,err) > err & f(y) <> 0 & count <> p
        x = y;
        jacob = numderivative(f,x,0.0001,4);
  
        if det(jacob) == 0 then
          mprintf("El jacobiano de f en uno de los pasos es 0\n Dentengo el algoritmo.\n");
          res = 0; count = 0;
        else        
          y = x - inv(jacob) * f(x);
          count = count + 1;
          mprintf("X1: %f | ",x(1)); mprintf("X2: %f | ",x(2)); mprintf("Y1: %f | ",y(1)); mprintf("Y2: %f | ",y(2)); mprintf("count: %d\n",count);
        end
      end
      
      res = y;
    end
  end
endfunction




// ################################################################
// ##################### Método de la secante #####################
// ################################################################
function [res,count] = secante(f,a,b,err)
  x = a;
  y = b;
  aux = f(y) - f(x);
  
  if aux == 0 then
    mprintf("La resta de f(x1) - f(x0) en uno de los pasos es 0.\n Dentengo el algoritmo.\n");
    res = 0; count = 0;
    break;
  else
  
    c = y - f(y) * ((y - x)/(f(y) - f(x)))
    count = 1;
    
    if abs(c - y) <= err | relative_error(c,y,err) <= err | f(c) == 0 then
        res = c;
    else
      while abs(c - y) > err & relative_error(c,y,err) > err & f(c) <> 0
        x = y;
        y = c;
        
        if aux == 0 then
          mprintf("La resta de f(x1) - f(x0) en uno de los pasos es 0.\n Dentengo el algoritmo.\n");
          res = 0; count = 0;
          break;
        else
          c = y - f(y) * ((y - x)/aux)
          count = count + 1;
        end
      end
        
      res = c;
    end
  end
endfunction



// ################################################################
// ######################### Regula falsi #########################
// ################################################################
function [res,count] = regula_falsi(f,a,b,err)
  if sign(f(a)) == sign(f(b)) then
    disp("Los puntos a y b deben tener imágenes con signo opuesto");
  elseif f(a) == 0 then
    res = a; count = 0;
  elseif f(b) == 0 then
    res = b; count = 0;
  else        
    x = a; y = b; c = y - f(y) * ((y - x)/(f(y) - f(x))); count = 1;
    
    if sign(f(x)) <> sign(f(c)) then
      y = c
    else
      x = c
    end
        
    if abs(y - x) <= err | relative_error(y,x,err) <= err | f(c) == 0 then
      res = c;
    else
      while abs(y - x) > err & relative_error(y,x,err) > err & f(c) <> 0
        c = y - f(y) * ((y - x)/(f(y) - f(x)));
        count = count + 1;
        
        if sign(f(x)) <> sign(f(c)) then
          y = c
        else
          x = c
        end
      end
      
      res = c;
    end
  end
endfunction



// ################################################################
// ##################### Método de punto fijo #####################
// ################################################################

//v = linspace(0.1,7,500);
//deff("z=g(x)","z = exp(x)/(3*x)");
//deff("z=id(x)","z = x");
//gv = apply(g,v);
//idv = apply(id,v);
//plot2d(v, [gv idv], rect=[0,0,7,5], leg="y=g(x)@y=x")

function [res,count] = punto_fijo(g,a,err)
  x = a;
  y = g(x);
  i = 0;
  
  if abs(y - x) <= err | relative_error(y,x,err) <= err | y == 0 then
    res = y; count = 1;
  else
    while abs(y - x) > err & relative_error(y,x,err) > err & y <> 0
      x = y;
      y = g(x);
      i = i + 1;
    end
    
    res = y; count = i;
  end
endfunction


// #########################################################################################################################
// ############################################## Factorización de matrices ################################################
// #########################################################################################################################



// ##################################################################
// ######################## Gauss sin pivoteo #######################
// ##################################################################
function [u,bp,res] = gauss_sin_pivoteo(m,b)
    [filas, columnas] = size(m);
    
    a = m;
    c = b;
    
    for i = 1:filas
      for j = (i+1):filas
        mul = a(j,i)/a(i,i);

        a(j,:) = a(j,:) - mul*a(i,:);
        c(j) = c(j) - mul*c(i);
      end
    end
    
    // Creo x como un vector columnas con todos 0.
    x = zeros(filas,1);
    
    // Obtengo x con sustitución regresiva
    for i = filas:-1:1
      j = i+1;
      if i == filas then
        x(i) = c(i)/a(i,i)
      else
        x(i) = (1/a(i,i)) * (c(i) - a(i,j:filas)*x(j:filas))
      end
    end
    
    u = a;   // Matriz triangular superior
    bp = c;  // Vector columna b modificado por las multiplicaciones
    res = x; // Resultado del sistema
endfunction


// ##################################################################
// ######################## Gauss con pivoteo #######################
// ##################################################################
//function [u,bp,res] = gauss_con_pivoteo(m,b)
//  n = size(m,1);
//  
//  if n <> length(b) then
//    printf("El primer y segundo argumento deben tener la misma cantidad de n\n");
//  else
//    a = m;
//    c = b;
//        
//    for i = 1:n
//      if a(i,i) == 0  then
//                
//        for k = i:n
//          if a(fila_pivot_no_0,k) <> 0 then break else end
//        end
//        
//        // Intercambio la i-ésima fila (que tiene 0 en el pivote) por
//        // la primer fila que encuentre cuyo pivote sea distinto de 0
//        fila_ia = a(i,:);
//        ci = c(i)
//        a(i,:) = a(fila_pivot_no_0,:);
//        a(fila_pivot_no_0,:) = fila_ia;
//        c(i) = c(k);
//        c(k) = ci;
//      else
//      end
//      
//      for j = (i+1):n
//        mul = a(j,i)/a(i,i);
//        a(j,:) = a(j,:) - mul*a(i,:);
//        c(j) = c(j) - mul*c(i);
//      end
//    end
//    
//    // Creo x como un vector columnas con todos 0.
//    //x = zeros(filas,1);
//    
//    // Obtengo x con sustitución regresiva
//    x = sustitucion_regresiva(a,c);
//    
//    u = a;   // Matriz triangular superior
//    bp = c;  // Vector columna b modificado por las multiplicaciones
//    res = x; // Resultado del sistema
//  end
//endfunction


// ##################################################################
// ######################## Gauss con pivoteo #######################
// ##################################################################
function [u,bp,res] = gauss_con_pivoteo(m,b)
  n = size(m,1);
  
  if n <> length(b) then
    printf("El primer y segundo argumento deben tener la misma cantidad de n\n");
  else
    a = m;
    c = b;
        
    for i = 1:n            
      // Busco la fila cuyo pivot en valor absoluto sea el máximo
      vect = abs(a(i:n,i));
      k = i - 1 + find(vect == max(vect));
      //#########################################################
      
      if i <> k  then
        fila_pivot_0 = i;
        fila_pivot_no_0 = k;
        
        // Intercambio la i-ésima fila por la fila con el máximo pivote
        // que encuentre en la columna desde la fila i hacia abajo
        fila_0a = a(fila_pivot_0,:);
        c0 = c(fila_pivot_0);
        
        // fila de a con pivote 0     <----->     fila de a con pivote máximo
        a(fila_pivot_0,:) = a(fila_pivot_no_0,:);
        a(fila_pivot_no_0,:) = fila_0a;
        // c(fila_pivot_0)            <----->     c(fila_pivot_no_0)
        c(fila_pivot_0) = c(fila_pivot_no_0);
        c(fila_pivot_no_0) = c0;
        //######################################################
      else
        fila_pivot_0 = 0;
        fila_pivot_no_0 = 0;
      end
      
      for j = (i+1):n
        mul = a(j,i)/a(i,i);
        a(j,:) = a(j,:) - mul*a(i,:);
        c(j) = c(j) - mul*c(i);
      end
    end
    
    // Creo x como un vector columnas con todos 0.
    //x = zeros(filas,1);
    
    // Obtengo x con sustitución regresiva
    x = sustitucion_regresiva(a,c);
    
    u = a;   // Matriz triangular superior
    bp = c;  // Vector columna b modificado por las multiplicaciones
    res = x; // Resultado del sistema
  end
endfunction




// ##################################################################
// ######################## Factorización LU ########################
// ##################################################################
function [l,u,p,bp,res] = factorizacion_lu(m,b)
  [filas, columnas] = size(m);
  
  if filas <> length(b) then
    printf("El primer y segundo argumento deben tener la misma cantidad de filas\n");
  else
    a = m;
    c = b;
    perm = diag(ones(filas,1));     // Matriz de permutación
    mMult = diag(ones(filas,1)); // Matriz de multiplicadores
    
    for i = 1:columnas
      
      // Busco la fila cuyo pivot en valor absoluto sea el máximo
      vect = abs(a(i:filas,i));
      k = i - 1 + find(vect == max(vect));
      //#########################################################
      
      if i <> k  then
        fila_pivot_0 = i;
        fila_pivot_no_0 = k;
        
        // Intercambio la i-ésima fila (que tiene 0 en el pivote) por
        // la primer fila que encuentre cuyo pivote sea distinto de 0
        fila_0a = a(fila_pivot_0,:);
        c0 = c(fila_pivot_0)
        fila_0p = perm(fila_pivot_0,:);
        
        // fila de a con pivote 0     <----->     fila de a con pivote máximo
        a(fila_pivot_0,:) = a(fila_pivot_no_0,:);
        a(fila_pivot_no_0,:) = fila_0a;
        // c(fila_pivot_0)            <----->     c(fila_pivot_no_0)
        c(fila_pivot_0) = c(fila_pivot_no_0);
        c(fila_pivot_no_0) = c0;
        // perm(fila_pivot_0,:)       <----->     perm(fila_pivot_no_0,:)
        perm(fila_pivot_0,:) = perm(fila_pivot_no_0,:);
        perm(fila_pivot_no_0,:) = fila_0p;
        //######################################################
      else
        fila_pivot_0 = 0;
        fila_pivot_no_0 = 0;
      end
      
      for j = (i+1):filas
        mul = a(j,i)/a(i,i);
        
        a(j,:) = a(j,:) - mul*a(i,:);
        c(j) = c(j) - mul*c(i);
        mMult(j,i) = mul;  
      end
      
      // Intercambio los multiplicadores, calculados previamente,
      // de las filas fila con pitot 0 y fila con pivot distinto de 0
      if i > 1 & fila_pivot_0 <> 0 then
        aux = mMult(fila_pivot_0,1:i-1)
        mMult(fila_pivot_0,1:i-1) = mMult(fila_pivot_no_0,1:i-1)
        mMult(fila_pivot_no_0,1:i-1) = aux
      else
      end
      //######################################################
    end
    
    y = sustitucion_progresiva(mMult,perm*b);
    x = sustitucion_regresiva(a,y);
    
    l = mMult; // Matriz triangular inferior
    u = a;     // Matriz triangular superior
    p = perm;  // Matriz de permutación
    bp = c;    // Vector columna b modificado por las multiplicaciones
    res = x;   // Resultado del sistema
  end
endfunction


// ##################################################################
// ##################### Factorización Doolittle ####################
// ##################################################################
function [ti,ts] = doolittle(A)
  [filas,columnas] = size(A);
  
  l = diag(ones(filas,1));
  u = zeros(filas,columnas);
  
  for j = 1:columnas
    u(1,j) = A(1,j)
  end
  
  for i = 2:filas
    for j = 1:columnas
      if j == 1 then
        l(i,j) = A(i,j)/u(j,j)
      elseif j < i then
        l(i,j) = (A(i,j) - (l(i,1:j-1)*u(1:j-1,j)))/u(j,j)
      else
        u(i,j) = A(i,j) - (l(i,1:i-1)*u(1:i-1,j))
      end
    end
  end
  ti = l;
  ts = u;
endfunction


// ##################################################################
// ########################## Gram-Schmidt ##########################
// ##################################################################

function q = gram_schmidt(x)
  u(1) = x(1)/norm(x1)
  
  for k = 2:length(x)
    c = 0;
    for i = 1:(k-1)
      ui = u(i);
      suma = suma + (x(k)'*ui)*ui 
    end
    w = x(i) - suma
    u(k) = w/norm(w)
  end
  
  q = u;
endfunction


// ##################################################################
// ############################ Cholesky ############################
// ##################################################################

function rm = cholesky(A)
  [filas,columnas] = size(A);

  for i = 1:filas
    if i == 1 then
      R(i,1) = sqrt(A(i,1));
    else
      R(i,1) = A(i,1)/R(1,1);
    end
  end

  for i = 2:filas
    for j = 2:i
      if i == j then
        R(i,j) = sqrt(A(i,j) - sum(R(i,1:j-1)*R(i,1:j-1)'));
      else
        R(i,j) = (A(i,j) - R(i,1:j-1)*R(j,1:j-1)')/R(j,j)
      end
    end
  end
  
  rm = R;
endfunction


// ##################################################################
// ##################### Sustitución regresiva ######################
// ##################################################################
function m = sustitucion_regresiva(u,y)
    [filas, columnas] = size(u);
    
    // Creo x como un vector columna con todos 0.
    x = zeros(filas,1);
    //######################################################
    
    for i = filas:-1:1
      j = i+1;
      if i == filas then
        x(i) = y(i)/u(i,i)
      else
        x(i) = (1/u(i,i)) * (y(i) - u(i,j:columnas)*x(j:columnas))
      end
    end
    
    m = x;
endfunction

// ##################################################################
// ##################### Sustitución progresiva #####################
// ##################################################################
function res = sustitucion_progresiva(l,b)
    [filas, columnas] = size(l);
    
    // Creo x como un vector columna con todos 0.
    y = zeros(filas,1);
    //######################################################
    
    y(1) = b(1)/l(1,1)
    
    for i = 2:filas
      j = i-1;
      y(i) = (1/l(i,i)) * (b(i) - l(i,1:j)*y(1:j));
    end
    
    res = y;
endfunction




// #########################################################################################################################
// ############################ Métodos iterativos para resolución de sistemas de ecuaciones ###############################
// #########################################################################################################################


// #############################################################################
// ############################## FORMA SUMATORIA ##############################
// #############################################################################


// ##################################################################
// ################### Método de JACOBI SUMATORIA ###################
// ##################################################################
function [res,count] = jacobi_iter(A, b, x, err)
    n = size(A, 1)
    
    sig(1) = (b(1) - A(1,2:n)*x(2:n))/A(1,1);
  
    for i = 2:n
      if i <> n then
        sig(i) = (b(i) - A(i,1:i-1)*x(1:i-1) - A(i,i+1:n)*x(i+1:n))/A(i,i)
      else
        sig(i) = (b(i) - A(i,1:i-1)*x(1:i-1))/A(i,i)
      end
    end
    
    count = 1;
    disp(sig)
    while norm(sig - x) > err
      x = sig;
      sig(1) = (b(1) - A(1,2:n)*x(2:n))/A(1,1);
    
      for i = 2:n
        if i <> n then
          sig(i) = (b(i) - A(i,1:i-1)*x(1:i-1) - A(i,i+1:n)*x(i+1:n))/A(i,i)
        else
          sig(i) = (b(i) - A(i,1:i-1)*x(1:i-1))/A(i,i)
        end
      end
      
      count = count + 1;
    end
    
    res = sig;
endfunction


// ##################################################################
// ############### Método de GAUSS-SEIDEL SUMATORIA #################
// ##################################################################
function [res,count] = gauss_seidel_iter(A,b,x,err)
  n = size(A,1);
  
  sig(1) = (b(1) - A(1,2:n)*x(2:n))/A(1,1)
  
  for i = 2:n
    if i <> n then
      sig(i) = (b(i) - A(i,1:i-1)*sig(1:i-1) - A(i,i+1:n)*x(i+1:n))/A(i,i)
    else
      sig(i) = (b(i) - A(i,1:i-1)*sig(1:i-1))/A(i,i)
    end
  end
  
  count = 1;
  
  while norm(sig - x) > err
    x = sig;
    sig(1) = (b(1) - A(1,2:n)*x(2:n))/A(1,1)
  
    for i = 2:n
      if i <> n then
        sig(i) = (b(i) - A(i,1:i-1)*sig(1:i-1) - A(i,i+1:n)*x(i+1:n))/A(i,i)
      else
        sig(i) = (b(i) - A(i,1:i-1)*sig(1:i-1))/A(i,i)
      end
    end
    
    count = count + 1;
  end
  
  res = sig;
endfunction


// ##################################################################
// ##################### Método de SOR SUMATORIA ####################
// ##################################################################
function [res,count] = sor_iter(A,b,x,w,err)
  n = size(A,1);
  
  sig(1) = w/A(1,1) * (b(1) -A(1,2:n)*x(2:n)) + (1 - w)*x(1);
  
  for i = 2:n
    if i <> n then
      sig(i) = w/A(i,i) * (b(i) - A(i,1:i-1)*sig(1:i-1) - A(i,i+1:n)*x(i+1:n)) + (1 - w)*x(i)
    else
      sig(i) = w/A(i,i) * (b(i) - A(i,1:i-1)*sig(1:i-1)) + (1 - w)*x(i)
    end
  end
  
  count = 1;
  
  while norm(sig - x) > err
    x = sig;
    sig(1) = w/A(1,1) * (b(1) -A(1,2:n)*x(2:n)) + (1 - w)*x(1);
  
    for i = 2:n
    if i <> n then
      sig(i) = w/A(i,i) * (b(i) - A(i,1:i-1)*sig(1:i-1) - A(i,i+1:n)*x(i+1:n)) + (1 - w)*x(i)
    else
      sig(i) = w/A(i,i) * (b(i) - A(i,1:i-1)*sig(1:i-1)) + (1 - w)*x(i)
    end
  end
    
    count = count + 1;
  end
  
  res = sig;
endfunction


// #############################################################################
// ############################## FORMA MATRICIAL ##############################
// #############################################################################


// ##################################################################
// ######################## Método de JACOBI ########################
// ##################################################################
function [res,spec_radius,count] = jacobi(A, b, x, err)
    n = size(A, 1);
    N = diag(diag(A));
    
    if det(N) == 0 then
      printf("Error: N es una matriz singular.");
      abort  
    else
      inv_N = inv(N);
      I = eye(n,n);
      
      T = I - inv_N*A;
      c = inv_N * b;
      
      sig = T * x + c
      count = 1;
      spec_radius = get_spec_radius(A,0,"j");
      
      if norm(sig - x) <= err then
        res = sig; 
      else
        while norm(sig - x) > err
          x = sig;
          sig = T * x + c;
          count = count + 1;
        end
        
        res = sig
      end
    end
endfunction

// ##################################################################
// ##################### Método de GAUSS-SEIDEL #####################
// ##################################################################
function [res,spec_radius,count] = gauss_seidel(A, b, x, err)
    n = size(A, 1);
    N = tril(A);
    U = A - N;
    
    if det(N) == 0 then
      printf("Error: N es una matriz singular.");
      abort
    else
      inv_N = inv(N);
    
      T = -inv_N * U;
      c = inv_N * b;
      count = 0;
      spec_radius = get_spec_radius(A,0,"gs");
      
      while( %T )
          sig = T * x + c
          count = count + 1;
          if( norm( sig - x) < err )
              break
          end
          x = sig
      end
      
      res = sig
    end
endfunction


// ##################################################################
// ########################## Método de SOR #########################
// ##################################################################
function [res,spec_radius,count] = sor(A, b, x, w, err)
    n = size(A, 1);
    D = diag(diag(A));
    L = tril(A) - D;
    N = D + w*L;
    U = A - tril(A);
    
    if det(N) == 0 then
      printf("Error: N es una matriz singular.");
      abort
    else
      inv_N = inv(N);
      
      Tw = inv_N * ((1 - w)*D - w*U);
      cw = w * inv_N * b;
      count = 0;
      spec_radius = get_spec_radius(A,w,"sor");
  
      while( %T )
          sig = Tw * x + cw
          count = count + 1;
          if( norm(sig - x) < err )
              break
          end
          x = sig
      end
      
      res = sig
    end
endfunction


// #########################################################################################################################
// ###################################### Aproximación de autovalores y autovectores #######################################
// #########################################################################################################################

// ##################################################################
// ##################### Método de la potencia ######################
// ##################################################################


function [val,vec,count] = metodo_potencia(A,x,err)
  
  n = length(x);
  w = A*x;
  z = x;
  
  w_sig = A*z;
  z_sig = w_sig/norm(w_sig,'inf');
  count = 1;
  
  while %T
    z = z_sig;
    w = w_sig;
    
    w_sig = A*z;
    z_sig = w_sig/norm(w_sig,'inf');
    count = count + 1;
    
    if norm(z_sig - z) <= err then
      w_sig_sig = A*z_sig;
      can_compare = %F

      // Si encuento una componente k no nula de w_n y de w_n+1,
      // obtengo el autovalor_n y autovalor_n+1 y habilito la bandera
      // can_compare para que si la norma es <= que err entonces termine la iteración
      if w_sig <> 0 then
        k = 1;
        while %T
          if w_sig(k) <> 0 & w_sig_sig(k) <> 0
            can_compare = %T;
            val_ant = w_sig(k)/z(k);
            val = w_sig_sig(k)/z_sig(k);
            break
          elseif k == n
            break
          else
            k = k + 1;
          end
        end 
      else
        printf("W es nulo, por lo tanto no se puede obtener el autovalor.");
      end
      
      if can_compare 
        if norm(val - val_ant) <= err
          vec = w_sig_sig/norm(w_sig_sig,'inf');
          break
        end
      end
    end    
  end
endfunction


// ########################################################################################################
// ##################### Calcula los centros y radios de los círculos de Gerschgorin ######################
// ########################################################################################################

function [centers,radius] = gerschgorin_circles(A)
    n = size(A,1);
    
    centers(1) = A(1,1);
    radius(1) = sum(abs(A(1,2:n)));
    
    for i = 2:n
        centers(i) = A(i,i);
        
        if i <> n then
            radius(i) = sum(abs(A(i,1:i-1))) + sum(abs(A(i,i+1:n)));
        else
            radius(i) = sum(abs(A(i,1:i-1)));
        end
    end
endfunction


// ##################################################################
// ######################## Dibuja circulos #########################
// ##################################################################

function draw_circles(centers,radius)
  m = 0;
  
  l = length(centers);
    
  for i = 1:l
    aux = max(abs(centers(i) - radius(i)), abs(centers(i) + radius(i)));
  
    if m < aux then
      m = aux
    else
    end
  end
  
  v = linspace(-m-1,m+1,100);
  
  plot2d(v,zeros(v),rect=[-m,-m,m,m])
  
  for i = 1:length(centers)
    if radius(i) == 0 then
      x = centers(i) - 0.05;
      y = 0.05;
      w = 0.1;
      h = 0.1;
    else
      x = centers(i) - radius(i);
      y = radius(i);
      w = 2*radius(i);
      h = 2*radius(i);
    end
    
    xarc(x,y,w,h,0,360*64)
  end
endfunction



// #########################################################################################################################
// #################################################### Interpolación ######################################################
// #########################################################################################################################



// ##########################################################################
// ######################## Interpolación de Lagrange #######################
// ##########################################################################

function [res,l] = inter_lagrange(vx,vy,val)
  
  n = length(vx)
  res = 0;
  
  
  for i = 1:n
    l(i) = lag(i,val,vx);
    res = res + l(i) * vy(i)
  end
  
endfunction

function res = lag(k,val,v)
  
  l = length(v);
  
  if k == 1 then
    n = prod(val - v(2:l));
    d = prod(v(k) - v(2:l));
  elseif k == l
    n = prod(val - v(1:l-1));
    d = prod(v(k) - v(1:l-1));
  else
    n = prod(val - v(1:k-1)) * prod(val - v(k+1:l));
    d = prod(v(k) - v(1:k-1)) * prod(v(k) - v(k+1:l));
  end
  
  res = n/d
endfunction


// ##########################################################################
// ######################## Interpolación de Newton #########################
// ##########################################################################


function [aprox,err] = inter_newton(vx,vy,vector,f)
  n = length(vector);
  dd = dif_div(vx,vy);
  
  for i = 1:n
    aux = eval_inter_newton(vx,vector(i),dd);
    aprox(i) = aux;
    err(i) = f(vector(i)) - aux;
  end
endfunction

function aprox = inter_newton_one(vx,vy,x)
  dd = dif_div(vx,vy);
  
  aprox = eval_inter_newton(vx,x,dd)
endfunction

function res = eval_inter_newton(vx,x,dd)
  n = length(vx);
  
  res = dd(n);
  
  for i = n-1:-1:1
    res = dd(i) + (x - vx(i))*res
  end
endfunction

// ################################################################################
// ######################## Calculo diferencias divididas #########################
// ################################################################################

function d = dif_div(x,y)
    
  l = length(x);
  
  for i = 1:l
    d(i) = y(i)
  end
  
  for i = 2:l
    for j = l:-1:i
      d(j) = (d(j) - d(j-1))/(x(j) - x(j-i+1))
    end
  end
endfunction


// ####################################################################################
// ######################## Aproximación de mínimos cuadrados #########################
// ####################################################################################

// phi es un vector con las phi_j que se usaran para aproximar f(x).
// Por ejemplo si phi = ["1" "x" "x^2"], el polinomio queda:
// P(x) = a_1*1 + a_2*x + a_3*x^2

function [pol,err] = minimos_cuadrados_pol(x,y,grade)
  n = length(x);
  k = 0;
  
  for i = 1:grade+1
    for j = 1:grade+1
      if j < i
        A(i,j) = A(j,i)
      else
        A(i,j) = sum(x .^ (j-1+k))
      end
    end
    
    b(i) = x.^(i-1) * y';
    k = k+1;
  end
  
  [u,bp,coef] = gauss_con_pivoteo(A,b);
  
  pol = poly(coef,"x","coeff")
  err = sum((horner(pol,x) - y).^2)
endfunction



// #########################################################################################################################
// ############################################ Métodos de integración numérica ############################################
// #########################################################################################################################

// ##########################################################################
// ########################## Método del trapecio ###########################
// ##########################################################################

function area = metodo_trapecio(a,b,n,f)
  h = (b-a)/n;
  x = a;
  area = 0;
  
  for i = 1:n+1
    if i == 1 | i == n+1 then
      area = f(x)/2 + area
    else
      area = f(x) + area
    end
    
    x = a + i*h;
  end
  
  area = h * area;
endfunction


// #############################################################################
// ########################## Método del trapecio 2D ###########################
// #############################################################################

function vol = metodo_trapecio_2d(a,b,c,d,n,f)
    hx = (b-a)/n;
    hy = (d-c)/n;
    x = a;
    vol = 0;
    
    for i = 1:n+1
      area = 0;
      y = c;
      
      for j = 1:n+1
        disp(y)
        if j == 1 | j == n+1 then
          area = f(x,y)/2 + area
        else
          area = f(x,y) + area
        end
        y = c + j*hy;
      end
      
      area = hy * area;
      
      if i == 1 | i == n+1 then
        vol = area/2 + vol
      else
        vol = area + vol
      end
             
      x = a + i*hx;
    end
    
    vol = hx * vol;    
endfunction


// ##########################################################################
// ########################### Método de Simpson ############################
// ##########################################################################

function area = metodo_simpson(a,b,n,f)
  h = (b-a)/n;
  x = a;
  area = 0;
  m = 2;
  
  for i = 1:n+1
    if i == 1 | i == n+1 then
      area = f(x) + area;
    else
      area = 2^m * f(x) + area;
      if m == 1 then m = 2; else m = 1; end
    end

    x = a + i*h;
  end
  
  area = h/3 * area;
endfunction


// #############################################################################
// ########################## Método del Simpson 2D ###########################
// #############################################################################

function [vol,count] = metodo_simpson_2d(a,b,c,d,n,f) 
    hx = (b-a)/n;
    hy = (d-c)/n;
    x = a;
    vol = 0;
    mx = 4;
    count = 0;
    
    
    for i = 1:n+1
      area = 0;
      y = c;
      my = 4;
      
      for j = 1:n+1
        if j == 1 | j == n+1 then
          area = f(x,y) + area
        else
          area = my * f(x,y) + area
          if my == 2 then my = 4; else my = 2; end
        end
        
        y = c + j*hy;
      end
      
      
      area = hy/3 * area;
      count = count + 1;

      if i == 1 | i == n+1 then
        vol = area + vol
      else
        vol = mx * area + vol
        if mx == 2 then mx = 4; else mx = 2; end
      end

      x = a + i*hx;
      
      //if abs(hx/3*vol - %pi) <= 10^-3 then
      //  break
      //end
      
    end
    
    vol = hx/3 * vol;    
endfunction


// ################################################################
// ##################### Funciones auxiliares #####################
// ################################################################

function res = apply(f,vect)
  
  r = [];
  
  for i = 1:(length(vect))
    r = cat(1,r,[f(vect(i))])
  end
  
  res = r;
endfunction


function res = relative_error(y,x,err)
  if norm(x) == 0 then
    res = err + 1;
  else
    res = norm(y - x)/norm(x)
  end
endfunction

function res = evaluar_sistema(A,b,x)
  [filas,columnas] = size(A);
  bool = %t
  
  for i = 1:filas
    bool = bool & (A(i,:) * x == b(i))
  end
  
  res = bool
endfunction

function res = myHorner(p, val)
    
    coef = coeff(p);
    
    n = length(coef); 
    
    res = coef(n);
    
    for i = n-1:-1:1
        res = coef(i) + val * res
    end
        
endfunction

function [res, resDer] = poweredHorner(p, val)
    
    coef = coeff(p);
    
    n = length(coef);
    
    res = coef(n); // <----------- res = b_(n-1)
    resDer = res;  // <----------- resDer = c_(n-1) = a_(n-1)

    for i = n-1:-1:1
        res = coef(i) + val * res;       // <----------- En el paso i: res = a_(i-1) + x * b_i = b_(i-1)
        
        // Ver (1)
        if i <> 1 then
            resDer = res + val * resDer; // <----------- En el paso i: resDer = b_(i-1) + x * c_i
        else
        end
    end
        
endfunction


// Derivada n-ésima calculada con el cociente incremental
function res = derivada_nesima_ci(f,var,vx,h,n)
    deff("z=DF0("+var+")","z="+f);

    denominador = string(h)
    
    for i = 1:n
        deff("z=DF" + string(i) + "("+var+")","z=cociente_inc(DF" + string(i-1) + "," + var + "," + string(h) + ")");
    end
      
    deff("z=Final("+var+")","z=DF" + string(n) + "("+ var + ")");
    
    res = Final(vx)
endfunction

// Derivada n-ésima calculada con numderivative
function res = derivada_nesima(f,var,vx,h,n)

    deff("z=DF0("+var+")","z="+f)

    for i = 1:n
        iStr = string(i);
        iMenos = string(i-1);
        deff("z=DF"+iStr+"("+var+")","z=numderivative(DF"+iMenos+","+var+","+string(h)+",4)");
    end
      
    deff("z=Final("+var+")","z=DF"+string(n)+"("+var+")");
    
    res = Final(vx)
endfunction


//v = linspace(-1,2,100);
//fv = apply(f,v);
//zerosv = v.*0;
//plot2d(v,[fv zerov'], leg = "f@cero")

// Calcula el polinomio de taylor de grado n respecto a f alrededor de aVal evaluandolo en xVal
function res = taylor(f,var,xVal,aVal,n)
    deff("z=F("+var+")","z="+f)
    
    if n == 0 then
        res = F(aVal)
    else
        res = taylor(f,var,xVal,aVal,n-1) + (1/fact(n)) * derivada_nesima(f,var,aVal,0.1,n) * (xVal - aVal)^n
    end
    
endfunction

function rad = get_spec_radius(A,w,method)
  n = size(A,1);
  I = eye(n,n);
  
  if method == "j" then
    N = diag(diag(A));
  elseif method == "gs"
    N = tril(A);
  elseif method == "sor"
    D = diag(diag(A));
    L = tril(A) - D;
    N = D + w*L;
  else
    printf("Error: Solo se puede obtener el radio espectral con los métodos de Jacobi, Gauss-Seidel y SOR\n")
    abort
  end
  
  inv_N = inv(N);
  
  rad = max(abs(spec(I - inv_N*A)));
endfunction
