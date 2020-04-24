
%load the Warwick data for home interactions
load('homeDist.mat')

%add folders for supplementary functions
addpath(genpath('../octave-networks-toolbox'));
addpath(genpath('../gendist'));


%desired size for final population
finalpop = 3000;

%separate those with degree <= 8 and > 8 into two distributions
[smallHome,largeHome] = separate(homeDist, 8);

%determine an initial population size
sizeInitialPop = 235;
popsize        = sizeInitialPop;

% Since the algorithm is stochastic, repeat until the population size is >= finalpop 
while popsize < finalpop 
    %store home degree distribution from Warwick data
    countHome = homeDist(1:end,1);
    
    samplePop = degreeSampler(countHome,sizeInitialPop);  %returns degrees for each node in sizeInitialPop
    totalPop = sum(samplePop);
    homeAdj = zeros(totalPop,totalPop); %home network adjacency matrix
    count = sizeInitialPop + 1;
    
    %loop through original sizeInitialPop people and for sampled degree, create
    %cluster around them
    for i = 1 : sizeInitialPop
        degree = samplePop(i);
        if degree > 8
            distribution = largeHome(:,4:end);
        else
            distribution = smallHome(:,4:end);
        end
        for j = count : count+degree
            [F] = freqSampler(distribution, 1); %selects a frequency from Warwick freq distribution
            homeAdj(i,j) = F;
            homeAdj(j,i)=F;
        end
        for k = count : count+degree
            for l = (k+1) : count+degree
                [F] = freqSampler(distribution, 1); %selects a frequency from Warwick freq distribution
                homeAdj(k,l) = F;
                homeAdj(l,k) = F;
            end
        end
        count = count+degree+1;
    end
    
    disp(length(homeAdj));
    popsize = length(homeAdj);
    
end

if popsize < finalpop
    error('initial population size too small');
end

%randomly select the extra nodes and remove from adjacency matrix to get
%desired population size
if popsize > finalpop
    
    extra = popsize-finalpop;
    x = randperm(finalpop,extra);
    
    for i = 1:extra
        j = x(i);
        homeAdj(j,:) = [];
        homeAdj(:,j) = [];
    end
end


%save adjacency matrix for home interactions
save('homeAdj.mat','homeAdj');


%calculate degree distribution of generated network
totDeg = degrees(homeAdj>0);
disp(length(totDeg));

centers = 0:3:54;

%plot degree distribution of generated network
figure
[f,x] = hist(totDeg, centers);
clusterDist = bar(x,f/sum(f)*100);
xlabel('Home Sub-network Degree', 'FontSize', 14)
ylabel('Percent of nodes', 'FontSize', 14)
hold off

%calculate frequency distribution of generated network
freqDist = frequencies(homeAdj);

%plot frequency distribution of generated network
figure
x = 1:14;
clusterDist = bar(x,freqDist/sum(freqDist)*100);
xlabel('Frequency', 'FontSize', 14)
ylabel('Percent of Interactions (Edges)', 'FontSize', 14)
hold off


