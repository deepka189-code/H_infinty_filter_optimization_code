function [num,den] = prony_zero_stablize(signal,number_zero,number_pole,x);

 [num,den]= prony(signal,number_zero, number_pole);
  

     if num==0
                            num=1;
                            k=1;
     end
      
    
 
if x==1
     
     


 [zero_old,pole_old,k] = tf2zpk(num,den);
                       
  
                          p_magnitude=abs(pole_old);
  
                        p_phase=phase(pole_old);
                          
                          for number_pole=1:length(pole_old)
                              
                          
     if p_magnitude(number_pole)>1
                          
                             
    k=k*1/p_magnitude(number_pole);
                               
  p_magnitude(number_pole)=1/p_magnitude(number_pole);
                       
        end
              
            end
  
                      
  p_new=p_magnitude.*exp(1j*p_phase);
 
                         
            
 
   
   z_magnitude=abs(zero_old);
   
 z_phase=phase(zero_old);
 
for number_zero=1:length(zero_old)
     
if z_magnitude(number_zero)>1
        
 k=k*z_magnitude(number_zero);
  
z_magnitude(number_zero)=1/z_magnitude(number_zero);
   
          end

 end
          
 z_new=z_magnitude.*exp(1j*z_phase);

                          
%        
 [num,den] = zp2tf(z_new,p_new,k);
 
end 


end

