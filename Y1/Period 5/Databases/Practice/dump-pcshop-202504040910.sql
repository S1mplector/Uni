-- MySQL dump 10.13  Distrib 9.2.0, for macos14.7 (arm64)
--
-- Host: localhost    Database: pcshop
-- ------------------------------------------------------
-- Server version	9.2.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `customer_id` char(10) NOT NULL,
  `firstname` varchar(32) DEFAULT NULL,
  `lastname` varchar(32) DEFAULT NULL,
  `city` varchar(32) DEFAULT NULL,
  `address` varchar(128) DEFAULT NULL,
  `email` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES ('1122334455','Ann','O\'Brien','Dublin','1 Jervis St.','aob@ul.ie'),('1231231231','John','Doe','Limerick',NULL,NULL),('1234567890','Paul','Murphy','Cork','20 O\'Connell St.',NULL),('5555555555','Emily','Smith','Dublin','5 O’Connell Street',NULL),('9876543210','Jack','Murphy','Galway','101 O\'Connell St.','jm@ul.ie'),('9999999999','Norah','Jones','Limerick','2 Thomas St.','nj@yahoo.com');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `laptops`
--

DROP TABLE IF EXISTS `laptops`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `laptops` (
  `model` char(4) NOT NULL DEFAULT '',
  `speed` double DEFAULT NULL,
  `ram` int DEFAULT NULL,
  `hd` int DEFAULT NULL,
  `screen` double DEFAULT NULL,
  `price` double DEFAULT NULL,
  PRIMARY KEY (`model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `laptops`
--

LOCK TABLES `laptops` WRITE;
/*!40000 ALTER TABLE `laptops` DISABLE KEYS */;
INSERT INTO `laptops` VALUES ('2001',2,2048,240,20.1,3673),('2002',1.73,1024,80,17,949),('2003',1.8,512,60,15.4,549),('2004',2,512,60,13.3,1150),('2005',2.16,1024,120,17,2500),('2006',2,2048,80,15.4,1700),('2007',1.83,1024,120,13.3,1429),('2008',1.6,1024,100,15.4,900),('2009',1.6,512,80,14.1,680),('2010',2,2048,160,15.4,2300);
/*!40000 ALTER TABLE `laptops` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pcs`
--

DROP TABLE IF EXISTS `pcs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pcs` (
  `model` char(4) NOT NULL,
  `speed` double NOT NULL,
  `ram` int NOT NULL,
  `hd` int NOT NULL,
  `price` double NOT NULL,
  PRIMARY KEY (`model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pcs`
--

LOCK TABLES `pcs` WRITE;
/*!40000 ALTER TABLE `pcs` DISABLE KEYS */;
INSERT INTO `pcs` VALUES ('1001',2.66,1024,250,2114),('1002',2.1,512,250,995),('1003',1.42,512,80,478),('1004',2.8,1024,250,649),('1005',3.2,512,250,630),('1006',3.2,1024,320,1049),('1007',2.2,1024,200,510),('1008',2.2,2048,250,770),('1009',2,1024,250,650),('1010',2.8,2048,300,770),('1011',1.86,2048,160,959),('1012',2.8,1024,160,649),('1013',3.06,512,80,529);
/*!40000 ALTER TABLE `pcs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `printers`
--

DROP TABLE IF EXISTS `printers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `printers` (
  `model` char(4) NOT NULL DEFAULT '',
  `color` varchar(5) DEFAULT NULL,
  `type` varchar(10) DEFAULT NULL,
  `price` double DEFAULT NULL,
  PRIMARY KEY (`model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `printers`
--

LOCK TABLES `printers` WRITE;
/*!40000 ALTER TABLE `printers` DISABLE KEYS */;
INSERT INTO `printers` VALUES ('3001','TRUE','ink-jet',99),('3002','FALSE','laser',239),('3003','TRUE','laser',899),('3004','TRUE','ink-jet',120),('3005','FALSE','laser',120),('3006','TRUE','ink-jet',100),('3007','TRUE','laser',200);
/*!40000 ALTER TABLE `printers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `maker` char(1) DEFAULT NULL,
  `model` char(4) NOT NULL DEFAULT '',
  `type` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES ('A','1001','pc'),('A','1002','pc'),('A','1003','pc'),('B','1004','pc'),('B','1005','pc'),('B','1006','pc'),('C','1007','pc'),('D','1008','pc'),('D','1009','pc'),('D','1010','pc'),('E','1011','pc'),('E','1012','pc'),('E','1013','pc'),('E','2001','laptop'),('E','2002','laptop'),('E','2003','laptop'),('A','2004','laptop'),('A','2005','laptop'),('A','2006','laptop'),('B','2007','laptop'),('F','2008','laptop'),('F','2009','laptop'),('G','2010','laptop'),('E','3001','printer'),('E','3002','printer'),('E','3003','printer'),('D','3004','printer'),('D','3005','printer'),('H','3006','printer'),('H','3007','printer');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales`
--

DROP TABLE IF EXISTS `sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales` (
  `customer_id` char(10) NOT NULL DEFAULT '',
  `model` char(4) NOT NULL DEFAULT '',
  `quantity` int DEFAULT NULL,
  `day` date NOT NULL DEFAULT '2010-01-01',
  `paid` double DEFAULT NULL,
  `type_of_payment` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`customer_id`,`model`,`day`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales`
--

LOCK TABLES `sales` WRITE;
/*!40000 ALTER TABLE `sales` DISABLE KEYS */;
INSERT INTO `sales` VALUES ('1122334455','2010',1,'2013-12-19',2300,'mastercard credit'),('1122334455','3001',1,'2013-12-18',99,'cash'),('1231231231','2002',2,'2013-12-19',1898,'visa credit'),('1231231231','3002',1,'2013-12-18',239,'cash'),('1234567890','1001',1,'2013-12-20',1902.6,'mastercard credit'),('9876543210','1007',1,'2013-12-17',510,'visa debit'),('9876543210','1007',3,'2013-12-19',1530,'visa debit'),('9876543210','2002',1,'2013-12-17',949,'visa debit'),('9999999999','1007',1,'2013-12-20',459,'visa credit'),('9999999999','3007',2,'2013-12-20',360,'visa credit');
/*!40000 ALTER TABLE `sales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'pcshop'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-04  9:10:09
