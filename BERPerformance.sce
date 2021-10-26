//Shubham Shirsekar ET2-40
clc;
clear;
xdel(winsid());
sym=10000;//no. of symbols
data1=grand(1,sym,"uin",0,1);//randomly generated input
s = 2*data1-1; // BPSK modulation 0 -> -1; 1 -> 1
nRx = [1 2 3];//no .of receiving antennas
snr_dB =   [1:10]; // signal to noise ratio
for j = 1:length(nRx)
    for i = 1:length(snr_dB)
        n = 1/sqrt(2)*[rand(nRx(j),sym,'normal') + %i*rand(nRx(j),sym,'normal')]; //white gaussian noise
       
        y = ones(nRx(j),1)*s + 10^(-snr_dB(i)/20)*n;//received signal over awgn channel
         [yHat1 ind] = mtlb_max(y,[],1);//find strongest received signal from all antennas
        
        ipHat1 = real(yHat1)>0;
        ipHat = bool2s(ipHat1);//boolean to zero one matrix conversion
        // effective SNR               
         nErr(j,i) = size(find([data1- ipHat]),2);//no. of error calculation
            end
end
simBer = nErr/sym; //BER calculation
// plot of ber comparison plot for 1,2 and 3 receiving antennas
snr_dB=1:10
plot2d(snr_dB,simBer(1,:),5,logflag="nl");
plot2d(snr_dB,simBer(2,:),2,logflag="nl");
plot2d(snr_dB,simBer(3,:),12,logflag="nl");
xgrid
legend( ['1X1';'1X2';'1x3']);
xlabel('Number of receive antenna');
ylabel('effective SNR, dB');
title('SNR improvement with Selection Combining');
