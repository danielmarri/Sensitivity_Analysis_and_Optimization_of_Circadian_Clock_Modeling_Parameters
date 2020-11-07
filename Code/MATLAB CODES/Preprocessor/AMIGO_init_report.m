
function AMIGO_init_report(report_path,problem_folder_path,task_folder)


% Start writing summary of results:
fid=fopen(report_path,'w');
if fid == -1
    pause(1);
    fid=fopen(report_path,'w');
end
AMIGO_release_info;
fprintf(fid,'   ***********************************\n');
fprintf(fid,'   *    AMIGO2, Copyright @CSIC      *\n');
fprintf(fid,'   *    %s    *\n',AMIGO_version);
fprintf(fid,'   *********************************** \n\n');
fprintf(fid,'Date: %s\n',date);
fprintf(fid,'Problem folder:\t %s\n',problem_folder_path);
fprintf(fid,'Results folder in problem folder:\t %s \n',task_folder);
fclose(fid);
