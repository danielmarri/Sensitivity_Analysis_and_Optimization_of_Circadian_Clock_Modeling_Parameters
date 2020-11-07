%AMIGO_generate_developers_cheat_sheet drafts the inputs structure from AMIGO_private_defaults
%
% Syntax:  AMIGO_generate_developers_cheat_sheet();
%
%
% Author: Attila Gabor
% IIM-CSIC
% July 2014; Last revision: 04-Jul-2014
clc


%%%%%%%%%%%%%%%%%%%%%%
%%% INPUTS  
%%%%%%%%%%%%%%%%%%%%%%
% read AMIGO inputs structure with the defaults:
inputs_def = AMIGO_default_options;

% read the documentation:
inputs_doc = AMIGO_default_options_doc;

% read options
inputs_options = AMIGO_inputs_options;

% comment the inputs_def by the documentation: takes care about missign doc
[doc_inputs missing_doc]= AMIGO_commentStruct(inputs_def,inputs_doc);

% handle missing options
[option_inputs missing_opt_doc]= AMIGO_commentStruct(inputs_def,inputs_options);

% generate access path for the structure's fields
inputs_path = AMIGO_structFieldPathsAsValue(doc_inputs,'inputs');



% Print to the command window.
AMIGO_release_info;
fprintf('Developer''s Cheat Sheet for %s\n',AMIGO_version);
fprintf('FIELD\t\t  DEFAULT\t\t DESCRIPTION  \t\t OTHER OPTIONS\n')
AMIGO_writeDoc(1,[],'inputs',inputs_path,inputs_def,doc_inputs,option_inputs)

%display missing documentation:
fprintf('Missing input documentation:\n')
AMIGO_displayStruct_fullsyntax(missing_doc,[],[],'inputs')

fprintf('\nMissing options documentation:\n')
AMIGO_displayStruct_fullsyntax(missing_opt_doc,[],[],'inputs')





