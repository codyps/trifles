% A script showing the basics of making one's own spectrogram code

% Suppose we have our data in the signal xt
load('QuizToneSig_0_1.mat');
xt=xt(:);   %forces data to be in column format
xtlen=length(xt);

FFTlen=512;

numloops=floor(xtlen/FFTlen);

out=zeros(FFTlen,numloops);

for k=1:numloops;
    start=(k-1)*FFTlen+1;
    stop=start+FFTlen-1;
    dat=xt(start:stop);
    df=fft(dat);
    df=fftshift(df);
    out(:,k)=20*log10(abs(df));
end;

figure(1);
t=1:numloops;
f=linspace(-fs/2,fs/2,FFTlen+1);
f=f(1:FFTlen);
imagesc(t,f,out);

f1 = [697, 770, 852, 941, 1209, 1336, 1477, 1633]; 
hold on
for f=f1;
	plot(ones(numloops,1)*f);
end
axis([0 55 500 1800]);
