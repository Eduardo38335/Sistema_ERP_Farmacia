/* ===========================================================
   05_unidades_medida
   DESCRIPCIÓN: Magnitudes físicas (mg, ml, gr, piezas)
   ===========================================================
*/

-- USE farmacia_db;

CREATE TABLE IF NOT EXISTS unidades_medida (
    id_unidad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL UNIQUE, -- Ej: 'mg', 'ml', 'g'
    descripcion VARCHAR(100) NULL,      -- Ej: 'Miligramos', 'Mililitros'
    
    estatus TINYINT DEFAULT (1) ,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertamos las unidades universales de farmacia
INSERT INTO unidades_medida (nombre, descripcion) VALUES 
('mg', 'Miligramos (Peso)'),
('g', 'Gramos (Peso)'),
('ml', 'Mililitros (Volumen)'),
('l', 'Litros (Volumen)'),
('pza', 'Piezas/Unidades (Conteo)'),
('ui', 'Unidades Internacionales (Vitaminas)');

SELECT * FROM unidades_medida;