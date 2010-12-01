function ss4_1()
    p1();
end

%%1
function p1()
    r1 = @(t) t + 1;
    r2 = @(t) -1/2*t + 1 ;
    F = piecewise([-1,0], r1, [0, 2], r2);
    Ts = 0.01;
    t = -2:Ts:3;
    
    X = Ts * fft(F(t));
    
    plot(t, F(t), t, abs(X));
    
    
    
end

%{
diff(x1(t),t) = p1(t+0.5) - 0.5 p2(t - 1) 
    <-Ft-> e^(jw/2) F{p1(t)} - 0.5 e ^ (-jw) F{p2(t)} 
    =   e^(jw/2) sinc(w/(2pi)) - e^(-jw) sinc(w/pi) = X(jw)

F{x1(t)} = 1/(jw) X(jw) + pi X(0) delta(w)
    = 1/(jw) ( e^(j*w/2) sinc(w /(2pi)) - e^(-jw)sinc(w/pi)) 
                + pi * 0 * delta(w) 
    = 1/ (jw) ( e^(jw/2) sinc(2/(2pi)) - e^(-jw) sinc(w/pi))

fft -> "butterfly". 

%}