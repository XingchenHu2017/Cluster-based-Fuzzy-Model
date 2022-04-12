%---------------------------------------------------------------------------------------------
%Contributed by Xingchen Hu
% Ref:
%[1] "Granular fuzzy rule-based models: A study in a comprehensive evaluation
%     and construction of fuzzy models." IEEE Transactions on Fuzzy Systems (2016).
%[2] "Development of granular models through the design of a granular output spaces."
%     Knowledge-Based Systems 134 (2017).
%[3] "Granular Fuzzy Rule-Based Modeling With Incomplete Data Representation." 
%     IEEE Transactions on Cybernetics (2021).
%---------------------------------------------------------------------------------------------
clear
clc
%---------------------------------------------------------------------------------------------
rule_all = [3 5 7 9]; % number of rules

fold = 1;
for rnum = 1:size(rule_all,2)
    m = 2; % fuzzification coefficient
    rule_num = rule_all(rnum);
    
    clearvars -except Data data_name fold net rule_num Trainflag Testflag...
        rule_all rnum time mean_V_train mean_V_test rmse_trn rmse_tst m
    
    load('data.mat')   %Stock Prices data set from KEEL dataset repository
    load('flag_group.mat') %split training data (70%) and test data (30%)
    [~,D]=size(Data);
    %---------------------------------------------------------------------------------------------
    % split training data (70%) and test data (30%)
    TrainData = Data(Trainflag{fold},:);
    
    [VW,MemX,obj_value] = fcm_revised(TrainData,rule_num,m);  % revised Fuzzy C-Means clustering

    Vi = VW(:,1:D-1);
    Wi= VW(:,D);
    U = MemX;
   %---------------------------------------------------------------------------------------------
    %Training data and test data
    train_flag = Trainflag{fold};
    trn_inputs = Data(train_flag,1:end-1);
    trn_targets = Data(train_flag,end);
    
    test_flag = Testflag{fold};
    tst_inputs = Data(test_flag,1:end-1);
    tst_targets = Data(test_flag,end);
    
    D=size(Data,2);
   %---------------------------------------------------------------------------------------------  
    % training data output
    Mem =partition_matrix(Vi,trn_inputs,2);    %generate membership degrees
    row = size(Vi,1);
    num = size(trn_inputs,1);
    for i = 1:row
        for k = 1:num
            trn_zz(i*(D-1)-(D-2):i*(D-1),k) = (Mem(i,k)*(trn_inputs(k,:)-Vi(i,:)))';
        end
    end
    for k = 1:num
        for i = 1:row
            trn_h(k,i) = Mem(i,k)*Wi(i);
        end
    end
    trn_h = sum(trn_h,2);
    trn_zz = trn_zz';
%     aa = (trn_zz'*trn_zz)\trn_zz'*(trn_targets-trn_h);
    aa = pinv(trn_zz)*(trn_targets-trn_h);
    trn_outputs = (trn_h+trn_zz*aa);
    
    rmse_trn(rnum) = sqrt(mean((trn_outputs-trn_targets).^2));
    %--------------------------------------------------------------------------------------------- 
    % test data output
    Mem =partition_matrix(Vi,tst_inputs,2);   %generate membership degrees
    num = size(tst_inputs,1);
    for i = 1:row
        for k = 1:num
            tst_zz(i*(D-1)-(D-2):i*(D-1),k) = (Mem(i,k)*(tst_inputs(k,:)-Vi(i,:)))';
        end
    end
    for k = 1:num
        for i = 1:row
            tst_h(k,i) = Mem(i,k)*Wi(i);
        end
    end
    tst_h = sum(tst_h,2);
    tst_zz = tst_zz';
    tst_outputs = (tst_h+tst_zz*aa);
    rmse_tst(rnum) = sqrt(mean((tst_outputs-tst_targets).^2));
       
end