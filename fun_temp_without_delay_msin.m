%function [  fs_numerator, fs_denominator,k_filter_num, k_filter_den] = fun_temp( path )





%change path of .mat and .wav wherever we want to store and 
%On which file you want to apply

function  fun_temp_without_delay_msin(wav_file_number,testfile_store,dest_path_p341,dest_path_msin_lpf,dest_path_amr122,nb_p_z,wb_p_z)
name=num2str(wav_file_number-2); 

WAV_path_final_org= strcat(dest_path_p341,name,'.wav');
WAV_path_final_msin_lpf = strcat(dest_path_msin_lpf,name,'.wav');
WAV_path_final_amr122 = strcat(dest_path_amr122,name,'.wav');


Intpol_factor=2;
fs=16000;
h_period=1/fs;
window_duaration=fs*20/1000;
     window_ham = sqrt(hann(window_duaration));
         window_ham2 = sqrt(hann(window_duaration/2));
  
        
        orginal=audioread(WAV_path_final_org);
        
        msin_sig_lpf=audioread(WAV_path_final_msin_lpf);
        
        down_sig=audioread(WAV_path_final_amr122);
        
        filter_order=41;
bpFilt = designfilt('bandpassfir', 'FilterOrder', filter_order-1,'StopbandFrequency1', 3660, 'PassbandFrequency1', 4340, 'PassbandFrequency2', 7000, 'StopbandFrequency2', 7800, 'SampleRate', 16000, 'DesignMethod', 'ls');
bpf_coeff=bpFilt.Coefficients.*kaiser(filter_order,5)';

     
        
         try
       file_name=strcat(testfile_store,'_files/',name,'.mat');
  
          load(file_name,'start','j','k_filter_num','k_filter_den','nb_lpc_k_filter');
     i=start;
         catch
             j=1;
             i=1;
         end
        
           
       
      
        
  try
       %%
       
       len=min(length(orginal), length(msin_sig_lpf));
   if i<=len -window_duaration+1
      
        for i=i:window_duaration/2:len -window_duaration+1
           %read original signal
            sig_org  = orginal(i : i+window_duaration-1).*window_ham;
            
           %read msin follwed lpf filtered signal
          sig_msin_filtered = msin_sig_lpf(i : i+window_duaration-1).*window_ham;
          
          %read downsampled following AMR122 CODING
          temp=(j-1)*(window_duaration/4);  
         down_signal=(down_sig(temp+1 : temp+(window_duaration/2)).*window_ham2);
          
          
       
             filtered_high=filtfilt(bpf_coeff,1,sig_org);
              time_index=1:window_duaration;
              mutiplyer=(-1).^(time_index-1);
              convert_low_filtered_high=filtered_high.*mutiplyer';

         
     
         k_yamma=[];
        yamma_signal=[];
         fs_low=[];
         fs_high=[];
          

        num=[];den=[]; 
        [num,den] = prony_zero_stablize(convert_low_filtered_high,wb_p_z(2),wb_p_z(1),1);
 
 
         fs_high=tf(num,den,h_period,'variable','z^-1');

         num=[];den=[];        

         [num,den] = prony_zero_stablize(sig_msin_filtered,nb_p_z(2),nb_p_z(1),1);
        fs_low=tf(num,den,h_period,'variable','z^-1');
       

        clear num den  filtered_low
   if down_signal==0
         
     else
    delay=0;
 try 
 [k_yamma]= yamma_new_fssest_lpf(fs_high,fs_low,h_period*Intpol_factor,Intpol_factor,delay,down_signal);
 catch
     
    num=[];den=[]; 
  [num,den] = prony_zero_stablize(convert_low_filtered_high,wb_p_z(2),11,1);
 
  fs_high=tf(num,den,h_period,'variable','z^-1');
   
   [k_yamma]= yamma_new_fssest_lpf(fs_high,fs_low,h_period*Intpol_factor,Intpol_factor,delay,down_signal);
  
 end
 clear convert_low_filtered_high
 
    [A,B]= tfdata(k_yamma);
    clear k_yamma
    FUN_K = tf(A,B,1,'variable','z^-1');
    k_filter_time = impulse(FUN_K);
    lpc_nb=lpc( down_signal,11);
    nb_lpc_k_filter(j,:)=cat(2,lpc_nb(2:end),k_filter_time(1:30)');
    clear lpc_nb  k_filter_time  lpc_nb FUN_K
  
    
    k_filter_num{wav_file_number-2,j}=A;
    k_filter_den{wav_file_number-2,j}=B;
    clear A B
    
   end
  

 j=j+1;
 
 start=i+window_duaration/2
 file_name=strcat('prony_use_han_data_lpf_nb_wb_inv_bpf/',testfile_store,'_files/',name,'.mat');
save(file_name,'start','j','k_filter_num','k_filter_den','nb_lpc_k_filter');
 end
   end  
     catch
      file_name=strcat('prony_use_han_data_lpf_nb_wb_inv_bpf/',testfile_store,'_files/error',name,'.mat');
   
     save(file_name, 'wav_file_number', 'i');
      end
      
    
        
end

