noisyRGB= imresize(imread('1234.jpg'), [225 225]);
figure, imshow(noisyRGB)
noisyR = noisyRGB(:,:,1);
noisyG = noisyRGB(:,:,2);
noisyB = noisyRGB(:,:,3);
net = denoisingNetwork('dncnn');
denoisedR = denoiseImage(noisyR, net);
denoisedG= denoiseImage(noisyG,net);
denoisedB = denoiseImage(noisyB,net);
denoisedRGB = cat (3, denoisedR, denoisedG, denoisedB);
figure, imshow(denoisedRGB)
title('DnCNN Image')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
noisyRGB=imresize (imread('1234.jpg'), [225 225]);
noisyR = noisyRGB(:,:,1);
noisyG = noisyRGB(:,:,2);
noisyB = noisyRGB(:,:,3);
y=double(reshape (noisyR, [1,50625]));
t=double(reshape (noisyB, [1,50625]));
p = con2seq(y);
t = con2seq(t);
lrn_net = layrecnet (1,8);
lrn_net.trainFcn = 'trainbr';
lrn_net.trainParam.show = 5;
lrn_net.trainParam.epochs = 50;
lrn_net = train (lrn_net,p,t);
%1rn_net = train(1rn_net,p);
y = lrn_net(p);
figure, plot(cell2mat(y))
v=(cell2mat(y));
h=reshape(v, [225,225]);
figure, imagesc(h) %figure,imshow(h)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Assuming 'h' is the final output image from your previous code
figure, imshow(h, []), title('Output Image')  % Display the final output image

% Step 1: Convert to grayscale (if necessary)
% If 'h' is a color image, you can convert it to grayscale using:
% grayImage = rgb2gray(h);

% Step 2: Apply thresholding to isolate the water body
% Adjust the threshold value (e.g., 100) based on the intensity of water
thresholdValue = 100;  % You may need to experiment with this value
binaryImage = h < thresholdValue;  % Creating a binary mask

% Step 3: Visualize the thresholded binary image
figure, imshow(binaryImage), title('Binary Image (Water Body)')

% Step 4: Calculate the area of the water body (in pixels)
waterBodyPixels = sum(binaryImage(:));

% Step 5: Define the real-world scale (in meters)
% Example: if 1 pixel represents 0.5 meters in the real world
pixelSizeInMeters = 0.5;  % 0.5 meters per pixel

% Calculate the area in square meters
waterBodyAreaSqMeters = waterBodyPixels * (pixelSizeInMeters^2);

% Optionally, you can overlay the binary mask onto the original image for visualization
figure, imshow(h, []), title('Original Image with Water Body Overlay')
hold on
contour(binaryImage, [1 1], 'r', 'LineWidth', 2);  % Red contour around the water body

% Step 6: Display the calculated area in square meters with decimal precision
fprintf('The area of the water body is: %.2f square meters\n', waterBodyAreaSqMeters);

