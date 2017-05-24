%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Tarea 7. Panoram:
%
% This file make a simple panoram out of 5 images which should be take from
% the same position, only changing the orientation of the camera.
%
% vgg_warp_H by David Liebovitz, Oxford RRG, dl@robots.ox.ac.uk, is used to
% re-sample and matching of the images.
%
% Three blending models are implemented: Darken, Lighten and Multiply.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Read Images
%%
% Adobe panoramas are used, because they provide homographies

addpath('imageStitchMatlab')
padsize=0;
Names = {'goldengate\goldengate-0', 'halfdome\halfdome-0', 'shanghai\shanghai-0'};
FileName = Names{1};

for i=1:5
  Projections(i) = {padarray(double(imread([FileName num2str(i) '.png'])),[padsize padsize])};
end

%% Projection to a common plane

% load homographies
for i=1:4
  i0=i;
  i1=i+1;
  eval(sprintf('load -ascii H%02dto%02d.txt; H%d%d=H%02dto%02d; clear H%02dto%02d', i1, i0, i1, i0, i1, i0, i1, i0));
end

% Define size of the new image
bbox = getBoundingBox([0 0 0 0], Projections(1:5), {inv(H32*H21), inv(H32), eye(3), (H43), (H43*H54)});
l = abs(bbox(1));    t = abs(bbox(4));
if strcmp(FileName,Names{1})
  bbox = bbox + [-l/4 -l/4 -t/2 t]; % Box fitting
elseif strcmp(FileName,Names{2})
  bbox = bbox + [-l/4 1.2*l -t/4 -t/8]; % Box fitting
elseif strcmp(FileName,Names{3})
  bbox = bbox + [-l/4 1.2*l -t/4 -t/8]; % Box fitting
end
%% Image warping

Background = 40;  % Parameter for the blending effectiveness

Im3w = vgg_warp_H(double(Projections{3}), eye(3), 'linear', bbox, Background);
Im2w = vgg_warp_H(double(Projections{2}), inv(H32), 'linear', bbox, Background);
Im4w = vgg_warp_H(double(Projections{4}), H43, 'linear', bbox, Background);
Im1w = vgg_warp_H(double(Projections{1}), inv(H32*H21), 'linear', bbox, Background);
Im5w = vgg_warp_H(double(Projections{5}), H43*H54, 'linear', bbox, Background);

figure(1);
imagesc(double(max(max(max(max(Im1w,Im2w), Im3w),Im4w),Im5w))/255); colormap gray; title('Darken image')

figure(2);
imagesc(double(min(min(min(min(Im1w,Im2w), Im3w),Im4w),Im5w))/255); colormap gray; title('Lighten image')

figure(3);
imagesc(Im1w.*Im2w.*Im3w.*Im4w.*Im5w/255); colormap gray; title('Multiply image')