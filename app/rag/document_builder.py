# NOTE: This file is NOT USED anymore
# We now load pre-built vectors from .faiss and .pkl files
# Keeping this for reference only

from langchain_core.documents import Document
from app.data.symptom_data import SYMPTOM_DB

def build_documents():
    """
    OLD METHOD - Creates documents from small demo data
    Not used in production (we use pre-built vectors now)
    """
    docs = []
    for symptom, info in SYMPTOM_DB.items():
        text = (
            f"Symptom: {symptom}. "
            f"Possible causes: {', '.join(info['possible_causes'])}. "
            f"Recommended doctor: {info['doctor']}. "
            f"Self care tips: {', '.join(info['self_care'])}."
        )
        doc = Document(page_content=text, metadata={"symptom": symptom})
        docs.append(doc)
    return docs