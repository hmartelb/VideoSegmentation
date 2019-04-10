# VideoSegmentation
## Introduction

Temporal video segmentation is the first step towards automatic annotation of digital video for browsing and retrieval. In this repository we will present the MATLAB implementation of existing shot detection algorithms and propose an alternative way to perform it.

## Problem definition

Temporal segmentation of a video, also called **shot detection**, consists of **dividing the video** into several parts according to the changes of shot. It is important to distinguish between the concepts of scene and shot, as they may be confusing. 
- A **scene** is defined as a continuous sequence that is temporally and spatially coherent in the real world, but it does not necessarily mean cohesion in the projection of the film.
- A **shot** refers to the longest continuous sequence that originates from a single camera recording with no cuts. Therefore, several shots make up a scene.


The temporal segmentation problem can be divided into two stages, which are **scoring** and **thresholding**. 
- **Scoring** refers to performing an analysis between two consecutive frames and assigning a number to it. 
- **Thresholding** is the decision part in which these numbers are evaluated to determine if there is a change in shot.

### Scoring Algorithms

All the methods below cover the scoring part of the problem. This means that either fixed or adaptive thresholding must be applied afterwards to in order to make the decision.


- **Pixelwise comparison (PC)**

Computes the difference between the value of the pixels at the same spatial location and channel for two consecutive frames. The mean of all pixels in the frame is returned as the score, so that this measure is similar to the Mean Squared Error (MSE). 


- **Sum of Absolute Differences (SAD)**

Computes the difference between the value of the pixels at the same spatial location and channel for two consecutive frames. The cummulative of all pixels in the frame is returned as the score.


- **Histogram Differences (HD)**

Computes the difference between the per-channel luminance distributions of the pixels in the frame and, thus, does not take spatial information into account. A normalized version of the [Bhattacharyya distance](https://en.wikipedia.org/wiki/Bhattacharyya_distance) is returned as the score. 


- **Qindex**

Method proposed in [this paper](http://ieeexplore.ieee.org/xpl/articleDetails.jsp?tp=&arnumber=995823) to compare two images. The authors originally proposed this method to compute the image quality for compression purposes, as an alternative to the Mean Squared Error (MSE) arguing that it is more robust. As it can also be considered a distance, here the Qindex is used at a frame level to measure the differences between two consecutive ones.

### Thresholding

- **Fixed threshold**: Comparison of the score value with a fixed threshold selected by hand. 
- **Adaptive threshold**: Comparison of the score value with a threshold that is selected relatively to the past history of scores.

## Further reading
A detailed explanation of the algorithms and the results obtained can be found in the docs. Please refer to the following PDF file:

[Temporal Segmentation for Video Processing using MATLAB](docs/article.pdf)

## License

This project is licensed under the MIT License.
```
MIT License

Copyright (c) 2016 
Héctor Martel, Pau Rotger, Manuel Ruiz

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
