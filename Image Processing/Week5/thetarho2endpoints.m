function [x1, y1, x2 , y2] = thetarho2endpoints(theta , rho , rows , cols)
sinus = sin(theta);
cosine = cos(theta);
if sinus ~= 0
    y1 = 0;
    x1 = (y1 * cosine + rho) / sinus;
    y2 = rows;
    x2 = (y2 * cosine + rho) / sinus;
else
    x1 = 0;
    y1 = (x1 * sinus - rho) / cosine;
    x2 = cols;
    y2 = (x2 * sinus - rho) / cosine;
end
end