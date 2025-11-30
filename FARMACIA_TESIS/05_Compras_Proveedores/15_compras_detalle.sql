/* ===========================================================
   15_compras_detalle
   DESCRIPCIÓN: Productos individuales de la factura
   ===========================================================
*/

USE farmacia_db;

CREATE TABLE IF NOT EXISTS compras_detalle (
    id_detalle_compra INT AUTO_INCREMENT PRIMARY KEY,
    
    -- RELACIONES
    id_compra INT NOT NULL,     -- Pertenece al encabezado anterior
    id_producto INT NOT NULL,   -- Qué compramos
    
    -- DATOS ESPECÍFICOS DE LA COMPRA
    cantidad INT NOT NULL,              -- Cuántas cajas llegaron
    costo_unitario DECIMAL(10,2) NOT NULL, -- A cómo nos lo dieron ESTA VEZ
    importe DECIMAL(10,2) NOT NULL,     -- Cantidad * Costo
    
    -- INFORMACIÓN DE LOTE (Vital para generar la entrada al inventario después)
    -- Aquí registramos qué lote venía impreso en la caja que llegó
    lote_fabricante VARCHAR(50) NOT NULL, -- Ej: 'LOTE-X-2025'
    fecha_caducidad DATE NOT NULL,
    
    -- CONSTRAINTS
    FOREIGN KEY (id_compra) REFERENCES compras_encabezado(id_compra),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- EJEMPLO: En la factura F-5000 venían 20 cajas de Amoxicilina
INSERT INTO compras_detalle 
(id_compra, id_producto, cantidad, costo_unitario, importe, lote_fabricante, fecha_caducidad) 
VALUES 
(1, 1, 20, 40.00, 800.00, 'LOTE-RECIBIDO-HOY', '2025-12-31');

SELECT * FROM compras_detalle;