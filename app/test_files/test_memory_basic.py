# app/test_files/test_memory_basic.py

from app.services.memory_service import add_to_history, conversation_history

print("="*60)
print("TESTING MEMORY - STEP BY STEP")
print("="*60)

# Simulate User A's conversation
print("\n[USER A's Conversation]")
print("-"*60)

# First message from User A
add_to_history(
    session_id="user_A",
    user_input="I have a headache",
    response={"refined_query": "headache", "severity": "MILD"}
)

# Check what's stored
print(f"User A's file now has {len(conversation_history['user_A'])} entries")
print(f"First entry: {conversation_history['user_A'][0]}")

# Second message from User A
print("\n5 minutes later...")
add_to_history(
    session_id="user_A", 
    user_input="It's getting worse",
    response={"refined_query": "severe headache", "severity": "MODERATE"}
)

print(f"User A's file now has {len(conversation_history['user_A'])} entries")

# Simulate User B's conversation (different person!)
print("\n\n[USER B's Conversation - Separate Person]")
print("-"*60)

add_to_history(
    session_id="user_B",
    user_input="I have fever",
    response={"refined_query": "fever", "severity": "MILD"}
)

# Show both files are separate
print("\n\n[FINAL STATE - Two Separate Files]")
print("-"*60)
print(f"User A has {len(conversation_history['user_A'])} messages")
print(f"User B has {len(conversation_history['user_B'])} messages")
print(f"\nUser A's history: {conversation_history['user_A']}")
print(f"\nUser B's history: {conversation_history['user_B']}")

print("\n" + "="*60)
print("TEST COMPLETE - Memory is working!")
print("="*60)

