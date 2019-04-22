function G = Gauss(sigma)
% get scale
scale = 3*sigma;
% create appropriate ranges for x and y
x = -scale : scale ;
y = -scale : scale ;
% create a sampling grid
[X , Y ] = meshgrid (x , y );
mesh = cat(3,X,Y);
% calculate the Gaussian function
G = (1/(sqrt(2*pi)*sigma)^2)*exp(-sum(mesh.^2, 3)./(2*sigma^2));
G = G./sum(sum(G));
end