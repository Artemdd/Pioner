function [para_massiv, L_mass_group] = para_create(m1_indif,L_mass)
%������ ��� �������� Pioner14, pionerPriklad � ����� ������
%���� ���� ����� � ���������� ����������� ����� ��������
%
% m1_indif - ������
% L_mass - ����� ���������� ����� �������



NNN = size(m1_indif,2);

%����� ����������� ���������� ����� ��������
L_mass_group = zeros(NNN,NNN);
para_massiv = cell(NNN);
for n = 1:NNN
    n_group = m1_indif(:,n);  
    n_group(n_group==0) = [];
    for i = 1:NNN
        
        if n ~= i
            
        i_group = m1_indif(:,i);
        i_group(i_group==0) = [];        
        %����������� ������������ ����������
        L_mass_group(n,i) = min(min(L_mass(n_group,i_group)));
        
        
        [y, x] = find(L_mass(n_group,i_group) == L_mass_group(n,i));
        % ���� � ����������� �����������
        para = [n_group(y(1)) i_group(x(1))];
        
        %���������� �������� ��� � ����������
        para_massiv(n,i) = {para};
        
        end
        
    end

end