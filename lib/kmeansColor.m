function [pixel_labels] = kmeansColor(im_orig, nColors)
% kMeans Color Sementation
% Performs color segmentation by clustering pixels with different colors.
% User determines the number of clusters and image
% Function returns segmented image (pixels range between [1, nColors])

Ilab = rgb2lab(im_orig);

% Extract a* and b* channels and reshape
ab = double(Ilab(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

% Segmentation usign k-means
[cluster_idx, ~] = kmeans(ab,nColors,...
  'distance',     'sqEuclidean', ...
  'Replicates',   3);

% Final result
pixel_labels = reshape(cluster_idx,nrows,ncols);

%imshow(pixel_labels,[]), title('image labeled by cluster index');
end

