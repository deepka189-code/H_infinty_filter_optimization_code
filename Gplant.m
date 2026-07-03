function [G_trans_fun,gmin] =Gplant(delay,G11_noise,G21_noise,PNZ,S,H,L,Ts,N);
%here we are finding state space moddel of plant G
%syms z

z=tf('z',Ts);
G11=z^(-delay)*G11_noise;
clear G11_noise
[ag,bg,cg,dg]=ssdata(G11);
clear ag bg cg
% eigen=sigma(dg'*dg)
% gmin=min(eigen)
gmin=norm(dg);
G12= -PNZ*H;
clear PNZ
G21=S*z^(-delay)*G21_noise;
clear G21_noise
G22=zeros(1,L);
G_trans=[G11,G12;G21,G22];
clear G11 G12 G21 G22
sys=ss(G_trans,'minimal');
clear G_trans
[A,B,C,D]=ssdata(sys);
clear sys
%gmin=norm(D)
%[num,den]=ss2tf(A,B,C,D,6)
% num2=cell2mat(num);
% den2=cell2mat(den);
%G_trans_fun=tf(num',den',Ts)
G_trans_fun=pck(A,B,C,D);

end

