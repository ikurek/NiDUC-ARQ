%Funkcja zwraca ciąg bitów z dodaną odpowiednią ilością błędów
%Param ciagBitow - Oryginalny ciąg bitowy
%Param iloscBledow - Ilość zamian jakie mają być wykonane
function Y = generujBitParzystosci(ciagBitow)

    Y = ciagBitow;
    bit = rem(sum(Y),2) == 1;
    Y(length(Y) + 1) = bit;
    
end