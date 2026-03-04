#!/bin/bash

set -e

echo "🔍 Testing Flutter setup locally..."

cd flutter

echo "📝 Flutter version:"
flutter --version

echo "🧹 Cleaning project..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo "📋 Listing available tests..."
flutter test --list-tests

echo "🧪 Running tests without coverage..."
timeout 60s flutter test --dart-define=ENV=test --timeout=30s --concurrency=1

echo "📊 Running tests with coverage..."
timeout 120s flutter test --coverage --dart-define=ENV=test --timeout=30s --concurrency=1 || echo "⚠️ Coverage tests timed out (non-critical)"

echo "✅ Flutter tests completed successfully"