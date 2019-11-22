function [NewGlobalDot] = LastPerebor (global_dot, L_mass)
%Функция для улучшения маршрута локальными перестановками по всей его
%длине

%global NN
NN = 10;

d_NN = floor(NN/2);  %размах перебора
len_d_dot = NN;      %Колличество точек перебора



NewGlobalDot = global_dot;
NewGlobalDot(end) = [];

for index = 1:d_NN:length(NewGlobalDot) - d_NN     

if index == 1
    d_dot = NewGlobalDot(end - d_NN + 1 : end);
    d_dot = [d_dot; NewGlobalDot(index : index + d_NN - 1)];
else
    d_dot = NewGlobalDot(index - d_NN + 1 : index + d_NN);
end
    
    %d_dot = NewGlobalDot(index - d_NN + 1 : index + d_NN);
        
        %ТОчки старта и финиша
        %StartFin = start_fin_search(NewGlobalDot, d_dot, 3);
        StartFin(1) = d_dot(1);
        StartFin(2) = d_dot(end);
        
        %Разомкнутый перебр
        [L, marshrut] = razoknut_perebor_min2(d_dot, StartFin, L_mass);
        marshrut = [StartFin(1) marshrut StartFin(2)];
        
        
        %сравнение старого и нового маршрутов.
        L_old = L_mass(StartFin(1),d_dot(1)) ...
            + L_mass(d_dot(len_d_dot),StartFin(2));
        
        L_new = L_mass(StartFin(1),marshrut(1)) ...
            + L_mass(marshrut(len_d_dot),StartFin(2));
        
        for i = 1:len_d_dot - 1
            L_old = L_old + L_mass(d_dot(i),d_dot(i+1));
            L_new = L_new + L_mass(marshrut(i),marshrut(i+1));    
        end
        
        %сРАВНЕНИЕ и переназначение точек
       
        if index == 1
        NewGlobalDot(end - d_NN + 1 : end) = marshrut(1 : d_NN);
        NewGlobalDot(index : index + d_NN - 1) = marshrut(d_NN + 1 : end);
        else
        NewGlobalDot(index - d_NN + 1 : index + d_NN) = marshrut;
        end
    
end