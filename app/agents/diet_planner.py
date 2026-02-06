from langchain_google_genai import ChatGoogleGenerativeAI
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from datetime import datetime
import json

# Initialize Gemini for diet planning
llm = ChatGoogleGenerativeAI(
    model="gemini-2.5-flash",
    temperature=0.7  # Higher temperature for creative meal variety
)

# Prompt template for diet plan generation
prompt = ChatPromptTemplate.from_template("""
You are a professional nutritionist and meal planner. Generate a personalized 7-day diet plan.

USER PREFERENCES:
{user_preferences}

INSTRUCTIONS:
1. Create meals for 7 days (Monday to Sunday)
2. Each day needs 4 meal types: breakfast, lunch, dinner, snack
3. For EACH meal type, provide exactly 2 different options (for variety/swapping)
4. Respect all dietary restrictions and preferences
5. Use preferred cuisines when possible
6. Ensure meals are practical and easy to prepare

NUTRITIONAL TARGETS:
- Daily calories: {target_calories}
- Daily protein: {target_protein}g
- Distribute calories: Breakfast 25%, Lunch 35%, Dinner 30%, Snack 10%

OUTPUT FORMAT (JSON only, no explanation):
{{
  "Monday": {{
    "breakfast": [
      {{"name": "Meal 1", "calories": 500, "proteins": 20}},
      {{"name": "Meal 2", "calories": 450, "proteins": 18}}
    ],
    "lunch": [...2 options...],
    "dinner": [...2 options...],
    "snack": [...2 options...]
  }},
  ... repeat for Tuesday through Sunday
}}

Generate the plan now:
""")

# Chain: prompt → LLM → parse output
chain = prompt | llm | StrOutputParser()


def generate_diet_plan(user_preferences: dict) -> dict:
    """
    Agent 4: Generates personalized 7-day meal plan
    
    Args:
        user_preferences: Dictionary containing:
            - goals: List[str]
            - activity_level: str
            - gender: str
            - height: float
            - weight: float
            - target_weight: float
            - diet_type: str
            - medical_diet: List[str]
            - allergies: List[str]
            - preferred_cuisines: List[str]
    
    Returns:
        Dictionary with 7-day meal plan matching Flutter's expected format
    """
    
    print("\n" + "="*60)
    print("AGENT 4: DIET PLANNER STARTED")
    print("="*60)
    
    # Step 1: Calculate nutritional targets based on user data
    target_calories = calculate_daily_calories(
        weight=user_preferences["weight"],
        height=user_preferences["height"],
        activity_level=user_preferences["activity_level"],
        goal=user_preferences["goals"][0] if user_preferences["goals"] else "Eat Healthy"
    )
    
    target_protein = calculate_protein_target(
        weight=user_preferences["weight"],
        goal=user_preferences["goals"][0] if user_preferences["goals"] else "Eat Healthy"
    )
    
    print(f"\n Calculated Targets:")
    print(f"   Daily Calories: {target_calories} kcal")
    print(f"   Daily Protein: {target_protein}g")
    
    # Step 2: Format user preferences for the prompt
    preferences_text = format_preferences(user_preferences)
    
    print(f"\n User Preferences:")
    print(f"{preferences_text}")
    
    # Step 3: Call Gemini to generate the meal plan
    print(f"\n Calling Gemini to generate meal plan...")
    
    try:
        response = chain.invoke({
            "user_preferences": preferences_text,
            "target_calories": target_calories,
            "target_protein": target_protein
        })
        
        print(f"\n Gemini response received")
        
        # Step 4: Parse the JSON response
        clean_response = response.strip()
        if clean_response.startswith("```json"):
            clean_response = clean_response[7:]  # Remove ```json
        if clean_response.startswith("```"):
            clean_response = clean_response[3:]  
        if clean_response.endswith("```"):
            clean_response = clean_response[:-3]  
        
        clean_response = clean_response.strip()
        
        # Parse JSON
        weekly_meals = json.loads(clean_response)
        
        print(f"\n Successfully parsed meal plan")
        
        # Step 5: Convert to Flutter's expected format
        final_plan = convert_to_flutter_format(weekly_meals, target_calories, target_protein)
        
        print(f"\n Converted to Flutter format")
        print(f"   Generated {len(final_plan['weekly_plan'])} days")
        print("="*60)
        
        return final_plan
        
    except Exception as e:
        print(f"\n Error generating diet plan: {e}")
        # Return a fallback mock plan
        return create_fallback_plan()


