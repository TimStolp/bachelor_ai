function l = line_through_points ( points )
% returns :
% l - homogeneous representation of the least -square -fit
    c = mean(points);
    p = points - c;
    cov_matrix = cov(p);
    [eigen_vectors, ~] = eigs(cov_matrix);
    eig_vect = eigen_vectors(:, 1);
    n = [-eig_vect(2), eig_vect(1)];
    new_point = ((n' * c) / n)';
    l = cross([c, 1], [new_point, 1]);
end