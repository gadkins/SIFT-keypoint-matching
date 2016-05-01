% Local Feature Stencil Code
% This script 
% (1) Loads and resizes images
% (2) Finds interest points in those images                 (you code this)
% (3) Describes each interest point with a local feature    (you code this)
% (4) Finds matching features                               (you code this)
% (5) Visualizes the matches
% (6) Evaluates the matches based on ground truth correspondences

close all

% you need prepare a pair of images on your own. You can either download from the internet or capture by your self.
%However, the particular evaluation function at the bottom of this script will only work for this
% provided image pair (unless you add ground truth annotations for other
% image pairs). It is suggested that you only work with these two images
% until you are satisfied with your implementation and ready to test on
% additional images. A single scale pipeline works fine for these two
% images (and will give you full credit for this project), but you will
% need local features at multiple scales to handle harder cases.
image1 = imread('../data/Notre Dame/921919841_a30df938f2_o.jpg');
image2 = imread('../data/Notre Dame/4191453057_c86028ce1f_o.jpg');
% image1 = imread('../data/ssb1.jpg');
% image2 = imread('../data/ssb2.jpg');
% image1 = imrotate(image1,-90);
% image2 = imrotate(image2,-90);

% You don't have to work with grayscale images. Matching with color
% information might be helpful.
image1 = rgb2gray(single(image1)/255);
image2 = rgb2gray(single(image2)/255);

scale_factor = 0.5; %make images smaller to speed up the algorithm
image1 = imresize(image1, scale_factor, 'bilinear');
image2 = imresize(image2, scale_factor, 'bilinear');

feature_width = 64; %width and height of each local feature, in pixels. 

%% Find distinctive points in each image. Szeliski 4.1.1
% !!! You will need to implement get_interest_points. !!!
close all;
disp('Calculating interest points & feature descriptors...');
[x1, y1, confidence, scale, orientation] = get_interest_points(image1, feature_width);
[image1_features] = get_features(image1, x1, y1, feature_width, orientation);
[x2, y2, confidence, scale, orientation] = get_interest_points(image2, feature_width);
[image2_features] = get_features(image2, x2, y2, feature_width, orientation);
%% Create feature vectors at each interest point. Szeliski 4.1.2
% !!! You will need to implement get_features. !!!




%% Match features. Szeliski 4.1.3
% !!! You will need to implement get_features. !!!
disp('Matching features...');
[matches, confidences] = match_features(image1_features, image2_features);

% You might want to set 'num_pts_to_visualize' and 'num_pts_to_evaluate' to
% some constant once you start detecting hundreds of interest points,
% otherwise things might get too cluttered. You could also threshold based
% on confidence.
num_pts_to_visualize = size(matches,1);
show_correspondence(image1, image2, x1(matches(1:num_pts_to_visualize)), ...
                                    y1(matches(1:num_pts_to_visualize)), ...
                                    x2(matches(1:num_pts_to_visualize)), ...
                                    y2(matches(1:num_pts_to_visualize)));

num_pts_to_evaluate = size(matches,1);
% All of the coordinates are being divided by scale_factor because of the
% imresize operation at the top of this script. This evaluation function
% will only work for the particular Notre Dame image pair specified in the
% starter code. You can, however, use 'collect_ground_truth_corr.m' to
% build ground truth for additional image pairs and then change the paths
% in 'evaluate_correspondence' accordingly. Or you can simply comment out
% this function once you start testing on additional image pairs.
evaluate_correspondence(x1(matches(1:num_pts_to_evaluate))/scale_factor, ...
                        y1(matches(1:num_pts_to_evaluate))/scale_factor, ...
                        x2(matches(1:num_pts_to_evaluate))/scale_factor, ...
                        y2(matches(1:num_pts_to_evaluate))/scale_factor);










