function Peak3D(Path)
%%
load([Path,'\process\TempData.mat']);
[a,b]=size(filtered_intensity);
mean_int=mean(filtered_intensity);
mean_mat=repmat(mean_int,a,1);
inten=(filtered_intensity-mean_mat)./mean_mat;
figure
hold on
surf(inten)
shading interp
for k=1:b
    raw_loc=peak_location(:,k);
    raw_loc(raw_loc==0)=[];
    x=repmat(k,length(raw_loc),1);
    scatter3(x,raw_loc,inten(raw_loc,k),4,'filled','r')
end
view(65, 45);
