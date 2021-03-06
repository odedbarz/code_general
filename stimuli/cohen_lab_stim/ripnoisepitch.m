%
%function []=ripnoisepitch(filename,f1,f2,fRD,fFM,fFm,MaxRD,MaxFM,MinFm,MaxFm,App,M,Fs,NS,DF,AmpDist)
%
%	
%	FILE NAME 	: RIP NOISE PITCH
%	DESCRIPTION 	: Generates Dynamic Moving Ripple with Dynamic Pitch
%			  Saved as a 'float' file
%			  Saves Spectral Profile as a sequence of MAT files
%			  This File is identical to RIPNOISE except it allows
%			  you to add an arbitrary number of Moving Ripple 
%			  Profiles to generate a Ripple Noise Profile
%
%			  Also the carriers used to generate the moving ripple
%			  are always linearly spaced.  The spacing of the 
%			  individual carriers are time varying so that a time 
%			  varying pitch signal is superimposed on the ripple
%
%	filename	: Ouput data file name
%       f1              : Lower carrier frequency
%       f2              : Upper carrier Frequency
%	fRD		: Ripple Density Bandlimit Frequency
%	fFM		: Temporal Modulation Bandlimit Frequency
%	fFm		: Fine structure (Pitch) bandlimit frequency
%	MaxRD		: Maximum Ripple Density ( Cycles / Octaves )
%	MaxFM		: Maximum Ripple Modulation Frequency ( Hz )
%	MinFm		: Maximum Fine Structure Pitch Modulation Frequency (Hz)
%	MaxFm		: Minimum Fine Structure Pitch Modulation Frequency (Hz)
%       App             : Peak to Peak Riple Amplitude ( dB )
%       M               : Number of Samples
%       Fs              : Sampling Rate
%	NS		: Number of Sinusoids Cariers used for spectral
%			  profile wich is saved
%	DF		: Temporal Dowsampling Factor For Spectral Profile
%			  Must Be an Integer
%	AmpDist		: Modulation Amplitude Distribution Type
%			  'dB'   = Uniformly Distributed on dB Scale
%			  'lin'  = Uniformly Distributed on linear Scale
%			  'both' = Designs Signals with both
%				   Uses the last element in the App Array to 
%				   Designate the modulation depth for 'lin'
%
function []=ripnoisepitch(filename,f1,f2,fRD,fFM,fFm,MaxRD,MaxFM,MinFm,MaxFm,App,M,Fs,NS,DF,AmpDist)

%Parameter Conversions
N=32;				%Noise Reconstruction Size  ->> Before changing check ripgensin!!!
LL=1000;			%Noise Upsampling Factor    ->> Before changing check ripgensin!!!
Fsn=Fs/LL;			%Noise Sampling Frequency
Mn=M/LL;			%Noise Signal Length
Mnfft=2^(ceil(log2(Mn)));	%Used for Signal Generation
fphase=5*fRD;			%Temporal Phase Signal Bandlimit Frequency
fphase=2;

%Log Frequency Axis
XMax=log2(f2/f1);
X=(0:NS-1)/(NS-1)*XMax;
faxis=f1*2.^X;

%Generating Ripple Density Signal (Uniformly Distributed Between [0 , MaxRD] )
RD=MaxRD*noiseunif(fRD,Fsn,Mnfft,1);

%Generating the Teporal Modulation Signal 
%Signal Varies Between [-MaxFM , MaxFM]
FM=noiseunif(fFM,Fsn,Mnfft,1);
FM=2*MaxFM*(FM-.5);

%Genreating Ripple Phase Components
%Note that: RP = 2*pi/Fsn*intfft(FM);
RP=2*pi/Fsn*intfft(FM);

%Generating Fine Structure Difference Frequency Signal - Pitch
Fm=(MaxFm-MinFm)*noiseunif(fFm,Fsn,Mnfft,1)+MinFm;

%Generating Fine Structure Phase Signal
PFm=2*pi/Fsn*intfft(Fm);

%Initial Carrier Sinusoid Phases - more phase components than necessary
phase=2*pi*rand(1,2000);

%For Displaying Statistics
%figure(1),hist(RD,100),title('Rippe Density Distribution')
%figure(2),hist(FM,100),title('Modulation Frequency Distribution')
%figure(3),plot((1:length(FM))/Fsn,FM),title('Modulation Frequency')
%figure(4),plot((1:length(RD))/Fsn,RD),title('Rippe Density')
%save data RD FM RP Fsn

%Generating Ripple Noise
K=0;
flag=0;		%Marks Last segment
for k=2:N:Mn-N-1

	%Extracting RD and RP Noise Segment 
	RDk    = RD(k-1:k+N-1);
	RPk    = RP(k-1:k+N-1);
	PFmk   = PFm(k-1:k+N-1);
	Fmk    = Fm(k-1:k+N-1);

	%Interpolating RD and RP
	MM=length(RDk)-1;
	RDint   = interp10(RDk,3);
	RPint   = interp10(RPk,3);
	PFmint  = interp10(PFmk,3);
	Fmint   = interp10(Fmk,3);
	RDint   = RDint(1:N*LL);
	RPint   = RPint(1:N*LL);
	PFmint  = PFmint(1:N*LL);
	Fmint   = Fmint(1:N*LL);

	%Generating Ripple Noise
	[Y,phase,SpecProf,faxis,taxis]=noisegensinpitch(f1,f2,RDint,RPint,PFmint,Fmint,App,Fs,phase,fphase,K,MaxRD,MaxFM,DF,AmpDist,NS);
	clear RDint RPint

	%Saving Sound Files
	if strcmp(AmpDist,'lin')

		%Saving Lin AmpDist
		for i=1:length(App)
			tofloat([filename int2str(App(i)) 'Lin.bin'],Y(i,:));
		end

	elseif strcmp(AmpDist,'dB')

		%Saving dB AmpDist
		for i=1:length(App)
			tofloat([filename int2str(App(i)) 'dB.bin'],Y(i,:));
		end

	else
	
		%Saving dB AmpDist
		for i=1:length(App)-1
			tofloat([filename int2str(App(i)) 'dB.bin'],Y(i,:));
		end

		%Saving Lin AmpDist
		tofloat([filename int2str(App(i+1)) 'Lin.bin'],Y(i+1,:));

	end
	clear Y

	%Writing Spectral Profile File as 'float' file
	NT=length(taxis);
	NF=length(faxis);
	tofloat([filename '.spr'],reshape(SpecProf,1,NT*NF));
	clear SpecProf 

	%Updating Display
	K=K+1;
	clc
	disp(['Segment ' num2str(K) ' Done'])

	%Saving Parameters Just in Case it Does Not Reach End
	if K==1
		%Saving Parameters
		f=['save ' filename '_param'];
	end

end

%Saving Parameters
clear RPint RDint RDk RPk k K Y flag f count FM1 filenumber MM ans l;
v=version;
if strcmp(v(1),'5')
	f=['save ' filename '_param -v4'];
	eval(f)
else
	f=['save ' filename '_param'];
	eval(f)
end

%Closing All Opened Files
fclose('all');
