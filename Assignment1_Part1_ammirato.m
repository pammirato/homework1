mos = imread('./crayons_mosaic.bmp');
original = imread('./crayons.jpg');

green_info = mos;
green_info(1:2:end,1:2:end) = 0;
green_info(2:2:end,2:2:end) = 0;

red_info = mos - green_info;
red_info(2:2:end,2:2:end) = 0;

blue_info = mos - green_info;
blue_info(1:2:end,1:2:end) = 0;

red_blue_filter = [.25 .5 .25; .5 1 .5; .25 .5 .25];
green_filter = [0 .25 0; .25 1 .25; 0 .25 0];

r = imfilter(red_info, red_blue_filter);
b = imfilter(blue_info, red_blue_filter);
g = imfilter(green_info, green_filter);

computed_img = zeros(size(r,1),size(r,2),3);
computed_img(:,:,1) = r;
computed_img(:,:,2) = g;
computed_img(:,:,3) = b;
computed_img = uint8(computed_img);

%show the computed image
imshow(computed_img);
figure, imshow(original);


diff_img = original - computed_img;
mean_diff = mean2(diff_img);
max_diff = max(max(max(diff_img)));

ssd_img = diff_img.^2;

single_ssd = ssd_img(:,:,1) + ssd_img(:,:,2) + ssd_img(:,:,3);

figure, imagesc(single_ssd);







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Part 2


d =dir('./data/');
d = d(3:end);

for i=1:length(d)
    img = imread(['./data/' d(i).name]);
    
    height = floor(size(img,1)/3);
    
    img1 = img(1:height,:);
    img2 = img(height+1:2*height,:);
    img3 = img(2*height +1:end,:);
    
    rows1 = floor(size(img1,1)/3);
    cols1 = floor(size(img1,2)/3);
    
    rows2 = floor(size(img2,1)/3);
    cols2 = floor(size(img2,2)/3);
    
    
    rect1 = [rows1, cols1, rows1, cols1];
    rect3 = [rows1-15, cols1-15, rows1+30, cols1+30];
    
    
    patch1 = imcrop(img1,rect1);
    patch2 = imcrop(img2,rect1);
    patch3 = imcrop(img3,rect3);
    %patch1 = img1(rows1:end-rows1,cols1:end-cols1);
    %patch2 = img2(rows1:end-rows1,cols1:end-cols1);
    %patch3 = img3(rows1-15:end-rows1+15,cols1-15:end-cols1+15);
    
    
    
    
    
    c1 = normxcorr2(patch1,patch3);
    [max_c1, imax] = max(abs(c1(:)));
    [ypeak, xpeak] = ind2sub(size(c1),imax(1));
    corr_offset = [ (ypeak-size(patch1,1)) (xpeak-size(patch1,2)) ];
    
    
    % relative offset of position of subimages
    rect_offset = [(rect3(1)-rect1(1))
               (rect3(2)-rect1(2))];
           
    % total offset
    offset1 = corr_offset + rect_offset';
    xoffset1 = offset1(1);
    yoffset1 = offset1(2);

    xbegin1 = round(xoffset1+1);
    xend1   = round(xoffset1+ size(patch1,2));
    ybegin1 = round(yoffset1+1);
    yend1  = round(yoffset1+size(patch1,1));
    
    
    
    
    
    
    
    c2 = normxcorr2(patch2,patch3);
    [max_c2, imax] = max(abs(c2(:)));
    [ypeak, xpeak] = ind2sub(size(c2),imax(1));
    corr_offset2 = [ (ypeak-size(patch2,1)) (xpeak-size(patch2,2)) ];
    
           
    % total offset
    offset2 = corr_offset2 + rect_offset';
    xoffset2 = offset2(1);
    yoffset2 = offset2(2);
    
    
    
    xbegin2 = round(xoffset2+1);
    xend2   = round(xoffset2+ size(patch2,2));
    ybegin2 = round(yoffset2+1);
    yend2  = round(yoffset2+size(patch2,1));
    
    
    
    
    
    
    %final_img = zeros(size(img3,1), size(img3,2),3);
    %final_img(:,:,1) = img3;
    %final_img(1:end-1,1:end-10,1) = img1(:,10:end);
    %final_img(3:end,1:end-4,2) = img2(1:end-1,4:end);
    
    
    
    %final_img(abs(ybegin2):yend2,ans(xbegin2):xend2,2) = img2;%img2(abs(yoffset2):end,abs(xoffset2):end);
    %final_img(abs(ybegin1):yend1,abs(xbegin1):xend1,2) = img1;%img1(abs(yoffset1):end,abs(xoffset1):end);
    final_img = uint8(final_img);
    
    
    imshow(final_img);
    
    
    
end
