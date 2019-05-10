clear;close all;clc;
% for i=1:19
%   RGB = imread(['images/' 'castle' num2str(i) '.jpg']);
  RGB = imread(['images/' 'castle' num2str(17) '.jpg']);

%convert frame from RGB to YCBCR colorspace
YCBCR = rgb2ycbcr(RGB);  
%filter YCBCR image between values and store filtered image to threshold  

%the green value in ycbcr
Y_MIN = 30;  Y_MAX = 160;  
Cb_MIN = 53;   Cb_MAX = 128;  
Cr_MIN = 34;   Cr_MAX = 128;  
threshold=roicolor(YCBCR(:,:,1),Y_MIN,Y_MAX)&roicolor(YCBCR(:,:,2),Cb_MIN,Cb_MAX)&roicolor(YCBCR(:,:,3),Cr_MIN,Cr_MAX);  


%reference:https://blog.csdn.net/whuhan2013/article/details/53956606
%perform morphological operations on thresholded image to eliminate noise 
%and emphasize the filtered object
erodeElement = strel('square', 3) ;  
dilateElement= strel('square', 12) ;  
threshold = imerode(threshold,erodeElement);  
threshold = imerode(threshold,erodeElement);  
threshold=imdilate(threshold, dilateElement);  
threshold=imdilate(threshold, dilateElement); 
threshold=imfill(threshold,'holes');  
  

%get the  of basic property:'Area', 'Centroid', and 'BoundingBox'
stats = regionprops(threshold, 'basic');  
[C,area_index]=max([stats.Area]);   
face_locate=[stats(area_index).Centroid(1),stats(area_index).Centroid(2)];  

I = imcrop(RGB,[face_locate(1)-600,face_locate(2)-400,1000,800]);% Clipping target box
I1 = rgb2hsv(I); % transform RGB to HSV
h = I1(:, :, 2); % S
bw = im2bw(h, graythresh(h)); % threshing
bw=imfill(bw,'holes');  
erodeElement = strel('square', 3) ;  
dilateElement=strel('square', 5) ;  
bw = imerode(bw,erodeElement);  
bw = imerode(bw,erodeElement);
bw=imdilate(bw, dilateElement);  
bw=imdilate(bw, dilateElement);  
bw1=imfill(bw,'holes');  

bw1 = bwareaopen(bw1, 8000); % Filter collection with more than 8000 pixels
bw2 = cat(3, bw1, bw1, bw1); % medol
I1 = I .* uint8(bw2); 

I2=RGB;
for i= 1:size(I2,1)
	for j=1:size(I2,2)
        if ~(j > face_locate(1)-600 && j< face_locate(1)-600+1000 && i>face_locate(2)-400 &&i<face_locate(2)-400+800)
            I2(i,j,1) = 0;
            I2(i,j,2) = 0;
            I2(i,j,3) = 0;
        else
                I2(i,j,:)=I1(i-floor(face_locate(2)-400),j-floor(face_locate(1)-600),:);      
        end
    end
end

figure;
imshow(I2); title('foreground tractor');

% end