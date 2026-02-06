

from app.agents.diet_planner import generate_diet_plan


def create_diet_plan(user_preferences: dict) -> dict:
    """
    Main service function to create personalized diet plan
    
    Process:
    1. Validate user data (optional - could add validation here)
    2. Call Agent 4 to generate plan
    3. Return the plan (already in correct format)
    
    Args:
        user_preferences: Dictionary with user's onboarding data
        
    Returns:
        Dictionary with 7-day meal plan
    """
    
    print("="*60)
    print("DIET SERVICE: Creating personalized meal plan")
    print("="*60)
    
    # Log request details
    print(f"\n📥 Request received:")
    print(f"   User: {user_preferences.get('gender', 'Unknown')}")
    print(f"   Goals: {', '.join(user_preferences.get('goals', []))}")
    print(f"   Diet: {user_preferences.get('diet_type', 'Unknown')}")
    
    # Call Agent 4 to generate the plan
    plan = generate_diet_plan(user_preferences)
    
    print(f"\n✅ Service: Plan generation complete")
    print(f"   Generated {len(plan.get('weekly_plan', []))} days")
    print("="*60)
    
    return plan


# Optional: Add validation function
def validate_user_data(data: dict) -> tuple[bool, str]:
    """
    Validates user data before generating plan
    
    Returns:
        (is_valid, error_message)
    """
    
    required_fields = [
        "goals", "activity_level", "gender", "height", 
        "weight", "target_weight", "diet_type"
    ]
    
    for field in required_fields:
        if field not in data or not data[field]:
            return False, f"Missing required field: {field}"
    
    # Validate numeric ranges
    if data["height"] < 100 or data["height"] > 250:
        return False, "Height must be between 100-250 cm"
    
    if data["weight"] < 30 or data["weight"] > 300:
        return False, "Weight must be between 30-300 kg"
    
    if data["target_weight"] < 30 or data["target_weight"] > 300:
        return False, "Target weight must be between 30-300 kg"
    
    return True, ""