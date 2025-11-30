/* ===========================================================
   ARCHIVO: 16_ia_reglas.sql
   DESCRIPCIÓN: El "Cerebro" donde se guarda lo aprendido
   ===========================================================
*/

-- USE farmacia_db;

CREATE TABLE IF NOT EXISTS ia_reglas_asociacion (
    id_regla INT AUTO_INCREMENT PRIMARY KEY,
    
    -- LA PREMISA (Si el cliente compra esto...)
    id_producto_origen INT NOT NULL,
    
    -- LA SUGERENCIA (Sugiérele esto...)
    id_producto_destino INT NOT NULL,
    
    -- LA FUERZA DE LA REGLA (Estadística)
    confianza DECIMAL(5,4) NOT NULL, -- Ej: 0.8500 significa 85% de probabilidad
    
    fecha_calculo TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Cuándo aprendió esto
    
    FOREIGN KEY (id_producto_origen) REFERENCES productos(id_producto),
    FOREIGN KEY (id_producto_destino) REFERENCES productos(id_producto)
);

-- EJEMPLO DE LO QUE GUARDARÁ LA IA AUTOMÁTICAMENTE:
-- "Si compra Paracetamol (1), hay un 85% de probabilidad de que quiera Amoxicilina (2)"
-- INSERT INTO ia_reglas_asociacion (id_producto_origen, id_producto_destino, confianza) VALUES (1, 2, 0.85);