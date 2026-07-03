function [ k_final] = yamma_new_fssest_lpf( fs_high,fs_low,h_period,Intpol_factor,delay,down_signal)
%,k_output 

l=1;
gmax=10000000.00;
clear Ps_fun
    NCON=Intpol_factor; NMEAS=1;tol=.0010;
    N=Intpol_factor;
   fs_ss11=ss(fs_high); %state space model of noiseless F(s) trandfer function 
   fs_ss21=ss(fs_low); %state space model of noiseless F(s) trandfer function 

    clear   den
    [Fa_11,Fb_11,Fc_11,Fd_11]= ssdata(fs_ss11); %state space analysis
    [Fa_21,Fb_21,Fc_21,Fd_21]= ssdata(fs_ss21); %state space analysis
     clear  fs_ss11 fs_ss21 Fs_fun
   
 
 % FNZ_noise=[0,0;0,0]; 
  FNZ_11=lift_Sig_ZT(Fa_11, Fb_11,Fc_11,Fd_11,N,h_period);
  FNZ_21=lift_Sig_ZT(Fa_21,Fb_21,Fc_21,Fd_21,N,h_period);
  
  PNZ=1
 
  clear Fa_11 Fb_11 Fc_11 Fd_11   Fa_21 Fb_21 Fc_21 Fd_21
  
  G11=FNZ_11;
  G21=FNZ_21;
  clear FNZ_11 FNZ_21

 S=[];H=[];
 S=zeros(1,N); S(1)=1;
 l= N/Intpol_factor;
 I_l =ones(l,1);
  H=zeros(N,Intpol_factor);
for i=1:Intpol_factor
H( l*(i-1)+1:l*i,i)= I_l;
end
lpc_down=lpc(down_signal,11);
A_z=tf(lpc_down,1,h_period,'variable','z^-1');

S=A_z*S;
clear A_z
[G_trans_fun,gmin] =  Gplant(delay,G11,G21,PNZ,S,H,Intpol_factor,h_period,N);
clear G11 G21 PNZ S

 [K,G_close,GAM_new] = dhfsyn(G_trans_fun,NMEAS,NCON,gmin,gmax,tol,h_period,'QUIET',1); 
 GAM_new
 clear G_close GAM_new G_trans_fun
 [a_k,b_k,c_k,d_k]=unpck(K);
 clear K
 k_bar_sys=ss(a_k,b_k,c_k,d_k,h_period);
 clear a_k b_k c_k d_k
 k_bar_trans=tf(k_bar_sys);
 clear k_bar_sys
%do upsampling of k 
k_upsample = upsample(k_bar_trans,Intpol_factor);
clear k_bar_trans
z=tf('z',h_period/Intpol_factor);
 k_final=0;
for i=1:Intpol_factor
k_final=z^(-(i-1))*k_upsample(i,1)+k_final;
end
clear k_upsample

end


