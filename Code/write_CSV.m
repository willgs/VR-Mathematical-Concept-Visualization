function write_CSV(dataStruct,fileFolder,filename)
%Takes in a 1 dimensional struct, and outputs it to a CSV file in the specified location
% FORMAT FOLLOWS standard based on https://tools.ietf.org/html/rfc4180
filename_csv=fullfile(fileFolder,[filename '.csv']);
fid = fopen(filename_csv,'w');

%pull the name fields out of the struct
names = fields(dataStruct);
[numFields,~] = size(names);

%check to make sure struct is one dimensional
for i=1:numFields
    if isstruct(eval(sprintf("dataStruct.%s",names{i})))
        disp("ERROR: struct is a multi-dimensional struct. This function only handles 1 dimension");
        return
    end
end

%starting writing fields
for i=1:numFields
    if 1 < numFields
        fprintf(fid,"%s,",names{i});
    else
        fprintf(fid,"%s",names{i});
    end
end

fprintf(fid,'\n');

%write values for fields
for i=1:numFields
    if 1 < numFields
        fprintf(fid,"%s,",num2str(eval(sprintf("dataStruct.%s",names{i}))));
    else
        fprintf(fid,"%s",num2str(eval(sprintf("dataStruct.%s",names{i}))));
    end
end

fprintf(fid,'\n');

fclose(fid);
    
end

