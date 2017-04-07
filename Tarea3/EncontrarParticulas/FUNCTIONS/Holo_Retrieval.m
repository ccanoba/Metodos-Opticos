function [ObjectReconstructed] = Holo_Retrieval(Ih, lambda, dxs, zs, zo)

%% Parameters:
Wavelength = lambda*1e6;%um
SensorPixel = [dxs, dxs]*1e6;%um
PointSensorDistance = zs*1e6;%um
PointObjectDistance = zo*1e6;%um

%% Load Resources
Hologram = Ih;

%% Prepair Hologram == Transform and interpolate 
[ModifiedHologram] = prepairHologram(Hologram, PointSensorDistance, SensorPixel, 1);

%% Reconstruct with convolution/Kreuzer
ObjectReconstructed = zeros([size(Hologram), length(zo)]);

for ii = 1:length(zo)
    ObjectPixel = (PointObjectDistance(ii)/PointSensorDistance)*SensorPixel;
    [ObjectReconstructed(:,:,ii)] = kreuzerConvolutionReconstruction(ModifiedHologram, ...
        Wavelength, PointSensorDistance,...
        PointObjectDistance(ii), ObjectPixel,...
        SensorPixel);
      disp(['Layer ' num2str(ii) ' at z = ' num2str(PointObjectDistance(ii)) ' um']);
end
% figure,
% imagesc(ObjectCoordinates.x(1,:), ObjectCoordinates.y(:,1), (abs(ObjectReconstructed)).^2)
% colormap gray, axis square, xlabel('X(um)'), ylabel('Y(um)'),title('Reconstructed intensity')
% set(gcf,'color','w');
% colorbar

%% Reconstruct with Fourier/Kreuzer
% [ObjectReconstructed] = kreuzerFourierReconstruction(ModifiedHologram, ...
%                             Wavelength, PointSensorDistance,...
%                             PointObjectDistance, SensorPixel);
% 
% FourierObjectPixel = Wavelength*PointSensorDistance./(size(Hologram,1)*SensorPixel);
% [FourierObjectCoordinates] = computeObjectCoordinates( size(Hologram,1), size(Hologram,2), FourierObjectPixel, PointObjectDistance );
% 
%                         
% figure,
% imagesc(FourierObjectCoordinates.x(1,:), FourierObjectCoordinates.y(:,1), (abs(ObjectReconstructed)).^2)
% colormap gray, axis square, xlabel('X(um)'), ylabel('Y(um)'),title('Reconstructed intensity')
% set(gcf,'color','w');
% colorbar
% axis square
end
