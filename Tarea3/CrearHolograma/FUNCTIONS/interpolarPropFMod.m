%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function performs the interpolation of a contrast hologram from the
% nonlinear coordinate system xp, yp to the coordinates X2,Y2
%
% Inputs:
%
% In: Contrast hologram
% X2,Y2: Desire coordinates system
% z: Object hologram distance
%
% Output:
%
% Out: Interpolated hologram
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Out] = interpolarPropFMod(In, X2, Y2, z)

xp = X2./sqrt(1-((X2.^2+Y2.^2)/(z^2)));
yp = Y2./sqrt(1-((X2.^2+Y2.^2)/(z^2))); % Non linear artificial coordinates system

Out = griddata(xp,yp,In,X2,Y2);
end