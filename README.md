# 立方晶系 MATLAB 绘图

`draw_cubic_crystal.m` 绘制立方晶系的常规晶胞：晶格常数满足 **a = b = c**，三个晶轴夹角均为 **90°**。

支持三种立方布拉维点阵：

| 参数 | 晶胞类型 | 图中标出的格点 |
| --- | --- | --- |
| `SC` | 简单立方 | 8 个顶点 |
| `BCC` | 体心立方 | 8 个顶点 + 1 个体心 |
| `FCC` | 面心立方 | 8 个顶点 + 6 个面心 |

球体仅用于标记格点位置，不代表实际原子半径或密堆积模型。表中的数量是图中可见格点数；考虑相邻晶胞共享后，每个晶胞分别包含 1、2、4 个格点。

## 使用方法

需要 MATLAB R2016b 或更新版本，无需额外工具箱。将 `draw_cubic_crystal.m` 放在 MATLAB 当前文件夹或搜索路径中，在命令窗口运行：

```matlab
% 默认：简单立方，晶格常数 a = 1
draw_cubic_crystal;

% 体心立方，晶格常数 a = 2
draw_cubic_crystal('BCC', 2);

% 面心立方，晶格常数 a = 3.6
draw_cubic_crystal('FCC', 3.6);
```

第一个参数不区分大小写。第二个参数必须为有限、实数、正标量；坐标单位与输入的晶格常数一致。可以只指定类型，例如 `draw_cubic_crystal('FCC')`，此时 a = 1。

图中包含 12 条晶胞棱线、格点、透明晶胞表面和 a、b、c 晶轴。三个坐标轴采用相同比例，鼠标拖动可旋转视角。

## 获取坐标与保存图片

```matlab
[fig, points] = draw_cubic_crystal('FCC', 3.6);
% points 是 N×3 坐标矩阵：先列出 8 个顶点，再列出体心或面心。
% 保存 300 dpi 的 PNG 图片到 MATLAB 当前文件夹。
print(fig, 'fcc_unit_cell.png', '-dpng', '-r300');
```

## 参考资料

- [IUCr：立方晶系晶胞参数](https://it.iucr.org/Cb/ch1o2v0001/sec1o2o6/)
- [MathWorks：sphere](https://www.mathworks.com/help/matlab/ref/sphere.html)、[patch](https://www.mathworks.com/help/matlab/ref/patch.html)、[quiver3](https://www.mathworks.com/help/matlab/ref/quiver3.html)
