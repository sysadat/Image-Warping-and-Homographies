function [warpIm, mergeIm] = warpImage(inputIm, refIm, H)

    [inputRows, inputCols, inputDimension] = size(inputIm);
    [refRows, refCols, refDimension] = size(refIm);

    imageCorners = zeros(8, 3);

    firstCorner = [1 1 1]';
    secondCorner = [inputCols 1 1]';
    thirdCorner = [1 inputRows 1]';
    fourthCorner = [inputCols inputRows 1]';

    imageCorners(1, :) = H * firstCorner;
    imageCorners(2, :) = H * secondCorner;
    imageCorners(3, :) = H * thirdCorner;
    imageCorners(4, :) = H * fourthCorner;

    imageCorners(5, :) = [1 1 1]';
    imageCorners(6, :) = [refCols 1 1]';
    imageCorners(7, :) = [1 refRows 1]';
    imageCorners(8, :) = [refCols refRows  1]';

    imageCorners(1,:) = imageCorners(1,:) / imageCorners(1,3);
    imageCorners(2,:) = imageCorners(2,:) / imageCorners(2,3);
    imageCorners(3,:) = imageCorners(3,:) / imageCorners(3,3);
    imageCorners(4,:) = imageCorners(4,:) / imageCorners(4,3);

    imageTop = round(min(imageCorners(:,1)),0);
    imageBottom = round(max(imageCorners(:,1)),0);
    imageLeft = round (min(imageCorners(:,2)),0);
    imageRight = round (max(imageCorners(:,2)),0);

    height = abs(imageTop - imageBottom);
    length = abs(imageLeft - imageRight);
    a = zeros(height, length);
    b = zeros(height, length);

    invH = H^(-1);
    for i = 1:(height)
        for j = 1:(imageRight - imageLeft)
            topIndex = imageTop + i;
            leftIndex = imageLeft + j;
            pixel = invH * ([topIndex, leftIndex, 1]');
            pixel = pixel / pixel(3);
            a(i,j) = pixel(1);
            b(i,j) = pixel(2);
        end
    end

for i = 1 : 3
    if i == 1
        warpImR = interp2(im2double(inputIm(:,:,i)),a,b)';
    elseif i == 2
        warpImG = interp2(im2double(inputIm(:,:,i)),a,b)';
    elseif i == 3
        warpImB = interp2(im2double(inputIm(:,:,i)),a,b)';
    end
end

warpIm = cat(3, warpImR, warpImG, warpImB);

mergeIm = warpIm;
refIm = im2double(refIm);
for i = 1:size(refIm,1)
    for j = 1:size(refIm,2)
        rowShifted = i + max(0,-imageLeft);
        colShifted = j + max(0,-imageTop);
        mergeIm(rowShifted,colShifted,1:3) = refIm(i,j,1:3);
    end

end
