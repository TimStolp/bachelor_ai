function projMatrix = estimateProjectionMatrix ( uv , XYZ )
% calculation of projection matrix
u = XYZ (: , 1);
v = XYZ (: , 2);
w = XYZ (: , 3);
% we cannot use x? and y? in Matlab because ? means transposed
x = uv (: , 1);
y = uv (: , 2);
o = ones ( size ( x ));
z = zeros ( size ( x ));
Aoddrows = [u , v , w , o , z , z , z , z , -x .* u , -x .* v , -x .* w , -x ];
Aevenrows = [z , z , z , z , u , v , w , o , -y .* u , -y .* v , -y .* w , -y ];
A = [ Aoddrows ; Aevenrows ];
% Do Singular Value Decomposition to obtain m
[U , D , V ] = svd ( A );
projMatrix = V (: , end );
% reshape m into the 3 x4 projection matrix M
projMatrix = reshape (projMatrix , 4 , 3)';
end
