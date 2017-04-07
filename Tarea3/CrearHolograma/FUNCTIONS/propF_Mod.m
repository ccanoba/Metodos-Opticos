%% Modified Fresnel propagator

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function calculates the propagated field, for an input A0 at a
% distance z, where the pixel size in the propagated image plane is odx
% times the pixel size in the object plane.
%
% The method used is a modificated Fresnel propagator available in:
% [1] "Diffraction-based modeling of high-numerical-aperture in-line lensless
% holograms", John F. Restrepo and Jorge Garcia-Sucerquia.
%
% Inputs : 
%
% A0 : Input field to be propagated
% L : Object size
% z : Propagation distance
% L2 : Image plane size
% lambda : illumination wavelength
% interpolar : Ask whether an interpolation should be performed or not
%
% Output :
% 
% A : Propagated field
% X2, Y2 : Image propagated plane coordinates
%
% Note : The input image has to be square
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [A, X2, Y2] = propF_Mod(A0, L, z, L2, lambda, interpolar)
%% Setup
M = size(A0,1);   % Size of the input image
dx = L/M;           % Pixel size object plane
dx2 = L2/M;       % Pixel size image plane
k = 2*pi/lambda;    % wavenumber

x = -L/2:dx:L/2-dx;     
[X,Y] = meshgrid(x,x);  % Object plane coordinates system

x2 = -L2/2:dx2:L2/2-dx2;
[X2,Y2] = meshgrid(x2,x2);  % Image plane coordenates system

xp = X2./sqrt(1-((X2.^2+Y2.^2)/(z^2)));
yp = Y2./sqrt(1-((X2.^2+Y2.^2)/(z^2))); % Non linear artificial coordinates system

R = sqrt(z^2+xp.^2+yp.^2);  % Approximation to the amplitude of R, described as R' in class

%% Modificated Fresnel propagator [1]
F2 = exp((1i*k./(2*R)).*(X.*xp+Y.*yp)); 
F1 = A0.*exp(((1i*k)./(2*z))*(X.^2+Y.^2)).*exp((-1i*k./(2*R)).*(X.*xp+Y.*yp));
F2 = padarray(F2,[size(F2,1)/2 size(F2,2)/2],'both');   % Padded variable for DFT Sampling
F1 = padarray(F1,[size(F1,1)/2 size(F1,2)/2],'both');   % Padded variable for DFT Sampling

fF1 = fftshift(fft2(fftshift(F1)));
fF2 = fftshift(fft2(fftshift(F2)));

Convolucion = fftshift(ifft2(fftshift(fF1.*fF2)));
Convolucion = Convolucion(size(A0,1)/2+1:size(A0,1)/2+size(A0,1),size(A0,2)/2+1:size(A0,2)/2+size(A0,2));

PhaseA = (exp(1i*k*R)./(1i*lambda*R))*exp((1i*k./(2*R).*(X.*xp+Y.*yp)));
AmpA = Convolucion;
%% Data interpolation
if interpolar == 1
    % Interpolates data from the non linear coordinates system to the image plane coordenates system
    A = griddata(xp,yp,abs(AmpA),X2,Y2);
else
    % Interpolation is not performed, it should be done in a further step
    A = abs(AmpA);
end

end