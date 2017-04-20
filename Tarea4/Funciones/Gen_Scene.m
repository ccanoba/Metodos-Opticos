%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function creates an scene.
%
% Inputs :
%
% scenenme : Cell array with the strings of the name for the different
%            objects to be place in the scene
% Scenproperties : Parameters related to the scene generation. 
%                  Scale Factor of the object
%                  Translation of the object
%                  Rotation of the object
%                  Geometrical parameters for object generation using
%                  genscene
% SceneType: Select the method to generate the objects, 1 for genscene, 2
%            to load obj file.
%
% Output :
% 
% X, L : Point coordinates and conection lines for the scene
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [X, L] = Gen_Scene (scenename,SceneProperties,SceneType)

Xtmp = [0 0 0 0]';
Ltmp = [0 0];

for ii = 1 : length(scenename)
  switch SceneType
    
    case 1      
      [X,L] = genscene(scenename{ii}, SceneProperties(ii));
      X(4,:) = 1;
      [X] = Escalar(X,SceneProperties(ii).ScaleFactor);
      [X] = rotar (X, SceneProperties(ii).A);
      [X] = Transladar(X, SceneProperties(ii).T);
    case 2
      [X, L] = read_Obj(scenename{ii});
      [X] = Escalar(X,SceneProperties(ii).ScaleFactor);
      [X] = rotar (X, SceneProperties(ii).A);
      [X] = Transladar(X, SceneProperties(ii).T);
    otherwise
      disp ('Not valid option')
  end
  Xtmp = [Xtmp, X];
  Ltmp = [Ltmp; L+(max(Ltmp(:)))];
end

Xtmp(:,1) = [];
Ltmp(1,:) = [];

X = Xtmp;
L = Ltmp;
