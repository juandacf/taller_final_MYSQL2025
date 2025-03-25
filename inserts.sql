INSERT INTO Clientes (nombre, email, fecha_nacimiento) VALUES
('Juan Pérez', 'juan.perez@email.com', '1985-04-12'),
('María López', 'maria.lopez@email.com', '1990-07-25'),
('Carlos Ramírez', 'carlos.ramirez@email.com', '1978-11-08'),
('Ana Torres', 'ana.torres@email.com', '1995-03-15'),
('Pedro Gómez', 'pedro.gomez@email.com', '1982-06-30');


INSERT INTO Telefonos (cliente_id, numero, tipo) VALUES
(1, '555-1234', 'Móvil'),
(1, '555-5678', 'Casa'),
(2, '555-8765', 'Móvil'),
(3, '555-4321', 'Trabajo'),
(4, '555-6789', 'Móvil'),
(5, '555-1111', 'Trabajo');

INSERT INTO Ubicaciones (entidad_id, tipo_entidad, direccion, ciudad, estado, codigo_postal, pais) VALUES
(1, 'Cliente', 'Calle A 123', 'Ciudad X', 'Estado Y', '12345', 'México'),
(2, 'Cliente', 'Avenida B 456', 'Ciudad Z', 'Estado W', '54321', 'España'),
(3, 'Cliente', 'Carrera 78 #12-34', 'Bogotá', 'Cundinamarca', '11001', 'Colombia'),
(4, 'Proveedor', 'Ruta 9 Km 300', 'Buenos Aires', 'Buenos Aires', '1400', 'Argentina'),
(5, 'Empleado', 'Rua das Palmeiras 100', 'São Paulo', 'São Paulo', '01310', 'Brasil');


INSERT INTO Puestos (nombre, salario) VALUES
('Gerente', 5000.00),
('Vendedor', 2000.00),
('Asistente', 1500.00),
('Desarrollador', 3500.00),
('Soporte Técnico', 1800.00);

INSERT INTO DatosEmpleados (nombre, puesto_id, fecha_contratacion) VALUES
('Luis Fernández', 1, '2015-06-20'),
('Sofía Martínez', 2, '2019-09-10'),
('Diego Castro', 3, '2020-01-05'),
('Valeria Ríos', 4, '2018-03-15'),
('Miguel Ortiz', 5, '2021-07-30');


INSERT INTO Proveedores (nombre) VALUES
('Tech Solutions'),
('ElectroWorld'),
('Muebles Express'),
('Distribuidora Global'),
('EcoBazar');


INSERT INTO ContactoProveedores (proveedor_id, contacto, telefono) VALUES
(1, 'Carlos Mendoza', '555-2222'),
(2, 'Ana Beltrán', '555-3333'),
(3, 'Javier Rojas', '555-4444'),
(4, 'Patricia Gómez', '555-5555'),
(5, 'Raúl Silva', '555-6666');


INSERT INTO TiposProductos (tipo_nombre, descripcion, padre_id) VALUES
('Electrónica', 'Productos electrónicos y accesorios', NULL),
('Muebles', 'Mobiliario para hogar y oficina', NULL),
('Celulares', 'Dispositivos móviles y accesorios', 1),
('Computadoras', 'Laptops, desktops y componentes', 1),
('Sillas', 'Sillas ergonómicas y de oficina', 2);


INSERT INTO Productos (nombre, precio, proveedor_id, tipo_id) VALUES
('Laptop HP Pavilion', 1200.00, 1, 4),
('iPhone 13', 999.99, 2, 3),
('Silla Gamer', 250.00, 3, 5),
('Escritorio de Madera', 350.00, 3, 2),
('Monitor Samsung 24"', 220.00, 1, 4);


INSERT INTO Pedidos (cliente_id, fecha) VALUES
(1, '2024-03-10'),
(2, '2024-03-15'),
(3, '2024-03-18'),
(4, '2024-03-22'),
(5, '2024-03-25');


INSERT INTO DetallesPedido (pedido_id, producto_id, cantidad) VALUES
(1, 1, 2),
(1, 3, 1),
(2, 2, 1),
(3, 4, 1),
(4, 5, 3),
(5, 1, 1);


INSERT INTO HistorialPedidos (pedido_id, fecha_modificacion, cambio) VALUES
(1, '2024-03-11 10:00:00', 'Pedido creado'),
(2, '2024-03-16 15:30:00', 'Pedido actualizado'),
(3, '2024-03-19 09:20:00', 'Producto agregado'),
(4, '2024-03-23 14:50:00', 'Pedido cancelado'),
(5, '2024-03-26 12:10:00', 'Pedido confirmado');


INSERT INTO Empleados_Proveedores (empleado_id, proveedor_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);
