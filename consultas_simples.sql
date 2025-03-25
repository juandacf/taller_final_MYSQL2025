-- 1. Seleccionar todos los productos con precio mayor a $50
SELECT * FROM Productos WHERE precio > 50;

-- 2. Consultar clientes registrados en una ciudad específica
SELECT Clientes.* FROM Clientes 
INNER JOIN Ubicaciones ON Clientes.id = Ubicaciones.entidad_id 
WHERE Ubicaciones.tipo_entidad = 'Cliente' AND Ubicaciones.ciudad = 'NombreCiudad';

-- 3. Mostrar empleados contratados en los últimos 2 años
SELECT * FROM DatosEmpleados 
WHERE fecha_contratacion >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR);

-- 4. Seleccionar proveedores que suministran más de 5 productos
SELECT Proveedores.nombre, COUNT(Productos.id) AS total_productos
FROM Proveedores 
INNER JOIN Productos ON Proveedores.id = Productos.proveedor_id
GROUP BY Proveedores.id
HAVING COUNT(Productos.id) > 5;

-- 5. Listar clientes que no tienen dirección registrada en Ubicaciones
SELECT Clientes.* FROM Clientes 
LEFT JOIN Ubicaciones ON Clientes.id = Ubicaciones.entidad_id AND Ubicaciones.tipo_entidad = 'Cliente' 
WHERE Ubicaciones.id IS NULL;

-- 6. Calcular el total de ventas por cada cliente
SELECT Clientes.nombre, SUM(DetallesPedido.cantidad * Productos.precio) AS total_ventas
FROM Clientes
INNER JOIN Pedidos ON Clientes.id = Pedidos.cliente_id
INNER JOIN DetallesPedido ON Pedidos.id = DetallesPedido.pedido_id
INNER JOIN Productos ON DetallesPedido.producto_id = Productos.id
GROUP BY Clientes.id;

-- 7. Mostrar el salario promedio de los empleados
SELECT AVG(Puestos.salario) AS salario_promedio FROM Puestos;

-- 8. Consultar el tipo de productos disponibles en TiposProductos
SELECT * FROM TiposProductos;

-- 9. Seleccionar los 3 productos más caros
SELECT * FROM Productos ORDER BY precio DESC LIMIT 3;

-- 10. Consultar el cliente con el mayor número de pedidos
SELECT Clientes.nombre, COUNT(Pedidos.id) AS total_pedidos
FROM Clientes
INNER JOIN Pedidos ON Clientes.id = Pedidos.cliente_id
GROUP BY Clientes.id
ORDER BY total_pedidos DESC
LIMIT 1;
