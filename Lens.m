function [phasemask] = Lens(fl, lambda,diam, PhMaskSize)
% Lens function creating a phasemask (virtual lens creation)
% Input: 
% fl: focal length in meter,
% lambda: laser wavelength in m
% PhMaskSize: size of the phasemask
% Output: 
% phasemask: Phasemask creating a lens of PhMaskSize 
if fl == 0 % if no lens skip calculation
    phasemask(:,:) = 0;
else
    Ny = PhMaskSize(1); %Number of pixels in y
    Nx = PhMaskSize(2); %Number of pixels in x
    pitch = 8e-6; %pixel pitch 8 mu m, needed for conversion from matrix
    % distance to real distance
    bw = zeros(Ny,Nx);
    bw(floor(Ny/2),floor(Nx/2)) = 1; % center point
    R = bwdist(bw,'euclidean').*pitch; %euklidian distance to center point
    G = R.^2; % squared distance
    phasemask = (pi/(lambda.*fl)).*G;
    phasemask = mod(phasemask,2*pi); %
    phasemask(R>=diam/2)=0;  % NA given by the aperture diameter
end
end

