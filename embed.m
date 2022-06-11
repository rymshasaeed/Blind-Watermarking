function y = embed(x, watermark, key)
% Blind watermarking algorithm using Discrete Cosine Transform
% ARGUMENTS
%           x: Original image to be watermarked
%           watermark: Watermark image
%           key: Key (any positve integer) for PN sequence generator
% RETURNS
%           y: Watermarked image

% Convert image to YCbCr color space
x_YCbCr = rgb2ycbcr(x);

% Extract idividual channels
Y = x_YCbCr(:,:,1);
Cb = x_YCbCr(:,:,2);
Cr = x_YCbCr(:,:,3);

% Generate PN sequence for permutation
rng(key);
PN = randi([0 1],size(Y,1));

% Permutation
I = zeros(size(Y));
for i = 1:size(Y,1)
    for j = 1:size(Y,2)
        if PN(i,j) == 1
            I(i,j) = PN(i,j)*Y(j,i) + imcomplement(PN(i,j))*Y(i,j);
        else
            I(i,j) = Y(i,j);
        end
    end
end

% Resize the watermark, convert it to binary and finally, reshape to a vector
if size(watermark) ~= [32, 32]
    watermark = imresize(watermark, [32, 32]);
end
watermark = imbinarize(watermark);
W_vec = reshape(watermark, 1, numel(watermark));

% Transform Y-channel to 8x8 blocks and apply DCT
r = 1;
c = 1;
b_size = 8;
num_blocks = size(Y,1)*b_size;
for k = 1:num_blocks
    blocks{k} = dct2(I(c:c+b_size-1, r:r+b_size-1));
    % Update blocks
    if r + b_size >= size(Y, 2)
        r = 1;
        c = c + b_size;
    else
        r = r + b_size;
    end
end

% Select a 1024-element random blocks to embed the watermark
rng(key);
n = randperm(numel(blocks),numel(W_vec));

% Embedding stage
alpha = 0.1;
for k = 1 : numel(watermark)
    if W_vec(k) == 0
        blocks{n(k)}(4,2) = blocks{n(k)}(4,2) - alpha;
    else
        blocks{n(k)}(4,2) = blocks{n(k)}(4,2) + alpha;
    end
end

% Combine the blocks back to original dimensions and apply IDCT
r = 1;
c = 1;
for k = 1 : numel(blocks)    
    Y_watermarked(c:c+b_size-1, r:r+b_size-1) = idct2(blocks{k});
    
    % Update blocks
    if r + b_size >= size(Y, 2)
        r = 1;
        c = c + b_size;
    else
        r = r + b_size;
    end
end

% Remove permutation
I = zeros(size(Y));
for i = 1:size(Y,1)
    for j = 1:size(Y,2)
        if PN(i,j) == 1
            I(i,j) = PN(i,j)*Y(i,j) + imcomplement(PN(i,j))*Y_watermarked(i,j);
        else
            I(i,j) = Y_watermarked(i,j);
        end
    end
end

% Combine the channels and convert back to RGB map
y = cat(3, I, Cb, Cr);
y = ycbcr2rgb(y);

end