%@author Wu AiJing

function Final_Q2()
    A = 2;
    B = 2;
    n = 7; %7 points in total
    L = A+3; %length of the rectangle
    W = B+6; %width of the rectangle
    X = zeros(1,n); %final points' x-values
    Y = zeros(1,n); %final points' y-values
    OptimalDistance = 1; %largest optimal distance (^2), got from the loop
    
    %Using loop to reduce the coincident influence of random initial value
    for i = 1:50
        P1 = L*rand(1,n); %random [x1, ..., xn]
        P2 = W*rand(1,n); %random [y1, ..., yn]
        P = [P1, P2]; %the initial vector of points
        %the coefficients for rand() will make the final result more accurate
        d = [];
        Constraint = @(c) max([-min(c), max(c(1:n))-L, max(c(n+1:2*n))-W]);
        %{
            c represents the vector containing [x1, ..., xn, y1, ..., yn].
            min(c) -- every element of c should be larger than 0;
            max(c(1:n)) -- every x should be less than L;
            max(c(n+1:2*n)) -- every y should be less than W;
            So, if C is larger than 0, then a penalty should be taken.
        %}

        for M = [1e3, 1e6, 1e9, 1e12, 1e15, 1e18]
            P = fminsearch(@(P) max(Distance(P, d, n)) + M*max(Constraint(P),0), P);
        end
        
        if OptimalDistance < -max(Distance(P, d, n))
            OptimalDistance = -max(Distance(P, d, n));
            X = P(1:n);
            Y = P(n+1:2*n);
        end
    end
    
    fprintf('The optimal distance is %g\n',sqrt(OptimalDistance))
    %min|Pj-Pk|, need back to positive and sqrt()
    plot(X, Y, 'r*')
    axis equal
    rectangle('Position',[0, 0, L, W]) %should be drawn after plot()
end

function Distance = Distance(P, d, n)
    for j = 1:n-1
        for k =j+1:n
            d = [d, -((P(j)-P(k))^2 + (P(j+n)-P(k+n))^2)];
            %collect all the -(Pj-Pk)^2 for fminsearch use
            %"-" is needed, but no need to do sqrt() for |Pj-Pk| now
        end
    end
    Distance = d;
end