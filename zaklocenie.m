%Funkcja zwraca ci�g bit�w z dodan� odpowiedni� ilo�ci� b��d�w
%Param ciagBitow - Oryginalny ci�g bitowy
%Param iloscBledow - Ilo�� zamian jakie maj� by� wykonane
function Y = zaklocenie(ciagBitow, pp)
    Y=ciagBitow;
    for i = 1 : length(Y)   
        wylosowana=randi([0,100]);
        if (wylosowana<pp)
            Y(i)=~Y(i);
        end
    end