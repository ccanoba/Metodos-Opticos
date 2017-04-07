function [ObjectReconstructed] = kreuzerConvolutionReconstruction(ModifiedContrastHologram, ...
                            Wavelength, PointSensorDistance,...
                            PointObjectDistance, ObjectPixel_xy,...
                            SensorPixel_XY)

   if nargin == 0, help('kreuzerConvolutionReconstruction'); return; end
   
   Im = ModifiedContrastHologram;
   lambda = Wavelength;
   L = PointSensorDistance;
   z = PointObjectDistance;
   
   [P,Q] = size(Im);
   [p, q] = meshgrid(0:P-1, 0:Q-1);

   k = 2 * pi / lambda;
   
   [SensorCoordinates] = computeAllSensorCoordinates( P, Q, SensorPixel_XY, PointSensorDistance);
   
   Xpp = SensorCoordinates.Xpp;
   Ypp = SensorCoordinates.Ypp;
   dXpp = SensorCoordinates.dXppYpp(1);
   dYpp = SensorCoordinates.dXppYpp(2);
   
   [ObjectCoordinates] = computeObjectCoordinates( P, Q, ObjectPixel_xy, PointObjectDistance );
   x = ObjectCoordinates.x;
   y = ObjectCoordinates.y;
   xo = ObjectCoordinates.xo;
   yo = ObjectCoordinates.yo;
   dx = ObjectPixel_xy(1);
   dy = ObjectPixel_xy(2);
   
   Rp = sqrt(L^2 - Xpp.^2 - Ypp.^2);
   r = sqrt( x.^2 + y.^2 + z.^2 );
%    xo=0;yo=0;
   
   Im = Im.*((L./Rp).^4).*exp(+1i*k*z*Rp/(L)).*exp(-1i*k*(r.^2).*Rp./(L^2));
%    F1 = Im.*exp(  1i*(k/(2*L))*( 2*xo*p*dXpp + 2*yo*q*dYpp + ((p-P/2).^2)*dx*dXpp + ((q-Q/2).^2)*dy*dYpp )  );
   F1 = Im.*exp(  1i*(k/(2*L))*( 2*xo*p*dXpp + 2*yo*q*dYpp + ((p).^2)*dx*dXpp + ((q).^2)*dy*dYpp )  );
   F1 = padarray(F1,[P/2, Q/2]);
   FF1 = fftshift(fft2(fftshift(F1)));
   
   F2 = exp( -1i*(k/(2*L))*( ((p-1*P/2).^2)*dx*dXpp ) );
   F2 = padarray(F2,[P/2, Q/2]);
   F3 = exp( -1i*(k/(2*L))*( ((q-1*Q/2).^2)*dy*dYpp ) );
   F3 = padarray(F3,[P/2, Q/2]);
   
   FF2 = fftshift(fft(fftshift(F2),[],2));
   FF3 = fftshift(fft(fftshift(F3),[],1));
   
   K = ifftshift(ifftn(ifftshift(FF1.*FF2.*FF3)));
   K = K(P/2+1:P/2+P,Q/2+1:Q/2+Q);

   K = K*(dXpp*dYpp).*exp( 1i*(k/L)*( (xo + p*dx)*dXpp + (yo + q*dy)*dYpp ) ).* ...
       exp( 1i*(k/(2*L))*( ((p-P/2).^2)*dx*dXpp + ((q-Q/2).^2)*dy*dYpp ) );
   
   ObjectReconstructed = K;

end        %end function:kreuzerReconstruction
