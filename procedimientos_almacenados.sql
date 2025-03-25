-- 1. Actualizar el precio de todos los productos de un proveedor
DELIMITER $$
CREATE PROCEDURE ActualizarPrecioProveedor(IN proveedorID INT, IN porcentaje DECIMAL(5,2))
BEGIN
    UPDATE Productos
    SET precio = precio * (1 + porcentaje / 100)
    WHERE proveedor_id = proveedorID;
END $$
DELIMITER ;

-- 2. Obtener la dirección de un cliente por ID
DELIMITER $$
CREATE PROCEDURE ObtenerDireccionCliente(IN clienteID INT)
BEGIN
    SELECT direccion, ciudad, estado, codigo_postal, pais
    FROM Ubicaciones
    WHERE entidad_id = clienteID AND tipo_entidad = 'Cliente';
END $$
DELIMITER ;

-- 3. Registrar un pedido nuevo y sus detalles
DELIMITER $$
CREATE PROCEDURE RegistrarPedido(IN clienteID INT, IN fechaPedido DATE)
BEGIN
    INSERT INTO Pedidos (cliente_id, fecha) VALUES (clienteID, fechaPedido);
END $$
DELIMITER ;

-- 4. Calcular el total de ventas de un cliente
DELIMITER $$
CREATE PROCEDURE TotalVentasCliente(IN clienteID INT)
BEGIN
    SELECT SUM(DP.cantidad * P.precio) AS total_ventas
    FROM Pedidos PD
    JOIN DetallesPedido DP ON PD.id = DP.pedido_id
    JOIN Productos P ON DP.producto_id = P.id
    WHERE PD.cliente_id = clienteID;
END $$
DELIMITER ;

-- 5. Obtener los empleados por puesto
DELIMITER $$
CREATE PROCEDURE ObtenerEmpleadosPorPuesto(IN puestoID INT)
BEGIN
    SELECT nombre FROM DatosEmpleados WHERE puesto_id = puestoID;
END $$
DELIMITER ;

-- 6. Actualizar el salario de empleados por puesto
DELIMITER $$
CREATE PROCEDURE ActualizarSalarioPorPuesto(IN puestoID INT, IN nuevoSalario DECIMAL(10,2))
BEGIN
    UPDATE Puestos SET salario = nuevoSalario WHERE id = puestoID;
END $$
DELIMITER ;

-- 7. Listar pedidos entre dos fechas
DELIMITER $$
CREATE PROCEDURE PedidosEntreFechas(IN fechaInicio DATE, IN fechaFin DATE)
BEGIN
    SELECT * FROM Pedidos WHERE fecha BETWEEN fechaInicio AND fechaFin;
END $$
DELIMITER ;

-- 8. Aplicar un descuento a productos de una categoría
DELIMITER $$
CREATE PROCEDURE AplicarDescuentoCategoria(IN tipoID INT, IN descuento DECIMAL(5,2))
BEGIN
    UPDATE Productos SET precio = precio * (1 - descuento / 100) WHERE tipo_id = tipoID;
END $$
DELIMITER ;

-- 9. Listar todos los proveedores de un tipo de producto
DELIMITER $$
CREATE PROCEDURE ProveedoresPorTipoProducto(IN tipoID INT)
BEGIN
    SELECT DISTINCT P.nombre
    FROM Proveedores P
    JOIN Productos PR ON P.id = PR.proveedor_id
    WHERE PR.tipo_id = tipoID;
END $$
DELIMITER ;

-- 10. Obtener el pedido de mayor valor
DELIMITER $$
CREATE PROCEDURE PedidoMayorValor()
BEGIN
    SELECT pedido_id, SUM(cantidad * precio) AS total
    FROM DetallesPedido
    JOIN Productos ON DetallesPedido.producto_id = Productos.id
    GROUP BY pedido_id
    ORDER BY total DESC
    LIMIT 1;
END $$
DELIMITER ;
