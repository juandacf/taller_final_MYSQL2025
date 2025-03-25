-- Objetivo: Crear una función que aplique un descuento sobre el precio de un producto si
-- pertenece a una categoría específica.

DELIMITER $$

CREATE FUNCTION CalcularDescuento(tipoID INT, precioOriginal DECIMAL(10,2)) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE descuento DECIMAL(10,2);
    
    -- Verificar si el tipo de producto es "Electrónica"
    IF (SELECT tipo_nombre FROM TiposProductos WHERE id = tipoID) = 'Electrónica' THEN
        SET descuento = precioOriginal * 0.90; -- Aplicar 10% de descuento
    ELSE
        SET descuento = precioOriginal; -- Mantener el precio original
    END IF;
    
    RETURN descuento;
END $$

DELIMITER ;

SELECT 
    P.nombre AS Producto,
    P.precio AS Precio_Original,
    CalcularDescuento(P.tipo_id, P.precio) AS Precio_Con_Descuento
FROM Productos P;

-- Objetivo: Crear una función que calcule la edad de un cliente en función de su fecha de
-- nacimiento y luego usarla para listar solo los clientes mayores de 18 años.
-- Pasos:
-- 1. Crear la función CalcularEdad que reciba la fecha de nacimiento y calcule la edad.
-- 2. Consultar todos los clientes y mostrar solo aquellos que sean mayores de 18 años

DELIMITER $$

CREATE FUNCTION CalcularEdad(fecha_nacimiento DATE) 
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE());
END $$

DELIMITER ;
SELECT 
    id, 
    nombre, 
    email, 
    fecha_nacimiento, 
    CalcularEdad(fecha_nacimiento) AS Edad
FROM Clientes
WHERE CalcularEdad(fecha_nacimiento) >= 18;

-- Objetivo: Crear una función que calcule el precio final de un producto aplicando un
-- impuesto del 15% y luego mostrar una lista de productos con el precio final incluido.
-- Pasos:
-- 1. Crear la función CalcularImpuesto que reciba el precio del producto y aplique el
-- impuesto.
-- 2. Mostrar el nombre del producto, el precio original y el precio final con impuesto.
DELIMITER $$

CREATE FUNCTION CalcularImpuesto(precio DECIMAL(10,2)) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN precio * 1.15;  
END $$

DELIMITER ;

SELECT 
    nombre AS Producto, 
    precio AS Precio_Original, 
    CalcularImpuesto(precio) AS Precio_Final
FROM Productos;


-- Objetivo: Crear una función que calcule el total de los pedidos de un cliente y usarla para
-- mostrar los clientes con total de pedidos mayor a $1000.
-- Pasos:
-- 1. Crear la función TotalPedidosCliente que reciba el ID de un cliente y calcule el total
-- de todos sus pedidos.
-- 2. Realizar una consulta que muestre el nombre del cliente y su total de pedidos, y filtrar
-- clientes con un total mayor a $1000.

DELIMITER $$

CREATE FUNCTION TotalPedidosCliente(clienteID INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);

    SELECT SUM(DP.cantidad * P.precio) INTO total
    FROM Pedidos PD
    JOIN DetallesPedido DP ON PD.id = DP.pedido_id
    JOIN Productos P ON DP.producto_id = P.id
    WHERE PD.cliente_id = clienteID;

    RETURN IFNULL(total, 0); s
END $$

DELIMITER ;


SELECT 
    C.nombre AS Cliente, 
    TotalPedidosCliente(C.id) AS Total_Pedidos
FROM Clientes C
HAVING Total_Pedidos > 1000;


-- Objetivo: Crear una función que calcule el salario anual de un empleado y usarla para listar
-- todos los empleados con un salario anual mayor a $50,000.
-- Pasos:
-- 1. Crear la función SalarioAnual que reciba el salario mensual y lo multiplique por 12.
-- 2. Realizar una consulta que muestre el nombre del empleado y su salario anual, filtrando
-- empleados con salario mayor a $50,000.

DELIMITER $$

CREATE FUNCTION SalarioAnual(salario_mensual DECIMAL(10,2)) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN salario_mensual * 12;
END $$

DELIMITER ;


SELECT 
    DE.nombre AS Empleado, 
    SalarioAnual(P.salario) AS Salario_Anual
FROM DatosEmpleados DE
JOIN Puestos P ON DE.puesto_id = P.id
HAVING Salario_Anual > 50000;



