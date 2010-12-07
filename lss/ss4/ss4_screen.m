paper_size = [7 5];
set (gcf, 'paperunits', 'inches');
set (gcf, 'papertype', '<custom>');
set (gcf, 'papersize', paper_size);
set (gcf, 'paperposition', [0, 0, paper_size]);

%% 1
w = 0.01:0.01:10;;;
Ts = 0.01;
X1exact = (exp(1i*0.5*w).*sinc(w/(2*pi)) ...
    -exp(-1i*w).*sinc(w/pi))./(1i*w);

t0=-2:Ts:-Ts-1;
t1=-1:Ts:-Ts;
t2=0:Ts:2;
t3=2+Ts:Ts:3;
t = [t0,t1,t2,t3];

x1 = [zeros(1,100), t1+1, 1-0.5*t2, zeros(1,100)];

N1 = length(x1);
X1N1 = Ts*fft(x1,N1);

k1 = 0:1:N1/2-1; %% fftindex
w1 = (2*pi*k1/N1)/Ts; %% fftfrequencies.

N2 = 5*length(x1); X1N2 = Ts*fft(x1,N2);
k2 = 0:1:N2/2-1; w2 = (2*pi*k2/N2)/Ts;

% input signal, exact fft, and matlab fft.
figure(1);
subplot(2,2,1);
plot(w,X1exact);
ylabel('X1 exact magnitude');
xlabel('Frequency [rad/s]');

subplot(2,2,2);
plot(t, x1); grid; 
ylabel('x1 signal');
xlabel('Time');

subplot(2,2,3);
plot(w1, abs(X1N1(1:N1/2))); axis([0, 10, 0, 2]);
xlabel('Frequency [rad/s]');
ylabel('X1 magnitude, N=length(x1)');

subplot(2,2,4);
plot(w2, abs(X1N2(1:N2/2))); axis([0, 10, 0, 2]);
xlabel('Frequency [rad/s]');
ylabel('X1 magnitude, N=5*length(x1)');

print ('-dpng', sprintf('ss4_%d.png',1 ))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2
%

%???
wc = 100; fc = wc/(2*pi);
fs = 1/Ts;

hx1 = imag(hilbert(x1));
x1mod=x1.*cos(wc*t);
N=length(x1mod) - 1; 
X1= Ts*fft(x1,N); 
X1mod=Ts*fft( x1mod, N);

k = 0:1:N/2-1; 
w = (2*pi*k/N)/Ts;

figure(2);
subplot(2,2,1);
plot(t,hx1);
grid; axis([-2,3,-1,1]);
xlabel('Time'); ylabel('Hilbert transform');

subplot(2,2,2);
plot(w, abs(X1(1:N/2)));
grid; axis([0 120 0 1.5]);
xlabel('Frequency [rad/s]'); ylabel('Signal spectrum');

subplot(2,2,3);
plot(t,x1mod);
grid; % axis([1 ???    
xlabel('Time'); ylabel('Modulated signal');

subplot (2,2,4);
plot(w, abs(X1mod(1:N/2))); grid; 
axis([0 120 0 1]);
xlabel('Frequency [rad/s]'); ylabel('Modulated Signal Spectrum');

print ('-dpng', sprintf('ss4_%d.png',2 ))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3
%

x1modSSB=modulate(x1,fc,fs,'amssb');
X1modSSB=Ts*fft(x1modSSB,N);

figure(3);
subplot(211);
plot(w, abs(X1modSSB(1:N/2))); %???
xlabel('Frequency [rad/s]');
ylabel('XmodSSB signal spectrum');

% upper SSB following
c1 = cos(2*pi*fc*t); % carier for origninal x(t)
c2 = sin(2*pi*fc*t); % carier for Hilbert transform x_hat(t)

x1c1mod = x1.*c1;  %modulation of original sig by sine
x1hil = imag(hilbert(1)); 
x1hilc2mod=x1hil.*c2; %modultaion of hilbert

% Office hours are only on non-lab weeks,
% wed 12:00-3:00, thurs 1:40-4:40

x1mod = x1c1mod-x1hilc2mod;
X1modUSSB=Ts*fft(x1mod,N);

subplot(212);
plot(w,abs(X1modUSSB(1:N/2)));
grid; axis([0 120 0 1.5]);
xlabel('Frequenct [rad/s]');
ylabel('XmodUSSB signal spectrum');
print ('-dpng', sprintf('ss4_%d.png',3 ))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4
% carrier 

x1demod = 4*demod(x1mod,fc,fs,'amssb');

figure(4);
subplot(2,2,1);
plot(t,x1); axis([-2 3 0 1]); ylabel('x1 signal'); xlabel('Time');
subplot(2,2,2);
plot(t,x1mod); ylabel('Modulated signal'); xlabel('Time');
subplot(2,2,3);
plot(t,x1demod); axis([-2 3 0 1]); ylabel('Demodulated signal'); xlabel('Time');

subplot(2,2,4); 
plot(w, abs(X1modUSSB(1:N/2)));
axis([0 120 0 1]); ylabel('Modulated Signal Spectrum'); xlabel('Frequency [rad/s]');
print ('-dpng', sprintf('ss4_%d.png',4 ))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5
%

fs = 1/Ts; fc = wc/(2*pi);
x1modTC=modulate(x1,fc,fs,'amdsb-tc',.1);
x1dem=demod(2*x1modTC', fc, fs, 'amdsb-tc',-.1);
X1modTC=Ts*fft(x1modTC,N);

figure(5);
subplot(2,2,1);
plot(t,x1); axis([-2 3 0 1]);
ylabel('x1 signal'); xlabel('Time');

subplot(2,2,2);
plot(t,x1modTC);
ylabel('AMDSB TC modulated signal');
xlabel('Time');

subplot(2,2,3);
plot(t,x1dem); axis([-2 3 0 1]);
ylabel('Demodulated signal');
xlabel('Time');

subplot(2,2,4);
plot(w, abs(X1modTC(1:N/2))); grid; 
axis([0 120 0 1]); ylabel('Modulated Signal Spectrum'); xlabel('Frequency [rad/s]');

print ('-dpng', sprintf('ss4_%d.png',5 ))
