function matrix = rot(phi)
%ROT Summary of this function goes here
%   Detailed explanation goes here
matrix = [[cos(phi), -sin(phi), 0];
          [sin(phi), cos(phi), 0];
          [0,0,1]];
end

