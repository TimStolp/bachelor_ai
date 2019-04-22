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
times = zeros(100,20);
for sigma = 1:20
    disp(sigma)
    for i = 1:100
        tic;
        H = imfilter(a, Gauss(sigma), 'conv', 'replicate');
        times(i,sigma) = toc;
    end
    imshow(H)
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
times = zeros(100,20);
for sigma = 1:20
    disp(sigma)
    for i = 1:100
        tic;
        f = Gauss1(sigma);
        H = imfilter(a, f, 'conv', 'replicate');
        H = imfilter(H, f', 'conv', 'replicate');
        times(i,sigma) = toc;
    end
    imshow(H)
end
mean(times)
plot(mean(times))
