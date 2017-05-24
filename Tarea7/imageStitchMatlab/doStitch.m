function doStitch(sifts, siftLoc, images)

    assert(length(sifts) == 3);
    assert(length(siftLoc) == 3);
    assert(length(images) == 3);
    
    [H12, corres12_1, corres12_2, inlinersIdx12] = ...
        getHomography(sifts{1}, siftLoc{1}, sifts{2}, siftLoc{2});
    [H32, corres32_1, corres32_2, inlinersIdx32] = ...
        getHomography(sifts{3}, siftLoc{3}, sifts{2}, siftLoc{2});
    
    visualize(images{1}, corres12_1', corres12_2', inlinersIdx12, 'Image 1 - 2');
    visualize(images{3}, corres32_1', corres32_2', inlinersIdx32, 'Image 2 - 3');
    
    % image space for mosaic
    % TODO: not hard-code...
    %bbox = [0 0 0 0];
    bbox = getBoundingBox([0 0 0 0], images, {H12, eye(3), H32});
    l = abs(bbox(1));    t = abs(bbox(3));
    bbox = bbox + [-l/4 l -t/2 -t/2];
    
    % warp image 1 to mosaic image
    Im2w = vgg_warp_H(double(images{2}), eye(3), 'linear', bbox);
    Im1w = vgg_warp_H(double(images{1}), H12, 'linear', bbox);
    Im3w = vgg_warp_H(double(images{3}), H32, 'linear', bbox);
    
    figure();
    imagesc(double(max(max(Im1w,Im2w), Im3w))/255);
end

function newBox = getBoundingBox(bbox, images, H)
    assert(length(images) == length(H));
    n = length(images);
    newBox = bbox;
    for i=1:n
        [w, h, ~] = size(images{i});
        imgBox = H{i}*[1 w 1 w; 1 1 h h; 1 1 1 1];
        imgBox = [imgBox(1, :) ./ imgBox(3, :); ...
                  imgBox(2, :) ./ imgBox(3, :)];
        newBox = [  ceil(min(newBox(1), min(imgBox(1, :)))) ...
                    ceil(max(newBox(2), max(imgBox(1, :)))) ...
                    ceil(min(newBox(3), min(imgBox(2, :)))) ...
                    ceil(max(newBox(4), max(imgBox(2, :))))];
    end
end