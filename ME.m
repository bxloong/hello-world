hx = 50;
hy = 50;
v1 = ones(hy, hx);
m = 49;
n = 49;
%% 上下两行的 Dirichlet 边界条件
v1(hy, :) = ones(1, hx) * 100;
v1(1, :) = ones(1, hx) * 0;
%% 左右两列的 Dirichlet 边界条件值
for i = 1 : hy
    v1(i, 1) = 0;
    v1(i, hx) = 0;
end
%% 计算松弛因子
t1 = (cos(pi/m) + cos(pi/n)) / 2;
w = 2 / (1 + sqrt(1 - t1 * t1));
%% 初始化
v2 = v1;
maxt = 1;
t = 0;
k = 0;
%% 迭代
while (maxt > 1e-6)
    k = k + 1;
    maxt = 0;
    for i =2:hy - 1
        for j = 2:hx - 1
            v2(i, j) = v1(i, j) + (v1(i, j + 1) + v1(i + 1, j) + ...
                v2(i - 1, j) + v2(i, j - 1) - 4 * v1(i, j)) * w / 4;
            t = abs(v2(i, j) - v1(i, j));
            if (t > maxt)
                maxt = t;
            end
        end
    end
    v1 = v2;
end
%% 输出
k  %迭代次数
subplot(1, 2, 1), mesh(v2); % 画三维曲面图
axis([0, hx, 0, hy, 0, 100]);
subplot(1, 2, 2), contour(v2, 30); %画等电位线图
hold on
x = 1 : 1 : hx;
y = 1 : 1 : hy;
[xx, yy] = meshgrid(x, y); % 形成栅格
[Gx, Gy] = gradient(-v2, 25, 25); % 计算梯度
q = quiver(xx, yy, Gx, Gy, 20.0); % 根据梯度画箭头
q.Color = 'g';
q.MaxHeadSize = 0.5;
axis([1, hx, 1, hy]); % 设置坐标边框
plot([1, 1, hx, hx, 1], [1, hy, hy, 1, 1], 'k') % 画导体边框
text(hx/2, -2.0, '0V', 'fontsize', 11); % 下标注
text(hx/2, hy + 2.0, '100V', 'fontsize', 11); % 上标注
text(-4.0, hy/2 + 2.0, '0V', 'fontsize', 11); % 左标注
text(hx + 1.0, hy/2 + 2.0, '0V', 'fontsize', 11); % 右标注
hold off