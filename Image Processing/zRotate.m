function output = zRotate(phi,vectors)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
vectors = reshape(vectors, [], 3);
output = rot(phi)*vectors;
end

