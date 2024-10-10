from app.modules.users import get_init_users


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
    await get_init_users()
    await load_ML_models()
    await init_db()
    await init_client()