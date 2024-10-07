from app.modules.users import async_get_users_from_csv, process_users, USERS


ml_models = {}
async def load_ML_models():
    ml_models["model1"] = lambda x : x + 2
    ml_models["model2"] = lambda x : x * 2
    ml_models["model3"] = lambda x : x ** 2

async def init_db():
    pass

async def init_client():
    pass

async def initialize():
    
    global USERS
    df_users = await async_get_users_from_csv()
    USERS = process_users(df_users)

    await load_ML_models()
    await init_db()
    await init_client()