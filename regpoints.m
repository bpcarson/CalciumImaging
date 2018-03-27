function [cur, curshort, a]=regpoints(filename)
% Returns paths and detected pattern
x2 = [2 -30 -30 2];
y2 = [-30 .999 -30 -30];
x3 = abs(x2);
y3 = y2;
x1= [-30 -30 30 30 -30];
y1= [1 25 25 1 1];
%%

% random X and Y location data
behav=readtable(filename);
for i=33:size(behav,1)
    if (behav.Var3{i}=='-')
        xq(i) = NaN;
        yq(i) = NaN;
        log(i)=i;
        continue
    end
    xq(i) = str2num(behav.Var3{i});
    yq(i) = str2num(behav.Var4{i});
end

x=1:1:size(xq,2);
[Fx,TF] = fillmissing(xq,'linear','SamplePoints',x);
[Fy,TF] = fillmissing(yq,'linear','SamplePoints',x);

%%

%
% find points in regions
[in] = inpolygon(Fx,Fy,x1,y1);
[in2] = inpolygon(Fx,Fy,x2,y2);
[in3] = inpolygon(Fx,Fy,x3,y3);
% Plot points and regions

%%
% Save detected points in one array to show order or switching
cur=in+(in2*2)+(in3*3); 
curshort=cur([1,diff(cur)]~=0);
curshort=curshort(curshort~=0);
p=perms([1 2 3]);
a=[];
for i =1:size(p,1)
al=strfind(curshort,[p(i,:)]);
a=[a al];
end