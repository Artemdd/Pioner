function [para_massiv, L_mass_group] = para_create(m1_indif,L_mass)
%Функия для программ Pioner14, pionerPriklad и более поздих
%Ищет пары точек с минималным расстоянием между группами
%
% m1_indif - группы
% L_mass - графф расстояний между точками



NNN = size(m1_indif,2);

%поиск минимальных расстояний между группами
L_mass_group = zeros(NNN,NNN);
para_massiv = cell(NNN);
for n = 1:NNN
    n_group = m1_indif(:,n);  
    n_group(n_group==0) = [];
    for i = 1:NNN
        
        if n ~= i
            
        i_group = m1_indif(:,i);
        i_group(i_group==0) = [];        
        %Определение минимального расстояния
        L_mass_group(n,i) = min(min(L_mass(n_group,i_group)));
        
        
        [y, x] = find(L_mass(n_group,i_group) == L_mass_group(n,i));
        % Пара с минимальным расстоянием
        para = [n_group(y(1)) i_group(x(1))];
        
        %Заполнение массивов пар и расстояния
        para_massiv(n,i) = {para};
        
        end
        
    end

end