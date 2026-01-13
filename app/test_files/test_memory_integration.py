# app/test_files/test_memory_integration.py

"""
Tests the complete memory system through the service layer
"""

from app.services.symptom_service import analyze_symptoms

print("="*60)
print("TESTING MEMORY INTEGRATION")
print("="*60)

# Conversation 1: New user (no session_id)
print("\n[CONVERSATION 1: New User]")
print("-"*60)

result1 = analyze_symptoms("I have a mild headache")

print(f"Symptoms: mild headache")
print(f"Severity: {result1['severity']}")
print(f"Session ID: {result1['session_id']}")

# Save the session_id for next request (simulating frontend behavior)
session_id = result1['session_id']

# Conversation 2: Same user returns (with session_id)
print("\n\n[CONVERSATION 2: User Returns - 5 Minutes Later]")
print("-"*60)

result2 = analyze_symptoms(
    "It's getting worse now",
    session_id=session_id  # Use the session_id from first request!
)

print(f"Symptoms: worse now")
print(f"Severity: {result2['severity']}")
print(f"Session ID: {result2['session_id']}")
print(f"Same session? {result2['session_id'] == session_id}")

# Conversation 3: Even worse!
print("\n\n[CONVERSATION 3: User Returns Again]")
print("-"*60)

result3 = analyze_symptoms(
    "Now I have fever too",
    session_id=session_id
)

print(f"Symptoms: fever too")
print(f"Severity: {result3['severity']}")
print(f"Session ID: {result3['session_id']}")

# Show the conversation history that's being tracked
print("\n\n[MEMORY CHECK]")
print("-"*60)
from app.services.memory_service import get_history

history = get_history(session_id)
print(f"Total conversations stored: {len(history)}")
print("\nConversation timeline:")
for i, turn in enumerate(history, 1):
    print(f"{i}. '{turn['user_input']}' → {turn['severity']}")

print("\n" + "="*60)
print("MEMORY INTEGRATION TEST COMPLETE!")
print("="*60)