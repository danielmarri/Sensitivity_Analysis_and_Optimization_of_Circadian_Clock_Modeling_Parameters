function AMIGO_cellstr2htmltable(cs,fid)
% AMIGO_cellstr2htmltable converts the cell string into a html table and writes to the file



[nrow ncolumn] = size(cs);

for irow = 1:nrow
    fprintf(fid,'\t<tr>\n');
    for icolumn=1:ncolumn
        
        
        
        fprintf(fid,'<td>%s',cs{irow,icolumn});
        
        
        
    end
    fprintf(fid,'\t</tr>\n');
end
    