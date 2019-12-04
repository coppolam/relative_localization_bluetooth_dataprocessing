function checknan( varargin )
%checknan Checks and gives an error if any of the input values are NaN

for i = 1:nargin
    
    if any(isnan(varargin{i}))
        error(['The variable ',  inputname(i), ' has NaN values in it!']);
    end

end

