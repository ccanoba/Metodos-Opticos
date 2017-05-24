function [sifts, siftLocations, images] = getSift(imgFiles, maxWidth)
% Compute the sift descriptor of N images
% imgFiles - N x 1 cell array containing image file names
% sifts - N x 1 cell array, sifts{i} is a M x 128 array containing 
%         M sift feature vectors of image i.
% siftLocations - N x 1 cell array, siftLocations is a M x 2 array 
%                   containing (x, y) of M interesting points of image i
    sifts = cell(length(imgFiles), 1);
    siftLocations = cell(length(imgFiles), 1);
    images = cell(length(imgFiles), 1);
    
    if nargin < 2
        maxWidth = 800;
    end
    
    for i=1:length(imgFiles)
        imgFile=imgFiles{i};
        img = imread(imgFile);
        if maxWidth > 0 && size(img, 2) > maxWidth
            img = imresize(img, maxWidth / size(img, 2));
        end
        fprintf(sprintf('Read %s: ', imgFile));
        size(img)
        
        % Harris detector
        [x, y, ~] = harris(img);
        
        % SIFT descriptor
        RADIUS = 10;
        ENLARGE_FACTOR = 1.5;
        circles = [x y RADIUS*ones(length(x), 1)];
        sifts{i} = find_sift(img, circles, ENLARGE_FACTOR);
        siftLocations{i} = [x y];
        images{i} = img;
    end
end