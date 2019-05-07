%% Use SIFT to find matches between nachtwacht pictures.
% Read images
im1 = single(rgb2gray(imread('nachtwacht1.jpg')));
im2 = single(rgb2gray(imread('nachtwacht2.jpg')));
sizeIm1 = size(im1);
sizeIm2 = size(im2);
dim = max(sizeIm1(1),sizeIm2(1));
% Make image dimensions equal
padIm1 = [im1;zeros(abs([dim, 0]-sizeIm1))];
padIm2 = [im2;zeros(abs([dim,0]-sizeIm2))];
% Pad image together
imPad = [padIm1, padIm2];
imPad = imPad./max(max(imPad));
% Find features
[fa, da] = vl_sift(im1) ;
[fb, db] = vl_sift(im2) ;
% Match features
[matches, scores] = vl_ubcmatch(da, db) ;

% Plot results
figure(2) ; clf ;

xa = fa(1,matches(1,:)) ;
xb = fb(1,matches(2,:)) + size(im1,2) ;
ya = fa(2,matches(1,:)) ;
yb = fb(2,matches(2,:)) ;

hold on ;
imshow(imPad)
h = line([xa ; xb], [ya ; yb]) ;
set(h,'linewidth', 1, 'color', 'r') ;

vl_plotframe(fa(:,matches(1,:)), 'color', 'y') ;
fb(1,:) = fb(1,:) + size(im1,2) ;
vl_plotframe(fb(:,matches(2,:)), 'color', 'y') ;
axis image off ;

%% Projection matrix estimation with 4 best feature matches and projecting the remaining features (Run block above first)
% Sort matches on score
total_list = [scores; xa; ya; xb; yb];
s = sortrows(total_list',1)';
to = s(2:3,1:4)';
from = s(4:5,1:4)';

% Estimate projection matrix with best points
projmatrix = estimateProjMatrix2(to, from);

homogen_points = [xa; ya; ones(size(xa))];
projected = projmatrix * homogen_points;
projected = projected./projected(end,:);

% Plot original and projected points with connecting lines
imshow(imPad)
hold on
plot(homogen_points(1,:), homogen_points(2,:), 'r*', 'LineWidth', 2, 'MarkerSize', 5);
plot(projected(1,:), projected(2,:), 'b*', 'LineWidth', 2, 'MarkerSize', 5);
h = line([homogen_points(1,:); projected(1,:)], [homogen_points(2,:); projected(2,:)]);
set(h,'linewidth', 1, 'color', 'y') ;

%% Projection of nachtwacht pictures using 4 best matches (remove " + size(im1,2)" on line 24 and rerun code)
f1 = imread('nachtwacht1.jpg');
f2 = imread('nachtwacht2.jpg');

T = maketform('projective', projmatrix');
[x y] = tformfwd(T,[1 size(f1,2)], [1 size(f1,1)]);

xdata = [min(1,x(1)) max(size(f2,2),x(2))];
ydata = [min(1,y(1)) max(size(f2,1),y(2))];
f12 = imtransform(f1,T,'Xdata',xdata,'YData',ydata);
f22 = imtransform(f2, maketform('affine', [1 0 0; 0 1 0; 0 0 1]), 'Xdata',xdata,'YData',ydata);
subplot(1,1,1);
imshow(max(f12,f22));

%% Use sift and ransac to estimate and perform projection on the nachtwacht or river
% Nachtwacht
im1 = imread('nachtwacht1.jpg');
im2 = imread('nachtwacht2.jpg');

% River
% im1 = imread('river1.jpg');
% im2 = imread('river2.jpg');

result = sift_ransac(im1, im2);
imshow(result)
