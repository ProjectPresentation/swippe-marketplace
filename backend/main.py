from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
import os

from routes import auth, products, orders, admin, diet_plans, suggestions
from utils.auth_middleware import get_current_user

# Load environment variables
load_dotenv()

app = FastAPI(title="Swippe API", version="1.0.0")

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth.router, prefix="/auth", tags=["Authentication"])
app.include_router(products.router, prefix="/products", tags=["Products"])
app.include_router(orders.router, prefix="/orders", tags=["Orders"])
app.include_router(admin.router, prefix="/admin", tags=["Admin"])
app.include_router(diet_plans.router, prefix="/diet-plans", tags=["Diet Plans"])
app.include_router(suggestions.router, prefix="/suggestions", tags=["Suggestions"])

@app.get("/")
async def root():
    return {"message": "Welcome to Swippe API"}

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host=os.getenv("API_HOST", "0.0.0.0"), port=int(os.getenv("API_PORT", 8000)))