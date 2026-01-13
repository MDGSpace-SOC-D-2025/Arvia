from typing import Dict, List
from datetime import datetime

# empty at the start
conversation_history: Dict[str, List[Dict]] = {}

def add_to_history(session_id: str, user_input: str, response: dict):
    """
    
    Args:
        session_id: Which user's file to write in (like "user_abc123")
        user_input: What the user said (like "I have a headache")
        response: What our system responded (the full analysis result)
    """
    
    # Step 1: If this user doesn't have a file yet, create one
    if session_id not in conversation_history:
        conversation_history[session_id] = []  # Empty list = new file
        print(f" Created new file for session: {session_id}")
    
    # Step 2:  "page" to add to their file
    conversation_turn = {
        "timestamp": datetime.now().isoformat(),  # When did they say this?
        "user_input": user_input,                 # Original words
        "symptoms": response["refined_query"],    # Medical terms
        "severity": response["severity"]          # How serious
    }
    
    # Step 3: Add this page to their file
    conversation_history[session_id].append(conversation_turn)
    print(f" Added to history: {user_input}")

def get_history(session_id: str) -> List[Dict]:
     """
     Retrieves conversation history for a user.
    
    Think of this as: "Open the user's file and show me what's inside"
    
    Args:
        session_id: Which user's file to read
        
    Returns:
        List of conversation turns (could be empty if user is new)
    """
    
    # If user has no file yet, return empty list
    # This is safe - won't crash if session_id doesn't exist
     return conversation_history.get(session_id, [])


def format_history_for_llm(session_id: str) -> str:   # converting Python data into natural language
    """
    Converts conversation history into a readable format for the LLM.
    
    
    The LLM needs context in natural language, not Python dictionaries!
    
    Args:
        session_id: Which user's history to format
        
    Returns:
        A string that can be added to the LLM prompt
    """
    
    # Get the user's history
    history = get_history(session_id)
    
    # If no history, return empty string (no context needed)
    if not history:
        return ""
    
    # Start building the context string
    context = "\n=== Previous Conversation ===\n"
    
    # We only want the LAST 3 conversations (not overwhelming the LLM)
    recent_history = history[-3:]  # Python list slicing: last 3 items
    
    for turn in recent_history:
        # Format each conversation turn nicely
        context += f"• [{turn['timestamp']}] User reported: '{turn['symptoms']}' "
        context += f"(Severity: {turn['severity']})\n"
    
    context += "=== End of Previous Conversation ===\n\n"
    
    return context