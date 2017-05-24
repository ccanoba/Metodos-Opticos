function [PtsOut] = ArrangePts(PtsIn, Plano)

PtsOut = zeros(size(PtsIn));

if strcmp(Plano,'XY')
  
  PtsOut(2,:) = PtsIn(1,:);
  PtsOut(1,:) = fliplr(PtsIn(2,:));
  
elseif strcmp(Plano,'YZ')
  
  PtsOut(3,:) = PtsIn(2,:);
  PtsOut(2,:) = fliplr(PtsIn(3,:));
  
elseif strcmp(Plano,'XZ')
  
  PtsOut(3,:) = PtsIn(1,:);
  PtsOut(1,:) = fliplr(PtsIn(3,:));
  
end
  
end