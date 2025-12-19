#convert dictionary data into documents/text for RAG ingestion,returns list
from app.data.symptom_data import SYMPTOM_DB

def build_documents():
    documents = []

    for symptom, info in SYMPTOM_DB.items():
        text = (
            f"Symptom: {symptom}. "
            f"Possible causes: {', '.join(info['possible_causes'])}. "
            f"Recommended doctor: {info['doctor']}. "
            f"Self care tips: {', '.join(info['self_care'])}."
        )
        documents.append(text)

    return documents
