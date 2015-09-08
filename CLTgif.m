%For empirically showing central limit theorem
%To optimize and shrink resultant gifs:
%gifsicle --delay=5 --loop -O2 CLTd.gif > CLTd2.gif

close all;
len=10000;
samples=500;
SS=5;

type=3;
switch type
    case 1
        X=unifrnd(0,1,1,len);
        ax=[0 1 0 1];
        tick=0:0.1:1;
        xl=[0 1];
        bins=0.05:0.1:1;
        filename = 'CLTc.gif';
    case 2
        X=unidrnd(6,1,len);
        ax=[0 7 0 1];
        xl=[0 7];
        tick=1:6;
        bins=1:6;
        filename = 'CLTd.gif';
    case 3 %Poisson
        X=poissrnd(2,1,len)./5+(unifrnd(-1,1,1,len)./10)+0.2;
        ax=[0 2 0 1];
        tick=0:0.2:2;
        xl=[0 2];
        bins=0.1:0.2:2;
        filename = 'CLTp.gif';
end

Y=zeros(1,len)+0.05;

f=figure;
subplot(2,2,1:2)
plot(X,Y,'+');
subplot(2,2,3)
[N,Xcent]=hist(X,bins);
bar(Xcent,N)
xlim(xl);
xlabel('Data distribution')
ylabel('Frequency')

Xa=zeros(1,samples).*NaN;
Ys=zeros(1,SS)+0.05;
Ya=zeros(1,samples)+0.5;
for i=1:samples
    Xs=randsample(X,SS);
    Xa(i)=mean(Xs);
    subplot(2,2,1:2)
    plot(X,Y,'+');
    hold on;
    plot(Xs,Ys,'mo','MarkerFaceColor','m','MarkerSize',10);
    plot(Xa,Ya,'ro','MarkerSize',6);
    line([Xs' repmat(Xa(i),size(Xs'))]',[Ys' repmat(Ya(i),size(Ys'))]','Color',[1 0 0])
    axis(ax)
    set(gca,'Xtick',tick);
    xlabel('Data (blue) - Sample (pink) - Averages (red)')
    title(sprintf('%05d data points - %02d samples',len, i));
    hold off;
    
    subplot(2,2,4)
    N=hist(Xa,bins);
    h=bar(Xcent,N);
    xlim(xl)
    xlabel('Sample average distribution')
    ylabel('Frequency')
    set(h,'FaceColor',[1 0 0]);
    drawnow;
    
    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if i == 1;
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',0);
    end
    if i < 100
        for i2=1:(10-floor(i/10))
            imwrite(imind,cm,filename,'gif','WriteMode','append');
        end
    elseif mod(i,5)==0
        imwrite(imind,cm,filename,'gif','WriteMode','append');
    end
end

for i2=1:20
    imwrite(imind,cm,filename,'gif','WriteMode','append');
end

