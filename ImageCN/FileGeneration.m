function FileGeneration(Path,filemane,frame_rate)
delta = round(frame_rate);
if exist([Path,'\process'])==0
    mkdir(strcat(Path,'\process'));
end
Pathnew = strcat(Path,'\process\');
File = strcat(Path,'\',filemane);
disp(['Processing: ',File])
File_Reference_Image = strcat(Pathnew,'Reference_Image.tif');
File_Average_Image = strcat(Pathnew,'Average_Image.tif');
File_Cell_Outline = strcat(Pathnew,'Cell_Outline.tif');
File_Cell_Number = strcat(Pathnew,'Cell_Number.tif');
File_Intensity = strcat(Pathnew,'Intensity.mat');
File_Delta = strcat(Pathnew,'Delta_F.mat');
File_ref_imov = strcat(Pathnew,'ROI_ref_overlay.tif');
File_ave_imov = strcat(Pathnew,'ROI_ave_overlay.tif');
% if exist([Pathnew,'\TempData.mat'])==0
%     save([Pathnew,'\TempData.mat']);
% end
if exist([Path,'\process\TempData.mat'])
    save([Path,'\process\TempData.mat'],'-append');
else
    save([Path,'\process\TempData.mat']);
end
disp('Done')