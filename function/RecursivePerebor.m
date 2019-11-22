function [marshrut] = RecursivePerebor(m, StartFin, L_mass_polovin, NN)
%�������-�������� ����������� ������ ������������ ������� ������� ��������
%� ����������� �������
%
%��� ��� ������ ����� ������ � ������ ��������� (n-2)! ��������� ���������
%
% m - ������ �����, ������� ����� ��������������� 
% NN - ���������� ����������� ����� ��� �������, ���� length(m) > NN, �� 
% ��������� ��������� ���� ����� �� NN ����� � ������ ����������� ������
% ������������ ��� ���� �����, ����� ��������� ��� �� ������� ��
% ���������������� �������

global inf 
L = inf;

L_mass = L_mass_polovin;
L_mass = L_mass + L_mass';

start = StartFin(1);
fin = StartFin(2);
marshrut = [];

%������������� ����� ������ � ������.
%�������� ��� ����, ����� ����������� � ����������� ���������� �
%�������� ����������
%������ �� ���� ����� ����������� (n-2)! ����������� ����������
m(m == 0) = []; 
m(m == start) = []; 
m(m == fin) = [];

sizem = length(m);



%% ������ �� ������ �� ���� ���������
if sizem <= 1  %������ ������� �� ����
    marshrut = m;
    
%% ������ m < NN
elseif sizem <= NN

%������� ����������� ������ ������������
%������� �������������. ����������� ������� �������
m_massiv = perms(m);

for n = 1:size(m_massiv,1)

%���������� ������ ��������
L_new = L_mass(start, m_massiv(n,1));  %������ ����� start � ������ 
for i = 1:sizem-1  %������ ����� ������������ 
L_new = L_new + L_mass(m_massiv(n,i),m_massiv(n,i+1)); 
end
L_new = L_new + L_mass(m_massiv(n,i+1),fin);  %����� ������������ � fin
%����� ���������� ������ ��������

%�������� �� ������
if L_new < L
    L = L_new; 
    marshrut = m_massiv(n,:);
end

end



%% ������ sizem > NN. ����� ������� ����� ������.
else 
    
    %������������� �� ���������
    m1_indif = group_razomknut(L_mass_polovin,m,NN);
    
    %������� � �������� ����� ������ � ������
    m1_indif(1,end+1) = start; m1_indif(1,end+1) = fin;
    
    %���� ���� ����� � ���������� ����������� ����� ��������
    [para_massiv, L_group] = para_create(m1_indif,L_mass);
    
    %�������� ��������
    m = 1:NN;
    
    %��������� ������ � ������ ��� ������� �������
    start_i = NN + 1; fin_i = NN + 2;
    
    
%������� ����������� ������ ������������
%������� �������������. ����������� ������� �������
m_massiv = perms(m);

for n = 1:size(m_massiv,1)

%���������� ������ ��������
L_new = L_group(start_i, m_massiv(n,1));  %������ ����� start � ������ 
for i = 1:NN-1  %������ ����� ������������ 
L_new = L_new + L_group(m_massiv(n,i),m_massiv(n,i+1)); 
end
L_new = L_new + L_group(m_massiv(n,i+1),fin_i);  %����� ������������ � fin
%����� ���������� ������ ��������

%�������� �� ������
if L_new < L
    L = L_new; 
    marshrut = m_massiv(n,:);
end

end  % ����� ������� ��� ��������

%������� ��������
marshrut = [start_i marshrut fin_i];


% �������� ����� �� ���� �����

%���� �����������, ����� ����� ����������� ���� ������ � ����� ��������� ��
%�������� ����� � ��� ��.
%������� ����������� ����������� ������. 1 - �������. 0 - ���������
zamknut = 0; 
% %%%%%%�������
[L_group, para_massiv] = para_correct_check(  ...
    marshrut, m1_indif, para_massiv, L_mass, L_group, zamknut);

%������������ �������� ����� �����
%������, ��� ������ n-� ������ - ��� ���� �� ������ n � ������ n+1, �
%��������� ������ - ���� �� ��������� ������ � ������
marshrut_mezd_group = [];   
% 
for n = 1:length(marshrut)-1
d_m = para_massiv{marshrut(n),marshrut(n+1)};
marshrut_mezd_group = [marshrut_mezd_group; d_m];
end


%%%%%����������� �������%%%%%%%%%%
marshrut_in_group = zeros(NN,size(m1_indif,1));
for n = 1:NN
    
    %����� ������ � ������
    %StartFinInGroup = start_fin_search(marshrut_mezd_group, n + 1, 1);
    %���������� ����� ������
    if n == 1
        StartFinInGroup(1) = marshrut_mezd_group(end,2);
    else
        StartFinInGroup(1) = marshrut_mezd_group(n-1,2);
    end
    %� ������
    StartFinInGroup(2) = marshrut_mezd_group(n,1);    
    
    
    %������ ������
    nn = marshrut(n + 1);
    
[marshrutNew] = RecursivePerebor(m1_indif(:,nn), ... 
    StartFinInGroup, L_mass_polovin, NN);

%���������� ������� ��������� ������ �����
marshrut_in_group(n,1:length(marshrutNew)) =  marshrutNew;

end

%%%%���������� ���������%%%%%
marshrut_all = zeros(size(marshrut_in_group,1)*2,size(marshrut_in_group,2));
marshrut_all(1,1:2) = marshrut_mezd_group(1,1:2);

for n = 1:size(marshrut_in_group,1)
marshrut_all(n*2,:) = marshrut_in_group(n,:);
marshrut_all(n*2+1,1:2) = marshrut_mezd_group(n+1,:);
end

marshrut = marshrut_all';
marshrut = marshrut(:);
marshrut = marshrut';
marshrut(marshrut==0) = [];   %�������� �����
marshrut = unique(marshrut,'stable'); %�������� ������������� ��������� 
    
end





