%function [K,R,C] = decompose_P( P, alg_version )
%--------------------------------------------
% 2 variants ( modified QR and Givens rotations) 
% of decomposing the camera matrix P into intrinsic
% matrix K, rotation R and camera center C
%
% P = K * R * [ 1 | -C ]
%
% alg_version = 'modifiedQR' | 'Givens'
%
% check also the articles
% 
%   http://ksimek.github.io/2012/08/13/introduction/
% * http://ksimek.github.io/2012/08/14/decompose/
%   http://ksimek.github.io/2012/08/22/extrinsic/
%   http://ksimek.github.io/2013/08/13/intrinsic/
%
% (c) 2013 Ivo Ihrke, INRIA Bordeaux Sud-Ouest / Institute d'Optique
%


%%% ---------------- solution 1 - QR decomposition turned into RQ --------- 


function [K,R,C] = decompose_P( P, alg_version )


if ( ~exist('alg_version') )
    VERSION = 2;
else
    if ( strcmp( alg_version, 'modifiedQR' ) )
        VERSION = 1;
    end
    if ( strcmp( alg_version, 'Givens' ) )
        VERSION = 2;
    end
    if ( ~exist('VERSION') )
        fprintf(2,'decompose_P: unknown algorithm version, try "modifiedQR" or "Givens"\n')
        return;
    end
end

%extract camera center as null space
C = null(P);
    
%normalize homogeneous coordinate
C = C / C(4); 

%extract KR submatrix 
KR = P( 1:3, 1:3 );


if ( VERSION == 1 )


    %% !! we need the RQ decomposition !! -> the rotation matrix is
    %% multiplied from the left, not from the right as in the QR decomposition
    
    %decompose R'*K' = (KR)'
    
    Perm = [0 0 1; 0 1 0; 1 0 0];
    
    [Rt,Kt] = qr( (Perm * KR)');
    
    %compute un-transposed quantities
    R = Perm * Rt';
    
    K = Perm * Kt' * Perm;
    
end




if ( VERSION == 2 )


    % derivations according to Hanning "High Precision Camera
    % Calibration" p. 48 (habilitation thesis Passau Univ. 2009)


    tx = atan2( -P( 3, 2 ), P( 3, 3 ) );
    sx = sin( tx );
    cx = cos( tx );
    Qx = [ 1 0 0; 0 cx -sx; 0 sx cx];
    
    Pdash = P(1:3,1:3) * Qx;
    
    
    ty = atan2( Pdash( 3, 1 ), Pdash( 3, 3 ) );
    sy = sin( ty );
    cy = cos( ty );
    
    Qy = [ cy 0  sy; 0 1 0; -sy 0 cy]; 
    
    Pdashdash = P(1:3,1:3) * Qx * Qy;
    
    tz = atan2( -Pdashdash( 2, 1 ), Pdashdash( 2, 2 ) );
    sz = sin( tz );
    cz = cos( tz );
    
    Qz = [ cz -sz 0; sz cz 0; 0 0 1 ]; 
    
    
    R = Qz' * Qy' * Qx';
    K = P(1:3,1:3) * Qx * Qy * Qz;
    
end
 
%difference between decomposition and input matrix - comment out if you want to be sure
error = K * R * [eye(3), -(C(1:3))] - P;

%TEMP----------------02/03/2016
% disp('Error in the P decomposition');
% error;
%------------------------------

K*R*[eye(3) -C(1:3)];

if ( K(3,3) < 0 )
    K = K / K( 3, 3 );
    R = R * (-1);
else
     K = K / K( 3, 3 );
end

if ( K(1,1) < 0 )  %flip matrix
    K = K * [-1 0 0; 0 1 0; 0 0 1];
    R = [-1 0 0; 0 1 0; 0 0 1] * R; 
end

if ( K(2,2) < 0 )  %flip matrix
    K = K * [1 0 0; 0 -1 0; 0 0 1];
    R = [-1 0 0; 0 -1 0; 0 0 1] * R; 
end

K*R*[eye(3) -C(1:3)];