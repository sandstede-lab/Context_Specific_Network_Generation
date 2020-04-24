function [ u,v ] = find_path_length(A, u_0)
%Returns the path of interactions cumulatively and at each generation
%input A: an adjacency matrix
%    u_0: a vector initial condition.
n = length(A);
v = zeros(n,1);
u = zeros(n,1);

%pick a generation k
k = 9;
% v(:,1) = zeros(n,1);

v(:,1) = u_0;
for i = 2:k+1
    u(:,i-1) = u_0 > 0; %initial infected people
    
    %next set of infected people
    u(:,i) = A*u(:,i-1); 
    u(:,i) = min(u(:,i),1); %logical so no repeats occur

    %getting rid of everyone who was infected before
    u(:,i) = u(:,i) - v(:,i-1);
    u(:,i) = max(u(:,i),0);
    
    %cumulative set of infected people
    v(:,i) = v(:,i-1) + u(:,i);
    v(:,i) = min(v(:,i),1); %logical so no repeats
    
    if v(:,i) == ones(n,1)
        break
    elseif  i == n
        break
    end
    u_0 = u(:,i);
end

end

