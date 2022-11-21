Folder for the project on data augmentation for auditory attention decoding by Gerben van Zessen. 

The script `slice_patient_data.m` loops through every `.mat` file for each subject and slices the data in segments of a given window size in seconds, taking into account the sampling rate. It also segments the data for the audio and stores it in a struct format, along with the attended track and attended ear. It uses `slice_data.m` as a helper function. 
This is done on the dataset by KULeuven (10.5281/zenodo.3377910), after running the provided pre-processing script. 
