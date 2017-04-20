function savegif (F,gifname,delayT)

if nargin < 3
  delayT = 0;
end

[im,map] = rgb2ind(F(1).cdata,256,'nodither');

for i = 1:length(F)
  im(:,:,1,i) = rgb2ind(F(i).cdata,map,'nodither');
end

imwrite(im,map,[gifname '.gif'],'DelayTime',delayT,'LoopCount',inf);