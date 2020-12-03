% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Report/AMIGO_report_data.m 929 2013-09-11 14:49:34Z attila $

% AMIGO_report_data: reports experimental data
%
%******************************************************************************
% AMIGO2: dynamic modeling, optimization and control of biological systems    % 
% Code development:     Eva Balsa-Canto                                       %
% Address:              Process Engineering Group, IIM-CSIC                   %
%                       C/Eduardo Cabello 6, 36208, Vigo-Spain                %
% e-mail:               ebalsa@iim.csic.es                                    %
% Copyright:            CSIC, Spanish National Research Council               %
%******************************************************************************
%
%*****************************************************************************%
%                                                                             %
% AMIGO_report_data: reports real or pseudo experimental data                 %
%                                                                             %
%*****************************************************************************%

fprintf(fid,'\n-->Number of sampling times for each experiment:\n');

for iexp=1:inputs.exps.n_exp
    fprintf(fid,'\t\tExperiment %i: \t %i\n',iexp,inputs.exps.n_s{iexp});
end

fprintf(fid,'\n-->Sampling times for each experiment:\n');


for iexp=1:inputs.exps.n_exp
    fprintf(fid,'\t\tExperiment %i, \n',iexp);
    fprintf(fid,'\t\t\tt_s=[');
    for i=1:inputs.exps.n_s{iexp}
        fprintf(fid,'%8.3f  ',inputs.exps.t_s{iexp}(1,i));
    end
    fprintf(fid,']\n');
end

