clear all
% Process all 16 subject data
params.window_size = 5;
newdir = sprintf("segmented_%ds", params.window_size)
if not(isfolder(newdir))
   mkdir(newdir)
end

for s_nr = 1:16
    s_file = sprintf("S%d.mat",s_nr);
    disp(s_file)
    load(s_file)
    %% The sampling size is 32hz. Therefore, to obtain 10s slices, we need to make slices of 320 samples long. Each participant has 20 trials. 
    params.nr_trials = max(size(preproc_trials));
    params.fs = 32;
    params.segment_length = params.window_size * params.fs;
    params.channels_nr = 64;
    newdir = sprintf("segmented_%ds", params.window_size);
    
    for i = 1:params.nr_trials
        preproc_trial = preproc_trials{i};
        preproc_trial_data = preproc_trial.RawData.EegData;
        preproc_trial_envelope = preproc_trial.Envelope.AudioData;
        % Amount of samples for this trial
        preproc_trial_data_length = max(size(preproc_trial.RawData.EegData));
    
        % Slice data
        preproc_trial_data_r = slice_data(preproc_trial_data, params.fs, params.window_size, params.channels_nr);
    
        % Sum audio envelope subbands
        summed_env = squeeze(sum(preproc_trial_envelope, 2)); % Sum 15 subbands and remove 1 dimension
        
        % Slice audio envelopes. channels_nr refers to left and right audio
        % envelope.
        sliced_env = slice_data(summed_env, params.fs, params.window_size, 2); 
    
        % Repeat steps but remove first segment_length / 2 samples to make the
        % segments that overlap 50%
        trunc_begin = (params.segment_length / 2) + 1;
        preproc_trial_overlap = preproc_trial_data(trunc_begin:end, :);
        preproc_trial_overlap_r = slice_data(preproc_trial_overlap, params.fs, params.window_size, params.channels_nr);
    
        % Slice audio for 50% overlappers
        sliced_env_overlap = summed_env(trunc_begin:end, :);
        sliced_env_overlap = slice_data(sliced_env_overlap, params.fs, params.window_size, 2);
    
        % Concatenate arrays
        trial_segments = cat(1, preproc_trial_data_r, preproc_trial_overlap_r);
        trial_envelopes = cat(1, sliced_env, sliced_env_overlap);
        
        % Save data in struct
        sliced_trial.eeg = trial_segments;
        sliced_trial.env = trial_envelopes;
        sliced_trial.att_track = preproc_trial.attended_track - 1;
        sliced_trial.att_ear = preproc_trial.attended_ear;
        sliced_trials(i) = sliced_trial;
    end
    
    %%
    s_filename = sprintf("segmented_%ds/S%d_proc.mat", params.window_size, s_nr);
    save(s_filename, "sliced_trials", '-mat')
end