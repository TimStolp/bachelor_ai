function rotatedImage = rotateImage(image, angle, method)
% Create the necessary rotation matrix
R = rot2d(angle*pi/180);
% Obtain indices needed for interpolation
sizeImage = size(image);
center = [(sizeImage(1)+1)/2; (sizeImage(2)+1)/2];
[rows, cols] = find(image);
coordinateMatrix = [rows'; cols'];
rotatedMatrix = (R*(coordinateMatrix-center)+center);
% Obtain colors for the whole rotatedImage matrix
for column = 1 : size(cols)
    c = rotatedMatrix(:,column);
    rotatedImage(:,column) = pixelValue(image, c(2), c(1), method);
end
% using the specified interpolation method
rotatedImage = cast(reshape(rotatedImage, [sizeImage(1), sizeImage(2)]), 'double');
rotatedImage = rotatedImage / max(max(rotatedImage));
end