function Algorithm_Octave()
    tic
    pkg load statistics;
    pkg load ltfat
    setenv('BLAS_VERSION','') %set BLAS to null
    round = 1; %counting the serial number of the current simulation (from 1:Round)
    Round = 10; %number of simulations
    Time = 6; %max-number of rounds for θ to converge
    pi1_output_true = zeros(Round,1); %store true pi_1
    pi1_output_init = zeros(Round,1); %store (b) pi_1
    pi1_output_mid = zeros(Time*Round,1); %store (e) pi_1
    pi1_output_fin = zeros(Round,1); %store (f) pi_1
    theta_original = zeros(Round,4); %store theta_logistic
    theta_output = zeros(Round,4); %store final theta_hat
    while (round <= Round) %using while than for helps to modify round more easily with signal       
        %(a) Set initial values
        A = xlsread(["NormNorm_Octave_", num2str(round), ".csv"]); %let R files generate enough sets of data before running, and Octave reads different files for each round
        %Upper-case (D, X, Z) are vectors
        %Lower-case (d, x, z) are elements
        n0 = sum(A(:,1)==0);
        n1 = sum(A(:,1)==1);
        n = n0 + n1;
        D = A(:,1);
        X = A(:,2);
        Z = A(:,3);
        pi1_output_true(round) = A(1,4);
        %θ -- theta = [alpha, beta_x, beta_z, beta_xz]
        theta_tilde = initialTheta(A(1,4), n0, n1, A(1:4,5));
        %γ & ξ
        gamma = X/sum(X); %density of x with initial value
        gamma = initialD(gamma);
        ksi = Z/sum(Z); %density of z with initial value
        ksi = initialD(ksi);
        
        %(b) Calculate
        m = @(x,z,theta_tilde) theta_tilde(2)*x + theta_tilde(3)*z + theta_tilde(4)*x*z;
        hh = @(x,z,theta_tilde) theta_tilde(1) + m(x,z,theta_tilde);
        h = @(d,x,z,theta_tilde) exp(d * (hh(x,z,theta_tilde))) / (1 + exp(hh(x,z,theta_tilde)));
        
        %(g) Converge until θ doesn't change
        theta_temp = zeros(4,1);
        for time = 1:Time
            %(e) Update pi_1 & pi_0
            pi_1 = pi1(n, gamma, ksi, theta_tilde, X, Z, h); % 0 < pi_1 < 1
            pi_0 = 1 - pi_1;
            if (time == 1)
                pi1_output_init(round) = pi_1;
            else
                pi1_output_mid(time+3*(round-1)) = pi_1;
            endif
            
            %(c) & (d) Update the density estimations
            [gamma, ksi] = density(n,n0,n1,pi_0,pi_1,gamma,ksi,theta_tilde,X,Z,h);
            %decide whether we need to abandon this set of data
            gamma_sum = sum(gamma); %sum(gamma_hat)
            ksi_sum = sum(ksi); %sum(ksi_hat)
            if (gamma_sum > 1.1 || ksi_sum > 1.1 || gamma_sum < 0.9 || ksi_sum < 0.9) %as densities, gamma_sum and ksi_sum should be equal to 1
                gamma = initialD(gamma);
                ksi = initialD(ksi);
            endif
            fprintf('gamma_sum: %5.4f\n', gamma_sum);
            fprintf('ksi_sum: %5.4f\n', ksi_sum);
            
            %(f) Update θ
            ff = [-4.102005; 0.4324335; 0.1733924; 0.2320964];
            %ff = [-4.165; log(1.5); log(1.2); log(1.3)];
            %f0 = ff - 0.3; %f0 = [-4.5; 0; 0; 0];
            %f1 = ff + 0.3; %f1 = [-4.0; 0.5; 0.5; 0.5];
            
            options = optimset('Algorithm', 'levenberg-marquardt', 'OutputFcn', @custom_stop_fun, 'MaxFunEval', 50);
            theta_hat = fsolve(@(theta_var) equation(theta_var,n,D,X,Z,h,gamma,ksi), ff, options);
            disp(theta_hat)
            if max(abs(theta_temp - theta_hat)) < 0.05
                %if the max absolute difference is less than 0.05,
                %theta_hat doesn't change much, it's time to output
                break;
            else
                theta_temp = theta_hat; %record this theta_hat for next comparison
            endif
        endfor
        fprintf('time: %d\n', time);
        pi1_output_fin(round) = pi1(n, gamma, ksi, theta_hat, X, Z, h);
        theta_original(round,:) = theta_tilde';
        theta_output(round,:) = theta_hat';
        fprintf('round: %d\n', round);
        round = round + 1;
    endwhile
    
    %output
    pi1_output_mid = pi1_output_mid(pi1_output_mid~=0); %remove all 0 elements in pi1_output_mid
    filename = 'D:\Octave\DataOutput_modified.xlsx';
    T = table(pi1_output_true);
    writetable(T, filename, 'Sheet', 1);
    T = table(pi1_output_init);
    writetable(T, filename, 'Sheet', 2);
    T = table(pi1_output_mid);
    writetable(T, filename, 'Sheet', 3);
    T = table(pi1_output_fin);
    writetable(T, filename, 'Sheet', 4);
    T = table(theta_original);
    writetable(T, filename, 'Sheet', 5);
    T = table(theta_output);
    writetable(T, filename, 'Sheet', 6);
    toc
    disp(['Running Time: ',num2str(toc)]);
