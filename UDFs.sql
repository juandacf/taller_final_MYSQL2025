-- 1. Función para calcular los días transcurridos desde una fecha dada
DELIMITER $$
CREATE FUNCTION DiasTranscurridos(fecha DATE) RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), fecha);
END $$
DELIMITER ;

-- 2. Función para calcular el total con impuesto de un monto
DELIMITER $$
CREATE FUNCTION TotalConImpuesto(monto DECIMAL(10,2), tasa DECIMAL(5,2)) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN monto * (1 + tasa / 100);
END $$
DELIMITER ;

-- 3. Función que devuelve el total de pedidos de un cliente específico
DELIMITER $$
CREATE FUNCTION TotalPedidosCliente(clienteID INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM Pedidos WHERE cliente_id = clienteID;
    RETURN total;
END $$
DELIMITER ;

-- 4. Función para aplicar un descuento a un producto
DELIMITER $$
CREATE FUNCTION PrecioConDescuento(productoID INT, descuento DECIMAL(5,2)) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE precio DECIMAL(10,2);
    SELECT precio INTO precio FROM Productos WHERE id = productoID;
    RETURN precio * (1 - descuento / 100);
END $$
DELIMITER ;

-- 5. Función que indica si un cliente tiene dirección registrada
DELIMITER $$
CREATE FUNCTION ClienteTieneDireccion(clienteID INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE existe INT;
    SELECT COUNT(*) INTO existe FROM Ubicaciones WHERE entidad_id = clienteID AND tipo_entidad = 'Cliente';
    RETURN existe > 0;
END $$
DELIMITER ;

-- 6. Función que devuelve el salario anual de un empleado
DELIMITER $$
CREATE FUNCTION SalarioAnual(empleadoID INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE salario DECIMAL(10,2);
    SELECT salario * 12 INTO salario FROM Puestos 
    WHERE id = (SELECT puesto_id FROM DatosEmpleados WHERE id = empleadoID);
    RETURN salario;
END $$
DELIMITER ;

-- 7. Función para calcular el total de ventas de un tipo de producto
DELIMITER $$
CREATE FUNCTION TotalVentasPorTipo(tipoID INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(DP.cantidad * P.precio) INTO total
    FROM DetallesPedido DP
    JOIN Productos P ON DP.producto_id = P.id
    WHERE P.tipo_id = tipoID;
    RETURN IFNULL(total, 0);
END $$
DELIMITER ;

-- 8. Función para devolver el nombre de un cliente por ID
DELIMITER $$
CREATE FUNCTION NombreCliente(clienteID INT) RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE nombre VARCHAR(100);
    SELECT nombre INTO nombre FROM Clientes WHERE id = clienteID;
    RETURN nombre;
END $$
DELIMITER ;

-- 9. Función que recibe el ID de un pedido y devuelve su total
DELIMITER $$
CREATE FUNCTION TotalPedido(pedidoID INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(DP.cantidad * P.precio) INTO total
    FROM DetallesPedido DP
    JOIN Productos P ON DP.producto_id = P.id
    WHERE DP.pedido_id = pedidoID;
    RETURN IFNULL(total, 0);
END $$
DELIMITER ;

-- 10. Función que indica si un producto está en inventario
DELIMITER $$
CREATE FUNCTION ProductoEnInventario(productoID INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE existe INT;
    SELECT COUNT(*) INTO existe FROM Productos WHERE id = productoID;
    RETURN existe > 0;
END $$
DELIMITER ;
