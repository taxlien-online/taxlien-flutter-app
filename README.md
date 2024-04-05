# 🌐 nativemind_reactnative

Welcome to `nativemind_reactnative`! This React Native application is designed to display the content of a primary PWA application within a WebView, offering a seamless integration of web content into a native app experience. 🚀

## Prerequisites

Before starting with `nativemind_reactnative`, you should have the following installed:

1. **Node.js** 🛠️

   Ensure Node.js is installed on your system. You can download it from [nodejs.org](https://nodejs.org/).

2. **React Native CLI** 📱

   Install the React Native CLI globally on your machine. This project does not use Expo, so the CLI is necessary for building and running the app.
   ```
   npm install -g react-native-cli
   ```

3. **Android Studio or Xcode** 🖥️

   For Android development, install Android Studio. For iOS development, ensure you have Xcode installed. These will provide the necessary tools to build and test your application on mobile devices.

## 🛠️ Installation

1. **Clone the Repository** 📦

   Clone `nativemind_reactnative` to your local machine:
   ```
   git clone https://github.com/yourrepository/nativemind_reactnative.git
   ```
   Then, navigate to the project directory:
   ```
   cd nativemind_reactnative
   ```

2. **Install Dependencies** 📤

   Within the project directory, install the necessary dependencies:
   ```
   npm install
   ```

3. **Configure WebView URL** 🌐

   Open the `App.js` file or wherever your WebView component is initialized. Configure the `source` prop of the WebView component to point to your PWA URL:
   ```javascript
   <WebView source={{ uri: 'https://yourpwaurl.com' }} style={{ marginTop: 20 }} />
   ```

## 🔌 Running the App

1. **Android** 🤖

   Ensure you have an Android emulator running, or a device connected, then execute:
   ```
   npx react-native run-android
   ```

2. **iOS** 🍏

   First, navigate to the iOS folder and install CocoaPods dependencies:
   ```
   cd ios && pod install && cd ..
   ```
   Then, run the app on an iOS simulator or device:
   ```
   npx react-native run-ios
   ```

Your React Native app should now load the content of your PWA within a WebView, blending web and native app functionalities! 🌍
---

Assets generator
https://www.appicon.co/
---

If you have suggestions or improvements, feel free to open an issue or submit a pull request. Dive into developing a hybrid app experience with React Native! 🎉
