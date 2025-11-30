/* ===========================================================
   09b_motivos_inventario
   DESCRIPCIÓN: Catálogo de causas para entradas, salidas o mermas
   ===========================================================
*/

USE farmacia_db;

CREATE TABLE IF NOT EXISTS motivos_inventario (
    id_motivo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,  -- Ej: 'Caducidad', 'Robo', 'Compra'
    descripcion VARCHAR(100) NULL,
    
    -- CONTROL
    estatus TINYINT DEFAULT 1,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertamos los motivos estándar para una farmacia
INSERT INTO motivos_inventario (nombre, descripcion) VALUES 
('Compra a Proveedor', 'Entrada de mercancía nueva con factura'),
('Venta a Cliente', 'Salida por venta en mostrador'),
('Caducidad', 'Merma por fecha de vencimiento'),
('Dañado / Roto', 'Merma por mal manejo o accidente'),
('Robo / Pérdida', 'Merma por robo hormiga o extravío'),
('Ajuste de Inventario', 'Corrección por error de conteo'),
('Devolución', 'Cliente regresa producto');

SELECT * FROM motivos_inventario;