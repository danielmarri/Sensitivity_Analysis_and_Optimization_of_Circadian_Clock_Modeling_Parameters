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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Create HTML documentation from inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Open file for the Cheat Sheet:
filename = 'amigo_cheatSheet_developers.html';
fid = fopen(filename, 'wt');

% create HTML Header info
AMIGO_release_info;
fprintf(fid,'<!DOCTYPE html>\n');
fprintf(fid,'<head> <title>Developer''s Cheat Sheet for %s</title></head>\n',AMIGO_version);
fprintf(fid,'<body>\n');
AMIGO_writeHtmlTableStyle(fid)
fprintf(fid,'<h1>Developer''s Cheat Sheet for %s</h1>',AMIGO_version);
% set-up table's header:
fprintf(fid,'<table class="tftable" border="1">\n');
fprintf(fid,'<tr>');
fprintf(fid,'  <th>Field</th>');
fprintf(fid,'  <th>Default</th> ');
fprintf(fid,'  <th> Description</th> ');
fprintf(fid,'  <th align="left">Possbile options</th> ');
fprintf(fid,'</tr>\n');

% fill up the table:
AMIGO_writeHTMLdoc(fid,[],'inputs',inputs_path,inputs_def,doc_inputs,option_inputs)

% AMIGO_writeDoc(1,[],'inputs',inputs_path,inputs_def,doc_inputs,option_inputs)

fprintf(fid,'</table>');
fprintf(fid,'</body>\n');
fprintf(fid,'</html>');
fclose(fid);

%pop-up the html:
web(filename)

%display missing documentation:
fprintf('Missing input documentation:\n')
AMIGO_displayStruct_fullsyntax(missing_doc,[],[],'inputs')

fprintf('\nMissing options documentation:\n')
AMIGO_displayStruct_fullsyntax(missing_opt_doc,[],[],'inputs')





