from fastapi import APIRouter, HTTPException
from typing import Optional

from app.modules.users import UserProfile

router = APIRouter(tags = ['usersManager'])

@router.get('/me')
async def read_user_me(msg: Optional[str]=None):
    msg = msg or "Hey! It's you! :D"
    return {"msg": msg}

@router.get('/error')
async def raise_error():
    raise HTTPException(status_code=500, detail="Error forzado por el server")

@router.get('/{username}')
async def read_user(username: str):
    return {"msg": f"Your username is {username}"}

@router.get('/{username}/groups/{group}')
async def read_user_me(username: str, group: str):
    return {"msg": f"Will bring the information of {group} group, to which {username} belongs"}

@router.post("/create")
async def create_user(user_data: UserProfile):
    return {"msg": f"User {user_data.username} will be created! (or not?)"}

@router.put("/update/{username}")
async def update_user(age: int):
    return {"msg": f"The new age is {age} (or not?)"}

@router.delete("/delete/{username}")
async def delete_user():
    return {"msg": f"Will delete user (or not?)"}