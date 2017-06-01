function Y = SumaKontrolna( ciagBitow )
    %Funkcja dodajaca do wczytanego ciagu bitów sume kontroln¹ zawsze na
    %ostanich 8 bitach.  
    %Funkcja zwraca ciag bitow z suma kontrolna na ostanich 8 bitach

    Y =ciagBitow; %wczytujemy 
    suma=0;
    for i = 1 : length(Y)  
        suma=suma+Y(i);     %liczymy w petle sume kontroln¹, ilosc jedynek w ciagu bitow
    end
    suma2=mod(suma,256); %sume robimy modulo 256
    binarnie=dec2bin(suma2);  %zamieniam sume na liczbe binarna
    binarnieMacierz=(mod(binarnie,2));   %zamieniam liczbe binarna na macierz
    dlugoscBinarnieMacierz=length(binarnieMacierz); %sprawdzam dlugosc naszej sumy kontrolnej
    a=[0];  %macierz o wartosci 0
    iloscZer=8-dlugoscBinarnieMacierz;   %obliczam ile dodac zer przed suma kontrolna zeby lacznie bylo 8 bitow
    for i=1 : iloscZer
        Y=[Y a]; %do ciagu bitow dodaje odpowienia liczbe zer
    end    
    Y=[Y binarnieMacierz];   %do ciagu bitów z odpowiednia liczba zer dodaje sume kontrolna
end

