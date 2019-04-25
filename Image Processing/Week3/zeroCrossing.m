function output = zeroCrossing(F, Fw)
[s1, s2] = size(F);
output = zeros(s1, s2);
for i = 2:s1-1
    for j =2:s2-1
        if Fw(i, j) > 0
            if F(i, j-1) < 0 && F(i, j+1) >= 0
                output(i, j) = F(i, j);
            elseif F(i, j-1) >= 0 && F(i, j+1) < 0
                output(i, j) = F(i, j);
            elseif F(i-1, j) < 0 && F(i+1, j) >= 0
                output(i, j) = F(i, j);
            elseif F(i-1, j) >= 0 && F(i+1, j) < 0
                output(i, j) = F(i, j);
            elseif F(i-1, j-1) < 0 && F(i+1, j+1) >= 0
                output(i, j) = F(i, j);
            elseif F(i-1, j-1) >= 0 && F(i+1, j+1) < 0
                output(i, j) = F(i, j);
            elseif F(i+1, j-1) >= 0 && F(i-1, j+1) < 0
                output(i, j) = F(i, j);
            elseif F(i+1, j-1) < 0 && F(i-1, j+1) >= 0
                output(i, j) = F(i, j);
            else
                output(i, j) = 0;
            end
        else
            output(i, j) = 0;
        end
    end
end

