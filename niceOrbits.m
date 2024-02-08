function niceOrbits
    % Define the colormap
    myColorMap = createColormap('#343635', '#FAF6ED', true);
    c_labels = myColorMap(end,:);

    % Define parameters
    n_points = 1000;
    n_iter = 500;
    % a = 5.46;
    % b = 4.55;
    a = 2.7;
    b = 2.08;

    % Calculate orbits
    [l_cx, l_cy] = calcOrbit(n_points, a, b, n_iter);

    % Plot
    area = [-1, 1, -1, 1];
    figure('Color',myColorMap(1,:)); 
    h = histogram2(l_cx, l_cy, 'XBinLimits', [area(1:2)],  'YBinLimits', [area(3:4)], 'BinWidth', [2/3000, 2/3000], 'Normalization', 'count');
    counts = h.Values;
    imagesc(log(counts + 1))
    colormap(myColorMap);
    axis image
    axis off;
    title(['$$\begin{array}{l} x_{t+1} = \sin(x_t^2-y_t^2 + ', num2str(a), ') \\ y_{t+1} = \cos(2x_t y_t + ', num2str(b), ') \end{array}$$'], 'Interpreter', 'latex', 'Color', c_labels);
    % colorbar;
end

function cmap = createColormap(hexColor1, hexColor2, reverse)
    color1 = hex2rgb(hexColor1);
    color2 = hex2rgb(hexColor2);
    if reverse
        colors = [color2; color1];
    else
        colors = [color1; color2];
    end
    x = linspace(0, 1, size(colors, 1));
    cmap = interp1(x, colors, linspace(0, 1, 256));
end

function [l_cx, l_cy] = calcOrbit(n_points, a, b, n_iter)
    x = linspace(-1, 1, n_points);
    y = linspace(-1, 1, n_points);
    [xx, yy] = meshgrid(x, y);
    l_cx = zeros(n_iter*n_points^2, 1);
    l_cy = zeros(n_iter*n_points^2, 1);
    for i = 0:n_iter-1
        xx_new = sin(xx.^2 - yy.^2 + a);
        yy_new = cos(2.*xx.*yy + b);
        xx = xx_new;
        yy = yy_new;
        l_cx(i*n_points^2+1:(i+1)*n_points^2) = xx(:);
        l_cy(i*n_points^2+1:(i+1)*n_points^2) = yy(:);
    end
end

function rgb = hex2rgb(hex)
    hex = strrep(hex, '#', '');
    rgb = sscanf(hex, '%2x%2x%2x', [1 3])/255;
end
