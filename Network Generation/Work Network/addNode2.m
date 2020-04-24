function [ resultMatrix ] = addNode2( adj, varargin )
%output an adjacency matrix that has one more node connected to the network
%by way of the fitness model and making weighted edges

% format
%           resultMatrix = addNode(adj, m, k_0)

if isSymmetric(adj)==0
    error('the input adjacency matrix is not symmetric')
end

n = length(adj);
etaList = ones(n,1); 
k = degrees(adj); 
Sigma_j = k*etaList;

if nargin > 3
    error('too many parameters')
end

switch nargin
    case 1
        m = 1;
    case 2
        m = cell2mat(varargin);
        for i = 1:n
            etaList(i,1) = eta(k(i));
        end
        Sigma_j = k*etaList;
    case 3
        m = cell2mat(varargin(1));
        for i = 1:n
            etaList(i,1) = eta(k(i),cell2mat(varargin(2)));
        end
        Sigma_j = k*etaList;
end

load('workDist.mat');

%building the new matrix
resultMatrix = [adj zeros(n,1); zeros(1,n+1)];

%establish ranges for old nodes
ranges = zeros(n,2);
cumulativeRange = 0;
for j = 1:n
    lb = cumulativeRange;
    up = cumulativeRange + k(j)*etaList(j);
    ranges(j,:) = [lb up];
    cumulativeRange = up;
end
ranges = ranges/Sigma_j;

%adding new node
m0 = 0; % degree of new node
while m0 < m
    u = rand(1);
    for j = 1:n %iterating over the original nodes
        %when the random number is within the right range
        if u > ranges(j,1) && u < ranges(j,2) 
            %the work distribution
            F = freqSampler(workDist(:, 5:end),1);
            %connecting new node to network
            resultMatrix(n+1,j) = F; 
            resultMatrix(j,n+1) = F;
            m0 = m0+1;
        end
    end
end

end