-- Objetivo: Crear una función que calcule la bonificación de un empleado (10% de su salario) y
-- mostrar el salario ajustado de cada empleado.
-- Pasos:
-- 1. Crear una función Bonificacion que reciba el salario y calcule el 10%.
-- 2. Realizar una consulta que muestre el salario ajustado (salario + bonificación).

DELIMITER $$

CREATE FUNCTION Bonificacion(salario DECIMAL(10,2)) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN salario * 0.10;
END $$

DELIMITER ;


SELECT 
    DE.nombre AS Empleado, 
    P.salario AS Salario_Base,
    Bonificacion(P.salario) AS Bonificacion,
    (P.salario + Bonificacion(P.salario)) AS Salario_Ajustado
FROM DatosEmpleados DE
JOIN Puestos P ON DE.puesto_id = P.id;


SELECT 
    DE.nombre AS Empleado, 
    P.salario AS Salario_Base,
    Bonificacion(P.salario) AS Bonificacion,
    (P.salario + Bonificacion(P.salario)) AS Salario_Ajustado
FROM DatosEmpleados DE
JOIN Puestos P ON DE.puesto_id = P.id;



-- Objetivo: Crear una función que calcule los días desde el último pedido de un cliente y
-- mostrar clientes que hayan hecho un pedido en los últimos 30 días.
-- Pasos:
-- 1. Crear la función DiasDesdeUltimoPedido que reciba el ID de un cliente y calcule los
-- días desde su último pedido.
-- 2. Realizar una consulta que muestre solo a los clientes con pedidos en los últimos 30 días

DELIMITER $$

