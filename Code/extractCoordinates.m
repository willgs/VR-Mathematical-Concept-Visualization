function [coordinateMatrix, faces] = extractCoordinates(inputFigureFile)
%This will take the input figure file and extract the x-y-z coordinates
%   from the children structures of the figure file
    
%   read data into workspace 
fig = openfig(inputFigureFile,'invisible');
    
%   extract data from figure and get type --fix for 2D surfaces
d = fig.Children.Children;

switch(d.Type)
    case 'surface'
        
        [row,col] = size(d.XData);
        len = row*col;
        
        coordinateMatrix = zeros(len,3);
        
        %merge data into one coordinate matrix
        k = 1;
        for i=1:row
            for j=1:col
                coordinateMatrix(k,1) = d.XData(i,j);
                coordinateMatrix(k,2) = d.YData(i,j);
                coordinateMatrix(k,3) = d.ZData(i,j);
                k=k+1;
            end
        end
        
        faces = delaunay(d.XData,d.YData);
        
    case 'line'
        


end

