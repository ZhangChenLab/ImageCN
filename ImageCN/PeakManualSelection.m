function PeakManualSelection(Path)
%%
load([Path,'\process\TempData.mat']);
[a,b] = size(sig);
manual_loc = zeros(a,b);
screen = get(0,'ScreenSize');
% flip(screen*0.25,2)
screen = screen*0.75+flip(screen.*[0.1 0.1 0.05 0.4],2);
figure
set(gcf,'Position',screen)
k = 1;
while k <= b
    disp(['Cell No.',num2str(k),'...'])
    smooth_trace = filtered_intensity(:,k);
    trace_loc = peak_location(:,k);
    trace_loc(trace_loc == 0) = [];
    peak_value = smooth_trace(trace_loc);
    h1 = subplot('Position',[0.1 0.55 0.85 0.35]);
    plot(smooth_trace)
    title(['Cell No.',num2str(k)]);
    axis([0 a min(smooth_trace)*0.95 max(smooth_trace)*1.05])
    %     line([203,203],[min(smooth_trace)*0.85,max(smooth_trace)*1.1],'color','r')
    %     line([213,213],[min(smooth_trace)*0.85,max(smooth_trace)*1.1],'color','r')
    hold on
    plot(trace_loc,peak_value,'r*')
    hold off
    [x,y,z] = ginput;
    x = round(x);
    if ~isempty(x) && z(1) == 2
        k = k-1;
        if k<1
            fprintf(2,'This is the first calcium trace.\n')
            k=1;
        end
        trace_loc = peak_location(1:length(trace_loc),k);
        trace_loc(trace_loc == 0) = [];
        manual_loc(1:length(trace_loc),k) = trace_loc;
    else
        for i = 1:length(x)
            if z(i) == 1 %鼠标左键删除点
                [loc_delete,delete_p] = min(abs(trace_loc-x(i)));
                if loc_delete < 10
                    trace_loc(delete_p) = 0;
                    peak_value(delete_p) = 0;
                end
            elseif z(i) == 3 %鼠标右键增加点
                if x(i) > 5 && x(i) < a-5
                    [peak_p,add_p] = max(smooth_trace(x(i)-5:x(i)+5));
                    trace_loc = [trace_loc;x(i)-6+add_p];
                    peak_value = [peak_value;peak_p];
                elseif x(i) < 5
                    [peak_p,add_p] = max(smooth_trace(x(i):x(i)+5));
                    trace_loc = [trace_loc;x(i)-1+add_p];
                    peak_value = [peak_value;peak_p];
                elseif x(i) > a-5
                    [peak_p,add_p] = max(smooth_trace(x(i)-5:x(i)));
                    trace_loc = [trace_loc;x(i)-6+add_p];
                    peak_value = [peak_value;peak_p];
                end
            end
        end
        h2 = subplot('Position',[0.1 0.1 0.85 0.35]);
        plot(smooth_trace)
        title(['Cell No.',num2str(k)]);
        axis([0 a min(smooth_trace)*0.95 max(smooth_trace)*1.05])
        %     line([203,203],[min(smooth_trace)*0.85,max(smooth_trace)*1.1],'color','r')
        %     line([213,213],[min(smooth_trace)*0.85,max(smooth_trace)*1.1],'color','r')
        hold on
        plot(trace_loc,peak_value,'r*')
        hold off
        pause()
        cla(h1);cla(h2);
        %     close
        manual_loc(1:length(trace_loc),k) = trace_loc;
        k = k+1;
    end
end
save([Path,'\process\TempData.mat'],'manual_loc','-append');
disp('Done')
