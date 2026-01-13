# app/test_files/test_memory_retrieval.py

from app.services.memory_service import (
    add_to_history, 
    get_history, 
    format_history_for_llm
)

print("="*60)
print("TESTING MEMORY RETRIEVAL")
print("="*60)

# Simulate a conversation with User A
print("\n[Building User A's History]")
print("-"*60)

add_to_history(
    "user_A",
    "I have a headache",
    {"refined_query": "headache", "severity": "MILD"}
)

add_to_history(
    "user_A",
    "It's getting worse",
    {"refined_query": "severe headache", "severity": "MODERATE"}
)

add_to_history(
    "user_A",
    "Now I have fever too",
    {"refined_query": "severe headache with fever", "severity": "MODERATE"}
)

# Test 1: Get raw history
print("\n[Test 1: Raw History]")
print("-"*60)
history = get_history("user_A")
print(f"User A has {len(history)} conversation turns")
print(f"\nFirst turn: {history[0]}")

# Test 2: Get formatted history for LLM
print("\n[Test 2: Formatted for LLM]")
print("-"*60)
formatted = format_history_for_llm("user_A")
print(formatted)

# Test 3: New user with no history
print("\n[Test 3: New User (No History)]")
print("-"*60)
new_user_history = get_history("user_Z")
print(f"User Z history: {new_user_history}")
formatted_new = format_history_for_llm("user_Z")
print(f"Formatted (should be empty): '{formatted_new}'")

print("\n" + "="*60)
print("RETRIEVAL TESTS COMPLETE!")
print("="*60)