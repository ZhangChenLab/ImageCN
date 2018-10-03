function [patches,L]  =  CNN_ref_input(Image_ref,Image_average,diameter)
%%
ref = imadjust(Image_ref,stretchlim(Image_ref,0),[0,1],1);
[a,b] = size(ref);
% ssq = round((a+b)/300)^2;
ssq = round(diameter*2/1.8);
if a+b<1000
    bw_size = 9;
    dm = 10;
    dm_open = 1;
    bw_dia = 1;
else
    bw_size = 17;
    dm = 10;
    dm_open = 2;
    bw_dia = 2;
end
se_dm = strel('disk',dm);
xbdingmao = imsubtract(imadd(ref,imtophat(ref,se_dm)),imbothat(ref,se_dm));
% xbdingmao = imopen(xbdingmao,strel('disk',dm_open));
C = 0.10;
IM = xbdingmao;
mIM = imfilter(IM,fspecial('average',bw_size),'replicate');
sIM = IM-mIM-C;
sIM = imopen(sIM,strel('disk',dm_open));
sIM = imfilter(sIM,fspecial('average',3),'replicate');
bw = double(imbinarize(sIM,0));
% imshow(sIM,[])
bw = imopen(bw,strel('square',dm_open));
fill = imfill(double(bw));
xbbwareaopen  =  bwareaopen(fill,ssq);
bw = imdilate(xbbwareaopen,strel('square',bw_dia));
D  =  -bwdist(~bw);
mask  =  imextendedmin(D,0.5);
D2  =  imimposemin(D,mask);
Ld2  =  watershed(D2,8);
bw(Ld2 == 0) = 0;
if a+b > 1000
    bw = imopen(bw,strel('disk',2));
    bw = imopen(bw,strel('disk',1));
    bw = imerode(bw,strel('square',1));
    bw  =  bwareaopen(bw,round(ssq/0.50));
    bw = imerode(bw,strel('disk',1));
else
    bw = imopen(bw,strel('disk',1));
    bw = imopen(bw,strel('square',1));
%     bw = imerode(bw,strel('square',1));
    bw  =  bwareaopen(bw,round(ssq/0.50));
end
bw = imclearborder(bw,8);
[~,L] =  bwboundaries(bw);
regionprop1 = regionprops(imerode(L,strel('disk',1)),Image_average,'MeanIntensity');
regionprop2 = regionprops(imerode(L,strel('disk',1)),ref,'MeanIntensity');
for  bb = 1:length(regionprop1)
    Out_combine1 = regionprop1(bb).MeanIntensity;
    Out_combine2 = regionprop2(bb).MeanIntensity;
    if Out_combine1>0.50 || Out_combine2<0.10
        L(L == bb) = 0;
    end
end
[B,L] =  bwboundaries(L);
% outline_temp = L*0;
% for i = 1:length(B)
%     outline = B{i};
%     for j = 1:length(outline)
%         outline_temp(outline(j,1),outline(j,2)) = 1;
%     end
% end
% imov = imoverlay(Image_ref,outline_temp,'r');
% imshow(imov)
% imov = imoverlay(Image_average,outline_temp,'cyan');
% figure
% imshow(sIM,[])
%%
[B,L] =  bwboundaries(L);
for ii = 1:max(max(L))
    mask_bw = zeros(size(bw));
    mask_bw(L == ii) = 1;
    %     imshow(mask_bw)
end
[a,b] = size(ref);
ref_mask = xbdingmao;
append_row = zeros(15,b);
append_column = zeros(a+30,15);
ref_mask = [append_row;ref_mask;append_row];
ref_mask = [append_column,ref_mask,append_column];
for  ii = 1:length(B)
    mask_rgb = repmat(ref,1,1,3);
    for j = 1:length(B{ii})
        mask_rgb(B{ii}(j,1),B{ii}(j,2),1) = 1;
        mask_rgb(B{ii}(j,1),B{ii}(j,2),2:3) = 0;
    end
%     [x,y,z] = ginput(1);%鼠标左键（1）是错误，右键（3）是正确
    % cen = round([mean(min(B{1}(:,1)),max(B{1}(:,1))),mean(min(B{1}(:,2)),max(B{1}(:,2)))]);
    cen = round([mean(B{ii}(:,1)),mean(B{ii}(:,2))])+15;
    maxi = max(max(B{ii}(:,1))-min(B{ii}(:,1)),max(B{ii}(:,2))-min(B{ii}(:,2)));
    if cen(1)+round(maxi/2)+5>a+30 || cen(2)+round(maxi/2)+5>b+30
            maxi = min(2*(a+30-5-cen(1)),2*(b+30-5-cen(2)));
    end
    if cen(1)-round(maxi/2)-5<= 0|| cen(2)-round(maxi/2)-5<= 0
            maxi = min(2*cen(1)-12,2*cen(2)-12);
    end
    ref_minus = ref_mask;
    L_cov = [append_row;L;append_row];
    L_cov = [append_column,L_cov,append_column];
    ref_minus(L_cov~= ii & L_cov>0) = 0;
    raw_cell = ref_minus(cen(1)-round(maxi/2)-5:cen(1)+round(maxi/2)+5,cen(2)-round(maxi/2)-5:cen(2)+round(maxi/2)+5);
    [aa,bb] = size(raw_cell);
    if max(max(B{ii}(:,1))-min(B{ii}(:,1)),max(B{ii}(:,2))-min(B{ii}(:,2)))/min(max(B{ii}(:,1))-min(B{ii}(:,1)),max(B{ii}(:,2))-min(B{ii}(:,2)))<3
    cell = imresize(raw_cell,24/aa);
    else
        cell = zeros(24,24);
    end
    patches(1:24,1:24,1,ii) = cell;
end