function rotatedImage = rotateImage(image, angle, method)
image = im2double(image);
% Create the necessary rotation matrix
R = rot2d(angle);

% Obtain indices needed for interpolation
sizeImage = size(image);
new_x = ceil(abs(sizeImage(1) * sin(angle)) + abs(sizeImage(2) * cos(angle)));
new_y = ceil(abs(sizeImage(1) * cos(angle)) + abs(sizeImage(2) * sin(angle)));
offset1 = (new_y-sizeImage(1))/2;
offset2 = (new_x-sizeImage(2))/2;
center = [new_y/2; new_x/2];
[rows, cols] = find(zeros(new_y, new_x)==0);
coordinateMatrix = [rows'; cols'];

% Rotate image
rotatedMatrix = (R*(coordinateMatrix-center)+center);
% Obtain colors for the whole rotatedImage matrix
rotatedImage = zeros(1, new_y*new_x);
for column = 1 : size(cols)
    c = rotatedMatrix(:,column);
    rotatedImage(:,column) = pixelValue(image, c(2)-offset2, c(1)-offset1, method);
end

% using the specified interpolation method
rotatedImage = reshape(rotatedImage, [new_y, new_x]);
rotatedImage = rotatedImage / max(max(rotatedImage));
end