%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function create a set of cameras acording to the function cameragen
%
% There are two available options:
%
% panoramic : Make a panoramic of a scene
% dolly : Displaces a camera while changing its FOV
% 
% Input parameters can be derive from cameragen
%
% Output is a cell array with the cameras
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function camera = cameras(look_at, sky, foclen, position, FOV, preoption, poinput)

if nargin>5
  switch preoption
    case 'panoramic'
      xpos = poinput(1)*cos(linspace(0,2*pi,poinput(3)+1));
      ypos = poinput(1)*sin(linspace(0,2*pi,poinput(3)+1));
      zpos = ones(1,poinput(3))*poinput(2);
      xpos = xpos+look_at(1); ypos = ypos+look_at(2);
      position = [xpos(1:end-1)', ypos(1:end-1)', zpos'];
    case 'dolly'
      position = [poinput{1}',ones(size(poinput{1}))'*look_at(2),ones(size(poinput{1}))'*look_at(3)];
      FOV = 2*atan2d(poinput{2},2*poinput{1});
    otherwise 
      disp('Not valid option')
  end
end

camera = cell(1,size(position,1));

for i = 1:size(position,1)
  pars.look_at = look_at';
  pars.angle = (FOV) *(pi/180);
  if length(FOV)>1
    pars.angle = (FOV(i)) *(pi/180);
  end
  pars.sky = sky';
  pars.foclen = foclen;
  pars.position = position(i,:)';
  
  camera{i} = cameragen(pars);
  
end