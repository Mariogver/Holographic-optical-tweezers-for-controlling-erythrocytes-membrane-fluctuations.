%Always store the first 0_0 center image as a 0_0.tif in the folder. This
%is needed to be appied everyday before an experiment is run. This script
%simply takes the 0.0 position for that day. Try to display in the 0_0
%image ONLY the particle in the central position (no other particle in the
%image)

clear MatCoord
T = imread('F:\videos\TIFF\captura_p1.tif');
%T = imread('C:\AOS Sequences\TIFF\0_0_p1.tif');
%T= imread('C:\Users\Fujitsu\Desktop\Matlab_Holo\CALIBRATION\TIFF\0_0_p1.tif'); %this only after a full calibration is done
I=imadjust(rgb2gray(T));
[centers, radii] = imfindcircles(I,[30 110],'Method','TwoStage', 'Sensitivity', 0.9,'ObjectPolarity','dark')
figure(9), imshow(I);
axis equal tight;
h = viscircles(centers,radii);
ncenters=size(centers);
%for other script:
centers_01 =centers;

for i=1:ncenters(1)
centers(i,2)=[1000-centers(i,2)];
end

centers_0=centers;
[MatCoord] = MatCoord(centers_0,centers,ncenters);
rownames= ["centers_0"]
T=table(centers_0);
writetable(T,'centers_0.txt');
type centers_0.txt

