function Chromo = ChromoGen(Customer,Vehicle,Product)
%% 染色体生成
    Sequence = randperm(Customer.Count) + 1; % 生成一个随机访问序列，不包括首位
    Chromo = Sequence2Chromo(Sequence,Customer,Vehicle,Product);
end