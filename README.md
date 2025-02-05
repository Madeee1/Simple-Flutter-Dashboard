# Simple Dashboard

A Flutter project for HomePal Assessment that displays sensor data and visualizes sensor uptime.

## Requirements

- **Flutter SDK**: Ensure you have Flutter SDK installed. This project requires Flutter version `3.27.3` or higher.
- **Dart SDK**: Included with Flutter SDK.

## Setup Instructions

### Step 1: Clone the Repository

```sh
git clone https://github.com/Madeee1/Simple-Flutter-Dashboard.git
cd Simple-Flutter-Dashboard
```

### Step 2: Install Dependencies

```sh
flutter pub get
```

### Step 3: Running the App

```sh
flutter run
```

### Step 4: Additional Setup

Ensure you have the `mock_data.json` file in the `assets` directory.
If you encounter any issues, ensure your Flutter and Dart SDKs are up to date.

## Dependencies

- **flutter**: The core Flutter framework.
- **fl_chart**: A charting library for Flutter used to visualize sensor uptime.

## Assumptions and Design Decisions

- **State Management**: Simple state management using `setState` for handling sensor status updates.
- **Data Source**: Sensor data is loaded from a local JSON file (`assets/mock_data.json`).
- **UI Design**: The app displays a list of sensors with their status and uptime, and a bar chart visualizing the uptime of each sensor.
- **Refresh Functionality**: A "Refresh" button is provided to simulate updating sensor statuses by randomly changing the status of 1-3 sensors.
