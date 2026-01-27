from fastapi import APIRouter
from app.schemas.diet_schema import DietPlannerRequest, DietPlanResponse
from app.services.diet_service import create_diet_plan, validate_user_data

router = APIRouter()


@router.post("/generate-diet-plan", response_model=DietPlanResponse)
async def generate_diet_plan_endpoint(request: DietPlannerRequest):
    """
    Diet Plan Generator Endpoint
    
    Accepts user preferences from onboarding and returns a personalized
    7-day meal plan.
    
    Request Body:
    - goals: List of health goals
    - activity_level: Physical activity level
    - gender: User's gender
    - height: Height in cm
    - weight: Current weight in kg
    - target_weight: Goal weight in kg
    - diet_type: Dietary preference (Vegan, Vegetarian, etc.)
    - medical_diet: Medical restrictions (Diabetes, etc.)
    - allergies: Food allergies/exclusions
    - preferred_cuisines: Cuisine preferences
    
    Returns:
    - generated_date: ISO timestamp
    - weekly_plan: List of 7 DayPlan objects
    """
    
    print("\n" + "="*60)
    print("API ENDPOINT: /generate-diet-plan")
    print("="*60)
    
    # Convert Pydantic model to dictionary
    user_data = request.model_dump()
    
    print(f"\n Received request:")
    print(f"   Goals: {user_data['goals']}")
    print(f"   Diet Type: {user_data['diet_type']}")
    print(f"   Activity: {user_data['activity_level']}")
    
    # Optional: Validate the data
    is_valid, error_msg = validate_user_data(user_data)
    
    if not is_valid:
        print(f"\n Validation failed: {error_msg}")
        # FastAPI will automatically return a 422 error with the message
        from fastapi import HTTPException
        raise HTTPException(status_code=422, detail=error_msg)
    
    print(f"\n Validation passed")
    
    # Call the service to generate the plan
    diet_plan = create_diet_plan(user_data)
    
    print(f"\n Diet plan generated successfully")
    print("="*60)
    
    # FastAPI automatically converts the dict to DietPlanResponse
    return diet_plan