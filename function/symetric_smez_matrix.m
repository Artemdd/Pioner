function mass = symetric_smez_matrix(map)
%������� ���������� ������� ���������� mass ����� map
%
%��������� ���� ���� �������� ������� ����������, ������ �������� ���
%�������� ����� ���������������� ������.

global inf

%����������� ������� ����������
Y = size(map,1);
X = size(map,2);
S = X*Y;

%�������� "���������" ������� ����������
mass = zeros(S, S);

%���������������� ������� ��� ����������� ������ ������ �������� �������
MAP = map'; 

%������������ ���������� (������� ����������)
for i = 1:S-1
    % �������� �� ��, �������� �� ����� ������������
    if MAP(i) == inf
        mass(i,i+1:end) = inf;
    else
    
    % ���������� ����� ������
    y1 = ceil(i/X);
    x1 = i - (y1*X - X);
    ii = i + 1;
    % ���������� ����� ������
for ii = i+1:S
    y2 = ceil(ii/X);
    x2 = ii - (y2*X - X);    
            
%�������� ��� �����������, ���� �� �� ���� �����������

%�������������� � ������������ �������� �� �����������
%��������������
if y1 == y2 & x1 ~= x2 %������ �������
    d_x = (x2 - x1)/abs((x2 - x1));
    d_map = map(y1,x1 + d_x:d_x:x2);
    if max(d_map) == inf;
        mass(i,ii) = inf;
    else
        mass(i,ii) = sqrt( (x2 - x1)^2 + (y2 - y1)^2 );
    end
    
%������������
elseif x1 == x2 & y1 ~= y2 
    d_y = (y2 - y1)/abs((y2 - y1));
    d_map = map(y1 + d_y:d_y:y2,x1);
    if max(d_map) == inf;
        mass(i,ii) = inf;
    else
        mass(i,ii) = sqrt( (x2 - x1)^2 + (y2 - y1)^2 );
    end
    
%�������� ��������� ����� �� ������� � ��� �����������    
elseif map(y2,x2) == inf
    mass(i,ii) = inf;
    
%��������� ��������, ���� x1~=x2 � y1~=y2.
else
    mass(i,ii) = sqrt( (x2 - x1)^2 + (y2 - y1)^2 );
    d_x = sign(x2-x1);
    d_y = sign(y2-y1);
    d_MAP = map(y1:d_y:y2,x1:d_x:x2);
    cosA = abs((x2-x1))/mass(i,ii);
    sinA = abs((y2-y1))/mass(i,ii);
    x = 0.5; y = 0.5;
    ix = 1;  iy = 1;
    ds = 0.1;
    s = 0;
    
    while s < mass(i,ii)
        x = x + ds*cosA;
        y = y + ds*sinA;
        s = s + ds;
        
        if x > ix & y > iy
            ix = ix + 1; iy = iy + 1;
           if d_MAP(iy,ix)==inf | d_MAP(iy-1,ix)==inf || d_MAP(iy,ix-1)==inf
            mass(i,ii) = inf;
            break
           end
           
        elseif x > ix
            ix = ix + 1;
            if d_MAP(iy,ix) == inf
                mass(i,ii) = inf;
                break
            end
            
        elseif y > iy
            iy = iy + 1;
            if d_MAP(iy,ix) == inf
                mass(i,ii) = inf;
                break
            end            
         
        end
        
        
    end
    
    
end
  
end
    
    end
    
end

%������������ ������ �������� �������
mass = mass + mass';
