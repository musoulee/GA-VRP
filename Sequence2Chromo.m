function Chromosome = Sequence2Chromo(Sequence,Customer,Vehicle,Product)
%% 序列变为染色体
    ChromoLength = Customer.Count + Vehicle.Count + 1; % 染色体长度
    Chromosome = ones(1,ChromoLength); % 全部初始化为1，即车场
    k = 1; % 染色体基因位
    load = 0; % 装载量
    distance = 0; % 行驶距离
    v = 1; % Sequence[v]
    while v <= length(Sequence) % 每一序列将其放至对应基因位
        visit = Sequence(v);
        k = k + 1; % 配置Chromosome下一基因位
        % 1. 如果d + d[i,j] + d[j,0] > maxD
        % 2. 如果load + sum(q[i]) > capacity
        if(load + sum(Product.Demand(visit,:).*Product.Volume',2) > Vehicle.Capacity ...
                || distance + Customer.Distance(Chromosome(k-1),visit) + Customer.Distance(visit,1) > Vehicle.MaxDistance)
            Chromosome(k) = 1; % 当前只能访问车场
            load = 0;
            distance = 0;
        else
            % 否则，将当前需求点加入染色体k位置
            distance = distance + Customer.Distance(Chromosome(k-1),visit);
            load = load + sum(Product.Demand(visit,:).*Product.Volume',2);
            Chromosome(k) = visit;
            v = v + 1; % 检查下一个需求点
        end
    end
    if(k >= ChromoLength) % 说明车辆数不够
        ME = MException('indexExceedBound:vehicleNumInsufficient','可用车辆不足！至少需要%d台车辆',length(find(Chromosome==1)));
        throw(ME);
    end
end