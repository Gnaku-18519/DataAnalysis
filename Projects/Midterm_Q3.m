n = input('n = ');
p = [1];
q = [1 0];
for m = 1:n-1
    r = ((2*m+1)*[q 0] - m*[0 0 p])/(m+1);
    p = q;
    q = r;
end
x = roots(r)';
disp(x);    %  the evaluation points
i = (1:n)'; 
A = x.^(i-1);
b = (1-(-1).^i)./i;
w = A\b;
disp(w');   %  the weights
