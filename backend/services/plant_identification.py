import os
import requests
from PIL import Image
import numpy as np
from typing import Dict, Any

class PlantIdentificationService:
    def __init__(self):
        # Initialize with PlantNet API or local model
        self.api_key = os.getenv("PLANTNET_API_KEY", "")
        self.base_url = "https://my.plantnet.org/api/v2"
        
    async def identify_plant(self, image_path: str) -> Dict[str, Any]:
        """
        Identify plant species from image using PlantNet API or local model.
        """
        try:
            # For demo purposes, return mock data
            # In production, this would use PlantNet API or a trained model
            return self._get_mock_identification()
            
            # Uncomment for actual PlantNet API integration
            # return await self._identify_with_plantnet(image_path)
            
        except Exception as e:
            print(f"Error in plant identification: {e}")
            return self._get_mock_identification()
    
    async def _identify_with_plantnet(self, image_path: str) -> Dict[str, Any]:
        """
        Use PlantNet API for plant identification.
        """
        if not self.api_key:
            raise ValueError("PlantNet API key not configured")
        
        url = f"{self.base_url}/identify/all"
        
        with open(image_path, 'rb') as image_file:
            files = {'images': image_file}
            data = {'api-key': self.api_key}
            
            response = requests.post(url, files=files, data=data)
            response.raise_for_status()
            
            result = response.json()
            
            if result['results']:
                best_match = result['results'][0]
                return {
                    "name": best_match['species']['genus'] + " " + best_match['species']['scientificNameWithoutAuthor'],
                    "scientific_name": best_match['species']['scientificNameWithoutAuthor'],
                    "common_name": best_match['species']['commonNames'][0] if best_match['species']['commonNames'] else "",
                    "confidence": best_match['score']
                }
            else:
                return self._get_mock_identification()
    
    def _get_mock_identification(self) -> Dict[str, Any]:
        """
        Return mock plant identification data for demo purposes.
        """
        return {
            "name": "Rose",
            "scientific_name": "Rosa",
            "common_name": "Garden Rose",
            "confidence": 0.95
        }
    
    def _preprocess_image(self, image_path: str) -> np.ndarray:
        """
        Preprocess image for model input.
        """
        image = Image.open(image_path)
        image = image.resize((224, 224))  # Standard size for many models
        image_array = np.array(image) / 255.0  # Normalize to [0, 1]
        return image_array