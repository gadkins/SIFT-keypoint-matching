function dog = difference_of_gaussian(image, sigma, octaves, scales)

% Incomplete

if nargin < 4
    scales = 5;
elseif nargin < 3
    octaves = 4;
end

sigma = 2^(-0.5);
image = (image - min(image)) / (max(image) - min(image));
H = fspecial('gaussian',(3*sigma)+1,sigma);
blur = imfilter(image,H);
dog = image - blur;

for i=1:octaves
    sigma = 2^(-0.5);
    for j=1:scales
        H = fspecial('gaussian',(3*sigma)+1,sigma);
        blur = imfilter(image,H);
        dog = image - blur;
        image = blur;
        sigma = 2^(-0.5+i);
    end
    image = imresize(image,0.5);
end

end
