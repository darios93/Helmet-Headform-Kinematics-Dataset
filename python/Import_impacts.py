import numpy as np

# Load dataset
data = np.load("Impacts_Dataset.npz")

# Time-series IMU data (n_impacts, timesteps, channels)
X_acc = data["X_acc"] # Linear acceleration (helmet IMU, functional frame)
Y_acc = data["Y_acc"] # Linear acceleration (headform reference, functional frame)
X_gyr = data["X_gyr"] # Angular velocity (helmet IMU, functional frame)
Y_gyr = data["Y_gyr"] # Angular velocity (headform reference, functional frame)

# Metadata
Intensity = data["Intensity"] # Impact severity level
Direction = data["Direction"] # Impact direction (e.g., front, side, oblique)
IMU = data["IMU"] # IMU location on helmet

# Print dataset shape (n_impacts, timesteps, channels)
print("Dataset shape (n_impacts, timesteps, channels):", X_acc.shape)