clc;clear;
%% 加载随机数据集
% Customer.
% Count             客户点数量
% LngLat            配送中心和客户点的经纬度信息，位置1代表配送中心
% Distance          距离矩阵
% Vehicle.
% Count             可用车辆数量
% Capacity          车辆容量约束
% MaxDistance       车辆最大行驶距离
% IdleCost          空载油耗
% FullyCost         满载油耗
% OilPrice          单位油价
% Price             固定发车成本
% Product.
% Count             产品的数量
% Volume            产品的单位体积
% Demand            客户点需求量
rng(0); % 随机生成器
%% 客户点数据
Customer.Count = 100; 
Customer.Index = [30 60 100]; % 三种产品的索引
Customer.LngLat = [rand(Customer.Count+1,1)* 0.804 + 105.4777, rand(Customer.Count+1,1)* 0.4228 + 32.2686]; 
Customer.Distance = zeros(Customer.Count+1,Customer.Count+1);
for i = 1:size(Customer.Distance,2)
    for j = 1:size(Customer.Distance,1)
        Customer.Distance(i,j) = LngLat2Km(Customer.LngLat(i,:),Customer.LngLat(j,:));
    end
end

%% 车辆数据
Vehicle.Count = Customer.Count * 0.5; 
Vehicle.Capacity = 30; 
Vehicle.MaxDistance = 200; 
Vehicle.IdleCost = 0.1;
Vehicle.FullyCost = 0.2;
Vehicle.OilPrice = 9.32;
Vehicle.Price = 200000;
%% 产品数据
Product.Count = length(Customer.Index);
Product.Volume = rand(Product.Count,1) * 0.03 + 0.12;
% Product.Demand = [zeros(1,Product.Count);randi([5,15],Customer.Count,Product.Count)]; % 车场需求设置为0
Product.Demand = zeros(Customer.Count,Product.Count); 
Product.Demand(1:Customer.Index(1),1) = randi([50,100],Customer.Index(1),1);% 产品1需求
Product.Demand(Customer.Index(1)+1:Customer.Index(2),2) = randi([20,60],Customer.Index(2)-Customer.Index(1),1); % 产品2需求
Product.Demand(Customer.Index(2)+1:Customer.Index(3),3) = randi([40,50],Customer.Index(3)-Customer.Index(2),1); % 产品3需求
Product.Demand = [zeros(1,Product.Count); Product.Demand]; % 车场需求为0
Product.DemandVolume = sum(Product.Demand.*Product.Volume',2);

save Customer.mat Customer
save Vehicle.mat Vehicle
save Product.mat Product
