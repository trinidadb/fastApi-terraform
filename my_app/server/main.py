from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles

from server.constants import API_PREFIX, ROUTE_PREFIX
from server.modules.initialization import initialize
from server.modules.on_finish import on_finish
import server.routers.img as imgRouter


@asynccontextmanager
async def lifespan(app: FastAPI):
    await initialize()
    yield
    await on_finish()

app = FastAPI(lifespan=lifespan, root_path=API_PREFIX+ROUTE_PREFIX)
app.mount("/static", StaticFiles(directory="./server/static"), name="static")

app.include_router(imgRouter.router, prefix='/img')


@app.get("/")
def read_root():
    return {"Base url of app to upload/download ham images"}


@app.get("/favicon.ico", include_in_schema=False)
async def favicon():
    return {"file": "static/favicon.ico"}


# To run the code: python -m uvicorn app.main:app --reload
# Check for secure communication: https://github.com/skatesham/fastapi-bigger-application/blob/master/app/src/routers/stocks.py
