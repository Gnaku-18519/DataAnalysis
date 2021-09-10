%@author Wu AiJing

% A = B = 2, so the random numbers are on the interval [-2, 2]

tries = 100000;
S = 0; %Count the number of real solutions of fixed points

for k = 1 : tries
    M = -2 + 4*rand(1, 4); %Random coefficients of p(x)
    A = [M(1), M(2), M(3)-1, M(4)]; %coefficients of p(x)-x
    g = @(x) 3*M(1)*x^2+2*M(2)*x+M(3); %g(x) = p'(x)
    r = roots(A); %Solutions of p(x)-x
    
    for i = 1 : numel(r)
        if (isreal(r(i)))
            if (abs(g(r(i)))<1)
                S = S + 1;
                break
            end
        end
    end
end

P = S/tries; %Probability
disp(P)