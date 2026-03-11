n_sub = 71; % Number of subjects
mask = cell(1, n_sub*6); % Preallocate a 1x(6*71) cell array for storing time segments

start_time = 1; % Initialize the starting time point counter

for i = 1:n_sub
    % ----- Pre-rest block -----
    % First 240 time points for pre-rest
    mask{(i-1)*6 + 1} = (start_time : start_time+239)'; 
    start_time = start_time + 240; % Update the starting point for the next segment
    
    % ----- Task blocks -----
    % Four consecutive task blocks, each 120 time points
    for j = 1:4
        mask{(i-1)*6 + 1 + j} = (start_time : start_time+119)';
        start_time = start_time + 120; % Update the starting point
    end
    
    % ----- Post-rest block -----
    % Last 240 time points for post-rest
    mask{(i-1)*6 + 6} = (start_time : start_time+239)';
    start_time = start_time + 240; % Update for next subject
end

% ----- Save the cell array -----
% Save the mask variable into a .mat file named Mask.mat
save('Mask.mat','mask');

disp('mask has been generated for all subjects, each with 6 cells, total rows per subject = 960, saved as Mask.mat');