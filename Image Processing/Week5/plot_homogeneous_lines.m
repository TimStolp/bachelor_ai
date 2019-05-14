function plot_homogeneous_lines(im, lines)
    % Plots lines between x = 1 and x = 2nd dimension of image
    % and their respective y using homogeneous line representations.
    imshow(im)
    hold on
    for i = 1:size(lines, 1)
        a = lines(i,1);
        b = lines(i,2);
        c = lines(i,3);
        x1 = 1;
        y1 = (-a*x1-c)/b;
        x2 = size(im, 2);
        y2 = (-a*x2-c)/b;
        line([x1, x2], [y1, y2])
    end
end