/* ===========================================================
   ARCHIVO: 02_categorias
   DESCRIPCIÓN: Clasificación de productos (Antibióticos, Higiene, etc.)
   ===========================================================
*/

-- USE farmacia_db;

CREATE TABLE IF NOT EXISTS categorias (
	-- INT(4) UNSIGNED ZEROFILL: 
    -- Hace que el 1 se vea como 0001, el 20 como 0020, etc.
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE, -- Ej: 'Analgesicos'
    descripcion VARCHAR(255) NULL,
    
    -- CAMPOS DE CONTROL
    estatus TINYINT DEFAULT (1),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertamos datos reales de una farmacia para probar
INSERT INTO categorias (nombre, descripcion) VALUES 
('Antibióticos', 'Medicamentos para infecciones (Requiere Receta)'),
('Analgésicos', 'Medicamentos para el dolor y fiebre'),
('Gastroenterología', 'Antiácidos, sueros, estomacales'),
('Higiene Personal', 'Jabones, Shampoos, Pastas'),
('Material de Curación', 'Gasas, Alcohol, Jeringas');

SELECT * FROM CATEGORIAS;
