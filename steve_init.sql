-- --------------------------------------------------------
-- Host:                         146.190.82.2
-- Server version:               10.4.28-MariaDB-1:10.4.28+maria~ubu2004 - mariadb.org binary distribution
-- Server OS:                    debian-linux-gnu
-- HeidiSQL Version:             12.4.0.6659
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for steve_db
CREATE DATABASE IF NOT EXISTS `steve_db` /*!40100 DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci */;
USE `steve_db`;

-- Dumping structure for table steve_db.address
CREATE TABLE IF NOT EXISTS `address` (
  `address_pk` int(11) NOT NULL AUTO_INCREMENT,
  `street` varchar(1000) DEFAULT NULL,
  `house_number` varchar(255) DEFAULT NULL,
  `zip_code` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`address_pk`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table steve_db.charge_box
CREATE TABLE IF NOT EXISTS `charge_box` (
  `charge_box_pk` int(11) NOT NULL AUTO_INCREMENT,
  `charge_box_id` varchar(255) NOT NULL,
  `endpoint_address` varchar(255) DEFAULT NULL,
  `ocpp_protocol` varchar(255) DEFAULT NULL,
  `registration_status` varchar(255) NOT NULL DEFAULT 'Accepted',
  `charge_point_vendor` varchar(255) DEFAULT NULL,
  `charge_point_model` varchar(255) DEFAULT NULL,
  `charge_point_serial_number` varchar(255) DEFAULT NULL,
  `charge_box_serial_number` varchar(255) DEFAULT NULL,
  `fw_version` varchar(255) DEFAULT NULL,
  `fw_update_status` varchar(255) DEFAULT NULL,
  `fw_update_timestamp` timestamp(6) NULL DEFAULT NULL,
  `iccid` varchar(255) DEFAULT NULL,
  `imsi` varchar(255) DEFAULT NULL,
  `meter_type` varchar(255) DEFAULT NULL,
  `meter_serial_number` varchar(255) DEFAULT NULL,
  `diagnostics_status` varchar(255) DEFAULT NULL,
  `diagnostics_timestamp` timestamp(6) NULL DEFAULT NULL,
  `last_heartbeat_timestamp` timestamp(6) NULL DEFAULT NULL,
  `description` mediumtext DEFAULT NULL,
  `note` mediumtext DEFAULT NULL,
  `location_latitude` decimal(11,8) DEFAULT NULL,
  `location_longitude` decimal(11,8) DEFAULT NULL,
  `address_pk` int(11) DEFAULT NULL,
  `admin_address` varchar(255) DEFAULT NULL,
  `insert_connector_status_after_transaction_msg` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`charge_box_pk`),
  UNIQUE KEY `chargeBoxId_UNIQUE` (`charge_box_id`),
  KEY `chargebox_op_ep_idx` (`ocpp_protocol`,`endpoint_address`),
  KEY `FK_charge_box_address_apk` (`address_pk`),
  CONSTRAINT `FK_charge_box_address_apk` FOREIGN KEY (`address_pk`) REFERENCES `address` (`address_pk`) ON DELETE SET NULL ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table steve_db.charging_profile
CREATE TABLE IF NOT EXISTS `charging_profile` (
  `charging_profile_pk` int(11) NOT NULL AUTO_INCREMENT,
  `stack_level` int(11) NOT NULL,
  `charging_profile_purpose` varchar(255) NOT NULL,
  `charging_profile_kind` varchar(255) NOT NULL,
  `recurrency_kind` varchar(255) DEFAULT NULL,
  `valid_from` timestamp(6) NULL DEFAULT NULL,
  `valid_to` timestamp(6) NULL DEFAULT NULL,
  `duration_in_seconds` int(11) DEFAULT NULL,
  `start_schedule` timestamp(6) NULL DEFAULT NULL,
  `charging_rate_unit` varchar(255) NOT NULL,
  `min_charging_rate` decimal(15,1) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  PRIMARY KEY (`charging_profile_pk`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporting was unselected.

-- Dumping structure for table steve_db.charging_schedule_period
CREATE TABLE IF NOT EXISTS `charging_schedule_period` (
  `charging_profile_pk` int(11) NOT NULL,
  `start_period_in_seconds` int(11) NOT NULL,
  `power_limit` decimal(15,1) NOT NULL,
  `number_phases` int(11) DEFAULT NULL,
  UNIQUE KEY `UQ_charging_schedule_period` (`charging_profile_pk`,`start_period_in_seconds`),
  CONSTRAINT `FK_charging_schedule_period_charging_profile_pk` FOREIGN KEY (`charging_profile_pk`) REFERENCES `charging_profile` (`charging_profile_pk`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporting was unselected.

-- Dumping structure for table steve_db.connector
CREATE TABLE IF NOT EXISTS `connector` (
  `connector_pk` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `charge_box_id` varchar(255) NOT NULL,
  `connector_id` int(11) NOT NULL,
  PRIMARY KEY (`connector_pk`),
  UNIQUE KEY `connector_pk_UNIQUE` (`connector_pk`),
  UNIQUE KEY `connector_cbid_cid_UNIQUE` (`charge_box_id`,`connector_id`),
  CONSTRAINT `FK_connector_charge_box_cbid` FOREIGN KEY (`charge_box_id`) REFERENCES `charge_box` (`charge_box_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table steve_db.connector_charging_profile
CREATE TABLE IF NOT EXISTS `connector_charging_profile` (
  `connector_pk` int(11) unsigned NOT NULL,
  `charging_profile_pk` int(11) NOT NULL,
  UNIQUE KEY `UQ_connector_charging_profile` (`connector_pk`,`charging_profile_pk`),
  KEY `FK_connector_charging_profile_charging_profile_pk` (`charging_profile_pk`),
  CONSTRAINT `FK_connector_charging_profile_charging_profile_pk` FOREIGN KEY (`charging_profile_pk`) REFERENCES `charging_profile` (`charging_profile_pk`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_connector_charging_profile_connector_pk` FOREIGN KEY (`connector_pk`) REFERENCES `connector` (`connector_pk`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporting was unselected.

-- Dumping structure for table steve_db.connector_meter_value
CREATE TABLE IF NOT EXISTS `connector_meter_value` (
  `connector_pk` int(11) unsigned NOT NULL,
  `transaction_pk` int(10) unsigned DEFAULT NULL,
  `value_timestamp` timestamp(6) NULL DEFAULT NULL,
  `value` text DEFAULT NULL,
  `reading_context` varchar(255) DEFAULT NULL,
  `format` varchar(255) DEFAULT NULL,
  `measurand` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `unit` varchar(255) DEFAULT NULL,
  `phase` varchar(255) DEFAULT NULL,
  KEY `FK_cm_pk_idx` (`connector_pk`),
  KEY `FK_tid_cm_idx` (`transaction_pk`),
  KEY `cmv_value_timestamp_idx` (`value_timestamp`),
  CONSTRAINT `FK_pk_cm` FOREIGN KEY (`connector_pk`) REFERENCES `connector` (`connector_pk`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_tid_cm` FOREIGN KEY (`transaction_pk`) REFERENCES `transaction_start` (`transaction_pk`) ON DELETE SET NULL ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table steve_db.connector_status
CREATE TABLE IF NOT EXISTS `connector_status` (
  `connector_pk` int(11) unsigned NOT NULL,
  `status_timestamp` timestamp(6) NULL DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `error_code` varchar(255) DEFAULT NULL,
  `error_info` varchar(255) DEFAULT NULL,
  `vendor_id` varchar(255) DEFAULT NULL,
  `vendor_error_code` varchar(255) DEFAULT NULL,
  KEY `FK_cs_pk_idx` (`connector_pk`),
  KEY `connector_status_cpk_st_idx` (`connector_pk`,`status_timestamp`),
  CONSTRAINT `FK_cs_pk` FOREIGN KEY (`connector_pk`) REFERENCES `connector` (`connector_pk`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table steve_db.ocpp_tag
CREATE TABLE IF NOT EXISTS `ocpp_tag` (
  `ocpp_tag_pk` int(11) NOT NULL AUTO_INCREMENT,
  `id_tag` varchar(255) NOT NULL,
  `parent_id_tag` varchar(255) DEFAULT NULL,
  `expiry_date` timestamp(6) NULL DEFAULT NULL,
  `max_active_transaction_count` int(11) NOT NULL DEFAULT 1,
  `note` mediumtext DEFAULT NULL,
  PRIMARY KEY (`ocpp_tag_pk`),
  UNIQUE KEY `idTag_UNIQUE` (`id_tag`),
  KEY `user_expiryDate_idx` (`expiry_date`),
  KEY `FK_ocpp_tag_parent_id_tag` (`parent_id_tag`),
  CONSTRAINT `FK_ocpp_tag_parent_id_tag` FOREIGN KEY (`parent_id_tag`) REFERENCES `ocpp_tag` (`id_tag`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for view steve_db.ocpp_tag_activity
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `ocpp_tag_activity` (
	`ocpp_tag_pk` INT(11) NOT NULL,
	`id_tag` VARCHAR(255) NOT NULL COLLATE 'utf8_unicode_ci',
	`parent_id_tag` VARCHAR(255) NULL COLLATE 'utf8_unicode_ci',
	`expiry_date` TIMESTAMP(6) NULL,
	`max_active_transaction_count` INT(11) NOT NULL,
	`note` MEDIUMTEXT NULL COLLATE 'utf8_unicode_ci',
	`active_transaction_count` BIGINT(21) NULL,
	`in_transaction` INT(1) NULL,
	`blocked` INT(1) NOT NULL
) ENGINE=MyISAM;

-- Dumping structure for table steve_db.reservation
CREATE TABLE IF NOT EXISTS `reservation` (
  `reservation_pk` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `connector_pk` int(11) unsigned NOT NULL,
  `transaction_pk` int(10) unsigned DEFAULT NULL,
  `id_tag` varchar(255) NOT NULL,
  `start_datetime` datetime DEFAULT NULL,
  `expiry_datetime` datetime DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  PRIMARY KEY (`reservation_pk`),
  UNIQUE KEY `reservation_pk_UNIQUE` (`reservation_pk`),
  UNIQUE KEY `transaction_pk_UNIQUE` (`transaction_pk`),
  KEY `FK_idTag_r_idx` (`id_tag`),
  KEY `reservation_start_idx` (`start_datetime`),
  KEY `reservation_expiry_idx` (`expiry_datetime`),
  KEY `reservation_status_idx` (`status`),
  KEY `FK_connector_pk_reserv_idx` (`connector_pk`),
  CONSTRAINT `FK_connector_pk_reserv` FOREIGN KEY (`connector_pk`) REFERENCES `connector` (`connector_pk`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_reservation_ocpp_tag_id_tag` FOREIGN KEY (`id_tag`) REFERENCES `ocpp_tag` (`id_tag`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_transaction_pk_r` FOREIGN KEY (`transaction_pk`) REFERENCES `transaction_start` (`transaction_pk`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table steve_db.schema_version
CREATE TABLE IF NOT EXISTS `schema_version` (
  `installed_rank` int(11) NOT NULL,
  `version` varchar(50) DEFAULT NULL,
  `description` varchar(200) NOT NULL,
  `type` varchar(20) NOT NULL,
  `script` varchar(1000) NOT NULL,
  `checksum` int(11) DEFAULT NULL,
  `installed_by` varchar(100) NOT NULL,
  `installed_on` timestamp NOT NULL DEFAULT current_timestamp(),
  `execution_time` int(11) NOT NULL,
  `success` tinyint(1) NOT NULL,
  PRIMARY KEY (`installed_rank`),
  KEY `schema_version_s_idx` (`success`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporting was unselected.

-- Dumping structure for table steve_db.settings
CREATE TABLE IF NOT EXISTS `settings` (
  `app_id` varchar(40) NOT NULL,
  `heartbeat_interval_in_seconds` int(11) DEFAULT NULL,
  `hours_to_expire` int(11) DEFAULT NULL,
  `mail_enabled` tinyint(1) DEFAULT 0,
  `mail_host` varchar(255) DEFAULT NULL,
  `mail_username` varchar(255) DEFAULT NULL,
  `mail_password` varchar(255) DEFAULT NULL,
  `mail_from` varchar(255) DEFAULT NULL,
  `mail_protocol` varchar(255) DEFAULT 'smtp',
  `mail_port` int(11) DEFAULT 25,
  `mail_recipients` text DEFAULT NULL COMMENT 'comma separated list of email addresses',
  `notification_features` text DEFAULT NULL COMMENT 'comma separated list',
  PRIMARY KEY (`app_id`),
  UNIQUE KEY `settings_id_UNIQUE` (`app_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for view steve_db.transaction
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `transaction` (
	`transaction_pk` INT(10) UNSIGNED NOT NULL,
	`connector_pk` INT(11) UNSIGNED NOT NULL,
	`id_tag` VARCHAR(255) NOT NULL COLLATE 'utf8_unicode_ci',
	`start_event_timestamp` TIMESTAMP(6) NOT NULL,
	`start_timestamp` TIMESTAMP(6) NULL,
	`start_value` VARCHAR(255) NULL COLLATE 'utf8_unicode_ci',
	`stop_event_actor` ENUM('station','manual') NULL COLLATE 'latin1_swedish_ci',
	`stop_event_timestamp` TIMESTAMP(6) NULL,
	`stop_timestamp` TIMESTAMP(6) NULL,
	`stop_value` VARCHAR(255) NULL COLLATE 'latin1_swedish_ci',
	`stop_reason` VARCHAR(255) NULL COLLATE 'latin1_swedish_ci'
) ENGINE=MyISAM;

-- Dumping structure for table steve_db.transaction_start
CREATE TABLE IF NOT EXISTS `transaction_start` (
  `transaction_pk` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `event_timestamp` timestamp(6) NOT NULL DEFAULT current_timestamp(6),
  `connector_pk` int(11) unsigned NOT NULL,
  `id_tag` varchar(255) NOT NULL,
  `start_timestamp` timestamp(6) NULL DEFAULT NULL,
  `start_value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`transaction_pk`),
  UNIQUE KEY `transaction_pk_UNIQUE` (`transaction_pk`),
  KEY `idTag_idx` (`id_tag`),
  KEY `connector_pk_idx` (`connector_pk`),
  KEY `transaction_start_idx` (`start_timestamp`),
  CONSTRAINT `FK_connector_pk_t` FOREIGN KEY (`connector_pk`) REFERENCES `connector` (`connector_pk`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_transaction_ocpp_tag_id_tag` FOREIGN KEY (`id_tag`) REFERENCES `ocpp_tag` (`id_tag`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table steve_db.transaction_stop
CREATE TABLE IF NOT EXISTS `transaction_stop` (
  `transaction_pk` int(10) unsigned NOT NULL,
  `event_timestamp` timestamp(6) NOT NULL DEFAULT current_timestamp(6),
  `event_actor` enum('station','manual') DEFAULT NULL,
  `stop_timestamp` timestamp(6) NOT NULL DEFAULT current_timestamp(6),
  `stop_value` varchar(255) NOT NULL,
  `stop_reason` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`transaction_pk`,`event_timestamp`),
  CONSTRAINT `FK_transaction_stop_transaction_pk` FOREIGN KEY (`transaction_pk`) REFERENCES `transaction_start` (`transaction_pk`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporting was unselected.

-- Dumping structure for table steve_db.transaction_stop_failed
CREATE TABLE IF NOT EXISTS `transaction_stop_failed` (
  `transaction_pk` int(11) DEFAULT NULL,
  `event_timestamp` timestamp(6) NOT NULL DEFAULT current_timestamp(6),
  `event_actor` enum('station','manual') DEFAULT NULL,
  `stop_timestamp` timestamp(6) NOT NULL DEFAULT current_timestamp(6),
  `stop_value` varchar(255) DEFAULT NULL,
  `stop_reason` varchar(255) DEFAULT NULL,
  `fail_reason` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporting was unselected.

-- Dumping structure for table steve_db.user
CREATE TABLE IF NOT EXISTS `user` (
  `user_pk` int(11) NOT NULL AUTO_INCREMENT,
  `ocpp_tag_pk` int(11) DEFAULT NULL,
  `address_pk` int(11) DEFAULT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `birth_day` date DEFAULT NULL,
  `sex` char(1) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `e_mail` varchar(255) DEFAULT NULL,
  `note` mediumtext DEFAULT NULL,
  PRIMARY KEY (`user_pk`),
  KEY `FK_user_ocpp_tag_otpk` (`ocpp_tag_pk`),
  KEY `FK_user_address_apk` (`address_pk`),
  CONSTRAINT `FK_user_address_apk` FOREIGN KEY (`address_pk`) REFERENCES `address` (`address_pk`) ON DELETE SET NULL ON UPDATE NO ACTION,
  CONSTRAINT `FK_user_ocpp_tag_otpk` FOREIGN KEY (`ocpp_tag_pk`) REFERENCES `ocpp_tag` (`ocpp_tag_pk`) ON DELETE SET NULL ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for view steve_db.ocpp_tag_activity
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `ocpp_tag_activity`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `ocpp_tag_activity` AS select `ocpp_tag`.`ocpp_tag_pk` AS `ocpp_tag_pk`,`ocpp_tag`.`id_tag` AS `id_tag`,`ocpp_tag`.`parent_id_tag` AS `parent_id_tag`,`ocpp_tag`.`expiry_date` AS `expiry_date`,`ocpp_tag`.`max_active_transaction_count` AS `max_active_transaction_count`,`ocpp_tag`.`note` AS `note`,coalesce(`tx_activity`.`active_transaction_count`,0) AS `active_transaction_count`,case when `tx_activity`.`active_transaction_count` > 0 then 1 else 0 end AS `in_transaction`,case when `ocpp_tag`.`max_active_transaction_count` = 0 then 1 else 0 end AS `blocked` from (`ocpp_tag` left join (select `transaction`.`id_tag` AS `id_tag`,count(`transaction`.`id_tag`) AS `active_transaction_count` from `transaction` where `transaction`.`stop_timestamp` is null and `transaction`.`stop_value` is null group by `transaction`.`id_tag`) `tx_activity` on(`ocpp_tag`.`id_tag` = `tx_activity`.`id_tag`));

-- Dumping structure for view steve_db.transaction
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `transaction`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `transaction` AS select `tx1`.`transaction_pk` AS `transaction_pk`,`tx1`.`connector_pk` AS `connector_pk`,`tx1`.`id_tag` AS `id_tag`,`tx1`.`event_timestamp` AS `start_event_timestamp`,`tx1`.`start_timestamp` AS `start_timestamp`,`tx1`.`start_value` AS `start_value`,`tx2`.`event_actor` AS `stop_event_actor`,`tx2`.`event_timestamp` AS `stop_event_timestamp`,`tx2`.`stop_timestamp` AS `stop_timestamp`,`tx2`.`stop_value` AS `stop_value`,`tx2`.`stop_reason` AS `stop_reason` from (`transaction_start` `tx1` left join (select `s1`.`transaction_pk` AS `transaction_pk`,`s1`.`event_timestamp` AS `event_timestamp`,`s1`.`event_actor` AS `event_actor`,`s1`.`stop_timestamp` AS `stop_timestamp`,`s1`.`stop_value` AS `stop_value`,`s1`.`stop_reason` AS `stop_reason` from `transaction_stop` `s1` where `s1`.`event_timestamp` = (select max(`s2`.`event_timestamp`) from `transaction_stop` `s2` where `s1`.`transaction_pk` = `s2`.`transaction_pk`) group by `s1`.`transaction_pk`,`s1`.`event_timestamp`) `tx2` on(`tx1`.`transaction_pk` = `tx2`.`transaction_pk`));

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
