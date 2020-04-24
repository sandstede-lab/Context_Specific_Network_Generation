function [T] = freqSampler(distribution,degree)
%function that creates discrete distribution based on frequency
%distribution and calls gendist which randomly samples from the discrete
%probability distribution and returns the freuqnecy that should be
%associated with each of the degree number of connections

%extract bin sizes for distribution of frequency of interactions as N
[N,edges] = histcounts(distribution);

a = length(N);

%total number of interactions (total across all bins) -- exclude first bin
%which represents no interactions
total = sum(N(2:end));

%initialize list to store probability of each bin in
probDist = [];

%calculate probability for each frequency value (14 days so possible to
%have up to 14 repeat interactions -- start with 2nd bin to exclude frequency of zero)
for i = 2:a
    probDist(i-1) = N(i)/total;
end

T = gendist(probDist,1,degree);
