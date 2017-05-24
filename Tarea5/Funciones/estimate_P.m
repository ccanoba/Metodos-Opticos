% function P = estimate_P( pts_2D, pts_3D )
% -----------------------------------------
%
% pts_2D = [ x1 y1; x2 y2; x3 y3; ... ]         - image coordinates
% pts_3D = [ X1 Y1 Z1; X2 Y2 Z2; X3 Y3 Z3; ...] - world space coordinates
%
% implements the (unnormalized) DLT algorithm for estimating the 
% camera matrix P from 2D-3D point correspondences 
%
% (c) 2013 Ivo Ihrke, INRIA Bordeaux Sud-Ouest / Institute d'Optique
%  
function P = estimate_P( pts_2D, pts_3D )


X = pts_3D( :, 1 );
Y = pts_3D( :, 2 );
Z = pts_3D( :, 3 );

x = pts_2D( :, 1 );
y = pts_2D( :, 2 );

A = [ -X -Y -Z -ones(length(X),1)  zeros(length(X),4)   X.*x Y.*x Z.*x x; ...
      zeros(length(X),4)  -X -Y -Z -ones(length(X),1)   X.*y Y.*y Z.*y y ];

[U,D,V] = svd(A);

pvec = V(:,end);

P = [pvec(1:4)'; pvec(5:8)'; pvec(9:12)' ];
