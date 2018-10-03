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
         int1(u,i) = 2*intensity_L1(i).MeanIntensity-intensity_R1(i).MeanIntensity;
    end
    for i = 1:length(intensity_L2)
         int2(u,i) = 2*intensity_L2(i).MeanIntensity-intensity_R2(i).MeanIntensity;
    end
    for i = 1:length(intensity_L3)
         int3(u,i) = 2*intensity_L3(i).MeanIntensity-intensity_R3(i).MeanIntensity;
    end
end
raw_intensity = [int1,int2,int3];
%%
for i = 1:size(raw_intensity,2)
    filtered_intensity(:,i) = smooth(raw_intensity(:,i),delta*FilterThreshold);
end
sig = (filtered_intensity-mean(filtered_intensity))./mean(filtered_intensity);
save([Path,'\process\TempData.mat'],'raw_intensity','filtered_intensity','sig','-append');
disp('Done')
