
function [inputs,results]= AMIGO_post_report_FIM(inputs,results,privstruct)

AMIGO_release_info;

%   Done in the AMIGO_init_report.m called in the main function: AMIGO_FIM
%     fprintf(fid,'\n\n*********************************** ');
%     fprintf(fid,'\n*     AMIGO, Copyright @CSIC      * ');
%     fprintf(fid,'\n*   %s    *',AMIGO_version);
%     fprintf(fid,'\n*********************************** ');
%     fprintf(fid,'\n\n*Date: %s',date); 
%     fprintf(fid,'\t   \n\n> Problem folder: %s\n',inputs.pathd.problem_folder_path);
%     fprintf(fid,'\t   \n> Results folder in problem folder: %s \n',inputs.pathd.task_folder);


if ~isfield(results.fit,'g_corr_mat') || isempty(results.fit.g_corr_mat)
    results.fit.g_corr_mat=1;
end

if privstruct.istate_sens >0 && sum(diag(results.fit.g_corr_mat))>0
%    AMIGO_report_confintervals
end

end