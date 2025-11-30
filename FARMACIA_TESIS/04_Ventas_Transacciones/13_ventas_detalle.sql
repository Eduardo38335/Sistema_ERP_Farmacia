/* ===========================================================
   13_ventas_detalle
   DESCRIPCIÓN: Renglones del ticket (Productos vendidos)
   ===========================================================
*/

-- USE farmacia_db;

-- DROP TABLE IF EXISTS ventas_detalle;

CREATE TABLE ventas_detalle (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    
    -- RELACIONES (INT limpio)
    id_venta INT NOT NULL,      -- ¿De qué ticket soy?
    id_producto INT NOT NULL,   -- ¿Qué producto soy?
    id_lote INT NOT NULL,       -- ¿De qué lote salí? (Para caducidad)
    
    -- DATOS DE LA VENTA
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL, -- Precio al momento de la venta
    importe DECIMAL(10,2) NOT NULL,         -- Cantidad * Precio
    
    -- CONSTRAINTS
    FOREIGN KEY (id_venta) REFERENCES ventas_encabezado(id_venta),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    FOREIGN KEY (id_lote) REFERENCES lotes(id_lote)
);

-- EJEMPLO DE VENTA REAL:
-- En el ticket 1, vendimos 2 cajas de Paracetamol del Lote 1
INSERT INTO ventas_detalle 
(id_venta, id_producto, id_lote, cantidad, precio_unitario, importe) 
VALUES 
(1, 1, 1, 2, 35.00, 70.00);

SELECT * FROM ventas_detalle;