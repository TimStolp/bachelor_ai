function projMatrix = estimateProjMatrix2 ( xy , uv )
% Prepare matrix A to estimate projection matrix
x = xy (: , 1);
y = xy (: , 2);
u = uv (: , 1);
v = uv (: , 2);
o = ones ( size ( x ));
z = zeros ( size ( x ));
Aoddrows = [x , y , o , z , z , z , -u .* x , -u .* y , -u ];
Aevenrows = [z , z , z , x , y , o , -v .* x , -v .* y , -v ];
A = [ Aoddrows ; Aevenrows ];
% Use last column of SVD to estimate the projection
[U , D , V ] = svd ( A );
projMatrix = V (: , end );
% reshape projection into the 3 x 3 projection matrix
projMatrix = reshape (projMatrix , [3 , 3])';
end