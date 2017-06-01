%porownuje dwie macierze przed wyslaniem i po 
%zwraca w jakim stopniu wyslane pliki sa identyczne jak odebrane
function Y = porownaj(przed, po)
    Y=0;
    z=size(przed,1);
    x=size(przed,2);
    for i = 1 : z 
        for j=1 : x
        if (przed(i,j)==po(i,j))
            Y=Y+1;
        end
    end
    end 
    Y=Y/(z*x)*100;