"""
Tests the actual HTTP API endpoint
"""
import requests

BASE_URL = "http://localhost:8000"

print("="*60)
print("API ENDPOINT TEST")
print("="*60)

# Test 1: Without location
print("\n[TEST 1] API Call - No Location")
print("-"*60)

response = requests.post(
    f"{BASE_URL}/check-symptoms",
    json={"symptoms": "I have fever and headache"}
)

print(f"Status Code: {response.status_code}")
data = response.json()
print(f"Severity: {data['severity']}")
print(f"Needs Doctor: {data['needs_doctor']}")
print(f"Doctors Found: {len(data.get('doctors_nearby', []))}")

# Test 2: With location
print("\n[TEST 2] API Call - With Location")
print("-"*60)

response = requests.post(
    f"{BASE_URL}/check-symptoms",
    json={
        "symptoms": "chest pain since morning",
        "latitude": 30.7333,
        "longitude": 76.7794
    }
)

print(f"Status Code: {response.status_code}")
data = response.json()
print(f"Severity: {data['severity']}")
print(f"Recommended: {data.get('recommended_specialization')}")
print(f"Doctors Found: {len(data.get('doctors_nearby', []))}")

if data.get('doctors_nearby'):
    print("\nNearby Hospitals:")
    for doc in data['doctors_nearby'][:3]:
        print(f"  - {doc['name']}")

print("\n" + "="*60)
print("API TESTS COMPLETED")
print("="*60)