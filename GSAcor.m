function [phasemask, Corr] = GSAcor(target, iter, target_norm, CorrSwitch)
% Gerchberg - Saxton Algorithm 
% Input: 
% target: 2D matrix containing desired intensity
% distribution
% iter: number of iteration of the algorithm
% target_norm: normalized target image for image reconstruction
% CorrSwitch: if 1 correlation is calculated
% Output:
% phasemask: range from -pi to +pi
% Corr: vector containing correlation between reconstructed image and
% target


% Extract size of target
[m ,n] = size(target);

%Shift image to middle
% important to supress multiple images and shift to middle
target = fftshift(target);

%random intial phase between -pi and pi
source_pha =-pi+ 2*pi*rand([m n]);
B = exp(1i*source_pha); %amplitude is assumed as 1

% if Correlation needed construct it 
if CorrSwitch == 1
    Corr(1:iter)=0;
else
    Corr = 0;
end
%iteration loop to find phase distribution to reconstruct the image
for i=1:iter
    %C is FT of B just from random phase
    C=fft2(B);
    % D is amplitude of FT of target with phase of C
    D=sqrt(target).*exp(1i*angle(C));
    A=ifft2(D);
    B=exp(1i*angle(A));
    %if correlation needed reconstruct image and calculate correlation
    if CorrSwitch == 1
    pmcor = abs(fftshift(fft2(exp(1i*angle(A)))));
    Corr(i) = corr2(target_norm,pmcor);
    end
end
phasemask = angle(A); %phasemask is phase ;)
end
