%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Rayleigh Sommerfeld discrete diffraction
%
% This function calculates the propagated field of an input U1 using 
% Rayleigh Sommerfeld equation. Par for is used to improve processing time.
%
% Inputs :
%
% U1 : Input field
% Lx, Ly : Image size
% lambda : illumination wavelength
% Z : Propagation distance
%
% Outputs : 
%
% U2 : Propagated field
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [U2] = RS_Prop_Par(U1, Lx, Ly, lambda, Z)

k = 2*pi/lambda;        % Wavenumber
Sx = size(U1,2);
Sy = size(U1,1);
U2 = zeros(Sx,Sy);      % Initialize output field matriz
dx = Lx/Sx;             % sample interval
dy = Ly/Sy;             % sample interval
x = -Lx/2:dx:Lx/2-dx;   
x = repmat(x,1,Sy);     % src coords x
y = -Ly/2:dy:Ly/2-dy;   
y = repmat(y',1,Sx);
y = reshape(y',1,Sx*Sy);% src coords y

% Discrete Rayleigh Sommerfeld
parfor t = 1:Sx*Sy
    for h = 1:Sx*Sy
            U2(t) = U2(t) + (U1(h)*exp(1i*k*sqrt(Z^2+(x(t)-x(h))^2+(y(t)-y(h))^2))/...
                (Z^2+(x(t)-x(h))^2+(y(t)-y(h))^2));
    end
end

U2 = U2*Z/(1i*lambda);