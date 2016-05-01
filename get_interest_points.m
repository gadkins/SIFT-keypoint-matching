% Local Feature Stencil Code

% Returns a set of interest points for the input image

% 'image' can be grayscale or color, your choice.
% 'feature_width', in pixels, is the local feature width. It might be
%   useful in this function in order to (a) suppress boundary interest
%   points (where a feature wouldn't fit entirely in the image, anyway)
%   or(b) scale the image filters being used. Or you can ignore it.

% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
% 'confidence' is an nx1 vector indicating the strength of the interest
%   point. You might use this later or not.
% 'scale' and 'orientation' are nx1 vectors indicating the scale and
%   orientation of each interest point. These are OPTIONAL. By default you
%   do not need to make scale and orientation invariant local features.
function [x, y, confidence, scale, orientation] = get_interest_points(image, feature_width)

% Implement the Harris corner detector (See Szeliski 4.1.1) to start with.
% You can create additional interest point detector functions (e.g. MSER)
% for extra credit.

% If you're finding spurious interest point detections near the boundaries,
% it is safe to simply suppress the gradients / corners near the edges of
% the image.

% The lecture slides and textbook are a bit vague on how to do the
% non-maximum suppression once you've thresholded the cornerness score.
% You are free to experiment. Here are some helpful functions:
%  BWLABEL and the newer BWCONNCOMP will find connected components in 
% thresholded binary image. You could, for instance, take the maximum value
% within each component.
%  COLFILT can be used to run a max() operator on each sliding window. You
% could use this to ensure that every interest point is at a local maximum
% of cornerness.

warning('off', 'Images:initSize:adjustingMag');
% blur = imgaussfilt(image, 1);
H = fspecial('laplacian');
blur = imfilter(image,H);
% figure; imshow(image); title('Blurred Image');
[Gx,Gy] = imgradientxy(blur);
[scale,orientation] = imgradient(blur);
orientation(orientation<0) = orientation(orientation<0) + 360;

% Image gradients
Ixx = imgaussfilt(Gx.^2);
Iyy = imgaussfilt(Gy.^2);
Ixy = Gx.*Gy;
Ixy = imgaussfilt(Ixy);
h = figure;
set(h, 'Position', [100 100 1200 600])
subplot(1,3,1); imshow(Ixx); title('Ixx: Squared Image Gradient wrt X');
subplot(1,3,2); imshow(Iyy); title('Iyy: Squared Image Gradient wrt Y');
subplot(1,3,3); imshow(Ixy); title('Ixy');

% Harris response function
alpha = 0.05;
response = Ixx.*Iyy - Ixy.^2 - alpha*(Ixx+Iyy).^2;
h = figure;
set(h, 'Position', [100 100 1200 600])
subplot(1,3,1); imshow(response); title('Harris Response'); 
range = max(response(:)) - min(response(:));
response(response<(0.15*range)) = 0; 
response = suppress_borders(response, 80);
subplot(1,3,2); imshow(response); title('Thresholded Response');

% NMS
CC = bwconncomp(response,8);
s = regionprops(CC,'Centroid');
centroids = cat(1,s.Centroid);
subplot(1,3,3); imshow(image); title('Key-Points');
hold on
plot(centroids(:,1),centroids(:,2),'ro');
hold off
[y,x,confidence] = find(response>0);
temp = zeros(length(y),1);
for i=1:length(y)
    temp(i) = orientation(y(i),x(i));
end
orientation = temp;

h = figure;
set(h, 'Position', [100 100 1200 600])
subplot(1,3,1); imshow(image); title('Image'); 
subplot(1,3,2); imshow(Ixx); title('Gradients'); 
subplot(1,3,3); imshow(image); title('Key-Points');
hold on
plot(centroids(:,1),centroids(:,2),'ro');
hold off
end