switch inputs.exps.data_type
    
    case {'pseudo','pseudo_pos'}
        fprintf(1,'\n\n--------------------------------------------------------------------------');
        fprintf(fid,'\n\n--------------------------------------------------------------------------');
        fprintf(1,'\n>>>>    Generated experimental data for each experiment:\n\n');
        fprintf(fid,'\n>>>>    Generated experimental data for each experiment:\n\n');
        for iexp=1:inputs.exps.n_exp
            fprintf(fid,'\t\t\nExperimental data %i: \n',iexp);
            fprintf(1,'\t\t\nExperimental data %i: \n',iexp);
            n_measures=inputs.exps.n_s{iexp};
            fprintf(fid,'\t\tinputs.exps.exp_data{%i}=[\n',iexp);
            fprintf(1,'\t\tinputs.exps.exp_data{%i}=[\n',iexp);
            printing_new='\t\t%g';
            for i=1:inputs.exps.n_obs{iexp}-1
                printing_new=strcat(printing_new, '  %g');
            end
            for i=1:inputs.exps.n_s{iexp}
                fprintf(fid, printing_new, inputs.exps.exp_data{iexp}(i,1:inputs.exps.n_obs{iexp}));
                fprintf(1, printing_new, inputs.exps.exp_data{iexp}(i,1:inputs.exps.n_obs{iexp}));
                fprintf(fid,'\n'); fprintf(1,'\n');
            end
            fprintf(fid,'\t\t];\n\n');fprintf(1,'\t\t];\n\n');
            
            
            fprintf(1,'\n\t\tError data %i: \n',iexp);
            fprintf(1,'\t\tStandard deviation: %g%%\n',inputs.exps.std_dev{iexp}*100);
            n_measures=inputs.exps.n_s{iexp};
            fprintf(1,'\t\tinputs.exps.error_data{%i}=[\n',iexp);
            printing_new='\t\t%g';
            for i=1:inputs.exps.n_obs{iexp}-1
                printing_new=strcat(printing_new, '  %g');
            end
            for i=1:inputs.exps.n_s{iexp}
                fprintf(1, printing_new, inputs.exps.error_data{iexp}(i,1:inputs.exps.n_obs{iexp}));
                fprintf(1,'\n'); end
            fprintf(1,'\t\t];\n\n');
            
            fprintf(fid,'\n\t\tError data %i: \n',iexp);
            fprintf(fid,'\t\tStandard deviation: %g%%\n',inputs.exps.std_dev{iexp}*100);
            n_measures=inputs.exps.n_s{iexp};
            fprintf(fid,'\t\tinputs.exps.error_data{%i}=[\n',iexp);
            printing_new='\t\t%g';
            for i=1:inputs.exps.n_obs{iexp}-1
                printing_new=strcat(printing_new, '  %g');
            end
            for i=1:inputs.exps.n_s{iexp}
                fprintf(fid, printing_new, inputs.exps.error_data{iexp}(i,1:inputs.exps.n_obs{iexp}));
                fprintf(fid,'\n');
            end
            fprintf(fid,'\t\t];\n\n');
            
            results.sim.error_data{iexp}=inputs.exps.error_data{iexp};
            
        end %for iexp=1:inputs.exps.n_exp
        fprintf(1,'\n\n--------------------------------------------------------------------------');
        fprintf(fid,'\n\n--------------------------------------------------------------------------');
        
        
    case 'real'
        
        fprintf(1,'\n\n--------------------------------------------------------------------------\n');
        fprintf(fid,'\n\n--------------------------------------------------------------------------\n');
        fprintf(fid,'\n-->Experimental data for each experiment:\n');
        for iexp=1:inputs.exps.n_exp
            fprintf(fid,'\t\t\nExperiment %i: \n',iexp);
            n_measures=inputs.exps.n_s{iexp};
            fprintf(fid,'\t\tinputs.exp_data{%i}=[\n',iexp);
            printing_new='\t\t%g';
            for i=1:inputs.exps.n_obs{iexp}-1
                printing_new=strcat(printing_new, '  %g');
            end
            for i=1:inputs.exps.n_s{iexp}
                fprintf(fid, printing_new, inputs.exps.exp_data{iexp}(i,1:inputs.exps.n_obs{iexp}));
                fprintf(fid,'\n');
            end
            fprintf(fid,'\t\t];\n\n');
        end %for iexp=1:inputs.exps.n_exp
        
        for iexp=1:inputs.exps.n_exp
            fprintf(1,'\t\t\nExperiment %i: \n',iexp);
            n_measures=inputs.exps.n_s{iexp};
            fprintf(1,'\t\tinputs.exp_data{%i}=[\n',iexp);
            printing_new='\t\t%g';
            for i=1:inputs.exps.n_obs{iexp}-1
                printing_new=strcat(printing_new, '  %g');
            end
            for i=1:inputs.exps.n_s{iexp}
                fprintf(1, printing_new, inputs.exps.exp_data{iexp}(i,1:inputs.exps.n_obs{iexp}));
                fprintf(1,'\n');
            end
            fprintf(1,'\t\t];\n\n');
        end %for iexp=1:inputs.exps.n_exp
        
        
        if strcmp(inputs.PEsol.PEcost_type,'llk')
            % error data related part needed only for log-likelihood
            % estimations. 
            
            fprintf(fid,'\n-->Noise type:%s\n', inputs.exps.noise_type);
            switch inputs.exps.noise_type
                
                
                case 'homo'
                    
                    for iexp=1:inputs.exps.n_exp
                        if isempty(inputs.exps.error_data{iexp})
                            inputs.exps.error_data{iexp}=repmat(max(inputs.exps.exp_data{iexp}).*inputs.exps.std_dev{iexp},[inputs.exps.n_s{iexp},1]);
                        end
                        
                        fprintf(1,'\n\t\tError data %i: \n',iexp);
                        n_measures=inputs.exps.n_s{iexp};
                        fprintf(1,'\t\tinputs.exps.error_data{%i}=[\n',iexp);
                        printing_new='\t\t%g';
                        for i=1:inputs.exps.n_obs{iexp}-1
                            printing_new=strcat(printing_new, '  %g');end
                        for i=1:inputs.exps.n_s{iexp}
                            fprintf(1, printing_new, inputs.exps.error_data{iexp}(i,1:inputs.exps.n_obs{iexp}));
                            fprintf(1,'\n');
                        end
                        fprintf(1,'\t\t];\n\n');
                    end
                    
                    for iexp=1:inputs.exps.n_exp
                        fprintf(fid,'\n\t\tError data %i: \n',iexp);
                        n_measures=inputs.exps.n_s{iexp};
                        fprintf(fid,'\t\tinputs.exps.error_data{%i}=[\n',iexp);
                        printing_new='\t\t%g';
                        for i=1:inputs.exps.n_obs{iexp}-1
                            printing_new=strcat(printing_new, '  %g');
                        end
                        for i=1:inputs.exps.n_s{iexp}
                            fprintf(fid, printing_new, inputs.exps.error_data{iexp}(i,1:inputs.exps.n_obs{iexp}));
                            fprintf(fid,'\n');
                        end
                        fprintf(fid,'\t\t];\n\n');
                    end
                    
                    
                case 'homo_var'
                    for iexp=1:inputs.exps.n_exp
                        fprintf(1,'\n\t\tError data %i: \n',iexp);
                        n_measures=inputs.exps.n_s{iexp};
                        fprintf(1,'\t\tinputs.exps.error_data{%i}=[\n',iexp);
                        printing_new='\t\t%g';
                        for i=1:inputs.exps.n_obs{iexp}-1
                            printing_new=strcat(printing_new, '  %g');
                        end
                        for i=1:inputs.exps.n_s{iexp}
                            fprintf(1, printing_new, inputs.exps.error_data{iexp}(i,1:inputs.exps.n_obs{iexp}));
                            fprintf(1,'\n');
                        end
                        fprintf(1,'\t\t];\n\n');
                    end
                    
                    for iexp=1:inputs.exps.n_exp
                        fprintf(fid,'\n\t\tError data %i: \n',iexp);
                        n_measures=inputs.exps.n_s{iexp};
                        fprintf(fid,'\t\tinputs.exps.error_data{%i}=[\n',iexp);
                        printing_new='\t\t%g';
                        for i=1:inputs.exps.n_obs{iexp}-1
                            printing_new=strcat(printing_new, '  %g');
                        end
                        for i=1:inputs.exps.n_s{iexp}
                            fprintf(fid, printing_new, inputs.exps.error_data{iexp}(i,1:inputs.exps.n_obs{iexp}));
                            fprintf(fid,'\n');
                        end
                        fprintf(fid,'\t\t];\n\n');
                    end
                    
                    
                    
                    %
                    %                  for iexp=1:inputs.exps.n_exp
                    %                  fprintf(1,'\t\t\nError data %i: \n',iexp);
                    %                  fprintf(1,'\t\tStandard deviation: %f%%\n',inputs.exps.std_dev{iexp}*100);
                    %                  fprintf(fid,'\t\t\nError data %i: \n',iexp);
                    %                  fprintf(fid,'\t\tStandard deviation: %f%%\n',inputs.exps.std_dev{iexp}*100);
                    %                  end
            end %switch inputs.exps.noise_type
        end %if strcmp(inputs.PEsol.PEcost_type,'llk')
        
end %switch inputs.exps.data_type