CREATE FUNCTION DiasDesdeUltimoPedido(clienteID INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE dias INT;
    
    -- Calcular la diferencia de días entre hoy y la fecha del último pedido del cliente
    SELECT DATEDIFF(CURDATE(), MAX(fecha)) INTO dias
    FROM Pedidos
    WHERE cliente_id = clienteID;

    -- Si el cliente no tiene pedidos, devolver NULL
    RETURN IFNULL(dias, NULL);
END $$

DELIMITER ;


SELECT 
    C.id AS ClienteID, 
    C.nombre AS Cliente, 
    DiasDesdeUltimoPedido(C.id) AS DiasDesdeUltimoPedido
FROM Clientes C
WHERE DiasDesdeUltimoPedido(C.id) <= 30;



-- Objetivo: Crear una función que calcule el total en inventario (cantidad x precio) de cada
-- producto y listar productos con inventario superior a $500.
-- Pasos:
-- 1. Crear la función TotalInventarioProducto que multiplique cantidad y precio de un
-- producto.
-- 2. Realizar una consulta que muestre el nombre del producto y su total en inventario,
-- filtrando los productos con inventario superior a $500.


DELIMITER $$

CREATE FUNCTION TotalInventarioProducto(productoID INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    
    
    SELECT SUM(DP.cantidad * P.precio) INTO total
    FROM DetallesPedido DP
    JOIN Productos P ON DP.producto_id = P.id
    WHERE P.id = productoID;

   
    RETURN IFNULL(total, 0);
END $$

DELIMITER ;


SELECT 
    P.id AS ProductoID, 
    P.nombre AS Producto, 
    TotalInventarioProducto(P.id) AS TotalInventario
FROM Productos P
WHERE TotalInventarioProducto(P.id) > 500;


-- Descripción: Crear un trigger y una tabla para mantener un historial de precios de
-- productos. Cada vez que el precio de un producto cambia, el trigger debe guardar el ID del
-- producto, el precio antiguo, el nuevo precio y la fecha de cambio.
-- Pasos:
-- 1. Crear la tabla HistorialPrecios .
-- 2. Crear el trigger RegistroCambioPrecio en la tabla Productos para registrar los
-- cambios de precio.

CREATE TABLE HistorialPrecios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    producto_id INT,
    precio_anterior DECIMAL(10,2),
    precio_nuevo DECIMAL(10,2),
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (producto_id) REFERENCES Productos(id)
);


DELIMITER $$

CREATE TRIGGER RegistroCambioPrecio
BEFORE UPDATE ON Productos
FOR EACH ROW
BEGIN
    
    IF OLD.precio <> NEW.precio THEN
        INSERT INTO HistorialPrecios (producto_id, precio_anterior, precio_nuevo)
        VALUES (OLD.id, OLD.precio, NEW.precio);
    END IF;
END $$

DELIMITER ;


-- Descripción: Crear un procedimiento almacenado que genere un reporte de ventas mensual
-- para cada empleado. El procedimiento debe recibir como parámetros el mes y el año, y
-- devolver una lista de empleados con el total de ventas que gestionaron en ese periodo.
-- Pasos:
-- 1. Crear el procedimiento ReporteVentasMensuales .
-- 2. Usar una subconsulta que agrupe las ventas por empleado y que filtre por el mes y el
-- año.

DELIMITER $$

CREATE PROCEDURE ReporteVentasMensuales(IN mes INT, IN anio INT)
BEGIN
    SELECT 
        DE.id AS empleado_id,
        DE.nombre AS empleado,
        SUM(DP.cantidad * P.precio) AS total_ventas
    FROM Pedidos PD
    JOIN DetallesPedido DP ON PD.id = DP.pedido_id
    JOIN Productos P ON DP.producto_id = P.id
    JOIN DatosEmpleados DE ON PD.cliente_id = DE.id 
    WHERE MONTH(PD.fecha) = mes AND YEAR(PD.fecha) = anio
    GROUP BY DE.id, DE.nombre
    ORDER BY total_ventas DESC;
END $$

DELIMITER ;


-- Descripción: Realizar una consulta compleja que devuelva el producto más vendido para
-- cada proveedor, mostrando el nombre del proveedor, el nombre del producto y la cantidad
-- vendida.
-- Pasos:
-- 1. Utilizar una subconsulta para calcular la cantidad total de ventas por producto.
-- 2. Filtrar en la consulta principal para obtener el producto más vendido de cada
-- proveedor

SELECT 
    P.id AS proveedor_id,
    P.nombre AS proveedor,
    PR.id AS producto_id,
    PR.nombre AS producto,
    ventas_totales
FROM (
    SELECT 
        PR.proveedor_id,
        PR.id AS producto_id,
        PR.nombre,
        SUM(DP.cantidad) AS ventas_totales,
        RANK() OVER (PARTITION BY PR.proveedor_id ORDER BY SUM(DP.cantidad) DESC) AS ranking
    FROM DetallesPedido DP
    JOIN Productos PR ON DP.producto_id = PR.id
    GROUP BY PR.proveedor_id, PR.id, PR.nombre
) AS subquery
JOIN Proveedores P ON subquery.proveedor_id = P.id
JOIN Productos PR ON subquery.producto_id = PR.id
WHERE ranking = 1;


-- Descripción: Crear una función que calcule el estado de stock de un producto y lo clasifique
-- en “Alto”, “Medio” o “Bajo” en función de su cantidad. Usar esta función en una consulta para
-- listar todos los productos y su estado de stock.
-- Pasos:
-- 1. Crear la función EstadoStock que reciba la cantidad de un producto.
-- 2. En la consulta principal, utilizar la función para clasificar el estado de stock de cada
-- producto.

DELIMITER $$

CREATE FUNCTION EstadoStock(cantidad INT) RETURNS VARCHAR(10) 
DETERMINISTIC
BEGIN
    DECLARE estado VARCHAR(10);
    
    IF cantidad >= 100 THEN
        SET estado = 'Alto';
    ELSEIF cantidad BETWEEN 50 AND 99 THEN
        SET estado = 'Medio';
    ELSE
        SET estado = 'Bajo';
    END IF;
    
    RETURN estado;
END $$

DELIMITER ;


SELECT 
    P.id AS producto_id,
    P.nombre AS producto,
    I.cantidad,
    EstadoStock(I.cantidad) AS estado_stock
FROM Productos P
JOIN Inventario I ON P.id = I.producto_id;

-- Descripción: Crear un trigger que, al insertar un nuevo pedido, disminuya automáticamente
-- la cantidad en stock del producto. El trigger debe también prevenir que se inserte el pedido si
-- el stock es insuficiente.
-- Pasos:
-- 1. Crear el trigger ActualizarInventario en la tabla DetallesPedido .
-- 2. Controlar que no se permita la inserción si la cantidad es mayor que el stock disponible.

DELIMITER $$

CREATE TRIGGER ActualizarInventario
BEFORE INSERT ON DetallesPedido
FOR EACH ROW
BEGIN
    DECLARE stock_actual INT;

    
    SELECT cantidad INTO stock_actual
    FROM Inventario
    WHERE producto_id = NEW.producto_id;

    
    IF stock_actual < NEW.cantidad THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Stock insuficiente para este pedido.';
    ELSE
        
        UPDATE Inventario
        SET cantidad = cantidad - NEW.cantidad
        WHERE producto_id = NEW.producto_id;
    END IF;
END $$

DELIMITER ;
