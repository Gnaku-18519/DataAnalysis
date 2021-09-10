%@author Wu AiJing

tries = 1000;
x = @(t) 17*cos(t) + sin(3*t);
y = @(t) 15*sin(t) - cos(4*t);
t = linspace(0, 2*pi, tries);

xd = @(t) -17*sin(t) + 3*cos(3*t); %derivative of x
yd = @(t) 15*cos(t) + 4*sin(4*t); %derivative of y
total_area = (1/2)*integral(@(t) x(t).*yd(t) - xd(t).*y(t), 0, 2*pi); %total area, Green's Theorem
g = @(t) x(t).*yd(t)-xd(t).*y(t); %function to calculate area of "sector"
h = @(a,b) abs(x(a)*y(b)-x(b)*y(a)) / 2; %needless triangle area included in the "sector"
%{
    h -- function to calculate area of triangle, from (0,0) to Point(a) and Point(b)
    Both methods below get the exactly same result.

Method 1:
    line Point(a) to Point(b):
    slope = (y(a)-y(b))/(x(a)-x(b))
    intercept = y(a)-slope*x(a)
    So, line: (y(a)-y(b))*x - (x(a)-x(b))*y + ((x(a)-x(b))*y(a)-(y(a)-y(b))*x(a)) = 0

    From (0,0) to line, distance =
    abs(((x(a)-x(b))*y(a)-(y(a)-y(b))*x(a)))/sqrt((y(a)-y(b))^2+(x(a)-x(b))^2)
    
    LengthAB = sqrt((x(a)-x(b))^2 + (y(a)-y(b))^2)
    triangle_area = LengthAB * distance / 2

Method 2:
    The triangle area can be got by half of its parallelogram.
    The area of the parralelogram is abs(x(a)*y(b) - x(b)*y(a))
    (basically this is the cross product of the two points -> |x1*y2-x2*y1|)
%}

%When using the linspace-points as random a, b,
%calculating the area of each segment to improve the efficiency
M = zeros(1, tries-1);
for k = 1:(tries-1)
    M(k) = (1/2)*integral(g, t(k), t(k+1));
end

L = 1e6; %square of the shortest length of the cut
A = 0; %value of a at the minimum length
B = 0; %value of b at the minimum length
for i = 1:floor(tries/3) %1/3 of the whole points number is enough
    a = t(i);
    for j = floor(i+tries/3):ceil(i+tries*2/3) %don't need to count back from 1
        b = t(j);
        temp = sum(M(i:j-1));
        area = min(temp, total_area-temp) - h(a,b); %find the smaller "sector" and then minus the needless triangle
        if abs(area - (1/2)*total_area) < 0.3 %close to half area or not
            %{
                Parameter = 0.3 here can be changed according to tries
                When using tries points on the curve to calculate, if the 
                parameter is too small, it may never reach a feasible result
            %}
            amount = (x(b)-x(a))^2 + (y(b)-y(a))^2;
            if amount < L
                L = amount;
                A = a;
                B = b;
            end
        end
    end
end

length = sqrt(L);
X = [x(A), x(B)];
Y = [y(A), y(B)];
plot(x(t), y(t), 'b', X(1), Y(1), 'r*', X(2), Y(2), 'k*', X, Y, 'd-')
axis equal
fprintf('The shortest cut found has length of %g\n', length)