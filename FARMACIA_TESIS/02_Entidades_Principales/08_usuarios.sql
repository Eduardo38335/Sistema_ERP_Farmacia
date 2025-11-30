/* ===========================================================
   08_usuarios
   DESCRIPCIÓN: Personal con nombres separados para mejor orden
   ===========================================================
*/

-- USE farmacia_db;

CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    
    -- DATOS DE ACCESO
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    
    -- DATOS PERSONALES (Separados para poder ordenar por apellidos)
    nombres VARCHAR(60) NOT NULL,           -- Ej: 'Juan Carlos'
    apellido_paterno VARCHAR(40) NOT NULL,  -- Ej: 'Pérez'
    apellido_materno VARCHAR(40) NULL,      -- Ej: 'López' (Opcional por si es extranjero)
    
    email VARCHAR(100) NULL,
    telefono VARCHAR(20) NULL,              -- Agregamos teléfono para contacto rápido
    
    -- RELACIÓN
    id_rol INT NOT NULL,
    
    -- CONTROL
    estatus TINYINT DEFAULT 1, 
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_rol) REFERENCES roles(id_rol)
);

-- Insertamos los usuarios de prueba con la nueva estructura
INSERT INTO usuarios 
(username, password, nombres, apellido_paterno, apellido_materno, id_rol) 
VALUES 
('admin', '12345', 'Administrador', 'Principal', '', 1),
('cajero1', '12345', 'Juan', 'Pérez', 'Gómez', 2);

SELECT * FROM usuarios;