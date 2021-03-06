A = [1 2 3; 4 5 6; 7 8 9];
gauss_elim(A)

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
