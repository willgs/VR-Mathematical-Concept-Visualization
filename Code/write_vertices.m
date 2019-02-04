function write_vertices(fid,V,type)
switch size(V,2)
        case 1
            for i=1:size(V,1)
                fprintf(fid,'%s %5.5f\n', type, V(i,1));
            end
        case 2
            for i=1:size(V,1)
                fprintf(fid,'%s %5.5f %5.5f\n', type, V(i,1), V(i,2));
            end
        case 3
            for i=1:size(V,1)
                fprintf(fid,'%s %5.5f %5.5f %5.5f\n', type, V(i,1), V(i,2), V(i,3));
            end
        otherwise
    end
    switch(type)
        case 'v'
            fprintf(fid,'# %d vertices \n', size(V,1));
        case 'vt'
            fprintf(fid,'# %d texture verticies \n', size(V,1));
        case 'vn'
            fprintf(fid,'# %d normals \n', size(V,1));
        otherwise
            fprintf(fid,'# %d\n', size(V,1));

    end

end

