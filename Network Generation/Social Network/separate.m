function [small,large] = separate(dist, split)
%divide participants in Warwick data based on degree -- people with the value
%of "split" or fewer degrees will be in a small category and those with a degree 
%greater than "split" will be in a large category 

tNum=3529;

small = zeros(1,tNum+3);
large = zeros(1,tNum+3);

smallCount = 1;
largeCount = 1;

for i = 1:length(dist(:,1))
    if dist(i,1) > split
        %next row of large matrix will have degree in first column and
        %average frequency in second column and list of frequencies in
        %third
        large(largeCount,1) = dist(i,1);
        large(largeCount,2) = dist(i,2);
        large(largeCount,3) = dist(i,3);
        large(largeCount,4:end) = dist(i,5:end);
        largeCount = largeCount + 1;
    else
        %next row of small matrix will have degree in first column and
        %average frequency in second column and list of frequencies in
        %third
        small(smallCount,1) = dist(i,1);
        small(smallCount,2) = dist(i,2);
        small(smallCount,3) = dist(i,3);
        small(smallCount,4:end) = dist(i,5:end);
        smallCount = smallCount + 1;
    end
end
