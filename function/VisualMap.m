function [global_dot, L_marshrut] = VisualMap (map, m1_indif, m1, ...
    marshrut_all, marshrut_mass_cell, L_mass)

global inf
%Визуализация

Y = size(map,1);
X = size(map,2);
MAP = map';

figure
hold on %Построение карты
grid on
axis('equal');
for n = 0:1:Y
line([0 X], [-n -n])
end
for n = 0:X
line([n n], [0 -Y])
end

%Точки-препятствия
i = find(MAP == inf);
[y_p, x_p] = cordinate(i,X);
for i = 1:length(y_p)
    line([x_p(i) x_p(i)-1],[-y_p(i) -y_p(i)+1])
    line([x_p(i) x_p(i)-1],[-y_p(i)+1 -y_p(i)])
end

%Перевод m1_indif из относителных номеров точек в абсолютные
m_map = m1_indif;
for i = 1:length(m1)
m_map(find(m1_indif == i)) = m1(i);
end

%Точки обсервации (номера групп)
for n = 1:size(m1_indif,2)
    d_map = m_map(:,n);
    d_map(find(d_map == 0)) = [];
[y_o, x_o] = cordinate(d_map,X);
for i = 1:length(y_o)
text(x_o(i)-0.5, -y_o(i)+0.5, num2str(n))
end
end




%Построение маршрута между основными группами
global_dot = marshrut_all';
global_dot = global_dot(:);
global_dot(global_dot==0) = [];   %удаление нулей
global_dot = unique(global_dot,'stable'); %удаление повторяющихся элементов 
global_dot(end + 1) = global_dot(1);  %Замыкание



%Перещет длинны маршрута
L_marshrut = 0;

for n = 1:length(global_dot)-1
graf_marshrut = marshrut_mass_cell{global_dot(n),global_dot(n+1)};

%Перещет длинны маршрута
L_marshrut = L_marshrut + L_mass(global_dot(n),global_dot(n+1));


%Перевод в координаты карты
[y_m, x_m] = cordinate(graf_marshrut,X);

%Построение на карте
for i = 1:length(graf_marshrut)-1
  plot([x_m(i)-0.5 x_m(i+1)-0.5], [-y_m(i)+0.5 -y_m(i+1)+0.5],'k')
end

end



%Длинна маршрута
title(['Самый короткий маршрут до "прохождения". Его длина равна ' num2str(L_marshrut)])
