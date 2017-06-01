function varargout = GBNgu(varargin)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GBNgui_OpeningFcn, ...
                   'gui_OutputFcn',  @GBNgui_OutputFcn, ...
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

function GBNgui_OpeningFcn(hObject, eventdata, handles, varargin)
    handles.output = hObject;
    guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = GBNgui_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;


% --- Executes on button press in koniec.
function koniec_Callback(hObject, eventdata, handles)
clear all;
close all;

% % % % % % % %

function generuj_Callback(hObject, eventdata, handles)
   % try     %'try' gwarantuje, ¿e errory lub warningi nie bêd¹ wyœwietlane
            %które s¹ spowodowane guzikiem koniec (idk why, od roku siê nie
            %dowiedzia³am dlaczego tak jest)
        tic;%zegar
        timerVal=tic;
        
        iloscpakietow=str2num(get(handles.iloscpakietow,'String'));             %pobieranie danych z okienek GUI
        wielkoscpakietow=str2num(get(handles.wielkoscpakietow,'String'));
        if (get(handles.binary,'Value')==get(handles.binary,'Max')) %wybor modelu kanalu miedzi binary 
        procbledow=str2num(get(handles.bledy,'String'));
        end
        iloscbitow=iloscpakietow*wielkoscpakietow;
        if (get(handles.gilbert,'Value')==get(handles.gilbert,'Max'))%a gilbertem
        dobry1=str2num(get(handles.dobry,'String'));
        zly1=str2num(get(handles.zly,'String'));
        end
        
        bity = generujBity(iloscpakietow,wielkoscpakietow);                     %generowanie macierzy bitów (iloœæ x wielkoœæ)
        k=1;                        %licznik do wysylania pakietow 
        o=1;                        %licznik do odbierania pakietow
        wszystkiebity=0;
        while o<=iloscpakietow                                                %pêtla 'dopóki wszystkie pakiety nie bêd¹ 'dobre''
            set(handles.sright, 'String','')                                    %zerowanie wartoœci tekstowych w GUI
            set(handles.sleft, 'String','')
            set(handles.odbiorca2, 'String', '')
            if(k>iloscpakietow)
                k=iloscpakietow;
            end
            wylosowana=(randi([1 (iloscpakietow-k+1)]));    % losujemy ile nadamy pakietow przed pierwszym odczytaniem pakietu
                                                        % przez odbiornik
         for i=1:wylosowana 
            pakiet=bity(k,:);                                                   
            set(handles.nadawca1,'String','Tworzê pakiet...'); 
           % pause(0.15);
            if (get(handles.crc,'Value')== get(handles.gilbert,'Max'))
            dowyslania=generujCRC(pakiet);   %generuje kod CRC i dopisuje do pakietu LUB
            else
            dowyslania=SumaKontrolna(pakiet);   %generuje sume kontrolna
            end
            set(handles.nadawca1,'String',strcat('Wysy³am pakiet:',num2str(k)));
            buforprzed(k,:)=dowyslania;         %macierz pomocnicza do obliczania jakoœci 
            a='>';
            for j=1:8                                                           %pêtla 'rysuj¹ca' strza³kê wysy³ania pakietu
                a=strcat('-',a);
                set(handles.sright, 'String',a)
           %     pause(0.1)
            end
            if (get(handles.binary,'Value')== get(handles.binary,'Max'))
            wyslany=zaklocenie(dowyslania,procbledow);                          %wysy³any pakiet z ewentualnymi zak³óceniami
            else
            wyslany=Gilbert(dowyslania,dobry1,zly1);                            %rozne zaklocenia dla gilberta i bsc
            end
            
            set(handles.nadawca1,'String',strcat('Wys³ano pakiet:',num2str(k)));
            buforodbiornika(k,:)= wyslany;                                       %macierz pomocnicza odebranych pakietow z crc
            wszystkiebity=wszystkiebity+wielkoscpakietow;       %suma wszystkich wyslanych bitow do obliczania efektywnosci
            k=k+1;                                              % jesli wyslalismy pakiet przechodzimy do nastepnego
         end    
    wylosowana2=randi([1,k-o]); %losujemy ile pakietow bedziemy odczytywaæ min 1 max tyleile zostalo wyslane 
    if(k==wielkoscpakietow+1 && o~=wielkoscpakietow+1)%if taki ktory dziala i zapobiega bledom do konca nie wiem jak
        wylosowana2=k-o;
    end
         for u=1:wylosowana2 
            set(handles.odbiorca2,'String','');
            set(handles.odbiorca1,'String','Odbieram...');

            %pause(0.1);
            set(handles.odbiorca1,'String',strcat('Sprawdzam pakiet:',num2str(o)));
            %pause(0.15);
            odebrany=buforodbiornika(o,:);      %przypisanie pojedynczego wiersza z bufora odbiornika
            if (get(handles.crc,'Value')== get(handles.crc,'Max'))
            czyBlad=dekodujCRC(odebrany);%dekododawnie crc
            elseif (get(handles.suma,'Value')== get(handles.suma,'Max'))
            czyBlad=sprawdzenieSumyKontrolnej(odebrany); %dekodowanie suma kontrolna
           % czyBlad=Funkcja(odebrany);
            end
                                                    %1-b³¹d, 0-prawdziwy
            if ~czyBlad                                                         %jeœli 0:
                set(handles.odbiorca1,'String',strcat('Sprawdzony pakiet:',num2str(o)));   
                o=o+1;                  %przejœcie do kolejnego pakietu wtedy kiedy odebrany pakiet jest poprawny
            else
                set(handles.odbiorca2,'String',strcat('NACK-pakiet:',num2str(o)),'ForegroundColor','r');   %wyœlij do nadajnika NACK
                k=o;                                                      % i zacznij wysylac pakiety od nowa od tego ktory jest zly
                set(handles.odbiorca1,'String',strcat('Sprawdzono pakiet:',num2str(o)));
            
            a='<';
            for z=1:8                                                           %pêtla rysuj¹ca strza³kê wysy³ania odp odbiornika
                a=strcat(a,'-');
                set(handles.sleft, 'String',a)
               % pause(0.1)
            end
            break;
            end
           % pause(0.1)
         end
            
        end
        %wyswietlanie jakosci efektywnosci i czasu
        set(handles.sright, 'String',strcat('Efektywnoœæ=',num2str(iloscbitow/wszystkiebity*100),'%'));
        jakosc=porownaj(buforprzed,buforodbiornika);
        set(handles.sleft, 'String',strcat('Jakoœæ=',num2str(jakosc),'%'));
        toc;
        set(handles.timer,'String',toc);
        
   % end

function bledy_Callback(hObject, eventdata, handles)

function bledy_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function iloscpakietow_Callback(hObject, eventdata, handles)

function iloscpakietow_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function wielkoscpakietow_Callback(hObject, eventdata, handles)

function wielkoscpakietow_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dobry_Callback(hObject, eventdata, handles)
% hObject    handle to dobry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dobry as text
%        str2double(get(hObject,'String')) returns contents of dobry as a double


% --- Executes during object creation, after setting all properties.
function dobry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dobry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zly_Callback(hObject, eventdata, handles)
% hObject    handle to zly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zly as text
%        str2double(get(hObject,'String')) returns contents of zly as a double


% --- Executes during object creation, after setting all properties.
function zly_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
