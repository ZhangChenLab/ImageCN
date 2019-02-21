function CaSigGeneration(Path)
%%
load([Path,'\process\TempData.mat']);
disp('Processing...')
FilterThreshold = 0.3;
%%
INFO  =  imfinfo(File);
t  =  size(INFO);
se1 = strel('disk',8);
se2 = strel('disk',3);
merge_region = L_merge+L_ref+L_ave;
R_merge = imdilate(L_merge,se1)-imdilate(L_merge,se2);
R_merge(imdilate(merge_region,se2)>1) = 0;
R_ref = imdilate(L_ref,se1)-imdilate(L_ref,se2);
R_ref(imdilate(merge_region,se2)>1) = 0;
R_ave = imdilate(L_ave,se1)-imdilate(L_ave,se2);
R_ave(imdilate(merge_region,se2)>1) = 0;
Centroid_merge = regionprops(L_merge,'Centroid');
Centroid_ref = regionprops(L_ref,'Centroid');
Centroid_ave = regionprops(L_ave,'Centroid');
int1=[];
int2=[];
int3=[];
%% 'L_ave','L_ref','L_merge'
for u  =  1:t(1,1)
    picture  =  im2double(imread(File,u));
    intensity_L1 = regionprops(L_merge,picture,'meanintensity');
    intensity_R1 = regionprops(R_merge,picture,'meanintensity');
    intensity_L2 = regionprops(L_ref,picture,'meanintensity');
    intensity_R2 = regionprops(R_ref,picture,'meanintensity');
    intensity_L3 = regionprops(L_ave,picture,'meanintensity');
    intensity_R3 = regionprops(R_ave,picture,'meanintensity');
    for i = 1:length(intensity_L1)
        if ~isnan(intensity_R1(i).MeanIntensity)
            int1(u,i) = 2*intensity_L1(i).MeanIntensity-intensity_R1(i).MeanIntensity;
        else
            int1(u,i) = 2*intensity_L1(i).MeanIntensity;
        end
    end
    for i = 1:length(intensity_L2)
        if ~isnan(intensity_R2(i).MeanIntensity)
            int2(u,i) = 2*intensity_L2(i).MeanIntensity-intensity_R2(i).MeanIntensity;
        else
            int2(u,i) = 2*intensity_L2(i).MeanIntensity;
        end
    end
    for i = 1:length(intensity_L3)
        if ~isnan(intensity_R3(i).MeanIntensity)
            int3(u,i) = 2*intensity_L3(i).MeanIntensity-intensity_R3(i).MeanIntensity;
        else
            int3(u,i) = 2*intensity_L3(i).MeanIntensity;
        end
    end
end
raw_intensity = [int1,int2,int3];
%%
[a,b]=size(raw_intensity);
for i = 1:b
    y=raw_intensity(:,i);
    f_y=fft(y);
    f_shift=(fftshift(f_y));
    power_low = 1-gaussmf(1:a,[6 round(a/2)]);
    power_high = gaussmf(1:a,[a/2 round(a)/2]);
%     power_high=1;
    f_shift_filter =f_shift.*power_low'.*power_high';
    y_fft=real(ifft(ifftshift(f_shift_filter)));
    filtered_intensity(:,i) = smooth(y_fft,delta*FilterThreshold)+mean(y);
end
sig = (filtered_intensity-mean(filtered_intensity))./mean(filtered_intensity);
sig(sig<-0.3)=0;
save([Path,'\process\TempData.mat'],'raw_intensity','filtered_intensity','sig','-append');
disp('Done')
