%Funkcja generuje ciąg zer i jedynek
%param n - Długość ciągu
function Y = generujBity(n)
  Y = round(rand(1, n));
end