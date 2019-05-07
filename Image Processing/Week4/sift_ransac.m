function result = sift_ransac(im1, im2)
% make single
im1 = im2single(im1) ;
im2 = im2single(im2) ;

% make grayscale
if size(im1,3) > 1
    im1g = rgb2gray(im1) ; 
else
    im1g = im1 ;
end

if size(im2,3) > 1
    im2g = rgb2gray(im2) ; 
else
    im2g = im2 ;
end

% Use SIFT to find matches
[f1,d1] = vl_sift(im1g) ;
[f2,d2] = vl_sift(im2g) ;

[matches, scores] = vl_ubcmatch(d1,d2) ;

numMatches = size(matches,2) ;

xa = f1(1,matches(1,:)) ;
xb = f2(1,matches(2,:)) ;
ya = f1(2,matches(1,:)) ;
yb = f2(2,matches(2,:)) ;

total_list = [xa; ya; xb; yb];
input = [xa; ya; ones(size(xa))];
output = [xb; yb; ones(size(xb))];

% Use RANSAC and homography to find best model
% Get RANSAC parameters
distance_threshold = 1000;
best_projmatrix = zeros([3,3]);
best_error = 999999999;
outlier_probability = 0.5;
number_points = 4;
p = 0.99;

% Calculate number of iterations to have a p probability to find a good
% projection
iterations = round(log(1-p)/log(1-(1-outlier_probability)^number_points));

% Perform RANSAC
for i = 1:iterations
    % Get 4 random matches
    random_indexes = randperm(size(total_list,2),number_points);
    random_matches = total_list(:,random_indexes);
    
    % Create projection matrix
    projmatrix = estimateProjMatrix2(random_matches(1:2,:)', random_matches(3:4,:)');
    
    % Project input features
    projected_output = projmatrix * input;
    projected_output = projected_output./projected_output(end,:);
    
    % Get error
    error = vecnorm(output - projected_output);
    
    % Find inliers (matches below error threshold)
    valid_indexes = find(error < distance_threshold);
    valid_matches = total_list(:,valid_indexes);
    
    % Check if enough inliers are found
    if size(valid_matches, 2) > round((1 - outlier_probability) * numMatches)
        % Get projection matrix from all valid matches and project input
        projmatrix = estimateProjMatrix2(valid_matches(1:2,:)', valid_matches(3:4,:)');
        projected_output = projmatrix * input;
        projected_output = projected_output./projected_output(end,:);
        
        % Get mean squared error and update if best solution
        mse = immse(output, projected_output);
        if mse < best_error
            best_projmatrix = projmatrix;
            best_error = mse;
        end
    end
end

% Project image 1 on top of image 2 with found best projection matrix
T = maketform('projective', best_projmatrix');
[x, y] = tformfwd(T,[1 size(im1,2)], [1 size(im1,1)]);

xdata = [min(1,x(1)) max(size(im2,2),x(2))];
ydata = [min(1,y(1)) max(size(im2,1),y(2))];
f12 = imtransform(im1,T,'Xdata',xdata,'YData',ydata);
f22 = imtransform(im2, maketform('affine', [1 0 0; 0 1 0; 0 0 1]), 'Xdata',xdata,'YData',ydata);
result = max(f12,f22);
end