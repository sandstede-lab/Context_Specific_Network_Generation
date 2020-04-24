
%load the Warwick data for social interactions
load('socialDist.mat');

%add folders for supplementary functions
addpath(genpath('../octave-networks-toolbox'));
addpath(genpath('../gendist'));


%build network of 37 nodes because most have uniform distribution of degree
%up to 36
n = 37;

node = 1;
deg = n-1;

%separate those with degree <= 18 and > 18 into two distributions
[smallSocial,largeSocial] = separate(socialDist, 18);

%one extra person we don't connect to anyone so some people of degree 0
socialAdj = zeros(n+1);
original = socialAdj;

%keep track of frequencies to take average at end
freqListSocial = [];


while sum(logical(socialAdj(node,:))) < n-((node)-1)
    %assign frequency using the frequency distribution (smallSocial or largeSocial) 
    %based on node with larger degree (will always be node i)
    for i = (node+1):deg+1
         if deg > 18
             distribution = largeSocial(:,4:end);
         else
             distribution = smallSocial(:,4:end);
         end
         [F] = freqSampler(distribution, 1);
         socialAdj(node,i) = F;
         socialAdj(i,node) = F;
         freqListSocial = [freqListSocial F];
    end
    node = node + 1;
    deg = deg - 1;
end

original = socialAdj;

%add original structure and randomly choose a person from each structure to
%create edge to other popular (as we keep doubling, we allow for some high degree
%outliers)

%number of top degree nodes to choose from when adding edges
t = 5;
popular = 1:t;

%expand network by forming multiple of the original block
numofblocks = 78;  % this makes a network of 3002

for j = 1:numofblocks

    socialAdj = [socialAdj zeros(length(socialAdj(:,1)),length(original)); zeros(length(original),length(socialAdj(1,:))) original];
    popular = [popular (popular(end)+(n-t+2)) : (popular(end)+(n-t+1)+t)];

    %add edges from 1 of t most popular node to a random 25 other popular
    %nodes in different clusters (to reduce clustering)
    for k = 1:1
        a = popular(length(popular)-randi(t));
        for l = 1:25
            %only connect to other popular
            b = popular(randi(length(popular)-(t+1)));
            
            %choose freq distribution based on node with max degree
            d1 = sum(socialAdj(a,:));
            d2 = sum(socialAdj(b,:));
            deg = max(d1,d2);
            if deg > 18
                distribution = largeSocial(:,4:end);
            else
                distribution = smallSocial(:,4:end);
            end
            %sample from appropriate freq distribution
            [F] = freqSampler(distribution, 1);
            
            socialAdj(a,b) = F;
            socialAdj(b,a) = F;
            socialAdj(i,node) = F;
            
            freqListSocial = [freqListSocial F];
        end

    end
  
end


%shuffle 13000 connections
for k = 1:13000
    %pick random person who has connections
    p1 = randi(length(socialAdj));
    while sum(socialAdj(p1,:)) == 0
        p1 = randi(length(socialAdj));
    end
    %find someone p1 is already connected to
    p2 = randi(length(socialAdj));
    while socialAdj(p1,p2) == 0
        p2 = randi(length(socialAdj));
    end
    %find someone p1 is not yet connected to and who doesn't have degree 0
    p3 = randi(length(socialAdj));
    while socialAdj(p1,p3) > 0 || p1 == p3 || sum(socialAdj(p3,:)) < 10 || (sum(logical(socialAdj(p3,:))) < 25  && mod(k,2) == 0) || sum(logical(socialAdj(p3,:))) > 60 %|| sum(logical(socialAdj(p3,:))) == 36
        p3 = randi(length(socialAdj));
    end
    %disconnect p1 and p2
    socialAdj(p1,p2) = 0;
    socialAdj(p2,p1) = 0;
          
    %choose freq distribution based on node with max degree
    d1 = sum(logical(socialAdj(p1,:)));
    d2 = sum(logical(socialAdj(p3,:)));
    deg = max(d1,d2);
    if deg > 18
        distribution = largeSocial(:,4:end);
    else
        distribution = smallSocial(:,4:end);
   end
   %sample from appropriate frequency distribution
   [F] = freqSampler(distribution, 1);
   %connect p1 and p3
   socialAdj(p1,p3) = F;
   socialAdj(p3,p1) = F;
   socialAdj(i,node) = F;
   freqListSocial = [freqListSocial F];
end

%randomly remove 2 nodes to have 3000 people
a = randi(length(socialAdj));
socialAdj(a,:) = [];
socialAdj(:,a) = [];
b = randi(length(socialAdj));
socialAdj(b,:) = [];
socialAdj(:,b) = [];


%save adjacency matrix for social interactions
save('socialAdj.mat','socialAdj');


%calculate degree distribution
totDeg = degrees(socialAdj>0);
disp(length(totDeg));

centers = 0:4:60;

%plot degree distribution of generated network
figure
[f,x] = hist(totDeg,centers);
bar(x,f/sum(f)*100);
xlabel('Social Sub-network Degree', 'FontSize', 14)
ylabel('Percent of nodes', 'FontSize', 14)
hold off

%calculate frequency distribution of generated network
freqDist = frequencies(socialAdj);

%plot frequency distribution of generated network
figure
x = 1:14;
clusterDist = bar(x,freqDist/sum(freqDist)*100);
xlabel('Frequency', 'FontSize', 14)
ylabel('Percent of Interactions (Edges)', 'FontSize', 14)
hold off

