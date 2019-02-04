function write_comment(fid,comments)
for l=1:length(comments), fprintf(fid,'# %s\n',comments{l});
    end
end

