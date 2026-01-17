from pydantic import BaseModel
from typing import List, Dict, Optional


class DietPlannerRequest(BaseModel):
    """
    Request model - matches Flutter's onboardingState.toJson()
    
    This is the data Flutter collects during onboarding:
    - User's health goals
    - Physical stats (height, weight, target)
    - Activity level
    - Diet preferences
    - Restrictions (medical, allergies)
    """
    goals: List[str] 
    activity_level: str 
    gender: str  
    height: float  
    weight: float  
    target_weight: float  
    diet_type: str  
    medical_diet: List[str] 
    allergies: List[str]  
    preferred_cuisines: List[str] 


class MealOption(BaseModel):
    """
    Single meal option (Flutter needs 2 options per meal type for swapping)
    
    Example:
    {
        "name": "Oatmeal with berries",
        "calories": 350,
        "proteins": 12
    }
    """
    name: str  
    calories: int  
    proteins: int  


class DayPlan(BaseModel):
    """
    Complete plan for one day
    
    Contains:
    - Day name (Monday, Tuesday, etc.)
    - Total daily calories/protein
    - All meals with 2 options each
    """
    day_name: str  
    total_calories: int  
    total_protein: int 
    meals: Dict[str, List[MealOption]]  


class DietPlanResponse(BaseModel):
    """
    Complete 7-day meal plan response
    
    This matches Flutter's DietPlanModel exactly!
    """
    generated_date: str  
    weekly_plan: List[DayPlan]  


# Example of what the response looks like:
"""
{
    "generated_date": "2025-01-15T10:30:00",
    "weekly_plan": [
        {
            "day_name": "Monday",
            "total_calories": 2000,
            "total_protein": 150,
            "meals": {
                "breakfast": [
                    {"name": "Oats", "calories": 300, "proteins": 10},
                    {"name": "Eggs", "calories": 250, "proteins": 18}
                ],
                "lunch": [
                    {"name": "Salad", "calories": 500, "proteins": 40},
                    {"name": "Dal-rice", "calories": 420, "proteins": 30}
                ],
                "dinner": [
                    {"name": "Paneer", "calories": 300, "proteins": 20},
                    {"name": "Rice", "calories": 200, "proteins": 10}
                ],
                "snack": [
                    {"name": "Almonds", "calories": 120, "proteins": 5},
                    {"name": "Fox-nuts", "calories": 200, "proteins": 10}
                ]
            }
        },
        ... 6 more days
    ]
}
"""