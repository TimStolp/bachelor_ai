function r = myAffine ( image , x1 , y1 , x2 , y2 , x3 , y3 , M , N , method )
r = zeros (N , M ); % allocate new image of correct size
% calculate X
A = [ x1 , y1 , 1; x2 , y2 , 1; x3 , y3 , 1]';
B = [ 1 , 1 ; M , 1 ; 1 , N ]';
% B = [ xx1 , yy1 ; xx2 , yy2 ; xx3 , yy3 ]';
X = B / A ;

% [rows, cols] = find(zeros(M, N)==0);
% coordinateMatrix = [rows'; cols'; ones(1, size(rows'))];
% rotatedMatrix = X*coordinateMatrix;

for xa = 1: M
    for ya = 1: N
        % calculate x and y ( insert code for this )
        vector = X*[xa; ya; 1];
        x = vector(1, 1);
        y = vector(2, 1);
        r(ya, xa) = pixelValue(image, x, y, method);
    end
end