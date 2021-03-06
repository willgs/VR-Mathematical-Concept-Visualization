function [coordinateMatrix, faces, vertexNormal, faceNormal] = extractCoordinates(inputFigureFile)
%This will take the input figure file and extract the x-y-z coordinates
%   from the children structures of the figure file
    
%   read data into workspace 
fig = openfig(inputFigureFile,'invisible');
    
%   extract data from figure and get type --fix for 2D surfaces
d = fig.Children.Children;

switch(d.Type)
    case 'surface'
        
        %assign coordinate matrices to different vars
        X = d.XData;
        Y = d.YData;
        Z = d.ZData;
        
        %check if any of the coordinate matrices have vectors instead of a
        %matrix
        [row,col] = size(X);
        if row == 1 
            temp = zeros(col,col);
            for i=1:col
                temp(i,:) = X;
            end 
            X = temp;
        end
        if col == 1
            temp = zeros(row,row);
            for i=1:row
                temp(i,:) = X;
            end
            X = temp;
        end
        
        [row,col] = size(Y);
        if row == 1
            temp = zeros(col,col);
            for i=1:col
                temp(:,i) = Y;
            end 
            Y = temp;
        end
        if col == 1
            temp = zeros(row,row);
            for i=1:row
                temp(:,i) = Y;
            end
            Y = temp;
        end
        
        [row,col] = size(Z);
        if row == 1
            temp = zeros(col,col);
            for i=1:col
                temp(i,:) = Z;
            end 
            X = temp;
        end
        if col == 1
            temp = zeros(row,row);
            for i=1:row
                temp(:,i) = Z;
            end
            Z = temp;
        end
        
        
        [row,col] = size(X);
        len = row*col;
        
        coordinateMatrix = zeros(len,3);
        
        
        %merge data into one coordinate matrix
        k = 1;
        for i=1:row
            for j=1:col
                coordinateMatrix(k,1) = X(i,j);
                coordinateMatrix(k,2) = Z(i,j);
                coordinateMatrix(k,3) = Y(i,j);
                k=k+1;
            end
        end
        

        %create faces using dlaunay -- fix by trying to extract from fig
        %or using a different function to get it from the coords
        faces = delaunay(X,Y);
        
        
        %get vertex and face normals
        vertNorm = fig.Children.Children.VertexNormals;
        faceNorm = fig.Children.Children.FaceNormals;
        
        %convert into X by 3 matrices for vertexNormals matrix
        [row,col,z] = size(vertNorm);
        len = row*col;
        
        
        k = 1;
        vertexNormal = zeros(len,3);
        for i=1:row
            for j=1:col
                
                vertexNormal(k,1) = vertNorm(i,j,1);
                vertexNormal(k,2) = vertNorm(i,j,2);
                vertexNormal(k,3) = vertNorm(i,j,3);
                k=k+1;
            end
        end
        
        %convert into X by 3 matrices for faceNormals matrix
        [row,col,z] = size(faceNorm);
        len = row*col;
        
        k = 1;
        faceNormal = zeros(len,3);
        for i=1:row
            for j=1:col
                faceNormal(k,1) = faceNorm(i,j,1);
                faceNormal(k,2) = faceNorm(i,j,2);
                faceNormal(k,3) = faceNorm(i,j,3);
                k=k+1;
            end
        end
        
        %invert face normals and add them to the matrix so object can be
        %seen from the other direction too
        [len,~] = size(faceNormal);
        invertedNorms = zeros(len,3);
        for i=1:len
            invertedNorms(len,1) = faceNormal(len,1)*-1;
            invertedNorms(len,2) = faceNormal(len,2)*-1;
            invertedNorms(len,3) = faceNormal(len,3)*-1;
        end
        
%         faceNormal = [faceNormal;invertedNorms];
        
        
        
    case 'line'
        coordinateMatrix = -1;
        faces = 0;
        vertexNormal = 0;
        faceNormal = 0;
        return;


end

