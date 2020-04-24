function [D] = degreeSampler(distribution, numNodes)
%function that creates discrete distribution based on degree
%distribution and calls gendist which randomly samples from the discrete
%probability distribution and returns the degrees for the number of nodes
%wanted

%extract bin sizes for distribution of degree of interactions as N
[N,edges] = histcounts(distribution,'BinMethod','integers');

a = length(N);

%total number of interactions (total across all bins) -- exclude first bin
%which represents no interactions
total = sum(N(1:end));

%initialize list to store probability of each bin in
probDist = [];

%calculate probability for each degree value
for i = 1:a
    probDist(i) = N(i)/total;
end

D = gendist(probDist,1,numNodes);

