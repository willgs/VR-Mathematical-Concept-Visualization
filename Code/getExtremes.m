function [highLow] = getExtremes(vertices)
%Takes in xyz vertices and returns a struct with the extremes for each
%coordinate axis

highLow = struct;

[row, col] = size(vertices);

for j=1:col
    
    high = vertices(1,j);
    low = high;
    
    for i=2:row
        if vertices(i,j) > high
            high = vertices(i,j);
        end
        if vertices(i,j) < low
            low = vertices(i,j);
        end
    end
    
    if j == 1
        highLow.xHigh = high;
        highLow.xLow = low;
    end
    if j == 2
        highLow.yHigh = high;
        highLow.yLow = low;
    end
    if j == 3
        highLow.zHigh = high;
        highLow.zLow = low;
    end

end

