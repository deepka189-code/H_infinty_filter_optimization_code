function zt = lift_Sig_ZT(A,B,C,D,N,Ts);
%FINDIN LIFTING ZT TRANSFORM MAUALLY
A_new=A^N;
%for cretin B_new an C_new
B_new=[];C_new=[];D_new=[];
[m_old,n_old]=size(D);
%zero_mat =zeros(m_old,n_old)
for i=1:1:N
%temp1=A^(N-i)*B; temp2  
B_new= cat(2,B_new,A^(N-i)*B);
C_new= cat(1,C_new,C*A^(i-1));
if i==1
temp1=D;
d_update=D;
else
   
   
   temp1=cat(2, C*(A^(i-2))*B,temp1);
   row_size_upda=size(d_update,1); 
   d_update=cat(2,d_update,zeros(row_size_upda,n_old)); %here we are finding the zeros matrix to be added old  
                                                     %d_update matrix to make same column of temp1 or d_opdate
   d_update=cat(1,d_update,temp1); % concate old update matrix added with zeros matrix  and temp1(last new matrix occured)

end
end
D_new=d_update;

%  sa=size(A_new);
% 
%  z=tf('z',Ts)
%  inv_chr=inv(z*eye(sa)-A_new);
% 
%  zt= D_new + C_new* inv_chr *B_new;
% size(zt);


system=ss(A_new,B_new,C_new,D_new,Ts);
zt=tf(system);
end
