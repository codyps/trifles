%% 1

t = -1.5:0.01:1.5;

T = 1;
w0 = 2*pi / T;
E = 1;

a0 = E; % Determine Yourself?

% Approximation with 5 harmonics
N = 5; %% N = 10, 20, ...
xN = a0 / 2;

for n = 1:N
    an = (E / (n*pi)) * (sin(n*pi/2) - sin(n*3*pi/2));
    xN = xN + an .* cos(n*w0*t);
end

figure(1);
subplot(2,2,1);
plot(t, xN, 'g')
xlabel('Time');
ylabel('Approximation x5');
axis([-1.5, 1.5, -0.2, 1.2]);

%subplot(2,2,2);
%bode(tf(t, xN));

%% 2
% Xn = 0.5 *(an-bn) = 0.5*an since bn = 0;
N = 11;
a0 = E;
X0 = a0 / 2;
X = zeros(N,1);
for n = 1 : N
    X(n) = 0.5 * (E/n*pi) * (sin(n*pi/2)-sin(n*3*pi/2));
end
n = 0:1:N;

figure(2);
plot(n,abs([X0; X]), 'o');
grid
xlabel('Harmonic Number');
ylabel('Amplitude in spectrum');


% if someone decides to to phase, they will get extra points
% rather than doing ..., account for numbers in X axis???

%% 3
% connects dots with what we did last time.

% diff(y(t),2) + 2 * diff(y(t), 1) +  3 * y(t) = x(t)
num =  1;
den = [1 2 3];
w = 0:0.01:10;
H = freqs(num, den, w);

magH = abs(H); phaseH = angle(H);


figure(3);
subplot(2,1,1);
semilogx(w, magH);
grid
xlabel('log(w)');
ylabel('Magnitude spectrum');
subplot(2,1,2);
semilogx(w, phaseH);
grid
xlabel('log(w)');
ylabel('Phase spectrum [rad]');


%% 4

E = 5;
w0new = 1;
n = [0, 1, 3, 5];

t = 0:0.01:4*pi; a0 = E; X0 = a0 / 2;
Xn = zeros(5,1);
for n = 1:5
        an(n) = (E/(n*pi)) * (sin(n*pi/2)-sin(n*3*pi/2));
        Xn(n) = 0.5 * an(n);
end

% First Approximation
Hm0 = 1/3;
y0 = X0 *Hm0;
N = 1; yN = y0;
for n = 1:N
    Hm = 1 / sqrt((3-(n*w0new)^2)^2+4*(n*w0new)^2);
    Hp = -atan(2*n*w0new/(3-(n*w0new)^2));
    Xnm = abs(Xn(n));
    Xnp = angle(Xn(n));
    Ynm = Xnm * Hm;
    Ynp = Xnp + Hp;
    yN = yN + 2 * Ynm * cos(n*w0new*t + Ynp);
end
y1 = Ynm;
figure(4);
plot(t, yN, '--');
grid








