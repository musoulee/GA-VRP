function TextOutput(Chromosome,Capacity,MaxDistance, Demand,Distance,FullyCost,IdleCost,params,result, fileDir)
%% 输出最优线路
% 输入：
% Chromosome     最优线路
% Capacity       车辆容积
% MaxDistance    最大行驶距离
% Demand         客户点需求，以体积计
% Distance       距离矩阵
    %% 写入文件名

    fileName = fileDir + "/log.txt";
    logFile = fopen(fileName,'a');
    separateLine = '--------------------------------------------------------------------------------------------------------';
    fprintf(logFile,[separateLine,'\n']);
    % 遗传信息
    fprintf(logFile,"PopulationSize=%d, MaxGeneration=%d, ProbMutation=%.2f, ProbSelection=%.2f, ProbCrossOver=%.2f\n" ...
        ,params.PopulationSize,params.MaxGeneration, params.ProbMutation,params.ProbSelection,params.ProbCrossOver);
    fprintf(logFile,[separateLine,'\n']);
    % 车辆参数
    fprintf(logFile,"Vehicle Parameter:\n\n");
    fprintf(logFile,"Capacity:    %d\n",Capacity);
    fprintf(logFile,"MaxDistance: %d\n", MaxDistance);
    fprintf(logFile,"FullCost:    %.2f\n", FullyCost);
    fprintf(logFile,"IdleCost:    %.2f\n", IdleCost);
    fprintf(logFile,[separateLine,'\n']);
    disp('Best Route:');
    fprintf(logFile,'Best Route: totalDistance = %.2fkm, totalOilCost = %.2fL\n', result(1), result(2));
    [routes, count] = Chromo2Routes(Chromosome);
    disp(separateLine);
    fprintf(logFile,[separateLine,'\n']);
    for i = 1:count
        route = routes{i};
        route = route + 1; % 全部加1，方便索引
        DisTraveled = 0; % 行驶距离
        Loadage = 0; % 装载量
        OilCost = 0; % 总油耗
        path = '0';
        for j = 2:length(route)
            DisTraveled = DisTraveled + Distance(route(j-1),route(j));
            Loadage = Loadage + Demand(route(j));
            path = [path, '->', num2str(route(j)-1)];
        end
        %% 计算总油耗
        currLoad = Loadage;
        for j = 1:length(route)-1
            cost = currLoad/Capacity*(FullyCost-IdleCost)+IdleCost;
            OilCost = OilCost + cost * Distance(route(j),route(j+1));
            currLoad = currLoad - Demand(route(j+1));
        end
        fprintf("Vehicle Of No.%d: %s. \n", i, path);
        fprintf(logFile, "Vehicle Of No.%d: %s. \n", i, path);
        fprintf("Distance Traveled: %.2fkm, load rate: %.2f%%, oil cost:%.2fL \n", DisTraveled, Loadage/Capacity*100, OilCost);
        fprintf(logFile, "Distance Traveled: %.2fkm, load rate: %.2f%%, oil cost:%.2fL \n", DisTraveled, Loadage/Capacity*100, OilCost);
        disp(separateLine);
        fprintf(logFile,[separateLine,'\n']);
    end
end
