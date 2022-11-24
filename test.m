% read reference
img_ref = imread('images/reference.png');

%read enhancement
img_enh = imread('images/enhancement.png');

addpath(genpath('function_library'));

LIEQA_score = LIEQA(img_ref,img_enh)