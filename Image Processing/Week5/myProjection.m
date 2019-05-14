function projection = myProjection ( image , uv , m , n , method )
projection = zeros (m , n ); % allocate new image of correct size
% calculate projection matrix
xy = [1 1; m 1; 1 n; m n];
M = createProjectionMatrix(xy, uv);
[rows, cols] = find(projection==0);
coordinateMatrix = [rows'; cols'; ones(size(rows'))];
rotatedMatrix = M*coordinateMatrix;
rotatedMatrix = rotatedMatrix./rotatedMatrix(end,:);

rotatedImage = zeros(1, m*n);
for column = 1 : size(cols)
    c = rotatedMatrix(:,column);
    rotatedImage(:,column) = pixelValue(image, c(1), c(2), method);
end

projection = reshape(rotatedImage, [m, n]);
projection = projection / max(max(projection));
end