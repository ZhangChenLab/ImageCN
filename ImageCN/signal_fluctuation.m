function [Image_average,Image_ref] = signal_fluctuation(File,delta)
%%
n = 2;
d0 = 80;
frame_smooth = 0.3;
INFO = imfinfo(File);
t = size(INFO);
a = INFO(1).Height;
b = INFO(1).Width;
stack_num = ceil(t(1,1)/(delta*10));
Image_filter = zeros(a,b,stack_num);
stack_per=delta*10;
im_start = 1;
smooth_trace = ceil(frame_smooth*delta);
if a+b<= 1024
    ave = 2;
    se1 = strel('disk',2);
else
    ave = 3;
    se1 = strel('disk',2);
end
u0 = round(a/2);
v0 = round(b/2);
for i = 1:a
    for j = 1:b
        d = sqrt((i-u0)^2+(j-v0)^2);
        h(i,j) = 1/(1+0.414*(d/d0)^(2*n));
    end
end
fprintf('\n')
for stack_round = 1:stack_num
%     disp(['Processing:',num2str(stack_round),'/',num2str(stack_num),'...'])
    hint = 'Processing: %d/%d...\n';
    fprintf(hint,stack_round,stack_num)
%     stack_round
    if t(1,1)-im_start>= stack_per
        stack_per = delta*10;
    else
        stack_per = t(1,1)-im_start+1;
    end
    sig = zeros(a,b,stack_per);
    stack = zeros(a,b,stack_per);
    Image_average = zeros(a,b);
    uu = 0;
    for u = im_start:im_start+stack_per-1
        uu = uu+1;
        stack(:,:,uu) = im2double(imread(File,u));
        Image_average = Image_average+stack(:,:,uu);
        stack(:,:,uu) = imclose(filter2(fspecial('average',[ave ave]),stack(:,:,uu)),se1);
        I = stack(:,:,uu);
        I2 = I;
        f = double(I2);
        k = fft2(f);
        g = fftshift(k);
        y = h.*g;
        y = ifftshift(y);
        E1 = ifft2(y);
        E2 = (real(E1));
        stack(:,:,uu) = E2;
    end
    for i = 1:a
        for j = 1:b
            F = smooth(stack(i,j,:),smooth_trace);
            sig(i,j,1:end) = F;
        end
    end
    sig = sig-mean(sig,3);
    for i = 1:stack_per
        sig(:,:,i) = sig(:,:,i)-mean2(sig(:,:,i));
    end
    difm = max(sig(:,:,:),[],3);
    Image_filter(:,:,stack_round) = difm;
    im_start = im_start+stack_per;
end
Image_average = Image_average/t(1,1);
Image_average = imadjust(Image_average,[min(min(Image_average)),max(max(Image_average))],[0,1]);
Image_filter_max = max(Image_filter,[],3);
if a+b<1200
    se2=strel('disk',1);
else
    se2=strel('disk',2);
end
fprintf('\n')
%%
Image_open = imopen(Image_filter_max,se2);
Image_ref = imadjust(Image_open,stretchlim(Image_open,0));
% imshow(Image_ref)
% imwrite(Image_ref,File_Reference_Image);