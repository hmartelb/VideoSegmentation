% MAIN
function shotDetectionMain(videoName, adaptative)
    if(nargin < 2)
        adaptative = false;
    end
    fprintf(['\nSHOT DETECTION FOR VIDEO FILE: ' videoName '\n']);
    % List the methods and the thresholds for each
    methods = {'pixelwise','sad','histogram','Qindex', 'Qindex_block','mixed'}; %%% For each new method, modify shotDetection.m %%%
    if(adaptative) 
        thresholds = zeros(1,length(methods)); %%% Adaptative thresholding %%%
    else
        thresholds = [0.4 0.4 0.15 0.75 0.9 0.06]; %%% For each method, specify its threshold %%%
    end
    
    videoObj = VideoReader(videoName);
    nFrames = videoObj.NumberOfFrames;  
    
    % Memory allocation
    D = zeros(length(methods),nFrames-1);
    for i = 1:length(methods)
        % Display information
        fprintf(['\nITERATION ' num2str(i) ':\n- Analyzing ' videoName ' with method [' methods{i} ']. Please wait... \n']);
        % Perform the analysis
        D(i,:) = shotDetection(videoName, methods{i}, thresholds(i), true);
    end
    % Show results
    hold all
    for i=1:length(methods)
        plot(D(i,:));
        title(['Dissimilarity measures using ' videoName]);
    end
    legend(methods)
    
end