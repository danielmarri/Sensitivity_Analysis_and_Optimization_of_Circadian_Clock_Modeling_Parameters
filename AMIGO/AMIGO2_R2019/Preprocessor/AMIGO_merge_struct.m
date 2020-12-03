% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_merge_struct.m 2132 2015-09-21 09:56:12Z evabalsa $
function [opts] = AMIGO_merge_struct(default,opts,parentName)
% [opts] = AMIGO_merge_struct(default,opts,parentName) merge the structures: defaults and opts.
% Iteratively goes through the fields in opts and fills the values with the values in default. Also 
% reports an error if the opts contains a field which does not contained in the default.
% parentName: the name of the input struct as str.
%
% coded: David H. 
% $Header: svn://.../trunk/AMIGO2R2016/Preprocessor/AMIGO_merge_struct.m 2132 2015-09-21 09:56:12Z evabalsa $ 
  
if isempty(opts)
    % no options: keep the defaults.
    opts=default;
    
elseif isempty(default) && ~isempty(opts)
    % empty defaults, keep the opts.
% elseif iscell(opts)
%     for i = 1:length(opts)
%         if isempty(opts{i}) && length(default)>= i
%             % if the user havent filled a field we fill it with the
%             % defaults.
%             opts{i} = default{i};
%         end
%     end
    
elseif ~isempty(default) && isstruct(default) && isstruct(opts)
    % defaults and opts are nonempty
    
    opt_names=fieldnames(opts);
    default_names=fieldnames(default);
    
    low_opt_names = lower(opt_names);
    low_default_names = lower(default_names);
   
    for i=1:length(opt_names)
        % DEBUG: break condition: strcmpi(opt_names{i},'tf_type')

        j = find(strcmp(low_opt_names{i,:},low_default_names));

        if isempty(j)
            % detect if opts has a field, that does not exists in te
            % defaults.
           error(sprintf(['Unrecognized field name %s in %s'], opt_names{i,:},parentName));
        end
        
        value=AMIGO_merge_struct(default.(default_names{j,:}),opts.(opt_names{i,:}),[parentName '.' default_names{j,:}]);
        default.(default_names{j,:}) = value;
       
    end
    
  opts=default;    
    

end




end