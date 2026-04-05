#!/bin/bash

# Exit on any error
set -e

echo "🚀 Starting Automated Integration Tests..."

# 1. Get dependencies
echo "📥 Fetching dependencies..."
flutter pub get

# 2. Run build_runner (ensure all code is generated)
echo "🏗️  Running build_runner..."
flutter pub run build_runner build -d

# 3. Run Integration Tests
echo "🧪 Running Integration Tests (Flow: Login -> News -> Bookmark -> Chat)..."
# Note: This requires a running simulator or connected device.
flutter test integration_test/app_test.dart

echo "✅ All tests passed successfully!"
