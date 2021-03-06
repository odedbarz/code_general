%
%function  [Cs]=ncsmtcohereshuffle(Data,chan1,chan2,NW,N,flag)
%
%DESCRIPTION: Shuffled Multi Taper Coherence for multi channel data from NCS file
%
%   Data        : Data structure containg all NCS channels from single 
%                 recording session (obtained using READALLNCS)
%   chan1       : Array of reference channels to correlate
%   chan2       : Array of secondary channesl to correlate
%   NW          : Number of tapers to use (Default==8)
%   N           : Number of shuffling itterations (Default==250)
%   flag        : Significance criterion
%                 1: Fixed Threshold (Default)
%                 2: Frequency Dependent Threshold
%
%RETURNED VARIABLES
%
%   Cs          : Shuffled Coherence Data Structure (For significance Analysis)
%   C01         : 0.01 confidence interval
%	C05         : 0.05 confidence interval
%   ADChannels	: Channels used for coherence estimates
%	Faxis		: Frequency Axis		
%
%Monty A. Escabi, December 2006
%
function  [Cs]=ncsmtcohereshuffle(Data,chan1,chan2,NW,N,flag)

%Input Arguments
if nargin<4
    NW=8;
end
if nargin<5
    N=250;
end
if nargin<6
	flag=1;
end

%Sampling Rate
Fs=Data(1).Fs;

%Quantized Amplitude Scaling Factor
dA=Data(1).ADBitVolts;

%Flag - Used to minimize the number of coherence calculations
Max=max([chan1 chan2]);
FLAG=zeros(Max,Max);

%Computing Coherence
for k=1:length(chan1)
	for l=1:length(chan2)

        if FLAG(chan2(l),chan1(k))
            %Copying Coherence Data
            index2=find(chan1(k)==chan2);
            index1=find(chan2(l)==chan1);
            Cs(k,l)=Cs(index1,index2);
            
            %Setting Flag
            FLAG(chan1(k),chan2(l))=1;
        else
            %Shuffling
            for n=1:N
            	%Shuffled Coherence Estimate
                X1=randphasespec(Data(chan1(k)).X);
                X2=randphasespec(Data(chan2(l)).X);
                
                %Coherence Estimate
            	[Cs(k,l).Faxis,CS(n).Cxy]=...
            		cmtm(dA*X1,dA*X2,1/Fs,NW);
                Cs(k,l).ADChannels=...
                    [Data(chan1(k)).ADChannel Data(chan2(l)).ADChannel];
                
                %Changing Dimensions
                CS(n).Cxy=CS(n).Cxy';, Cs(k,l).Faxis=Cs(k,l).Faxis';
            end
        
            %Estimating Significance Curve
            if flag==2

            	%Computing 0.05 and 0.01 confidence interval
            	
                    %Shuffled Coherence
                    Cxy=[CS(:).Cxy];
	
        			for m=1:size(Cxy,1)                      
                        %0.01 confidence interval
                        CXYsort=sort(Cxy(m,:));
                        NN=round(size(Cxy,2)*0.99);
                        Cs(k,l).C01(m,1)=CXYsort(NN);
                
                        %0.05 confidence interval
                        CXYsort=sort(Cxy(m,:));
                        NN=round(size(Cxy,2)*0.95);
                        Cs(k,l).C05(m,1)=CXYsort(NN);
                    end
            else

                %Computing 0.05 and 0.01 confidence interval (Fixed Threshold)
                
                	%Shuffled Coherence
                    Cxy=[CS.Cxy];
                    Cxy=reshape(Cxy,1,size(Cxy,1)*size(Cxy,2));
	
                    %0.01 confidence interval
                    CXYsort=sort(Cxy);
                    NN=round(length(Cxy)*0.99);
                    Cs(k,l).C01=CXYsort(NN)*ones(size(CS(1).Cxy));
                
                    %0.05 confidence interval
                    CXYsort=sort(Cxy);
                    NN=round(length(Cxy)*0.95);
                    Cs(k,l).C05=CXYsort(NN)*ones(size(CS(1).Cxy));
            end

            %Setting Flag
            FLAG(chan1(k),chan2(l))=1;
            
        end
        
            %Displaying Progress
            clc
            disp(['Correrlating Channels: ' int2str(k) ' vs. ' int2str(l)])
            disp(['Progress:              ' int2str(((k-1)*length(chan2)+l)/length(chan1)/length(chan2)*100) ' % Finished '])
            
    end
end