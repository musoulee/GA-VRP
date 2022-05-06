function Population = ReProducePop(Parent, Child, FitnessP)
%% 把亲代和子代重组为新的种群
% 输入：
% Parent      亲代种群
% Child       子代种群
% FitnessP    亲代适应度值
% 输出：
% Population  新的种群
    PSize = size(Parent,1);
    CSize = size(Child,1);
    [~, index] = sort(FitnessP, 'descend');
    % 先将父代优秀的个体放入，再把子代放入尾端
    Population = [Parent(index(1:PSize-CSize),:);Child];
end