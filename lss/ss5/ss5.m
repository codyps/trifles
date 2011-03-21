function ss5()

paper_size = [7 5];
set (gcf, 'paperunits', 'inches');
set (gcf, 'papertype', '<custom>');
set (gcf, 'papersize', paper_size);
set (gcf, 'paperposition', [0, 0, paper_size]);


fignum = 1;

%% %%%% P1 (optional)

x = [1, 2, -1, -2, 3, -3, 4, 0, 0];
y = [2, -2, 3, -3, 4, -4, 1, 1, 1];


%%%%%%%%%%%%%%%%%%%%%%
%% %%%% Problem 2

% %% part A
omega = 0.01:0.01:pi;
% find x[k]'s discrete fourier transform analyticaly.



% Part b
x1 = [ 1, 1, 1, 1 ];
X1_analytic = (1 - exp(-1i*4*omega)) ./ (1-exp(-1i*omega));

figure(fignum);
fignum = fignum + 1;
subplot(2,2,1);
plot(omega, abs(X1_analytic));

fignum = P2(x1,fignum);
print ('-dpng', 'ss5_2b.png')

% Part c
x2 = ones(1,12);
X2_analytic = (1 - exp(-1i*length(x2)*omega)) ./ (1-exp(-1i*omega));

figure(fignum);
fignum = fignum + 1;
subplot(2,2,1);
plot(omega, abs(X2_analytic));
title('X2 Analytic');

fignum = P2(x2,fignum);
print ('-dpng', 'ss5_2c.png')

% Part d
x3 = [1,2,3,4,5,4,3,2,1];
fignum = P2(x3, fignum);
print ('-dpng', 'ss5_2d.png')
%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%% Problem 3

% (a) Ts=0.1
% XXX: adjust for Ts=0.01 for (b).
Ts = 0.1;
t0 = -2:Ts:-Ts;
t1=-1:Ts:-Ts;
t2=0:Ts:2;
t3=0:Ts:1;

xs = cell(4,1);
xs{1} = [t1+1 1-0.5*t2];
xs{2} = [ones(1,11) -1*ones(1,2)];
xs{3} = [2*t1+2 2-2*t3];
xs{4} = [ones(1,21) -1*ones(1,20)];

Ns = cell(size(xs));
Xs = cell(size(xs));
ks = cell(size(xs));
ws = cell(size(xs));

figure(fignum);
fignum = fignum + 1;
for i = 1:length(xs);
    Ns{i} = length(xs{i});
    Xs{i} = Ts*fft(xs{i}, Ns{i});
    ks{i} = 0:1:Ns{i}/2-1;
    ws{i} = (2*pi*ks{i}/Ns{i})/Ts;
    
    subplot(2,2,i);
    plot(ws{i},abs(Xs{i}(1:floor(Ns{i}/2))));
    title(sprintf('FFT Xs{%d}(t)', i));
end

print('-dpng', 'ss5_3a1.png');

%%%%%% Ts = 0.01

Ts = 0.01;
t0 = -2:Ts:-Ts;
t1=-1:Ts:-Ts;
t2=0:Ts:2;
t3=0:Ts:1;

xs = cell(4,1);
xs{1} = [t1+1 1-0.5*t2];
xs{2} = [ones(1,11) -1*ones(1,2)];
xs{3} = [2*t1+2 2-2*t3];
xs{4} = [ones(1,21) -1*ones(1,20)];

Ns = cell(size(xs));
Xs = cell(size(xs));
ks = cell(size(xs));
ws = cell(size(xs));

figure(fignum);
fignum = fignum + 1;
for i = 1:length(xs);
    Ns{i} = length(xs{i});
    Xs{i} = Ts*fft(xs{i}, Ns{i});
    ks{i} = 0:1:Ns{i}/2-1;
    ws{i} = (2*pi*ks{i}/Ns{i})/Ts;
    
    subplot(2,2,i);
    plot(ws{i},abs(Xs{i}(1:floor(Ns{i}/2))));
    title(sprintf('FFT Xs{%d}(t)', i));
end

print('-dpng', 'ss5_3b.png');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



w = 0.1:0.1:30;
Xs{1} = 1./(1i.*w).*( exp(1i.*(w./2)).*sinc(w./(2*pi)) ...
    - exp(-1i.*w).*sinc(w./pi) );
%X2 = int(exp(-jwt),t,-1,0) + int((-1)*exp(-jwt),t,0,2) =
Xs{2} = -1./(1i.*w).*(1-exp(1i.*w)) ...
    + 1./(1i.*w).*(exp(-2i.*w)-1);
% % only need derivation for the following 2
Xs{3} = 2.*sinc(w./(2*pi)).^2;
Xs{4} = 4i.*w.*sinc(w./pi).^2;

figure(fignum);
fignum = fignum + 1;
for i = 1:length(xs);
    subplot(2,2,i);
    plot(w,Xs{i});
    title(sprintf('Analytical Xs{%d}(w)', i));
end
print('-dpng', 'ss5_3a2.png')

figure(fignum);
fignum = fignum + 1;
for i = 1:length(xs);
    subplot(2,2,i);
    k = 0:1:Ns{i} - 1;
    stem(k,xs{i});
    
end
print('-dpng', 'ss5_3a3.png');

% plot ffts and analiticals to compare. You don't need to plot
% iffts

% One other thing you can do if you want: you can do ifft for all 4
% and see if they match.
end

function fignum = P2(x, fignum)
    % %% part B
    Ns = [4, 8, 12, 16, 24, 32];

    Xs = cell(size(Ns));
    Oms = cell(size(Ns));
    for i = 1:length(Ns);
        Xs{i} = fft(x,Ns(i));
        Oms{i}= ( 0:1:Ns(i)/2 )*pi/(Ns(i)/2);
    end

    subplot(2,2,2)
    hold on;
    ts = {};
    for i = 1:length(Xs);
        aX = abs(Xs{i});
        plot(Oms{i}, aX(1:Ns(i)/2+1), sprintf('%d',i));
	ts{i} = sprintf('fft N=%d', i);
    end
    legend(ts);

    xi = cell(size(Ns));
    for i = 1:length(Xs);
        xi{i} = ifft(Xs{i}, Ns(i));
    end
    hold off;
    subplot(2,2,3);
    hold on;
    ts = {};
    for i = 1:length(xi);
        stem(abs(xi{i}));
        ts{i} = sprintf('ifft N=%d',Ns(i));
    end
    legend(ts);
end
% EC to person who tells me what the spectrum of the signal
% in part D is.
% Just by looking at these numbers.
% 

