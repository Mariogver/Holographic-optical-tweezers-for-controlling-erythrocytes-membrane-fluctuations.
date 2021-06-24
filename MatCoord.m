function [MatCoord] = MatCoord(centers_0,centers,ncenters);
%UNTITLED2 From a camera input image coordinates obtain a new matlab coordinates that
%are adequate to geerate a phase mask.
%variable centers must be an array of center coordinates from the camera
%image
A= readtable('C:\Users\Fujitsu\Desktop\Matlab_Holo\CALIBRATION\AOStoMatCalibration.txt');
factor =table2array(A(1,'factor'));
%matlab/camera conversion factor
MatCoord=[]
%cacluate X/Y coordinates for matlab:
for i=1:ncenters(1)
MatCoord(i,1)=((centers(i,1)-centers_0(1))/factor + 0); %0 is the matlab's center coordinate for x
MatCoord(i,2)=((centers(i,2)-centers_0(2))/factor + 0);
end




end
