%% Rayleigh Sommerfeld discrete diffraction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
% This function calculates the propagated field of an input U1 using 
% Rayleigh Sommerfeld equation.
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

function [U2] = RS_Prop(U1, Lx, Ly, lambda, Z)

%% Set up
k = 2*pi/lambda;        % Wavenumber
Sx = size(U1,2);    
Sy = size(U1,1);
U2 = zeros(Sx,Sy);      % Initialize output field matriz
dx = Lx/Sx;             % sample interval
dy = Ly/Sy;             % sample interval
x = -Lx/2:dx:Lx/2-dx;   % src coords x
y = -Ly/2:dy:Ly/2-dy;   % src coords y

%% Discrete Rayleigh Sommerfeld
for r = 1:Sx
    for s = 1:Sy
        for p = 1:Sx
            for q = 1:Sy
                U2(s,r) = U2(s,r) + (U1(q,p)*exp(1i*k*sqrt(Z^2+(x(r)-x(p))^2+(y(s)-y(q))^2))/...
                                        (Z^2+(x(r)-x(p))^2+(y(s)-y(q))^2));
            end
        end
    end
end

U2 = U2*Z/(1i*lambda);