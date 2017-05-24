function [X,L] = genscene(type, Properties)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Function to create scenes based on Tomas Svoboda method
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(type, 'Poly')
  
  w = Properties.w; % width
  h = Properties.h; % height
  l = Properties.l; % depth (length)
  
  
  X = zeros(3,10);
  % Front face
  X(:,1) = [0,0,0]';
  X(:,2) = [0,w,0]';
  X(:,3) = [0,w,h]';
  X(:,4) = [0,0,h]';
  % Back face
  X(:,5:8) = X(:,1:4)-repmat([l,0,0]',1,4);
  % top and botton
  X(:,9) = [-l/2,w/2,1.5*h]';
  X(:,10) = [-l/2,w/2,-0.5*h]';
  
  % Lines
  L = [1,2;2,3;3,4;4,1;5,6;6,7;7,8;8,5;1,5;2,6;3,7;4,8];
  L = [L;[1,10;2,10;5,10;6,10;3,9;4,9;7,9;8,9]];
elseif strcmp(type, 'peaks')
  N = Properties.N;
  X = zeros(3,N^2);
  datos = peaks(N);
  datos = (Properties.h)*(datos/max(datos(:)));
  datos = round(datos);
  X(3,:) = reshape(datos,1,numel(datos));
  coorX = 1:N;
  coorX = repmat(coorX,N,1);
  coorX = reshape(coorX,1,numel(coorX));
  coorY = 1:N;
  coorY = repmat(coorY',1,N);
  coorY = reshape(coorY,1,numel(coorY));
  L = [1,1];
  for ii = 1:N
    L1 = [(ii-1)*N+1,(ii-1)*N+2;ii*N-1,ii*N];
    L2 = [ii,N+ii;N*(N-2)+ii,N*(N-1)+ii];
    L = [L;L1;L2];
  end
  a = 1:numel(coorX);
  a = reshape(a,N,N); b = a'; b(:,[1,N]) = [];
  for ii = b
    L1 = [ii-1,ii;ii,ii+1];
    L = [L;L1];
  end
  b = a'; b([1,N],:) = [];
  for ii = b
    L1 = [ii-N,ii;ii,ii+N];
    L = [L;L1];
  end
  L(1,:) = [];
  X(1:2,:) = [((coorX-1)/max(coorX))*Properties.l;((coorY-1)/max(coorY))*Properties.w];
  
elseif strcmp(type,'house')
  w = Properties.w; % width
  h = Properties.h; % height
  l = Properties.l; % depth (length)
  X = zeros(3,10);
  % frontal side of the house
  X(:,1) = [0,0,0]';
  X(:,2) = [0,w,0]';
  X(:,3) = [0,w,h]';
  X(:,4) = [0,0,h]';
  X(:,5) = [0,w/2,1.5*h]';
  % back side of the house
  X(:,6:10) = X(:,1:5)-repmat([l,0,0]',1,5);
  L = [1,2;2,3;3,4;4,1;3,5;4,5];
  L = [L;L+5];
  L = [L;1,6;2,7;3,8;4,9;5,10];
  
elseif strcmp(type, 'sphere')
  
  N = Properties.N;
  coorX = 1:N;
  coorX = repmat(coorX,N,1);
  coorX = reshape(coorX,1,numel(coorX));
  coorY = 1:N;
  coorY = repmat(coorY',1,N);
  coorY = reshape(coorY,1,numel(coorY));
  coorZ = sqrt((N/2).^2-(coorX-N/2).^2-(coorY-N/2).^2);
  coorZ = real(coorZ);
  L = [1,1];
  for ii = 1:N
    L1 = [(ii-1)*N+1,(ii-1)*N+2;ii*N-1,ii*N];
    L2 = [ii,N+ii;N*(N-2)+ii,N*(N-1)+ii];
    L = [L;L1;L2];
  end
  a = 1:numel(coorX);
  a = reshape(a,N,N); b = a'; b(:,[1,N]) = [];
  for ii = b
    L1 = [ii-1,ii;ii,ii+1];
    L = [L;L1];
  end
  b = a'; b([1,N],:) = [];
  for ii = b
    L1 = [ii-N,ii;ii,ii+N];
    L = [L;L1];
  end
  L(1,:) = [];
  X = [((coorX-1)/max(coorX))*Properties.l;((coorY-1)/max(coorY))*Properties.w;((coorZ-1)/max(coorZ))*Properties.h];
elseif strcmp(type, 'pyramid')
  w = Properties.w; % width
  h = Properties.h; % height
  l = Properties.l; % depth (length)
  
  X = zeros(3,5);
  X(:,1) = [0,0,0]';
  X(:,2) = [0,w,0]';
  X(:,3) = [-l,w,0]';
  X(:,4) = [-l,0,0]';
  X(:,5) = [-l/2,w/2,h];
  
  L = [1,2;2,3;3,4;4,1;1,5;2,5;3,5;4,5];
else
  error('unknown type of scene');
  
end



