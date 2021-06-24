function [point]= perimetro(I,centers,izquierda)
%izquierda is a variable that should be fed as 1 if the left point of the
%figure is desired or 0 if you are looking for the right one.
%this function literally studies the intensity profile horizontally from
%the centre and searches for the highest vale of the derivative of the
%polynomial fit to the distribution (steepes slope), and therefore border
%region of the object. This point is retrieved as "point", a two
%dimensional coordinate array.

if izquierda == 1
 b=double(I(centers(1),1:centers(2)));
 a=(1:centers(2));
else
b=double(I(centers(1),centers(2):length(I)));
 a=(centers(2):length(I));
end
[p,S]=polyfit(a,b,13);
y=polyval(p,a);
figure
plot(a,y,'r')
hold on
plot(a,b,'b')
hold off
%%%
f= poly2sym(p);
f2=diff(f);
v=a(20:end-20);
h= subs(f2,v);
h2=double(h);
if izquierda == 1
 u=(20+find(h2==min(h2)));
 point= [u,centers(2)];
else
    u=v(find(h2==max(h2)));
    point =floor([u,centers(2)]);
end

  end


