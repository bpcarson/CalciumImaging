function [ traces,cent, rad,c ] = cadet( comp )
%UNTITLED3 Detects neurons in video
%   Detailed explanation goes here
    cm=medfilt3(comp,[45, 45, 7]); % filter with size [x, y, z]
    c=comp-1.05*cm; %subtract background
    %{
    cent=[0 ,0];
    for i=1:size(c,3)
        BW2 = bwareafilt(c(:,:,i)>5*mean(mean(c(:,:,i),3)),10);
        stats = regionprops('table',BW2,'Centroid', ...
                         'MajorAxisLength','MinorAxisLength');
        % Get centers and radii of the circles
        centers(:,:,i)= stats.Centroid;
        %cent=[cent;centers];
        diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
        radii(:,:,i) = diameters/2;
    end
    
    cent=centers(:,:,1);
    rad=radii(:,:,1);
     
    for j = 1:size(centers,3)
        cent=[cent; centers(:,:,j)];
        rad=[rad; radii(:,:,j)];
    end
             
    pcent=cent.^2;
    sc=sqrt(pcent(:,1)+pcent(:,2));
    sort(sc);
    %}
    mimg=max(c,[],3)-medfilt2(max(c,[],3),[15 15]);
    BW2 = bwareafilt(mimg>1,50);
    stats = regionprops('table',BW2,'Centroid', ...
                     'MajorAxisLength','MinorAxisLength');
    % Get centers and radii of the circles
    cent(:,:) = stats.Centroid;
    diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
    rad(:,:) = diameters/2;
    
    for i = 1:size(cent,1) %now has multiple dimensions! must sort first!
        neuron{i}.cuts = comp(round(cent(i,1)-rad(i)):round(cent(i,1)+rad(i)), round(cent(i,2)-rad(i)): ...
             round(cent(i,2)+rad(i)),:);
        traces(i,:)=squeeze(sum(sum(neuron{i}.cuts,2)));
    end
    
end
%cent
