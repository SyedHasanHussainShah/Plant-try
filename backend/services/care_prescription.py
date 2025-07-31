import os
from datetime import datetime, timedelta
from typing import List, Dict, Any
import openai
from anthropic import Anthropic
from models.plant_models import CarePrescription, CareStep

class CarePrescriptionService:
    def __init__(self):
        # Initialize AI services
        self.openai_client = openai.OpenAI(
            api_key=os.getenv("OPENAI_API_KEY", "")
        )
        self.anthropic_client = Anthropic(
            api_key=os.getenv("ANTHROPIC_API_KEY", "")
        )
        
    async def generate_prescription(
        self, 
        plant_name: str, 
        diseases: List[Dict[str, Any]]
    ) -> CarePrescription:
        """
        Generate personalized care prescription using AI.
        """
        try:
            # For demo purposes, return mock data
            # In production, this would use OpenAI/Claude API
            return self._get_mock_prescription(plant_name, diseases)
            
            # Uncomment for actual AI integration
            # return await self._generate_with_ai(plant_name, diseases)
            
        except Exception as e:
            print(f"Error generating care prescription: {e}")
            return self._get_mock_prescription(plant_name, diseases)
    
    async def _generate_with_ai(
        self, 
        plant_name: str, 
        diseases: List[Dict[str, Any]]
    ) -> CarePrescription:
        """
        Generate care prescription using OpenAI/Claude API.
        """
        # Prepare prompt for AI
        prompt = self._create_prompt(plant_name, diseases)
        
        try:
            # Try OpenAI first
            response = await self._call_openai(prompt)
        except:
            try:
                # Fallback to Claude
                response = await self._call_claude(prompt)
            except:
                # Fallback to mock data
                return self._get_mock_prescription(plant_name, diseases)
        
        # Parse AI response and create prescription
        return self._parse_ai_response(response, plant_name, diseases)
    
    def _create_prompt(self, plant_name: str, diseases: List[Dict[str, Any]]) -> str:
        """
        Create prompt for AI care prescription generation.
        """
        disease_info = ""
        if diseases:
            disease_info = "The plant has the following diseases:\n"
            for disease in diseases:
                disease_info += f"- {disease['name']}: {disease['description']}\n"
        else:
            disease_info = "The plant appears to be healthy with no diseases detected."
        
        prompt = f"""
        You are an expert plant care specialist. Generate a comprehensive care prescription for a {plant_name}.
        
        {disease_info}
        
        Please provide a detailed care prescription including:
        1. A summary of the plant's condition and care needs
        2. Step-by-step treatment instructions with priorities
        3. Watering, sunlight, soil, and fertilizer requirements
        4. Important warnings and precautions
        5. When to check up on the plant again
        
        Format the response as a structured care plan that can be easily followed.
        """
        
        return prompt
    
    async def _call_openai(self, prompt: str) -> str:
        """
        Call OpenAI API for care prescription generation.
        """
        if not self.openai_client.api_key:
            raise ValueError("OpenAI API key not configured")
        
        response = self.openai_client.chat.completions.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": "You are an expert plant care specialist."},
                {"role": "user", "content": prompt}
            ],
            max_tokens=1000,
            temperature=0.7
        )
        
        return response.choices[0].message.content
    
    async def _call_claude(self, prompt: str) -> str:
        """
        Call Claude API for care prescription generation.
        """
        if not self.anthropic_client.api_key:
            raise ValueError("Anthropic API key not configured")
        
        response = self.anthropic_client.messages.create(
            model="claude-3-sonnet-20240229",
            max_tokens=1000,
            messages=[
                {"role": "user", "content": prompt}
            ]
        )
        
        return response.content[0].text
    
    def _parse_ai_response(self, response: str, plant_name: str, diseases: List[Dict[str, Any]]) -> CarePrescription:
        """
        Parse AI response and create structured care prescription.
        """
        # This would parse the AI response and extract structured data
        # For now, return mock data
        return self._get_mock_prescription(plant_name, diseases)
    
    def _get_mock_prescription(self, plant_name: str, diseases: List[Dict[str, Any]]) -> CarePrescription:
        """
        Return mock care prescription data for demo purposes.
        """
        has_diseases = len(diseases) > 0
        
        if has_diseases:
            summary = f"Your {plant_name} has detected diseases and needs immediate attention to prevent further damage."
            steps = [
                CareStep(
                    title="Remove Infected Leaves",
                    description="Carefully remove all leaves with visible disease symptoms",
                    category="immediate",
                    priority=1,
                    materials=["Gloves", "Pruning shears", "Disinfectant"]
                ),
                CareStep(
                    title="Apply Fungicide",
                    description="Spray with a copper-based fungicide to treat existing infections",
                    category="immediate",
                    priority=1,
                    materials=["Copper fungicide", "Spray bottle"]
                ),
                CareStep(
                    title="Improve Air Circulation",
                    description="Prune to open up the plant and allow better air flow",
                    category="weekly",
                    priority=2,
                    materials=["Pruning shears"]
                ),
                CareStep(
                    title="Water at Base",
                    description="Water at the base of the plant to avoid wetting leaves",
                    category="daily",
                    priority=3,
                    materials=["Watering can"]
                ),
                CareStep(
                    title="Monitor Progress",
                    description="Check for new symptoms weekly and continue treatment if needed",
                    category="weekly",
                    priority=4,
                    materials=[]
                )
            ]
            warnings = [
                "Avoid overhead watering",
                "Dispose of infected leaves properly",
                "Clean tools after use"
            ]
        else:
            summary = f"Your {plant_name} appears healthy! Continue with regular care to maintain its condition."
            steps = [
                CareStep(
                    title="Regular Watering",
                    description="Water when the top inch of soil feels dry",
                    category="daily",
                    priority=3,
                    materials=["Watering can"]
                ),
                CareStep(
                    title="Fertilize Monthly",
                    description="Apply balanced fertilizer during growing season",
                    category="monthly",
                    priority=4,
                    materials=["Balanced fertilizer"]
                ),
                CareStep(
                    title="Prune as Needed",
                    description="Remove dead or damaged growth to maintain plant health",
                    category="weekly",
                    priority=3,
                    materials=["Pruning shears"]
                )
            ]
            warnings = [
                "Monitor for any signs of disease or pests",
                "Ensure proper drainage",
                "Avoid overwatering"
            ]
        
        return CarePrescription(
            summary=summary,
            steps=steps,
            watering="Water deeply 2-3 times per week, avoiding wetting the leaves",
            sunlight="Full sun (6-8 hours per day)",
            soil="Well-draining, rich soil with pH 6.0-6.5",
            fertilizer="Apply balanced fertilizer monthly during growing season",
            warnings=warnings,
            next_checkup=datetime.now() + timedelta(days=7)
        )