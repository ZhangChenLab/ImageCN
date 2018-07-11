function RefGeneration(Path)
clear Image_average Image_ref
load([Path,'\process\TempData.mat']);
[Image_average,Image_ref] = signal_fluctuation(File,delta);
figure;
imshow(Image_average);
imwrite(Image_average,File_Average_Image);
figure;
imshow(Image_ref);
imwrite(Image_ref,File_Reference_Image);
save([Path,'\process\TempData.mat'],'Image_average','Image_ref','-append');
