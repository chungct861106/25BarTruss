import get_model_result.*
history.x = [];
history.fval = [];
searchdir = [];

% call optimization
x0 = 1.2 * ones(8,1);   % 瞦



% A<=b
A=[];           % ぃ单Α絬┦╰计痻皚
b=[];           % ぃ单Α絬┦秖

% A==b
Aeq=[];         % 单Α絬┦╰计痻皚
beq=[];         % 单Α絬┦秖

ub=10 * ones(8,1);   % 跑计秖
lb=0.001 * ones(8,1);   % 跑计秖
options = optimset ('display','off','Algorithm','sqp');
[x, fval, exitflag] = fmincon(@objfun,x0,A,b,Aeq,beq,lb,ub,@confun, options);

x
fval
Con = confun(x)
[P, S] = get_model_result(x)

function y = objfun(x)
    node_coord(1,:) = [-37.5, 0, 200];
    node_coord(2,:) = [37.5, 0, 200];
    node_coord(3,:) = [-37.5, 37.5, 100];
    node_coord(4,:) = [37.5, 37.5, 100];
    node_coord(5,:) = [37.5, -37.5, 100];
    node_coord(6,:) = [-37.5,-37.5,100];
    node_coord(7,:) = [-100, 100, 0];
    node_coord(8,:) = [100, 100, 0];
    node_coord(9,:) = [100, -100, 0];
    node_coord(10,:) = [-100, -100, 0];
    
     en_pair = [ ...
        1,2; 1,4; 2,3; 1,5; 2,6; ...
        2,4; 2,5; 1,3; 1,6; 3,6; ...
        4,5; 3,4; 5,6; 3,10; 6,7; ...
        4,9; 5,8; 4,7; 3,8; 5,10; ...
        6,9; 6,10; 3,7; 4,8; 5,9];  % elemenet node pair
    y = 0;
    for i=1:25
        A_radius = 0;
        if i==1
            A_radius =x(1);
        elseif (i>=2 && i<=5)
            A_radius = x(2);
        elseif (i>=6 && i<=9)
            A_radius = x(3);
        elseif (i>=10 && i<=11)
            A_radius = x(4);
        elseif (i>=12 && i<=13)
            A_radius = x(5);
        elseif (i>=14 && i<=17)
            A_radius = x(6);
        elseif (i>=18 && i<=21)
            A_radius = x(7);
        elseif (i>=22 && i<=25)
            A_radius = x(8);
        end
        
        n1 = en_pair(i,1);
        n2 = en_pair(i,2);
        Length = sqrt((node_coord(n1,1)-node_coord(n2,1))^2 + (node_coord(n1,2)-node_coord(n2,2))^2 + (node_coord(n1,3)-node_coord(n2,3))^2);
        y = y + Length*A_radius;
    end
    y = y * 0.1;
end

function [g, geq] = confun(x)
    [Q, stress] = get_model_result(x);
    for i=1:25
        g(i) = stress(i)^2 - 40000^2;
    end
    g(26) = Q(1)^2 - 0.35^2;
    g(27) = Q(2)^2 - 0.35^2;
    g(28) = Q(4)^2 - 0.35^2;
    g(29) = Q(5)^2 - 0.35^2;
    
    %g(26) = sqrt(Q(1)^2+Q(2)^2)-0.35;
    %g(27) = sqrt(Q(4)^2+Q(5)^2)-0.35;
    geq=[];
end


