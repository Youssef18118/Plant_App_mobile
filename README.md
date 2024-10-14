# GreenLife App

GreenLife is a beautiful and user-friendly mobile application developed with Flutter that helps plant lovers manage their indoor and outdoor gardens. Whether you're new to gardening or a seasoned pro, this app allows you to explore various plants, add them to your personal garden, and take care of them by managing watering schedules and more.

## Features

### 1. **Browse and Search for Plants**
- Explore a wide variety of plants in the app’s collection.
- Use the search function to quickly find plants by their name.

### 2. **Add to MyGarden**
- Add plants to your personalized garden (MyGarden) for easy tracking.
- Users can either select from the available plant list or manually add a plant by entering its name and uploading a photo. The app will then fetch detailed plant care information from the *Gimini* API.

### 3. **Plant Care Information**
- Each plant in the app comes with detailed care instructions:
  - **Watering Schedule**: See how often the plant needs to be watered.
  - **Pruning Info**: Learn how and when to prune your plant.
  - **Sunlight Requirements**: Understand the sunlight needs of each plant.

### 4. **Watering Notifications**
- Stay on top of your plant care with timely **watering notifications** for each plant in your MyGarden.
- Notifications are personalized based on the specific watering needs of your plants.

### 5. **Google Sign-In**
- Users can securely sign in to the app using their **Google Account**.
- Sync your plant collection across multiple devices.

### 6. **Local Storage with Hive**
- All plant data, user preferences, and garden collections are stored locally using **Hive** for fast, offline access.
- Your plant collection will always be available, even without an internet connection.

### 7. **Fetch Plant Info with Gemini API**
- When users manually add a plant by name and photo, the app fetches detailed care information from the **Gemini API**.

## Tech Stack

- **Flutter**: Cross-platform mobile development framework.
- **Dart**: Programming language used for Flutter.
- **Hive**: Lightweight and fast NoSQL database for local storage.
- **Google Sign-In**: Easy and secure Google authentication.
- **Gemini API**: Used for fetching plant care data when users manually add a plant.
- **Flutter Local Notifications**: Used for setting up and managing watering reminders.

## Demo Video
Video Link: 

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)
- [Android Studio](https://developer.android.com/studio) or [Xcode](https://developer.apple.com/xcode/) (for iOS development)

### Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/Youssef18118/Plant_App_mobile.git
    ```

2. Navigate to the project folder:

    ```bash
    cd Plant_App_mobile
    ```

3. Install dependencies:

    ```bash
    flutter pub get
    ```

4. Run the app:

    ```bash
    flutter run
    ```
