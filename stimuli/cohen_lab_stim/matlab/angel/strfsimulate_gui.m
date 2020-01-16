% function  strfsimulate_gui(action)
%
%
% Input 
%       action 
%                initialize or default
%                open
%                exec
%                close
%                setSound
%                setSprfile
% Output 
%       savefile in the same directory as the selected data file.
%                Its name includes the selected data filename and parameters.
%
% Required files
%       strfsimulate1.m strfsprpre.m strf2pre.m rtwstrfdb_gui.m 
%       impulse2spet.m integratefire.m n1overf.m convlinfft.m
%       movingripple.spr movingripple_param.mat
%       ripplenoise.spr  ripplenoise_param.mat
%
%       

function  strfsimulate_gui(action)

if nargin<1,
    action='initialize';
end;


%to initialize the interface

if strcmp(action,'initialize'),
 shh = get(0,'ShowHiddenHandles');
 set(0,'ShowHiddenHandles','on');
 
  fig=figure( ...
     'Color',[0.8 0.8 0.8], ...
     'handlevisibility','callback',...
     'IntegerHandle','off',...
     'Name','STRF', ...
     'NumberTitle','off',...
     'PaperPosition',[18 180 576 432], ...
	  'PaperUnits','points', ...
     'Position',[150 150 700 450], ...
     'Resize','off',...
	  'Tag','Fig1', ...
	  'ToolBar','none');
       
 Bntclose = uicontrol('Parent',fig, ...
	'Units','points', ...
	'BackgroundColor',[0.83 0.815 0.784], ...
	'Callback','strfsimulate_gui(''close'');',...
	'ListboxTop',0, ...
	'Position',[ 417 42 59.25 23.25 ], ...
	'String','Close', ...
	'Tag','Pushbutton1', ...
	'UserData','[ ]');
BntExec = uicontrol('Parent',fig, ...
	'Units','points', ...
	'BackgroundColor',[0.83 0.815 0.784], ...
	'Callback','strfsimulate_gui(''exec'');', ...
	'ListboxTop',0, ...
	'Position',[ 417 98 60 23.25 ], ...
	'String','Exec', ...
	'Tag','Pushbutton1', ...
	'UserData','[ ]');
PopSound = uicontrol('Parent',fig, ...
	'Units','points', ...
   'BackgroundColor',[0.80 0.80 0.80], ...
   'Callback','strfsimulate_gui(''setSound'');', ...
	'FontSize',9, ...
	'ListboxTop',0, ...
	'Position',[ 415.5 300.75 60 15 ], ...
	'String','MR|RN', ...
	'Style','popupmenu', ...
	'Tag','PopupMenu1', ...
	'UserData','MR', ...
	'Value',1);
TextSound = uicontrol('Parent',fig, ...
	'Units','points', ...
	'BackgroundColor',[0.80 0.80 0.80], ...
	'FontSize',10, ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[ 414.75 322.5 47.25 15 ], ...
	'String','Sound', ...
	'Style','text', ...
	'Tag','StaticText1');
TextSprfile = uicontrol('Parent',fig, ...
	'Units','points', ...
	'BackgroundColor',[0.80 0.80 0.80], ...
	'FontSize',10, ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[ 415.5 274.5 47.25 15 ], ...
	'String','Sprfile', ...
	'Style','text', ...
	'Tag','StaticText1');
PopSprfile = uicontrol('Parent',fig, ...
	'Units','points', ...
   'BackgroundColor',[0.80 0.80 0.80], ...
   'Callback','strfsimulate_gui(''setSprfile'');', ...
	'FontSize',9, ...
	'ListboxTop',0, ...
	'Position',[ 415.5 249 77.25 19.5 ], ...
	'String','movingripple.spr|ripplenoise.spr', ...
	'Style','popupmenu', ...
	'Tag','PopupMenu1', ...
	'UserData','movingripple.spr', ...
	'Value',1);
EditTau = uicontrol('Parent',fig, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','', ...
	'ListboxTop',0, ...
	'Position',[ 30.75 41.25 51.75 18.75 ], ...
	'String','8', ...
	'Style','edit', ...
	'Tag','EditText1', ...
	'UserData','[8]');
