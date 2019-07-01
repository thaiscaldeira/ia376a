function [RGB_label, labeled, count] = dtWatershed(im_binarized, sensitivity)

    % Distance transform
    D = -bwdist(~im_binarized);
    mask = imextendedmin(D, sensitivity);

    %imshowpair(bw2, mask,'blend')

    D2 = imimposemin(D, mask);
    W = watershed(D2);
    
    BW_label = im_binarized;
    BW_label(W == 0) = 0;
    
    cc = bwconncomp(BW_label, 4);

    labeled = labelmatrix(cc);
    RGB_label = label2rgb(labeled, 'parula', 'white', 'shuffle');
    
    count = cc.NumObjects;
    
end

