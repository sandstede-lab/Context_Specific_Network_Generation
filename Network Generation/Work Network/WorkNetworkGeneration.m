
%load the Warwick data for work interactions
load('workDist.mat');
load('workNet.mat');

%add folders for supplementary functions
addpath(genpath('../octave-networks-toolbox'));
addpath(genpath('../gendist'));

%% number of n-person businesses

% 136 units of 3 people
% 26 units of 8 people
% 2 units of 15 people
% 11 units of 17 people
% 2 units of 18 people
% 2 units of 19 people  
% 12 units of 38 people
% 4 units of 80 people
% 1 unit of size 99 people
% 1 unit of 193 people
% 2 unit of 200 people
% 1 unit of 275 people
% 1 unit of 350 people

% total: 3000 people


m = 30; %parameter for the B-A model

totDeg = [];

%% we make up the work network using many individual work units

%all units under 20 employees are uniformly distributed
%n+1 is the number of people uniformly distributed with degrees from 0 to n-1


% 136 units of size 3 people

n = 2; %first generate one of these
node = 1;
deg = n-1;
adj = zeros(n+1);
while sum(logical(adj(node, :)))<n-(node-1)
    for i = (node+1):deg+1
        F = freqSampler(workDist(:,5:end),1);
        adj(node,i) = F;
        adj(i, node) = F;
    end
    node = node+1;
    deg = deg-1;
end
original = adj;
number_of_businesses = 135; %generate 135 more identical units
for j = 1:number_of_businesses
    adj = addNetwork(adj,original);
end

workAdj = adj;    
totDeg = [totDeg degrees(adj>0)];

%%%%%%%%%%%%%%%%%%%%%

% 26 units of size 8 people

n = 7; %generate one of these
node = 1;
deg = n-1;
adj = zeros(n+1);
while sum(logical(adj(node, :)))<n-(node-1)
    for i = (node+1):deg+1
        F = freqSampler(workDist(:,5:end),1);
        adj(node,i) = F;
        adj(i, node) = F;
    end
    node = node+1;
    deg = deg-1;
end
original = adj;
number_of_businesses = 25; %generate 25 more identical units
for j = 1:number_of_businesses
    adj = addNetwork(adj,original);
end
workAdj = addNetwork(adj,workAdj);                                                                          
totDeg = [totDeg degrees(adj>0)];


%%%%%%%%%%%%%%%%%%%%%

% 2 units of size 15 people

n = 14; %generate one of these
node = 1;
deg = n-1;
adj = zeros(n+1);
while sum(logical(adj(node, :)))<n-(node-1)
    for i = (node+1):deg+1
        F = freqSampler(workDist(:,5:end),1);
        adj(node,i) = F;
        adj(i, node) = F;
    end
    node = node+1;
    deg = deg-1;
end
original = adj;
number_of_businesses = 1; %generate 1 more identical unit
for j = 1:number_of_businesses
    adj = addNetwork(adj,original);
end
workAdj = addNetwork(adj,workAdj);                                                                           
totDeg = [totDeg degrees(adj>0)];


%%%%%%%%%%%%%%%%%%%%%

% 11 units of 17 people

n = 16; %generate one of these
node = 1;
deg = n-1;
adj = zeros(n+1);
while sum(logical(adj(node, :)))<n-(node-1)
    for i = (node+1):deg+1
        F = freqSampler(workDist(:,5:end),1);
        adj(node,i) = F;
        adj(i, node) = F;
    end
    node = node+1;
    deg = deg-1;
end
original = adj;
number_of_businesses = 10; %generate 10 more identical units
for j = 1:number_of_businesses
    adj = addNetwork(adj,original);
end
workAdj = addNetwork(adj,workAdj);                                                                           
totDeg = [totDeg degrees(adj>0)];


%%%%%%%%%%%%%%%%%%%%%

% 2 units of size 18 people

n = 17; %generate one of these
node = 1;
deg = n-1;
adj = zeros(n+1);
while sum(logical(adj(node, :)))<n-(node-1)
    for i = (node+1):deg+1
        F = freqSampler(workDist(:,5:end),1);
        adj(node,i) = F;
        adj(i, node) = F;
    end
    node = node+1;
    deg = deg-1;
end
original = adj;
number_of_businesses = 1; %generate 1 more identical unit
for j = 1:number_of_businesses
    adj = addNetwork(adj,original);
end
workAdj = addNetwork(adj,workAdj);                                                                           
totDeg = [totDeg degrees(adj>0)];


