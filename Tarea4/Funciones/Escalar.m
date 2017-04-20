function [X] = Escalar(X,ScaleFactor)

X(1:3,:) = X(1:3,:).*ScaleFactor;

end