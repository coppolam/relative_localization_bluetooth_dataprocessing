function [ varargout ] = startempty(size)
%startempty Starts an empty field with the name
% [out1, out2 ] = startempty(rows, columns)
% 	is equal to
% 				out1 = zeros(rows,columns);
%				out2 = zeros(rows,columns);
%
% If rows and columns are left unspecified, then:
% 				out1 = [];
%				out2 = [];
%
% Developed by Mario Coppola, January 2016

varargout = cell(1,nargout);

for i = 1:nargout
    if ~isempty(size)
        varargout{i} = zeros(size); 
    else
        varargout{i} = [];
    end
end

end