def calculate_daily_calories(weight: float, height: float, activity_level: str, goal: str) -> int:
    """
    Calculate daily calorie target using simplified Harris-Benedict equation
    
    """
    # Base metabolic rate (simplified)
    bmr = 10 * weight + 6.25 * height - 5 * 25 + 5  # Assuming average age 25
    
    # Activity multipliers
    activity_multipliers = {
        "Sedentary (no exercise)": 1.2,
        "Lightly Active (1-3 days/week)": 1.375,
        "Moderately Active (3-5 days/week)": 1.55,
        "Very Active (6-7 days/week)": 1.725,
        "Extra Active (Physical Job/Athlete)": 1.9
    }
    
    multiplier = activity_multipliers.get(activity_level, 1.55)
    daily_calories = bmr * multiplier
    
    # Adjust based on goal
    if "Lose Weight" in goal:
        daily_calories *= 0.85  # 15% deficit
    elif "Build Muscle" in goal:
        daily_calories *= 1.1   # 10% surplus
    
    return int(daily_calories)


def calculate_protein_target(weight: float, goal: str) -> int:
    """
    Calculate daily protein target
    
    General guidelines:
    - Sedentary: 0.8g per kg
    - Active: 1.2-1.6g per kg
    - Muscle building: 1.8-2.2g per kg
    """
    if "Build Muscle" in goal:
        return int(weight * 2.0)
    elif "Lose Weight" in goal:
        return int(weight * 1.6)  # Higher protein for satiety
    else:
        return int(weight * 1.2)


def format_preferences(prefs: dict) -> str:
    """
    Convert user preferences dictionary into readable text for the LLM
    """
    text = f"""
Goals: {', '.join(prefs['goals'])}
Diet Type: {prefs['diet_type']}
Activity Level: {prefs['activity_level']}
Physical Stats: {prefs['gender']}, {prefs['height']}cm, {prefs['weight']}kg → Target: {prefs['target_weight']}kg
Medical Restrictions: {', '.join(prefs['medical_diet']) if prefs['medical_diet'] else 'None'}
Allergies/Exclusions: {', '.join(prefs['allergies']) if prefs['allergies'] else 'None'}
Preferred Cuisines: {', '.join(prefs['preferred_cuisines'])}
    """
    return text.strip()


def convert_to_flutter_format(weekly_meals: dict, target_calories: int, target_protein: int) -> dict:
    """
    Converts Gemini's output to match Flutter's DietPlanResponse model
    
    Input format (from Gemini):
    {
        "Monday": {
            "breakfast": [{"name": "...", "calories": 300, "proteins": 10}, ...],
            ...
        },
        ...
    }
    
    Output format (for Flutter):
    {
        "generated_date": "2025-01-17T10:30:00",
        "weekly_plan": [
            {
                "day_name": "Monday",
                "total_calories": 2000,
                "total_protein": 150,
                "meals": { "breakfast": [...], "lunch": [...], "dinner": [...], "snack": [...] }
            },
            ...
        ]
    }
    """
    
    days_order = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    weekly_plan = []
    
    for day_name in days_order:
        if day_name not in weekly_meals:
            print(f"⚠️  Warning: {day_name} not in generated plan, skipping")
            continue
        
        day_meals = weekly_meals[day_name]
        
        # Calculate actual totals from the meals
        day_calories = 0
        day_protein = 0
        
        # Sum up first option of each meal type (user can swap later)
        for meal_type in ["breakfast", "lunch", "dinner", "snack"]:
            if meal_type in day_meals and len(day_meals[meal_type]) > 0:
                day_calories += day_meals[meal_type][0]["calories"]
                day_protein += day_meals[meal_type][0]["proteins"]
        
        day_plan = {
            "day_name": day_name,
            "total_calories": day_calories,
            "total_protein": day_protein,
            "meals": day_meals
        }
        
        weekly_plan.append(day_plan)
    
    return {
        "generated_date": datetime.now().isoformat(),
        "weekly_plan": weekly_plan
    }


def create_fallback_plan() -> dict:
    """
    Creates a basic fallback plan if Gemini fails
    This ensures the app doesn't crash
    """
    
    print("\n  Using fallback plan")
    
    days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    weekly_plan = []
    
    for day in days:
        day_plan = {
            "day_name": day,
            "total_calories": 2000,
            "total_protein": 150,
            "meals": {
                "breakfast": [
                    {"name": f"{day} Oats with berries", "calories": 500, "proteins": 20},
                    {"name": f"{day} Eggs and toast", "calories": 450, "proteins": 25}
                ],
                "lunch": [
                    {"name": "Grilled chicken salad", "calories": 700, "proteins": 50},
                    {"name": "Dal and rice", "calories": 650, "proteins": 40}
                ],
                "dinner": [
                    {"name": "Paneer curry with roti", "calories": 600, "proteins": 35},
                    {"name": "Fish with vegetables", "calories": 550, "proteins": 40}
                ],
                "snack": [
                    {"name": "Almonds", "calories": 200, "proteins": 8},
                    {"name": "Greek yogurt", "calories": 150, "proteins": 15}
                ]
            }
        }
        weekly_plan.append(day_plan)
    
    return {
        "generated_date": datetime.now().isoformat(),
        "weekly_plan": weekly_plan
    }
