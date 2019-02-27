function ROIGeneration(Path,th_ref,th_ave,diameter)
%%
th1 = th_ref;
th2 = th_ave;
d = diameter;
load([Path,'\process\TempData.mat']);
clear imov L_ave L_ref L_merge th_ref th_ave diameter
[a,b]=size(Image_average);
th_ref = th1;
th_ave = th2;
diameter = d;
% [ input_yingyong, Centroid_T,L_ann,cell_aera] = ANN_input(Image_ref);
fprintf('ROI detection: %d/%d...\n',1,2)
[ patches,L_ref] = CNN_ref_input(Image_ref,Image_average,diameter);
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
fprintf('ROI detection: %d/%d...\n',2,2)
[patches,L_ave] = CNN_ave_input(Image_average,diameter);
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
L_ave=raw_L_ave;
L_ref=raw_L_ref;
[B_ave,L_ave]= bwboundaries(L_ave);
[B_ref,L_ref]= bwboundaries(L_ref);
outline_ave=L_ave*0;
outline_ref=L_ave*0;
outline_merge=L_ave*0;
for i=1:length(B_ave)
    outline=B_ave{i};
    for j=1:length(outline)
        outline_ave(outline(j,1),outline(j,2))=1;
    end
end
imov_ave=imoverlay(Image_average,outline_ave,'y');
% imov_ref=imoverlay(Image_ref,outline_ave,'y');
for i=1:length(B_ref)
    outline=B_ref{i};
    for j=1:length(outline)
        outline_ref(outline(j,1),outline(j,2))=1;
    end
end
% imov_ave=imoverlay(imov_ave,outline_ref,'r');
imov_ref=imoverlay(Image_ref,outline_ref,'c');
% imov_ave=imoverlay(imov_ave,outline_merge,'y');
% imov_ref=imoverlay(imov_ref,outline_merge,'y');
figure
subplot(2,2,1)
imshow(Image_average)
title('average projection image')
subplot(2,2,2)
imshow(imov_ave)
title('detection results')
% figure
subplot(2,2,3)
imshow(Image_ref)
title('reference image')
subplot(2,2,4)
imshow(imov_ref)
title('detection results')
imwrite(imov_ave,File_ave_imov);
imwrite(imov_ref,File_ref_imov);
%%
L_merge=raw_L_ref*0;
L_ave=raw_L_ave;
L_ref=raw_L_ref;
for i=1:max(max(raw_L_ave))
    if (sum(L_ref(raw_L_ave==i))/max(L_ref(raw_L_ave==i)))/sum(sum(raw_L_ave==i))>0.7
        L_ave(raw_L_ave==i)=0;
        L_merge(raw_L_ref==max(L_ref(raw_L_ave==i)))=1;
        L_ref(raw_L_ref==max(L_ref(raw_L_ave==i)))=0.5;
    elseif (sum(L_ref(raw_L_ave==i))/max(L_ref(raw_L_ave==i)))/sum(sum(raw_L_ref==max(L_ref(raw_L_ave==i))))>0.7
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
outline_index=outline_merge+outline_ref+outline_ave;
neuron_index_ref=imoverlay(Image_ref,outline_index,[1,0.5,0]);
neuron_index_ave=imoverlay(Image_average,outline_index,[1,0.5,0]);
imwrite(neuron_index_ref,[Pathnew,'Neuron_index_ref.tif']);
imwrite(neuron_index_ave,[Pathnew,'Neuron_index_ref.tif']);
% f_size=ceil(a+b)/150;
% figure
% imshow(neuron_index_ref,'border','tight');
% hold on
% ROIs={};
% for i=1:max(max(L_merge))
%     loc=mean(B_merge{i});
%     text(loc(2)-2,loc(1),num2str(i),'color','c','FontSize',f_size)
% end
% for i=1:max(max(L_ref))
%     loc=mean(B_ref{i});
%     text(loc(2)-2,loc(1),num2str(i+max(max(L_merge))),'color','c','FontSize',f_size)
% end
% for i=1:max(max(L_ave))
%     loc=mean(B_ave{i});
%     text(loc(2)-2,loc(1),num2str(i+max(max(L_merge))+max(max(L_ref))),'color','c','FontSize',f_size)
% end
% hold off
% print(gcf,[Pathnew,'Neuron_index_ref'],'-dtiff','-r600')
% close

% figure
% imshow(neuron_index_ave,'border','tight');
% hold on
% for i=1:max(max(L_merge))
%     loc=mean(B_merge{i});
%     text(loc(2)-2,loc(1),num2str(i),'color','c','FontSize',f_size)
% end
% for i=1:max(max(L_ref))
%     loc=mean(B_ref{i});
%     text(loc(2)-2,loc(1),num2str(i+max(max(L_merge))),'color','c','FontSize',f_size)
% end
% for i=1:max(max(L_ave))
%     loc=mean(B_ave{i});
%     text(loc(2)-2,loc(1),num2str(i+max(max(L_merge))+max(max(L_ref))),'color','c','FontSize',f_size)
% end
ROIs=[B_merge;B_ref;B_ave];
% hold off
% print(gcf,[Pathnew,'Neuron_index_ave'],'-dtiff','-r600')
% close
save([Pathnew,'\TempData.mat'],'th_ref','th_ave','imov_ave','imov_ref','L_ave','L_ref','L_merge','diameter','ROIs','-append');
fprintf('Done\n')