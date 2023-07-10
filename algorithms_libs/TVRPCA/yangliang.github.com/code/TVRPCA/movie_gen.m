load(['data' filesep 'badminton_tv_result']);

dataName = 'badminton'
moviename = [ dataName,'_E.avi']; fps = 12;
aviObj = VideoWriter(moviename);
open(aviObj);
[m,n,p] = size(ImData);

F_hat = abs(M_hat) / max(max(abs(M_hat)))>0.1;

start_frame = 1;
end_frame = 200;

for i = start_frame:end_frame
    figure(1); clf;
    subplot(1,3,1);
    imshow(uint8(ImData(:,:,i))), axis off, colormap gray; axis off;
    title('Original Image','fontsize',12);
    
   
    subplot(1,3,2);
    imshow(reshape(F_hat(:,i),m,n)), axis off,colormap gray; axis off;
    hold on; %contour(Mask(:,:,i),[0 0],'y','linewidth',5);
    title('TVRPCA Mask','fontsize',12);
    
    subplot(1,3,3);
    %imshow(reshape(B_hat(:,i),m,n)), axis off, colormap gray; axis off;    
    imshow(uint8(ImData(:,:,i)).*uint8(reshape(F_hat(:,i),m,n))), axis off, colormap gray; axis off;
    title('TVRPCA Foreground','fontsize',12);
    writeVideo(aviObj,getframe(1));
    %mov = addframe(mov,getframe(1));
end
close(aviObj);
%h = close(mov);