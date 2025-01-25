# NASA APOD App

A Flutter-based application that showcases NASA's Astronomy Picture of the Day (APOD). The app fetches data from NASA's public API and provides two main features:

1. **Home Page**: Displays the APOD for the last 7 days.
2. **Search Page**: Allows users to search for APOD by a specific date.

## Features

- **Dark Mode Support**: Toggle between light and dark themes.
- **Dynamic Media Display**: Handles both images and videos (with YouTube redirection for videos).
- **Interactive UI**: Expandable cards for detailed explanations.
- **Date Picker**: Select dates to fetch specific APOD entries.

## Screenshots

_Add screenshots or GIFs here to showcase your app._

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/nasa-apod-app.git
   ```
2. Navigate to the project directory:
   ```bash
   cd nasa-apod-app
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Dependencies

The project uses the following dependencies:

- `http`: For making API requests.
- `intl`: For date formatting.
- `video_player`: To handle video content.
- `url_launcher`: For opening URLs (e.g., YouTube links).

Add them in your `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^0.15.0
  intl: ^0.17.0
  video_player: ^2.5.0
  url_launcher: ^6.1.0
```

## API Key Setup

The app uses NASA's APOD API. To use it:

1. Obtain an API key from [NASA API Portal](https://api.nasa.gov/).
2. Replace the placeholder API key in the code:
   ```dart
   final apiKey = 'YOUR_API_KEY';
   ```

## Project Structure

```plaintext
lib/
├── main.dart       # Entry point of the app.
├── home.dart       # Home page logic and UI.
├── search.dart     # Search page logic and UI.
```

## Contribution

Contributions are welcome! If you have any suggestions or find a bug, feel free to open an issue or create a pull request.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

---

Enjoy exploring the universe with NASA's APOD app!
