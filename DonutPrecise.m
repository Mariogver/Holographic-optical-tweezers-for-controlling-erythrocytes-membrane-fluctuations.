
% Create the exact contour fitting donut trap for an RBC The four vertex (most radiant points from the center in 4 normal
% directions) are defined. The x axis values from the left point to the right point are taken as a linear array of coordinates and for each of those
% individual values the upper intensity profile is studied as if a normal line was drawn towards the upper part. The region of
% the highest slope or the highest derivative value is considered as the equatorial contour position of the RBC. The same is done for the below
% section, and after that the same porcedure is repeated for the upper point to the down point. 


I = imread('F:\videos_3\RBC1_Normal_1835fps\captura_p0001.tif'); %load frame of desired RBC
[r,s]=size(I);
[centers, radii] = imfindcircles(I,[30 800],'Method','TwoStage', 'Sensitivity', 0.9,'ObjectPolarity','dark');
centers
%If a visulaization of the captured centers is required:
 figure(9), imshow(I);
  h = viscircles(centers,radii);
  centers= floor(centers);
 %Now two other functions are called: perimetro and perimetro_2 that will
 %extract the coordinates for the vertices of the RBC, denotd as
 %puntoiz,der,arriba and abajo
 [puntoiz]=perimetro(I,centers,1);
 [puntoder]=perimetro(I,centers,0);
 [puntoarriba] =perimetro_2(I, centers, 1);
 [puntoabajo]= perimetro_2(I,centers,0);

 %variables for storing the coordinates of the 4 segments of the RBC
leftpoints=[];
rightpoints=[];
upperpoints=[];
downpoints=[];

 %rigth to letf searching for the leftpoints:
for i=puntoiz(1):puntoder(1)
    
    
 b=double(I(1:centers(2),i));
 a=(1:centers(2));
    
[p,S]=polyfit(a,b,14);
y=polyval(p,a);
% figure
% plot(a,y,'r')
% hold on
% plot(a,b,'b')
% hold off
%%%
f= poly2sym(p); % fit the polynomial
f2=diff(f); %derivate the polynomial
h= subs(f2,a(20:end-20));
h2=double(h);
 u=(20+find(h2==min(h2))); %find the highest value of the derivative
 leftpoints(i,2)= u;
 leftpoints(i,1)= i;
end
% right to left searching for the rightpoints:
  for i=puntoiz(1):puntoder(1)
    
    
 b=double(I(centers(2):300,i));
 a=(centers(2):300);
    
[p,S]=polyfit(a,b,13);
y=polyval(p,a);
% figure
% plot(a,y,'r')
% hold on
% plot(a,b,'b')
% hold off
%%%
f= poly2sym(p);
f2=diff(f);
v=a(20:end-20);
h= subs(f2,v);
h2=double(h);
u=v(find(h2==max(h2)));;
rightpoints(i,2)= u;
rightpoints(i,1)= i;
  end

  %up and down:
for i=puntoarriba(2):puntoabajo(2)
    
    
 b=double(I(i,centers(2):300));
 a=(centers(2):300);
    
[p,S]=polyfit(a,b,13);
y=polyval(p,a);
% figure
% plot(a,y,'r')
% hold on
% plot(a,b,'b')
% hold off
%%%
f= poly2sym(p);
f2=diff(f);
v=a(20:end-20);
h= subs(f2,v);
h2=double(h);
u=v(find(h2==max(h2)));
downpoints(i,1)= u;
downpoints(i,2)= i;
end  
  
  for i=puntoarriba(2):puntoabajo(2)
    
    
 b=double(I(i,1:centers(2)));
 a=(1:centers(2));
    
[p,S]=polyfit(a,b,13);
y=polyval(p,a);
% figure
% plot(a,y,'r')
% hold on
% plot(a,b,'b')
% hold off
%%%
f= poly2sym(p);
f2=diff(f);
h= subs(f2,a(20:end-20));
h2=double(h);
 u=(20+find(h2==min(h2)));
 upperpoints(i,1)= u;
 upperpoints(i,2)= i;
  end
 
% convert the obtained points in plottable variables:
q= upperpoints(1:end,1);
c= upperpoints(1:end,2);
e= downpoints(1:end,1);
r= downpoints(1:end,2);
u = leftpoints(1:end,1);
t = leftpoints(1:end,2);
v = rightpoints(1:end,1);
w = rightpoints(1:end,2);

figure % draw the coordinate values over a raw image of an RBC
imshow(I)
hold on
scatter(q,c)
scatter(e,r)
scatter(u,t)
scatter(v,w)

scatter(puntoiz(1),puntoiz(2)) %draw the vertex too
scatter(puntoder(1),puntoder(2))
scatter(puntoarriba(1),puntoarriba(2))
scatter(puntoabajo(1),puntoabajo(2))
hold off
centers_01=centers
[rightpoints_2,leftpoints_2,upperpoints_2,downpoints_2]=MatCoord_2(centers_01,rightpoints, leftpoints, upperpoints, downpoints); %translate the image coordinates to matlab coordinates

array= floor(cat(1,upperpoints_2,downpoints_2,leftpoints_2,rightpoints_2));
donnut= zeros(1000);


for i= 1:length(array); %draw the trap 
    if array(i,1)~=-53 
        donnut(array(i,1)+500,array(i,2)+500)= 1;
    end
end

%% BUILD THE PHASEMASK AND SEND IT TO THE SML

bit=256;
image= donnut*bit;
set(0,'units','pixels'); 
 Monitors = get(0, 'MonitorPositions');
 m_s = Monitors(2,4); % number of rows SLM phasemask
 n_s = Monitors(2,3); % number of columns SLM phasemask
 %IF THERE IS NOT A SECOND SCREEN ASSOCIATED, UNSILENCE THE LINES BELOW
% A= readtable('C:\Users\Fujitsu\Desktop\Matlab_Holo\m_s_n_s.txt');
% m_s =table2array(A(1,'m_s'));
% n_s=table2array(A(1,'n_s'));

PhMaskSize = [m_s n_s]; % phasemask (SLM) size
lambda = 785e-9; % laser wavelength in meters %% 785e-9
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
 PhasemaskSend_Nicco(phasemask_TOT); %send the phasemask to the SML
% 

