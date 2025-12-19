def generate_answer(user_query: str, retrieved_docs: list):
    """
    This function represents the LLM generation step.
    For now, it returns a dummy response using retrieved context.
    """

    if not retrieved_docs:
        return "I could not find relevant medical information for your symptoms."

    # Take the most relevant document
    top_doc = retrieved_docs[0]["document"]  #(retrival ranked documents by similarity, 0 idx means most relevant)


    response = (
        f"Based on the available medical information: {top_doc}. "
        f"It is advised to consult a healthcare professional if symptoms persist."
    )

    return response
