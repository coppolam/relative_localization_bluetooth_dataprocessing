function checkmag( reference, mode , varargin )
%checkmag Checks the magnitude of one or more variables against a reference
% and returns an error if the magnitude does not comply
%
% You should program in the desired setting. Let's say we have reference
% value A, and we need to check that A is larger than B, C, and D, then we
% can program that in as:
%       checkmag(A, '>', B, C, D)
% Accepted modes are
%       '>'
%       '<'
%       '='
%       '>='
%       '<='
%
% Developed by Mario Coppola, January 2016

t = 'Verification issue: Variable ';

if strcmp(mode, '>')
    
    for i = 1:nargin-2
        if any(reference <= varargin{i})
            error([t, inputname(i+2), 'is not larger than ', inputname(1)])
        end
    end
    
elseif strcmp(mode, '<')
    
    for i = 1:nargin-2
        if any(reference >= varargin{i})
            error([t, inputname(i+2), 'is not smaller than ', inputname(1)])
        end
    end
    
elseif strcmp(mode, '=')

    for i = 1:nargin-2
        if any(varargin{i} ~= reference)
            error([t, inputname(i+2), 'is not equal to ', inputname(1)])
        end
    end
    
elseif strcmp(mode, '>=')
    
    for i = 1:nargin-2
        if any(reference < varargin{i})
            error([t, inputname(i+2), 'is not larger than or equal to ', inputname(1)])
        end
    end
    
elseif strcmp(mode, '<=')
    
    for i = 1:nargin-2
        if any(reference > varargin{i})
            error([t, inputname(i+2), 'is not smaller than or equal to ', inputname(1)])
        end
    end
    
else
    error('Please specify a proper magnitude verification mode, see help')
end

end

