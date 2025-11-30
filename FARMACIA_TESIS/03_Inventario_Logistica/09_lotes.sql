/* ===========================================================
   09_lotesx
   DESCRIPCIÓN: Control de Existencias, Caducidades y Ubicación
   ===========================================================
*/

USE farmacia_db;

CREATE TABLE IF NOT EXISTS lotes (
    id_lote INT AUTO_INCREMENT PRIMARY KEY,
    
    -- ¿DE QUÉ PRODUCTO ES ESTE LOTE?
    id_producto INT NOT NULL,
    
    -- DATOS DEL LOTE FÍSICO
    numero_lote VARCHAR(50) NOT NULL,  -- Lo que viene impreso en la caja (ej: 'L-2024-X')
    fecha_caducidad DATE NOT NULL,     -- ¡DATO CRÍTICO PARA FARMACIAS!
    
    -- CANTIDADES (INVENTARIO)
    stock_inicial INT NOT NULL,        -- Cuántos llegaron cuando se compró
    stock_actual INT NOT NULL,         -- Cuántos quedan hoy (este número bajará con las ventas)
    
    -- COSTOS ESPECÍFICOS DEL LOTE
    -- El costo puede cambiar. El lote de Enero costó $10, el de Marzo costó $12.
    costo_compra DECIMAL(10,2) NOT NULL, 
    
    -- UBICACIÓN (Opcional, pero útil)
    ubicacion_almacen VARCHAR(50) NULL, -- Ej: 'Estante A, Repisa 2'
    
    -- CONTROL
    estatus TINYINT DEFAULT 1, -- 1=Activo, 0=Agotado/Cancelado
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- RELACIONES
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- EJEMPLO DE LA VIDA REAL:
-- Compramos 100 cajas de Paracetamol que caducan en 2026
INSERT INTO lotes 
(id_producto, numero_lote, fecha_caducidad, stock_inicial, stock_actual, costo_compra, ubicacion_almacen) 
VALUES 
(1, 'BATCH-001-A', '2026-12-31', 100, 100, 15.50, 'Anaquel 1');

-- Compramos otras 50 cajas del MISMO producto, pero caducan antes (2025)
INSERT INTO lotes 
(id_producto, numero_lote, fecha_caducidad, stock_inicial, stock_actual, costo_compra, ubicacion_almacen) 
VALUES 
(1, 'BATCH-002-B', '2025-06-30', 50, 50, 16.00, 'Anaquel 1');

SELECT * FROM lotes;