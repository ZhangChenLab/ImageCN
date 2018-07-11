function [patches,L]  =  CNN_ave_input(Image_average)
ref = Image_average;
ref = imadjust(ref,stretchlim(ref,0),[0,1],1);
[a,b] = size(ref);
ssq = round((a+b)/350)^2;
if a+b<1000
    bw_size = 15;
    dm = 12;
else
    bw_size = 21;
    dm = 10;
end
se_dm = strel('disk',dm);
xbdingmao = imsubtract(imadd(ref,imtophat(ref,se_dm)),imbothat(ref,se_dm));
% xbdingmao = imgaussfilt(xbdingmao,1);
xbdingmao = imdilate(xbdingmao,strel('square',2));
xbdingmao = imopen(xbdingmao,strel('disk',1));
C = 0.012;
IM = xbdingmao;
mIM = imfilter(IM,fspecial('average',bw_size),'replicate');
sIM = IM-mIM-C;
sIM = imfilter(sIM,fspecial('average',3),'replicate');
bw = double(imbinarize(sIM,0));
% imshow(bw)
bw = imopen(bw,strel('square',1));
bw = imerode(bw,strel('square',1));
fill = imfill(bw);
xbbwareaopen  =  bwareaopen(fill,ssq);
BS = strel('square',1);
bw = imdilate(xbbwareaopen,BS);
D  =  -bwdist(~bw);
mask  =  imextendedmin(D,0.4);
D2  =  imimposemin(D,mask);
Ld2  =  watershed(D2,8);
bw(Ld2 == 0) = 0;
bw = imopen(bw,strel('disk',1));
bw = imopen(bw,strel('disk',2));
bw = imerode(bw,strel('square',1));
bw = imopen(bw,strel('square',3));
bw  =  bwareaopen(bw,round(ssq/0.4),4);
[B,L] =  bwboundaries(bw);
outline_ave = L*0;
% for i = 1:length(B)
%     outline = B{i};
%     for j = 1:length(outline)
%         outline_ave(outline(j,1),outline(j,2)) = 1;
%     end
% end
% imov = imoverlay(Image_average,outline_ave,'cyan');
% imshow(imov)
%%
for i = 1:max(max(L))
    mask_bw = zeros(size(bw));
    mask_bw(L == i) = 1;
    %     imshow(mask_bw)
end
[a,b] = size(ref);
ref_mask = ref;
append_row = zeros(15,b);
append_column = zeros(a+30,15);
ref_mask = [append_row;ref_mask;append_row];
ref_mask = [append_column,ref_mask,append_column];
for  i = 1:length(B)
    mask_rgb = repmat(ref,1,1,3);
    for j = 1:length(B{i})
        mask_rgb(B{i}(j,1),B{i}(j,2),1) = 1;
        mask_rgb(B{i}(j,1),B{i}(j,2),2:3) = 0;
    end
%     [x,y,z] = ginput(1);%��������1���Ǵ����Ҽ���3������ȷ
    % cen = round([mean(min(B{1}(:,1)),max(B{1}(:,1))),mean(min(B{1}(:,2)),max(B{1}(:,2)))]);
    cen = round([mean(B{i}(:,1)),mean(B{i}(:,2))])+15;
    maxi = max(max(B{i}(:,1))-min(B{i}(:,1)),max(B{i}(:,2))-min(B{i}(:,2)));
    if cen(1)+round(maxi/2)+5>a+30 || cen(2)+round(maxi/2)+5>b+30
            maxi = min(2*(a+30-5-cen(1)),2*(b+30-5-cen(2)));
    end
    if cen(1)-round(maxi/2)-5 <= 0|| cen(2)-round(maxi/2)-5 <= 0
            maxi = min(2*cen(1)-12,2*cen(2)-12);
    end
    ref_minus = ref_mask;
    L_cov = [append_row;L;append_row];
    L_cov = [append_column,L_cov,append_column];
    ref_minus(L_cov ~= i & L_cov>0) = 0;
    raw_cell = ref_minus(cen(1)-round(maxi/2)-5:cen(1)+round(maxi/2)+5,cen(2)-round(maxi/2)-5:cen(2)+round(maxi/2)+5);
    [aa,bb] = size(raw_cell);
    if max(max(B{i}(:,1))-min(B{i}(:,1)),max(B{i}(:,2))-min(B{i}(:,2)))/min(max(B{i}(:,1))-min(B{i}(:,1)),max(B{i}(:,2))-min(B{i}(:,2)))<3
    cell = imresize(raw_cell,24/aa);
    else
        cell = zeros(24,24);
    end
    patches(1:24,1:24,1,i) = cell;
end
