function [ Eta ] = eta( k, varargin )
%The eta function is a function of degree of a node.
%This function will modify the Barabasi-Albert model into the Fitness
%model. eta(k) = -0.5*tanh((k-k_0)/epsilon)+1

%Establishing default values for k_0 and epsilon
k_0 = 10; %number of people before eta kicks in
epsilon = 1; %rate of total effect

if nargin > 3
    error('too many parameters');
end
if k < 0
    error('Cannot have a negative degree');
end

switch nargin
    case 2
        k_0 = cell2mat(varargin);
    case 3
        k_0 = cell2mat(varargin(1));
        epsilon = cell2mat(varargin(2));
end

Eta = -0.5*tanh((k-k_0)/epsilon)+0.5;
end
