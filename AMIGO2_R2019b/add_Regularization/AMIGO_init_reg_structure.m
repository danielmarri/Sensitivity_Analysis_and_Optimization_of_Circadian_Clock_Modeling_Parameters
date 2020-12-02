function reg = AMIGO_init_reg_structure (inputs )
%reg_par_selection_structure = AMIGO_init_reg_structure(reg_inputs)
% initialization function for the regularization structure.
% The regularization structure contains the information how to compute the
% regularization parameter.
% for user specified set of regularization parameters, it stores
%       the values in the alphaSet and its number of element. 
% For automatic computation it stores 
%       the minimum, maximum value of the regularization parameter to
%       search and the regularization method. 
%
% TODO:
% add further checking of the inputs:
%   - correct reg_par_method
%   - consistent minimum and maximum


switch inputs.nlpsol.regularization.reg_par_method
    case 'lcurve_selection'
        reg.nalpha = inputs.nlpsol.regularization.n_alpha;
        reg.alphaSet = inputs.nlpsol.regularization.alphaSet;
%         reg.alpha_min = inputs.nlpsol.regularization.alpha_min;
%         reg.alpha_max = inputs.nlpsol.regularization.alpha_max;
        
        if length(reg.alphaSet) ~= inputs.nlpsol.regularization.n_alpha
            error('the number of given regularization parameters is inconsistent with the regularization parameter number. inputs.nlpsol.regularization.n_alpha ~= legnth(inputs.nlpsol.regularization.alphaSet)');
        end
    case {'method_A','GCV'}
        reg = [];
end
reg.reg_par_method_type = inputs.nlpsol.regularization.reg_par_method_type; 
reg.reg_par_method = inputs.nlpsol.regularization.reg_par_method;