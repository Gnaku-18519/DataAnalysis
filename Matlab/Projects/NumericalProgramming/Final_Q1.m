%@author Wu AiJing

y = [0 3 21 31 29 29 24 23 22 22 27 44 56 66 63 54 45 42 35 41 43 53 61 83];
x = 1:numel(y);

%{
    Infectious Curve:
    I(t) = coefficient.*t.^2.*exp(-t)
    should be transformed to plot(t+shift, I(times.*t))
    Let's call coefficient as C, shift as S, and times as T.
    Hence, I(t) = C.*(T.*(t-S)).^2.*exp(-(T.*(t-S)))
    
    F = [C1, T1, S1, C2, T2, S2, C3, T3, S3] -- factors
%}
g = @(x) max(x,0).^2.*exp(-x);
%use max(x,0) as subsection of curves, no need to manually set the division
%if x is less than F(3/6/9), then x-F(3/6/9) < 0, so max(x,0) = 0
I = @(x, F) 0 + F(1).*g(F(2).*(x-F(3))) + F(4).*g(F(5).*(x-F(6))) + F(7).*g(F(8).*(x-F(9)));
optimal = fminsearch(@(F) sum((y-I(x, F)).^2), [63, 0.95, 0.65, 100, 0.53, 9, 170, 0.35, 18]);

t = linspace(min(x), max(x)+6, 1000)';
plot(t, I(t, optimal), 'b', x, y, 'r*')