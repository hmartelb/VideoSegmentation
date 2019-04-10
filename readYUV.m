function [yuvMovie, YUV] = readYUV(filename, numOfFrames, fileFormat)
%
% readYUV: Reads from a YUV format video sequence
%    READYUV(FILENAME, NUMOFFRAMES, FILEFORMAT) Reads information from 
%    a YUV video sequence: FILENAME and returns a MATLAB movie structure 
%    array: YUVMOVIE and an array of YUV frames with size equal to number of 
%    frames.
%    The default resolution for this function is 
%       NTSC:       Y: 720 x 480 ; U,V: 360 x 240
%                   with 4:2:0 chroma subsampling
%
%    The user can change the default resolution by passing the file format 
%    to the function.  Supported File Format Standards are:
%       NTSC:       Y: 720 x 480 ; U,V: 360 x 240
%       PAL:        Y: 720 x 576 ; U,V: 320 x 288    
%       MPEGYUV     Y: 704 x 480 ; U,V: 352 x 240
%       CIF_NTSC:   Y: 352 x 240 ; U,V: 176 x 120
%       CIF_PAL:    Y: 352 x 288 ; U,V: 176 x 144
%       QCIF_NTSC:  Y: 176 x 120 ; U,V:  88 x  60
%       QCIF_PAL:   Y: 176 x 144 ; U,V:  88 x  72
%
%    The file is opened for reading (FOPEN).  
%    For each NUMOFRAMES, the luminance (Y) component is 
%    read (using FREAD), followed by the two subsampled 
%    chrominance (U, V) components.
%    
%    Each Y,U,V component is transposed (') once it has been read.
%    The Chrominance frames are sampled-up to display in MATLAB.
%    A YCbCr Image with size cols x rows x 3 is constructed and converted
%    to RGB format (YCBCR2RGB).
%    The RGB image is converted to movie frame format using IM2FRAME,
%    and stored in a movie structure array, yuvMOVIE.

%   Modifications:
%
%   1-16-06     Changed indexing variable for up-sampling from 'i' and 'j'
%               to 'm' and 'n', because i and j are internal variables to
%               MATLAB and could possibly conflict with other operations.
%
%               The default value of fileFormat was added as an explicit
%               parameter as well (for completeness)
%                   -Jeremy Jacob
%
%   1-22-06     Added error checking to make sure specified number of
%               frames are actually available.  If not, it will seek the
%               file to determine the max number of frames based on the
%               users format selection.
%
%   2-6-06      The YUV variable was preallocated based on the number of
%               frames the use specified, and NOT based on the max number
%               of frames available in the file.  This has been fixed.  
%               Also, a wait bar has been added.


if (nargin == 2)                                   % default NTSC format resolution for 
    rows = 480;                                    % (Y) color component
    cols = 720; 
else 
    if     (isequal(fileFormat,'NTSC'))                %NTSC resolution
        rows = 480;
        cols = 720;
    elseif (isequal(fileFormat,'PAL'))                 % PAL resolution
        rows = 576;
        cols = 720; 
    elseif (isequal(fileFormat,'MPEGYUV'))
        rows = 480;
        cols = 704;
    elseif (isequal(fileFormat,'CIF_NTSC'))            % CIF (NTSC) resolution
        rows = 240;
        cols = 352;    
    elseif (isequal(fileFormat,'CIF_PAL'))             % CIF (PAL) resolution
        rows = 288;
        cols = 352;    
    elseif (isequal(fileFormat,'QCIF_NTSC'))           % QCIF (NTSC) resolution
        rows = 120;
        cols = 176;
    elseif (isequal(fileFormat,'QCIF_PAL'))            % QCIF (PAL) resolution
        rows = 144;
        cols = 176;  
    else
        'Invalid File Format'
    end
end

fid = fopen(filename, 'r');                         % open the file with read permission

%//BEGIN ERROR CHECKING
lastchar = (rows * cols * numOfFrames) + ...        % calculate last character based on input
    2 * ((rows/2) * (cols/2) * numOfFrames);

h = waitbar(0,'Validating number of frames');

if fseek(fid, lastchar, 'bof') == -1                % is this location within the file
    % User specified too many frames
    % Determine the minimum number of frames
    found = 0;          %when max num of frames is found
    k = 1;              %counter
    max_frames = 0;     %max num of frames
    while found == 0
        % seek frame by frame until we are out of file boundary
        waitbar(k/numOfFrames)
        cur_char = (rows * cols * k) + ...
            2 * ((rows/2) * (cols/2) * k);
        if fseek(fid, cur_char, 'bof') == -1
            found = 1;
            max_frames = k - 1;
        else
            k = k + 1;
        end
    end
    if max_frames == 0
        %There are no frames available.  Error to user
        msgbox(['You specified too many frames, but ', ...
            'there are no frames available based on ', ...
            'your file format selection', ...
            'Too many frames specified', ...
            'error']);
        return
    else
        %notify user of num of frames that will be loaded
        msgbox(['You specified too many frames. Loading ', ...
            num2str(max_frames), ' frames.'], ...
            'Too many frames specified', ...
            'warn');
        numOfFrames = max_frames;
    end
end
delete(h)
fseek(fid, 0, 'bof');   %seek back to begining of file
%//END ERROR CHECKING

YUV = zeros(rows, cols, 3, numOfFrames, 'uint8');            % preallocate arrays
uu = zeros(rows, cols, 'uint8');
vv = zeros(rows, cols, 'uint8');

h = waitbar(0,'Loading');

for index=1:numOfFrames                            % loop for number of frames
    waitbar(index/numOfFrames, h, ['Loading frame ', num2str(index), ...
        ' of ', num2str(numOfFrames)])
    
    y = fread(fid,[cols,rows],'uchar');            % luminance
    y = y';                                        % transpose the luminance matrix
    
    u = fread(fid,[cols/2,rows/2],'uchar');        % chrominance
    u = u';                                        % transpose the chrominance matrix
    
    v = fread(fid,[cols/2,rows/2],'uchar');        % chrominance
    v = v';                                         % transpose the chrominance matrix
    
    for m=1:rows/2
        for n=1:cols/2                             % loop for chrominance dimensions
            uu(m*2-1:m*2,n*2-1:n*2) = u(m,n);      % upsample
            vv(m*2-1:m*2,n*2-1:n*2) = v(m,n);
        end
    end
    YUV(:,:,1,index) = y;                          % construct one YUV Image
    YUV(:,:,2,index) = uu;      
    YUV(:,:,3,index) = vv;
    
    rgbImage = ycbcr2rgb(uint8(YUV(:,:,:,index))); % convert YCbCr to RGB
    yuvMovie(index) = im2frame(rgbImage);          % Convert RGB image to movie frame, store
                                                   % in the movie structure array yuvMovie
end
delete(h)
fclose(fid);                                             