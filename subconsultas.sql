-- 1. Consultar el producto más caro en cada categoría
SELECT tipo_id, nombre, precio
FROM Productos
WHERE precio = (SELECT MAX(precio) FROM Productos P WHERE P.tipo_id = Productos.tipo_id);

-- 2. Encontrar el cliente con mayor total en pedidos
SELECT cliente_id, SUM(DetallesPedido.cantidad * Productos.precio) AS total_compras
FROM Pedidos
JOIN DetallesPedido ON Pedidos.id = DetallesPedido.pedido_id
JOIN Productos ON DetallesPedido.producto_id = Productos.id
GROUP BY cliente_id
ORDER BY total_compras DESC
LIMIT 1;

-- 3. Listar empleados que ganan más que el salario promedio
SELECT DatosEmpleados.nombre, Puestos.salario
FROM DatosEmpleados
JOIN Puestos ON DatosEmpleados.puesto_id = Puestos.id
WHERE Puestos.salario > (SELECT AVG(salario) FROM Puestos);

-- 4. Consultar productos que han sido pedidos más de 5 veces
SELECT producto_id, SUM(cantidad) AS total_vendido
FROM DetallesPedido
GROUP BY producto_id
HAVING total_vendido > 5;

-- 5. Listar pedidos cuyo total es mayor al promedio de todos los pedidos
SELECT id, (SELECT SUM(cantidad * precio) FROM DetallesPedido WHERE pedido_id = Pedidos.id) AS total_pedido
FROM Pedidos
HAVING total_pedido > (SELECT AVG(total_pedido) FROM (SELECT pedido_id, SUM(cantidad * precio) AS total_pedido FROM DetallesPedido GROUP BY pedido_id) AS subquery);

-- 6. Seleccionar los 3 proveedores con más productos
SELECT proveedor_id, COUNT(*) AS total_productos
FROM Productos
GROUP BY proveedor_id
ORDER BY total_productos DESC
LIMIT 3;

-- 7. Consultar productos con precio superior al promedio en su tipo
SELECT nombre, precio
FROM Productos
WHERE precio > (SELECT AVG(precio) FROM Productos P WHERE P.tipo_id = Productos.tipo_id);

-- 8. Mostrar clientes que han realizado más pedidos que la media
SELECT cliente_id, COUNT(*) AS total_pedidos
FROM Pedidos
GROUP BY cliente_id
HAVING total_pedidos > (SELECT AVG(total_pedidos) FROM (SELECT cliente_id, COUNT(*) AS total_pedidos FROM Pedidos GROUP BY cliente_id) AS subquery);

-- 9. Encontrar productos cuyo precio es mayor que el promedio de todos los productos
SELECT nombre, precio
FROM Productos
WHERE precio > (SELECT AVG(precio) FROM Productos);

-- 10. Mostrar empleados cuyo salario es menor al promedio del departamento
SELECT DatosEmpleados.nombre, Puestos.salario
FROM DatosEmpleados
JOIN Puestos ON DatosEmpleados.puesto_id = Puestos.id
WHERE Puestos.salario < (SELECT AVG(salario) FROM Puestos);
