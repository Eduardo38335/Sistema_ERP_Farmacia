/* ===========================================================
   11_clientes
   DESCRIPCIÓN: Directorio de clientes para facturación
   ===========================================================
*/

USE farmacia_db;

CREATE TABLE IF NOT EXISTS clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    
    -- DATOS PERSONALES (Atómicos)
    nombres VARCHAR(60) NOT NULL,
    apellido_paterno VARCHAR(40) NOT NULL,
    apellido_materno VARCHAR(40) NULL,
    
    -- DATOS FISCALES (Para Factura)
    rfc VARCHAR(20) NULL,             -- Registro Federal de Contribuyentes
    razon_social VARCHAR(150) NULL,   -- Si es empresa, aquí va su nombre legal
    regimen_fiscal VARCHAR(100) NULL, -- Dato obligatorio para facturación 4.0
    
    -- CONTACTO
    telefono VARCHAR(20) NULL,
    email VARCHAR(100) NULL,
    
    -- DIRECCIÓN (Separada para Facturación correcta)
    calle VARCHAR(100) NULL,
    numero_exterior VARCHAR(20) NULL,
    numero_interior VARCHAR(20) NULL,
    colonia VARCHAR(100) NULL,
    codigo_postal VARCHAR(10) NULL,
    ciudad VARCHAR(100) NULL,
    estado VARCHAR(100) NULL,
    
    -- CONTROL
    estatus TINYINT DEFAULT 1,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- DATO OBLIGATORIO: El Cliente "Público en General"
-- En México se usa el RFC genérico: XAXX010101000
-- Este será siempre el cliente ID 0001 (Venta de mostrador rápida)
INSERT INTO clientes 
(nombres, apellido_paterno, rfc, razon_social) 
VALUES 
('Público', 'General', 'XAXX010101000', 'Venta al Mostrador');

-- Un cliente real de ejemplo
INSERT INTO clientes 
(nombres, apellido_paterno, apellido_materno, rfc, email, telefono) 
VALUES 
('María', 'González', 'López', 'GOLM900101HDF', 'maria@email.com', '55-9999-8888');

SELECT * FROM clientes;