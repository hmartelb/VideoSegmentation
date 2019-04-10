function [] = InterlacedVersion(video, numframes)
%creates a interlaced version

%read yuv video
[mov,imgRgb] = readYUV(video ,numframes, 'QCIF_PAL');
numframes = length(mov);

%filter of videos with pair number of frames
if rem(numframes,2)~=0
    numframes = numframes -1;
end
i = 1;
%take the number of the pixels by column, row and components
[m, n, d] = size(uint8(mov(1).cdata));
%create a matrix of zeros
If = uint8(zeros(m,n,3));
for j = 1:2:numframes
   I1(:,:,:) = (uint8(mov(j).cdata)); %get the frameA
   I2(:,:,:) = (uint8(mov(j+1).cdata)); %get the frameB
   for l = 1:2:m
       If(l, :, 1) = I1(l, :, 1); %set the odd frames
       If(l, :, 2) = I1(l, :, 2);   
       If(l, :, 3) = I1(l, :, 3);
       if l~=m
           If(l+1, :, 1) = I2(l+1, :, 1); %set the pair frames
           If(l+1, :, 2) = I2(l+1, :, 2);  
           If(l+1, :, 3) = I2(l+1, :, 3);
       end
   end
   image(If);
   F(i) = getframe;
   i = i +1; 
end
end

