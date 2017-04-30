%Funkcja zwraca ciąg bitów z dodaną odpowiednią ilością błędów
%Param ciagBitow - Oryginalny ciąg bitowy
%Param iloscBledow - Ilość zamian jakie mają być wykonane
function Y = generujSzum(ciagBitow, iloscBledow)

    Y = ciagBitow;

    for i = 1 : iloscBledow
        
        pos = randi(length(ciagBitow));
        if Y(pos) == 1
            Y(pos) = 0;
        else
            Y(pos) = 1;
        end
        
    end
    
end