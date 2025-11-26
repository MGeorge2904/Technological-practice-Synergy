-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: tourism
-- ------------------------------------------------------
-- Server version	8.0.44

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
-- Temporary view structure for view `active_orders_view`
--

DROP TABLE IF EXISTS `active_orders_view`;
/*!50001 DROP VIEW IF EXISTS `active_orders_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `active_orders_view` AS SELECT 
 1 AS `order_id`,
 1 AS `client`,
 1 AS `tour_name`,
 1 AS `start_date`,
 1 AS `end_date`,
 1 AS `total_price`,
 1 AS `status`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `services_report`
--

DROP TABLE IF EXISTS `services_report`;
/*!50001 DROP VIEW IF EXISTS `services_report`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `services_report` AS SELECT 
 1 AS `service_name`,
 1 AS `category_name`,
 1 AS `price`,
 1 AS `times_ordered`,
 1 AS `total_quantity`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `active_orders_view`
--

/*!50001 DROP VIEW IF EXISTS `active_orders_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`admin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `active_orders_view` AS select `o`.`order_id` AS `order_id`,concat(`c`.`first_name`,' ',`c`.`last_name`) AS `client`,`t`.`tour_name` AS `tour_name`,`o`.`start_date` AS `start_date`,`o`.`end_date` AS `end_date`,`o`.`total_price` AS `total_price`,`o`.`status` AS `status` from ((`orders` `o` join `clients` `c` on((`o`.`client_id` = `c`.`client_id`))) join `tours` `t` on((`o`.`tour_id` = `t`.`tour_id`))) where (`o`.`status` in ('pending','confirmed','paid')) order by `o`.`start_date` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `services_report`
--

/*!50001 DROP VIEW IF EXISTS `services_report`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`admin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `services_report` AS select `s`.`service_name` AS `service_name`,`sc`.`category_name` AS `category_name`,`s`.`price` AS `price`,count(`os`.`service_id`) AS `times_ordered`,sum(`os`.`quantity`) AS `total_quantity` from ((`services` `s` join `service_categories` `sc` on((`s`.`category_id` = `sc`.`category_id`))) left join `order_services` `os` on((`s`.`service_id` = `os`.`service_id`))) group by `s`.`service_id`,`s`.`service_name`,`sc`.`category_name`,`s`.`price` */;
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

-- Dump completed on 2025-11-25 12:31:35