TextTau = uicontrol('Parent',fig, ...
	'Units','points', ...
	'BackgroundColor',[0.80 0.80 0.80], ...
	'FontSize',10, ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[ 32.25 66.75 47.25 15 ], ...
	'String','Tau', ...
	'Style','text', ...
	'Tag','StaticText1');
TextNsig = uicontrol('Parent',fig, ...
	'Units','points', ...
	'BackgroundColor',[0.80 0.80 0.80], ...
	'FontSize',10, ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[ 279.75 66 47.25 15 ], ...
	'String','Nsig', ...
	'Style','text', ...
	'Tag','StaticText1');
EditNsig = uicontrol('Parent',fig, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[ 280.5 41.25 51.75 18.75 ], ...
	'String','3', ...
	'Style','edit', ...
	'Tag','EditText1', ...
	'UserData','[3]');
EditSNR = uicontrol('Parent',fig, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[ 150 42 51.75 18.75 ], ...
	'String','9', ...
	'Style','edit', ...
	'Tag','EditText1', ...
	'UserData','[9]');
TextSNR = uicontrol('Parent',fig, ...
	'Units','points', ...
	'BackgroundColor',[0.80 0.80 0.80], ...
	'FontSize',10, ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[ 150 66.75 47.25 15 ], ...
	'String','SNR', ...
	'Style','text', ...
	'Tag','StaticText1');
TextL = uicontrol('Parent',fig, ...
	'Units','points', ...
	'BackgroundColor',[0.80 0.80 0.80], ...
	'FontSize',10, ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[ 416.25 225.75 72.75 15 ], ...
	'String','Length of Block', ...
	'Style','text', ...
	'Tag','StaticText1');
EditL = uicontrol('Parent',fig, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'HorizontalAlignment','right', ...
	'ListboxTop',0, ...
	'Position',[ 416.25 201 51.75 18.75 ], ...
	'String','150', ...
	'Style','edit', ...
	'Tag','EditText1', ...
	'UserData','[150]');
BtnOpen = uicontrol('Parent',fig, ...
	'Units','points', ...
   'BackgroundColor',[0.83 0.815 0.784], ...
   'Callback','strfsimulate_gui(''open'');',...
	'ListboxTop',0, ...
	'Position',[ 417 140.25 60 23.25 ], ...
	'String','......', ...
	'Tag','Pushbutton1', ...
	'UserData','[ ]');
TextOpen = uicontrol('Parent',fig, ...
	'Units','points', ...
	'BackgroundColor',[0.80 0.80 0.80], ...
	'FontSize',10, ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[ 417 172.5 83.25 15 ], ...
	'String','Select STRF File', ...
	'Style','text', ...
	'Tag','StaticText1');
hndaxes = axes('Parent',fig, ...
	'CameraUpVector',[0 1 0], ...
	'CameraUpVectorMode','manual', ...
	'Color',[1 1 1], ...
	'Position',[ 0.04 0.35 0.30 0.48 ], ...
	'Tag','Axes', ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
   'ZColor',[0 0 0]);

hndxaxes = text('Parent',hndaxes, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[0.5 -0.05 9.16], ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(hndxaxes,'Parent'),'XLabel',hndxaxes);
hndyaxes = text('Parent',hndaxes, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[-0.05 0.5 9.16], ...
	'Rotation',90, ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(hndyaxes,'Parent'),'YLabel',hndyaxes);
hndzaxes = text('Parent',hndaxes, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Position',[0 1 9.16], ...
	'Tag','Axes1Text2', ...
	'Visible','off');
set(get(hndzaxes,'Parent'),'ZLabel',hndzaxes);
hndtitle = text('Parent',hndaxes, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
   'Position',[0.5 1 9.16], ...
   'String','',...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(hndtitle,'Parent'),'Title',hndtitle);

hndaxes1 = axes('Parent',fig, ...
	'CameraUpVector',[0 1 0], ...
	'CameraUpVectorMode','manual', ...
	'Color',[1 1 1], ...
	'Position',[ 0.40 0.35 0.30 0.48 ], ...
	'Tag','Axes1', ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
   'ZColor',[0 0 0]);

