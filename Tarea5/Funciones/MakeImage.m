%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% This function calculates the image for a set of cameras (camera) and the
% scene defined by X and L.
%
% The output are the images saved as frames.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [F, P, IM] = MakeImage(X,L,camera)

for i = 1:length(camera)
  P{i} = camera{i}.P;
  u = camera{i}.P * X;
  u = u./repmat(u(3,:),3,1);
  
  figure(2)
  clf
  plot(u(1,:),u(2,:),'k.','MarkerFaceColor','white')
  hold on
  for j=1:size(L,1),
    line([u(1,L(j,:))],[u(2,L(j,:))],'LineWidth',1);
  end
  
  axis ij
  axis equal
  axis([0 camera{i}.width 0 camera{i}.height])
  grid on;
  title('Projection to the camera, units are pixels')
  
  figure(2)
  set(gca,'Position',[0 0 1 1])
  axis off
  grid off;
  im = getframe(gcf);
  F(i) = im;
  IM{i} = im.cdata;
  IM{i} = imresize(IM{i},[camera{i}.height,camera{i}.width],'bilinear');
  IM{i} = rgb2gray(IM{i});
end