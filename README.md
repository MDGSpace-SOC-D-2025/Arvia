# ARVIA HEALTH - AI-Powered Health & Wellness Platform

## Description / Overview
Arvia Health is a comprehensive mobile health application that combines AI-powered symptom analysis with personalized nutrition planning. The platform consists of a Flutter mobile app and a FastAPI backend, leveraging advanced AI models and retrieval-augmented generation (RAG) to provide intelligent health recommendations.

---

## Features

### 1. Symptom Checker

**Multi-Agent AI System: Three specialized AI agents:**
- **Agent 1 (Query Refiner):** Converts casual symptom descriptions into precise medical terminology  
- **Agent 2 (Severity Assessor):** Classifies symptoms into MILD, MODERATE, or SEVERE categories using evidence-based medical criteria  
- **Agent 3 (Doctor Finder):** Locates nearby hospitals and recommends appropriate medical specialists  

**Context-Aware Analysis:**
- Session-based conversation memory for tracking symptom progression  
- RAG system with vector database (FAISS) containing medical knowledge  
- Severity-specific UI responses with color-coded urgency indicators  

**Location-Based Services:**
- Real-time GPS integration for finding nearby hospitals  
- Integration with Mappls API (Indian mapping service)  
- Distance-based hospital recommendations with specialization filtering  

**Smart Recommendations:**
- Home remedies for mild symptoms extracted from medical knowledge base  
- Urgent care instructions for severe symptoms  
- Specialist recommendations based on symptom analysis  

---

### 2. Personalised Diet Planner

**Comprehensive Onboarding: Collects user data including:**
- Health goals (weight loss, muscle gain, disease prevention, etc.)  
- Physical stats (height, weight, target weight, activity level)  
- Dietary preferences (Vegan, Vegetarian, Keto, Mediterranean, etc.)  
- Medical restrictions (Diabetes, Low-FODMAP, Anti-inflammatory, etc.)  
- Allergies and food exclusions  
- Preferred cuisines  

**AI-Generated Meal Plans:**
- Agent 4 (Diet Planner) powered by Gemini 2.5 Flash  
- Personalized 7-day meal plans with calculated calorie and protein targets  
- Two meal options per meal type (breakfast, lunch, dinner, snack) for variety  
- Respects all dietary restrictions and preferences  

**Interactive Meal Management:**
- Instant meal swapping functionality  
- Daily calorie and protein tracking  
- Weekly plan overview  
- Persistent storage with SharedPreferences  

---

## Tech Stack

### Backend Stack
- **Framework:** FastAPI (Python)  

**AI/ML:**
- **LLM:** Google Gemini 2.5 Flash via LangChain  
- **Vector Database:** FAISS with HuggingFace embeddings (all-MiniLM-L6-v2, 384 dimensions)  
- **RAG Framework:** LangChain for document retrieval and generation  

- **APIs:** Mappls API for location services  
- **State Management:** In-memory conversation history with session-based persistence  

### Frontend Stack
- **Framework:** Flutter/Dart  
- **State Management:** BLoC (Business Logic Component) pattern  
- **Location Services:** Geolocator package  
- **Persistent Storage:** SharedPreferences  
- **HTTP Client:** http package for API communication  

---

## Installation

### Prerequisites
- Python with pip  
- Flutter with Dart SDK  
- Android Studio (for mobile development)  
- Google API Key (for Gemini AI)  
- Mappls API Credentials (for location services)  

---

## Usage

### Starting the Backend
- Activate virtual environment  
- Run FastAPI server  

### Symptom Checker Flow
- Tap "Symptom Checker" on home screen  
- Enter symptoms in natural language (e.g., "headache and fever since 2 days")  
- View AI analysis with severity assessment  
- For moderate/severe cases, tap "Find Nearby Doctors" to get location-based recommendations  

### Diet Planner Flow
- Tap "Diet Planner" on home screen  
- Complete 8-step onboarding questionnaire  
- Receive personalized 7-day meal plan  
- Swap meals using the "Swap" button for variety  
- View weekly plan overview  

---

## Configuration / Environment Variables

### Backend Environment Variables
- `.env` file contains the Mappls location api  

- **Google Gemini API:** from Google AI Studio  
- **Mappls API:** from Mappls Developer Portal  

### Backend URL
Located in `frontend/lib/features/symptom_check/data/repositories/symptom_repository.dart`

---

## Screenshots / Demo

