% EBC generates input structure from SBML file
%
%

SBMLModel=TranslateSBML(strcat(inputs.model.sbmlmodel_file,'.xml'),1,0);

[ParameterNames, ParameterValues] = GetAllParametersUnique(SBMLModel);
% ParameterNames = {SBMLModel.parameter.id};
% ParameterValues = [SBMLModel.parameter.value];

Species = AnalyseSpecies(SBMLModel);
NumberSpecies = length(SBMLModel.species);
Speciesnames = GetSpecies(SBMLModel);
NumFuncs = length(SBMLModel.functionDefinition);

% READ STATES: names and nominal initial conditions
inputs.model.n_st=length(Species);                   % Number of states

inputs.model.st_names=char(Speciesnames');           % Names of the states
inputs.model.nominal_initial_conditions=[Species.initialValue]; % These are nominal values for the intial conditions

% ASSIGNEMENTS
n_par_INIT=length(ParameterNames);
index_par_INIT=[1:n_par_INIT];
n_stimulus_INIT=0;
stimulus_names=[];
index_stimulus=[];
u_INIT=[];
index_non_cte=[];
inputs.model.piecewise_times=0;
inputs.model.piecewiseF=[];

% READ PARAMETERS - CHECK WHETHER THEY ARE CONSTANT

if sum([SBMLModel.parameter.constant])<n_par_INIT
    
    disp('-----> Non-constant parameter(s) detected');
    
    index_non_cte=find([SBMLModel.parameter.constant]<1);
    
    ParameterNames(index_non_cte)
    
    
    if size(SBMLModel.event,2) >0
        
        n_steps=size(SBMLModel.event,2);
        disp('-----> EVENTS in non-constant parameters');
        for i_non_cte_par=1:length(index_non_cte)
            for i_event=1:n_steps-1
                if strcmp(ParameterNames(i_non_cte_par),SBMLModel.event(i_event).eventAssignment.variable)
                    index_stimulus=[index_stimulus i_non_cte_par];
                    n_stimulus_INIT=n_stimulus_INIT+1;
                    stimulus_names=[stimulus_names ParameterNames(i_non_cte_par)];
                end
            end %i_event
        end %i_non_cte_par
    end
    
    % there can be assignment rules that are not events, so we should not
    % use an elseif
    if size(SBMLModel.rule,2) >0
        
        disp('-----> RULES in non-constant parameters');
        
        % store 
        variables_rules = {SBMLModel.rule.variable};
        formula_rules = {SBMLModel.rule.formula};
        
        for i_non_cte_par=1:length(index_non_cte)
            temp_par = ParameterNames(index_non_cte(i_non_cte_par));
            if any(strcmp(ParameterNames(index_non_cte(i_non_cte_par)), variables_rules))
                idx_var_rule = find(strcmp(variables_rules, temp_par ) == 1);
                
                [iinit, iend] = regexpi(formula_rules{idx_var_rule}, 'piecewise(');
                
                if iinit
                    
                    fprintf('*****WARNING: AMIGO handles PIECEWISE rules******\n');
                    
                    lttime=cell2mat(regexp(SBMLModel.rule.formula,'lt(time,\d*|lt(time,\d+.\d+','Match'));
                    inputs.model.piecewise_times=cell2mat(regexp(lttime,'\d*|\d+.\d+','Match')');
                    
                    %                     for i=1:length(index_lt_times)
                    %                    [inputs.model.piecewise_times(i), dummy]=regexp(lttime(index_lt_times(i)),'\d*|\d+.\d+','Match');
                    %                    end
                    
                    inputs.model.n_piecewiseF=length(inputs.model.piecewise_times)+1;
                    i_commas= regexp(SBMLModel.rule.formula,',');
                    i_and=regexp(SBMLModel.rule.formula,',and');
                    
                    inputs.model.piecewiseF{1}=SBMLModel.rule.formula(iend+1:i_commas(1)-1);
                    
                    
                    ipF=2;
                    for j=1:length(i_commas)
                        for k=1:length(i_and)
                            if i_commas(j)==i_and(k)
                                inputs.model.piecewiseF{ipF}=SBMLModel.rule.formula(i_commas(j-1)+1:i_commas(j)-1);
                                ipF=ipF+1;
                            end
                        end
                    end
                    inputs.model.piecewiseF{inputs.model.n_piecewiseF}=SBMLModel.rule.formula(i_commas(end)+1:end-1);
                end %iinit
            end %strcmp(ParameterNames(i_non_cte_par),SBMLModel.rule.variable)
            
            
        end %i_non_cte_par
        
    end    %size(SBMLModel.event,2) >0
    
end


% CONSTANT PARAMETERS: names and nominal values

index_par=setdiff([1:1:length(ParameterNames)],index_non_cte);
inputs.model.n_par=length(ParameterNames(index_par));           % Number of model parameters
inputs.model.par_names=char(ParameterNames(index_par)');        % Names of the parameters
inputs.model.par=ParameterValues(index_par);                    % These values may be updated during optimization



% NON-CONSTANT PARAMETERS - STIMULI: names and nominal values


if n_stimulus_INIT>0
    disp('-----> Stimuli');
    unique(stimulus_names)
    inputs.model.stimulus_names=unique(stimulus_names);  % Names of the stimuli, inputs or controls
    inputs.model.n_stimulus=length(inputs.model.stimulus_names);                    % Number of inputs, stimuli or control variables
    u_INIT=zeros(inputs.model.n_stimulus,size(SBMLModel.event,2)+1);
    u_times=zeros(inputs.model.n_stimulus,size(SBMLModel.event,2));
    for iu=1:inputs.model.n_stimulus
        u_INIT(iu,1)=ParameterValues(unique(index_stimulus));
        j=2;
        for i_event=1:n_steps
            u_INIT(iu,j)=str2num(SBMLModel.event(i_event).eventAssignment.math);
            u_times(iu,j-1)=str2double(regexp(SBMLModel.event(i_event).trigger.math,'\d*\.\d+|\d+','Match'));
            j=j+1;
        end
    end
end

% TIME SYMBOL IN SBML
inputs.model.time_symbol=SBMLModel.time_symbol;

% changed by Willi: If there is no time dependency in the model, use "time"
if strcmp(inputs.model.time_symbol, '')
    SBMLModel.time_symbol = 'time';
    inputs.model.time_symbol = 'time';
end



