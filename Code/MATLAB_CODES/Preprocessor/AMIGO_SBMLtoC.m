function [model_eqns]=AMIGO_SBMLtoC(varargin)
% 
%  Generates a inputs.model.eqns to write C code ODE function
%  to be solved with cvodes
%  Eva Balsa-Canto
%  July 2018
%  

switch (nargin)
        
    case 5
        SBMLModel = varargin{1};
        filename = varargin{2};
        flag=varargin{3}; % 0 for the case ODES and 1 for the case SENS
        filepath= varargin{4}; 
        inputs_model=varargin{5};
                
    otherwise
        error('WriteODEFunction(SBMLModel, (optional) filename)\n%s', 'does not take more than two arguments');
end;

% check input is an SBML model
if (~isSBML_Model(SBMLModel))
    error('AMIGO_SBMLtoC(SBMLModel, (optional) filename)\n%s', 'first argument must be an SBMLModel structure');
end;

% -------------------------------------------------------------
% get information from the model

%[ParameterNames, ParameterValues] = GetAllParametersUnique(SBMLModel);
ParameterNames=inputs_model.par_names;
ParameterValues=inputs_model.par;

Species = AnalyseSpecies(SBMLModel);
NumberSpecies = length(SBMLModel.species);
SpeciesNames = GetSpecies(SBMLModel);

[CompartmentNames, CompartmentValues] = GetCompartments(SBMLModel);


if (SBMLModel.SBML_level == 2)
    NumEvents = length(SBMLModel.event);
    NumFuncs = length(SBMLModel.functionDefinition);
   
    % version 2.0.2 adds the time_symbol field to the model structure
    % need to check that it exists
    if (isfield(SBMLModel, 'time_symbol'))
        if (~isempty(SBMLModel.time_symbol))
            timeVariable = SBMLModel.time_symbol;
        else
            timeVariable = 'time';
        end;
    else
        timeVariable = 'time';
    end;

else
    NumEvents = 0;
    NumFuncs = 0;
    timeVariable = 'time';
end;



%---------------------------------------------------------------
% get the name/id of the model

Name = '';
if (SBMLModel.SBML_level == 1)
    Name = SBMLModel.name;
else
    if (isempty(SBMLModel.id))
        Name = SBMLModel.name;
    else
        Name = SBMLModel.id;
    end;
end;

if (~isempty(filename))
    Name = filename;
elseif (length(Name) > 63)
    Name = Name(1:60);
end;

