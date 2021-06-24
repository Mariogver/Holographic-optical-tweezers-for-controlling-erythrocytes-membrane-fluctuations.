%edge detection and phase mask construction of the captured image data. This image (with the target objects to be trapped)
%should be stored in the following pathway: C:\AOS Sequences\TIFF\ (can be
%changed in the codeline 10) and must be stored under the name
%'captura_p1.tif'. P1.tif is automatically set by AOS software. This script
%is ONLY to employ real images (.tif) from which a phasemask will be
%produced. If a PhM is fed, this will not work. Final image will be deleted
%from its folder.

clear all; close all;

I = imread('C:\AOS Sequences\TIFF\test02_p1_006.tif');
 %I=rgb2gray(I);
[r,s]=size(I);

[centers, radii] = imfindcircles(I,[30 90],'Method','TwoStage', 'Sensitivity', 0.9,'ObjectPolarity','dark');
centers
%If a visulaization of the captured centers is required:
 figure(9), imshow(I);
  h = viscircles(centers,radii);
 axis equal tight;
ncenters=size(centers);
for i=1:ncenters(1)
centers(i,2)=[1000-centers(i,2)];
end
%The daily calibrated central position is stored in centers_0.txt file
%(see: CalibracionCentral.m)
A= readtable('centers_0.txt');
centers_0=[]
centers_0(1,1) =table2array(A(1,'centers_0_1'));
centers_0(1,2)=table2array(A(1,'centers_0_2'));
[MatCoord] = MatCoord(centers_0,centers,ncenters);

% Drawing the center trap
for i= 1:ncenters(1);
    x_centers(i)=(MatCoord(i,1));
    y_centers(i)= (MatCoord(i,2));% center first lorentian
end

RR=6;         % radius, ouside =0
G=1;  %factor do define gamma as a function of RR. Proportional to the barrier height
aspect_ratio = 5; % aspect ratio to improve drawing sensibility

% display size
h_length = 200*aspect_ratio ; 
v_length = 200*aspect_ratio ; 
h_ax = [-0.5*h_length:1:0.5*h_length-1];
v_ax = [-0.5*v_length:1:0.5*v_length-1];
[x,y] = meshgrid(h_ax, v_ax);
y=-y;
%rall={}
for i= 1:ncenters(1);
    rall{i} = sqrt( (x-x_centers(i)).^2 + (y-y_centers(i)).^2)+1;
   %create the circles:
   rall{i}(rall{i}>RR)=0;
end
r= sumacelda (rall, ncenters);

   %give the donut a uniform value:
   r(logical(r)) = 1;
    
   % 2D Lorentzian
   Lor_2D = @(b,p,q)   b(1)./(  ((p-b(2)).^2)/b(3)^2 +  ((q-b(4)).^2)/b(5)^2 +1 ) ;  

   for i=1:ncenters(1)
   omega(i,1)= 1;
   omega(i,2)= x_centers(i);
   omega(i,3)= RR/G;
   omega(i,4)= y_centers(i);
   omega(i,5)= RR/G;
   Loren{i}=Lor_2D(omega(i,:),x,y);
   end
   MultiLorentz= sumacelda(Loren, ncenters); 
   
  % multiply lorenztians x position & normailze to max=1
   
   target0= MultiLorentz.*r;
   target0= target0/max(max(target0));
 
% define a colormap in RGB format (3 columns) 
bit=256;
Grey_2=zeros(bit,3);
numscale=numel(Grey_2(:,1));
for nn=1:numscale
Grey_2(nn,:)=nn/numscale;
end


%Phase Mask Building

set(0,'units','pixels'); 
Monitors = get(0, 'MonitorPositions');

m_s = Monitors(2,4); % number of rows SLM phasemask
n_s = Monitors(2,3); % number of columns SLM phasemask

PhMaskSize = [m_s n_s]; % phasemask (SLM) size

lambda = 785e-9; % laser wavelength in meters %% 785e-9
             
% Read target picture  

image = target0*bit;


 % Compress the input picture in the vertical axis
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
% Call Gerchberg - Saxton algorithm
iter = 10; %Number of algorithm iterations
CorrSwitch = 0; % If info about correlation of Target and Reconstruction 
                % is needed set to 1, else 0
target_norm = uint8(255*mat2gray(target));
[phasemask_GSA , pmcor] = GSAcor(target, iter, target_norm, CorrSwitch);
 
close all;
% Lens phasemask i.e. axial shift
diameter = 20e-3; % aperture diametr; number in m
fl = 360e-3; %  focal length of the lens; number in meters(530)
phasemask_lens = Lens(fl, lambda, diameter, PhMaskSize);

% Blazed Grating phasemask i.e. lateral shift
% k_x=-0; %-0.15; 
% k_y=0;
%phasemask_grating = Grating(k_y, k_x, PhMaskSize);

% Construct overall phasemask, wrap phase to 2pi
%phasemask_TOT = mod(phasemask_GSA + phasemask_grating + phasemask_lens,2*pi);
phasemask_TOT = mod(phasemask_GSA +  phasemask_lens,2*pi);

 PhasemaskSend_Nicco(phasemask_TOT);
 disp('finished')
 %Delete the "captura" image used to build the mask
 %delete('C:\AOS Sequences\TIFF\captura_p1.tif');
% 
