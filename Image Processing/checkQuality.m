function squareDistance = checkQuality(image, angle, method)
sizeImage = size(image);
rotatedImage = rotateImage(image, angle, method);
rotatedImage = rotateImage(rotatedImage, 2*pi-angle, method);
x = ceil(abs(sizeImage(1) * sin(angle)) + abs(sizeImage(2) * cos(angle)));
y = ceil(abs(sizeImage(1) * cos(angle)) + abs(sizeImage(2) * sin(angle)));
x = ceil(abs(x * sin(2*pi-angle)) + abs(x * cos(2*pi-angle)));
y = ceil(abs(y * cos(2*pi-angle)) + abs(y * sin(2*pi-angle)));
offset1 = round((y-sizeImage(1))/2);
offset2 = round((x-sizeImage(2))/2);
cutImage = rotatedImage(offset1:end-offset1, offset2:end-offset2);
cutImage = cutImage(1:sizeImage(1), 1:sizeImage(2));
image = image / max(max(image));
difference = cast(image, 'double') - cutImage;
squareDistance = sum(sum(difference.^2));
end