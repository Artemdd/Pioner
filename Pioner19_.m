clear
%Версия программы работающая, предположительно, с количеством точек
%обсервации любых величин.
%
%Программа избавлена от всякого рода атавизмов для написания программной 
%документации. 

%папка с функциями
cd('function')

%глобальные функции
global inf N NN
inf = 5000;

%Допустимое количество групп и подгрупп
N = 9;  NN = N+1;

while 1
%формирование карты для пути судна Пионер-М
map = ones(15,20)*0.5;
map = imnoise(map, 'salt & pepper', 0.25);
MAP = map';
map = map*inf;

%Точки обсервации
m1 = find(MAP == 0);
m_fin = m1; 







%% Первый этап задачи
%Построение матрицы смежностей
mass = symetric_smez_matrix(map);


%% Второй этап задачи
%Поиск кратчайших маршрутов для точек обсервации

%Массив самых коротких маршрутов
L_mass = zeros(length(m1),length(m1));

%Массив содержащий путь из одной точки обсервации в другую
marshrut_mass_cell = cell(length(m1));

%Алгоритм Дейкстры для симметричной матрицы 
for m = 1:length(m1)
[MASS_1, ~, L_met] = Dxtra(mass,m1(m));

%Массив самых коротких маршрутов
L_mass(1+m:end,m) = L_met(m_fin(m+1:end));


%marshrut_mass_cell 
for i = 1:length(m1)
massaa = [m1(m) MASS_1(m1(i),:)];
massaa(massaa == 0) = [];
marshrut_mass_cell(m,i) = {massaa};
end


end

%Вывод ошибки в случае, если хотя бы до одной из ТО нельзя добраться из-за
%препятствий
if max(max(L_mass)) ~= inf
    break
end


end


%% Третий этап задачи
%Задача комивояжера
%Данная программа совершает сементацию основного поля точек на допустимое
%для решения прямым перебором групп. 


%% Решение замкнутой задачи коммивояжера для основных групп 

%Граф точек обсервации заполненный наполовину слева внизу
%Нужен для функции распределения по группам
L_mass_polovin = L_mass;
%Полный Граф точек обсервации
L_mass = L_mass + L_mass';  


%%%%Распределение точек по группам
m1_indif = group_zamk(L_mass_polovin,m1);


%%%%Ищет пары точек с минималным расстоянием между группами
[para_massiv, L_mass_group] = para_create(m1_indif,L_mass);


%%%%Решение задачи коммивояжера для основных групп
[L_group, marshrut_group] = zamk_perebor(L_mass_group);


%Цикл проверяющий, чтобы точка, соединяющая свою группу с двумя соседними, 
%не являлась одной и той же.
%Аргумет определяющй замкнутость задачи. 1 - замкнут. 0 - разомкнут
zamknut = 1; 
%%%%Функция
[L_group, para_massiv] = para_correct_check(  ...
    marshrut_group, m1_indif, para_massiv, L_mass, L_group, zamknut);


%% Решение разомкнутой задачи коммивояжера для элементов внутри групп

%Массив, где каждая n-я строка - это путь из группы n в группу n+1, а
%последняя строка - путь из последней группы в первую
marshrut_mezd_group = [];   
% 
for n = 1:length(marshrut_group)-1
d_m = para_massiv{marshrut_group(n),marshrut_group(n+1)};
marshrut_mezd_group = [marshrut_mezd_group; d_m];
end


%Массив, где каждая n-я строка - это маршрут внутри n-й группы
marshrut_in_group = zeros(N,size(m1_indif,1));

for n = 1:size(m1_indif, 2)
    
    %Нахождение точек старта
    if n == 1
        StartFin(1) = marshrut_mezd_group(end,2);
    else
        StartFin(1) = marshrut_mezd_group(n-1,2);
    end
    %и финиша
    StartFin(2) = marshrut_mezd_group(n,1);
    

    %Рекурсивный разомкнутый перебор
    [marshrut] = RecursivePerebor(m1_indif(:,marshrut_group(n)), ...
        StartFin, L_mass_polovin, NN);

%Заполнение массива маршрутов внутри групп
marshrut_in_group(n,1:length(marshrut)) =  marshrut;

end


%% Визуализация

if length(m1) > N
 %построение маршрута соединенем маршрутов между групп
marshrut_all = zeros(size(marshrut_in_group,1)*2,size(marshrut_in_group,2));

for n = 1:2:size(marshrut_all,1)
marshrut_all(n,:) = marshrut_in_group((n+1)/2,:);
marshrut_all(n+1,1:2) = marshrut_mezd_group((n+1)/2,:);
end

else
    marshrut_all = marshrut_group;
end

%Визуализация
[global_dot, L_marshrut] = VisualMap (map, m1_indif, m1, marshrut_all, ...
    marshrut_mass_cell, L_mass);

%% Совершенствование метода с помощью последовательного перебора точек

[NewGlobalDot] = LastPerebor (global_dot, L_mass);

%Визуализация
[NewGlobalDot, L_marshrut] = VisualMap (map, m1_indif, m1, NewGlobalDot', ...
    marshrut_mass_cell, L_mass);



