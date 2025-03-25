-- 1. Listar todos los pedidos y el cliente asociado
SELECT Pedidos.id, Clientes.nombre, Pedidos.fecha 
FROM Pedidos 
INNER JOIN Clientes ON Pedidos.cliente_id = Clientes.id;

-- 2. Mostrar la ubicación de cada cliente en sus pedidos
SELECT Pedidos.id, Clientes.nombre, Ubicaciones.direccion, Ubicaciones.ciudad, Ubicaciones.estado
FROM Pedidos
INNER JOIN Clientes ON Pedidos.cliente_id = Clientes.id
INNER JOIN Ubicaciones ON Clientes.id = Ubicaciones.entidad_id AND Ubicaciones.tipo_entidad = 'Cliente';

-- 3. Listar productos junto con el proveedor y tipo de producto
SELECT Productos.nombre, Proveedores.nombre AS proveedor, TiposProductos.tipo_nombre
FROM Productos
INNER JOIN Proveedores ON Productos.proveedor_id = Proveedores.id
INNER JOIN TiposProductos ON Productos.tipo_id = TiposProductos.id;

-- 4. Consultar todos los empleados que gestionan pedidos de clientes en una ciudad específica
SELECT DISTINCT DatosEmpleados.nombre
FROM DatosEmpleados
INNER JOIN Pedidos ON DatosEmpleados.id = Pedidos.id
INNER JOIN Clientes ON Pedidos.cliente_id = Clientes.id
INNER JOIN Ubicaciones ON Clientes.id = Ubicaciones.entidad_id
WHERE Ubicaciones.tipo_entidad = 'Cliente' AND Ubicaciones.ciudad = 'NombreCiudad';

-- 5. Consultar los 5 productos más vendidos
SELECT Productos.nombre, SUM(DetallesPedido.cantidad) AS total_vendido
FROM DetallesPedido
INNER JOIN Productos ON DetallesPedido.producto_id = Productos.id
GROUP BY Productos.id
ORDER BY total_vendido DESC
LIMIT 5;

-- 6. Obtener la cantidad total de pedidos por cliente y ciudad
SELECT Clientes.nombre, Ubicaciones.ciudad, COUNT(Pedidos.id) AS total_pedidos
FROM Clientes
INNER JOIN Pedidos ON Clientes.id = Pedidos.cliente_id
INNER JOIN Ubicaciones ON Clientes.id = Ubicaciones.entidad_id AND Ubicaciones.tipo_entidad = 'Cliente'
GROUP BY Clientes.id, Ubicaciones.ciudad;

-- 7. Listar clientes y proveedores en la misma ciudad
SELECT C.nombre AS cliente, P.nombre AS proveedor, U.ciudad
FROM Ubicaciones U
JOIN Clientes C ON U.entidad_id = C.id AND U.tipo_entidad = 'Cliente'
JOIN Proveedores P ON U.entidad_id = P.id AND U.tipo_entidad = 'Proveedor';

-- 8. Mostrar el total de ventas agrupado por tipo de producto
SELECT TiposProductos.tipo_nombre, SUM(DetallesPedido.cantidad * Productos.precio) AS total_ventas
FROM DetallesPedido
INNER JOIN Productos ON DetallesPedido.producto_id = Productos.id
INNER JOIN TiposProductos ON Productos.tipo_id = TiposProductos.id
GROUP BY TiposProductos.tipo_nombre;

-- 9. Listar empleados que gestionan pedidos de productos de un proveedor específico
SELECT DISTINCT DatosEmpleados.nombre
FROM DatosEmpleados
INNER JOIN Pedidos ON DatosEmpleados.id = Pedidos.id
INNER JOIN DetallesPedido ON Pedidos.id = DetallesPedido.pedido_id
INNER JOIN Productos ON DetallesPedido.producto_id = Productos.id
WHERE Productos.proveedor_id = (SELECT id FROM Proveedores WHERE nombre = 'NombreProveedor');

-- 10. Obtener el ingreso total de cada proveedor a partir de los productos vendidos
SELECT Proveedores.nombre, SUM(DetallesPedido.cantidad * Productos.precio) AS total_ingresos
FROM Productos
INNER JOIN Proveedores ON Productos.proveedor_id = Proveedores.id
INNER JOIN DetallesPedido ON Productos.id = DetallesPedido.producto_id
GROUP BY Proveedores.id;