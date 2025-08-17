/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.13-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: sthostsitedb
-- ------------------------------------------------------
-- Server version	10.11.13-MariaDB-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cart_domains`
--

DROP TABLE IF EXISTS `cart_domains`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart_domains` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(128) NOT NULL COMMENT 'ID сесії користувача',
  `user_id` int(11) DEFAULT NULL COMMENT 'ID користувача (якщо авторизований)',
  `domain_name` varchar(255) NOT NULL COMMENT 'Повна назва домену',
  `domain_zone` varchar(50) NOT NULL COMMENT 'Доменна зона',
  `registration_period` int(11) NOT NULL DEFAULT 1 COMMENT 'Період реєстрації в роках',
  `price` decimal(10,2) NOT NULL COMMENT 'Ціна за період',
  `whois_privacy` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Захист WHOIS',
  `auto_renewal` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Автопродовження',
  `status` enum('cart','ordered','cancelled') NOT NULL DEFAULT 'cart' COMMENT 'Статус товару',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_cart_session` (`session_id`,`status`),
  KEY `idx_cart_user` (`user_id`,`status`),
  KEY `idx_cart_domain` (`domain_name`),
  KEY `idx_cart_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Домени в кошику користувачів';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_domains`
--

LOCK TABLES `cart_domains` WRITE;
/*!40000 ALTER TABLE `cart_domains` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_domains` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `complaints`
--

DROP TABLE IF EXISTS `complaints`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `complaints` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` enum('complaint','suggestion','feedback','question') DEFAULT NULL,
  `priority` enum('low','normal','high','urgent') DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `subject` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `complaints`
--

LOCK TABLES `complaints` WRITE;
/*!40000 ALTER TABLE `complaints` DISABLE KEYS */;
/*!40000 ALTER TABLE `complaints` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contact_requests`
--

DROP TABLE IF EXISTS `contact_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `subject` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `form_type` enum('contact','reseller','support') DEFAULT 'contact',
  `ip_address` varchar(45) NOT NULL,
  `user_agent` text DEFAULT NULL,
  `status` enum('new','processing','resolved','closed') DEFAULT 'new',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `processed_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`),
  KEY `idx_created` (`created_at`),
  KEY `idx_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact_requests`
--

LOCK TABLES `contact_requests` WRITE;
/*!40000 ALTER TABLE `contact_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `contact_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `csrf_tokens`
--

DROP TABLE IF EXISTS `csrf_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `csrf_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(64) NOT NULL,
  `user_session` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `expires_at` timestamp NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `idx_token` (`token`),
  KEY `idx_expires` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `csrf_tokens`
--

LOCK TABLES `csrf_tokens` WRITE;
/*!40000 ALTER TABLE `csrf_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `csrf_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `default_dns_servers`
--

DROP TABLE IF EXISTS `default_dns_servers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `default_dns_servers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `server_address` varchar(255) NOT NULL,
  `priority` int(11) DEFAULT 10,
  `is_active` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `idx_priority` (`priority`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `default_dns_servers`
--

LOCK TABLES `default_dns_servers` WRITE;
/*!40000 ALTER TABLE `default_dns_servers` DISABLE KEYS */;
INSERT INTO `default_dns_servers` VALUES
(1,'NS1 StormHosting','ns1.sthost.pro',1,1),
(2,'NS2 StormHosting','ns2.sthost.pro',2,1),
(3,'NS3 StormHosting','ns3.sthost.pro',3,1);
/*!40000 ALTER TABLE `default_dns_servers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_check_logs`
--

DROP TABLE IF EXISTS `domain_check_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_check_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain_name` varchar(255) NOT NULL COMMENT 'Назва домену без зони',
  `domain_zone` varchar(50) NOT NULL COMMENT 'Доменна зона (.ua, .com, тощо)',
  `full_domain` varchar(255) NOT NULL COMMENT 'Повна назва домену',
  `is_available` tinyint(1) NOT NULL COMMENT 'Чи доступний домен',
  `check_method` enum('whois','dns','api') NOT NULL DEFAULT 'whois' COMMENT 'Метод перевірки',
  `check_time_ms` int(11) DEFAULT NULL COMMENT 'Час перевірки в мілісекундах',
  `user_ip` varchar(45) DEFAULT NULL COMMENT 'IP користувача',
  `session_id` varchar(128) DEFAULT NULL COMMENT 'ID сесії',
  `user_id` int(11) DEFAULT NULL COMMENT 'ID користувача (якщо авторизований)',
  `whois_response` text DEFAULT NULL COMMENT 'Відповідь WHOIS',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_domain_check_name` (`domain_name`),
  KEY `idx_domain_check_zone` (`domain_zone`),
  KEY `idx_domain_check_full` (`full_domain`),
  KEY `idx_domain_check_date` (`created_at`),
  KEY `idx_domain_check_user` (`user_id`),
  KEY `idx_domain_check_session` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Логи перевірки доменів на доступність';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_check_logs`
--

LOCK TABLES `domain_check_logs` WRITE;
/*!40000 ALTER TABLE `domain_check_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `domain_check_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_page_settings`
--

DROP TABLE IF EXISTS `domain_page_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_page_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text NOT NULL,
  `setting_type` enum('string','number','boolean','json') NOT NULL DEFAULT 'string',
  `description` text DEFAULT NULL,
  `category` varchar(50) NOT NULL DEFAULT 'general',
  `is_public` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Чи можна показувати на фронті',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `setting_key` (`setting_key`),
  KEY `idx_setting_key` (`setting_key`),
  KEY `idx_setting_category` (`category`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Налаштування сторінки реєстрації доменів';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_page_settings`
--

LOCK TABLES `domain_page_settings` WRITE;
/*!40000 ALTER TABLE `domain_page_settings` DISABLE KEYS */;
INSERT INTO `domain_page_settings` VALUES
(1,'hero_title','Знайдіть ідеальний домен для вашого проекту','string','Заголовок героїв секції','hero',1,'2025-08-13 14:40:30','2025-08-13 14:40:30'),
(2,'hero_subtitle','Підтримуємо всі популярні українські та міжнародні доменні зони','string','Підзаголовок героїв секції','hero',1,'2025-08-13 14:40:30','2025-08-13 14:40:30'),
(3,'search_placeholder','Введіть бажане доменне ім\'я','string','Плейсхолдер поля пошуку','search',1,'2025-08-13 14:40:30','2025-08-13 14:40:30'),
(4,'promo_text','Спеціальна пропозиція! Знижка 20% на реєстрацію доменів .ua','string','Промо текст','promo',1,'2025-08-13 14:40:30','2025-08-13 14:40:30'),
(5,'min_domain_length','2','number','Мінімальна довжина домену','validation',0,'2025-08-13 14:40:30','2025-08-13 14:40:30'),
(6,'max_domain_length','63','number','Максимальна довжина домену','validation',0,'2025-08-13 14:40:30','2025-08-13 14:40:30'),
(7,'enable_whois_privacy','true','boolean','Увімкнути захист WHOIS','features',0,'2025-08-13 14:40:30','2025-08-13 14:40:30'),
(8,'enable_auto_renewal','true','boolean','Увімкнути автопродовження','features',0,'2025-08-13 14:40:30','2025-08-13 14:40:30'),
(9,'popular_zones','[\"ua\",\"com.ua\",\"kiev.ua\",\"com\",\"net\",\"org\",\"pp.ua\"]','json','Популярні доменні зони','display',1,'2025-08-13 14:40:30','2025-08-13 14:40:30'),
(10,'featured_zones','[{\"zone\":\".ua\",\"discount\":10},{\"zone\":\".com.ua\",\"discount\":15}]','json','Рекомендовані зони зі знижками','promo',1,'2025-08-13 14:40:30','2025-08-13 14:40:30');
/*!40000 ALTER TABLE `domain_page_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_registrars`
--

DROP TABLE IF EXISTS `domain_registrars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_registrars` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `api_endpoint` varchar(255) DEFAULT NULL,
  `api_key` varchar(255) DEFAULT NULL,
  `api_secret` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `supported_zones` text DEFAULT NULL,
  `commission_percent` decimal(5,2) DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `priority` int(11) DEFAULT 1 COMMENT 'Приоритет использования',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_registrars`
--

LOCK TABLES `domain_registrars` WRITE;
/*!40000 ALTER TABLE `domain_registrars` DISABLE KEYS */;
INSERT INTO `domain_registrars` VALUES
(1,'UA Registry',NULL,NULL,NULL,1,'[\"ua\",\"com.ua\",\"net.ua\",\"org.ua\",\"kiev.ua\",\"pp.ua\"]',5.00,'2025-08-04 15:17:42',1),
(2,'Backup Registrar',NULL,NULL,NULL,1,'[\"com\",\"net\",\"org\",\"info\",\"biz\"]',7.50,'2025-08-04 15:17:42',1);
/*!40000 ALTER TABLE `domain_registrars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `domain_search_statistics`
--

DROP TABLE IF EXISTS `domain_search_statistics`;
/*!50001 DROP VIEW IF EXISTS `domain_search_statistics`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `domain_search_statistics` AS SELECT
 1 AS `search_date`,
  1 AS `domain_zone`,
  1 AS `total_checks`,
  1 AS `available_count`,
  1 AS `taken_count`,
  1 AS `avg_check_time_ms`,
  1 AS `unique_sessions`,
  1 AS `unique_users` */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `domain_search_trends`
