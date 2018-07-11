function PeakDetection(Path,PeakThreshold)
%%
clear peak_location
Threshold=PeakThreshold;
load('cnn_peak');
load([Path,'\process\TempData.mat']);
[a,b]=size(filtered_intensity);
peak_mat=zeros(a,b);
smooth_intensity=filtered_intensity;
peak_location=zeros(a,b);
for k=1:b
    [peak,loc]=findpeaks(sig(:,k));
    peak(loc<=delta | loc>=a-delta)=[];
    loc(loc<=delta | loc>=a-delta)=[];
    loc(peak<Threshold)=[];
    peak(peak<Threshold)=[];
    del=[];
    for i=1:length(loc)
        if peak(i)-mean(sig(loc(i)-round(delta*0.6):loc(i)-round(delta*0.2),k)) < 0.1*Threshold
            del=[del,i];
        end
    end
    loc(del)=[];
    peak(del)=[];
    if ~isempty(loc)
        for i=1:length(loc)
            input_trace(:,i)=sig(loc(i)-20:loc(i)+19,k);
        end
        input_trace(input_trace<=0)=0.0001;
        input_trace=input_trace*10;
        input_trace(input_trace>1)=1;
        image_input=[];
        for i=1:length(loc)
            mask=zeros(40,40);
            for j=1:40
                mask(40-round(39*input_trace(j,i)),j)=1;
            end
            image_input(:,:,1,i)=mask;
        end
        results=[];
        if ~isempty(loc)
%             [results,scores] = classify(net,image_input);
            results=categorical([]);
        else
            results=categorical([]);
        end
        loc(double(results)==1)=[];
        peak(double(results)==1)=[];
        for i=1:length(loc)
            [raw_peak(i,1),tem_loc]=max(smooth_intensity(loc(i)-5:loc(i)+5,k));
            raw_loc(i,1)=loc(i,1)-6+tem_loc;
        end
        ii=0;
        if ~isempty(loc)
        raw_loc=raw_loc(:,1)';
        end
        for i=1:length(raw_loc)
            if (smooth_intensity(raw_loc(i),k)-smooth_intensity(raw_loc(i)-1,k))...
                *(smooth_intensity(raw_loc(i),k)-smooth_intensity(raw_loc(i)+1,k))<0
            raw_loc(i)=NaN;
            end
        end
        raw_loc(isnan(raw_loc))=[];
        for i=2:length(raw_loc) 
               if raw_loc(i-ii)-raw_loc(i-1-ii)<frame_rate/4
                  [raw_loc(i-1-ii),~]=max([raw_loc(i-1-ii),raw_loc(i-ii)]);
                  raw_loc(i-ii)=[];
                  ii=ii+1;
               end
        end
              plot(smooth_intensity(:,k))
              hold on
              plot(raw_loc,smooth_intensity(raw_loc,k),'r*','MarkerSize',5)
%               ginput(1);
%               close
        peak_mat(raw_loc,k)=1;
        if ~isempty(raw_loc)
         peak_location(1:length(raw_loc),k)=raw_loc';  
        end
    end
end
peak_m=max(peak_location,[],2);
peak_zero=find(peak_m>0,1,'last');
peak_location(peak_zero+1:end,:)=[];
save([Path,'\process\TempData.mat'],'peak_location','PeakThreshold','-append');