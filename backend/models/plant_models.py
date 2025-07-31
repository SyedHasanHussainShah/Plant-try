from datetime import datetime
from typing import List, Optional
from pydantic import BaseModel

class Disease(BaseModel):
    name: str
    description: str
    confidence: float
    severity: str  # 'low', 'medium', 'high', 'critical'
    symptoms: List[str]
    treatment: str

class CareStep(BaseModel):
    title: str
    description: str
    category: str  # 'immediate', 'daily', 'weekly', 'monthly'
    priority: int  # 1-5, where 1 is highest priority
    materials: List[str]

class CarePrescription(BaseModel):
    summary: str
    steps: List[CareStep]
    watering: str
    sunlight: str
    soil: str
    fertilizer: str
    warnings: List[str]
    next_checkup: datetime

class PlantAnalysis(BaseModel):
    id: str
    name: str
    scientific_name: str
    common_name: str
    confidence: float
    image_url: str
    diseases: List[Disease]
    care_prescription: CarePrescription
    analyzed_at: datetime