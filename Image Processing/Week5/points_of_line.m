function [ pts ] = points_of_line( points , line , epsilon )
% points - an array containing all points
% line - the homogeneous representation of the line
% epsilon - the maximum distance
% returns :
% pts - an array of all points within epsilon of the line
    points(:, 3) = 1;
    line = line./sqrt(line(1)^2 + line(2)^2);
    distances = abs(points * line');
    pts = points(distances < epsilon, [1,2]);
end