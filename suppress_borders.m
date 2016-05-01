function image = suppress_borders(image, border_width)

image(:,1:border_width) = 0;
image(:,(end-border_width):end) = 0;
image(1:border_width,:) = 0;
image((end-border_width):end,:) = 0;