%% 0. Підготовка
clear; close all; clc;

%% 1. Завантаження кількох зображень з бібліотеки MATLAB у різних форматах та їх відображення
I1 = imread('trees.tif');
I2 = imread('onion.png');
I3 = imread('trailer.jpg');

figure;
subplot(1,3,1), imshow(I1), title('trees.tif');
subplot(1,3,2), imshow(I2), title('onion.png');
subplot(1,3,3), imshow(I3), title('trailer.jpg');

%% 2. Завантаження зображення з каталогу і його відображення
imagePath = 'images/sad_cat.jpg';
I_custom = imread(imagePath);

figure;
imshow(I_custom);
title('Sad Cat');

%% 3. Інформація про завантажені зображення
info1 = imfinfo('trees.tif');
info2 = imfinfo('onion.png');
info3 = imfinfo('trailer.jpg');
info4 = imfinfo('images/sad_cat.jpg');

disp('Info - trees.tif:'); disp(info1);
disp('Info - onion.png:'); disp(info2);
disp('Info - trailer.jpg:'); disp(info3);
disp('Info - sad_cat.jpg:'); disp(info4);

size_I1 = size(I1);
class_I1 = class(I1);
disp(['Розмір trees.tif: ', num2str(size_I1)]);
disp(['Тип даних trees.tif: ', class_I1]);

size_I2 = size(I2);
class_I2 = class(I2);
disp(['Розмір onion.png: ', num2str(size_I2)]);
disp(['Тип даних onion.png: ', class_I2]);

size_I3 = size(I3);
class_I3 = class(I3);
disp(['Розмір trailer.jpg: ', num2str(size_I3)]);
disp(['Тип даних trailer.jpg: ', class_I3]);

size_I4 = size(I_custom);
class_I4 = class(I_custom);
disp(['Розмір sad_cat.jpg: ', num2str(size_I4)]);
disp(['Тип даних sad_cat.jpg: ', class_I4]);

%% 4. Збереження завантажених зображень
imwrite(I1, 'images/trees_saved.tif');
imwrite(I2, 'images/onion_saved.png');
imwrite(I3, 'images/trailer_saved.jpg');

%% 5. Побудова гістограм для зображень imhist(I)
figure;
imhist(I1);
title("Гістограма trees.tif");

figure;
imhist(I2);
title("Гістограма onion.jpg");

figure;
imhist(I3);
title("Гістограма trailer.png");

figure;
imhist(I_custom);
title("Гістограма sad_cat.jpg");

%% 6-7. Контрастування зображень (imadjust)
% Для сірого зображення I1 (trees.tif)
I1_adjusted = imadjust(I1);
figure;
subplot(1,2,1), imshow(I1), title('Оригінал trees.tif');
subplot(1,2,2), imshow(I1_adjusted), title('Контрастоване trees.tif (imadjust)');

% Для кольорового зображення I2 (onion.png)
R = I2(:,:,1);
G = I2(:,:,2);
B = I2(:,:,3);
R_adjusted = imadjust(R);
G_adjusted = imadjust(G);
B_adjusted = imadjust(B);
I2_adjusted = cat(3, R_adjusted, G_adjusted, B_adjusted);
figure;
subplot(1,2,1), imshow(I2), title('Оригінал onion.png');
subplot(1,2,2), imshow(I2_adjusted), title('Контрастоване onion.png (imadjust)');

% Для кольорового зображення I3 (trailer.jpg)
R = I3(:,:,1);
G = I3(:,:,2);
B = I3(:,:,3);
R_adjusted = imadjust(R);
G_adjusted = imadjust(G);
B_adjusted = imadjust(B);
I3_adjusted = cat(3, R_adjusted, G_adjusted, B_adjusted);
figure;
subplot(1,2,1), imshow(I3), title('Оригінал trailer.jpg');
subplot(1,2,2), imshow(I3_adjusted), title('Контрастоване trailer.jpg (imadjust)');

% Для кольорового зображення I_custom (sad_cat.jpg)
R = I_custom(:,:,1);
G = I_custom(:,:,2);
B = I_custom(:,:,3);
R_adjusted = imadjust(R);
G_adjusted = imadjust(G);
B_adjusted = imadjust(B);
I_custom_adjusted = cat(3, R_adjusted, G_adjusted, B_adjusted);
figure;
subplot(1,2,1), imshow(I_custom), title('Оригінал sad_cat.jpg');
subplot(1,2,2), imshow(I_custom_adjusted), title('Контрастоване sad_cat.jpg (imadjust)');

%% 8. Негативи зображень
I1_negative = imcomplement(I1);
I2_negative = imcomplement(I2);
I3_negative = imcomplement(I3);
I_custom_negative = imcomplement(I_custom);

figure;
subplot(1,2,1), imshow(I1), title('Оригінал trees.tif');
subplot(1,2,2), imshow(I1_negative), title('Негатив trees.tif');

figure;
subplot(1,2,1), imshow(I2), title('Оригінал onion.png');
subplot(1,2,2), imshow(I2_negative), title('Негатив onion.png');

figure;
subplot(1,2,1), imshow(I3), title('Оригінал trailer.jpg');
subplot(1,2,2), imshow(I3_negative), title('Негатив trailer.jpg');

figure;
subplot(1,2,1), imshow(I_custom), title('Оригінал sad_cat.jpg');
subplot(1,2,2), imshow(I_custom_negative), title('Негатив sad_cat.jpg');

%% 9. Приклади використання параметрів imadjust
help imadjust  % Відображення довідки у Command Window

% Розділяємо зображення I_custom на канали
R = I_custom(:,:,1);
G = I_custom(:,:,2);
B = I_custom(:,:,3);

%% Приклад 1: Сильне розтягнення контрасту
R_adj1 = imadjust(R, [0.2 0.8], [0 1]);
G_adj1 = imadjust(G, [0.2 0.8], [0 1]);
B_adj1 = imadjust(B, [0.2 0.8], [0 1]);
cat_adj1 = cat(3, R_adj1, G_adj1, B_adj1);

%% Приклад 2: Менше розтягнення контрасту
R_adj2 = imadjust(R, [0.3 0.7], [0 1]);
G_adj2 = imadjust(G, [0.3 0.7], [0 1]);
B_adj2 = imadjust(B, [0.3 0.7], [0 1]);
cat_adj2 = cat(3, R_adj2, G_adj2, B_adj2);

%% Приклад 3: Інверсія зображення
R_adj3 = imadjust(R, [0 1], [1 0]);
G_adj3 = imadjust(G, [0 1], [1 0]);
B_adj3 = imadjust(B, [0 1], [1 0]);
cat_adj3 = cat(3, R_adj3, G_adj3, B_adj3);

figure;
subplot(2,2,1), imshow(I_custom), title('Оригінал sad\_cat.jpg');
subplot(2,2,2), imshow(cat_adj1), title('[0.2, 0.8] -> [0, 1]');
subplot(2,2,3), imshow(cat_adj2), title('[0.3, 0.7] -> [0, 1]');
subplot(2,2,4), imshow(cat_adj3), title('Інверсія: [0, 1] -> [1, 0]');
