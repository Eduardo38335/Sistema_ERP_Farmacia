/* ===========================================================
   10_movimientos_inventario
   DESCRIPCIÓN: Bitácora con motivos estandarizados
   ===========================================================
*/

 USE farmacia_db;
-- DROP TABLE movimientos_inventario;
-- Borramos la tabla anterior para aplicar el cambio de estructura
-- DROP TABLE IF EXISTS movimientos_inventario;

CREATE TABLE IF NOT EXISTS movimientos_inventario (
    id_movimiento INT AUTO_INCREMENT PRIMARY KEY,
    
    -- ¿QUÉ SE MOVIÓ?
    id_producto INT NOT NULL,
    id_lote INT NOT NULL,
    
    -- TIPO MACRO
    tipo_movimiento ENUM('ENTRADA', 'SALIDA', 'MERMA', 'AJUSTE') NOT NULL,
    
    -- CAUSA EXACTA (Normalizada)
    id_motivo INT NOT NULL,
    
    -- DETALLES OPCIONALES (Aquí sí va el texto libre para aclarar)
    comentarios VARCHAR(255) NULL,   -- Ej: "Se le cayó a Juan limpiando"
    
    -- CANTIDADES
    cantidad INT NOT NULL,
    stock_anterior INT NOT NULL,
    stock_resultante INT NOT NULL,
    
    -- RESPONSABLE
    id_usuario INT NOT NULL,
    fecha_movimiento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- RELACIONES
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    FOREIGN KEY (id_lote) REFERENCES lotes(id_lote),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_motivo) REFERENCES motivos_inventario(id_motivo) -- ¡Nueva relación!
);

-- EJEMPLO 1: Entrada por Compra
-- Usamos id_motivo = 1 (Compra a Proveedor)
INSERT INTO movimientos_inventario 
(id_producto, id_lote, tipo_movimiento, id_motivo, comentarios, cantidad, stock_anterior, stock_resultante, id_usuario) 
VALUES 
(1, 1, 'ENTRADA', 1, 'Factura A-100', 10, 0, 10, 1);

-- EJEMPLO 2: Merma por Rotura
-- Usamos id_motivo = 4 (Dañado/Roto)
INSERT INTO movimientos_inventario 
(id_producto, id_lote, tipo_movimiento, id_motivo, comentarios, cantidad, stock_anterior, stock_resultante, id_usuario) 
VALUES 
(1, 1, 'MERMA', 4, 'Se cayó al limpiar estante', 1, 10, 9, 2);

SELECT * FROM movimientos_inventario;