### Symptom Checker
<img width="271" height="603" alt="image" src="https://github.com/user-attachments/assets/f9cc6b1e-2918-42a9-bc6e-90486a320bdc" />
<img width="271" height="602" alt="image" src="https://github.com/user-attachments/assets/b372e168-721b-450c-9615-5e217f54fc45" />
<img width="271" height="602" alt="image" src="https://github.com/user-attachments/assets/55fc68f5-c581-4d17-8557-12190e616547" />
<img width="271" height="371" alt="image" src="https://github.com/user-attachments/assets/b30dfd60-955d-4e5f-85f3-4c76f2a497a4" />

### Diet Planner
<img width="271" height="600" alt="image" src="https://github.com/user-attachments/assets/b41e5b83-5f27-4558-a0cc-5beaabb7819d" />
<img width="271" height="600" alt="image" src="https://github.com/user-attachments/assets/7c15870a-6453-4668-bf72-60a42cc5fe4e" />
<img width="271" height="600" alt="image" src="https://github.com/user-attachments/assets/a0e1df4d-729d-4dca-b4ea-dfbb543fb6c6" />
<img width="271" height="600" alt="image" src="https://github.com/user-attachments/assets/552a0084-52bc-4f41-93ff-4fe944a7a134" />
<img width="271" height="600" alt="image" src="https://github.com/user-attachments/assets/ed1a906a-c505-4ee8-986d-48f1e6ae05af" />
<img width="271" height="600" alt="image" src="https://github.com/user-attachments/assets/0a859f15-dc81-446f-8be3-9767c2ffb613" />
<img width="271" height="600" alt="image" src="https://github.com/user-attachments/assets/fb3c2538-df13-4ea0-a07f-864d5153c529" />
<img width="271" height="600" alt="image" src="https://github.com/user-attachments/assets/d8e77c9c-ce16-4603-9f04-5c45d9b0a9eb" />

---

## Project Structure

### BACKEND
app/ # Backend (FastAPI)
│ ├── agents/ # AI Agents
│ │ ├── query_refiner.py # Agent 1: Symptom refinement
│ │ ├── severity_assessor.py # Agent 2: Severity classification
│ │ ├── doctor_finder.py # Agent 3: Hospital finder
│ │ └── diet_planner.py # Agent 4: Meal plan generator
│ ├── rag/ # RAG System
│ │ ├── indexing.py # Vector store loader
│ │ ├── generation_service.py # Answer generation
│ │ └── document_builder.py # (Legacy - not used)
│ ├── services/ # Business Logic
│ │ ├── symptom_service.py # Symptom analysis orchestration
│ │ ├── memory_service.py # Conversation history
│ │ └── diet_service.py # Diet plan generation
│ ├── routes/ # API Endpoints
│ │ ├── symptom.py # Symptom checker endpoint
│ │ └── diet.py # Diet planner endpoint
│ ├── schemas/ # Pydantic Models
│ │ ├── symptom_schema.py # Request/Response models
│ │ └── diet_schema.py # Diet plan models
│ ├── data/ # Static Data
│ │ └── symptom_data.py # Demo symptom data
│ ├── test_files/ # Testing Scripts
│ └── main.py # FastAPI app entry point

### FRONTEND
frontend/
├── lib/ # Frontend (Flutter)
│ ├── features/
│ │ ├── symptom_check/ # Symptom Checker Feature
│ │ │ ├── bloc/
│ │ │ ├── data/
│ │ │ └── presentation/
│ │ ├── onboarding/ # Diet Planner Feature
│ │ │ ├── bloc/
│ │ │ ├── models/
│ │ │ ├── screens/
│ │ │ └── services/
│ │ └── home/
│ ├── core/
│ │ └── services/
│ └── main.dart


---

## Roadmap

### Phase 1: Core Enhancements
- User authentication and profile management  
- Medication tracking and reminders  
- Voice input for symptoms  

### Phase 2: Advanced Health Features
- Appointment booking system with doctors  
- Sleep tracking and recommendations  
- Water intake reminders  

### Phase 3: Diet Planner Enhancements
- Recipe instructions with step-by-step guides  
- Meal prep suggestions for weekly planning  
- Integration with food delivery services  

### Phase 4: AI & Analytics
- Predictive health insights based on history  
- Family health profiles  
- Symptom trend analysis over time  
- AI-powered chatbot for general health queries  

### Phase 5: Community & Social
- Achievement badges and gamification  
- Share meal plans with family  

---

## Known Issues

### Current Limitations
- Conversation memory is in-memory only (resets on server restart)  
- No user authentication  
- Session persistence limited to single app session  
- iOS testing not complete (only tested on Android)  
- Need to work on UI design  
