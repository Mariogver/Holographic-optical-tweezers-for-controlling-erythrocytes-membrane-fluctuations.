%Phase Mask Building and observation of a already created trap in a .png
%format. This script is specifically designed to present the 0_0, 50_50 and
%minus 50_50 images to the SML and create the Single traps if a new calibration
%was required,which are already created traps.
%These images must be stord in the directory: C:\Users\Fujitsu\Desktop\Matlab_Holo\CALIBRATION\TIFF
%under the names: 0_0, 50_50 and -50_-50.
bit=256;
set(0,'units','pixels'); 
Monitors = get(0, 'MonitorPositions');
m_s = Monitors(2,4); % number of rows SLM phasemask
n_s = Monitors(2,3); % number of columns SLM phasemask
% A= readtable('C:\Users\Fujitsu\Desktop\Matlab_Holo\m_s_n_s.txt');
% m_s =table2array(A(1,'m_s'));
% n_s=table2array(A(1,'n_s'));

PhMaskSize = [m_s n_s]; % phasemask (SLM) size
lambda = 785e-9; % laser wavelength in meters %% 785e-9
trap= imread('C:\Users\Fujitsu\Desktop\Matlab_Holo\1Traps_Calib0_00_R6_G1.png');
%trap= imread('C:\Users\Fujitsu\Desktop\Matlab_Holo\Image_Input_traps\2Traps_d120_R30_G3.png');
image = trap*bit;
[m,n]=size(image);
aspect_ratio = m_s/n_s;
New_v_length = floor(m*aspect_ratio);
Im_resize = imresize(image,[New_v_length  n],'Antialiasing',true);
% insert the image in the middle     
central_pos = [m_s/2, n_s/2];
scale=1; %multiply scale =3 for 200x200
[target, imageT] = ImagScPo(Im_resize, PhMaskSize,scale,central_pos );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% INPUT PHASE mask %%%%%%%%%%%

% Construct bare Phasemask  TF
 % true
% Call Gerchberg - Saxton algorithm
iter = 10; %Number of algorithm iterations
CorrSwitch = 0; % If info about correlation of Target and Reconstruction 
                % is needed set to 1, else 0
target_norm = uint8(255*mat2gray(target));
[phasemask_GSA , pmcor] = GSAcor(target, iter, target_norm, CorrSwitch);
% if correlation was calculated display in extra figure



% 
close all;
% Lens phasemask i.e. axial shift
diameter = 20e-3; % aperture diametr; number in m
fl = 365e-3; %  focal length of the lens; number in meters(530)
phasemask_lens = Lens(fl, lambda, diameter, PhMaskSize);

% Blazed Grating phasemask i.e. lateral shift
k_x=-0; %-0.15; 
k_y=0;
phasemask_grating = Grating(k_y, k_x, PhMaskSize);

% Construct overall phasemask, wrap phase to 2pi
phasemask_TOT = mod(phasemask_GSA + phasemask_grating + phasemask_lens,2*pi);

% % Flip the mask on vertical axis due to the optical path
% % In order to view on the camera in the microscope the target image
% phasemask = flip(phasemask,2);

% Reconstructed Image
%fftshift needed to center image
Im_construct = abs(fftshift(fft2(exp(1i*phasemask_GSA))));
%%% if I started with a PhaseMask and want to reconstruct the real image
%%% (symmetrical 200x200):
%       Im_construct2=imresize(Im_construct,[200  200],'Antialiasing',true);
disp('finished')
%if strcmp(ImgaeInputKind,'real')  == 1 % true
% % Flip the mask on vertical axis due to the optical path
% % In order to view on the camera in the microscope the target image
% Im_construct = flip(Im_construct,2);
% output of Target, Reconstruction and Phasemask
%  figure(5)
%  subplot(1,3,1)       
%  target_norm = uint8(255*mat2gray(flip(target,2)));
%  target_norm = uint8(255*mat2gray(target));
% imshow(target_norm);
%  axis equal tight;
% title('Target image')
% %end
% 
% subplot(1,3,2)       
% Im_constr_norm = uint8(255*mat2gray(Im_construct));
% imshow(Im_constr_norm);
%  axis equal tight;
% title('Reconstructed Image')
% 
% subplot(1,3,3)       
% phasemask_GSA_norm = uint8(255*mat2gray(phasemask_GSA));
% imshow(phasemask_GSA_norm);
%  axis equal tight;
% title('Phasemask')
% 
 PhasemaskSend_Nicco(phasemask_TOT);
% 
