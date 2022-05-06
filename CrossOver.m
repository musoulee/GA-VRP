function Child = CrossOver(Parent, prob, method)
%% 交叉
% 输入：
% Parent    父代种群
% prob      交叉概率
% method    交叉方法
% 1         OX
% 2         LOX
% 3         PMX
% 4         PMX_LIKE

% 输出：
% Child：   子代种群
    Method.OX = 1;
    Method.LOX = 2;
    Method.PMX = 3;
    Method.PMX_LIKE = 4;
    [popSize, len]= size(Parent); % 种群大小
    Child = Parent;
    for i = 1:2:popSize-mod(popSize,2)
        if rand <= prob 
            % 两两交叉
            switch method
                case Method.OX
                    [Child(i,2:len-1),Child(i+1,2:len-1)] = OX(Parent(i,2:len-1), Parent(i+1,2:len-1));
                case Method.LOX

                case Method.PMX

                case Method.PMX_LIKE
                    [Child(i,2:len-1),Child(i+1,2:len-1)]=PMX_LIKE(Parent(i,2:len-1),Parent(i+1,2:len-1)); % 除去首尾的1
                otherwise
            end
        end
    end
end
% OX方法交叉
function [c1, c2] = OX(p1,p2)
    L = length(p1);
    r1 = unidrnd(L);
    r2 = unidrnd(L);
    s = min(r1, r2); % 起点位置
    e = max(r1, r2); % 终点位置
    function c = helper(p1, p2)
        
    end
    c1 = helper(p1,p2);
    c2 = helper(p2,p1);
end
% LOX方法


% 类PMX方法
function [c1, c2] = PMX_LIKE(p1,p2)
    L = length(p1);
    r1 = unidrnd(L);
    r2 = unidrnd(L);
    s = min(r1, r2); % 起点位置
    e = max(r1, r2); % 终点位置
    seq1 = p1(s:e);
    seq2 = p2(s:e); % 被复制的序列
    % 两个序列中都有的基因去重
    seq12 = p1(s:e);
    seq22 = p2(s:e);
    pp1 = p1;
    pp2 = p2;
    pp1(s:e) = [];  % 用来替换重复基因
    pp2(s:e) = [];
    % 消除重复元素
    for i = 1:length(seq12)
        for j = 1:length(seq22)
            if seq12(i) == seq22(j)
                seq12(i) = -1;
                seq22(j) = -1;
                break;
            end
        end
    end
    seq12(seq12==-1) = [];
    seq22(seq22==-1) = [];
    % 对于pp1中与seq2重复的基因，使用seq1中对应位置的基因替换
    for i = 1:length(seq22)
        j = pp1==seq22(i); % 找到重复基因的索引
        pp1(j) = seq12(i);
    end
    for i = 1:length(seq12)
        j = pp2 == seq12(i);
        pp2(j) = seq22(i);
    end
    c1 = [pp1(1:s-1),seq2,pp1(s:length(pp1))];
    c2 = [pp2(1:s-1),seq1,pp2(s:length(pp2))];
end
