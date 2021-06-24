function [rightpoints_2,leftpoints_2,upperpoints_2,downpoints_2] = MatCoord_2(centers_01,rightpoints,leftpoints,upperpoints,downpoints)
%UNTITLED2 From a camera input image coordinates obtain a new matlab coordinates that
%are adequate to geerate a phase mask.
%variable centers must be an array of center coordinates from the camera
%image
A= readtable('C:\Users\Fujitsu\Desktop\Matlab_Holo\CALIBRATION\AOStoMatCalibration.txt');
factor =table2array(A(1,'factor'));
%matlab/camera conversion factor
%cacluate X/Y coordinates for matlab:
for i=1:230
rightpoints_2(i,1)=((rightpoints(i,1)-centers_01(1))/factor + 0); %0 is the matlab's center coordinate for x
rightpoints_2(i,2)=((rightpoints(i,2)-centers_01(2))/factor + 0);
leftpoints_2(i,1)=((leftpoints(i,1)-centers_01(1))/factor + 0); %0 is the matlab's center coordinate for x
leftpoints_2(i,2)=((leftpoints(i,2)-centers_01(2))/factor + 0);
upperpoints_2(i,1)=((upperpoints(i,1)-centers_01(1))/factor + 0); %0 is the matlab's center coordinate for x
upperpoints_2(i,2)=((upperpoints(i,2)-centers_01(2))/factor + 0);
downpoints_2(i,1)=((downpoints(i,1)-centers_01(1))/factor + 0); %0 is the matlab's center coordinate for x
downpoints_2(i,2)=((downpoints(i,2)-centers_01(2))/factor + 0);
end

