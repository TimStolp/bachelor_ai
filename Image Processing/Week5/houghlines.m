function [lines] = houghlines ( im , accu , threshold,  plot)
% HOUGHLINES
%
% Function takes an image and its Hough transform , finds the
% significant lines and draws them over the image
%
% Usage : houghlines (im , h, thresh )
    % Check default param
    if nargin < 4
        plot = 0;
    end
    
    % Dialate image
    se = strel('line',11,90);
    im = imdilate(im,se);
    
    % Recalculate delta_rho and delta_theta
    size_im = size(im);
    size_accu = size(accu);

    nrho = size_accu(1);
    ntheta = size_accu(2);

    max_rho = sqrt(size_im(1)^2 + size_im(2)^2);
    delta_rho = 2 * max_rho / (nrho - 1);

    delta_theta = pi / ntheta;

    % Threshold the hough transform
    accu(accu < threshold) = 0;
    
    % Get region mask
    bwl = bwlabel(accu);
    
    % Get number of regions
    nregions = max(max(bwl));
    
    if plot
        imshow(im)
    end
    
    lines = [];
    for n = 1: nregions
        mask = bwl == n ;
        region = mask .* accu ;
        
        [max_rho_i, max_theta_i] = find(region == max(max(region)));
        max_theta_i = max_theta_i(1,1);
        max_rho_i = max_rho_i(1,1);
        
        max_rho = (max_rho_i - nrho / 2) * delta_rho;
        max_theta = (max_theta_i - 1) * delta_theta;
        
        [x1, y1, x2 , y2] = thetarho2endpoints(max_theta , max_rho , size_im(1) , size_im(2));
        
        if plot
            line([x1, x2], [y1, y2])
        end
        lines = [lines; cross([x1, y1, 1], [x2 , y2, 1])];
    end
end