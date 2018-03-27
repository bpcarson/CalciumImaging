function [ comp ] = readvid( filename ,frameNum)
%UNTITLED Read in and resize calcium imaging video
%   Reads in video from filename input and then resizes it to half its
%   frame size. These frames are returned in the variable 'comp'

    v=VideoReader(filename);
    vlen=round(v.Duration*v.FrameRate)-1; %doesn't always come out as a whole number and is therefor rounded down 1.
    if frameNum==0
        frameNum=vlen;
    end
     
    for i=1:frameNum %vlen
        frame=readFrame(v);
        %frameg=rgb2gray(frame);
        compressedframe=imresize3(frame(:,:,:),[v.Height/2,v.Width/2 3]); %resized to save memory
        comp(i,:,:,:)=squeeze(compressedframe);% squeeze(frame); %squeeze out singleton dimensions
    end
end
