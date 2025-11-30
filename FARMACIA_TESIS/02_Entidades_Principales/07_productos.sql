/* ===========================================================
   07_productos
   DESCRIPCIÓN: Catálogo Maestro con SKU (Interno) y UPC (Escáner)
   ===========================================================
*/

USE farmacia_db;
-- DROP TABLE PRODUCTOS;
CREATE TABLE IF NOT EXISTS productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    
    -- 1. CÓDIGO INTERNO (Corto, para teclear)
    sku VARCHAR(50) NOT NULL UNIQUE,       -- Ej: 'PAR-500-GI'
    
    -- 2. CÓDIGO DE ESCÁNER (Renombrado a UPC por comodidad)
    upc VARCHAR(50) NULL,                  -- Guarda EAN-13 o UPC-12
    
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT NULL,
    
    -- RELACIONES
    id_categoria INT NOT NULL,
    id_laboratorio INT NOT NULL,
    id_presentacion INT NOT NULL,
    id_unidad INT NOT NULL,
    
    -- FINANZAS
    precio_compra DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    precio_venta DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    
    -- LOGÍSTICA
    tiene_iva TINYINT DEFAULT 0,
    stock_minimo INT DEFAULT 5,
    
    estatus TINYINT DEFAULT (1) ,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- CONSTRAINTS
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria),
    FOREIGN KEY (id_laboratorio) REFERENCES laboratorios(id_laboratorio),
    FOREIGN KEY (id_presentacion) REFERENCES presentaciones(id_presentacion),
    FOREIGN KEY (id_unidad) REFERENCES unidades_medida(id_unidad)
);

-- Ejemplo de inserción
INSERT INTO productos 
(sku, upc, nombre, id_categoria, id_laboratorio, id_presentacion, id_unidad, precio_compra, precio_venta) 
VALUES 
('PAR-500-GI', '7501234567890', 'Paracetamol 500mg', 1, 1, 1, 1, 15.50, 35.00);

SELECT * FROM productos;
USE farmacia_db;
-- Agregamos la bandera para saber qué SÍ puede recomendar la IA
ALTER TABLE productos 
ADD COLUMN requiere_receta TINYINT DEFAULT 0 AFTER precio_venta; 
-- 0 = Venta Libre (Lo puede recomendar la IA)
-- 1 = Requiere Receta (La IA lo ignora)