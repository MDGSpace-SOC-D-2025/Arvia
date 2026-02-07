from langchain_google_genai import ChatGoogleGenerativeAI
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser

llm = ChatGoogleGenerativeAI(
    model="gemini-3-flash-preview",  # Latest stable model with good free tier
    temperature=0.1 ,
    google_api_key="AIzaSyC1RV_FxY6MIASI0oWlOJjwZWRCaFmJcuI"

)

# Teaching Gemini to extract symptoms and mark vague inputs
# NOW with conversation history support for better context understanding
prompt = ChatPromptTemplate.from_template("""
Extract medical symptoms from user input.

{history_context}

Current user input: "{user_input}"

INSTRUCTIONS:
- If there's previous conversation history above, use it to understand context
- Example: If user said "headache" before and now says "worse", refine to "worsening headache"
- If input is vague (like "not feeling well") and no history, start with [VAGUE]
- If specific symptoms mentioned, extract them

Examples:
- "my head hurts" → headache
- "not feeling well" → [VAGUE] general malaise
- "stomach pain and nausea" → abdominal pain, nausea
- Previous: "headache", Current: "it's worse" → worsening headache

Extract:
""")

chain = prompt | llm | StrOutputParser()


def refine_query(user_input: str, history_context: str = "") -> dict:
    """
    Refines user query into medical terms, now with conversation history support.
    
    Args:
        user_input: What the user just said
        history_context: Formatted conversation history (empty if new conversation)
    """
    try:
        # pass both user input and history context to the LLM
        result = chain.invoke({
            "user_input": user_input,
            "history_context": history_context
        })
        
        # Check if vague
        is_vague = result.startswith("[VAGUE]")
        
        # Clean up the result
        if is_vague:
            result = result.replace("[VAGUE]", "").strip()
        
        return {
            "refined_query": result,
            "original_query": user_input,
            "needs_clarification": is_vague
        }
    except Exception as e:         # ensures system does not crash on errors
        print(f"Error: {e}")
        return {
            "refined_query": user_input,
            "original_query": user_input,
            "needs_clarification": False
        }


def extract_symptoms_structured(user_input: str) -> dict:
    """
    Extracts structured symptom data from user input.
    Note: Not used in main pipeline, kept for backwards compatibility
    """
    refined = refine_query(user_input)
    text = refined["refined_query"]
    
    # Simple parsing   (extracting text)
    symptoms = []
    duration = None
    severity = None
    # extract duration and severity if mentioned
    if "duration:" in text:
        parts = text.split("duration:")
        symptoms_part = parts[0]
        duration = parts[1].split(",")[0].strip() if len(parts) > 1 else None
    else:
        symptoms_part = text
    
    if "severity:" in text:
        idx = text.index("severity:") + len("severity:")
        severity = text[idx:].strip()
    
    # for extracting symptoms list
    symptoms = [s.strip() for s in symptoms_part.split(",") if s.strip()]
    
    return {
        "symptoms": symptoms,
        "duration": duration,
        "severity": severity,
        "refined_query": text
    }