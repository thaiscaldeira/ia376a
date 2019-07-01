function [J] = contrastEnhancement(RGB, value)
% Choose value around 0.002 and 0.005

LAB = rgb2lab(RGB);
L = LAB(:,:,1)/100;
L = adapthisteq(L,'NumTiles',[8 8],'ClipLimit', value);
LAB(:,:,1) = L*100;
J = lab2rgb(LAB);

end

