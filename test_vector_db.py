print("Testing Vector Database...\n")

# Test 1: Can we load the vector store?
print("[1] Loading vector store...")
try:
    from app.rag.indexing import SYMPTOM_VECTOR_STORE
    print(f"✓ Loaded successfully")
    print(f"✓ Contains {SYMPTOM_VECTOR_STORE.index.ntotal} vectors\n")
except Exception as e:
    print(f"✗ Failed: {e}\n")
    exit(1)

# Test 2: Can we search for symptoms?
print("[2] Testing search...")
retriever = SYMPTOM_VECTOR_STORE.as_retriever(search_kwargs={"k": 2})

query = "headache"
results = retriever.invoke(query)
print(f"✓ Searched for '{query}'")
print(f"✓ Found {len(results)} documents")
print(f"Preview: {results[0].page_content[:80]}...\n")

# Test 3: Can RAG generate answers?
print("[3] Testing RAG generation...")
from app.rag.generation_service import generate_answer

answer = generate_answer("I have fever")
print(f"✓ Generated answer")
print(f"Preview: {answer[:100]}...\n")

# Test 4: Full pipeline test
print("[4] Testing full pipeline...")
from app.services.symptom_service import analyze_symptoms

result = analyze_symptoms("headache and fever")
print(f"✓ Pipeline working")
print(f"Severity: {result['severity']}")
print(f"Needs doctor: {result['needs_doctor']}\n")

print("="*60)
print("ALL TESTS PASSED ✓")
print("="*60)
print("\nNext: Run 'uvicorn app.main:app --reload'")