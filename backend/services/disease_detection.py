import os
from typing import List
from PIL import Image
import numpy as np
from models.plant_models import Disease

class DiseaseDetectionService:
    def __init__(self):
        # Initialize disease detection model
        # In production, this would load a trained CNN model
        self.model = None
        self.disease_classes = [
            "healthy",
            "black_spot",
            "powdery_mildew",
            "rust",
            "leaf_blight",
            "bacterial_spot",
            "early_blight",
            "late_blight"
        ]
        
    async def detect_diseases(self, image_path: str) -> List[Disease]:
        """
        Detect diseases in plant image using AI model.
        """
        try:
            # For demo purposes, return mock data
            # In production, this would use a trained disease detection model
            return self._get_mock_diseases()
            
            # Uncomment for actual model inference
            # return await self._detect_with_model(image_path)
            
        except Exception as e:
            print(f"Error in disease detection: {e}")
            return self._get_mock_diseases()
    
    async def _detect_with_model(self, image_path: str) -> List[Disease]:
        """
        Use trained model for disease detection.
        """
        # Preprocess image
        image_array = self._preprocess_image(image_path)
        
        # Model inference (placeholder)
        # predictions = self.model.predict(image_array)
        
        # For now, return mock data
        return self._get_mock_diseases()
    
    def _preprocess_image(self, image_path: str) -> np.ndarray:
        """
        Preprocess image for disease detection model.
        """
        image = Image.open(image_path)
        image = image.resize((224, 224))
        image_array = np.array(image) / 255.0
        image_array = np.expand_dims(image_array, axis=0)
        return image_array
    
    def _get_mock_diseases(self) -> List[Disease]:
        """
        Return mock disease detection data for demo purposes.
        """
        return [
            Disease(
                name="Black Spot",
                description="A fungal disease that causes black spots on rose leaves",
                confidence=0.87,
                severity="medium",
                symptoms=[
                    "Black spots on leaves",
                    "Yellowing around spots",
                    "Leaf drop in severe cases"
                ],
                treatment="Remove infected leaves and apply fungicide"
            ),
            Disease(
                name="Powdery Mildew",
                description="A fungal disease that appears as white powdery spots",
                confidence=0.72,
                severity="low",
                symptoms=[
                    "White powdery spots on leaves",
                    "Distorted new growth",
                    "Reduced flowering"
                ],
                treatment="Improve air circulation and apply fungicide"
            )
        ]
    
    def _load_model(self):
        """
        Load the trained disease detection model.
        """
        # In production, this would load a trained TensorFlow/PyTorch model
        # Example:
        # self.model = tf.keras.models.load_model('models/disease_detection_model.h5')
        pass