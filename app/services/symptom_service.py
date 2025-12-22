from app.rag.generation_service import generate_answer
from app.agents.query_refiner import refine_query

def analyze_symptoms(user_input: str):
    """
    Main analysis function with query refinement.
    
    Flow: User input → Agent refines → RAG generates → Return response
    TODO: Add severity assessment and doctor finder routing
    """
    
    # Refine the query first (casual → medical terms)
    refined = refine_query(user_input)
    
    # Use refined query for RAG (better retrieval)
    answer = generate_answer(refined["refined_query"])
    
    return {
        "answer": answer,
        "original_query": refined["original_query"],
        "refined_query": refined["refined_query"],
        "needs_clarification": refined["needs_clarification"],
        "disclaimer": "This is not a medical diagnosis. Consult a healthcare professional."
    }