function transformedCube = transformCube(scale, t, xy, XYZ)
% Performs transformation on cube.
t = t + [-0.5,-0.5,0.5].*scale;
pfaces = createCube(scale, t);
projMatrix = estimateProjectionMatrix(xy, XYZ);

transformedCube = projMatrix*[reshape(pfaces, [30,3])'; ones(1, 30)];
transformedCube = transformedCube./transformedCube(end,:);
transformedCube = transformedCube([1,2],:);
transformedCube = reshape(transformedCube', [6,5,2]);
end