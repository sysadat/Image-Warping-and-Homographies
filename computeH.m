function H = computeH(t1, t2)
    t1Size = size(t1);
    t2Size = size(t2);
    
    if (t1Size ~= t2Size)
        error('Dimension Error');
    end
    if (t1Size < 4)
        error('t1 does not have enough points');
    end
    if (t2Size < 4)
        error('t2 does not have enough points');
    end
    
    [~,t1Col] = size(t1);
    A = zeros(2 * t1Col, 9);
    
    for i = 1:t1Col
        temp1_1 = t1(1, i);
        temp1_2 = t1(2, i);
        temp2_1 = t2(1, i);
        temp2_2 = t2(2, i);
        negProduct1 = -1 * temp2_1 * temp1_1;
        negProduct2 = -1 * temp2_1 * temp1_2;
        negProduct3 = -1 * temp2_2 * temp1_1;
        negProduct4 = -1 * temp2_2 * temp1_2;

        A(2 * i - 1,: ) = [temp1_1, temp1_2, 1, 0, 0, 0, negProduct1, negProduct2, -temp2_1];
        A(2 * i, :) = [0, 0, 0, temp1_1, temp1_2, 1, negProduct3, negProduct4, -temp2_2];
    end
    
    tempH = zeros(3,3);
    B = (A' * A);
    [V, ~] = eig(B);
    tempH = V(:,1);
    tempH = reshape(tempH, [3, 3])';
    H = tempH;
end

