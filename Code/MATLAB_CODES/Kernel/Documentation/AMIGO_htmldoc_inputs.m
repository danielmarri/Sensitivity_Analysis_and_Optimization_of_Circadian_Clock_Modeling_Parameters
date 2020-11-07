function AMIGO_htmldoc_inputs(inputs,filename)
% Writes comments for partial inputs structure.

% handle case, when inS is not the inputs structure:
%if ~strcmp(inputname,'inputs')
%    warning('AMIGO_autoDoc:structName','Make sure the input is a regular AMIGO inputs structure')
%end
if nargin < 2 || isempty(2)
    filename = 'tmp.html';
end


inputs_doc = AMIGO_default_options_doc;
[doc_inputs missing_doc]= AMIGO_commentStruct(inputs,inputs_doc);
inputs_path = AMIGO_structFieldPathsAsValue(inputs,'inputs');

% filename = 'amigo_cheatSheet_developers.html';
fid = fopen(filename, 'w');

% create HTML Header info
AMIGO_release_info;
fprintf(fid,'<!DOCTYPE html>\n');
fprintf(fid,'<head> <title>Comments on the inputs</title></head>\n');
fprintf(fid,'<body>\n');
AMIGO_writeHtmlTableStyle(fid)
fprintf(fid,'<h1>Inputs</h1>');
% set-up table's header:
fprintf(fid,'<table class="tftable" border="1">\n');
fprintf(fid,'<tr>');
fprintf(fid,'  <th>Field</th>');
fprintf(fid,'  <th> Description</th> ');
% fprintf(fid,'  <th align="left">Possbile options</th> ');
fprintf(fid,'</tr>\n');

AMIGO_writeHTMLdoc(fid,[],'inputs',inputs_path,doc_inputs)
fprintf(fid,'</table>');
fprintf(fid,'</body>\n');
fprintf(fid,'</html>');
fclose(fid);

%pop-up the html:
% web(filename)
