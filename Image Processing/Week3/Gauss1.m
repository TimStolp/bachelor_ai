function G = Gauss1(sigma)
% get scale
scale = 3*sigma;
% create appropriate ranges for x and y
x = -scale : scale ;
% create a sampling grid
[X , Y ] = meshgrid (x , 1 );
% calculate the Gaussian function
G = (1/(sqrt(2*pi)*sigma)^2)*exp(-sum(X.^2, 3)./(2*sigma^2));
G = G./sum(sum(G));
end