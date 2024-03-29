function [L, marshrut] = razoknut_perebor_min2(m, StartFin, L_mass)
%�������-�������� ����������� ������ ����������� ������� ������� ��������
% ����������� � LastPerebor
%��� ��� ������ ����� ������ � ������ ��������� (n-2)! ��������� ���������
%
% m - ������ �����, ������� ����� ��������������� 


global inf 
L = inf;

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

%����������� ���� ������� ����������� ������
if sizem <= 1  %������ ������� �� ����
    marshrut = m;

else 

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

end  

end