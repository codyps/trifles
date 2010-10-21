clf
clear
%clc

Tmax = 100; T= Tmax / 1000; t = 0:T:Tmax;
f = sin(3*t) .* rectpuls(t - 30/2,30) + ...
    sin(2*t) .* rectpuls(t-30 - 40/2,40) + ...
    sin(3*t) .* rectpuls(t-70 - 30 /2,30);
wo = 2;
%a = .1;
a = .3;
wr = sqrt(wo.^2 - a.^2 / 4);

g = a * exp(-a * t / 2) .* (cos(wr * t) - a/(2*wr) * sin(wr*t));
h = dirac(t) - g;

H = @(s) (s.^2 + wo .^2) ./ (s.^2 + a .* s + wo .^2);
w = 0:5/1000:5;
aH = abs(H(I.*w)).^2;

y1 = T * conv(g,f);
y1 = y1(1:length(t));
y = f - y1;

subplot(2,2,1);
plot(t,f);
title('input signal, f(t)');
xlabel('Time (seconds)');
axis([0, 100, -2, 2]);
grid('on');

subplot(2,2,2);
plot(t,y);
title('output signal, y(t)');
xlabel('Time (seconds)');
axis([0, 100, -2, 2]);
grid('on');

subplot(2,2,3);
plot(w,aH);
title('notch filter magnitude responce, |H(\omega)|^2');
axis([0,5,0,1.1]);

subplot(2,2,4);
plot(t,h);
title('notch filter impulse response');
xlabel('Time (seconds)');
axis([0,100,-.4,.3]);

paper_size = [3 3.5];
set (gcf, "paperunits", "inches")
set (gcf, "papertype", "<custom>")
set (gcf, "papersize", paper_size)
set (gcf, "paperposition", [0, 0, paper_size])
print('-dpng', 'P2_A.png');
%print('-dpng', 'P2_B.png');
