function [ input_yingyong, Centroid_T, L ,TR3]  =  ANN_input(ref)
%%
xbadjust = ref;
[a,b] = size(xbadjust);
ssq = round((a+b)/20);
if a+b < 1000
    bw_size = 13;
else
    bw_size = 21;
end
se = strel('disk',bw_size);
xbdingmao = imsubtract(imadd(xbadjust,imtophat(xbadjust,se)),imbothat(xbadjust,se));
C = 0.02;
IM = xbdingmao;
mIM = imfilter(IM,fspecial('average',bw_size),'replicate');
sIM = IM-mIM-C;
bw = double(imbinarize(sIM,0));
% bw = imclearborder(bw,4);
bw = imopen(bw,strel('square', 2));
fill = imfill(bw);
xbbwareaopen  =  bwareaopen(fill,ssq);
BS = strel('square',2);
bw = imdilate(xbbwareaopen,BS);
D  =  -bwdist(~bw);
mask  =  imextendedmin(D,0.5);
D2  =  imimposemin(D,mask);
Ld2  =  watershed(D2,8);
bw(Ld2 =  = 0) = 0;
bw  =  bwareaopen(bw,round(ssq));
bw = imopen(bw,strel('disk', 1));
% imshow(bw,[])
%%
[B,L,~,~]  =  bwboundaries(bw,4);
regionprop1 = regionprops(L,ref,'Area','MajorAxisLength'...
    ,'MinorAxisLength','MeanIntensity','MaxIntensity','Centroid');
Out_combine = zeros(5,max(max(L))); % 面积 周长 短长轴比 原图mean 环形mean
Centroid = zeros(2,max(max(L)));
BS0 = strel('disk', 2);
BS1 = strel('disk', 6);
L_dilate_0 = imdilate(L,BS0);
length(B)
for  bb = 1:length(B)
    Out_combine(1,bb) = regionprop1(bb,1).Area;
    Out_combine(2,bb) = regionprop1(bb,1).MinorAxisLength/regionprop1(bb,1).MajorAxisLength;
    Out_combine(3,bb) = regionprop1(bb,1).MeanIntensity;
    Out_combine(4,bb) = regionprop1(bb,1).MaxIntensity;
    Centroid(1,bb)  = regionprop1(bb,1) .Centroid(:,1);
    Centroid(2,bb)  = regionprop1(bb,1) .Centroid(:,2);
    L_dilate = zeros(a,b);
    L_dilate(L =  = bb) = 1;
    L_dilate_2 = imdilate(L_dilate,BS1);
    L_dilate_1 = L_dilate_2-imdilate(L_dilate,BS0);
    L_dilate_1(L_dilate_0>0) = 0;
    while(max(max(L_dilate_1))) =  = 0
        L_dilate_2 = imdilate(L_dilate_2,BS1);
        L_dilate_1 = L_dilate_2-imdilate(L_dilate,BS0);
         L_dilate_1(L_dilate_0>0) = 0;
    end
    regionprop1_dilate = regionprops(L_dilate_1,ref,'MeanIntensity');
    Out_combine(5,bb) = regionprop1_dilate(1,1).MeanIntensity;
end
Out_combine_T = Out_combine;
Centroid_T = Centroid;
TR3 = sort(Out_combine_T(1,:),'descend');
input_yingyong = Out_combine_T([1 2 3 4 5],:);
area_norm = mean(TR3(4:5));
input_yingyong(1,:) = input_yingyong(1,:)/area_norm;
end