%% Regions of interest
x2 = [2 -30 -30 2];
y2 = [-30 .99 -30 -30];
x3 = abs(x2);
y3 = y2;
x4 = [2 -30 30 2];
y4 = [-30.01 1 1 -30.01];
x1= [-30 -30 30 30 -30];
y1= [1.01 25 25 1.01 1.01];

% random X and Y location data
%behav=readtable('behavEtho.xlsx');
%rng default
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
%log=log>1;
%log(size(xq,2))=0;
%xq(log)=NaN;
%yq(log)=NaN;
%chek=xq;
%mind=find(log>1);
%gind=find(diff(mind)~=1) %mind([1,diff(mind)]~=1)
[Fx,TF] = fillmissing(xq,'linear','SamplePoints',x);
[Fy,TF] = fillmissing(yq,'linear','SamplePoints',x);


%
% find points in regions
[in] = inpolygon(Fx,Fy,x1,y1);
[in2] = inpolygon(Fx,Fy,x2,y2);
[in3] = inpolygon(Fx,Fy,x3,y3);
[in4]=inpolygon(Fx,Fy,x4,y4);
% Plot points and regions
figure
plot(x1,y1,'LineWidth',2) % polygon
axis equal
hold on

plot(x2,y2,'LineWidth',2)
plot(x3,y3,'LineWidth',2)
plot(x4,y4, 'LineWidth',2)
plot(Fx,Fy, 'k.') % all points
plot(Fx(in),Fy(in),'yo') % points in 1
plot(Fx(in2),Fy(in2),'bo') % points in 2
plot(Fx(in3),Fy(in3),'ro') % points in 3
plot(Fx(in4),Fy(in4),'go') % points in 3
title('Detected points in regions of interest')
legend('show')
hold off
   
   
   %%
   
% Save detected points in one array to show order or switching
cur=in+(in2*2)+(in3*3)+(in4*4);
cur(cur==0)=NaN;
[Fcur,TF] = fillmissing(cur,'linear','SamplePoints',x);
curshort=cur([1,diff(Fcur)]~=0);
b=strfind(curshort,[1 4 2 4 3]);
c=strfind(curshort,[1 4 3 4 2]);
d=strfind(curshort,[2 4 1 4 3]);
e=strfind(curshort,[2 4 3 4 1]);
f=strfind(curshort,[3 4 1 4 2]);
g=strfind(curshort,[3 4 2 4 1]);
%cur=in+(in2*2);
figure
plot(curshort,':s')
hold on
plot(b,curshort(b),'ro')
plot(c,curshort(c),'bo')
plot(d,curshort(d),'go')
plot(e,curshort(e),'ro')
plot(f,curshort(f),'bo')
plot(g,curshort(g),'go')
hold off
title("Total alternations: "+size([b c d e f g],2) )
xlabel('time')
ylabel('region')