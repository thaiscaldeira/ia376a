function [binImage] = selectLayers(labeledImage, layer0, layer1)

 binImage = labeledImage*10;

     % Change pixel values to 0
     for i = layer0*10
         binImage(binImage == i) = 0;     
     end

     % Change pixel values to 1
     for i = layer1
         binImage(binImage == i) = 1;     
     end

end

