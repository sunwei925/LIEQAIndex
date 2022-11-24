function [color_score] = calculate_colorSimilarity(img1,img2)


img1_hsv = rgb2hsv(img1);
img2_hsv = rgb2hsv(img2);


h1 = img1_hsv(:,:,1);
h2 = img2_hsv(:,:,1);

s1 = img1_hsv(:,:,2);
s2 = img2_hsv(:,:,2);

constForColor = 14/256;


win = fspecial('gaussian',11,2);
win = win/sum(sum(win));
h1 = imfilter(h1,win,'replicate');
s1 = imfilter(s1,win,'replicate');
h2 = imfilter(h2,win,'replicate');
s2 = imfilter(s2,win,'replicate');

hSIM = (2*h1.*h2+constForColor)./(h1.^2+h2.^2+constForColor);
sSIM = (2*s1.*s2+constForColor)./(s1.^2+s2.^2+constForColor);

hsSIM = hSIM.*sSIM;

SIM = h1.*s1;

weight = 1./(SIM+0.05);

color_score = sum(sum(hsSIM(:,:).*weight))/sum(weight(:));


end

