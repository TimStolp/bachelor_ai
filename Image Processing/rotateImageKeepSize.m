function rotatedImage = rotateImageKeepSize(image, angle, method)
image = im2double(image);
% Create the necessary rotation matrix
R = rot2d(angle);

% Obtain indices needed for interpolation
sizeImage = size(image);
center = [sizeImage(2)/2; sizeImage(1)/2];
[rows, cols] = find(zeros(sizeImage(1), sizeImage(2))==0);
coordinateMatrix = [rows'; cols'];

% Obtain colors for the whole rotatedImage matrix
rotatedMatrix = (R*(coordinateMatrix-center)+center);
rotatedImage = zeros(1, sizeImage(1)*sizeImage(2));
for column = 1 : size(cols)
    c = rotatedMatrix(:,column);
    rotatedImage(:,column) = pixelValue(image, c(2), c(1), method);
end

% using the specified interpolation method
rotatedImage = reshape(rotatedImage, [sizeImage(1), sizeImage(2)]);
rotatedImage = rotatedImage / max(max(rotatedImage));
end