%Calibracion AOS camera to Matlab (1000x1000)
% In this script, a calibration factor for 1000x1000 AOS images and
% Matlab's 1000x1000 coordinates is obtained from the slope of a 3 point calibration line.
%This script is not designed to be run everyday, only if a full
%recaibration of the slopes is required. In order to do so, three images
%must be taken from the AOS camera: One trapped molecule at the matlab's coordinates
%x=0,y=0 (use TrapDraw.m), another at the coordinates x=+50,y=+50 and the third
%one at x=-50,y=-50. These three images should be stored in the desired
%path under the names 0_0,50_50 and -50_-50 respectively, in a .tif format.

image0_0 = imadjust(rgb2gray((imread('C:\Users\Fujitsu\Desktop\Matlab_Holo\CALIBRATION\TIFF\0_0_p1.tif'))));
image50_50 = imadjust(rgb2gray((imread('C:\Users\Fujitsu\Desktop\Matlab_Holo\CALIBRATION\TIFF\50_50_p1.tif'))));
imageminus50_50 = imadjust(rgb2gray((imread('C:\Users\Fujitsu\Desktop\Matlab_Holo\CALIBRATION\TIFF\-50_-50_p1.tif'))));

[centers0, radii0] = imfindcircles(image0_0,[30 60],'Method','TwoStage', 'Sensitivity', 0.9,'ObjectPolarity','dark');
[centers50, radii50] = imfindcircles(image50_50,[30 60],'Method','TwoStage', 'Sensitivity', 0.9,'ObjectPolarity','dark');
[centersminus50, radiiminus50] = imfindcircles(imageminus50_50,[30 60],'Method','TwoStage', 'Sensitivity', 0.9,'ObjectPolarity','dark');

[slope1,slope2] = Calibration(centers0,centers50,centersminus50);
factor=(abs(slope1)+abs((slope2)))/2;
date = convertCharsToStrings(date);
T=table(slope1,slope2,factor,date);
writetable(T,'C:\Users\Fujitsu\Desktop\Matlab_Holo\CALIBRATION\AOStoMatCalibration.txt');
type 'CALIBRATION\AOStoMatCalibration.txt'


