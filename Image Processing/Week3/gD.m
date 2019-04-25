function output = gD(f, sigma, xorder, yorder)
X = Gauss1(sigma);
Y = Gauss1(sigma);

scale = 3*sigma;

x = -scale : scale ;
% Get polynomials for derivative order one and two.
firstpoly = x.*(-1/sigma^2);
secondpoly = ((x.^2).*(sigma^4)) - (1/sigma^2);

% Multiply the Gaussian kernel with the right polynomial
% to get the right Gaussian derivative kernel
if xorder == 1
    X = X.*firstpoly;
end
if xorder == 2
    X = X.*secondpoly;
end
if yorder == 1
    Y = Y.*firstpoly;
end
if yorder == 2
    Y = Y.*secondpoly;
end

% Convolute image with X and Y kernels.
output = imfilter(f, X, 'conv', 'replicate');
output = imfilter(output, Y', 'conv', 'replicate');
end

