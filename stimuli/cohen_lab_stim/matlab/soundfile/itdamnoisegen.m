%
%function [Xl,Xr,ITD]=itdamnoisegen(f1,f2,ITDMax,Fm,Fs,M,seed)
%
%       FILE NAME       : ITD AM NOISE GEN
%       DESCRIPTION     : Generates a noise signal with sinusoidally
%                         varying ITD profile
%
%       f1              : Lower noise cutoff frequency (Hz)
%       f2              : Upper noise cutoff frequency (Hz)
%       ITDMax          : Maximum ITD (micro sec)
%       Fm              : ITD Beat Frequency (Hz)
%       Fs              : Sampling Frequency
%       M               : Number of Samples
%       seed            : Seed for random number generator
%                         (Default = no seed)
%
% (C) Monty A. Escabi, Jan 2009
%
function [Xl,Xr,ITD]=itdamnoisegen(f1,f2,ITDMax,Fm,Fs,M,seed)

%Input Arguments
if nargin<7
    seed=sum(100*clock);
end

%Time Axis and warped time axis. ITDs are generated by time warping the 
%signal for the left and right audio channels
t=(1:M)/Fs;
tpl=t+ITDMax/1E6/2*sin(2*pi*Fm*t);
tpr=t-ITDMax/1E6/2*sin(2*pi*Fm*t);
ITD=tpr-tpl;

%Gaussian Bandlimited Noise
%X=noiseblfft(f1,f2,Fs,M);
X=noiseblh(f1,f2,Fs,M,seed,'y');

%Time Warping the left and right sounds
Xl=interp1(tpl,X,t,'cubic');
Xr=interp1(tpr,X,t,'cubic');

%BandPass Filtering to remove spectral splatter due to time warping and
%interpolation artifact (i.e., crappy interpolator)
ATT=60;
H=bandpass(f1,f2,.1*(f2-f1)/2,Fs,ATT,'n');
N=(length(H)-1)/2;
NFFT=2^nextpow2(N+M);
Xl=convfft(Xl,H,N,NFFT);
Xr=convfft(Xr,H,N,NFFT);
Xl=Xl(1:M);
Xr=Xr(1:M);