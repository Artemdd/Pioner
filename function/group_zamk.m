function m1_indif = group_zamk(L_mass_polovin,m1)
%Функция распределения поля точек на группы
% Использован принцип ближайшего среднего расстояния 
%Распределяет поле на N групп для решения замкнутой задачи Коммивояжера
%Используется на самом верхнем уровне
%
% L_mass - Граф точек обсервации
% m1 - точки обсервации

global inf N



%Массив из которого будем брать минимальные значения
L_massiv = L_mass_polovin;
L_massiv(find(L_massiv == 0)) = inf;
%Граф точек обсервации
L_mass = L_mass_polovin + L_mass_polovin';  
%Массив собирающий группы
m1_indif = 1:length(m1);


%Алгоритм распределения 
while size(m1_indif,2) > N  %Работает пока кол-во групп больше N

% Поиск пары точек с наименьшим расстоянием
[L1 i1] = min(L_massiv);
[L2 i2] = min(L1);
%Удобное переназначение
xdot = i2;
ydot = i1(i2);

%Поиск точек в m1_indif 
[x xx] = find(m1_indif == xdot);
[y yy] = find(m1_indif == ydot);


%Захват групп
x_mass = m1_indif(:,xx);  
y_mass = m1_indif(:,yy);

%Удаление нулей из групп
x_mass(find(x_mass == 0)) = [];
y_mass(find(y_mass == 0)) = [];


%Объединение двух групп в одну
xy_mass = [x_mass; y_mass];
m1_indif(1:length(xy_mass),end+1) = xy_mass;
m1_indif(:,[xx yy]) = [];


%Расчет среднего расстояния от новообразованной группы до остальных групп
%И занесение его в L_massiv
for n = 1:size(m1_indif,2)-1  %Номер группы
    n_group = m1_indif(:,n);  %Группа n
    n_group(n_group==0) = []; %Удаление нулей из группы
    
    %Расчет среднего значения между новой группой n-й группой
    L_mean = nanmean(nanmean(L_mass(n_group, xy_mass)));
    
    %Занесение среднего значения в L_massiv
    if xy_mass(1) > n_group(1)
    L_massiv(xy_mass(1),n_group(1)) = L_mean;
    else
    L_massiv(n_group(1),xy_mass(1)) = L_mean;
    end
    
        
end  %Конец Расчета среднего расстояния между группами

%Удаление присоединенной группы из расчета в L_massiv
L_massiv(y_mass(1),:) = inf;
L_massiv(:,y_mass(1)) = inf;


end