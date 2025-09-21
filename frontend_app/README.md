##  Frontend (Flutter Application) 📱

The frontend is a modern, cross-platform mobile application built with Flutter. It provides a rich user interface for both new and registered users to interact with the various services offered. The app is designed to be intuitive, responsive, and consistent across all screens.

### Key Features

* **User Authentication**: A complete login and registration flow that communicates with the backend to securely authenticate users.
* **Dynamic Home Screen**: The home screen is not static; it fetches the list of all 12+ service categories directly from the backend API, ensuring the content is always up-to-date.
* **Real-time Search**: A functional search bar allows users to filter the extensive list of categories instantly.
* **Custom Forms for Each Category**: Every category navigates to a unique, feature-rich form tailored to its specific requirements. This includes:
    * **Dependent Dropdowns**: For selecting a country and then seeing a filtered list of states.
    * **Visual Selectors**: Stylish, image-based cards for selecting options like cuisine types, accommodation, and services, enhancing the user experience.
    * **Custom UI Widgets**: Unique input methods like multi-date pickers, choice cards for preferences, and combined budget/currency fields.
* **Consistent Design Language**: All form screens share a consistent and professional design, including a themed `AppBar`, a gradient background, and a uniform "title above the box" style for all input fields.
* **Fixed Layout**: A modern UI structure with a fixed `AppBar` at the top, a fixed footer with app info at the bottom, and a scrollable content area in the middle.

### Project Structure

The Flutter project is organized into a clean and scalable structure to separate concerns and make the code easy to maintain.

```frontend_app/
└── lib/
├── main.dart             # App entry point
├── data/                 # Contains static data like lists (countries, currencies)
├── models/               # (Optional) For defining data structures
├── screens/              # Contains all the main screen widgets
│   ├── login_page.dart
│   ├── home_screen.dart
│   └── ... (all 12+ form screen files)
├── services/
│   └── api_service.dart    # Handles all HTTP communication with the backend
└── widgets/              # Contains reusable UI components
├── category_card.dart
├── choice_card.dart
├── cuisine_card.dart
└── ... (other custom card widgets)
````

### State Management & API Service

* **State Management**: The app uses `StatefulWidget` and the `setState` method for managing local UI state, which is a simple yet effective approach for forms and dynamic content.
* **API Service**: All communication with the Node.js backend is centralized in the `ApiService` class. This service uses the `http` package to make `GET` and `POST` requests to the various API endpoints, handling data serialization (JSON) and error management.

### Key Packages Used

* **`http`**: For making network requests to the backend API.
* **`intl`**: For formatting dates and numbers to be displayed in the UI.
* **`flutter/cupertino.dart`**: For specific UI elements and icons.

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
