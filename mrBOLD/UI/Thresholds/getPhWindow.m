function phWindow = getPhWindow(vw)
%
% phWindow = getPhWindow(<vw = current view>)
%
% Gets phWindow values from phWindow sliders (non-hidden views)
% or from the view.settings.phWin field (hidden views). If can't
% find either, defaults to [0 2*pi].
%
% ras 06/06.
if nargin<1, vw = getCurView; end

phWindow = viewGet(vw, 'phWindow');

warning('vistasoft:obsoleteFunction', 'getPhWindow.m is obsolete.\nUsing\n\tphWindow = viewGet(vw, ''phWindow'')\ninstead.');

return
