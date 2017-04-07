function [Coordinates] = computeObjectCoordinates(Rows, Cols, ObjectPixel_XY, PointObjectDistance)

   if nargin == 0, help('computeObjectCoordinates'); return; end
   
   P = Cols;
   Q = Rows;
   dx = ObjectPixel_XY(1);
   dy = ObjectPixel_XY(2);
   z = PointObjectDistance;
   
   [p, q] = meshgrid(0:P-1, 0:Q-1);

   xo = -P*dx/2.0 + dx/2.0;
   yo = -Q*dy/2.0 + dy/2.0;

   x = xo + p*dx;
   y = yo + q*dy;

   Coordinates.x = x;
   Coordinates.y = y;
   Coordinates.xo =xo;
   Coordinates.yo = yo;

end        %end function:computeObjectCoordinates
