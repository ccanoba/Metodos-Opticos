function [ModifiedHologram] = prepairHologram(Hologram, PointSensorDistance, SensorPixel_XY, IPmethod)

   if nargin == 0, help('prepairHologram'); return; end
   
   I = Hologram;
   I = I - mean(I(:));
    
   [P,Q] = size(I);
   
   [Coordinates] = computeAllSensorCoordinates( P, Q, SensorPixel_XY, PointSensorDistance);
   
   if IPmethod == 1
   
   Xp = Coordinates.Xp;
   Yp = Coordinates.Yp;
   
   Xop = Coordinates.Xop;
   Yop = Coordinates.Yop;
   
   Xcoord = (Xp - Xop)/(Coordinates.dXppYpp(1));
   Ycoord = (Yp - Yop)/(Coordinates.dXppYpp(2));
   
   iXcoord = floor(Xcoord);
   iYcoord = floor(Ycoord);

   iXcoord(iXcoord==0) = 1;
   iYcoord(iYcoord==0) = 1;
   
   x1frac = (iXcoord + 1.0) - Xcoord;
   x2frac = 1.0 - x1frac;
   y1frac = (iYcoord + 1.0) - Ycoord;
   y2frac = 1.0 - y1frac;

   x1y1 = x1frac.*y1frac;
   x1y2 = x1frac.*y2frac;
   x2y1 = x2frac.*y1frac;
   x2y2 = x2frac.*y2frac;

   Im = zeros(P,Q);

   for it = 1:P-1
      for jt = 1:Q-1

            Im(iYcoord(it,jt),iXcoord(it,jt)) = Im(iYcoord(it,jt),iXcoord(it,jt)) + (x1y1(it,jt))*I(it,jt);
            Im(iYcoord(it,jt),iXcoord(it,jt)+1) =  Im(iYcoord(it,jt),iXcoord(it,jt)+1) + (x2y1(it,jt))*I(it,jt);
            Im(iYcoord(it,jt)+1,iXcoord(it,jt)) = Im(iYcoord(it,jt)+1,iXcoord(it,jt)) + (x1y2(it,jt))*I(it,jt);
            Im(iYcoord(it,jt)+1,iXcoord(it,jt)+1) = Im(iYcoord(it,jt)+1,iXcoord(it,jt)+1) + (x2y2(it,jt))*I(it,jt);

      end
   end
   else
       Xp = Coordinates.Xp; Yp = Coordinates.Yp;
       Xpp = Coordinates.Xpp; Ypp = Coordinates.Ypp;
       Im = griddata(Xp,Yp,I,Xpp,Ypp);
       Im(isnan(Im)) = 0;
   end
    
   ModifiedHologram = Im;
   
end        %end function:prepairHologram
