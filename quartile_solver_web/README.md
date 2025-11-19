# Apple Quartile Solver - Flutter Web

Web interface for solving Apple News Quartile puzzles built with Flutter.

## Prerequisites

- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- Chrome or Edge browser (for development)

## Setup

1. **Install Flutter**
   ```bash
   # macOS
   brew install flutter
   
   # Or download from https://flutter.dev/docs/get-started/install
   ```

2. **Verify Installation**
   ```bash
   flutter doctor
   ```

3. **Copy Dictionary File**
   ```bash
   mkdir -p assets
   cp ../prolog/wn_s.pl assets/
   ```

4. **Install Dependencies**
   ```bash
   flutter pub get
   ```

## Development

Run in development mode:
```bash
flutter run -d chrome
```

Run with hot reload:
```bash
flutter run -d chrome --web-hot-restart
```

## Build for Production

Build optimized web app:
```bash
flutter build web --release
```

Output will be in `build/web/` directory.

## Deploy

### GitHub Pages
```bash
flutter build web --release --base-href "/apple-quartile-solver/"
# Copy build/web/* to gh-pages branch
```

### Netlify/Vercel
```bash
flutter build web --release
# Deploy build/web/ directory
```

## Project Structure

```
lib/
├── main.dart              # App entry point
├── models/                # Data models
│   ├── trie.dart
│   ├── puzzle.dart
│   └── solver_result.dart
├── services/              # Business logic
│   ├── dictionary_service.dart
│   ├── solver_service.dart
│   └── word_generator.dart
├── providers/             # State management
│   └── app_state.dart
└── widgets/               # UI components
    ├── puzzle_input.dart
    └── results_panel.dart
```

## Features

- Real-time puzzle solving
- Sample puzzle quick-load
- Multiple sort options
- Copy/export results
- Responsive design (mobile & desktop)
- Offline-capable (PWA)

## Performance

- Dictionary loads in ~2-3 seconds
- Solves 20-tile puzzles in <1 second
- Smooth 60fps UI animations

