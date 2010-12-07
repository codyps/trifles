%% 1
function p1()
	T = 1;
	E = 1;

	prob_1(T, E);
	prob_2(T, E);
	prob_3();
	prob_4();
end

function xN = do_1(t, N, E, T)
	a0 = E; % Determine Yourself?
	w0 = 2*pi / T;

	% Approximation with 5 harmonics
	xN = a0 / 2;

	for n = 1:N
	    an = (2 * E / (n*pi)) * (sin(pi*n/2));
	    xN = xN + an .* cos(n*w0*t);
	end
end

function prob_1(T, E)
	t = -1.5:0.01:1.5;
	Ns = [5,10,20,30,40,50];
	figure(1);
	for i = 1:length(Ns)
		N = Ns(i);
		xN = do_1(t, N, E, T);

		subplot(2,3,i);
		plot(t, xN, 'g')
		xlabel('Time');
		ylabel(sprintf('Approximation x%d',N));
		axis([-1.5, 1.5, -0.2, 1.2]);
	end
end


%subplot(2,2,2);
%bode(tf(t, xN));

%% 2
% Xn = 0.5 *(an-bn) = 0.5*an since bn = 0;
function prob_2(T, E)
	N = 11;
	a0 = E;
	X0 = a0 / 2;
	X = zeros(N,1);
	for n = 1 : N
	    X(n) = 0.5 * (E/n*pi) * (sin(n*pi/2)-sin(n*3*pi/2));
	end
	n = 0:1:N;

	figure(2);
	plot(n,abs([X0; X]), '*');
	grid
	xlabel('Harmonic Number');
	ylabel('Amplitude in spectrum');
end

% if someone decides to to phase, they will get extra points
% rather than doing ..., account for numbers in X axis???

%% 3
% connects dots with what we did last time.

% diff(y(t),2) + 2 * diff(y(t), 1) +  3 * y(t) = x(t)
function prob_3()
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
end

%% 4
function prob_4()
	E = 5;
	w0new = 1;
	n = [0, 1, 3, 5];

	t = 0:0.01:4*pi; a0 = E; X0 = a0 / 2;
	Xn = zeros(5,1);
	for n = 1:5
		an(n) = (E/(n*pi)) * (sin(n*pi/2)-sin(n*3*pi/2));
		Xn(n) = 0.5 * an(n);
	end

	figure(4);
	hold on;
	% First Approximation
	Ns = [0, 1, 3, 5];
	Hm0 = 1/3;
	y0 = X0 *Hm0;
	N = 5; yN = y0;
	for n = 1:N
		Hm = 1 / sqrt((3-(n*w0new)^2)^2+4*(n*w0new)^2);
		Hp = -atan(2*n*w0new/(3-(n*w0new)^2));
		Xnm = abs(Xn(n));
		Xnp = angle(Xn(n));
		Ynm = Xnm * Hm;
		Ynp = Xnp + Hp;
		yN = yN + 2 * Ynm * cos(n*w0new*t + Ynp);
		if (sum(n == Ns) != 0)
			plot(t, yN, '--');
	end
	y1 = Ynm;
	xlabel('Time[s]');
	ylabel('Approximations y1, y3, y5');
	grid
end







