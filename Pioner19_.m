clear
%������ ��������� ����������, ����������������, � ����������� �����
%���������� ����� �������.
%
%��������� ��������� �� ������� ���� ��������� ��� ��������� ����������� 
%������������. 

%����� � ���������
cd('function')

%���������� �������
global inf N NN
inf = 5000;

%���������� ���������� ����� � ��������
N = 9;  NN = N+1;

while 1
%������������ ����� ��� ���� ����� ������-�
map = ones(15,20)*0.5;
map = imnoise(map, 'salt & pepper', 0.25);
MAP = map';
map = map*inf;

%����� ����������
m1 = find(MAP == 0);
m_fin = m1; 







%% ������ ���� ������
%���������� ������� ����������
mass = symetric_smez_matrix(map);


%% ������ ���� ������
%����� ���������� ��������� ��� ����� ����������

%������ ����� �������� ���������
L_mass = zeros(length(m1),length(m1));

%������ ���������� ���� �� ����� ����� ���������� � ������
marshrut_mass_cell = cell(length(m1));

%�������� �������� ��� ������������ ������� 
for m = 1:length(m1)
[MASS_1, ~, L_met] = Dxtra(mass,m1(m));

%������ ����� �������� ���������
L_mass(1+m:end,m) = L_met(m_fin(m+1:end));


%marshrut_mass_cell 
for i = 1:length(m1)
massaa = [m1(m) MASS_1(m1(i),:)];
massaa(massaa == 0) = [];
marshrut_mass_cell(m,i) = {massaa};
end


end

%����� ������ � ������, ���� ���� �� �� ����� �� �� ������ ��������� ��-��
%�����������
if max(max(L_mass)) ~= inf
    break
end


end


%% ������ ���� ������
%������ �����������
%������ ��������� ��������� ���������� ��������� ���� ����� �� ����������
%��� ������� ������ ��������� �����. 


%% ������� ��������� ������ ������������ ��� �������� ����� 

%���� ����� ���������� ����������� ���������� ����� �����
%����� ��� ������� ������������� �� �������
L_mass_polovin = L_mass;
%������ ���� ����� ����������
L_mass = L_mass + L_mass';  


%%%%������������� ����� �� �������
m1_indif = group_zamk(L_mass_polovin,m1);


%%%%���� ���� ����� � ���������� ����������� ����� ��������
[para_massiv, L_mass_group] = para_create(m1_indif,L_mass);


%%%%������� ������ ������������ ��� �������� �����
[L_group, marshrut_group] = zamk_perebor(L_mass_group);


%���� �����������, ����� �����, ����������� ���� ������ � ����� ���������, 
%�� �������� ����� � ��� ��.
%������� ����������� ����������� ������. 1 - �������. 0 - ���������
zamknut = 1; 
%%%%�������
[L_group, para_massiv] = para_correct_check(  ...
    marshrut_group, m1_indif, para_massiv, L_mass, L_group, zamknut);


%% ������� ����������� ������ ������������ ��� ��������� ������ �����

%������, ��� ������ n-� ������ - ��� ���� �� ������ n � ������ n+1, �
%��������� ������ - ���� �� ��������� ������ � ������
marshrut_mezd_group = [];   
% 
for n = 1:length(marshrut_group)-1
d_m = para_massiv{marshrut_group(n),marshrut_group(n+1)};
marshrut_mezd_group = [marshrut_mezd_group; d_m];
end


%������, ��� ������ n-� ������ - ��� ������� ������ n-� ������
marshrut_in_group = zeros(N,size(m1_indif,1));

for n = 1:size(m1_indif, 2)
    
    %���������� ����� ������
    if n == 1
        StartFin(1) = marshrut_mezd_group(end,2);
    else
        StartFin(1) = marshrut_mezd_group(n-1,2);
    end
    %� ������
    StartFin(2) = marshrut_mezd_group(n,1);
    

    %����������� ����������� �������
    [marshrut] = RecursivePerebor(m1_indif(:,marshrut_group(n)), ...
        StartFin, L_mass_polovin, NN);

%���������� ������� ��������� ������ �����
marshrut_in_group(n,1:length(marshrut)) =  marshrut;

end


%% ������������

if length(m1) > N
 %���������� �������� ���������� ��������� ����� �����
marshrut_all = zeros(size(marshrut_in_group,1)*2,size(marshrut_in_group,2));

for n = 1:2:size(marshrut_all,1)
marshrut_all(n,:) = marshrut_in_group((n+1)/2,:);
marshrut_all(n+1,1:2) = marshrut_mezd_group((n+1)/2,:);
end

else
    marshrut_all = marshrut_group;
end

%������������
[global_dot, L_marshrut] = VisualMap (map, m1_indif, m1, marshrut_all, ...
    marshrut_mass_cell, L_mass);

%% ����������������� ������ � ������� ����������������� �������� �����

[NewGlobalDot] = LastPerebor (global_dot, L_mass);

%������������
[NewGlobalDot, L_marshrut] = VisualMap (map, m1_indif, m1, NewGlobalDot', ...
    marshrut_mass_cell, L_mass);



