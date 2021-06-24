%4 traps in the vertex of the circle.

T = imread('F:\videos_3\RBC1_Normal_1835fps\captura_p0001.tif');
I=imadjust(rgb2gray(T));
[r,s]=size(I);
%I=T;
[centers, radii] = imfindcircles(I,[30 800],'Method','TwoStage', 'Sensitivity', 0.9,'ObjectPolarity','dark');
%If a visulaization of the captured centers is required:
 figure(9), imshow(I);
% axis equal tight;
 h = viscircles(centers,radii);
 
A= readtable('C:\Users\Fujitsu\Desktop\Matlab_Holo\CALIBRATION\AOStoMatCalibration.txt'); %import the Matlab/camera relationship factor information
factor =table2array(A(1,'factor'));
radio = radii;

v1 = [centers(1)+500-r/2,500-centers(2)+radio+s/2]; % individual vertex coordinates
v2 = [centers(1)+radio+500-r/2, 500-centers(2)+s/2];
v3= [centers(1)-r/2+500, 500-centers(2)-radio+s/2];
v4= [centers(1)-radio-r/2+500, 500-centers(2)+s/2];
coord = [v1(1),v2(1),v3(1),v4(1),v1(2),v2(2),v3(2),v4(2)];
coord= reshape(coord,[4,2]);
ncenters=size(coord);
A= readtable('centers_0.txt');
centers_0=[]
 centers_0(1,1) =table2array(A(1,'centers_0_1'));
 centers_0(1,2)=table2array(A(1,'centers_0_2'));
clear MatCoord 
[MatCoord] = MatCoord(centers_0,coord,ncenters);

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
 

% Lens phasemask i.e. axial shift
diameter = 20e-3; % aperture diametr; number in m
fl = 360e-3; %  focal length of the lens; number in meters(530)
phasemask_lens = Lens(fl, lambda, diameter, PhMaskSize);


% Construct overall phasemask, wrap phase to 2pi
%phasemask_TOT = mod(phasemask_GSA + phasemask_grating + phasemask_lens,2*pi);
phasemask_TOT = mod(phasemask_GSA +  phasemask_lens,2*pi);
PhasemaskSend_Nicco(phasemask_TOT);
 disp('finished')
