clear all; close all; clc;
%%
% Constants
Re = 7.9; % ohm
Le0 = 5.65*10^(-3); % H
Bl0 = 14.54; % T.m
k0 = 6259.3; % N/m
Rm = 2.628; % N.s/m
mt = 52.08*10^(-3); % kg
b1 = 2.6826; % T
b2 = -4.0269*10^3; % T/m
k1 = -1.4562*10^5; % N/m2
k2 = 2.6106*10^7; % N/m3
l1 = -5.2937*10^(-1); % H/m
l2 = -1.2012*10^2; % H/m2

% Simulation
TIME_SIM = 5;
STEP_SIZE = 0.0001;
t=0:STEP_SIZE:TIME_SIM;

% P3
Au = 5; % V
fc = 20; % Hz
ue = Au*sin(2*pi*fc*t);

[ts,xs,ys] = sim('nonLinearModel2',TIME_SIM,[],[t' ue']);

%%
figure
grid on, axP = axes; set(axP, 'FontSize', 14)
subplot(411), plot(t,ue)
title('input $u_e$ and states responses in time domain', 'FontSize', 14, 'Interpreter','Latex')
xlabel('Time [s]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('$u_e$ [V]', 'FontSize', 14, 'Interpreter','Latex')
subplot(412), plot(t,xs(:,1))
xlabel('Time [s]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('$x$ [m]', 'FontSize', 14, 'Interpreter','Latex')
subplot(413), plot(t,xs(:,2))
xlabel('Time [s]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('$\dot{x}$ [m/s]', 'FontSize', 14, 'Interpreter','Latex')
subplot(414), plot(t,xs(:,3))
xlabel('Time [s]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('$i$ [A]', 'FontSize', 14, 'Interpreter','Latex')

%%
Fs=1/STEP_SIZE;
Pxx=[];
f=[];
for i = 1:1:3
    [Pxx_tmp, f_tmp]=power_spectral_density(xs(:,i), Fs);
    Pxx=[Pxx, Pxx_tmp];
    f=[f, f_tmp'];
end
[UE, fe]=power_spectral_density(ue, Fs);

Pxx_db=10*log10(Pxx);
UE_db=10*log10(UE);

figure
grid on, axP = axes; set(axP, 'FontSize', 14)
subplot(411), plot(fe,UE_db)
title('Periodogram Using FFT')
axis([-1 100 -inf inf]);
xlabel('frequency [Hz]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('$P_{u_e}$ [dB/Hz]', 'FontSize', 14, 'Interpreter','Latex')
subplot(412), plot(f(:,1),Pxx_db(:,1))
axis([-1 100 -inf inf]);
xlabel('frequency [Hz]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('$P_{x}$ [dB/Hz]', 'FontSize', 14, 'Interpreter','Latex')
subplot(413), plot(f(:,2),Pxx_db(:,2))
axis([-1 100 -inf inf]);
xlabel('frequency [Hz]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('$P_{\dot{x}}$ [dB/Hz]', 'FontSize', 14, 'Interpreter','Latex')
subplot(414), plot(f(:,3),Pxx_db(:,3))
axis([-1 100 -inf inf]);
xlabel('frequency [Hz]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('$P_{i}$ [dB/Hz]', 'FontSize', 14, 'Interpreter','Latex')

%% PB4

Amplitude=[];
for j=1:3
    for i=1:6
       Amplitude(j,i)=amplitude(xs(:,j), TIME_SIM, 20*i);
    end
end

N = 6;
THD = THD(Amplitude(2,:),N);
d2 = Amplitude(2,2)/sqrt(Amplitude(2,1)^2+Amplitude(2,2)^2)*100;
d3 = Amplitude(2,3)/sqrt(Amplitude(2,1)^2+Amplitude(2,3)^2)*100;

THDMatlab = thd(xs(:,2), Fs, N);

%% PB5

% AuPb5 = 2.5:2.5:10; % V
% fcPb5 = 20:5:200; % Hz
% d2Pb5 = zeros(length(AuPb5),length(fcPb5));
% d3Pb5 = zeros(length(AuPb5),length(fcPb5));
% 
% for k=1:length(AuPb5)
%     for l=1:length(fcPb5)
%         uePb5 = AuPb5(k)*sin(2*pi*fcPb5(l)*t);
%         [tsPb5,xsPb5,ysPb5] = sim('nonLinearModel2',TIME_SIM,[],[t' uePb5']);
%         AmplitudePb5=[];
%         for j=1:3
%             for i=1:3
%                AmplitudePb5(j,i)=amplitude(xsPb5(:,j), TIME_SIM, fcPb5(l)*i);
%             end
%         end
%         d2Pb5(k,l) = AmplitudePb5(2,2)/sqrt(AmplitudePb5(2,1)^2+AmplitudePb5(2,2)^2)*100;
%         d3Pb5(k,l) = AmplitudePb5(2,3)/sqrt(AmplitudePb5(2,1)^2+AmplitudePb5(2,3)^2)*100;
%     end
% end
% 
% figure
% grid on, axP = axes; set(axP, 'FontSize', 14)
% subplot(411)
% plot(fcPb5, d2Pb5(1,:))
% hold on
% plot(fcPb5, d3Pb5(1,:))
% xlabel('Frequency [Hz]', 'FontSize', 14, 'Interpreter','Latex')
% ylabel('$A_u = 2.5$ V', 'FontSize', 14, 'Interpreter','Latex')
% l=legend('$d_2 [\%]$','$d_3 [\%]$');
% set(l, 'FontSize',14, 'Interpreter','Latex')
% subplot(412)
% plot(fcPb5, d2Pb5(2,:))
% hold on
% plot(fcPb5, d3Pb5(2,:))
% xlabel('Frequency [Hz]', 'FontSize', 14, 'Interpreter','Latex')
% ylabel('$A_u = 5$ V', 'FontSize', 14, 'Interpreter','Latex')
% l=legend('$d_2 [\%]$','$d_3 [\%]$');
% set(l, 'FontSize',14, 'Interpreter','Latex')
% subplot(413)
% plot(fcPb5, d2Pb5(3,:))
% hold on
% plot(fcPb5, d3Pb5(3,:))
% xlabel('Frequency [Hz]', 'FontSize', 14, 'Interpreter','Latex')
% ylabel('$A_u = 7.5$ V', 'FontSize', 14, 'Interpreter','Latex')
% l=legend('$d_2 [\%]$','$d_3 [\%]$');
% set(l, 'FontSize',14, 'interpreter','Latex')
% subplot(414)
% plot(fcPb5, d2Pb5(4,:))
% hold on
% plot(fcPb5, d3Pb5(4,:))
% xlabel('Frequency [Hz]', 'FontSize', 14, 'Interpreter','Latex')
% ylabel('$A_u = 10$ V', 'FontSize', 14, 'Interpreter','Latex')
% l=legend('$d_2 [\%]$','$d_3 [\%]$');
% set(l, 'interpreter','Latex', 'FontSize',14)

%% P6

[x,u,y,dx,options] = trim('nonLinearModel2',[0;0;0],[0],[],[],[1],[]);

[A,B,C,D] = linmod('nonLinearModel2',[0;0;0],0);


%% P7

Mc = [B A*B A^2*B];
rank(Mc); % = 3 controllable
Mo=[C
    C*A
    C*A^2];
rank(Mo); % = 3 observable


%% P8

lambda = eig(A); % lambda in the left half plane -> stable
syms X
eq = X^3 + (Re/Le0 + Rm/mt)*X^2 + (Rm*Re+Bl0^2+k0*Le0)/(mt*Le0)*X + k0*Re/(mt*Le0);

eval(subs(eq, X, lambda(1)));
eval(subs(eq, X, lambda(2)));
eval(subs(eq, X, lambda(3)));

%% PB9
%ue = Au*sin(2*pi*fc*t) + Au*sin(2*pi*40*t) + Au*sin(2*pi*60*t);
[ts,xs,ys] = sim('linearModelMatrix',TIME_SIM,[],[t' ue']);

figure
grid on, axP = axes; set(axP, 'FontSize', 14)
subplot(411), plot(t,ue)
title('input $u_e$ and states responses in time domain', 'FontSize', 14, 'Interpreter','Latex')
xlabel('Time [s]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('$u_e$ [V]', 'FontSize', 14, 'Interpreter','Latex')
subplot(412), plot(t,xs(:,1))
xlabel('Time [s]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('$x$ [m]', 'FontSize', 14, 'Interpreter','Latex')
subplot(413), plot(t,xs(:,2))
xlabel('Time [s]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('$\dot{x}$ [m/s]', 'FontSize', 14, 'Interpreter','Latex')
subplot(414), plot(t,xs(:,3))
xlabel('Time [s]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('$i$ [A]', 'FontSize', 14, 'Interpreter','Latex')

% freq domain

Pxx=[];
f=[];
for i = 1:1:3
    [Pxx_tmp, f_tmp]=power_spectral_density(xs(:,i), Fs);
    Pxx=[Pxx, Pxx_tmp];
    f=[f, f_tmp'];
end
[UE, fe]=power_spectral_density(ue, Fs);

Pxx_db=10*log10(Pxx);
UE_db=10*log10(UE);

figure
grid on, axP = axes; set(axP, 'FontSize', 14)
subplot(411), plot(fe,UE_db)
title('Periodogram Using FFT')
axis([-1 100 -inf inf]);
xlabel('frequency [Hz]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('$P_{u_e}$ [dB/Hz]', 'FontSize', 14, 'Interpreter','Latex')
subplot(412), plot(f(:,1),Pxx_db(:,1))
axis([-1 100 -inf inf]);
xlabel('frequency [Hz]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('$P_{x}$ [dB/Hz]', 'FontSize', 14, 'Interpreter','Latex')
subplot(413), plot(f(:,2),Pxx_db(:,2))
axis([-1 100 -inf inf]);
xlabel('frequency [Hz]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('$P_{\dot{x}}$ [dB/Hz]', 'FontSize', 14, 'Interpreter','Latex')
subplot(414), plot(f(:,3),Pxx_db(:,3))
axis([-1 100 -inf inf]);
xlabel('frequency [Hz]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('$P_i$ [dB/Hz]', 'FontSize', 14, 'Interpreter','Latex')

%% PB10
Noise1 = 0.0830*sin(4*pi*fc*t);
Noise2 = 0.075*sin(6*pi*fc*t);
Noise = [Noise1; Noise2];

% sys=ss(A,B,C,[0]);
% w = [2:2:6]*pi*fc;
% [MAG,PHASE] = bode(sys,w)
% MAG=[MAG(1) MAG(2) MAG(3)];
% Amplitude(3,1:3)./MAG

Bd=[B B];
[ts,xs,ys] = sim('linearModelNoise',TIME_SIM,[],[t' ue'], [t' Noise1'], [t' Noise2']);
%time domain
figure
grid on, axP = axes; set(axP, 'FontSize', 14)
subplot(411), plot(t,ue)
title('input $u_e$ and states responses in time domain', 'FontSize', 14, 'Interpreter','Latex')
xlabel('Time [s]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('$u_e$', 'FontSize', 14, 'Interpreter','Latex')
subplot(412), plot(t,xs(:,1))
xlabel('Time [s]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('$x$ [m]', 'FontSize', 14, 'Interpreter','Latex')
subplot(413), plot(t,xs(:,2))
xlabel('Time [s]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('$\dot{x}$ [m/s]', 'FontSize', 14, 'Interpreter','Latex')
subplot(414), plot(t,xs(:,3))
xlabel('Time [s]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('$i$ [A]', 'FontSize', 14, 'Interpreter','Latex')


% freq domain
Pxx=[];
f=[];
for i = 1:1:3
[Pxx_tmp, f_tmp]=power_spectral_density(xs(:,i), Fs);
Pxx=[Pxx, Pxx_tmp];
f=[f, f_tmp'];
end
[UE, fe]=power_spectral_density(ue, Fs);
Pxx_db=10*log10(Pxx);
UE_db=10*log10(UE);
figure
grid on, axP = axes; set(axP, 'FontSize', 14)
subplot(411), plot(fe,UE_db)
title('Periodogram Using FFT')
axis([-1 100 -inf inf]);
xlabel('frequency [Hz]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('PSD of $u_e$ [dB/Hz]', 'FontSize', 14, 'Interpreter','Latex')
subplot(412), plot(f(:,1),Pxx_db(:,1))
axis([-1 100 -inf inf]);
xlabel('frequency [Hz]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('PSD of $x$ [dB/Hz]', 'FontSize', 14, 'Interpreter','Latex')
subplot(413), plot(f(:,2),Pxx_db(:,2))
axis([-1 100 -inf inf]);
xlabel('frequency [Hz]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('PSD of $\dot{x}$ [dB/Hz]', 'FontSize', 14, 'Interpreter','Latex')
subplot(414), plot(f(:,3),Pxx_db(:,3))
axis([-1 100 -inf inf]);
xlabel('frequency [Hz]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('PSD of $i$ [dB/Hz]', 'FontSize', 14, 'Interpreter','Latex')
Pxx_db(40*TIME_SIM+1, 3), Pxx_db(60*TIME_SIM+1, 3);

amplitude(xs(:,3), TIME_SIM, 40);
amplitude(xs(:,3), TIME_SIM, 60);

%%
%Pb12
Ts=0.0001; %[s]
[F,G]=c2d(A, B, Ts);
[F, Gd] = c2d(A, Bd, Ts);
lambdad=eig(F);

%% Pb13
k=0:TIME_SIM/STEP_SIZE;
ued=Au*sin(2*pi*fc*k*Ts);
Noise1d = 0.0830*sin(4*pi*fc*k*Ts);
Noise2d = 0.0303*sin(6*pi*fc*k*Ts);

[ts,xs,ys] = sim('discreteTimeModel',TIME_SIM,[],[(k*Ts)' ued'], [(k*Ts)' Noise1d'], [(k*Ts)' Noise2d']);

%time domain
figure
grid on, axP = axes; set(axP, 'FontSize', 14)
subplot(411), plot((k*Ts),ued)
title('input $u_e$ and states responses in time domain', 'FontSize', 14, 'Interpreter','Latex')
xlabel('Time [s]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('$u_e$', 'FontSize', 14, 'Interpreter','Latex')
subplot(412), plot((k*Ts),xs(:,1))
xlabel('Time [s]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('$x$ [m]', 'FontSize', 14, 'Interpreter','Latex')
subplot(413), plot((k*Ts),xs(:,2))
xlabel('Time [s]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('$\dot{x}$ [m/s]', 'FontSize', 14, 'Interpreter','Latex')
subplot(414), plot((k*Ts),xs(:,3))
xlabel('Time [s]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('$i$ [A]', 'FontSize', 14, 'Interpreter','Latex')

%freq domain
Pxx=[];
f=[];
for i = 1:1:3
[Pxx_tmp, f_tmp]=power_spectral_density(xs(:,i), Fs);
Pxx=[Pxx, Pxx_tmp];
f=[f, f_tmp'];
end
[UE, fe]=power_spectral_density(ued, Fs);
Pxx_db=10*log10(Pxx);
UE_db=10*log10(UE);

figure
grid on, axP = axes; set(axP, 'FontSize', 14)
subplot(411), plot(fe,UE_db)
title('Periodogram Using FFT')
axis([-1 100 -inf inf]);
xlabel('frequency [Hz]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('PSD of $u_e$ [dB/Hz]', 'FontSize', 14, 'Interpreter','Latex')
subplot(412), plot(f(:,1),Pxx_db(:,1))
axis([-1 100 -inf inf]);
xlabel('frequency [Hz]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('PSD of $x$ [dB/Hz]', 'FontSize', 14, 'Interpreter','Latex')
subplot(413), plot(f(:,2),Pxx_db(:,2))
axis([-1 100 -inf inf]);
xlabel('frequency [Hz]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('PSD of $\dot{x}$ [dB/Hz]', 'FontSize', 14, 'Interpreter','Latex')
subplot(414), plot(f(:,3),Pxx_db(:,3))
axis([-1 100 -inf inf]);
xlabel('frequency [Hz]', 'FontSize', 14, 'Interpreter','Latex')
ylabel('PSD of $i$ [dB/Hz]', 'FontSize', 14, 'Interpreter','Latex')


%% Pb14
Mc=[G F*G F^2*G];
rank(Mc); % = 3, controllable

%% Pb15
C=[1 0 0];
P=[-0.97, -0.99, -0.98];
K=acker(F,G,P);
Fk=F-G*K;
sys=ss(Fk,G,C,[]);
bode(sys, -10:0.1:30);





