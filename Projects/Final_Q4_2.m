%@author Wu AiJing

function Final_Q4_2()
    x = @(t) 17*cos(t) + sin(3*t);
    y = @(t) 15*sin(t) - cos(4*t);
    t = linspace(0, 2*pi, 1000);

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
        From (0,0) to line, distance = abs(((x(a)-x(b))*y(a)-(y(a)-y(b))*x(a)))/sqrt((y(a)-y(b))^2+(x(a)-x(b))^2)
        LengthAB = sqrt((x(a)-x(b))^2 + (y(a)-y(b))^2)
        triangle_area = LengthAB * distance / 2

      Method 2:
        The triangle area can be got by half of its parallelogram.
        The area of the parralelogram is abs(x(a)*y(b) - x(b)*y(a))
        (basically this is the cross product of the two points -> |x1*y2-x2*y1|)
    %}
    
    IP1 = rand(1,1)*pi;
    IP2 = rand(1,1)*pi+pi;
    IP = [IP1, IP2]; %initial random points [a,b], members of t
    F = @(p) (p(1)-p(3))^2+(p(2)-p(4))^2;
    %p is [x(a), y(a), x(b), y(b)]
    Constraint = @(c) abs(c-(1/2)*total_area)-0.1;
    %c is ExactArea
    %The acceptable difference is set to be less than 0.1
    
    for M = [1e3, 1e5, 1e7, 1e9]
        %M don't need to be too large for this, 
        %IP won't change along when M is too large
        IP = fminsearch(@(IP) min(F([x(IP(1)), y(IP(1)), x(IP(2)), y(IP(2))])) ...
                              + M*max(Constraint(ExactArea(IP,total_area,g,h)),0), IP);
    end
    
    length = sqrt(F([x(IP(1)), y(IP(1)), x(IP(2)), y(IP(2))]));
    X = [x(IP(1)), x(IP(2))];
    Y = [y(IP(1)), y(IP(2))];
    plot(x(t), y(t), 'b', X(1), Y(1), 'r*', X(2), Y(2), 'k*', X, Y, 'd-')
    axis equal
    fprintf('The shortest cut found has length of %g\n', length)
end

function ExactArea = ExactArea(IP,total_area,g,h)
    temp = (1/2)*integral(g, IP(1), IP(2));
    area = min(temp, total_area-temp) - h(IP(1),IP(2));
    ExactArea = area;
end