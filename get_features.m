% Local Feature Stencil Code
 
% Returns a set of feature descriptors for a given set of interest points. 

% 'image' can be grayscale or color, your choice.
% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
%   The local features should be centered at x and y.
% 'feature_width', in pixels, is the local feature width. You can assume
%   that feature_width will be a multiple of 4 (i.e. every cell of your
%   local SIFT-like feature will have an integer width and height).
% If you want to detect and describe features at multiple scales or
% particular orientations you can add input arguments.

% 'features' is the array of computed features. It should have the
%   following size: [length(x) x feature dimensionality] (e.g. 128 for
%   standard SIFT)

function [features] = get_features(image, x, y, feature_width, orientation)

% To start with, you might want to simply use normalized patches as your
% local feature. This is very simple to code and works OK. However, to get
% full credit you will need to implement the more effective SIFT descriptor
% (See Szeliski 4.1.2 or the original publications at
% http://www.cs.ubc.ca/~lowe/keypoints/)

% Your implementation does not need to exactly match the SIFT reference.
% Here are the key properties your (baseline) descriptor should have:
%  (1) a 4x4 grid of cells, each feature_width/4.
%  (2) each cell should have a histogram of the local distribution of
%    gradients in 8 orientations. Appending these histograms together will
%    give you 4x4 x 8 = 128 dimensions.
%  (3) Each feature should be normalized to unit length
%
% You do not need to perform the interpolation in which each gradient
% measurement contributes to multiple orientation bins in multiple cells
% As described in Szeliski, a single gradient measurement creates a
% weighted contribution to the 4 nearest cells and the 2 nearest
% orientation bins within each cell, for 8 total contributions. This type
% of interpolation probably will help, though.

% You do not have to explicitly compute the gradient orientation at each
% pixel (although you are free to do so). You can instead filter with
% oriented filters (e.g. a filter that responds to edges with a specific
% orientation). All of your SIFT-like feature can be constructed entirely
% from filtering fairly quickly in this way.

% You do not need to do the normalize -> threshold -> normalize again
% operation as detailed in Szeliski and the SIFT paper. It can help, though.

% Another simple trick which can help is to raise each element of the final
% feature vector to some power that is less than one. This is not required,
% though.

dim = 8;
N_bins = 16;
descriptor_size = dim*dim*N_bins;

if mod(feature_width,4) ~= 0
    error('feature width should be a multiple of 4');
end

features = zeros(size(x,1), descriptor_size);

cell_count = 0;
H = fspecial('gaussian',dim,0.5);


for i=1:length(x)
    descriptor = zeros(1,descriptor_size);
    bins = zeros(1,N_bins);
    y_zero = (y(i)-feature_width);
    x_zero = (x(i)-feature_width);
    try
        window = image(y_zero:((y_zero-1)+feature_width), x_zero:((x_zero-1)+feature_width));
        for j=1:feature_width
            subwindow = window((cell_count*dim+1):(cell_count*dim+1)+3,(cell_count*dim+1):(cell_count*dim+1)+3);
            [Gmag,Gdir] = imgradient(subwindow);
            Gmag = imfilter(Gmag,H);    %% gaussian weighting function
            Gdir(Gdir<0) = Gdir(Gdir<0) + 360;
            Gdir = Gdir - orientation(i);
            for k=1:N_bins
                angle_mag = 0;
                [r,c] = find(Gdir>((k-1)*23.5-1) & Gdir<=(k*23.5-1));
                for l=1:length(r)
                    angle_mag = angle_mag + Gmag(r(l),c(l));
                end
                bins(1,k) = angle_mag;
            end
            descriptor((j-1)*8+1:j*8) = bins;
        end
    catch
    end
%     descriptor = descriptor - orientation(i);
    descriptor = normr(descriptor);
    descriptor(descriptor > 0.2) = 0.2;     %% illumination invariant
    features(i,:) = normr(descriptor);
end
features = features.^0.3;
end








