function Selected =  Selection(Population, Fitness, ProbSelection)
%% 从种群中选择个体（轮盘赌）
% 输入：
% Population    种群
% Fitness       适应值
% ProbSelection 选择的概率
prob = Fitness/sum(Fitness); % 选择每个个体的概率
cumProb = cumsum(prob); % 累计概率
[PopSize, ChromoLength] = size(Population);
SelSize = max(ceil(PopSize * ProbSelection), 2); % 被选择的个体数量，至少为2
Selected = zeros(SelSize, ChromoLength);
for i = 1:SelSize
    pho = rand;
    for j = 1:PopSize
        if(pho <= cumProb(j))
            Selected(i,:) = Population(j,:); % 选择此个体放入子代
            break;
        end
    end
end
end