/* ===========================================================
   12_ventas_encabezado
   UBICACIÓN: /04_Ventas_Transacciones/
   =========================================================== */

USE farmacia_db;

-- DROP TABLE IF EXISTS ventas_encabezado;

CREATE TABLE ventas_encabezado (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    
    folio_ticket VARCHAR(20) UNIQUE NULL, 
    
    -- RELACIONES (INT limpio para no dar error 3780)
    id_cliente INT NOT NULL,
    id_usuario INT NOT NULL,
    
    -- DINERO
    subtotal DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    impuestos DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    
    forma_pago ENUM('Efectivo', 'Tarjeta Debito', 'Tarjeta Credito', 'Transferencia') NOT NULL DEFAULT 'Efectivo',
    
    estatus ENUM('COMPLETADA', 'CANCELADA') DEFAULT 'COMPLETADA',
    fecha_venta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- CONSTRAINTS
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- Ejemplo de Venta
INSERT INTO ventas_encabezado 
(folio_ticket, id_cliente, id_usuario, subtotal, impuestos, total, forma_pago) 
VALUES 
('T-0001', 1, 1, 50.50, 0.00, 50.50, 'Efectivo');

SELECT * FROM ventas_encabezado;