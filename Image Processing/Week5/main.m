%% Get all pictures in gray values
billboard = rgb2gray(imread('billboard.png'));
box = rgb2gray(imread('box.png'));
shapes = rgb2gray(imread('shapes.png'));
szeliski = rgb2gray(imread('szeliski.png'));

%% hough transforms box image
box_hough = hough(box, 0.2, 360, 360);
imshow(box_hough, [])

%% hough transform shapes image
shapes_hough = hough(shapes, 0.9, 360, 360);
imshow(shapes_hough, [])

%% hough transform szeliski image
szeliski_hough = hough(szeliski, 0.9, 360, 360);
imshow(szeliski_hough, [])

%% hough lines box image
lines = houghlines(box, box_hough, 175, 1);

%% hough lines shapes image
lines = houghlines(shapes, shapes_hough, 100, 1);

%% hough lines szeliski image
lines = houghlines(szeliski, szeliski_hough, 50, 1);

%% szeliski houghlines improvement test
lines = houghlines(szeliski, szeliski_hough, 100);

[y, x] = find(edge(szeliski, 'canny', 0.9));

for i = 1:length(lines)
    good_points = points_of_line([x, y], lines(i,:), 10);
    lines(i, :) = line_through_points(good_points);
end

plot_homogeneous_lines(szeliski, lines);

%% Projection using line intersections

one = lines(1,:);
two = lines(2,:);
three = lines(3,:);
four = lines(4,:);
points = [cross(one, three); cross(one, four); cross(three, two); cross(four, two)];
points = points./points(:, 3);
points = points(:,[1,2]);

projected = myProjection(szeliski, points, 400, 300, 'linear');

imshow(projected)
