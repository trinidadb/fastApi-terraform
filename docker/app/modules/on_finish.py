from app.modules.initialization import ml_models
from app.modules.users import write_final_users

async def release_memory():
    global ml_models
    ml_models.clear()

async def close_client_connection():
    pass

async def on_finish():
    await write_final_users()
    await release_memory()
    await close_client_connection()