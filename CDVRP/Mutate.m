function Population = Mutate(Population, prob, style)
%% 种群变异
% 输入：
% Population 初始种群
% prob       变异概率
% style      变异方式
% 1          随机交换两个基因
% 2          2-opt对子路径进行局部优化
% 输出：
% Population 变异后的种群
RANDOM_EXCH = 1;
[M, N] = size(Population);
for i = 1:M
    if rand <= prob % 随机交换两个位置，只要不为首尾即可
        Chromosome = Population(i,:);
        if style == RANDOM_EXCH
            R = randperm(N-1); % 除去尾部
            R(R==1) = []; % 除去首位
            Chromosome(R(1:2)) = Chromosome(R(2:-1:1)); % 随机交换两个位置
        end
        Population(i,:) = Chromosome;
    end
end
end