clc, clearvars, close all

% Input parameters
img = im2double(imread('lena.jpg'));
watermark = im2double(imread('watermark.bmp'));
key = 394;

% Watermark embedding and extraction
y = embed(img, watermark, key);
W = extract(img, y, key);

% Evaluation metrics
MSE = immse(y, img);
PSNR = psnr(y, img);

% Display results
figure;
sgtitle('Watermark Embedding')
subplot(1,3,1), imshow(img), title('Original image')
subplot(1,3,2), imshow(watermark,[]), title('Watermark')
subplot(1,3,3), imshow(y), title({['Watermarked image'], ...
                                  ['PSNR: ', num2str(PSNR, '%.2f'), ' dB'],...
                                  ['MSE: ', num2str(MSE, '%.5f')]})
figure;
sgtitle('Watermark Extraction')
subplot(1,2,1), imshow(y), title('Watermarked image')
subplot(1,2,2), imshow(W), title('Extracted watermark')
