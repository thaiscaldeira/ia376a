function [im_otsu] = otsuMorph(im_orig, bht, opn, cls)
% otsuMorph changes RGB image into grayspace, performs morphological 
%   bottom-hat, opening and closing, and then, Otsu binarization.
% Receives image and diameter of structuring element.

im_gray = rgb2gray(im_orig);

se = strel('disk', bht);
se2 = strel('disk', opn);
se3 = strel('disk', cls);

im_gray = imbothat(im_gray, se);
im_gray = imopen(im_gray, se2);
im_gray = imclose(im_gray, se3);

im_otsu = imbinarize(im_gray);

end

