function ln=localnormalize(IM)
%LOCALNORMALIZE A local normalization algorithm that uniformizes the local
%mean and variance of an image.
%  ln=localnormalize(IM,sigma1,sigma2) outputs local normalization effect of 
%  image IM using local mean and standard deviation estimated by Gaussian
%  kernel with sigma1 and sigma2 respectively.
%
%  Contributed by Guanglei Xiong (xgl99@mails.tsinghua.edu.cn)
%  at Tsinghua University, Beijing, China.

gaussian1=fspecial('gaussian',11,2);
gaussian2=fspecial('gaussian',11,2);
num=IM-imfilter(IM,gaussian1);
den=sqrt(imfilter(num.^2,gaussian2));
ln=num./den;
end