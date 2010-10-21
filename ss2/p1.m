clf
clear
clc

td = 5; Tmax = 25; a = 0.5; tp = 10; T = Tmax/1000;
t = 0:T:Tmax;
h = a .* exp(-a .* t);
f = rectpuls(t - tp /2 - td,tp);

yexact = exp(-a .* (t)) .* (exp(a .* min(tp + td,t)) - 1);
y = T .* conv(double(h),double(f));

y = y(1:length(t));

plot(t,f,t,y,t,yexact)
legend({'f','y_{approx}','y_{exact}'})

