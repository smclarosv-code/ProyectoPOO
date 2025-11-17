Create SCHEMA ventas_directas;

CREATE TABLE ventas_directas.usuarios (
    id INT IDENTITY (1,1) PRIMARY KEY,
    nombre_completo NVARCHAR (150) NOT NULL,
    telefono NVARCHAR (50),
    correo NVARCHAR (150) UNIQUE,
    fecha_registro DATETIME DEFAULT SYSDATETIME()
)

CREATE TABLE ventas_directas.productos (
    id INT IDENTITY (1,1) PRIMARY KEY,
    nombre_producto NVARCHAR (150) NOT NULL,
    descripcion_producto NVARCHAR (300),
    precio_unitario FLOAT NOT NULL,
    activo BIT DEFAULT 1,
    id_categoria INT NOT NULL
)

CREATE TABLE ventas_directas.stock (
    id INT IDENTITY (1,1) PRIMARY KEY,
    id_productos INT NOT NULL,
    cantidad_disponible INT DEFAULT 0,
)

ALTER TABLE ventas_directas.stock
ADD CONSTRAINT FK_Catalogo_Stock
FOREIGN KEY (id_productos) REFERENCES ventas_directas.productos(id)

CREATE TABLE ventas_directas.Orden_pedido (
    id INT IDENTITY (1,1) PRIMARY KEY,
    id_usuarios INT NOT NULL,
    fecha_orden DATETIME DEFAULT SYSDATETIME(),
    total FLOAT NOT NULL,
    estado_pago NVARCHAR (50) DEFAULT 'Pendiente',
    -- Pendiente, pagado, cancelado
    metodo_pago NVARCHAR (50)
)

ALTER TABLE ventas_directas.Orden_pedido
ADD CONSTRAINT FK_Cliente_OrdenPedido
FOREIGN KEY (id_usuarios) REFERENCES ventas_directas.usuarios(id)

CREATE TABLE ventas_directas.Detalle_pedido (
    id INT IDENTITY (1,1) PRIMARY KEY,
    id_orden INT NOT NULL,
    id_productos INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario FLOAT NOT NULL,
    subtotal AS (cantidad * precio_unitario) PERSISTED,

)

ALTER TABLE ventas_directas.Detalle_pedido
ADD CONSTRAINT FK_OrdenCompra_DetallePedido
FOREIGN KEY (id_orden) REFERENCES ventas_directas.Orden_pedido(id)

ALTER TABLE ventas_directas.Detalle_pedido
ADD CONSTRAINT FK_Catalogo_DetallePedido
FOREIGN KEY (id_productos) REFERENCES ventas_directas.productos(id)

CREATE TABLE ventas_directas.categorias (
    id INT IDENTITY (1,1) PRIMARY KEY,
    nombre_categoria NVARCHAR (100) NOT NULL
)

ALTER TABLE ventas_directas.productos
ADD CONSTRAINT FK_Productos_Categoria
FOREIGN KEY (id_categoria) REFERENCES ventas_directas.Categoria(id)

INSERT INTO ventas_directas.usuarios (nombre_completo, telefono, correo)
VALUES ('Ana Pérez', '98765432', 'ana.perez@example.com');

INSERT INTO ventas_directas.usuarios (nombre_completo, telefono, correo)
VALUES ('Edwin Requeno', '98765432', 'edwin.requeno@example.com');

SELECT * FROM ventas_directas.usuarios;

--Modificando el nombre de la tabla categorias  
EXEC sp_rename 'ventas_directas.categoria', 'categorias';

--Cambiando Atributo de la tabla de stock
EXEC sp_rename 
    'ventas_directas.stock.id_productos', 
    'id_producto', 
    'COLUMN';
