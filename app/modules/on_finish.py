from app.modules.initialization import ml_models
from app.modules.users import async_write_users_to_csv, USERS

async def release_memory():
    global ml_models
    ml_models.clear()

async def close_client_connection():
    pass

async def on_finish():
    await async_write_users_to_csv(USERS)
    await release_memory()
    await close_client_connection()