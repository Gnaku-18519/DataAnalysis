%@author Wu AiJing

tries = 1000;
t = linspace(0, 2*pi, tries);
x = @(t) 17*cos(t) + sin(3*t);
y = @(t) 15*sin(t) - cos(4*t);
xd = @(t) -17*sin(t) + 3*cos(3*t); %derivative of x
yd = @(t) 15*cos(t) + 4*sin(4*t); %derivative of y

f = @(t) sqrt(xd(t).^2 + yd(t).^2); %function to calculate arc
arc_total = integral(f, 0, 2*pi); %arc = sum(sqrt(diff(x).^2 + diff(y).^2))
%integral() needs relatively long time to proceed,
%so the less times of using it, the better in efficiency
%When using the linspace-points as random a, b,
%we may calculate the arc of each segment to improve the efficiency
N = zeros(1, tries-1);
for k = 1:(tries-1)
    N(k) = integral(f, t(k), t(k+1));
end

delta = 1; %the chord-arc constant = min(chord/arc)
A = 0; %value of a at the minimum delta
B = 0; %value of b at the minimum delta
for i = 1:(tries-1)
    a = t(i);
    for j = i+1:(tries-1) %don't need to count back from 1
        b = t(j);
        chord = sqrt((x(b)-x(a))^2 + (y(b)-y(a))^2);
        temp = sum(N(i:j-1)); %get the arc (a is always smaller than b)
        arc = min(temp, arc_total-temp); %find the shorter one of two arcs
        c = chord/arc;
        
        if c < delta
            delta = c;
            A = a;
            B = b;
        end
    end
end

plot(x(t), y(t), 'b', x(A), y(A), 'r*', x(B), y(B), 'k*')
axis equal
fprintf('The minimum chord-arc constant is %g\n', delta)