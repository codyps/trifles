clf
clear
clc


Tmax = 100; T= Tmax / 1000; t = 0:T:Tmax;
f = sin(3*t) .* rectpuls(t - 30/2,30) + ...
    sin(2*t) .* rectpuls(t-30 - 40/2,40) + ...
    sin(3*t) .* rectpuls(t-70 - 30 /2,30);
w = 2;
a = .3;
wr = sqrt(w^2 - a^2 /4);

g = a * exp(-a * t / 2) .* (cos(wr * t) - a/(2*wr) * sin(wr*t));
h = dirac(t) - g;

y1 = T * conv(g,f);
y1 = y1(1:length(t));
y = f - y1;

subplot(2,2,1);
plot(t,f);
title('input signal, f(t)');
axis([0, 100, -2, 2]);
grid('on');

subplot(2,2,2);
plot(t,y);
title('output signal, y(t)');
axis([0, 100, -2, 2]);
grid('on');

subplot(2,2,3);
title('notch filter magnitude responce, |H(\omega)|^2');
plot(t,h);
axis([0,5,0,1.1]);

subplot(2,2,4);
title('notch filter impulse response');
plot(t,tf(h))
axis([0,100,-.4,.3]);
