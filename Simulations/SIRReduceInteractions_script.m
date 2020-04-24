% Script that loads the .mat files for a specific network realization, then runs the 
% SIRWPathLength.m function in parallel "NT" times with infected seed chosen in the 
% particular way indicated by parameters "degreeInitial" and "LorR"

% User can remove networks pre-simulation to compare influence of each context
% and can initiate various dynamic responses of infected individuals

% Returns raw number of infected and recovered individuals (numInfectious, numImmune), 
% fraction of population infected at each time step (epidemicSize), and matrices for 
% speed at which infection reaches individuals at each distance from the initial 
% infection seed (speedSpreadInfected, speedSpreadImmune)


% load home, work, social networks
load('homeAdj.mat');
load('socialAdj.mat');
load('workAdj.mat');

NT   = 100;              % number of trials
nr_days = 200;        % number of days to run the simulation

R_0 = 1.2515;           % basic reproduction number
T = 4.5;                % mean infection time 

sizeSeed  = 10;         % number of infected individuals to start with
degreeInitial = 'R';    % 'L' for minimum degree initial person,
                        % 'H' for maximum degree initial person and 'R' for random
LorR = 'L';             % 'L' for localized infected seed (neighbors of initial person) or 
                        % 'R' (all random infected seed)
                        
% parameters for removing subnetworks pre-simulation to compare influence of each context
removeNum = 0;          % remove various subnetworks - see below
tau = 1;                % tau : 1 to calculate mean weighted degree after removing networks
                              % 2 to calculate mean weighted degree before removing networks
                        
% parameters for reducing interactions post infection (as dynamic response of individuals)
p            = 0.5;     % probability of changing interaction patterns 1 day after infected vs 2 days
workChange   = 0;       % percent of work interactions individual reduces post becoming infected
socialChange = 0;       % percent of social interactions individual reduces post becoming infected
homeChange   = 0;       % percent of home interactions an individual increases post becoming infected

%removeNum: 0 --> generate zeros matrix and subtract nothing; 
           %1 -->subtract social;
           %2 -->subtract work;
           %3 -->subtract home
           %4 -->subtract social and work;
           %5-->subtract social and home;
           %6-->subtract work and home;


for trial = 1:NT

% SIR - various contexts removed or reduced post infection
[numInfectious, numImmune, epidemicSize, speedSpreadInfected, speedSpreadImmune] = SIRReduceInteractions(trial,socialAdj,workAdj,homeAdj,nr_days,R_0,T,sizeSeed,degreeInitial,'L',removeNum,tau,p,workChange,socialChange,homeChange);

end


who
