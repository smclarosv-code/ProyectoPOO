from fastapi import APIRouter, status
from models.stock import Stock

from controllers.categoria import (
    get_one_producto,
    get_all_productos,
    create_producto,
    update_producto,
    delete_producto
)

router = APIRouter(prefix="/productos")

@router.get("/{id}", tags=["Productos"], status_code=status.HTTP_200_OK)
async def get_one_categoria_endpoint(id: int):
    result: Productos = await get_one_producto(id)
    return result

@router.get("/", tags=["Productos"], status_code=status.HTTP_200_OK)
async def get_all_productos_endpoint():
    result = await get_all_productos()
    return result

@router.post("/", tags=["Productos"], status_code=status.HTTP_201_CREATED)
async def create_new_producto(productos_data: Productos):
    result = await create_producto(productos_data)
    return result

@router.put("/{id}", tags=["Producto"], status_code=status.HTTP_200_OK)
async def update_producto_information(id: int, producto_data: Productos):
    producto_data.id = id
    result = await update_producto(producto_data)
    return result
