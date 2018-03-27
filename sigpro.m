function [ neur, catran,clusters ] = sigpro( traces, centers )
%UNTITLED5 Process and cluster detected traces
%   Detailed explanation goes here
    lpFilt = designfilt('lowpassiir','FilterOrder',8, ...
             'PassbandFrequency',.5,'PassbandRipple',0.2, ...
             'SampleRate',20);
    hpFilt = designfilt('highpassiir','FilterOrder',8, ...
     'PassbandFrequency',2,'PassbandRipple',0.2, ...
     'SampleRate',20);

    for i=1:size(traces,1)
        normx=filtfilt(hpFilt,traces(i,:));
        neur(i,:)=normx;

    end

    for i=1:size(traces,1)
        norml=filtfilt(lpFilt,traces(i,:));
        catran(i,:)=norml;
    end

    clusters = clusterdata(neur,3);
    
    
end

