function [rgbImage] = changeMaskColor(im_bin)
    
    % Convert binary to 8bit image
    RGB_Image = uint8(im_bin(:,:,[0 1 1]) * 255);
    
    % Extract the individual red, green, and blue color channels.
    redChannel = RGB_Image(:, :, 1);
    greenChannel = RGB_Image(:, :, 2);
    blueChannel = RGB_Image(:, :, 3);

    % Find pixels that are pure white
    whitePixels = (redChannel == 255 & greenChannel  == 255 & blueChannel  == 255);

    % Make cyan (0,255,255)
    redChannel(whitePixels) = 0;
    greenChannel(whitePixels) = 0;
    blueChannel(whitePixels) = 255;

    % Recombine separate color channels into a single, true color RGB image.
    rgbImage = cat(3, redChannel, greenChannel, blueChannel);
    
end

