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

%Plot the curve
x = linspace(0, 2*pi, 500); %variable t
%The plotted graph is not changing after we get the random A and t.
plot(A(1)*cos(1*(x-t(1))) + A(2)*cos(2*(x-t(2))) + A(3)*cos(3*(x-t(3))) + A(4)*cos(4*(x-t(4))), A(1)*sin(1*(x-t(1))) + A(2)*sin(2*(x-t(2))) + A(3)*sin(3*(x-t(3))) + A(4)*sin(4*(x-t(4))))

%Functions
%F(T) = [x(t)-x(s), y(t)-y(s)]
F = @(T) [A(1)*cos(1*(T(1)-t(1)))+A(2)*cos(2*(T(1)-t(2)))+A(3)*cos(3*(T(1)-t(3)))+A(4)*cos(4*(T(1)-t(4)))-A(1)*cos(1*(T(2)-t(1)))-A(2)*cos(2*(T(2)-t(2)))-A(3)*cos(3*(T(2)-t(3)))-A(4)*cos(4*(T(2)-t(4))); A(1)*sin(1*(T(1)-t(1)))+A(2)*sin(2*(T(1)-t(2)))+A(3)*sin(3*(T(1)-t(3)))+A(4)*sin(4*(T(1)-t(4)))-A(1)*sin(1*(T(2)-t(1)))-A(2)*sin(2*(T(2)-t(2)))-A(3)*sin(3*(T(2)-t(3)))-A(4)*sin(4*(T(2)-t(4)))];
%Jacobian matrix of F(T)
J = @(T) [-A(1)*sin(T(1)-t(1))-2*A(2)*sin(2*(T(1)-t(2)))-3*A(3)*sin(3*(T(1)-t(3)))-4*A(4)*sin(4*(T(1)-t(4))), A(1)*sin(T(2)-t(1))+2*A(2)*sin(2*(T(2)-t(2)))+3*A(3)*sin(3*(T(2)-t(3)))+4*A(4)*sin(4*(T(2)-t(4)));
    A(1)*cos(T(1)-t(1))+2*A(2)*cos(2*(T(1)-t(2)))+3*A(3)*cos(3*(T(1)-t(3)))+4*A(4)*cos(4*(T(1)-t(4))), -A(1)*cos(T(2)-t(1))-2*A(2)*cos(2*(T(2)-t(2)))-3*A(3)*cos(3*(T(2)-t(3)))-4*A(4)*cos(4*(T(2)-t(4)))];
%X, XX, Y, YY are changing according to T during process
X = @(T) A(1)*cos(1*(T(1)-t(1)))+A(2)*cos(2*(T(1)-t(2)))+A(3)*cos(3*(T(1)-t(3)))+A(4)*cos(4*(T(1)-t(4))); %x(t)
XX = @(T) A(1)*cos(1*(T(2)-t(1)))+A(2)*cos(2*(T(2)-t(2)))+A(3)*cos(3*(T(2)-t(3)))+A(4)*cos(4*(T(2)-t(4))); %x(s)
Y = @(T) A(1)*sin(1*(T(1)-t(1)))+A(2)*sin(2*(T(1)-t(2)))+A(3)*sin(3*(T(1)-t(3)))+A(4)*sin(4*(T(1)-t(4))); %y(t)
YY = @(T) A(1)*sin(1*(T(2)-t(1)))+A(2)*sin(2*(T(2)-t(2)))+A(3)*sin(3*(T(2)-t(3)))+A(4)*sin(4*(T(2)-t(4))); %y(s)

hold on %print dots
max_tries = 100; %can be larger & i and k do not have to do the same tries
for i = 1:max_tries %necessary to change random T
    T = pi*rand(1, 2); %T = [t, s], random initial point (starting point)
    
    for k = 1:max_tries
        h = -J(T)\F(T);
        T = T + h';
        if norm(h) < 100*eps(norm(T)) %find a solution T
            %plot(X(T),Y(T), 'k*') %plot the dot of solution T
            break
        end
    end
    if k == max_tries
        continue %doesn't find a solution T and go back to get another initial T
    end
    
    n = (T(1)-T(2))/2/pi;
    if abs(n-round(n)) > 1e-4 %t-s~=coefficient*(2*pi) -> n is not an integer
        plot(X(T), Y(T), 'r+') %plot(x(t), y(t))
        plot(XX(T), YY(T), 'g.') %plot(x(s), y(s))
        %break %found a solution, so break the loop
    else %t-s == coefficient*(2*pi) -> n is an integer
        continue %didn't find a solution, so continue the loop of new T
    end
end
hold off
%{
if i < max_tries
    disp('The curve intersects itself.')
else
    disp('The curve does not intersect itself.')
end
%}

%Notes: command "clf" can be used to clear the figure / plot window