/* ===========================================================
   06_proveedores
   DESCRIPCIÓN: Proveedores con Dirección Atómica (1FN)
   ===========================================================
*/

USE farmacia_db;

CREATE TABLE IF NOT EXISTS proveedores (
    id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
    
    -- IDENTIFICACIÓN
    nombre_comercial VARCHAR(100) NOT NULL UNIQUE, 
    razon_social VARCHAR(150) NULL,
    rfc VARCHAR(20) NULL, 
    
    -- CONTACTO
    telefono VARCHAR(20) NULL,
    email VARCHAR(100) NULL,
    
    -- DIRECCIÓN (NORMALIZADA - 1FN)
    -- Separamos la dirección para poder filtrar por Ciudad o Estado
    calle VARCHAR(100) NULL,
    numero_exterior VARCHAR(20) NULL,
    numero_interior VARCHAR(20) NULL,
    colonia VARCHAR(100) NULL,
    codigo_postal VARCHAR(10) NULL,
    ciudad VARCHAR(100) NULL,
    estado VARCHAR(100) NULL,
    
    -- CONTROL
    estatus TINYINT DEFAULT (1) ,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Ejemplo de inserción con dirección desglosada
INSERT INTO proveedores 
(nombre_comercial, razon_social, telefono, calle, numero_exterior, colonia, codigo_postal, ciudad, estado) 
VALUES 
('Nadro', 'Nacional de Drogas, S.A. de C.V.', '55-1234-5678', 'Av. Revolución', '123', 'Centro', '06000', 'CDMX', 'CDMX');

SELECT * FROM proveedores;