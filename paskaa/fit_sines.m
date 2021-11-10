function fit_sines()
    % Search for b-values, - just pick limits and step
    
    left_end = -pi; right_end = pi;
    N = 3;
    b = zeros(N,1);
    f = @(t) (1/pi)*t;
    
    M = 500;
    
    %test_sinesum();
    %trial(left_end, right_end, f, b, N, M);
    
    % Produce and store an initially "smallest" error
    b(1) = -1; b(2) = -1; b(3) = -1;
    test_b = b;
    smallest_E = error(left_end, right_end, test_b, f, M);
    db = 0.1;
    for b1 = -1:db:1
        for b2 = -1:db:1
            for b3 = -1:db:1
                test_b(1) = b1; test_b(2) = b2; 
                test_b(3) = b3;
                E = error(left_end, right_end, test_b, f, M);
                if E < smallest_E
                    b = test_b;
                    smallest_E = E;
                end
            end
        end
    end
    b
    plot_compare(left_end, right_end, f, b, N, M)
    fprintf('b coeffiecients: %g %g and %g \n', b(1), b(2), b(3));
    fprintf('Smallest error found: %g \n', smallest_E);
end

function result = sinesum(t, b)
    % Computes S as the sum over n of b_n * sin(n*t)
    % For each point in time (M) we loop over all b_n to 
    % produce one element S(M), i.e. one element in
    % S corresponds to one point in time.
    S = zeros(length(t),1);
    for M = 1:length(t)
        for n = 1:length(b)
            S(M) = S(M) + b(n)*sin(n*t(M));
        end
    end
    result = S;
end

function test_sinesum()
    t = zeros(2,1); t(1) = -pi/2; t(2) = pi/4;
    b = zeros(2,1); b(1) = 4.0; b(2) = -3;
    sinesum(t,b)
end

function plot_compare(left_end, right_end, f, b, N, M)
    time = linspace(left_end, right_end, M);
    y = f(time);
    S = sinesum(time, b);
    plot(time, y, 'b-', time, S, 'r--');
    xlabel('Time');
    ylabel('f (blue) and S (red)');
end

function result = error(left_end, right_end, b, f, M)
    time = linspace(left_end, right_end, M);
    y = f(time);
    S = sinesum(time, b);
    E = 0;
    for i = 1:length(time)
        E = E + sqrt((y(i) - S(i))^2);
    end
    result = E;
end

function trial(left_end, right_end, f, b, N, M)
    M = 500;
    new_trial = true;
    while new_trial
        for i = 1:N
            text = strcat('Give b', num2str(i), ' : \n');
            b(i) = input(text);
        end
        plot_compare(left_end, right_end, f, b, N, M)
        fprintf('Error: \n',error(left_end, right_end, b, f, M));
        answer = input('Another trial (y/n)? ','s');
        if answer == 'n'
            new_trial = false;
        end
    end
end