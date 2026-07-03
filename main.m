clc;
clear;
close all;


 fs=16000;
 h_period=1/fs;


WAV_path_final_p341 ="add path of wideband speech files which are filter by p.341 filter";


dest_path_msin_lpf="add path of narrowband speech files which are processed by MSIN filter, p.56 level adjusted, and HQ2 filter  ;
%PATH FOR DOWNSAMPLED SIGNAL
dest_path_amr122="add path of narrowband speech files which are processed by  AMR coder ";
 number_wavfile=length(WAV_path_final_p341);

testfile_store ="path to store data";

for (wav_file_number=3:number_wavfile)
    nb_p_z=[15,1] ; 
    wb_p_z=[15,3];
    fun_temp_without_delay_msin(wav_file_number,testfile_store,dest_path_p341,dest_path_msin_lpf,dest_path_amr122,nb_p_z,wb_p_z) ;

end
