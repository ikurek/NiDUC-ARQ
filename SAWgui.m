function varargout = SAWgui(varargin)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
        'gui_Singleton',  gui_Singleton, ...
        'gui_OpeningFcn', @SAWgui_OpeningFcn, ...
        'gui_OutputFcn',  @SAWgui_OutputFcn, ...
        'gui_LayoutFcn',  [], ...
        'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
end


function SAWgui_OpeningFcn(hObject, eventdata, handles, varargin)
    handles.output = hObject;
    guidata(hObject, handles);


function varargout = SAWgui_OutputFcn(hObject, eventdata, handles)
    varargout{1} = handles.output;


% --- Executes on button press in koniec.
function koniec_Callback(hObject, eventdata, handles)
    clear all;
    close all;


% --- Executes on button press in generuj.
function generuj_Callback(hObject, eventdata, handles)
   try     %'try' gwarantuje, ¿e errory lub warningi nie bêd¹ wyœwietlane
        %które s¹ spowodowane guzikiem koniec (idk why, od roku siê nie
        %dowiedzia³am dlaczego tak jest)
        tic;
        timerVal=tic;

        iloscpakietow=str2num(get(handles.iloscpakietow,'String'));             %pobieranie danych z okienek GUI
        wielkoscpakietow=str2num(get(handles.wielkoscpakietow,'String'));
        if (get(handles.binary,'Value')==get(handles.binary,'Max'))
            procbledow=str2num(get(handles.bledy,'String'));
        end
        
        if (get(handles.gilbert,'Value')==get(handles.gilbert,'Max'))
            dobry1=str2num(get(handles.dobry,'String'));
            zly1=str2num(get(handles.zly,'String'));
        end
        iloscbitow=iloscpakietow*wielkoscpakietow;
        bity = generujBity(iloscpakietow,wielkoscpakietow);                     %generowanie macierzy bitów (iloœæ x wielkoœæ)
        k=1;
        wszystkiebity=0;
        while k~=iloscpakietow+1                                                %pêtla 'dopóki wszystkie pakiety nie bêd¹ 'dobre''
            set(handles.sright, 'String','')                                    %zerowanie wartoœci tekstowych w GUI
            set(handles.sleft, 'String','')
            set(handles.odbiorca2, 'String', '')
            pakiet=bity(k,:);
            set(handles.nadawca1,'String','Tworzê pakiet...');

           % pause(0.1);
            if (get(handles.crc,'Value')== get(handles.crc,'Max'))
                dowyslania=generujCRC(pakiet);   %generuje kod CRC i dopisuje do pakietu
            else
                dowyslania=SumaKontrolna(pakiet);
            end                                      %generuje kod CRC i dopisuje do pakietu
            set(handles.nadawca1,'String',strcat('Wysy³am pakiet:',num2str(k)));
            buforprzed(k,:)=dowyslania;
            
            a='>';
            for i=1:8                                                           %pêtla 'rysuj¹ca' strza³kê wysy³ania pakietu
                a=strcat('-',a);
                set(handles.sright, 'String',a)
             %   pause(0.1)
            end

            if (get(handles.binary,'Value')== get(handles.binary,'Max'))
                wyslany=zaklocenie(dowyslania,procbledow);                          %wysy³any pakiet z ewentualnymi zak³óceniami
            else
                wyslany=Gilbert(dowyslania,dobry1,zly1); 
            end                          
            set(handles.nadawca1,'String',strcat('Wys³ano pakiet:',num2str(k)));
            buforodbiornika(k,:)=wyslany;
                        
            wszystkiebity=wszystkiebity+wielkoscpakietow;
                       
            set(handles.odbiorca2,'String','');
            set(handles.odbiorca1,'String','Odbieram...');
            odebrany=wyslany;
            
            %pause(0.1);
           set(handles.odbiorca1,'String',strcat('Sprawdzam pakiet:',num2str(k)));
           % pause(0.1);

            if (get(handles.crc,'Value')== get(handles.crc,'Max'))
                czyBlad=dekodujCRC(odebrany);
            else
                czyBlad=sprawdzenieSumyKontrolnej(odebrany);
            end

            if ~czyBlad
                set(handles.odbiorca1,'String',strcat('Sprawdzony pakiet:',num2str(k)));
                set(handles.odbiorca2,'String','ACK','ForegroundColor','g');    %wyœlij do nadajnika ACK
                k=k+1;                                                          %przejœcie do kolejnego pakietu
            else
                set(handles.odbiorca2,'String','NACK','ForegroundColor','r');   %wyœlij do nadajnika NACK
            end
            

            a='<';
            for i=1:8                                                           %pêtla rysuj¹ca strza³kê wysy³ania odp odbiornika
                a=strcat(a,'-');
                set(handles.sleft, 'String',a)
                %pause(0.1)
            end
            %pause(0.05)
        end
        set(handles.sright, 'String',strcat('Efektywnoœæ=',num2str(iloscbitow/wszystkiebity*100),'%'));
        jakosc=porownaj(buforprzed,buforodbiornika);
        set(handles.sleft, 'String',strcat('Jakoœæ=',num2str(jakosc),'%'));
        toc
        set(handles.timer,'String',toc);
    end


    function dobry_Callback(hObject, eventdata, handles)



    % --- Executes during object creation, after setting all properties.
    function dobry_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function zly_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function zly_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bledy_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function bledy_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function iloscpakietow_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function iloscpakietow_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function wielkoscpakietow_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function wielkoscpakietow_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
