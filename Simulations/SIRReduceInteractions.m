function [numInfectious, numImmune, epidemicSize, speedSpreadInfected, speedSpreadImmune] = SIRReduceInteractions(trial,socialAdj,workAdj,homeAdj,iterations,R_0,T,seedSize,degreeInitial,LorR,removeNum,tau,probReduce,workChange,socialChange,homeChange)

%combine subnetworks to create single network with multiple interaction contexts
adjMatrix = homeAdj + socialAdj + workAdj;

%identify which matrix to subtract (zeros if no matrix -- removeNum = 0)
if removeNum == 0
    remove = zeros(length(adjMatrix(:,1)),length(adjMatrix(1,:)));
elseif removeNum == 1
    remove = socialAdj;
elseif removeNum == 2
    remove = workAdj;
elseif removeNum == 3
    remove = homeAdj;
elseif removeNum == 4
    remove = socialAdj + workAdj;
elseif removeNum == 5
    remove = socialAdj + homeAdj;
elseif removeNum == 6
    remove = workAdj + homeAdj;
end

%mean weighted degree calculation based on parameter tau
% remove networks first
if tau == 1
    adjMatrix = adjMatrix - remove; 
    meanWeightedDegree = mean(adjMatrix*ones(length(adjMatrix(1,:)),1));
%calculate first
elseif tau == 2
    meanWeightedDegree = mean(adjMatrix*ones(length(adjMatrix(1,:)),1));
    adjMatrix = adjMatrix - remove;
end

numInfectious = zeros(1,iterations);
numImmune = zeros(1,iterations);
epidemicSize = zeros(1,iterations);

mkdir(['SIRRemove' num2str(removeNum) '_Reduce_Social' num2str(socialChange) '_Work' num2str(workChange) '_Home' num2str(homeChange) '_initialDegree' degreeInitial]);
%SIR model

%number of people who are susceptible, infected, or recovered
n = length(adjMatrix);

%initialize list to store initial infected people
u_0 = zeros(n,1);
%initialize list for very first person infected in local case
u_initial = zeros(n,1);

%initialize array that will be used to show who is infected at the
%beginning of the given time step
old = zeros(1,n);
allOld = zeros(iterations, n);
allOld(1,:) = old;
%same as old but replace with -1 when reduce someone's interactions
interactingAllOld = zeros(iterations, n);
interactingAllOld(1,:) = old;
%list to keep track of duration of infectiousness
timeInf = zeros(1,n);

%one list to keep track of people infected at the previous round so at end of time
%period we can reduce their interactions, and another to keep track of
%newly infected that round so next time step we can reduce interactions
newlyInfected = zeros(1,n);
reduceInteractionsNext = zeros(1,n);
tempNewlyInfected = zeros(1,n);

%create a localized infection seed if LorR is 'L'
if LorR == 'L' || LorR == 'l'
    %begin with lowest degree person initially
    if degreeInitial == 'L' || degreeInitial == 'l'
        [numMin,whichIndex] = min(sum(adjMatrix(:,:)>0));
        I = whichIndex;
    %or begin with highest degree person initially
    elseif degreeInitial == 'H' || degreeInitial == 'h'
        [numMax,whichIndex] = max(sum(adjMatrix(:,:)>0));
        I = whichIndex;
    %otherwise choose random initital
    else
        I = randi(n);
    end
    old(I) = 1;
    u_0(I) = 1;
    u_initial(I) = 1;
    %find time of infectiousness
    while timeInf(I) == 0
        timeInf(I) = round(exprnd(T));
    end
    %choose seedSize-1 neighbors and account for issue if don't have enough neighbors
    numNeighbors = sum(logical(adjMatrix(I,:)));
    if numNeighbors < seedSize-1
       for i = 1 : length(adjMatrix(I,:))
         if adjMatrix(i,I) >=1
            old(i) = 1;
            u_0(i) = 1;
            while timeInf(i) == 0
                timeInf(i) = round(exprnd(T));
            end
         end
        end
       remaining = seedSize - sum(old(1,:));
       %randomly choose people 2 degrees away from original to infect
       %reminaing number
       [ u,v ] = find_path_length(adjMatrix, u_initial);
       for j = 1:remaining
           A = randi(n);
           %make sure random index A is 2 degrees away from original and
           %not yet infected
           while u(A,3) == 0 || old(A) == 1
               A = randi(n);
           end
           old(A) = 1;
           u_0(A) = 1;
           while timeInf(A) == 0
               timeInf(A) = round(exprnd(T));
           end
       end
    else  %infect neighbors if initial infected has seedSize-1 neighbors
        for j = 1:seedSize-1
           A = randi(n);
           while adjMatrix(I,A) == 0 || old(A) == 1
                A = randi(n);
           end
           old(A) = 1;
           u_0(A) = 1;
           %find time of infectiousness
           while timeInf(A) == 0
               timeInf(A) = round(exprnd(T));
           end
        end
    end
    
            

