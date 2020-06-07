function inspect_pull1419
% The code requires the MatNWB toolbox in a version >= 
% NeurodataWithoutBorders/matnwb@a1b1266 (19.05.2020).
% 
% It is assumed that the user is familiar with the basics of MatNWB and 
% the user's system is in a state that would also allow loading the data using MatNWB 
% (MatNWB must be in the path, generateCore must have been run, the correct schema must be 
% installed, see NWB schemas).
% 
% The code was tested with the following example datasets that are freely available online:
%
% From https://gui.dandiarchive.org/#/file-browser/folder/5e6eb2b776569eb93f451f8d:
% sub-YutaMouse20_ses-YutaMouse20-140324_behavior+ecephys.nwb
% 
% From https://osf.io/hv7ja/ 
% P9HMH_NOID5.nwb
%
% At its current stage, the code is not feature-complete. For example:
% 
% we have not implemented ft_read_event. NWB:N is a pretty generic dataformat and can 
% contain very diverse types of data. So we were not sure how to programmatically and 
% reliably create an event output that could be used in a trial function. Waveforms are 
% not read in by ft_read_spike
%
% Useful links:
%
% For examples of spike data structures in FieldTrip see
% http://www.fieldtriptoolbox.org/tutorial/spike/

%% Manual settings
path_matnwb			= '../matnwb';			

% Dataset from https://osf.io/hv7ja/
% Info about the data: https://github.com/rutishauserlab/recogmem-release-NWB
path_nwbfile{1}		=	'D:\NWB\data\NWBData\NWBData\P9HMH_NOID5.nwb';

% Data from https://gui.dandiarchive.org/#/file-browser/folder/5e6eb2b776569eb93f451f8d
% Info about the data: http://www.buzsakilab.com/content/PDFs/Senzai2017Neuron.pdf
path_nwbfile{2}		=	'D:\NWB\data\sub-YutaMouse20_ses-YutaMouse20-140324_behavior+ecephys.nwb'; 

 
%% Initialization
% Make sure no duplicate versions of +types are in the search path
restoredefaultpath()

% Navigate to the systems temporary directory (+types lives here, too, after generateCore())
cd(tempdir) 

% Add matnwb to search path and (re-)generate core classes for matNWB from it's schema (lands in +types)
addpath(genpath(path_matnwb))
generateCore()


%% Conversion Example 1. NWB data, Version 2.1.0
for iDs = 1:numel(path_nwbfile)
	% Load data in nwb format
	nwbFile = path_nwbfile{iDs};
	nwb		= nwbRead(nwbFile);
	
	% Try to obtain hdr, lfp data and spike data in FieldTrip format
	try
		hdr = ft_read_header(nwbFile); % contains no lfp data: throws error
	catch ME
		disp('Could not load in hdr information')
		rethrow(ME)
	end
	try
		dat = ft_read_data(nwbFile); % contains no lfp data: throws error
	catch ME
		disp('Could not load in NWB data')
		rethrow(ME)
	end
	try
		spike = ft_read_spike(nwbFile); % contains spike data: Converts
	catch ME
		disp('Could not read in spike data from NWB file.')
		rethrow(ME)
	end
end