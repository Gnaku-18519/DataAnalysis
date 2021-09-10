%@author Wu AiJing

%Random parameters
A = 10*rand(1, 4); %amplitudes   
%{
    Test case parameters
    A(1) = 20;
    A(3) = 1;
    A(4) = 0;
%}
t = 2*pi*rand(1, 4); %phases (tk)

% original equations 
% parametric equations
% FX = @(x) A(1)*cos(1*(x-t(1))) + A(2)*cos(2*(x-t(2))) + A(3)*cos(3*(x-t(3))) + A(4)*cos(4*(x-t(4)));
% FY = @(x) A(1)*sin(1*(x-t(1))) + A(2)*sin(2*(x-t(2))) + A(3)*sin(3*(x-t(3))) + A(4)*sin(4*(x-t(4)));
% derivatives     
% FXp = @(x) -A(1)*sin(x-t(1)) - 2*A(2)*sin(2*(x-t(2))) - 3*A(3)*sin(3*(x-t(3))) - 4*A(4)*sin(4*(x-t(4)));
% FYp = @(x)  A(1)*cos(x-t(1)) + 2*A(2)*cos(2*(x-t(2))) + 3*A(3)*cos(3*(x-t(3))) + 4*A(4)*cos(4*(x-t(4)));

% alternative choice 
% parametric equations
FX = @(x) A(1)*cos(1*(x-t(1))) + A(2)*cos(2*(x-t(2))) + A(3)*cos(1*(x-t(3))) + A(4)*cos(2*(x-t(4)));
FY = @(x) A(1)*sin(1*(x-t(1))) + A(2)*sin(2*(x-t(2))) - A(3)*sin(1*(x-t(3))) - A(4)*sin(2*(x-t(4)));
% derivatives     
FXp = @(x) -A(1)*sin(x-t(1)) - 2*A(2)*sin(2*(x-t(2))) - 1*A(3)*sin(1*(x-t(3))) - 2*A(4)*sin(2*(x-t(4)));
FYp = @(x)  A(1)*cos(x-t(1)) + 2*A(2)*cos(2*(x-t(2))) - 1*A(3)*cos(1*(x-t(3))) - 2*A(4)*cos(2*(x-t(4)));




%Plot the curve
x = linspace(0, 2*pi, 500); %variable t
%The plotted graph is not changing after we get the random A and t.
plot(FX(x), FY(x))

%Functions
%F(T) = [x(t)-x(s), y(t)-y(s)]
F = @(T) [FX(T(1)) - FX(T(2)); FY(T(1)) - FY(T(2))];


%Jacobian matrix of F(T)
J = @(T) [FXp(T(1)), -FXp(T(2)); FYp(T(1)), -FYp(T(2))]; 
%X, XX, Y, YY are changing according to T during process
X = @(T) FX(T(1));  %x(t)
XX = @(T) FX(T(2)); %x(s)
Y = @(T) FY(T(1)); %y(t)
YY = @(T) FY(T(2)); %y(s)

hold on %print dots
max_tries = 100; %can be larger & i and k do not have to do the same tries
for i = 1:max_tries %necessary to change random T
    T = pi*rand(1, 2); %T = [t, s], random initial point (starting point)
    failed = 0;
    for k = 1:max_tries
        h = -J(T)\F(T);
        T = T + h';
        if norm(h) < 100*eps(norm(T)) %find a solution T
            %plot(X(T),Y(T), 'k*') %plot the dot of solution T
            break
        end
        n = (T(1)-T(2))/2/pi;
        if abs(n-round(n)) < 1e-4
            failed = 1;
            break
        end
    end
    if failed == 1 || k == max_tries
        continue %doesn't find a solution T and go back to get another initial T
    end
    
    plot(X(T), Y(T), 'r+', 'MarkerSize', 20) %plot(x(t), y(t))
    plot(XX(T), YY(T), 'g.', 'MarkerSize', 20) %plot(x(s), y(s))
    break %found a solution, so break the loop
end
hold off

if i < max_tries
    disp('The curve intersects itself.')
else
    disp('The curve does not intersect itself.')
end

%Notes: command "clf" can be used to clear the figure / plot window