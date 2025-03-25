-- 1. Obtener la lista de todos los pedidos con los nombres de clientes usando INNER JOIN .
SELECT Pedidos.id, Clientes.nombre, Pedidos.fecha 
FROM Pedidos 
INNER JOIN Clientes ON Pedidos.cliente_id = Clientes.id;
-- 2. Listar los productos y proveedores que los suministran con INNER JOIN .
SELECT Productos.nombre, Proveedores.nombre 
FROM Productos 
INNER JOIN Proveedores ON Productos.proveedor_id = Proveedores.id;
-- 3. Mostrar los pedidos y las ubicaciones de los clientes con LEFT JOIN .
SELECT Pedidos.id, Clientes.nombre, Ubicaciones.direccion, Ubicaciones.ciudad 
FROM Pedidos 
LEFT JOIN Clientes ON Pedidos.cliente_id = Clientes.id 
LEFT JOIN Ubicaciones ON Clientes.id = Ubicaciones.entidad_id AND Ubicaciones.tipo_entidad = 'Cliente';
-- 4. Consultar los empleados que han registrado pedidos, incluyendo empleados sin pedidos
SELECT DatosEmpleados.nombre, Pedidos.id 
FROM DatosEmpleados 
LEFT JOIN Pedidos ON DatosEmpleados.id = Pedidos.id;

-- 5. Obtener el tipo de producto y los productos asociados con INNER JOIN .
SELECT TiposProductos.tipo_nombre, Productos.nombre 
FROM Productos 
INNER JOIN TiposProductos ON Productos.tipo_id = TiposProductos.id;

-- 6. Listar todos los clientes y el número de pedidos realizados con COUNT y GROUP BY .

SELECT Clientes.nombre, COUNT(Pedidos.id) AS total_pedidos 
FROM Clientes 
LEFT JOIN Pedidos ON Clientes.id = Pedidos.cliente_id 
GROUP BY Clientes.id;
-- 7. Combinar Pedidos y Empleados para mostrar qué empleados gestionaron pedidos
-- específicos.
SELECT Pedidos.id, DatosEmpleados.nombre 
FROM Pedidos 
INNER JOIN DatosEmpleados ON Pedidos.id = DatosEmpleados.id;
-- 8. Mostrar productos que no han sido pedidos ( RIGHT JOIN ).

SELECT Productos.nombre 
FROM Productos 
RIGHT JOIN DetallesPedido ON Productos.id = DetallesPedido.producto_id 
WHERE DetallesPedido.id IS NULL;
-- 9. Mostrar el total de pedidos y ubicación de clientes usando múltiples JOIN .
SELECT Clientes.nombre, COUNT(Pedidos.id) AS total_pedidos, Ubicaciones.direccion 
FROM Clientes 
LEFT JOIN Pedidos ON Clientes.id = Pedidos.cliente_id 
LEFT JOIN Ubicaciones ON Clientes.id = Ubicaciones.entidad_id AND Ubicaciones.tipo_entidad = 'Cliente' 
GROUP BY Clientes.id;
-- 10. Unir Proveedores , Productos , y TiposProductos para un listado completo de inventario./*  */

SELECT Proveedores.nombre AS proveedor, Productos.nombre AS producto, TiposProductos.tipo_nombre AS categoria 
FROM Productos 
INNER JOIN Proveedores ON Productos.proveedor_id = Proveedores.id 
INNER JOIN TiposProductos ON Productos.tipo_id = TiposProductos.id;