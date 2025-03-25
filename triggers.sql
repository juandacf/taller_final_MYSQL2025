-- 1. Registrar en HistorialSalarios cada cambio de salario de empleados
CREATE TABLE HistorialSalarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    empleado_id INT,
    salario_anterior DECIMAL(10,2),
    salario_nuevo DECIMAL(10,2),
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (empleado_id) REFERENCES DatosEmpleados(id)
);

DELIMITER $$
CREATE TRIGGER trg_HistorialSalarios
BEFORE UPDATE ON Puestos
FOR EACH ROW
BEGIN
    IF OLD.salario <> NEW.salario THEN
        INSERT INTO HistorialSalarios (empleado_id, salario_anterior, salario_nuevo)
        SELECT id, OLD.salario, NEW.salario FROM DatosEmpleados WHERE puesto_id = OLD.id;
    END IF;
END $$
DELIMITER ;

-- 2. Evitar borrar productos con pedidos activos
DELIMITER $$
CREATE TRIGGER trg_PreventDeleteProductos
BEFORE DELETE ON Productos
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM DetallesPedido WHERE producto_id = OLD.id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede eliminar un producto con pedidos activos';
    END IF;
END $$
DELIMITER ;

-- 3. Registrar en HistorialPedidos cada actualización en Pedidos
DELIMITER $$
CREATE TRIGGER trg_HistorialPedidosUpdate
AFTER UPDATE ON Pedidos
FOR EACH ROW
BEGIN
    INSERT INTO HistorialPedidos (pedido_id, cambio)
    VALUES (NEW.id, CONCAT('Actualización en pedido ID ', NEW.id, ' en ', NOW()));
END $$
DELIMITER ;

-- 4. Actualizar el inventario al registrar un pedido
ALTER TABLE Productos ADD COLUMN stock INT DEFAULT 0;

DELIMITER $$
CREATE TRIGGER trg_ActualizarInventario
AFTER INSERT ON DetallesPedido
FOR EACH ROW
BEGIN
    UPDATE Productos
    SET stock = stock - NEW.cantidad
    WHERE id = NEW.producto_id;
END $$
DELIMITER ;

-- 5. Evitar actualizaciones de precio a menos de $1
DELIMITER $$
CREATE TRIGGER trg_ValidarPrecio
BEFORE UPDATE ON Productos
FOR EACH ROW
BEGIN
    IF NEW.precio < 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El precio del producto no puede ser menor a $1';
    END IF;
END $$
DELIMITER ;

-- 6. Registrar la fecha de creación de un pedido en HistorialPedidos
DELIMITER $$
CREATE TRIGGER trg_HistorialPedidosInsert
AFTER INSERT ON Pedidos
FOR EACH ROW
BEGIN
    INSERT INTO HistorialPedidos (pedido_id, cambio)
    VALUES (NEW.id, CONCAT('Pedido creado con ID ', NEW.id, ' en ', NOW()));
END $$
DELIMITER ;

-- 7. Mantener el precio total de cada pedido en Pedidos
ALTER TABLE Pedidos ADD COLUMN total DECIMAL(10,2) DEFAULT 0;

DELIMITER $$
CREATE TRIGGER trg_ActualizarTotalPedido
AFTER INSERT ON DetallesPedido
FOR EACH ROW
BEGIN
    UPDATE Pedidos
    SET total = (SELECT SUM(DP.cantidad * P.precio)
                 FROM DetallesPedido DP
                 JOIN Productos P ON DP.producto_id = P.id
                 WHERE DP.pedido_id = NEW.pedido_id)
    WHERE id = NEW.pedido_id;
END $$
DELIMITER ;

-- 8. Validar que UbicacionCliente no esté vacío al crear un cliente
DELIMITER $$
CREATE TRIGGER trg_ValidarUbicacionCliente
BEFORE INSERT ON Clientes
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Ubicaciones WHERE entidad_id = NEW.id AND tipo_entidad = 'Cliente') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El cliente debe tener una ubicación registrada';
    END IF;
END $$
DELIMITER ;

-- 9. Registrar en LogActividades cada modificación en Proveedores
CREATE TABLE LogActividades (
    id INT PRIMARY KEY AUTO_INCREMENT,
    entidad VARCHAR(50),
    entidad_id INT,
    accion TEXT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$
CREATE TRIGGER trg_LogProveedores
AFTER UPDATE ON Proveedores
FOR EACH ROW
BEGIN
    INSERT INTO LogActividades (entidad, entidad_id, accion)
    VALUES ('Proveedor', NEW.id, CONCAT('Modificación en proveedor ID ', NEW.id, ' en ', NOW()));
END $$
DELIMITER ;

-- 10. Registrar en HistorialContratos cada cambio en Empleados
CREATE TABLE HistorialContratos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    empleado_id INT,
    puesto_anterior INT,
    puesto_nuevo INT,
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (empleado_id) REFERENCES DatosEmpleados(id)
);

DELIMITER $$
CREATE TRIGGER trg_HistorialContratos
BEFORE UPDATE ON DatosEmpleados
FOR EACH ROW
BEGIN
    IF OLD.puesto_id <> NEW.puesto_id THEN
        INSERT INTO HistorialContratos (empleado_id, puesto_anterior, puesto_nuevo)
        VALUES (NEW.id, OLD.puesto_id, NEW.puesto_id);
    END IF;
END $$
DELIMITER ;
