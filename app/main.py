from fastapi import FastAPI
from app.routes.symptom import router as symptom_router
from app.routes.diet import router as diet_router

app = FastAPI()

@app.get("/")
def health():
    return {"status": "backend alive"}

app.include_router(symptom_router)
app.include_router(diet_router)  # generate-diet-plan