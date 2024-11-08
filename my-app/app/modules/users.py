import pandas as pd
from pydantic import BaseModel, EmailStr, field_validator
from typing import Optional

from app.modules.utils import async_wrap

USERS = pd.DataFrame()


class UserProfile(BaseModel):
    username: str
    password: str
    confirmation_password: str
    email: EmailStr
    age: Optional[int] = None

    @field_validator('username')
    def username_length(cls, password):
        if len(password) < 4:
            raise ValueError('La longitud mínima  es de 4 caracteres.')
        return password

    @field_validator('confirmation_password')
    def passwords_match(cls, confirmation_password, values, **kwargs):
        if 'password' in values.data and confirmation_password != values.data['password']:
            raise ValueError('Las contraseñas no coinciden')
        return confirmation_password

def get_users_from_csv(filePath="app/static/contacts.csv"):
    return pd.read_csv(filePath)

def write_users_to_csv(users_obj_list, filePath="app/static/contacts.csv"):
    users_data = [user.dict() for user in users_obj_list]
    df = pd.DataFrame(users_data)
    df.to_csv(filePath, index=False)

def process_users(df_users):
    users = []
    for _, row in df_users.iterrows():
        user = UserProfile(
            username=row['username'],
            password=row['password'],
            confirmation_password=row['confirmation_password'],
            email=row['email'],
            age=row['age'] if not pd.isnull(row['age']) else None
        )
        users.append(user)

    return users


async_get_users_from_csv = async_wrap(get_users_from_csv)
async_write_users_to_csv = async_wrap(write_users_to_csv)

async def get_init_users():
    global USERS
    df_users = await async_get_users_from_csv()
    USERS = process_users(df_users)

async def write_final_users():
    global USERS
    await async_write_users_to_csv(USERS)