endfunction

function theta_tilde = initialTheta(PI1_true,n0,n1,theta_tilde)
    PI0_true = 1 - PI1_true;
    %Preprocess alpha from kappa: alpha = kappa - log(n0 / n1) + log(pi_1 / pi_0)
    temp = theta_tilde(1);
    theta_tilde(1) = temp - log(n0 / n1) + log(PI1_true / PI0_true);
endfunction

function newD = initialD(raw)
    N = normalize(raw); %directly normalize to [0,1]
    newD = N/sum(N); %making sum(density) == 1
endfunction

function pi1 = pi1(n,gamma,ksi,theta_tilde,X,Z,h)
    Value = 0;
    temp = 0;
    for k = 1:n
        for j = 1:n
            temp = temp + gamma(j) * h(1, X(j), Z(k), theta_tilde);
        endfor
        Value = Value + temp * ksi(k);
        temp = 0;
    endfor
    pi1 = Value;
endfunction

function [gamma_hat, ksi_hat] = density(n,n0,n1,pi_0,pi_1,gamma_tilde,ksi_tilde,theta_tilde,X,Z,h)
    gamma_hat = zeros(n, 1);
    ksi_hat = zeros(n, 1);
    addend = n1/pi_1;
    coefficient = n0/pi_0 - n1/pi_1;
    sum_ksi = 0;
    sum_gamma = 0;
    for a = 1:n
        % a is used as l for gamma_hat and s for ksi_hat
        for b = 1:n
            % b is used as j for gamma_tilde and k for ksi_tilde
            sum_ksi = sum_ksi + ksi_tilde(b) * h(0,X(a),Z(b),theta_tilde);
            sum_gamma = sum_gamma + gamma_tilde(b) * h(0,X(b),Z(a),theta_tilde);
        endfor
        gamma_hat(a) = 1/(addend + coefficient * sum_ksi);
        ksi_hat(a) = 1/(addend + coefficient * sum_gamma);
        sum_ksi = 0;
        sum_gamma = 0;
    endfor
endfunction

function Derivative = Derivative(theta,d,x,z)
    temp = theta(1) + theta(2)*x + theta(3)*z + theta(4)*x*z;
    temp1 = d * exp(temp) - exp(temp) + d;
    Derivative = zeros(1,4);
    Derivative(1) = temp1*exp(d*temp)/((1+exp(temp))^2);
    Derivative(2) = temp1*exp(d*temp)*x/((1+exp(temp))^2);
    Derivative(3) = temp1*exp(d*temp)*z/((1+exp(temp))^2);
    Derivative(4) = temp1*exp(d*temp)*x*z/((1+exp(temp))^2);
endfunction

function equation = equation(theta,n,D,X,Z,h,gamma,ksi)
    fprintf('theta for this time: %5.4f; %5.4f; %5.4f; %5.4f\n', theta);
    out = zeros(n,4);
    for i = 1:n
        out(i,:) = Derivative(theta,D(i),X(i),Z(i)) ./ h(D(i),X(i),Z(i),theta) - equation2(theta,n,D(i),X,Z,gamma,ksi,h);
        %clear Derivative(theta,D(i),X(i),Z(i)) equation2(theta,n,D(i),X,Z,gamma_tilde,ksi_tilde,h)
    endfor
    Equation = zeros(4,1);
    for ii = 1:4
        Equation(ii) = sum(out(:,ii))/n;
    endfor
    equation = 100*sum(power(Equation, 2));
    fprintf('equation for this time: %5.4f\n', equation);
endfunction

function equation2 = equation2(theta,n,d,X,Z,gamma,ksi,h)
    temp1 = zeros(n,4);
    temp2 = zeros(n,1);
    temp3 = zeros(n,4);
    temp4 = zeros(n,1);
    for j = 1:n
        for k = 1:n
            temp1(k,:) = ksi(k) * Derivative(theta,d,X(j),Z(k));
            temp2(k) = ksi(k) * h(d,X(j),Z(k),theta);
        endfor
        for jj = 1:4
            temp3(j,jj) = sum(temp1(:,jj)) * gamma(j);
        endfor
        temp4(j) = sum(temp2) * gamma(j);
    endfor
    equation2 = zeros(1,4);
    tmp = sum(temp4);
    for m = 1:4
        equation2(m) = sum(temp3(:,m)) ./ tmp;
    endfor
endfunction

function stop = custom_stop_fun(~, optimValues, ~)
    if optimValues.fval < 0.05
        stop = true;
    else
        stop = false;
    endif
endfunction
