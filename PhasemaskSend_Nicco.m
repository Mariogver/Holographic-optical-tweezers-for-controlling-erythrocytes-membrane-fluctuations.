function PhasemaskSend_Nicco(phasemask)
% Input: Correctly normed phasemask with size 1080 by 1920
% Output: Phasemask send to 2nd monitor (SLM), smaller version displayed on
%         monitor 1

phasemask_norm = uint8(255*mat2gray(phasemask));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % check if phasemask is 1080 by 1920, if not add padding
% if min(size(phasemask))~= 1080 || max(size(phasemask)) ~= 1920
%     m_s = 1080; %height of SLM
%     n_s = 1920; %width of SLM
%     [m, n] = size(phasemask); 
%     %prepare background
% %     phasemask0 = 255*rand([m_s n_s]); 
%     phasemask0 = zeros([m_s n_s]); 
%     % find starting positions to center image
%     m_start = floor((m_s-m)/2)+1; % floor to force integer
%     m_end = m_start + m -1;
%     n_start = floor((n_s-n)/2)+1;
%     n_end = n_start + n - 1;
% 
%     % Add image to target (SLM size)
%     phasemask0(m_start:m_end , n_start:n_end) = phasemask(:,:);
%     phasemask =uint8(255*mat2gray(phasemask0)); % for correct display
% end

 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Small Monitor Figure
% ph_mon = figure();    
% imshow(phasemask); %IMAGESC Scale data and display as image.
% set(ph_mon, 'Position', [200  200 1920/3 1080/3]); %[left bottom width height]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%% Phasemask to SLM v0%%%%%%%%%%%%%%%%%%%%%%%%%
% fig=figure(10);
% imshow(phasemask_norm);
% pause(.01); %needed to correctly send the figure
% %Position — Location and size of figure, excluding borders, title bar, menu
% %bar, and tool bars
% set(fig, 'Position', [1680 0 1920 1080]);  % 1680 [left bottom width height]
% set(fig ,'MenuBar','none','ToolBar','none','resize','off');
% set(gca,'Position',[0 0 1 1],'Visible','off')      %gca: current axes 


% %%%%%%%%%%%%%% Phasemask to SLM v1%%%%%%%%%%%%%%%%%%%%%%%%%
% fig=figure(10);
% set(fig, 'Position', [1680 0 1920 1080]);  % 1680 [left bottom width height]
% % drawnow; % Force display to update immediately.
% set(fig ,'MenuBar','none','ToolBar','none','resize','off');
% set(gca,'Position',[0 0 1 1],'Visible','off')      %gca: current axes 
% imshow(phasemask_norm);

%%%%%%%%%%%%%% Phasemask to SLM v2%%%%%%%%%%%%%%%%%%%%%%%%%
 set(0,'units','pixels'); 
Monitors = get(0, 'MonitorPositions');
% PC_length = Monitors(1,3);
% PC_height = Monitors(1,4);
% PC_x0 = Monitors(1,1);
% PC_y0 = Monitors(1,2);
SLM_length = Monitors(2,3);
SLM_height = Monitors(2,4);
SLM_x0 = Monitors(2,1);
SLM_y0 = Monitors(2,2);

fig=figure(10);
imshow(phasemask_norm)
set(gca,'Position',[0 0 1 1],'Visible','off')      %gca: current axes 
set(fig, 'Position', [SLM_x0 SLM_y0 SLM_length SLM_height]);  %  [left bottom width height]
set(fig ,'MenuBar','none','ToolBar','none','resize','off');


end