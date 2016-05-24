function roiSaveAsNifti(vw, fname, roiColor)
% function roiSaveAsNifti(vw, fname, roiColor)
%
% Aug 2008: JW
%
% Save a mrVista ROI as a nifti file. The data field in the nifti file
% contains the value roiColor for each coordinate that is in the ROI. Other
% coordinates are 0. The nifti header information is propagated from the
% whole brain underlay (vANATOMY).
%
% See roiSaveAllForItkGray.m

% check vars
mrGlobals;

if notDefined('vw'), vw = getCurView; end

viewType = viewGet(vw, 'viewtype');
switch lower(viewType)
    case {'gray', 'volume'}, ROI = viewGet(vw, 'roistruct');
    otherwise, error('[%s]: Must be in gray view', mfilename);
end

if notDefined('fname'),
    fname = fullfile(fileparts(vANATOMYPATH), [ROI.name '.nii.gz']);
end

% By default, ROI value is 1
if notDefined('roiColor'), roiColor = 1; end

% Get ROI coords
coords = getCurROIcoords(vw);
len = size(coords, 2);

% make a 3D image with all points set to zero except ROI = roiColor
roiData = zeros(viewGet(vw, 'anatomy size'));
for ii = 1:len
    roiData(coords(1,ii), coords(2,ii), coords(3,ii)) = roiColor;
end

    
% Convert mrVista format to our preferred axial format for NIFTI
mmPerVox = viewGet(vw, 'mmPerVox');
[data, xform, ni] = mrLoadRet2nifti(roiData, mmPerVox);  %#ok<ASGLU>
ni.fname = fname;

% Use the header information from the volume anatomy so that the ROI file
% and the anatomy file have identical headers.
[tmp, tmp, ext] = fileparts(vANATOMYPATH); %#ok<ASGLU>
if ismember(ext, {'.nii', '.gz'}) 
    if ~exist(vANATOMYPATH, 'file')
        warning('vANATOMYPATH not found. Not using vANAT header') %#ok<WNTAG>
    else
        ni       = niftiRead(vANATOMYPATH);
        ni.fname = fname;
        ni.data  = data;
        ni.scl_slope  = 1; % this appears to be necessary for the file to be readable in freesurfer
    end
end

writeFileNifti(ni);

message = (['file saved as ' fname]);
msgbox(message)

return
