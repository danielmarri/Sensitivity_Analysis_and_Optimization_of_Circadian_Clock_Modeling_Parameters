% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Report/AMIGO_report_identifiability.m 2202 2015-09-24 07:10:57Z evabalsa $
   %
   %    REPORTS RESULTS
   %
     fid=fopen(inputs.pathd.report,'a+');

   % MEAN VALUE AND CONFIDENCE INTERVALS USING THE HYPER-ELLIPSOID
     
     
     fprintf(1,'\n\n>>> Mean value and confidence interval using the hyper-ellipsoid:\n');  %
     fprintf(fid,'\n\n>>> Mean value and confidence interval using the hyper-ellipsoid:\n');  %
     
     fprintf(fid,'\n\n>>> Estimated global parameters: \n');  
     fprintf(1,'\n\n>>> Estimated global parameters: \n');  

        for i=1:inputs.PEsol.n_global_theta
                      
            if numel(inputs.model.par_names)>1
            fprintf(1,'\t%s : %8.4e  +-  %8.4e (%8.4e percent); \n',inputs.model.par_names(inputs.PEsol.index_global_theta(1,i),:),...
                results.rid.mu(i),results.rid.confidence_interval(i),100*results.rid.confidence_norm(i));   
            fprintf(fid,'\t%s : %8.4e  +-  %8.4e (%8.4e percent); \n',inputs.model.par_names(inputs.PEsol.index_global_theta(1,i),:),...
                results.rid.mu(i),results.rid.confidence_interval(i),100*results.rid.confidence_norm(i));   
            else
            fprintf(1,'\ttheta(%u): %8.4e  +-  %8.4e (%8.4e percent); \n',inputs.PEsol.index_global_theta(1,i),results.rid.mu(i),...
                results.rid.confidence_interval(i),100*results.rid.confidence_norm(i));     
            fprintf(fid,'\ttheta(%u): %8.4e  +-  %8.4e (%8.4e percent); \n',inputs.PEsol.index_global_theta(1,i),results.rid.mu(i),...
                results.rid.confidence_interval(i),100*results.rid.confidence_norm(i));    
            end
        end %i=1:inputs.n_theta
     
    if inputs.PEsol.n_global_theta_y0>0
    fprintf(fid,'\n\n>>> Estimated global initial conditions: \n');  
    fprintf(1,'\n\n>>> Estimated global initial conditions: \n');  
        j=1;
        for i=inputs.PEsol.n_global_theta+1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0
        
            if numel(inputs.model.par_names)>1
            fprintf(1,'\t%s : %8.4e  +-  %8.4e (%8.4e percent); \n',inputs.model.st_names(inputs.PEsol.index_global_theta_y0(1,j),:),...
                results.rid.mu(i),results.rid.confidence_interval(i),100*results.rid.confidence_norm(i));    
            fprintf(fid,'\t%s : %8.4e  +-  %8.4e (%8.4e percent); \n',inputs.model.st_names(inputs.PEsol.index_global_theta_y0(1,j),:),...
                results.rid.mu(i),results.rid.confidence_interval(i),100*results.rid.confidence_norm(i));   
            else
            fprintf(1,'\ty0(%u): %8.4e  +-  %8.4e (%8.4e percent); \n',inputs.PEsol.index_global_theta_y0(1,j),...
                results.rid.mu(i),results.rid.confidence_interval(i),100*results.rid.confidence_norm(i));   
            fprintf(fid,'\ty0(%u): %8.4e  +-  %8.4e (%8.4e percent); \n',inputs.PEsol.index_global_theta_y0(1,j),...
            results.rid.mu(i),results.rid.confidence_interval(i),100*results.rid.confidence_norm(i));   
            end
            j=j+1;
        end %i=1:inputs.n_theta
               
    end %if inputs.PEsol.n_global_theta_y0>0
  
  
if inputs.PEsol.ntotal_local_theta>0
fprintf(fid,'\n\n>>> Estimated local parameters: \n');  
fprintf(1,'\n\n>>> Estimated local parameters: \n');  

