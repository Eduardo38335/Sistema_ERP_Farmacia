/* ===========================================================
   ARCHIVO: 04_presentaciones
   DESCRIPCIÓN: Tipo de empaque (Caja, Frasco, Tubo, etc.)
   ===========================================================
*/

-- USE farmacia_db;
-- DROP TABLE presentaciones;
CREATE TABLE IF NOT EXISTS presentaciones (
    id_presentacion INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE, -- Ej: 'Caja', 'Frasco'
    descripcion VARCHAR(255) NULL,      -- Ej: 'Caja de cartón estándar'
    
    -- CAMPOS DE CONTROL
    estatus TINYINT DEFAULT (1) ,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertamos las presentaciones más comunes en farmacia
INSERT INTO presentaciones (nombre, descripcion) VALUES 
('Caja', 'Empaque de cartón externo'),
('Frasco', 'Para jarabes o tabletas sueltas'),
('Blister', 'Lámina de plástico/aluminio con pastillas'),
('Tubo', 'Para cremas o pomadas'),
('Ampolleta', 'Envase de vidrio sellado (Inyectables)'),
('Unidad', 'Venta individual/suelta');

SELECT * FROM presentaciones;