function Y = sprawdzenieSumyKontrolnej( ciagBitow )
    %program odczytujacy ostatnie 8 bitow z ciagu, zamienia na liczbe
    %dziesietna, natepnie sam oblicza sume kontrolna z wszystkich bitow
    %oprocz 8 ostatnich, oblicza z nich sumê. Ostatecznie porownuje sumy
    %kontrolne otrzymane i obliczone i zwraca czy siê zgadzaj¹, czy sa
    %rowne.
    
    Y=ciagBitow; %przypisanie ciagu bitow do Y
    ostatnieBity=[];    %deklaracja macierzy przechowujacej ostatnie 8 bitow 
    
    for i=length(Y)-7 : length(Y)   
        ostatnieBity=[ostatnieBity Y(i)];  %do macierzy dopisuje kolejne bity
    end
    
    str=num2str(ostatnieBity);   %zapisuje sume odczytana jako liczbe dziesietna
    sumaOdczytana=bin2dec(str);   %zapisuje sume kontrolna jako liczbe binarna
       
    pierwszeBity=[];    %macierz przechowywujaca pierwsze bity bez 8 ostatnich
    for i=1 : length(Y)-8   
        pierwszeBity=[pierwszeBity Y(i)];  %do macierzy dopisuje kolejne bity
    end
    sumaObliczona=0;
    str2=num2str(pierwszeBity);   %zapisuje sume odczytana jako liczbe dziesietna
    for j=1: length(pierwszeBity+1)
        if(pierwszeBity(j)==1)
            sumaObliczona=sumaObliczona+1;
        end
    end
    sumaObliczonaMod=mod(sumaObliczona,256); %robimy modulo 256
    
    if(sumaObliczonaMod == sumaOdczytana)
            Y=false;
    else
            Y=true;
    end

