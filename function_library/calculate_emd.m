function [emd_score] = calculate_emd(img1,img2)

img1_hsv = rgb2hsv(img1);
img2_hsv = rgb2hsv(img2);

v1 = img1_hsv(:,:,3);
v2 = img2_hsv(:,:,3);

v1 = localnormalize(v1);
v2 = localnormalize(v2);

v1 = mapminmax(v1,0,1);
v2 = mapminmax(v2,0,1);

v1 = im2uint8(v1);
v2 = im2uint8(v2);

C=zeros(256,256);
for i=1:256
    for j=1:256
        C(i,j)=abs(i-j);
    end
end

[with, height, ~] = size(v1);

img_black = zeros(with,height); 
img_black = im2uint8(img_black);

P=histc(v1(:)',0:255);
Q=histc(v2(:)',0:255);
black = histc(img_black(:)',0:255);

w1=P/(with*height);
w2=Q/(with*height);
w_black = black/(with*height);
% 
[emd1,~]=emd_mex(w1,w2,C);
[emd2,~]=emd_mex(w1,w_black,C);

emd = emd1/emd2;

emd_score = exp(-2.2*emd);

end

