# LIEQAIndex

Low-light Enhancement Quality Assessment Index

## Description
This is a repository for the model proposed in the paper "[**Perceptual quality assessment of low-light image enhancement**](https://dl.acm.org/doi/abs/10.1145/3457905)". 


## Usage

#### Requirement
MATLAB (tested on MATLAB 2016a, Windows 10)

#### Build emd_mex

Run function_library/emd/build_emd.m


#### LIEQAIndex

```matlab
% read reference
img_ref = imread('images/reference.png');

%read enhancement
img_enh = imread('images/enhancement.png');

addpath(genpath('function_library'));

LIEQA_score = LIEQA(img_ref,img_enh)
```


## Citation


**If you find this code is useful for your research, please cite:**:
```
@article{zhai2021perceptual,
  title={Perceptual quality assessment of low-light image enhancement},
  author={Zhai, Guangtao and Sun, Wei and Min, Xiongkuo and Zhou, Jiantao},
  journal={ACM Transactions on Multimedia Computing, Communications, and Applications (TOMM)},
  volume={17},
  number={4},
  pages={1--24},
  year={2021},
  publisher={ACM New York, NY}
}
```

