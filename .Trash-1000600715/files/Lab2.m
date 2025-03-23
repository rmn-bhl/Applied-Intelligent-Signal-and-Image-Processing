%% 0. Підготовка середовища
clear; close all; clc;

% У цьому прикладі використовуємо 2 зображення з бібліотеки MATLAB:
% 1) cameraman.tif (сіре)
% 2) peppers.png (кольорове)

I1 = imread('cameraman.tif');  % Сіре зображення
I2 = imread('peppers.png');    % Кольорове зображення

%% 1-2. Відображення вихідних зображень
figure('Name','Original Images');
subplot(1,2,1), imshow(I1), title('Original Cameraman');
subplot(1,2,2), imshow(I2), title('Original Peppers');

% Пояснення:
% "cameraman" — сіре (1 канал),
% "peppers" — кольорове (3 канали: R,G,B).

%% 3. Зашумлення зображення нормальним білим шумом і "сіль та перець"
% Налаштовуємо різні рівні шуму, щоб побачити відмінності.
% Gaussian: середнє=0, дисперсія=0.01 (для cameraman), 0.05 (для peppers).
% Salt & pepper: ймовірність шуму 0.02 (для cameraman), 0.05 (для peppers).

I1_gauss = imnoise(I1, 'gaussian', 0, 0.01);
I1_sp    = imnoise(I1, 'salt & pepper', 0.02);
I2_gauss = imnoise(I2, 'gaussian', 0, 0.05);
I2_sp    = imnoise(I2, 'salt & pepper', 0.05);

%% 4. Відображення зашумлених зображень
figure('Name','Noisy Images - Cameraman');
subplot(1,2,1), imshow(I1_gauss), title('Cameraman + Gaussian Noise');
subplot(1,2,2), imshow(I1_sp),    title('Cameraman + Salt & Pepper Noise');

figure('Name','Noisy Images - Peppers');
subplot(1,2,1), imshow(I2_gauss), title('Peppers + Gaussian Noise');
subplot(1,2,2), imshow(I2_sp),    title('Peppers + Salt & Pepper Noise');

% Пояснення:
% Gaussian noise (нормальний білий шум) розподіляється за гаусівською кривою.
% Salt & pepper (імпульсний шум) випадково задає яскраво-білі та чорні точки.

%% 5-6. Фільтрація зашумлених зображень лінійними фільтрами
% Створимо декілька лінійних фільтрів:
%  - Усереднювальний (average) — низькочастотний
%  - Гаусівський (gaussian) — також низькочастотний, але з гаусівською вагою
%  - Unsharp — фільтр підвищення різкості (фактично високочастотний)

h_avg    = fspecial('average', [3 3]);      % 3x3 усереднювальний фільтр
h_gauss  = fspecial('gaussian', [3 3], 0.5);% 3x3 гаусівський фільтр, sigma=0.5
h_unsharp= fspecial('unsharp');             % фільтр для підсилення різкості

% Застосуємо кожен фільтр до зашумлених зображень

% --- Cameraman (сіре) ---
% Gaussian noise
cam_gauss_avg    = imfilter(I1_gauss, h_avg);
cam_gauss_gauss  = imfilter(I1_gauss, h_gauss);
cam_gauss_unsharp= imfilter(I1_gauss, h_unsharp);

% Salt & Pepper noise
cam_sp_avg       = imfilter(I1_sp, h_avg);
cam_sp_gauss     = imfilter(I1_sp, h_gauss);
cam_sp_unsharp   = imfilter(I1_sp, h_unsharp);

% --- Peppers (кольорове) ---
% Gaussian noise
pep_gauss_avg    = imfilter(I2_gauss, h_avg);
pep_gauss_gauss  = imfilter(I2_gauss, h_gauss);
pep_gauss_unsharp= imfilter(I2_gauss, h_unsharp);

% Salt & Pepper noise
pep_sp_avg       = imfilter(I2_sp, h_avg);
pep_sp_gauss     = imfilter(I2_sp, h_gauss);
pep_sp_unsharp   = imfilter(I2_sp, h_unsharp);

% Відобразимо результати лінійної фільтрації
figure('Name','Cameraman Gaussian Noise - Linear Filters');
subplot(1,3,1), imshow(cam_gauss_avg),     title('Average Filter');
subplot(1,3,2), imshow(cam_gauss_gauss),   title('Gaussian Filter');
subplot(1,3,3), imshow(cam_gauss_unsharp), title('Unsharp Filter');

figure('Name','Cameraman Salt & Pepper Noise - Linear Filters');
subplot(1,3,1), imshow(cam_sp_avg),     title('Average Filter');
subplot(1,3,2), imshow(cam_sp_gauss),   title('Gaussian Filter');
subplot(1,3,3), imshow(cam_sp_unsharp), title('Unsharp Filter');

figure('Name','Peppers Gaussian Noise - Linear Filters');
subplot(1,3,1), imshow(pep_gauss_avg),     title('Average Filter');
subplot(1,3,2), imshow(pep_gauss_gauss),   title('Gaussian Filter');
subplot(1,3,3), imshow(pep_gauss_unsharp), title('Unsharp Filter');

figure('Name','Peppers Salt & Pepper Noise - Linear Filters');
subplot(1,3,1), imshow(pep_sp_avg),     title('Average Filter');
subplot(1,3,2), imshow(pep_sp_gauss),   title('Gaussian Filter');
subplot(1,3,3), imshow(pep_sp_unsharp), title('Unsharp Filter');

