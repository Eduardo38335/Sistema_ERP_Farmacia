/* ===========================================================
   ARCHIVO: 03_laboratorios
   DESCRIPCIÓN: Marcas o fabricantes de los medicamentos.
   =========================================================== */

-- USE farmacia_db;
-- DROP TABLE laboratorios;
CREATE TABLE IF NOT EXISTS laboratorios (
    id_laboratorio INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE, -- Ej: 'Bayer', 'Genomma Lab'
    origen VARCHAR(50) NULL,             -- Ej: 'Nacional', 'Importado' (Opcional)
    
    estatus TINYINT DEFAULT(1),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Datos de ejemplo
INSERT INTO laboratorios (nombre, origen) VALUES 
('Bayer', 'Internacional'),
('Pfizer', 'Internacional'),
('Genéricos GI', 'Nacional'),
('Sanfer', 'Nacional');

SELECT * FROM laboratorios;