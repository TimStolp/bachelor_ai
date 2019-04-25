%% Use blur, derivative, increase intensity convolution on an image.
a = imread('peppers.png');
blur = [1 2 1; 2 4 2; 1 2 1]./16;
first_derivative = [1 0 -1]./2;
intensity_3 = [0 0 0; 0 3 0; 0 0 0];

a_blurred = imfilter(a, blur, 'conv', 'replicate');
a_first_der = imfilter(a, first_derivative, 'conv', 'replicate');
a_int_3 = imfilter(a, intensity_3, 'conv', 'replicate');

subplot(2,2,1), imshow(a), title('Original')
subplot(2,2,2), imshow(a_blurred), title('Blurred')
subplot(2,2,3), imshow(a_first_der), title('First derivative')
subplot(2,2,4), imshow(a_int_3), title('Intensity multiplied by 3')

%% Plot of Gaussian kernel

mesh(Gauss(3))

%% Time Gaussian on different scales
a = imread('peppers.png');
times = zeros(10,200);
for sigma = 1:200
    disp(sigma)
    for i = 1:10
        tic;
        H = imfilter(a, Gauss(sigma), 'conv', 'replicate');
        times(i,sigma) = toc;
    end
end
mean(times)
plot(mean(times))

%% Compare two consecutive Gaussian blurs with a one time Gaussian blur
a = imread('peppers.png');

a_blur_temp = imfilter(a, Gauss(3), 'conv', 'replicate');
a_blur_cons = imfilter(a_blur_temp, Gauss(4), 'conv', 'replicate');
a_blur = imfilter(a, Gauss(sqrt(25)), 'conv', 'replicate');

subplot(1,2,1), imshow(a_blur_cons), title('Two times consecutive blur of scale 3 and 4')
subplot(1,2,2), imshow(a_blur), title('Instant blur of scale sqrt(3^2 + 4^2)')

squared_error = sum((a_blur_cons - a_blur).^2, 'all')
size_a = size(a)
pixels = 384*512*3

%% Time seperated Gaussian on different scales

a = imread('peppers.png');
times = zeros(10,200);
for sigma = 1:200
    disp(sigma)
    for i = 1:10
        tic;
        f = Gauss1(sigma);
        H = imfilter(a, f, 'conv', 'replicate');
        H = imfilter(H, f', 'conv', 'replicate');
        times(i,sigma) = toc;
    end
end
mean(times)
plot(mean(times))

%% gD test
f = imread('cameraman.tif');
fx = gD(f, 1, 1, 0);
fy = gD(f, 1, 0, 1);
fxx = gD(f, 1, 2, 0);
fyy = gD(f, 1, 0, 2);
fxy = gD(f, 1, 1, 1);

subplot(2,3,1), imshow(f, []), title('f')
subplot(2,3,2), imshow(fx, []), title('fx')
subplot(2,3,3), imshow(fy, []), title('fy')
subplot(2,3,4), imshow(fxx, []), title('fxx')
subplot(2,3,5), imshow(fyy, []), title('fyy')
subplot(2,3,6), imshow(fxy, []), title('fxy')

%% cos and sin function
x = -100:100;
y = -100:100;
[X , Y ] = meshgrid (x , y );
A = 1; B = 2; V = 6* pi /201; W = 4* pi /201;
F = A * sin ( V * X ) + B * cos ( W * Y );
Fx = V * A * cos ( V * X );
Fy = -W * B * sin ( W * Y );
subplot(1,3,1), imshow (F , [] , 'xData' , x , 'yData' , y ), title('F')
subplot(1,3,2), imshow (Fx , [] , 'xData' , x , 'yData' , y ), title('Fx')
subplot(1,3,3), imshow (Fy , [] , 'xData' , x , 'yData' , y ), title('Fy')

%% Image with vectors (Run "cos and sin function" block before this)
xx = -100:10:100;
yy = -100:10:100;
[ XX , YY ] = meshgrid ( xx , yy );
Fx = V * A * cos ( V * XX );
Fy = -W * B * sin ( W * YY );
imshow (F , [] , 'xData' , xx , 'yData' , yy );
hold on ;
quiver ( xx , yy , Fx , Fy , 'r' );
hold off ;

%% Gaussian vector plot (Run "cos and sin function" block before this)
xx = -100:10:100;
yy = -100:10:100;
[ XX , YY ] = meshgrid ( xx , yy );
Gx = gD(F, 1, 1, 0);
Gy = gD(F, 1, 0, 1);
imshow (F , [] , 'xData' , xx , 'yData' , yy );
hold on ;
quiver ( xx , yy , Gx(1:10:end,1:10:end) , Gy(1:10:end,1:10:end) , 'r' );
hold off ;

%% Rotated image (Run "cos and sin function" block before this)
RF = rotateImage(F, pi/18, 'linear');
[s1, s2] = size(RF);
RGx = gD(RF, 1, 1, 0);
RGy = gD(RF, 1, 0, 1);
imshow (RF , [] , 'xData' , 1:10:s1 , 'yData' , 1:10:s2 );
hold on ;
quiver ( 1:10:s1 , 1:10:s2 , RGx(1:10:end,1:10:end) , RGy(1:10:end,1:10:end) , 5, 'r');
hold off ;

%% Use canny edge detector
a = imread('cameraman.tif');
cannied = canny(a, 1);
imshow(cannied, [])