% Пояснення принципу роботи лінійних фільтрів:
% - Фільтри низьких частот (average, gaussian) "розмивають" різкі переходи,
%   пригнічують шум, але зменшують різкість.
% - Фільтр Unsharp підсилює різкі переходи (краї), що підвищує чіткість.

%% 7. Адаптивна фільтрація Вінером (wiener2)
% Wiener2 адаптивно підлаштовується до локальної дисперсії зображення.
% Для сірого зображення (cameraman) можна застосувати напряму,
% а для кольорового (peppers) — по каналах.

% --- Cameraman ---
cam_gauss_wiener = wiener2(I1_gauss, [5 5]);
cam_sp_wiener    = wiener2(I1_sp,    [5 5]);

figure('Name','Cameraman - Wiener Filter');
subplot(1,2,1), imshow(cam_gauss_wiener), title('Gaussian Noise - Wiener');
subplot(1,2,2), imshow(cam_sp_wiener),    title('Salt & Pepper - Wiener');

% --- Peppers (кольорове) ---
% Розділяємо на канали
pr_gauss = I2_gauss(:,:,1); pg_gauss = I2_gauss(:,:,2); pb_gauss = I2_gauss(:,:,3);
pr_sp    = I2_sp(:,:,1);    pg_sp    = I2_sp(:,:,2);    pb_sp    = I2_sp(:,:,3);

% Фільтруємо кожен канал
pr_gauss_w = wiener2(pr_gauss,[5 5]);
pg_gauss_w = wiener2(pg_gauss,[5 5]);
pb_gauss_w = wiener2(pb_gauss,[5 5]);
pr_sp_w    = wiener2(pr_sp,[5 5]);
pg_sp_w    = wiener2(pg_sp,[5 5]);
pb_sp_w    = wiener2(pb_sp,[5 5]);

% Об'єднуємо назад
pep_gauss_wiener = cat(3, pr_gauss_w, pg_gauss_w, pb_gauss_w);
pep_sp_wiener    = cat(3, pr_sp_w,    pg_sp_w,    pb_sp_w);

figure('Name','Peppers - Wiener Filter');
subplot(1,2,1), imshow(pep_gauss_wiener), title('Gaussian Noise - Wiener');
subplot(1,2,2), imshow(pep_sp_wiener),    title('Salt & Pepper - Wiener');

% Пояснення:
% Wiener2 оцінює локальні статистики (середнє, дисперсію) та зменшує шум
% ефективніше, ніж фіксований лінійний фільтр, особливо при нестаціонарних шумах.

%% 8. Медіанна фільтрація
% Медіанна фільтрація добре пригнічує імпульсні шуми, зберігаючи краї краще,
% ніж середнє згладжування.

% --- Cameraman (сіре) ---
cam_gauss_med = medfilt2(I1_gauss, [3 3]);
cam_sp_med    = medfilt2(I1_sp,    [3 3]);

figure('Name','Cameraman - Median Filter');
subplot(1,2,1), imshow(cam_gauss_med), title('Gaussian Noise - Median');
subplot(1,2,2), imshow(cam_sp_med),    title('Salt & Pepper Noise - Median');

% --- Peppers (кольорове) ---
% Аналогічно застосуємо медіанний фільтр до кожного каналу
pr_gauss_med = medfilt2(pr_gauss, [3 3]);
pg_gauss_med = medfilt2(pg_gauss, [3 3]);
pb_gauss_med = medfilt2(pb_gauss, [3 3]);
pep_gauss_med = cat(3, pr_gauss_med, pg_gauss_med, pb_gauss_med);

pr_sp_med = medfilt2(pr_sp, [3 3]);
pg_sp_med = medfilt2(pg_sp, [3 3]);
pb_sp_med = medfilt2(pb_sp, [3 3]);
pep_sp_med = cat(3, pr_sp_med, pg_sp_med, pb_sp_med);

figure('Name','Peppers - Median Filter');
subplot(1,2,1), imshow(pep_gauss_med), title('Gaussian Noise - Median');
subplot(1,2,2), imshow(pep_sp_med),    title('Salt & Pepper Noise - Median');

% Пояснення:
% При імпульсному шумі ("сіль і перець") медіанний фільтр особливо ефективний,
% оскільки відкидає аномальні "сплески" (білі/чорні точки) без надмірного
% розмивання решти зображення.

%% 9. Який фільтр краще для якого шуму?
% - Gaussian Noise:
%   * Добре працюють лінійні низькочастотні фільтри (average, gaussian),
%     а також адаптивний Wiener.
% - Salt & Pepper Noise (імпульсний):
%   * Найкраще підходить медіанний фільтр,
%     хоча Wiener теж може давати прийнятний результат.
%
% Пояснення:
% - Лінійні фільтри згладжують шуми, але при імпульсному шумі вони
%   розмивають яскраві точки й можуть псувати контрасти.
% - Медіанний фільтр для імпульсних шумів працює краще, бо "вибирає" середнє
%   значення серед сусідів, ігноруючи аномальні піки.
% - Wiener2 адаптивно враховує локальну варіацію, тому може бути компромісом
%   і для гаусівського, і для імпульсного шуму.

disp('--- Виконання завдання завершено ---');