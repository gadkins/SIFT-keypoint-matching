% Local Feature Stencil Code


% 'features1' and 'features2' are the n x feature dimensionality features
%   from the two images.
% If you want to include geometric verification in this stage, you can add
% the x and y locations of the features as additional inputs.
%
% 'matches' is a k x 2 matrix, where k is the number of matches. The first
%   column is an index in features 1, the second column is an index
%   in features2. 
% 'Confidences' is a k x 1 matrix with a real valued confidence for every
%   match.
% 'matches' and 'confidences' can empty, e.g. 0x2 and 0x1.
function [matches, confidences] = match_features(features1, features2)

% This function does not need to be symmetric (e.g. it can produce
% different numbers of matches depending on the order of the arguments).

% For extra credit you can implement various forms of spatial verification of matches.

distance_ratio = 0.2;
N_features1 = size(features1, 1);
N_features2 = size(features2, 1);
matches = zeros(N_features1, 2);
confidences = zeros(N_features1,1);
% if N_features1 > N_features2
%     features = N_features1;
% else
%     features = N_features2;
% end

for i=1:N_features1
    for j=1:N_features2
        try
            confidences(j) = sqrt(sum(features1(i,:)-features2(j,:)).^2);
        catch
            break
        end
    end
    [confidences, idx] = sort(confidences);
    matches(i,1) = i;
    if (confidences(1) < (distance_ratio * confidences(2)))
        matches(i,2) = idx(1);
    else
        matches(i,2) = 0;
    end
end

end

% Sort the matches so that the most confident onces are at the top of the
% list. You should probably not delete this, so that the evaluation
% functions can be run on the top matches easily.
% [confidences, ind] = sort(confidences, 'descend');
% matches = matches(ind,:);