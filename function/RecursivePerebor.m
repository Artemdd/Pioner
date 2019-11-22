function [marshrut] = RecursivePerebor(m, StartFin, L_mass_polovin, NN)
%Функция-решатель разомкнутой задачи коммивояжера методом прямого перебора
%в рекурсивном порядке
%
%Так как заданы точки старта и финиша перебрает (n-2)! вариантов маршрутов
%
% m - массив точек, которые нужно перерасределить 
% NN - Допустимое колличество точек для решения, если length(m) > NN, то 
% программа разделяет поле точек на NN групп и решает разомкнутую задачу
% коммивояжера для этих групп, затем исользует эту же функцию на
% новообразованных группах

global inf 
L = inf;

L_mass = L_mass_polovin;
L_mass = L_mass + L_mass';

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



%% Случай от одного до трех элементов
if sizem <= 1  %Ничего менятьь не надо
    marshrut = m;
    
%% Случай m < NN
elseif sizem <= NN

%Решение разомкнутой задачи коммивояжера
%функция распределения. Стандартная функция матлаба
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



%% Случай sizem > NN. Тогда создаем новые группы.
else 
    
    %Распределение на подгруппы
    m1_indif = group_razomknut(L_mass_polovin,m,NN);
    
    %Добавка в пересчет точек старта и финиша
    m1_indif(1,end+1) = start; m1_indif(1,end+1) = fin;
    
    %Ищет пары точек с минималным расстоянием между группами
    [para_massiv, L_group] = para_create(m1_indif,L_mass);
    
    %Создание подгрупп
    m = 1:NN;
    
    %переделка старта и финиша для нужного расчета
    start_i = NN + 1; fin_i = NN + 2;
    
    
%Решение разомкнутой задачи коммивояжера
%функция распределения. Стандартная функция матлаба
m_massiv = perms(m);

for n = 1:size(m_massiv,1)

%Нахождение длинны маршрута
L_new = L_group(start_i, m_massiv(n,1));  %Длинна между start и вторым 
for i = 1:NN-1  %Длинны между последующими 
L_new = L_new + L_group(m_massiv(n,i),m_massiv(n,i+1)); 
end
L_new = L_new + L_group(m_massiv(n,i+1),fin_i);  %между предпосленим и fin
%Конец нахождения длинны маршрута

%Проверка на длинну
if L_new < L
    L = L_new; 
    marshrut = m_massiv(n,:);
end

end  % Конец расчета для подгрупп

%Маршрут конечный
marshrut = [start_i marshrut fin_i];


% Проверка групп на пары точек

%Цикл проверяющий, чтобы точка соединяющая свою группу с двумя соседними не
%являлась одной и той же.
%Аргумет определяющй замкнутость задачи. 1 - замкнут. 0 - разомкнут
zamknut = 0; 
% %%%%%%Функция
[L_group, para_massiv] = para_correct_check(  ...
    marshrut, m1_indif, para_massiv, L_mass, L_group, zamknut);

%Формирования маршрута между групп
%Массив, где каждая n-я строка - это путь из группы n в группу n+1, а
%последняя строка - путь из последней группы в первую
marshrut_mezd_group = [];   
% 
for n = 1:length(marshrut)-1
d_m = para_massiv{marshrut(n),marshrut(n+1)};
marshrut_mezd_group = [marshrut_mezd_group; d_m];
end


%%%%%Рекурсивный перебор%%%%%%%%%%
marshrut_in_group = zeros(NN,size(m1_indif,1));
for n = 1:NN
    
    %точки старта и финиша
    %StartFinInGroup = start_fin_search(marshrut_mezd_group, n + 1, 1);
    %Нахождение точек старта
    if n == 1
        StartFinInGroup(1) = marshrut_mezd_group(end,2);
    else
        StartFinInGroup(1) = marshrut_mezd_group(n-1,2);
    end
    %и финиша
    StartFinInGroup(2) = marshrut_mezd_group(n,1);    
    
    
    %нужный индекс
    nn = marshrut(n + 1);
    
[marshrutNew] = RecursivePerebor(m1_indif(:,nn), ... 
    StartFinInGroup, L_mass_polovin, NN);

%Заполнение массива маршрутов внутри групп
marshrut_in_group(n,1:length(marshrutNew)) =  marshrutNew;

end

%%%%Соединение маршрутов%%%%%
marshrut_all = zeros(size(marshrut_in_group,1)*2,size(marshrut_in_group,2));
marshrut_all(1,1:2) = marshrut_mezd_group(1,1:2);

for n = 1:size(marshrut_in_group,1)
marshrut_all(n*2,:) = marshrut_in_group(n,:);
marshrut_all(n*2+1,1:2) = marshrut_mezd_group(n+1,:);
end

marshrut = marshrut_all';
marshrut = marshrut(:);
marshrut = marshrut';
marshrut(marshrut==0) = [];   %удаление нулей
marshrut = unique(marshrut,'stable'); %удаление повторяющихся элементов 
    
end