counter_g=inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0;
j=1;
for iexp=1:inputs.exps.n_exp

        for i=1:inputs.PEsol.n_local_theta{iexp}
        
            if numel(inputs.model.par_names)>1
            fprintf(1,'\tExperiment %u, %s : %8.4e  +-  %8.4e (%8.4e percent); \n',iexp,inputs.model.par_names(inputs.PEsol.index_local_theta{iexp}(1,j),:),...
                results.rid.mu(counter_g+i),results.rid.confidence_interval(counter_g+i),100*results.rid.confidence_norm(counter_g+i));      
            fprintf(fid,'\tExperiment %u, %s : %8.4e  +-  %8.4e (%8.4e percent); \n',inputs.model.par_names(inputs.PEsol.index_local_theta{iexp}(1,j),:),...
                results.rid.mu(counter_g+i),results.rid.confidence_interval(counter_g+i),100*results.rid.confidence_norm(counter_g+i));   
            else
            fprintf(1,'\tExperiment %u, theta(%u): %8.4e  +-  %8.4e (%8.4e percent); \n',iexp,inputs.PEsol.index_local_theta{iexp}(1,j),...
                results.rid.mu(counter_g+i),results.rid.confidence_interval(counter_g+i),100*results.rid.confidence_norm(counter_g+i));       
            fprintf(fid,'\tExperiment %u, theta(%u): %8.4e  +-  %8.4e (%8.4e percent); \n',iexp,inputs.PEsol.index_local_theta{iexp}(1,j),...
                results.rid.mu(counter_g+i),results.rid.confidence_interval(counter_g+i),100*results.rid.confidence_norm(counter_g+i));     
            end

            j=j+1;
        end %i=1:inputs.n_theta
        j=1;
        counter_g=counter_g+inputs.PEsol.n_local_theta{iexp};
    end %iexp      
               
 end %if inputs.PEsol.ntotal_local_theta_y0>0
 

if inputs.PEsol.ntotal_local_theta_y0>0
fprintf(fid,'\n\n>>> Estimated local initial conditions: \n');  
fprintf(1,'\n\n>>> Estimated local initial conditions: \n');  

counter_gl=inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0+inputs.PEsol.ntotal_local_theta;
for iexp=1:inputs.exps.n_exp

        for i=1:inputs.PEsol.n_local_theta_y0{iexp}
                         
            if numel(inputs.model.st_names)>1
            fprintf(1,'\tExperiment %u, %s : %8.4e  +-  %8.4e (%8.4e percent); \n',iexp,inputs.model.st_names(inputs.PEsol.index_local_theta_y0{iexp}(1,i),:),...
                results.rid.mu(counter_gl+i),results.rid.confidence_interval(counter_gl+i),100*results.rid.confidence_norm(counter_gl+i));     
            fprintf(fid,'\tExperiment %u, %s : %8.4e  +-  %8.4e (%8.4e percent); \n',iexp,inputs.model.st_names(inputs.PEsol.index_local_theta_y0{iexp}(1,i),:),...
                results.rid.mu(counter_gl+i),results.rid.confidence_interval(counter_gl+i),100*results.rid.confidence_norm(counter_gl+i));   
            else
            fprintf(1,'\tExperiment %u, y0(%u): %8.4e  +-  %8.4e (%8.4e percent); \n',iexp,inputs.PEsol.index_local_theta_y0{iexp}(1,i),...
               results.rid.mu(counter_gl+i),results.rid.confidence_interval(counter_gl+i),100*results.rid.confidence_norm(counter_gl+i));     
            fprintf(fid,'\tExperiment %u, y0(%u): %8.4e  +-  %8.4e (%8.4e percent); \n',iexp,inputs.PEsol.index_local_theta_y0{iexp}(1,i),...
                results.rid.mu(counter_gl+i),results.rid.confidence_interval(counter_gl+i),100*results.rid.confidence_norm(counter_gl+i));    
            end
            counter_gl=counter_gl+1;
        end %i=1:inputs.n_theta
        
    end %iexp      
               
 end %if inputs.PEsol.ntotal_local_theta_y0>0    
 
 
     
     %   DISTANCE FROM MEAN TO THETA*  
          
     
     
     
     fprintf(1,'\n\n>>> Distance from mean to theta*:\n');  
     fprintf(fid,'\n\n>>> Distance from mean to theta*:\n');
     
        for i=1:inputs.PEsol.n_global_theta
                      
            if numel(inputs.model.par_names)>1
            fprintf(1,'\tlambda(%s) : %8.4e; \n',inputs.model.par_names(inputs.PEsol.index_global_theta(1,i),:),results.rid.lambda(i));   
            fprintf(fid,'\tlambda(%s) : %8.4e; \n',inputs.model.par_names(inputs.PEsol.index_global_theta(1,i),:),results.rid.lambda(i));   
            else
            fprintf(1,'\tlambda(theta(%u)): %8.4e; \n',inputs.PEsol.index_global_theta(1,i),results.rid.lambda(i));  
            fprintf(fid,'\tlambda(theta(%u)): %8.4e; \n',inputs.PEsol.index_global_theta(1,i),results.rid.lambda(i));  
            end
        end %i=1:inputs.n_theta
     
    if inputs.PEsol.n_global_theta_y0>0
    fprintf(fid,'\n>>> Estimated global initial conditions: \n');  
    fprintf(1,'\n>>> Estimated global initial conditions: \n');  
        j=1;
        for i=inputs.PEsol.n_global_theta+1:inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0
            if numel(inputs.model.par_names)>1
            fprintf(1,'\tlambda(%s) : %8.4e;\n',inputs.model.st_names(inputs.PEsol.index_global_theta_y0(1,j),:),results.rid.lambda(i));      
            fprintf(fid,'\tlambda(%s) : %8.4e;\n',inputs.model.st_names(inputs.PEsol.index_global_theta_y0(1,j),:),results.rid.lambda(i));   
            else
            fprintf(1,'\tlambda(y0(%u)): %8.4e; \n',inputs.PEsol.index_global_theta_y0(1,j),results.rid.lambda(i));   
            fprintf(fid,'\tlambda(y0(%u)): %8.4e; \n',inputs.PEsol.index_global_theta_y0(1,j),results.rid.lambda(i));   
            end
            j=j+1;
        end %i=1:inputs.n_theta
               
 end %if inputs.PEsol.n_global_theta_y0>0
  
  
