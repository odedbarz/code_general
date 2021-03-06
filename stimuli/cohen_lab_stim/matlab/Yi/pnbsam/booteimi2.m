% function [CC,MI]=booteimi(MTFsh,FMAxis,NB)

% DESCRIPTION: bootstrap Rab to compute the mean and standard error corr
% coeff and mod index

% MTFsh     : population shuff-corr
% FMAxis
% NB        : number of bootstraps

% CC        : corr coeff
%   .M      : mean of CC
%   .SE     : standard error of CC
% MI        : mod index
%   .M      : mean of MI
%   .SE     : standard error of SE

% Yi Zheng, March 2007

function [CC,MI]=booteimi2(MTFsh,FMAxis,NB,Flag)

L=10;
for FMindex = 1:length(FMAxis)
   
   % Generate population Rab matrix for one mod freq
   i=1; Rab=[];Rab1=[];
   for n=1:size(MTFsh,1)
    if ~isempty(MTFsh(n,FMindex).Rab)
     Rab(i,:)=real(sqrt(MTFsh(n,FMindex).Rab));  
     bin = round(min(L,12207/FMAxis(FMindex)));
     center =(length(MTFsh(n,FMindex).Rab)+1)/2;
     %Rab1(i,:) = MTFsh(n,FMindex).Rab((center-round(bin/2)):(center+round(bin/2)));
     %Rab1(i,:)= real(sqrt(Rab1(i,:)));  % one cycle Rab
     i = i+1;
    end % end of if 
   end % end of n
   %Rab1m = mean(Rab1,1);
   Rabm = mean(Rab,1);
   %MI(FMindex).m = (max(Rab1m)-min(Rab1m))/max(Rab1m);
   MI(FMindex).m = (max(Rabm)-min(Rabm))/max(Rabm);
 
   % Bootstrap Rab and compute CC & MI
   for l=1:NB
       j = randsample(size(Rab,1),size(Rab,1),'true');
       Rab_m = mean(Rab(j,:));
       Fsd = min(FMAxis(FMindex)*L,12207);
       N = (length(Rab_m)-1)/2;
       Tau = (-N:N)/Fsd;
    if Flag ==1 % PNB
           ondiv = 0.00025./((1./FMAxis(FMindex))/L);  % stimulus(2.5ms) on divisions
    if ondiv<1  % for FMAXis(k)<400 Hz in the case L=10
    
    Rabmodel = zeros(1,length(Rab_m));
    Rabmodel(1,(length(Rab_m)+2)/2) = max(real(sqrt(Rab_m)));
    shift=0;
    while (length(Rab_m)-1)/2 - shift>=0
        Rabmodel(1,(length(Rab_m)+2)/2-shift)=max(real(sqrt(Rab_m)));
        Rabmodel(1,(length(Rab_m)+2)/2+shift)=max(real(sqrt(Rab_m)));
        shift=shift+round(Fsd/FMAxis(FMindex));
    end
    
    else  % for FAMsix(k)>400Hz in the case L=10
    
    Rabmodel = zeros(1,length(Rab_m));
    Rabmodel(1,(length(Rab_m)+1)/2) = max(real(sqrt(Rab_m)));
    Rabmodel(1,(length(Rab_m)+1)/2+1) = min(max(0,ondiv-1),1)*max(real(sqrt(Rab_m)));
    Rabmodel(1,(length(Rab_m)+1)/2+L-1) = min(max(0,ondiv-2),1)*max(real(sqrt(Rab_m)));
    Rabmodel(1,(length(Rab_m)+1)/2+2) = min(max(0,ondiv-3),1)*max(real(sqrt(Rab_m)));
    Rabmodel(1,(length(Rab_m)+1)/2+L-2) = min(max(0,ondiv-4),1)*max(real(sqrt(Rab_m)));
    shift=1:round(Fsd/FMAxis(FMindex));
    while (length(Rab_m)-1)/2 - max(shift)>=0
        Rabmodel(1,(length(Rab_m)+1)/2-length(shift)-1+shift)=Rabmodel(1,(length(Rab_m)+1)/2-1+shift);
        Rabmodel(1,(length(Rab_m)+1)/2+length(shift)-1+shift)=Rabmodel(1,(length(Rab_m)+1)/2-1+shift);
        shift = shift + round(Fsd/FMAxis(FMindex));
    end
    end % end of if ondiv    
    Rabmodel=Rabmodel((length(Rab_m)+1)/2-((length(Rab_m)-1)/2):(length(Rab_m)+1)/2+((length(Rab_m)-1)/2));
   
       else
       beta = lsqcurvefit(@(beta,time) beta(1)*cos(2*pi*FMAxis(FMindex)*Tau)+beta(2),[10 10],Tau,Rab_m);
       Rabmodel = beta(1)*cos(2*pi*FMAxis(FMindex)*Tau)+beta(2);
       end
       r = corrcoef(Rabmodel,Rab_m);
       CC(FMindex).boot(l,1) = r(1,2);
       % MI = Peak Sinusoid Amp / DC
       % MIboot(l,FMindex) = beta(1)/beta(2); 
       % MI = peak-to-peak amplitude / maximum amplitude
       MI(FMindex).boot_m(l,1) =  (max(Rabmodel)-min(Rabmodel))/max(Rabmodel);
       
       Rab1_mboot = mean(Rab(j,:));
       MI(FMindex).boot_r(l,1) = (max(Rab1_mboot)-min(Rab1_mboot))/max(Rab1_mboot); % MI from true Rab data
   end % end of NB 
   
   %Direct Estimates CC and MI
    Rab_m = mean(Rab);
	Fsd = min(FMAxis(FMindex)*L,12207);
	N = (length(Rab_m)-1)/2;
	Tau = (-N:N)/Fsd;
    if Flag==1  %PNB
        Rabmodel = zeros(1,length(Rab_m));
        Rabmodel(1,(length(Rab_m)+2)/2)=max(real(sqrt(Rab_m)));
        shift=0;
        while (length(Rab_m)+2)/2 - shift>0
        Rabmodel(1,(length(Rab_m)+2)/2-shift)=max(real(sqrt(Rab_m)));
        Rabmodel(1,(length(Rab_m)+2)/2+shift)=max(real(sqrt(Rab_m)));
        shift=shift+round(Fsd/FMAxis(FMindex));
        end
    else
	beta = lsqcurvefit(@(beta,time) beta(1)*cos(2*pi*FMAxis(FMindex)*Tau)+beta(2),[10 10],Tau,Rab_m);
	Rabmodel = beta(1)*cos(2*pi*FMAxis(FMindex)*Tau)+beta(2);
    end
    
	r = corrcoef(Rabmodel(1:40),Rab_m);
	CC(FMindex).M = r(1,2);
    temp=[CC(FMindex).boot];
    % CC(FMindex).M = mean(temp(find(~isnan(temp))),1);
    CC(FMindex).SE = std(temp(find(~isnan(temp))),1);
	% MIdirect(FMindex) = beta(1)/beta(2);  
    % MI(FMindex).Mm = (max(Rabmodel)-min(Rabmodel))/max(Rabmodel);
    temp=[MI(FMindex).boot_m];
    MI(FMindex).Mm = mean(temp(find(~isnan(temp))),1);
    MI(FMindex).SEm = std(temp(find(~isnan(temp))),1);
    Rab1_m = mean(Rab);
    %MI(FMindex).Mr =(max(Rab1_m)-min(Rab1_m))/max(Rab1_m); % MI ture from Rab data
    temp=[MI(FMindex).boot_r];
    MI(FMindex).Mr = mean(temp(find(~isnan(temp))),1);
    MI(FMindex).SEr = std(temp(find(~isnan(temp))),1);
end  % end of FMindex

FM2 = log10(FMAxis);
figure
subplot(211)
errorbar(FM2,[CC.M],[CC.SE]);
set(gca,'Xtick',FMAxis);
axis([0 log10(2000) 0 1])
ylabel('CC');

subplot(212)
% errorbar(FM2,[MI.Mm],[MI.SEm]);
hold on 

errorbar(FM2,[MI.Mr],[MI.SEr],'r');
set(gca,'Xtick',FMAxis);
axis([0 log10(2000) 0 1])
ylabel('MI');
     


