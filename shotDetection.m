function [D] = shotDetection(videoName, method, threshold, info, show)
if(nargin < 2)
    error('Some arguments missing! Make sure to specify at least a video file and a method.');
end
if(nargin < 3)
    threshold = 0.4;
end
if(nargin < 4)
    info = false;
end
if(nargin < 5)
    show = false;
end

% Object will read the video
videoObj = VideoReader(videoName);
nFrames   = videoObj.NumberOfFrames;   % Number of frames of video
vidHeight = videoObj.Height;           % Height of the frame
vidWidth  = videoObj.Width;            % Weight of the frame
numPix = vidHeight*vidWidth;

% Play the video
if(show)
    for k = 1:nFrames-1
        frame = read(videoObj,k);
        figure;
        imagesc(frame);
        pause(0.05)
    end
end

% Memory allocation
fig_number = 1;
D = zeros(1,nFrames-1);
bc = zeros(1,nFrames-1);

for t = 1:nFrames-1
    % Get the frames t and t+1
    frameA = double(read(videoObj, t));
    frameB = double(read(videoObj, t+1));
    
    % Methods to calculate D
    switch method
        case 'pixelwise'
            % Compute the square of the difference, the euclidean distance, and normalize
            normrest = ((frameA - frameB)/255).^2;
            eudistance = sqrt(normrest(:,:,1) + normrest(:,:,2) + normrest(:,:,3));
            D(t) = (sum(sum(eudistance)))/numPix;
        case 'sad'
            % Compute the difference between frames and normalize
            absDifference = abs(frameA - frameB);
            D(t) = sum(absDifference(:))/(255*numPix);
        case 'histogram'
            % Get the luminance channel only for both frames
            frameA_bw = double(rgb2gray(frameA));
            frameB_bw = double(rgb2gray(frameB));
            % Compute the normalized histograms
            ha = hist(frameA_bw(:))/numPix;
            hb = hist(frameB_bw(:))/numPix;
            % Compute the Bhattachayya coefficient and distance
            bc(t) = (sum(sqrt(ha.*hb)));
            D(t) = sqrt(1-bc(t));
        case 'Qindex'
            D(t) = 1 - qIndex(frameA,frameB);
        case 'Qindex_block'
            D(t) = 1 - block_qIndex(frameA,frameB);
        case 'mixed'
            % Compute the difference between frames and normalize
            absDifference = abs(frameA - frameB);
            D(t) = sum(absDifference(:))/(255*numPix);
            % Get the luminance channel only for both frames
            frameA_bw = double(rgb2gray(frameA));
            frameB_bw = double(rgb2gray(frameB));
            % Compute the normalized histograms
            ha = hist(frameA_bw(:))/numPix;
            hb = hist(frameB_bw(:))/numPix;
            % Compute the Bhattachayya coefficient and distance
            bc(t) = (sum(sqrt(ha.*hb)));
            %%% Multiply the Absolute Difference and the Histograms %%%
            D(t) = D(t)*0.5 + sqrt(1-bc(t))*0.5;
        otherwise
            error(['method = ' method '. No such method. Please specify a valid one']);
    end
    % Evaluate the result and decide
    if(threshold > 0 && D(t) > threshold)
        % Show information on the command prompt
        if(info)
            msg=sprintf('Shot detected between frames %d and %d', t, t+1);
            fig_number = fig_number+1;
            disp(msg)
        end
        % Plot the frames
        if(show)
            figure(fig_number);
            subplot(2,1,1);
            imagesc(frameA);
            subplot(2,1,2);
            imagesc(frameB);
        end
    end
end

% Adaptative threshold. Set threshold to zero when calling shotDetection.m
if(threshold == 0)
    dist = 30; % Minimum distance between cuts
    delta = 0.01; % Increment for each iteration
    flag = true;
    while(flag || threshold > 1)
        [pk, ploc] = findpeaks(D,'Threshold',threshold);
        threshold = threshold + delta;
        flag = length(pk) > nFrames/dist;
    end
    for n = ploc
        %Show information on the command prompt
        if(info)
            msg=sprintf('Shot detected between frames %d and %d', n, n+1);
            fig_number = fig_number+1;
            disp(msg)
        end
    end
end

% Plot the results of the shot detection for the whole video
figure(fig_number+1); plot(D);
title(['Dissimilarity measures using ' method]);

end