%choose 10 random people to start infected if 'R' or 'r'
elseif LorR == 'R' || LorR == 'r'
    for i = 1:seedSize
        I = randi(n);
        %don't choose someone already chosen to infect
        while old(I) == 1
            I = randi(n);
        end
        old(I) = 1;
        u_0(I) = 1;
        %find time of infectiousness
        while timeInf(I) == 0
            timeInf(I) = round(exprnd(T));
        end
    end
end


%create u matrix of people at each distance from initial people infected
[ u,v ] = find_path_length(adjMatrix, u_0);

speedSpreadInfected = zeros(iterations, length(u(1,:)));
speedSpreadImmune = zeros(iterations, length(u(1,:)));
speedSpreadInfected(1,1) = sum(old(1,:));

newlyInfected = old;

temp = old;

%initialize counter to count number of infected
count = 0;
for l = 1:n
    if temp(l) == 1
        count = count + 1;
    end
end

epidemic = count/n;

numInfected(1) = count;
epidemicSize(1) = epidemic;
numImmune(1) = 0;


%%%
%create matrix to easily evaluate susceptible people's total interactions
    %with infected
infectedConnections = adjMatrix;

for doublingTime = 1:iterations-1
    
    for i = 1:length(adjMatrix(1,:))
        %only keep values down column for infected person
        if old(i) ~= 1
            infectedConnections(:,i) = 0;
        end
        %if not susceptible, get rid of row
        if old(i) ~= 0
           infectedConnections(i,:) = 0;
        end 

    end

    %save initial matrix to avoid someone getting infected from someone who gets infected in
    %same time step
    originalInfectedConnections = infectedConnections;
    
    %loop through all people and if susceptible, see if infected
    for s = 1:n
        %don't do anything if not susceptible
        if old (s) ~= 0
        %for all susceptible people
        else
            %for each susceptible person look at their neighbors by looking at row of
                %originalInfectedConnections matrix to see if any infected
                %neighbors from previous time step
            totalF = sum(originalInfectedConnections(s,:));
            %if not susceptible (already infected) or no infected connections, don't do anything
            if totalF == 0
            else
                %for all infected neighbors of person s, sum weights of interaction
                %between each infected and s over mean weighted degree
                sumRatio = 0;
                for i = 1:length(infectedConnections(s,:))
                    if originalInfectedConnections(s,i) ~= 0
                        ratioConnected = originalInfectedConnections(s,i)/meanWeightedDegree;
                        sumRatio = sumRatio + ratioConnected;
                    end
                end
                p = (R_0/T)*sumRatio;
                r = rand(1);
                   %if become infected insert a one in the person's index of
                            %temp and sample for time to recover
                    if r < p
                        temp(s) = 1;  
                        tempNewlyInfected(s) = 1;
                  
                        %find time to recover
                        while timeInf(s) == 0
                            timeInf(s) = round(exprnd(T));
                        end
                    end
            end
        end

    end

        
    %initialize final as temp and then adjust based on who recovers
    final = temp;
   
    %loop through those who were infected in old to see who recovers
    for a = 1:n
        if old(a) == 1
            tp = timeInf(a);
            %one day closer to recovery
            if tp >= 1
                timeInf(a) = timeInf(a)-1;
            %else person recovered
            else
                final(a) = 2;
                infectedConnections(:,a) = 0;
                infectedConnections(a,:) = 0;
            end
        end
    end

    
    %initialize counter to count number of infected
    immune = 0;
    count = 0;
    for l = 1:n
        if final(l) == 1
            count = count + 1;
        elseif final(l) == 0
        else
            immune = immune +1;
        end
    end
    epidemic = count/n;

    numInfectious(doublingTime+1) = count;
    epidemicSize(doublingTime+1) = epidemic;
    numImmune(doublingTime+1) = immune;
  

    %fill in table to analyze speed of disease spread
    for layer = 1:length(u(1,:))
        for i = 1:n
            if u(i,layer) == 1
                if final(i) == 1
                    speedSpreadInfected(doublingTime+1,layer) = speedSpreadInfected(doublingTime+1,layer) + 1;
                elseif final(i) == 2
                    speedSpreadImmune(doublingTime+1,layer) = speedSpreadImmune(doublingTime+1,layer) + 1;
                end
            end
        end
    end
    
    %remove interactions from adjMatrix for those infected 2 time steps back 
    %and in reduceInteractionsNext list and in previous time step if randi 
    %is less than .5, otherwise add to list for next round
    for i = 1:n
        tempReduceInteractions = reduceInteractionsNext;
        if tempReduceInteractions(i) == 1
            adjMatrix(i,:) = adjMatrix(i,:) - socialChange*socialAdj(i,:) - workChange*workAdj(i,:) + homeChange*homeAdj(i,:);
            adjMatrix(:,i) = adjMatrix(:,i) - socialChange*socialAdj(:,i) - workChange*workAdj(:,i) + homeChange*homeAdj(:,i);
            interactingAllOld(doublingTime+1,i) = -1;
            reduceInteractionsNext(i) = 0;
        elseif newlyInfected(i) == 1
            
            randomNum = randi(1);
            if randomNum < probReduce
                adjMatrix(i,:) = adjMatrix(i,:) - socialChange*socialAdj(i,:) - workChange*workAdj(i,:) + homeChange*homeAdj(i,:);
                adjMatrix(:,i) = adjMatrix(:,i) - socialChange*socialAdj(:,i) - workChange*workAdj(:,i) + homeChange*homeAdj(:,i);
                interactingAllOld(doublingTime+1,i) = -1;
            else 
                reduceInteractionsNext(i) = 1;
            end
        end
    end
    
    %update newlyInfected
    newlyInfected = tempNewlyInfected;
    
    old = final;
    temp = old;
    allOld(doublingTime+1,:) = old;
    %update infectedConnections to match new adj
    infectedConnections = adjMatrix;

end

%determine the speed at which infection and recovery spread from the
%initial seed
scaledSpeedSpreadInfected = zeros(iterations, length(u(1,:)));
scaledSpeedSpreadImmune = zeros(iterations, length(u(1,:)));
total = zeros(1,length(speedSpreadInfected(1,:)));
for i = 1:length(u(1,:))
    total(i) = sum(u(:,i));
end

for i = 1:length(speedSpreadInfected(1,:))
    scaledSpeedSpreadInfected(:,i) = speedSpreadInfected(:,i)/total(1,i);
    scaledSpeedSpreadImmune(:,i) = speedSpreadImmune(:,i)/total(1,i);
end

% plot the epidemic size over time
time = 1:iterations;
plot(time,epidemicSize,'LineWidth',3);

xlabel('Time(Days)');
ylabel('Percent of Population');


save(['SIRRemove' num2str(removeNum) '_Reduce_Social' num2str(socialChange) '_Work' num2str(workChange) '_Home' num2str(homeChange) '_initialDegree' degreeInitial '/SIRNetwork_Initial_' LorR '_Trial_' num2str(trial) '.mat'])
