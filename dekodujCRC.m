%Funckja dekoduj¹ca;
%zwraca: 0 - gdy nie ma b³êdów w kodowaniu CRC, 1 - gdy s¹ b³êdy

function frmError=dekodujCRC(data)
det=comm.CRCDetector([1 0 0 0 0 0 1 0 0 1 1 0 0 0 0 0 1 0 0 0 1 1 0 0 1 1 0 1 1 0 1 1 1]);
[~,frmError] = step(det,data');

