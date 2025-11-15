from fastapi import HTTPException
from utils.database import execute_query_json
from models.categoria import Categoria
import json


# -------------------------------------------------------------------
# GET ONE
# -------------------------------------------------------------------
async def get_one_categoria(id: int) -> Categoria:

    sql = """
        SELECT [id]
            ,[nombre_categoria]
        FROM ventas_directas.Categoria
        WHERE id = ?
    """

    try:
        result = await execute_query_json(sql, params=[id])
        data = json.loads(result)

        if len(data) == 0:
            raise HTTPException(status_code=404, detail="Categoría no encontrada")

        return data[0]

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")


# -------------------------------------------------------------------
# GET ALL
# -------------------------------------------------------------------
async def get_all_categoria() -> list[Categoria]:

    sql = """
        SELECT [id]
            ,[nombre_categoria]
        FROM ventas_directas.Categoria
    """

    try:
        result = await execute_query_json(sql)
        return json.loads(result)

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")


# -------------------------------------------------------------------
# CREATE CATEGORIA
# -------------------------------------------------------------------
async def create_categoria(categoria: Categoria) -> Categoria:

    sql = """
        INSERT INTO ventas_directas.Categoria
            ([nombre_categoria])
        VALUES (?);
    """

    params = [
        categoria.nombre_categoria
    ]

    try:
        await execute_query_json(sql, params=params, needs_commit=True)

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")

    # retornar el registro insertado
    sql_find = """
        SELECT [id]
            ,[nombre_categoria]
        FROM ventas_directas.Categoria
        WHERE nombre_categoria = ?;
    """

    try:
        result = await execute_query_json(sql_find, params=[categoria.nombre_categoria])
        data = json.loads(result)
        return data[0] if len(data) > 0 else {}

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")


# -------------------------------------------------------------------
# UPDATE CATEGORIA
# -------------------------------------------------------------------
async def update_categoria(categoria: Categoria) -> Categoria:

    data = categoria.model_dump(exclude_none=True)

    if "id" not in data:
        raise HTTPException(status_code=400, detail="El ID es requerido para actualizar")

    keys = list(data.keys())
    keys.remove("id")

    variables = " = ?, ".join(keys) + " = ?"

    sql = f"""
        UPDATE ventas_directas.Categoria
        SET {variables}
        WHERE id = ?
    """

    params = [data[k] for k in keys]
    params.append(categoria.id)

    try:
        await execute_query_json(sql, params=params, needs_commit=True)

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")

    return await get_one_categoria(categoria.id)


# -------------------------------------------------------------------
# DELETE CATEGORIA
# -------------------------------------------------------------------
async def delete_categoria(id: int) -> str:

    sql = """
        DELETE FROM ventas_directas.Categoria
        WHERE id = ?;
    """

    try:
        await execute_query_json(sql, params=[id], needs_commit=True)
        return "DELETED"

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")
