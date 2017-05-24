function [Pts2D, Pts3D] = findCornersChessTarget(TargetImage, SelectedCorners,...
                          CornerWindowXY, SquareSize, PlaneName, PreCorner)

   if nargin == 0, help('findCornersChessTarget'); return; end

   if nargin >5, Esquina = 1 ; else Esquina = 0; end
   
   %Renaming the window size for corner detection

   wintx = CornerWindowXY(1); winty = CornerWindowXY(2);
   
   %Read image
   I = imread(TargetImage);
   
   %TODO:include name of current plane in title
  
   if Esquina ~=1
     
   figHand1 = figure;
   imshow(I)
   axis equal
     
   fprintf('Click on the four extreme corners of the desired rectangle according to the indicated order \n')
   
   x= [];y = [];
   figure(figHand1); hold on;
   for count = 1:4,
       title(sprintf('Current click should be on square (%d, %d)', SelectedCorners(1,count), SelectedCorners(2,count)))
       [xi,yi] = ginput4(1);
       fprintf('xi=%.3f, yi=%.3f \n',xi,yi);
       [xxi] = cornerfinder([xi;yi],double(I),winty,wintx);
       xi = xxi(1);
       yi = xxi(2);
       plot(xi,yi,'+','color',[ 1.000 0.314 0.510 ],'linewidth',2);
       plot(xi + [wintx+.5 -(wintx+.5) -(wintx+.5) wintx+.5 wintx+.5],yi + [winty+.5 winty+.5 -(winty+.5) -(winty+.5)  winty+.5],'-','color',[ 1.000 0.314 0.510 ],'linewidth',2);
       x = [x;xi];
       y = [y;yi];
       plot(x,y,'-','color',[ 1.000 0.314 0.510 ],'linewidth',2);
       drawnow;
   end;
   plot([x;x(1)],[y;y(1)],'-','color',[ 1.000 0.314 0.510 ],'linewidth',2);
   drawnow;
   hold off;
   else 
     x = PreCorner(:,1);
     y = PreCorner(:,2);
   end
   
   disp('Corner Extraction for outer squares...')
   [Xc, ~, ~, ~] = cornerfinder([x';y'],double(I),winty,wintx); % the four cornersW
   x = Xc(1,:)';
   y = Xc(2,:)';

   % Compute the inside points through computation of the planar homography (collineation)
   a00 = [x(1);y(1);1];
   a10 = [x(2);y(2);1];
   a11 = [x(3);y(3);1];
   a01 = [x(4);y(4);1];

   % Compute the planar collineation: (return the normalization matrix as well)
   [Homo, ~, ~] = compute_homography([a00 a10 a11 a01],[0 1 1 0;0 0 1 1;1 1 1 1]);
   
   %Number of squares on each direction
   n_sq_x = abs(max(SelectedCorners(2,:)) -  min(SelectedCorners(2,:)));
   n_sq_y = abs(max(SelectedCorners(1,:)) -  min(SelectedCorners(1,:)));

   % Build the grid using the planar collineation:
   x_l = ((0:n_sq_x)'*ones(1,n_sq_y+1))/n_sq_x;
   y_l = (ones(n_sq_x+1,1)*(0:n_sq_y))/n_sq_y;
   pts = [x_l(:) y_l(:) ones((n_sq_x+1)*(n_sq_y+1),1)]';

   XX = Homo*pts;
   XX = XX(1:2,:) ./ (ones(2,1)*XX(3,:));
   
   %Total number of corners
   Np = (n_sq_x+1)*(n_sq_y+1);
   
   disp('Corner extraction for inner squares...');
   grid_pts = cornerfinder(XX, double(I),winty,wintx); %%% Finds the exact corners at all points!
   
   %Compute boxes for corner detection window
   x_box_kk = [grid_pts(1,:)-(wintx+.5);grid_pts(1,:)+(wintx+.5);grid_pts(1,:)+(wintx+.5);grid_pts(1,:)-(wintx+.5);grid_pts(1,:)-(wintx+.5)];
   y_box_kk = [grid_pts(2,:)-(winty+.5);grid_pts(2,:)-(winty+.5);grid_pts(2,:)+(winty+.5);grid_pts(2,:)+(winty+.5);grid_pts(2,:)-(winty+.5)];

   %Index of corners
   ind_corners = [1 n_sq_x+1 (n_sq_x+1)*n_sq_y+1 (n_sq_x+1)*(n_sq_y+1)]; % index of the 4 corners

   figHand2 = figure;
   imshow(I); hold on;
   plot(grid_pts(1,:)+1,grid_pts(2,:)+1,'r+');
   plot(x_box_kk+1,y_box_kk+1,'-b');
   plot(grid_pts(1,ind_corners)+1,grid_pts(2,ind_corners)+1,'mo');
   xlabel('Xc (in camera frame)');
   ylabel('Yc (in camera frame)');
   title('All extracted corners');
   zoom on;
   drawnow;
   hold off;

   switch lower(PlaneName)
       case 'xy'

           Xi = reshape(([0:n_sq_x])'*ones(1,n_sq_y+1),Np,1)';
           Yi = reshape(ones(n_sq_x+1,1)*[n_sq_y:-1:0],Np,1)';
           Zi = zeros(1,Np);
           
           Xi = Xi*SquareSize; Yi = Yi*SquareSize; Zi = Zi*SquareSize;
   
           %Correct for the recentering
           Xi = Xi + min(SelectedCorners(1,:))*SquareSize;
           Yi = Yi + min(SelectedCorners(2,:))*SquareSize;

           
       case 'yz'
   
           Yi = reshape(([0:n_sq_x])'*ones(1,n_sq_y+1),Np,1)';
           Zi = reshape(ones(n_sq_x+1,1)*[n_sq_y:-1:0],Np,1)';
           Xi = zeros(1,Np);
           
           Xi = Xi*SquareSize; Yi = Yi*SquareSize; Zi = Zi*SquareSize;
           
           %Correct for the recentering
           Yi = Yi + min(SelectedCorners(1,:))*SquareSize;
           Zi = Zi + min(SelectedCorners(2,:))*SquareSize;

           
       case 'xz'

           Xi = reshape(([0:n_sq_x])'*ones(1,n_sq_y+1),Np,1)';
           Yi = zeros(1,Np);
           Zi = reshape(ones(n_sq_x+1,1)*[n_sq_y:-1:0],Np,1)';
           
           Xi = Xi*SquareSize; Yi = Yi*SquareSize; Zi = Zi*SquareSize;

           %Correct for the recentering
           Xi = Xi + min(SelectedCorners(1,:))*SquareSize;
           Zi = Zi + min(SelectedCorners(2,:))*SquareSize;
           
       otherwise 
           error('No plane specified...options: XY, YZ, XZ')
   end
         
   %Group
   Xgrid = [Xi;Yi;Zi];
      
   % All the point coordinates (on the image, and in 3D) - for global optimization:
   Pts2D = grid_pts;
   Pts3D = Xgrid;
      
end        %end function:findCornersChessTarget
