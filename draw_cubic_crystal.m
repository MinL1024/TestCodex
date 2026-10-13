function [fig, latticePoints] = draw_cubic_crystal(latticeType, a)
%DRAW_CUBIC_CRYSTAL Draw a conventional cubic unit cell in 3-D.
%   DRAW_CUBIC_CRYSTAL() draws a simple cubic cell with a = 1.
%   DRAW_CUBIC_CRYSTAL(TYPE, A) uses TYPE = 'SC', 'BCC', or 'FCC'
%   (case-insensitive) and the positive lattice constant A.
%   [FIG, POINTS] = DRAW_CUBIC_CRYSTAL(...) returns the figure handle
%   and an N-by-3 array of lattice-point coordinates, using the same
%   length units as A.
%   Spheres mark lattice points; their radii are only for illustration.
%
%   Examples:
%       draw_cubic_crystal;
%       draw_cubic_crystal('BCC', 2);
%       fig = draw_cubic_crystal('FCC', 3.6);
%       print(fig, 'fcc_unit_cell.png', '-dpng', '-r300');
%
%   Requires MATLAB R2016b or later. No additional toolboxes required.

if nargin < 1
    latticeType = 'SC';
end
if nargin < 2
    a = 1;
end

if isstring(latticeType) && isscalar(latticeType)
    latticeType = char(latticeType);
end
if ~ischar(latticeType) || size(latticeType, 1) ~= 1
    error('draw_cubic_crystal:InvalidType', ...
        'Lattice type must be SC, BCC, or FCC.');
end
latticeType = upper(strtrim(latticeType));
validateattributes(a, {'numeric'}, ...
    {'real', 'finite', 'scalar', 'positive'}, mfilename, 'a', 2);
a = double(a);

% Fractional coordinates of the eight corners of the conventional cell.
corners = [0 0 0; 1 0 0; 1 1 0; 0 1 0; ...
           0 0 1; 1 0 1; 1 1 1; 0 1 1];
switch latticeType
    case 'SC'
        extraPoints = zeros(0, 3);
        cellName = 'Simple cubic (SC)';
        extraLabel = '';
    case 'BCC'
        extraPoints = [0.5 0.5 0.5];
        cellName = 'Body-centered cubic (BCC)';
        extraLabel = 'Body-center lattice point';
    case 'FCC'
        extraPoints = [0.5 0.5 0; 0.5 0.5 1; ...
                       0.5 0 0.5; 0.5 1 0.5; ...
                       0 0.5 0.5; 1 0.5 0.5];
        cellName = 'Face-centered cubic (FCC)';
        extraLabel = 'Face-center lattice points';
    otherwise
        error('draw_cubic_crystal:InvalidType', ...
            'Unknown lattice type. Choose SC, BCC, or FCC.');
end
latticePoints = a * [corners; extraPoints];

edges = [1 2; 2 3; 3 4; 4 1; ...
         5 6; 6 7; 7 8; 8 5; ...
         1 5; 2 6; 3 7; 4 8];
faces = [1 2 3 4; 5 6 7 8; 1 2 6 5; ...
         2 3 7 6; 3 4 8 7; 4 1 5 8];

fig = figure('Color', 'w', 'Name', cellName, ...
    'NumberTitle', 'off', 'Position', [100 100 880 700]);
ax = axes('Parent', fig);
hold(ax, 'on');
patch('Parent', ax, 'Vertices', a * corners, 'Faces', faces, ...
    'FaceColor', [0.35 0.65 0.90], 'FaceAlpha', 0.06, ...
    'EdgeColor', 'none', 'HandleVisibility', 'off');

for k = 1:size(edges, 1)
    endpoints = a * corners(edges(k, :), :);
    plot3(ax, endpoints(:, 1), endpoints(:, 2), endpoints(:, 3), ...
        '-', 'Color', [0.22 0.28 0.35], 'LineWidth', 1.5, ...
        'HandleVisibility', 'off', 'Tag', 'UnitCellEdge');
end

% Small spheres make the point positions visible without hiding the cell.
[sx, sy, sz] = sphere(20);
radius = 0.055 * a;
cornerColor = [0.15 0.45 0.80];
centerColor = [0.95 0.45 0.15];
legendHandles = gobjects(1, 1 + ~isempty(extraPoints));
legendLabels = {'Corner lattice points'};
for k = 1:size(latticePoints, 1)
    if k <= 8
        pointColor = cornerColor;
    else
        pointColor = centerColor;
    end
    p = latticePoints(k, :);
    h = surf(ax, p(1) + radius * sx, p(2) + radius * sy, ...
        p(3) + radius * sz, 'FaceColor', pointColor, ...
        'EdgeColor', 'none', 'FaceLighting', 'gouraud', ...
        'HandleVisibility', 'off', 'Tag', 'LatticePoint');
    if k == 1
        legendHandles(1) = h;
        set(h, 'HandleVisibility', 'on');
    elseif k == 9
        legendHandles(2) = h;
        legendLabels{2} = extraLabel;
        set(h, 'HandleVisibility', 'on');
    end
end

% The crystallographic axes a, b, c are parallel to x, y, z.
axisColors = [0.85 0.20 0.20; 0.15 0.60 0.25; 0.20 0.35 0.85];
axisLabels = {'a / x', 'b / y', 'c / z'};
for k = 1:3
    direction = zeros(1, 3);
    direction(k) = 1.28 * a;
    quiver3(ax, 0, 0, 0, direction(1), direction(2), direction(3), 0, ...
        'Color', axisColors(k, :), 'LineWidth', 1.8, ...
        'MaxHeadSize', 0.18, 'HandleVisibility', 'off');
    labelPosition = 1.07 * direction;
    text(ax, labelPosition(1), labelPosition(2), labelPosition(3), ...
        axisLabels{k}, 'Color', axisColors(k, :), 'FontSize', 12, ...
        'FontWeight', 'bold', 'HorizontalAlignment', 'center');
end

axis(ax, 'equal');
axis(ax, [-0.15 * a, 1.45 * a, -0.15 * a, 1.45 * a, -0.15 * a, 1.45 * a]);
view(ax, 35, 25);
grid(ax, 'on');
box(ax, 'on');
set(ax, 'FontSize', 11, 'Projection', 'orthographic', ...
    'XTick', [0 a / 2 a], 'YTick', [0 a / 2 a], 'ZTick', [0 a / 2 a]);
xlabel(ax, 'x');
ylabel(ax, 'y');
zlabel(ax, 'z');
title(ax, {cellName; sprintf('a = b = c = %.4g;  \\alpha = \\beta = \\gamma = 90^{\\circ}', a)}, ...
    'Interpreter', 'tex', 'FontSize', 14);
legend(ax, legendHandles, legendLabels, 'Location', 'southoutside');
camlight(ax, 'headlight');
rotate3d(fig, 'on');
hold(ax, 'off');
end
