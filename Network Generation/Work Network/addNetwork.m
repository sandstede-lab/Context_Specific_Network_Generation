function [ result ] = addNetwork( added, original )
%This will use memory allocation to make growing an array faster
% result will be an adjacency matrix that will add the added matrix
% to the original matrix

if ~isSymmetric(added) || ~isSymmetric(original)
    error('One of the matrices is not symmetric')
end

n_o = length(original);
n_a = length(added);

result = [original zeros(n_o,n_a);
          zeros(n_a,n_o) added];

end
