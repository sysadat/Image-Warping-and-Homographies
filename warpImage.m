function [warpIm, mergeIm] = warpImage(inputIm, refIm, H)
    
    inputIm = double(inputIm);
    refIm = double(refIm);
    
    [inputHeight, inputWidth, inputDimension] = size(inputIm);
    [refHeight, refWidth, refDimension] = size(refIm);

    imageCorners = zeros(8, 3);
%     refCorners = zeros(4, 3);
    
    % Want to find the corners for the imput image
%     inputCorners(1, :) = [1 1 1]';
%     inputCorners(2, :) = [inputWidth 1 1]';
%     inputCorners(3, :) = [1 inputHeight 1]';
%     inputCorners(4, :) = [inputWidth inputHeight 1]';
    
    % Want to find the corners for the imput image
    
    firstCorner = [1 1 1]';
    secondCorner = [inputWidth 1 1]';
    thirdCorner = [1 inputHeight 1]';
    fourthCorner = [inputWidth inputHeight 1]';
 
    imageCorners(1, :) = firstCorner * H;
    imageCorners(2, :) = secondCorner * H;
    imageCorners(3, :) = thirdCorner * H;
    imageCorners(4, :) = fourthCorner * H;
    
    % Want to find the corners for the ref image
    imageCorners(5, :) = [1 1 1]';
    imageCorners(6, :) = [refWidth 1 1]';
    imageCorners(7, :) = [1 refHeight 1]';
    imageCorners(8, :) = [refWidth refHeight  1]';

    for i = 1:4
        imageCorners(i,:) = imageCorners(i,:) / imageCorners(i,3);
    end

end