--

DROP TABLE IF EXISTS `domain_search_trends`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_search_trends` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `search_term` varchar(255) NOT NULL COMMENT 'Пошуковий запит',
  `search_count` int(11) NOT NULL DEFAULT 1 COMMENT 'Кількість пошуків',
  `last_searched` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_search_term` (`search_term`),
  KEY `idx_search_trends_count` (`search_count` DESC),
  KEY `idx_search_trends_date` (`last_searched`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Тренди пошуку доменів';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_search_trends`
--

LOCK TABLES `domain_search_trends` WRITE;
/*!40000 ALTER TABLE `domain_search_trends` DISABLE KEYS */;
/*!40000 ALTER TABLE `domain_search_trends` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_whois_servers`
--

DROP TABLE IF EXISTS `domain_whois_servers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_whois_servers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `zone` varchar(20) NOT NULL,
  `whois_server` varchar(255) NOT NULL,
  `port` int(11) DEFAULT 43,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_zone` (`zone`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_whois_servers`
--

LOCK TABLES `domain_whois_servers` WRITE;
/*!40000 ALTER TABLE `domain_whois_servers` DISABLE KEYS */;
INSERT INTO `domain_whois_servers` VALUES
(1,'.ua','whois.ua',43,1,'2025-08-04 15:16:09'),
(2,'.com.ua','whois.ua',43,1,'2025-08-04 15:16:09'),
(3,'.net.ua','whois.ua',43,1,'2025-08-04 15:16:09'),
(4,'.org.ua','whois.ua',43,1,'2025-08-04 15:16:09'),
(5,'.kiev.ua','whois.ua',43,1,'2025-08-04 15:16:09'),
(6,'.lviv.ua','whois.ua',43,1,'2025-08-04 15:16:09'),
(7,'.pp.ua','whois.ua',43,1,'2025-08-04 15:16:09'),
(8,'.co.ua','whois.ua',43,1,'2025-08-04 15:16:09'),
(9,'.in.ua','whois.ua',43,1,'2025-08-04 15:16:09'),
(10,'.biz.ua','whois.ua',43,1,'2025-08-04 15:16:09'),
(11,'.info.ua','whois.ua',43,1,'2025-08-04 15:16:09'),
(12,'.com','whois.verisign-grs.com',43,1,'2025-08-04 15:16:09'),
(13,'.net','whois.verisign-grs.com',43,1,'2025-08-04 15:16:09'),
(14,'.org','whois.pir.org',43,1,'2025-08-04 15:16:09'),
(15,'.info','whois.afilias.net',43,1,'2025-08-04 15:16:09'),
(16,'.biz','whois.neulevel.biz',43,1,'2025-08-04 15:16:09'),
(17,'.pro','whois.registrypro.pro',43,1,'2025-08-04 15:16:09');
/*!40000 ALTER TABLE `domain_whois_servers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_zones`
--

DROP TABLE IF EXISTS `domain_zones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_zones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `zone` varchar(20) NOT NULL,
  `description` text DEFAULT NULL COMMENT 'Опис доменної зони',
  `features` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Особливості доменної зони' CHECK (json_valid(`features`)),
  `min_registration_period` int(11) NOT NULL DEFAULT 1 COMMENT 'Мінімальний період реєстрації в роках',
  `price_registration` decimal(10,2) NOT NULL,
  `price_renewal` decimal(10,2) NOT NULL,
  `price_transfer` decimal(10,2) NOT NULL,
  `is_popular` tinyint(1) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `max_registration_period` int(11) DEFAULT 10 COMMENT 'Максимальний період реєстрації',
  `grace_period_days` int(11) DEFAULT 30 COMMENT 'Період відновлення після закінчення',
  `whois_privacy_available` tinyint(1) DEFAULT 1 COMMENT 'Доступність приховування WHOIS',
  `auto_renewal_available` tinyint(1) DEFAULT 1 COMMENT 'Доступність автопродовження',
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `zone` (`zone`),
  KEY `idx_zone` (`zone`),
  KEY `idx_popular` (`is_popular`),
  KEY `idx_active` (`is_active`),
  KEY `idx_domain_zones_popular` (`is_popular`,`is_active`),
  KEY `idx_domain_zones_type` (`zone`(10),`is_active`),
  KEY `idx_domain_zones_price` (`price_registration`,`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_zones`
--

LOCK TABLES `domain_zones` WRITE;
/*!40000 ALTER TABLE `domain_zones` DISABLE KEYS */;
INSERT INTO `domain_zones` VALUES
(1,'.ua','Український національний домен верхнього рівня. Ідеальний вибір для українських компаній та проектів.','[\"Національний домен\", \"Висока довіра\", \"Українська локалізація\"]',1,200.00,200.00,180.00,1,1,10,30,1,1,'2025-08-13 14:40:28'),
(2,'.com.ua','Комерційний домен України. Популярний вибір для бізнесу та електронної комерції.','[\"Для бізнесу\", \"Висока довіра\", \"Доступна ціна\"]',1,150.00,150.00,130.00,1,1,10,30,1,1,'2025-08-13 14:40:29'),
(3,'.kiev.ua','Домен для Києва та Київської області. Ідеально підходить для місцевого бізнесу.','[\"Регіональний домен\", \"Локальний бізнес\", \"Географічна прив\'язка\"]',1,180.00,180.00,160.00,1,1,10,30,1,1,'2025-08-13 14:40:29'),
(4,'.org.ua','Домен для організацій України. Підходить для некомерційних організацій.','[\"Для організацій\", \"Некомерційний сектор\", \"Соціальні проекти\"]',1,180.00,180.00,160.00,1,1,10,30,1,1,'2025-08-13 14:40:29'),
(5,'.lviv.ua',NULL,NULL,1,200.00,200.00,180.00,0,1,10,30,1,1,'2025-08-13 14:40:28'),
(6,'.dp.ua',NULL,NULL,1,200.00,200.00,180.00,0,1,10,30,1,1,'2025-08-13 14:40:28'),
(7,'.kharkov.ua',NULL,NULL,1,200.00,200.00,180.00,0,1,10,30,1,1,'2025-08-13 14:40:28'),
(8,'.odessa.ua',NULL,NULL,1,200.00,200.00,180.00,0,1,10,30,1,1,'2025-08-13 14:40:28'),
(9,'.zp.ua',NULL,NULL,1,200.00,200.00,180.00,0,1,10,30,1,1,'2025-08-13 14:40:28'),
(10,'.vinnica.ua',NULL,NULL,1,200.00,200.00,180.00,0,1,10,30,1,1,'2025-08-13 14:40:28'),
(11,'.cherkassy.ua',NULL,NULL,1,200.00,200.00,180.00,0,1,10,30,1,1,'2025-08-13 14:40:28'),
(12,'.chernigov.ua',NULL,NULL,1,200.00,200.00,180.00,0,1,10,30,1,1,'2025-08-13 14:40:28'),
(13,'.crimea.ua',NULL,NULL,1,200.00,200.00,180.00,0,0,10,30,1,1,'2025-08-13 14:40:28'),
(14,'.cv.ua',NULL,NULL,1,200.00,200.00,180.00,0,1,10,30,1,1,'2025-08-13 14:40:28'),
(15,'.dn.ua',NULL,NULL,1,200.00,200.00,180.00,0,1,10,30,1,1,'2025-08-13 14:40:28'),
(16,'.if.ua',NULL,NULL,1,200.00,200.00,180.00,0,1,10,30,1,1,'2025-08-13 14:40:28'),
(17,'.kr.ua',NULL,NULL,1,200.00,200.00,180.00,0,1,10,30,1,1,'2025-08-13 14:40:28'),
(18,'.lg.ua',NULL,NULL,1,200.00,200.00,180.00,0,1,10,30,1,1,'2025-08-13 14:40:28'),
(19,'.mk.ua',NULL,NULL,1,200.00,200.00,180.00,0,1,10,30,1,1,'2025-08-13 14:40:28'),
(20,'.pl.ua',NULL,NULL,1,200.00,200.00,180.00,0,1,10,30,1,1,'2025-08-13 14:40:28'),
(21,'.rv.ua',NULL,NULL,1,200.00,200.00,180.00,0,1,10,30,1,1,'2025-08-13 14:40:28'),
(22,'.sm.ua',NULL,NULL,1,200.00,200.00,180.00,0,1,10,30,1,1,'2025-08-13 14:40:28'),
(23,'.te.ua',NULL,NULL,1,200.00,200.00,180.00,0,1,10,30,1,1,'2025-08-13 14:40:28'),
(24,'.uz.ua',NULL,NULL,1,200.00,200.00,180.00,0,1,10,30,1,1,'2025-08-13 14:40:28'),
(25,'.vn.ua',NULL,NULL,1,200.00,200.00,180.00,0,1,10,30,1,1,'2025-08-13 14:40:28'),
(26,'.volyn.ua',NULL,NULL,1,200.00,200.00,180.00,0,1,10,30,1,1,'2025-08-13 14:40:28'),
(27,'.zak.ua',NULL,NULL,1,200.00,200.00,180.00,0,1,10,30,1,1,'2025-08-13 14:40:28'),
(28,'.zt.ua',NULL,NULL,1,200.00,200.00,180.00,0,1,10,30,1,1,'2025-08-13 14:40:28'),
(29,'.net.ua',NULL,NULL,1,180.00,180.00,160.00,1,1,10,30,1,1,'2025-08-13 14:40:28'),
(30,'.co.ua',NULL,NULL,1,200.00,200.00,180.00,0,1,10,30,1,1,'2025-08-13 14:40:28'),
(31,'.pp.ua','Персональний домен для фізичних осіб України. Безкоштовна реєстрація.','[\"Для фізичних осіб\", \"Безкоштовний\", \"Персональні проекти\"]',1,120.00,120.00,100.00,1,1,10,30,1,1,'2025-08-13 14:40:29'),
(32,'.in.ua',NULL,NULL,1,150.00,150.00,130.00,0,1,10,30,1,1,'2025-08-13 14:40:28'),
(33,'.biz.ua',NULL,NULL,1,200.00,200.00,180.00,0,1,10,30,1,1,'2025-08-13 14:40:28'),
(34,'.info.ua',NULL,NULL,1,180.00,180.00,160.00,0,1,10,30,1,1,'2025-08-13 14:40:28'),
(35,'.name.ua',NULL,NULL,1,180.00,180.00,160.00,0,1,10,30,1,1,'2025-08-13 14:40:28'),
(36,'.edu.ua',NULL,NULL,1,0.00,0.00,0.00,0,0,10,30,1,1,'2025-08-13 14:40:28'),
(37,'.gov.ua',NULL,NULL,1,0.00,0.00,0.00,0,0,10,30,1,1,'2025-08-13 14:40:28'),
(38,'.mil.ua',NULL,NULL,1,0.00,0.00,0.00,0,0,10,30,1,1,'2025-08-13 14:40:28'),
(39,'.com','Найпопулярніший комерційний домен у світі. Універсальний вибір для будь-якого проекту.','[\"Світове визнання\", \"Максимальна довіра\", \"SEO переваги\"]',1,350.00,350.00,300.00,1,1,10,30,1,1,'2025-08-13 14:40:29'),
(40,'.net','Міжнародний мережевий домен для IT та технічних проектів.','[\"Для технічних проектів\", \"IT сфера\", \"Міжнародний рівень\"]',1,450.00,450.00,400.00,1,1,10,30,1,1,'2025-08-13 14:40:29'),
(41,'.org','Домен для некомерційних організацій. Підходить для фондів та громадських організацій.','[\"Некомерційні організації\", \"Благодійність\", \"Громадські проекти\"]',1,400.00,400.00,350.00,1,1,10,30,1,1,'2025-08-13 14:40:29'),
(42,'.info','Інформаційний домен для довідкових та інформаційних ресурсів.','[\"Інформаційні проекти\", \"Довідкові ресурси\", \"База знань\"]',1,300.00,350.00,300.00,0,1,10,30,1,1,'2025-08-13 14:40:29'),
(43,'.biz','Бізнес-домен для комерційних проектів та стартапів.','[\"Для бізнесу\", \"Стартапи\", \"B2B проекти\"]',1,350.00,400.00,350.00,0,1,10,30,1,1,'2025-08-13 14:40:29'),
(44,'.pro','Професійний домен для фахівців та експертів.','[\"Для професіоналів\", \"Експерти\", \"Консультанти\"]',1,400.00,450.00,400.00,0,1,10,30,1,1,'2025-08-13 14:40:29');
/*!40000 ALTER TABLE `domain_zones` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sthostdb`@`localhost`*/ /*!50003 TRIGGER IF NOT EXISTS `tr_domain_zones_updated_at`
    BEFORE UPDATE ON `domain_zones`
    FOR EACH ROW
BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `email_verifications`
--

DROP TABLE IF EXISTS `email_verifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `email_verifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `expires_at` timestamp NOT NULL,
  `is_used` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_expires` (`expires_at`),
  CONSTRAINT `email_verifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_verifications`
--

LOCK TABLES `email_verifications` WRITE;
/*!40000 ALTER TABLE `email_verifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `email_verifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hosting_plans`
--

DROP TABLE IF EXISTS `hosting_plans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hosting_plans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name_ua` varchar(100) NOT NULL,
  `name_en` varchar(100) DEFAULT NULL,
  `name_ru` varchar(100) DEFAULT NULL,
  `type` enum('shared','cloud','reseller') NOT NULL,
  `disk_space` int(11) NOT NULL,
  `bandwidth` int(11) NOT NULL,
  `databases` int(11) DEFAULT 0,
  `email_accounts` int(11) DEFAULT 0,
  `domains` int(11) DEFAULT 1,
  `price_monthly` decimal(10,2) NOT NULL,
  `price_yearly` decimal(10,2) NOT NULL,
  `is_popular` tinyint(1) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `features_ua` text DEFAULT NULL,
  `features_en` text DEFAULT NULL,
  `features_ru` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_type` (`type`),
  KEY `idx_active` (`is_active`),
  KEY `idx_popular` (`is_popular`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hosting_plans`
--

LOCK TABLES `hosting_plans` WRITE;
/*!40000 ALTER TABLE `hosting_plans` DISABLE KEYS */;
INSERT INTO `hosting_plans` VALUES
(1,'Базовий','Basic','Базовый','shared',1024,10,1,5,1,99.00,990.00,0,1,'SSL сертифікат, Підтримка PHP, MySQL база даних',NULL,NULL),
(2,'Стандарт','Standard','Стандарт','shared',5120,50,5,20,5,199.00,1990.00,1,1,'SSL сертифікат, Підтримка PHP, MySQL бази даних, Безлімітні домени',NULL,NULL),
(3,'Преміум','Premium','Премиум','shared',10240,100,10,50,0,399.00,3990.00,0,1,'SSL сертифікат, Підтримка PHP, MySQL бази даних, Безлімітні домени, SSD накопичувач',NULL,NULL);
/*!40000 ALTER TABLE `hosting_plans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ip_blacklist_cache`
--

DROP TABLE IF EXISTS `ip_blacklist_cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ip_blacklist_cache` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ip_address` varchar(45) NOT NULL,
  `rbl_name` varchar(100) NOT NULL,
  `is_listed` tinyint(1) NOT NULL,
  `response_code` varchar(20) DEFAULT NULL,
  `checked_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_ip_rbl` (`ip_address`,`rbl_name`),
  KEY `idx_ip_rbl` (`ip_address`,`rbl_name`),
  KEY `idx_checked` (`checked_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ip_blacklist_cache`
--

LOCK TABLES `ip_blacklist_cache` WRITE;
/*!40000 ALTER TABLE `ip_blacklist_cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `ip_blacklist_cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ip_check_logs`
--

DROP TABLE IF EXISTS `ip_check_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ip_check_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `checked_ip` varchar(45) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `user_agent` text DEFAULT NULL,
  `results_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`results_json`)),
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_ip_time` (`ip_address`,`created_at`),
  KEY `idx_checked_ip` (`checked_ip`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ip_check_logs`
--

LOCK TABLES `ip_check_logs` WRITE;
/*!40000 ALTER TABLE `ip_check_logs` DISABLE KEYS */;
INSERT INTO `ip_check_logs` VALUES
(1,'93.170.44.119','93.170.44.119','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36','{\"ip\":\"93.170.44.119\",\"timestamp\":\"2025-08-09T18:24:47+03:00\",\"general\":{\"ip\":\"93.170.44.119\",\"is_valid\":true,\"ip_type\":\"Публічна IPv4\",\"check_time\":\"2025-08-09T18:24:47+03:00\"},\"location\":{\"country\":\"Ukraine\",\"country_code\":\"UA\",\"region\":\"Dnipropetrovsk Oblast\",\"city\":\"Dnipro\",\"postal\":\"49000\",\"latitude\":48.4604,\"longitude\":35.033000000000001,\"timezone\":\"Europe\\/Kyiv\"},\"network\":{\"isp\":\"Невідомо\",\"org\":\"Невідомо\",\"asn\":\"\",\"connection_type\":\"Невідомо\",\"usage_type\":\"Невідомо\",\"is_proxy\":false},\"blacklists\":[{\"name\":\"Spamhaus ZEN\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SpamCop\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Barracuda\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Spam\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS HTTP\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS SOCKS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Misc\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Zombie\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS DUL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 1\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 2\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 3\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus PBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus SBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus CSS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus XBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Composite Blocking List\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Passive Spam Block List\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Lashback UBL\",\"listed\":false,\"checked\":true,\"response\":null}],\"threats\":{\"risk_level\":\"Низький\",\"confidence\":0,\"categories\":[],\"last_seen\":null},\"distance\":null,\"weather\":{\"temperature\":15,\"description\":\"Хмарно\",\"condition\":\"cloudy\",\"humidity\":42,\"wind_speed\":3,\"visibility\":11}}','2025-08-09 15:24:51'),
(2,'93.170.44.119','93.170.44.119','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36','{\"ip\":\"93.170.44.119\",\"timestamp\":\"2025-08-09T18:24:49+03:00\",\"general\":{\"ip\":\"93.170.44.119\",\"is_valid\":true,\"ip_type\":\"Публічна IPv4\",\"check_time\":\"2025-08-09T18:24:49+03:00\"},\"location\":{\"country\":\"Ukraine\",\"country_code\":\"UA\",\"region\":\"Dnipropetrovsk Oblast\",\"city\":\"Dnipro\",\"postal\":\"49000\",\"latitude\":48.4604,\"longitude\":35.033000000000001,\"timezone\":\"Europe\\/Kyiv\"},\"network\":{\"isp\":\"Невідомо\",\"org\":\"Невідомо\",\"asn\":\"\",\"connection_type\":\"Невідомо\",\"usage_type\":\"Невідомо\",\"is_proxy\":false},\"blacklists\":[{\"name\":\"Spamhaus ZEN\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SpamCop\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Barracuda\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Spam\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS HTTP\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS SOCKS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Misc\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Zombie\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS DUL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 1\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 2\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 3\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus PBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus SBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus CSS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus XBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Composite Blocking List\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Passive Spam Block List\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Lashback UBL\",\"listed\":false,\"checked\":true,\"response\":null}],\"threats\":{\"risk_level\":\"Низький\",\"confidence\":0,\"categories\":[],\"last_seen\":null},\"distance\":null,\"weather\":{\"temperature\":23,\"description\":\"Хмарно\",\"condition\":\"cloudy\",\"humidity\":69,\"wind_speed\":9,\"visibility\":7}}','2025-08-09 15:24:51'),
(3,'194.44.7.103','93.170.44.119','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36','{\"ip\":\"194.44.7.103\",\"timestamp\":\"2025-08-09T18:25:03+03:00\",\"general\":{\"ip\":\"194.44.7.103\",\"is_valid\":true,\"ip_type\":\"Публічна IPv4\",\"check_time\":\"2025-08-09T18:25:03+03:00\"},\"location\":{\"country\":\"Ukraine\",\"country_code\":\"UA\",\"region\":\"Dnipropetrovsk\",\"city\":\"Obukhivka\",\"postal\":\"\",\"latitude\":48.548839999999998,\"longitude\":34.853870000000001,\"timezone\":\"Europe\\/Kyiv\"},\"network\":{\"isp\":\"Невідомо\",\"org\":\"Невідомо\",\"asn\":\"\",\"connection_type\":\"Невідомо\",\"usage_type\":\"Невідомо\",\"is_proxy\":false},\"blacklists\":[{\"name\":\"Spamhaus ZEN\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SpamCop\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Barracuda\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Spam\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS HTTP\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS SOCKS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Misc\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Zombie\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS DUL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 1\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 2\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 3\",\"listed\":true,\"checked\":true,\"response\":\"127.0.0.2\"},{\"name\":\"Spamhaus PBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus SBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus CSS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus XBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Composite Blocking List\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Passive Spam Block List\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Lashback UBL\",\"listed\":false,\"checked\":true,\"response\":null}],\"threats\":{\"risk_level\":\"Низький\",\"confidence\":0,\"categories\":[],\"last_seen\":null},\"distance\":{\"km\":16,\"miles\":10,\"flight_time\":\"1 хв\"},\"weather\":{\"temperature\":22,\"description\":\"Хмарно\",\"condition\":\"cloudy\",\"humidity\":52,\"wind_speed\":4,\"visibility\":14}}','2025-08-09 15:25:06'),
(4,'194.44.7.103','93.170.44.119','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36','{\"ip\":\"194.44.7.103\",\"timestamp\":\"2025-08-09T18:25:16+03:00\",\"general\":{\"ip\":\"194.44.7.103\",\"is_valid\":true,\"ip_type\":\"Публічна IPv4\",\"check_time\":\"2025-08-09T18:25:16+03:00\"},\"location\":{\"country\":\"Ukraine\",\"country_code\":\"UA\",\"region\":\"Dnipropetrovsk\",\"city\":\"Obukhivka\",\"postal\":\"\",\"latitude\":48.548839999999998,\"longitude\":34.853870000000001,\"timezone\":\"Europe\\/Kyiv\"},\"network\":{\"isp\":\"Невідомо\",\"org\":\"Невідомо\",\"asn\":\"\",\"connection_type\":\"Невідомо\",\"usage_type\":\"Невідомо\",\"is_proxy\":false},\"blacklists\":[{\"name\":\"Spamhaus ZEN\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SpamCop\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Barracuda\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Spam\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS HTTP\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS SOCKS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Misc\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Zombie\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS DUL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 1\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 2\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 3\",\"listed\":true,\"checked\":true,\"response\":\"127.0.0.2\"},{\"name\":\"Spamhaus PBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus SBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus CSS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus XBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Composite Blocking List\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Passive Spam Block List\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Lashback UBL\",\"listed\":false,\"checked\":true,\"response\":null}],\"threats\":{\"risk_level\":\"Низький\",\"confidence\":0,\"categories\":[],\"last_seen\":null},\"distance\":{\"km\":16,\"miles\":10,\"flight_time\":\"1 хв\"},\"weather\":{\"temperature\":15,\"description\":\"Хмарно\",\"condition\":\"cloudy\",\"humidity\":50,\"wind_speed\":8,\"visibility\":15}}','2025-08-09 15:25:19'),
(7,'8.8.8.8','93.170.44.119','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36','{\"ip\":\"8.8.8.8\",\"timestamp\":\"2025-08-09T18:28:05+03:00\",\"general\":{\"ip\":\"8.8.8.8\",\"is_valid\":true,\"ip_type\":\"Публічна IPv4\",\"check_time\":\"2025-08-09T18:28:05+03:00\"},\"location\":{\"country\":\"United States\",\"country_code\":\"US\",\"region\":\"California\",\"city\":\"Mountain View\",\"postal\":\"94043\",\"latitude\":37.423009999999998,\"longitude\":-122.083352,\"timezone\":\"America\\/Los_Angeles\"},\"network\":{\"isp\":\"Невідомо\",\"org\":\"Невідомо\",\"asn\":\"\",\"connection_type\":\"Невідомо\",\"usage_type\":\"Невідомо\",\"is_proxy\":false},\"blacklists\":[{\"name\":\"Spamhaus ZEN\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SpamCop\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Barracuda\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Spam\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS HTTP\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS SOCKS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Misc\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Zombie\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS DUL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 1\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 2\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 3\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus PBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus SBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus CSS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus XBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Composite Blocking List\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Passive Spam Block List\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Lashback UBL\",\"listed\":false,\"checked\":true,\"response\":null}],\"threats\":{\"risk_level\":\"Низький\",\"confidence\":0,\"categories\":[],\"last_seen\":null},\"distance\":{\"km\":9883,\"miles\":6141,\"flight_time\":\"11 год\"},\"weather\":{\"temperature\":21,\"description\":\"Хмарно\",\"condition\":\"cloudy\",\"humidity\":74,\"wind_speed\":5,\"visibility\":15}}','2025-08-09 15:28:08'),
(8,'194.44.7.103','93.170.44.119','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36','{\"ip\":\"194.44.7.103\",\"timestamp\":\"2025-08-09T18:28:15+03:00\",\"general\":{\"ip\":\"194.44.7.103\",\"is_valid\":true,\"ip_type\":\"Публічна IPv4\",\"check_time\":\"2025-08-09T18:28:15+03:00\"},\"location\":{\"country\":\"Ukraine\",\"country_code\":\"UA\",\"region\":\"Dnipropetrovsk\",\"city\":\"Obukhivka\",\"postal\":\"\",\"latitude\":48.548839999999998,\"longitude\":34.853870000000001,\"timezone\":\"Europe\\/Kyiv\"},\"network\":{\"isp\":\"Невідомо\",\"org\":\"Невідомо\",\"asn\":\"\",\"connection_type\":\"Невідомо\",\"usage_type\":\"Невідомо\",\"is_proxy\":false},\"blacklists\":[{\"name\":\"Spamhaus ZEN\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SpamCop\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Barracuda\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Spam\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS HTTP\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS SOCKS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Misc\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Zombie\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS DUL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 1\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 2\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 3\",\"listed\":true,\"checked\":true,\"response\":\"127.0.0.2\"},{\"name\":\"Spamhaus PBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus SBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus CSS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus XBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Composite Blocking List\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Passive Spam Block List\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Lashback UBL\",\"listed\":false,\"checked\":true,\"response\":null}],\"threats\":{\"risk_level\":\"Низький\",\"confidence\":0,\"categories\":[],\"last_seen\":null},\"distance\":{\"km\":377,\"miles\":234,\"flight_time\":\"25 хв\"},\"weather\":{\"temperature\":16,\"description\":\"Хмарно\",\"condition\":\"cloudy\",\"humidity\":64,\"wind_speed\":10,\"visibility\":7}}','2025-08-09 15:28:18'),
(10,'93.170.44.119','93.170.44.119','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36','{\"ip\":\"93.170.44.119\",\"timestamp\":\"2025-08-09T18:28:49+03:00\",\"general\":{\"ip\":\"93.170.44.119\",\"is_valid\":true,\"ip_type\":\"Публічна IPv4\",\"check_time\":\"2025-08-09T18:28:49+03:00\"},\"location\":{\"country\":\"Ukraine\",\"country_code\":\"UA\",\"region\":\"Dnipropetrovsk Oblast\",\"city\":\"Dnipro\",\"postal\":\"49000\",\"latitude\":48.4604,\"longitude\":35.033000000000001,\"timezone\":\"Europe\\/Kyiv\"},\"network\":{\"isp\":\"Невідомо\",\"org\":\"Невідомо\",\"asn\":\"\",\"connection_type\":\"Невідомо\",\"usage_type\":\"Невідомо\",\"is_proxy\":false},\"blacklists\":[{\"name\":\"Spamhaus ZEN\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SpamCop\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Barracuda\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Spam\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS HTTP\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS SOCKS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Misc\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Zombie\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS DUL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 1\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 2\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 3\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus PBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus SBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus CSS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus XBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Composite Blocking List\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Passive Spam Block List\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Lashback UBL\",\"listed\":false,\"checked\":true,\"response\":null}],\"threats\":{\"risk_level\":\"Низький\",\"confidence\":0,\"categories\":[],\"last_seen\":null},\"distance\":{\"km\":394,\"miles\":245,\"flight_time\":\"26 хв\"},\"weather\":{\"temperature\":15,\"description\":\"Хмарно\",\"condition\":\"cloudy\",\"humidity\":64,\"wind_speed\":4,\"visibility\":7}}','2025-08-09 15:28:52'),
(13,'93.170.44.119','93.170.44.119','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36','{\"ip\":\"93.170.44.119\",\"timestamp\":\"2025-08-09T18:29:16+03:00\",\"general\":{\"ip\":\"93.170.44.119\",\"is_valid\":true,\"ip_type\":\"Публічна IPv4\",\"check_time\":\"2025-08-09T18:29:16+03:00\"},\"location\":{\"country\":\"Ukraine\",\"country_code\":\"UA\",\"region\":\"Dnipropetrovsk Oblast\",\"city\":\"Dnipro\",\"postal\":\"49000\",\"latitude\":48.4604,\"longitude\":35.033000000000001,\"timezone\":\"Europe\\/Kyiv\"},\"network\":{\"isp\":\"Невідомо\",\"org\":\"Невідомо\",\"asn\":\"\",\"connection_type\":\"Невідомо\",\"usage_type\":\"Невідомо\",\"is_proxy\":false},\"blacklists\":[{\"name\":\"Spamhaus ZEN\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SpamCop\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Barracuda\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Spam\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS HTTP\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS SOCKS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Misc\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Zombie\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS DUL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 1\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 2\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 3\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus PBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus SBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus CSS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus XBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Composite Blocking List\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Passive Spam Block List\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Lashback UBL\",\"listed\":false,\"checked\":true,\"response\":null}],\"threats\":{\"risk_level\":\"Низький\",\"confidence\":0,\"categories\":[],\"last_seen\":null},\"distance\":{\"km\":0,\"miles\":0,\"flight_time\":\"0 хв\"},\"weather\":{\"temperature\":19,\"description\":\"Хмарно\",\"condition\":\"cloudy\",\"humidity\":43,\"wind_speed\":6,\"visibility\":7}}','2025-08-09 15:29:19'),
(14,'8.8.8.8','93.170.44.119','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36','{\"ip\":\"8.8.8.8\",\"timestamp\":\"2025-08-09T20:27:16+03:00\",\"general\":{\"ip\":\"8.8.8.8\",\"is_valid\":true,\"ip_type\":\"Публічна IPv4\",\"check_time\":\"2025-08-09T20:27:16+03:00\"},\"location\":{\"country\":\"United States\",\"country_code\":\"US\",\"region\":\"California\",\"city\":\"Mountain View\",\"postal\":\"94043\",\"latitude\":37.423009999999998,\"longitude\":-122.083352,\"timezone\":\"America\\/Los_Angeles\"},\"network\":{\"isp\":\"Невідомо\",\"org\":\"Невідомо\",\"asn\":\"\",\"connection_type\":\"Невідомо\",\"usage_type\":\"Невідомо\",\"is_proxy\":false},\"blacklists\":[{\"name\":\"Spamhaus ZEN\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SpamCop\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Barracuda\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Spam\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS HTTP\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS SOCKS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Misc\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Zombie\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS DUL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 1\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 2\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 3\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus PBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus SBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus CSS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus XBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Composite Blocking List\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Passive Spam Block List\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Lashback UBL\",\"listed\":false,\"checked\":true,\"response\":null}],\"threats\":{\"risk_level\":\"Низький\",\"confidence\":0,\"categories\":[],\"last_seen\":null},\"distance\":{\"km\":10201,\"miles\":6339,\"flight_time\":\"11.3 год\"},\"weather\":{\"temperature\":19,\"description\":\"Хмарно\",\"condition\":\"cloudy\",\"humidity\":53,\"wind_speed\":9,\"visibility\":14}}','2025-08-09 17:27:19'),
(15,'1.1.1.1','93.170.44.119','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36','{\"ip\":\"1.1.1.1\",\"timestamp\":\"2025-08-09T20:27:18+03:00\",\"general\":{\"ip\":\"1.1.1.1\",\"is_valid\":true,\"ip_type\":\"Публічна IPv4\",\"check_time\":\"2025-08-09T20:27:18+03:00\"},\"location\":{\"country\":\"Australia\",\"country_code\":\"AU\",\"region\":\"New South Wales\",\"city\":\"Sydney\",\"postal\":\"2000\",\"latitude\":-33.859335999999999,\"longitude\":151.20362399999999,\"timezone\":\"Australia\\/Sydney\"},\"network\":{\"isp\":\"Невідомо\",\"org\":\"Невідомо\",\"asn\":\"\",\"connection_type\":\"Невідомо\",\"usage_type\":\"Невідомо\",\"is_proxy\":false},\"blacklists\":[{\"name\":\"Spamhaus ZEN\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SpamCop\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Barracuda\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Spam\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS HTTP\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS SOCKS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Misc\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Zombie\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS DUL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 1\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 2\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 3\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus PBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus SBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus CSS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus XBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Composite Blocking List\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Passive Spam Block List\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Lashback UBL\",\"listed\":false,\"checked\":true,\"response\":null}],\"threats\":{\"risk_level\":\"Низький\",\"confidence\":0,\"categories\":[],\"last_seen\":null},\"distance\":{\"km\":14599,\"miles\":9071,\"flight_time\":\"16.2 год\"},\"weather\":{\"temperature\":25,\"description\":\"Хмарно\",\"condition\":\"cloudy\",\"humidity\":58,\"wind_speed\":5,\"visibility\":14}}','2025-08-09 17:27:21'),
(16,'208.67.222.222','93.170.44.119','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36','{\"ip\":\"208.67.222.222\",\"timestamp\":\"2025-08-09T20:27:18+03:00\",\"general\":{\"ip\":\"208.67.222.222\",\"is_valid\":true,\"ip_type\":\"Публічна IPv4\",\"check_time\":\"2025-08-09T20:27:18+03:00\"},\"location\":{\"country\":\"United States\",\"country_code\":\"US\",\"region\":\"California\",\"city\":\"San Francisco\",\"postal\":\"94107\",\"latitude\":37.774777999999998,\"longitude\":-122.397966,\"timezone\":\"America\\/Los_Angeles\"},\"network\":{\"isp\":\"Невідомо\",\"org\":\"Невідомо\",\"asn\":\"\",\"connection_type\":\"Невідомо\",\"usage_type\":\"Невідомо\",\"is_proxy\":false},\"blacklists\":[{\"name\":\"Spamhaus ZEN\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SpamCop\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Barracuda\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Spam\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS HTTP\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS SOCKS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Misc\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Zombie\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS DUL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 1\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 2\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 3\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus PBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus SBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus CSS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus XBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Composite Blocking List\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Passive Spam Block List\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Lashback UBL\",\"listed\":false,\"checked\":true,\"response\":null}],\"threats\":{\"risk_level\":\"Низький\",\"confidence\":0,\"categories\":[],\"last_seen\":null},\"distance\":{\"km\":10170,\"miles\":6319,\"flight_time\":\"11.3 год\"},\"weather\":{\"temperature\":19,\"description\":\"Хмарно\",\"condition\":\"cloudy\",\"humidity\":45,\"wind_speed\":8,\"visibility\":9}}','2025-08-09 17:27:21'),
(17,'194.44.7.103','93.170.44.31','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36','{\"ip\":\"194.44.7.103\",\"timestamp\":\"2025-08-13T17:44:23+03:00\",\"general\":{\"ip\":\"194.44.7.103\",\"is_valid\":true,\"ip_type\":\"Публічна IPv4\",\"check_time\":\"2025-08-13T17:44:23+03:00\"},\"location\":{\"country\":\"Ukraine\",\"country_code\":\"UA\",\"region\":\"Dnipropetrovsk\",\"city\":\"Obukhivka\",\"postal\":\"\",\"latitude\":48.548839999999998,\"longitude\":34.853870000000001,\"timezone\":\"Europe\\/Kyiv\"},\"network\":{\"isp\":\"Невідомо\",\"org\":\"Невідомо\",\"asn\":\"\",\"connection_type\":\"Невідомо\",\"usage_type\":\"Невідомо\",\"is_proxy\":false},\"blacklists\":[{\"name\":\"Spamhaus ZEN\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SpamCop\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Barracuda\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Spam\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS HTTP\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS SOCKS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Misc\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Zombie\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS DUL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 1\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 2\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 3\",\"listed\":true,\"checked\":true,\"response\":\"127.0.0.2\"},{\"name\":\"Spamhaus PBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus SBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus CSS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus XBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Composite Blocking List\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Passive Spam Block List\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Lashback UBL\",\"listed\":false,\"checked\":true,\"response\":null}],\"threats\":null,\"distance\":null,\"weather\":{\"temperature\":20,\"description\":\"Хмарно\",\"condition\":\"cloudy\",\"humidity\":70,\"wind_speed\":6,\"visibility\":9}}','2025-08-13 14:44:26'),
(18,'194.44.7.103','93.170.44.31','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36','{\"ip\":\"194.44.7.103\",\"timestamp\":\"2025-08-13T17:44:35+03:00\",\"general\":{\"ip\":\"194.44.7.103\",\"is_valid\":true,\"ip_type\":\"Публічна IPv4\",\"check_time\":\"2025-08-13T17:44:35+03:00\"},\"location\":{\"country\":\"Ukraine\",\"country_code\":\"UA\",\"region\":\"Dnipropetrovsk\",\"city\":\"Obukhivka\",\"postal\":\"\",\"latitude\":48.548839999999998,\"longitude\":34.853870000000001,\"timezone\":\"Europe\\/Kyiv\"},\"network\":{\"isp\":\"Невідомо\",\"org\":\"Невідомо\",\"asn\":\"\",\"connection_type\":\"Невідомо\",\"usage_type\":\"Невідомо\",\"is_proxy\":false},\"blacklists\":[{\"name\":\"Spamhaus ZEN\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SpamCop\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Barracuda\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Spam\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS HTTP\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS SOCKS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Misc\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS Zombie\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"SORBS DUL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 1\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 2\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"UCEPROTECT Level 3\",\"listed\":true,\"checked\":true,\"response\":\"127.0.0.2\"},{\"name\":\"Spamhaus PBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus SBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus CSS\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Spamhaus XBL\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Composite Blocking List\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Passive Spam Block List\",\"listed\":false,\"checked\":true,\"response\":null},{\"name\":\"Lashback UBL\",\"listed\":false,\"checked\":true,\"response\":null}],\"threats\":{\"risk_level\":\"Низький\",\"confidence\":0,\"categories\":[],\"last_seen\":null},\"distance\":{\"km\":16,\"miles\":10,\"flight_time\":\"1 хв\"},\"weather\":{\"temperature\":15,\"description\":\"Хмарно\",\"condition\":\"cloudy\",\"humidity\":68,\"wind_speed\":4,\"visibility\":9}}','2025-08-13 14:44:38'),
(19,'194.44.7.103','93.170.44.31','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36','{\"ip\":\"194.44.7.103\",\"timestamp\":\"2025-08-13T17:44:43+03:00\",\"general\":{\"ip\":\"194.44.7.103\",\"is_valid\":true,\"ip_type\":\"Публічна IPv4\",\"check_time\":\"2025-08-13T17:44:43+03:00\"},\"location\":{\"country\":\"Ukraine\",\"country_code\":\"UA\",\"region\":\"Dnipropetrovsk\",\"city\":\"Obukhivka\",\"postal\":\"\",\"latitude\":48.548839999999998,\"longitude\":34.853870000000001,\"timezone\":\"Europe\\/Kyiv\"},\"network\":{\"isp\":\"Невідомо\",\"org\":\"Невідомо\",\"asn\":\"\",\"connection_type\":\"Невідомо\",\"usage_type\":\"Невідомо\",\"is_proxy\":false},\"blacklists\":null,\"threats\":null,\"distance\":null,\"weather\":{\"temperature\":21,\"description\":\"Хмарно\",\"condition\":\"cloudy\",\"humidity\":45,\"wind_speed\":7,\"visibility\":11}}','2025-08-13 14:44:44');
/*!40000 ALTER TABLE `ip_check_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ip_check_stats`
--

DROP TABLE IF EXISTS `ip_check_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ip_check_stats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date_checked` date NOT NULL,
  `total_checks` int(11) DEFAULT 0,
  `unique_ips` int(11) DEFAULT 0,
  `blacklisted_count` int(11) DEFAULT 0,
  `threats_detected` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_date` (`date_checked`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ip_check_stats`
--

LOCK TABLES `ip_check_stats` WRITE;
/*!40000 ALTER TABLE `ip_check_stats` DISABLE KEYS */;
/*!40000 ALTER TABLE `ip_check_stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ip_geolocation_cache`
--

DROP TABLE IF EXISTS `ip_geolocation_cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ip_geolocation_cache` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ip_address` varchar(45) NOT NULL,
  `country` varchar(100) DEFAULT NULL,
  `region` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL,
  `timezone` varchar(50) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `ip_address` (`ip_address`),
  KEY `idx_ip` (`ip_address`),
  KEY `idx_updated` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ip_geolocation_cache`
--

LOCK TABLES `ip_geolocation_cache` WRITE;
/*!40000 ALTER TABLE `ip_geolocation_cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `ip_geolocation_cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `location_stats`
--

DROP TABLE IF EXISTS `location_stats`;
/*!50001 DROP VIEW IF EXISTS `location_stats`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `location_stats` AS SELECT
 1 AS `location`,
  1 AS `checks_count`,
  1 AS `avg_response_time`,
  1 AS `success_count` */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `login_attempts`
--

DROP TABLE IF EXISTS `login_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_attempts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ip_address` varchar(45) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `attempts` int(11) DEFAULT 1,
  `last_attempt` timestamp NULL DEFAULT current_timestamp(),
  `locked_until` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_ip` (`ip_address`),
  KEY `idx_email` (`email`),
  KEY `idx_locked` (`locked_until`),
  KEY `idx_login_attempts_ip_time` (`ip_address`,`last_attempt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_attempts`
--

LOCK TABLES `login_attempts` WRITE;
/*!40000 ALTER TABLE `login_attempts` DISABLE KEYS */;
/*!40000 ALTER TABLE `login_attempts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `news`
--

DROP TABLE IF EXISTS `news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `news` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title_ua` varchar(255) NOT NULL,
  `content_ua` text NOT NULL,
  `content_en` text DEFAULT NULL,
  `content_ru` text DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `is_featured` tinyint(1) DEFAULT 0,
  `is_published` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_featured` (`is_featured`),
  KEY `idx_published` (`is_published`),
  KEY `idx_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news`
--

LOCK TABLES `news` WRITE;
/*!40000 ALTER TABLE `news` DISABLE KEYS */;
/*!40000 ALTER TABLE `news` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `newsletter_subscribers`
--

DROP TABLE IF EXISTS `newsletter_subscribers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `newsletter_subscribers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `subscribed_at` timestamp NULL DEFAULT current_timestamp(),
  `ip_address` varchar(45) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `newsletter_subscribers`
--

LOCK TABLES `newsletter_subscribers` WRITE;
/*!40000 ALTER TABLE `newsletter_subscribers` DISABLE KEYS */;
/*!40000 ALTER TABLE `newsletter_subscribers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_resets`
--

DROP TABLE IF EXISTS `password_resets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_resets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `expires_at` timestamp NOT NULL,
  `is_used` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `idx_email` (`email`),
  KEY `idx_expires` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_resets`
--

LOCK TABLES `password_resets` WRITE;
/*!40000 ALTER TABLE `password_resets` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_resets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `popular_checked_sites`
--

DROP TABLE IF EXISTS `popular_checked_sites`;
/*!50001 DROP VIEW IF EXISTS `popular_checked_sites`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `popular_checked_sites` AS SELECT
 1 AS `domain`,
  1 AS `check_count`,
  1 AS `avg_response_time`,
  1 AS `last_checked` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `popular_domains_view`
--

DROP TABLE IF EXISTS `popular_domains_view`;
/*!50001 DROP VIEW IF EXISTS `popular_domains_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `popular_domains_view` AS SELECT
 1 AS `zone`,
  1 AS `price_registration`,
  1 AS `price_renewal`,
  1 AS `price_transfer`,
  1 AS `description`,
  1 AS `domain_type`,
  1 AS `price_category`,
  1 AS `features`,
  1 AS `whois_privacy_available`,
  1 AS `auto_renewal_available` */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `remember_tokens`
--

DROP TABLE IF EXISTS `remember_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `remember_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `expires_at` timestamp NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_expires` (`expires_at`),
  CONSTRAINT `remember_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `remember_tokens`
--

LOCK TABLES `remember_tokens` WRITE;
/*!40000 ALTER TABLE `remember_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `remember_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `security_logs`
--

DROP TABLE IF EXISTS `security_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `security_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ip_address` varchar(45) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `details` text DEFAULT NULL,
  `severity` enum('low','medium','high','critical') DEFAULT 'medium',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_ip` (`ip_address`),
  KEY `idx_user` (`user_id`),
  KEY `idx_action` (`action`),
  KEY `idx_severity` (`severity`),
  KEY `idx_created` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `security_logs`
--

LOCK TABLES `security_logs` WRITE;
/*!40000 ALTER TABLE `security_logs` DISABLE KEYS */;
INSERT INTO `security_logs` VALUES
(1,'104.197.69.115',NULL,'database_connect','Успешное подключение к основной БД','low','2025-08-04 14:56:55'),
(2,'93.170.44.119',NULL,'database_connect','Успешное подключение к основной БД','low','2025-08-06 10:34:46'),
(3,'93.170.44.119',NULL,'database_connect','Успешное подключение к основной БД','low','2025-08-06 10:34:51');
/*!40000 ALTER TABLE `security_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site_alerts`
--

DROP TABLE IF EXISTS `site_alerts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `site_alerts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `monitor_id` int(11) NOT NULL COMMENT 'ID записи мониторинга',
  `alert_type` enum('down','slow','ssl_expiring','ssl_expired') NOT NULL COMMENT 'Тип алерта',
  `message` text NOT NULL COMMENT 'Сообщение алерта',
  `is_resolved` tinyint(1) DEFAULT 0 COMMENT 'Решен ли алерт',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `resolved_at` timestamp NULL DEFAULT NULL COMMENT 'Время решения алерта',
  PRIMARY KEY (`id`),
  KEY `idx_monitor_type` (`monitor_id`,`alert_type`),
  KEY `idx_unresolved` (`is_resolved`,`created_at`),
  CONSTRAINT `site_alerts_ibfk_1` FOREIGN KEY (`monitor_id`) REFERENCES `site_monitors` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Алерты и уведомления';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_alerts`
--

LOCK TABLES `site_alerts` WRITE;
/*!40000 ALTER TABLE `site_alerts` DISABLE KEYS */;
/*!40000 ALTER TABLE `site_alerts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site_check_logs`
--

DROP TABLE IF EXISTS `site_check_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `site_check_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` varchar(512) NOT NULL COMMENT 'URL проверяемого сайта',
  `ip_address` varchar(45) NOT NULL COMMENT 'IP адрес пользователя',
  `user_agent` text DEFAULT NULL COMMENT 'User Agent браузера',
  `results_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Результаты проверки в JSON формате' CHECK (json_valid(`results_json`)),
  `created_at` timestamp NULL DEFAULT current_timestamp() COMMENT 'Время создания записи',
  PRIMARY KEY (`id`),
  KEY `idx_ip_time` (`ip_address`,`created_at`) COMMENT 'Индекс для rate limiting',
  KEY `idx_url` (`url`(100)) COMMENT 'Индекс для поиска по URL',
  KEY `idx_created` (`created_at`) COMMENT 'Индекс для сортировки по времени'
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Логи проверки доступности сайтов';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_check_logs`
--

LOCK TABLES `site_check_logs` WRITE;
/*!40000 ALTER TABLE `site_check_logs` DISABLE KEYS */;
INSERT INTO `site_check_logs` VALUES
(1,'https://worldmates.club','93.170.44.119','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36','{\"url\":\"https:\\/\\/worldmates.club\",\"timestamp\":\"2025-08-09T17:57:41+03:00\",\"general\":{\"url\":\"https:\\/\\/worldmates.club\",\"host\":\"worldmates.club\",\"ip\":\"195.22.131.11\",\"check_time\":\"2025-08-09T17:57:41+03:00\",\"server\":null,\"content_length\":66867,\"content_type\":\"text\\/html; charset=UTF-8\"},\"locations\":[{\"location\":\"kyiv\",\"location_name\":\"Київ, Україна\",\"response_time\":265,\"status_code\":200,\"status_text\":\"OK\",\"dns_time\":63,\"connect_time\":64,\"error\":null,\"content_length\":66786,\"content_type\":\"text\\/html; charset=UTF-8\",\"server_ip\":\"195.22.131.11\"},{\"location\":\"frankfurt\",\"location_name\":\"Франкфурт, Німеччина\",\"response_time\":134,\"status_code\":200,\"status_text\":\"OK\",\"dns_time\":41,\"connect_time\":41,\"error\":null,\"content_length\":66832,\"content_type\":\"text\\/html; charset=UTF-8\",\"server_ip\":\"195.22.131.11\"},{\"location\":\"london\",\"location_name\":\"Лондон, Великобританія\",\"response_time\":160,\"status_code\":200,\"status_text\":\"OK\",\"dns_time\":71,\"connect_time\":72,\"error\":null,\"content_length\":66867,\"content_type\":\"text\\/html; charset=UTF-8\",\"server_ip\":\"195.22.131.11\"}],\"ssl\":{\"valid\":true,\"issuer\":\"R10\",\"subject\":\"worldmates.club\",\"valid_from\":\"2025-07-08 19:55:58\",\"valid_to\":\"2025-10-06 19:55:57\",\"days_until_expiry\":58,\"alt_names\":[\"chat.worldmates.club\",\"music.worldmates.club\",\"video.worldmates.club\",\"worldmates.club\",\"www.worldmates.club\"],\"signature_algorithm\":\"RSA-SHA256\"},\"headers\":{\"server\":\"nginx\",\"date\":\"Sat, 09 Aug 2025 14:57:41 GMT\",\"content-type\":\"text\\/html; charset=UTF-8\",\"set-cookie\":\"src=1; expires=Sun, 09 Aug 2026 20:46:27 GMT; Max-Age=31556926; path=\\/\",\"expires\":\"Thu, 19 Nov 1981 08:52:00 GMT\",\"cache-control\":\"no-store, no-cache, must-revalidate\",\"pragma\":\"no-cache\",\"location\":\"https:\\/\\/worldmates.club\\/welcome\",\"strict-transport-security\":\"max-age=31536000;\",\"Content-Type\":\"text\\/html; charset=UTF-8\",\"Content-Length\":0}}','2025-08-09 14:57:41');
/*!40000 ALTER TABLE `site_check_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site_monitor_results`
--

DROP TABLE IF EXISTS `site_monitor_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `site_monitor_results` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `monitor_id` int(11) NOT NULL COMMENT 'ID записи мониторинга',
  `location` varchar(50) NOT NULL COMMENT 'Локация проверки',
  `status_code` int(11) DEFAULT NULL COMMENT 'HTTP статус код',
  `response_time` int(11) DEFAULT NULL COMMENT 'Время ответа в миллисекундах',
  `error_message` text DEFAULT NULL COMMENT 'Сообщение об ошибке если есть',
  `is_up` tinyint(1) NOT NULL COMMENT 'Доступен ли сайт',
  `checked_at` timestamp NULL DEFAULT current_timestamp() COMMENT 'Время проверки',
  PRIMARY KEY (`id`),
  KEY `idx_monitor_time` (`monitor_id`,`checked_at`),
  KEY `idx_location` (`location`),
  KEY `idx_status` (`is_up`,`checked_at`),
  CONSTRAINT `site_monitor_results_ibfk_1` FOREIGN KEY (`monitor_id`) REFERENCES `site_monitors` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Результаты мониторинга сайтов';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_monitor_results`
--

LOCK TABLES `site_monitor_results` WRITE;
/*!40000 ALTER TABLE `site_monitor_results` DISABLE KEYS */;
/*!40000 ALTER TABLE `site_monitor_results` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site_monitors`
--

DROP TABLE IF EXISTS `site_monitors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `site_monitors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL COMMENT 'ID пользователя (NULL для анонимных)',
  `url` varchar(512) NOT NULL COMMENT 'URL для мониторинга',
  `check_interval` int(11) DEFAULT 300 COMMENT 'Интервал проверки в секундах',
  `locations` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Массив локаций для проверки' CHECK (json_valid(`locations`)),
  `email_notifications` tinyint(1) DEFAULT 0 COMMENT 'Включены ли email уведомления',
  `webhook_url` varchar(512) DEFAULT NULL COMMENT 'URL для webhook уведомлений',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Активен ли мониторинг',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_active` (`is_active`),
  KEY `idx_next_check` (`created_at`,`check_interval`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Настройки мониторинга сайтов';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_monitors`
--

LOCK TABLES `site_monitors` WRITE;
/*!40000 ALTER TABLE `site_monitors` DISABLE KEYS */;
/*!40000 ALTER TABLE `site_monitors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site_settings`
--

DROP TABLE IF EXISTS `site_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `site_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text DEFAULT NULL,
  `setting_type` enum('string','number','boolean','json') DEFAULT 'string',
  `is_public` tinyint(1) DEFAULT 0,
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `setting_key` (`setting_key`),
  KEY `idx_key` (`setting_key`),
  KEY `idx_public` (`is_public`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_settings`
--

LOCK TABLES `site_settings` WRITE;
/*!40000 ALTER TABLE `site_settings` DISABLE KEYS */;
INSERT INTO `site_settings` VALUES
(1,'site_maintenance','0','boolean',0,'2025-08-04 14:12:37'),
(2,'registration_enabled','1','boolean',0,'2025-08-04 14:12:37'),
(3,'max_upload_size','10485760','number',0,'2025-08-04 14:12:37'),
(4,'session_timeout','3600','number',0,'2025-08-04 14:12:37'),
(5,'enable_recaptcha','1','boolean',0,'2025-08-04 14:12:37');
/*!40000 ALTER TABLE `site_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translations`
--

DROP TABLE IF EXISTS `translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `translations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `translation_key` varchar(255) NOT NULL,
  `language` enum('ua','en','ru') NOT NULL,
  `translation_value` text NOT NULL,
  `section` varchar(100) DEFAULT 'general',
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_translation` (`translation_key`,`language`),
  KEY `idx_key` (`translation_key`),
  KEY `idx_lang` (`language`),
  KEY `idx_section` (`section`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translations`
--

LOCK TABLES `translations` WRITE;
/*!40000 ALTER TABLE `translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_activity`
--

DROP TABLE IF EXISTS `user_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_activity` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `action` varchar(100) NOT NULL,
  `details` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_action` (`action`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `user_activity_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_activity`
--

LOCK TABLES `user_activity` WRITE;
/*!40000 ALTER TABLE `user_activity` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_activity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_sessions`
--

DROP TABLE IF EXISTS `user_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_sessions` (
  `id` varchar(128) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `last_activity` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `data` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_last_activity` (`last_activity`),
  CONSTRAINT `user_sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_sessions`
--

LOCK TABLES `user_sessions` WRITE;
/*!40000 ALTER TABLE `user_sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `language` enum('ua','en','ru') DEFAULT 'ua',
  `registration_date` timestamp NULL DEFAULT current_timestamp(),
  `last_login` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `marketing_emails` tinyint(1) DEFAULT 0,
  `fossbilling_client_id` int(11) DEFAULT NULL,
  `ispmanager_username` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_email` (`email`),
  KEY `idx_active` (`is_active`),
  KEY `idx_users_email_active` (`email`,`is_active`),
  KEY `idx_users_registration_date` (`registration_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vds_plans`
--

DROP TABLE IF EXISTS `vds_plans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `vds_plans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name_ua` varchar(100) NOT NULL,
  `name_en` varchar(100) DEFAULT NULL,
  `name_ru` varchar(100) DEFAULT NULL,
  `type` enum('virtual','dedicated') NOT NULL,
  `cpu_cores` int(11) NOT NULL,
  `ram_mb` int(11) NOT NULL,
  `disk_gb` int(11) NOT NULL,
  `bandwidth_gb` int(11) NOT NULL,
  `price_monthly` decimal(10,2) NOT NULL,
  `price_yearly` decimal(10,2) NOT NULL,
  `is_popular` tinyint(1) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `features_ua` text DEFAULT NULL,
  `features_en` text DEFAULT NULL,
  `features_ru` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_type` (`type`),
  KEY `idx_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vds_plans`
--

LOCK TABLES `vds_plans` WRITE;
/*!40000 ALTER TABLE `vds_plans` DISABLE KEYS */;
INSERT INTO `vds_plans` VALUES
(1,'VDS-1','VDS-1','VDS-1','virtual',1,1024,20,1000,299.00,2990.00,0,1,'KVM віртуалізація, SSD диск, Root доступ',NULL,NULL),
(2,'VDS-2','VDS-2','VDS-2','virtual',2,2048,40,2000,599.00,5990.00,1,1,'KVM віртуалізація, SSD диск, Root доступ, Безкоштовна міграція',NULL,NULL),
(3,'VDS-4','VDS-4','VDS-4','virtual',4,4096,80,4000,1199.00,11990.00,0,1,'KVM віртуалізація, SSD диск, Root доступ, Безкоштовна міграція, 24/7 підтримка',NULL,NULL);
/*!40000 ALTER TABLE `vds_plans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `domain_search_statistics`
--

/*!50001 DROP VIEW IF EXISTS `domain_search_statistics`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sthostdb`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `domain_search_statistics` AS select cast(`dl`.`created_at` as date) AS `search_date`,`dl`.`domain_zone` AS `domain_zone`,count(0) AS `total_checks`,sum(case when `dl`.`is_available` = 1 then 1 else 0 end) AS `available_count`,sum(case when `dl`.`is_available` = 0 then 1 else 0 end) AS `taken_count`,avg(`dl`.`check_time_ms`) AS `avg_check_time_ms`,count(distinct `dl`.`session_id`) AS `unique_sessions`,count(distinct `dl`.`user_id`) AS `unique_users` from `domain_check_logs` `dl` group by cast(`dl`.`created_at` as date),`dl`.`domain_zone` order by cast(`dl`.`created_at` as date) desc,count(0) desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `location_stats`
--

/*!50001 DROP VIEW IF EXISTS `location_stats`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sthostdb`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `location_stats` AS select json_unquote(json_extract(`location_data`.`value`,'$.location')) AS `location`,count(0) AS `checks_count`,avg(json_extract(`location_data`.`value`,'$.response_time')) AS `avg_response_time`,sum(case when json_extract(`location_data`.`value`,'$.status_code') between 200 and 299 then 1 else 0 end) AS `success_count` from (`sthostsitedb`.`site_check_logs` join JSON_TABLE(json_extract(`sthostsitedb`.`site_check_logs`.`results_json`,'$.locations'), '$[*]' COLUMNS (`row_id` FOR ORDINALITY, `value` longtext PATH '$')) `location_data`) where `sthostsitedb`.`site_check_logs`.`created_at` > current_timestamp() - interval 24 hour and json_valid(`sthostsitedb`.`site_check_logs`.`results_json`) group by json_unquote(json_extract(`location_data`.`value`,'$.location')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `popular_checked_sites`
--

/*!50001 DROP VIEW IF EXISTS `popular_checked_sites`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sthostdb`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `popular_checked_sites` AS select substring_index(substring_index(`site_check_logs`.`url`,'/',3),'//',-1) AS `domain`,count(0) AS `check_count`,avg(json_extract(`site_check_logs`.`results_json`,'$.locations[0].response_time')) AS `avg_response_time`,max(`site_check_logs`.`created_at`) AS `last_checked` from `site_check_logs` where `site_check_logs`.`created_at` > current_timestamp() - interval 7 day and json_valid(`site_check_logs`.`results_json`) group by substring_index(substring_index(`site_check_logs`.`url`,'/',3),'//',-1) order by count(0) desc limit 100 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `popular_domains_view`
--

/*!50001 DROP VIEW IF EXISTS `popular_domains_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sthostdb`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `popular_domains_view` AS select `domain_zones`.`zone` AS `zone`,`domain_zones`.`price_registration` AS `price_registration`,`domain_zones`.`price_renewal` AS `price_renewal`,`domain_zones`.`price_transfer` AS `price_transfer`,`domain_zones`.`description` AS `description`,case when `domain_zones`.`zone` like '%.ua' then 'Український домен' when `domain_zones`.`zone` in ('.com','.net','.org','.info','.biz') then 'Міжнародний домен' else 'Спеціальний домен' end AS `domain_type`,case when `domain_zones`.`price_registration` <= 150 then 'Економ' when `domain_zones`.`price_registration` <= 300 then 'Стандарт' else 'Преміум' end AS `price_category`,`domain_zones`.`features` AS `features`,`domain_zones`.`whois_privacy_available` AS `whois_privacy_available`,`domain_zones`.`auto_renewal_available` AS `auto_renewal_available` from `domain_zones` where `domain_zones`.`is_active` = 1 and `domain_zones`.`is_popular` = 1 order by case when `domain_zones`.`zone` like '%.ua' then 1 else 2 end,`domain_zones`.`price_registration` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-08-17 11:45:57
