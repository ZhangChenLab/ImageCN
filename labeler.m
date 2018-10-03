clc;clear
num=3;
folder=['F:\data\software\compare\ImageCN_samples\ImageCN_20180817\t',num2str(num)];
load([folder,'\TempData.mat'])
clear imov L_ave L_ref L_merge
%     roi_folder=['F:\data\software\compare\ImageCN_samples\tif-',num2str(num)];
%     load([roi_folder,'\centroid.mat'])
load('show.mat')
%%
if num==8
    th_ref=10.35;
    th_ave=-0.1;
else
    th_ref=-0.4;
    th_ave=-0.0;
end
fprintf('ROI detection: %d/%d...\n',1,2)
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
fprintf('ROI detection: %d/%d...\n',2,2)
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
L_merge=raw_L_ref*0;
L_ave=raw_L_ave;
L_ref=raw_L_ref;
% for i=1:max(max(raw_L_ave))
%     if (sum(L_ref(raw_L_ave==i))/max(L_ref(raw_L_ave==i)))/sum(sum(raw_L_ave==i))>0.6
%         L_ave(raw_L_ave==i)=0;
%         L_merge(raw_L_ref==max(L_ref(raw_L_ave==i)))=1;
%         L_ref(raw_L_ref==max(L_ref(raw_L_ave==i)))=0.5;
%     elseif (sum(L_ref(raw_L_ave==i))/max(L_ref(raw_L_ave==i)))/sum(sum(raw_L_ref==max(L_ref(raw_L_ave==i))))>0.6
%         L_ave(raw_L_ref==max(L_ref(raw_L_ave==i)))=0;
%         L_ref(raw_L_ref==max(L_ref(raw_L_ave==i)))=0;
%         L_merge(raw_L_ave==i)=1;
%         L_ave(raw_L_ave==i)=0.5;
%     end
% end
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
for i=1:length(B_ref)
    outline=B_ref{i};
    for j=1:length(outline)
        outline_ref(outline(j,1),outline(j,2))=1;
    end
end
for i=1:length(B_merge)
    outline=B_merge{i};
    for j=1:length(outline)
        outline_merge(outline(j,1),outline(j,2))=1;
    end
end
outline_merge1=outline_merge+outline_ref+outline_ave;
outline_merge1(outline_merge1>1)=1;
outline_ave1_raw=imdilate(outline_merge1,strel('square',2));
if num==8
    th_ref=10.35;
    th_ave=-0.1;
else
    th_ref=-0.0;
    th_ave=-0.3;
end
fprintf('ROI detection: %d/%d...\n',1,2)
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
fprintf('ROI detection: %d/%d...\n',2,2)
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
L_merge=raw_L_ref*0;
L_ave=raw_L_ave;
L_ref=raw_L_ref;
% for i=1:max(max(raw_L_ave))
%     if (sum(L_ref(raw_L_ave==i))/max(L_ref(raw_L_ave==i)))/sum(sum(raw_L_ave==i))>0.6
%         L_ave(raw_L_ave==i)=0;
%         L_merge(raw_L_ref==max(L_ref(raw_L_ave==i)))=1;
%         L_ref(raw_L_ref==max(L_ref(raw_L_ave==i)))=0.5;
%     elseif (sum(L_ref(raw_L_ave==i))/max(L_ref(raw_L_ave==i)))/sum(sum(raw_L_ref==max(L_ref(raw_L_ave==i))))>0.6
%         L_ave(raw_L_ref==max(L_ref(raw_L_ave==i)))=0;
%         L_ref(raw_L_ref==max(L_ref(raw_L_ave==i)))=0;
%         L_merge(raw_L_ave==i)=1;
%         L_ave(raw_L_ave==i)=0.5;
%     end
% end
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
for i=1:length(B_ref)
    outline=B_ref{i};
    for j=1:length(outline)
        outline_ref(outline(j,1),outline(j,2))=1;
    end
end
for i=1:length(B_merge)
    outline=B_merge{i};
    for j=1:length(outline)
        outline_merge(outline(j,1),outline(j,2))=1;
    end
end
outline_merge2=outline_merge+outline_ref+outline_ave;
outline_merge2(outline_merge1>1)=1;
outline_ave2_raw=imdilate(outline_merge2,strel('square',2));
%%
outline_ave1=outline_ave1_raw;
outline_ave2=outline_ave2_raw;
outline_ave=outline_ave1==outline_ave2;
outline_ave(outline_ave1==0)=0;
outline_ave(outline_ave2==0)=0;
outline_ave1(outline_ave1==outline_ave)=0;
outline_ave2(outline_ave2==outline_ave)=0;
imov_ave=imoverlay(Image_average,outline_ave,'y');
imov_ave=imoverlay(imov_ave,outline_ave1,'b');
imov_ave=imoverlay(imov_ave,outline_ave2,'c');
imshow(imov_ave,'border','tight')
hold on
scatter(ave_c(:,1),ave_c(:,2),35,'ro')
scatter(ave_c(:,1),ave_c(:,2),30,'ro')
scatter(ave_c(:,1),ave_c(:,2),25,'ro')
f=getframe;
f_im=f.cdata;
imwrite(f_im,'show_mer.tif')
%%