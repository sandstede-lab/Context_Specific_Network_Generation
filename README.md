# Context-Specific Network Generation

MATLAB code for generating context-specific networks by lifting the interaction structure of the Warwick diary data, and simulating flu dynamics on the network

*Authors:* Kristina Mallory, Joshua Rubin Abrams, Anne Schwartz, Maria-Veronica Ciocanel, Alexandria Volkening, and Bjorn Sandstede

*Contact:* Kristina Mallory (kristina_mallory@brown.edu)


## Description

This software generates context-specific networks by lifting the interaction structure of the Warwick diary data. The software inputs the diary data and outputs three individual sub-networks: home, social, and work interaction networks with an extended population size and comparable structure to the diary data. The software also simulates influenza spread over the combined network.

We adapted some of our functions from an online GitHub toolbox: octave-networks-toolbox, DOI: 10.5281/zenodo.22398 (http://dx.doi.org/10.5281/zenodo.22398). The specific files are cited in the Exposition below. All other files were written by the authors. 

This software reproduces the computations presented in K. Mallory, J.R. Abrams, A. Schwartz, M.V. Ciocanel, A. Volkening, and B. Sandstede, "Influenza spread on context-specific networks lifted from interaction-based diary data" (2020). In preparation.

Details about the method can be found in the manuscript.


## Exposition

*Note:* Before working with the existing Warwick diary (see reference [1]), we transferred the data from a single spreadsheet containing all interaction types to three Matlab matrices: homeDist.mat, socialDist.mat, and workDist.mat, which separate each interaction by context (home, social, and work interaction, respectively). These are located in the folder Network Generation within subfolders Home Network, Social Network, and Work Network, respectively. In separating and storing the data, we made a few choices to account for discrepancies and missing data. To learn how this data was organized and cleaned, see the separate text file titled OrganizingTheWarwickData.md. 


### Network Generation

The folder Network Generation contains three folders with code to generate each of the sub-networks. 

#### Home Network 

Inside the Home Network folder, the main script for generating the extended home network from the cleaned Warwick diary data is titled HomeNetworkGeneration.m. This file will load the home interaction details in the Warwick diary data titled homeDist.mat and generate a larger network of home units by sampling from the degree and frequency distributions of the data in homeDist.mat. The script then saves the generated home network adjacency matrix and plots the generated home network degree and frequency distributions. The remaining files are auxiliary functions called by HomeNetworkGeneration.m to generate the network: degrees.m, degreeSampler.m, freqSampler.m, frequencies.m, gendist.m, isDirected.m, separate.m. Note that degrees.m, gendist.m, and isDirected.m were adapted from reference [2].

#### Social Network

Inside the Social Network folder, the main script for generating the extended social network from the cleaned Warwick diary data is titled SocialNetworkGeneration.m. This file will load the social interaction details in the Warwick diary data titled socialDist.mat and generate a larger network of social units with pre-specified degree by sampling from the frequency distributions of the data in socialDist.mat. The script then saves the generated social network adjacency matrix and plots the generated social network degree and frequency distributions. The remaining files are auxiliary functions called by SocialNetworkGeneration.m to generate the network: degrees.m, freqSampler.m, frequencies.m, gendist.m, isDirected.m, separate.m. Note that degrees.m, gendist.m, and isDirected.m were adapted from reference [2].

#### Work Network
 
Inside the Work Network folder, the main script for generating the extended work network from the cleaned Warwick diary data is titled WorkNetworkGeneration.m. This file will load the work interaction details in the Warwick diary data titled workDist.mat and workNet.mat, and generate a larger network of work units with pre-specified degree by sampling from the frequency distributions of the data in workDist.mat and workNet.mat. The script then saves the generated work network adjacency matrix and plots the generated work network degree and frequency distributions. The remaining files are auxiliary functions called by WorkNetworkGeneration.m to generate the network: addDegrees.m, addNetwork.m, addNode2.m, degrees.m, eta.m, freqSampler.m, frequencies.m, gendist.m, grow2.m, isDirected.m, and isSymmetric.m. Note that degrees.m, gendist.m, isDirected.m, and isSymmetric.m were adapted from reference [2].


### Simulations

The folder Simulations contains the main function titled SIRReduceInteractions.m for SIR simulations on the network and a script SIRReduceInteractions_script.m to call this function for various network realizations. This function will load and combine the three sub-networks generated from the files in the Network Generation folder and run a discrete SIR model over the network. The function plots the epidemic size over time and outputs the raw number of infected and recovered individuals (numInfectious, numImmune), the fraction of the population infected at each time step (epidemicSize), and matrices for the speed at which the infection reaches individuals at each distance from the initial infection seed (speedSpreadInfected, speedSpreadImmune).

In the script SIRReduceInteractions_script.m, which calls the SIRReduceInteractions.m function, we can select appropriate parameters for the scenario we desire:

- Using the removeNum parameter, we can remove any sub-network (home, social, work, or several of these) to run the simulation over a simplified version of the network. This scenario allows us to compare the influence of each interaction context on disease spread. 

- Using the homeChange, socialChange, and workChange parameters, we can initiate a dynamic response to infection. The socialChange parameter indicates the percent of social interactions an individual will remove after being infected (thereby reducing their total social interactions by socialChange percent). Similarly, workChange indicates the percent of work interactions an individual removes after infection. The homeChange parameter indicates the percent by which an individual increases their home interactions after being infected. When one of the above parameters is positive, there is also a parameter p that gives the percentage of infected individuals who will reduce these interactions after one day of infection (versus after two days). 

- The folder Simulations lastly contains a file whichContext.m which loads the simulations generated in SIRReduceInteractions.m for a designated number of trials, averages this data, and then finds the percent contribution of each interaction context (i.e., sub-network) to the disease spread at each time step. For comparison, the function then plots the results over time alongside the expected percent contributions of each network due to the underlying network structure.


## References

1. Read JM, Eames KT, Edmunds WJ. Dynamic social networks and the implications for the spread of infectious disease. Journal of The Royal Society Interface. 2008; 5(26):1001–1007.
2.  Octave-networks-toolbox (GitHub). DOI: 10.5281/zenodo.22398 (http://dx.doi.org/10.5281/zenodo.22398).
