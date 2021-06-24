function [result] = sumacelda(A, ncenters)
%sumacelda La funcion sum de matlab no suma bien los elementos dentro de la
%celda para ibtener una matriz sumatorio de todas.
%   Detailed explanation goes here
result=zeros(1000,1000);
for i=1:ncenters(1)
c=A{1,i};
result=result+c;
end
end

