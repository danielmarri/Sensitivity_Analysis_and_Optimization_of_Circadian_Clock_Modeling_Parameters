%AMIGO_HTML_PE_inputs drafts documentation for the recommended input structure for AMIGO_PE
%
% Syntax:  AMIGO_HTML_PE_inputs
%
%
% Author: Attila Gabor
% IIM-CSIC
% July 2014; Last revision: 07-Jul-2014
clc


%%%%%%%%%%%%%%%%%%%%%%
%%% INPUTS  
%%%%%%%%%%%%%%%%%%%%%%
inputs = AMIGO_default_options;
inputs_doc = AMIGO_default_options_doc;
[doc_inputs]= AMIGO_commentStruct(inputs,inputs_doc);

% create table only with PE AND REG
inputsPE = AMIGO_structByTag_logic(doc_inputs,'#PE&#REG');
% create table for PE but not REG
% inputsPE = AMIGO_structByTag_logic(doc_inputs,'#PE&~#REG');

inputsPE_path = AMIGO_structFieldPathsAsValue(inputsPE,'inputs');






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Create HTML documentation from inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Open file for the Cheat Sheet:
filename = 'AMIGO_PE inputs.html';
fid = fopen(filename, 'wt');

% create HTML Header info
AMIGO_release_info;
fprintf(fid,'<!DOCTYPE html>\n');
fprintf(fid,'<head> <title>AMIGO_PE inputs structure documentation for %s</title></head>\n',AMIGO_version);
fprintf(fid,'<body>\n');
AMIGO_writeHtmlTableStyle(fid)
fprintf(fid,'<h1>AMIGO_PE inputs structure documentation for %s</h1>',AMIGO_version);
% set-up table's header:
fprintf(fid,'<table class="tftable" border="1">\n');
fprintf(fid,'<tr>');
fprintf(fid,'  <th>Field</th>');
fprintf(fid,'  <th> Description</th> ');
fprintf(fid,'</tr>\n');

% fill up the table:
AMIGO_writeHTMLdoc(fid,[],'inputs',inputsPE_path,inputsPE)

% AMIGO_writeDoc(1,[],'results',results_path,doc_results)

fprintf(fid,'</table>');
fprintf(fid,'</body>\n');
fprintf(fid,'</html>');
fclose(fid);

%pop-up the html:
web(filename)
% 
% %display missing documentation:
% fprintf('Missing AMIGO_PE inputs documentation:\n')
% AMIGO_displayStruct_fullsyntax(missing_doc,[],[],'results')






