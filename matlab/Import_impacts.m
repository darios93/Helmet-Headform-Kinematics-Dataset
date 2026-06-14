% Load dataset
data = load('Impacts_Dataset.mat');

% Time-series kinematic data — shape: (n_impacts, timesteps, channels)
X_acc = data.X_acc;  % Helmet linear acceleration, functional frame (g)
X_gyr = data.X_gyr;  % Helmet angular velocity, functional frame (deg/s)
Y_acc = data.Y_acc;  % Headform linear acceleration, functional frame (g)
Y_gyr = data.Y_gyr;  % Headform angular velocity, functional frame (deg/s)

% Metadata
Intensity = data.Intensity;  % Pendulum arm angle: 30, 50, or 70 deg
Direction = data.Direction;  % Impact direction: Front, Side, Front-oblique, Back-oblique
IMU       = data.IMU;        % IMU location: Top-Front, Back 1, Back 2

disp(size(X_acc))  % (n_impacts, timesteps, channels)