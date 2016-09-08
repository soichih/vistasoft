function volCoords = ip2volXformCoords(inplane, gray)
% Return coords from Volume view that correspond to coords in
% mrVista inplane coords
%
%  volCoords = ip2volXformCoords(inplane, gray)
%
% We first get a 3xn matrix of inplane coordinates and find the
% corresponding volume  coordinates. 
%
% INPUTS
%   inplane: mrVista view structure (must be an inplane view)
%   gray: mrVista view structure (must be a gray view)
%   preserveExactValues: boolean. If false, return integer coordinates. If
%                   true, return the calculated (non-integer values). If
%                   non-integer values are returned, then the parent
%                   function will have to deal with these, e.g., via
%                   interpolation.
% OUTPUTS
%   volCoords: 3xn matrix of coordinates in Volume space
%                   corresponding to 3xn matrix of inplane functional  coords
%
% Example:
%   volCoords = ip2volXformCoords(inplane, gray)
%
%
% CO & JW 2016.01.14

% Don't do this unless inplane is really an inplane and volume is really a volume
if ~strcmp(viewGet(inplane, 'viewType'),'Inplane')
    myErrorDlg('ip2volParMap can only be used to transform from inplane to volume/gray.');
end
if ~strcmp(viewGet(gray, 'viewType'),'Volume') &&~strcmp(viewGet(gray, 'viewType'),'Gray')
    myErrorDlg('ip2volParMap can only be used to transform from inplane to volume/gray.');
end

% we need mrSESSION for the alignment matrix
mrGlobals;

% The gray coords are the integer-valued (y,x,z) volume 
% coordinates that correspond to the inplanes.  Convert to
% homogeneous form by adding a row of ones.
inplaneCoords  = viewGet(inplane, 'coords');
nVoxels        = size(inplaneCoords, 2);
inplaneCoords  = double([inplaneCoords; ones(1,nVoxels)]);

% inplane2VolXform is the 4x4 homogeneous transform matrix that
% takes inplane (y',x',z',1) coordinates into Volume (y,x,z,1)
% coordinates.
inplane2VolXform = sessionGet(mrSESSION,'alignment');

% We don't care about the last coordinate in (y,x,z,1), so we
% toss the fourth row of Xform.  Then our outputs will be (y,x,z).
% 
inplane2VolXform = inplane2VolXform(1:3,:);

% Transform coord positions to the volume.  Hence, grayCoords
% contains the volume position of each of the inplane  voxels.  These
% will generally not fall on integer-valued coordinates, rather they will
% fall between voxels.  Other functions that rely on the output of this
% function will require interpolation to get the data at these
% between-voxel positions.
% 
volCoords = inplane2VolXform*inplaneCoords; 


return
