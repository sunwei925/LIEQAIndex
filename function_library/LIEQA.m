function[score] = LLEIQA(img1,img2)

% luminance feature: emd
emd_score = calculate_emd(img1,img2);

% edge feature
img1_gray = 0.299*double(img1(:,:,1)) + 0.587*double(img1(:,:,2)) + 0.114*double(img1(:,:,3));
img2_gray = 0.299*double(img2(:,:,1)) + 0.587*double(img2(:,:,2)) + 0.114*double(img2(:,:,3));

img1_edge = edge(img1_gray,'log');
img2_edge = edge(img2_gray,'log');

constForEdge = 0.01;
edgeSIM = (2*img1_edge.*img2_edge+constForEdge)./(img1_edge.^2+img2_edge.^2+constForEdge); % for weight

win = fspecial('gaussian',11,1);
win = win/sum(sum(win));
mu1_edge = imfilter(img1_edge,win,'replicate');
mu_sq1_edge = mu1_edge.*mu1_edge;
sigma1_edge = sqrt(abs(imfilter(img1_edge.*img1_edge,win,'replicate') - mu_sq1_edge));
mu2_edge = imfilter(img2_edge,win,'replicate');
mu_sq2_edge = mu2_edge.*mu2_edge;
sigma2_edge = sqrt(abs(imfilter(img2_edge.*img2_edge,win,'replicate') - mu_sq2_edge));
edge_sigmaSIM = (2*sigma1_edge.*sigma2_edge+constForEdge)./(sigma1_edge.^2+sigma2_edge.^2+constForEdge);
weight = 1./(sigma1_edge+0.1);
% weight = 1;
edge_score = sum(sum(edge_sigmaSIM.*weight))/sum(weight(:));

%over enhancement
win = fspecial('gaussian',11,1);
win = win/sum(sum(win));
mu1 = imfilter(img1_gray,win,'replicate');
mu_sq1 = mu1.*mu1;
sigma1 = sqrt(abs(imfilter(img1_gray.*img1_gray,win,'replicate') - mu_sq1));
mu2 = imfilter(img2_gray,win,'replicate');
mu_sq2 = mu2.*mu2;
sigma2 = sqrt(abs(imfilter(img2_gray.*img2_gray,win,'replicate') - mu_sq2));
constForSigma = 0.01;%fixed
sigmaSIM = (2*sigma1.*sigma2+constForSigma)./(sigma1.^2+sigma2.^2+constForSigma);
weight = 1./(sigma1+0.57);
% weight = 1;
overEnhancement_score = sum(sum(sigmaSIM.*weight))/sum(weight(:));

% color feature
color_score = calculate_colorSimilarity(img1,img2);

% lss score
img1_lss = rgb2gray(img1);
img2_lss = rgb2gray(img2);
 
img1_lss = im2uint8(img1_lss);
img2_lss = im2uint8(img2_lss);

mapDIST = LBP41(img1_lss);
mapPRI = LBP41(img2_lss);

score_lss = sum(sum(mapPRI.*mapDIST))/(sum(sum(mapPRI|mapDIST))+1);

score = emd_score.*edge_score.^3.5*overEnhancement_score.*color_score.*score_lss;

end

function lbp_map = LBP41(img)
% Calculate the LBP statistics using a neighbors number of 4 and a radius of 1
img = double(img);
img = mat2gray(img);

neighborNum = 8;
[M,N] = size(img);
% Coordinate offset of neighbors
% offset = [0 1; -1 0; 0 -1; 1 0;1,1;-1,-1;1,-1;-1,1];
cnt = 1;
for i = -1:1
    for j = -1:1
        if ~(i==0 & j==0)
            offset(cnt,1) = i;
            offset(cnt,2) = j;
            cnt = cnt+1;
        end
    end
end
% Block size
bsize_M = 3;
bsize_N = 3;
% Starting coordinate
orig_m = 2;
orig_n = 2;
% d_m and d_n
d_m = M - bsize_M;
d_n = N - bsize_N;

% Center pixel matrix
Center = img(orig_m:orig_m+d_m,orig_n:orig_n+d_n);
% LBP matrix
LBP = zeros(d_m+1,d_n+1);

% Compute the LBP code matrix
D = cell(neighborNum,1);
for i = 1:neighborNum
    m = offset(i,1) + orig_m;
    n = offset(i,2) + orig_n;
    Neighbor = img(m:m+d_m,n:n+d_n);
    D{i} = Neighbor >= Center;
end

% Accumulate all neighbors
for i = 1:neighborNum
	LBP = LBP + D{i};
end

lbp_map = (LBP == 0) | (LBP == 1) | (LBP == 2) | (LBP == 3)| (LBP == 4)| (LBP == 5)| (LBP == 6);


end


