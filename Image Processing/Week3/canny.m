function output = canny(F, sigma)
F = double(F);
Fx = gD(F, sigma, 1, 0);
Fy = gD(F, sigma, 0, 1);
Fxx = gD(F, sigma, 2, 0);
Fyy = gD(F, sigma, 0, 2);
Fxy = gD(F, sigma, 1, 1);

Fw = sqrt(Fx.^2 + Fy.^2);
Fww = (Fx.^2 .* Fxx + 2 * Fx .* Fy .* Fxy + Fy.^2 .* Fyy) ./ (Fx.^2 + Fy.^2);
output = zeroCrossing(Fww, Fw);
end

