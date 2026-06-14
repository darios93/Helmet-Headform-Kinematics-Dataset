# Helmet-Headform-Kinematics-Dataset
This dataset provides 1125 kinematic recordings from helmet-mounted Inertial Measurement Units (IMUs) and a reference headform, collected during labratory-controlled head impacts tests. It is designed to support the development of data-driven models that map surface-mounted sensor signals to internal head kinematics.

The dataset is available in two formats:
- `Impacts_Dataset.npz` — compressed NumPy archive for Python workflows
- `Impacts_Dataset.mat` — MATLAB format

---

## Experimental Setup

### Anthropometric Test Device (ATD) and Impact System

Laboratory-controlled impact tests were conducted using a Hybrid III 50th percentile male head–neck ATD, mounted on a linear sliding carriage and subjected to impacts delivered by a custom pendulum system.

Reference kinematic measurements at the head centre of mass (CoM) were obtained using:
- Three orthogonally mounted uniaxial accelerometers (Endevco 7264C-2000, DTS, USA; ±500 g range; 10 kHz sampling rate)
- Three angular rate sensors (ARS 8000, DTS, USA; ±8000 deg/s range; 10 kHz sampling rate)

### Helmet Instrumentation

A commercially available ice hockey helmet (RE-AKT 150, size M, Bauer, Canada) was instrumented with three IMUs (MindMaze, Switzerland), positioned along the sagittal midline of the helmet shell:

| Label | Location | Mounting |
|-------|----------|----------|
| `Top-Front` | Anterior-superior region | External, double-sided adhesive tape (3M, USA) |
| `Back 1` | Posterior-central region | External, double-sided adhesive tape (3M, USA) |
| `Back 2` | Posterior-inferior region | Internal, protective casing between liner and outer shell |

Each IMU included:
- Triaxial accelerometer (ADXL375, Analog Devices, USA; ±200 g range; 1024 Hz sampling frequency)
- Triaxial gyroscope (LSM6DSOX, STMicroelectronics, Switzerland; ±2000 deg/s range; 512 Hz sampling frequency)

### Impact Protocol

The helmet was fitted to the ATD following manufacturer guidelines. Impacts were delivered in four directions at three energy levels:

| Arm angle | Impact energy | Velocity |
|-----------|--------------|----------|
| 30° | 33 J | ~3.0 m/s |
| 50° | 79 J | ~4.6 m/s |
| 70° | 134 J | ~6.1 m/s |

These conditions were selected to reflect head impact magnitudes reported in ice hockey, covering both sub-concussive and concussive events.

For each combination of impact direction and energy level, six trials were performed. Each trial consisted of five impacts separated by approximately 20 seconds. Testing was organised by fixing the energy level and varying impact direction before proceeding to the next energy condition.

### Test Matrix

| Impact direction | 30° (33 J) | 50° (79 J) | 70° (134 J) | Total impacts | Total recordings (×4 IMUs) |
|-----------------|-----------|-----------|------------|--------------|--------------------------|
| Front | 30 | 30 | 30 | 90 | 360 |
| Front-oblique | 30 | 30 | 30 | 90 | 360 |
| Side | 30 | 30 | 30 | 90 | 360 |
| Back-oblique | 30 | 30 | 30 | 90 | 360 |
| **Total** | | | | **360** | **1440** |

The total number of recordings included in the dataset after signal processing is **1125** (see Signal Processing below).

---

## Signal Processing

### Coordinate System and Calibration

A functional coordinate system was defined with:
- **X-axis** — anterior–posterior direction
- **Y-axis** — axial (vertical) direction
- **Z-axis** — medial–lateral direction

### Resampling

To ensure consistency across signals, headform data and helmet gyroscope signals were resampled to 1024 Hz, matching the native sampling frequency of the helmet accelerometers.

### Impact Detection

Impact events were detected using the magnitude of the resultant linear acceleration:

- **Start/end criterion** — an event was defined as beginning when the acceleration norm exceeded 15 g and ending when it returned below this threshold.
- **Exclusion criterion** — events in which the angular velocity norm exceeded 400 deg/s were flagged and excluded as false positives (e.g. helmet handling or sensor manipulation).
- **Window expansion** — each detected event was expanded by 0.25 s before and after the identified start and end points to ensure full capture of the impact waveform.

### Temporal Alignment and Windowing

Temporal alignment between linear and angular kinematic signals was achieved by identifying the peak of the linear acceleration resultant, which served as the anchor time point. Each signal was then windowed to:
- 0.02 s before the peak
- 0.06 s after the peak

At 1024 Hz this yields **81 discrete timesteps** per impact.

---

## Dataset Structure

### Kinematic Tensors

All numerical data are stored as `float32` tensors. $N = 1125$ impacts, $T = 81$ timesteps.

| Key | Shape | Unit | Description |
|-----|-------|------|-------------|
| `X_acc` | $(N, T, 4)$ | g | Helmet triaxial accelerometer — channels 0–2 are the acceleration axes, channel 3 is the pre-computed Euclidean norm |
| `X_gyr` | $(N, T, 4)$ | deg/s | Helmet triaxial gyroscope — channels 0–2 are the angular velocity axes, channel 3 is the pre-computed Euclidean norm |
| `Y_acc` | $(N, T, 3)$ | g | Headform triaxial linear acceleration at the head CoM — ground-truth reference |
| `Y_gyr` | $(N, T, 3)$ | deg/s | Headform triaxial angular velocity at the head CoM — ground-truth reference |

### Metadata Arrays

| Key | Renamed key | Shape | Type | Description |
|-----|-------------|-------|------|-------------|
| `IMU` | `imu` | $(N,)$ | str | IMU location label: `Top-Front`, `Back 1`, or `Back 2` |
| `Intensity` | `impact_intensity` | $(N,)$ | int32 | Pendulum arm angle in degrees (30, 50, or 70) |
| `Direction` | `impact_direction` | $(N,)$ | str | Impact direction label: `Front`, `Front-oblique`, `Side`, or `Back-oblique` |

### Summary Table

| Key | Shape | Unit | Type |
|-----|-------|------|------|
| `X_acc` | (1125, 81, 4) | g | float32 |
| `X_gyr` | (1125, 81, 4) | deg/s | float32 |
| `Y_acc` | (1125, 81, 3) | g | float32 |
| `Y_gyr` | (1125, 81, 3) | deg/s | float32 |
| `Direction` | (1125,) | — | str |
| `Intensity` | (1125,) | deg (°) | int32 |
| `IMU` | (1125,) | — | str |

---
