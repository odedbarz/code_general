function nDoLatency()
    
hLT=findobj('tag','LatencyFig');
if ~isempty(hLT),
    figure(hLT);
  else 
    a = figure('Color',[0.8 0.8 0.8], ...
      'Units', 'points', ...
      'Name', 'latency', ...
      'Menubar','none', ...
    	'Position',[10 10 385 270], ...
    	'Tag','LatencyFig');
    b = axes('Parent',a, ...
    	'Units','points', ...
    	'ButtonDownFcn','pickLatency', ...
    	'CameraUpVector',[0 1 0], ...
    	'CameraUpVectorMode','manual', ...
    	'Color',[1 1 1], ...
    	'Position',[50 130 320 125], ...
    	'Tag','LatencyAxes', ...
    	'XColor',[0 0 0], ...
    	'YColor',[0 0 0], ...
    	'ZColor',[0 0 0]);
    c = text('Parent',b, ...
    	'Color',[0 0 0], ...
    	'HandleVisibility','callback', ...
    	'HorizontalAlignment','center', ...
    	'Position',[0.5 -0.127 0], ...
    	'Tag','Text1', ...
    	'VerticalAlignment','cap');
    set(get(c,'Parent'),'XLabel',c);
    c = text('Parent',b, ...
    	'Color',[0 0 0], ...
    	'HandleVisibility','callback', ...
    	'HorizontalAlignment','center', ...
    	'Position',[-0.066 0.5 0], ...
    	'Rotation',90, ...
    	'Tag','Text2', ...
    	'VerticalAlignment','baseline');
    set(get(c,'Parent'),'YLabel',c);
    c = text('Parent',b, ...
    	'Color',[0 0 0], ...
    	'HandleVisibility','callback', ...
    	'HorizontalAlignment','right', ...
    	'Position',[-0.146 1.120 0], ...
    	'Tag','Text3', ...
    	'Visible','off');
    set(get(c,'Parent'),'ZLabel',c);
    c = text('Parent',b, ...
    	'Color',[0 0 0], ...
    	'HandleVisibility','callback', ...
    	'HorizontalAlignment','center', ...
    	'Position',[0.5 1.050 0], ...
    	'Tag','Text4', ...
    	'VerticalAlignment','bottom');
    set(get(c,'Parent'),'Title',c);
    b = uicontrol('Parent',a, ...
    	'Units','points', ...
    	'BackgroundColor',[0.7 0.7 0.7], ...
    	'Callback','latencyRadios', ...
    	'Position',[10 80 55 20], ...
    	'String','CF', ...
    	'Style','radiobutton', ...
    	'Tag','CFRadio', ...
    	'Value',1);
    b = uicontrol('Parent',a, ...
    	'Units','points', ...
    	'BackgroundColor',[0.7 0.7 0.7], ...
    	'Callback','latencyRadios', ...
    	'Position',[10 60 55 20], ...
    	'String','Range', ...
    	'Style','radiobutton', ...
    	'Tag','RangeRadio');
    b = uicontrol('Parent',a, ...
    	'Units','points', ...
    	'BackgroundColor',[1 1 1], ...
    	'Enable', 'inactive', ...
    	'HorizontalAlignment','left', ...
    	'Position',[70 60 300 20], ...
    	'String','unmarked', ...
    	'Style','edit', ...
    	'Tag','SelRangeEdit');
    b = uicontrol('Parent',a, ...
    	'Units','points', ...
    	'BackgroundColor',[0.7 0.7 0.7], ...
    	'Callback', 'selectLatency', ...
    	'Position',[255 35 55 20], ...
    	'String','Accept', ...
    	'Tag','MarkLatencyButton');
    b = uicontrol('Parent',a, ...
    	'Units','points', ...
    	'BackgroundColor',[0.7 0.7 0.7], ...
    	'Callback', '[hobj, hfig] = gcbo; delete(hfig)', ...
    	'Position',[315 35 55 20], ...
    	'String','Dismiss', ...
    	'Tag','DismissButton');
    b = uicontrol('Parent',a, ...
    	'Units','points', ...
    	'BackgroundColor',[0.7 0.7 0.7], ...
    	'Callback','latencyZoom', ...
    	'Position',[195 35 55 20], ...
    	'String','Zoom', ...
    	'Style','radiobutton', ...
    	'Tag','ZoomRadio');
    b = uicontrol('Parent',a, ...
    	'Units','points', ...
    	'BackgroundColor',[1 1 1], ...
    	'Enable', 'inactive', ...
    	'HorizontalAlignment','left', ...
    	'Position',[70 80 300 20], ...
    	'String','unmarked', ...
    	'Style','edit', ...
    	'Tag','CFRangeEdit');
    b = uicontrol('Parent',a, ...
    	'Units','points', ...
    	'BackgroundColor',[1 1 1], ...
    	'Enable', 'inactive', ...
    	'HorizontalAlignment','left', ...
    	'Position',[10 5 360 20], ...
    	'Style','edit', ...
    	'Tag','LatencyMessage');
      
    b = uimenu('Label', 'Print', 'Tag', 'PrintMenu');
    c = uimenu(b, 'Label', 'Page Position...', ...
            'Callback', 'pagedlg');
    c = uimenu(b, 'Label', 'Print All...', ...
            'Callback', 'printdlg');
    c = uimenu(b, 'Label', 'Print Axes...', ...
            'Callback', 'printAxes');
 
    b = uimenu(a, 'Label', 'Window', ...
       'Callback', winmenu('callback'), 'Tag', 'winmenu');
    winmenu(a);  % Initialize the submenu
    
  end % (if)
    
return
