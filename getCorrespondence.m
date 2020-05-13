function [firstCorrespondence, secondCorrespondence] = getCorrespondence(firstImage, secondImage, amountOfPoints)
   
    imagesc(firstImage);
    [x1, y1] = ginput(amountOfPoints);
    firstCorrespondence = [x1 y1]';
    
    imagesc(secondImage);
    [x2, y2] = ginput(amountOfPoints);
    secondCorrespondence = [x2 y2]';
   
end

