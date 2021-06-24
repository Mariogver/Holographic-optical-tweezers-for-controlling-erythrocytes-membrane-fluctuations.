function [point]= perimetro_2(I,centers,arriba)
%arriba is a variable that should be fed as 1 if the top point of the
%figure is desired or 0 if the down point is desired. Same functioning as
%perimetro.m but in this case the search is directed vertically from the
%centre.

if arriba == 1
 b=double(I(1:centers(1),centers(2)));
 a=(1:centers(1));
else
b=double(I(centers(1):300,centers(2)));
 a=(centers(1):300);
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
if arriba == 1
 u=(20+find(h2==min(h2)));
 point= [centers(1),u];
else
    u=v(find(h2==max(h2)));
    point =floor([centers(1),u]);
end

  end


