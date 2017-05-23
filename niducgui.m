function varargout = niducgui(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @niducgui_OpeningFcn, ...
                   'gui_OutputFcn',  @niducgui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% --- Executes just before niducgui is made visible.
function niducgui_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = niducgui_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;

% --- Executes on button press in generuj.
function generuj_Callback(hObject, eventdata, handles)

iloscpakietow=str2num(get(handles.iloscpakietow,'String'));
wielkoscpakietow=str2num(get(handles.wielkoscpakietow,'String'));
procbledow=str2num(get(handles.bledy,'String'));
bity = generujBity(iloscpakietow,wielkoscpakietow)
set(handles.wyniki,'String',num2str(bity));
guidata(hObject,handles);
for k = 1 : iloscpakietow
      pakiet=bity(k,:);
      crc=CRCGen(pakiet);
      bufor(k,:)=crc;
end
dowyslania=[bity , bufor];
for k=1 : iloscpakietow
      pakiet=dowyslania(k,:)
      wyslany=zaklocenie(pakiet,procbledow);
      odebrany=wyslany(k,1:(length(wyslany)-32))
      crc=CRCGen(odebrany);
      bufor(k,:)=crc;
      if((wyslany(k,length(wyslany)-31:length(wyslany)))~=bufor(k,:))
         % k=k-1;
      else
          odebranepakiety(k,:)=odebrany;
      end
end
odebranepakiety

function iloscpakietow_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function iloscpakietow_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function bledy_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function bledy_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

zaklocenie(ciagbitow, pp)

generujBity(iloscpakietow,wielkoscpakietu)

generujCRC(data)

function wielkoscpakietow_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function wielkoscpakietow_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in akceptuj.
function akceptuj_Callback(hObject, eventdata, handles)

% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
