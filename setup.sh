#!/bin/bash

echo "🌱 Setting up PlantDoctor - AI-Powered Plant Disease Detection & Care App"
echo "=================================================================="

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed. Please install Python 3.8+ first."
    exit 1
fi

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    echo "Visit: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Prerequisites check passed"

# Create necessary directories
echo "📁 Creating project directories..."
mkdir -p mobile_app/assets/images
mkdir -p mobile_app/assets/animations
mkdir -p mobile_app/assets/icons
mkdir -p mobile_app/assets/fonts
mkdir -p backend/temp
mkdir -p backend/uploads
mkdir -p backend/ml_models
mkdir -p docs

# Setup Flutter app
echo "📱 Setting up Flutter app..."
cd mobile_app

# Get Flutter dependencies
echo "📦 Installing Flutter dependencies..."
flutter pub get

# Setup Android
echo "🤖 Setting up Android configuration..."
flutter build apk --debug

# Setup iOS (if on macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍎 Setting up iOS configuration..."
    flutter build ios --debug --no-codesign
fi

cd ..

# Setup Python backend
echo "🐍 Setting up Python backend..."
cd backend

# Create virtual environment
echo "🔧 Creating Python virtual environment..."
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate

# Install Python dependencies
echo "📦 Installing Python dependencies..."
pip install -r requirements.txt

# Create .env file from example
if [ ! -f .env ]; then
    echo "⚙️ Creating environment configuration..."
    cp .env.example .env
    echo "📝 Please edit backend/.env with your API keys"
fi

cd ..

# Create documentation
echo "📚 Creating documentation..."
cat > docs/API_DOCUMENTATION.md << 'EOF'
# PlantDoctor API Documentation

## Endpoints

### POST /analyze-plant
Analyze a plant image for identification, disease detection, and care prescription.

**Request:**
- Content-Type: multipart/form-data
- Body: image file

**Response:**
```json
{
  "id": "uuid",
  "name": "Rose",
  "scientific_name": "Rosa",
  "common_name": "Garden Rose",
  "confidence": 0.95,
  "image_url": "",
  "diseases": [...],
  "care_prescription": {...},
  "analyzed_at": "2024-01-01T12:00:00Z"
}
```

### POST /identify-plant
Identify plant species from image.

### POST /detect-diseases
Detect diseases in plant image.

### POST /care-prescription
Generate care prescription for plant with diseases.

## Setup Instructions

1. Install dependencies: `pip install -r requirements.txt`
2. Configure API keys in `.env` file
3. Run server: `python main.py`
EOF

cat > docs/FLUTTER_SETUP.md << 'EOF'
# Flutter App Setup

## Prerequisites
- Flutter SDK 3.0+
- Android Studio / Xcode
- Dart SDK

## Setup Steps

1. Install dependencies:
   ```bash
   cd mobile_app
   flutter pub get
   ```

2. Run the app:
   ```bash
   flutter run
   ```

3. Build for production:
   ```bash
   flutter build apk --release
   flutter build ios --release
   ```

## Features
- Camera capture with edge detection
- Gallery image upload
- Real-time plant analysis
- Disease detection and treatment
- Care prescription generation
- Plant history tracking
- Beautiful UI with nature-inspired design
EOF

echo ""
echo "🎉 Setup completed successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Configure API keys in backend/.env"
echo "2. Start the backend server: cd backend && python main.py"
echo "3. Run the Flutter app: cd mobile_app && flutter run"
echo ""
echo "📚 Documentation created in docs/ folder"
echo ""
echo "🌱 Happy plant caring!"