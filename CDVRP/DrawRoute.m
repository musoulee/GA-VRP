function DrawRoute(route, LngLat, Index, Demand, fileDir)
%% 画路径
% route  待画路径
% LngLat 经纬度信息
% Index  顾客索引
% Demand 需求量，以体积计
% fileDir 文件夹

    Count = size(LngLat, 1) - 1; % 需求点数量
    depot = LngLat(1,:); % 车场
    Customer = LngLat(2:Count+1,:); % 需求点
    h = figure;
    hold on
    % 设置坐标轴范围
    xlim([min(LngLat(:,1)) - .05, max(LngLat(:,1)) + .05]);
    ylim([min(LngLat(:,2)) - .03, max(LngLat(:,2)) + .03]);
    axis equal;
    box on;
    % 画配送中心
    h1 = plot(depot(1), depot(2), 'bp', 'MarkerSize',15, 'MarkerFaceColor','red');
    % 画需求点
    h2 = plot(Customer(1:Index(1),1), Customer(1:Index(1),2), 'o','Color',[0.5 0.5 0.5],'MarkerFaceColor','red');
    h3 = plot(Customer(Index(1)+1:Index(2),1), Customer(Index(1)+1:Index(2),2), 'o','Color',[0.5 0.5 0.5],'MarkerFaceColor','black');
    h4 = plot(Customer(Index(2)+1:Index(3),1), Customer(Index(2)+1:Index(3),2), 'o','Color',[0.5 0.5 0.5],'MarkerFaceColor','blue');
    % 加标注
    for i = 1:Count
        str = sprintf("$q_{%d}=%.2f$",i,Demand(i+1));
        text(Customer(i,1)+0.003, Customer(i,2) -0.002, str ,'Interpreter','Latex');
    end

  
    % 画路径

    color = rand(1,3);
    for i = 1:length(route) - 1
        x = LngLat(route(i), 1);
        y = LngLat(route(i), 2);
        x2 = LngLat(route(i+1), 1);
        y2 = LngLat(route(i+1), 2);
        quiver(x,y,x2-x,y2-y,'AutoScaleFactor',0.95,'LineWidth',1.5,'Color',color,'MaxHeadSize',0.1);
        if(route(i+1) == 1)
            color = rand(1,3);
        end
    end
    xlabel('经度');
    ylabel('纬度');
    title('车辆行驶路线');    
    legend([h1,h2,h3,h4],"配送中心","产品1","产品2","产品3","Location","eastoutside");

    hold off;
    %% 保存图片
    filename = fileDir + "/routes.png";
    saveas(h,filename);
end