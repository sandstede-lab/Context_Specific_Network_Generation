function [ resultMatrix ] = grow2( adj, numIts, varargin )
%I use the addNode function to grow the network a certain number of times.
%recursive function to continue growing matrix quickly.
%This will grow a weighted adjacency matrix.

% format:
%            resultMatrix = grow(adj, numIts, m, k_0)

if nargin > 4
    error('too many parameters')
end

switch nargin
    case 1
        error('too few parameters')
    case 2
        m = 1;
        k_0 = 1000;
    case 3
        m = cell2mat(varargin);
        k_0 = 1000;
    case 4
        m = cell2mat(varargin(1));
        k_0 = cell2mat(varargin(2));
end

if numIts == 0
    resultMatrix = adj;
else
    resultMatrix = addNode2(adj, m, k_0);
    resultMatrix = grow2(resultMatrix, numIts-1, m, k_0);
end

end
