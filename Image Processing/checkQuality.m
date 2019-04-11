function squareDistance = checkQuality(image, angle, method)
image = im2double(image);
sizeImage = size(image);
% Rotate twice
rotatedImage = rotateImage(image, angle, method);
rotatedImage = rotateImage(rotatedImage, -angle, method);
[y, x] = size(rotatedImage);
offset1 = round((y-sizeImage(1))/2);
offset2 = round((x-sizeImage(2))/2);
% Crop image to original size
cutImage = rotatedImage(offset1:offset1+sizeImage(1)-1, offset2:offset2+sizeImage(2)-1);
image = image / max(max(image));
difference = image - cutImage;
squareDistance = sum(sum(difference.^2));
end