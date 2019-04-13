%% 2.1
a = imread ('autumn.tif');
a = im2double ( rgb2gray ( a ) );
reset ( gcf ); % this resets the (get) current figure
hold on ; % overlay on current figure
plot ( profile ( a , 100 , 100 , 120 , 120 , 200 , 'linear') , 'b' );
plot ( profile ( a , 100 , 100 , 120 , 120 , 200 , 'nearest') , 'r' );
hold off ;

%% 3.1, 30 degree counter clockwise rotation while keeping image size.
a = imread ('cameraman.tif');
result = rotateImageKeepSize(a, pi/6, 'linear');
imshow(result)

%% 3.1, 30 degree counter clockwise rotation while maintaining image information.
a = imread ('cameraman.tif');
result = rotateImage(a, pi/6, 'linear');
imshow(result)

%% 3.1, Rotates using bilinear and nearest neighbour interpolation and printing their processing time.
a = imread ('cameraman.tif');
tic()
rotateImage(a, pi/6, 'nearest');
toc()
tic()
rotateImage(a, pi/6, 'linear');
toc()

%% 3.1, Checks rotation quality by rotating forth and back and using squared error between the rotated and original image.
a = imread ('cameraman.tif');
nearest = checkQuality(a, pi/6, 'nearest');
linear = checkQuality(a, pi/6, 'linear');
fprintf("Squared error for nearest neighbour = %f\n", nearest)
fprintf("Squared error for bilinear = %f\n", linear)

%% 4.1, Rotate image 45 degrees using myAffine.
a = imread ('cameraman.tif');
% Calls myAffine with the right x and y values for a 45 degree rotation.
[result, p, M, N] = rotateImageAffine(a, pi/4, 'linear');
imshow(result)
fprintf("x1 = %f, y1 = %f\nx2 = %f, y2 = %f\nx3 = %f, y3 = %f\nM = %f, N = %f\n", p(2,1), p(1,1), p(2,2), p(1,2), p(2,3), p(1,3), M, N)

%% 5.1 Project image using myProjection.
a = imread('flyers.png');
imshow(a)
title('click order: top-left, bottom-left, top-right, bottom-right');
points = ginput(4); % click order: top-left, bottom-left, top-right, bottom-right
result = myProjection(a, points, 400, 300, 'linear');
imshow(result)

%% 8.1 Place 3 cubes on calibration image
mat = load('calibrationpoints.mat');
imshow('calibrationpoints.jpg')
hold on
transformedCube = transformCube(1, [0,0,0], mat.xy, mat.XYZ);
subPlotFaces(transformedCube)
transformedCube = transformCube(1, [5,0,3], mat.xy, mat.XYZ);
subPlotFaces(transformedCube)
transformedCube = transformCube(1, [0,7,6], mat.xy, mat.XYZ);
subPlotFaces(transformedCube)

%% 8.1 Place 3 cubes on different views of calibration image.
mat = load('calibrationpoints.mat');

for i = 1:4
    calibration_points = load(['view',num2str(i),'.mat']);
    subplot(2,2,i), imshow(['view',num2str(i),'.jpg']), title(['view ',num2str(i),''])
    transformedCube = transformCube(1, [0,0,0], calibration_points.xy, mat.XYZ);
    subPlotFaces(transformedCube)
    transformedCube = transformCube(1, [5,0,3], calibration_points.xy, mat.XYZ);
    subPlotFaces(transformedCube)
    transformedCube = transformCube(1, [0,7,6], calibration_points.xy, mat.XYZ);
    subPlotFaces(transformedCube)
end
