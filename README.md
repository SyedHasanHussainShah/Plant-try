# 🌱 PlantDoctor - AI-Powered Plant Disease Detection & Care App

A cross-platform mobile application that uses AI to identify plants, detect diseases, and provide personalized care recommendations.

## 🚀 Features

- **Plant Identification**: Identify plants from photos with high accuracy
- **Disease Detection**: Detect diseases and pests affecting plants
- **AI Care Prescriptions**: Get personalized treatment and prevention advice
- **Modern UI/UX**: Beautiful, nature-inspired design with intuitive navigation
- **Cross-Platform**: Works on both iOS and Android
- **Offline Capability**: Core features work without internet connection

## 🛠 Tech Stack

### Frontend
- **Flutter** - Cross-platform mobile development
- **Dart** - Programming language
- **Provider** - State management
- **Camera Plugin** - Image capture functionality
- **Image Picker** - Gallery upload support

### Backend
- **Python** - Backend API development
- **FastAPI** - High-performance web framework
- **TensorFlow** - ML model serving
- **OpenAI API** - Dynamic care advice generation
- **Firebase** - Authentication and storage

### AI/ML
- **PlantNet API** - Plant identification
- **Custom CNN Model** - Disease detection
- **GPT-4/Claude** - Care advice generation

## 📱 App Screenshots

- Splash screen with plant animation
- Camera capture with edge detection
- Gallery upload interface
- Results screen with diagnosis
- Care prescription with actionable steps
- History tracking

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (3.0+)
- Python 3.8+
- Android Studio / Xcode
- Firebase project

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd plantdoctor
```

2. **Setup Flutter App**
```bash
cd mobile_app
flutter pub get
flutter run
```

3. **Setup Backend**
```bash
cd backend
pip install -r requirements.txt
python main.py
```

4. **Configure Environment Variables**
```bash
cp .env.example .env
# Add your API keys and configuration
```

## 📊 Success Metrics

- **Accuracy**: >90% plant identification and disease detection
- **Latency**: <3 seconds for analysis on mid-range devices
- **User Experience**: Intuitive navigation and beautiful design

## 🏗 Project Structure

```
plantdoctor/
├── mobile_app/          # Flutter application
├── backend/             # Python FastAPI backend
├── ml_models/           # Trained ML models
├── docs/               # Documentation
└── assets/             # Images and resources
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- PlantNet for plant identification API
- PlantVillage dataset for disease detection training
- OpenAI for care advice generation
- Flutter team for the amazing framework