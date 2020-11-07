function AMIGO_network2file(fileName,header,varargin)

 fid = fopen(fileName,'w');
%fid = 1;

if ~isempty(header)
fprintf(fid,'%s\t',header{:});
fprintf(fid,'\n');
end
for i = 1:length(varargin{1})
    for j = 1:length(varargin)
        fprintf(fid,'%s\t',varargin{j}{i});
    end
    fprintf(fid,'\n');
end

fclose(fid);
end