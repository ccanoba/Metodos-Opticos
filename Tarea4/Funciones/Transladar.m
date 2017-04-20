function [X] = Transladar(X, T)

for ii = 1:3
  X(ii,:) = X(ii,:)+T(ii);
end
end