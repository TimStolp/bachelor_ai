function r = myAffine ( image , x1 , y1 , x2 , y2 , x3 , y3 , M , N , method )
r = zeros (M , N ); % allocate new image of correct size
% calculate X
A = [ x1 , y1 , 1; x2 , y2 , 1; x3 , y3 , 1]';
B = [ 1 , 1 ; M , 1 ; 1 , N ]';
X = B / A ;

[rows, cols] = find(r==0);
coordinateMatrix = [rows'; cols'; ones(size(rows'))];
rotatedMatrix = X*coordinateMatrix;
rotatedImage = zeros(1, M*N);
% Obtain colors for the whole rotatedImage matrix
for column = 1 : size(cols)
    c = rotatedMatrix(:,column);
    rotatedImage(:,column) = pixelValue(image, c(2), c(1), method);
end

r = reshape(rotatedImage, [M, N]);
r = r / max(max(r));
end