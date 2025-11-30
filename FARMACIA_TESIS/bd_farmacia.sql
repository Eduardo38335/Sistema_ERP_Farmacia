CREATE DATABASE  IF NOT EXISTS `farmacia_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `farmacia_db`;
-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: farmacia_db
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `categorias`
--

DROP TABLE IF EXISTS `categorias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categorias` (
  `id_categoria` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estatus` tinyint DEFAULT (1),
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_categoria`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorias`
--

LOCK TABLES `categorias` WRITE;
/*!40000 ALTER TABLE `categorias` DISABLE KEYS */;
INSERT INTO `categorias` VALUES (1,'Antibióticos','Medicamentos para infecciones (Requiere Receta)',1,'2025-11-25 03:43:25'),(2,'Analgésicos','Medicamentos para el dolor y fiebre',1,'2025-11-25 03:43:25'),(3,'Gastroenterología','Antiácidos, sueros, estomacales',1,'2025-11-25 03:43:25'),(4,'Higiene Personal','Jabones, Shampoos, Pastas',1,'2025-11-25 03:43:25'),(5,'Material de Curación','Gasas, Alcohol, Jeringas',1,'2025-11-25 03:43:25');
/*!40000 ALTER TABLE `categorias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `id_cliente` int NOT NULL AUTO_INCREMENT,
  `nombres` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellido_paterno` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellido_materno` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rfc` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `razon_social` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `regimen_fiscal` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `calle` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `numero_exterior` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `numero_interior` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `colonia` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `codigo_postal` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ciudad` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estatus` tinyint DEFAULT '1',
  `fecha_registro` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_cliente`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'Público','General',NULL,'XAXX010101000','Venta al Mostrador',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2025-11-25 03:44:58'),(2,'María','González','López','GOLM900101HDF',NULL,NULL,'55-9999-8888','maria@email.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2025-11-25 03:44:58'),(3,'Público','General',NULL,'XAXX010101000','Venta al Mostrador',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2025-11-29 22:46:04'),(4,'María','González','López','GOLM900101HDF',NULL,NULL,'55-9999-8888','maria@email.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2025-11-29 22:46:04');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `compras_detalle`
--

DROP TABLE IF EXISTS `compras_detalle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `compras_detalle` (
  `id_detalle_compra` int NOT NULL AUTO_INCREMENT,
  `id_compra` int NOT NULL,
  `id_producto` int NOT NULL,
  `cantidad` int NOT NULL,
  `costo_unitario` decimal(10,2) NOT NULL,
  `importe` decimal(10,2) NOT NULL,
  `lote_fabricante` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_caducidad` date NOT NULL,
  PRIMARY KEY (`id_detalle_compra`),
  KEY `id_compra` (`id_compra`),
  KEY `id_producto` (`id_producto`),
  CONSTRAINT `compras_detalle_ibfk_1` FOREIGN KEY (`id_compra`) REFERENCES `compras_encabezado` (`id_compra`),
  CONSTRAINT `compras_detalle_ibfk_2` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `compras_detalle`
--

LOCK TABLES `compras_detalle` WRITE;
/*!40000 ALTER TABLE `compras_detalle` DISABLE KEYS */;
INSERT INTO `compras_detalle` VALUES (1,1,1,20,40.00,800.00,'LOTE-RECIBIDO-HOY','2025-12-31'),(2,1,1,20,40.00,800.00,'LOTE-RECIBIDO-HOY','2025-12-31'),(3,3,4,20,50.00,1000.00,'LOTE-PRUEBA-1','2026-12-29'),(4,4,2,20,35.00,700.00,'xxxx','0001-12-12'),(5,4,4,2,100.00,200.00,'111222','0001-12-12'),(6,4,3,14,124.00,1736.00,'3333','0001-12-12');
/*!40000 ALTER TABLE `compras_detalle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `compras_encabezado`
--

DROP TABLE IF EXISTS `compras_encabezado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `compras_encabezado` (
  `id_compra` int NOT NULL AUTO_INCREMENT,
  `folio_factura` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_compra` date NOT NULL,
  `fecha_registro` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_proveedor` int NOT NULL,
  `id_usuario` int NOT NULL,
  `subtotal` decimal(10,2) NOT NULL DEFAULT '0.00',
  `impuestos` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `estatus` enum('RECIBIDA','CANCELADA') COLLATE utf8mb4_unicode_ci DEFAULT 'RECIBIDA',
  `comentarios` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_compra`),
  KEY `id_proveedor` (`id_proveedor`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `compras_encabezado_ibfk_1` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedores` (`id_proveedor`),
  CONSTRAINT `compras_encabezado_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `compras_encabezado`
--

LOCK TABLES `compras_encabezado` WRITE;
/*!40000 ALTER TABLE `compras_encabezado` DISABLE KEYS */;
INSERT INTO `compras_encabezado` VALUES (1,'F-5000','2025-11-25','2025-11-25 06:45:41',1,1,1000.00,160.00,1160.00,'RECIBIDA',NULL),(2,'F-5000','2025-11-29','2025-11-29 22:46:52',1,1,1000.00,160.00,1160.00,'RECIBIDA',NULL),(3,'0000','2025-11-29','2025-11-30 05:27:49',1,1,1000.00,0.00,1000.00,'RECIBIDA',NULL),(4,'11111','2025-12-12','2025-11-30 07:30:29',1,1,2636.00,429.76,3065.76,'RECIBIDA',NULL);
/*!40000 ALTER TABLE `compras_encabezado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ia_reglas_asociacion`
--

DROP TABLE IF EXISTS `ia_reglas_asociacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ia_reglas_asociacion` (
  `id_regla` int NOT NULL AUTO_INCREMENT,
  `id_producto_origen` int NOT NULL,
  `id_producto_destino` int NOT NULL,
  `confianza` decimal(5,4) NOT NULL,
  `fecha_calculo` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_regla`),
  KEY `id_producto_origen` (`id_producto_origen`),
  KEY `id_producto_destino` (`id_producto_destino`),
  CONSTRAINT `ia_reglas_asociacion_ibfk_1` FOREIGN KEY (`id_producto_origen`) REFERENCES `productos` (`id_producto`),
  CONSTRAINT `ia_reglas_asociacion_ibfk_2` FOREIGN KEY (`id_producto_destino`) REFERENCES `productos` (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ia_reglas_asociacion`
--

LOCK TABLES `ia_reglas_asociacion` WRITE;
/*!40000 ALTER TABLE `ia_reglas_asociacion` DISABLE KEYS */;
/*!40000 ALTER TABLE `ia_reglas_asociacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `laboratorios`
--

DROP TABLE IF EXISTS `laboratorios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `laboratorios` (
  `id_laboratorio` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `origen` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estatus` tinyint DEFAULT (1),
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_laboratorio`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `laboratorios`
--

LOCK TABLES `laboratorios` WRITE;
/*!40000 ALTER TABLE `laboratorios` DISABLE KEYS */;
INSERT INTO `laboratorios` VALUES (1,'Bayer','Internacional',1,'2025-11-25 03:43:30'),(2,'Pfizer','Internacional',1,'2025-11-25 03:43:30'),(3,'Genéricos GI','Nacional',1,'2025-11-25 03:43:30'),(4,'Sanfer','Nacional',1,'2025-11-25 03:43:30');
/*!40000 ALTER TABLE `laboratorios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lotes`
--

DROP TABLE IF EXISTS `lotes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lotes` (
  `id_lote` int NOT NULL AUTO_INCREMENT,
  `id_producto` int NOT NULL,
  `numero_lote` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_caducidad` date NOT NULL,
  `stock_inicial` int NOT NULL,
  `stock_actual` int NOT NULL,
  `costo_compra` decimal(10,2) NOT NULL,
  `ubicacion_almacen` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estatus` tinyint DEFAULT '1',
  `fecha_registro` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_lote`),
  KEY `id_producto` (`id_producto`),
  CONSTRAINT `lotes_ibfk_1` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lotes`
--

LOCK TABLES `lotes` WRITE;
/*!40000 ALTER TABLE `lotes` DISABLE KEYS */;
INSERT INTO `lotes` VALUES (1,1,'LOTE-VIEJO','2024-12-31',20,18,40.00,NULL,1,'2025-11-30 02:36:38'),(2,1,'LOTE-NUEVO','2026-06-30',50,50,42.00,NULL,1,'2025-11-30 02:36:38'),(3,4,'LOTE-PRUEBA-1','2026-12-29',20,20,50.00,NULL,1,'2025-11-30 05:27:49'),(4,2,'xxxx','0001-12-12',20,20,35.00,NULL,1,'2025-11-30 07:30:29'),(5,4,'111222','0001-12-12',2,2,100.00,NULL,1,'2025-11-30 07:30:29'),(6,3,'3333','0001-12-12',14,14,124.00,NULL,1,'2025-11-30 07:30:29');
/*!40000 ALTER TABLE `lotes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `motivos_inventario`
--

DROP TABLE IF EXISTS `motivos_inventario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `motivos_inventario` (
  `id_motivo` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estatus` tinyint DEFAULT '1',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_motivo`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `motivos_inventario`
--

LOCK TABLES `motivos_inventario` WRITE;
/*!40000 ALTER TABLE `motivos_inventario` DISABLE KEYS */;
INSERT INTO `motivos_inventario` VALUES (1,'Compra a Proveedor','Entrada de mercancía nueva con factura',1,'2025-11-25 03:44:30'),(2,'Venta a Cliente','Salida por venta en mostrador',1,'2025-11-25 03:44:30'),(3,'Caducidad','Merma por fecha de vencimiento',1,'2025-11-25 03:44:30'),(4,'Dañado / Roto','Merma por mal manejo o accidente',1,'2025-11-25 03:44:30'),(5,'Robo / Pérdida','Merma por robo hormiga o extravío',1,'2025-11-25 03:44:30'),(6,'Ajuste de Inventario','Corrección por error de conteo',1,'2025-11-25 03:44:30'),(7,'Devolución','Cliente regresa producto',1,'2025-11-25 03:44:30');
/*!40000 ALTER TABLE `motivos_inventario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movimientos_inventario`
--

DROP TABLE IF EXISTS `movimientos_inventario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movimientos_inventario` (
  `id_movimiento` int NOT NULL AUTO_INCREMENT,
  `id_producto` int NOT NULL,
  `id_lote` int NOT NULL,
  `tipo_movimiento` enum('ENTRADA','SALIDA','MERMA','AJUSTE') COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_motivo` int NOT NULL,
  `comentarios` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cantidad` int NOT NULL,
  `stock_anterior` int NOT NULL,
  `stock_resultante` int NOT NULL,
  `id_usuario` int NOT NULL,
  `fecha_movimiento` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_movimiento`),
  KEY `id_producto` (`id_producto`),
  KEY `id_lote` (`id_lote`),
  KEY `id_usuario` (`id_usuario`),
  KEY `id_motivo` (`id_motivo`),
  CONSTRAINT `movimientos_inventario_ibfk_1` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`),
  CONSTRAINT `movimientos_inventario_ibfk_2` FOREIGN KEY (`id_lote`) REFERENCES `lotes` (`id_lote`),
  CONSTRAINT `movimientos_inventario_ibfk_3` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`),
  CONSTRAINT `movimientos_inventario_ibfk_4` FOREIGN KEY (`id_motivo`) REFERENCES `motivos_inventario` (`id_motivo`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movimientos_inventario`
--

LOCK TABLES `movimientos_inventario` WRITE;
/*!40000 ALTER TABLE `movimientos_inventario` DISABLE KEYS */;
INSERT INTO `movimientos_inventario` VALUES (1,4,3,'ENTRADA',1,NULL,20,0,20,1,'2025-11-30 05:27:49'),(2,2,4,'ENTRADA',1,NULL,20,0,20,1,'2025-11-30 07:30:29'),(3,4,5,'ENTRADA',1,NULL,2,0,2,1,'2025-11-30 07:30:29'),(4,3,6,'ENTRADA',1,NULL,14,0,14,1,'2025-11-30 07:30:29');
/*!40000 ALTER TABLE `movimientos_inventario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `presentaciones`
--

DROP TABLE IF EXISTS `presentaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `presentaciones` (
  `id_presentacion` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estatus` tinyint DEFAULT (1),
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_presentacion`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `presentaciones`
--

LOCK TABLES `presentaciones` WRITE;
/*!40000 ALTER TABLE `presentaciones` DISABLE KEYS */;
INSERT INTO `presentaciones` VALUES (1,'Caja','Empaque de cartón externo',1,'2025-11-25 03:43:36'),(2,'Frasco','Para jarabes o tabletas sueltas',1,'2025-11-25 03:43:36'),(3,'Blister','Lámina de plástico/aluminio con pastillas',1,'2025-11-25 03:43:36'),(4,'Tubo','Para cremas o pomadas',1,'2025-11-25 03:43:36'),(5,'Ampolleta','Envase de vidrio sellado (Inyectables)',1,'2025-11-25 03:43:36'),(6,'Unidad','Venta individual/suelta',1,'2025-11-25 03:43:36');
/*!40000 ALTER TABLE `presentaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productos`
--

DROP TABLE IF EXISTS `productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productos` (
  `id_producto` int NOT NULL AUTO_INCREMENT,
  `sku` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `upc` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nombre` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `id_categoria` int NOT NULL,
  `id_laboratorio` int NOT NULL,
  `id_presentacion` int NOT NULL,
  `id_unidad` int NOT NULL,
  `precio_compra` decimal(10,2) NOT NULL DEFAULT '0.00',
  `precio_venta` decimal(10,2) NOT NULL DEFAULT '0.00',
  `requiere_receta` tinyint DEFAULT '0',
  `tiene_iva` tinyint DEFAULT '0',
  `stock_minimo` int DEFAULT '5',
  `estatus` tinyint DEFAULT (1),
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_producto`),
  UNIQUE KEY `sku` (`sku`),
  KEY `id_categoria` (`id_categoria`),
  KEY `id_laboratorio` (`id_laboratorio`),
  KEY `id_presentacion` (`id_presentacion`),
  KEY `id_unidad` (`id_unidad`),
  CONSTRAINT `productos_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id_categoria`),
  CONSTRAINT `productos_ibfk_2` FOREIGN KEY (`id_laboratorio`) REFERENCES `laboratorios` (`id_laboratorio`),
  CONSTRAINT `productos_ibfk_3` FOREIGN KEY (`id_presentacion`) REFERENCES `presentaciones` (`id_presentacion`),
  CONSTRAINT `productos_ibfk_4` FOREIGN KEY (`id_unidad`) REFERENCES `unidades_medida` (`id_unidad`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
INSERT INTO `productos` VALUES (1,'AMOX-500',NULL,'Amoxicilina 500mg',NULL,1,1,1,1,40.00,85.00,0,0,5,1,'2025-11-30 02:36:38'),(2,'PAR-500-GI','7501234567890','Paracetamol 500mg',NULL,1,1,1,1,15.50,35.00,0,0,5,1,'2025-11-30 02:41:11'),(3,'TRIB-100','7502208894786','TRIBEDOCE','TIAMINA, PIRIDOIXINA, CIANOCOBALAMINA',2,3,1,1,40.00,80.00,0,0,5,1,'2025-11-30 04:21:59'),(4,'VESSEL-250','8020030091252','VESSEL DUE F','SULODEXINA',1,1,1,1,50.00,120.00,0,0,5,1,'2025-11-30 04:26:55');
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proveedores`
--

DROP TABLE IF EXISTS `proveedores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proveedores` (
  `id_proveedor` int NOT NULL AUTO_INCREMENT,
  `nombre_comercial` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `razon_social` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rfc` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `calle` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `numero_exterior` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `numero_interior` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `colonia` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `codigo_postal` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ciudad` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estatus` tinyint DEFAULT (1),
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_proveedor`),
  UNIQUE KEY `nombre_comercial` (`nombre_comercial`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proveedores`
--

LOCK TABLES `proveedores` WRITE;
/*!40000 ALTER TABLE `proveedores` DISABLE KEYS */;
INSERT INTO `proveedores` VALUES (1,'Nadro','Nacional de Drogas, S.A. de C.V.',NULL,'55-1234-5678',NULL,'Av. Revolución','123',NULL,'Centro','06000','CDMX','CDMX',1,'2025-11-25 03:43:47');
/*!40000 ALTER TABLE `proveedores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id_rol` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estatus` tinyint DEFAULT (1),
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_rol`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'Administrador','Dueño o Gerente. Acceso total al sistema.',1,'2025-11-25 03:43:20'),(2,'Farmacéutico','Encargado de mostrador y dispensación.',1,'2025-11-25 03:43:20'),(3,'Almacenista','Encargado de recibir mercancía e inventarios.',1,'2025-11-25 03:43:20');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unidades_medida`
--

DROP TABLE IF EXISTS `unidades_medida`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `unidades_medida` (
  `id_unidad` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estatus` tinyint DEFAULT (1),
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_unidad`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unidades_medida`
--

LOCK TABLES `unidades_medida` WRITE;
/*!40000 ALTER TABLE `unidades_medida` DISABLE KEYS */;
INSERT INTO `unidades_medida` VALUES (1,'mg','Miligramos (Peso)',1,'2025-11-25 03:43:41'),(2,'g','Gramos (Peso)',1,'2025-11-25 03:43:41'),(3,'ml','Mililitros (Volumen)',1,'2025-11-25 03:43:41'),(4,'l','Litros (Volumen)',1,'2025-11-25 03:43:41'),(5,'pza','Piezas/Unidades (Conteo)',1,'2025-11-25 03:43:41'),(6,'ui','Unidades Internacionales (Vitaminas)',1,'2025-11-25 03:43:41');
/*!40000 ALTER TABLE `unidades_medida` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombres` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellido_paterno` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellido_materno` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_rol` int NOT NULL,
  `estatus` tinyint DEFAULT '1',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `username` (`username`),
  KEY `id_rol` (`id_rol`),
  CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'admin','12345','Administrador','Principal','',NULL,NULL,1,1,'2025-11-25 03:44:13'),(2,'cajero1','12345','Juan','Pérez','Gómez',NULL,NULL,2,1,'2025-11-25 03:44:13');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ventas_detalle`
--

DROP TABLE IF EXISTS `ventas_detalle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ventas_detalle` (
  `id_detalle` int NOT NULL AUTO_INCREMENT,
  `id_venta` int NOT NULL,
  `id_producto` int NOT NULL,
  `id_lote` int NOT NULL,
  `cantidad` int NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `importe` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id_detalle`),
  KEY `id_venta` (`id_venta`),
  KEY `id_producto` (`id_producto`),
  KEY `id_lote` (`id_lote`),
  CONSTRAINT `ventas_detalle_ibfk_1` FOREIGN KEY (`id_venta`) REFERENCES `ventas_encabezado` (`id_venta`),
  CONSTRAINT `ventas_detalle_ibfk_2` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`),
  CONSTRAINT `ventas_detalle_ibfk_3` FOREIGN KEY (`id_lote`) REFERENCES `lotes` (`id_lote`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ventas_detalle`
--

LOCK TABLES `ventas_detalle` WRITE;
/*!40000 ALTER TABLE `ventas_detalle` DISABLE KEYS */;
INSERT INTO `ventas_detalle` VALUES (1,1,1,1,2,85.00,170.00);
/*!40000 ALTER TABLE `ventas_detalle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ventas_encabezado`
--

DROP TABLE IF EXISTS `ventas_encabezado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ventas_encabezado` (
  `id_venta` int NOT NULL AUTO_INCREMENT,
  `folio_ticket` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_cliente` int NOT NULL,
  `id_usuario` int NOT NULL,
  `subtotal` decimal(10,2) NOT NULL DEFAULT '0.00',
  `impuestos` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `forma_pago` enum('Efectivo','Tarjeta Debito','Tarjeta Credito','Transferencia') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Efectivo',
  `estatus` enum('COMPLETADA','CANCELADA') COLLATE utf8mb4_unicode_ci DEFAULT 'COMPLETADA',
  `fecha_venta` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_venta`),
  UNIQUE KEY `folio_ticket` (`folio_ticket`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `ventas_encabezado_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`),
  CONSTRAINT `ventas_encabezado_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ventas_encabezado`
--

LOCK TABLES `ventas_encabezado` WRITE;
/*!40000 ALTER TABLE `ventas_encabezado` DISABLE KEYS */;
INSERT INTO `ventas_encabezado` VALUES (1,'T-0001',1,1,170.00,0.00,170.00,'Efectivo','COMPLETADA','2025-11-30 02:36:38');
/*!40000 ALTER TABLE `ventas_encabezado` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-30  2:16:15
