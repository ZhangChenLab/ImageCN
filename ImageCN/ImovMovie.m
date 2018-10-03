load([Path,'\process\TempData.mat']);
[B_ref,L_ref]= bwboundaries(L_ref);
outline_ref=0*L_ref;
for i=1:length(B_ref)
    outline=B_ref{i};
    for j=1:length(outline)
        outline_ref(outline(j,1),outline(j,2))=1;
    end
end
for i=1:500
    imov=imread([Path,filemane],i);
    imov = imadjust(imov,stretchlim(imov,0),[]);
    imov=imoverlay(imov,outline_ref,'r');
    imwrite(imov,'F:\data\software\responive map\test_ref.tif','writemode','append');
end
sprintf('done')
% imshow(imov)
% imwrite(imov,File_ROI_imov);