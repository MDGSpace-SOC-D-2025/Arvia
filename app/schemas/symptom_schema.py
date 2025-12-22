from pydantic import BaseModel
from typing import Optional

class SymptomRequest(BaseModel):
    symptoms: str

class SymptomResponse(BaseModel):
    answer: str
    disclaimer: str
    original_query: Optional[str] = None      # What user typed   Optional, can be None
    refined_query: Optional[str] = None       # What Agent-1 extracted
    needs_clarification: Optional[bool] = False  # If query was too vague