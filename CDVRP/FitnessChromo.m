function [totalDistance, totalOilCost, totalRoutes, fitness] = FitnessChromo(Chromosome,Customer,Vehicle,Product)
%% 计算染色体的适应度函数
% 输入：
% Chromosome        染色体
% Customer
% Vehicle
% Product
% 输出：
% totalDistance     行驶距离，单位：km
% totalOilCost      总油耗，单位：升
% vehicleUsed       发车数量
% objValue          目标函数值
% fitness           适应值
    totalDistance = 0;
    totalOilCost = 0;
    [routes, totalRoutes] = Chromo2Routes(Chromosome);
    DisByRoute = zeros(1,totalRoutes); % 每条路径的行驶里程
    LoadByRoute = zeros(1,totalRoutes); % 每条路径的装载量
    OilCostByRoute = zeros(1, totalRoutes); % 每条路径的油耗
    Demand = sum(Product.Demand'.*Product.Volume); % 客户点的需求量（换算成体积）
    %% 按照每一条路径计算行驶距离，装载量，以及总油耗
    for i = 1:totalRoutes
        route = routes{i};
        route = route + 1; % 方便索引
        DisTraveled = 0;
        Loadage = 0;
        OilCost = 0;
        for j = 2:length(route)
            %% 计算总里程
            DisTraveled = DisTraveled + Customer.Distance(route(j),route(j-1));
            if(DisTraveled > Vehicle.MaxDistance)
                totalOilCost = Inf;
                totalDistance = Inf;
                totalRoutes = Inf;
                fitness = 0; % 超出行程限制，适应值为0，直接跳出
                return;
            end
            %% 计算装载量
            Loadage = Loadage + Demand(route(j));
            if(Loadage > Vehicle.Capacity)
                totalOilCost = Inf;
                totalDistance = Inf;
                totalRoutes = Inf;
                fitness = 0;
                return; % 超出装载限制，直接跳出
            end
        end
        DisByRoute(i) = DisTraveled;
        LoadByRoute(i) = Loadage;
        %% 计算总油耗
        currLoad = Loadage;
        for j = 1:length(route)-1
            cost = currLoad/Vehicle.Capacity*(Vehicle.FullyCost-Vehicle.IdleCost)+Vehicle.IdleCost;
            OilCost = OilCost + cost * Customer.Distance(route(j),route(j+1));
            currLoad = currLoad - Demand(route(j+1));
        end
        OilCostByRoute(i) = OilCost;
    end
    totalDistance = sum(DisByRoute);
    totalOilCost = sum(OilCostByRoute);
    %% 计算适应值，难点在于平衡优先级，需要次优先级的无论如何也无法影响高优先级
    % 1.车辆数最少   [7,10]      ==>     [0.1,0.14]
    % 2.总油耗最小   [85,180]    ==>     [0.005,0.011]
    % 2.1 总距离最小 [1000,2000] ==>     [0.0005,0.0001]
    % 3.装载率最平衡,都大于70% [.5,10.5] ==> [0.1,2]
    P1 = 1000;
    P2 = 10000;
    P3 = 1;
    fitness = P1/totalRoutes + P2/totalDistance + P3/(length(LoadByRoute(LoadByRoute>0.7))+.5);
end
