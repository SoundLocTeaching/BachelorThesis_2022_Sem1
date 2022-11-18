function [sliced_data] = slice_data(preproc_trial_data, fs, window_size, channels_nr)
segment_length = window_size * fs;
preproc_trial_data_length = max(size(preproc_trial_data));

% Amount of segments to be computed
slices_nr = floor(preproc_trial_data_length / segment_length);

% Truncating the EEG data so that all data slices have size segment_length
trunc_lim = segment_length * slices_nr;
preproc_trial_data_trunc = preproc_trial_data(1:trunc_lim, :);

% Slice data using reshape
preproc_trial_data_r = reshape(preproc_trial_data_trunc, segment_length, slices_nr, channels_nr);   
% Permute such that the first dimension corresponds to a segment
% dim1 = segments, dim2 = samples of segment, dim3 = channels
sliced_data = permute(preproc_trial_data_r, [2, 1, 3]);

end