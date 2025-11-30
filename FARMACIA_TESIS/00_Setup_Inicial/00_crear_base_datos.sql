/* ===========================================================
   DESCRIPCIÓN: Crea la base de datos limpia.
   ===========================================================
*/
-- DROP DATABASE IF EXISTS farmacia_db;
-- 2. Creamos la base de datos con soporte para acentos (UTF8)
CREATE DATABASE farmacia_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

-- 3. Seleccionamos la base para empezar a trabajar
USE farmacia_db;