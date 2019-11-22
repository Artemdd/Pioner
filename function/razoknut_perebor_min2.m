function [L, marshrut] = razoknut_perebor_min2(m, StartFin, L_mass)
%Функция-решатель разомкнутой задачи Комивояжера методом прямого перебора
% Исользуется в LastPerebor
%Так как заданы точки старта и финиша перебрает (n-2)! вариантов маршрутов
%
% m - массив точек, которые нужно перерасределить 


global inf 
L = inf;

start = StartFin(1);
fin = StartFin(2);
marshrut = [];

%Заразервируем точки старта и финиша.
%Делается для того, чтобы согласовать с материнской программой и
%уменшить вычисления
%именно за счет этого достигается (n-2)! колличество вычислений
m(m == 0) = []; 
m(m == start) = []; 
m(m == fin) = [];

sizem = length(m);

%Определения типа решения разомкнутой задачи
if sizem <= 1  %Ничего менятьь не надо
    marshrut = m;

else 

%функция распределения. стандартная функция матлаба
m_massiv = perms(m);


for n = 1:size(m_massiv,1)

%Нахождение длинны маршрута
L_new = L_mass(start, m_massiv(n,1));  %Длинна между start и вторым 
for i = 1:sizem-1  %Длинны между последующими 
L_new = L_new + L_mass(m_massiv(n,i),m_massiv(n,i+1)); 
end
L_new = L_new + L_mass(m_massiv(n,i+1),fin);  %между предпосленим и fin
%Конец нахождения длинны маршрута

%Проверка на длинну
if L_new < L
    L = L_new; 
    marshrut = m_massiv(n,:);
end


end

end  

end