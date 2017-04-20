%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Tarea 3, Generation of cameras.
%
% There are two examples:
% 
% 1. A panoramic of an scene
% 2. Dolly zoom of an scene
%
% There are 10 posible objects which can be place in the scene.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parameters initaialization

close all

addpath('Objetos')
addpath('Funciones')

% Scene parameters initialization
scenename_list1 = {'Poly', 'peaks', 'house', 'sphere', 'pyramid'};
scenename_list2 = {'cube', 'diamond', 'dodecahedron', 'humanoid_tri', 'teapot'};
SceneProperties = struct('w',[],'h',[],'l',[],'N',[],'T',[],'A',[],'ScaleFactor',[]);


% Camera parameters

look_at = [-5, 5, 0]; % Look at for the panoramic example. Can be change for any other
% look_at = [0,0,0];  % Look at for the dolly effect example
sky = [0,-1,0];       % Do not change it.
foclen = 1;           % Focal length of the camera
position = [0, 0, 0]; % Camera position for single shot (If you do not define options camera it makes a single image for the camera position defined in this line)
FOV = 70;             % Field of view
Panoramica = [15,0,10]; % Radial distance to the observation point, Elevation of the camera, Number of images in the panoramic
Dolly = {[logspace(1.3,2,20)],20}; % Positions range, scene width

%% Create Scene

% Load or create scene
SceneType = 2;     % if SceneType = 1 create scene with genscene, if SceneType = 2 load .obj file

% For generated scene

% T Indicates tranlation
% A for rotation
% ScaleFactor to scale object
if SceneType == 1
  scenename = {scenename_list1{1}};
  SceneProperties.w = 4;
  SceneProperties.h = 4;
  SceneProperties.l = 4;
  SceneProperties.N = 20;
  SceneProperties.T = [0 0 0];
  SceneProperties.A = [0 0 0];
  SceneProperties.ScaleFactor = 1;
end

% For .obj load scene

% T Indicates tranlation
% A for rotation
% ScaleFactor to scale object
if SceneType == 2
scenename = {};
scenename(1) = {[scenename_list2{5} '.obj']};
SceneProperties(1).T = [0 0 0];
SceneProperties(1).A = [0 0 pi/2];
SceneProperties(1).ScaleFactor = 1/50;

scenename(2) = {[scenename_list2{3} '.obj']};
SceneProperties(2).T = [-8 8 0];
SceneProperties(2).A = [0 0 0];
SceneProperties(2).ScaleFactor = 4;
end

% Generates scene
[X, L] = Gen_Scene (scenename,SceneProperties,SceneType);

% Display scene
fig = display3Dscene([],X,L);
axis([min(X(1,:)),max(X(1,:)),min(X(2,:)),max(X(2,:)),min(X(3,:)),max(X(3,:))])
view([45 45])

%% Create cameras

% Panoramic example
camera = cameras(look_at, sky, foclen, position, FOV, 'panoramic', Panoramica);

% Dolly zoom example
% camera = cameras(look_at, sky, foclen, position, FOV, 'dolly', Dolly);

% Single shoot example
% camera = cameras(look_at, sky, foclen, position, FOV);

disp('Generating cameras')

%% Make projections

[F, P, IM] = MakeImage(X,L,camera);
%% Show results

showcams(fig,foclen,P,IM);
axis('tight')
print('-dpng','-r96','-cmyk','3D_scene_with_cams_ejemplo1.png')

showVideo (F, 2, 5);

%% Save data

disp('Saving data')

v=VideoWriter('ejemplo1.avi');
v.FrameRate=10;
open(v);
writeVideo(v,F);
close(v)

savegif(F,'ejemplo1');

