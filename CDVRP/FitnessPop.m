function [ttlDistance, ttlOilCost, ttlRoutes, Fitness] = FitnessPop(Population,Customer,Vehicle,Product)
%% 计算种群的适应度值
    PopulationSize = size(Population, 1);
    ttlDistance = zeros(PopulationSize,1); 
    ttlOilCost = zeros(PopulationSize,1); 
    ttlRoutes = zeros(PopulationSize,1);
    Fitness = zeros(PopulationSize,1); 
    
    for i = 1:size(Population,1)
        Chromosome = Population(i,:);
        [totalDistance, totalOilCost, routesNum, fitness] = FitnessChromo(Chromosome,Customer,Vehicle,Product);
        ttlDistance(i) = totalDistance;
        ttlOilCost(i) = totalOilCost;
        ttlRoutes(i) = routesNum;
        Fitness(i) = fitness;
    end
end