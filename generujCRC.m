function encdata=generujCRC(data)
gen=comm.CRCGenerator([1 0 0 0 0 0 1 0 0 1 1 0 0 0 0 0 1 0 0 0 1 1 0 0 1 1 0 1 1 0 1 1 1]);
encdata=[];
[x,y]=size(data);
for i=1:x
    encdata=[encdata;data(i,:)'];
end
encdata=step(gen,encdata);
encdata=encdata(length(encdata)-31:end);