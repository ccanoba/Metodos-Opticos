%% Example Modified Fresnel propagator

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This example is used to compare the output of the modified Fresnel
% propagator and the clasical fresnel propagator
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clear,clc,close all

%% Set up
M = 128;                            % Array size 
A0 = zeros(M);                      
L = 1e-3;                           % Image size
z = 300e-3;                         % Propagation distance
lambda = 532e-9;                    % Illumination wavelength
dx=L/M;                             % sample interval
odx=15;                             % Factor in which pixel image plane size is scaled
k = 2*pi/lambda;                    %wavenumber

x = -L/2:dx:L/2-dx;
[X,Y] = meshgrid(x,x);              % Object plane coordinates system

A0(sqrt(X.^2+Y.^2)<=0.1e-3) = 1;   % Circular aperture 
% A0(64-20:65+20,64-20:65+20) = 1;    % Square aperture

propag = 0.05;                         % Propagation distance from the point source
SourcePhase = exp((1i*k*sqrt(X.^2+Y.^2+propag.^2)))./sqrt(X.^2+Y.^2+propag.^2); % Spherical wavefront phase

A0 = A0.*SourcePhase;               % Object field

figure, imagesc(x,x,abs(A0)), colorbar, colormap gray, title('Amplitude object field'), xlabel('x[m]'), ylabel('y[m]');
set(gcf,'Units', 'normalized', 'Position', [0 0.05 0.4 0.4]);
figure, imagesc(x,x,angle(A0)), colorbar, colormap gray, title('Phase object field'), xlabel('x[m]'), ylabel('y[m]');
set(gcf,'Units', 'normalized', 'Position', [0 0.5 0.4 0.4]);

%% Modified Fresnel propagator

[A, X2, Y2] = propF_Mod(A0, L, z, L*odx, lambda);

figure,imagesc(X2(1,:),X2(1,:),abs(A)),colorbar, colormap gray, title('Amplitude image field, Mod. Fresnel'), xlabel('x[m]'), ylabel('y[m]');
set(gcf,'Units', 'normalized', 'Position', [0.6 0.05 0.4 0.4]);

%% Fresnel propagator using impulse response
[u2] = propIR(A0,L*2,lambda,z);

figure,imagesc(x,x,abs(u2)),colorbar, colormap gray, title('Amplitude image field, Fresnel'), xlabel('x[m]'), ylabel('y[m]');
set(gcf,'Units', 'normalized', 'Position', [0.6 0.5 0.4 0.4]);
