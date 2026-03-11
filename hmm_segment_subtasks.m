        
 %______________________Analyzed separately for each task
 addpath(genpath('/home/huweiyu/HMM/task_dynamics_project/HMM-MAR-master'))   
 TR = 2;  % TR of timeseries
     options = struct();
    options.K = K; % number of states
    options.order = 0; % no autoregressive components
    options.zeromean = 0; % model the mean
    options.covtype = 'full'; % full covariance matrix
    options.Fs = 1/TR;
    options.verbose = 1;
    options.standardise = 1;
    options.inittype = 'HMM-MAR';
    options.cyc = 500;
    options.initcyc = 10;
    options.initrep = 3;

% %      15=num of state   
  len=[240 120 120 120 120 240];
  G_task1=nan(len(1)*71,15);
  G_task2=nan(len(2)*71,15);
  G_task3=nan(len(3)*71,15);
  G_task4=nan(len(4)*71,15);
  G_task5=nan(len(5)*71,15);
  G_task6=nan(len(6)*71,15);


  for t = 1:71
    % ----- Pre-rest block -----
    G_task1((t-1)*240 + 1 : t*240, :) = Gamma((t-1)*960 + 1 : (t-1)*960 + 240, :);

    % ----- Task blocks -----
    % Task block 1: 120
    G_task2((t-1)*120 + 1 : t*120, :) = Gamma((t-1)*960 + 241 : (t-1)*960 + 360, :);

    % Task block 2: 120
    G_task3((t-1)*120 + 1 : t*120, :) = Gamma((t-1)*960 + 361 : (t-1)*960 + 480, :);

    % Task block 3: 120
    G_task4((t-1)*120 + 1 : t*120, :) = Gamma((t-1)*960 + 481 : (t-1)*960 + 600, :);

    % Task block 4: 120
    G_task5((t-1)*120 + 1 : t*120, :) = Gamma((t-1)*960 + 601 : (t-1)*960 + 720, :);

    % ----- Post-rest block -----
    G_task6((t-1)*240 + 1 : t*240, :) = Gamma((t-1)*960 + 721 : (t-1)*960 + 960, :);
end


   Gamma=G_task5;

  T = cell(n_sub,1);

for j = 1:n_sub

    T{j}=[120];%only one task

end
%____________________________________________________________________________
