%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function find particles from a contrast Hologram
%
% Some parameters are needed:
%
% name: name of the hologram file
% zs : source detector distance
% lambda : illumination wavelength
% PixelSize : Sensor pixel size
% Manual : Whether or not the user want to choose the presence of particles
% manually
%
% Some adittional values have to be set for the filtering and binarization
% process, they are called Factor1 and Factor2 and are defined form 0 to 1
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Read and prepare image

addpath('FUNCTIONS')

name = 'ejemplo1';
zs = 6e-3;                  % Source detector distance
lambda = 405e-9;            % Ilumination wavelength
PixelSize = 6e-6;           % Sensor pixel size
Manual = 0;                 % Whether or not particle identification is done by the user

if strcmp(name, 'ejemplo1')
  HoloCont = imread('Ejemplos/holo.pgm');
  HoloCont = double(HoloCont);
  zs = 6e-3;
  lambda = 405e-9;
  PixelSize = 6e-6;
  Manual = 0;
elseif strcmp(name, 'ejemplo2')
  HoloCont = imread('Ejemplos/holo.tiff');
  HoloCont = double(HoloCont);
  zs = 8e-3;
  lambda = 405e-9;
  PixelSize = 6e-6;
  Manual = 0;
else
  HoloCont = imread(name);
  HoloCont = double(HoloCont);
end

%% Reconstruction of several planes

if strcmp(name, 'ejemplo1')
  StartPlane = 90e-6;             % Plane in which starts to look for particles
  EndPlane = 210e-6;              % Plane in which finish to look for particles
  SamplePlane = 2e-6;             % Sample intervale in which finish look for particles
elseif strcmp(name, 'ejemplo2')
  StartPlane = 180e-6;             % Plane in which starts to look for particles
  EndPlane = 220e-6;              % Plane in which finish to look for particles
  SamplePlane = 2e-6;             % Sample intervale in which finish look for particles
else
  StartPlane = 180e-6;             % Plane in which starts to look for particles
  EndPlane = 220e-6;              % Plane in which finish to look for particles
  SamplePlane = 2e-6;             % Sample intervale in which finish look for particles
end

Planes = StartPlane:SamplePlane:EndPlane;                                       % Planes vector list
disp('Reconstruction of interest planes');
tic
ObjectReconstructed = Holo_Retrieval(HoloCont, lambda, PixelSize, zs, Planes);  % Reconstruction of the different planes of interest
ObjectReconstructed = abs(ObjectReconstructed).^2;                              % It is better to work with the intensity
tiempo = toc;
disp(['The reconstruction took ' num2str(tiempo) ' s']);
%% Particles identification

disp('Finding particles');
% Objects projection
ObjectProj = sum(ObjectReconstructed,3);
ObjectProj = ObjectProj/max(ObjectProj(:));
ObjectProj = squeeze(ObjectProj);
figure,imagesc(abs(ObjectProj).^2), colorbar, colormap gray, axis square, xlabel('Pixel in X'), ylabel('Pixel in Y'), title('Projection: Reconstructed planes superposition')

% Image filtering
FObject = fftshift(fft2(fftshift(ObjectProj)));
xt = linspace(-1,1,size(ObjectProj,1));
[Xt,Yt] = meshgrid(xt);
[T,R] = cart2pol(Xt,Yt);
if strcmp(name, 'ejemplo1')
  Factor1 = 0.1;
elseif strcmp(name, 'ejemplo2')
  Factor1 = 0.05;
else
  Factor1 = 0.1;
end
mask = R>Factor1;
FilteredObjectProj = fftshift(ifft2(fftshift(FObject.*mask)));
FilteredObjectProj = abs(FilteredObjectProj).^2;
FilteredObjectProj = FilteredObjectProj/max(FilteredObjectProj(:));
figure,imagesc(FilteredObjectProj), colorbar, colormap gray, axis square, xlabel('Pixel in X'), ylabel('Pixel in Y'), title('Filtered projection')

% Image binarization
if strcmp(name, 'ejemplo1')
  Factor2 = 0.1;
elseif strcmp(name, 'ejemplo2')
  Factor2 = 0.5;
else
  Factor2 = 0.1;
end
Points1 = FilteredObjectProj > Factor2;

% Automatic particle identification

if Manual == 0
  se = strel('disk',5);
  bw = imclose(Points1,se);
  figure,imagesc(bw), colorbar, colormap gray, axis square, xlabel('Pixel in X'), ylabel('Pixel in Y'), title('Binarized projection')
