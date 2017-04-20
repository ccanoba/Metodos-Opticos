function showVideo (F, n, frameRate)

if nargin < 3
  
  frameRate = 2;
  
  if nargin <2
    
    n = 1;
  end
  
end

for i = 1:length(F)*n
  figure(99), axis square, axis equal,
  k = mod(i,length(F));
  if k == 0
    k = length(F);
  end
  imagesc(F(k).cdata);
  pause(1/frameRate);
end

