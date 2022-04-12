clc
clear
num = 950;
% rows = ones(10,1);
% row = 100;
i = 1;
j = 1;
index = sort(randperm(num,round(num*0.7)));
% Train_flag = index;
for n=1:num
    if n == index(i)
        Train_flag(i) = n;
        if i<round(num*0.7)
            i = i+1;
        end
    else
        Test_flag(j) = n;
        j = j+1;
    end;
end
Trainflag{1} = Train_flag;
Testflag{1} = Test_flag;
save('flag_group.mat','Trainflag','Testflag')