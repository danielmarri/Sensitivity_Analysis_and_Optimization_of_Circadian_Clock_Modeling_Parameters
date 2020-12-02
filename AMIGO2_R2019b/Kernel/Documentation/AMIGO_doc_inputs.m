function AMIGO_doc_inputs(inputs,fid)
% Writes comments for partial inputs structure.

% handle case, when inputs is not the AMIGO inputs structure:
if ~strcmp(inputname,'inputs')
    warning('AMIGO_autoDoc:structName','Make sure the input is a regular AMIGO inputs structure')
end
if nargin < 2 || isempty(2)
    fid = 1;
end


inputs_doc = AMIGO_default_options_doc;
[doc_inputs missing_doc]= AMIGO_commentStruct(inputs,inputs_doc);
inputs_path = AMIGO_structFieldPathsAsValue(inputs,'inputs');
AMIGO_writeDoc(fid,[],'inputs',inputs_path,doc_inputs)
