%Derivative
%derivative of a variable
syms x
h = (2*x^2+1)/(3*x);
diff(h)

%derivative of a constant
constant = sym('5');
diff(constant)

%second derivative
f = cos(8*x);
diff(f,2) %OR diff(diff(f))

%partial derivative
syms y z
g = sin(y*z);
diff(g,y)

%derivative of a matrix
A = [cos(4*x), 3*x; x, sin(5*x)];
diff(A)
