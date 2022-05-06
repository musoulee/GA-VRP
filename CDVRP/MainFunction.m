clc;clear;close all;

%% 遗传算法求解CDVRP
% 输入：
% CustomerNum         客户点数量
% CustomerAndDepot    配送中心和客户点的经纬度信息，位置1代表配送中心
% Distance            距离矩阵
% VehicleNum          可用车辆数量
% Capacity            车辆容量约束
% MaxTravelDistance   车辆最大行驶距离
% ProductNum          产品的数量
% ProductVolume       产品的单位体积
% Demand              客户点需求量
% params
% .PopulationSize     种群大小
% .MaxGeneration      最大迭代次数
% .ProbMutation       变异概率
% .ProbCrossOver      交叉概率
% .ProbSelection      健壮个体的概率

%% 加载数据集
load("../testdata/Customer.mat"); % 客户点信息，包括车场
load("../testdata/Vehicle.mat"); % 车辆信息
load("../testdata/Product.mat"); % 产品信息

%% 遗传相关参数
params.PopulationSize = 100;
params.MaxGeneration = 5000;
params.ProbMutation = 0.05; 
params.ProbCrossOver = 0.8;
params.ProbSelection = 0.8;
params.CrossMethod = 4; % 1 OX 2 LOX 3 PMX 4 PMX_LIKE
params.MutationMethod = 1; % 1 随机交换 2 2-opt局部优化
%% 遗传相关信息保存
tic % 开始计时
Population = InitPopulation(params,Customer,Vehicle,Product); % 初始化种群
ChromosomeLength = Customer.Count + Vehicle.Count + 1; % 染色体长度
bestChromosome = zeros(params.MaxGeneration, ChromosomeLength); % 历代最优个体
maxFitness = zeros(params.MaxGeneration, 1); % 历代最优适应度
minOilCost = zeros(params.MaxGeneration,1); % 油耗
minDistance = zeros(params.MaxGeneration,1); % 行驶距离
minRoutes = zeros(params.MaxGeneration, 1); % 车辆数
%% 迭代计算

for gen = 1: params.MaxGeneration 
    %% 计算种群适应度，最优个体
    [ttlDistance, ttlOilCost, ttlRoutes, Fitness] = FitnessPop(Population,Customer,Vehicle,Product);
    [bestFitness, index] = max(Fitness);
    maxFitness(gen) = bestFitness; % 保留历代最优适应值
    bestChromosome(gen,:) = Population(index,:); % 保留历代最优个体
    minOilCost(gen) = ttlOilCost(index); % 最小油耗
    minDistance(gen) = ttlDistance(index); % 最优情况下行驶距离
    minRoutes(gen) = ttlRoutes(index);
    %% 选择
    Selected = Selection(Population,Fitness,params.ProbSelection);
    %% 交叉
    Child = CrossOver(Selected, params.ProbCrossOver,params.CrossMethod);
    %% 变异
    Child = Mutate(Child,params.ProbMutation,params.MutationMethod);
    %% 进化反转，保证种群多样性
    Child = Reverse(Child,Customer,Vehicle,Product);
    %% 亲代与子代结合成新种群，保持种群大小不变
    Population = ReProducePop(Population, Child, Fitness);
    % 显示此代最优
    fprintf("Iteration = %d, ProbMutation = %.2f, uniqueInd = %d, totalOilCost = %.2f L, totalDistance = %.2f km, totalRoutes=%d\n",...
        gen, params.ProbMutation, size(unique(Population,'rows'),1), ttlOilCost(index), ttlDistance(index),ttlRoutes(index));
end
toc

%% 迭代图
h = figure;
plot(1:1:params.MaxGeneration,minOilCost,'LineWidth',2)
xlim([1 params.MaxGeneration]);
set(gca, 'LineWidth',1);
xlabel('迭代次数');
ylabel('总油耗/L');
title('GA迭代过程');

%% 最优结果
[~, bestIndex] = max(maxFitness);
bestRoute = bestChromosome(bestIndex,:);
%% 子路径优化
disp('------------------------------------------------------------------------------');
disp('Local Search Optimization:')
disp('------------------------------------------------------------------------------');
newRoute = bestRoute;
optimTimes = 0;
for k = 2:length(bestRoute)-2
    if(bestRoute(k) ~= 1 && bestRoute(k+1) ~= 1) % 优化子路径
        newRoute(k:k+1) = bestRoute(k+1:-1:k);
        [ttlDis,ttlOil,~,fit] = FitnessChromo(newRoute, Customer, Vehicle, Product);
        [ttlDis2,ttlOil2,~,fit2] = FitnessChromo(bestRoute, Customer, Vehicle, Product);
        if(ttlOil < ttlOil2) % 如果新路径比原路径好
            optimTimes = optimTimes + 1;
            bestRoute = newRoute;
            fprintf("Improvement %d, totalOilCost = %.2fL, totalDistance = %.2fkm\n",optimTimes,ttlOil,ttlDis);
        end
        newRoute = bestRoute;
    end
end
disp('------------------------------------------------------------------------------');

%% 为结果创建文件夹
fileDir = "../output/" + string(datetime('now')).replace(["-",":"," "],""); 
mkdir(fileDir);
%% 保存迭代图
saveas(h,fileDir+"/iter.png");
%% 绘制路线
DrawRoute(bestRoute, Customer.LngLat,Customer.Index,Product.DemandVolume, fileDir);
%% 输出路线
TextOutput(bestRoute,Vehicle.Capacity,Vehicle.MaxDistance,Product.DemandVolume,Customer.Distance, ...
    Vehicle.FullyCost,Vehicle.IdleCost,params,[minDistance(bestIndex),minOilCost(bestIndex)],fileDir);