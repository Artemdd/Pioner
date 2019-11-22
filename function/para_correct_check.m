function [L_group, para_massiv] = para_correct_check( ...
    marshrut_group, m1_indif, para_massiv, L_mass, L_group, zamknut)
%Функция проверяющая, чтобы точка соединяющая свою группу с двумя 
%соседними не являлась одной и той же.
%Если это так, она исравит положение.
%Да, столько входных данных необходимо.

global inf

if zamknut == 1
%Предварительная работа для замкнутой задачи коммивояжера
marshrut_group = [marshrut_group marshrut_group(2)];
end


%Цикл проверяющий, чтобы точка соединяющая свою группу с двумя соседними не
%являлась одной и той же
for i = 2:length(marshrut_group)-1
% пары с предыдущей и следующей группами i-группы
para_prev = para_massiv{marshrut_group(i-1),marshrut_group(i)};
para_next = para_massiv{marshrut_group(i),marshrut_group(i+1)};

i_group = m1_indif(:,marshrut_group(i));
i_group(i_group == 0) = [];

%Проверка на размер группы. Если она состоит из одной точки, то пропускаем
if length(i_group) ~= 1
% Алгоритм для поиска новой минимальной пары, если есть общая точка
if para_prev(2) == para_next(1)
    dot_X = para_prev(2);
    dot_prev = para_prev(1);
    dot_next = para_next(2);
    
    
    %поиск пар с соседями без учета dot_X
    i_group(i_group == dot_X) = [];
    
    
    L_prev_min = inf;  L_next_min = inf;
    
    %Поиск Минимальной пары между ...
    for n = 1:length(i_group)
        % i-й и предыдущей
        
        L_prev = L_mass(dot_prev,i_group(n));
        if L_prev < L_prev_min
            L_prev_min = L_prev;
            L_prev_min_index = [dot_prev i_group(n)];
        end
        
        % i-й и следующей
        
        L_next = L_mass(i_group(n),dot_next); 
        if L_next < L_next_min
            L_next_min = L_next;
            L_next_min_index = [i_group(n) dot_next];
        end
        
        
    end %Конец поиска минимальной пары
    
    %Присваиваивание новой минимальной пары
    if L_prev_min > L_next_min
    
    L_group = L_group - L_mass(para_next(1),para_next(2));
    para_massiv{marshrut_group(i),marshrut_group(i+1)} = L_next_min_index;
    L_group = L_group + L_next_min;
    else
   
    L_group = L_group - L_mass(para_prev(1),para_prev(2));
    para_massiv{marshrut_group(i-1),marshrut_group(i)} = L_prev_min_index;
    L_group = L_group + L_prev_min;        
        
    end
    
end

end

end