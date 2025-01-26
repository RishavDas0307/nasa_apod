# NASA APOD Flutter App

This is a Flutter application that displays the Astronomy Picture of the Day (APOD) from NASA. Users can view the daily image, along with its title, explanation, and other details. The app also allows users to sign in, add images to their favorites, and view them later.

## Features
- Display Astronomy Picture of the Day (APOD)
- User authentication with Firebase
- Add images to favorites
- View favorites list
- Fetch images from NASA API

## Requirements
- Flutter 2.x or higher
- Firebase Project (for authentication and Firestore)
- Internet connection (to fetch data from NASA API)

## Setup Instructions

### 1. Clone the repository
```bash
git clone https://github.com/yourusername/nasa_apod_flutter.git
cd nasa_apod_flutter
```

### 2. Install Dependencies
   Make sure you have Flutter installed on your system. Then, run the following command to install the necessary packages:
  ```bash
   flutter pub get
```

### 3. Firebase Setup
Follow these steps to set up Firebase for your Flutter project:

- Go to the Firebase Console.
- Create a new Firebase project.
- Add Firebase to your Flutter app:
- For Android, download the google-services.json and place it in the android/app directory.
- For iOS, download the GoogleService-Info.plist and place it in the ios/Runner directory.
- Enable Firebase Authentication (email/password) in the Firebase console.
- Enable Firestore and set up a users collection for storing user data and favorites.

### 4. Configure the App with Firebase
   - Make sure your Firebase configuration is correct in ``android/app/build.gradle`` and ``ios/Runner/Info.plist``.
   - For Firebase Authentication, make sure the email/password sign-in method is enabled
  
### 5. API Key for NASA
   The app fetches images from NASA's Astronomy Picture of the Day (APOD) API. You need to sign up for an API key:
   - Visit [NASA's API](https://api.nasa.gov/) page and get your API key.
   - Replace the placeholder `apiKey` in the `home.dart` file with your API key.
  
### 6. Run the App
   Run the app using the following command
   ```bash flutter run```

   #### File Structure
   ```bash
├── android/                     # Android-specific code and configurations
├── assets/                      # Image and assets for the app
├── ios/                         # iOS-specific code and configurations
├── lib/
│   ├── auth.dart                # User authentication related code
│   ├── authProvider.dart        # AuthProvider for handling user and favorites
│   ├── home.dart                # Home screen displaying NASA APOD
│   ├── favorites.dart           # Page to view and manage favorites
│   └── main.dart                # Entry point of the Flutter app
├── pubspec.yaml                 # Dependencies and configuration
└── README.md                    # This file
```

   #### Firebase Authentication
   The app uses Firebase for user authentication. The AuthProvider class manages user login, registration, and favorites. Users can register with their email and password, log in, and manage their favorite images.

   #### API Used
   NASA API: The app fetches data from the Astronomy Picture of the Day API provided by NASA to display images, titles, and explanations.

   #### Dependencies
   - `flutter`: The Flutter SDK
   - `firebase_core`: To initialize Firebase
   - `firebase_auth`: To handle user authentication
   - `cloud_firestore`: For storing user data and favorites in Firebase
   - `http`: To fetch data from the NASA API
   - `intl`: For date formating
   - `provider`: For state management

### 7. Screenshots
[url=https://ibb.co/1Q7nz98][img]https://i.ibb.co/8sNBYj6/landing-page.png[/img][/url]
[url=https://ibb.co/rb5KsSB][img]https://i.ibb.co/7grx453/search-page.png[/img][/url]
[url=https://ibb.co/QJRLLvp][img]https://i.ibb.co/grpNNZm/favourites-page-light-mode.png[/img][/url]
[url=https://ibb.co/5FcpFj6][img]https://i.ibb.co/SrvYrmP/home-page-0.png[/img][/url]
[url=https://ibb.co/bHFwnz0][img]https://i.ibb.co/CJ6CFhc/home-page-1.png[/img][/url]
![Landing Page](https://i.ibb.co/8sNBYj6/landing-page.png)
![Home_Page_0](https://i.ibb.co/SrvYrmP/home-page-0.png)
![Home_Page_1](https://i.ibb.co/CJ6CFhc/home-page-1.png)
![Search_Page](https://i.ibb.co/7grx453/search-page.png)
![Fav_Page_Light_Mode](https://i.ibb.co/grpNNZm/favourites-page-light-mode.png)

### 8. Acknowledgments
   - Thanks to NASA for providing the Astronomy Picture of the Day (APOD) API.
   - Firebase for authentication and Firestore.

### 9. How to use this template:
   1. **Clone the repo** and replace the placeholder text with your own information.
   2. **Add API Key**: Make sure you replace the placeholder for the NASA API key in `home.dart`.
   3. **Add any additional sections** like screenshots, acknowledgments, or specific instructions about your app.



