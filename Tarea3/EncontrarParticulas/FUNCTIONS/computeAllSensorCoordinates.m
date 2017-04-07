function [Coordinates] = ...
         computeAllSensorCoordinates(Rows, Cols, SensorPixel_XY, PointSensorDistance)

   if nargin == 0, help('computeAllCoordinates'); return; end

   P = Cols;
   Q = Rows;
   dX = SensorPixel_XY(1);
   dY = SensorPixel_XY(2);
   L = PointSensorDistance;
   
   [p, q] = meshgrid(0:P-1, 0:Q-1);

   Xo = -P*dX/2.0 + dX/2.0;
   Yo = -Q*dY/2.0 + dY/2.0;
   
   Xop = Xo * L / sqrt(L^2 + Xo^2);
   Yop = Yo * L / sqrt(L^2 + Yo^2);
   
   Xmaxp = (Xo + (P-1)*dX) * L / sqrt( L^2 + (Xo + (P-1)*dX)^2 );
   Ymaxp = (Yo + (Q-1)*dY) * L / sqrt( L^2 + (Yo + (Q-1)*dY)^2 );
   
   dXpp = (Xmaxp - Xop)/(P-1);
   dYpp = (Ymaxp - Yop)/(Q-1);
   
   X = Xo + p*dX;
   Y = Yo + q*dY;
   
   R = sqrt(L^2 + (X).^2 + (Y).^2 );
   
   Xp = (X) * L ./ R;
   Yp = (Y) * L ./ R;
    
   Xpp = Xop + p*dXpp;
   Ypp = Yop + q*dXpp;
   
   Coordinates = struct();
   
   Coordinates.X = X;
   Coordinates.Y = Y;
   Coordinates.Xo = Xo;
   Coordinates.Yo = Yo;  

   Coordinates.Xp = Xp;
   Coordinates.Yp = Yp;
   Coordinates.Xop = Xop;
   Coordinates.Yop = Yop;
   
   Coordinates.dXppYpp(1) = dXpp;
   Coordinates.dXppYpp(2) = dYpp;
   
   Coordinates.Xpp = Xpp;
   Coordinates.Ypp = Ypp;
   

end        %end function:ComputePrimeCoordinates
