import os
import uuid
from datetime import datetime
from typing import List, Optional
from fastapi import FastAPI, File, UploadFile, HTTPException, Form
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import uvicorn
from dotenv import load_dotenv

from services.plant_identification import PlantIdentificationService
from services.disease_detection import DiseaseDetectionService
from services.care_prescription import CarePrescriptionService
from models.plant_models import PlantAnalysis, Disease, CarePrescription, CareStep

# Load environment variables
load_dotenv()

app = FastAPI(
    title="PlantDoctor API",
    description="AI-Powered Plant Disease Detection & Care API",
    version="1.0.0"
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure appropriately for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize services
plant_identification_service = PlantIdentificationService()
disease_detection_service = DiseaseDetectionService()
care_prescription_service = CarePrescriptionService()

@app.get("/")
async def root():
    return {
        "message": "PlantDoctor API",
        "version": "1.0.0",
        "status": "running"
    }

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

@app.post("/analyze-plant")
async def analyze_plant(image: UploadFile = File(...)):
    """
    Analyze a plant image for identification, disease detection, and care prescription.
    """
    try:
        # Validate image file
        if not image.content_type.startswith('image/'):
            raise HTTPException(status_code=400, detail="File must be an image")
        
        # Save uploaded image temporarily
        image_path = f"temp/{uuid.uuid4()}_{image.filename}"
        os.makedirs("temp", exist_ok=True)
        
        with open(image_path, "wb") as buffer:
            content = await image.read()
            buffer.write(content)
        
        # Perform plant identification
        plant_info = await plant_identification_service.identify_plant(image_path)
        
        # Perform disease detection
        diseases = await disease_detection_service.detect_diseases(image_path)
        
        # Generate care prescription
        care_prescription = await care_prescription_service.generate_prescription(
            plant_name=plant_info["name"],
            diseases=diseases
        )
        
        # Clean up temporary file
        os.remove(image_path)
        
        # Create response
        analysis = PlantAnalysis(
            id=str(uuid.uuid4()),
            name=plant_info["name"],
            scientific_name=plant_info["scientific_name"],
            common_name=plant_info["common_name"],
            confidence=plant_info["confidence"],
            image_url="",  # Would be uploaded to cloud storage in production
            diseases=diseases,
            care_prescription=care_prescription,
            analyzed_at=datetime.now()
        )
        
        return analysis.dict()
        
    except Exception as e:
        # Clean up on error
        if os.path.exists(image_path):
            os.remove(image_path)
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/identify-plant")
async def identify_plant(image: UploadFile = File(...)):
    """
    Identify plant species from image.
    """
    try:
        if not image.content_type.startswith('image/'):
            raise HTTPException(status_code=400, detail="File must be an image")
        
        image_path = f"temp/{uuid.uuid4()}_{image.filename}"
        os.makedirs("temp", exist_ok=True)
        
        with open(image_path, "wb") as buffer:
            content = await image.read()
            buffer.write(content)
        
        plant_info = await plant_identification_service.identify_plant(image_path)
        
        os.remove(image_path)
        return plant_info
        
    except Exception as e:
        if os.path.exists(image_path):
            os.remove(image_path)
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/detect-diseases")
async def detect_diseases(image: UploadFile = File(...)):
    """
    Detect diseases in plant image.
    """
    try:
        if not image.content_type.startswith('image/'):
            raise HTTPException(status_code=400, detail="File must be an image")
        
        image_path = f"temp/{uuid.uuid4()}_{image.filename}"
        os.makedirs("temp", exist_ok=True)
        
        with open(image_path, "wb") as buffer:
            content = await image.read()
            buffer.write(content)
        
        diseases = await disease_detection_service.detect_diseases(image_path)
        
        os.remove(image_path)
        return {"diseases": [disease.dict() for disease in diseases]}
        
    except Exception as e:
        if os.path.exists(image_path):
            os.remove(image_path)
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/care-prescription")
async def get_care_prescription(
    plant_name: str = Form(...),
    diseases: Optional[str] = Form("[]")
):
    """
    Generate care prescription for plant with diseases.
    """
    try:
        import json
        diseases_list = json.loads(diseases) if diseases else []
        
        care_prescription = await care_prescription_service.generate_prescription(
            plant_name=plant_name,
            diseases=diseases_list
        )
        
        return care_prescription.dict()
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        reload=True
    )