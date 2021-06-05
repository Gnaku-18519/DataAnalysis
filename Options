Display (fminbnd, fminsearch, fzero, lsqnonneg):
  A flag indicating whether intermediate steps appear on the screen.
	'notify' (default) displays output only if the function does not converge.
	'iter' displays intermediate steps (not available with lsqnonneg). See Optimization Solver Iterative Display.
	'off' or 'none' displays no intermediate steps.
	'final' displays just the final output.

FunValCheck (fminbnd, fminsearch, fzero):
  Check whether objective function values are valid.
	'on' displays an error when the objective function or constraints return a value that is complex or NaN.
	'off' (default) displays no error.
  
MaxFunEvals (fminbnd, fminsearch):
  The maximum number of function evaluations allowed. The default value is 500 for fminbnd and 200*length(x0) for fminsearch.
  eg. options = optimset('MaxFunEvals', 50);

MaxIter	(fminbnd, fminsearch):
  The maximum number of iterations allowed. The default value is 500 for fminbnd and 200*length(x0) for fminsearch.

%{
Differences between MaxFunEvals & MaxIter (retrieved from mathworks.com, by Steven Lord):
If you had to walk through an unfamiliar darkened room and you had a stick, you might tap the ground in front of you, in front and to the left, and in front and to the right to determine where the path is clear.
Once you know the direction where it's safe to move, you take a step and repeat the process of tapping and stepping.
Tapping the ground is a function evaluation. Stepping is an iteration. One step (iteration) may require multiple taps (function evaluations) to complete.
%}
  
OutputFcn (fminbnd, fminsearch, fzero):
  Display information on the iterations of the solver. The default is [] (none). See Optimization Solver Output Functions.
  eg. options = optimset('OutputFcn', @custom_stop_fun);
      function stop = custom_stop_fun(~, optimValues, ~)
        if optimValues.fval < 20
          stop = true;
        else
          stop = false;
        end
      end
  
PlotFcns (fminbnd, fminsearch, fzero):
  Plot information on the iterations of the solver. The default is [] (none). For available predefined functions, see Optimization Solver Plot Functions.

TolFun (fminsearch):
  The termination tolerance for the function value. The default value is 1.e-4. See Tolerances and Stopping Criteria.
  
TolX (fminbnd, fminsearch, fzero, lsqnonneg):
  The termination tolerance for x.
  The default value is 1.e-4, except for fzero, which has a default value of eps (= 2.2204e-16), and lsqnonneg, which has a default value of 10*eps*norm(c,1)*length(c).
