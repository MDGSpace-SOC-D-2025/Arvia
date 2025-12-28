from fastapi import APIRouter
from app.schemas.symptom_schema import SymptomRequest, SymptomResponse
from app.services.symptom_service import analyze_symptoms

router = APIRouter()


@router.post("/check-symptoms", response_model=SymptomResponse)   # defining api endpoint
async def check_symptoms(request: SymptomRequest): # receive http request
    """
    Symptom checker endpoint.
    
    Accepts:
    - symptoms (required)
    - latitude, longitude (optional)
    
    Returns complete analysis with doctor recommendations if applicable.
    """
    
    # Prepare location dict if provided
    user_location = None
    if request.latitude and request.longitude:
        user_location = {
            "latitude": request.latitude,
            "longitude": request.longitude
        }
    
    # Run the pipeline
    result = analyze_symptoms(request.symptoms, user_location)
    
    return result