end

% Selection of particles
if Manual == 1
  figure, imagesc((Points1-1)*-1), colorbar, colormap gray, axis square, xlabel('Pixel in X'), ylabel('Pixel in Y'), title('Binarized projection')
  uiwait(msgbox('Select points to evaluate'));
  [px,py] = ginput;
  px = round(px); py = round(py);
end
%% Centroid calculation

if Manual == 1
  
  Xc=zeros(1,length(px));
  Yc=zeros(1,length(py));
  ROIc = 10;
  
  for p = 1:length(px);
    for q = -ROIc:ROIc
      for r = -ROIc:ROIc
        Xc(p) = Xc(p)+abs(Points1(py(p)+q,px(p)+r)*(px(p)+r));
      end
    end
    
    Xc(p) = Xc(p)/sum(sum(abs(Points1(py(p)-ROIc:py(p)+ROIc,px(p)-ROIc:px(p)+ROIc))));
    
    for q = -ROIc:ROIc
      for r = -ROIc:ROIc
        Yc(p) = Yc(p)+abs(Points1(py(p)+q,px(p)+r)*(py(p)+q));
      end
    end
    
    Yc(p) = Yc(p)/sum(sum(abs(Points1(py(p)-ROIc:py(p)+ROIc,px(p)-ROIc:px(p)+ROIc))));
  end

end
% Automatic centroid calculation
if Manual == 0
  PointR = bwconncomp(bw);
  Xc=zeros(1,PointR.NumObjects);
  Yc=zeros(1,PointR.NumObjects);
  PointLoc = regionprops(PointR,'Centroid');
  for p = 1:PointR.NumObjects
    Dato = PointLoc(p).Centroid;
    Xc(p) = Dato(1); Yc(p) = Dato(2);
  end
end

%% Find z position

disp([num2str(PointR.NumObjects) ' particles were found']);

Xcr = round(Xc); Ycr = round(Yc);
z = Planes; z2 = linspace(StartPlane,EndPlane,500);
ILine = zeros(1,length(Planes),length(Xcr));
ILine2 = zeros(1,length(z2),length(Xcr));
PointPlane = zeros(1, length(Xcr));
ROIc = 10;

for p = 1:length(Xcr)
  ObjectROIc = ObjectReconstructed(Ycr(p)-ROIc:Ycr(p)+ROIc,Xcr(p)-ROIc:Xcr(p)+ROIc,:);
  ObjectROIc = sum(sum(ObjectROIc,1),2);
  ILine(:,:,p) = ObjectROIc;
  curve = ILine(:,:,p);
  f = fit(z',curve','gauss2');
  a1 = f.a1; a2 = f.a2; b1 = f.b1; b2 = f.b2; c1 = f.c1; c2 = f.c2;
  gauss=a1.*exp(-((z2-b1)./(c1)).^2) + a2.*exp(-((z2-b2)./(c2)).^2);
  ILine2(:,:,p) = gauss;
  if PointR.NumObjects <= 30
  figure(99), plot(z,ILine(:,:,p),'b*'), hold on,plot(z2,gauss,'r');
  end
end

[~,PointPlane] = max(ILine2,[],2);
PointPlaneZ = z2(PointPlane)*1e6;

ObjectPixel = (PointPlaneZ/zs)*PixelSize;
PointXcoor = (Xcr-size(HoloCont,2)/2).*ObjectPixel;
PointYcoor = -(Ycr-size(HoloCont,2)/2).*ObjectPixel;

Coordinates = [PointXcoor' PointYcoor' PointPlaneZ'];


if strcmp(name, 'ejemplo1')
  figure,plot3(PointXcoor', PointYcoor', PointPlaneZ', 'ob')
  load('Ejemplos/Pts_XYZ.mat')
  hold on,plot3(Points_XYZ(:,1), Points_XYZ(:,2), Points_XYZ(:,3), 'or'), hold off,
  axis square, xlabel('x[\mum]'), ylabel('y[\mum]'), zlabel('z[\mum]'),grid on, title('Found particles')
  legend('Found positions', 'Real Positions','Location','North')
else
  figure,plot3(PointXcoor', PointYcoor', PointPlaneZ', 'o')
  axis square, xlabel('x[\mum]'), ylabel('y[\mum]'), zlabel('z[\mum]'),grid on, title('Found particles')
end
