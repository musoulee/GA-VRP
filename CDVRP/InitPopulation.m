function Population = InitPopulation(params,Customer,Vehicle,Product)
    ChromoLength = Customer.Count + Vehicle.Count + 1; % 染色体长度
    Population = zeros(params.PopulationSize, ChromoLength); % 种群预分配大小
    for i = 1:size(Population,1)
        Population(i,:) = ChromoGen(Customer,Vehicle,Product);
    end
end
