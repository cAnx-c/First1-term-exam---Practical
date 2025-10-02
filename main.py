from fastapi import FastAPI, HTTPException
from sqlmodel import SQLModel, Field
from typing import Optional, List
from pydantic import BaseModel
import itertools

    

app = FastAPI()

class User(SQLModel):
    id: Optional[int] = Field(default=None)
    username: str
    password: str
    email: Optional[str] = None
    is_active: bool = True

DataBase: List[User] = [
    User(id=1, username="Mateo", password="Levno", email="mateo@example.com", is_active=True),
    User(id=2, username="Pipo", password="1234", email="Pipo@gmail.com", is_active=False),
]
@app.post("/usuarios", response_model=User)
def create_user(user: User):
    for usuario in DataBase:
        if usuario.username == user.username:
            raise HTTPException(status_code=400, detail="El usuario ya esta bro")

    user.id = len(DataBase) + 1
    DataBase.append(user)
    return user

@app.get("/listUsers", response_model=List[User])
def list_users():
    return DataBase

@app.get("/userID/{id}")
def get_user(id: int):
    for usuario in DataBase:
        if usuario.id == id:
            return usuario
    raise HTTPException(status_code=404, detail="No se encuentra al usuario")

@app.put("/insertUser/{id}", response_model=User)
def update_user(id: int, user_update: User):
    for i, user in enumerate(DataBase):
        if user.id == id:
            user.username = user_update.username
            user.email = user_update.email
            user.is_active = user_update.is_active
            DataBase[i] = user
            return user
    raise HTTPException(status_code=404, detail="No se encuentra al usuario")

@app.delete("/deleteUser/{id}", response_model=User)
def delete_user(id: int):
    for usuario in DataBase:
        if usuario.id == id:
            DataBase.remove(usuario)  
            return usuario          
    raise HTTPException(status_code=404, detail="No se encuentra al usuario")

class Login(BaseModel):
    email: str
    password: str

@app.post("/login")
def login(request: Login):
    for usuario in DataBase:
        if usuario.email == request.email and usuario.password == request.password:
            return {
                "message": "Login fue un exito...",
                "user": usuario.username,
                "email": usuario.email
            }
    raise HTTPException(status_code=401, detail="No se encuentra al usuario")
