"""
Complete pipeline test - tests all 3 agents together
"""

print("="*60)
print("COMPLETE PIPELINE TEST")
print("="*60)

# Test Case 1: MILD symptoms (no location needed)
print("\n[TEST 1] MILD Case - No Doctor Needed")
print("-"*60)

from app.services.symptom_service import analyze_symptoms

result = analyze_symptoms("I have a mild headache")

print(f"Symptom: mild headache")
print(f"Severity: {result['severity']}")
print(f"Needs Doctor: {result['needs_doctor']}")
print(f"Recommended Spec: {result['recommended_specialization']}")
print(f"Doctors Found: {len(result['doctors_nearby'])}")
print(f"\nAnswer Preview: {result['answer'][:100]}...")

# Test Case 2: SEVERE symptoms (no location)
print("\n\n[TEST 2] SEVERE Case - No Location Provided")
print("-"*60)

result = analyze_symptoms("severe chest pain and difficulty breathing")

print(f"Symptom: severe chest pain")
print(f"Severity: {result['severity']}")
print(f"Needs Doctor: {result['needs_doctor']}")
print(f"Recommended Spec: {result['recommended_specialization']}")
print(f"Doctors Found: {len(result['doctors_nearby'])}")
print(f"\nAnswer Preview: {result['answer'][:150]}...")

# Test Case 3: MODERATE symptoms WITH location
print("\n\n[TEST 3] MODERATE Case - With Location")
print("-"*60)

location = {
    "latitude": 30.7333,
    "longitude": 76.7794
}

result = analyze_symptoms("chest pain since yesterday", location)

print(f"Symptom: chest pain")
print(f"Location: Chandigarh")
print(f"Severity: {result['severity']}")
print(f"Needs Doctor: {result['needs_doctor']}")
print(f"Recommended Spec: {result['recommended_specialization']}")
print(f"Doctors Found: {len(result['doctors_nearby'])}")

if result['doctors_nearby']:
    print(f"\nNearby Hospitals:")
    for i, doc in enumerate(result['doctors_nearby'][:3], 1):
        print(f"  {i}. {doc['name']} - {doc['distance']}m away")

print("\n" + "="*60)
print("ALL TESTS COMPLETED")
print("="*60)