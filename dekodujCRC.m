%Funckja dekoduj�ca;
%zwraca: 0 - gdy nie ma b��d�w w kodowaniu CRC, 1 - gdy s� b��dy

function frmError=dekodujCRC(data)
det=comm.CRCDetector([1 0 0 0 0 0 1 0 0 1 1 0 0 0 0 0 1 0 0 0 1 1 0 0 1 1 0 1 1 0 1 1 1]);
[~,frmError] = step(det,data');

