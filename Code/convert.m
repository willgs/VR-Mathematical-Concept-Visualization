function convert(inputFigureFileName)
%This function will be the parent converter, utilizing other functions and
%   its own algorithms to convert a figure file to an object file
  
%create structure and fill it with the coordinates and faces of the figure
FV = struct;
[vertices, faces, vertexNorms, faceNorms] = extractCoordinates(inputFigureFileName);
FV.vertices = vertices;
FV.faces = faces;
FV.vNorms = vertexNorms;
FV.fNorms = faceNorms;

%   BASED OFF OF KROON ALGORITHM

%  This MTL commented out code is for the future, if the next individual
%  wishes to implement MTL as a way of sending imaging information to unity

% % Make a material structure
% material(1).type='newmtl';
% material(1).data='skin';
% material(2).type='Ka';
% material(2).data=[1 1 1];
% material(3).type='Kd';
% material(3).data=[0.8 0.4 0.4];
% material(4).type='Ks';
% material(4).data=[1 1 1];
% material(5).type='illum';
% material(5).data=2;
% material(6).type='Ns';
% material(6).data=27;

% Make OBJ structure
clear OBJ
OBJ.vertices = FV.vertices;
OBJ.vertices_normal = FV.fNorms; %CHANGE BACK TO NORMALS IF CAN
OBJ.material = material;
OBJ.objects(1).type='g';
OBJ.objects(1).data='skin';
OBJ.objects(2).type='usemtl';
OBJ.objects(2).data='skin';
OBJ.objects(3).type='f';
OBJ.objects(3).data.vertices=FV.faces;
OBJ.objects(3).data.normal=FV.faces;


if(exist('fullfilename','var')==0)
    [filename, filefolder] = uiputfile('*.obj', 'Write obj-file');
    fullfilename = [filefolder filename];
end
[filefolder,filename] = fileparts( fullfilename);

%create struct with high and low values for each axis coordinate
extremes = getExtremes(vertices);
write_CSV(extremes,filefolder,filename);

comments=cell(1,4);
comments{1}=' Produced by Matlab Write Wobj exporter ';
comments{2}='';
fid = fopen(fullfilename,'w');

write_comment(fid,comments);

% if(isfield(OBJ,'material')&&~isempty(OBJ.material))
%     filename_mtl=fullfile(filefolder,[filename '.mtl']);
%     fprintf(fid,'mtllib %s\n',filename_mtl);
%     write_MTL_file(filename_mtl,OBJ.material)
%     
% end

disp('CONVERTING.....');

if(isfield(OBJ,'vertices')&&~isempty(OBJ.vertices))
    write_vertices(fid,OBJ.vertices,'v');
end
if(isfield(OBJ,'vertices_point')&&~isempty(OBJ.vertices_point))
    write_vertices(fid,OBJ.vertices_point,'vp');
end
if(isfield(OBJ,'vertices_normal')&&~isempty(OBJ.vertices_normal))
    write_vertices(fid,OBJ.vertices_normal,'vn');
end
if(isfield(OBJ,'vertices_texture')&&~isempty(OBJ.vertices_texture))
    write_vertices(fid,OBJ.vertices_texture,'vt');
end
for i=1:length(OBJ.objects)
    type=OBJ.objects(i).type;
    data=OBJ.objects(i).data;
    switch(type)
        case 'usemtl'
            fprintf(fid,'usemtl %s\n',data);
        case 'f'
            check1=(isfield(OBJ,'vertices_texture')&&~isempty(OBJ.vertices_texture));
            check2=(isfield(OBJ,'vertices_normal')&&~isempty(OBJ.vertices_normal));
            if(check1&&check2)
                for j=1:size(data.vertices,1)
                    fprintf(fid,'f %d/%d/%d',data.vertices(j,1),data.texture(j,1),data.normal(j,1));
                    fprintf(fid,' %d/%d/%d', data.vertices(j,2),data.texture(j,2),data.normal(j,2));
                    fprintf(fid,' %d/%d/%d\n', data.vertices(j,3),data.texture(j,3),data.normal(j,3));
                end
            elseif(check1)
                for j=1:size(data.vertices,1)
                    fprintf(fid,'f %d/%d',data.vertices(j,1),data.texture(j,1));
                    fprintf(fid,' %d/%d', data.vertices(j,2),data.texture(j,2));
                    fprintf(fid,' %d/%d\n', data.vertices(j,3),data.texture(j,3));
                end
            elseif(check2)
                for j=1:size(data.vertices,1)
                    fprintf(fid,'f %d//%d',data.vertices(j,1),data.normal(j,1));
                    fprintf(fid,' %d//%d', data.vertices(j,2),data.normal(j,2));
                    fprintf(fid,' %d//%d\n', data.vertices(j,3),data.normal(j,3));
                end
            else
                for j=1:size(data.vertices,1)
                    fprintf(fid,'f %d %d %d\n',data.vertices(j,1),data.vertices(j,2),data.vertices(j,3));
                end
            end
        otherwise
            fprintf(fid,'%s ',type);
            if(iscell(data))
                for j=1:length(data)
                    if(ischar(data{j}))
                        fprintf(fid,'%s ',data{j});
                    else
                        fprintf(fid,'%0.5g ',data{j});
                    end
                end 
            elseif(ischar(data))
                 fprintf(fid,'%s ',data);
            else
                for j=1:length(data)
                    fprintf(fid,'%0.5g ',data(j));
                end      
            end
            fprintf(fid,'\n');
    end
end
fclose(fid);
disp('SUCCESS');

end

