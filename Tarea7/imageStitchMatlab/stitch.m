% function stitch(imgFiles)
    
    imgFiles = {'cite/cite_a.jpg', 'cite/cite_b.jpg', 'cite/cite_c.jpg'};

    assert(length(imgFiles) == 3);
    
    % compute sift feature vectors
    [sifts, siftLoc, images] = getSift(imgFiles);
    
    doStitch(sifts, siftLoc, images);
% end