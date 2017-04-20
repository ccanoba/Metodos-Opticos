%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function reads and obj file, then delete repeated links between
% coordinate points.
%
% Only for 3rd order obj files. This means triangle meshing
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [X, L] = read_Obj(filename)

OBJ=read_wobj(filename); % Read obj. file

Pos=OBJ.vertices;
Pos2 = Pos;
Pos2(:,4) = 1;
X = Pos2';               % Object coordinates

Datos=OBJ.objects;
Links = Datos(2).data;
L=Links.vertices;
L2 = [L(:,1:2);L(:,2:3);[L(:,3),L(:,1)]];
L3 = sort(L2,2);
C=unique(L3,'rows','legacy');
L = C;                   % Object links