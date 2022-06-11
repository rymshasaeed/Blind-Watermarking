function watermark = extract(x, y, key)
% Blind watermarking algorithm using Discrete Cosine Transform
% ARGUMENTS
%           x: Original image
%           y: Watermarked image
%           key: Key (any positve integer) to decode PN sequence
% RETURNS
%           y: Original image without watermark
%           y: Extracted watermark

% Convert the images to YCbCr color space
x_YCbCr = rgb2ycbcr(x);
y_YCbCr = rgb2ycbcr(y);

% Extract Y-channel
x_Y = x_YCbCr(:,:,1);
y_Y = y_YCbCr(:,:,1);

% Transform Y-channel to 8x8 blocks and apply DCT
r = 1;
c = 1;
block_size = 8;
num_blocks = size(x_Y,1)*block_size;
for k = 1:num_blocks
    x_blocks{k} = dct2(x_Y(c:c+block_size-1, r:r+block_size-1));
    y_blocks{k} = dct2(y_Y(c:c+block_size-1, r:r+block_size-1));

    % Update blocks
    if r + block_size >= size(x_Y, 2)
        r = 1;
        c = c + block_size;
    else
        r = r + block_size;
    end
end

% Get 1024 watermarked blocks
rng(key);
n = randperm(numel(x_blocks), 1024);

% Extraction stage
for k = 1 : 1024
    diff(k) = y_blocks{n(k)}(4,2) - x_blocks{n(k)}(4,2);
    if diff(k) < 0
        watermark(k) = 0;
    elseif diff(k) > 0
        watermark(k) = 1;
    end
end

% Convert to original dimensions
watermark = reshape(watermark, 32, 32);

end