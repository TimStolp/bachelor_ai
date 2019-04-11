function rotatedImage = rotateImageAffine(image, angle, method)
% Rotate an angle using affine matrix
sizeImage = size(image);
points = [1, 1, sizeImage(2); 1, sizeImage(1), 1];
R = rot2d(angle);
center = [sizeImage(2)/2; sizeImage(1)/2];
p = R*(points - center) + center;
rotatedImage = myAffine(image, p(2,1), p(1,1), p(2,2), p(1,2), p(2,3), p(1,3), sizeImage(1), sizeImage(2), method); 
end