fileName = strcat(filepath,'\',Name, '.m'); % EBC -- add to results path

%--------------------------------------------------------------------
% 

% write Compartments 


for i = 1:length(CompartmentNames)
    if strcmp(CompartmentNames{i}(1),'d')
        CompartmentNames{i}=strcat('C',CompartmentNames{i});   % this is to avoid problems with the definition of derivatives in C 
    end
        inputs.model.sbml_eqns{i}=strcat(CompartmentNames{i},'=',num2str(CompartmentValues(i)));
end;


% write assignment rules

nC=length(CompartmentNames);

AssignRules = Model_getListOfAssignmentRules(SBMLModel);

if ~isempty(SBMLModel.time_symbol) 
if ~strcmp(SBMLModel.time_symbol,'t') 
 inputs.model.sbml_eqns{nC+1} =strcat(SBMLModel.time_symbol,'=t');
 nC=nC+1;
end
end

neqs=nC+1;
nRp=0;
nRr=0;
for i = 1:length(AssignRules)
    
    if inputs_model.piecewise_times>0  % EBC if piecewise
    inputs.model.sbml_eqns{neqs}=strcat('if(',SBMLModel.time_symbol,'<',inputs_model.piecewise_times(1,:),'){');  
   
    for j=1:inputs_model.n_piecewiseF-2    
     inputs.model.sbml_eqns{j+neqs} = strcat(AssignRules(i).variable,'=',inputs_model.piecewiseF{j},';}');  
     inputs.model.sbml_eqns{j+neqs+1} = ['else' ' ' 'if' ' ' '(' SBMLModel.time_symbol '<' inputs_model.piecewise_times(j+1,:) '){'];  
     neqs=neqs+1;
    end
    neqs=neqs+2;

    inputs.model.sbml_eqns{neqs} = ['else' ' ' 'if' ' ' '(' SBMLModel.time_symbol '<' inputs_model.piecewise_times(end,:) '){'];  
    inputs.model.sbml_eqns{neqs+1}=strcat(AssignRules(i).variable,'=',inputs_model.piecewiseF{inputs_model.n_piecewiseF-1},';}');  
    inputs.model.sbml_eqns{neqs+2}='else{';  
    inputs.model.sbml_eqns{neqs+3}=strcat(AssignRules(i).variable,'=',inputs_model.piecewiseF{inputs_model.n_piecewiseF},';}'); 
    
    neqs=neqs+3;
    
    nRp=neqs-nC; % EBC, needs to be updated for several piecewise rules
    else  % EBC other non-piecewise rules
    inputs.model.sbml_eqns{neqs+i-1} = strcat(AssignRules(i).variable,'=',AssignRules(i).formula);   
    nRr=length(AssignRules);
    end    
   
end;


nR=nRp+nRr;

% write ODE EQNS

    
for i = 1:NumberSpecies
    
    if strcmp(Species(i).compartment(1,1),'d')
    Species(i).compartment=strcat('C',Species(i).compartment);
    end
    
    if isempty(Species(i).KineticLaw)
        Species(i).KineticLaw(i)='0';
        SpeciesKineticLaw=char(Species(i).KineticLaw);
        inputs.model.sbml_eqns{i+nC+nR}=strcat('d',SpeciesNames{i},'=',SpeciesKineticLaw,'/',Species(i).compartment);
    else
        SpeciesKineticLaw=char(Species(i).KineticLaw);
        if strcmp(SpeciesKineticLaw(1,1),'+') | strcmp(SpeciesKineticLaw(1,2),'+') | strcmp(SpeciesKineticLaw(1,1),'-') | strcmp(SpeciesKineticLaw(1,2),'-')
        inputs.model.sbml_eqns{i+nC+nR}=strcat('d',SpeciesNames{i},'=',SpeciesKineticLaw(1:end),'/',Species(i).compartment);
        end
        
    end     
end;




model_eqns=[inputs.model.sbml_eqns'];



% write algebraic rules        
% fprintf(fileID, '\n%%--------------------------------------------------------\n');
% fprintf(fileID, '%% algebraic rules\n');
% 
% for i = 1:NumberSpecies
%     if (Species(i).ConvertedToAssignRule == 1)
%         fprintf(fileID, '%s = %s;\n', char(Species(i).Name), Species(i).ConvertedRule);
%     end;
% end;


% 
% for i = 1:NumberSpecies
% 
% 
%     
%     if (Species(i).ChangedByReaction == 1)
%         % need to look for piecewise functions
%         if (isempty(strfind(char(Species(i).KineticLaw), 'piecewise')))
%             if (Species(i).isConcentration == 1)
%                 Array{i} = sprintf('\tydot(%u,1) = (%s)/%s;\n', i, char(Species(i).KineticLaw), Species(i).compartment);
%             else
%                 Array{i} = sprintf('\tydot(%u,1) = %s;\n', i, char(Species(i).KineticLaw));
%             end;
% 
%         else
%             Arguments = DealWithPiecewise(char(Species(i).KineticLaw));
% 
%             Array{i} = sprintf('\tif (%s) \n\t\txdot(%u) = %s;\n\telse\n\t\txdot(%u) = %s;\n\tend;\n', Arguments{2}, i, Arguments{1}, i, Arguments{3});
% 
%         end;
% 
%     elseif (Species(i).ChangedByRateRule == 1)
%         Array{i} = sprintf('\tydot(%u,1) = %s;\n', i, char(Species(i).RateRule));
% 
%     elseif (Species(i).ChangedByAssignmentRule == 1)
%         % here no rate law has been provided by either kinetic law or rate
%         % rule - need to check whether the species is in an
%         % assignment rule which may impact on the rate
% 
%         %%% Checking for a piecewise in the assignment rule and
%         %%% handling it
%         %%% Change made by Sumant Turlapati, Entelos, Inc. on June 8th, 2005
%         if (isempty(strfind(char(Species(i).AssignmentRule), 'piecewise')))
%             DifferentiatedRule = DifferentiateRule(char(Species(i).AssignmentRule), SpeciesNames);
%             Array{i} = sprintf('\tydot(%u,1) = %s;\n', i, char(DifferentiatedRule));
%             NeedToOrderArray = 1;
%         else
% %                 error('WriteODEFunction(SBMLModel)\n%s', 'cannot yet deal with a piecewise function within an assignment rule');
%             %char(Species(i).AssignmentRule)
%             %% taken out as this did not fully handle piecewise in an
%             %% assignment rule
%             Args = DealWithPiecewise(char(Species(i).AssignmentRule));
% 
%             DiffRule1 = DifferentiateRule(char(Args{1}), SpeciesNames);
%             DiffRule2 = DifferentiateRule(char(Args{3}), SpeciesNames);
%             Array{i} = sprintf('\tif (%s) \n\t\tydot(%d,1) = %s;\n\telse\n\t\txdot(%u) = %s;\n\tend;\n', Args{2}, i, char(DiffRule1), i, char(DiffRule2));
%        %     NeedToOrderArray = 1;
%         end;
%         %DifferentiatedRule = DifferentiateRule(char(Species(i).AssignmentRule), SpeciesNames);
%         %Array{i} = sprintf('\txdot(%u) = %s;\n', i, char(DifferentiatedRule));
%         %NeedToOrderArray = 1;
% 
%     elseif (Species(i).ConvertedToAssignRule == 1)
%         % here no rate law has been provided by either kinetic law or rate
%         % rule - need to check whether the species is in an
%         % algebraic rule which may impact on the rate
%         DifferentiatedRule = DifferentiateRule(char(Species(i).ConvertedRule), SpeciesNames);
%         Array{i} = sprintf('\tydot(%u,1) = %s;\n', i, char(DifferentiatedRule));
%         NeedToOrderArray = 1;
%     else
%         % not set by anything
%         Array{i} = sprintf('\tydot(%u,1) = 0;\n', i);
% 
%     end;
% end; % for Numspecies

% need to check that assignments are made in appropriate order
% deals with rules that have been differentiated where xdot may occur on
% both sides of an equation
% if (NeedToOrderArray == 1)
%     Array = OrderArray(Array);
% end;
% for i = 1:NumberSpecies
%     fprintf(fileID, '%s', Array{i});
% end;
% 
% 
% fprintf(fileID, '\nreturn;\n');

% put in any function definitions

% if (NumFuncs > 0)
%     fprintf(fileID, '\n\n%%---------------------------------------------------\n%%Function definitions\n\n');
% 
%     for i = 1:NumFuncs
%         Name = SBMLModel.functionDefinition(i).id;
% 
%         Elements = GetArgumentsFromLambdaFunction(SBMLModel.functionDefinition(i).math);
% 
%         fprintf(fileID, '%%function %s\n\n', Name);
%         fprintf(fileID, 'function returnValue = %s(', Name);
%         for j = 1:length(Elements)-1
%             if (j == length(Elements)-1)
%             fprintf(fileID, '%s', Elements{j});
%             else
%                 fprintf(fileID, '%s, ', Elements{j});
%             end;
%         end;
%         fprintf(fileID, ')\n\nreturnValue = %s;\n\n\n', Elements{end});
%     end;
% 
% end;
% 
% 
% fclose(fileID);

% -----------------------------------------------------------------

% if (NumEvents > 0)
% % write two additional files for events
% 
%     WriteEventHandlerFunction(SBMLModel);
%     WriteEventAssignmentFunction(SBMLModel);
% 
% end;


%--------------------------------------------------------------------------

function y = WriteRule(SBMLRule)

y = '';


switch (SBMLRule.typecode)
    case 'SBML_ASSIGNMENT_RULE'
    %%% Checking for a piecewise in the assignment rule and
        %%% handling it
        %%% Change made by Sumant Turlapati, Entelos, Inc. on June 8th, 2005
        if (isempty(strfind(char(SBMLRule.formula), 'piecewise')))
            y = sprintf('%s = %s;', SBMLRule.variable, SBMLRule.formula);
        else
            Arguments = DealWithPiecewise(char(SBMLRule.formula));
            y = sprintf('\tif (%s) \n\t\t%s = %s\n\telse\n\t\t%s = %s\n\tend\n', Arguments{2}, SBMLRule.variable, Arguments{1}, SBMLRule.variable, Arguments{3});
        end;
%         y = sprintf('%s = %s;', SBMLRule.variable, SBMLRule.formula);
    case 'SBML_SPECIES_CONCENTRATION_RULE'
        y = sprintf('%s = %s', SBMLRule.species, SBMLRule.formula);
    case 'SBML_PARAMETER_RULE'
        y = sprintf('%s = %s', SBMLRule.name, SBMLRule.formula);

    otherwise
        error('No assignment rules');
end;

%--------------------------------------------------------------------------
function formula = DifferentiateRule(f, SpeciesNames)

Brackets = PairBrackets(f);

Dividers = '+-';
Divide = ismember(f, Dividers);

% dividers between brackets do not count
if (Brackets ~= 0)
    [NumPairs,y] = size(Brackets);
for i = 1:length(Divide)
    if (Divide(i) == 1)
        for j = 1:NumPairs
            if ((i > Brackets(j,1)) && (i < Brackets(j, 2)))
                Divide(i) = 0;
            end;
        end;
    end;
end;
end;    

Divider = '';
NoElements = 1;
element = '';
for i = 1:length(f)
    if (Divide(i) == 0)
        element = strcat(element, f(i));
    else
        Divider = strcat(Divider, f(i));
        Elements{NoElements} = element;
        NoElements = NoElements + 1;
        element = '';
    end;

    % catch last element
    if (i == length(f))
        Elements{NoElements} = element;
    end;
end;

for i = 1:NoElements
    % check whether element contains a species name
    % need to catch case where element is number and
    % species names use numbers eg s3 element '3'
    for j = 1:length(SpeciesNames)
        %     j = 1;
        A = strfind(Elements{i}, SpeciesNames{j});
        if (~isempty(A))
            break;
        end;
    end;

    if (isempty(A))
        % this element does not contain a species
        Elements{i} = strrep(Elements{i}, Elements{i}, '0');
    else
        % this element does contain a species

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % WHAT IF MORE THAN ONE SPECIES

        % for moment assume this would not happen
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        Power = strfind(Elements{i}, '^');
        if (~isempty(Power))
            Number = '';
            Digits = isstrprop(Elements{i}, 'digit');

            k = Power+1;
            while ((k < (length(Elements{i})+1)) & (Digits(k) == 1))
              Number = strcat(Number, Elements{i}(k));
              k = k + 1;
            end;

            Index = str2num(Number); 



            Replace = sprintf('%u * %s^%u*xdot(%u)', Index, SpeciesNames{j}, Index-1, j);
            Initial = sprintf('%s^%u', SpeciesNames{j}, Index);
            Elements{i} = strrep(Elements{i}, Initial, Replace);
        else

        Replace = sprintf('xdot(%u)', j);
         Elements{i} = strrep(Elements(i), SpeciesNames{j}, Replace);

       end;
    end;
end;

% put the formula back together
formula = '';
for i = 1:NoElements-1
    formula = strcat(formula, Elements{i}, Divider(i));
end;
formula = strcat(formula, Elements{NoElements});


%--------------------------------------------------------------------------
% function to put rate assignments in appropriate order
% eg
%       xdot(2) = 3
%       xdot(1) = 3* xdot(2)

function Output = OrderArray(Array)

% if (length(Array) > 9)
%     error('cannot deal with more than 10 species yet');
% end;

NewArrayIndex = 1;
TempArrayIndex = 1;
TempArray2Index = 1;
NumberInNewArray = 0;
NumberInTempArray = 0;
NumberInTempArray2 = 0;
TempArray2 = {};

% put any formula withoutxdot on RHS into new array
for i = 1:length(Array)
    if (length(strfind(Array{i}, 'xdot'))> 1)
        % xdot occurs more than once
        % put in temp array
        TempArray{TempArrayIndex} = Array{i};
        TempArrayIndices(TempArrayIndex) = i;

        % update
        TempArrayIndex = TempArrayIndex + 1;
        NumberInTempArray = NumberInTempArray + 1;

    else
        % no xdot on RHS
        % put in New array
        NewArray{NewArrayIndex} = Array{i};
        NewArrayIndices(NewArrayIndex) = i;

        % update
        NewArrayIndex = NewArrayIndex + 1;
        NumberInNewArray = NumberInNewArray + 1;


    end;
end;

while (NumberInTempArray > 0)
    % go thru temp array
    for i = 1:NumberInTempArray
        % find positions of xdot
        Xdot = strfind(TempArray{i}, 'xdot');

        % check whether indices of xdot on RHS are already in new array
        Found = 0;
        for j = 2:length(Xdot)
            Number = str2num(TempArray{i}(Xdot(j)+5));
            if (sum(ismember(NewArrayIndices, Number)) == 1)
                Found = 1;
            else
                Found = 0;
            end;
        end;

        % if all have been found put in new array
        if (Found == 1)
            % put in New array
            NewArray{NewArrayIndex} = TempArray{i};
            NewArrayIndices(NewArrayIndex) = TempArrayIndices(i);

            % update
            NewArrayIndex = NewArrayIndex + 1;
            NumberInNewArray = NumberInNewArray + 1;

        else
            % put in temp array2
            TempArray2{TempArray2Index} = TempArray{i};
            TempArray2Indices(TempArray2Index) = TempArrayIndices(i);

            % update
            TempArray2Index = TempArray2Index + 1;
            NumberInTempArray2 = NumberInTempArray2 + 1;


        end;



    end;

    %Realloctate temp arrays

    if (~isempty(TempArray2))
        TempArray = TempArray2;
        TempArrayIndices = TempArray2Indices;
        NumberInTempArray = NumberInTempArray2;
        TempArray2Index = 1;
        NumberInTempArray2 = 0;
    else
        NumberInTempArray = 0;
    end;




end; % of while NumInTempArray > 0

Output = NewArray;

