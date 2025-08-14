import os
from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from tensorflow.keras.models import load_model
from preprocess import preprocess_img
import numpy as np

# ----------------
# Config
# ----------------
THRESHOLD = 0.5  # adjust if needed
BASE_DIR = os.path.dirname(__file__)
MODELS_DIR = os.path.join(BASE_DIR, "models")

# Load models (make sure these .h5 files exist in backend/models)
nails_model = load_model(os.path.join(MODELS_DIR, "nails_mobilenet_finetune.h5"))
conj_model = load_model(os.path.join(MODELS_DIR, "conj_mobilenet_finetune.h5"))

# ----------------
# App setup
# ----------------
app = FastAPI(title="Anemia Detection API")

# Allow Flutter app to connect
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],   # You can restrict to your teammate's IP/domain later
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ----------------
# Routes
# ----------------
@app.get("/")
def root():
    return {"ok": True, "msg": "Anemia API running"}

@app.post("/predict")
async def predict_anemia(
    fingernails: UploadFile = File(...),
    conjunctiva: UploadFile = File(...)
):
    # Read uploaded images
    nail_bytes = await fingernails.read()
    conj_bytes = await conjunctiva.read()

    # Save temp files so preprocess_img can read them
    nail_path = os.path.join(BASE_DIR, "temp_nail.png")
    conj_path = os.path.join(BASE_DIR, "temp_conj.png")

    with open(nail_path, "wb") as f:
        f.write(nail_bytes)
    with open(conj_path, "wb") as f:
        f.write(conj_bytes)

    # Preprocess
    nail_input = preprocess_img(nail_path)
    conj_input = preprocess_img(conj_path)

    # Predict
    nail_score = float(nails_model.predict(nail_input, verbose=0)[0][0])
    conj_score = float(conj_model.predict(conj_input, verbose=0)[0][0])

    combined_score = (nail_score + conj_score) / 2
    prediction = "Anemic" if combined_score >= THRESHOLD else "Non-Anemic"

    # Clean up temp files
    os.remove(nail_path)
    os.remove(conj_path)

    return {
        "nails_score": nail_score,
        "conj_score": conj_score,
        "combined_score": combined_score,
        "threshold": THRESHOLD,
        "prediction": prediction
    }
