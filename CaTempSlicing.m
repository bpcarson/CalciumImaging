%% Exploratory Analysis of Calcium Imaging 
% The first section takes in a video file and converts it into 3D and 4D variables. 
% The data is then reshaped to view temporal slices. 

addpath('Ca Vids');
v=VideoReader('msCam1.avi');
vlen=round(v.Duration*v.FrameRate)-1;
for i=1:vlen
    frame=readFrame(v);
   compressedframe=imresize(frame(:,:,1),[v.Height/2,v.Width/2]);
   % d(:,:,1,i)=compressedframe;
   comp(:,:,i)=squeeze(compressedframe);
    %comp(:,:,i)=squeeze(frame(:,:,1));
end

%% Data Exploration
%%

%cm=medfilt3(comp,[41, 41, 19]);
cm=medfilt3(comp,[45, 45, 7]);%measure neuron?
%maxcm=max(max(cm));
%threshfilt(cm>max(max(cm))=cm;
c=comp-1.05*cm;
%%

imagesc(squeeze(mean(comp,3)))
gra=imgradient(squeeze(mean(comp,3)));
%gra(gra<mean(mean(gra)))=0;
imagesc(gra)
imagesc(squeeze(mean(c,3)>2))
imagesc(squeeze(mean(cm,3)))
%%

imagesc(squeeze(mean(c,2)))

%%

V = im2single(c);

imagesc(squeeze(mean(c,2)))
imagesc(squeeze(mean(comp,1)))
imagesc(squeeze(mean(c,1)))
%%
imagesc(mean(c,3))
%hold on
%for i = 1:size(c,3)
grim=gra+mean(c,3);
imagesc(grim)
%imshowpair(mean(c,3),gra)
imshowpair(grim,mean(c,3))

%%

gra3=imgradientxyz(comp);
imshowpair(abs(mean(gra3,3)),mean(comp,3))
%%

BW4 = bwareafilt(mean(gra3,3)>.6,10);
imagesc(BW4)

 BW3 = bwareafilt(grim>2.1,10);
imagesc(BW3)
imshowpair(BW3, mean(comp,3),'Montage')

%volumeViewer(V)


%%

%imshow(B)
%d=reshape(c,size(c,1), size(c,2), 1, size(c,3));
BW2 = bwareafilt(mean(c,3)>6*mean(mean(mean(c,3))),25);
imshow(BW2)

imagesc(mean(comp,3))
title('Detected Neurons')

BW2 = bwareafilt(mean(c,3)>5*mean(mean(mean(c,3))),25);

stats = regionprops('table',BW2,'Centroid', ...
                 'MajorAxisLength','MinorAxisLength');

% Get centers and radii of the circles
centers = stats.Centroid;
diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
radii = diameters/2;

% Plot the circles
hold on
viscircles(centers,radii);
hold off
%%
lpFilt = designfilt('lowpassiir','FilterOrder',8, ...
         'PassbandFrequency',.5,'PassbandRipple',0.2, ...
         'SampleRate',20);
hpFilt = designfilt('highpassiir','FilterOrder',8, ...
 'PassbandFrequency',2,'PassbandRipple',0.2, ...
 'SampleRate',20);
fig1=figure;
hold on
for i = 1:size(centers,1)
    neuron{i}.cuts = comp(round(centers(i,1)-1.5*radii(i)):round(centers(i,1)+1.5*radii(i)), round(centers(i,2)-1.5*radii(i)): ...
        round(centers(i,2)+1.5*radii(i)),:);
    traces(i,:)=squeeze(sum(sum(neuron{i}.cuts,2)));
    
    plot(traces(i,:))
    %{
    [p,s,mu] = polyfit((1:size(traces(i,:),2)),traces(i,:),8);
    f_y = polyval(p,(1:numel(traces(i,:)))',[],mu);

%  Subtract polynomial fit from data to remove drift.

    normx=traces(i,:)-f_y';

    plot(normx)
    %}
end
hold off
%%

fig=figure;
hold on
for i=1:size(traces,1)
    normx=filtfilt(hpFilt,traces(i,:));
    plot(normx)
    title('High pass filtered traces')
end
hold off
fig2=figure;
hold on
for i=1:size(traces,1)
        norml=filtfilt(lpFilt,traces(i,:));
    plot(norml)
    title('Low pass filtered traces')
end
hold off