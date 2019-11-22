function [MASS_1, MASS_2, L_met] = Dxtra(mass,m1)
%Функция ищущая кратчайшие маршруты из точки старта во все осталные точки
%карты. 
%Реализованна по алгоритму Дейкстры

global inf

S = length(mass);
m = m1; %Точка нахождения в данныйй момент
MASS = mass; %массив для работы
MASS_1 = zeros(S,1); %Последователность точек маршрута
MASS_2 = mass(m1,:)'; %длинна
L_met  = mass(m1,:)'; %метки точек
dot_p  = []; %массив посещенных точек
dot_np = [1:S]; %массив непосещенных точек
LL = L_met; %массив для поиска следующей точки расчета, посещенные точки отмечаются как 2*inf

n = 1; %номер итерации

%предварительная рaбота с массивами
%Алгоритм ищет точки куда может добраться напрямую
for i = 1:S
    
    if mass(m1,i) ~= inf
        MASS_1(i,1) = i;
        MASS_2(i,1) = mass(m1,i);
        dot_p = [dot_p i];
        
        %проставка меток всем остальным точкам
        for ii = dot_np(1):dot_np(end)
        if mass(i,dot_np(ii)) ~= inf
            L = sum(MASS_2(i,:)) + mass(i,ii);
  
            
        end
        end
            
    else
        MASS_2(i,1) = inf;

    end
end
%Конец поиска путей напрямую

%исключаем точки в которые есть прямые маршруты из точки старта
dot_np(MASS_2 ~= inf) = []; 

LL(m1) = 2*inf;

%Алгорим Дейкстры
while 1
    %поиск точки с минимальной меткой
[L_m m] = min(LL);

for ii = 1:length(dot_np)
    m2 = dot_np(ii);

    if mass(m,m2) ~= inf
        L = L_m + mass(m,m2);

        if L < L_met(m2)
            

            L_met(m2) = L;
            LL(m2) = L; 
            
            %алгоритм, чтоб все работало
            kek = MASS_1(m,:);
            kek(find(kek == 0)) = [];
            if length(kek) >= size(MASS_1,2)
                n = length(kek) - size(MASS_1,2);
                MASS_1(:,end+1:end+1+n) = zeros(S,1+n);
                MASS_2(:,end+1:end+1+n) = zeros(S,1+n);
            end

        MASS_1(m2,:) = 0;
        MASS_1(m2,1:length(kek)+1) = [kek m2];
        MASS_2(m2,1:length(kek)+1) = [MASS_2(m,1:length(kek)) mass(m, m2)];
            

            
        end

    end


end

LL(m) = 2*inf;


%Остановка расчета
if min(LL) >= inf
    break
end

end