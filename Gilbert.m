function Y = Gilbert(ciagBitow, pd,pz)
    Y=ciagBitow;
    stan=true;%jestesmy wstanie dobrym, false - w stanie zlym
    for i = 1 : length(Y)   
        wylosowana=randi([0,100]);
        if (((stan==true) && (wylosowana<pd)) || ((stan==false) && (wylosowana<pz)))
            Y(i)=~Y(i);
            stan=~stan;
        %elseif ((stan==true & wylosowana<1-pd) | (stan==false & wylosowana<1-pz))
           % Y(i)=Y(i);
            %stan=true;
        end
    end