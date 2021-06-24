%%%%%%%%%%%%%  Image output 200x200 pixeles %%%%%%%%%%%%%%
%creates a new single trap in the object coordinates on the input image. This
%image should be stored in the path: C:\AOS
%Sequences\TIFF\test02_p1_006.tif;


I = imread('C:\AOS Sequences\TIFF\test02_p1_006.tif'); 

[centers, radii] = imfindcircles(I,[30 90],'Method','TwoStage', 'Sensitivity', 0.9,'ObjectPolarity','dark');


% coordinates acquisition
ncenters=size(centers)
for i= 1:ncenters(1);
    x_centers = (MatCoord(centers_0,(centers(i,:)),ncenters))
    y_centers = (MatCoord(centers_0,(centers(i,:)),ncenters))% center first lorentian
end
    
    %IN CASE THERE ARE MORE THAN 1 OBJECT:
%if ndims(centers)>1
%x2=centers(2,2); y2 = centers(2,1);
%if ndims(centers)>2
   % x3 = centers(3,2); y3 =centers(3,1)

RR=6;         % radius, ouside =0
G=1;  %factor do define gamma as a function of RR. Proportional to the barrier height
gamma1_x=RR/G; gamma1_y=RR/G;
gamma2_x=RR/G; gamma2_y=RR/G;
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
    rall{i} = sqrt( (x-x_centers(i)).^2 + (y-y_centers(i+1)).^2)+1;

   %r1 = sqrt( (x-x1).^2 + (y-y1).^2)+1;
   %r2 = sqrt( (x-x2).^2 + (y-y2).^2)+1;
   %r3 = sqrt( (x-x3).^2 + (y-y3).^2)+1;
   %create the circles:
   rall{i}(rall{i}>RR)=0;
end
r= sumacelda (rall, ncenters);

   %r1(r1>RR) = 0;
   %r2(r2>RR) = 0;
   %r=r1+r2;
   
   %give the donut a uniform value:
   r(logical(r)) = 1;
    
   % 2D Lorentzian
   Lor_2D = @(b,p,q)   b(1)./(  ((p-b(2)).^2)/b(3)^2 +  ((q-b(4)).^2)/b(5)^2 +1 ) ;  
   %alfa(1)= 1;        beta(1)= 1;% Amplitude
   %alfa(2)= x1;       beta(2)= x2; % x0
   %alfa(3)=gamma1_x;  beta(3)=gamma2_x;% gamma_x
   %alfa(4)= y1;       beta(4)= y2; % y0
   %alfa(5)=gamma1_y;  beta(5)=gamma2_y;% gamma_y
   %DoubleLorentz =  Lor_2D(alfa,x,y) +Lor_2D(beta,x,y);
   for i=1:ncenters(1)
   omega(i,1)= 1;
   omega(i,2)= x_centers(i);
   omega(i,3)= gamma1_x;
   omega(i,4)= y_centers(i);
   omega(i,5)= gamma1_y
   Loren{i}=Lor_2D(omega(i,:),x,y)
   end
   MultiLorentz= sumacelda(Loren, ncenters); 
   ML = Loren{1};
   
  % multiply lorenztians x position & normailze to max=1
   %target0 = DoubleLorentz.*r;
   %target0 = target0 / max(max(target0));
   target0= MultiLorentz.*r;
   target0= target0/max(max(target0));
  
   
   %%%%%%%%%%%%%%%%%%%%%% resize and insert in the middle
%    
% New_v_length = floor(v_length/aspect_ratio);
% New_v_width = floor(h_length/aspect_ratio);
% Im_resize = imresize(target0,[New_v_length  New_v_width],'Antialiasing',false);
% target = Im_resize / max(max(Im_resize));


 
   
% define a colormap in RGB format (3 columns) 
bit=256;
Grey_2=zeros(bit,3);
numscale=numel(Grey_2(:,1));
for nn=1:numscale
Grey_2(nn,:)=nn/numscale;
end

if ~ishandle(1)
figure
end
%plot the donut:
figure(1) 
imagesc(target0*bit)
axis equal tight;
% title(['Circles A:(',num2str(x1),'; ',num2str(y1),') R',num2str(R1),'px   B:(',num2str(x2),'; ',num2str(y2),') R',num2str(R2),'px ']);
set(gca,'Fontsize',12)
colormap(Grey_2)
caxis([0 bit]);
colorbar

% plot the center line as a potential (minus sign)
figure(2)
plot((1:h_length),-target0(h_length/2, : )); set(gca,'Fontsize',12)
%% %% Save image 
name_out=(['C:\Users\Fujitsu\Desktop\Matlab_Holo\Generated_traps\AbajoDer',num2str(ncenters(1)),'_centers','_R',num2str(RR),'_G',num2str(G),'.png']);
% name_out='2Traps_small.png'; Los guardamos en una nueva carpeta
% denominada Generated traps. 
imwrite(target0, name_out);