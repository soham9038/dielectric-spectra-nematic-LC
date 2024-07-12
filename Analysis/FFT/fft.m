% x-axis in Hz
% y-axis needs to be normalized and rescaled according to the theory

clear all
clc

fileID = fopen('data.txt','r');
formatSpec = '%f %f';
sizeC = [2 Inf];
C = fscanf(fileID,formatSpec,sizeC)
fclose(fileID);
C=C'

L=300000; % Length of the file

t=C(1:L,1);

X=C(1:L,2);

T=2e-12; % Time difference between each steps

Fs=1/T;


X=[X 0.*X];
Y = fft(X);

P2 = real(Y/L); % change to -imag(Y/L) to calculate the imaginary/loss part
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;
A = [f; P1];
plot(f,P1) 
title("Single-Sided Amplitude Spectrum of X(t)")
xlabel("f (Hz)")
ylabel("|P1(f)|")

fileID = fopen('realpart.txt','w'); % change the name accordingly
fprintf(fileID,'%6s %12s\n','f','P1');
fprintf(fileID,'%6.2f %12.8f\n',A);
fclose(fileID);

