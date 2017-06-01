% Funkcja generuj�ca kod CRC;
% zwraca wektor przyj�tych bit�w z dopisanym kodem CRC

function encdata=generujCRC(data)
gen=comm.CRCGenerator([1 0 0 0 0 0 1 0 0 1 1 0 0 0 0 0 1 0 0 0 1 1 0 0 1 1 0 1 1 0 1 1 1]);
encdata=step(gen,data');
encdata=encdata';

