function [ FD ] = FrameDifference( video, numframes )

%read yuv video
[mov,imgRgb] = readYUV(video ,numframes, 'QCIF_PAL');

numframes = length(mov);

for j = 2:numframes
    I1(:,:,:) = (uint8(mov(j).cdata)); %get the frameA
    I2(:,:,:) = (uint8(mov(j-1).cdata)); %get the frameB
    D(:,:,:) = abs(I1(:,:,:)-I2(:,:,:));   %calculate the distance
    image(uint8(D)); %show the distance image
    FD(j-1) = getframe; %save the distance image in a vector
end

end

