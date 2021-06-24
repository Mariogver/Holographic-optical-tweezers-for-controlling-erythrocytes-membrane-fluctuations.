function [slope1,slope2] = Calibration(centers_0,centers_50,centers_minus50)
% Calibrate the pixel position from the input image (1000x10000)
%and their equivalent position in Matlab pixel scale.
%   The reationship between input image file's pixel size is not 1:1 with
%   Matlab's pixel size. Therefore, to obtain traps in Matlab coordinate
%   system that adequate themselves to the input image size, a linear
%   regression is done between these two variables. 

Xreal=[centers_minus50(1),centers_0(1), centers_50(1)];
Pxmat=[-50,0,50];
Yreal=[centers_minus50(2),centers_0(2), centers_50(2)];

%figure(1),scatter(Pxmat,Xreal);
%figure(2),scatter(Pxmat, Yreal);
%Xreal=reshape(Xreal,3,1);
%Yreal=reshape(Yreal,3,1);
%Pxmat=reshape(Pxmat,3,1);


%regression Xreal to Pxmat:
[P1]= Regression (Pxmat,Xreal);
slope1=P1(1);

%regression Yreal to Pxmat:
[P2] = Regression(Pxmat,Yreal);
slope2 = P2(1);
    function [P]=Regression(x,y) 
     
    figure(8),scatter(x,y) 
    P = polyfit(x,y,1);
    yfit = P(1)*x+P(2);
    hold on;
    plot(x,yfit,'r-.');
    hold off

    end
end

