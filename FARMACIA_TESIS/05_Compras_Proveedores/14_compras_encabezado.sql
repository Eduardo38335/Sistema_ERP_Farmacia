/* ===========================================================
   14_compras_encabezado
   DESCRIPCIÓN: Registro de facturas de proveedores
   ===========================================================
*/

USE farmacia_db;

CREATE TABLE IF NOT EXISTS compras_encabezado (
    id_compra INT AUTO_INCREMENT PRIMARY KEY,
    
    -- DATOS DE LA FACTURA FÍSICA
    folio_factura VARCHAR(50) NOT NULL, -- El número que trae el papel (Ej: A-998877)
    fecha_compra DATE NOT NULL,         -- Fecha impresa en la factura
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Cuando la metiste al sistema
    
    -- RELACIONES
    id_proveedor INT NOT NULL,          -- ¿A quién le compramos?
    id_usuario INT NOT NULL,            -- ¿Quién recibió la mercancía?
    
    -- DINERO
    subtotal DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    impuestos DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    
    -- CONTROL
    estatus ENUM('RECIBIDA', 'CANCELADA') DEFAULT 'RECIBIDA',
    comentarios TEXT NULL,
    
    -- CONSTRAINTS
    FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- EJEMPLO: Le compramos a Nadro (Proveedor 1) la Factura "F-5000"
INSERT INTO compras_encabezado 
(folio_factura, fecha_compra, id_proveedor, id_usuario, subtotal, impuestos, total) 
VALUES 
('F-5000', CURDATE(), 1, 1, 1000.00, 160.00, 1160.00);

SELECT * FROM compras_encabezado;