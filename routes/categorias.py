from fastapi import APIRouter, status
from models.categoria import Categoria
from controllers.categoria import (
    get_one_categoria,
    get_all_categoria,
    create_categoria,
    update_categoria,
    delete_categoria
)

router = APIRouter(prefix="/categorias")

@router.get("/{id}", tags=["Categorías"], status_code=status.HTTP_200_OK)
async def get_one_categoria_endpoint(id: int):
    result: Categoria = await get_one_categoria(id)
    return result

@router.get("/", tags=["Categorías"], status_code=status.HTTP_200_OK)
async def get_all_categorias_endpoint():
    result = await get_all_categoria()
    return result

@router.post("/", tags=["Categorías"], status_code=status.HTTP_201_CREATED)
async def create_new_categoria(categoria_data: Categoria):
    result = await create_categoria(categoria_data)
    return result

@router.put("/{id}", tags=["Categorías"], status_code=status.HTTP_200_OK)
async def update_categoria_information(id: int, categoria_data: Categoria):
    categoria_data.id = id
    result = await update_categoria(categoria_data)
    return result

@router.delete("/{id}", tags=["Categorías"], status_code=status.HTTP_204_NO_CONTENT)
async def delete_categoria_information(id: int):
    status: str = await delete_categoria(id)
    return status
