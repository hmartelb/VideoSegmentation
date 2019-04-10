function Q = block_qIndex(img1,img2,blocksize)
    if(nargin < 3)
        blocksize = 8;
    end
    % Convert images to grayscale if they are in RGB 
    if(size(img1,3) == 3) 
        img1 = rgb2gray(img1);
    end
    if(size(img2,3) == 3) 
        img2 = rgb2gray(img2);
    end
    % Check the size of both images
    if (numel(img1) ~= numel(img2))
        return;
    end
    % Get the image size
    [M,N] = size(img1);
    % Allocate the matrix for the Q indexes
    Q_matrix = zeros(floor(M/blocksize),floor(N/blocksize));
    % Iterate for all the blocks
    for i = 1:size(Q_matrix,1)-1
        for j = 1:size(Q_matrix,2)-1
            % Select the same block for both images (img1, img2)
            block1 = img1(i*blocksize:(i+1)*blocksize-1, j*blocksize:(j+1)*blocksize-1);
            block2 = img2(i*blocksize:(i+1)*blocksize-1, j*blocksize:(j+1)*blocksize-1);
            % Compute the Q index for the blocks
            Q_matrix(i,j) = qIndex(block1, block2);
        end
    end
    % Discard the indexes of the non-multiple of blocksize
    Q_matrix(Q_matrix < eps) = [];
    % Get the overall quality index (Computing the mean) 
    Q = mean(Q_matrix(:));
end