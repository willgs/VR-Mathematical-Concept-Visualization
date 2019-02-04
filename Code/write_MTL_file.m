function write_MTL_file(filename,material)
fid = fopen(filename,'w');
    comments=cell(1,2);
    comments{1}=' Produced by Matlab Write Wobj exporter ';
    comments{2}='';
    write_comment(fid,comments);
    for i=1:length(material)
        type=material(i).type;
        data=material(i).data;
        switch(type)
            case('newmtl')
                fprintf(fid,'%s ',type);
                fprintf(fid,'%s\n',data);
            case{'Ka','Kd','Ks'}
                fprintf(fid,'%s ',type);
                fprintf(fid,'%5.5f %5.5f %5.5f\n',data);
            case('illum')
                fprintf(fid,'%s ',type);
                fprintf(fid,'%d\n',data);
            case {'Ns','Tr','d'}
                fprintf(fid,'%s ',type);
                fprintf(fid,'%5.5f\n',data);
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


    comments=cell(1,2);
    comments{1}='';
    comments{2}=' EOF';
    write_comment(fid,comments);
    fclose(fid);
end

