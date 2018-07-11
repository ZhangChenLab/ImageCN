function FileGeneration(Path,filemane,frame_rate)
delta = round(frame_rate);
mkdir(strcat(Path,'\process'));
Pathnew = strcat(Path,'\process\');
File = strcat(Path,'\',filemane);
File_Reference_Image = strcat(Pathnew,'Reference_Image.tif');
File_Average_Image = strcat(Pathnew,'Average_Image.tif');
File_Cell_Outline = strcat(Pathnew,'Cell_Outline.tif');
File_Cell_Number = strcat(Pathnew,'Cell_Number.tif');
File_Intensity = strcat(Pathnew,'Intensity.mat');
File_Delta = strcat(Pathnew,'Delta_F.mat');
File_ROI_imov = strcat(Pathnew,'ROI_overlay.tif');
save([Pathnew,'\TempData.mat']);