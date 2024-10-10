from fastapi import FastAPI, BackgroundTasks
from fastapi.staticfiles import StaticFiles
from contextlib import asynccontextmanager

from modules.sendEmail import EmailSender

ml_models = {}

def load_ML_models():
    ml_models["model1"] = lambda x : x + 2
    ml_models["model2"] = lambda x : x * 2
    ml_models["model3"] = lambda x : x ** 2
    pass

def init_db():
    pass

def init_client():
    pass

@asynccontextmanager
async def lifespan(app: FastAPI): #To see the use of this refer to: https://fastapi.tiangolo.com/advanced/events/ . But this code it's executed once before/after the api starts/finishes
    # Code executed before start.Load the ML model
    load_ML_models()
    init_db()
    init_client()
    yield
    # Code executed after termination
    ml_models.clear()


app = FastAPI(lifespan=lifespan)
app.mount("/static", StaticFiles(directory="./static"), name="static")



def send_email(email: str, message=""):
    EmailSender().send_email(email)


@app.post("/send-reminder/{email}")
async def send_notification(email: str, background_tasks: BackgroundTasks):
    background_tasks.add_task(send_email, email, message="some notification")
    return {"message": "Notification sent in the background"}

@app.post("/send-reminder/{email}")
async def send_notification(email: str, background_tasks: BackgroundTasks):
    background_tasks.add_task(send_email, email, message="some notification")
    return {"message": "Notification sent in the background"}

@app.get("/")
def read_root():
    return {"Hello": "World"}

# This will serve favicon.ico from the static folder. This is so the code doesn't output an error
@app.get("/favicon.ico", include_in_schema=False)
async def favicon():
    return {"file": "static/favicon.ico"}

#To run the code: python -m uvicorn main:app --reload