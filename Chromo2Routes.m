function [routes, count] = Chromo2Routes(Chromosome)
%% 解码染色体为路径序列
% 输入：
% Chromosome 形如1,2,3,1,4,5,1,1,1的基因序列
% 输出：
% routes     形如{route1, route2, ..., routeN}的路径序列
% route_i    形如[1,2,3,1]的序列
% count      路径的数量

    Chromosome = Chromosome - 1; % 编号全部减1
    for k = 2:length(Chromosome)
        if(Chromosome(k) == 0 && Chromosome(k-1) == 0)
            Chromosome(k-1) = -1;
        end
    end
    Chromosome(Chromosome==-1) = [];

    routes = {}; % 空的路径集合
    index = 1;
    route = [0]; % 路径从车场出发
    for k = 2:length(Chromosome)
        route = [route, Chromosome(k)];
        if(Chromosome(k) == 0) % 如果是车场，新加一条路径
            if(route(length(route)) == route(length(route) - 1)) % 如果最后两个都为1，就说明所有的路径已经寻找完毕
                break
            end
            routes{index} = route;
            index = index + 1;
            route = [0];
        end
    end
    count = length(routes);
end