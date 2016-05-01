image1 = imread('../data/Notre Dame/921919841_a30df938f2_o.jpg');
image2 = imread('../data/Notre Dame/4191453057_c86028ce1f_o.jpg');

image1 = rgb2gray(single(image1)/255);
image2 = rgb2gray(single(image2)/255);

scale_factor = 0.5; %make images smaller to speed up the algorithm
image1 = imresize(image1, scale_factor, 'bilinear');
image2 = imresize(image2, scale_factor, 'bilinear');

points1 = corner(image1,'Harris');
points2 = corner(image2,'Harris');

h = figure;
set(h, 'Position', [100 100 1200 600])
subplot(1,3,1); imshow(image1); hold on; title('Image 1'); 
plot(points1(:,1), points1(:,2), 'ro'); hold off
subplot(1,3,2); imshow(image2); hold on; title('Image 2');
plot(points2(:,1), points2(:,2), 'ro'); hold off

[features1,valid_points1] = extractFeatures(image1,points1);
[features2,valid_points2] = extractFeatures(image2,points2);

indexPairs = matchFeatures(features1,features2);

matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);

subplot(1,3,3); imshow(image2); hold on; title('Matching');
showMatchedFeatures(image1,image2,matchedPoints1,matchedPoints2);
hold off;