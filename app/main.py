from fastapi import FastAPI
from pydantic import BaseModel
from app.symptom_data import SYMPTOM_DB

app = FastAPI()

@app.get("/")
def health():
    return {"status": "backend alive"}

class SymptomRequest(BaseModel):
    symptoms: str

@app.post("/check-symptoms")
async def check_symptoms(request: SymptomRequest):
    user_input = request.symptoms.lower()

    for symptom, info in SYMPTOM_DB.items():
        if symptom in user_input:
            return {
                "detected_symptoms": symptom,
                "possible_causes": info["possible_causes"],
                "recommended_doctor": info["recommended_doctor"],
                "self_care_tips": info["self_care_tips"],
                "disclaimer": "This is not a medical diagnosis."
            }

    return {
        "detected_symptoms": "none",
        "possible_causes": [],
        "recommended_doctor": "General Physician",
        "self_care_tips": [],
        "disclaimer": "Symptoms not recognized."
    }
