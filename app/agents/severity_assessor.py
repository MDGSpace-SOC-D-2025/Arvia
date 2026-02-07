from langchain_google_genai import ChatGoogleGenerativeAI
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser

# Separate Gemini instance for severity assessment
# Different job from Agent-1, so separate config
llm = ChatGoogleGenerativeAI(
    model="gemini-3-flash-preview",  # Latest stable model with good free tier
    temperature=0.1 ,
    google_api_key="AIzaSyC1RV_FxY6MIASI0oWlOJjwZWRCaFmJcuI"

)

# Prompt teaches Gemini how to assess severity
prompt = ChatPromptTemplate.from_template("""
You are a medical triage assistant trained to assess symptom severity using evidence-based criteria. Your role is to help users understand when they need immediate care, scheduled care, or can manage at home.

SYMPTOMS TO ANALYZE:
{symptoms}

SEVERITY CLASSIFICATION CRITERIA:

**SEVERE (Immediate medical attention required)**
These are RED FLAG symptoms that indicate potential life-threatening conditions:

Cardiac/Respiratory:
- Chest pain (especially with radiation to arm/jaw, sweating, or difficulty breathing)
- Severe difficulty breathing or shortness of breath at rest
- Sudden severe headache (worst headache of life)
- Sudden confusion, slurred speech, or facial drooping (stroke signs)
- Coughing up blood

Neurological:
- Loss of consciousness or severe altered mental state
- Seizures (new onset or prolonged)
- Sudden vision loss or severe vision changes
- Severe dizziness with inability to walk

Trauma/Emergency:
- Severe bleeding that won't stop
- Suspected broken bones with deformity
- Severe burns covering large areas
- Severe allergic reaction (difficulty breathing, swelling of throat/face)

Pain Scale:
- Pain rated 8-10/10 with sudden onset
- Severe abdominal pain (especially if rigid abdomen)

Duration/Onset:
- Sudden onset (within minutes to hours) of severe symptoms
- Rapidly worsening symptoms

**MODERATE (See doctor within 24-48 hours)**
These symptoms need professional evaluation but are not immediately life-threatening:

Infections:
- Fever >101°F (38.3°C) lasting more than 3 days
- Persistent cough for >2 weeks
- Symptoms of urinary tract infection (burning, frequency, fever)
- Ear pain with fever

Pain:
- Moderate pain (5-7/10) that persists despite over-the-counter medication
- New joint pain with swelling
- Back pain with numbness or tingling

Digestive:
- Persistent vomiting/diarrhea for >2 days
- Blood in stool or black tarry stools
- Persistent abdominal pain (not severe)

General:
- Unexplained weight loss (>10 lbs in a month)
- New or worsening chronic symptoms
- Rash with fever
- Symptoms interfering with daily activities

**MILD (Self-care appropriate)**
Common conditions that typically resolve with home care:

Common Cold/Flu:
- Mild fever <101°F for 1-2 days
- Runny nose, mild congestion
- Mild sore throat without difficulty swallowing
- Mild cough without blood

Minor Aches:
- Tension headache (4/10 or less, responds to rest/OTC meds)
- Muscle soreness after exercise
- Minor sprains without severe swelling

Digestive:
- Mild indigestion or heartburn
- Mild nausea without persistent vomiting
- Occasional constipation

Skin:
- Minor cuts, scrapes
- Small rash without fever or spreading
- Dry skin, minor irritation

KEY ASSESSMENT FACTORS:
1. Onset: Sudden/rapid = higher severity
2. Duration: Persistent or worsening = higher concern
3. Intensity: Use patient's pain scale (8-10 = severe, 5-7 = moderate, 1-4 = mild)
4. Red Flags: Presence of any red flag symptom = SEVERE
5. Functional Impact: Can't perform normal activities = at least MODERATE
6. Combination: Multiple moderate symptoms together may indicate MODERATE/SEVERE

IMPORTANT RULES:
- If ANY red flag is present → classify as SEVERE
- If symptom persists >3 days without improvement → upgrade from MILD to MODERATE
- When uncertain between two levels, choose the MORE conservative (higher severity)
- Consider patient's description of severity seriously
- Headache alone is usually MILD unless it's "worst headache ever" or with other symptoms

HANDLING MISSING PAIN SCALE:
- If user mentions "severe", "unbearable", "worst pain ever" → infer 8-10/10
- If user mentions "moderate", "pretty bad", "hurts a lot" → infer 5-7/10
- If user mentions "mild", "slight", "minor" → infer 1-4/10
- If no severity mentioned, assess based on other factors (red flags, duration, function impact)
- You can work with descriptive terms - don't require numeric pain scale

OUTPUT FORMAT (you must follow exactly):
SEVERITY: [MILD/MODERATE/SEVERE]
REASON: [Specific reasoning based on the criteria above - mention which factors led to this classification]
DOCTOR_NEEDED: [yes/no]
KEY_FACTORS: [List 2-3 key factors that influenced the decision]

Now assess these symptoms:
""")

chain = prompt | llm | StrOutputParser()


def assess_severity(symptoms: str) -> dict:
    """
    Analyzes symptoms and returns severity assessment.
    
    Args:
        symptoms: Refined symptoms from Agent-1
        
    Returns:
        dict with severity, reasoning, needs_doctor flag
    """
    try:
        result = chain.invoke({"symptoms": symptoms})
        
        # Parse the response
        severity = "MODERATE"  # default
        reasoning = ""
        needs_doctor = False
        key_factors = []
        
        # Extract severity level
        if "SEVERITY:" in result:
            severity_line = result.split("SEVERITY:")[1].split("\n")[0].strip()
            if "MILD" in severity_line.upper() and "SEVERE" not in severity_line.upper():
                severity = "MILD"
            elif "SEVERE" in severity_line.upper():
                severity = "SEVERE"
            elif "MODERATE" in severity_line.upper():
                severity = "MODERATE"
        
        # Extract reasoning
        if "REASON:" in result:
            reason_section = result.split("REASON:")[1]
            if "DOCTOR_NEEDED:" in reason_section:
                reasoning = reason_section.split("DOCTOR_NEEDED:")[0].strip()
            elif "KEY_FACTORS:" in reason_section:
                reasoning = reason_section.split("KEY_FACTORS:")[0].strip()
            else:
                reasoning = reason_section.strip()
        
        # Extract key factors
        if "KEY_FACTORS:" in result:
            factors_section = result.split("KEY_FACTORS:")[1].strip()
            # Parse the factors (could be bullet points or comma-separated)
            key_factors = [f.strip().strip('-•').strip() for f in factors_section.split('\n') if f.strip()]
            if not key_factors:  # Try comma-separated
                key_factors = [f.strip() for f in factors_section.split(',') if f.strip()]
        
        # Determine if doctor needed
        needs_doctor = severity in ["MODERATE", "SEVERE"]
        
        return {
            "severity": severity,
            "reasoning": reasoning,
            "needs_doctor": needs_doctor,
            "key_factors": key_factors[:3],  # Limit to top 3 factors
            "raw_response": result  # Keep for debugging
        }
        
    except Exception as e:
        print(f"Severity assessment error: {e}")
        # Safe fallback - assume needs doctor if error
        return {
            "severity": "MODERATE",
            "reasoning": "Unable to assess, recommend medical consultation",
            "needs_doctor": True,
            "key_factors": [],
            "raw_response": ""
        }