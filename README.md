# Blind Watermarking
Digital image watermarking could be described as a method for embedding information (or an image) into another image. The embedded information could be either visible or hidden from the user. This repository presents a secure and invisible watermark embedding method based on discrete cosine transform.

## Embedding
The algorithm works by converting the original RGB image to YCbCr color space and then extracting its Y-channel which would be used to embed the watermark. To achieve a secure embedding, a pseudo random sequence is generated using a security key. This PN sequence is then used to permute the Y-channel. The permuted frame is broken into 8x8 non-overlapping blocks and DCT is applied to each block. From these DCT blocks, 1024 random block are used to embed the watermark pixels with the watermarking strength of 0.1. Then IDCT is applied to each block and the blocks are combined to form the original dimensions. Finally, permutation is removed and the individual channels are combined to form RGB watermarked image.
<p align=center margin=10px>
  <img src="https://github.com/rimshasaeed/Blind-Watermarking/blob/main/results/embedding.jpg" width=70%/>
</p>

## Extraction
The extraction algorithm works in a similar way by extracting the Y-channel, applying DCT to 8x8 blocks and computing the difference at the pixel location where the watermark has been embedded. Negative difference corresponds to foreground pixels and positive difference corresponds to background pixel of the watermark.  
<p align=center margin=10px>
  <img src="https://github.com/rimshasaeed/Blind-Watermarking/blob/main/results/extraction.jpg" width=60%/>
</p>
