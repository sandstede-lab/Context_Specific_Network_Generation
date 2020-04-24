function [freq]=frequencies(adj)

rawfreqs = zeros(1,14);

a = size(adj);

for i = 1:a  %loop through adjacency matrix to collect all nonzero frequencies
    for j = 1:a
        if adj(i,j) > 0
            b = adj(i,j);
            rawfreqs(b) = rawfreqs(b) + 1;
        end 
    end
end

total = sum(rawfreqs(1:end));
freq = zeros(1,14);

%create distribution for frequency
for i = 1:14
    freq(i) = rawfreqs(i)/total;
end

end