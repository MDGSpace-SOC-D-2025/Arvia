"""
AUTO-FIX SCRIPT
Detects your vector dimension and updates indexing.py automatically
"""

import faiss
import os

print("="*60)
print("AUTO-FIXING VECTOR DATABASE SETUP")
print("="*60)

# Step 1: Detect dimension
print("\n[1] Detecting vector dimension...")
index = faiss.read_index("vector_db/symptom_vectorstore.faiss")
dimension = index.d
print(f"✓ Found dimension: {dimension}")

# Step 2: Determine the right embedding model
print("\n[2] Determining embedding model...")

if dimension == 384:
    model_type = "huggingface"
    model_name = "all-MiniLM-L6-v2"
    print(f"✓ Using HuggingFace: {model_name}")
    
elif dimension == 768:
    model_type = "huggingface"
    model_name = "sentence-transformers/all-mpnet-base-v2"
    print(f"✓ Using HuggingFace: {model_name}")
    
elif dimension == 1536:
    model_type = "openai"
    model_name = "text-embedding-3-small"
    print(f"✓ Using OpenAI: {model_name}")
    
else:
    print(f"✗ Uncommon dimension: {dimension}")
    print("Please check what model created this index")
    exit(1)

# Step 3: Generate the correct indexing.py code
print("\n[3] Generating indexing.py...")

if model_type == "huggingface":
    code = f'''import os
from langchain_community.vectorstores import FAISS
from langchain_huggingface import HuggingFaceEmbeddings

# Auto-detected embedding model for dimension {dimension}
embeddings = HuggingFaceEmbeddings(model_name="{model_name}")

VECTOR_DB_PATH = "vector_db/symptom_vectorstore"

if not os.path.exists(f"{{VECTOR_DB_PATH}}.faiss"):
    raise FileNotFoundError(f"Cannot find {{VECTOR_DB_PATH}}.faiss")

print("Loading vector database...")

vector_store = FAISS.load_local(
    folder_path="vector_db",
    index_name="symptom_vectorstore",
    embeddings=embeddings,
    allow_dangerous_deserialization=True
)

print(f"✓ Loaded {{vector_store.index.ntotal}} vectors")

SYMPTOM_VECTOR_STORE = vector_store
'''

elif model_type == "openai":
    code = f'''import os
from langchain_community.vectorstores import FAISS
from langchain_openai import OpenAIEmbeddings

# Auto-detected embedding model for dimension {dimension}
embeddings = OpenAIEmbeddings(model="{model_name}")

VECTOR_DB_PATH = "vector_db/symptom_vectorstore"

if not os.path.exists(f"{{VECTOR_DB_PATH}}.faiss"):
    raise FileNotFoundError(f"Cannot find {{VECTOR_DB_PATH}}.faiss")

print("Loading vector database...")

vector_store = FAISS.load_local(
    folder_path="vector_db",
    index_name="symptom_vectorstore",
    embeddings=embeddings,
    allow_dangerous_deserialization=True
)

print(f"✓ Loaded {{vector_store.index.ntotal}} vectors")

SYMPTOM_VECTOR_STORE = vector_store
'''

# Step 4: Write the file
with open("app/rag/indexing.py", "w") as f:
    f.write(code)

print("✓ Updated app/rag/indexing.py")

# Step 5: Check dependencies
print("\n[4] Checking dependencies...")

if model_type == "huggingface":
    try:
        import sentence_transformers
        print("✓ sentence-transformers installed")
    except:
        print("✗ Missing: sentence-transformers")
        print("  Run: pip install sentence-transformers")
        
elif model_type == "openai":
    try:
        import openai
        print("✓ openai installed")
    except:
        print("✗ Missing: langchain-openai")
        print("  Run: pip install langchain-openai")
    
    if not os.getenv("OPENAI_API_KEY"):
        print("⚠️  Set OPENAI_API_KEY in .env file")

# Step 6: Instructions
print("\n" + "="*60)
print("SETUP COMPLETE!")
print("="*60)

print("\nNext steps:")
print("1. Install missing dependencies (if any shown above)")

if model_type == "huggingface":
    print("   pip install sentence-transformers")
elif model_type == "openai":
    print("   pip install langchain-openai")
    print("   (Also set OPENAI_API_KEY in .env)")

print("\n2. Test it:")
print("   python test_vector_db.py")

print("\n3. Start API:")
print("   uvicorn app.main:app --reload")