%@author Wu AiJing

% A = B = 2, so the random numbers are on the interval [-2, 2]

%Define new variables
P = zeros(1, 5); %Pn = Times of having n real solution(s)
tries = 10000000; %Total times to loop

%Loop for more p(x) in order to get the probabilities
for k = 1 : tries
    M = -2 + 4*rand(1, 6); %Random coefficients for p(x)
    r = roots(M); %Solutions of p(x)
    N = 0; %Count the number of real solutions; RESET every time
    for i = 1 : numel(r)
        if (isreal(r(i)))
            N = N + 1;
        end
    end

    switch N %Add Pn according to each N
        case N
            P(N) = P(N) + 1;
    end
end

%Use Pn/tries to count probability of each case
disp(P./tries)