A = [6 -2 2 4; 12 -8 6 10; 3 -13 9 3; -6 1 4 -18];
b = [16 26 -19 -34];
x = solve(A, b);
x1 = solve1(A, b);
disp(x);
disp(x1);
x==x1

function x = solve(A, b)
    [A1, b1] = scaled_part_pivot(A, b)
    [A2, b2] = gauss_elim(A1, b1);
    x = back_subs_up(A2, b2);
end

function x = solve1(A, b)
    [A1, b1, colperms] = tot_pivot(A, b)
    [A2, b2] = gauss_elim(A1, b1);
    x = back_subs_up(A2, b2);
    for i = length(colperms(:,1)):-1:1
        x = switch_cols(x, colperms(i, 1), colperms(i, 2))
    end
end

function A = switch_rows(A, x, y)
    if 0<x<length(A(:,1)) && 0<y<length(A(:, 1))
        temp = A(y, :);
        A(y, :) = A(x, :);
        A(x, :) = temp;
    end
end

function A = switch_cols(A, x, y)
    if 0<x<length(A(1,:)) && 0<y<length(A(1,:))
        temp = A(:, y);
        A(:, y) = A(:, x);
        A(:, x) = temp;
    end
end

function [A, b] = part_pivot(A, b)
    for i = 1:length(A)-1
        colmaxindex = i;
        for j = i+1:length(A)
            if abs(A(j, i)) > abs(A(colmaxindex, i))
                colmaxindex = j;
            end
        end
        if colmaxindex ~= i
            A = switch_rows(A, i, colmaxindex);
            b = switch_rows(b', i, colmaxindex)';
        end
    end
end

function [A, b] = scaled_part_pivot(A, b)
    for i = 1:length(A)-1 %fix a column
        colmaxindex = i;
        rowmax = max(abs(A(i, :)));
        for j = i+1:length(A)  % fix a row
            jrowmax = max(abs(A(j, :)));
            if abs(A(j, i))/jrowmax > abs(A(colmaxindex, i))/rowmax
                colmaxindex = j;
                rowmax = jrowmax;
            end
        end
        if colmaxindex ~= i
            A = switch_rows(A, i, colmaxindex);
            b = switch_rows(b', i, colmaxindex)';
        end
    end
end

function [A, b] = gauss_elim(A, b)
    for i = 1:length(A(1, :))-1
        for j = i+1:length(A(:, 1))
            d = A(j, i)/A(i, i);
            for k = i:length(A(j, :))
                A(j, k) = A(j, k) - d*A(i, k);
            end
            b(j) = b(j) - d*b(i);
        end
    end
end

function [A, b, permlist] = tot_pivot(A, b)
    permlist = [];
    permcount = 1;
    rowlen = length(A(:, 1));
    collen = length(A(1, :));
    for i = 1:collen-1
        maxindex = [i, i];
        for j = i: rowlen
            for k = i: collen
                if abs(A(j, k)) > abs(A(maxindex(1),maxindex(2)))
                    maxindex = [j, k];
                end
            end
        end

        if maxindex(1) ~= i
            A = switch_rows(A, i, maxindex(1));
            b = switch_rows(b', i, maxindex(1))';
        end
        if maxindex(2) ~= i
            A = switch_cols(A, i, maxindex(2));
            permlist(permcount, :) = [i, maxindex(2)];
            permcount = permcount + 1;
        end
    end
end

function x = back_sub_up(A, b)
    collen = length(A(1, :));
    x = zeros(1, collen);
    for i = collen:-1:1
        d = b(i);
        for j = i+1:size
            d = d - A(i, j)*x(j);
        end
        x(i) = d/A(i,i);
    end
end

function x = back_sub_low(A, b)
    collen = length(A(1, :));
    x = zeros(1, collen);
    for i = 1:collen
        d = b(i);
        for j = 1:i-1
            d = d - A(i, j)*x(j);
        end
        x(i) = d/A(i,i);
    end
end
