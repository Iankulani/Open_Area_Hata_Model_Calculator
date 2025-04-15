clc;
clear;

disp('--- Hata Model Path Loss Calculator (Open Area) ---');

% --- User Inputs ---
fc = input('Enter the carrier frequency in Hz: ');
htx = input('Enter the transmitter height in meters:');
hrx = input('Enter the receiver height in meters:');

% --- Set Environment ---
Etype = 'open';  % Force Open/Rural environment

% --- Frequency Conversion ---
fc_MHz = fc / 1e6;

% --- Distance Vector (from 100m to 10 km) ---
d = linspace(100, 10000, 1000); % in meters

% --- Receiver Antenna Correction Factor ---
if fc_MHz >= 150 && fc_MHz <= 200
    C_Rx = 8.29 * (log10(1.54 * hrx))^2 - 1.1;
elseif fc_MHz > 200
    C_Rx = 3.2 * (log10(11.75 * hrx))^2 - 4.97;
else
    C_Rx = 0.8 + (1.1 * log10(fc_MHz) - 0.7) * hrx - 1.56 * log10(fc_MHz);
end

% --- Calculate Basic Path Loss (Urban Formula as Base) ---
PL = 69.55 + 26.16 * log10(fc_MHz) - 13.82 * log10(htx) - C_Rx ...
     + (44.9 - 6.55 * log10(htx)) * log10(d / 1000);

% --- Apply Open/Rural Area Correction ---
PL = PL + (18.33 - 4.78 * log10(fc_MHz)) * log10(fc_MHz) - 40.97;

% --- Plotting ---
figure;
plot(d / 1000, PL, 'g', 'LineWidth', 2);  % Green color for open area
xlabel('Distance (km)');
ylabel('Path Loss (dB)');
title('Hata Model Path Loss (Open Area)');
grid on;
xlim([min(d)/1000, max(d)/1000]);

% --- Display final message ---
fprintf('\nOpen area path loss plot generated for distances from 100 m to 10 km.\n');
fprintf('Frequency: %.2f MHz | Tx Height: %.2f m | Rx Height: %.2f m\n', fc_MHz, htx, hrx);