%%%%%%%%%%%%%%%%%%%%%

% 2 units of size 19 people  

n = 18; %generate one of these
node = 1;
deg = n-1;
adj = zeros(n+1);
while sum(logical(adj(node, :)))<n-(node-1)
    for i = (node+1):deg+1
        F = freqSampler(workDist(:,5:end),1);
        adj(node,i) = F;
        adj(i, node) = F;
    end
    node = node+1;
    deg = deg-1;
end
original = adj;
number_of_businesses = 1; %generate 1 more identical unit
for j = 1:number_of_businesses
    adj = addNetwork(adj,original);
end
workAdj = addNetwork(adj,workAdj);                                                                          
totDeg = [totDeg degrees(adj>0)];


%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%

% for larger units we use Barabasi-Albert model to generate

% 12 units of size 38

number_of_businesses = 12;
for i = 1:number_of_businesses
    cluster_38 = grow2(workNet, 28, m); %fitness model growth
    workAdj = addNetwork(cluster_38,workAdj);
    deg38 = degrees(cluster_38>0);
    totDeg = addDegrees(totDeg, deg38);
%     disp([num2str(i) '/' num2str(number_of_businesses)])
end

% 4 units of size 80 people

number_of_businesses = 4;
for i = 1:number_of_businesses
    cluster_80 = grow2(workNet, 70, m); %fitness model growth
    workAdj = addNetwork(cluster_80,workAdj);
    deg80 = degrees(cluster_80>0);
    totDeg = addDegrees(totDeg, deg80);
%     disp([num2str(i) '/' num2str(number_of_businesses)])
end


% 1 unit of size 99

number_of_businesses = 1;
for i = 1:number_of_businesses
    cluster_99 = grow2(workNet, 89, m); %fitness model growth
    workAdj = addNetwork(cluster_99,workAdj);
    deg99 = degrees(cluster_99>0);
    totDeg = addDegrees(totDeg, deg99);
%     disp([num2str(i) '/' num2str(number_of_businesses)])
end


% 1 unit of size 193

number_of_businesses = 1;
for i = 1:number_of_businesses
    cluster_193 = grow2(workNet, 183, m); %fitness model growth
    workAdj = addNetwork(cluster_193,workAdj);
    deg193 = degrees(cluster_193>0);
    totDeg = addDegrees(totDeg, deg193);
%     disp([num2str(i) '/' num2str(number_of_businesses)])
end


% 2 units of size 200

number_of_businesses = 2;
for i = 1:number_of_businesses
    cluster_200 = grow2(workNet, 190, m); %fitness model growth
    workAdj = addNetwork(cluster_200,workAdj);
    deg200 = degrees(cluster_200>0);
    totDeg = addDegrees(totDeg, deg200);
%     disp([num2str(i) '/' num2str(number_of_businesses)])
end


% 1 unit of size 275

number_of_businesses = 1;
for i = 1:number_of_businesses
    cluster_275 = grow2(workNet, 265, m); %fitness model growth
    workAdj = addNetwork(cluster_275,workAdj);
    deg275 = degrees(cluster_275>0);
    totDeg = addDegrees(totDeg, deg275);
%     disp([num2str(i) '/' num2str(number_of_businesses)])
end


% 1 unit of size 350

number_of_businesses = 1;
for i = 1:number_of_businesses
    cluster_350 = grow2(workNet, 340, m); %fitness model growth
    workAdj = addNetwork(cluster_350,workAdj);
    deg350 = degrees(cluster_350>0);
    totDeg = addDegrees(totDeg, deg350);
%     disp([num2str(i) '/' num2str(number_of_businesses)])
end


%save adjacency matrix for work interactions
save('workAdj.mat','workAdj');


%display size of generated network
disp(length(totDeg));

centers = 0:4:200;

%plot degree distribution of generated network
figure
[f,x] = hist(totDeg, centers);
clusterDist = bar(x,f/sum(f)*100);
xlabel('Work Sub-network Degree', 'FontSize', 14)
ylabel('Percent of nodes', 'FontSize', 14)
hold off

%calculate frequency distribution of generated network
freqDist = frequencies(workAdj);

%plot frequency distribution of generated network
figure
x = 1:14;
clusterDist = bar(x,freqDist/sum(freqDist)*100);
xlabel('Frequency', 'FontSize', 14)
ylabel('Percent of Interactions (Edges)', 'FontSize', 14)
hold off

            
