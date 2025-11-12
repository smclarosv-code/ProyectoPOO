Create SCHEMA ventas_directas;

CREATE TABLE ventas_directas.usuarios (
    id INT IDENTITY (1,1) PRIMARY KEY,
    nombre_completo NVARCHAR (150) NOT NULL,
    telefono NVARCHAR (50),
    correo NVARCHAR (150) UNIQUE,
    fecha_registro DATETIME DEFAULT SYSDATETIME()
)

CREATE TABLE ventas_directas.productos
(
    id INT IDENTITY (1,1) PRIMARY KEY,
    nombre_producto NVARCHAR (150) NOT NULL,
    descripcion_producto NVARCHAR (300),
    precio_unitario FLOAT NOT NULL,
    activo BIT DEFAULT 1,
    categoria NVARCHAR (100) 
)

CREATE TABLE ventas_directas.stock
(
    id INT IDENTITY (1,1) PRIMARY KEY,
    id_productos INT NOT NULL,
    cantidad_disponible INT DEFAULT 0,
    ubicacion NVARCHAR (100)
)

ALTER TABLE ventas_directas.stock
ADD CONSTRAINT FK_Catalogo_Stock
FOREIGN KEY (id_productos) REFERENCES ventas_directas.productos(id)

CREATE TABLE ventas_directas.Orden_pedido
(
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

CREATE TABLE ventas_directas.Detalle_pedido
(
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


