function Q = qIndex(img1, img2)
    % Convert images to grayscale if they are in RGB 
    if(size(img1,3) == 3) 
        img1 = rgb2gray(img1);
    end
    if(size(img2,3) == 3) 
        img2 = rgb2gray(img2);
    end
    % Check the size of both images
    if (numel(img1) ~= numel(img2))
        error('ERROR: The image size is not the same.');
    end

    % Convert to double
    img1 = double(img1(:));
    img2 = double(img2(:));
    
    % Compute the mean
    x_mean = mean(img1);
    y_mean = mean(img2);
    
    % Compute the std for x, y and xy
    x_std = std(img1);
    y_std = std(img2);
    xy_std = cov(img1,img2);
    xy_std = xy_std(1,2); %%
    
    % Compute the Quality Index Q from 
    Q = (4*xy_std*x_mean*y_mean)/((x_mean^2 + y_mean^2) * (x_std^2 + y_std^2) + eps);
end