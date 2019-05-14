function accu = hough(im, threshold, nrho , ntheta)
% HOUGHLINES
%
% Function takes an image and its Hough transform , finds the
% significant lines and draws them over the image
%
% Usage : houghlines (im , h, thresh )

    % Get edges
    edge_im = edge(im, 'canny', threshold);
    size_im = size(edge_im);
    
    % Create accumulator
    accu = zeros(nrho, ntheta);
    
    % Get nonzeros
    [y, x] = find(edge_im);
    
    max_rho = sqrt(size_im(1)^2 + size_im(2)^2);
    delta_rho = 2 * max_rho / (nrho - 1);
    
    delta_theta = pi / ntheta;
    thetas = [0: delta_theta :( pi - delta_theta )];
    
    for i = 1:length([y, x])
        for theta = 1:length(thetas)
            % Calculate rho
            rho = x(i) * sin(thetas(theta)) - y(i) * cos(thetas(theta));
            
            % Get indexes
            rho_i = round(rho / delta_rho + nrho / 2);
            theta_i = round(thetas(theta) / delta_theta + 1);
            
            % Increment
            accu(rho_i, theta_i) = accu(rho_i, theta_i) + 1;
        end
    end
end
