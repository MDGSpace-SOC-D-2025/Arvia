from app.rag.retrieval_service import retrieve_relevant_documents

from app.rag.generation_service import generate_answer


def analyze_symptoms(user_input: str): #(to be changed later)
    # Step 1: Retrieve relevant documents
    retrieved_docs = retrieve_relevant_documents(user_input)

    # Step 2: Generate response using retrieved context
    answer = generate_answer(user_input, retrieved_docs)

    return {
        "answer": answer,
        "disclaimer": "This is not a medical diagnosis."
    }

