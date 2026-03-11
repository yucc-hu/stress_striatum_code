clear;
clc;
tic;
addpath(genpath('C:\toolbox\HMM-MAR-master'))


subs_to_use = [1:71];
n_sub = numel(subs_to_use); % no. of subjects(used for concatenation)
% DirData = 'C:\Users\szqin\Documents\MATLAB\HMMStress\data\AAL90\all_0.01-0.15_oldorder\neworder\';
DirData = 'C:\≤© øcode\old_code_liu&reward\HMM_code\data_merge_sorted\';

load C:\≤© øcode\old_code_liu&reward\HMM_code\mask\Mask %TP per participants
% load C:\Users\szqin\Documents\MATLAB\HMMStress\data_pca_Shirer.mat % all of data from PCA, and change the T format if run this line


TR = 2;  % TR of timeseries
J = 12; % ROIs
%             Masks={[1:21606],[21607:33240]};
% %             Masks={[1:12741],[12742:19560]};%‰∏§ÁªÑÂÆûÈôÖÈ°∫Â∫èËøòÊ≤°Êî?
%             Mask(178:240)=[]; %59 participants
Masks = mask;%TP per participants
T = cell(n_sub,1);
data = cell(n_sub,1);

for j = 1:n_sub
    data{j} = [DirData 'sub' num2str(j,'%03d') '.mat'];
    load(data{j});
    T{j}=[240,128,128,128,128,240];%only two task
end

% dat = smoothdata(dat);

% change the T format if PCA first
% if iscell(T)
%     
%     for i = 1:length(T)
%         if size(T{i},1)==1, T{i} = T{i}';
%         end
%     end
%     
%     T = int64(cell2mat(T));
% end
% data = data_pca_Shirer;



for K = 15 % no. states
    reps = 10; % to run it multiple times (saves all the results
    % as a seperate mat file)
    
    
    save_dir =  ['C:\≤© øcode\old_code_liu&reward\HMM_code\result_71K' num2str(K)];
    
    % use with caution, since we potentially remove directory which
    % already exists.
    if exist(save_dir,'dir')
        rmdir(save_dir,'s');
        mkdir(save_dir);
    else
        mkdir(save_dir);
    end
    
    % options for model estimation; I have set the usual choices here
    % for explanation see the HMM-MAR Wiki page at:
    % https://github.com/OHBA-analysis/HMM-MAR/wiki
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
%     options.pca = 0.7; % keep the 75% varianceÔº? need to change!!!

    
    %             options.filter = [0.01 0.15];
    %             options.filter = [0.008 inf];
    
    % run the HMM multiple times - and save the results to .mat
    % files
    for r = 1:reps
        disp(['RUN ' num2str(r)]);
        [hmm, Gamma, ~, vpath, ~, ~, fe] = hmmmar(data,T,options);
        save([save_dir '/HMMrun_rep_' num2str(r) '.mat'],'Gamma','vpath',...
            'hmm','T','J','K','n_sub','fe');
        
        % keyboard;
        % we also save the data now...
        save([save_dir '/HMMrun_rep_' num2str(r) '_data.mat'], 'data');
        
        
        % calculate summary measures for this HMM and save those
        % too to the disk:
        
        mean_em=zeros(J,K); % mean emissions
        for k=1:K
            mean_em(:,k)=getMean(hmm,k);
        end
      
        prob=hmm.P; % transition probabilities,including the persistence probabilities
        %
        %
        %                 do = 1; % do = Flag to replace 0s with NaNs (in all summary measures)
        %                 % do=0 keeps all misisng values as zeros; do=1 sets them
        %                 % to Nans; this is important while comparing between groups!!
        

        FO = getFractionalOccupancy(Gamma,T,options);
        SW = getSwitchingRate(Gamma,T,options);
        LT = getStateLifeTimes(vpath,T,options);
        TP = getTransProbs(hmm);%transition probabilities,not including the persistence probabilities
        [P,Pi] = getMaskedTransProbMats (data,T,hmm,Masks,Gamma); %TP between two groups
        
        save([save_dir '/Summary_measures_rep_',num2str(r) '.mat'],...
            'mean_em','prob','FO','SW','LT','TP','P','Pi');
        
        
    end
end
