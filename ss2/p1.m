clf
clear
%clc

td = 0;
%td = 5;
Tmax = 25; a = 0.5; tp = 10; T = Tmax/1000;
t = 0:T:Tmax;
h = a .* exp(-a .* t);
f = rectpuls(t - tp /2 - td,tp);

yexact = exp(-a .* (t - td)) .* (exp(a .* min(tp,t - td)) - 1);
yexact(yexact < 0) = 0;
y = T .* conv(double(h),double(f));

y = y(1:length(t));

plot(t,f,t,y,t,yexact)
legend({'f','y_{approx}','y_{exact}'})
xlabel('Time (seconds)');
ylabel('Output Value (unitless)');
%title('Time Invariance Property Demonstation, Shifted');
title('Time Invariance Property Demonstation, Unshifted');

paper_size = [3 3.5];
set (gcf, "paperunits", "inches")
set (gcf, "papertype", "<custom>")
set (gcf, "papersize", paper_size)
set (gcf, "paperposition", [0, 0, paper_size])

%print('-dpng', 'P1_A.png');
print('-dpng', 'P1_B.png');
