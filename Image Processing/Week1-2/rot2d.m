function matrix = rot2d(phi)
%ROT Summary of this function goes here
%   Detailed explanation goes here
matrix = [[cos(phi), sin(phi)];
          [-sin(phi), cos(phi)]];
end