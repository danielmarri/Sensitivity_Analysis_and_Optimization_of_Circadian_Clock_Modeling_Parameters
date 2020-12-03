%AMIGO_HTML_PE_results drafts documentation for the results structure for AMIGO_PE
%
% Syntax:  AMIGO_HTML_PE_results
%
%
% Author: Attila Gabor
% IIM-CSIC
% July 2014; Last revision: 04-Jul-2014
clc


%%%%%%%%%%%%%%%%%%%%%%
%%% INPUTS  
%%%%%%%%%%%%%%%%%%%%%%
% load an AMIGO_PE results:
load AMIGO_PE_results_04072014

% load the documentation
results_doc = AMIGO_PE_results_doc;

% generate path data
results_path = AMIGO_structFieldPathsAsValue(results,'results');

% check dosumentation:
[doc_results missing_doc]= AMIGO_commentStruct(results,results_doc);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Create HTML documentation from inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Open file for the Cheat Sheet:
filename = 'AMIGO_PE results.html';
fid = fopen(filename, 'wt');

% create HTML Header info
AMIGO_release_info;
fprintf(fid,'<!DOCTYPE html>\n');
fprintf(fid,'<head> <title>AMIGO_PE results structure documentation for %s</title></head>\n',AMIGO_version);
fprintf(fid,'<body>\n');
AMIGO_writeHtmlTableStyle(fid)
fprintf(fid,'<h1>AMIGO_PE results structure documentation for %s</h1>',AMIGO_version);
% set-up table's header:
fprintf(fid,'<table class="tftable" border="1">\n');
fprintf(fid,'<tr>');
fprintf(fid,'  <th>Field</th>');
fprintf(fid,'  <th> Description</th> ');
fprintf(fid,'</tr>\n');

% fill up the table:
AMIGO_writeHTMLdoc(fid,[],'results',results_path,doc_results)

% AMIGO_writeDoc(1,[],'results',results_path,doc_results)

fprintf(fid,'</table>');
fprintf(fid,'</body>\n');
fprintf(fid,'</html>');
fclose(fid);

%pop-up the html:
web(filename)

%display missing documentation:
fprintf('Missing AMIGO_PE results documentation:\n')
AMIGO_displayStruct_fullsyntax(missing_doc,[],[],'results')






