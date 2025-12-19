from pydantic import BaseModel

class SymptomRequest(BaseModel):
    symptoms: str

class SymptomResponse(BaseModel):
    answer: str
    disclaimer: str
