function [X] = rotar (X, A)

rot1 = nfi2r( [0 0 1], A(1) );
rot2 = nfi2r( [0 1 0], A(2) );
rot3 = nfi2r( [1 0 0], A(3) );

rot = rot1*rot2*rot3;

tmp = X(1:3,:)'*rot; 
X(1:3,:) = tmp';

end