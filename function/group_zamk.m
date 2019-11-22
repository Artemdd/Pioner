function m1_indif = group_zamk(L_mass_polovin,m1)
%������� ������������� ���� ����� �� ������
% ����������� ������� ���������� �������� ���������� 
%������������ ���� �� N ����� ��� ������� ��������� ������ ������������
%������������ �� ����� ������� ������
%
% L_mass - ���� ����� ����������
% m1 - ����� ����������

global inf N



%������ �� �������� ����� ����� ����������� ��������
L_massiv = L_mass_polovin;
L_massiv(find(L_massiv == 0)) = inf;
%���� ����� ����������
L_mass = L_mass_polovin + L_mass_polovin';  
%������ ���������� ������
m1_indif = 1:length(m1);


%�������� ������������� 
while size(m1_indif,2) > N  %�������� ���� ���-�� ����� ������ N

% ����� ���� ����� � ���������� �����������
[L1 i1] = min(L_massiv);
[L2 i2] = min(L1);
%������� ��������������
xdot = i2;
ydot = i1(i2);

%����� ����� � m1_indif 
[x xx] = find(m1_indif == xdot);
[y yy] = find(m1_indif == ydot);


%������ �����
x_mass = m1_indif(:,xx);  
y_mass = m1_indif(:,yy);

%�������� ����� �� �����
x_mass(find(x_mass == 0)) = [];
y_mass(find(y_mass == 0)) = [];


%����������� ���� ����� � ����
xy_mass = [x_mass; y_mass];
m1_indif(1:length(xy_mass),end+1) = xy_mass;
m1_indif(:,[xx yy]) = [];


%������ �������� ���������� �� ���������������� ������ �� ��������� �����
%� ��������� ��� � L_massiv
for n = 1:size(m1_indif,2)-1  %����� ������
    n_group = m1_indif(:,n);  %������ n
    n_group(n_group==0) = []; %�������� ����� �� ������
    
    %������ �������� �������� ����� ����� ������� n-� �������
    L_mean = nanmean(nanmean(L_mass(n_group, xy_mass)));
    
    %��������� �������� �������� � L_massiv
    if xy_mass(1) > n_group(1)
    L_massiv(xy_mass(1),n_group(1)) = L_mean;
    else
    L_massiv(n_group(1),xy_mass(1)) = L_mean;
    end
    
        
end  %����� ������� �������� ���������� ����� ��������

%�������� �������������� ������ �� ������� � L_massiv
L_massiv(y_mass(1),:) = inf;
L_massiv(:,y_mass(1)) = inf;


end