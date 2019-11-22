function [MASS_1, MASS_2, L_met] = Dxtra(mass,m1)
%������� ������ ���������� �������� �� ����� ������ �� ��� �������� �����
%�����. 
%������������ �� ��������� ��������

global inf

S = length(mass);
m = m1; %����� ���������� � ������� ������
MASS = mass; %������ ��� ������
MASS_1 = zeros(S,1); %����������������� ����� ��������
MASS_2 = mass(m1,:)'; %������
L_met  = mass(m1,:)'; %����� �����
dot_p  = []; %������ ���������� �����
dot_np = [1:S]; %������ ������������ �����
LL = L_met; %������ ��� ������ ��������� ����� �������, ���������� ����� ���������� ��� 2*inf

n = 1; %����� ��������

%��������������� �a���� � ���������
%�������� ���� ����� ���� ����� ��������� ��������
for i = 1:S
    
    if mass(m1,i) ~= inf
        MASS_1(i,1) = i;
        MASS_2(i,1) = mass(m1,i);
        dot_p = [dot_p i];
        
        %��������� ����� ���� ��������� ������
        for ii = dot_np(1):dot_np(end)
        if mass(i,dot_np(ii)) ~= inf
            L = sum(MASS_2(i,:)) + mass(i,ii);
  
            
        end
        end
            
    else
        MASS_2(i,1) = inf;

    end
end
%����� ������ ����� ��������

%��������� ����� � ������� ���� ������ �������� �� ����� ������
dot_np(MASS_2 ~= inf) = []; 

LL(m1) = 2*inf;

%������� ��������
while 1
    %����� ����� � ����������� ������
[L_m m] = min(LL);

for ii = 1:length(dot_np)
    m2 = dot_np(ii);

    if mass(m,m2) ~= inf
        L = L_m + mass(m,m2);

        if L < L_met(m2)
            

            L_met(m2) = L;
            LL(m2) = L; 
            
            %��������, ���� ��� ��������
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


%��������� �������
if min(LL) >= inf
    break
end

end