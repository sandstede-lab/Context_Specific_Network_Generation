%Script which loads the simulations generated in SIRReduceInteractions.m 
%for a designated number of trials, averages this data, and then finds the 
%percent contribution of each interaction context to disease spread at each
%time step

%Plots the results over time alongside the expected percent contributions
%of each network due to underlying network structure
clear

% load home, work, social networks
load('homeAdj.mat');
load('socialAdj.mat');
load('workAdj.mat');

numPeople = 3000;      %population size
numIterations = 200;   %number of days for which the simulations ran
numTrials = 100;         %number of simulations obtained
percentContexts = zeros(numIterations-1,4,numTrials);

epidemicSizeTotal = zeros(1,200);

for y = 1:numTrials
    %load each simulation 
    load(['SIRRemove0_Reduce_Social0_Work0_Home0_initialDegreeL/SIRNetwork_Initial_L_Trial_' num2str(y) '.mat' ]);
    epidemicSizeTotal = epidemicSizeTotal + epidemicSize;
    for k = 2:numIterations
        sumHomeInteractions = 0;
        sumWorkInteractions = 0;
        sumSocialInteractions = 0;
        totalInfectiousInteractions = 0;
        for w = 1:numPeople
            %if person w became infected that time interval
            if allOld(k,w) == 1 && allOld(k-1,w) ~= 1
                for q = 1:numPeople
                    %for all infected people in previous time, see if w is
                    %connected in any context and increment variables as
                    %needed
                    if allOld(k-1,q) == 1
                        if homeAdj(w,q) ~= 0 
                            sumHomeInteractions = sumHomeInteractions + homeAdj(w,q);
                            totalInfectiousInteractions = totalInfectiousInteractions + homeAdj(w,q);
                        end
                        if workAdj(w,q) ~= 0 
                            sumWorkInteractions = sumWorkInteractions + workAdj(w,q);
                            totalInfectiousInteractions = totalInfectiousInteractions + workAdj(w,q);
                        end
                        if socialAdj(w,q) ~= 0 
                            sumSocialInteractions = sumSocialInteractions + socialAdj(w,q);
                            totalInfectiousInteractions = totalInfectiousInteractions + socialAdj(w,q);
                        end
                    end
                end
            end
        end
        %fill in array with percent for each context 
            % if no one infected that round, fill in zeros
        percentContexts(k-1,1,y) = k;
        if totalInfectiousInteractions == 0
            percentContexts(k-1,2,y) = 0;
            percentContexts(k-1,3,y) = 0;
            percentContexts(k-1,4,y) = 0;
        else
            percentContexts(k-1,2,y) = sumHomeInteractions/totalInfectiousInteractions;
            percentContexts(k-1,3,y) = sumWorkInteractions/totalInfectiousInteractions;
            percentContexts(k-1,4,y) = sumSocialInteractions/totalInfectiousInteractions;
        end
    end
end

totalPercents = zeros(199,4);
avgPercents = zeros(199,4);

for w = 1:199
    countNonZero = 0;
    for trialsIndex = 1:numTrials
        if sum(percentContexts(w,2:end,trialsIndex)) == 0
        else
            totalPercents(w,:) = totalPercents(w,:) + percentContexts(w,:,trialsIndex);
            countNonZero = countNonZero+1;
        end
    end
    avgPercents(w,:) = totalPercents(w,:)/countNonZero;
end

figure

xlabel('Time (Days)')
ylabel('Percent Contribution to Disease Spread')

homeWeightedDegree = mean(homeAdj*ones(length(homeAdj(1,:)),1))/meanWeightedDegree;
workWeightedDegree = mean(workAdj*ones(length(workAdj(1,:)),1))/meanWeightedDegree;
socialWeightedDegree = mean(socialAdj*ones(length(socialAdj(1,:)),1))/meanWeightedDegree;

%plot the expected percent contribution of each sub-network given the underlying network structures
plot([1:1:numIterations],[(workWeightedDegree)*ones(1,numIterations)],'--r','LineWidth',4); hold on;
plot([1:1:numIterations],[(homeWeightedDegree)*ones(1,numIterations)],'b','LineWidth',4)
plot([1:1:numIterations],[(socialWeightedDegree)*ones(1,numIterations)],'-.k','LineWidth',4)

%plot the actual percent contribution of each sub-network averaged over the simulations 
plot(avgPercents(:,1),avgPercents(:,3),'dr'); hold on;
plot(avgPercents(:,1),avgPercents(:,2),'*b'); 
plot(avgPercents(:,1),avgPercents(:,4),'ok');

set(gca, 'box', 'off');
legend('Work','Home','Social','Fraction Work Interactions',...
    'Fraction Home Interactions','Fraction Social Interactions')

% plot the average epidemic size over time
figure(2)
hold on
time = 1:iterations;
plot(time,epidemicSizeTotal/numTrials,'LineWidth',3);
xlabel('Time (Days)');
ylabel('Percent of Population');