if inputs.PEsol.ntotal_local_theta>0
fprintf(fid,'\n>>> Distance from mean to estimated local parameters: \n');  
fprintf(1,'\n>>> Distance from mean to estimated local parameters:\n');  

counter_g=inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0;
j=1;
for iexp=1:inputs.exps.n_exp

        for i=1:inputs.PEsol.n_local_theta{iexp}
                      
            if numel(inputs.model.par_names)>1
            fprintf(1,'\tExperiment %u, lambda(%s) : %8.4e; \n',iexp,inputs.model.par_names(inputs.PEsol.index_local_theta{iexp}(1,j),:),results.rid.lambda(counter_g+i));   
            fprintf(fid,'\tExperiment %u, lambda(%s) : %8.4e; \n',iexp,inputs.model.par_names(inputs.PEsol.index_local_theta{iexp}(1,j),:),results.rid.lambda(counter_g+i)); 
            else
            fprintf(1,'\tExperiment %u, lambda(theta(%u)) : %8.4e; \n',iexp,inputs.PEsol.index_local_theta{iexp}(1,j),results.rid.lambda(counter_g+i));     
            fprintf(fid,'\tExperiment %u, lambda(theta(%u)) : %8.4e; \n',iexp,inputs.PEsol.index_local_theta{iexp}(1,j),results.rid.lambda(counter_g+i));   
            end
              j=j+1;
        end %i=1:inputs.n_theta
        j=1;
        counter_g=counter_g+inputs.PEsol.n_local_theta{iexp};
    end %iexp      
               
 end %if inputs.PEsol.ntotal_local_theta_y0>0
 

if inputs.PEsol.ntotal_local_theta_y0>0
fprintf(fid,'\n>>> Estimated local initial conditions: \n');  
fprintf(1,'\n>>> Estimated local initial conditions: \n');  

