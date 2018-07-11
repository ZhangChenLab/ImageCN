function ROIGeneration(Path,th_ref,th_ave)
%%
load([Path,'\process\TempData.mat']);
clear imov L_ave L_ref L_merge
% [ input_yingyong, Centroid_T,L_ann,cell_aera] = ANN_input(Image_ref);
[ patches,L_ref] = CNN_ref_input(Image_ref,Image_average);
load('net_ref.mat')
[~,raw_scores]=classify(net,patches);
scores=raw_scores;
scores(:,1)=raw_scores(:,1)+th_ref;
scores(:,2)=raw_scores(:,2)-th_ref;
[~,y]=max(scores,[],2);
wrong_num=find(y==1);
for ci=1:length(wrong_num)
    L_ref(L_ref==wrong_num(ci))=0;
end
[~,raw_L_ref]= bwboundaries(L_ref);
%%
[patches,L_ave] = CNN_ave_input(Image_average);
load('net_ave.mat')
[~,raw_scores]=classify(net_cnn,patches);
scores=raw_scores;
scores(:,1)=raw_scores(:,1)+th_ave;
scores(:,2)=raw_scores(:,2)-th_ave;
[~,y]=max(scores,[],2);
wrong_num=find(y==1);
for ci=1:length(wrong_num)
    L_ave(L_ave==wrong_num(ci))=0;
end
[~,raw_L_ave]= bwboundaries(L_ave);
%%
L_merge=raw_L_ref*0;
L_ave=raw_L_ave;
L_ref=raw_L_ref;
for i=1:max(max(raw_L_ave))
    if (sum(L_ref(raw_L_ave==i))/max(L_ref(raw_L_ave==i)))/sum(sum(raw_L_ave==i))>0.6
        L_ave(raw_L_ave==i)=0;
        L_merge(raw_L_ref==max(L_ref(raw_L_ave==i)))=1;
        L_ref(raw_L_ref==max(L_ref(raw_L_ave==i)))=0.5;
    elseif (sum(L_ref(raw_L_ave==i))/max(L_ref(raw_L_ave==i)))/sum(sum(raw_L_ref==max(L_ref(raw_L_ave==i))))>10.7
        L_ave(raw_L_ref==max(L_ref(raw_L_ave==i)))=0;
        L_ref(raw_L_ref==max(L_ref(raw_L_ave==i)))=0;
        L_merge(raw_L_ave==i)=1;
        L_ave(raw_L_ave==i)=0.5;
    end
end
L_ref(L_ref==0.5)=0;
L_ave(L_ave==0.5)=0;
[B_ave,L_ave]= bwboundaries(L_ave);
[B_ref,L_ref]= bwboundaries(L_ref);
[B_merge,L_merge]= bwboundaries(L_merge);
outline_ave=L_ave*0;
outline_ref=L_ave*0;
outline_merge=L_ave*0;
for i=1:length(B_ave)
    outline=B_ave{i};
    for j=1:length(outline)
        outline_ave(outline(j,1),outline(j,2))=1;
    end
end
imov=imoverlay(Image_average,outline_ave,'g');
for i=1:length(B_ref)
    outline=B_ref{i};
    for j=1:length(outline)
        outline_ref(outline(j,1),outline(j,2))=1;
    end
end
imov=imoverlay(imov,outline_ref,'r');
for i=1:length(B_merge)
    outline=B_merge{i};
    for j=1:length(outline)
        outline_merge(outline(j,1),outline(j,2))=1;
    end
end
mapp=[length(B_ave),length(B_ref),length(B_merge)];
imov=imoverlay(imov,outline_merge,'y');
imshow(imov)
imwrite(imov,File_ROI_imov);
save([Pathnew,'\TempData.mat'],'imov','L_ave','L_ref','L_merge','-append');