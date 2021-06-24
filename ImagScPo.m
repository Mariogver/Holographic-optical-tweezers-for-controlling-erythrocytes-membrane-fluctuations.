function [target, imageT] = ImagScPo(im, SLMsize, scale, position)
% TargetFun creates target with padding
% Input
% if 2 input arguments are given: middle, largest possible
% if 3 input arguments: if scale is number: rescale acc to factor
%                       if scale is vector: rescale to size
% if 4 input arguments: put image in given position and not in middle 
% Outout:
% imageT: Target image rescaled, without padding
% target: rescaled target image with padding
imageT = double(im);
m_s= SLMsize(1);
n_s = SLMsize(2);
if nargin == 2      % Scale as big as possible

%         scale = (max(SLMsize)/max(size(im)));
%         imageT = imresize(imageT,[m_s n_s]);
        scale = (min(SLMsize)/max(size(im)));
        imageT = imresize(imageT,scale);
else  %Scale according to scale, if length(scale) = 1: use factor
        %if length(scale) = 2: rescale to target size
        imageT = imresize(imageT,scale);
end

if nargin < 4 % if no position given center image
    [m, n] = size(imageT);
    % Add padding to reach 1080 by 1920 with target image in center
    % find starting positions to center image
    m_start = floor((m_s-m)/2)+1; % floor to force integer
    m_end = m_start + m -1;
    n_start = floor((n_s-n)/2)+1;
    n_end = n_start + n - 1;
else
    [m, n] = size(imageT);
    % Add padding to reach 1080 by 1920 with target image on position
    % find starting positions to put image on desired position
    m_start = position(1)-m/2; % x position of image
    m_end = m_start + m -1;
    n_start = position(2)-n/2; % y position of image
    n_end = n_start + n - 1;
end
%prepare black background
target = zeros([m_s n_s]); %255 due to 8 bit
% Add image to target background of SLM size
target(m_start:m_end , n_start:n_end) = imageT(:,:);
end