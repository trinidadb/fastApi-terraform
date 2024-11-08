from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles

from app.constants.general import API_PREFIX, ROUTE_PREFIX
from app.modules.initialization import initialize
from app.modules.on_finish import on_finish
import app.routers.users as usersRouter


@asynccontextmanager
async def lifespan(app: FastAPI):  # To see the use of this refer to: https://fastapi.tiangolo.com/advanced/events/ . But this code it's executed once before/after the api starts/finishes
    await initialize()
    yield
    await on_finish()

app = FastAPI(lifespan=lifespan, root_path=API_PREFIX+ROUTE_PREFIX)
app.mount("/static", StaticFiles(directory="./app/static"), name="static")

app.include_router(usersRouter.router, prefix='/users')


@app.get("/")
def read_root():
    return {"Hello": "World"}


# This will serve favicon.ico from the static folder.
# Before this the code output an error->fastapi automatically searches favicon.ico
@app.get("/favicon.ico", include_in_schema=False)
async def favicon():
    return {"file": "static/favicon.ico"}

# To run the code: python -m uvicorn app.main:app --reload
# Check for secure communication: https://github.com/skatesham/fastapi-bigger-application/blob/master/app/src/routers/stocks.py