counter_gl=inputs.PEsol.n_global_theta+inputs.PEsol.n_global_theta_y0+inputs.PEsol.ntotal_local_theta;
for iexp=1:inputs.exps.n_exp

        for i=1:inputs.PEsol.n_local_theta_y0{iexp}
                         
            if numel(inputs.model.st_names)>1
            fprintf(1,'\tExperiment %u, lambda(%s) : %8.4e; \n',iexp,inputs.model.st_names(inputs.PEsol.index_local_theta_y0{iexp}(1,i),:),results.rid.lambda(counter_gl+i));   
            fprintf(fid,'\tExperiment %u, lambda(%s) : %8.4e; \n',iexp,inputs.model.st_names(inputs.PEsol.index_local_theta_y0{iexp}(1,i),:),results.rid.lambda(counter_gl+i)); 
            else
            fprintf(1,'\tExperiment %u, lambda(y0(%u)) : %8.4e; \n',iexp,inputs.PEsol.index_local_theta_y0{iexp}(1,i),results.rid.lambda(counter_gl+i));     
            fprintf(fid,'\tExperiment %u, lambda(y0(%u)) : %8.4e; \n',iexp,inputs.PEsol.index_local_theta_y0{iexp}(1,i),results.rid.lambda(counter_gl+i));   
            end
            counter_gl=counter_gl+1;
        end %i=1:inputs.n_theta
        
    end %iexp      
               
 end %if inputs.PEsol.ntotal_local_theta_y0>0    
     fprintf(1,'\n\n>>> Total distance, lambda_total = %f \n', results.rid.lambda_total); 
     fprintf(fid,'\n\n>>> Total distance, lambda_total = %f \n', results.rid.lambda_total);
         
         
     fprintf(1,'\n\n>>> Confidende hyper-ellipsoid orientation and eccentricity:\n');  
     fprintf(fid,'\n\n>>> Confidende hyper-ellipsoid  orientation and eccentricity:\n');    
     
     fprintf(1,'\n\t Maximum angle: %8.4f', results.rid.alfa_max*180/pi); 
     fprintf(1,'\n\t Minimum angle: %8.4f', results.rid.alfa_min*180/pi);
     fprintf(1,'\n\t Mean angle: %8.4f\n\n', results.rid.alfa_mean*180/pi);
     fprintf(fid,'\n\t Maximum angle: %8.4f', results.rid.alfa_max*180/pi); 
     fprintf(fid,'\n\t Minimum angle: %8.4f', results.rid.alfa_min*180/pi);
     fprintf(fid,'\n\t Mean angle: %8.4f\n\n', results.rid.alfa_mean*180/pi);
     
     fprintf(1,'\n\t Maximum eccentricity: %8.4f', results.rid.ecc_max); 
     fprintf(1,'\n\t Minimum eccentricity: %8.4f', results.rid.ecc_min);
     fprintf(1,'\n\t Mean eccentricity: %8.4f\n\n', results.rid.ecc_mean);
     fprintf(fid,'\n\t Maximum eccentricity: %8.4f', results.rid.ecc_max); 
     fprintf(fid,'\n\t Minimum eccentricity: %8.4f', results.rid.ecc_min);
     fprintf(fid,'\n\t Mean eccentricity: %8.4f\n\n', results.rid.ecc_mean);
      

    fprintf(1,'\n\n>>> Confidence hyper-ellipsoid pseudo-volume: %e\n',results.rid.ellipse_pseudo_vol); 
       
    fprintf(1,'\n\t Monte Carlo-based correlation_mat=[\n');
    fprintf(fid,'\n\n>>> Confidence hyper-ellipsoid pseudo-volume: %e\n',results.rid.ellipse_pseudo_vol); 
    
    fprintf(fid,'\n\t Monte Carlo-based correlation_mat=[\n');

    for i=1:inputs.PEsol.n_theta
       fprintf(1,'\t');
       fprintf(fid,'\t');
         for j=1:inputs.PEsol.n_theta
              fprintf(1,'%10.3f  ',results.rid.mc_corrmat(i,j));
              fprintf(fid,'%10.3f  ',results.rid.mc_corrmat(i,j));
         end
       fprintf(1,'\n');
       fprintf(fid,'\n');
     end
       fprintf(1,'\t];');
       fprintf(fid,'\t];');
       
    fprintf(fid,'\n\t Eccentricity based correlation_mat=[\n');
 fprintf(1,'\n\t Eccentricity based correlation_mat=[\n');
    for i=1:inputs.PEsol.n_theta
       fprintf(1,'\t');
       fprintf(fid,'\t');
         for j=1:inputs.PEsol.n_theta
              fprintf(1,'%10.3f  ',results.rid.ecc(i,j));
              fprintf(fid,'%10.3f  ',results.rid.ecc(i,j));
         end
       fprintf(1,'\n');
       fprintf(fid,'\n');
     end
       fprintf(1,'\t];');
       fprintf(fid,'\t];');
       
       
fclose(fid);