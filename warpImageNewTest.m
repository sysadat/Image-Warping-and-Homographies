% part c
function [warpIm, mergeIm] = warpImage(inputIm, refIm, H)
    
    [rows, cols, inputDimension] = size(inputIm);
    [refRows, refCols, refDimension] = size(refIm);

    corners = zeros(8, 3);
    
    % Want to find the corners for the imput image
    
    firstCorner = [1 1 1]';
    secondCorner = [cols 1 1]';
    thirdCorner = [1 rows 1]';
    fourthCorner = [cols rows 1]';
 
    corners(1, :) = H * firstCorner;
    corners(2, :) = H * secondCorner;
    corners(3, :) = H * thirdCorner;
    corners(4, :) = H * fourthCorner;
    
    % Want to find the corners for the ref image
    corners(5, :) = [1 1 1]';
    corners(6, :) = [refCols 1 1]';
    corners(7, :) = [1 refRows 1]';
    corners(8, :) = [refCols refRows  1]';

    corners(1,:) = corners(1,:) / corners(1,3);
    corners(2,:) = corners(2,:) / corners(2,3);
    corners(3,:) = corners(3,:) / corners(3,3);
    corners(4,:) = corners(4,:) / corners(4,3);

    top = round(min(corners(:,1)));
    bot = round(max(corners(:,1)));
    left = round (min(corners(:,2)));
    right = round (max(corners(:,2)));
    
    height = abs(top - bot);
    length = abs(left - right);
    a = zeros(height, length);
    b = zeros(height, length);
    
    invH = H^(-1);
    for i = 1:(height)
        for j = 1:(right - left)
            topIndex = top + i;
            leftIndex = left + j;
            pixel = [topIndex, leftIndex, 1]';
            pixel = invH * pixel;
            pixel = pixel / pixel(3);

            a(i,j) = pixel(1);
            b(i,j) = pixel(2);
        end
    end

% transfer the "normal image" using interpolation

inputImR = im2double(inputIm(:,:,1));
inputImG = im2double(inputIm(:,:,2));
inputImB = im2double(inputIm(:,:,3));

warpImR = interp2(inputImR,a,b)';
warpImG = interp2(inputImG,a,b)';
warpImB = interp2(inputImB,a,b)';

warpIm = cat(3, warpImR, warpImG, warpImB);


% transfer the original image to the warp image
vshift = max(0,-left);
hshift = max(0,-top);

mergeIm = warpIm;
refIm = im2double(refIm);
for i = 1:size(refIm,1)
    for j = 1:size(refIm,2)
        for k = 1:3
            mergeIm(i + vshift,j + hshift,k) = refIm(i,j,k);
        end
    end

end


