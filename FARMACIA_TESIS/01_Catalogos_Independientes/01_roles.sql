/* ===========================================================
   DESCRIPCIÓN: Define los niveles de acceso (Admin, Cajero, etc.)
   ===========================================================
*/

-- USE farmacia_db;
-- drop table roles;
CREATE TABLE IF NOT EXISTS roles (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,  -- Ej: 'Administrador'
    descripcion VARCHAR(255) NULL,       -- Ej: 'Tiene acceso total'
    
    -- AUDITORÍA Y CONTROL (Clave para clientes reales)
    estatus TINYINT DEFAULT (1),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    /*
     TINYINT(1) 1=Activo, 0=Inactivo (Borrado lógico).
     Si el cliente te dice "Ya no quiero que exista el rol de Almacenista",
     NO borras el registro (porque romperías historiales antiguos).
     Simplemente cambias este numerito a 0 y el sistema lo oculta.
     Se llama "Borrado Lógico".
    */
);

-- Insertamos los roles básicos que necesita una farmacia
INSERT INTO roles (nombre, descripcion) VALUES 
('Administrador', 'Dueño o Gerente. Acceso total al sistema.'),
('Farmacéutico', 'Encargado de mostrador y dispensación.'),
('Almacenista', 'Encargado de recibir mercancía e inventarios.');

SELECT * FROM ROLES;