hndxaxes1 = text('Parent',hndaxes1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[0.5 -0.05 9.16], ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(hndxaxes1,'Parent'),'XLabel',hndxaxes1);
hndyaxes1 = text('Parent',hndaxes1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[-0.05 0.5 9.16], ...
	'Rotation',90, ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(hndyaxes1,'Parent'),'YLabel',hndyaxes1);
hndzaxes1 = text('Parent',hndaxes1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Position',[0 1 9.16], ...
	'Tag','Axes1Text2', ...
	'Visible','off');
set(get(hndzaxes1,'Parent'),'ZLabel',hndzaxes1);
hndtitle1 = text('Parent',hndaxes1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
   'Position',[0.5 1 9.16], ...
   'String','',...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(hndtitle1,'Parent'),'Title',hndtitle1);


hndlist=[EditTau EditSNR EditNsig EditL PopSound PopSprfile hndaxes hndaxes1 fig BtnOpen];
set(fig, ...
	'Visible','on', ...
	'UserData',hndlist);        
return;
%to open data file
elseif strcmp(action,'open'),
   [filename,pathway]=uigetfile('*dB.mat','Open File');
   filename=[pathway filename];
   hndlist=get(gcf,'UserData');
   hnd=hndlist(10);
   set(hnd,'UserData',filename);
   return;   
%to set the type of sound
elseif strcmp(action,'setSound'),
   n=get(gco,'Value');
   s=get(gco,'String');
   set(gco,'Userdata',s(n,:));
   return;
%to set the sprfile that is the same as type of sound
elseif strcmp(action,'setSprfile')
   n=get(gco,'Value');
   s=get(gco,'String');
   set(gco,'Userdata',s(n,1:15));
   return;
%to calculate the STRF and save file
elseif strcmp(action,'exec'),
   hndlist=get(gcf,'Userdata');
   hnd=hndlist(1);
   Tau=str2num(get(hnd,'String'));
   hnd=hndlist(3);
   Nsig=str2num(get(hnd,'String'));
   hnd=hndlist(2);
   SNR=str2num(get(hnd,'String'));
   hnd=hndlist(5);
   SoundType=get(hnd,'UserData');
   hnd=hndlist(4);
   L=str2num(get(hnd,'String'));
   hnd=hndlist(10);
   filename=get(hnd,'UserData');
   hnd=hndlist(6);
   sprfile=get(hnd,'UserData');
   fig=hndlist(9);
   set(gcf,'Visible','off');
   msgbox('Please wait for a few minutes!');
   pause(1);
   [X,Y,timeaxis,freqaxis,STRF1,STRF2,PP,Wo1,Wo2,No1,No2,SPLN]=strfsimulate1(filename,sprfile,Nsig,SNR,Tau,SoundType,L);
   set(fig,'Visible','on');
   hndlist=get(fig,'Userdata');
   hndaxes=hndlist(7);
   axes(hndaxes);
   pcolor(timeaxis,log2(freqaxis/500),STRF1*sqrt(PP));
   shading flat,colormap jet,colorbar;
   title(['No = 'int2str(No1) ' Wo = 'num2str(Wo1,3)]);
   
   hndaxes1=hndlist(8);
   axes(hndaxes1);
   pcolor(timeaxis,log2(freqaxis/500),STRF2*sqrt(PP));
	shading flat,colormap jet,colorbar;
	title(['No = 'int2str(No2) 'Wo = ' num2str(Wo2,3)]); 
   %  save data
   hnd=hndlist(1);
   Tau=str2num(get(hnd,'String'));
   hnd=hndlist(3);
   Nsig=str2num(get(hnd,'String'));
   hnd=hndlist(2);
   SNR=str2num(get(hnd,'String'));
   hnd=hndlist(5);
   SoundType=get(hnd,'UserData');
   hnd=hndlist(10);
   filename=get(hnd,'UserData');
   i=find(filename=='.');
   imfilename=[ filename(1:i-1) '_Tau' num2str(Tau) '_SNR' num2str(SNR) '_Nsig' num2str(Nsig) '_' SoundType '.mat'];
   f=['save ' imfilename ' X Y timeaxis freqaxis STRF1 STRF2 PP Wo1 Wo2 No1 No2 SPLN;'];
   eval(f);   
   return;
else
   close(gcf);
   return;
end;