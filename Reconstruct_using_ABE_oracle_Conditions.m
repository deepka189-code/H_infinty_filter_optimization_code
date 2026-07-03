%% 
clear all


WAV_path_final = ="add path of wideband speech files which are filter by p.341 filter";;
number_wavfile=length(WAV_path_final);
%define paramweters

testfile_amr122='testingset2/testingset2_down_scaled_16_13_AMR_16_13'

dest_path_amr122="add path of narrowband speech files which are processed by  AMR coder ";



dest_path_amr122_up="add path of resampled to 16 KHz of  AMR coded signal";

%define paramweters
         fs=16000;
         h_period=1/fs;
         window_duaration=fs*20/1000;
         win_ham= sqrt(hann(window_duaration));
         
         win_ham2 = sqrt(hann(window_duaration/2));
  

          filter_order=41;
          bpFilt = designfilt('bandpassfir', 'FilterOrder', filter_order-1,'StopbandFrequency1', 3660, 'PassbandFrequency1', 4340, 'PassbandFrequency2', 7000, 'StopbandFrequency2', 7800, 'SampleRate', 16000, 'DesignMethod', 'ls'); 
          high_coeff=bpFilt.Coefficients.*kaiser(filter_order,5)';
          time_index=1:length(high_coeff);
           mutiplyer=(-1).^(time_index-1);
          low_coeff=high_coeff.*mutiplyer;


          clear fc   bta 
 
k=1;


time_index=1:window_duaration;
             mutiplyer=(-1).^(time_index-1);
 for  wav_file_number=3:number_wavfile
          name=num2str(wav_file_number-2);

          LARGE_SIGNAL=[];
        WAV_path_final_org= strcat(dest_path_p341,name,'.wav');
 LARGE_SIGNAL=audioread(WAV_path_final_org);
  
        WAV_path_final_amr122 =[];
        WAV_path_final_amr122 = strcat(dest_path_amr122,name,'.wav');
    
    down_full_sig=[];
    down_full_sig=audioread(WAV_path_final_amr122);
      
    
    WAV_path_final_amr122_up =[];
        WAV_path_final_amr122_up = strcat(dest_path_amr122_up,name,'.wav');
    
    resamp_full_sig=[];
    resamp_full_sig=audioread(WAV_path_final_amr122_up);
   
        j=1;
       
        i=1;
        len_sig=min(2*length(down_full_sig), length(LARGE_SIGNAL));
          complete_yamma_trun=zeros(1, len_sig);

      
        file_name=strcat(name,'.mat');
      
        try

          k_filter_num=[];
          k_filter_den=[];
         load(file_name,'k_filter_num','k_filter_den');
        % clear nb_lpc_k_filter
        for i=i:window_duaration/2:len_sig-window_duaration+1
          sig_model  = LARGE_SIGNAL(i : i+window_duaration-1).*win_ham; 
       temp2=[];

       
           sig_model2=[sig_model;temp2];

          down_signal=[];
        filtered_high=filtfilt(high_coeff,1,sig_model2);
  
      
         temp=(j-1)*(window_duaration/4);  
         down_signal=down_full_sig(temp+1 : temp+(window_duaration/2)).*win_ham2;

         s2=resamp_full_sig(i : i+window_duaration-1).*win_ham;
         
          if down_signal==0
               s4_in_fft=s2;
  else
         
         
        lpc_nb=lpc( down_signal,11);
       
        down_residual=filter(lpc_nb,1,down_signal);
        clear lpc_nb down_signal

       up_residual=upsample(down_residual,2);
       clear down_residual
  
              K_IIR=[];   
              K_IIR = tf(k_filter_num{wav_file_number-2,j},k_filter_den{wav_file_number-2,j},1,'variable','z^-1');

          
       
    
                           k_filter_time=[]
              k_filter_time = impulse(K_IIR);             

              k_full=k_filter_time;
 
             clear K_IIR  k_filter_time K_bpf
            k1=[];           
            k1=k_full;
            k1=k1/max(abs(k1));   %this k1 is replaced by predicted k1 by dnn 
         
            clear k_full
             yamma_trun=filter(k1,1,up_residual);
            yamma_trun_invert=yamma_trun.*mutiplyer';
             s3=filtfilt(high_coeff,1,yamma_trun_invert);
             clear  yamma_trun  yamma_trun2 k1
             
             gain=sqrt(sum(filtered_high(1:window_duaration).^2)/sum(s3(1:window_duaration).^2));  % use predicted gain by DNN
             
             ub_estimated=s3(1:window_duaration)*gain;
             clear s3 gain
             
        

    
    k=k+1;
    
   
      dhigh=-7;
      dlow=-13;
       theta=5;
     s lope=(dhigh-dlow)/theta
   dl=min([slope*Rl_sfs+dlow,dhigh]);
     
     
           s4_in_fft=s2+  (10^(dl/20)*ub_estimated);
           
             clear s2 ub_estimated   num den ub_psd  nb_psd slope
             
             
        
        
             
            
                 end
         complete_yamma_trun(i:i+window_duaration-1)=complete_yamma_trun(i:i+window_duaration-1)+(s4_in_fft.*win_ham)';

                j=j+1; 
        end
   clear  k_filter_num k_filter_den nb_lpc_k_filter
    
        reconstructed_file1 =strcat('path to store speech file',name,'.wav');
  
             audiowrite(reconstructed_file1,complete_yamma_trun,fs,'BitsPerSample',16); 

 
%       
  clear complete_yamma_trun 
        catch
        end
        clear k_filter_num  k_filter_den 
       
 end
 
        
      