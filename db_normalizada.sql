
CREATE DATABASE vtaszfs;
USE vtaszfs;


CREATE TABLE Clientes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    fecha_nacimiento DATE
);


CREATE TABLE Telefonos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT,
    numero VARCHAR(20),
    tipo ENUM('Móvil', 'Casa', 'Trabajo'),
    FOREIGN KEY (cliente_id) REFERENCES Clientes(id)
);


CREATE TABLE Ubicaciones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    entidad_id INT,  
    tipo_entidad ENUM('Cliente', 'Proveedor', 'Empleado'),
    direccion VARCHAR(255),
    ciudad VARCHAR(100),
    estado VARCHAR(50),
    codigo_postal VARCHAR(10),
    pais VARCHAR(50)
);


CREATE TABLE Puestos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50),
    salario DECIMAL(10, 2)
);


CREATE TABLE DatosEmpleados (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    puesto_id INT,
    fecha_contratacion DATE,
    FOREIGN KEY (puesto_id) REFERENCES Puestos(id)
);


CREATE TABLE Proveedores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100)
);


CREATE TABLE ContactoProveedores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    proveedor_id INT,
    contacto VARCHAR(100),
    telefono VARCHAR(20),
    FOREIGN KEY (proveedor_id) REFERENCES Proveedores(id)
);


CREATE TABLE TiposProductos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tipo_nombre VARCHAR(100),
    descripcion TEXT,
    padre_id INT NULL,
    FOREIGN KEY (padre_id) REFERENCES TiposProductos(id)
);


CREATE TABLE Productos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    precio DECIMAL(10, 2),
    proveedor_id INT,
    tipo_id INT,
    FOREIGN KEY (proveedor_id) REFERENCES Proveedores(id),
    FOREIGN KEY (tipo_id) REFERENCES TiposProductos(id)
);


CREATE TABLE Pedidos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT,
    fecha DATE,
    FOREIGN KEY (cliente_id) REFERENCES Clientes(id)
);


CREATE TABLE DetallesPedido (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT,
    producto_id INT,
    cantidad INT,
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(id),
    FOREIGN KEY (producto_id) REFERENCES Productos(id)
);


CREATE TABLE HistorialPedidos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    cambio TEXT,
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(id)
);


CREATE TABLE Empleados_Proveedores (
    empleado_id INT,
    proveedor_id INT,
    PRIMARY KEY (empleado_id, proveedor_id),
    FOREIGN KEY (empleado_id) REFERENCES DatosEmpleados(id),
    FOREIGN KEY (proveedor_id) REFERENCES Proveedores(id)
);